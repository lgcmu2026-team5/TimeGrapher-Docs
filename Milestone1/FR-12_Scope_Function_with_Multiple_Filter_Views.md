# FR-12 Scope Function with Multiple Filter Views

## Functional Requirements

| ID | Priority | Functional Requirement | Requirement Basis |
|---|---|---|---|
| FR-12-01 | Mandatory | [EN] The system shall provide four filter views — F0, F1, F2, F3 — over the same watch signal.<br>[KO] 시스템은 동일한 시계 신호에 대해 F0, F1, F2, F3 4개의 필터 뷰를 제공해야 한다. | [EN] Project Plan Draft p.23–24 defines the Scope function with the four filter views F0/F1/F2/F3 over the same watch signal.<br>[KO] Project Plan Draft p.23–24는 동일한 시계 신호에 대한 F0/F1/F2/F3 4개 필터 뷰의 Scope 기능을 정의한다. |
| FR-12-02 | Mandatory | [EN] The user shall be able to easily switch among the four filters and compare how each one changes the waveform and the visibility of key events (T1, T2, T3).<br>[KO] 사용자는 4개 필터 간 쉽게 전환하며 각 필터가 파형 및 주요 이벤트(T1·T2·T3) 가시성을 어떻게 바꾸는지 비교할 수 있어야 한다. | [EN] Project Plan Draft p.24 requires easy switching and comparison among the four filters with respect to waveform and key-event (T1/T2/T3) visibility.<br>[KO] Project Plan Draft p.24는 파형 및 주요 이벤트(T1/T2/T3) 가시성에 대한 4개 필터 간 쉬운 전환·비교를 요구한다. |
| FR-12-03 | Mandatory | [EN] All filter views shall update in real time as measurements are acquired and processed.<br>[KO] 모든 필터 뷰는 측정 획득·처리에 따라 실시간으로 갱신되어야 한다. | [EN] Project Plan Draft p.25 (Real-Time Performance) requires the filter views to update in real time as measurements are acquired and processed.<br>[KO] Project Plan Draft p.25 Real-Time Performance는 측정 획득·처리에 따라 필터 뷰가 실시간 갱신되도록 요구한다. |
| FR-12-04 | Mandatory | [EN] All filter views shall be rendered from the same input signal data and the same time axis.<br>[KO] 모든 필터 뷰는 동일한 입력 신호 데이터와 동일한 시간축을 기반으로 렌더링되어야 한다. | [EN] Project Plan Draft p.25 (Correctness) requires the views to share the same underlying data and timing assumptions so they can be compared.<br>[KO] Project Plan Draft p.25 Correctness는 뷰들이 동일 underlying data·timing 가정을 공유하여 비교 가능하도록 요구한다. |
| FR-12-10 | Mandatory | [EN] F0 shall display the signal as captured, formatted to fit the screen and mirrored symmetrically around its average value (reflecting positive and negative excursions), and shall be treated as the closest available representation of the raw watch signal.<br>[KO] F0은 캡처된 신호를 화면에 맞게 포맷하고 평균값을 기준으로 대칭 미러링(양·음 excursion 반사)하여 표시하며, 가장 raw에 가까운 표현으로 취급되어야 한다. | [EN] Project Plan Draft p.24 defines F0 as the screen-formatted, average-mirrored representation closest to the raw watch signal.<br>[KO] Project Plan Draft p.24는 F0을 화면 포맷·평균 미러링된, raw에 가장 가까운 표현으로 정의한다. |
| FR-12-11 | Mandatory | [EN] F1 shall apply a moving-average filter to the F0 signal to smooth the waveform envelope and remove a large portion of background noise.<br>[KO] F1은 F0 신호에 이동 평균(moving-average) 필터를 적용하여 엔벨로프를 평활화하고 배경 노이즈를 상당 부분 제거해야 한다. | [EN] Project Plan Draft p.24 defines F1 as a moving-average filter over F0 that smooths the envelope and removes background noise.<br>[KO] Project Plan Draft p.24는 F1을 F0에 대한 이동 평균 필터로 정의하며, 엔벨로프 평활화 및 배경 노이즈 제거를 수행한다. |
| FR-12-13 | Mandatory | [EN] F2 shall build on F1 by emphasizing rising slopes and attenuating falling slopes to make beat features stand out, especially T3 (and to some extent T2).<br>[KO] F2는 F1을 기반으로 상승 슬로프를 강조하고 하강 슬로프를 감쇠시켜, 특히 T3(일부 T2) 특징을 부각해야 한다. | [EN] Project Plan Draft p.24 defines F2 as building on F1 with rising-slope emphasis and falling-slope attenuation to highlight T3 (and partly T2).<br>[KO] Project Plan Draft p.24는 F2를 F1 기반의 상승 슬로프 강조·하강 슬로프 감쇠로 정의하여 T3(일부 T2)을 부각한다. |
| FR-12-14 | Optional | [EN] F2 may use an attenuation function that decays after a local rise.<br>[KO] F2는 국소 상승 후 decay하는 감쇠 함수를 사용할 수 있다. | [EN] Project Plan Draft p.24 allows F2 to implement its slope attenuation via a function that decays after a local rise.<br>[KO] Project Plan Draft p.24는 F2의 슬로프 감쇠를 국소 상승 후 decay하는 함수로 구현하는 것을 허용한다. |
| FR-12-15 | Mandatory | [EN] F3 shall display only the upper portion of the signal relative to its average value (bringing the lower portion upward), applying emphasis to rising edges and attenuation to falling portions, to support identification of T1 and especially T3.<br>[KO] F3은 평균값 기준 상단부만 표시하고(하단부를 위로 끌어올림), 상승 에지 강조 및 하강부 감쇠를 적용하여 T1·특히 T3 식별을 지원해야 한다. | [EN] Project Plan Draft p.24 defines F3 as showing only the upper portion relative to the average with rising-edge emphasis and falling-portion attenuation to support T1 and especially T3.<br>[KO] Project Plan Draft p.24는 F3을 평균값 기준 상단부 표시 + 상승 에지 강조·하강부 감쇠로 정의하여 T1·특히 T3 식별을 지원한다. |
| FR-12-20 | Mandatory | [EN] Each filter view shall display its filter label (F0/F1/F2/F3).<br>[KO] 각 필터 뷰는 자신의 필터 라벨(F0/F1/F2/F3)을 표시해야 한다. | [EN] Project Plan Draft p.24 requires each filter view to be clearly labeled (F0/F1/F2/F3).<br>[KO] Project Plan Draft p.24는 각 필터 뷰가 라벨(F0/F1/F2/F3)을 명확히 표시하도록 요구한다. |
| FR-12-21 | Mandatory | [EN] The system shall provide a UI to display the four filters simultaneously or switch between them for comparison.<br>[KO] 시스템은 4개 필터를 동시 표시하거나 전환 비교할 수 있는 UI를 제공해야 한다. | [EN] Project Plan Draft p.24 requires a UI for simultaneous display of, or switching between, the four filters for comparison.<br>[KO] Project Plan Draft p.24는 4개 필터의 동시 표시 또는 전환 비교를 위한 UI를 요구한다. |
| FR-12-22 | Desired | [EN] Filter views shall operate in Live/Playback/Sim modes and support pause and navigation through captured data.<br>[KO] 필터 뷰는 라이브/Playback/Sim 모드에서 동작하며, pause 및 과거 데이터 탐색을 지원해야 한다. | [EN] Project Plan Draft p.10 and p.25 require the views to operate in Live/Playback/Sim modes with pause and navigation through captured data.<br>[KO] Project Plan Draft p.10과 p.25는 뷰가 라이브/Playback/Sim 모드에서 동작하며 pause 및 과거 데이터 탐색을 지원하도록 요구한다. |

