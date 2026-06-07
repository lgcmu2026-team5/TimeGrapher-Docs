# Milestone1 — Architectural Drivers QAS+Constraints+Priority

> English version above, Korean version below. (위쪽은 영어 버전, 아래쪽은 한국어 버전입니다.)

## Quality Attribute Scenarios

### Terminology

| Term | Meaning |
|------|---------|
| p99 | The 99th-percentile value — everything except the slowest 1 % falls within this value |
| Google INP | Interaction to Next Paint — Google's web metric for the time from user input to the next screen update (good ≤ 200 ms / poor > 500 ms) |
| SPS | Samples Per Second — the audio sampling rate |
| SNR | Signal-to-Noise Ratio (dB) — higher means a cleaner signal |
| person-days | The amount of work one person completes in one day |
| Rate | Seconds the watch gains or loses per day (s/d) |
| Beat error | Asymmetry between the tick and tock intervals (ms) |
| Amplitude | Swing angle of the balance wheel (°) — a key indicator of watch health |
| Onset / Peak | The start (leading edge) / maximum point of a beat's waveform — the measurement reference points |
| Sim / Playback | Sim = synthetic watch-signal generator mode (ground truth known in advance); Playback = replay of a recorded file |
| SMPTE | Society of Motion Picture and Television Engineers — source of the viewing-distance / viewing-angle guideline |
| ISO 9241-303 | International ergonomics standard for electronic displays — source of the character-size guideline |
| Glyph | The visual shape of a single character on screen |
| arcmin | Minute of arc (1° = 60 arcmin) — unit for how large something appears to the eye |

### QAS-1 · Performance (Latency) — From Sound Input to Screen Display
> **In one line: sound reaches the microphone → the result is on screen within 0.5 s.**
>
> While measuring live on the Raspberry Pi 5, when watch sound enters the input → analysis → display flow through the microphone, the system processes it, shows it on screen, and reports the three latency components — over a 10-min run, (1) processing latency p99 and (2) display latency p99 are reported, and (3) processing+display latency must be **p99 ≤ 500 ms**.

**Why this attribute**
- The Plan demands it — and even prescribes the three-part split: *"Teams shall report capture-to-processing latency, processing-to-display latency, and total end-to-end latency in milliseconds."*
- An event arrives and the response is measured in **time** → that is Performance (Latency) by SAP's definition.

| Element | Content |
|---------|---------|
| Source | Watch sound (external) |
| Stimulus | Sound arrives at the microphone |
| Artifact | The input → analysis → display flow — timestamped at each point |
| Environment | Live measurement on the Raspberry Pi 5 (8 GB) |
| Response | Process, show on screen, and report the three latency components |
| Response Measure | Over a 10-min run: (1) processing latency — p99 (2) display latency — p99 (3) processing+display latency — **p99 ≤ 500 ms** (the pass/fail gate) |

**Why these numbers**
- **≤ 500 ms** — p99 (the slowest 1 %) sits at Google's INP (Interaction to Next Paint) boundary just before "poor" (good ≤ 200 ms · needs improvement ≤ 500 ms · poor > 500 ms); adopted as the maximum allowable limit for the final display update.

**Related FRs** — FR-08-01, FR-12-04, FR-05-03, FR-12-14 (Live display and low-latency feedback features)

### QAS-2 · Availability (Graceful Degradation) — Under Noisy or Weak Signals
> **In one line: under noise, keep the measurement service usable when the signal is good enough, and show the "signal weak" indication while handling weak input appropriately.**
>
> In a noisy working environment, when watch sound mixed with ambient noise — or a weak signal — reaches the noise-removal / beat-detection part, the system either accepts the signal and produces a bounded measurement, or shows the "signal weak" indication while handling weak input appropriately. At SNR ≥ 30 dB, accepted input must meet detection **≥ 95 %** and keep the displayed rate **within ±3 s/d of the Sim/Playback reference rate**.

**Why this attribute**
- Plan: *"the system should degrade gracefully when the signal is weak, noisy, or partially missing, rather than producing unstable or misleading outputs"* — and graceful degradation is a catalogued SAP **Availability** tactic.
- Both halves are about **continuing to deliver correct service under adverse conditions**: within tolerance while signal quality allows, and a graceful "signal weak" state below the threshold. That is Availability.

