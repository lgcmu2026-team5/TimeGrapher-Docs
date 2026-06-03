# Milestone1 — QA Final 1

> English version above, Korean version below. (위쪽은 영어 버전, 아래쪽은 한국어 버전입니다.)

## Quality Attribute Scenarios

### QAS-1 · Performance (Latency) — From Sound Input to Screen Display
> **In one line: sound reaches the microphone → the result is on screen within 0.5 s.**
>
> While measuring on the target platform, when sound arrives at the microphone, the system processes and displays it with end-to-end p99 latency ≤ 500 ms. Latency is measured at three boundaries and reported as (1) processing latency, (2) display latency, (3) processing+display latency. Keeping up with the input (0 dropped blocks / 0 missed beats) is a separately verified precondition.

**Why this attribute**
- The Plan demands it — and even prescribes the three-part split: *"Teams shall report capture-to-processing latency, processing-to-display latency, and total end-to-end latency in milliseconds."*
- An event arrives and the response is measured in **time** → that is Performance (Latency) by SAP's definition.

| Element | Content |
|---------|---------|
| Source | The microphone / watch (external) |
| Stimulus | Sound arrives at the microphone |
| Artifact | The input → analysis → display flow, timestamped at capture · analysis-done · on-screen |
| Environment | Live on the Raspberry Pi 5 (8 GB), 96,000 SPS objective (must also hold at the 48,000 SPS minimum), GUI active |
| Response | Process, show on screen, and report the three latency components |
| Response Measure | Over a 10-min run: (1) processing latency — p99 reported; (2) display latency — p99 reported; (3) end-to-end — **p99 ≤ 500 ms** (the pass/fail gate) |

**Why these numbers**
- **≤ 500 ms** — per Google's INP (Interaction to Next Paint) thresholds, 500 ms is the last value before a response is rated "poor" (good ≤ 200 ms · needs improvement ≤ 500 ms · poor > 500 ms); adopted as the maximum allowable limit for the final display update.

**Related FRs** — FR-08-01, FR-12-04, FR-05-03, FR-12-14 (real-time / Live display features)

### QAS-2 · Accuracy — Pinpointing Beats Precisely
> **In one line: locate each tick/tock to within 0.1 ms.**
>
> When a new beat arrives, the system finds its onset and peak positions within ≤ 0.1 ms and preserves timing precision through every processing stage. Verified on synthetic signals with known positions — real hardware cannot supply 0.1 ms ground truth.

**Why this attribute**
- Plan §Measurement Accuracy: *"the software must accurately identify the start/onset and peak of the important acoustic signals."*
- The measure is **closeness to the true value** — that is Accuracy, not speed (Performance) and not display agreement (Consistency). Accuracy is outside SAP's catalog, so it is specified in the same six-part form per the textbook's guidance for other quality attributes.

| Element | Content |
|---------|---------|
| Source | Watch beat (external input stream) |
| Stimulus | A new beat (tick/tock) arrives |
| Artifact | The beat-detection / time-calculation part |
| Environment | Measuring as usual; verified at 96,000 and 48,000 SPS |
| Response | Locate onset/peak accurately; preserve timing precision through every stage |
| Response Measure | Maximum onset/peak position error **≤ 0.1 ms** over ≥ 1,000 synthetic beats with known positions; at 48,000 SPS that is 4.8 samples → sub-sample interpolation required |

**Why these numbers**
- **0.1 ms** — equals the Witschi X1 beat-error spec, and ≈ 1/6 of the Plan's 0.6 ms "good" bound, so meaningful differences stay visible.
- Feasible: the baseline detector already interpolates below one sample.

**Related FRs** — FR-08-04…06, FR-05-13, FR-06-01…04 (beat markers and the values derived from them)

### QAS-3 · Availability (Graceful Degradation) — Under Noisy or Weak Signals
> **In one line: in noise, filter and measure correctly — and below the limit, say "signal weak" rather than show a wrong number.**
>
> In a noisy or weak-signal environment, the system reduces extraneous noise (e.g., nearby speech) while preserving the watch features needed for detection. At SNR ≥ 14 dB it still detects ≥ 95 % of beats with rate error ≤ ±3 s/d; below the threshold it shows "signal weak" only — 0 wrong values, and invalid results are excluded from X/D summaries.

