# FR-05 Beat-Noise Scope Display

## Functional Requirements

| ID | Priority | Functional Requirement | Requirement Basis |
|---|---|---|---|
| FR-05-01 | Mandatory | [EN] The system shall add a Beat-Noise Scope tab to the Tabbed Graph Panel that can be displayed without restarting the program.<br>[KO] 시스템은 Tabbed Graph Panel에 Beat-Noise Scope 탭을 추가하여 기존 프로그램을 재시작하지 않고 표시할 수 있어야 한다. | [EN] Project Plan Draft p.17 defines the Beat-Noise Scope Display, and p.10 requires all graphs to operate within the existing Tabbed Graph Panel without a program restart.<br>[KO] Project Plan Draft p.17은 Beat-Noise Scope Display를 정의하고, p.10은 모든 그래프가 프로그램 재시작 없이 기존 Tabbed Graph Panel 안에서 동작해야 함을 요구한다. |
| FR-05-02 | Mandatory | [EN] The system shall provide two related views, Scope 1 and Scope 2.<br>[KO] 시스템은 Scope 1과 Scope 2 두 개의 연관된 뷰를 제공해야 한다. | [EN] Project Plan Draft p.17 specifies the Beat-Noise Scope as two related views, Scope 1 and Scope 2.<br>[KO] Project Plan Draft p.17은 Beat-Noise Scope를 Scope 1과 Scope 2 두 개의 연관된 뷰로 규정한다. |
| FR-05-03 | Mandatory | [EN] The system shall operate in Live/Playback/Sim modes and support pause and forward/backward navigation through captured data without data loss.<br>[KO] 시스템은 라이브/Playback/Sim 모드 모두에서 동작하며 데이터 손실 없이 pause 및 과거 데이터 앞뒤 탐색을 지원해야 한다. | [EN] Project Plan Draft p.10 (Expected Enhancements) requires live pause, forward/backward cursor navigation, and retention of recorded data without loss.<br>[KO] Project Plan Draft p.10 Expected Enhancements는 라이브 pause, 앞뒤 커서 이동, 기록 데이터 보존(손실 없음)을 요구한다. |
| FR-05-10 | Mandatory | [EN] Scope 1 shall graphically display the watch's alternating tick/tock beat noises as a waveform.<br>[KO] Scope 1은 시계의 교번하는 tick/tock 비트 노이즈를 파형으로 그래프 표시해야 한다. | [EN] Project Plan Draft p.17: Scope 1 displays the watch's alternating tick/tock beat noises as a waveform.<br>[KO] Project Plan Draft p.17의 Scope 1은 시계의 교번하는 tick/tock 비트 노이즈를 파형으로 표시한다. |
| FR-05-11 | Mandatory | [EN] Scope 1 shall allow the time range to be selected from 20 ms / 200 ms / 400 ms.<br>[KO] Scope 1은 시간 범위를 20 ms / 200 ms / 400 ms 중 선택할 수 있어야 한다. | [EN] Project Plan Draft p.17 defines the selectable Scope 1 time ranges of 20 ms, 200 ms, and 400 ms.<br>[KO] Project Plan Draft p.17은 Scope 1의 선택 가능한 시간 범위로 20 ms, 200 ms, 400 ms를 정의한다. |
| FR-05-12 | Mandatory | [EN] After sufficient measurement time, the system shall display the most recent beat noises as small strips beneath the current waveform.<br>[KO] 충분한 측정 시간 경과 후, 시스템은 최근 비트 노이즈들을 현재 파형 아래에 작은 스트립(strip) 형태로 누적 표시해야 한다. | [EN] Project Plan Draft p.17 describes accumulating recent beat noises as small strips beneath the current Scope 1 waveform.<br>[KO] Project Plan Draft p.17은 최근 비트 노이즈를 현재 Scope 1 파형 아래에 작은 스트립으로 누적하는 동작을 기술한다. |
| FR-05-13 | Desired | [EN] The user shall be able to select one of the accumulated prior beat strips for enlarged viewing.<br>[KO] 사용자는 누적된 이전 비트 스트립 중 하나를 선택하여 확대 보기를 할 수 있어야 한다. | [EN] Project Plan Draft p.17 supports selecting an accumulated prior beat strip for enlarged viewing, and p.10 supports review of recorded data.<br>[KO] Project Plan Draft p.17은 누적된 이전 비트 스트립을 선택해 확대 보기하는 기능을 지원하며, p.10은 기록 데이터 검토를 지원한다. |
| FR-05-14 | Desired | [EN] The system shall provide an option to display the signal as its absolute value (\|x\|) to improve readability.<br>[KO] 시스템은 가독성 향상을 위해 신호를 절대값(\|x\|)으로 표시하는 옵션을 제공해야 한다. | [EN] Project Plan Draft p.17 offers an absolute-value (\|x\|) display option for the beat-noise signal to improve readability.<br>[KO] Project Plan Draft p.17은 가독성 향상을 위해 비트 노이즈 신호의 절대값(\|x\|) 표시 옵션을 제시한다. |
| FR-05-15 | Mandatory | [EN] Scope 1 shall identify the relevant A and C beats and display a visual marker for the C beat in particular.<br>[KO] Scope 1은 관련 A·C 비트를 식별하고, 특히 C 비트에 시각적 마커를 표시해야 한다. | [EN] Project Plan Draft p.17 requires Scope 1 to identify the A and C beats and visually mark the C beat.<br>[KO] Project Plan Draft p.17은 Scope 1이 A·C 비트를 식별하고 C 비트를 시각적으로 표시하도록 요구한다. |
| FR-05-16 | Mandatory | [EN] Scope 1 shall display the lift angle associated with the displayed beat pattern.<br>[KO] Scope 1은 표시 중인 비트 패턴에 해당하는 lift angle 값을 함께 표시해야 한다. | [EN] Project Plan Draft p.17 requires Scope 1 to display the lift angle for the shown beat pattern, and TimeGrapher Equations v1 provides the measurement basis.<br>[KO] Project Plan Draft p.17은 Scope 1이 표시 비트 패턴의 lift angle을 표시하도록 요구하며, TimeGrapher Equations v1은 그 계산 근거를 제공한다. |
| FR-05-20 | Mandatory | [EN] Scope 2 shall display tic and tac beat noises on two horizontal axes.<br>[KO] Scope 2는 tic·tac 비트 노이즈를 2개의 수평 축에 표시해야 한다. | [EN] Project Plan Draft p.17: Scope 2 displays tic and tac beat noises on two horizontal axes.<br>[KO] Project Plan Draft p.17의 Scope 2는 tic·tac 비트 노이즈를 2개의 수평 축에 표시한다. |
| FR-05-21 | Mandatory | [EN] Scope 2 shall use a fixed 20 ms time range.<br>[KO] Scope 2는 20 ms 고정 시간 범위를 사용해야 한다. | [EN] Project Plan Draft p.17 fixes the Scope 2 time range at 20 ms.<br>[KO] Project Plan Draft p.17은 Scope 2 시간 범위를 20 ms로 고정한다. |
| FR-05-22 | Mandatory | [EN] The system shall toggle averaging ON/OFF via a Σ control.<br>[KO] 시스템은 Σ(averaging) 컨트롤로 평균화 ON/OFF를 토글할 수 있어야 한다. | [EN] Project Plan Draft p.17 provides a Σ control to toggle Scope 2 averaging ON/OFF.<br>[KO] Project Plan Draft p.17은 Scope 2 평균화 ON/OFF를 토글하는 Σ 컨트롤을 제공한다. |
| FR-05-23 | Mandatory | [EN] When averaging is ON, the system shall combine multiple beat noises to reduce random noise and improve signal clarity.<br>[KO] 평균화 ON일 때, 시스템은 여러 비트 노이즈를 합산하여 랜덤 노이즈를 줄이고 신호 선명도를 향상시켜야 한다. | [EN] Project Plan Draft p.17 requires averaging to combine multiple beat noises to reduce random noise and improve clarity.<br>[KO] Project Plan Draft p.17은 평균화가 여러 비트 노이즈를 합산하여 랜덤 노이즈를 줄이고 선명도를 높이도록 요구한다. |
| FR-05-24 | Mandatory | [EN] The measurement cycle shall be determined by the watch's beat number and selected interval, and shall complete after 50 tic + 50 tac intervals.<br>[KO] 측정 사이클은 watch beat number와 선택된 간격에 따라 결정되며, tic 50회 + tac 50회 후 완료되어야 한다. | [EN] Project Plan Draft p.17 specifies a Scope 2 measurement cycle of 50 tic + 50 tac intervals determined by beat number and interval.<br>[KO] Project Plan Draft p.17은 beat number와 간격으로 결정되는 tic 50회 + tac 50회 Scope 2 측정 사이클을 규정한다. |
| FR-05-25 | Mandatory | [EN] At the end of the cycle, the system shall display the average amplitude on each horizontal axis using arrows.<br>[KO] 사이클 종료 시, 시스템은 각 수평 축의 평균 진폭을 화살표로 표시해야 한다. | [EN] Project Plan Draft p.17 requires the average amplitude on each axis to be shown with arrows at cycle end, and TimeGrapher Equations v1 defines the amplitude basis.<br>[KO] Project Plan Draft p.17은 사이클 종료 시 각 축의 평균 진폭을 화살표로 표시하도록 요구하며, TimeGrapher Equations v1은 진폭 계산 근거를 제공한다. |
| FR-05-26 | Mandatory | [EN] The system shall present the two averaged beat-noise traces without assuming a fixed tic/tac axis assignment.<br>[KO] 시스템은 어느 축이 tic/tac인지 고정 가정하지 않고 "두 개의 평균 비트 노이즈 트레이스"로 제시해야 한다. | [EN] Project Plan Draft p.17 requires the two averaged traces to be presented without a fixed tic/tac axis assignment.<br>[KO] Project Plan Draft p.17은 두 평균 트레이스를 tic/tac 축 고정 가정 없이 제시하도록 요구한다. |
| FR-05-27 | Optional | [EN] The system shall be able to display intermediate averaging results, such as after 10 or 20 intervals.<br>[KO] 시스템은 10회·20회 간격 등의 중간 평균화 결과를 표시할 수 있어야 한다. | [EN] Project Plan Draft p.17 allows intermediate averaging results (e.g., after 10 or 20 intervals) to be displayed before the cycle completes.<br>[KO] Project Plan Draft p.17은 사이클 완료 전 중간 평균화 결과(예: 10회·20회 후) 표시를 허용한다. |

