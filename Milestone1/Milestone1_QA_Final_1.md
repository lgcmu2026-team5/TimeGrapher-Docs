# Milestone1 — QA Final 1

> English version above, Korean version below. (위쪽은 영어 버전, 아래쪽은 한국어 버전입니다.)

## Quality Attribute Scenarios

### QAS-1 · Performance (Latency) — From Sound Input to Screen Display
> *(Modified for the presentation: latency is decomposed and reported in three parts — (1) processing latency, (2) display latency, (3) processing+display latency.)*
>
> While measuring on the target platform, when sound arrives at the microphone, the system processes it through the input → analysis → display flow and shows it on screen. Latency is instrumented at three boundaries — sound arrival, analysis result produced, on-screen — and reported as (1) processing latency, (2) display latency, and (3) processing+display latency, with the combined p99 ≤ 500 ms. Keeping up with the input rate (0 dropped blocks / 0 missed beats) is a separately verified precondition here.

**Why this attribute**
- The Plan mandates it almost verbatim: *"The system shall minimize end-to-end latency between acoustic capture at the microphone and presentation of the corresponding waveform, markers, and computed values in the GUI"* (§Low Latency and Low Number of Missed Beats).
- The three-part split is the Plan's own reporting requirement, not our invention: *"Teams shall report capture-to-processing latency, processing-to-display latency, and total end-to-end latency in milliseconds."*
- Attribute test: a time bound on the response to an arriving event is the defining shape of a Performance (Latency) scenario.

