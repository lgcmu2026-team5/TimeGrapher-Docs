# Pipe-and-Filter Architecture View Speaker Notes

![Pipe-and-filter architecture diagram](<3. Pipe_And_Filter.png>)

Draw.io source: [3. Pipe_And_Filter.drawio](<3. Pipe_And_Filter.drawio>)

Rendered preview: [3. Pipe_And_Filter.png](<3. Pipe_And_Filter.png>)

## Slide Purpose

이 다이어그램은 Context Diagram에서 사용한 용어를 기준으로, watch sound가 UI graph로 보이기 전까지 어떤 구조적 흐름을 거치는지 보여주는 Pipe-and-Filter 관점의 architecture view이다.

이 그림의 목적은 코드의 모든 클래스와 메서드를 1:1로 보여주는 것이 아니라, 다음 세 가지를 발표자가 설명할 수 있게 하는 것이다.

- `Audio Input`, `Shared Data`, `AnalysisWorker`, `UI Thread`, `Graph view`가 어떤 책임을 나누는지 보여준다.
- `AnalysisWorker` 내부에서 분석 결과가 `AnalysisFrame` DTO로 만들어지는 지점을 보여준다.
- `AnalysisFrame`이 실제 graph renderer까지 어떻게 전달되는지는 다음 Sequence Diagram에서 이어서 설명한다.

중요한 발표 포인트는 이 그림이 전체 시스템의 모든 세부 구현을 그린 것이 아니라, Context Diagram 용어와 실제 runtime data flow를 연결하는 구조적 요약이라는 점이다.

## Final Diagram Review

현재 그림은 발표용으로 사용할 수 있는 방향이다. 특히 Context Diagram에서 사용한 용어를 그대로 가져와 `Audio Input -> Shared Data -> AnalysisWorker -> UI Thread -> Graph view` 흐름을 만들었기 때문에, 앞선 architecture 설명과 연결성이 좋다.

`Latest-Frame Buffer`라는 표현도 적절하다. 이것은 FIFO queue처럼 모든 frame을 쌓아두고 순서대로 처리한다는 의미가 아니라, UI가 처리할 수 있는 시점에 최신 `AnalysisFrame`을 중심으로 넘겨주는 latest-wins handoff 지점으로 설명하는 것이 좋다.

`AnalysisFrameReady(frame)` 라벨은 그림에 반드시 넣지 않아도 된다. 이 그림은 Pipe-and-Filter 구조를 보여주는 view이고, 이벤트/메서드 호출을 시간 순서로 보여주는 역할은 다음 Sequence Diagram이 담당한다. 발표에서는 구두로 "이 지점에서 `AnalysisFrame` DTO가 UI 쪽으로 넘어가고, 그 이후 renderer까지의 전달은 다음 sequence diagram에서 보여드리겠습니다"라고 연결하면 된다.

다만 PNG preview는 draw.io 파일을 수정한 뒤 다시 export되어야 한다. 발표 자료나 GitHub markdown에서 이미지를 직접 볼 예정이면, 최종 draw.io 기준으로 `3. Pipe_And_Filter.png`를 다시 생성해야 한다.

## Notation

- `Component`: 주요 runtime component 또는 filter 역할을 하는 처리 단위이다.
- `Shared Data / Buffer`: component 사이의 data handoff를 완충하는 저장 지점이다.
- `Boundary I/O or DTO`: 외부 입력 또는 layer 사이를 지나가는 data object를 의미한다.
- `Data handoff`: 한 component의 결과가 다음 component로 전달되는 흐름이다.
- `Internal synchronous stage`: `AnalysisWorker` 내부에서 순차적으로 수행되는 분석 단계이다.

이 그림은 엄격한 UML 다이어그램이라기보다, 교수와 팀원이 빠르게 이해할 수 있도록 만든 informal architecture view이다. 따라서 표기법 자체보다 "어떤 책임이 어디에 있고, 어떤 data가 어디서 만들어지는가"를 설명하는 것이 더 중요하다.

## Component Roles

| Component | Role | Presentation Emphasis |
|---|---|---|
| `Audio Input` | microphone/audio input을 받아 runtime으로 유입시키는 component | 분석 pipeline의 시작점이다. signal capture와 이후 분석을 분리한다. |
| `Shared Data` | input side와 analysis side 사이의 shared buffer | audio input rate와 analysis/rendering rate를 직접 묶지 않도록 완충한다. |
| `AnalysisWorker` | Core analysis를 수행하는 worker-level component | UI나 graph renderer를 직접 알지 않고, 분석 결과를 `AnalysisFrame` DTO로 만든다. |
| `Detector` | watch beat event를 찾는 내부 분석 단계 | raw signal에서 의미 있는 beat timing 정보를 뽑아내는 핵심 처리 지점이다. |
| `Analysis` | detection 결과를 rate, amplitude, beat error 등 graph/metric에 필요한 결과로 정리하는 단계 | graph별 표시 내용의 원천이 되는 분석 결과를 만든다. |
| `AnalysisFrame DTO` | 한 번의 analysis pass 결과를 담는 data contract | Core와 UI 사이의 안정적인 전달 단위이다. 다음 Sequence Diagram의 핵심 payload이다. |
| `UI Thread` | 화면 갱신과 graph rendering을 담당하는 UI execution context | Core 분석 thread와 UI rendering 책임을 분리한다. |
| `Latest-Frame Buffer` | UI rendering 쪽으로 넘어온 최신 frame을 유지하는 handoff 지점 | FIFO queue가 아니라 latest-wins buffer로 설명해야 한다. UI backlog를 줄인다. |
| `Graph view` | 사용자가 보는 graph display | 실제 graph rendering 세부 흐름은 다음 Sequence Diagram에서 router/consumer/renderer로 설명한다. |

