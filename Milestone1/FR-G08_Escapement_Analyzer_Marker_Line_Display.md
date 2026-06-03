# FR-G08 Escapement Analyzer & Marker-Line Display

## Functional Requirements

| ID | Priority | Functional Requirement | Requirement Basis |
|---|---|---|---|
| FR-G08-01 | Mandatory | [EN] The system shall visualize and display real-time microphone input.<br>[KO] 시스템은 실시간 마이크 입력을 시각화하여 디스플레이해야 한다. | [EN] Project Plan Draft p.6 states that the baseline GUI displays the raw acoustic signal from the mechanical watch in real time; p.7 defines Live Mode as capturing and analyzing signal data directly from the microphone in real time.<br>[KO] Project Plan Draft p.6은 baseline GUI가 mechanical watch의 raw acoustic signal을 실시간으로 표시한다고 설명하며, p.7은 Live Mode가 microphone에서 signal data를 직접 실시간 capture 및 analyze한다고 정의한다. |
| FR-G08-02 | Mandatory | [EN] The system shall visualize and display stored recording files.<br>[KO] 시스템은 저장 된 녹음 파일을 시각화하여 디스플레이 해야 한다. | [EN] Project Plan Draft p.8 defines Playback Mode as using a previously recorded signal for reviewing past captures, debugging software, and comparing algorithm behavior on the same data.<br>[KO] Project Plan Draft p.8은 Playback Mode가 이전에 녹음된 signal을 사용하여 past capture 검토, software debugging, 동일 data에서 algorithm behavior 비교에 유용하다고 정의한다. |
| FR-G08-03 | Mandatory | [EN] The system shall support pause/capture mode for the visualization display used for analysis.<br>[KO] 시스템은 분석을 위한 시각화 디스플레이를 일시정지/캡처 모드를 지원할 수 있어야 한다. | [EN] Project Plan Draft p.10 requires the user to be able to pause the live display in any graph or tab and move backward and forward through captured readings; p.11 says users should inspect prior data without losing the recorded signal or forcing a reset.<br>[KO] Project Plan Draft p.10은 사용자가 어떤 graph 또는 tab에서도 live display를 pause하고 captured reading을 앞뒤로 이동할 수 있어야 한다고 요구하며, p.11은 recorded signal을 잃거나 reset하지 않고 prior data를 검사할 수 있어야 한다고 설명한다. |
| FR-G08-05 | Mandatory | [EN] The system shall provide vertical markers at tick (A) and tock (C) event points selected for analysis by the user.<br>[KO] 시스템은 사용자가 분석하고자 하는 틱(A)과 톡(C) 이벤트 지점에 수직 마커를 제공해야한다. | [EN] Project Plan Draft p.20 requires an Escapement Analyzer and Marker-Line Display with vertical timing markers, and states that the system shall support placing and displaying markers for the relevant A and C events.<br>[KO] Project Plan Draft p.20은 vertical timing marker를 포함한 Escapement Analyzer and Marker-Line Display를 요구하며, relevant A and C event에 marker를 배치하고 표시하는 기능을 최소 요구사항으로 제시한다. |
| FR-G08-06 | Mandatory | [EN] The system shall calculate and display the elapsed time between markers in milliseconds.<br>[KO] 시스템은 마커 간의 경과 시간은 ms 단위로 계산하여 화면에 나타내야 한다. | [EN] Project Plan Draft p.20 requires millisecond labels for important escapement-cycle events and states that the system shall calculate the elapsed time between A and C events in milliseconds.<br>[KO] Project Plan Draft p.20은 escapement cycle의 중요 event에 대한 millisecond label을 요구하고, A/C event 사이의 elapsed time을 millisecond 단위로 계산해야 한다고 명시한다. |
| FR-G08-07 | Mandatory | [EN] The system shall allow the user to change the marker measurement criterion based on signal feature points such as onset or peak.<br>[KO] 시스템은 신호의 특징점(Onset 또는 Peak 등)을 기준으로 마커의 측정 기준을 사용자가 변경할 수 있어야 한다. | [EN] Project Plan Draft p.20 states that the interface should allow the user to compare alternative interpretations of the signal, such as measuring from the start/onset of a feature or from its peak, to determine which reference point produces stable and meaningful timing results.<br>[KO] Project Plan Draft p.20은 interface가 feature의 start/onset 또는 peak에서 측정하는 대안적 signal 해석을 비교할 수 있게 해야 하며, 어떤 reference point가 안정적이고 의미 있는 timing result를 만드는지 판단하는 것이 목적이라고 설명한다. |