## Quality Attributes

### QA-05-01 Real-Time Throughput

**Scenario**

[EN] While a watch running at 28,800 bph produces about 8 beats per second and audio is captured continuously at 96 kHz, the Beat-Noise Scope rendering pipeline aligns and displays each waveform window and updates the Scope 2 accumulator without dropping audio blocks or frames.

[KO] 28,800 bph 시계가 초당 약 8비트를 생성하고 오디오가 96 kHz로 연속 캡처되는 동안, Beat-Noise Scope 렌더링 파이프라인은 오디오 블록이나 프레임을 드롭하지 않고 각 파형 윈도우를 정렬·표시하며 Scope 2 누적기를 갱신한다.

**Quality Attribute Rationale**

[EN] Performance is selected because the scope performs windowing and Scope 2 accumulation on every beat, so sustained high-sample-rate throughput is the key risk (Project Plan Draft p.25 Real-Time Performance: 96 kHz target / 48 kHz minimum / 192 kHz stretch, and avoiding memory exhaustion and overload on the Pi).

[KO] Beat-Noise Scope는 매 비트마다 윈도잉·Scope 2 누적 처리를 수행하므로 고샘플레이트 지속 처리량이 핵심 위험이며(Project Plan Draft p.25 Real-Time Performance: 96 kHz 목표 / 48 kHz 최소 / 192 kHz stretch, Pi에서 메모리 고갈·과부하 회피), 이에 따라 Performance를 선택한다.