## Frame Flow

1. `Audio Input`이 microphone/audio signal을 받아 system 안으로 넣는다.
   - 이 단계는 signal capture 쪽 책임이다.
   - 분석 알고리즘과 UI rendering을 직접 수행하지 않는다.

2. `Audio Input`은 signal을 `Shared Data`에 write한다.
   - `Shared Data`는 input side와 analysis side 사이의 buffer 역할을 한다.
   - 이 구조 덕분에 audio capture와 analysis worker가 서로 강하게 묶이지 않는다.

3. `AnalysisWorker`가 `Shared Data`에서 audio block을 read한다.
   - worker는 Core analysis를 수행하는 주체이다.
   - UI graph renderer를 직접 호출하지 않고, 분석 결과를 data object로 만든다.

4. `AnalysisWorker` 내부에서는 synchronous staged chain이 수행된다.
   - 그림의 `Detector`와 `Analysis`는 내부 알고리즘 단계를 추상화한 표현이다.
   - 실제 구현의 모든 세부 filter를 다 그리기보다, 발표에서 중요한 "beat detection -> analysis result" 흐름을 보여준다.

5. 내부 분석 결과는 `AnalysisFrame DTO`로 정리된다.
   - `AnalysisFrame`은 Core와 UI 사이의 data contract이다.
   - 여러 graph가 같은 frame을 기반으로 각자 필요한 payload를 선택해 사용할 수 있다.

6. `AnalysisFrame`은 UI 쪽 `Latest-Frame Buffer`로 넘어간다.
   - 이 지점은 FIFO queue라기보다 latest-wins handoff로 설명하는 것이 안전하다.
   - UI가 바쁠 때 오래된 frame을 모두 렌더링하려고 쌓아두는 대신, 최신 frame 중심으로 화면을 갱신한다.

7. UI는 최신 frame을 기반으로 `Graph view`를 갱신한다.
   - 이 그림에서는 graph rendering의 세부 route를 생략한다.
   - 다음 Sequence Diagram에서 `AnalysisFrame`이 scheduler, router, consumer, renderer로 어떻게 전달되는지 이어서 보여준다.

## QAS Connection

| QAS | How This View Supports It |
|---|---|
| Performance / Resource Control | `Shared Data`와 `Latest-Frame Buffer`가 input rate, analysis rate, UI rendering rate 사이의 차이를 완충한다. 특히 UI는 latest-wins 방식으로 backlog를 줄인다. |
| Modifiability | Core 분석 결과는 `AnalysisFrame` DTO로 UI에 전달된다. 새 graph를 추가할 때 Core worker hot path를 직접 바꾸기보다, graph consumer/renderer 쪽 변경으로 제한할 수 있다. |
| Consistency | 여러 graph가 서로 다른 분석을 따로 수행하는 것이 아니라, 같은 `AnalysisFrame` contract를 기준으로 표시된다. |
| Testability | `AnalysisWorker` 내부 분석 흐름과 `AnalysisFrame` 생성은 UI rendering과 분리해서 설명하고 검증할 수 있다. |

## Presenter Script

이 슬라이드는 앞에서 설명한 Context Diagram의 용어를 사용해서, 실제 watch sound가 graph로 보이기 전까지 어떤 처리 흐름을 거치는지 Pipe-and-Filter 관점으로 정리한 그림입니다.

왼쪽부터 보면 `Audio Input`이 microphone 또는 audio signal을 받아 시스템 안으로 넣습니다. 이 component의 책임은 signal capture이고, 분석 알고리즘이나 graph rendering을 직접 수행하지는 않습니다.

그 다음 signal은 `Shared Data`에 write됩니다. 여기서 중요한 점은 audio input과 analysis worker를 직접 강하게 묶지 않는다는 것입니다. `Shared Data`는 input side와 analysis side 사이의 buffer 역할을 하기 때문에, audio가 들어오는 속도와 분석이 수행되는 속도를 architecture level에서 분리할 수 있습니다.