| Element | Content |
|---------|---------|
| Source | Watch sound mixed with ambient noise / weak watch sound (external) |
| Stimulus | Noise mixes in, or the signal arrives weak |
| Artifact | The noise-removal / beat-detection part and the signal-quality indication |
| Environment | A noisy working environment, or Sim/Playback input with calibrated noise injected at a held-constant SNR |
| Response | Accept usable noisy input and produce a bounded measurement; below the quality threshold, show the "signal weak" indication and handle the input appropriately |
| Response Measure | Against the generator's known schedule and reference rate, over ≥ 1,000 beats: accepted input at SNR ≥ 30 dB has detection ≥ 95 % and absolute displayed-rate error ≤ 3 s/d; below threshold, show the "signal weak" indication and handle the input appropriately |

**Why these numbers**
- **30 dB** — the worst clean recording measured with the team's microphone (30–51 dB over 9 recordings): a severe condition reachable only by deliberate noise injection; provisional.
- **±3 s/d** — the allowed difference between the displayed rate and the Sim/Playback reference rate; the width is based on roughly half of the tightest Witschi grade band (Chronometer −2…+6 s/d). **95 %** is a team target to confirm by experiment.

**Related FRs** — FR-12-08, FR-05-17…18 (noise filtering, averaging)

### QAS-3 · Consistency — Consistent Values Across Displays
> **In one line: every number and graph on screen comes from the same measurement result.**
>
> While measuring as usual, when the analysis/computation stage fans a single measurement result out to multiple graph and numeric displays, everything rendered in the same frame derives from that one result and agrees — **0 mismatches** over a 10-min run.

**Why this attribute**
- Plan §Correctness: *"remaining internally consistent across the GUI, derived measurements, and longer-term summaries"* — *"calculations and visualizations are based on the same underlying data."*
- That Plan section bundles multiple demands: stay internally consistent (→ **this scenario**) and stay usable under noise (→ QAS-2). This scenario measures only consistency, so that is its name — "Correctness" would overclaim the other parts.

| Element | Content |
|---------|---------|
| Source | The analysis/computation stage (internal) |
| Stimulus | One measurement result fans out to multiple displays (graphs/numbers) |
| Artifact | Numeric readouts and graph displays |
| Environment | Measuring as usual (verified via Sim/Playback) |
| Response | Everything shown in one frame derives from one result and agrees |
| Response Measure | Over a 10-min run on known input: **0 mismatches** across all simultaneously shown displays (within display rounding); each display exposes its source-result identity, so the check is observable |

**Why these numbers**
- **0** is the only sensible target — consistency is a correctness-class property, not a tunable number.
- The check is genuinely verifiable because each display exposes which result it came from.

**Related FRs** — FR-12-05, FR-06-06, FR-02-07…08 (views and summaries showing the same data)

### QAS-4 · Modifiability (Extensibility) — Adding a New Measurement/Filter/Graph
> **In one line: adding a new graph, filter, or measurement touches one place — 8 person-days per feature.**
>
> During development under a tight schedule, when a developer adds a new graph, filter, or measurement to the codebase, the addition is incremental without tearing into existing code — **≤ 1 existing module changed** (common parts only), 8 person-days per feature.

**Why this attribute**
- Plan §Extensibility, Modifiability: *"support the addition of new measurements, filters, graphs, and display modes without major redesign of existing code."*
- A **change request** measured by **how much code is touched** → SAP's Modifiability general scenario, using SAP's recommended measure (modules/locations affected).

| Element | Content |
|---------|---------|
| Source | Developer |
| Stimulus | Wants to add a new graph, filter stage, or derived measurement |
| Artifact | The codebase holding the measurement/display features |
| Environment | During development, tight schedule |
| Response | Add incrementally without tearing into existing code |
| Response Measure | New graph / filter / measurement, each: ≤ 1 existing module changed (common parts only), 8 person-days per feature |