**Why this attribute**
- Plan: *"the system should degrade gracefully when the signal is weak, noisy, or partially missing, rather than producing unstable or misleading outputs"* — and graceful degradation is a catalogued SAP **Availability** tactic.
- Both halves are about **continuing to deliver correct service under adverse conditions**: within tolerance while signal quality allows, and a graceful "signal weak" — never a wrong value — below the threshold. That is Availability.

| Element | Content |
|---------|---------|
| Source | Ambient noise / weak signal (external) |
| Stimulus | Noise mixes in, or the signal arrives weak |
| Artifact | The noise-removal / beat-detection part and the signal-quality indication |
| Environment | Noisy bench, reproduced by injecting calibrated noise into Sim/Playback input at a held-constant SNR |
| Response | Detect and measure within tolerance under noise; below the quality threshold show "signal weak" instead of any value; exclude invalid results from X/D |
| Response Measure | Against the generator's known schedule, over ≥ 1,000 beats: at SNR ≥ 14 dB, detection ≥ 95 % and rate error ≤ ±3 s/d; below threshold, "signal weak" only and **0 wrong values**; invalid values included in X/D = 0 |

**Why these numbers**
- **14 dB** — ≥ 16 dB below the worst clean recording measured with the team's microphone (30–51 dB over 9 recordings): a severe condition reachable only by deliberate noise injection; provisional.
- **±3 s/d** — half-width of the tightest Witschi grade band (Chronometer −2…+6 s/d); **95 %** is a team target to confirm by experiment.
- Ground truth = synthetic beats + injected noise — a reference instrument hears the same noise, so it cannot serve as the truth.

**Related FRs** — FR-12-08, FR-05-17…18, FR-04-06 (noise filtering, averaging, excluding invalid results)

### QAS-4 · Consistency — Consistent Values Across Displays
> **In one line: every number and graph on screen comes from the same measurement result.**
>
> When a single measurement result fans out to multiple graphs and numbers, everything rendered in the same frame derives from that one result and agrees — 0 mismatches, including the X/D summaries.

**Why this attribute**
- Plan §Correctness: *"remaining internally consistent across the GUI, derived measurements, and longer-term summaries"* — *"calculations and visualizations are based on the same underlying data."*
- That Plan section bundles three demands: compute correctly (→ QAS-2), stay internally consistent (→ **this scenario**), stay usable under noise (→ QAS-3). This scenario measures only consistency, so that is its name — "Correctness" would overclaim the other two.

| Element | Content |
|---------|---------|
| Source | The analysis/computation stage (internal) |
| Stimulus | One measurement result fans out to multiple displays (graphs/numbers) |
| Artifact | Numeric readouts and graph displays |
| Environment | Measuring as usual (verified via Sim/Playback) |
| Response | Everything shown in one frame derives from one result and agrees; X/D summaries derive from the displayed per-position results |
| Response Measure | Over a 10-min run on known input: **0 mismatches** across all simultaneously shown displays (within display rounding); each display exposes its source-result identity, so the check is observable; X/D source mismatch = 0 |

**Why these numbers**
- **0** is the only sensible target — consistency is a correctness-class property, not a tunable number.
- The check is genuinely verifiable because each display exposes which result it came from.

**Related FRs** — FR-12-05, FR-06-06, FR-04-05…07, FR-02-07…08 (views and summaries showing the same data)

### QAS-5 · Modifiability (Extensibility) — Adding a New Measurement/Filter/Graph
> **In one line: adding a new graph, filter, or measurement touches one registration point — and breaks nothing.**
>
> Under the tight project schedule, a developer can add a new graph, filter stage, or derived measurement incrementally, within a per-kind change budget and with zero regressions.

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
| Response Measure | New graph: ≤ 1 existing module changed (registration/wiring only). New filter: ≤ 1 pipeline registration point. New measurement: ≤ 1 calculation-registry change. All kinds: **0 regressions** — the regression test set passes before and after |

