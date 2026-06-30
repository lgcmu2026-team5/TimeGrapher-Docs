# AnalysisFrame Sequence Diagram Speaker Notes

![AnalysisFrame sequence diagram](<2. AnalysisFrame sequence diagram.png>)

Draw.io source: [2. AnalysisFrame sequence diagram.drawio](<2. AnalysisFrame sequence diagram.drawio>)

Rendered preview: [2. AnalysisFrame sequence diagram.png](<2. AnalysisFrame sequence diagram.png>)

## Slide Purpose

이 다이어그램은 `AnalysisFrame`이 Core 분석 결과에서 UI graph rendering까지 전달되는 흐름을 보여주는 sequence view이다. 코드 call stack을 전부 보여주기보다, 아키텍처적으로 중요한 책임 분리를 설명하는 그림이다.

강조할 포인트는 세 가지다.

- Core의 `_analysisWorker: AnalysisWorker`는 UI graph renderer를 직접 알지 않는다.
- `frame: AnalysisFrame`은 독립 actor가 아니라 `AnalysisFrameReady(frame: AnalysisFrame)` 이벤트/호출에 실려 전달되는 DTO payload이다.
- Router는 모든 consumer에 `ObserveFrame(frame)`을 호출하지만, 실제 rendering은 `activeTabId`로 선택된 active consumer 하나에만 수행한다.

## UML Notation

- `_analysisWorker`는 객체/인스턴스 이름이고, `:AnalysisWorker`는 타입이다.
- `frame: AnalysisFrame`은 메시지 파라미터로 전달되는 DTO 인스턴스를 의미한다.
- `consumer: IAnalysisFrameConsumer`는 등록된 graph consumer 중 하나를 의미한다.
- `activeConsumer: IAnalysisFrameConsumer`는 `activeTabId`로 선택된 consumer를 의미한다.
- `tabRenderer: selected graph renderer`는 활성 탭에 따라 달라지는 실제 graph renderer를 추상화한 표현이다.

## Component Roles

| Component | Role | Demo/Presentation Emphasis |
|---|---|---|
| `_analysisWorker: AnalysisWorker` | Core producer | 분석 결과를 `AnalysisFrame`으로 묶어 발행한다. UI나 graph renderer를 직접 호출하지 않는다. |
| `:AnalysisFrameRenderScheduler` | UI render scheduler | 분석 thread에서 들어온 frame을 UI thread rendering 흐름으로 넘기고, 최신 frame 중심으로 처리한다. |
| `:MainWindow` | UI callback/context owner | 현재 active tab과 rendering context를 붙여 router로 전달한다. |
| `router: AnalysisFrameRouter` | Routing control | 모든 consumer에 observe를 수행하고, active consumer 하나만 render하도록 분기한다. |
| `consumer: IAnalysisFrameConsumer` | Registered graph consumer | 각 graph가 필요한 최신 상태를 관찰하거나 cache/update할 수 있다. |
| `activeConsumer: IAnalysisFrameConsumer` | Selected graph consumer | 현재 선택된 tab의 consumer만 실제 render path로 들어간다. |
| `tabRenderer: selected graph renderer` | Graph-specific renderer | 선택된 graph view에 맞는 payload를 실제 plot/image로 렌더링한다. |

## Frame Flow

1. `_analysisWorker`가 `AnalysisFrameReady(frame: AnalysisFrame)`를 발행한다.
   - 여기서 `frame`은 이번 analysis pass 결과를 담은 DTO이다.
   - `frame`을 lifeline으로 세우지 않는 이유는, 스스로 동작을 시작하는 actor가 아니라 메시지 payload이기 때문이다.

2. `AnalysisFrameRenderScheduler`가 frame을 UI rendering 흐름으로 넘긴다.
   - UI가 모든 분석 frame을 즉시 렌더링하면 비용이 커질 수 있다.
   - scheduler는 UI 쪽 처리 빈도와 최신 frame 중심 처리를 담당한다.

3. `MainWindow`가 `Route(frame, activeTabId, context)`를 호출한다.
   - `AnalysisFrame`은 분석 결과이고, UI layer가 현재 active tab과 render context를 붙인다.

4. Router가 모든 registered consumer에 `ObserveFrame(frame)`을 호출한다.
   - 이것은 모든 graph consumer가 최신 frame을 볼 기회를 주는 단계이다.
   - observe는 render와 다르다. inactive graph도 필요한 최신 상태만 가볍게 cache/update할 수 있다.