## Documentation Notes (Non-FR)

[EN] The following are not functional requirements (they describe no system behavior) but documentation obligations to be captured in the user-facing README/manual.

[KO] 아래는 기능 요구사항이 아니라(시스템 동작을 기술하지 않음) 사용자용 README/매뉴얼에 기재할 문서화 의무이다.

| Doc Item | Note | Basis |
|---|---|---|
| DOC-12-01 | [EN] The README shall note that low-amplitude signal components may become less visible in F1 mode (a side effect of moving-average smoothing).<br>[KO] README는 F1 모드에서 저진폭 신호 성분의 가시성이 저하될 수 있음(이동 평균 평활화의 부작용)을 명시해야 한다. | [EN] Project Plan Draft p.24.<br>[KO] Project Plan Draft p.24. |

## Quality Attributes

### QA-12-01 Filter Pipeline Extensibility

**Scenario**

[EN] When a fifth filter view (F4) or a change to the existing F2 algorithm is requested, the new filter is added in a plug-in fashion without modifying the existing signal acquisition or display modules.

[KO] 5번째 필터 뷰(F4) 또는 기존 F2 알고리즘 변경이 요청되면, 기존 신호 획득·표시 모듈을 수정하지 않고 새 필터를 플러그인 방식으로 추가한다.