**Why these numbers**
- ~11 mandatory graphs in a 5-week schedule — only a bounded touch surface makes that feasible.
- "0 regressions" is tied to a concrete detection method (the test set), not just declared.

**Related FRs** — G01–G12 overall; e.g., FR-05-01 (new tab), FR-12-01 (new filters), FR-04-06…07 (new measurements)

### QAS-6 · Usability — Reading and Operating on the Low-Resolution Touchscreen
> **In one line: on the small 800×480 touchscreen, the three key readings are readable at a glance and operable by finger.**
>
> On the Raspberry Pi's 800×480 touchscreen, the key readings (rate, beat error, amplitude) are legible without scrolling or zooming, and primary functions work by touch alone. Physical sizes (mm) are normative; pixel values are advisory until the panel size is confirmed.

**Why this attribute**
- Plan §Usability and User Purpose: *"The GUI should support ease of use by clearly showing … the calculated values that matter most to the user, such as rate, beat error, amplitude."*
- A **user** stimulus measured by **legibility and task time** → SAP's Usability general scenario. The low-res touch panel is given hardware, not a choice.

| Element | Content |
|---------|---------|
| Source | User (watchmaker / operator) |
| Stimulus | Reads measurement values and switches modes on the touchscreen |
| Artifact | The GUI (graph/numeric displays and controls) |
| Environment | Raspberry Pi 5 + 800×480 touch display; panel physical size unconfirmed (the Plan states both 8-inch and 5-inch); the baseline GUI is fixed at 1280×750, so re-layout is required work |
| Response | Show key readings legibly; make primary functions operable by touch; show the active position and X/D near the related values |
| Response Measure | Rate / beat error / amplitude visible simultaneously without scroll/zoom; glyph height ≥ 1.9 mm and contrast ≥ 4.5:1; touch targets ≥ 9 mm; any primary mode within ≤ 2 taps; in a timed task with ≥ 3 users, active position found ≤ 5 s and X/D ≤ 10 s in ≥ 90 % of trials |

**Why these numbers**
- **mm, not px** — the Plan states both 8-inch and 5-inch panels, so a pixel criterion would change pass/fail with the panel; 9 mm is the standard touch-target size.
- **1.9 mm glyphs + 4.5:1 contrast** — replaces vague "readable" with a perception spec verifiable without test subjects.
- **≤ 2 taps, 5 s / 10 s tasks** — team criteria that make "easy to use" measurable.

**Related FRs** — FR-06-06, FR-01-05, FR-04-03, FR-02-06, FR-06-11·13 (at-a-glance readings, position indication, alerts)

## Priority

ATAM style: each scenario carries a (**B**usiness importance, technical **R**isk) pair, H/M/L. The H/H scenarios shape the architecture most.

| Priority | QAS | Quality | B | R | Rationale |
|----------|-----|---------|---|---|-----------|
| 1 | QAS-1 | Performance (Latency) | H | H | The headline "real-time" driver; feasibility on the Pi is the stated project risk |
| 2 | QAS-2 | Accuracy | H | H | Every derived measure depends on event-position accuracy — the foundation |
| 3 | QAS-3 | Availability | H | H | Usable measurement in real environments; noise robustness builds on QAS-2 |
| 4 | QAS-4 | Consistency | H | M | Explicit Plan driver; the design solution (single source of truth) is well understood |
| 5 | QAS-5 | Modifiability | H | M | 11 graphs in 5 weeks demand cheap, regression-free addition |
| 6 | QAS-6 | Usability | M | M | Fixed small panel; mostly layout discipline once sizes are pinned |

**Ordering:** the H/H group (QAS-1 · 2 · 3) leads — QAS-1 is the headline driver, and QAS-2 precedes QAS-3 because position accuracy is the foundation noise robustness builds on. Then QAS-4 (explicit Plan driver) over QAS-5; QAS-6 is the only B = M.