**Why these numbers**
- 12 mandatory features in a 3-week schedule — only a bounded touch surface makes that feasible.
- Milestone 2/3 schedule (16 days) × 6 team members / 12 features = 8 person-days per feature.

**Related FRs** — all requirements

### QAS-5 · Usability — Reading and Operating on the Touchscreen
> **In one line: on the small 1280×800 touchscreen, the three key readings are readable at a glance and operable by finger.**
>
> On the Raspberry Pi 5's 1280×800 (8-inch) touchscreen, when the user reads measurement values and switches modes in the GUI, key readings are shown legibly and primary functions operate by touch alone — rate / beat error / amplitude visible simultaneously, uppercase letter height ≥ 2.9 mm, touch targets ≥ 9 mm. Physical sizes (mm) are normative.

**Why this attribute**
- Plan §Usability and User Purpose: *"The GUI should support ease of use by clearly showing … the calculated values that matter most to the user, such as rate, beat error, amplitude."*
- A **user** stimulus measured by **legibility and task time** → SAP's Usability general scenario. The touch panel is given hardware, not a choice.

| Element | Content |
|---------|---------|
| Source | User (watchmaker / operator) |
| Stimulus | Reads measurement values and switches modes on the touchscreen |
| Artifact | The GUI (graph/numeric displays and controls) |
| Environment | Raspberry Pi 5 + 1280×800 touch display; 8-inch panel |
| Response | Show key readings legibly; make primary functions operable by touch |
| Response Measure | Rate / beat error / amplitude visible simultaneously without scroll/zoom; uppercase letter height ≥ 2.9 mm; touch targets ≥ 9 mm |

**Why these numbers**
- **mm, not px** — a pixel criterion flips pass/fail with the panel; 9 mm is the standard touch-target size.
- **Uppercase letter height ≥ 2.9 mm** — considering full-screen visibility (SMPTE), character legibility (ISO 9241-303), and room for touch operation, the design viewing distance is conservatively set to 50 cm. At 50 cm, ISO 9241-303's recommended glyph size of ≥ 20 arcmin converts to 2.9 mm — a viewing-distance-based physical size, independent of panel resolution.
  - Calculation: 20 arcmin = 20/60° = 0.333° ≈ 0.00582 rad → letter height = viewing distance × visual angle = 500 mm × 0.00582 ≈ **2.9 mm**
  - Pixel equivalents on this panel (8″ 1280×800 → √(1280²+800²)/8 ≈ 189 PPI, 1 px ≈ 0.135 mm): letter height 2.9 mm ≈ **22 px**, touch target 9 mm ≈ **67 px** (advisory — mm is normative)

**Related FRs** — FR-06-06, FR-01-05, FR-04-03, FR-02-06, FR-06-11·13 (at-a-glance readings, position indication, alerts)

## Constraints

| ID | Constraint |
|----|------------|
| C-1 | The system shall run on a Raspberry Pi 5 (8 GB RAM, 128 GB microSD) with a touchscreen attached. |
| C-2 | The system shall render and operate the GUI correctly on the 1280×800 display connected to the Raspberry Pi 5. |
| C-3 | The system shall run on both a Windows 11 (x64) PC and a Raspberry Pi 5 running Raspberry Pi OS (Debian-based, 64-bit/ARM64). |
| C-4 | The system shall operate with Auto Gain Control turned off. |

## Priority

ATAM style: each scenario carries an (**I**mportance, **D**ifficulty) pair, H/M/L. The H/H scenarios shape the architecture most.

| Priority | QAS | Quality | I | D | Rationale |
|----------|-----|---------|---|---|-----------|
| 1 | QAS-1 | Performance (Latency) | H | H | The result must appear quickly, and the Pi may be the bottleneck |
| 2 | QAS-2 | Availability | H | H | Noisy or weak signals are likely in actual use |
| 3 | QAS-3 | Consistency | H | M | Users should not see different values for the same result |
| 4 | QAS-4 | Modifiability | H | M | Many required features still need to be added |
| 5 | QAS-5 | Usability | M | M | The small touchscreen limits layout choices |

