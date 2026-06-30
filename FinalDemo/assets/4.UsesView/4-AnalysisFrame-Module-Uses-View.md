# AnalysisFrame Module Uses View Speaker Notes

![AnalysisFrame module uses view](<4-ForPresentation_AnalysisFrame-Module-Uses-View.drawio.png>)

Draw.io source: [4-ForPresentation_AnalysisFrame-Module-Uses-View.drawio](<4-ForPresentation_AnalysisFrame-Module-Uses-View.drawio>)

Rendered preview: [4-ForPresentation_AnalysisFrame-Module-Uses-View.drawio.png](<4-ForPresentation_AnalysisFrame-Module-Uses-View.drawio.png>)

Archived source: [backup/4-AnalysisFrame-Module-Uses-View.drawio](<backup/4-AnalysisFrame-Module-Uses-View.drawio>)

## Slide Purpose

이 그림은 `AnalysisFrame` 기반 graph rendering 구조를 **Module Uses View** 관점에서 보여준다.

앞의 Sequence Diagram이 runtime message order를 보여준다면, 이 Uses View는 같은 구조를 **code-level dependency 방향**과 **변경 영향 범위**로 다시 보여준다.

핵심 메시지는 하나다. Core analysis는 graph UI를 직접 알지 않고 `AnalysisFrame`이라는 shared DTO contract만 사용하며, graph display 변경은 App routing / App rendering / graph-specific renderer 쪽으로 제한된다.

## How To Read This View

- 점선 화살표는 `<<uses>> dependency`를 의미한다.
- 화살표 방향은 data flow가 아니라 **사용하는 module에서 사용되는 module**을 향한다.
- 박스 안의 문구는 class 목록이 아니라 해당 module이 맡는 **architecture role**이다.
- 이 그림은 전체 dependency를 모두 나열하지 않고, `AnalysisFrame` 전달과 graph rendering 변경 영향에 중요한 dependency만 추상화한다.

## Dependency Flow

1. `TimeGrapher.Core.Analysis`는 detection과 metrics 결과를 바탕으로 `AnalysisFrame`을 만든다.
2. `TimeGrapher.Core.Analysis`는 `TimeGrapher.Core.Shared`의 `AnalysisFrame` contract를 사용한다.
3. `TimeGrapher.App.UI Dispatch`는 최신 frame을 UI routing path로 넘기기 위해 frame DTO와 routing module을 사용한다.
4. `TimeGrapher.App.Tabs`는 `activeTabId` 기준으로 frame을 routing하고, graph consumer contract를 정의한다.
5. `TimeGrapher.App.Rendering`은 frame payload를 읽어 lightweight graph state를 갱신하고 active graph payload를 준비한다.
6. `Graph-specific renderers`는 선택된 graph payload를 실제 UI/plot drawing으로 변환하며 Avalonia / ScottPlot 같은 external modules를 사용한다.

## Arrow Labels

| Label | Meaning |
|---|---|
| `uses AnalysisFrame contract` | Core analysis가 분석 결과를 shared DTO contract로 발행하기 위해 `Core.Shared`를 사용한다. |
| `uses frame DTO` | UI dispatch와 tab routing code가 `AnalysisFrame` 타입을 method/event parameter로 사용한다. |
| `uses router` | UI dispatch entry가 frame routing을 `App.Tabs`의 router에 위임한다. |
| `reads frame payload` | graph consumer가 `AnalysisFrame` 안의 graph/metric payload를 읽는다. |
| `implements consumer contract` | concrete frame consumer가 `App.Tabs`의 consumer contract를 구현한다. |
| `delegates selected graph drawing` | frame consumer가 active graph payload의 실제 drawing을 graph-specific renderer에 위임한다. |
| `uses UI/plot libraries` | graph renderer가 Avalonia UI / ScottPlot.Avalonia 같은 외부 library를 사용한다. |

## Component Roles

| Module | Role | Presentation Point |
|---|---|---|
| `TimeGrapher.Core.Analysis` | Produces `AnalysisFrame` from detection and metrics | Core는 graph renderer를 직접 호출하지 않고 분석 결과만 만든다. |
| `TimeGrapher.Core.Shared` | Shared DTO contract and frame payloads | Core와 UI가 공유하는 안정적인 data contract이다. |
| `TimeGrapher.App.UI Dispatch` | Latest-frame handoff into UI routing path | analysis thread와 UI routing 흐름을 연결하는 entry 역할이다. |
| `TimeGrapher.App.Tabs` | Routes by `activeTabId` and defines consumer contract | 어떤 graph consumer가 active rendering path에 올라갈지 결정하는 routing boundary이다. |
| `TimeGrapher.App.Rendering` | Updates lightweight graph state and prepares active graph payload | inactive graph는 가벼운 state/cache만 갱신하고, active graph만 render payload를 준비한다. |
| `Graph-specific renderers` | Draw selected graph using graph-specific UI/plot logic | Rate/Scope, Spectrogram, Vario, BeatNoise, BeatError 같은 화면별 drawing logic이 모이는 곳이다. |
| External modules | UI/plot libraries | Avalonia UI와 ScottPlot.Avalonia 같은 외부 기술 의존성이다. |