| Field | Description |
|---|---|
| ID | QA-05-01 |
| Quality Attribute | [EN] Performance<br>[KO] 성능 |
| Source of Stimulus | [EN] Live audio stream from the microphone<br>[KO] 마이크에서 들어오는 라이브 오디오 스트림 |
| Stimulus | [EN] Watch beat noise arrives continuously at a 96 kHz sample rate (about 8 beats per second at 28,800 bph).<br>[KO] 96 kHz 샘플레이트로 watch beat noise가 연속 도착 (28,800 bph 기준 초당 8비트). |
| Artifact | [EN] Beat-Noise Scope rendering pipeline (windowing + Scope 1 accumulation + Scope 2 averaging)<br>[KO] Beat-Noise Scope 렌더링 파이프라인 (윈도잉 + Scope 1 누적 + Scope 2 평균화) |
| Environment | [EN] Raspberry Pi 5 (8GB), normal operation, with other tabs also active<br>[KO] Raspberry Pi 5(8GB), 정상 운영, 동시에 다른 탭도 활성 |
| Response | [EN] The system aligns and displays the waveform window for each beat and updates the Scope 2 50-cycle accumulator without dropping frames.<br>[KO] 시스템은 매 비트마다 파형 윈도우를 정렬·표시하고 Scope 2 50-cycle accumulator를 갱신하면서 프레임을 드롭하지 않는다. |
| Response Measure | [EN] At sustained 96 kHz, dropped audio blocks = 0, screen refresh ≥ 30 FPS, and CPU usage < 70%.<br>[KO] 지속 96 kHz에서 dropped audio block = 0, 화면 갱신 ≥ 30 FPS, CPU 사용률 < 70%. |