**Ordering:** QAS-1 and QAS-2 come first because they affect whether the device is usable at all. QAS-3 and QAS-4 follow because they keep the results trustworthy and the project manageable. QAS-5 is still important, but its risk is more contained.

---

# Milestone1 — Architectural Drivers QAS+Constraints+Priority

## Quality Attribute Scenarios

### 용어 설명

| 용어 | 설명 |
|------|------|
| p99 | 측정값을 작은 순으로 정렬했을 때 99% 지점의 값 — 가장 느린 1%를 제외한 전부가 이 값 이내 |
| Google INP | Interaction to Next Paint — 사용자 입력 후 다음 화면 갱신까지의 시간에 대한 Google 웹 지표 (good ≤ 200 ms / poor > 500 ms) |
| SPS | Samples Per Second — 초당 오디오 샘플 수(샘플링 레이트) |
| SNR | Signal-to-Noise Ratio — 신호 대 잡음 비(dB). 클수록 신호가 깨끗함 |
| person-days | 1명이 1일에 처리하는 작업량 단위 |
| 일오차 (rate) | 시계가 하루에 빨라지거나 느려지는 초 수 (s/d) |
| 비트오차 (beat error) | 틱과 톡 사이 간격의 비대칭 정도 (ms) |
| 진폭 (amplitude) | 밸런스 휠이 흔들리는 회전 각도 (°) — 시계 건강 상태의 핵심 지표 |
| Onset / Peak | 비트 파형의 시작점(앞 가장자리) / 최대점 — 측정의 기준점 |
| Sim / Playback | Sim = 합성 시계 신호 생성 모드(정답을 미리 알고 있음); Playback = 녹음 파일 재생 모드 |
| SMPTE | 미국 영화·TV 기술자 협회 — 화면 시청 거리·시야각 권고 기준의 출처 |
| ISO 9241-303 | 전자 디스플레이 인간공학 국제 표준 — 글자 크기 권고 기준의 출처 |
| 글리프 (glyph) | 화면에 표시되는 글자 한 개의 모양 |
| arcmin | 각도의 분 단위(1° = 60 arcmin) — 눈에 보이는 크기를 재는 단위 |

### QAS-1 · Performance (Latency) — 소리 입력에서 화면 표시까지
> **한 줄 요약: 소리가 마이크에 들어오면 0.5초 안에 화면에 나타난다.**
>
> Raspberry Pi 5에서 Live로 측정하는 동안 시계 소리가 마이크를 통해 입력 → 분석 → 표시 흐름에 들어오면, 시스템은 처리하여 화면에 표시하고 세 지연 구간을 보고하며, 10분 연속 실행 동안 (1) processing latency p99와 (2) display latency p99를 보고하고 (3) processing+display latency는 **p99 ≤ 500 ms**이어야 한다.

**왜 이 속성인가**
- 플랜이 직접 요구하며, 3구간 분해까지 지정한다: *"Teams shall report capture-to-processing latency, processing-to-display latency, and total end-to-end latency in milliseconds."*
- 이벤트가 도착하고 응답을 **시간**으로 측정 → SAP 정의 그대로 Performance (Latency).

| 요소 | 내용 |
|------|------|
| 자극유발원 | 시계 소리 (외부) |
| 자극 | 마이크로 소리가 들어옴 |
| 대상 | 입력 → 분석 → 표시 - 해당 시점의 타임스탬프 |
| 환경 | Raspberry Pi 5(8 GB)에서 Live 측정 |
| 응답 | 처리하여 화면에 표시하고, 세 지연 구간을 보고함 |
| 응답측정 | 10분 연속 실행 동안: (1) processing latency — p99 (2) display latency — p99 (3) processing + display latency — **p99 ≤ 500 ms** (pass/fail 게이트) |

**측정값 근거**
- **≤ 500 ms** — p99(하위 1% 느린 값)를 Google INP(Interaction to Next Paint) 기준에서 "poor"로 넘어가기 직전 값(good ≤ 200 ms · needs improvement ≤ 500 ms · poor > 500 ms); 최종 디스플레이 갱신의 최대 허용 한계값으로 채택.

