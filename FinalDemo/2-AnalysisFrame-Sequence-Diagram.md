# AnalysisFrame Sequence Diagram Speaker Notes

Draw.io source: [assets/2. AnalysisFrame sequence diagram.drawio](assets/2.%20AnalysisFrame%20sequence%20diagram.drawio)

## Slide Purpose

이 다이어그램은 `AnalysisFrame`이 Core 분석 결과에서 UI graph rendering까지 전달되는 책임 흐름을 보여준다. 코드 call stack을 1:1로 설명하는 그림이 아니라, 다음 아키텍처 포인트를 보여주는 발표용 sequence view다.

- Core는 UI나 graph renderer를 직접 알지 않는다.
- `AnalysisFrame`은 분석 결과를 묶은 DTO 인스턴스로, 이벤트/메서드 호출의 payload로 전달된다.
- Router는 모든 graph consumer에 최신 frame을 observe시키고, 실제 rendering은 active graph consumer 하나만 수행한다.
- 새 graph/display를 추가할 때 변경 지점이 consumer/renderer/catalog 쪽으로 제한된다.

Recommended caption under the diagram:

> Note: `frame` is an `AnalysisFrame` DTO instance carried as message payload, not modeled as an active lifeline.

## Component Roles

| Component | Role in this view | What to emphasize |
|---|---|---|
| `AnalysisWorker` | Core producer | 분석 pipeline 결과를 `AnalysisFrame`으로 묶어 발행한다. UI와 graph consumer를 직접 호출하지 않는다. |
| `AnalysisFrameRenderScheduler` | UI render scheduler | 들어오는 frame 중 최신 frame을 UI rendering 쪽으로 dispatch한다. UI rendering 부하가 Core 분석 흐름을 직접 막지 않게 한다. |
| `MainWindow` / UI callback | UI state provider | frame을 받아 현재 active tab, sample rate, review cursor 같은 render context를 붙여 router에 넘긴다. |
| `AnalysisFrameRouter` | Routing control | 같은 `AnalysisFrame`을 모든 consumer에 `ObserveFrame(frame)`으로 전달하고, active tab에 해당하는 consumer에만 `RenderFrame(frame, context)`를 호출한다. |
| `IAnalysisFrameConsumer` | Graph-specific adapter | 각 graph가 필요한 payload를 선택한다. 일부 consumer는 inactive 상태에서도 최신 image/history/beat data를 cache/update한다. |
| `Renderer` | Graph render target | consumer가 고른 payload를 실제 plot/image로 그린다. |

## Frame Flow

1. `AnalysisWorker` publishes `AnalysisFrameReady(frame)`.
   - 여기서 `frame`은 한 번의 analysis pass 결과를 담은 DTO 인스턴스다.
   - Core는 이 frame을 발행할 뿐, 어떤 UI graph가 그릴지는 모른다.

2. `AnalysisFrameRenderScheduler` dispatches the latest frame.
   - UI가 모든 frame을 그대로 다 그리면 비용이 커질 수 있으므로, render scheduler가 UI 쪽 update 흐름을 조절한다.
   - 발표에서는 "latest-wins scheduling" 정도로 설명하면 충분하다.

3. `MainWindow` / UI callback calls `Route(frame, activeTabId, context)`.
   - UI layer가 active tab과 rendering context를 제공한다.
   - `AnalysisFrame` 자체는 UI 상태를 모르고, UI layer가 필요한 context를 붙인다.

4. Router loops over all registered consumers.
   - `ObserveFrame(frame)`은 모든 graph consumer가 최신 frame을 볼 기회를 준다.
   - 중요한 점은 observe가 곧 rendering은 아니라는 것이다.

5. Router renders only the active consumer.
   - `activeTabId`로 선택된 consumer 하나만 `RenderFrame(frame, context)`를 수행한다.
   - 이것이 여러 graph를 지원하면서도 rendering work를 active display 중심으로 제한하는 방식이다.

6. Active consumer selects graph-specific payload and calls renderer.
   - 예를 들어 Rate/Scope는 series와 marker를, Beat Noise는 beat segment payload를, Spectrogram은 image/metadata payload를 사용한다.
   - consumer는 frame 전체를 다시 분석하지 않고, 자기 graph에 필요한 payload만 선택한다.

## Presenter Script

