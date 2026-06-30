# TimeGrapher Worker Pipeline View - Runtime Analysis Flow

이 런타임 뷰는 측정 실행 중 사용하는 worker-level Pipe-and-Filter 구조를 보여준다. [ADR-002](../ADR/ADR-002.md)가 참조하는 다이어그램의 architecture view다.

**표기:** UML-style component and connector diagram.

## Primary Presentation

![Worker-level partial Pipe-and-Filter](../../assets/worker-level-partial-pipe-and-filter.svg)

Editable source: [worker-level-partial-pipe-and-filter.drawio](../../assets/worker-level-partial-pipe-and-filter.drawio)

## Element Catalog

| Element | Type | 책임 |
|---|---|---|
| Input worker | Worker/filter | live audio, playback audio, simulated audio 중 선택된 입력을 캡처해 shared buffer에 block을 쓴다. |
| MasterAudioBuffer | Bounded pipe | input production과 analysis consumption을 분리한다. |
| Analysis worker | Worker/filter | audio block을 읽고 detection/metrics/imaging을 실행한 뒤 `AnalysisFrame` 결과를 만든다. |
| Optional TinyML classifier | Leaf component | `ISignalQualityClassifier`를 통해 `SignalQuality` label을 만든다. ONNX loading은 `TimeGrapher.Core` 밖에 두며 실패 시 heuristic classifier로 폴백한다. |
| Latest-wins frame scheduler | Pipe | 오래된 frame을 쌓지 않고 최신 frame을 전달해 UI 응답성을 유지한다. |
| UI/render path | Final consumer | 최신 `AnalysisFrame`으로 active tab과 status/warning overlay를 렌더링한다. |
| Recording queue and writer | Pipe + consumer | analysis를 막지 않고 measurement data를 저장한다. |

## Behavior

1. 선택된 input source가 audio block을 `MasterAudioBuffer`에 쓴다.
2. `AnalysisWorker`는 전용 analysis thread에서 block을 소비하고, stage별 queue overhead를 피하기 위해 내부 DSP/metrics chain을 synchronous하게 유지한다.
3. 선택적 TinyML classifier는 비파괴적인 signal-quality label만 추가한다. weak/noisy/unstable signal은 `AnalysisFrame.SignalQuality`와 UI warning으로 보고하며, classifier가 rate, amplitude, beat-error 측정을 버리거나 수정하지 않는다.
4. latest-wins scheduler는 최신 frame만 UI/render path로 전달한다. Rendering은 active-tab 중심이므로 tab 선택에 따라 그려지는 graph가 바뀌며, 모든 graph tab을 매 frame 강제로 렌더링하지 않는다.
5. Recording은 별도 bounded queue를 사용하므로 file I/O가 input capture나 analysis를 막지 않는다.

이 뷰는 input, analysis, rendering, recording을 분리해 **QAS-2 Performance**를 지원하고, weak/noisy/unstable signal state를 보고해 **QAS-3 Reliability**를 지원하며, 하나의 analysis cycle에서 `AnalysisFrame`을 만들어 **QAS-4 Consistency**를 지원한다.

## Related ADRs

- [ADR-002 — Worker-Level Partial Pipe-and-Filter 적용](../ADR/ADR-002.md): worker-level pipeline을 쓰는 이유와 analysis hot path를 synchronous하게 유지하는 이유를 기록한다.

## Related views

- [Run Lifecycle Sequence View](5-4-Run-Lifecycle-Sequence-View.md) — 측정 루프의 호출 순서.
- [Module Uses View](5-2-Module-Uses-View.md) — 이 worker 뒤의 정적 모듈 의존성.
- [Deployment View](5-6-Deployment-View.md) — 이 pipeline이 실행되는 하드웨어/runtime node.