**관련 FR** — FR-08-01, FR-12-04, FR-05-03, FR-12-14 (실시간/Live 표시 기능)

### QAS-2 · Availability (Graceful Degradation) — 잡음·약신호 환경
> **한 줄 요약: 잡음 속에서도 신호가 충분할 때는 측정 서비스를 유지하고, 부족하면 "신호 약함"을 표시한 뒤 적절하게 처리한다.**
>
> 잡음이 포함된 열악한 작업 환경에서 잡음 섞인 시계 소리 또는 약한 시계 소리가 잡음 제거·비트 감지 부분에 들어오면, 시스템은 신호를 수용해 제한된 오차 안의 측정값을 내거나, 품질 임계 미만 입력에는 "신호 약함"을 표시하고 적절하게 처리한다. SNR ≥ 30 dB에서 수용된 입력은 감지율 **≥ 95%**이고, 표시 일오차가 **Sim/Playback 기준 일오차에서 ±3 s/d 이내**여야 한다.

**왜 이 속성인가**
- 플랜 원문: *"the system should degrade gracefully when the signal is weak, noisy, or partially missing, rather than producing unstable or misleading outputs."* — graceful degradation은 SAP에 수록된 **Availability 전술**.
- 임계 이상에서는 허용오차 내 감지·측정을, 임계 미만에서는 "신호 약함" 상태로 낮추는 게이트 — 둘 다 **악조건에서도 올바른 서비스를 계속 제공하는 능력** → Availability.

| 요소 | 내용 |
|------|------|
| 자극유발원 | 주변 잡음이 포함된 시계 소리 / 약한 시계 소리 (외부) |
| 자극 | 잡음이 섞이거나 신호가 약하게 들어옴 |
| 대상 | 잡음 제거 / 비트 감지 부분과 신호 품질 표시 |
| 환경 | 주변 잡음이 포함된 열악한 작업 환경 or Sim/Playback 입력에 보정된 잡음을 일정 SNR로 주입한 데이터 |
| 응답 | 사용 가능한 잡음 입력은 수용해 제한된 오차 안의 측정값을 내고, 품질 임계 미만 입력에는 "신호 약함"을 표시하고 적절하게 처리 |
| 응답측정 | 생성기의 알려진 스케줄과 기준 일오차 대비, 1,000비트 이상: SNR ≥ 30 dB인 수용 입력은 감지율 ≥ 95%, 표시 일오차와 기준 일오차의 절대 차이 ≤ 3 s/d; 임계 미만 입력에는 "신호 약함"을 표시하고 적절하게 처리 |

**측정값 근거**
- **30 dB** — 팀 마이크로 실측한 최악 클린 녹음(9개, 30–51 dB)중 제일 심한 조건 — 의도적 잡음 주입으로만 도달; 잠정값. 
- **±3 s/d** — 표시된 일오차가 Sim/Playback의 기준 일오차에서 벗어날 수 있는 허용 폭. 폭은 가장 엄격한 Witschi 등급 대역(Chronometer −2…+6 s/d)의 약 절반을 기준으로 둔다. **95%**는 실험으로 확정할 팀 목표.

**관련 FR** — FR-12-08, FR-05-17…18 (잡음 필터링·averaging)

### QAS-3 · Consistency — 표시 간 값 일치
> **한 줄 요약: 화면의 모든 숫자와 그래프는 같은 측정 결과에서 나온다.**
>
> 평소처럼 측정하는 동안 분석/계산 단계가 하나의 측정 결과를 여러 그래프·숫자 표시에 전달하면, 한 프레임에 함께 표시되는 모든 것이 그 단일 결과에서 파생되어 일치하며, 10분 실행 동안 **불일치 0회**이어야 한다.

**왜 이 속성인가**
- 플랜 §Correctness 원문: *"remaining internally consistent across the GUI, derived measurements, and longer-term summaries"* / *"calculations and visualizations are based on the same underlying data."*
- 그 절은 여러 요구의 묶음: 내부 일관성(→ **본 시나리오**)과 잡음 하 사용 가능(→ QAS-2). 본 시나리오는 일관성만 측정하므로 이름도 Consistency — Correctness라 부르면 나머지 부분까지 커버하는 듯한 과대 표기.