## Quality Attributes

### QA-G08-01 Analysis Mode Entry Latency

**Scenario**

[EN] When the user manipulates the waveform display, such as marker controls, under normal conditions, the system enters analysis mode within 100 ms.

[KO] 사용자가 정상상황에서 마커 등 음성 파형 디스플레이 화면을 조작하면, 시스템은 100ms 이내에 분석 모드에 진입한다.

**Quality Attribute Rationale**

[EN] Performance is selected because Project Plan Draft p.25 requires low end-to-end latency between acoustic capture and presentation of waveform, markers, and computed values in the GUI.

[KO] Project Plan Draft p.25가 acoustic capture와 GUI의 waveform, marker, computed value 표시 사이의 낮은 end-to-end latency를 요구하므로 Performance를 선택한다.

| Field | Description |
|---|---|
| ID | QA-G08-01 |
| Quality Attribute | [EN] Performance<br>[KO] 성능 |
| Source of Stimulus | [EN] User<br>[KO] 사용자 |
| Stimulus | [EN] The user manipulates the audio waveform display, such as marker controls.<br>[KO] 사용자가 마커 등 음성 파형 디스플레이 화면을 조작한다. |
| Artifact | [EN] System analysis mode<br>[KO] 시스템 분석 모드 |
| Environment | [EN] Normal operating condition<br>[KO] 정상상황 |
| Response | [EN] The system enters analysis mode.<br>[KO] 시스템은 분석 모드에 진입한다. |
| Response Measure | [EN] The operation completes within 100 ms.<br>[KO] 동작은 100ms 이내에 완료된다. |

### QA-G08-02 Marker Algorithm Modifiability

**Scenario**

[EN] When the user selects onset or peak under normal conditions, the system applies the configured marker value and the existing code modification remains below 10% for adding or changing a marker algorithm module.

[KO] 사용자가 정상상황에서 onset 또는 peak를 설정하면, 시스템은 설정한 마크 값으로 알고리즘을 적용하고 새로운 알고리즘 모듈 추가 또는 변경 시 기존 코드 수정은 10% 미만으로 유지된다.

**Quality Attribute Rationale**

[EN] Modifiability is selected because Project Plan Draft p.26 requires the architecture to support adding new measurements, filters, graphs, and display modes without major redesign, with signal acquisition, processing, calculation, and presentation separated.

[KO] Project Plan Draft p.26이 acquisition, processing, calculation, presentation을 분리하여 새로운 measurement, filter, graph, display mode를 major redesign 없이 추가할 수 있어야 한다고 요구하므로 Modifiability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-G08-02 |
| Quality Attribute | [EN] Modifiability<br>[KO] 변경 용이성 |
| Source of Stimulus | [EN] User<br>[KO] 사용자 |
| Stimulus | [EN] Onset or peak criterion is configured.<br>[KO] Onset 또는 Peak 기준이 설정된다. |
| Artifact | [EN] Marker detection algorithm and display behavior<br>[KO] Marker 검출 알고리즘 및 display 동작 |
| Environment | [EN] Normal operating condition<br>[KO] 정상상황 |
| Response | [EN] The system applies the configured marker value to the algorithm.<br>[KO] 시스템은 설정한 마크 값으로 알고리즘을 적용한다. |
| Response Measure | [EN] When a new algorithm module is added or changed, the impact on existing code remains below 10%.<br>[KO] 새로운 알고리즘 모듈 추가 또는 변경 시 기존 코드 수정 영향도는 10% 미만이다. |

### QA-G08-03 Analysis Visualization Correctness

**Scenario**

[EN] When the user enters analysis mode, the system visualizes the audio data without distortion.

[KO] 사용자가 분석모드 상황에 진입하면, 시스템은 음성 데이터를 왜곡 없이 시각화한다.

**Quality Attribute Rationale**

[EN] Correctness / Measurement Accuracy is selected because Project Plan Draft p.11 requires users to inspect prior data without losing the recorded signal or forcing a reset, and p.25 requires displayed values and graphs to correspond to the underlying watch events while avoiding stale data, backlog, or timing failures.

[KO] Project Plan Draft p.11이 recorded signal 손실이나 reset 없이 prior data를 검사할 수 있어야 한다고 요구하고, p.25가 표시값과 graph가 underlying watch event와 대응하며 stale data, backlog, timing failure를 피해야 한다고 요구하므로 Correctness / Measurement Accuracy를 선택한다.