**Quality Attribute Rationale**

[EN] Modifiability is selected because F0–F3 are essentially a filter pipeline (FR-12-10–15); Project Plan Draft p.26 (Extensibility, Modifiability) requires adding new measurement/filter/graph/display modes without major redesign and separating acquisition/processing/calculation/presentation.

[KO] F0–F3는 본질적으로 필터 파이프라인(FR-12-10–15)이므로 Modifiability를 선택한다. Project Plan Draft p.26 Extensibility, Modifiability는 새 measurement·filter·graph·display mode를 대규모 재설계 없이 추가하고 acquisition/processing/calculation/presentation을 분리하도록 요구한다.

| Field | Description |
|---|---|
| ID | QA-12-01 |
| Quality Attribute | [EN] Modifiability<br>[KO] 변경 용이성 |
| Source of Stimulus | [EN] Developer (student team)<br>[KO] 개발자(학생 팀) |
| Stimulus | [EN] A request for a fifth filter view (F4) or a change to the existing F2 algorithm.<br>[KO] 5번째 필터 뷰(F4) 또는 기존 F2 알고리즘 변경 요청. |
| Artifact | [EN] Filter pipeline abstraction (Filter interface/strategy)<br>[KO] 필터 파이프라인 추상화(Filter 인터페이스/전략) |
| Environment | [EN] Development/build time<br>[KO] 개발·빌드 타임 |
| Response | [EN] The new filter is added in plug-in fashion without changing the existing signal acquisition/display modules.<br>[KO] 기존 신호 획득/표시 모듈 변경 없이 새 필터를 플러그인 방식으로 추가한다. |
| Response Measure | [EN] 0 lines modified in the GUI/acquisition modules, ≤ 2 files changed to add a new filter, and regression tests pass.<br>[KO] GUI·acquisition 모듈 수정 0줄, 신규 필터 추가 시 변경 파일 ≤ 2개, 회귀 테스트 통과. |

### QA-12-02 Four-View Concurrent Performance

**Scenario**

[EN] When the same signal is processed concurrently through the four pipelines F0/F1/F2/F3 (dependency chain F1→F2→F3) and displayed in four views on the Pi, all views update smoothly in real time.

[KO] 동일 신호를 F0/F1/F2/F3 4개 파이프라인(F1→F2→F3 의존 체인)으로 동시 처리하여 Pi에서 4개 뷰로 표시할 때, 모든 뷰가 실시간으로 부드럽게 갱신된다.

**Quality Attribute Rationale**

[EN] Performance is selected because concurrently processing one signal through four pipelines (FR-12-01/03) is the biggest performance risk on the Pi (Project Plan Draft p.25 Real-Time Performance).

[KO] 동일 신호를 4개 파이프라인으로 동시 처리(FR-12-01/03)하는 부하가 Pi에서 가장 큰 성능 위험이므로(Project Plan Draft p.25 Real-Time Performance) Performance를 선택한다.

