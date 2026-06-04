# Milestone1 — QA Final 1

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

**Related FRs** — FR-08-01, FR-12-04, FR-05-03, FR-12-14 (real-time / Live display features)

### QAS-2 · Accuracy — Pinpointing Beats Precisely
> **In one line: locate each tick/tock to within 0.1 ms.**
>
> While measuring as usual, when a new beat (tick/tock) of the watch sound arrives at the beat-detection / time-calculation part, the system locates its onset/peak accurately and preserves timing precision through every stage — maximum error must be **≤ 0.1 ms** over ≥ 1,000 synthetic beats with known positions.

**Why this attribute**
- Plan §Measurement Accuracy: *"the software must accurately identify the start/onset and peak of the important acoustic signals."*
- The measure is **closeness to the true value** — that is Accuracy, not speed (Performance) and not display agreement (Consistency). Accuracy is outside SAP's catalog, so it is specified in the same six-part form per the textbook's guidance for other quality attributes.

| Element | Content |
|---------|---------|
| Source | Watch sound (external) |
| Stimulus | A new beat (tick/tock) arrives |
| Artifact | The beat-detection / time-calculation part |
| Environment | Measuring as usual; verified at 96,000 and 48,000 SPS |
| Response | Locate onset/peak accurately; preserve timing precision through every stage |
| Response Measure | Maximum onset/peak position error **≤ 0.1 ms** over ≥ 1,000 synthetic beats with known positions |

**Why these numbers**
- **0.1 ms** — equals the Witschi X1 beat-error spec.

**Related FRs** — FR-08-04…06, FR-05-13, FR-06-01…04 (beat markers and the values derived from them)

### QAS-3 · Availability (Graceful Degradation) — Under Noisy or Weak Signals
> **In one line: in noise, filter and measure correctly — and below the limit, say "signal weak" rather than show a wrong number.**
>
> In a noisy working environment, when watch sound mixed with ambient noise — or a weak signal — reaches the noise-removal / beat-detection part, the system detects and measures within tolerance and, below the quality threshold, shows "signal weak" instead of any value — detection **≥ 95 %** and rate error **≤ ±3 s/d** at SNR ≥ 14 dB.

**Why this attribute**
- Plan: *"the system should degrade gracefully when the signal is weak, noisy, or partially missing, rather than producing unstable or misleading outputs"* — and graceful degradation is a catalogued SAP **Availability** tactic.
- Both halves are about **continuing to deliver correct service under adverse conditions**: within tolerance while signal quality allows, and a graceful "signal weak" — never a wrong value — below the threshold. That is Availability.

| Element | Content |
|---------|---------|
| Source | Watch sound mixed with ambient noise / weak watch sound (external) |
| Stimulus | Noise mixes in, or the signal arrives weak |
| Artifact | The noise-removal / beat-detection part and the signal-quality indication |
| Environment | A noisy working environment, or Sim/Playback input with calibrated noise injected at a held-constant SNR |
| Response | Detect and measure within tolerance under noise; below the quality threshold show "signal weak" instead of any value |
| Response Measure | Against the generator's known schedule, over ≥ 1,000 beats: at SNR ≥ 14 dB, detection ≥ 95 % and rate error ≤ ±3 s/d; below threshold, "signal weak" only |

**Why these numbers**
- **14 dB** — ≥ 16 dB below the worst clean recording measured with the team's microphone (30–51 dB over 9 recordings): a severe condition reachable only by deliberate noise injection; provisional.
- **±3 s/d** — half-width of the tightest Witschi grade band (Chronometer −2…+6 s/d); **95 %** is a team target to confirm by experiment.

**Related FRs** — FR-12-08, FR-05-17…18 (noise filtering, averaging)

### QAS-4 · Consistency — Consistent Values Across Displays
> **In one line: every number and graph on screen comes from the same measurement result.**
>
> While measuring as usual, when the analysis/computation stage fans a single measurement result out to multiple graph and numeric displays, everything rendered in the same frame derives from that one result and agrees — **0 mismatches** over a 10-min run.

**Why this attribute**
- Plan §Correctness: *"remaining internally consistent across the GUI, derived measurements, and longer-term summaries"* — *"calculations and visualizations are based on the same underlying data."*
- That Plan section bundles three demands: event-position accuracy (→ QAS-2), stay internally consistent (→ **this scenario**), stay usable under noise (→ QAS-3). This scenario measures only consistency, so that is its name — "Correctness" would overclaim the other two.

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

### QAS-5 · Modifiability (Extensibility) — Adding a New Measurement/Filter/Graph
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