## Presenter Script

이 그림은 앞의 sequence diagram과 같은 구조를 다른 관점에서 보여줍니다. Sequence Diagram은 frame이 어떤 순서로 전달되는지를 보여줬고, 이 Uses View는 그 흐름을 가능하게 하는 code-level dependency 방향을 보여줍니다.

왼쪽의 Core modules에서 `TimeGrapher.Core.Analysis`는 detection과 metrics 결과를 바탕으로 `AnalysisFrame`을 만듭니다. 중요한 점은 Core가 특정 tab이나 graph renderer를 직접 알지 않는다는 것입니다. Core는 `TimeGrapher.Core.Shared`에 있는 shared DTO contract만 사용합니다.

오른쪽의 App routing modules는 최신 frame을 UI routing path로 넘기는 부분입니다. UI dispatch는 frame DTO를 받아 routing module을 사용하고, `TimeGrapher.App.Tabs`는 `activeTabId`와 consumer contract를 기준으로 frame을 graph consumer에게 전달합니다.

아래의 Graph display modules는 실제 display 변경 영향이 모이는 곳입니다. `TimeGrapher.App.Rendering`은 frame payload를 읽고 lightweight graph state/cache를 업데이트합니다. 그리고 현재 active graph에 대해서만 selected graph payload를 준비합니다. 실제 drawing은 graph-specific renderer에 위임되고, renderer는 Avalonia / ScottPlot 같은 외부 UI library를 사용합니다.

이 구조의 장점은 graph display 변경이 Core analysis hot path로 퍼지지 않는다는 점입니다. 새 graph나 기존 graph 표현을 바꿀 때 변경은 주로 consumer, renderer, routing/catalog 쪽의 예측 가능한 지점에 제한됩니다.

## Why This Matters Architecturally

이 Uses View는 특히 Modifiability 설명에 좋다.

- Core analysis와 graph rendering 사이의 dependency 방향을 분리해서 보여준다.
- `AnalysisFrame DTO`가 Core와 UI 사이의 안정적인 shared contract 역할을 한다.
- consumer contract가 routing module과 graph-specific rendering 사이의 접점이 된다.
- graph-specific 변경은 rendering/renderer 쪽으로 모이고, Detection/Metrics hot path로 번지는 것을 줄인다.

## If Asked

**Q. 이 그림은 sequence diagram과 무엇이 다른가?**  
Sequence diagram은 runtime message order를 보여준다. Uses View는 code-level dependency 방향과 변경 영향 범위를 보여준다.

**Q. 왜 화살표가 data flow 방향과 다르게 보이나?**  
Uses View의 화살표는 data flow가 아니라 dependency direction이다. 예를 들어 runtime에서는 Core가 frame을 UI로 넘기지만, code dependency 관점에서는 UI code도 `AnalysisFrame` DTO type을 사용하므로 `Core.Shared`에 의존한다.

**Q. 왜 class 이름 대신 역할을 적었나?**  
발표 목적상 모든 class를 나열하는 것보다 각 module이 맡는 architecture responsibility를 보여주는 것이 더 중요하기 때문이다. 실제 코드 예시는 speaker notes에서 `AnalysisFrameRenderScheduler`, `AnalysisFrameRouter`, `IAnalysisFrameConsumer`처럼 설명할 수 있다.

**Q. 이 뷰가 QAS와 어떻게 연결되나?**  
주로 Modifiability와 연결된다. 새 graph나 renderer 변경이 Core analysis 쪽으로 퍼지지 않고 consumer/renderer 쪽 변경으로 제한되는 구조를 설명할 수 있다.

**Q. 모든 dependency가 다 표현된 그림인가?**  
아니다. 발표 목적상 `AnalysisFrame` 전달과 graph rendering 변경 영향에 중요한 dependency만 추상화해서 보여준 view이다.

## One-Sentence Summary

이 Uses View는 `AnalysisFrame DTO`와 consumer contract를 중심으로 Core analysis와 graph-specific rendering의 dependency를 분리하고, graph 변경 영향을 UI rendering 쪽의 예측 가능한 지점으로 제한하는 구조를 보여준다.