| Field | Description |
|---|---|
| ID | QA-G08-03 |
| Quality Attribute | [EN] Correctness / Measurement Accuracy<br>[KO] 정확성 / 측정 정확성 |
| Source of Stimulus | [EN] User<br>[KO] 사용자 |
| Stimulus | [EN] The user enters analysis mode.<br>[KO] 사용자가 분석모드 상황에 진입한다. |
| Artifact | [EN] Audio-data visualization display<br>[KO] 음성 데이터 시각화 display |
| Environment | [EN] Normal operating condition<br>[KO] 정상상황 |
| Response | [EN] The visualized audio-data screen is shown.<br>[KO] 시각화한 음성데이터 화면이 보여진다. |
| Response Measure | [EN] The audio-data buffer is dumped without distortion.<br>[KO] 음성 데이터 버퍼는 왜곡 없이 덤프된다. |

### QA-G08-04 Marker and Waveform Alignment

**Scenario**

[EN] When A/C event markers are generated from the acoustic waveform, the marker positions remain aligned with the signal features they represent and the elapsed time is calculated from those same event timestamps.

[KO] acoustic waveform에서 A/C event marker가 생성되면, marker position은 자신이 나타내는 signal feature와 정렬을 유지하고 elapsed time은 동일 event timestamp에서 계산된다.

**Quality Attribute Rationale**

[EN] Correctness / Measurement Accuracy is selected because Project Plan Draft p.20 requires marker positions to update consistently with the waveform and remain visually aligned with the signal features, and p.26 requires accurate identification of start/onset and peak of important acoustic signals.

[KO] Project Plan Draft p.20이 marker position이 waveform과 일관되게 업데이트되고 signal feature와 시각적으로 정렬되어야 한다고 요구하며, p.26이 중요한 acoustic signal의 start/onset과 peak를 정확히 식별해야 한다고 요구하므로 Correctness / Measurement Accuracy를 선택한다.

| Field | Description |
|---|---|
| ID | QA-G08-04 |
| Quality Attribute | [EN] Correctness / Measurement Accuracy<br>[KO] 정확성 / 측정 정확성 |
| Source of Stimulus | [EN] Acoustic event detection pipeline<br>[KO] Acoustic event detection pipeline |
| Stimulus | [EN] A and C event markers are generated from the waveform.<br>[KO] waveform에서 A 및 C event marker가 생성된다. |
| Artifact | [EN] Escapement Analyzer and Marker-Line Display<br>[KO] Escapement Analyzer and Marker-Line Display |
| Environment | [EN] Live or Playback mode with valid watch signal and visible waveform<br>[KO] 유효한 watch signal과 visible waveform이 있는 Live 또는 Playback mode |
| Response | [EN] The system displays marker lines aligned with detected A/C waveform features and calculates elapsed time from the same event timestamps.<br>[KO] 시스템은 감지된 A/C waveform feature와 정렬된 marker line을 표시하고 동일 event timestamp에서 elapsed time을 계산한다. |
| Response Measure | [EN] In the reviewed sample set, marker positions remain visually aligned with their corresponding waveform features, and marker interval values are derived from the same A/C event timestamps with 0 inconsistent marker/interval references.<br>[KO] 검토 sample set에서 marker position은 대응 waveform feature와 시각적 정렬을 유지하고, marker interval 값은 동일 A/C event timestamp에서 도출되며 marker/interval reference 불일치는 0건이다. |

### QA-G08-05 Marker Measurement Testability

**Scenario**

[EN] When a tester runs the same Playback or Sim input set multiple times, the marker positions and marker interval measurements remain repeatable.

[KO] 테스터가 동일한 Playback 또는 Sim 입력 세트를 여러 번 실행하면, marker position과 marker interval 측정값은 반복 가능하게 유지된다.

**Quality Attribute Rationale**

[EN] Testability is selected because Paulo's guidance requires measurable QA scenarios, and Project Plan Draft p.8 to p.9 define Playback and Sim modes as controlled inputs for reviewing captures, debugging software, and evaluating detection, graphing, and GUI behavior.