---

# Milestone1 — QA Final 1 (한국어)

## Quality Attribute Scenarios

### QAS-1 · Performance (Latency) — 소리 입력에서 화면 표시까지
> **한 줄 요약: 소리가 마이크에 들어오면 0.5초 안에 화면에 나타난다.**
>
> 타깃 플랫폼에서 측정하는 동안 마이크로 소리가 들어오면, 시스템은 종단 p99 지연 ≤ 500 ms로 처리·표시한다. 지연은 세 경계에서 측정하여 (1) processing latency, (2) display latency, (3) processing+display latency로 보고한다. 입력 따라가기(블록 드롭 0·비트 누락 0)는 별도로 검증되는 전제 조건이다.

**왜 이 속성인가**
- 플랜이 직접 요구하며, 3구간 분해까지 지정한다: *"Teams shall report capture-to-processing latency, processing-to-display latency, and total end-to-end latency in milliseconds."*
- 이벤트가 도착하고 응답을 **시간**으로 측정 → SAP 정의 그대로 Performance (Latency).

| 요소 | 내용 |
|------|------|
| 출처 | 마이크 / 시계 (외부) |
| 자극 | 마이크로 소리가 들어옴 |
| 대상 산출물 | 입력 → 분석 → 표시 흐름 — 캡처 · 분석 완료 · 화면 표시 시점에 타임스탬프 |
| 환경 | Raspberry Pi 5(8 GB)에서 Live 측정, 96,000 SPS 목표(48,000 SPS 최소에서도 충족), GUI 활성 |
| 응답 | 처리하여 화면에 표시하고, 세 지연 구간을 보고함 |
| 응답 척도 | 10분 연속 실행 동안: (1) processing latency — p99 보고; (2) display latency — p99 보고; (3) 종단 — **p99 ≤ 500 ms** (pass/fail 게이트) |

**측정값 근거**
- **≤ 500 ms** — Google INP(Interaction to Next Paint) 기준에서 "poor"로 넘어가기 직전 값(good ≤ 200 ms · needs improvement ≤ 500 ms · poor > 500 ms); 최종 디스플레이 갱신의 최대 허용 한계값으로 채택.

**관련 FR** — FR-08-01, FR-12-04, FR-05-03, FR-12-14 (실시간/Live 표시 기능)

### QAS-2 · Accuracy — 비트 위치 정밀 검출
> **한 줄 요약: 틱/톡 하나하나의 위치를 0.1 ms 오차 안에서 찾아낸다.**
>
> 새 비트가 도착하면 시스템은 onset과 peak 위치를 ≤ 0.1 ms 오차로 찾아내고, 모든 처리 단계에서 시간 정밀도를 보존한다. 0.1 ms 정답은 실제 하드웨어로 얻을 수 없으므로 위치가 알려진 합성 신호로 검증한다.

**왜 이 속성인가**
- 플랜 원문(§Measurement Accuracy): *"the software must accurately identify the start/onset and peak of the important acoustic signals."* — onset/peak의 정확한 식별을 직접 요구.
- 척도가 **참값에 얼마나 가까운가** → 빠르기(Performance)도 표시 일치(Consistency)도 아닌 Accuracy. SAP 카탈로그에 없는 속성이라, 교재의 '기타 품질 속성' 가이드대로 동일한 6-part 형식으로 기술.

| 요소 | 내용 |
|------|------|
| 출처 | 시계 비트 (외부 입력 스트림) |
| 자극 | 새 비트(틱/톡)가 도착함 |
| 대상 산출물 | 비트 감지 / 시간 계산 부분 |
| 환경 | 평소처럼 측정 중; 96,000과 48,000 SPS에서 검증 |
| 응답 | onset/peak 위치를 정확히 찾고, 전 단계에서 시간 정밀도를 보존함 |
| 응답 척도 | 위치가 알려진 합성 비트 ≥ 1,000개에서 onset/peak 최대 오차 **≤ 0.1 ms**; 48,000 SPS에서는 4.8샘플 → 서브샘플 보간 필요 |

