# Milestone1 Jae-hong Oh

> English version above, Korean version below. (위쪽은 영어 버전, 아래쪽은 한국어 버전입니다.)

## Functional Requirements

### G09 · Time-Frequency Spectrogram Display

| ID | Grade | Requirement |
|----|-------|-------------|
| FR-G09-01 | mandatory | The system shall provide the user with a time-frequency spectrogram that shows how the watch's acoustic energy is distributed across time and frequency. |
| FR-G09-02 | mandatory | The system shall present the spectrogram to the user with time on the horizontal axis, frequency on the vertical axis, and signal strength as color intensity. |
| FR-G09-03 | optional | The system should provide the user with the ability to inspect either the most recent beat or a selected recent time window. |
| FR-G09-04 | optional | The system should provide the user with the ability to view recurring energy structures at characteristic frequency ranges. |
| FR-G09-05 | optional | The system should provide the user with the ability to compare one beat with the next. |
| FR-G09-06 | optional | The system should provide the user with a color scale or legend for interpreting relative signal strength. |

### G11 · Scope Mode with Synchronized Sweep Display

| ID | Grade | Requirement |
|----|-------|-------------|
| FR-G11-01 | mandatory | The system shall provide the user with a display of the watch's acoustic signal in a fixed sweep window, similar to an oscilloscope. |
| FR-G11-02 | optional | The system should provide the user with a display of the processed signal that combines the upper and lower halves of the waveform. |
| FR-G11-03 | optional | The system should provide the user with the ability to configure the sweep time as a multiple of the watch's tick interval. |
| FR-G11-04 | optional | The system should provide the user with a synchronized display in which the beat pattern stays visually stable near the nominal rate and drifts when the watch is fast or slow. |
| FR-G11-05 | optional | The system may provide the user with reference values (daily rate, amplitude, beat error, nominal beat rate) from the most recent timing test. |

## Quality Attribute Scenarios

### QAS-1 · Performance (Responsiveness) — Real-Time Graph Update
> While measuring as usual on the Raspberry Pi, when a new measurement is produced and the graph needs to be redrawn, the system immediately reflects the new value on the on-screen graph, completing the screen update in under 100 ms with no stutter.

| Element | Content |
|---------|---------|
| Source | The system |
| Stimulus | A new measurement is produced and the graph must be redrawn |
| Artifact | The on-screen graph |
| Environment | Measuring as usual on the Raspberry Pi |
| Response | Immediately reflect the new value on the graph |
| Response Measure | Screen update in under 100 ms, 0 stutters |

### QAS-2 · Performance (Latency) — From Sound Input to Screen Display
> While measuring as usual, when sound comes in and moves into the analysis/display process, the system quickly processes the whole input → analysis → display flow, shows it on screen, and records the elapsed time, guaranteeing average input-to-screen latency under 100 ms with 0 dropped audio blocks and beats.

| Element | Content |
|---------|---------|
| Source | The system |
| Stimulus | Sound comes in and moves into the analysis/display process |
| Artifact | The full input → analysis → display flow |
| Environment | Measuring as usual |
| Response | Quickly analyze, show on screen, and record elapsed time |
| Response Measure | Average input-to-screen latency under 100 ms, 0 dropped audio blocks, 0 missed beats |

### QAS-3 · Performance (Resources) — No Slowdown Over Long Runs
> While measuring continuously without stopping on the Raspberry Pi (8 GB RAM), the system keeps processing data without loss and runs stably without running out of memory, sustaining 96,000 SPS (48,000 SPS minimum) with no memory growth and 0 screen freezes over 10 minutes of continuous operation.

| Element | Content |
|---------|---------|
| Source | The system |
| Stimulus | Measuring continuously without stopping for a long time |
| Artifact | The whole system, Raspberry Pi memory/performance |
| Environment | Long-running operation on the Raspberry Pi (8 GB RAM) |
| Response | Keep processing data without loss, stay stable without running out of memory |
| Response Measure | Sustains 96,000 SPS (48,000 SPS minimum), 0 memory growth (no leak) over 10 min continuous run, 0 screen freezes |

