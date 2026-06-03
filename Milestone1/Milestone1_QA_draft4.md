# Milestone1 Jae-hong Oh — QA draft 4 (Selected Scenarios)

> English version above, Korean version below. (위쪽은 영어 버전, 아래쪽은 한국어 버전입니다.)
>
> **draft 4 (2026-06-03)** — Per instructor guidance, this draft selects **7 of the 15 scenarios** in draft 3 and presents them concisely: the goal is to demonstrate command of the taught framework — SAP (*Software Architecture in Practice*, Bass · Clements · Kazman; the SEI 6-part Quality Attribute Scenario) — rather than exhaustive coverage. Each selected scenario is rewritten to be self-contained. The full set (15 QAS + scope notes + threshold evidence) remains in `Milestone1_QA_draft3.md` for traceability.

## The 6-Part Scenario Form

A quality attribute requirement is testable only when stated as a stimulus–response pair with its context (SAP Ch. 3):

**Source of stimulus → Stimulus → Artifact (in an Environment) → Response → Response Measure**

Two writing rules applied throughout: the *Response Measure* must be quantified and observable, and every threshold carries its derivation with a status tag — **grounded** (directly supported by a source) · **anchored** (team value with a cited reference point) · **derived** (computed from cited sources) · **provisional** (no numeric basis — to be confirmed by the Planned Experiments before Milestone 2).

Evidence sources: **[X1]** Witschi Chronoscope X1-G3 manual · **[TC]** Witschi Training Course · **[EQ]** TimeGrapher Equations doc · **[SNR]** `SNR-Analysis-WeishiMic.md` (measured) · **[Code]** TimeGrapher baseline code · **[Draft]/[Brief]** project draft / brief.

## Why These Seven

Selection criteria: (a) the highest business-importance (B) / technical-risk (R) drivers from draft 3's priority table; (b) together they span the SAP quality attributes taught in the course — Performance, Availability, Modifiability, Testability, Usability — plus one **domain-defined** attribute (Accuracy), reflecting SAP's point that the canonical attribute list is a starting set, not a ceiling.

| # | Quality (SAP) | From draft 3 | B | R | Why selected |
|---|---------------|--------------|---|---|--------------|
| QAS-1 | Performance (Latency) | QAS-1 (+ keep-up from QAS-2) | H | H | Headline "real-time" driver; feasibility on the Pi is the stated project risk |
| QAS-2 | Accuracy (Computed Values) | QAS-13 | H | M | The product is a measuring instrument — accuracy is its reason to exist; clean ground-truth method |
| QAS-3 | Accuracy & Availability (Graceful Degradation) | QAS-5 | H | H | Usable measurement on a real, noisy bench; illustrates the degradation tactic |
| QAS-4 | Availability (Recoverability) | QAS-12 | M | M | The canonical fault → detect → notify → recover scenario; bench-workflow resilience |
| QAS-5 | Modifiability (Extensibility) | QAS-7 | H | M | 11 mandatory graphs in a 5-week box — the schedule driver |
| QAS-6 | Testability | QAS-10 | H | M | Supplies the ground truth used by QAS-1/2/3 and the regression safety of QAS-5 |
| QAS-7 | Usability (Touchscreen) | QAS-11 | M | M | The fixed 800×480 panel is a hard constraint (C-2) |