### QAS-6 · Usability — Reading and Operating on the Low-Resolution Touchscreen
> **In one line: on the small 800×480 touchscreen, the three key readings are readable at a glance and operable by finger.**
>
> On the Raspberry Pi 5's 800×480 (8-inch) touchscreen, when the user reads measurement values and switches modes in the GUI, key readings are shown legibly and primary functions operate by touch alone — rate / beat error / amplitude visible simultaneously, uppercase letter height ≥ 2.9 mm, touch targets ≥ 9 mm. Physical sizes (mm) are normative.

**Why this attribute**
- Plan §Usability and User Purpose: *"The GUI should support ease of use by clearly showing … the calculated values that matter most to the user, such as rate, beat error, amplitude."*
- A **user** stimulus measured by **legibility and task time** → SAP's Usability general scenario. The low-res touch panel is given hardware, not a choice.

| Element | Content |
|---------|---------|
| Source | User (watchmaker / operator) |
| Stimulus | Reads measurement values and switches modes on the touchscreen |
| Artifact | The GUI (graph/numeric displays and controls) |
| Environment | Raspberry Pi 5 + 800×480 touch display; 8-inch panel |
| Response | Show key readings legibly; make primary functions operable by touch |
| Response Measure | Rate / beat error / amplitude visible simultaneously without scroll/zoom; uppercase letter height ≥ 2.9 mm; touch targets ≥ 9 mm |

**Why these numbers**
- **mm, not px** — a pixel criterion flips pass/fail with the panel; 9 mm is the standard touch-target size.
- **Uppercase letter height ≥ 2.9 mm** — considering full-screen visibility (SMPTE), character legibility (ISO 9241-303), and room for touch operation, the design viewing distance is conservatively set to 50 cm. At 50 cm, ISO 9241-303's recommended glyph size of ≥ 20 arcmin converts to 2.9 mm on this panel (8″ 800×480).
  - Calculation: 20 arcmin = 20/60° = 0.333° ≈ 0.00582 rad → letter height = viewing distance × visual angle = 500 mm × 0.00582 ≈ **2.9 mm**

**Related FRs** — FR-06-06, FR-01-05, FR-04-03, FR-02-06, FR-06-11·13 (at-a-glance readings, position indication, alerts)

## Priority

ATAM style: each scenario carries a (**B**usiness importance, technical **R**isk) pair, H/M/L. The H/H scenarios shape the architecture most.

| Priority | QAS | Quality | B | R | Rationale |
|----------|-----|---------|---|---|-----------|
| 1 | QAS-1 | Performance (Latency) | H | H | The headline "real-time" driver; feasibility on the Pi is the stated project risk |
| 2 | QAS-2 | Accuracy | H | H | Every derived measure depends on event-position accuracy — the foundation |
| 3 | QAS-3 | Availability | H | H | Usable measurement in real environments; noise robustness builds on QAS-2 |
| 4 | QAS-4 | Consistency | H | M | Explicit Plan driver; the design solution (single source of truth) is well understood |
| 5 | QAS-5 | Modifiability | H | M | 12 features in 3 weeks demand cheap, incremental addition |
| 6 | QAS-6 | Usability | M | M | Fixed small panel; mostly layout discipline once sizes are pinned |

**Ordering:** the H/H group (QAS-1 · 2 · 3) leads — QAS-1 is the headline driver, and QAS-2 precedes QAS-3 because position accuracy is the foundation noise robustness builds on. Then QAS-4 (explicit Plan driver) over QAS-5; QAS-6 is the only B = M.

---

# Milestone1 — QA Final 1 (한국어)

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

### QAS-2 · Accuracy — 비트 위치 정밀 검출
> **한 줄 요약: 틱/톡 하나하나의 위치를 0.1 ms 오차 안에서 찾아낸다.**
>
> 평소처럼 측정하는 동안 시계 소리의 새 비트(틱/톡)가 비트 감지·시간 계산 부분에 도착하면, 시스템은 onset/peak 위치를 정확히 찾고 전 단계에서 시간 정밀도를 보존하며, 위치가 알려진 합성 비트 ≥ 1,000개에서 최대 오차 **≤ 0.1 ms**이어야 한다.

**왜 이 속성인가**
- 플랜 원문(§Measurement Accuracy): *"the software must accurately identify the start/onset and peak of the important acoustic signals."* — onset/peak의 정확한 식별을 직접 요구.
- 척도가 **참값에 얼마나 가까운가** → 빠르기(Performance)도 표시 일치(Consistency)도 아닌 Accuracy. SAP 카탈로그에 없는 속성이라, 교재의 '기타 품질 속성' 가이드대로 동일한 6-part 형식으로 기술.