| Field | Description |
|---|---|
| ID | QA-12-02 |
| Quality Attribute | [EN] Performance<br>[KO] 성능 |
| Source of Stimulus | [EN] Live audio stream<br>[KO] 라이브 오디오 스트림 |
| Stimulus | [EN] The same signal is processed concurrently through the F0/F1/F2/F3 pipelines (F1→F2→F3 dependency chain).<br>[KO] 동일 신호를 F0·F1·F2·F3 4개 파이프라인으로 동시 처리 (F1→F2→F3 의존 체인). |
| Artifact | [EN] Multi-filter scope rendering<br>[KO] 다중 필터 스코프 렌더링 |
| Environment | [EN] Raspberry Pi 5, four views displayed simultaneously<br>[KO] Raspberry Pi 5, 4개 뷰 동시 표시 |
| Response | [EN] All four views update smoothly in real time.<br>[KO] 4개 뷰 모두 실시간으로 부드럽게 갱신된다. |
| Response Measure | [EN] Under the 48 kHz minimum guarantee, 4-view concurrent rendering ≥ 20 FPS, additional latency < 50 ms, and bounded memory growth via reuse of a shared input buffer.<br>[KO] 48 kHz 최소 보장 하 4-뷰 동시 ≥ 20 FPS, 추가 지연 < 50 ms, 메모리 증가 한정적(공유 입력 버퍼 재사용). |

### QA-12-03 Filter Output Consistency

**Scenario**

[EN] When the same input is passed through the four filters, all views render from the same time axis and the same input data, and T3 visibility is improved in F2/F3.

[KO] 동일 입력을 4개 필터에 통과시키면, 모든 뷰가 동일한 시간축·동일 입력 데이터를 기반으로 렌더링되고 F2/F3에서 T3 가시성이 향상된다.

**Quality Attribute Rationale**

[EN] Accurateness is selected because Project Plan Draft p.24 requires processing the same watch signal through four filters for comparison, and p.25 Correctness requires the same underlying data and timing assumptions (FR-12-04).

[KO] Project Plan Draft p.24가 동일 watch 신호를 4개 필터로 처리해 비교하도록 요구하고, p.25 Correctness가 동일 underlying data·timing 가정을 요구하므로(FR-12-04) Accurateness를 선택한다.

| Field | Description |
|---|---|
| ID | QA-12-03 |
| Quality Attribute | [EN] Accurateness<br>[KO] 정확성 |
| Source of Stimulus | [EN] Reference verification signal (known T1/T2/T3 positions)<br>[KO] 검증용 기준 신호 (T1·T2·T3 위치 기지) |
| Stimulus | [EN] The same input is passed through the four filters.<br>[KO] 동일 입력을 4개 필터에 통과. |
| Artifact | [EN] F0 mirroring, F1 moving-average, F2 rising-slope emphasis, F3 upper-portion emphasis<br>[KO] F0 미러링, F1 moving-average, F2 rising-slope emphasis, F3 upper-portion emphasis |
| Environment | [EN] Test environment<br>[KO] 테스트 환경 |
| Response | [EN] All views render from the same time axis and the same input data, and T3 visibility is improved in F2/F3.<br>[KO] 모든 뷰가 동일한 시간축·동일 입력 데이터를 기반으로 렌더링되고, F2/F3에서 T3 가시성이 향상된다. |
| Response Measure | [EN] 0-sample time-axis alignment error across the four views; in F2, the T3 peak-to-background ratio ≥ 2× that of F0; use of the same-timestamp data is verified.<br>[KO] 4개 뷰의 시간축 정렬 오차 0 sample, F2에서 T3 피크 대비 배경비 ≥ F0의 2배, 동일 timestamp 데이터 사용 검증. |

### QA-12-04 Filter Switching Usability

**Scenario**

[EN] When the user switches among F0↔F1↔F2↔F3 or requests a comparison, the same signal is immediately re-displayed with the selected filter so changes in waveform and event visibility can be compared, without resetting the measurement session.

[KO] 사용자가 F0↔F1↔F2↔F3 전환 또는 비교를 요청하면, 측정 세션을 리셋하지 않고 동일 신호가 선택된 필터로 즉시 재표시되어 파형·이벤트 가시성 변화를 비교할 수 있다.

**Quality Attribute Rationale**

[EN] Usability is selected because Project Plan Draft p.24 specifies easy switching and comparison among the four filters (FR-12-02/21), combined with Usability (p.5–6).