| 요소 | 내용 |
|------|------|
| 자극유발원 | 분석/계산 단계 (내부) |
| 자극 | 하나의 측정 결과가 여러 표시(그래프/숫자)로 전달됨 |
| 대상 | 수치 표시값과 그래프 표시 |
| 환경 | 평소처럼 측정 중 (검증은 Sim/Playback) |
| 응답 | 한 프레임에 함께 표시되는 모든 것이 하나의 결과에서 파생되어 일치 |
| 응답측정 | 알려진 기준 입력의 10분 실행 동안: 동시에 표시되는 모든 표시에서 **불일치 0회**(표시 반올림 이내); 각 표시는 소스 결과 식별자를 노출하여 검사 가능 |

**측정값 근거**
- **0** 이 유일하게 말이 되는 목표 — 일관성은 정합성 계열 속성이지 조정 가능한 수치가 아님.
- 각 표시가 어느 결과에서 왔는지 노출하므로 "0"을 실제로 검증 가능.

**관련 FR** — FR-12-05, FR-06-06, FR-02-07…08 (여러 뷰·요약이 같은 데이터를 표시)

### QAS-4 · Modifiability (Extensibility) — 새 측정/필터/그래프 추가
> **한 줄 요약: 새 그래프·필터·측정값 추가 = 한 곳만 고친다 — 기능당 8 person-days.**
>
> 일정이 촉박한 개발 중에 개발자가 코드베이스에 새 그래프·필터·측정값을 추가하려 할 때, 기존 코드를 뜯어고치지 않고 점진적으로 추가하며, 기존 모듈 변경 **≤ 1개**(공통 부분만) · 기능당 8 person-days이어야 한다.

**왜 이 속성인가**
- 플랜 원문(§Extensibility, Modifiability): *"support the addition of new measurements, filters, graphs, and display modes without major redesign of existing code."*
- **변경 요청**을 **건드리는 코드의 양**으로 측정 → SAP의 Modifiability 일반 시나리오이며, 척도(영향 모듈/위치 수)도 SAP 권장 그대로.

| 요소 | 내용 |
|------|------|
| 자극유발원 | 개발자 |
| 자극 | 새 그래프, 필터 단계, 또는 파생 측정값을 추가하려고 함 |
| 대상 | 측정·표시 기능을 담은 코드베이스 |
| 환경 | 개발 중, 일정이 촉박함 |
| 응답 | 기존 코드를 뜯어고치지 않고 점진적으로 추가함 |
| 응답측정 | 새 그래프/필터/측정값 각각: 기존 모듈 변경 ≤ 1개(공통 부분만), 기능당 8 person-days |

**측정값 근거**
- 3주 일정에 필수 기능 12종 — 좁은 변경 표면이어야만 가능한 일정.
- 마일스톤2/3 일정 (16일) * 조 인원 (6명) / 기능 수 (12) = 8 person-days effort

**관련 FR** — 모든 요구사항

### QAS-5 · Usability — 터치스크린에서 읽기·조작
> **한 줄 요약: 작은 1280×800 터치스크린에서도 핵심 값 3개를 한눈에 읽고 손가락으로 조작한다.**
>
> Raspberry Pi 5의 1280×800(8인치) 터치스크린에서 사용자가 GUI의 측정값을 읽고 모드를 전환할 때, 핵심 측정값을 가독성 있게 표시하고 주요 기능을 터치만으로 조작할 수 있으며, 일오차·비트오차·진폭 동시 표시 · 영어 대문자 글자 높이 ≥ 2.9 mm · 터치 타깃 ≥ 9 mm를 만족해야 한다. 물리 크기(mm)가 규범 기준.

**왜 이 속성인가**
- 플랜 원문(§Usability and User Purpose): *"The GUI should support ease of use by clearly showing … the calculated values that matter most to the user, such as rate, beat error, amplitude."*
- **사용자** 자극을 **가독성과 과업 시간**으로 측정 → SAP의 Usability 일반 시나리오. 터치 패널은 선택이 아니라 주어진 하드웨어.