### QA-05-02 Capture-to-Display Latency

**Scenario**

[EN] When a new tick/tock beat occurs, the corresponding waveform, C marker, and lift angle appear on screen with low end-to-end latency.

[KO] 새로운 tick/tock 비트가 발생하면, 해당 비트의 파형과 C 마커, lift angle이 낮은 end-to-end 지연으로 화면에 나타난다.

**Quality Attribute Rationale**

[EN] Performance is selected because the scope is a live diagnostic display that must show the C marker and lift angle in real time (FR-05-15/16), so Project Plan Draft p.25 (Low Latency and Low Number of Missed Beats) requires the capture→process→display latency to be measured and minimized.

[KO] Scope는 C 마커·lift angle을 실시간으로 표시해야 하는 라이브 진단 디스플레이이므로(FR-05-15/16), Project Plan Draft p.25 "Low Latency and Low Number of Missed Beats"가 capture→process→display 지연을 측정·최소화하도록 요구한다. 이에 따라 Performance를 선택한다.

| Field | Description |
|---|---|
| ID | QA-05-02 |
| Quality Attribute | [EN] Performance<br>[KO] 성능 |
| Source of Stimulus | [EN] Acoustic events (A/C) of the watch escapement<br>[KO] 시계 escapement의 음향 이벤트(A/C) |
| Stimulus | [EN] A new tick/tock beat occurs.<br>[KO] 새로운 tick/tock 비트 발생. |
| Artifact | [EN] Capture → beat detection → Scope widget display path<br>[KO] 캡처 → 비트 검출 → Scope 위젯 표시 경로 |
| Environment | [EN] Live mode, Raspberry Pi<br>[KO] 라이브 모드, Raspberry Pi |
| Response | [EN] The waveform, C marker, and lift angle for that beat appear on screen.<br>[KO] 해당 비트의 파형과 C 마커, lift angle이 화면에 나타난다. |
| Response Measure | [EN] Capture-to-display end-to-end latency averages ≤ 100 ms, with a worst-case ≤ 200 ms.<br>[KO] capture-to-display end-to-end latency 평균 ≤ 100 ms, worst-case ≤ 200 ms. |

