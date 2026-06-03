# Milestone1 Jae-hong Oh

> English version above, Korean version below. (위쪽은 영어 버전, 아래쪽은 한국어 버전입니다.)

## Functional Requirements

### G09 · Time-Frequency Spectrogram Display

| ID | Grade | Requirement |
|----|-------|-------------|
| FR-G09-01 | mandatory | The Time-Frequency Spectrogram Display shall provide the user with a time-frequency spectrogram that shows how the watch's acoustic energy is distributed across time and frequency. |
| FR-G09-02 | mandatory | The Time-Frequency Spectrogram Display shall present the spectrogram to the user with time on the horizontal axis, frequency on the vertical axis, and signal strength as color intensity. |
| FR-G09-03 | optional | The Time-Frequency Spectrogram Display should provide the user with the ability to inspect either the most recent beat or a selected recent time window. |
| FR-G09-04 | optional | The Time-Frequency Spectrogram Display should provide the user with the ability to view recurring energy structures at characteristic frequency ranges. |
| FR-G09-05 | optional | The Time-Frequency Spectrogram Display should provide the user with the ability to compare one beat with the next. |
| FR-G09-06 | optional | The Time-Frequency Spectrogram Display should provide the user with a color scale or legend for interpreting relative signal strength. |

### G11 · Scope Mode with Synchronized Sweep Display

| ID | Grade | Requirement |
|----|-------|-------------|
| FR-G11-01 | mandatory | The Scope Mode with Synchronized Sweep Display shall provide the user with a display of the watch's acoustic signal in a fixed sweep window, similar to an oscilloscope. |
| FR-G11-02 | optional | The Scope Mode with Synchronized Sweep Display should provide the user with a display of the processed signal that combines the upper and lower halves of the waveform. |
| FR-G11-03 | optional | The Scope Mode with Synchronized Sweep Display should provide the user with the ability to configure the sweep time as a multiple of the watch's tick interval. |
| FR-G11-04 | optional | The Scope Mode with Synchronized Sweep Display should provide the user with a synchronized display in which the beat pattern stays visually stable near the nominal rate and drifts when the watch is fast or slow. |
| FR-G11-05 | optional | The Scope Mode with Synchronized Sweep Display may provide the user with reference values (daily rate, amplitude, beat error, nominal beat rate) from the most recent timing test. |

## Quality Attribute Scenarios

### QAS-1 · Performance (Latency) — From Sound Input to Screen Display
> While measuring as usual, when sound arrives at the microphone, the system processes it through the input → analysis → display flow and shows it on screen, guaranteeing p99 (99th-percentile) end-to-end latency (from sound arrival to on-screen display) under 500 ms, with 0 dropped audio blocks and 0 missed beats over a 10-min continuous run.

| Element | Content |
|---------|---------|
| Source | The microphone / watch (external) |
| Stimulus | Sound arrives at the microphone |
| Artifact | The full input → analysis → display flow |
| Environment | Measuring as usual |
| Response | Process and show on screen |
| Response Measure | p99 end-to-end latency (sound arrival → on-screen) ≤ 500 ms; 0 dropped audio blocks and 0 missed beats over a 10-min continuous run |

### QAS-2 · Performance (Throughput) — Analysis Processing Budget
> While measuring as usual, when an audio block arrives for analysis, the system completes the analysis processing (input → analysis stage, excluding audio buffering and display) within a bounded compute budget, guaranteeing p99 computation time under 100 ms, with 0 dropped audio blocks and 0 missed beats over a 10-min continuous run.

| Element | Content |
|---------|---------|
| Source | The analysis/computation stage (internal) |
| Stimulus | An audio block arrives for analysis |
| Artifact | The input → analysis processing stage |
| Environment | Measuring as usual |
| Response | Complete the analysis processing within the compute budget |
| Response Measure | p99 computation time (analysis processing only, excluding audio buffering and display) ≤ 100 ms; 0 dropped audio blocks and 0 missed beats over a 10-min continuous run |

### QAS-3 · Dependability (Reliability) — No Degradation Over Long Runs
> While measuring continuously without stopping on the Raspberry Pi (8 GB RAM), the system continues to deliver correct service without degrading over time — no memory leak, no crash, and no UI freeze — over 10 minutes of continuous operation (keeping up with the input rate is assumed, per QAS-2). [JYP] "long-running / over time" needs a concrete bound — define the duration explicitly (rec. 2) and raise the 10-min measure to match that intent (rec. 1).