[KO] Project Plan Draft p.24가 4개 필터 간 쉬운 전환과 비교를 명시하고(FR-12-02/21) p.5–6 Usability와 결합되므로 Usability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-12-04 |
| Quality Attribute | [EN] Usability<br>[KO] 사용성 |
| Source of Stimulus | [EN] User (watchmaker)<br>[KO] 사용자(워치메이커) |
| Stimulus | [EN] A request to switch among or compare F0↔F1↔F2↔F3.<br>[KO] F0↔F1↔F2↔F3 전환 또는 비교 요청. |
| Artifact | [EN] Filter selection/comparison UI<br>[KO] 필터 선택/비교 UI |
| Environment | [EN] Live or paused state<br>[KO] 라이브 또는 pause 상태 |
| Response | [EN] The same signal is immediately re-displayed with the selected filter, allowing comparison of waveform/event visibility changes.<br>[KO] 동일 신호가 선택된 필터로 즉시 재표시되어 파형/이벤트 가시성 변화를 비교 가능하다. |
| Response Measure | [EN] Switch response time ≤ 100 ms, the measurement session is maintained on switch (0 resets), and a 4-view comparison mode is provided.<br>[KO] 전환 응답 시간 ≤ 100 ms, 전환 시 측정 세션 유지(리셋 0), 4-뷰 비교 모드 제공. |

### QA-12-05 Readability in Noisy Environments

**Scenario**

[EN] When a watch signal mixed with background noise is input, the F1 moving-average and F2 slope-emphasis filters reduce the background noise while preserving the features (T1/T3) needed for beat detection.

[KO] 배경 소음이 섞인 watch 신호가 입력되면, F1 moving-average와 F2 slope emphasis 필터가 배경 노이즈를 줄이면서 비트 검출에 필요한 특징(T1/T3)은 보존한다.

**Quality Attribute Rationale**

[EN] Robustness is selected because Project Plan Draft p.25 Correctness requires the system to remain usable with features preserved through filtering even under ambient acoustic noise; F1/F2 (FR-12-11/13) are the noise-reduction means.

[KO] Project Plan Draft p.25 Correctness가 주변 음향 소음 하에서도 필터링으로 특징을 보존하며 사용 가능해야 함을 요구하고, F1/F2(FR-12-11/13)가 노이즈 저감 수단이므로 Robustness를 선택한다.

| Field | Description |
|---|---|
| ID | QA-12-05 |
| Quality Attribute | [EN] Robustness<br>[KO] 강건성 |
| Source of Stimulus | [EN] Surrounding environment (e.g., human speech and other disturbances)<br>[KO] 주변 환경 (사람 말소리 등 외란) |
| Stimulus | [EN] A watch signal with background noise is input.<br>[KO] 배경 소음이 섞인 watch 신호 입력. |
| Artifact | [EN] F1 moving-average / F2 slope-emphasis filters<br>[KO] F1 moving-average / F2 slope emphasis 필터 |
| Environment | [EN] Non-ideal measurement environment, live<br>[KO] 비이상적 측정 환경, 라이브 |
| Response | [EN] Filtering reduces background noise while preserving the features (T1/T3) needed for beat detection.<br>[KO] 필터링으로 배경 노이즈를 줄이면서 비트 검출에 필요한 특징(T1/T3)은 보존한다. |
| Response Measure | [EN] ≥ 50% background-noise reduction after F1, ≤ 10% loss of T1/T3 peak amplitude, and beat-detection success rate maintained.<br>[KO] F1 적용 후 배경 노이즈 ≥ 50% 감소, T1/T3 피크 진폭 손실 ≤ 10%, 비트 검출 성공률 유지. |

## Traceability Summary

| Requirement | Related QA | Notes |
|---|---|---|
| FR-12-01 to FR-12-04 | QA-12-02, QA-12-03 | Four concurrent views from one input and one time axis drive performance and output consistency. |
| FR-12-10 to FR-12-15 | QA-12-01, QA-12-03, QA-12-05 | The F0–F3 filter pipeline drives extensibility, output consistency, and noise robustness. |
| FR-12-20 to FR-12-22 | QA-12-04 | Filter labels, the comparison UI, and Live/Playback/Sim navigation support fast-switching usability. |