### QA-05-03 Measurement Accuracy

**Scenario**

[EN] In Sim mode with a synthetic signal of known amplitude (e.g., 300°), the C-marker position and lift angle shown by Scope 1 match the input values and agree with the Summary Bar.

[KO] Sim 모드에서 알려진 amplitude(예: 300°)를 가진 합성 신호에 대해, Scope 1이 표시하는 C 마커 위치와 lift angle이 입력값과 일치하고 Summary Bar 값과도 일치한다.

**Quality Attribute Rationale**

[EN] Accurateness is selected because displayed values must match the actual events and remain internally consistent across the GUI (Project Plan Draft p.25 Correctness, p.26 Measurement Accuracy); Sim mode (p.8) provides a ground-truth verification means.

[KO] 표시값이 실제 이벤트와 일치하고 GUI 전반에 내부 정합성을 유지해야 하므로(Project Plan Draft p.25 Correctness, p.26 Measurement Accuracy) Accurateness를 선택하며, Sim 모드(p.8)가 기지값(ground truth) 검증 수단을 제공한다.

| Field | Description |
|---|---|
| ID | QA-05-03 |
| Quality Attribute | [EN] Accurateness<br>[KO] 정확성 |
| Source of Stimulus | [EN] Synthetic signal in Sim mode (known amplitude and beat error)<br>[KO] Sim 모드의 합성 신호 (amplitude·beat error 기지값) |
| Stimulus | [EN] A signal with a known amplitude (e.g., 300°) is input.<br>[KO] 알려진 amplitude(예: 300°)를 가진 신호 입력. |
| Artifact | [EN] A/C event detection and Scope 1 lift angle/marker calculation<br>[KO] A/C 이벤트 검출 및 Scope 1의 lift angle/마커 계산 |
| Environment | [EN] Verification (test) environment<br>[KO] 검증(테스트) 환경 |
| Response | [EN] The C-marker position and lift angle displayed by Scope 1 match the input values.<br>[KO] Scope 1이 표시하는 C 마커 위치와 lift angle이 입력값과 일치한다. |
| Response Measure | [EN] Displayed amplitude error ≤ ±5°, C-marker timing error ≤ 1 sample, and 100% agreement with the summary bar values.<br>[KO] 표시 amplitude 오차 ≤ ±5°, C-마커 타이밍 오차 ≤ 1 sample, summary bar 값과 100% 일치. |

### QA-05-04 Past-Beat Review Usability

**Scenario**

[EN] While paused during live measurement, the user selects one of the accumulated prior beat strips for enlarged viewing, and the recorded live data is preserved without loss.

[KO] 라이브 측정 중 pause 상태에서 사용자는 누적된 이전 비트 스트립 중 하나를 선택해 확대 보기하며, 라이브 녹화 데이터는 손실 없이 보존된다.

**Quality Attribute Rationale**

[EN] Usability is selected because the user must be able to review past beats easily; Project Plan Draft p.10 (Expected Enhancements) requires live pause, forward/backward navigation, and retention of recorded data, and FR-05-12/13 specify accumulation and enlargement of prior beat strips, combined with Usability (p.5–6).

[KO] 사용자가 과거 비트를 쉽게 검토할 수 있어야 하므로 Usability를 선택한다. Project Plan Draft p.10 Expected Enhancements는 라이브 pause·앞뒤 탐색·기록 데이터 보존을 요구하고, FR-05-12/13은 이전 비트 스트립의 누적·확대를 규정하며, p.5–6 Usability와 결합된다.