Not selected (kept in draft 3): throughput compute budget (absorbed here as QAS-1's keep-up precondition), long-run resource resilience, display consistency, beat-position precision (QAS-2 bounds beat-error accuracy at the same 0.1 ms figure; the onset/peak position-error requirement itself stays in draft 3), modularity, portability, session continuity, alert annunciation. Security and deployability are out of scope (local bench instrument, no network exposure).

## Quality Attribute Scenarios

### QAS-1 · Performance (Latency) — From Sound Input to Screen Display
> While measuring on the target platform, when sound arrives at the microphone, the system processes it through the input → analysis → display flow and shows it on screen with p99 end-to-end latency ≤ 500 ms, while keeping up with the input rate (0 dropped blocks, 0 missed beats).

| Element | Content |
|---------|---------|
| Source | The microphone / watch (external) |
| Stimulus | Sound arrives at the microphone |
| Artifact | The full input → analysis → display flow |
| Environment | Live measurement on the Raspberry Pi 5 (8 GB, C-1) at 96,000 SPS objective — must also hold at the 48,000 SPS minimum (C-6); GUI active, continuous normal load |
| Response | Process and show on screen, keeping up with the input rate |
| Response Measure | Over a 10-min continuous run: p99 end-to-end latency (sound arrival → on-screen) ≤ 500 ms, measured via capture / processing / display timestamps; 0 dropped audio blocks (input-callback overrun counter) and 0 missed beats vs the known Sim/Playback beat schedule (harness per QAS-6) |

**Why these numbers**
- **≤ 500 ms** (provisional, anchored) — ① ≈ 4 beat periods at the typical 28,800 BPH (beat period 125 ms [EQ]); ② below the ≈ 600 ms bound at which a display still feels near-real-time (team UX rationale); ③ > 7× the baseline's ≈ 70 ms structural display path (20 ms block cadence + fixed 50 ms envelope-alignment delay [Code]). The brief mandates minimizing and reporting latency but sets no number.
- **10-min run** (anchored) — matches the Witschi Sequence-mode maximum measurement time.
- **Environment pinned to the Pi + sample rates** — the brief explicitly warns PC performance does not transfer to the Pi; rates per C-6.

### QAS-2 · Accuracy (Computed Values) — Rate, Amplitude, Beat Error vs Ground Truth
> In clean conditions, when the system measures a Sim-generated signal with known programmed parameters (BPH, Error Rate, Amplitude, Beat Error) and a configured lift angle, the displayed values match the injected ground truth: rate ≤ ±1 s/d, amplitude ≤ ±5°, beat error ≤ ±0.1 ms over ≥ 1,000 beats. (Accuracy is a domain-defined quality attribute — the instrument's reason to exist.)

| Element | Content |
|---------|---------|
| Source | The Sim signal generator with known programmed parameters (internal ground truth) |
| Stimulus | A measurement run on a Sim signal with programmed rate / amplitude / beat error |
| Artifact | The calculation stages (rate, amplitude incl. lift angle, beat error) |
| Environment | Clean conditions (no injected noise), Sim mode with Realistic OFF (default is ON — must be unchecked), 96,000 SPS |
| Response | Compute and display rate, amplitude, and beat error; the configured lift angle and BPH demonstrably flow into the computation |
| Response Measure | Versus the programmed values over ≥ 1,000 beats: \|rate error\| ≤ 1 s/d; \|amplitude error\| ≤ 5° (with the configured lift angle, default 52°); \|beat-error error\| ≤ 0.1 ms |

**Why these numbers**
- **rate ≤ ±1 s/d** (anchored, provisional) — 10× the X1 instrument accuracy (± 0.1 s/d [X1]) and ⅛ of the tightest watch-grade band (Chronometer −2…+6 s/d [TC]).
- **amplitude ≤ ±5°** (derived, provisional) — error propagation from Amp = 3600λ/(π·n·t_AC) [EQ]: at the worked example (230° @ t_AC = 9 ms), \|dAmp/dt_AC\| ≈ 25.6°/ms; a 0.1 ms event-timing error (the X1 beat-error spec [X1]) ≈ 2.6° → ±5° ≈ 2× margin.
- **beat error ≤ ±0.1 ms** (grounded) — equals the X1 instrument's accuracy spec [X1].
- **Sim ground truth, ≥ 1,000 beats** (grounded / feasible) — the Draft's Simulation Parameters; lift angle default 52° ("52° is common" [EQ]); 1,000 beats ≈ 2.1–3.3 min of capture. Clean verification requires Realistic OFF — the default is ON [Code].

### QAS-3 · Accuracy & Availability (Graceful Degradation) — Under Noisy or Weak Signals
> In a poor environment where ambient noise mixes in or a weak signal arrives, the system filters out noise while preserving the needed sounds, and when signal quality is below threshold it shows "signal weak" instead of a wrong value: at SNR ≥ 14 dB, beat detection ≥ 95 % and rate error ≤ ±3 s/d over ≥ 1,000 beats; below threshold, "signal weak" only and 0 wrong values.

| Element | Content |
|---------|---------|
| Source | Ambient noise / weak signal (external) |
| Stimulus | Noise mixes in or the signal arrives weak |
| Artifact | The noise-removal / beat-detection part and the signal-quality indication |
| Environment | Noisy bench environment, reproduced by mixing calibrated noise into Sim/Playback input at a controlled SNR (per-beat impulse peak vs ambient-noise RMS in the analysis band, method per [SNR]) |
| Response | (Accuracy) detect beats and compute rate within tolerance under noise; (Availability) below the quality threshold, degrade gracefully — show "signal weak" instead of any value |
| Response Measure | Against the generator's known beat schedule and programmed rate, over ≥ 1,000 beats: detection ≥ 95 % and rate error ≤ ±3 s/d at SNR ≥ 14 dB; below threshold: only "signal weak" and 0 wrong values (= a reading shown without the flag whose error exceeds the tolerance above) |

**Why these numbers**
- **SNR ≥ 14 dB** (anchored by measurement; provisional as acceptance bound) — the 9 WeiShi-mic test recordings measure 30–51 dB clean [SNR], so 14 dB is ≥ 16 dB below the worst clean capture — a severe-degradation condition reachable only by deliberate noise injection. (Per [SNR] §Definition Sensitivity, it must **not** be framed as "1 dB below the sample minimum" — that switches metrics and leaves zero margin.)
- **rate ≤ ±3 s/d** (anchored) — within the half-width of the tightest Witschi grade band (Chronometer −2…+6 s/d [TC]).
- **detection ≥ 95 %** (provisional) — no basis found in any document or the code.
- **Ground truth = synthetic + injected noise** — a reference instrument is itself an acoustic device exposed to the same noise; both could drift together and still "agree" (circularity). The generator's known schedule is the ground truth; a reference reading is a clean-condition sanity check only.

### QAS-4 · Availability (Recoverability) — Audio Device Disconnect or Stream Error
> While measuring as usual, when the audio input device is disconnected or the input stream raises a recoverable error (e.g., an ALSA xrun), the system detects the fault without crashing, informs the user, preserves the last useful reading (flagged stale) and all captured data, and resumes automatically within 10 s of the fault clearing — no manual restart.

| Element | Content |
|---------|---------|
| Source | Sound device (external) |
| Stimulus | The device is disconnected, or the input stream raises a recoverable error (device still attached), during measurement |
| Artifact | The sound-input part / the system |
| Environment | Measuring as usual |
| Response | Detect the fault without crashing; inform the user; keep the last valid reading visible (flagged stale) and preserve captured data; resume automatically once the fault clears |
| Response Measure | Over ≥ 20 unplug/replug cycles and ≥ 5 injected stream errors: 0 crashes; "no device" / "input error" indication ≤ 5 s; automatic resumption ≤ 10 s of the fault clearing, every trial; the last valid reading stays visible (stale-flagged) throughout the fault; 0 loss of captured data; 0 data corruption (= mixed pre-/post-fault samples, torn-buffer samples, or non-monotonic timestamps across the fault boundary) |

**Why these numbers**
- **auto-resume ≤ 10 s** (derived, provisional) — the baseline's re-lock path after a stream re-open is ≈ 2.5–3.5 s (detector warmup 200 ms + BPH auto-detect 1.5 s + sync acquisition ≈ 0.8–1.7 s [Code]) → ≈ 3× margin. The baseline has **no** reconnect handling today — device loss simply ends the worker [Code] — so this scenario specifies a new capability.
- **indication ≤ 5 s** (provisional) — the Draft requires clear fault indication ("don't leave the user guessing"); status displays update on a ≈ 2 s cycle → 5 s ≈ two update cycles + margin.
- **last-reading preservation** (grounded) — the Draft's "preserve the last useful reading".

### QAS-5 · Modifiability (Extensibility) — Adding a New Measurement/Filter/Graph
> In a tight-schedule development situation, when a developer adds a new graph, filter stage, or derived measurement, they can add it incrementally without tearing into existing code — within a per-kind change budget and with zero regressions.

| Element | Content |
|---------|---------|
| Source | Developer |
| Stimulus | Wants to add a new graph, a new filter stage, or a new derived measurement |
| Artifact | The system (codebase holding the measurement/display features) |
| Environment | During development, tight schedule |
| Response | Add incrementally without heavily tearing into existing code |
| Response Measure | New graph/display tab: ≤ 1 existing module changed (registration/wiring only), 0 changes to analysis/acquisition code; new filter stage or derived measurement: analogously ≤ 1 registration point. All kinds: 0 regressions — the existing-feature regression test set (QAS-6, hardware-free) passes before and after. (≈ 5 person-days per graph is informational, not pass/fail.) |

**Why these numbers**
- **≤ 1 registration/wiring point per kind** (anchored) — the Project Plan demands incremental extension with separated responsibilities inside the 5-week box, with ~11 mandatory graph features; a bounded touch surface is what makes that schedule feasible. (Module = a cohesive code unit behind a single interface, its own tests excluded.)
- **0 regressions** — operationalized as "the regression test set passes before and after"; a bare 0 is meaningless without a detection method.
- **≈ 5 person-days** (informational only) — a planning estimate; effort measures developer skill, not the architecture, so it is excluded from pass/fail.

### QAS-6 · Testability — Testing Parts in Isolation
> During testing, when a developer/tester wants to test just the sound-analysis stages or the input part separately, each core analysis stage and the sound-input part can be checked in isolation by feeding fake input without real hardware. Sim mode generates synthetic beat signals whose onset/peak positions and beat schedule are known a priori — the ground truth used by QAS-1/2/3.

| Element | Content |
|---------|---------|
| Source | Developer / tester |
| Stimulus | Wants to test just the sound-analysis stages or input part separately |
| Artifact | The core analysis stages (beat/onset detection, onset/peak location, rate / beat-error / amplitude computation, X/D aggregation — X = mean rate over the valid measured positions, D = max–min rate difference, per FR-04-06/07), the sound-input part |
| Environment | During testing, on a host with no audio hardware |
| Response | Check parts in isolation via fake-input injection; generate synthetic beat signals with a-priori known onset/peak positions and beat schedule |
| Response Measure | Line coverage ≥ 80 % on the enumerated core analysis stages; every core stage and the sound-input source is drivable via its interface with Sim/Playback injection — contract tests pass on a host with no audio device; Sim signals carry a-priori known onset/peak positions and beat schedule; X/D sequence results reproducible across 3 repeated runs and traceable to included/excluded positions (details in draft 3) |

**Why these numbers**
- **Hardware-free isolation** (grounded) — the Draft's Sim mode plus the baseline's `WatchSynthStream`, `SimWorker`, `PlaybackWorker`, and WAV fixtures [Code] already inject input without hardware.
- **Line coverage ≥ 80 %** (provisional) — a team-chosen target; the denominator is fixed by the enumerated core-stage list so the percentage is meaningful.
- **Contract-test criterion** — replaces "100 % of unit tests runnable without hardware", which was tautological (a property of whatever tests exist, not of the architecture).

### QAS-7 · Usability — Reading and Operating on the Low-Resolution Touchscreen
> While using the device on the Raspberry Pi 5's 800×480 touchscreen, when the user reads measurement values and switches modes, the key readings are legible without scrolling/zooming and primary functions are operable by touch alone. Physical sizes (mm) are normative; pixel equivalents are advisory until the panel size is confirmed.

| Element | Content |
|---------|---------|
| Source | User (watchmaker / operator) |
| Stimulus | Reads measurement values and switches modes on the 800×480 touchscreen |
| Artifact | The GUI (spectrogram/scope/numeric displays and controls) |
| Environment | Raspberry Pi 5 + 800×480 touch display, normal use. Panel physical size unconfirmed (Draft self-contradicts: "8 Inch" heading vs "5-inch" body — see C-1). The baseline GUI is hard-fixed at 1280×750, so re-layout is required work [Code] |
| Response | Present key readings legibly; allow primary functions by touch alone |
| Response Measure | Primary readings (rate, beat error, amplitude) shown simultaneously without scroll/zoom; glyph height ≥ 1.9 mm (≈ 16 arcmin at 40 cm working distance), contrast ≥ 4.5:1 (WCAG AA); all primary touch targets ≥ 9 mm physical (pixel equivalents advisory until the panel size is confirmed); any primary mode reachable in ≤ 2 taps. Touch = single tap/drag; multi-touch gestures are out of scope |

**Why these numbers**
- **Physical mm normative, px advisory** — "9 mm ≈ 48 px" holds only at ≈ 135 ppi (7-inch panel); the Draft states both 8-inch (→ ≈ 41 px) and 5-inch (→ ≈ 66 px), so pass/fail must not depend on the conversion (open question in C-1).
- **≥ 9 mm touch targets** (anchored) — standard touch-ergonomics target size.
- **Glyph ≥ 1.9 mm / 16 arcmin @ 40 cm + contrast ≥ 4.5:1** (derived) — replaces the unmeasurable "readable at working distance" with a perception spec needing no test subjects (legibility practice + WCAG AA).
- **≤ 2 taps** (provisional) — team criterion bounding primary-mode reachability; 800×480 itself is a direct Draft constraint (C-2).

## Constraints

| ID | Constraint |
|----|------------|
| C-1 | The system shall run on a Raspberry Pi 5 (8 GB RAM, 128 GB microSD) with the attached touchscreen. Open question: the Draft states the panel as both "8 Inch" and "5-inch"; the confirmed size drives the QAS-7 pixel equivalents. |
| C-2 | The system shall render and operate the GUI correctly on the low-resolution (800×480) display attached to the Raspberry Pi 5 (usability measures: QAS-7). |
| C-3 | The system shall run on both a Windows 11 (x64) PC and a Raspberry Pi 5 running Raspberry Pi OS (Debian-based, 64-bit/ARM64). |
| C-4 | (Operating precondition) The host audio device shall have Auto Gain Control disabled, verified in the OS audio mixer before measurement. The baseline already disables AGC programmatically at startup [Code]. |
| C-5 | The system shall be implemented by extending the provided Qt-based TimeGrapher baseline (TimeGrapher_v10.5_Student), not built from scratch. (Qt 6 with Qt 5 fallback, CMake ≥ 3.16, C++17.) |
| C-6 | The system shall support the defined sample-rate operating points: 48,000 SPS (minimum), 96,000 SPS (objective), 192,000 SPS (stretch). |

---

# Milestone1 Jae-hong Oh — QA draft 4 (선별 시나리오, 한국어)

> **draft 4 (2026-06-03)** — 교수자 조언에 따라 draft 3의 15개 시나리오 중 **7개를 선별**하여 간결하게 제시한다: 목표는 전수 커버리지가 아니라, 학습한 프레임워크 — SAP(*Software Architecture in Practice*, Bass · Clements · Kazman)의 SEI 6-part Quality Attribute Scenario — 를 제대로 이해하고 설명할 수 있음을 보이는 것이다. 선별된 각 시나리오는 자기완결적으로 재작성했다. 전체 집합(QAS 15개 + scope note + 근거)은 추적성을 위해 `Milestone1_QA_draft3.md`에 보존한다.

## 6-Part 시나리오 형식

품질 속성 요구사항은 자극–응답 쌍과 그 맥락으로 기술될 때에만 검증 가능하다 (SAP 3장):

**자극의 출처(Source) → 자극(Stimulus) → 대상 산출물(Artifact) (환경(Environment) 안에서) → 응답(Response) → 응답 척도(Response Measure)**

전체에 적용한 두 가지 작성 규칙: *응답 척도*는 정량적이고 관측 가능해야 하며, 모든 임계값은 도출 근거와 상태 태그를 동반한다 — **grounded**(출처가 직접 뒷받침) · **anchored**(인용 기준점을 가진 팀 선정값) · **derived**(인용 출처로부터 계산) · **provisional**(수치 근거 없음 — Milestone 2 전 Planned Experiments로 확정).

근거 출처: **[X1]** Witschi Chronoscope X1-G3 매뉴얼 · **[TC]** Witschi Training Course · **[EQ]** TimeGrapher Equations 문서 · **[SNR]** `SNR-Analysis-WeishiMic.md`(실측) · **[Code]** TimeGrapher 베이스라인 코드 · **[Draft]/[Brief]** 프로젝트 Draft / Brief.

## 왜 이 7개인가

선별 기준: (a) draft 3 우선순위 표에서 비즈니스 중요도(B)/기술 리스크(R)가 가장 높은 드라이버; (b) 합쳐서 과정에서 배운 SAP 품질 속성 — Performance, Availability, Modifiability, Testability, Usability — 을 고루 포괄하고, 여기에 **도메인 정의** 속성(Accuracy) 하나를 더함 — 표준 속성 목록은 출발점이지 천장이 아니라는 SAP의 가르침을 반영.

| # | 품질 속성 (SAP) | draft 3 출처 | B | R | 선별 이유 |
|---|----------------|-------------|---|---|----------|
| QAS-1 | Performance (Latency) | QAS-1 (+ QAS-2의 keep-up) | H | H | 대표 "real-time" 드라이버; Pi에서의 실현 가능성이 명시된 프로젝트 리스크 |
| QAS-2 | Accuracy (Computed Values) | QAS-13 | H | M | 이 제품은 계측기 — 정확도가 존재 이유; 깔끔한 ground-truth 검증법 |
| QAS-3 | Accuracy & Availability (Graceful Degradation) | QAS-5 | H | H | 실제 잡음 환경에서 쓸 수 있는 측정; degradation 전술의 예시 |
| QAS-4 | Availability (Recoverability) | QAS-12 | M | M | 교과서적 fault → 감지 → 통지 → 복구 시나리오; 작업대 워크플로 복원력 |
| QAS-5 | Modifiability (Extensibility) | QAS-7 | H | M | 5주 안에 필수 그래프 11종 — 일정을 좌우하는 드라이버 |
| QAS-6 | Testability | QAS-10 | H | M | QAS-1/2/3의 ground truth와 QAS-5의 회귀 안전성을 공급 |
| QAS-7 | Usability (Touchscreen) | QAS-11 | M | M | 800×480 고정 패널은 하드 제약(C-2) |

선별 제외(draft 3에 보존): throughput 연산 예산(여기서는 QAS-1의 keep-up 전제로 흡수), 장기 실행 자원 복원력, 표시 간 값 일치, 비트 위치 정밀도(QAS-2가 같은 0.1 ms 수치로 비트오차 정확도를 한정하나, onset/peak 위치 오차 요구 자체는 draft 3에 유지), 모듈성, 이식성, 세션 연속성, 경보 표시. Security와 deployability는 범위 밖(네트워크 노출 없는 로컬 작업대 계측기).

## Quality Attribute Scenarios

### QAS-1 · Performance (Latency) — 소리 입력에서 화면 표시까지
> 타깃 플랫폼에서 측정하는 동안 마이크로 소리가 들어오면, 시스템은 입력 → 분석 → 표시 흐름으로 처리하여 화면에 표시하며, p99 종단 지연 ≤ 500 ms를 만족하고 입력 rate를 따라간다(블록 드롭 0, 비트 누락 0).

| 요소 | 내용 |
|------|------|
| 출처 | 마이크 / 시계 (외부) |
| 자극 | 마이크로 소리가 들어옴 |
| 대상 산출물 | 전체 입력 → 분석 → 표시 흐름 |
| 환경 | Raspberry Pi 5(8 GB, C-1)에서 Live 측정, 96,000 SPS 목표 — 48,000 SPS 최소에서도 충족(C-6); GUI 활성, 연속 정상 부하 |
| 응답 | 입력 rate를 따라가며 처리하여 화면에 표시함 |
| 응답 척도 | 10분 연속 실행 동안: p99 종단 지연(소리 도착 → 화면) ≤ 500 ms, capture/processing/display 타임스탬프로 측정; 블록 드롭 0개(입력 콜백 overrun 카운터), 기지 Sim/Playback 비트 스케줄 대비 비트 누락 0개(하네스는 QAS-6) |

**측정값 근거**
- **≤ 500 ms** (provisional, anchored) — ① 일반적인 28,800 BPH에서 약 4비트 주기(비트 주기 125 ms [EQ]); ② 화면이 실시간에 가깝게 느껴지는 상한 약 600 ms보다 여유 있게 잡은 값(팀 UX 근거); ③ 베이스라인의 구조적 표시 경로 약 70 ms(블록 주기 20 ms + 고정 50 ms envelope 정렬 지연 [Code])의 7배 이상. 브리프는 지연 최소화·보고만 요구하고 수치를 정하지 않음.
- **10분 연속 실행** (anchored) — Witschi Sequence mode 최대 측정 시간과 일치.
- **환경 고정(Pi + 샘플레이트)** — 브리프가 명시 경고: PC 성능은 Pi로 이전되지 않음; 레이트는 C-6 기준.

### QAS-2 · Accuracy (Computed Values) — 일오차·진폭·비트오차 vs Ground Truth
> 클린 조건에서 시스템이 기지 파라미터(BPH, Error Rate, Amplitude, Beat Error)와 설정된 lift angle로 생성된 Sim 신호를 측정할 때, 표시되는 값이 주입된 정답과 일치한다: 1,000비트 이상 기준 일오차 ≤ ±1 s/d, 진폭 ≤ ±5°, 비트오차 ≤ ±0.1 ms. (Accuracy는 도메인 정의 품질 속성 — 계측기의 존재 이유.)

| 요소 | 내용 |
|------|------|
| 출처 | 기지 파라미터를 가진 Sim 신호 생성기 (내부 ground truth) |
| 자극 | 프로그래밍된 rate/amplitude/beat error를 가진 Sim 신호에 대한 측정 실행 |
| 대상 산출물 | 계산 단계(rate, lift angle 포함 진폭, beat error) |
| 환경 | 클린 조건(잡음 주입 없음), Sim mode에서 Realistic OFF(기본값 ON — 해제 필요), 96,000 SPS |
| 응답 | rate, 진폭, beat error를 계산·표시; 설정된 lift angle과 BPH가 계산에 실제로 반영됨을 입증 가능 |
| 응답 척도 | 프로그래밍된 값 대비, 1,000비트 이상 기준: \|일오차\| ≤ 1 s/d; \|진폭 오차\| ≤ 5°(설정 lift angle 기준, 기본 52°); \|비트오차 오차\| ≤ 0.1 ms |

**측정값 근거**
- **일오차 ≤ ±1 s/d** (anchored, provisional) — X1 계측 정확도(± 0.1 s/d [X1])의 10×이자 가장 엄격한 등급 대역(Chronometer −2…+6 s/d [TC])의 1/8 수준.
- **진폭 ≤ ±5°** (derived, provisional) — Amp = 3600λ/(π·n·t_AC) [EQ]의 오차 전파: worked example(230° @ t_AC = 9 ms)에서 \|dAmp/dt_AC\| ≈ 25.6°/ms; 이벤트 타이밍 오차 0.1 ms(X1 beat error 스펙 [X1]) ≈ 2.6° → ±5° ≈ 2× 마진.
- **비트오차 ≤ ±0.1 ms** (grounded) — X1 계측기의 정확도 스펙과 동일 [X1].
- **Sim ground truth, ≥ 1,000비트** (grounded / feasible) — Draft의 Simulation Parameters; lift angle 기본 52°("52° is common" [EQ]); 1,000비트 ≈ 캡처 2.1–3.3분. 클린 검증은 Realistic OFF 필수 — 기본값은 ON [Code].

### QAS-3 · Accuracy & Availability (Graceful Degradation) — 잡음·약신호 환경
> 주변 잡음이 섞이거나 약한 신호가 들어오는 열악한 환경에서, 시스템은 필요한 소리를 보존하며 잡음을 걸러내고, 신호 품질이 임계 이하면 잘못된 값 대신 "신호 약함"을 표시한다: SNR ≥ 14 dB에서 1,000비트 이상 기준 비트 감지율 ≥ 95%, 일오차 ≤ ±3 s/d; 임계 미만에서는 "신호 약함"만 표시하고 잘못된 값 0회.

| 요소 | 내용 |
|------|------|
| 출처 | 주변 잡음 / 약한 신호(외부) |
| 자극 | 잡음이 섞이거나 신호가 약하게 들어옴 |
| 대상 산출물 | 잡음 제거 / 비트 감지 부분과 신호 품질 표시 |
| 환경 | 열악한 작업 환경 — Sim/Playback 입력에 보정된 잡음을 통제된 SNR로 주입하여 재현(SNR = 비트당 임펄스 피크 대 분석 대역 내 주변 잡음 RMS, 방법은 [SNR] 기준) |
| 응답 | (Accuracy) 잡음 하에서 비트를 감지하고 rate를 허용오차 내로 계산; (Availability) 품질 임계 미만이면 우아하게 성능 저하 — 어떤 값도 아닌 "신호 약함"을 표시 |
| 응답 척도 | 생성기의 기지 비트 스케줄·프로그래밍된 rate 대비, 1,000비트 이상 기준: SNR ≥ 14 dB에서 감지율 ≥ 95%, 일오차 ≤ ±3 s/d; 임계 미만: "신호 약함"만 표시, 잘못된 값 0회(= 플래그 없이 표시된 판독값 중 오차가 위 허용오차를 초과하는 것) |

**측정값 근거**
- **SNR ≥ 14 dB** (실측 anchored; 합격 기준으로서는 provisional) — WeiShi-mic 시험 녹음 9개의 클린 실측 = 30–51 dB [SNR], 따라서 14 dB는 최악 클린 캡처보다 ≥ 16 dB 낮은 심한 열화 조건 — 의도적 잡음 주입으로만 도달 가능. ([SNR] §Definition Sensitivity에 따라 "샘플 최저치보다 1 dB 낮춘 값"으로 설명하면 **안 됨** — 지표가 바뀌고 열화 마진이 0이 됨.)
- **일오차 ≤ ±3 s/d** (anchored) — 가장 엄격한 Witschi 등급 대역(Chronometer −2…+6 s/d [TC])의 반폭 이내.
- **감지율 ≥ 95%** (provisional) — 문서·코드 어디에도 근거 없음.
- **정답 = 합성 신호 + 잡음 주입** — 기준 장비도 같은 잡음에 노출되는 음향 계측기라서 둘이 같이 틀려도 "일치"로 통과 가능(순환성). 생성기의 기지 스케줄이 정답; 기준 장비 판독값은 클린 조건 sanity check 용도만.

### QAS-4 · Availability (Recoverability) — 오디오 장치 분리·스트림 오류
> 평소처럼 측정하는 동안 오디오 입력 장치가 분리되거나 입력 스트림이 복구 가능한 오류(예: ALSA xrun)를 일으키면, 시스템은 크래시 없이 오류를 감지·통지하고, 마지막 유효 판독값(stale 플래그)과 기캡처 데이터를 보존하며, fault 해소 후 10초 이내에 수동 재시작 없이 자동 재개한다.

| 요소 | 내용 |
|------|------|
| 출처 | 사운드 장치(외부) |
| 자극 | 측정 중 장치가 분리되거나, 장치가 연결된 상태에서 입력 스트림이 복구 가능한 오류를 일으킴 |
| 대상 산출물 | 사운드 입력 부분 / 시스템 |
| 환경 | 평소처럼 측정 중 |
| 응답 | 크래시 없이 오류를 감지하고 사용자에게 알림; 마지막 유효 판독값을 stale 플래그와 함께 계속 표시하고 기캡처 데이터를 보존; fault 해소 시 자동 재개 |
| 응답 척도 | unplug/replug ≥ 20회 + 주입 스트림 오류 ≥ 5회에 걸쳐: 크래시 0회; "장치 없음"/"입력 오류" 표시 ≤ 5초; fault 해소 후 자동 재개 ≤ 10초, 전 시행 충족; fault 구간 내내 마지막 유효 판독값이 stale 플래그와 함께 계속 표시; 기캡처 데이터 손실 0건; 데이터 손상 0건(= fault 전후 샘플 혼입, torn 버퍼 샘플, fault 경계의 비단조 타임스탬프) |

**측정값 근거**
- **자동 재개 ≤ 10초** (derived, provisional) — 스트림 재오픈 후 베이스라인 재고착 경로 ≈ 2.5–3.5초(검출기 warmup 200 ms + BPH auto-detect 1.5 s + sync 획득 ≈ 0.8–1.7초 [Code]) → 약 3× 마진. 베이스라인에는 재연결 처리가 **없음** — 장치 소실 시 워커가 종료될 뿐 [Code] — 본 시나리오는 신규 능력을 규정.
- **표시 ≤ 5초** (provisional) — Draft의 명확한 오류 표시 요구("사용자가 추측하게 두지 말 것"); 상태 표시는 약 2초 주기로 갱신 → 5초 ≈ 갱신 주기 2회 + 여유.
- **마지막 판독값 보존** (grounded) — Draft의 "preserve the last useful reading".

### QAS-5 · Modifiability (Extensibility) — 새 측정/필터/그래프 추가
> 일정이 촉박한 개발 상황에서 개발자가 새 그래프·필터 단계·파생 측정값을 추가할 때, 기존 코드를 크게 뜯어고치지 않고 점진적으로 추가할 수 있다 — 종류별 변경 예산과 회귀 0건.

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 |
| 자극 | 새 그래프, 새 필터 단계, 또는 새 파생 측정값을 추가하려고 함 |
| 대상 산출물 | 시스템(측정·표시 기능을 담은 코드베이스) |
| 환경 | 개발 중, 일정이 촉박함 |
| 응답 | 기존 코드를 크게 뜯어고치지 않고 점진적으로 추가함 |
| 응답 척도 | 새 그래프/표시 탭: 기존 모듈 변경 ≤ 1개(등록/배선부만), 분석/획득 코드 변경 0건; 새 필터 단계·파생 측정값: 동일하게 등록 지점 ≤ 1개. 전 종류 공통: 회귀 0건 — 기존 기능 회귀 테스트 셋(QAS-6, 하드웨어 불요)이 변경 전후 모두 통과. (그래프 1종당 약 5인일은 참고용이며 pass/fail 아님.) |

**측정값 근거**
- **종류별 등록/배선 지점 ≤ 1개** (anchored) — Project Plan은 5주 일정 안에서 책임을 분리하며 점진적으로 확장하라고 요구하고, 필수 그래프가 약 11종; 좁은 변경 표면이 그 일정을 가능케 하는 조건. (모듈 = 단일 인터페이스 뒤의 응집된 코드 단위, 자기 테스트 제외.)
- **회귀 0건** — "회귀 테스트 셋이 변경 전후 통과"로 조작화; 검출 방법 없는 0은 무의미.
- **약 5인일** (참고용) — 일정 추정값; 작업량은 아키텍처가 아니라 개발자 숙련도를 측정하므로 pass/fail에서 제외.

### QAS-6 · Testability — 부분 격리 테스트
> 테스트 중 개발자/테스터가 사운드 분석 단계나 입력 부분만 따로 테스트하려고 할 때, 각 핵심 분석 단계와 사운드 입력 부분은 실제 하드웨어 없이 가짜 입력 주입으로 독립 확인할 수 있다. Sim mode는 onset/peak 위치와 비트 스케줄이 선험적으로 알려진 합성 신호를 생성한다 — QAS-1/2/3이 사용하는 ground truth.

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 / 테스터 |
| 자극 | 사운드 분석 단계 또는 입력 부분만 따로 테스트하려고 함 |
| 대상 산출물 | 핵심 분석 단계(비트/onset 감지, onset/peak 위치, rate/beat error/진폭 계산, X/D 집계 — X = valid measured position들의 rate 평균, D = rate 최대–최소 차, FR-04-06/07 기준), 사운드 입력 부분 |
| 환경 | 테스트 중, 오디오 하드웨어가 없는 호스트 |
| 응답 | 가짜 입력 주입으로 부분별 독립 확인; onset/peak 위치·비트 스케줄이 선험적으로 알려진 합성 신호 생성 |
| 응답 척도 | 열거된 핵심 분석 단계의 line coverage ≥ 80%; 모든 핵심 단계와 사운드 입력 소스가 자기 인터페이스 경유 Sim/Playback 주입으로 구동 가능 — 계약(contract) 테스트가 오디오 장치 없는 호스트에서 통과; Sim 신호는 onset/peak 위치·비트 스케줄을 선험적으로 보유; X/D sequence 결과는 3회 반복 실행에서 재현되고 포함/제외 position으로 역추적 가능(상세는 draft 3) |

**측정값 근거**
- **하드웨어 없는 격리** (grounded) — Draft의 Sim mode와 베이스라인의 `WatchSynthStream`, `SimWorker`, `PlaybackWorker`, WAV fixture [Code]가 이미 하드웨어 없이 입력을 주입.
- **line coverage ≥ 80%** (provisional) — 팀 선정 목표; 분모를 열거된 핵심 단계 목록으로 고정해야 퍼센트가 의미를 가짐.
- **계약 테스트 기준** — "하드웨어 없이 실행 가능한 단위 테스트 100%"를 대체 — 그 척도는 동어반복(작성된 테스트 집합의 속성일 뿐, 아키텍처의 격리 가능성을 측정하지 않음).

### QAS-7 · Usability — 저해상도 터치스크린에서 읽기·조작
> Raspberry Pi 5의 800×480 터치스크린에서 사용자가 측정값을 읽고 모드를 전환할 때, 핵심 측정값은 스크롤/확대 없이 가독성 있게 표시되고 주요 기능은 터치만으로 조작 가능하다. 물리 크기(mm)가 규범 기준이며, 픽셀 환산치는 패널 크기 확정 전까지 참고용.

| 요소 | 내용 |
|------|------|
| 출처 | 사용자(시계공 / 측정자) |
| 자극 | 800×480 터치스크린에서 측정값을 읽고 모드를 전환함 |
| 대상 산출물 | GUI(스펙트로그램/스코프/수치 표시와 컨트롤) |
| 환경 | Raspberry Pi 5 + 800×480 터치 디스플레이, 평소 사용 중. 패널 물리 크기 미확정(Draft 자기모순: "8 Inch" vs "5-inch" — C-1 참조). 베이스라인 GUI는 1280×750 고정이라 재레이아웃이 필수 작업 [Code] |
| 응답 | 핵심 측정값을 가독성 있게 표시; 주요 기능을 터치만으로 조작 가능 |
| 응답 척도 | 주요 측정값(일오차·비트오차·진폭)을 스크롤/확대 없이 동시 표시; 글리프 높이 ≥ 1.9 mm(작업 거리 40 cm에서 약 16 arcmin), 대비 ≥ 4.5:1 (WCAG AA); 모든 주요 터치 타깃 물리 크기 ≥ 9 mm(픽셀 환산치는 패널 크기 확정 전까지 참고용); 주요 모드 도달 ≤ 2 탭. 터치 = 단일 탭/드래그; 멀티터치 제스처는 범위 밖 |

**측정값 근거**
- **물리 mm 규범, px 참고** — "9 mm ≈ 48 px"는 약 135 ppi(7인치 패널)에서만 성립; Draft 자체가 8인치(→ ≈ 41 px)와 5인치(→ ≈ 66 px)를 동시에 기술하므로 pass/fail이 환산에 의존하면 안 됨(미해결 질문은 C-1에 기록).
- **터치 타깃 ≥ 9 mm** (anchored) — 통용되는 터치 인체공학 타깃 크기.
- **글리프 ≥ 1.9 mm / 40 cm에서 16 arcmin + 대비 ≥ 4.5:1** (derived) — 측정 불가능한 "작업 거리에서 판독 가능"을 피험자 없이 검증 가능한 지각 사양으로 교체(가독성 관행 + WCAG AA).
- **≤ 2 탭** (provisional) — 주요 모드 도달을 제한하는 팀 기준; 800×480 자체는 Draft의 직접 제약(C-2).

## Constraints

| ID | 제약사항 |
|----|----------|
| C-1 | 시스템은 터치스크린이 연결된 Raspberry Pi 5(8 GB RAM, 128 GB microSD)에서 실행되어야 한다. 미해결 질문: Draft가 패널을 "8 Inch"/"5-inch"로 자기모순 기술 — 확정 크기가 QAS-7의 픽셀 환산치를 결정한다. |
| C-2 | 시스템은 Raspberry Pi 5에 연결된 저해상도(800×480) 디스플레이에서 GUI를 올바르게 렌더링하고 동작해야 한다 (사용성 척도: QAS-7). |
| C-3 | 시스템은 Windows 11 (x64) PC와 Raspberry Pi OS(Debian 기반, 64-bit/ARM64)를 실행하는 Raspberry Pi 5 모두에서 실행되어야 한다. |
| C-4 | (운영 전제 조건) 호스트 오디오 장치는 측정 전 OS 오디오 믹서에서 Auto Gain Control 비활성을 확인해야 한다. 베이스라인은 이미 시작 시 AGC를 프로그램적으로 비활성화한다 [Code]. |
| C-5 | 시스템은 제공된 Qt 기반 TimeGrapher 베이스라인(TimeGrapher_v10.5_Student)을 확장하여 구현해야 하며, 처음부터 새로 구축하지 않는다. (Qt 6 + Qt 5 fallback, CMake ≥ 3.16, C++17.) |
| C-6 | 시스템은 정의된 샘플레이트 운영점 — 48,000 SPS(최소), 96,000 SPS(목표), 192,000 SPS(스트레치) — 을 지원해야 한다. |