| Element | Content |
|---------|---------|
| Source | The system |
| Stimulus | Measuring continuously without stopping for a long time |
| Artifact | The whole system, Raspberry Pi memory/process health |
| Environment | Long-running operation on the Raspberry Pi (8 GB RAM) [JYP] Define "long-running" concretely (e.g., ≥ 2 h continuous, ideally ≥ 6 h per the Long-Term Performance Graph) — the bare term is ambiguous and not testable on its own. |
| Response | Continue correct service without degrading: no resource exhaustion, no crash, no freeze |
| Response Measure | Over a 10-min continuous run: RSS growth ≤ 20 MB in any 5-min window with no monotonic upward trend; 0 crashes; 0 screen freezes, where a freeze = no screen update for ≥ 2 s [JYP] 10 min is too short to substantiate "no degradation over long runs" — raise the verification window to the representative long-term duration defined in Environment (e.g., ≥ 2 h) and require no monotonic RSS upward trend over any 30-min window. |

### QAS-4 · Dependability (Reliability) — Consistent Values Across Displays
> While measuring as usual, when a single measurement result is produced and fanned out to multiple graphs and numbers, the system renders every display in a given on-screen frame from the same underlying measurement snapshot (each tagged with a snapshot ID) so they do not disagree, with 0 value mismatches across displays — a mismatch being any two displays in the same frame whose values trace to different snapshot IDs. [SJ] For sequence features, the X/D summary uses the same captured result set as the per-position display.

| Element | Content |
|---------|---------|
| Source | The analysis/computation stage (internal) |
| Stimulus | A single measurement result is produced and fanned out to multiple displays (graphs/numbers) |
| Artifact | Numeric readouts and multiple graph displays |
| Environment | Measuring as usual |
| Response | Render all displays in a frame from the same measurement snapshot (tagged with a snapshot ID) so they do not disagree; [SJ] derive X/D sequence summaries from the displayed per-position result set |
| Response Measure | 0 value mismatches across displays in the same on-screen frame, where a mismatch = two displays whose values trace to different snapshot IDs; [SJ] X/D source mismatch between sequence summary and displayed per-position values = 0 cases |