### QAS-4 · Correctness — Consistent Values Across Displays
> While measuring as usual, when the same sound is shown across multiple graphs and numbers at once, the system ensures every display is computed from the same underlying data so they do not disagree, with 0 mismatches across displays for the same input and agreement with the simulation reference value within rate ±1 s/d, beat error ±0.1 ms, amplitude ±3°.

| Element | Content |
|---------|---------|
| Source | The system |
| Stimulus | The same sound is shown across multiple graphs/numbers at once |
| Artifact | Numeric readouts and multiple graph displays |
| Environment | Measuring as usual |
| Response | Compute all displays from the same underlying data so they do not disagree |
| Response Measure | 0 value mismatches across displays for the same input; within rate ±1 s/d, beat error ±0.1 ms, amplitude ±3° of the simulation reference value |

### QAS-5 · Robustness — Under Noisy or Weak Signals
> In a poor environment where ambient noise mixes in or a weak signal arrives, the system (noise removal / beat detection) filters out noise while preserving the needed sounds, and when the signal is bad it shows a "signal weak" indication instead of a wrong value, meeting beat detection rate ≥ 95% and rate error ≤ ±3 s/d under noise conditions of SNR ≥ 14 dB (using a reference instrument's reading as ground truth), while signals weaker than that show only "signal weak" and output 0 wrong values.

| Element | Content |
|---------|---------|
| Source | Ambient noise / weak signal (external) |
| Stimulus | Noise mixes in or the signal arrives weak |
| Artifact | The noise-removal / beat-detection part |
| Environment | Poor environment |
| Response | Filter out noise while preserving needed sounds; when the signal is bad, show "signal weak" instead of a wrong value |
| Response Measure | Using a reference instrument's reading as ground truth, beat detection rate ≥ 95% and rate error ≤ ±3 s/d under SNR ≥ 14 dB; weaker signals show only "signal weak" and output 0 wrong values |

### QAS-6 · Accuracy — Pinpointing Beats Precisely
> While measuring as usual, when the start and peak of the sound must be located precisely, the system (beat detection / time calculation) pinpoints the key points accurately and maintains timing precision throughout the measurement, locating A·C within ≤ 0.1 ms (≈10 samples at 96 kSps) so beat error is resolved down to 0.1 ms.

| Element | Content |
|---------|---------|
| Source | The system |
| Stimulus | The start and peak of the sound must be located precisely |
| Artifact | The beat-detection / time-calculation part |
| Environment | Measuring as usual |
| Response | Pinpoint the key points accurately and maintain timing precision throughout |
| Response Measure | A·C onset/peak detection position error ≤ 0.1 ms (≈10 samples at 96 kSps), beat error resolvable to 0.1 ms |

### QAS-7 · Extensibility — Adding a New Graph
> In a tight-schedule development situation, when a developer wants to add a new measurement/filter/graph, the structure split into input / analysis / calculation / display lets them add incrementally without heavily tearing into existing code and test in isolation, completing within schedule with 0 existing modules changed (additions only), 0 regressions in existing features, and ≤ 5 person-days of effort for adding one new graph.

| Element | Content |
|---------|---------|
| Source | Developer |
| Stimulus | Wants to add a new measurement/filter/graph |
| Artifact | The structure split into input / analysis / calculation / display |
| Environment | During development, tight schedule |
| Response | Add incrementally without heavily tearing into existing code; test in isolation |
| Response Measure | Adding one new graph: 0 existing modules changed (additions only), 0 regressions in existing features, ≤ 5 person-days of effort |

### QAS-8 · Modifiability — Fixing in One Place
> During maintenance, when a developer wants to change one thing in the main-screen code that had too many responsibilities crammed together, the system splits functions by role so that changing one thing has no effect elsewhere, decomposing into modules of ≤ 500 lines each so that fixing one responsibility touches 1 file.

| Element | Content |
|---------|---------|
| Source | Developer |
| Stimulus | Too many responsibilities crammed into one screen class; needs to change one of them |
| Artifact | The main-screen code where all functions were lumped together |
| Environment | During maintenance |
| Response | Split functions by role so changing one thing has no effect elsewhere |
| Response Measure | Decomposed into modules of ≤ 500 lines each; fixing one responsibility changes 1 file |

### QAS-9 · Portability — Running on Other Devices/OSes
> When porting to a different environment or supporting a new sound device, when a developer migrates between Windows ↔ Raspberry Pi, etc., the sound-input part keeps the common interface unchanged and only swaps the environment-specific part, with 1 module changed/added and 0 lines of existing domain code changed when adding a new environment.

| Element | Content |
|---------|---------|
| Source | Developer |
| Stimulus | Migrating to a different environment (e.g., Windows ↔ Raspberry Pi) or supporting a new sound device |
| Artifact | The sound-input part |
| Environment | When porting or adding |
| Response | Keep the common interface unchanged and swap only the environment-specific part |
| Response Measure | Adding a new environment (OS / sound device): 1 module changed/added, 0 lines of existing domain code changed |

### QAS-10 · Testability — Testing Parts in Isolation
> During testing, when a developer/tester wants to test just the sound-analysis stages or the input part separately, the stage-by-stage analysis parts and the sound-input part can be checked in isolation by feeding fake input without real hardware, meeting unit-test coverage ≥ 80% on the core analysis stages and 100% of unit tests runnable without real hardware.

| Element | Content |
|---------|---------|
| Source | Developer / tester |
| Stimulus | Wants to test just the sound-analysis stages or input part separately |
| Artifact | The stage-by-stage analysis parts, the sound-input part |
| Environment | During testing |
| Response | Check parts in isolation by feeding fake input without real hardware |
| Response Measure | Unit-test coverage ≥ 80% on core analysis stages, 100% of unit tests runnable without real hardware |

## Constraints

| ID | Constraint |
|----|------------|
| C-1 | The system shall run on a Raspberry Pi 5 (8 GB RAM, 128 GB microSD) with a touchscreen. |
| C-2 | The system shall render and operate the GUI correctly on the low-resolution (800×480) display attached to the Raspberry Pi 5. |
| C-3 | The system shall run on both Windows PC and Debian Linux Raspberry Pi 5. |
| C-4 | The system shall operate with Auto Gain Control turned off. |

---

## 기능 요구사항 (Functional Requirements)

### G09 · 시간-주파수 스펙트로그램 디스플레이

| ID | 등급 | 요구사항 |
|----|------|----------|
| FR-G09-01 | 필수 | 시스템은 사용자에게 시계의 음향 에너지가 시간과 주파수에 따라 어떻게 분포하는지 보여주는 시간-주파수 스펙트로그램을 제공해야 한다. |
| FR-G09-02 | 필수 | 시스템은 스펙트로그램을 사용자에게 표시할 때 가로축은 시간, 세로축은 주파수, 색상 강도는 신호 세기를 나타내도록 해야 한다. |
| FR-G09-03 | 선택 | 시스템은 사용자가 가장 최근 비트 또는 선택한 최근 시간 구간을 검사할 수 있는 기능을 제공해야 한다. |
| FR-G09-04 | 선택 | 시스템은 사용자가 특징적인 주파수 범위에서 반복적으로 나타나는 에너지 구조를 볼 수 있는 기능을 제공해야 한다. |
| FR-G09-05 | 선택 | 시스템은 사용자가 한 비트와 다음 비트를 비교할 수 있는 기능을 제공해야 한다. |
| FR-G09-06 | 선택 | 시스템은 상대적인 신호 세기를 해석할 수 있도록 색상 스케일 또는 범례를 제공해야 한다. |

### G11 · 동기화 스윕 스코프 모드 디스플레이

| ID | 등급 | 요구사항 |
|----|------|----------|
| FR-G11-01 | 필수 | 시스템은 오실로스코프와 유사하게 고정된 스윕 창에서 시계의 음향 신호를 표시하는 화면을 사용자에게 제공해야 한다. |
| FR-G11-02 | 선택 | 시스템은 파형의 위쪽 절반과 아래쪽 절반을 결합한 처리 신호 표시를 사용자에게 제공해야 한다. |
| FR-G11-03 | 선택 | 시스템은 사용자가 시계 틱 간격의 배수로 스윕 시간을 설정할 수 있는 기능을 제공해야 한다. |
| FR-G11-04 | 선택 | 시스템은 비트 패턴이 명목 속도 근처에서는 시각적으로 안정적으로 유지되고, 시계가 빠르거나 느릴 때는 드리프트가 보이는 동기화 표시를 제공해야 한다. |
| FR-G11-05 | 선택 | 시스템은 가장 최근 타이밍 테스트에서 얻은 기준값(일오차, 진폭, 비트 오차, 명목 비트 속도)을 사용자에게 제공할 수 있다. |

## 품질속성 시나리오 (Quality Attribute Scenarios)

### QAS-1 · 성능 (응답성) — 실시간 그래프 업데이트
> Raspberry Pi에서 평소처럼 측정하는 동안 새 측정값이 생성되어 그래프를 다시 그려야 할 때, 시스템은 새 값을 화면 그래프에 즉시 반영하고, 끊김 없이 100 ms 이내에 화면 업데이트를 완료한다.

| 요소 | 내용 |
|------|------|
| 출처 | 시스템 |
| 자극 | 새 측정값이 생성되고 그래프를 다시 그려야 함 |
| 대상 산출물 | 화면 그래프 |
| 환경 | Raspberry Pi에서 평소처럼 측정 중 |
| 응답 | 그래프에 새 값을 즉시 반영함 |
| 응답 척도 | 화면 업데이트 100 ms 미만, 끊김 0회 |

### QAS-2 · 성능 (지연 시간) — 소리 입력에서 화면 표시까지
> 평소처럼 측정하는 동안 소리가 들어와 분석/표시 과정으로 이동할 때, 시스템은 입력 → 분석 → 표시 전체 흐름을 빠르게 처리하고 화면에 표시하며 경과 시간을 기록하여, 평균 입력-화면 지연 시간이 100 ms 미만이고 오디오 블록과 비트 누락이 0회임을 보장한다.

| 요소 | 내용 |
|------|------|
| 출처 | 시스템 |
| 자극 | 소리가 들어와 분석/표시 과정으로 이동함 |
| 대상 산출물 | 전체 입력 → 분석 → 표시 흐름 |
| 환경 | 평소처럼 측정 중 |
| 응답 | 빠르게 분석하고 화면에 표시하며 경과 시간을 기록함 |
| 응답 척도 | 평균 입력-화면 지연 시간 100 ms 미만, 드롭된 오디오 블록 0개, 놓친 비트 0개 |

### QAS-3 · 성능 (자원) — 장시간 실행 중 성능 저하 없음
> Raspberry Pi(8 GB RAM)에서 멈추지 않고 연속 측정하는 동안, 시스템은 데이터 손실 없이 계속 처리하고 메모리가 고갈되지 않도록 안정적으로 실행되며, 10분 연속 실행 동안 96,000 SPS(최소 48,000 SPS)를 유지하고 메모리 증가와 화면 멈춤이 0회이다.

| 요소 | 내용 |
|------|------|
| 출처 | 시스템 |
| 자극 | 오랫동안 멈추지 않고 연속 측정함 |
| 대상 산출물 | 전체 시스템, Raspberry Pi 메모리/성능 |
| 환경 | Raspberry Pi(8 GB RAM)에서 장시간 실행 |
| 응답 | 데이터 손실 없이 계속 처리하고, 메모리 부족 없이 안정적으로 유지됨 |
| 응답 척도 | 96,000 SPS 유지(최소 48,000 SPS), 10분 연속 실행 동안 메모리 증가 0회(누수 없음), 화면 멈춤 0회 |

### QAS-4 · 정확성 — 여러 표시 간 값 일관성
> 평소처럼 측정하는 동안 같은 소리가 여러 그래프와 숫자에 동시에 표시될 때, 시스템은 모든 표시가 같은 기반 데이터에서 계산되도록 하여 서로 불일치하지 않게 하며, 같은 입력에 대한 표시 간 불일치가 0회이고 시뮬레이션 기준값과 일오차 ±1 s/d, 비트 오차 ±0.1 ms, 진폭 ±3° 이내로 일치한다.

| 요소 | 내용 |
|------|------|
| 출처 | 시스템 |
| 자극 | 같은 소리가 여러 그래프/숫자에 동시에 표시됨 |
| 대상 산출물 | 수치 표시값과 여러 그래프 표시 |
| 환경 | 평소처럼 측정 중 |
| 응답 | 모든 표시를 같은 기반 데이터에서 계산하여 서로 불일치하지 않게 함 |
| 응답 척도 | 같은 입력에 대해 표시 간 값 불일치 0회; 시뮬레이션 기준값 대비 일오차 ±1 s/d, 비트 오차 ±0.1 ms, 진폭 ±3° 이내 |

### QAS-5 · 견고성 — 잡음이 많거나 약한 신호에서
> 주변 잡음이 섞이거나 약한 신호가 들어오는 열악한 환경에서, 시스템(잡음 제거/비트 감지)은 필요한 소리를 보존하면서 잡음을 걸러내고, 신호가 나쁠 때는 잘못된 값을 표시하는 대신 "신호 약함" 표시를 보여준다. 기준 장비 판독값을 정답으로 사용할 때 SNR ≥ 14 dB 잡음 조건에서 비트 감지율 ≥ 95%, 일오차 ≤ ±3 s/d를 만족하며, 그보다 약한 신호는 "신호 약함"만 표시하고 잘못된 값 출력은 0회이다.

| 요소 | 내용 |
|------|------|
| 출처 | 주변 잡음 / 약한 신호(외부) |
| 자극 | 잡음이 섞이거나 신호가 약하게 들어옴 |
| 대상 산출물 | 잡음 제거 / 비트 감지 부분 |
| 환경 | 열악한 환경 |
| 응답 | 필요한 소리를 보존하면서 잡음을 걸러냄; 신호가 나쁠 때 잘못된 값 대신 "신호 약함"을 표시함 |
| 응답 척도 | 기준 장비 판독값을 정답으로 사용할 때 SNR ≥ 14 dB 조건에서 비트 감지율 ≥ 95%, 일오차 ≤ ±3 s/d; 더 약한 신호는 "신호 약함"만 표시하고 잘못된 값 출력 0회 |

### QAS-6 · 정확도 — 비트 위치 정밀 검출
> 평소처럼 측정하는 동안 소리의 시작점과 피크를 정밀하게 찾아야 할 때, 시스템(비트 감지/시간 계산)은 핵심 지점을 정확히 찾아내고 측정 내내 시간 정밀도를 유지하여, A·C 시작/피크 검출 위치 오차가 ≤ 0.1 ms(96 kSps에서 약 10샘플)이고 비트 오차를 0.1 ms까지 해상할 수 있다.

| 요소 | 내용 |
|------|------|
| 출처 | 시스템 |
| 자극 | 소리의 시작점과 피크를 정밀하게 찾아야 함 |
| 대상 산출물 | 비트 감지 / 시간 계산 부분 |
| 환경 | 평소처럼 측정 중 |
| 응답 | 핵심 지점을 정확히 찾아내고 측정 내내 시간 정밀도를 유지함 |
| 응답 척도 | A·C 시작/피크 검출 위치 오차 ≤ 0.1 ms(96 kSps에서 약 10샘플), 비트 오차 0.1 ms 해상 가능 |

### QAS-7 · 확장성 — 새 그래프 추가
> 일정이 촉박한 개발 상황에서 개발자가 새 측정/필터/그래프를 추가하려고 할 때, 입력 / 분석 / 계산 / 표시로 분리된 구조는 기존 코드를 크게 뜯어고치지 않고 점진적으로 추가하고 독립적으로 테스트할 수 있게 하며, 새 그래프 하나 추가에 대해 기존 모듈 변경 0개(추가만), 기존 기능 회귀 0건, 작업량 ≤ 5인일로 일정 내 완료한다.

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 |
| 자극 | 새 측정/필터/그래프를 추가하려고 함 |
| 대상 산출물 | 입력 / 분석 / 계산 / 표시로 분리된 구조 |
| 환경 | 개발 중, 일정이 촉박함 |
| 응답 | 기존 코드를 크게 뜯어고치지 않고 점진적으로 추가함; 독립적으로 테스트함 |
| 응답 척도 | 새 그래프 하나 추가: 기존 모듈 변경 0개(추가만), 기존 기능 회귀 0건, 작업량 ≤ 5인일 |

### QAS-8 · 수정 용이성 — 한 곳에서 수정 가능
> 유지보수 중 개발자가 너무 많은 책임이 한 화면 클래스에 몰려 있던 메인 화면 코드에서 한 가지를 변경하려고 할 때, 시스템은 역할별로 기능을 분리하여 한 가지 변경이 다른 곳에 영향을 주지 않게 하며, 각 모듈을 500줄 이하로 분해하고 하나의 책임 수정이 1개 파일만 변경하도록 한다.

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 |
| 자극 | 한 화면 클래스에 너무 많은 책임이 몰려 있어 그중 하나를 변경해야 함 |
| 대상 산출물 | 모든 기능이 한데 뭉쳐 있던 메인 화면 코드 |
| 환경 | 유지보수 중 |
| 응답 | 역할별로 기능을 분리하여 한 가지 변경이 다른 곳에 영향을 주지 않게 함 |
| 응답 척도 | 각 모듈 ≤ 500줄로 분해; 하나의 책임 수정 시 1개 파일 변경 |

### QAS-9 · 이식성 — 다른 장치/운영체제에서 실행
> 다른 환경으로 포팅하거나 새 사운드 장치를 지원할 때, 개발자가 Windows ↔ Raspberry Pi 등으로 이전하더라도 사운드 입력 부분은 공통 인터페이스를 그대로 유지하고 환경별 부분만 교체하며, 새 환경(OS / 사운드 장치) 추가 시 1개 모듈만 변경/추가하고 기존 도메인 코드 변경은 0줄이다.

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 |
| 자극 | 다른 환경(예: Windows ↔ Raspberry Pi)으로 이전하거나 새 사운드 장치를 지원함 |
| 대상 산출물 | 사운드 입력 부분 |
| 환경 | 포팅 또는 추가 시 |
| 응답 | 공통 인터페이스를 그대로 유지하고 환경별 부분만 교체함 |
| 응답 척도 | 새 환경(OS / 사운드 장치) 추가: 1개 모듈 변경/추가, 기존 도메인 코드 변경 0줄 |

### QAS-10 · 테스트 용이성 — 부분별 독립 테스트
> 테스트 중 개발자/테스터가 사운드 분석 단계나 입력 부분만 따로 테스트하려고 할 때, 단계별 분석 부분과 사운드 입력 부분은 실제 하드웨어 없이 가짜 입력을 주입하여 독립적으로 확인할 수 있으며, 핵심 분석 단계의 단위 테스트 커버리지 ≥ 80%, 실제 하드웨어 없이 실행 가능한 단위 테스트 100%를 만족한다.

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 / 테스터 |
| 자극 | 사운드 분석 단계 또는 입력 부분만 따로 테스트하려고 함 |
| 대상 산출물 | 단계별 분석 부분, 사운드 입력 부분 |
| 환경 | 테스트 중 |
| 응답 | 실제 하드웨어 없이 가짜 입력을 주입하여 부분별로 독립 확인함 |
| 응답 척도 | 핵심 분석 단계 단위 테스트 커버리지 ≥ 80%, 실제 하드웨어 없이 실행 가능한 단위 테스트 100% |

## 제약사항 (Constraints)

| ID | 제약사항 |
|----|----------|
| C-1 | 시스템은 터치스크린이 연결된 Raspberry Pi 5(8 GB RAM, 128 GB microSD)에서 실행되어야 한다. |
| C-2 | 시스템은 Raspberry Pi 5에 연결된 저해상도(800×480) 디스플레이에서 GUI를 올바르게 렌더링하고 동작해야 한다. |
| C-3 | 시스템은 Windows PC와 Debian Linux Raspberry Pi 5 모두에서 실행되어야 한다. |
| C-4 | 시스템은 Auto Gain Control이 꺼진 상태에서 동작해야 한다. |