| 요소 | 내용 |
|------|------|
| 자극유발원 | 시계 소리 (외부) |
| 자극 | 새 비트(틱/톡)가 도착함 |
| 대상 | 비트 감지 / 시간 계산 부분 |
| 환경 | 평소처럼 측정 중; 96,000과 48,000 SPS에서 검증 |
| 응답 | onset/peak 위치를 정확히 찾고, 전 단계에서 시간 정밀도를 보존함 |
| 응답측정 | 위치가 알려진 합성 비트 ≥ 1,000개에서 onset/peak 최대 오차 **≤ 0.1 ms** |

**측정값 근거**
- **0.1 ms** — Witschi X1의 beat error 스펙과 동일.

**관련 FR** — FR-08-04…06, FR-05-13, FR-06-01…04 (비트 마커와 거기서 파생되는 측정값)

### QAS-3 · Availability (Graceful Degradation) — 잡음·약신호 환경
> **한 줄 요약: 시끄러우면 걸러서 정확히 재고, 한계 아래면 틀린 값 대신 "신호 약함"을 보여준다.**
>
> 잡음이 포함된 열악한 작업 환경에서 잡음 섞인 시계 소리 또는 약한 시계 소리가 잡음 제거·비트 감지 부분에 들어오면, 시스템은 잡음 하에서 허용오차 내로 감지·측정하고 품질 임계 미만이면 잘못된 값 대신 "신호 약함"을 표시하며, SNR ≥ 14 dB에서 감지율 **≥ 95%** · 일오차 **≤ ±3 s/d**이어야 한다.

**왜 이 속성인가**
- 플랜 원문: *"the system should degrade gracefully when the signal is weak, noisy, or partially missing, rather than producing unstable or misleading outputs."* — graceful degradation은 SAP에 수록된 **Availability 전술**.
- 임계 이상에서는 허용오차 내 감지·측정을, 임계 미만에서는 우아한 성능 저하("신호 약함" ≠ 잘못된 값)를 게이트 — 둘 다 **악조건에서도 올바른 서비스를 계속 제공하는 능력** → Availability.

| 요소 | 내용 |
|------|------|
| 자극유발원 | 주변 잡음이 포함된 시계 소리 / 약한 시계 소리 (외부) |
| 자극 | 잡음이 섞이거나 신호가 약하게 들어옴 |
| 대상 | 잡음 제거 / 비트 감지 부분과 신호 품질 표시 |
| 환경 | 주변 잡음이 포함된 열악한 작업 환경 or Sim/Playback 입력에 보정된 잡음을 일정 SNR로 주입한 데이터 |
| 응답 | 잡음 하에서 허용오차 내로 감지·측정; 품질 임계 미만이면 어떤 값도 아닌 "신호 약함"을 표시 |
| 응답측정 | 생성기의 알려진 스케줄 대비, 1,000비트 이상: SNR ≥ 14 dB에서 감지율 ≥ 95%, 일오차 ≤ ±3 s/d; 임계 미만에서는 "신호 약함"만 표시 |

**측정값 근거**
- **14 dB** — 팀 마이크로 실측한 최악 클린 녹음(9개, 30–51 dB)보다 ≥ 16 dB 낮은 심한 조건 — 의도적 잡음 주입으로만 도달; 잠정값.
- **±3 s/d** — 가장 엄격한 Witschi 등급 대역(Chronometer −2…+6 s/d)의 반폭; **95%**는 실험으로 확정할 팀 목표.

**관련 FR** — FR-12-08, FR-05-17…18 (잡음 필터링·averaging)

### QAS-4 · Consistency — 표시 간 값 일치
> **한 줄 요약: 화면의 모든 숫자와 그래프는 같은 측정 결과에서 나온다.**
>
> 평소처럼 측정하는 동안 분석/계산 단계가 하나의 측정 결과를 여러 그래프·숫자 표시에 전달하면, 한 프레임에 함께 표시되는 모든 것이 그 단일 결과에서 파생되어 일치하며, 10분 실행 동안 **불일치 0회**이어야 한다.

**왜 이 속성인가**
- 플랜 §Correctness 원문: *"remaining internally consistent across the GUI, derived measurements, and longer-term summaries"* / *"calculations and visualizations are based on the same underlying data."*
- 그 절은 세 요구의 묶음: 이벤트 위치 정확도(→ QAS-2), 내부 일관성(→ **본 시나리오**), 잡음 하 사용 가능(→ QAS-3). 본 시나리오는 일관성만 측정하므로 이름도 Consistency — Correctness라 부르면 나머지 둘까지 커버하는 듯한 과대 표기.

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