| 요소 | 내용 |
|------|------|
| 자극유발원 | 사용자 (시계공 / 측정자) |
| 자극 | 터치스크린에서 측정값을 읽고 모드를 전환함 |
| 대상 | GUI (그래프/수치 표시와 컨트롤) |
| 환경 | Raspberry Pi 5 + 1280×800 터치 디스플레이; 패널 크기 8인치 |
| 응답 | 핵심 측정값을 가독성 있게 표시; 주요 기능을 터치만으로 조작 |
| 응답측정 | 일오차·비트오차·진폭을 스크롤/확대 없이 동시 표시; 영어 대문자 글자 높이 ≥ 2.9 mm, 터치 타깃 ≥ 9 mm |

**측정값 근거**
- **px가 아닌 mm** — 픽셀 기준은 패널에 따라 합격/불합격이 뒤바뀜; 9 mm는 통용되는 터치 타깃 크기.
- **영어 대문자 글자 높이 ≥ 2.9mm** — 화면 전체 가시성(SMPTE)·글자 가독성(ISO 9241-303)·터치 조작 여유를 고려해 설계 시야 거리를 보수적으로 50cm로 채택. 50cm에서 ISO 9241-303 권장 글자 크기 ≥ 20 arcmin을 환산하면 2.9mm — 시야 거리 기반 물리 크기로, 패널 해상도와 무관.
  - 계산: 20 arcmin = 20/60° = 0.333° ≈ 0.00582 rad → 글자 높이 = 시야 거리 × 시각 = 500 mm × 0.00582 ≈ **2.9 mm**
  - 본 패널 기준 px 환산 (8″ 1280×800 → √(1280²+800²)/8 ≈ 189 PPI, 1 px ≈ 0.135 mm): 글자 높이 2.9 mm ≈ **22 px**, 터치 타깃 9 mm ≈ **67 px** (참고용 — 규범 기준은 mm)

**관련 FR** — FR-06-06, FR-01-05, FR-04-03, FR-02-06, FR-06-11·13 (한눈에 읽기·포지션 표시·경보)

## 제약사항

| ID | 제약사항 |
|----|----------|
| C-1 | 시스템은 터치스크린이 연결된 Raspberry Pi 5(8 GB RAM, 128 GB microSD)에서 실행되어야 한다. |
| C-2 | 시스템은 Raspberry Pi 5에 연결된 1280×800 디스플레이에서 GUI를 올바르게 렌더링하고 동작해야 한다. |
| C-3 | 시스템은 Windows 11 (x64) PC와 Raspberry Pi OS(Debian 기반, 64-bit/ARM64)를 실행하는 Raspberry Pi 5 모두에서 실행되어야 한다. |
| C-4 | 시스템은 Auto Gain Control이 꺼진 상태에서 동작해야 한다. |

## 우선순위

ATAM 방식: 각 시나리오에 (**I**중요도, **D**난이도) 쌍을 부여(H/M/L). H/H 시나리오가 아키텍처를 가장 좌우한다.

| 순위 | QAS | 품질 속성 | I | D | 근거 |
|------|-----|----------|---|---|------|
| 1 | QAS-1 | Performance (Latency) | H | H | 결과가 빨리 떠야 하고, Pi 성능이 병목이 될 수 있음 |
| 2 | QAS-2 | Availability | H | H | 실제 사용 환경에서는 잡음이나 약한 신호가 자주 생길 수 있음 |
| 3 | QAS-3 | Consistency | H | M | 같은 측정 결과가 화면마다 다르게 보이면 안 됨 |
| 4 | QAS-4 | Modifiability | H | M | 아직 추가해야 할 기능이 많음 |
| 5 | QAS-5 | Usability | M | M | 작은 터치스크린이라 화면 배치가 제한됨 |

**정렬:** QAS-1과 QAS-2는 장치가 실제로 쓸 만한지에 직접 연결되므로 앞에 둔다. QAS-3과 QAS-4는 결과 신뢰성과 개발 진행을 지키는 항목이라 그다음이다. QAS-5도 중요하지만 위험은 비교적 제한적이다.
