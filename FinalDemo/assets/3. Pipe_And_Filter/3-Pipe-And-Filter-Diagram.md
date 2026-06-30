# Pipe-and-Filter / Runtime Dataflow Speaker Notes

![Pipe-and-filter architecture diagram](<3. Pipe_And_Filter.drawio.png>)

Draw.io source: [3. Pipe_And_Filter.drawio](<3. Pipe_And_Filter.drawio>)

Rendered preview: [3. Pipe_And_Filter.drawio.png](<3. Pipe_And_Filter.drawio.png>)

## Slide Purpose

이 그림은 watch sound가 입력되어 Core에서 분석되고, `AnalysisFrame DTO`로 정리되어 UI graph view로 전달되는 **전체 runtime dataflow**를 보여준다.

핵심 메시지는 다음과 같다.

- Audio input, shared data, analysis worker, UI graph view의 책임이 분리되어 있다.
- `AnalysisWorker` 내부에서는 detector와 analysis 단계가 순차적으로 실행되어 `AnalysisFrame DTO`를 만든다.
- 만들어진 frame은 UI thread / latest-frame buffer 쪽으로 넘어가고, 이후 세부 routing과 rendering은 Sequence Diagram에서 설명한다.

## Core Flow

1. `Audio Input`이 watch sound를 받아 `Shared Data`에 기록한다.
2. `Shared Data`는 input side와 analysis side 사이의 buffer 역할을 한다.
3. `AnalysisWorker`가 audio block을 읽어 Core analysis를 수행한다.
4. worker 내부에서 `Detector -> Analysis -> AnalysisFrame DTO` 순서로 결과가 정리된다.
5. `AnalysisFrame DTO`가 UI thread / latest-frame buffer 쪽으로 전달된다.
6. UI는 최신 frame을 기준으로 graph view를 update한다.

## Presenter Script

이 그림은 watch sound가 graph로 보이기까지의 전체 처리 흐름을 보여줍니다.

먼저 Audio Input이 signal을 받아 Shared Data에 기록합니다. Shared Data는 input side와 analysis side 사이의 buffer 역할을 하며, audio input과 analysis worker가 직접 강하게 묶이지 않도록 합니다.

다음으로 AnalysisWorker가 Shared Data에서 audio block을 읽고 Core analysis를 수행합니다. 아래 detail 영역은 이 worker 내부를 확대한 것입니다. Detector가 beat event를 찾고, Analysis 단계가 rate, amplitude, beat error 같은 결과를 계산합니다. 그 결과가 하나의 `AnalysisFrame DTO`로 정리됩니다.

여기서 `AnalysisFrame DTO`는 Core와 UI 사이의 data contract입니다. Core worker가 graph renderer를 직접 호출하는 것이 아니라, 분석 결과를 frame으로 묶어 UI 쪽으로 넘깁니다.

UI 쪽에서는 latest-frame buffer를 통해 최신 frame 중심으로 graph를 갱신합니다. 이 그림은 `AnalysisFrame`이 어디서 만들어져 UI로 넘어오는지 보여주고, 그 frame이 router와 consumer를 거쳐 실제 renderer까지 전달되는 세부 흐름은 Sequence Diagram에서 이어서 설명합니다.

## Architecture Interpretation

이 그림은 strict pipe-and-filter 구현을 주장하기 위한 그림이라기보다, **pipe-and-filter style의 staged dataflow**를 보여주는 view이다.

특히 `AnalysisWorker` 내부의 detector와 analysis는 독립 프로세스가 병렬로 pipe를 주고받는 구조라기보다 synchronous staged chain에 가깝다. 따라서 발표에서는 “strict pipe-and-filter”라고 단정하기보다 “worker-level pipe-and-filter style dataflow”라고 말하는 것이 안전하다.

## Relation To Other Views

- 이 그림은 전체 dataflow와 책임 분리를 보여준다.
- Sequence Diagram은 `AnalysisFrame DTO`가 UI routing 내부에서 어떻게 전달되는지 보여준다.
- Uses View는 이 흐름을 가능하게 하는 static dependency와 변경 영향 범위를 보여준다.

## If Asked

**Q. 이것을 strict pipe-and-filter라고 봐도 되나?**  
완전한 strict pipe-and-filter 구현이라기보다 dataflow와 staged processing을 설명하는 architecture view라고 말하는 것이 안전하다. `AnalysisWorker` 내부는 synchronous staged chain으로 보는 것이 맞다.

**Q. Latest-Frame Buffer는 FIFO queue인가?**  
모든 frame을 FIFO로 끝까지 처리한다는 의미보다, UI가 처리 가능한 최신 frame 중심으로 graph를 갱신하는 latest-frame handoff로 설명하는 것이 좋다.

**Q. 이 그림에서 강조할 QAS는 무엇인가?**  
Modifiability와 performance/resource control이다. Core analysis는 `AnalysisFrame DTO`를 만들고, UI rendering 흐름은 그 이후로 분리되어 변경 영향과 rendering 부담을 설명할 수 있다.

## One-Sentence Summary

watch sound는 `Audio Input -> Shared Data -> AnalysisWorker -> AnalysisFrame DTO -> Latest-Frame Buffer -> Graph view` 흐름으로 전달되며, 이 구조는 input, analysis, UI rendering 책임을 분리한다.