5. Router가 `activeTabId`로 선택된 consumer 하나에만 `RenderFrame(frame, context)`를 호출한다.
   - 실제 rendering work는 active graph 중심으로 제한된다.
   - 이 구조가 graph 수가 늘어나도 UI rendering 부담을 제어하는 근거가 된다.

6. Active consumer가 graph-specific payload를 골라 `tabRenderer`로 전달한다.
   - 예: Rate/Scope는 series와 marker, Beat Noise는 beat segment payload, Spectrogram은 image/metadata를 사용한다.
   - graph별 rendering logic은 Core 분석 pipeline과 분리된다.

## Presenter Script

이 그림은 `AnalysisFrame`이 분석 결과에서 graph rendering까지 어떻게 전달되는지 설명하는 sequence diagram입니다.

왼쪽의 `_analysisWorker: AnalysisWorker`는 Core 쪽 분석 producer입니다. 이 worker는 detection, metrics, image projection 같은 분석 결과를 `AnalysisFrame` 하나로 묶어 `AnalysisFrameReady(frame: AnalysisFrame)` 이벤트로 발행합니다. 중요한 점은 Core worker가 UI나 특정 graph renderer를 직접 호출하지 않는다는 것입니다.

여기서 `frame: AnalysisFrame`은 별도 actor가 아니라 메시지에 실려 전달되는 DTO입니다. 그래서 lifeline으로 세우지 않고, 첫 번째 메시지의 파라미터로 표현했습니다. 이 표현이 `AnalysisFrame`의 역할을 가장 정확하게 보여줍니다.

그 다음 `AnalysisFrameRenderScheduler`가 이 frame을 UI rendering 흐름으로 넘깁니다. UI는 모든 frame을 무조건 즉시 그리는 것이 아니라 최신 frame 중심으로 처리합니다. 이 부분은 rendering 비용을 제어하는 역할을 합니다.

UI callback인 `MainWindow`는 현재 active tab과 rendering context를 붙여 `AnalysisFrameRouter`에 `Route(frame, activeTabId, context)` 형태로 넘깁니다. 즉 frame 자체는 분석 결과이고, 어떤 graph를 보여줄지에 대한 UI 상태는 UI layer에서 붙습니다.

Router의 핵심은 두 단계입니다. 먼저 모든 registered consumer에 `ObserveFrame(frame)`을 호출합니다. 이 단계는 모든 graph consumer가 최신 frame을 볼 수 있게 해줍니다. 하지만 observe는 render가 아닙니다.

그 다음 `activeTabId`로 선택된 `activeConsumer` 하나에만 `RenderFrame(frame, context)`를 호출합니다. 그래서 실제 graph rendering work는 현재 선택된 tab 하나에 집중됩니다. 이 구조 덕분에 graph가 늘어나도 Core hot path를 건드리지 않고, UI rendering 부담도 active graph 중심으로 제한할 수 있습니다.

마지막 `tabRenderer: selected graph renderer`는 고정된 단일 클래스가 아니라, 선택된 graph에 따라 달라지는 실제 renderer를 추상화한 표현입니다. 예를 들어 Rate/Scope, Beat Noise, Spectrogram은 서로 다른 payload를 사용하지만, 전체 흐름은 같은 `AnalysisFrame` 계약과 router 구조를 통해 연결됩니다.

## If Asked

**Q. 왜 `AnalysisFrame`을 lifeline으로 그리지 않았나?**  
`AnalysisFrame`은 runtime에 존재하는 객체이지만 이 interaction에서 행동 주체가 아니다. 이벤트/메서드 호출에 실려 전달되는 DTO payload이므로 메시지 파라미터로 표현하는 것이 더 정확하다.

**Q. 왜 모든 consumer에 observe를 호출하나?**  
inactive graph도 최신 image, metadata, history, beat window 같은 상태를 cache/update해야 할 수 있기 때문이다. observe는 render가 아니라 lightweight state update 기회이다.

**Q. 왜 active consumer만 render하나?**  
모든 graph를 매 frame마다 렌더링하면 UI 비용이 커진다. active tab 하나만 render하여 display work를 제한한다.

**Q. 어떤 QAS와 연결되나?**  
Modifiability와 performance/resource control을 설명하기 좋다. 새 graph display는 consumer/renderer/catalog 쪽으로 추가되고, Core analysis hot path와 graph-specific rendering은 분리된다.

## One-Sentence Summary

`AnalysisFrame`은 Core와 UI 사이의 안정적인 DTO 계약이고, `AnalysisFrameRouter`는 "모든 graph consumer는 observe, active graph consumer만 render"라는 방식으로 책임과 비용을 분리한다.
