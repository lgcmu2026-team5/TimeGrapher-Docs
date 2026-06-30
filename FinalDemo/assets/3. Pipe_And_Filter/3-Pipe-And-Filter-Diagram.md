# Pipe-and-Filter Architecture View Speaker Notes

![Pipe-and-filter architecture diagram](<3. Pipe_And_Filter.drawio.png>)

Draw.io source: [3. Pipe_And_Filter.drawio](<3. Pipe_And_Filter.drawio>)

Rendered preview: [3. Pipe_And_Filter.drawio.png](<3. Pipe_And_Filter.drawio.png>)


## Slide Purpose

이 그림은 watch sound가 입력되어 분석되고, `AnalysisFrame DTO`로 정리된 뒤 UI graph로 전달되는 전체 runtime dataflow를 보여준다.

강조할 메시지는 두 가지다.

- `Audio Input`, `Shared Data`, `AnalysisWorker`, `UI Thread`가 서로 다른 책임을 가진다.
- `AnalysisWorker` 내부에서는 synchronous staged chain을 통해 분석 결과가 `AnalysisFrame DTO`로 만들어지고, 이 DTO가 UI graph 표시 흐름의 입력이 된다.

이 그림은 renderer 호출 세부 순서까지 모두 설명하지 않는다. `AnalysisFrame`이 실제 graph rendering으로 전달되는 상세 흐름은 다음 Sequence Diagram에서 이어서 설명한다.

## Core Flow

1. `Audio Input`이 watch sound를 받아 `Shared Data`에 write한다.
2. `Shared Data`는 input side와 analysis side 사이의 shared buffer 역할을 한다.
3. `AnalysisWorker`가 `Shared Data`에서 audio block을 read한다.
4. `AnalysisWorker` 내부에서 `Detector -> Analysis -> AnalysisFrame DTO` 순서로 결과가 만들어진다.
5. 만들어진 `AnalysisFrame DTO`는 UI thread 쪽 `Latest-Frame Buffer`로 전달된다.
6. UI는 latest frame을 기준으로 `Graph view`를 render/update한다.

여기서 `Latest-Frame Buffer`는 모든 frame을 순서대로 끝까지 처리하는 FIFO queue라기보다, UI가 처리 가능한 최신 frame 중심으로 화면을 갱신하는 latest-wins handoff로 설명하는 편이 안전하다.

## Presenter Script

이 그림은 watch sound가 graph로 보이기까지의 큰 처리 흐름을 보여줍니다.

먼저 `Audio Input`이 signal을 받아 `Shared Data`에 write합니다. `Shared Data`는 input side와 analysis side 사이의 buffer 역할을 하며, audio input과 analysis worker가 직접 강하게 묶이지 않도록 합니다.

그 다음 `AnalysisWorker`가 `Shared Data`에서 audio block을 read하고 Core analysis를 수행합니다. 아래 detail view는 `AnalysisWorker` 내부를 확대해서 보여주는 부분입니다. 이 안에서 `Detector`가 beat event를 찾고, `Analysis` 단계에서 rate, amplitude, beat error 같은 metric과 graph에 필요한 결과를 정리합니다.

그 결과는 `AnalysisFrame DTO`로 만들어집니다. 이 DTO가 Core와 UI 사이의 data contract입니다. Core worker가 graph renderer를 직접 호출하는 것이 아니라, 분석 결과를 `AnalysisFrame`으로 묶어 UI 쪽으로 넘깁니다.

UI 쪽에서는 `Latest-Frame Buffer`를 통해 최신 frame 중심으로 graph를 갱신합니다. 이 그림에서는 여기까지의 큰 구조와 dataflow를 보여주고, `AnalysisFrame`이 router와 consumer를 거쳐 실제 renderer까지 어떻게 전달되는지는 다음 Sequence Diagram에서 설명합니다.

## Why This Matters Architecturally

이 뷰는 runtime dataflow와 responsibility separation을 설명하기 좋다.

- input, shared buffer, analysis worker, UI thread의 책임이 분리된다.
- Core analysis 결과는 `AnalysisFrame DTO`라는 명시적인 data contract로 정리된다.
- UI thread는 latest frame 중심으로 graph update를 수행하므로 analysis flow와 UI rendering flow가 직접 강하게 묶이지 않는다.
- 내부 processing stages는 `AnalysisWorker` 내부 detail로만 보여주고, graph rendering 상세는 Sequence Diagram으로 분리해서 설명할 수 있다.

## If Asked

**Q. 이 그림을 strict pipe-and-filter라고 봐도 되나?**  
엄밀한 pipe-and-filter 구현이라기보다, dataflow와 staged processing을 pipe-and-filter 관점으로 설명한 architecture view라고 말하는 것이 안전하다. 특히 `AnalysisWorker` 내부는 synchronous staged chain으로 표현되어 있다.

**Q. 왜 `AnalysisWorker` 내부를 따로 그렸나?**  
상단에서는 `AnalysisWorker`를 하나의 component로 단순화하고, 하단에서는 그 내부에서 `AnalysisFrame DTO`가 만들어지는 지점을 보여주기 위해 확대했다.

**Q. `Latest-Frame Buffer`는 queue인가?**  
모든 frame을 FIFO로 끝까지 처리한다는 의미보다는, UI가 처리 가능한 최신 frame 중심으로 graph를 갱신하는 latest-frame handoff로 설명하는 것이 좋다.

**Q. 어떤 QAS와 연결되나?**  
주로 Modifiability와 performance/resource control에 연결된다. Core analysis는 `AnalysisFrame DTO`를 만들고, UI graph rendering 세부 흐름은 UI 쪽으로 분리되므로 변경 영향과 rendering 부담을 나눠 설명할 수 있다.

## One-Sentence Summary

watch sound는 `Audio Input -> Shared Data -> AnalysisWorker -> AnalysisFrame DTO -> Latest-Frame Buffer -> Graph view` 흐름으로 전달되며, 이 구조는 input, analysis, UI rendering 책임을 분리한다.