### QAS-5 · Modifiability (Extensibility) — 새 측정/필터/그래프 추가
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

### QAS-6 · Usability — 저해상도 터치스크린에서 읽기·조작
> **한 줄 요약: 작은 800×480 터치스크린에서도 핵심 값 3개를 한눈에 읽고 손가락으로 조작한다.**
>
> Raspberry Pi 5의 800×480(8인치) 터치스크린에서 사용자가 GUI의 측정값을 읽고 모드를 전환할 때, 핵심 측정값을 가독성 있게 표시하고 주요 기능을 터치만으로 조작할 수 있으며, 일오차·비트오차·진폭 동시 표시 · 영어 대문자 글자 높이 ≥ 2.9 mm · 터치 타깃 ≥ 9 mm를 만족해야 한다. 물리 크기(mm)가 규범 기준.

**왜 이 속성인가**
- 플랜 원문(§Usability and User Purpose): *"The GUI should support ease of use by clearly showing … the calculated values that matter most to the user, such as rate, beat error, amplitude."*
- **사용자** 자극을 **가독성과 과업 시간**으로 측정 → SAP의 Usability 일반 시나리오. 저해상도 터치 패널은 선택이 아니라 주어진 하드웨어.

| 요소 | 내용 |
|------|------|
| 자극유발원 | 사용자 (시계공 / 측정자) |
| 자극 | 터치스크린에서 측정값을 읽고 모드를 전환함 |
| 대상 | GUI (그래프/수치 표시와 컨트롤) |
| 환경 | Raspberry Pi 5 + 800×480 터치 디스플레이; 패널 크기 8인치 |
| 응답 | 핵심 측정값을 가독성 있게 표시; 주요 기능을 터치만으로 조작 |
| 응답측정 | 일오차·비트오차·진폭을 스크롤/확대 없이 동시 표시; 영어 대문자 글자 높이 ≥ 2.9 mm, 터치 타깃 ≥ 9 mm |

**측정값 근거**
- **px가 아닌 mm** — 픽셀 기준은 패널에 따라 합격/불합격이 뒤바뀜; 9 mm는 통용되는 터치 타깃 크기.
- **영어 대문자 글자 높이 ≥ 2.9mm** — 화면 전체 가시성(SMPTE)·글자 가독성(ISO 9241-303)·터치 조작 여유를 고려해 설계 시야 거리를 보수적으로 50cm로 채택. 50cm에서 ISO 9241-303 권장 글자 크기 ≥ 20 arcmin을 본 패널(8″ 800×480)로 환산하면 2.9mm.
  - 계산: 20 arcmin = 20/60° = 0.333° ≈ 0.00582 rad → 글자 높이 = 시야 거리 × 시각 = 500 mm × 0.00582 ≈ **2.9 mm**

**관련 FR** — FR-06-06, FR-01-05, FR-04-03, FR-02-06, FR-06-11·13 (한눈에 읽기·포지션 표시·경보)

## 우선순위

ATAM 방식: 각 시나리오에 (**B**비즈니스 중요도, 기술 리스크 **R**) 쌍을 부여(H/M/L). H/H 시나리오가 아키텍처를 가장 좌우한다.

| 순위 | QAS | 품질 속성 | B | R | 근거 |
|------|-----|----------|---|---|------|
| 1 | QAS-1 | Performance (Latency) | H | H | 대표 "real-time" 드라이버; Pi에서의 실현 가능성이 명시된 리스크 |
| 2 | QAS-2 | Accuracy | H | H | 모든 파생 측정값이 이벤트 위치 정확도에 의존 — 토대 |
| 3 | QAS-3 | Availability | H | H | 실제 환경에서 쓸 수 있는 측정; QAS-2 위에 쌓이는 잡음 강건성 |
| 4 | QAS-4 | Consistency | H | M | 플랜 명시 드라이버; 해법(single source of truth)은 잘 알려짐 |
| 5 | QAS-5 | Modifiability | H | M | 3주에 기능 12종 — 저비용·점진적 추가가 필수 |
| 6 | QAS-6 | Usability | M | M | 고정 소형 패널; 크기 확정 후엔 주로 레이아웃 규율 문제 |

**정렬:** H/H 그룹(QAS-1 · 2 · 3)이 선두 — QAS-1은 헤드라인 드라이버, QAS-2가 QAS-3보다 앞서는 이유는 위치 정확도가 잡음 강건성의 토대이기 때문. 그다음 플랜 명시 드라이버인 QAS-4가 QAS-5보다 앞; QAS-6은 유일한 B = M.