| Element | Content |
|---------|---------|
| Source | The microphone / watch (external) |
| Stimulus | Sound arrives at the microphone |
| Artifact | The full input → analysis → display flow, instrumented at three timestamps: t_sound_arrival (capture) · t_result_produced (analysis output) · t_on_screen (display) |
| Environment | Live measurement on the Raspberry Pi 5 (8 GB) at the 96,000 SPS objective rate — must also hold at the 48,000 SPS minimum; GUI active, continuous normal load |
| Response | Process and show on screen; report the three latency components |
| Response Measure | Over a 10-min continuous run, via capture / processing / display timestamps (per the Draft's latency-reporting requirement): **(1) processing latency** (t_sound_arrival → t_result_produced) — p99 measured and reported; **(2) display latency** (t_result_produced → t_on_screen) — p99 measured and reported; **(3) processing+display latency** (end-to-end, t_sound_arrival → t_on_screen) — **p99 ≤ 500 ms** (the pass/fail gate) |

**Why these numbers**
- **Three-part decomposition** (per the Draft's latency-reporting requirement) — the brief mandates minimizing *and reporting* latency; splitting at the analysis-output boundary localizes where time is spent on the Pi (analysis vs render) and directs optimization. Component bounds are not gated yet — per-component budgets are set after the Planned Experiments (provisional); only the combined ≤ 500 ms is pass/fail.
- **≤ 500 ms combined** (provisional, anchored) — ① ≈ 4 beat periods at the typical 28,800 BPH (beat period 125 ms [EQ]; Sim default BPH [Code]); ② below the ≈ 600 ms upper bound at which a display still feels near-real-time (team UX rationale); ③ > 7× the baseline's ≈ 70 ms structural display path (20 ms Linux/Pi block cadence + fixed 50 ms envelope-alignment delay [Code]) — headroom remains for analysis + render on the Pi. The brief sets no number — hence provisional.
- **Display-component reference point** — the baseline's structural display path is ≈ 70 ms [Code], a sanity anchor for component (2).
- **10-min run** (anchored) — matches the Witschi Sequence-mode maximum measurement time; longer durability is out of scope here.
- **Environment pinned** — the brief explicitly warns PC performance does not transfer to the Pi.

### QAS-2 · Accuracy — Pinpointing Beats Precisely
> While measuring as usual, when a new beat (tick/tock) arrives, the system determines its onset and peak positions accurately and preserves timing precision through every processing stage (acquisition → filtering → event detection → calculation, per the Draft), locating onset/peak within ≤ 0.1 ms. Verified on synthetic signals with known positions, since 0.1 ms ground truth cannot be obtained from real hardware.

**Why this attribute**
- The Plan's §Measurement Accuracy, Error Detection, and Handling demands exactly this: *"the software must accurately identify the start/onset and peak of the important acoustic signals used to compute watch metrics such as rate, beat error, amplitude, lift angle."*
- Same section: *"the architecture should preserve timing precision throughout acquisition, filtering, event detection, and calculation"* — this scenario's Response verbatim.
- Attribute test: the response measure is an error bound against ground truth (≤ 0.1 ms) — that is Accuracy: closeness to the true value, independent of how fast it is produced (Performance) or how consistently it is shown (Consistency).

| Element | Content |
|---------|---------|
| Source | Watch beat (external input stream) |
| Stimulus | A new beat (tick/tock) arrives in the input stream |
| Artifact | The beat-detection / time-calculation part |
| Environment | Measuring as usual; verified at 96,000 SPS objective and 48,000 SPS minimum |
| Response | Determine onset and peak positions accurately; preserve timing precision through every processing stage |
| Response Measure | Maximum onset/peak position error ≤ 0.1 ms over ≥ 1,000 synthetic beats with known positions (Sim mode, FR-05-05 / FR-12-16; onset/peak per FR-08-06), verified at 96,000 SPS (= 9.6 samples) and 48,000 SPS (= 4.8 samples — sub-sample interpolation required); no real hardware |

**Why these numbers**
- **≤ 0.1 ms** (grounded) — ① equals the reference instrument's beat-error spec (X1 resolution 0.1 ms / accuracy ± 0.1 ms [X1]); ② ≈ 1/6 of the Draft's 0.6 ms "good" beat-error bound, so clinically meaningful beat-error differences stay resolvable; ③ the baseline display and Sim input already step at 0.1 ms [Code].
- **Sample equivalents** (derived) — 0.1 ms = 4.8 / 9.6 / 19.2 samples @ 48/96/192k; worst case is the 48k minimum → sub-sample interpolation required, and the baseline detector already interpolates sub-sample (onset linear, peak parabolic) [Code] — so the target is feasible.
- **Synthetic verification, ≥ 1,000 beats** — real hardware cannot provide 0.1 ms ground truth; Sim signals with a-priori known positions via the Sim test harness; sample size per QAS-3.

### QAS-3 · Accuracy & Availability (Graceful Degradation) — Under Noisy or Weak Signals
> In a poor environment where ambient noise mixes in or a weak signal arrives, the system lets the user obtain a readable measurement by reducing extraneous noise, such as nearby speech, while preserving the watch features needed for correct detection and analysis (Brief); when signal quality is below threshold it shows "signal weak" instead of a wrong value: at SNR ≥ 14 dB, beat detection ≥ 95 % and rate error ≤ ±3 s/d over ≥ 1,000 beats; below threshold, "signal weak" only and 0 wrong values. [SJ] Invalid / low-confidence position results are excluded from X/D calculations (rule owned by FR-04-06).

**Why this attribute**
- Accuracy half, Plan §Correctness: *"reduce extraneous noise, such as nearby speech, while preserving the features needed for correct beat detection and measurement"* — correct detection must survive noise.
- Availability half, Plan §Measurement Accuracy: *"the system should degrade gracefully when the signal is weak, noisy, or partially missing, rather than producing unstable or misleading outputs"* — "degrade gracefully" is the Plan's own wording.
- Attribute test: above the quality threshold the scenario gates accuracy under noise (detection rate, rate error); below it, it gates the availability of correct service ("signal weak" instead of a wrong value) — hence the dual label.

| Element | Content |
|---------|---------|
| Source | Ambient noise / weak signal (external) |
| Stimulus | Noise mixes in or the signal arrives weak |
| Artifact | The noise-removal / beat-detection part and the signal-quality indication |
| Environment | Noisy bench environment, reproduced by mixing calibrated noise into Sim/Playback input at a controlled, held-constant SNR (SNR definition: per-beat impulse peak vs ambient-noise RMS in the analysis band, method per [SNR]) |
| Response | (Accuracy) detect beats and compute rate within tolerance under noise; (Availability) below the quality threshold, degrade gracefully — show "signal weak" instead of any value; [SJ] exclude invalid/low-confidence results from X/D (rule per FR-04-06) |
| Response Measure | Against the generator's known beat schedule and programmed rate, over ≥ 1,000 beats: detection rate ≥ 95 % and rate error ≤ ±3 s/d at SNR ≥ 14 dB; below threshold: only "signal weak" and 0 wrong values (wrong value = a reading shown without the "signal weak" flag whose error vs ground truth exceeds the tolerance above); [SJ] invalid/low-confidence values included in X/D = 0 cases |

**Why these numbers**
- **SNR ≥ 14 dB** (anchored by measurement; provisional as acceptance bound) — the 9 WeiShi-mic test recordings measure 30–51 dB clean (1 ms-envelope method; worst file 33.4 dB median-beat / 30.4 dB weak-beat) [SNR]; Sim realistic mode ≈ 45 dB, clean config ≈ 58 dB [Code]. So 14 dB is ≥ 16 dB below the worst clean capture — a severe-degradation condition reachable only by deliberate noise injection. Caution: under a whole-signal-RMS metric the same worst file reads 15.1 dB — do **not** rationalize 14 dB as "1 dB below the sample minimum" (that framing switches metrics, leaves zero degradation margin, and conflates weak coupling with ambient noise) [SNR §Definition Sensitivity].
- **rate error ≤ ±3 s/d** (anchored) — keeps noise-induced error within the half-width of the tightest Witschi grade band (Chronometer −2…+6 s/d; cf. Gent's −5…+15, Lady's −5…+25) [TC].
- **detection ≥ 95 %** (provisional) — no basis found in any document or the code; the baseline only declares sync loss after 12 consecutive misses [Code].
- **≥ 1,000 beats** (feasible) — ≈ 2.1–3.3 min of capture at 18,000–28,800 BPH; the test recordings carry 229–366 beats per ≈ 45 s [SNR].
- **Ground truth = synthetic + calibrated noise injection** — a reference instrument is itself an acoustic device exposed to the same noise; both could drift together and still "agree" (circularity). The generator's known beat schedule / programmed rate is the ground truth; a reference-instrument reading is a clean-condition sanity check only.

### QAS-4 · Consistency — Consistent Values Across Displays
> While measuring as usual, when a single measurement result is produced and fanned out to multiple graphs and numbers, every display rendered in the same on-screen frame derives from that single result and is mutually consistent — 0 value mismatches. [SJ] The X/D summary uses the same captured result set as the per-position display.

**Why this attribute**
- Plan §Correctness: *"the displayed values and graphs shall correspond to the underlying watch events while remaining internally consistent across the GUI, derived measurements, and longer-term summaries"*, and the architecture should make it possible to *"verify that calculations and visualizations are based on the same underlying data and timing assumptions."*
- That section bundles three demands: ① compute correctly → owned by QAS-2; ② stay internally consistent → **this scenario**; ③ remain usable under ambient noise → owned by QAS-3.
- This scenario measures only clause ② (all displays derive from one result, 0 mismatches), so the precise name is Consistency — calling it Correctness would overclaim clauses ① and ③.

| Element | Content |
|---------|---------|
| Source | The analysis/computation stage (internal) |
| Stimulus | A single measurement result is produced and fanned out to multiple displays (graphs/numbers) |
| Artifact | Numeric readouts and multiple graph displays |
| Environment | Measuring as usual (verification via Sim/Playback) |
| Response | All values and graphs shown together in one frame derive from one measurement result and agree; [SJ] X/D sequence summaries derive from the displayed per-position result set |
| Response Measure | Over a 10-min Sim/Playback run on a known reference input, across all sampled frames: every pair of simultaneously shown displays presents values from the same measurement result (within display rounding) — 0 mismatches; each display exposes its source-result identity (trace log / debug overlay) so the check is observable; [SJ] X/D source mismatch = 0 cases |

**Why these numbers**
- **0 mismatches** (grounded) — consistency is a correctness requirement, not a tunable performance number: the Project Plan requires displayed values and graphs to agree with the same underlying events, and the brief names "Correctness" as a driver. A shared tagged snapshot (snapshot ID) is a suggested tactic, not a required mechanism — the requirement is stated by observable behavior only.
- **10-min observation window on known input** (anchored) — reuses the QAS-1 run length and the Sim/Playback test harness so the check is reproducible.

### QAS-5 · Modifiability (Extensibility) — Adding a New Measurement/Filter/Graph
> In a tight-schedule development situation, when a developer adds a new graph, filter stage, or derived measurement, they can add it incrementally without tearing into existing code — within a per-kind change budget and with zero regressions.

**Why this attribute**
- Plan §Extensibility, Modifiability states it directly: *"Its architecture shall support the addition of new measurements, filters, graphs, and display modes without major redesign of existing code"* — a 1:1 match with this scenario's stimulus.
- Same section: enhancements *"implemented incrementally, tested independently, and added with limited impact on existing modules"* — "limited impact" is this scenario's change budget (≤ 1 registration point, 0 regressions).
- Attribute test: a developer-initiated change with a bounded change-scope measure is the defining shape of Modifiability; this scenario covers the extension (add-new) case.

| Element | Content |
|---------|---------|
| Source | Developer |
| Stimulus | Wants to add a new graph, a new filter stage, or a new derived measurement |
| Artifact | The system (codebase holding the measurement/display features) |
| Environment | During development, tight schedule |
| Response | Add incrementally without heavily tearing into existing code |
| Response Measure | New graph/display tab: ≤ 1 existing module changed (registration/wiring only), 0 changes to analysis/acquisition code. New filter stage (cf. F0–F3): ≤ 1 pipeline registration point changed, downstream filters and acquisition unchanged. New derived measurement: ≤ 1 calculation-registry change, 0 changes to acquisition/display frameworks. All kinds: 0 regressions — the existing-feature regression test set (hardware-free) passes before and after. (Informational planning target, not pass/fail: ≈ 5 person-days per graph.) |

**Why these numbers**
- **≤ 1 registration/wiring point per kind** (anchored) — the Project Plan demands incremental extension with separated responsibilities inside the 5-week box, with ~11 mandatory graph features; a bounded touch surface is what makes that schedule feasible. Per-kind budgets because graphs, filters, and measurements touch different profiles.
- **0 regressions** — operationalized as "the existing-feature regression test set passes before and after" (a bare 0 is meaningless without a detection method).
- **≈ 5 person-days** (informational only) — a planning estimate with no direct source; excluded from pass/fail because effort measures developer skill, not the architecture.

### QAS-6 · Usability — Reading and Operating on the Low-Resolution Touchscreen
> While using the device on the Raspberry Pi 5's 800×480 touchscreen, when the user reads measurement values and switches modes, the key readings are legible without scrolling/zooming and primary functions are operable by touch alone. Physical sizes (mm) are normative; pixel equivalents are advisory until the panel size is confirmed. [SJ] During position/sequence review, the active position and X/D summary are quickly identifiable.

**Why this attribute**
- Plan §Usability and User Purpose: *"The GUI should support ease of use by clearly showing the current signal, the detected measurement points, and the calculated values that matter most to the user, such as rate, beat error, amplitude."*
- The hardware section fixes the environment: *"a compact 5-inch capacitive display with 800×480 resolution … HDMI (video) and USB (touch input)"* — low resolution and touch input are given, not chosen.
- Attribute test: a user-initiated stimulus (read, operate) measured by legibility, touch operability, and task time is a Usability scenario by definition.

| Element | Content |
|---------|---------|
| Source | User (watchmaker / operator) |
| Stimulus | Reads measurement values and switches modes on the 800×480 touchscreen |
| Artifact | The GUI (spectrogram/scope/numeric displays and controls) |
| Environment | Raspberry Pi 5 + 800×480 touch display, normal use. Panel physical size unconfirmed (Draft self-contradicts: "8 Inch" heading vs "5-inch" body). The baseline GUI is hard-fixed at 1280×750 with no 800×480 layout, so re-layout is required work [Code] |
| Response | Present key readings legibly; allow primary functions by touch alone; [SJ] show active/selected position and X/D near the related values |
| Response Measure | Primary readings (rate, beat error, amplitude) shown simultaneously without scroll/zoom; glyph height ≥ 1.9 mm (≈ 16 arcmin at 40 cm working distance), contrast ≥ 4.5:1 (WCAG AA) — "≥ 24 px" retained as advisory only; all primary touch targets ≥ 9 mm physical (pixel equivalent advisory, re-derived once the panel size is confirmed); any primary mode reachable in ≤ 2 taps; [SJ] timed task with ≥ 3 representative users from the sequence-review screen: active position identified ≤ 5 s and X/D ≤ 10 s in ≥ 90 % of trials. Touch = single tap/drag; multi-touch gestures are out of scope ([JYP]) |

**Why these numbers**
- **Physical mm normative, px advisory** — "9 mm ≈ 48 px" holds only at ≈ 135 ppi (a 7-inch 800×480 panel); the Draft itself states both 8-inch (≈ 117 ppi → 9 mm ≈ 41 px) and 5-inch (≈ 187 ppi → ≈ 66 px), so pass/fail must not depend on the conversion.
- **≥ 9 mm touch targets** (anchored) — standard touch-ergonomics target size, kept as the physical criterion.
- **Glyph ≥ 1.9 mm / 16 arcmin @ 40 cm + contrast ≥ 4.5:1** (derived) — replaces the unmeasurable "readable at working distance" with a perception spec needing no test subjects (16 arcmin legibility practice + WCAG AA contrast).
- **≤ 2 taps** (provisional) — team criterion bounding primary-mode reachability; 800×480 itself is a direct Draft constraint.
- **[SJ] 5 s / 10 s identification** — made measurable as a timed task (≥ 3 users, ≥ 90 % of trials).
- **[JYP] touch scope** — "operate by touch" derives from the provided hardware, not an explicit Draft requirement; single tap/drag only — multi-touch (swipe/pinch) has no Draft basis.

## Priority Order (Selected Six)

B = business importance, R = technical risk (H/M/L).

| Priority | QAS | Quality (SAP) | B | R | Rationale |
|----------|-----|---------------|---|---|-----------|
| 1 | QAS-1 | Performance (Latency) | H | H | Headline "real-time / low latency" driver; feasibility on the Pi is the stated project risk |
| 2 | QAS-2 | Accuracy | H | H | Every derived measure depends on event-position accuracy — the foundation of the accuracy family; sub-sample risk at 48k |
| 3 | QAS-3 | Accuracy & Availability (Graceful Degradation) | H | H | Usable measurement in real bench environments; algorithmic risk under noise — robustness built on top of QAS-2 |
| 4 | QAS-4 | Consistency | H | M | Brief's explicit "Correctness" driver; single-source-of-truth design is well understood |
| 5 | QAS-5 | Modifiability (Extensibility) | H | M | 11 mandatory graphs in a 5-week box demand cheap, regression-free addition |
| 6 | QAS-6 | Usability | M | M | Fixed 800×480 panel; largely layout discipline once sizes are pinned |

**Ordering logic:** the H/H group (QAS-1 · 2 · 3) leads — QAS-1 as the headline driver, QAS-2 before QAS-3 because event-position accuracy is the foundation noise robustness builds on. In the H/M group, QAS-4 (explicit brief driver) precedes QAS-5. QAS-6 is the only selected B = M.

---

# Milestone1 — QA Final 1 (한국어)

## Quality Attribute Scenarios

### QAS-1 · Performance (Latency) — 소리 입력에서 화면 표시까지
> *(발표용 수정: 지연을 세 부분으로 분해해 보고 — (1) processing latency, (2) display latency, (3) processing+display latency.)*
>
> 타깃 플랫폼에서 측정하는 동안 마이크로 소리가 들어오면, 시스템은 입력 → 분석 → 표시 흐름으로 처리하여 화면에 표시한다. 지연은 세 경계 — 소리 도착, 분석 결과 산출, 화면 표시 — 에서 계측하여 (1) processing latency, (2) display latency, (3) processing+display latency로 보고하며, 합산 p99 ≤ 500 ms이다. 입력 rate 따라가기(블록 드롭 0·비트 누락 0)는 별도로 검증되는 본 측정의 전제 조건이다.

**왜 이 속성인가**
- 플랜 원문: *"The system shall minimize end-to-end latency between acoustic capture at the microphone and presentation of the corresponding waveform, markers, and computed values in the GUI."* (§Low Latency and Low Number of Missed Beats) — 마이크 캡처→GUI 표시의 종단 지연 최소화를 직접 요구.
- 플랜 원문: *"Teams shall report capture-to-processing latency, processing-to-display latency, and total end-to-end latency in milliseconds."* — 본 시나리오의 3구간 분해는 우리가 만든 게 아니라 **플랜이 명시한 보고 요구 그 자체**.
- 속성 판별: 자극(소리 도착)에 대한 응답을 시간 한계로 측정 → SAP 분류상 Performance(Latency)의 정의 그대로.

| 요소 | 내용 |
|------|------|
| 출처 | 마이크 / 시계 (외부) |
| 자극 | 마이크로 소리가 들어옴 |
| 대상 산출물 | 전체 입력 → 분석 → 표시 흐름 — 세 타임스탬프로 계측: t_sound_arrival(캡처) · t_result_produced(분석 출력) · t_on_screen(화면 표시) |
| 환경 | Raspberry Pi 5(8 GB)에서 Live 측정, 96,000 SPS 목표 — 48,000 SPS 최소에서도 충족; GUI 활성, 연속 정상 부하 |
| 응답 | 처리하여 화면에 표시함; 세 지연 구간을 보고함 |
| 응답 척도 | 10분 연속 실행 동안, capture/processing/display 타임스탬프로 측정(Draft의 지연 보고 요구에 따름): **(1) processing latency**(t_sound_arrival → t_result_produced) — p99 측정·보고; **(2) display latency**(t_result_produced → t_on_screen) — p99 측정·보고; **(3) processing+display latency**(종단, t_sound_arrival → t_on_screen) — **p99 ≤ 500 ms** (pass/fail 게이트) |

**측정값 근거**
- **3구간 분해** (Draft의 지연 보고 요구에 따름) — 브리프는 지연의 최소화와 *보고*를 함께 요구; 분석 출력 경계에서 분해하면 Pi에서 시간이 어디에 쓰이는지(분석 vs 렌더링)를 국소화하여 최적화를 이끈다. 구간별 한계값은 아직 게이트가 아님 — 구간별 예산은 Planned Experiments 후 설정(provisional); pass/fail은 합산 ≤ 500 ms만.
- **합산 ≤ 500 ms** (provisional, anchored) — ① 일반적인 28,800 BPH에서 약 4비트 주기(비트 주기 125 ms [EQ]; Sim 기본 BPH [Code]); ② 화면이 실시간에 가깝게 느껴지는 상한 약 600 ms보다 여유 있게 잡은 값(팀 UX 근거); ③ 베이스라인의 구조적 표시 경로 약 70 ms(Linux/Pi 블록 주기 20 ms + 고정 50 ms envelope 정렬 지연 [Code])의 7배 이상 — Pi에서 분석+렌더링에 여유 확보. 브리프는 수치를 정하지 않으므로 provisional.
- **display 구간 기준점** — 베이스라인의 구조적 표시 경로 ≈ 70 ms [Code]가 구간 (2)의 sanity 기준점.
- **10분 연속 실행** (anchored) — Witschi Sequence mode 최대 측정 시간과 일치; 더 긴 내구성은 본 범위 밖.
- **환경 고정** — 브리프가 명시 경고: PC 성능은 Pi로 이전되지 않음.

### QAS-2 · Accuracy — 비트 위치 정밀 검출
> 평소처럼 측정하는 동안 새 비트(틱/톡)가 도착하면, 시스템은 그 onset과 peak 위치를 정확히 찾아내고 모든 처리 단계(획득 → 필터링 → 이벤트 검출 → 계산, Draft 기준)를 관통하여 시간 정밀도를 보존하며, onset/peak 위치 오차 ≤ 0.1 ms를 만족한다. 0.1 ms 정답은 실제 하드웨어로 얻을 수 없으므로 위치가 알려진 합성 신호로 검증한다.

**왜 이 속성인가**
- 플랜 원문: *"the software must accurately identify the start/onset and peak of the important acoustic signals used to compute watch metrics such as rate, beat error, amplitude, lift angle."* (§Measurement Accuracy, Error Detection, and Handling) — onset/peak의 정확한 식별을 직접 요구.
- 플랜 원문: *"the architecture should preserve timing precision throughout acquisition, filtering, event detection, and calculation."* — 전 처리 단계의 시간 정밀도 보존 = 본 시나리오의 응답 그대로.
- 속성 판별: 응답 척도가 정답 대비 오차 한계(≤ 0.1 ms) → 빠르기(Performance)도, 표시 간 일치(Consistency)도 아닌 **참값에 얼마나 가까운가 = Accuracy**.

| 요소 | 내용 |
|------|------|
| 출처 | 시계 비트 (외부 입력 스트림) |
| 자극 | 새 비트(틱/톡)가 입력 스트림에 도착함 |
| 대상 산출물 | 비트 감지 / 시간 계산 부분 |
| 환경 | 평소처럼 측정 중; 96,000 SPS 목표와 48,000 SPS 최소에서 검증 |
| 응답 | onset과 peak 위치를 정확히 찾아내고, 모든 처리 단계를 관통하여 시간 정밀도를 보존함 |
| 응답 척도 | 위치가 알려진 합성 비트 ≥ 1,000개(Sim mode, FR-05-05 / FR-12-16; onset/peak는 FR-08-06 기준)에 대해 onset/peak 위치 최대 오차 ≤ 0.1 ms; 96,000 SPS(= 9.6샘플)와 48,000 SPS(= 4.8샘플 — 서브샘플 보간 필요)에서 검증; 실제 하드웨어 불요 |

**측정값 근거**
- **≤ 0.1 ms** (grounded) — ① 기준 계측기의 beat error 스펙과 일치(X1 해상도 0.1 ms / 정확도 ± 0.1 ms [X1]); ② Draft의 0.6 ms "양호" beat error 기준의 약 1/6 → 임상적으로 유의한 beat error 차이를 해상 가능; ③ 베이스라인 표시와 Sim 입력 모두 이미 0.1 ms 단위 [Code].
- **샘플 환산** (derived) — 0.1 ms = 48/96/192k에서 4.8 / 9.6 / 19.2 샘플; 최악 케이스는 48k 최소 레이트 → 서브샘플 보간 필요 — 베이스라인 검출기가 이미 서브샘플 보간 수행(onset 선형, peak 포물선) [Code]이므로 실현 가능.
- **합성 검증, ≥ 1,000비트** — 실제 하드웨어는 0.1 ms 정답 제공 불가; Sim 테스트 하네스로 위치가 선험적으로 알려진 신호 사용; 표본 크기는 QAS-3과 동일.

### QAS-3 · Accuracy & Availability (Graceful Degradation) — 잡음·약신호 환경
> 주변 잡음이 섞이거나 약한 신호가 들어오는 열악한 환경에서, 시스템은 올바른 검출·분석에 필요한 시계 신호 특징은 보존하면서 주변 대화 같은 불요 잡음을 줄여 사용자가 판독 가능한 측정을 얻게 하고(Brief), 신호 품질이 임계 이하면 잘못된 값 대신 "신호 약함"을 표시한다: SNR ≥ 14 dB에서 1,000비트 이상 기준 비트 감지율 ≥ 95%, 일오차 ≤ ±3 s/d; 임계 미만에서는 "신호 약함"만 표시하고 잘못된 값 0회. [SJ] Invalid/low-confidence position result는 X/D 계산에서 제외(규칙은 FR-04-06 소유).

**왜 이 속성인가**
- Accuracy 측 원문: *"reduce extraneous noise, such as nearby speech, while preserving the features needed for correct beat detection and measurement."* (§Correctness) — 잡음을 줄이되 올바른 검출에 필요한 특징은 보존하라는 요구.
- Availability 측 원문: *"the system should degrade gracefully when the signal is weak, noisy, or partially missing, rather than producing unstable or misleading outputs."* (§Measurement Accuracy) — **"degrade gracefully"는 플랜의 표현 그대로**이며, 오해를 부르는 출력 대신 우아한 성능 저하를 요구.
- 속성 판별: 임계 이상에서는 잡음 하 정확도(감지율·일오차)를, 임계 미만에서는 잘못된 값 대신 "신호 약함"이라는 올바른 서비스의 지속을 게이트 → 두 속성의 결합(Accuracy & Availability)이 정확한 이름.

| 요소 | 내용 |
|------|------|
| 출처 | 주변 잡음 / 약한 신호(외부) |
| 자극 | 잡음이 섞이거나 신호가 약하게 들어옴 |
| 대상 산출물 | 잡음 제거 / 비트 감지 부분과 신호 품질 표시 |
| 환경 | 열악한 작업 환경 — Sim/Playback 입력에 보정된 잡음을 통제·일정 SNR로 주입하여 재현(SNR 정의: 비트당 임펄스 피크 대 분석 대역 내 잡음 RMS, 방법은 [SNR] 기준) |
| 응답 | (Accuracy) 잡음 하에서 비트를 감지하고 rate를 허용오차 내로 계산; (Availability) 품질 임계 미만이면 우아하게 성능 저하 — 어떤 값도 아닌 "신호 약함"을 표시; [SJ] invalid/low-confidence 결과를 X/D에서 제외(FR-04-06) |
| 응답 척도 | 생성기의 기지 비트 스케줄·프로그래밍된 rate 대비, 1,000비트 이상 기준: SNR ≥ 14 dB에서 감지율 ≥ 95%, 일오차 ≤ ±3 s/d; 임계 미만: "신호 약함"만 표시, 잘못된 값 0회(잘못된 값 = "신호 약함" 플래그 없이 표시된 판독값 중 정답 대비 오차가 허용오차 초과); [SJ] invalid/low-confidence 값의 X/D 포함 0건 |

**측정값 근거**
- **SNR ≥ 14 dB** (실측 anchored; 합격 기준으로서는 provisional) — WeiShi-mic 시험 녹음 9개의 클린 실측 = 30–51 dB(1 ms envelope 방법; 최악 파일 중앙 비트 33.4 dB / 약비트 30.4 dB) [SNR]; Sim realistic 모드 ≈ 45 dB, clean 설정 ≈ 58 dB [Code]. 따라서 14 dB는 최악 클린 캡처보다 ≥ 16 dB 낮은 심한 열화 조건 — 도달하려면 의도적 잡음 주입이 필요. 주의: 전체-신호-RMS 지표로는 동일 최악 파일이 15.1 dB로 읽힘 — 14 dB를 "샘플 최저치보다 1 dB 낮춘 값"으로 설명하지 말 것(지표가 바뀌고, 열화 마진이 0이 되며, 커플링 약화와 주변 잡음을 혼동) [SNR §Definition Sensitivity].
- **일오차 ≤ ±3 s/d** (anchored) — 잡음 유발 오차를 가장 엄격한 Witschi 등급 대역의 반폭 이내로 제한(Chronometer −2…+6 s/d; 참고: Gent's −5…+15, Lady's −5…+25) [TC].
- **감지율 ≥ 95%** (provisional) — 문서·코드 어디에도 근거 없음; 베이스라인은 연속 12회 누락 시에만 sync loss 선언 [Code].
- **≥ 1,000비트** (feasible) — 18,000–28,800 BPH에서 캡처 약 2.1–3.3분; 시험 녹음은 ~45초당 229–366비트 [SNR].
- **정답 = 합성 신호 + 보정 잡음 주입** — 기준 장비도 같은 잡음에 노출되는 음향 계측기라서 둘이 같이 틀려도 "일치"로 통과 가능(순환성). 생성기의 기지 비트 스케줄·프로그래밍된 rate가 정답; 기준 장비 판독값은 클린 조건 sanity check 용도만.

### QAS-4 · Consistency — 표시 간 값 일치
> 평소처럼 측정하는 동안 하나의 측정 결과가 여러 그래프와 숫자로 전달될 때, 한 화면 프레임에 함께 렌더링되는 모든 표시는 그 단일 결과에서 파생되어 상호 일치한다 — 값 불일치 0회. [SJ] X/D summary는 position별 표시와 동일한 captured result set을 사용한다.

**왜 이 속성인가**
- 플랜 §Correctness 원문: *"the displayed values and graphs shall correspond to the underlying watch events while remaining internally consistent across the GUI, derived measurements, and longer-term summaries"* / *"verify that calculations and visualizations are based on the same underlying data and timing assumptions."*
- 이 절은 세 요구의 묶음: ① 올바른 계산(*compute … correctly*) → QAS-2가 검증, ② 내부 일관성(*internally consistent / same underlying data*) → **본 시나리오**, ③ 잡음 하 사용 가능(*remain usable in the presence of ambient acoustic noise*) → QAS-3이 검증.
- 본 시나리오가 측정하는 것은 ②뿐(모든 표시가 한 결과에서 파생, 불일치 0)이므로 정확한 이름은 Consistency — Correctness로 부르면 ①·③까지 커버하는 듯한 과대 표기가 됨. 즉 플랜의 Correctness 드라이버는 QAS-2·3·4로 **분해되어 전부 실현**되고 있음.

| 요소 | 내용 |
|------|------|
| 출처 | 분석/계산 단계 (내부) |
| 자극 | 하나의 측정 결과가 여러 표시(그래프/숫자)로 전달됨 |
| 대상 산출물 | 수치 표시값과 여러 그래프 표시 |
| 환경 | 평소처럼 측정 중 (검증은 Sim/Playback) |
| 응답 | 한 프레임에 함께 표시되는 모든 값·그래프가 하나의 측정 결과에서 파생되어 일치함; [SJ] X/D sequence summary는 표시된 position별 result set에서 산출 |
| 응답 척도 | 기지 기준 입력의 10분 Sim/Playback 실행 동안, 샘플링된 전체 프레임에서: 동시에 표시되는 모든 표시 쌍이 동일 측정 결과의 값을 표시(표시 반올림 이내) — 불일치 0회; 각 표시는 소스 결과 식별자를 노출(trace 로그/디버그 오버레이)하여 검사 가능; [SJ] X/D source mismatch 0건 |

**측정값 근거**
- **불일치 0회** (grounded) — 일치는 조정 가능한 성능 수치가 아니라 정합성 요구: Project Plan은 표시값과 그래프가 동일한 underlying events와 일치할 것을 요구하고, 브리프는 "Correctness"를 드라이버로 명시. 스냅샷 ID 등 태그된 공유 스냅샷은 권고 전술이며 필수 메커니즘이 아님 — 요구사항은 관찰 가능한 행위로만 기술.
- **기지 입력 10분 관측 구간** (anchored) — QAS-1의 실행 길이와 Sim/Playback 테스트 하네스를 재사용하여 재현 가능.

### QAS-5 · Modifiability (Extensibility) — 새 측정/필터/그래프 추가
> 일정이 촉박한 개발 상황에서 개발자가 새 그래프·필터 단계·파생 측정값을 추가할 때, 기존 코드를 크게 뜯어고치지 않고 점진적으로 추가할 수 있다 — 종류별 변경 예산과 회귀 0건.

**왜 이 속성인가**
- 플랜 원문: *"Its architecture shall support the addition of new measurements, filters, graphs, and display modes without major redesign of existing code."* (§Extensibility, Modifiability) — 본 시나리오의 자극(새 측정/필터/그래프 추가)과 1:1 대응.
- 플랜 원문: *"enhancements can be implemented incrementally, tested independently, and added with limited impact on existing modules."* — "limited impact"가 곧 본 시나리오의 변경 예산(등록 지점 ≤ 1, 회귀 0).
- 속성 판별: 개발자 자극 + 변경 범위 척도 → SAP Modifiability; 그중 신규 추가(extension) 케이스이므로 Extensibility.

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 |
| 자극 | 새 그래프, 새 필터 단계, 또는 새 파생 측정값을 추가하려고 함 |
| 대상 산출물 | 시스템(측정·표시 기능을 담은 코드베이스) |
| 환경 | 개발 중, 일정이 촉박함 |
| 응답 | 기존 코드를 크게 뜯어고치지 않고 점진적으로 추가함 |
| 응답 척도 | 새 그래프/표시 탭: 기존 모듈 변경 ≤ 1개(등록/배선부만), 분석/획득 코드 변경 0건. 새 필터 단계(F0–F3 참조): 파이프라인 등록 지점 변경 ≤ 1개, 하류 필터·획득부 무변경. 새 파생 측정값: 계산 레지스트리 변경 ≤ 1개, 획득/표시 프레임워크 변경 0건. 전 종류 공통: 회귀 0건 — 기존 기능 회귀 테스트 셋(하드웨어 불요)이 변경 전후 모두 통과. (pass/fail이 아닌 참고용 계획 목표: 그래프 1종당 약 5인일.) |

**측정값 근거**
- **종류별 등록/배선 지점 ≤ 1개** (anchored) — Project Plan은 5주 일정 안에서 책임을 분리하며 점진적으로 확장하라고 요구하고, 필수 그래프가 약 11종; 좁은 변경 표면이 그 일정을 가능케 하는 조건. 그래프·필터·측정값은 변경 프로파일이 달라 종류별 예산으로 분리.
- **회귀 0건** — "기존 기능 회귀 테스트 셋이 변경 전후 통과"로 조작화(검출 방법 없는 0은 무의미).
- **약 5인일** (참고용) — 직접 근거가 없는 일정 추정값; 작업량은 아키텍처가 아니라 개발자 숙련도를 측정하므로 pass/fail에서 제외.

### QAS-6 · Usability — 저해상도 터치스크린에서 읽기·조작
> Raspberry Pi 5의 800×480 터치스크린에서 사용자가 측정값을 읽고 모드를 전환할 때, 핵심 측정값은 스크롤/확대 없이 가독성 있게 표시되고 주요 기능은 터치만으로 조작 가능하다. 물리 크기(mm)가 규범 기준이며, 픽셀 환산치는 패널 크기 확정 전까지 참고용. [SJ] Position/sequence review 중 active position과 X/D summary를 빠르게 식별 가능.

**왜 이 속성인가**
- 플랜 원문: *"The GUI should support ease of use by clearly showing the current signal, the detected measurement points, and the calculated values that matter most to the user, such as rate, beat error, amplitude."* (§Usability and User Purpose) — 핵심 측정값의 가독 표시를 직접 요구.
- 하드웨어 원문: *"a compact 5-inch capacitive display with 800×480 resolution … HDMI (video) and USB (touch input)."* — 저해상도·터치 입력은 선택이 아니라 주어진 환경.
- 속성 판별: 사용자 자극(읽기·조작)에 가독성·터치 조작성·과업 시간으로 응답을 측정 → Usability의 정의 그대로.

| 요소 | 내용 |
|------|------|
| 출처 | 사용자(시계공 / 측정자) |
| 자극 | 800×480 터치스크린에서 측정값을 읽고 모드를 전환함 |
| 대상 산출물 | GUI(스펙트로그램/스코프/수치 표시와 컨트롤) |
| 환경 | Raspberry Pi 5 + 800×480 터치 디스플레이, 평소 사용 중. 패널 물리 크기 미확정(Draft 자기모순: 헤더 "8 Inch" vs 본문 "5-inch"). 베이스라인 GUI는 1280×750 고정으로 800×480 레이아웃이 없어 재레이아웃이 필수 작업 [Code] |
| 응답 | 핵심 측정값을 가독성 있게 표시; 주요 기능을 터치만으로 조작 가능; [SJ] active/selected position과 X/D를 관련 측정값 근처에 표시 |
| 응답 척도 | 주요 측정값(일오차·비트오차·진폭)을 스크롤/확대 없이 동시 표시; 글리프 높이 ≥ 1.9 mm(작업 거리 40 cm에서 약 16 arcmin), 대비 ≥ 4.5:1 (WCAG AA) — "≥ 24 px"는 참고용으로만 유지; 모든 주요 터치 타깃 물리 크기 ≥ 9 mm(픽셀 환산치는 참고용, 패널 크기 확정 후 재산출); 주요 모드 도달 ≤ 2 탭; [SJ] 대표 사용자 ≥ 3명이 sequence-review 화면에서 시작하는 시간 측정 과업에서 시도의 ≥ 90%에서 active position 5초 이내, X/D 10초 이내 식별. 터치 = 단일 탭/드래그; 멀티터치 제스처는 범위 밖([JYP]) |

**측정값 근거**
- **물리 mm 규범, px 참고** — "9 mm ≈ 48 px"는 약 135 ppi(7인치 800×480 패널)에서만 성립; Draft 자체가 8인치(≈ 117 ppi → 9 mm ≈ 41 px)와 5인치(≈ 187 ppi → ≈ 66 px)를 동시에 기술하므로 pass/fail이 환산에 의존하면 안 됨.
- **터치 타깃 ≥ 9 mm** (anchored) — 통용되는 터치 인체공학 타깃 크기 기준; 물리 기준으로 유지.
- **글리프 ≥ 1.9 mm / 40 cm에서 16 arcmin + 대비 ≥ 4.5:1** (derived) — 측정 불가능한 "작업 거리에서 판독 가능"을 피험자 없이 검증 가능한 지각 사양으로 교체(16 arcmin 가독성 관행 + WCAG AA 대비).
- **≤ 2 탭** (provisional) — 주요 모드 도달을 제한하는 팀 기준; 800×480 자체는 Draft의 직접 제약.
- **[SJ] 5초/10초 식별** — 측정 가능한 시간 과업으로 전환(사용자 ≥ 3명, 시도의 ≥ 90%).
- **[JYP] 터치 범위** — "터치로 조작"은 제공된 하드웨어에서 파생한 가정이지 Draft의 명시 요구가 아님; 단일 탭/드래그로 한정 — 멀티터치(swipe/pinch)는 Draft에 근거 없음.

## 우선순위 (선정 6개)

B = 비즈니스 중요도, R = 기술 리스크 (H/M/L).

| 순위 | QAS | 품질 속성 (SAP) | B | R | 근거 |
|------|-----|----------------|---|---|------|
| 1 | QAS-1 | Performance (Latency) | H | H | 프로젝트 대표 드라이버("real-time / low latency"); Pi에서의 실현 가능성이 명시된 리스크 |
| 2 | QAS-2 | Accuracy | H | H | 모든 파생 측정값이 이벤트 위치 정확도에 의존 — 정확도 계열의 토대; 48k에서 서브샘플 리스크 |
| 3 | QAS-3 | Accuracy & Availability (Graceful Degradation) | H | H | 실제 작업 환경에서 쓸 수 있는 측정; 잡음 하 알고리즘 리스크 — QAS-2 위에 쌓이는 강건성 |
| 4 | QAS-4 | Consistency | H | M | 브리프의 명시 "Correctness" 드라이버; single-source-of-truth 설계는 잘 알려짐 |
| 5 | QAS-5 | Modifiability (Extensibility) | H | M | 5주 안에 그래프 11종 — 저비용·무회귀 추가가 필수 |
| 6 | QAS-6 | Usability | M | M | 800×480 고정 패널; 크기 확정 후엔 주로 레이아웃 규율 문제 |

**정렬 논리:** H/H 그룹(QAS-1 · 2 · 3)이 선두 — QAS-1은 헤드라인 드라이버, QAS-2가 QAS-3보다 앞서는 이유는 이벤트 위치 정확도가 잡음 강건성이 딛고 서는 토대이기 때문. H/M 그룹에서는 브리프 명시 드라이버인 QAS-4를 QAS-5보다 앞에 둠. QAS-6은 선정 항목 중 유일한 B = M.