**측정값 근거**
- **0.1 ms** — Witschi X1의 beat error 스펙과 동일하고, 플랜의 0.6 ms "양호" 기준의 약 1/6 → 의미 있는 차이를 구분 가능.
- 실현 가능: 베이스라인 검출기가 이미 서브샘플 보간을 수행.

**관련 FR** — FR-08-04…06, FR-05-13, FR-06-01…04 (비트 마커와 거기서 파생되는 측정값)

### QAS-3 · Availability (Graceful Degradation) — 잡음·약신호 환경
> **한 줄 요약: 시끄러우면 걸러서 정확히 재고, 한계 아래면 틀린 값 대신 "신호 약함"을 보여준다.**
>
> 잡음이 섞이거나 신호가 약한 환경에서, 시스템은 검출에 필요한 시계 신호 특징은 보존하면서 주변 대화 같은 불요 잡음을 줄인다. SNR ≥ 14 dB에서는 비트 감지율 ≥ 95%, 일오차 ≤ ±3 s/d를 유지하고; 임계 미만에서는 "신호 약함"만 표시한다 — 잘못된 값 0회, invalid 결과는 X/D summary에서 제외.

**왜 이 속성인가**
- 플랜 원문: *"the system should degrade gracefully when the signal is weak, noisy, or partially missing, rather than producing unstable or misleading outputs."* — graceful degradation은 SAP에 수록된 **Availability 전술**.
- 임계 이상에서는 허용오차 내 감지·측정을, 임계 미만에서는 우아한 성능 저하("신호 약함" ≠ 잘못된 값)를 게이트 — 둘 다 **악조건에서도 올바른 서비스를 계속 제공하는 능력** → Availability.

| 요소 | 내용 |
|------|------|
| 출처 | 주변 잡음 / 약한 신호 (외부) |
| 자극 | 잡음이 섞이거나 신호가 약하게 들어옴 |
| 대상 산출물 | 잡음 제거 / 비트 감지 부분과 신호 품질 표시 |
| 환경 | 열악한 작업 환경 — Sim/Playback 입력에 보정된 잡음을 일정 SNR로 주입하여 재현 |
| 응답 | 잡음 하에서 허용오차 내로 감지·측정; 품질 임계 미만이면 어떤 값도 아닌 "신호 약함"을 표시; invalid 결과는 X/D에서 제외 |
| 응답 척도 | 생성기의 기지 스케줄 대비, 1,000비트 이상: SNR ≥ 14 dB에서 감지율 ≥ 95%, 일오차 ≤ ±3 s/d; 임계 미만에서는 "신호 약함"만 표시, **잘못된 값 0회**; invalid 값의 X/D 포함 0건 |

**측정값 근거**
- **14 dB** — 팀 마이크로 실측한 최악 클린 녹음(9개, 30–51 dB)보다 ≥ 16 dB 낮은 심한 조건 — 의도적 잡음 주입으로만 도달; 잠정값.
- **±3 s/d** — 가장 엄격한 Witschi 등급 대역(Chronometer −2…+6 s/d)의 반폭; **95%**는 실험으로 확정할 팀 목표.
- 정답 = 합성 신호 + 주입 잡음 — 기준 장비도 같은 잡음을 듣기 때문에 정답이 될 수 없음.

**관련 FR** — FR-12-08, FR-05-17…18, FR-04-06 (잡음 필터링·averaging·invalid 제외)

### QAS-4 · Consistency — 표시 간 값 일치
> **한 줄 요약: 화면의 모든 숫자와 그래프는 같은 측정 결과에서 나온다.**
>
> 하나의 측정 결과가 여러 그래프와 숫자로 전달될 때, 한 프레임에 함께 렌더링되는 모든 표시는 그 단일 결과에서 파생되어 일치한다 — 불일치 0회, X/D summary 포함.