오른쪽의 `AnalysisWorker`는 Core analysis를 수행하는 worker-level component입니다. 이 worker는 `Shared Data`에서 audio block을 읽고, 내부 분석 단계를 순차적으로 수행합니다. 아래쪽 박스가 그 내부를 확대한 부분입니다. 여기서는 모든 세부 filter를 다 보여주기보다, 발표에서 중요한 흐름인 `audio block -> Detector -> Analysis -> AnalysisFrame DTO`를 보여주고 있습니다.

`Detector`는 raw signal에서 watch beat event를 찾는 단계이고, `Analysis`는 그 결과를 rate, amplitude, beat error, graph payload에 필요한 분석 결과로 정리하는 단계입니다. 최종적으로 이 결과가 `AnalysisFrame` DTO로 만들어집니다.

여기서 `AnalysisFrame`이 중요합니다. 이것은 Core와 UI 사이의 안정적인 data contract입니다. Core worker가 특정 graph renderer를 직접 호출하는 것이 아니라, 한 번의 analysis pass 결과를 `AnalysisFrame`이라는 DTO로 묶어서 UI 쪽으로 넘깁니다.

UI 쪽에는 `Latest-Frame Buffer`가 있습니다. 이 이름을 queue라고 하지 않은 이유는, 모든 frame을 순서대로 쌓아두고 반드시 다 렌더링하는 구조가 아니기 때문입니다. UI rendering은 비용이 큰 작업이 될 수 있기 때문에, 오래된 frame을 계속 쌓기보다 최신 frame을 중심으로 화면을 갱신하는 latest-wins handoff로 이해하는 것이 맞습니다.

마지막으로 UI는 이 최신 frame을 사용해서 `Graph view`를 갱신합니다. 이 슬라이드에서는 여기까지를 구조적으로 보여주고, 실제로 `AnalysisFrame`이 scheduler, router, consumer, renderer를 통해 선택된 graph까지 어떻게 전달되는지는 다음 Sequence Diagram에서 설명하겠습니다.

따라서 이 그림의 핵심 메시지는 두 가지입니다. 첫째, input, analysis, UI rendering 책임이 분리되어 있습니다. 둘째, Core 분석 결과는 `AnalysisFrame` DTO라는 명확한 계약으로 UI에 전달되며, graph rendering 세부 구조와 Core hot path가 직접 결합되어 있지 않습니다.

## If Asked

**Q. 이 그림은 정확한 UML Pipe-and-Filter 다이어그램인가?**  
엄격한 UML이라기보다 architecture view입니다. Context Diagram의 용어를 유지하면서 runtime data flow와 responsibility separation을 설명하기 위한 informal Pipe-and-Filter view입니다.

**Q. `Shared Data`는 pipe인가, buffer인가?**  
순수한 function-to-function pipe라기보다는 component 사이 data handoff를 완충하는 shared buffer입니다. 그래서 legend에서는 `Shared Data / Buffer`로 표현하는 것이 더 정확합니다.

**Q. `Latest-Frame Buffer`는 queue인가?**  
FIFO queue라고 설명하면 오해가 생깁니다. 모든 frame을 쌓아서 순서대로 처리하는 것이 아니라, UI rendering 쪽에서 최신 frame을 중심으로 처리하는 latest-wins handoff로 설명하는 것이 안전합니다.

**Q. 왜 `AnalysisFrameReady(frame)` 이벤트를 그림에 직접 쓰지 않았나?**  
이 그림은 구조적 처리 흐름을 보여주는 view이기 때문입니다. 이벤트/메서드 호출이 renderer까지 전달되는 시간 순서 흐름은 다음 Sequence Diagram에서 따로 보여주는 것이 더 깔끔합니다.

**Q. `Detector`와 `Analysis`는 실제 코드의 모든 단계를 그대로 나타내나?**  
아닙니다. 발표용으로 중요한 내부 처리 단계를 추상화한 것입니다. 실제 구현에는 더 세부적인 signal processing과 metric 계산이 있지만, 이 그림에서는 핵심 책임만 보여줍니다.

**Q. 이 그림으로 어떤 QAS를 강조할 수 있나?**  
Performance/resource control, modifiability, consistency를 강조하기 좋습니다. `Shared Data`와 `Latest-Frame Buffer`는 처리 속도 차이를 완충하고, `AnalysisFrame` DTO는 Core 분석과 graph rendering 사이의 결합을 줄입니다.

**Q. 새 graph를 추가하면 이 구조에서 어디가 바뀌나?**  
Core 분석 결과가 이미 `AnalysisFrame`으로 전달되기 때문에, 일반적으로 새 graph의 consumer/renderer/catalog 쪽 변경이 중심이 됩니다. Core worker hot path를 매번 직접 수정하는 구조가 아니라는 점을 강조하면 됩니다.

## One-Sentence Summary

이 그림은 watch signal이 `Audio Input`과 `Shared Data`를 거쳐 `AnalysisWorker`에서 `AnalysisFrame` DTO로 정리되고, UI의 `Latest-Frame Buffer`를 통해 graph display로 넘어가는 책임 분리 구조를 보여준다.