이 슬라이드는 `AnalysisFrame`이 graph rendering 쪽으로 전달되는 방식을 설명하는 sequence view입니다. 여기서 핵심은 `AnalysisFrame`을 별도의 active lifeline으로 그리지 않았다는 점입니다. `AnalysisFrame`은 runtime에 생성되는 DTO 인스턴스지만, 이 interaction에서는 스스로 메시지를 보내는 객체가 아니라 이벤트와 메서드 호출에 실려 전달되는 payload로 표현했습니다.

왼쪽의 `AnalysisWorker`는 Core 분석 pipeline 쪽 producer입니다. 이 컴포넌트가 detection, metrics, image projection 같은 분석 결과를 `AnalysisFrame` 하나로 묶어서 발행합니다. 중요한 점은 Core 쪽 worker가 UI나 특정 graph renderer를 직접 알지 않는다는 것입니다. 이 구조가 Core 무의존성과 변경 범위 제한을 설명할 수 있는 지점입니다.

다음 단계는 `AnalysisFrameRenderScheduler`입니다. 이 컴포넌트는 UI rendering 쪽으로 frame을 넘기는 scheduler 역할을 합니다. 모든 분석 frame을 그대로 다 그리려고 하면 UI rendering 비용이 커질 수 있기 때문에, scheduler는 최신 frame 중심으로 UI update를 전달합니다. 발표에서는 "latest-wins dispatch"라고 짧게 설명하면 됩니다.

그 다음 `MainWindow` 또는 UI callback은 UI state를 제공하는 위치입니다. 여기서 현재 active tab, sample rate, review cursor 같은 rendering context가 만들어지고, `AnalysisFrameRouter`에 `Route(frame, activeTabId, context)` 형태로 전달됩니다. 즉, `AnalysisFrame`은 분석 결과이고, UI layer가 현재 어떤 graph를 보여줄지에 대한 context를 붙입니다.

Router의 책임은 두 단계입니다. 먼저 모든 registered consumer에 `ObserveFrame(frame)`을 호출합니다. 이것은 모든 graph가 최신 frame을 관찰할 수 있게 하는 단계입니다. 하지만 observe는 render와 다릅니다. 일부 graph는 inactive 상태에서도 최신 image나 history를 cache할 수 있고, 필요 없는 consumer는 단순히 frame을 무시할 수도 있습니다.

그 다음 router는 `activeTabId`로 선택된 consumer 하나에만 `RenderFrame(frame, context)`를 호출합니다. 이 부분이 active graph rendering path입니다. 여러 graph를 지원하지만 실제 rendering work는 active display 중심으로 제한됩니다. 이 구조 덕분에 새 graph를 추가할 때도 Core detection/metrics hot path를 건드리지 않고, consumer와 renderer를 추가하는 방향으로 변경 범위를 제한할 수 있습니다.

마지막으로 active consumer는 `AnalysisFrame`에서 자기 graph에 필요한 payload만 선택해서 renderer에 넘깁니다. 예를 들어 Rate/Scope는 series와 marker를 보고, Beat Noise는 beat segment data를 보고, Spectrogram은 image와 metadata를 봅니다. 이 말은 graph별 rendering logic이 Core 분석 pipeline과 분리되어 있다는 뜻입니다.

## If Asked

**Q. Why is `AnalysisFrame` not drawn as a lifeline?**  
`AnalysisFrame` exists at runtime, but here it is a DTO instance carried as message payload. It does not initiate behavior in this interaction, so modeling it as a parameter keeps the diagram focused.

**Q. Why do all consumers observe the frame?**  
Because inactive graphs may still need to keep latest state, such as image, metadata, history, or beat windows. Observe gives each consumer a chance to update lightweight state without forcing all graphs to render.

**Q. Why render only the active consumer?**  
Rendering every graph on every frame would increase UI work. The router keeps display work focused on the active graph while still allowing other consumers to observe latest data.

**Q. What architecture quality does this support?**  
This supports modifiability and performance/resource control. New displays can be added through predictable UI-side extension points, while Core analysis remains independent of graph-specific rendering.

## One-Sentence Summary

`AnalysisFrame` is the stable DTO contract from Core to UI, and `AnalysisFrameRouter` separates "observe all graph consumers" from "render only the active graph consumer."