**왜 이 속성인가**
- 플랜 §Correctness 원문: *"remaining internally consistent across the GUI, derived measurements, and longer-term summaries"* / *"calculations and visualizations are based on the same underlying data."*
- 그 절은 세 요구의 묶음: 올바른 계산(→ QAS-2), 내부 일관성(→ **본 시나리오**), 잡음 하 사용 가능(→ QAS-3). 본 시나리오는 일관성만 측정하므로 이름도 Consistency — Correctness라 부르면 나머지 둘까지 커버하는 듯한 과대 표기.

| 요소 | 내용 |
|------|------|
| 출처 | 분석/계산 단계 (내부) |
| 자극 | 하나의 측정 결과가 여러 표시(그래프/숫자)로 전달됨 |
| 대상 산출물 | 수치 표시값과 그래프 표시 |
| 환경 | 평소처럼 측정 중 (검증은 Sim/Playback) |
| 응답 | 한 프레임에 함께 표시되는 모든 것이 하나의 결과에서 파생되어 일치; X/D summary도 표시된 position별 결과에서 산출 |
| 응답 척도 | 기지 입력의 10분 실행 동안: 동시에 표시되는 모든 표시에서 **불일치 0회**(표시 반올림 이내); 각 표시는 소스 결과 식별자를 노출하여 검사 가능; X/D source mismatch 0건 |

**측정값 근거**
- **0** 이 유일하게 말이 되는 목표 — 일관성은 정합성 계열 속성이지 조정 가능한 수치가 아님.
- 각 표시가 어느 결과에서 왔는지 노출하므로 "0"을 실제로 검증 가능.

**관련 FR** — FR-12-05, FR-06-06, FR-04-05…07, FR-02-07…08 (여러 뷰·요약이 같은 데이터를 표시)

### QAS-5 · Modifiability (Extensibility) — 새 측정/필터/그래프 추가
> **한 줄 요약: 새 그래프·필터·측정값 추가 = 등록 지점 한 곳만 고치고, 기존 기능은 깨지지 않는다.**
>
> 촉박한 일정에서 개발자가 새 그래프·필터 단계·파생 측정값을 추가할 때, 종류별 변경 예산 안에서 점진적으로 추가하며 회귀는 0건이다.

**왜 이 속성인가**
- 플랜 원문(§Extensibility, Modifiability): *"support the addition of new measurements, filters, graphs, and display modes without major redesign of existing code."*
- **변경 요청**을 **건드리는 코드의 양**으로 측정 → SAP의 Modifiability 일반 시나리오이며, 척도(영향 모듈/위치 수)도 SAP 권장 그대로.

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 |
| 자극 | 새 그래프, 필터 단계, 또는 파생 측정값을 추가하려고 함 |
| 대상 산출물 | 측정·표시 기능을 담은 코드베이스 |
| 환경 | 개발 중, 일정이 촉박함 |
| 응답 | 기존 코드를 뜯어고치지 않고 점진적으로 추가함 |
| 응답 척도 | 새 그래프: 기존 모듈 변경 ≤ 1개(등록/배선부만). 새 필터: 파이프라인 등록 지점 ≤ 1개. 새 측정값: 계산 레지스트리 변경 ≤ 1개. 전 종류: **회귀 0건** — 회귀 테스트 셋이 변경 전후 모두 통과 |

**측정값 근거**
- 5주 일정에 필수 그래프 약 11종 — 좁은 변경 표면이어야만 가능한 일정.
- "회귀 0건"은 구체적 검출 수단(테스트 셋)에 묶여 있음 — 선언만 하는 0이 아님.

**관련 FR** — G01–G12 전체; 예: FR-05-01(새 탭), FR-12-01(새 필터), FR-04-06…07(새 측정값)

### QAS-6 · Usability — 저해상도 터치스크린에서 읽기·조작
> **한 줄 요약: 작은 800×480 터치스크린에서도 핵심 값 3개를 한눈에 읽고 손가락으로 조작한다.**
>
> Raspberry Pi의 800×480 터치스크린에서 핵심 측정값(일오차·비트오차·진폭)은 스크롤/확대 없이 읽히고, 주요 기능은 터치만으로 동작한다. 물리 크기(mm)가 규범 기준이며, 픽셀 값은 패널 크기 확정 전까지 참고용.