### QAS-5 · Dependability (Reliability) — Under Noisy or Weak Signals
> In a poor environment where ambient noise mixes in or a weak signal arrives, the system (noise removal / beat detection) filters out noise while preserving the needed sounds, and when the signal is bad it shows a "signal weak" indication instead of a wrong value, meeting beat detection rate ≥ 95% and rate error ≤ ±3 s/d under noise conditions of SNR ≥ 14 dB (using a reference instrument's reading as ground truth, over a sample of at least 1,000 beats), while signals weaker than that show only "signal weak" and output 0 wrong values. [SJ] Invalid or low-confidence position results are excluded from X/D sequence calculations.

| Element | Content |
|---------|---------|
| Source | Ambient noise / weak signal (external) |
| Stimulus | Noise mixes in or the signal arrives weak |
| Artifact | The noise-removal / beat-detection part |
| Environment | Poor environment |
| Response | Filter out noise while preserving needed sounds; when the signal is bad, show "signal weak" instead of a wrong value; [SJ] exclude invalid or low-confidence position results from X/D calculations |
| Response Measure | Using a reference instrument's reading as ground truth, over a sample of ≥ 1,000 beats: beat detection rate ≥ 95% and rate error ≤ ±3 s/d under SNR ≥ 14 dB; weaker signals show only "signal weak" and output 0 wrong values; [SJ] invalid/low-confidence values included in X/D calculations = 0 cases |

### QAS-6 · Dependability (Reliability) — Pinpointing Beats Precisely
> While measuring as usual, when a new beat (tick/tock) arrives in the input stream, the system (beat detection / time calculation) determines its onset and peak positions accurately and maintains timing precision throughout the measurement, locating onset/peak within ≤ 0.1 ms (≈10 samples at 96,000 SPS) so beat error is resolved down to 0.1 ms; this is verified against synthetic input signals with known onset/peak positions (per QAS-10), since 0.1 ms ground truth cannot be obtained from real hardware.

| Element | Content |
|---------|---------|
| Source | Watch beat (external input stream) |
| Stimulus | A new beat (tick/tock) arrives in the input stream |
| Artifact | The beat-detection / time-calculation part |
| Environment | Measuring as usual |
| Response | Determine the arriving beat's onset and peak positions accurately and maintain timing precision throughout |
| Response Measure | Onset/peak detection position error ≤ 0.1 ms (≈10 samples at 96,000 SPS), verified against synthetic signals with known onset/peak positions (per QAS-10, no real hardware); beat error resolvable to 0.1 ms |

### QAS-7 · Modifiability (Extensibility) — Adding a New Graph
> In a tight-schedule development situation, when a developer wants to add a new measurement/filter/graph, they can add it incrementally without heavily tearing into existing code and test it in isolation, completing within schedule with ≤ 1 existing module changed (registration/wiring only), 0 regressions in existing features, and ≤ 5 person-days of effort for adding one new graph.

| Element | Content |
|---------|---------|
| Source | Developer |
| Stimulus | Wants to add a new measurement/filter/graph |
| Artifact | The system (codebase holding the measurement/display features) |
| Environment | During development, tight schedule |
| Response | Add incrementally without heavily tearing into existing code; test in isolation |
| Response Measure | Adding one new graph: ≤ 1 existing module changed (registration/wiring only), 0 regressions in existing features, ≤ 5 person-days of effort |

### QAS-8 · Modifiability (Modularity) — Fixing in One Place
> During maintenance, when a developer wants to change one responsibility that used to be crammed together with others on the main screen, changing that one thing has no effect elsewhere, so that fixing one responsibility touches 1 file with 0 ripple changes to other responsibilities.

| Element | Content |
|---------|---------|
| Source | Developer |
| Stimulus | Needs to change one of several responsibilities previously lumped onto one screen |
| Artifact | The main-screen code where all functions were lumped together |
| Environment | During maintenance |
| Response | Changing one responsibility has no effect on the others |
| Response Measure | Fixing one responsibility changes 1 file; 0 ripple changes to other responsibilities |

### QAS-9 · Portability — Running on Other Devices/OSes
> When porting to a different environment or supporting a new sound device, when a developer migrates between Windows ↔ Raspberry Pi, etc., the system can support the new OS / sound device, with 1 module changed/added and 0 lines of existing domain code changed when adding a new environment.

| Element | Content |
|---------|---------|
| Source | Developer |
| Stimulus | Migrating to a different environment (e.g., Windows ↔ Raspberry Pi) or supporting a new sound device |
| Artifact | The sound-input part |
| Environment | When porting or adding |
| Response | Support the new OS / sound device |
| Response Measure | Adding a new environment (OS / sound device): 1 module changed/added, 0 lines of existing domain code changed |

### QAS-10 · Modifiability (Testability) — Testing Parts in Isolation
> During testing, when a developer/tester wants to test just the sound-analysis stages or the input part separately, the stage-by-stage analysis parts and the sound-input part can be checked in isolation by feeding fake input without real hardware, meeting unit-test coverage ≥ 80% on the core analysis stages and 100% of unit tests runnable without real hardware. [SJ] X/D sequence summaries are reproducible with the same Sim/Playback input and traceable to included/excluded position results.

| Element | Content |
|---------|---------|
| Source | Developer / tester |
| Stimulus | Wants to test just the sound-analysis stages or input part separately |
| Artifact | The stage-by-stage analysis parts, the sound-input part |
| Environment | During testing |
| Response | Check parts in isolation by feeding fake input without real hardware; [SJ] produce repeatable X/D sequence results and expose the included/excluded position results used to calculate them |
| Response Measure | Unit-test coverage ≥ 80% on core analysis stages, 100% of unit tests runnable without real hardware; [SJ] X/D values are identical across 3 repeated runs with the same standard-position input, and X/D trace-back coverage = 100% |

### QAS-11 · Usability — Reading and Operating on the Low-Resolution Touchscreen
> While using the device as usual on the Raspberry Pi's 800×480 touchscreen, when the user reads measurement values and switches modes, the system presents the key readings legibly without scrolling/zooming and lets the user operate primary functions by touch alone, keeping primary readings (rate, beat error, amplitude) readable at normal working distance, all primary touch targets ≥ 9 mm (≈ 48 px), and any primary mode reachable in ≤ 2 taps. [SJ] During position and sequence review, the user can quickly identify the active/selected position and X/D summary.

| Element | Content |
|---------|---------|
| Source | User (watchmaker / operator) |
| Stimulus | Reads measurement values and switches modes on the 800×480 touchscreen |
| Artifact | The GUI (spectrogram/scope/numeric displays and controls) |
| Environment | Raspberry Pi 5 with the 800×480 touch display, in normal use |
| Response | Present key readings legibly and allow primary functions to be operated by touch alone; [SJ] show active/selected position and X/D near the related measurement values |
| Response Measure | Primary readings (rate, beat error, amplitude) shown simultaneously without scroll/zoom at ≥ 24 px font, readable at ~40 cm working distance; all primary touch targets ≥ 9 mm (≈ 48 px); any primary mode reachable in ≤ 2 taps; [SJ] active/selected position identifiable within 5 seconds, and X/D identifiable within 10 seconds |

### QAS-12 · Availability (Recoverability) — Audio Device Disconnect/Reconnect
> While measuring as usual, when the audio input device is disconnected or errors out, the system detects the fault without crashing, informs the user, and resumes measurement without a manual restart once the device is reconnected, with 0 crashes, a "no device" indication within 5 s, automatic resumption within 10 s of reconnection, and 0 data corruption.

| Element | Content |
|---------|---------|
| Source | Sound device (external) |
| Stimulus | The audio input device is disconnected or raises an error during measurement |
| Artifact | The sound-input part / the system |
| Environment | Measuring as usual |
| Response | Detect the fault without crashing, inform the user, and resume measurement without a manual restart once reconnected |
| Response Measure | 0 crashes on disconnect; "no device" indication within 5 s; automatic resumption within 10 s of reconnection; 0 data corruption |

## Constraints

| ID | Constraint |
|----|------------|
| C-1 | The system shall run on a Raspberry Pi 5 (8 GB RAM, 128 GB microSD) with a touchscreen. |
| C-2 | The system shall render and operate the GUI correctly on the low-resolution (800×480) display attached to the Raspberry Pi 5. |
| C-3 | The system shall run on both Windows PC and Debian Linux Raspberry Pi 5. |
| C-4 | The system shall operate with Auto Gain Control turned off. |

---

## Functional Requirements

### G09 · Time-Frequency Spectrogram Display

| ID | Grade | 요구사항 |
|----|-------|----------|
| FR-G09-01 | mandatory | Time-Frequency Spectrogram Display는 사용자에게 시계의 음향 에너지가 시간과 주파수에 따라 어떻게 분포하는지 보여주는 시간-주파수 스펙트로그램을 제공해야 한다. |
| FR-G09-02 | mandatory | Time-Frequency Spectrogram Display는 스펙트로그램을 사용자에게 표시할 때 가로축은 시간, 세로축은 주파수, 색상 강도는 신호 세기를 나타내도록 해야 한다. |
| FR-G09-03 | optional | Time-Frequency Spectrogram Display는 사용자가 가장 최근 비트 또는 선택한 최근 시간 구간을 검사할 수 있는 기능을 제공해야 한다. |
| FR-G09-04 | optional | Time-Frequency Spectrogram Display는 사용자가 특징적인 주파수 범위에서 반복적으로 나타나는 에너지 구조를 볼 수 있는 기능을 제공해야 한다. |
| FR-G09-05 | optional | Time-Frequency Spectrogram Display는 사용자가 한 비트와 다음 비트를 비교할 수 있는 기능을 제공해야 한다. |
| FR-G09-06 | optional | Time-Frequency Spectrogram Display는 상대적인 신호 세기를 해석할 수 있도록 색상 스케일 또는 범례를 제공해야 한다. |

### G11 · Scope Mode with Synchronized Sweep Display

| ID | Grade | 요구사항 |
|----|-------|----------|
| FR-G11-01 | mandatory | Scope Mode with Synchronized Sweep Display는 오실로스코프와 유사하게 고정된 스윕 창에서 시계의 음향 신호를 표시하는 화면을 사용자에게 제공해야 한다. |
| FR-G11-02 | optional | Scope Mode with Synchronized Sweep Display는 파형의 위쪽 절반과 아래쪽 절반을 결합한 처리 신호 표시를 사용자에게 제공해야 한다. |
| FR-G11-03 | optional | Scope Mode with Synchronized Sweep Display는 사용자가 시계 틱 간격의 배수로 스윕 시간을 설정할 수 있는 기능을 제공해야 한다. |
| FR-G11-04 | optional | Scope Mode with Synchronized Sweep Display는 비트 패턴이 명목 속도 근처에서는 시각적으로 안정적으로 유지되고, 시계가 빠르거나 느릴 때는 드리프트가 보이는 동기화 표시를 제공해야 한다. |
| FR-G11-05 | optional | Scope Mode with Synchronized Sweep Display는 가장 최근 타이밍 테스트에서 얻은 기준값(일오차, 진폭, 비트 오차, 명목 비트 속도)을 사용자에게 제공할 수 있다. |

## Quality Attribute Scenarios

### QAS-1 · Performance (Latency) — From Sound Input to Screen Display
> 평소처럼 측정하는 동안 마이크로 소리가 들어오면, 시스템은 입력 → 분석 → 표시 흐름으로 처리하여 화면에 표시하며, 소리가 들어온 시점부터 화면에 뜰 때까지의 p99(99 백분위) 종단 지연 시간이 500 ms 미만이고, 10분 연속 실행 동안 오디오 블록과 비트 누락이 0회임을 보장한다.

| 요소 | 내용 |
|------|------|
| 출처 | 마이크 / 시계 (외부) |
| 자극 | 마이크로 소리가 들어옴 |
| 대상 산출물 | 전체 입력 → 분석 → 표시 흐름 |
| 환경 | 평소처럼 측정 중 |
| 응답 | 처리하여 화면에 표시함 |
| 응답 척도 | p99 종단 지연 시간(소리 도착 → 화면 표시) ≤ 500 ms; 10분 연속 실행 동안 드롭된 오디오 블록 0개, 놓친 비트 0개 |

### QAS-2 · Performance (Throughput) — Analysis Processing Budget
> 평소처럼 측정하는 동안 분석할 오디오 블록이 들어오면, 시스템은 분석 처리(입력 → 분석 단계, 오디오 버퍼링과 화면 표시 제외)를 제한된 연산 예산 내에 완료하여, p99 연산 시간이 100 ms 미만이고 10분 연속 실행 동안 오디오 블록과 비트 누락이 0회임을 보장한다.

| 요소 | 내용 |
|------|------|
| 출처 | 분석/계산 단계 (내부) |
| 자극 | 분석할 오디오 블록이 들어옴 |
| 대상 산출물 | 입력 → 분석 처리 단계 |
| 환경 | 평소처럼 측정 중 |
| 응답 | 분석 처리를 연산 예산 내에 완료함 |
| 응답 척도 | p99 연산 시간(오디오 버퍼링·화면 표시 제외, 분석 처리만) ≤ 100 ms; 10분 연속 실행 동안 드롭된 오디오 블록 0개, 놓친 비트 0개 |

### QAS-3 · Dependability (Reliability) — No Degradation Over Long Runs
> Raspberry Pi(8 GB RAM)에서 멈추지 않고 연속 측정하는 동안, 시스템은 시간이 지나도 성능이 열화되지 않고 정상 서비스를 계속 제공하여 — 메모리 누수 없음, 크래시 없음, 화면 멈춤 없음 — 10분 연속 실행을 견딘다(입력 rate를 따라가는 것은 QAS-2에서 전제). [JYP] "장시간 / 시간이 지나도"에는 구체적 기준이 필요함 — 지속시간을 명시적으로 정의하고(권고 2) 10분 척도를 그 의도에 맞게 상향할 것(권고 1).

| 요소 | 내용 |
|------|------|
| 출처 | 시스템 |
| 자극 | 오랫동안 멈추지 않고 연속 측정함 |
| 대상 산출물 | 전체 시스템, Raspberry Pi 메모리/프로세스 상태 |
| 환경 | Raspberry Pi(8 GB RAM)에서 장시간 실행 [JYP] "장시간"을 구체적 지속시간으로 정의할 것(예: 연속 ≥ 2시간, 가능하면 Long-Term Performance Graph 기준 ≥ 6시간) — 표현만으로는 모호하고 그 자체로 검증 불가. |
| 응답 | 열화 없이 정상 서비스를 계속 제공: 자원 고갈 없음, 크래시 없음, 멈춤 없음 |
| 응답 척도 | 10분 연속 실행 중: 임의 5분 구간에서 RSS 증가 ≤ 20 MB, 단조 증가 추세 없음; 크래시 0회; 화면 멈춤 0회(멈춤 = 화면 업데이트가 2초 이상 미갱신) [JYP] 10분은 "장기 무열화"를 입증하기엔 너무 짧음 — 검증 구간을 환경 칸에서 정의한 대표 장기 지속시간(예: ≥ 2시간)으로 상향하고, 임의 30분 구간에서 RSS 단조 증가가 없어야 함. |

### QAS-4 · Dependability (Reliability) — Consistent Values Across Displays
> 평소처럼 측정하는 동안 하나의 측정 결과가 산출되어 여러 그래프와 숫자로 전달될 때, 시스템은 한 화면 프레임의 모든 표시를 동일한 측정 스냅샷(각 스냅샷 ID 부여)에서 렌더링하여 서로 불일치하지 않게 하며, 표시 간 값 불일치가 0회이다 — 불일치란 같은 프레임의 두 표시가 서로 다른 스냅샷 ID에서 파생된 경우를 말한다. [SJ] Sequence 기능에서는 X/D summary가 position별 표시와 동일한 captured result set을 사용한다.

| 요소 | 내용 |
|------|------|
| 출처 | 분석/계산 단계 (내부) |
| 자극 | 하나의 측정 결과가 산출되어 여러 표시(그래프/숫자)로 전달됨 |
| 대상 산출물 | 수치 표시값과 여러 그래프 표시 |
| 환경 | 평소처럼 측정 중 |
| 응답 | 한 프레임의 모든 표시를 동일한 측정 스냅샷(스냅샷 ID 부여)에서 렌더링하여 서로 불일치하지 않게 함; [SJ] 표시된 position별 result set으로부터 X/D sequence summary를 산출함 |
| 응답 척도 | 같은 화면 프레임의 표시 간 값 불일치 0회. 불일치 = 두 표시의 값이 서로 다른 스냅샷 ID에서 파생된 경우; [SJ] sequence summary와 표시된 position별 값 사이의 X/D source mismatch 0건 |

### QAS-5 · Dependability (Reliability) — Under Noisy or Weak Signals
> 주변 잡음이 섞이거나 약한 신호가 들어오는 열악한 환경에서, 시스템(잡음 제거/비트 감지)은 필요한 소리를 보존하면서 잡음을 걸러내고, 신호가 나쁠 때는 잘못된 값을 표시하는 대신 "신호 약함" 표시를 보여준다. 기준 장비 판독값을 정답으로 사용하여 최소 1,000비트 표본 기준, SNR ≥ 14 dB 잡음 조건에서 비트 감지율 ≥ 95%, 일오차 ≤ ±3 s/d를 만족하며, 그보다 약한 신호는 "신호 약함"만 표시하고 잘못된 값 출력은 0회이다. [SJ] Invalid 또는 low-confidence position result는 X/D sequence 계산에서 제외된다.

| 요소 | 내용 |
|------|------|
| 출처 | 주변 잡음 / 약한 신호(외부) |
| 자극 | 잡음이 섞이거나 신호가 약하게 들어옴 |
| 대상 산출물 | 잡음 제거 / 비트 감지 부분 |
| 환경 | 열악한 환경 |
| 응답 | 필요한 소리를 보존하면서 잡음을 걸러냄; 신호가 나쁠 때 잘못된 값 대신 "신호 약함"을 표시함; [SJ] invalid 또는 low-confidence position result를 X/D 계산에서 제외함 |
| 응답 척도 | 기준 장비 판독값을 정답으로, 최소 1,000비트 표본 기준 SNR ≥ 14 dB 조건에서 비트 감지율 ≥ 95%, 일오차 ≤ ±3 s/d; 더 약한 신호는 "신호 약함"만 표시하고 잘못된 값 출력 0회; [SJ] invalid/low-confidence 값의 X/D 계산 포함 0건 |

### QAS-6 · Dependability (Reliability) — Pinpointing Beats Precisely
> 평소처럼 측정하는 동안 새 비트(틱/톡)가 입력 스트림에 도착할 때, 시스템(비트 감지/시간 계산)은 그 비트의 시작점과 피크 위치를 정확히 찾아내고 측정 내내 시간 정밀도를 유지하여, 시작/피크 검출 위치 오차가 ≤ 0.1 ms(96,000 SPS에서 약 10샘플)이고 비트 오차를 0.1 ms까지 해상할 수 있다. 0.1 ms 정답은 실제 하드웨어로 얻을 수 없으므로, 시작/피크 위치가 알려진 합성 입력 신호로 검증한다(QAS-10 연계).

| 요소 | 내용 |
|------|------|
| 출처 | 시계 비트 (외부 입력 스트림) |
| 자극 | 새 비트(틱/톡)가 입력 스트림에 도착함 |
| 대상 산출물 | 비트 감지 / 시간 계산 부분 |
| 환경 | 평소처럼 측정 중 |
| 응답 | 도착한 비트의 시작점과 피크 위치를 정확히 찾아내고 측정 내내 시간 정밀도를 유지함 |
| 응답 척도 | 시작/피크 검출 위치 오차 ≤ 0.1 ms(96,000 SPS에서 약 10샘플), 시작/피크 위치가 알려진 합성 신호로 검증(QAS-10 연계, 실제 하드웨어 불요); 비트 오차 0.1 ms 해상 가능 |

### QAS-7 · Modifiability (Extensibility) — Adding a New Graph
> 일정이 촉박한 개발 상황에서 개발자가 새 측정/필터/그래프를 추가하려고 할 때, 기존 코드를 크게 뜯어고치지 않고 점진적으로 추가하고 독립적으로 테스트할 수 있으며, 새 그래프 하나 추가에 대해 기존 모듈 변경 ≤ 1개(등록/배선부만), 기존 기능 회귀 0건, 작업량 ≤ 5인일로 일정 내 완료한다.

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 |
| 자극 | 새 측정/필터/그래프를 추가하려고 함 |
| 대상 산출물 | 시스템(측정·표시 기능을 담은 코드베이스) |
| 환경 | 개발 중, 일정이 촉박함 |
| 응답 | 기존 코드를 크게 뜯어고치지 않고 점진적으로 추가함; 독립적으로 테스트함 |
| 응답 척도 | 새 그래프 하나 추가: 기존 모듈 변경 ≤ 1개(등록/배선부만), 기존 기능 회귀 0건, 작업량 ≤ 5인일 |

### QAS-8 · Modifiability (Modularity) — Fixing in One Place
> 유지보수 중 개발자가 메인 화면에 다른 책임들과 함께 몰려 있던 한 가지 책임을 변경하려고 할 때, 그 한 가지 변경이 다른 곳에 영향을 주지 않으며, 하나의 책임 수정 시 1개 파일만 변경되고 다른 책임으로의 변경 전파가 0건이다.

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 |
| 자극 | 한 화면에 함께 몰려 있던 여러 책임 중 하나를 변경해야 함 |
| 대상 산출물 | 모든 기능이 한데 뭉쳐 있던 메인 화면 코드 |
| 환경 | 유지보수 중 |
| 응답 | 한 가지 책임 변경이 다른 책임에 영향을 주지 않음 |
| 응답 척도 | 하나의 책임 수정 시 1개 파일 변경; 다른 책임으로의 변경 전파 0건 |

### QAS-9 · Portability — Running on Other Devices/OSes
> 다른 환경으로 포팅하거나 새 사운드 장치를 지원할 때, 개발자가 Windows ↔ Raspberry Pi 등으로 이전하더라도 시스템은 새 OS/사운드 장치를 지원할 수 있으며, 새 환경(OS / 사운드 장치) 추가 시 1개 모듈만 변경/추가하고 기존 도메인 코드 변경은 0줄이다.

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 |
| 자극 | 다른 환경(예: Windows ↔ Raspberry Pi)으로 이전하거나 새 사운드 장치를 지원함 |
| 대상 산출물 | 사운드 입력 부분 |
| 환경 | 포팅 또는 추가 시 |
| 응답 | 새 OS / 사운드 장치를 지원함 |
| 응답 척도 | 새 환경(OS / 사운드 장치) 추가: 1개 모듈 변경/추가, 기존 도메인 코드 변경 0줄 |

### QAS-10 · Modifiability (Testability) — Testing Parts in Isolation
> 테스트 중 개발자/테스터가 사운드 분석 단계나 입력 부분만 따로 테스트하려고 할 때, 단계별 분석 부분과 사운드 입력 부분은 실제 하드웨어 없이 가짜 입력을 주입하여 독립적으로 확인할 수 있으며, 핵심 분석 단계의 단위 테스트 커버리지 ≥ 80%, 실제 하드웨어 없이 실행 가능한 단위 테스트 100%를 만족한다. [SJ] X/D sequence summary는 동일 Sim/Playback input으로 재현 가능하고 included/excluded position result로 역추적 가능하다.

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 / 테스터 |
| 자극 | 사운드 분석 단계 또는 입력 부분만 따로 테스트하려고 함 |
| 대상 산출물 | 단계별 분석 부분, 사운드 입력 부분 |
| 환경 | 테스트 중 |
| 응답 | 실제 하드웨어 없이 가짜 입력을 주입하여 부분별로 독립 확인함; [SJ] 반복 가능한 X/D sequence result를 산출하고 계산에 사용된 included/excluded position result를 제시함 |
| 응답 척도 | 핵심 분석 단계 단위 테스트 커버리지 ≥ 80%, 실제 하드웨어 없이 실행 가능한 단위 테스트 100%; [SJ] 동일 standard-position input 3회 반복 실행 시 X/D 값이 동일하고 X/D 역추적 가능률 100% |

### QAS-11 · Usability — Reading and Operating on the Low-Resolution Touchscreen
> Raspberry Pi의 800×480 터치스크린에서 평소처럼 사용하는 동안 사용자가 측정값을 읽고 모드를 전환할 때, 시스템은 핵심 측정값을 스크롤/확대 없이 가독성 있게 표시하고 주요 기능을 터치만으로 조작할 수 있게 하며, 주요 측정값(일오차·비트오차·진폭)을 정상 작업 거리에서 판독 가능하게 표시하고, 모든 주요 터치 타깃을 ≥ 9 mm(≈ 48 px)로, 주요 모드 도달을 ≤ 2 탭으로 유지한다. [SJ] Position 및 sequence review 중 사용자는 active/selected position과 X/D summary를 빠르게 식별할 수 있다.

| 요소 | 내용 |
|------|------|
| 출처 | 사용자(시계공 / 측정자) |
| 자극 | 800×480 터치스크린에서 측정값을 읽고 모드를 전환함 |
| 대상 산출물 | GUI(스펙트로그램/스코프/수치 표시와 컨트롤) |
| 환경 | Raspberry Pi 5 + 800×480 터치 디스플레이, 평소 사용 중 |
| 응답 | 핵심 측정값을 가독성 있게 표시하고 주요 기능을 터치만으로 조작 가능하게 함; [SJ] active/selected position과 X/D를 관련 측정값 근처에 표시함 |
| 응답 척도 | 주요 측정값(일오차·비트오차·진폭)을 스크롤/확대 없이 동시 표시, 폰트 ≥ 24 px, 약 40 cm 작업 거리에서 판독 가능; 모든 주요 터치 타깃 ≥ 9 mm(≈ 48 px); 주요 모드 도달 ≤ 2 탭; [SJ] active/selected position은 5초 이내 식별 가능, X/D는 10초 이내 식별 가능 |

### QAS-12 · Availability (Recoverability) — Audio Device Disconnect/Reconnect
> 평소처럼 측정하는 동안 오디오 입력 장치가 분리되거나 오류를 일으킬 때, 시스템은 크래시 없이 오류를 감지하고 사용자에게 알리며 장치 재연결 시 수동 재시작 없이 측정을 재개하여, 크래시 0회, 5초 이내 "장치 없음" 표시, 재연결 후 10초 이내 자동 측정 재개, 데이터 손상 0을 보장한다.

| 요소 | 내용 |
|------|------|
| 출처 | 사운드 장치(외부) |
| 자극 | 측정 중 오디오 입력 장치가 분리되거나 오류를 일으킴 |
| 대상 산출물 | 사운드 입력 부분 / 시스템 |
| 환경 | 평소처럼 측정 중 |
| 응답 | 크래시 없이 오류를 감지하고 사용자에게 알리며, 장치 재연결 시 수동 재시작 없이 측정을 재개함 |
| 응답 척도 | 장치 분리 시 크래시 0회; 5초 이내 "장치 없음" 표시; 재연결 후 10초 이내 자동 측정 재개; 데이터 손상 0 |

## Constraints

| ID | 제약사항 |
|----|----------|
| C-1 | 시스템은 터치스크린이 연결된 Raspberry Pi 5(8 GB RAM, 128 GB microSD)에서 실행되어야 한다. |
| C-2 | 시스템은 Raspberry Pi 5에 연결된 저해상도(800×480) 디스플레이에서 GUI를 올바르게 렌더링하고 동작해야 한다. |
| C-3 | 시스템은 Windows PC와 Debian Linux Raspberry Pi 5 모두에서 실행되어야 한다. |
| C-4 | 시스템은 Auto Gain Control이 꺼진 상태에서 동작해야 한다. |