| Field | Description |
|---|---|
| ID | QA-05-04 |
| Quality Attribute | [EN] Usability<br>[KO] 사용성 |
| Source of Stimulus | [EN] Watchmaker (user)<br>[KO] 워치메이커(사용자) |
| Stimulus | [EN] A request to select one accumulated prior beat strip for enlarged viewing.<br>[KO] 누적된 이전 비트 스트립 중 하나를 선택해 확대 보기 요청. |
| Artifact | [EN] Scope 1 beat strips with the pause/review function<br>[KO] Scope 1 비트 스트립 + pause/리뷰 기능 |
| Environment | [EN] Paused during live measurement<br>[KO] 라이브 측정 중 pause 상태 |
| Response | [EN] The selected past beat is enlarged, and the live recorded data is preserved without loss.<br>[KO] 선택한 과거 비트가 확대 표시되고, 라이브 녹화 데이터는 손실 없이 보존된다. |
| Response Measure | [EN] ≤ 200 ms from selection to display, 0 measurement-session resets, and 0 recorded-data loss.<br>[KO] 선택 후 표시까지 ≤ 200 ms, 측정 세션 리셋 0회, 기록 데이터 손실 0. |

### QA-05-05 Averaging Accuracy (Scope 2)

**Scenario**

[EN] With averaging (Σ) ON over a noisy beat signal, after 50 cycles the average amplitude of the two traces is shown with arrows without assuming a fixed tic/tac axis, improving the signal-to-noise ratio.

[KO] 노이즈가 섞인 비트 신호에 대해 averaging(Σ)을 켠 상태에서, 50 사이클 완료 후 두 트레이스의 평균 진폭을 tic/tac 축 고정 가정 없이 화살표로 표시하며 SNR이 개선된다.

**Quality Attribute Rationale**

[EN] Accurateness is selected because Project Plan Draft p.17 requires 50 tic / 50 tac averaging to reduce random noise (FR-05-24), and this is combined with Correctness (p.25, summary-bar consistency) and operation in ambient-noise environments.

[KO] Project Plan Draft p.17의 Scope 2 사양이 50 tic / 50 tac 평균화로 랜덤 노이즈 감소를 요구하고(FR-05-24), Correctness(p.25, summary bar 정합성)와 주변 소음 환경 운용 요구가 결합되므로 Accurateness를 선택한다.

| Field | Description |
|---|---|
| ID | QA-05-05 |
| Quality Attribute | [EN] Accurateness<br>[KO] 정확성 |
| Source of Stimulus | [EN] User who turned on the Σ (averaging) control<br>[KO] Σ(averaging) 컨트롤을 켠 사용자 |
| Stimulus | [EN] Averaging is activated on a noisy beat signal.<br>[KO] 노이즈가 섞인 비트 신호에 대해 averaging 활성화. |
| Artifact | [EN] Scope 2 50 tic / 50 tac averaging buffer<br>[KO] Scope 2 50 tic / 50 tac 평균화 버퍼 |
| Environment | [EN] Live, with ambient noise present<br>[KO] 라이브, 주변 소음 존재 |
| Response | [EN] After 50 cycles, the average amplitude of the two traces is displayed with arrows without a fixed tic/tac axis assumption.<br>[KO] 50 사이클 완료 후 두 트레이스의 평균 진폭을 tic/tac 축 고정 가정 없이 화살표로 표시한다. |
| Response Measure | [EN] SNR improvement ≥ 6 dB after averaging, exactly 50/50 count per cycle, and intermediate (10/20 interval) results can be displayed.<br>[KO] averaging 후 SNR 개선 ≥ 6 dB, 사이클당 정확히 50/50 카운트, 중간(10·20회) 결과 표시 가능. |

## Traceability Summary

| Requirement | Related QA | Notes |
|---|---|---|
| FR-05-01 to FR-05-03 | QA-05-01, QA-05-04 | Tab integration and Live/Playback/Sim navigation underpin real-time throughput and past-beat review without data loss. |
| FR-05-10 to FR-05-16 | QA-05-01, QA-05-02, QA-05-03, QA-05-04 | Scope 1 waveform, C marker, and lift angle drive throughput, latency, accuracy, and review usability. |
| FR-05-20 to FR-05-27 | QA-05-01, QA-05-05 | Scope 2 two-trace averaging requires sustained throughput and accurate 50/50 averaging. |
