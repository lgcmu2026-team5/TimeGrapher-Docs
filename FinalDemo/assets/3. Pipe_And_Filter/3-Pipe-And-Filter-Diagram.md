# Pipe-and-Filter Architecture View Speaker Notes

![Pipe-and-filter architecture diagram](<3. Pipe_And_Filter.png>)

Draw.io source: [3. Pipe_And_Filter.drawio](<3. Pipe_And_Filter.drawio>)

Rendered preview: [3. Pipe_And_Filter.png](<3. Pipe_And_Filter.png>)

Rendered vector preview: [3. Pipe_And_Filter.svg](<3. Pipe_And_Filter.svg>)

## Slide Purpose

이 그림은 Context Diagram의 용어를 그대로 사용해서, watch sound가 분석되고 graph로 표시되기까지의 큰 흐름을 보여준다.

핵심은 두 가지이다.

- `Audio Input`, `Shared Data`, `AnalysisWorker`, `UI Thread`가 서로 다른 책임을 가진다.
- `AnalysisWorker` 안에서 분석 결과가 `AnalysisFrame DTO`로 정리되고, 이 DTO가 UI graph 표시의 입력이 된다.

세부 메서드 호출이나 renderer 전달 과정은 이 그림에서 모두 설명하지 않는다. 그 부분은 다음 Sequence Diagram에서 이어서 설명한다.

## Core Flow

1. `Audio Input`이 watch sound를 받아 `Shared Data`에 쓴다.
2. `Shared Data`는 입력 쪽과 분석 쪽 사이의 buffer 역할을 한다.
3. `AnalysisWorker`가 `Shared Data`에서 audio block을 읽어 분석한다.
4. `AnalysisWorker` 내부에서는 `Detector -> Analysis -> AnalysisFrame DTO` 흐름으로 결과가 만들어진다.
5. 만들어진 `AnalysisFrame`은 UI 쪽 `Latest-Frame Buffer`로 넘어간다.
6. UI는 최신 frame을 기준으로 `Graph view`를 갱신한다.

여기서 `Latest-Frame Buffer`는 FIFO queue가 아니라 latest-wins handoff로 설명하는 것이 좋다. 즉, 모든 frame을 쌓아서 전부 그리는 구조가 아니라 UI가 처리할 수 있는 최신 frame 중심으로 화면을 갱신한다.

## Presenter Script

이 그림은 watch sound가 graph로 보이기 전까지의 큰 처리 흐름을 보여줍니다.

먼저 `Audio Input`이 signal을 받아 `Shared Data`에 씁니다. `Shared Data`는 input side와 analysis side 사이의 buffer 역할을 해서, audio input과 analysis worker가 직접 강하게 묶이지 않도록 합니다.

그 다음 `AnalysisWorker`가 `Shared Data`에서 audio block을 읽고 Core analysis를 수행합니다. 아래쪽 detail view는 같은 `AnalysisWorker` 내부를 확대한 것입니다. 여기서 `Detector`가 beat event를 찾고, `Analysis` 단계에서 rate, amplitude, beat error 같은 graph/metric에 필요한 결과로 정리됩니다.

그 결과는 `AnalysisFrame DTO`로 만들어집니다. 이 DTO가 Core와 UI 사이의 data contract입니다. Core worker가 graph renderer를 직접 호출하는 것이 아니라, 분석 결과를 `AnalysisFrame`으로 묶어서 UI 쪽으로 넘깁니다.

UI 쪽에서는 `Latest-Frame Buffer`를 통해 최신 frame 중심으로 graph를 갱신합니다. 이 그림에서는 여기까지의 구조적 흐름만 보여주고, `AnalysisFrame`이 실제 renderer까지 어떻게 전달되는지는 다음 Sequence Diagram에서 설명하겠습니다.

## If Asked

**Q. 왜 `AnalysisWorker` 내부를 따로 그렸나?**  
위쪽에서는 `AnalysisWorker`를 하나의 component로 단순화했고, 아래쪽은 그 내부에서 `AnalysisFrame DTO`가 만들어지는 지점을 확대한 것이다.

**Q. `Latest-Frame Buffer`는 queue인가?**  
FIFO queue는 아니다. 오래된 frame을 모두 쌓아서 처리한다기보다, UI가 최신 frame 중심으로 갱신되도록 하는 handoff 지점이다.

**Q. 이 그림에서 강조할 QAS는 무엇인가?**  
책임 분리와 modifiability이다. Core analysis는 `AnalysisFrame`을 만들고, graph rendering 세부 흐름은 UI 쪽에서 처리되므로 Core와 UI가 직접 강하게 결합되지 않는다.

## One-Sentence Summary

watch sound는 `Audio Input -> Shared Data -> AnalysisWorker -> AnalysisFrame DTO -> Latest-Frame Buffer -> Graph view` 흐름으로 전달되며, 이 구조는 input, analysis, UI rendering 책임을 분리한다.
