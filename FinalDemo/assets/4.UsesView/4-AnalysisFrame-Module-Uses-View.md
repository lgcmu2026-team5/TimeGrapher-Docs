# AnalysisFrame Module Uses View Speaker Notes

![AnalysisFrame module uses view](<4-AnalysisFrame-Module-Uses-View.drawio.png>)

Draw.io source: [4-AnalysisFrame-Module-Uses-View.drawio](<4-AnalysisFrame-Module-Uses-View.drawio>)

Rendered preview: [4-AnalysisFrame-Module-Uses-View.drawio.png](<4-AnalysisFrame-Module-Uses-View.drawio.png>)

## Slide Purpose

이 그림은 `AnalysisFrame` 기반 graph rendering 구조를 Module Uses View 관점에서 보여준다.

Sequence diagram이 runtime message order를 보여준다면, 이 Uses View는 code-level dependency 방향과 변경 영향 범위를 보여준다.

핵심 메시지는 `AnalysisFrame DTO`와 `IAnalysisFrameConsumer` contract를 기준으로 Core analysis와 graph-specific rendering을 분리했다는 점이다.

## How To Read This View

- 점선 화살표는 `<<uses>> dependency`를 의미한다.
- 화살표 방향은 사용하는 module에서 사용되는 module을 향한다.
- 이 그림은 실행 순서가 아니라 code dependency와 coupling 방향을 보여준다.
- 새 graph를 추가할 때 변경이 어디에 집중되는지 설명하기 위한 view이다.

## Dependency Flow

1. `TimeGrapher.Core.Analysis`는 분석 결과를 만들고 `TimeGrapher.Core.Shared`의 `AnalysisFrame DTO`를 사용한다.
2. `TimeGrapher.App.Services / Views`는 frame-ready UI dispatch를 처리하면서 `AnalysisFrame DTO`와 `AnalysisFrameRouter`를 사용한다.
3. `TimeGrapher.App.Tabs`는 `AnalysisFrameRouter`와 `IAnalysisFrameConsumer` contract를 통해 consumer routing을 담당한다.
4. `TimeGrapher.App.Rendering`의 concrete frame consumers는 frame payload를 읽고, active graph에 필요한 payload를 선택한다.
5. `Graph-specific renderers`는 선택된 payload를 실제 graph rendering으로 위임하고, Avalonia UI / ScottPlot.Avalonia 같은 external modules를 사용한다.

## Component Roles

| Module | Role | Presentation Point |
|---|---|---|
| `TimeGrapher.Core.Analysis` | analysis producer | Core는 graph UI를 직접 알지 않고 shared DTO를 통해 결과를 내보낸다. |
| `TimeGrapher.Core.Shared` | shared data contract | `AnalysisFrame DTO`, pixel/snapshot, metric/quality payload가 Core와 App 사이의 계약 역할을 한다. |
| `TimeGrapher.App.Services / Views` | UI dispatch and view entry | 분석 frame을 UI route로 넘기고 현재 UI context와 연결한다. |
| `TimeGrapher.App.Tabs` | routing and consumer contract | `activeTabId` 기준으로 consumer routing을 담당하고 consumer contract를 제공한다. |
| `TimeGrapher.App.Rendering` | concrete graph consumers | frame에서 필요한 payload를 읽고, graph state/cache와 active payload 선택을 담당한다. |
| `Graph-specific renderers` | graph drawing logic | RateScope, Spectrogram, Vario, BeatNoise, BeatError 등 graph-specific rendering을 담당한다. |
| External modules | UI/plot libraries | Avalonia UI와 ScottPlot.Avalonia 같은 외부 기술 의존성이다. |

## Presenter Script

이 그림은 sequence diagram과 다르게 runtime 순서를 보여주는 그림이 아닙니다. Module Uses View이기 때문에 code-level dependency 방향을 보여줍니다.

왼쪽의 Core modules를 보면 `TimeGrapher.Core.Analysis`는 분석 결과를 만들고, 이 결과를 `TimeGrapher.Core.Shared`에 있는 `AnalysisFrame DTO` 형태로 내보냅니다. 중요한 점은 Core analysis 쪽이 특정 UI tab이나 graph renderer를 직접 알지 않는다는 것입니다.

오른쪽의 App routing modules는 UI 쪽에서 frame을 받아 route하는 부분입니다. `TimeGrapher.App.Services / Views`는 frame-ready dispatch와 current UI context를 담당하고, `TimeGrapher.App.Tabs`의 `AnalysisFrameRouter`와 consumer contract를 사용합니다.

아래의 Graph display modules는 실제 graph별 display logic이 모이는 곳입니다. Concrete FrameConsumers는 shared frame payload를 읽고, 필요한 cache/state를 업데이트하거나 active graph payload를 준비합니다. 그 다음 graph-specific renderer가 RateScope, Spectrogram, BeatNoise, BeatError 같은 화면별 rendering을 수행합니다.

이 구조의 장점은 graph display 변경 영향이 주로 App.Rendering과 graph-specific renderer 쪽에 제한된다는 점입니다. 새 graph를 추가하거나 기존 graph 표현을 바꾸더라도 Core analysis hot path를 직접 건드리지 않는 방향으로 변경을 제한할 수 있습니다.

## Why This Matters Architecturally

이 Uses View는 특히 Modifiability 설명에 좋다.

- Core analysis와 graph rendering 사이의 dependency 방향을 분리해서 보여준다.
- `AnalysisFrame DTO`가 Core와 UI 사이의 안정적인 계약 역할을 한다.
- `IAnalysisFrameConsumer` contract가 tab routing과 graph-specific rendering 사이의 접점을 만든다.
- graph-specific 변경은 rendering/consumer 쪽으로 모이고, Core analysis hot path로 번지는 것을 줄인다.

## If Asked

**Q. 이 그림은 sequence diagram과 무엇이 다른가?**  
Sequence diagram은 runtime message order를 보여준다. Uses View는 code-level dependency 방향과 변경 영향 범위를 보여준다.

**Q. 왜 `AnalysisFrame DTO`가 중요하게 보이나?**  
Core analysis 결과와 UI graph rendering 사이의 shared contract이기 때문이다. 이 계약이 있어야 graph renderer가 Core internals에 직접 의존하지 않고 필요한 payload를 받을 수 있다.

**Q. 이 뷰가 QAS와 어떻게 연결되나?**  
주로 Modifiability와 연결된다. 새 graph나 renderer 변경이 Core analysis 쪽으로 퍼지지 않고 consumer/renderer 쪽 변경으로 제한되는 구조를 설명할 수 있다.

**Q. 모든 dependency가 다 표현된 그림인가?**  
아니다. 발표 목적상 `AnalysisFrame` 전달과 graph rendering 변경 영향에 중요한 dependency만 추상화해서 보여준 view이다.

## One-Sentence Summary

이 Uses View는 `AnalysisFrame DTO`와 consumer contract를 중심으로 Core analysis와 graph-specific rendering의 dependency를 분리하고, graph 변경 영향을 UI rendering 쪽으로 제한하는 구조를 보여준다.