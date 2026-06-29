# AnalysisFrame Graph-to-Payload Mapping View

이 그림은 UML 클래스 다이어그램을 실제 대표 graph/display 소비 관계로 연결한다.

발표 포인트:

- UML class diagram은 `AnalysisFrame`의 정적 구조를 보여준다.
- Mapping View는 그 구조가 실제 화면에서 어떻게 소비되는지 보여준다.
- 모든 그래프를 나열하는 목적이 아니라, 대표 그래프를 통해 공통 frame contract를 설명하는 목적이다.
- 핵심 메시지: 각 graph가 Core에 직접 붙는 것이 아니라, 같은 `AnalysisFrame`에서 필요한 payload만 소비한다.

대표 mapping:

- `ScopeSeries / RateSeries / Markers` -> `RateScopeRenderer`, `BeatErrorDiagRenderer`
- `MetricsHistory` -> `BeatErrorDiagRenderer`, `VarioRenderer`, `LongTermPerfRenderer`
- `BeatSegments` -> `BeatNoiseScopeRenderer`, `WaveformCompareRenderer`
- `SoundImage / SpectrogramImage + metadata` -> `SoundPrintFrameConsumer`, `SpectrogramFrameConsumer`