[KO] 파울로 교수의 지침은 측정 가능한 QA scenario를 요구하며, Project Plan Draft p.8~p.9는 Playback과 Sim mode를 capture 검토, software debugging, detection/graphing/GUI behavior 평가를 위한 controlled input으로 정의하므로 Testability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-G08-05 |
| Quality Attribute | [EN] Testability<br>[KO] 테스트 용이성 |
| Source of Stimulus | [EN] Tester<br>[KO] 테스터 |
| Stimulus | [EN] The same Playback or Sim input set is executed repeatedly for marker-line verification.<br>[KO] marker-line 검증을 위해 동일한 Playback 또는 Sim 입력 세트가 반복 실행된다. |
| Artifact | [EN] Marker placement and marker interval calculation<br>[KO] Marker 배치 및 marker interval 계산 |
| Environment | [EN] Development or integration test environment using controlled Playback or Sim data<br>[KO] controlled Playback 또는 Sim data를 사용하는 개발 또는 통합 테스트 환경 |
| Response | [EN] The system produces repeatable marker positions and elapsed-time measurements for the same input data.<br>[KO] 시스템은 동일 입력 데이터에 대해 반복 가능한 marker position과 elapsed-time measurement를 생성한다. |
| Response Measure | [EN] Across 3 repeated runs of the same input set, selected A/C marker positions and displayed marker intervals match within the displayed precision.<br>[KO] 동일 입력 세트 3회 반복 실행에서 선택된 A/C marker position과 표시 marker interval은 표시 정밀도 이내에서 일치한다. |

### QA-G08-06 Reference Point Interpretability

**Scenario**

[EN] When the user compares onset-based and peak-based timing interpretations, the display supports deciding which reference point produces the more stable and meaningful timing result.

[KO] 사용자가 onset 기준과 peak 기준 timing 해석을 비교할 때, display는 어떤 reference point가 더 안정적이고 의미 있는 timing result를 만드는지 판단할 수 있게 지원한다.

**Quality Attribute Rationale**

[EN] Usability is selected because Project Plan Draft p.20 says the interface should allow alternative interpretations of the signal, such as measuring from start/onset or peak, to help determine which reference point produces stable and meaningful timing results.

[KO] Project Plan Draft p.20이 interface가 start/onset 또는 peak 기준 측정 같은 signal의 alternative interpretation을 비교할 수 있게 하고, 어떤 reference point가 stable하고 meaningful한 timing result를 만드는지 판단하도록 도와야 한다고 설명하므로 Usability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-G08-06 |
| Quality Attribute | [EN] Usability<br>[KO] 사용성 |
| Source of Stimulus | [EN] User<br>[KO] 사용자 |
| Stimulus | [EN] The user compares timing measured from onset against timing measured from peak.<br>[KO] 사용자가 onset 기준 timing과 peak 기준 timing을 비교한다. |
| Artifact | [EN] Escapement Analyzer and Marker-Line Display<br>[KO] Escapement Analyzer and Marker-Line Display |
| Environment | [EN] Acoustic waveform, A/C markers, and millisecond labels are visible during analysis<br>[KO] 분석 중 acoustic waveform, A/C marker, millisecond label이 표시되는 상태 |
| Response | [EN] The system presents the alternative reference-point interpretations in a way that supports comparison.<br>[KO] 시스템은 alternative reference-point interpretation을 비교 가능한 방식으로 제시한다. |
| Response Measure | [EN] During review or demo, the user can identify which reference point produces the more stable and meaningful timing result for the displayed input set.<br>[KO] review 또는 demo 중 사용자는 표시된 input set에 대해 어떤 reference point가 더 stable하고 meaningful한 timing result를 만드는지 식별할 수 있다. |

## Traceability Summary

| Requirement | Related QA | Notes |
|---|---|---|
| FR-G08-01 to FR-G08-03 | QA-G08-01, QA-G08-03, QA-G08-05 | Project Plan Draft p.6 to p.11 support live visualization, playback review, pause, captured-data navigation, and controlled input review. |
| FR-G08-05 to FR-G08-06 | QA-G08-01, QA-G08-04, QA-G08-05 | Project Plan Draft p.20 requires vertical timing markers, millisecond labels, A/C event markers, elapsed-time calculation, and visual alignment with signal features. |
| FR-G08-07 | QA-G08-02, QA-G08-06 | Project Plan Draft p.20 supports comparing onset-based and peak-based marker interpretations to determine the most stable and meaningful timing reference. |
| FR-G08-01 to FR-G08-07 | QA-G08-03, QA-G08-04, QA-G08-05, QA-G08-06 | Project Plan Draft p.11, p.20, p.25, and p.26 support preserving recorded signal data, aligning markers with waveform features, comparing reference points, and keeping displays consistent with underlying watch events. |