**왜 이 속성인가**
- 플랜 원문(§Usability and User Purpose): *"The GUI should support ease of use by clearly showing … the calculated values that matter most to the user, such as rate, beat error, amplitude."*
- **사용자** 자극을 **가독성과 과업 시간**으로 측정 → SAP의 Usability 일반 시나리오. 저해상도 터치 패널은 선택이 아니라 주어진 하드웨어.

| 요소 | 내용 |
|------|------|
| 출처 | 사용자 (시계공 / 측정자) |
| 자극 | 터치스크린에서 측정값을 읽고 모드를 전환함 |
| 대상 산출물 | GUI (그래프/수치 표시와 컨트롤) |
| 환경 | Raspberry Pi 5 + 800×480 터치 디스플레이; 패널 물리 크기 미확정(플랜이 8인치와 5인치를 모두 기술); 베이스라인 GUI는 1280×750 고정이라 재레이아웃 필수 |
| 응답 | 핵심 측정값을 가독성 있게 표시; 주요 기능을 터치만으로 조작; active position과 X/D를 관련 값 근처에 표시 |
| 응답 척도 | 일오차·비트오차·진폭을 스크롤/확대 없이 동시 표시; 글리프 높이 ≥ 1.9 mm, 대비 ≥ 4.5:1; 터치 타깃 ≥ 9 mm; 주요 모드 도달 ≤ 2 탭; 대표 사용자 ≥ 3명의 시간 측정 과업에서 시도의 ≥ 90%에서 active position 5초 이내, X/D 10초 이내 식별 |

**측정값 근거**
- **px가 아닌 mm** — 플랜이 8인치와 5인치를 모두 기술하므로 픽셀 기준은 패널에 따라 합격/불합격이 뒤바뀜; 9 mm는 통용되는 터치 타깃 크기.
- **글리프 1.9 mm + 대비 4.5:1** — 막연한 "읽기 좋게"를 피험자 없이 검증 가능한 지각 사양으로 교체.
- **≤ 2 탭, 5초/10초 과업** — "쓰기 쉽다"를 측정 가능하게 만드는 팀 기준.

**관련 FR** — FR-06-06, FR-01-05, FR-04-03, FR-02-06, FR-06-11·13 (한눈에 읽기·포지션 표시·경보)

## 우선순위

ATAM 방식: 각 시나리오에 (**B**비즈니스 중요도, 기술 리스크 **R**) 쌍을 부여(H/M/L). H/H 시나리오가 아키텍처를 가장 좌우한다.

| 순위 | QAS | 품질 속성 | B | R | 근거 |
|------|-----|----------|---|---|------|
| 1 | QAS-1 | Performance (Latency) | H | H | 대표 "real-time" 드라이버; Pi에서의 실현 가능성이 명시된 리스크 |
| 2 | QAS-2 | Accuracy | H | H | 모든 파생 측정값이 이벤트 위치 정확도에 의존 — 토대 |
| 3 | QAS-3 | Availability | H | H | 실제 환경에서 쓸 수 있는 측정; QAS-2 위에 쌓이는 잡음 강건성 |
| 4 | QAS-4 | Consistency | H | M | 플랜 명시 드라이버; 해법(single source of truth)은 잘 알려짐 |
| 5 | QAS-5 | Modifiability | H | M | 5주에 그래프 11종 — 저비용·무회귀 추가가 필수 |
| 6 | QAS-6 | Usability | M | M | 고정 소형 패널; 크기 확정 후엔 주로 레이아웃 규율 문제 |

**정렬:** H/H 그룹(QAS-1 · 2 · 3)이 선두 — QAS-1은 헤드라인 드라이버, QAS-2가 QAS-3보다 앞서는 이유는 위치 정확도가 잡음 강건성의 토대이기 때문. 그다음 플랜 명시 드라이버인 QAS-4가 QAS-5보다 앞; QAS-6은 유일한 B = M.
