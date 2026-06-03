# Milestone1 Jae-hong Oh — QA draft 3

> English version above, Korean version below. (위쪽은 영어 버전, 아래쪽은 한국어 버전입니다.)
>
> **draft 3 (2026-06-03)** — Synthesis of `Milestone1_QA_draft.md` (scenarios + [OJH]/[JYP]/[SJ] notes), `review_result.md` (SAP 6-part review), and `Milestone1_QA_draft2.md` (review applied + threshold grounding). Framework: SEI 6-part Quality Attribute Scenario (SAP — Bass · Clements · Kazman). Change vs draft 2: the central grounding table (G1–G19) is dissolved into a short **Why these numbers** list under each scenario, so each threshold and all of its evidence read together; reviewer threads are incorporated and closed.

## How to Read

- Each scenario states the six SAP parts: **Source · Stimulus · Artifact · Environment · Response · Response Measure**.
- Evidence sources: **[X1]** Witschi Chronoscope X1-G3 manual · **[TC]** Witschi Training Course · **[EQ]** TimeGrapher Equations doc · **[SNR]** `SNR-Analysis-WeishiMic.md` (measured, this folder) · **[Code]** TimeGrapher baseline code · **[Draft]/[Brief]** project draft / brief.
- Threshold status: **grounded** (directly supported by a source) · **anchored** (team value with a cited reference point) · **derived** (computed from cited sources) · **provisional** (no numeric basis — to be confirmed by the Planned Experiments before Milestone 2). Entries describing a verification method rather than a numeric threshold carry no status tag.

## Shared Definitions

| Term | Definition |
|------|------------|
| Module | A cohesive code unit behind a single interface (interface + implementation; its own tests excluded). Counting unit for QAS-7/8/9; the concrete decomposition is fixed by the Milestone-2 module view. |
| Domain code | The analysis/calculation logic — beat detection, time calculation, rate/amplitude/beat-error computation, X/D aggregation — excluding acquisition, platform/OS, GUI, and registration/wiring code (per the Draft's layer separation). |
| Core analysis stages | Beat/onset detection · onset/peak location · rate computation · beat-error computation · amplitude (incl. lift angle) computation · X/D aggregation. Shared denominator for QAS-2/6/10. |
| Sample-rate operating points | 48,000 SPS (minimum) · 96,000 SPS (objective) · 192,000 SPS (stretch) — see C-6. |
| Provisional | A team-chosen threshold without a numeric basis in the brief; confirmed or revised by experiment before Milestone 2. |

## QAS Priorities

Per the Milestone-1 requirement that drivers be prioritized. B = business importance, R = technical risk (H/M/L).

| QAS | Quality (SAP) | B | R | Rationale |
|-----|---------------|---|---|-----------|
| QAS-1 | Performance (Latency) | H | H | Headline "real-time / low latency" driver; feasibility on the Pi is the stated project risk |
| QAS-2 | Performance (Throughput) | H | H | Keeping up with 96k SPS on the Pi is the binding feasibility risk; precondition of QAS-1/3 |
| QAS-3 | Availability (Resource-Leak Resilience) | M | M | Long-run sessions (Long-Term Performance Graph) require it; mitigations are standard |
| QAS-4 | Correctness (Display Consistency) | H | M | Brief's explicit "Correctness" driver; single-source-of-truth design is well understood |
| QAS-5 | Accuracy & Availability (Graceful Degradation) | H | H | Usable measurement in real bench environments; algorithmic risk under noise |
| QAS-6 | Accuracy (Measurement Correctness) | H | H | Every derived measure depends on event-position accuracy; sub-sample risk at 48k |
| QAS-7 | Modifiability (Extensibility) | H | M | 11 mandatory graphs in a 5-week box demand cheap, regression-free addition |
| QAS-8 | Modifiability (Modularity) | M | L | Supports QAS-7; verified by representative change scenarios |
| QAS-9 | Modifiability (Portability) | M | L | C-3 imposes both platforms; the Qt baseline (C-5) mitigates |
| QAS-10 | Testability | H | M | Enables ground-truth verification of QAS-2/5/6/13 and the regression safety of QAS-7 |
| QAS-11 | Usability (Touchscreen) | M | M | Fixed 800×480 panel; largely layout discipline once sizes are pinned |
| QAS-12 | Availability (Recoverability) | M | M | Bench-workflow resilience; standard device-fault handling |
| QAS-13 | Accuracy (Computed Values) | H | M | Closes the amplitude/beat-error accuracy gap; Sim ground truth makes it testable |
| QAS-14 | Usability (Session Continuity) | M | M | Explicit, repeated brief requirement ("without losing the recorded signal or forcing a reset") |
| QAS-15 | Usability (Alert Annunciation) | M | L | FR-anchored alerts (FR-02-05/09, FR-06-11/13); "don't leave the user guessing" |

**Top architecture-shaping drivers:** QAS-1/2 (real-time performance on the Pi), QAS-5/6/13 (measurement accuracy and noise robustness), QAS-7/10 (extensibility and testability within the schedule).

## Quality Attribute Scenarios

### QAS-1 · Performance (Latency) — From Sound Input to Screen Display
> While measuring on the target platform, when sound arrives at the microphone, the system processes it through the input → analysis → display flow and shows it on screen with p99 end-to-end latency ≤ 500 ms. Keeping up with the input rate (0 dropped blocks / 0 missed beats) is owned by QAS-2 and is a precondition here.

| Element | Content |
|---------|---------|
| Source | The microphone / watch (external) |
| Stimulus | Sound arrives at the microphone |
| Artifact | The full input → analysis → display flow |
| Environment | Live measurement on the Raspberry Pi 5 (8 GB, C-1) at the 96,000 SPS objective rate — must also hold at the 48,000 SPS minimum (C-6); GUI active, continuous normal load |
| Response | Process and show on screen |
| Response Measure | p99 end-to-end latency (sound arrival → on-screen) ≤ 500 ms over a 10-min continuous run, measured via capture / processing / display timestamps (per the Draft's latency-reporting requirement) |

**Why these numbers**
- **≤ 500 ms** (provisional, anchored) — ① ≈ 4 beat periods at the typical 28,800 BPH (beat period 125 ms [EQ]; Sim default BPH [Code]); ② below the ≈ 600 ms upper bound at which a display still feels near-real-time (team UX rationale, draft 1); ③ > 7× the baseline's ≈ 70 ms structural display path (20 ms Linux/Pi block cadence + fixed 50 ms envelope-alignment delay [Code]) — headroom remains for analysis + render on the Pi. The brief mandates minimizing and reporting latency but sets no number — hence provisional.
- **10-min run** (anchored) — matches the Witschi Sequence-mode maximum measurement time; longer durability is owned by QAS-3.
- **Environment pinned** — the brief explicitly warns PC performance does not transfer to the Pi; rates per C-6.

### QAS-2 · Performance (Throughput) — Analysis Keep-Up and Compute Budget
> While measuring on the target platform, when audio blocks arrive at the configured sample-rate cadence, the system sustains the input rate without backlog — 0 dropped blocks, 0 missed beats, no backlog growth over a 10-min run — and, as the enabling budget, completes each block's analysis within p99 ≤ 80 % of the block inter-arrival interval.

| Element | Content |
|---------|---------|
| Source | The audio input / acquisition pipeline (delivers blocks at the configured cadence) |
| Stimulus | An audio block arrives for analysis |
| Artifact | The analysis stage, instrumented from t_block_handed_to_analysis to t_result_produced (beat detection + rate/amplitude/beat-error computation; excludes capture buffering and display rendering) |
| Environment | Live on the Raspberry Pi 5 at 96,000 SPS objective — also verified at the 48,000 SPS minimum; 192,000 SPS stretch measured but not gated (C-6) |
| Response | Sustain the input rate; complete each block's analysis within the compute budget |
| Response Measure | Over a 10-min run at each gated rate: 0 dropped blocks (input-callback overrun counter); 0 missed beats vs the known Sim/Playback beat schedule (missed beat = an expected beat with no detection); no backlog (queue-depth) growth trend; p99 per-block compute time ≤ 0.8 × the block inter-arrival interval (= 16 ms at the baseline's 20 ms Linux/Pi cadence) |

**Why these numbers**
- **p99 ≤ 0.8 × inter-arrival** (grounded) — the baseline delivers 20 ms blocks on Linux/Pi (10 ms on Windows) [Code] → budget 16 ms/block; staying under the arrival cadence is exactly what makes "0 dropped blocks" achievable, and 0.8 leaves 20 % headroom for scheduling jitter. Live blocks are ALSA-driven and variable [Code], so they are measured against the observed inter-arrival interval. (Supersedes draft 1's fixed "100 ms ≈ one beat period @ 36,000 BPH" budget — a fixed budget not tied to the cadence can itself imply backlog.)
- **0 missed beats** (grounded observability) — verified against the known Sim/Playback beat schedule (QAS-10); the tg library exposes per-beat events and sync-loss reporting (BPH auto-detect 1.5 s; sync loss after 12 consecutive misses) [Code].
- **10-min run** (anchored) — as QAS-1 (Witschi Sequence-mode maximum).

### QAS-3 · Availability (Resource-Leak Resilience) — No Degradation Over Long Runs
> While measuring continuously on the Raspberry Pi 5 (8 GB) for an extended session, the system keeps delivering correct service without degrading — no memory leak, no crash, no UI freeze, no thermal-throttling slowdown — over a ≥ 2-hour continuous run (≥ 6 h for Long-Term Performance Graph use). Keep-up is a precondition verified by QAS-2.

| Element | Content |
|---------|---------|
| Source | The operator starting a long unattended measurement (e.g., a Long-Term Performance test, G07) |
| Stimulus | A continuous measurement runs for an extended period without stopping |
| Artifact | The whole system, Raspberry Pi memory / process health |
| Environment | Continuous run ≥ 2 h (≥ 6 h for long-term-graph use) on the Raspberry Pi 5 (8 GB) at 96,000 SPS; keep-up per QAS-2 |
| Response | Continue correct service without degrading: no resource exhaustion, no crash, no freeze, no thermal throttling |
| Response Measure | Over the full run: linear-fit RSS slope over every 30-min window ≤ 0 + ε (ε = measurement-noise allowance); 0 crashes; 0 screen freezes (freeze = no screen update ≥ 2 s, detected via a render-heartbeat log); mean CPU ≤ 70 %, peak ≤ 90 %; 0 thermal-throttling events reported by the Pi's governor |

**Why these numbers**
- **≥ 2 h (≥ 6 h)** (anchored) — ≥ 2 h is the reference instrument's first long-run integration band ("0–2 h → 2 s" auto table [X1]); the X1 measures up to 99:59:58 h and Witschi Vario tracks stability up to 100 h [X1][TC]. Replaces draft 1's 10 min, which could not substantiate "no degradation over long runs" ([JYP] applied).
- **RSS slope ≤ 0 + ε** (anchored) — the baseline's memory shape is fixed at Start (30 s ring buffer allocated once = 5.76 / 11.52 / 23.04 MB @ 48/96/192k; graph history pruned beyond 10 s [Code]), so no structural growth is expected; ε covers allocator/Qt caches. Replaces draft 1's "≤ 20 MB per 5 min" cap (≈ 20 % of the ≈ 110 MB RSS observed on a previous project) — a fixed cap lets slow leaks pass and flags benign one-shot allocations (review).
- **freeze = no update ≥ 2 s** (provisional) — users clearly perceive a ≥ 2 s stall as a hang (team UX rationale, draft 1). (The X1's 2 s minimum integration step is a numeric coincidence, not evidence for a render-freeze window.)
- **CPU 70 % / 90 %, 0 throttling** (provisional) — no source found; included because sustained 96k load on the Pi is the brief's stated feasibility risk.

### QAS-4 · Correctness (Display Consistency) — Consistent Values Across Displays
> While measuring as usual, when a single measurement result is produced and fanned out to multiple graphs and numbers, every display rendered in the same on-screen frame derives from that single result and is mutually consistent — 0 value mismatches. [SJ] The X/D summary uses the same captured result set as the per-position display.

| Element | Content |
|---------|---------|
| Source | The analysis/computation stage (internal) |
| Stimulus | A single measurement result is produced and fanned out to multiple displays (graphs/numbers) |
| Artifact | Numeric readouts and multiple graph displays |
| Environment | Measuring as usual (verification via Sim/Playback) |
| Response | All values and graphs shown together in one frame derive from one measurement result and agree; [SJ] X/D sequence summaries derive from the displayed per-position result set |
| Response Measure | Over a 10-min Sim/Playback run on a known reference input (QAS-10), across all sampled frames: every pair of simultaneously shown displays presents values from the same measurement result (within display rounding) — 0 mismatches; each display exposes its source-result identity (trace log / debug overlay) so the check is observable; [SJ] X/D source mismatch = 0 cases |

**Why these numbers**
- **0 mismatches** (grounded) — consistency is a correctness requirement, not a tunable performance number: the Project Plan requires displayed values and graphs to agree with the same underlying events (draft 1), and the brief names "Correctness" as a driver. A shared tagged snapshot (snapshot ID) is a suggested tactic, not a required mechanism — the requirement is stated by observable behavior only (review).
- **10-min observation window on known input** (anchored) — reuses the QAS-1/2 run length and the QAS-10 harness so the check is reproducible.

### QAS-5 · Accuracy & Availability (Graceful Degradation) — Under Noisy or Weak Signals
> In a poor environment where ambient noise mixes in or a weak signal arrives, the system filters out noise while preserving the needed sounds, and when signal quality is below threshold it shows "signal weak" instead of a wrong value: at SNR ≥ 14 dB, beat detection ≥ 95 % and rate error ≤ ±3 s/d over ≥ 1,000 beats; below threshold, "signal weak" only and 0 wrong values. [SJ] Invalid / low-confidence position results are excluded from X/D calculations (rule owned by FR-04-06).

| Element | Content |
|---------|---------|
| Source | Ambient noise / weak signal (external) |
| Stimulus | Noise mixes in or the signal arrives weak |
| Artifact | The noise-removal / beat-detection part and the signal-quality indication |
| Environment | Noisy bench environment, reproduced by mixing calibrated noise into Sim/Playback input at a controlled, held-constant SNR (SNR definition: per-beat impulse peak vs ambient-noise RMS in the analysis band, method per [SNR]) |
| Response | (Accuracy) detect beats and compute rate within tolerance under noise; (Availability) below the quality threshold, degrade gracefully — show "signal weak" instead of any value; [SJ] exclude invalid/low-confidence results from X/D (rule per FR-04-06) |
| Response Measure | Against the generator's known beat schedule and programmed rate, over ≥ 1,000 beats: detection rate ≥ 95 % and rate error ≤ ±3 s/d at SNR ≥ 14 dB; below threshold: only "signal weak" and 0 wrong values (wrong value = a reading shown without the "signal weak" flag whose error vs ground truth exceeds the tolerance above); [SJ] invalid/low-confidence values included in X/D = 0 cases |

**Why these numbers**
- **SNR ≥ 14 dB** (anchored by measurement; provisional as acceptance bound) — the 9 WeiShi-mic test recordings measure 30–51 dB clean (1 ms-envelope method; worst file 33.4 dB median-beat / 30.4 dB weak-beat) [SNR]; Sim realistic mode ≈ 45 dB, clean config ≈ 58 dB [Code]. So 14 dB is ≥ 16 dB below the worst clean capture — a severe-degradation condition reachable only by deliberate noise injection. Caution: under a whole-signal-RMS metric the same worst file reads 15.1 dB — do **not** rationalize 14 dB as "1 dB below the sample minimum" (that framing switches metrics, leaves zero degradation margin, and conflates weak coupling with ambient noise) [SNR §Definition Sensitivity]; draft 1's wording is superseded.
- **rate error ≤ ±3 s/d** (anchored) — keeps noise-induced error within the half-width of the tightest Witschi grade band (Chronometer −2…+6 s/d; cf. Gent's −5…+15, Lady's −5…+25) [TC].
- **detection ≥ 95 %** (provisional) — no basis found in any document or the code; the baseline only declares sync loss after 12 consecutive misses [Code].
- **≥ 1,000 beats** (feasible) — ≈ 2.1–3.3 min of capture at 18,000–28,800 BPH; the test recordings carry 229–366 beats per ≈ 45 s [SNR].
- **Ground truth = synthetic + calibrated noise injection** — a reference instrument is itself an acoustic device exposed to the same noise; both could drift together and still "agree" (circularity, review). The generator's known beat schedule / programmed rate is the ground truth; a reference-instrument reading is a clean-condition sanity check only.

### QAS-6 · Accuracy (Measurement Correctness) — Pinpointing Beats Precisely
> While measuring as usual, when a new beat (tick/tock) arrives, the system determines its onset and peak positions accurately and preserves timing precision through every processing stage (acquisition → filtering → event detection → calculation, per the Draft), locating onset/peak within ≤ 0.1 ms. Verified on synthetic signals with known positions, since 0.1 ms ground truth cannot be obtained from real hardware.

| Element | Content |
|---------|---------|
| Source | Watch beat (external input stream) |
| Stimulus | A new beat (tick/tock) arrives in the input stream |
| Artifact | The beat-detection / time-calculation part |
| Environment | Measuring as usual; verified at 96,000 SPS objective and 48,000 SPS minimum (C-6) |
| Response | Determine onset and peak positions accurately; preserve timing precision through every processing stage |
| Response Measure | Maximum onset/peak position error ≤ 0.1 ms over ≥ 1,000 synthetic beats with known positions (Sim mode, FR-05-05 / FR-12-16; onset/peak per FR-08-06), verified at 96,000 SPS (= 9.6 samples) and 48,000 SPS (= 4.8 samples — sub-sample interpolation required); no real hardware (QAS-10) |

**Why these numbers**
- **≤ 0.1 ms** (grounded) — ① equals the reference instrument's beat-error spec (X1 resolution 0.1 ms / accuracy ± 0.1 ms [X1]); ② ≈ 1/6 of the Draft's 0.6 ms "good" beat-error bound, so clinically meaningful beat-error differences stay resolvable; ③ the baseline display and Sim input already step at 0.1 ms [Code].
- **Sample equivalents** (derived) — 0.1 ms = 4.8 / 9.6 / 19.2 samples @ 48/96/192k (draft 1's "≈ 10 samples @ 96k" corrected to 9.6); worst case is the 48k minimum → sub-sample interpolation required, and the baseline detector already interpolates sub-sample (onset linear, peak parabolic) [Code] — so the target is feasible.
- **Synthetic verification, ≥ 1,000 beats** — real hardware cannot provide 0.1 ms ground truth; Sim signals with a-priori known positions via the QAS-10 harness; sample size per QAS-5.

### QAS-7 · Modifiability (Extensibility) — Adding a New Measurement/Filter/Graph
> In a tight-schedule development situation, when a developer adds a new graph, filter stage, or derived measurement, they can add it incrementally without tearing into existing code — within a per-kind change budget and with zero regressions. (Isolation testability of the new unit is governed by QAS-10.)

| Element | Content |
|---------|---------|
| Source | Developer |
| Stimulus | Wants to add a new graph, a new filter stage, or a new derived measurement |
| Artifact | The system (codebase holding the measurement/display features) |
| Environment | During development, tight schedule |
| Response | Add incrementally without heavily tearing into existing code; isolation testing per QAS-10 |
| Response Measure | New graph/display tab: ≤ 1 existing module changed (registration/wiring only), 0 changes to analysis/acquisition code. New filter stage (cf. F0–F3): ≤ 1 pipeline registration point changed, downstream filters and acquisition unchanged. New derived measurement: ≤ 1 calculation-registry change, 0 changes to acquisition/display frameworks. All kinds: 0 regressions — the existing-feature regression test set (QAS-10, hardware-free) passes before and after. (Informational planning target, not pass/fail: ≈ 5 person-days per graph.) |

**Why these numbers**
- **≤ 1 registration/wiring point per kind** (anchored) — the Project Plan demands incremental extension with separated responsibilities inside the 5-week box, with ~11 mandatory graph features (draft 1); a bounded touch surface is what makes that schedule feasible. Per-kind budgets because graphs, filters, and measurements touch different profiles (review).
- **0 regressions** — operationalized as "the existing-feature regression test set passes before and after" (review: a bare 0 is meaningless without a detection method).
- **≈ 5 person-days** (informational only) — a planning estimate with no direct source; excluded from pass/fail because effort measures developer skill, not the architecture (review).

### QAS-8 · Modifiability (Modularity) — Fixing in One Place
> During maintenance, when a developer changes a single responsibility, the change stays confined to that responsibility's module: for a predefined set of representative single-responsibility change scenarios, each change touches ≤ 1 module with 0 ripple. Cross-cutting changes (shared types, pipeline-wide fields) are explicitly out of scope.

| Element | Content |
|---------|---------|
| Source | Developer |
| Stimulus | Needs to change a single responsibility (e.g., one display's formatting, one calculation, one alert rule) |
| Artifact | The module owning the responsibility being changed |
| Environment | During maintenance |
| Response | Changing one responsibility has no effect on the others |
| Response Measure | For ≥ 3 predefined representative single-responsibility change scenarios: each change touches ≤ 1 module (excluding its own tests; module per Definitions); 0 ripple — no module outside the responsibility boundary requires a source or test edit. Cross-cutting changes are out of scope. |

**Why these numbers**
- **≤ 1 module, not "1 file"** ([JYP] applied) — files mismeasure modularity even in the ideal case (interface + implementation, code + test legitimately span > 1 file); measured per module, consistent with QAS-7/9.
- **≥ 3 representative scenarios, cross-cutting excluded** — "0 ripple" only holds inside a single responsibility boundary; representative scenarios make the claim testable (review).
- **Motivation** — the baseline's `MainWindow.cpp` concentrates ≈ 1,540 lines of mixed responsibilities [Code] (draft 1); stated here as a coupling risk to avoid, not as a description of the delivered baseline (review).

### QAS-9 · Modifiability (Portability) — Running on Other Devices/OSes
> When supporting a new sound device or porting to a new OS (the mandated platform pair is fixed by C-3), platform-specific concerns stay isolated behind abstraction layers: a new sound device touches one adapter module; an OS port is confined to the platform-abstraction layer — both with 0 domain-code changes. (Design-time concern; run-time device loss/recovery is QAS-12.)

| Element | Content |
|---------|---------|
| Source | Developer |
| Stimulus | Supporting a new sound device, or porting to a new OS beyond the C-3 pair |
| Artifact | Device case: the audio-input adapter layer. OS case: the platform-abstraction layer (GUI/Qt, threading, filesystem paths, build toolchain) |
| Environment | Development/maintenance time, against the existing codebase; mandated platforms = Windows 11 x64 and Raspberry Pi OS ARM64 (C-3); Qt baseline per C-5 |
| Response | Support the new OS / sound device through the abstraction layer |
| Response Measure | New sound device: 1 adapter module changed/added, 0 lines of domain code changed (per Definitions). New OS: changes confined to the platform-abstraction layer, 0 lines of domain code changed; the regression test set (QAS-10) passes on both C-3 platforms |

**Why these numbers**
- **Device ≠ OS split** (review) — an OS port cuts across GUI/Qt, threading, filesystem, and build — not just sound input; so the device case budgets one adapter module while the OS case gets a separate, realistic budget.
- **0 domain-code lines** (anchored) — the Draft requires platform-specific concerns to be separated and domain calculations preserved; the baseline already splits Linux/Windows audio from the analysis core [Code] (draft 1), so the target has a structural basis. "1 module" is a target, not the current state.

### QAS-10 · Testability — Testing Parts in Isolation
> During testing, when a developer/tester wants to test just the sound-analysis stages or the input part separately, each core analysis stage and the sound-input part can be checked in isolation by feeding fake input without real hardware. Sim mode generates synthetic beat signals whose onset/peak positions and beat schedule are known a priori — the ground truth for QAS-2/5/6/13. [SJ] X/D summaries are reproducible and traceable.

| Element | Content |
|---------|---------|
| Source | Developer / tester |
| Stimulus | Wants to test just the sound-analysis stages or input part separately |
| Artifact | The core analysis stages (per Definitions), the sound-input part |
| Environment | During testing, on a host with no audio hardware |
| Response | Check parts in isolation via fake-input injection; generate synthetic beat signals with a-priori known onset/peak positions and beat schedule; [SJ] produce repeatable X/D results and expose the included/excluded position results behind them |
| Response Measure | Line coverage ≥ 80 % on the enumerated core analysis stages; every core stage and the sound-input source is drivable via its interface with Sim/Playback injection — contract tests pass on a host with no audio device; Sim signals carry a-priori known onset/peak positions (FR-05-05 / FR-12-16); [SJ] X/D values identical across 3 repeated runs of the same Sim/Playback dataset covering the standard position set (CH/CB/6H/9H/3H/12H, FR-01-03 / FR-04-04); X/D trace-back: included and excluded position results enumerable from system output for 100 % of summaries |

**Why these numbers**
- **Hardware-free isolation** (grounded) — the Draft's Sim mode plus the baseline's `WatchSynthStream`, `SimWorker`, `PlaybackWorker`, and WAV fixtures [Code] already inject input without hardware (draft 1).
- **Line coverage ≥ 80 %** (provisional) — a team-chosen quality target with no external source; the denominator is fixed by the Definitions' core-stage list so the percentage is meaningful (review).
- **Contract-test criterion** — replaces draft 1's "100 % of unit tests runnable without hardware", which was tautological (a property of whatever tests exist, not of the architecture) (review).
- **Known-position synthetic signals** — added because QAS-2/5/6/13 depend on them as ground truth (review: the cross-reference was dangling in draft 1).
- **3 repeated runs / 100 % trace-back [SJ]** — repeatability and auditability of X/D; the run count is a test-protocol choice (provisional).

### QAS-11 · Usability — Reading and Operating on the Low-Resolution Touchscreen
> While using the device on the Raspberry Pi 5's 800×480 touchscreen, when the user reads measurement values and switches modes, the key readings are legible without scrolling/zooming and primary functions are operable by touch alone. Physical sizes (mm) are normative; pixel equivalents are advisory until the panel size is confirmed. [SJ] During position/sequence review, the active position and X/D summary are quickly identifiable.

| Element | Content |
|---------|---------|
| Source | User (watchmaker / operator) |
| Stimulus | Reads measurement values and switches modes on the 800×480 touchscreen |
| Artifact | The GUI (spectrogram/scope/numeric displays and controls) |
| Environment | Raspberry Pi 5 + 800×480 touch display, normal use. Panel physical size unconfirmed (Draft self-contradicts: "8 Inch" heading vs "5-inch" body — see C-1). The baseline GUI is hard-fixed at 1280×750 with no 800×480 layout, so re-layout is required work [Code] |
| Response | Present key readings legibly; allow primary functions by touch alone; [SJ] show active/selected position and X/D near the related values |
| Response Measure | Primary readings (rate, beat error, amplitude) shown simultaneously without scroll/zoom; glyph height ≥ 1.9 mm (≈ 16 arcmin at 40 cm working distance), contrast ≥ 4.5:1 (WCAG AA) — "≥ 24 px" retained as advisory only; all primary touch targets ≥ 9 mm physical (pixel equivalent advisory, re-derived once the panel size is confirmed); any primary mode reachable in ≤ 2 taps; [SJ] timed task with ≥ 3 representative users from the sequence-review screen: active position identified ≤ 5 s and X/D ≤ 10 s in ≥ 90 % of trials. Touch = single tap/drag; multi-touch gestures are out of scope ([JYP]) |

**Why these numbers**
- **Physical mm normative, px advisory** (review) — "9 mm ≈ 48 px" holds only at ≈ 135 ppi (a 7-inch 800×480 panel); the Draft itself states both 8-inch (≈ 117 ppi → 9 mm ≈ 41 px) and 5-inch (≈ 187 ppi → ≈ 66 px), so pass/fail must not depend on the conversion. Open question recorded in C-1.
- **≥ 9 mm touch targets** (anchored) — standard touch-ergonomics target size (draft 1's basis), kept as the physical criterion.
- **Glyph ≥ 1.9 mm / 16 arcmin @ 40 cm + contrast ≥ 4.5:1** (derived) — replaces the unmeasurable "readable at working distance" with a perception spec needing no test subjects (16 arcmin legibility practice + WCAG AA contrast) (review).
- **≤ 2 taps** (provisional) — team criterion bounding primary-mode reachability; 800×480 itself is a direct Draft constraint (C-2).
- **[SJ] 5 s / 10 s identification** — made measurable as a timed task (≥ 3 users, ≥ 90 % of trials) (review: a bare time bound had no protocol).
- **[JYP] touch scope** — "operate by touch" derives from the provided hardware, not an explicit Draft requirement; single tap/drag only — multi-touch (swipe/pinch) has no Draft basis.

### QAS-12 · Availability (Recoverability) — Audio Device Disconnect or Stream Error
> While measuring as usual, when the audio input device is disconnected or the input stream raises a recoverable error (e.g., an ALSA xrun) with the device attached, the system detects the fault without crashing, informs the user, preserves the last useful reading (flagged stale) and all captured data, and resumes automatically within 10 s of the fault clearing — no manual restart.

| Element | Content |
|---------|---------|
| Source | Sound device (external) |
| Stimulus | The device is disconnected, or the input stream raises a recoverable error (device still attached), during measurement |
| Artifact | The sound-input part / the system |
| Environment | Measuring as usual |
| Response | Detect the fault without crashing; inform the user; keep the last valid reading visible (flagged stale) and preserve all captured data; resume automatically once the fault clears |
| Response Measure | Over ≥ 20 unplug/replug cycles and ≥ 5 injected stream errors during active measurement: 0 crashes; "no device" / "input error" indication ≤ 5 s; automatic resumption ≤ 10 s of the fault clearing, every trial; the most recent valid reading stays visible (stale-flagged) throughout; 0 loss of captured sequence/trace data; 0 data corruption — corruption = a post-recovery record that (a) mixes pre-/post-fault samples, (b) contains torn-buffer samples, or (c) has non-monotonic timestamps across the fault boundary |

**Why these numbers**
- **auto-resume ≤ 10 s** (derived, provisional) — the baseline's re-lock path after a stream re-open is ≈ 2.5–3.5 s (detector warmup 200 ms + BPH auto-detect 1.5 s + sync acquisition ≈ 0.8–1.7 s) [Code] → ≈ 3× margin. Note: the baseline has **no** reconnect handling today — device loss simply ends the worker [Code] — so this scenario specifies a new capability.
- **indication ≤ 5 s** (provisional) — no direct source; team rationale (draft 1): the Draft requires clear fault indication ("don't leave the user guessing") and status displays update on a ≈ 2 s cycle → 5 s ≈ two update cycles + margin.
- **last-reading preservation, 0 data loss** (grounded) — the Draft's "preserve the last useful reading"; also operationalizes "0 data corruption" together with the (a)/(b)/(c) definition (review).
- **Trial counts ≥ 20 / ≥ 5** (provisional) — test-protocol choice; both fault paths (unplug vs stream error) are exercised separately (review).

### QAS-13 · Accuracy (Computed Values) — Rate, Amplitude, Beat Error vs Ground Truth
> In clean conditions, when the system measures a Sim-generated signal with known programmed parameters (BPH, Error Rate, Amplitude, Beat Error) and a configured lift angle, the displayed values match the injected ground truth: rate ≤ ±1 s/d, amplitude ≤ ±5°, beat error ≤ ±0.1 ms over ≥ 1,000 beats. Closes the clean-condition accuracy gap — in particular amplitude, which no other scenario bounds.

| Element | Content |
|---------|---------|
| Source | The Sim signal generator with known programmed parameters (internal ground truth) |
| Stimulus | A measurement run on a Sim signal with programmed rate / amplitude / beat error |
| Artifact | The calculation stages (rate, amplitude incl. lift angle, beat error) |
| Environment | Clean conditions (no injected noise), Sim mode with Realistic OFF (default is ON — must be unchecked), 96,000 SPS |
| Response | Compute and display rate, amplitude, and beat error from the detected events; the configured lift angle and BPH demonstrably flow into the computation |
| Response Measure | Versus the programmed values over ≥ 1,000 beats: \|rate error\| ≤ 1 s/d; \|amplitude error\| ≤ 5° (with the configured lift angle, default 52°); \|beat-error error\| ≤ 0.1 ms; covers the values displayed by FR-04-05 / FR-06-01..04 |

**Why these numbers**
- **rate ≤ ±1 s/d** (anchored, provisional) — 10× the X1 instrument accuracy (± 0.1 s/d [X1]) and ⅛ of the tightest grade band (Chronometer −2…+6 s/d [TC]); the display steps at 0.1 s/d [Code].
- **amplitude ≤ ±5°** (derived, provisional) — error propagation from Amp = 3600λ/(π·n·t_AC) [EQ]: at the worked example (230° @ t_AC = 9 ms), \|dAmp/dt_AC\| ≈ 25.6°/ms, so QAS-6's 0.1 ms timing budget ≈ 2.6° → ±5° ≈ 2× margin. Reference points: X1 amplitude accuracy ± 0.4° [X1]; display unit 1° [Code].
- **beat error ≤ ±0.1 ms** (grounded) — equals the X1 accuracy spec [X1]; consistent with QAS-6.
- **Sim ground truth** (grounded) — the Draft's Simulation Parameters; Sim ranges: Error Rate ± 999 s/d, Amplitude 100–360° (default 300°), Beat Error ± 10 ms (step 0.1), BPH 3,600–43,200 (default 28,800); lift angle default 52° ("52° is common" [EQ]; X1 range 10–90°) [Code]. Clean verification requires Realistic OFF — the default is ON [Code].
- **≥ 1,000 beats** (feasible) — as QAS-5.

### QAS-14 · Usability (Session Continuity) — Pause, Seek, and View Switching Without Reset
> While measuring as usual, when the user pauses the display, seeks through captured data, or switches the graph tab / analysis view, the session and recorded data are preserved: 0 resets, 0 data loss, capture continues during pause, and resuming loses nothing captured while paused.

| Element | Content |
|---------|---------|
| Source | User (watchmaker / operator) |
| Stimulus | Pauses, seeks backward/forward, or switches graph tab / analysis view during a live session |
| Artifact | GUI session state, the capture buffer, the acquisition pipeline |
| Environment | Normal interactive operation (not a device fault — that is QAS-12) |
| Response | Preserve the session and recorded data; keep capturing during pause; render the requested region |
| Response Measure | Over a scripted run (≥ 20 pause/seek/switch operations during a 10-min live session): 0 session resets; 0 captured-data loss (record count/hash before vs after); the sought view renders ≤ 500 ms after selection; on resume, the full pause-period data is present |

**Why these numbers**
- **0 resets / 0 data loss** (grounded) — the brief states it verbatim: "all graphs can run continuously … without losing the recorded signal or forcing a reset"; FR-05-06/07, FR-08-03, FR-12-17/18.
- **render ≤ 500 ms** (provisional) — no direct basis; plausible because the redraw working set is bounded by the 10 s graph history [Code].
- **≥ 20 operations** (provisional) — test-protocol choice.

### QAS-15 · Usability (Alert Annunciation) — Fault and Out-of-Tolerance Conditions
> While measuring as usual, when a reading crosses a defined tolerance band — amplitude outside 270°–300° (FR-02-09), running late (FR-02-05), trace-line spacing out of range (FR-06-11), trace slope ≥ 45° (FR-06-13) — the GUI surfaces a clear alert near the related reading within 2 s, so the user never has to guess whether the watch or the software is at fault (Draft, Usability).

| Element | Content |
|---------|---------|
| Source | Analysis results crossing tolerance bands (internal) |
| Stimulus | A computed reading enters an out-of-tolerance or fault condition |
| Artifact | The alert/annunciation logic and GUI indicators |
| Environment | Measuring as usual; conditions induced via Sim parameters for verification |
| Response | Surface a clear, attributable alert near the related reading |
| Response Measure | Over a Sim test set exercising each condition: alert displayed ≤ 2 s after the condition is computed; 0 missed alerts; 0 false alerts while readings stay within tolerance; traces to FR-02-05 / FR-02-09 / FR-06-11 / FR-06-13 |

**Why these numbers**
- **alert ≤ 2 s** (anchored) — equals the X1's minimum integration time (Diagram integration 2–240 s; auto table starts "0–2 h → 2 s") [X1], and the baseline's averaging options also start at 2 s [Code] — annunciation faster than the first computable result is not meaningful.
- **tolerance bands** (anchored) — 270° is Witschi's canonical reference amplitude (DVm @ 270° [X1]); healthy range 260–310° [TC]; the band endpoints equal the Sim defaults (clean config 270° / UI default 300° — the same UI default cited in QAS-13) [Code]. Beat-error context: Draft 0.6 ms "good"; [TC] acceptable 0.0–0.5 ms, defective ≈ 3 ms.
- **0 missed / 0 false** (grounded) — alert correctness traces to the alert FRs and the Draft's usability narrative ("don't leave the user guessing").

## Scope Notes — Deferred Drivers

Recorded so absences are documented decisions, not oversights:

- **AI / TinyML on-device PoC** (kickoff System Requirement, "where feasible"): out of Milestone-1 driver scope (time-boxed schedule); revisit at Milestone 2 as an Integrability concern.
- **Security, Deployability**: out of scope — a local bench instrument with no network exposure; deployment is the Qt build flow (C-5).
- **Startup / mode-transition timing** (Start → first valid reading; Live↔Playback↔Sim switch): identified gap; bounds after the Planned Experiments. Session preservation across switches is covered by QAS-14.
- **Interactive timing-point / region selection quality** (G08/G10): realized as FRs; a dedicated quality measure is deferred.

## Constraints

| ID | Constraint |
|----|------------|
| C-1 | The system shall run on a Raspberry Pi 5 (8 GB RAM, 128 GB microSD) with the attached touchscreen. Open question: the Draft states the panel as both "8 Inch" (heading) and "5-inch" (body); the confirmed size will be recorded here and drives the QAS-11 pixel equivalents. |
| C-2 | The system shall render and operate the GUI correctly on the low-resolution (800×480) display attached to the Raspberry Pi 5 (usability measures: QAS-11). |
| C-3 | The system shall run on both a Windows 11 (x64) PC and a Raspberry Pi 5 running Raspberry Pi OS (Debian-based, 64-bit/ARM64). (Modifiability cost of additional platforms: QAS-9.) |
| C-4 | (Operating precondition) The host audio device shall have Auto Gain Control disabled, configured and verified in the OS audio mixer before measurement; the system presupposes AGC-off input. The baseline already disables AGC programmatically at startup on both OSes [Code]. |
| C-5 | The system shall be implemented by extending the provided Qt-based TimeGrapher baseline (TimeGrapher_v10.5_Student, a Qt Creator project), not built from scratch. (Toolchain: Qt 6 with Qt 5 fallback, CMake ≥ 3.16, C++17.) |
| C-6 | The system shall support the defined sample-rate operating points: 48,000 SPS (minimum), 96,000 SPS (objective), 192,000 SPS (stretch). (The baseline offers 48k/96k/192k plus 384k, default 48k; the WeiShi test recordings span 48/96/192k.) |

---

# Milestone1 Jae-hong Oh — QA draft 3 (한국어)

> **draft 3 (2026-06-03)** — `Milestone1_QA_draft.md`(시나리오 + [OJH]/[JYP]/[SJ] 메모), `review_result.md`(SAP 6-part 리뷰), `Milestone1_QA_draft2.md`(리뷰 반영 + 근거 표)를 종합. 프레임워크: SEI 6-part Quality Attribute Scenario (SAP — Bass · Clements · Kazman). draft 2 대비 변경점: 중앙 근거 표(G1–G19)를 해체하여 각 시나리오 바로 아래 **측정값 근거** 목록으로 통합 — 임계값과 그 근거 전부를 한자리에서 읽을 수 있게 함; 리뷰어 스레드는 본문에 반영 후 종결.

## 읽는 법

- 각 시나리오는 SAP 6요소로 기술: **출처 · 자극 · 대상 산출물 · 환경 · 응답 · 응답 척도**.
- 근거 출처: **[X1]** Witschi Chronoscope X1-G3 매뉴얼 · **[TC]** Witschi Training Course · **[EQ]** TimeGrapher Equations 문서 · **[SNR]** `SNR-Analysis-WeishiMic.md`(실측, 본 폴더) · **[Code]** TimeGrapher 베이스라인 코드 · **[Draft]/[Brief]** 프로젝트 Draft / Brief.
- 임계값 상태: **grounded**(출처가 직접 뒷받침) · **anchored**(인용 기준점을 가진 팀 선정값) · **derived**(인용 출처로부터 계산) · **provisional**(수치 근거 없음 — Milestone 2 전 Planned Experiments로 확정). 수치 임계값이 아닌 검증 방법을 설명하는 항목에는 상태 태그를 붙이지 않는다.

## 측정 정의 (시나리오 공통)

| 용어 | 정의 |
|------|------|
| Module(모듈) | 단일 인터페이스 뒤의 응집된 코드 단위(인터페이스 + 구현, 자기 테스트 제외). QAS-7/8/9의 계수 단위; 구체적 분해는 Milestone 2 module view에서 확정. |
| Domain code(도메인 코드) | 분석·계산 로직 — 비트 감지, 시간 계산, rate/amplitude/beat error 계산, X/D 집계 — 신호 획득, 플랫폼/OS, GUI, 등록/배선 코드는 제외(Draft의 계층 분리 기준). |
| Core analysis stages(핵심 분석 단계) | 비트/onset 감지 · onset/peak 위치 결정 · rate 계산 · beat error 계산 · amplitude(lift angle 포함) 계산 · X/D 집계. QAS-2/6/10이 공유하는 분모. |
| Sample-rate operating points(샘플레이트 운영점) | 48,000 SPS(최소) · 96,000 SPS(목표) · 192,000 SPS(스트레치) — C-6 참조. |
| Provisional(잠정) | 브리프에 수치 근거가 없어 팀이 선정한 임계값. Milestone 2 전 실험으로 확정 또는 수정. |

## QAS 우선순위

Milestone 1의 "요구사항 우선순위화" 요구에 따름. B = 비즈니스 중요도, R = 기술 리스크 (H/M/L).

| QAS | 품질 속성 (SAP) | B | R | 근거 |
|-----|----------------|---|---|------|
| QAS-1 | Performance (Latency) | H | H | 프로젝트 대표 드라이버("real-time / low latency"); Pi에서의 실현 가능성이 명시된 리스크 |
| QAS-2 | Performance (Throughput) | H | H | Pi에서 96k SPS 따라가기가 결정적 실현 리스크; QAS-1/3의 전제 |
| QAS-3 | Availability (Resource-Leak Resilience) | M | M | 장기 세션(Long-Term Performance Graph)에 필수; 완화책은 표준적 |
| QAS-4 | Correctness (Display Consistency) | H | M | 브리프의 명시 "Correctness" 드라이버; single-source-of-truth 설계는 잘 알려짐 |
| QAS-5 | Accuracy & Availability (Graceful Degradation) | H | H | 실제 작업 환경에서 쓸 수 있는 측정; 잡음 하 알고리즘 리스크 |
| QAS-6 | Accuracy (Measurement Correctness) | H | H | 모든 파생 측정값이 이벤트 위치 정확도에 의존; 48k에서 서브샘플 리스크 |
| QAS-7 | Modifiability (Extensibility) | H | M | 5주 안에 그래프 11종 — 저비용·무회귀 추가가 필수 |
| QAS-8 | Modifiability (Modularity) | M | L | QAS-7을 지지; 대표 변경 시나리오로 검증 |
| QAS-9 | Modifiability (Portability) | M | L | C-3이 두 플랫폼을 부과; Qt 베이스라인(C-5)이 완화 |
| QAS-10 | Testability | H | M | QAS-2/5/6/13의 ground-truth 검증과 QAS-7의 회귀 안전성을 가능케 함 |
| QAS-11 | Usability (Touchscreen) | M | M | 800×480 고정 패널; 크기 확정 후엔 주로 레이아웃 규율 문제 |
| QAS-12 | Availability (Recoverability) | M | M | 작업대 워크플로 복원력; 표준적 장치 오류 처리 |
| QAS-13 | Accuracy (Computed Values) | H | M | amplitude/beat error 정확도 공백을 해소; Sim ground truth로 검증 가능 |
| QAS-14 | Usability (Session Continuity) | M | M | 브리프의 명시·반복 요구("기록 손실·리셋 없이") |
| QAS-15 | Usability (Alert Annunciation) | M | L | FR 기반 경보(FR-02-05/09, FR-06-11/13); "사용자가 추측하게 두지 말 것" |

**아키텍처를 가장 좌우하는 드라이버:** QAS-1/2(Pi 실시간 성능), QAS-5/6/13(측정 정확도·잡음 강건성), QAS-7/10(일정 내 확장성·테스트 용이성).

## Quality Attribute Scenarios

### QAS-1 · Performance (Latency) — 소리 입력에서 화면 표시까지
> 타깃 플랫폼에서 측정하는 동안 마이크로 소리가 들어오면, 시스템은 입력 → 분석 → 표시 흐름으로 처리하여 화면에 표시하며, p99 종단 지연(소리 도착 → 화면 표시)이 ≤ 500 ms이다. 입력 rate 따라가기(블록 드롭 0·비트 누락 0)는 QAS-2가 소유하며 본 측정의 전제 조건이다.

| 요소 | 내용 |
|------|------|
| 출처 | 마이크 / 시계 (외부) |
| 자극 | 마이크로 소리가 들어옴 |
| 대상 산출물 | 전체 입력 → 분석 → 표시 흐름 |
| 환경 | Raspberry Pi 5(8 GB, C-1)에서 Live 측정, 96,000 SPS 목표 — 48,000 SPS 최소에서도 충족(C-6); GUI 활성, 연속 정상 부하 |
| 응답 | 처리하여 화면에 표시함 |
| 응답 척도 | 10분 연속 실행 동안 p99 종단 지연(소리 도착 → 화면) ≤ 500 ms, capture/processing/display 타임스탬프로 측정(Draft의 지연 보고 요구에 따름) |

**측정값 근거**
- **≤ 500 ms** (provisional, anchored) — ① 일반적인 28,800 BPH에서 약 4비트 주기(비트 주기 125 ms [EQ]; Sim 기본 BPH [Code]); ② 화면이 실시간에 가깝게 느껴지는 상한 약 600 ms보다 여유 있게 잡은 값(팀 UX 근거, draft 1); ③ 베이스라인의 구조적 표시 경로 약 70 ms(Linux/Pi 블록 주기 20 ms + 고정 50 ms envelope 정렬 지연 [Code])의 7배 이상 — Pi에서 분석+렌더링에 여유 확보. 브리프는 지연 최소화·보고만 요구하고 수치를 정하지 않으므로 provisional.
- **10분 연속 실행** (anchored) — Witschi Sequence mode 최대 측정 시간과 일치; 더 긴 내구성은 QAS-3 소유.
- **환경 고정** — 브리프가 명시 경고: PC 성능은 Pi로 이전되지 않음; 레이트는 C-6 기준.

### QAS-2 · Performance (Throughput) — 분석 따라가기와 연산 예산
> 타깃 플랫폼에서 측정하는 동안 설정된 샘플레이트 주기로 오디오 블록이 들어오면, 시스템은 backlog 없이 입력 rate를 유지하고 — 10분 실행 동안 블록 드롭 0개, 비트 누락 0개, backlog 증가 추세 없음 — 그 수단으로서 각 블록의 분석을 블록 도착 간격의 80% 이내(p99)에 완료한다.

| 요소 | 내용 |
|------|------|
| 출처 | 오디오 입력/획득 파이프라인 (설정된 주기로 블록 전달) |
| 자극 | 분석할 오디오 블록이 들어옴 |
| 대상 산출물 | 분석 처리 단계 — t_block_handed_to_analysis부터 t_result_produced까지 계측(비트 감지 + rate/amplitude/beat error 계산; 캡처 버퍼링·화면 렌더링 제외) |
| 환경 | Raspberry Pi 5에서 Live 측정, 96,000 SPS 목표 — 48,000 SPS 최소에서도 검증; 192,000 SPS 스트레치는 측정만(게이트 아님) (C-6) |
| 응답 | 입력 rate를 유지함; 각 블록의 분석을 연산 예산 내에 완료함 |
| 응답 척도 | 각 게이트 레이트에서 10분 실행 동안: 블록 드롭 0개(입력 콜백 overrun 카운터); 기지 Sim/Playback 비트 스케줄 대비 비트 누락 0개(누락 = 기대 비트에 검출 없음); backlog(큐 깊이) 증가 추세 없음; 블록당 연산 시간 p99 ≤ 0.8 × 블록 도착 간격(베이스라인 Linux/Pi 주기 20 ms 기준 = 16 ms) |

**측정값 근거**
- **p99 ≤ 0.8 × 도착 간격** (grounded) — 베이스라인은 Linux/Pi에서 20 ms(Windows 10 ms) 블록을 전달 [Code] → 예산 16 ms/블록; 도착 주기보다 빠른 처리가 곧 "드롭 0"을 가능케 하는 조건이며, 0.8은 스케줄링 지터용 20% 여유. Live 블록은 ALSA 구동 가변 크기 [Code]이므로 실측 도착 간격 대비 측정. (draft 1의 고정 "100 ms ≈ 36,000 BPH 1비트 주기" 예산을 대체 — 도착 주기와 무관한 고정 예산은 그 자체로 backlog를 함의할 수 있음.)
- **비트 누락 0** (grounded 관측성) — 기지 Sim/Playback 비트 스케줄 대비 검증(QAS-10); tg 라이브러리가 비트별 이벤트와 sync-loss를 노출(BPH auto-detect 1.5 s; 연속 12회 누락 시 sync loss) [Code].
- **10분** (anchored) — QAS-1과 동일(Witschi Sequence mode 최대 시간).

### QAS-3 · Availability (Resource-Leak Resilience) — 장기 실행 무열화
> Raspberry Pi 5(8 GB)에서 장기 세션으로 연속 측정하는 동안, 시스템은 열화 없이 정상 서비스를 계속 제공한다 — 메모리 누수·크래시·화면 멈춤·서멀 스로틀링 저하 없음 — 연속 ≥ 2시간 기준(Long-Term Performance Graph 용도는 ≥ 6시간). 입력 따라가기는 QAS-2가 검증하는 전제 조건이다.

| 요소 | 내용 |
|------|------|
| 출처 | 장시간 무인 측정을 시작하는 측정자 (예: Long-Term Performance 테스트, G07) |
| 자극 | 연속 측정이 멈추지 않고 장시간 지속됨 |
| 대상 산출물 | 전체 시스템, Raspberry Pi 메모리/프로세스 상태 |
| 환경 | Raspberry Pi 5(8 GB), 96,000 SPS에서 연속 ≥ 2시간(장기 그래프 용도 ≥ 6시간); 입력 따라가기는 QAS-2 전제 |
| 응답 | 열화 없이 정상 서비스 지속: 자원 고갈·크래시·멈춤·서멀 스로틀링 없음 |
| 응답 척도 | 전체 실행 동안: 모든 30분 구간에서 RSS 선형 회귀 기울기 ≤ 0 + ε (ε = 측정 노이즈 허용치); 크래시 0회; 화면 멈춤 0회(멈춤 = 화면 업데이트 ≥ 2초 미갱신, render-heartbeat 로그로 검출); CPU 평균 ≤ 70%, 피크 ≤ 90%; Pi governor가 보고하는 서멀 스로틀링 이벤트 0회 |

**측정값 근거**
- **≥ 2시간 (≥ 6시간)** (anchored) — ≥ 2시간은 기준 계측기의 첫 장기 integration 구간 경계("0–2 h → 2 s" 자동표 [X1]); X1은 최대 99:59:58시간 측정, Witschi Vario는 최대 100시간 안정성 추적 [X1][TC]. "장기 무열화"를 입증하기엔 너무 짧았던 draft 1의 10분을 대체([JYP] 반영).
- **RSS 기울기 ≤ 0 + ε** (anchored) — 베이스라인 메모리는 Start 시 고정 할당(30 s 링 버퍼 1회 할당 = 48/96/192k에서 5.76/11.52/23.04 MB; 그래프 히스토리는 10 s 초과분 prune [Code]) → 구조적 증가 없음이 기대됨; ε는 할당자/Qt 캐시 몫. draft 1의 "5분당 ≤ 20 MB" 상한(기존 프로젝트 실측 RSS 약 110 MB의 약 20%)을 대체 — 고정 상한은 느린 누수를 통과시키고 정상적 일회성 할당을 결함으로 잡음(리뷰).
- **멈춤 = 2초 이상 미갱신** (provisional) — 사용자가 2초 이상의 정지를 명확히 멈춤으로 인지(팀 UX 근거, draft 1). (X1의 최소 integration 단위 2초는 수치상의 우연 일치일 뿐, 렌더링 멈춤 검출 기준의 근거는 아님.)
- **CPU 70% / 90%, 스로틀링 0회** (provisional) — 출처 없음; 96k 지속 부하에서의 Pi 발열이 브리프가 명시한 실현 리스크라서 포함.

### QAS-4 · Correctness (Display Consistency) — 표시 간 값 일치
> 평소처럼 측정하는 동안 하나의 측정 결과가 여러 그래프와 숫자로 전달될 때, 한 화면 프레임에 함께 렌더링되는 모든 표시는 그 단일 결과에서 파생되어 상호 일치한다 — 값 불일치 0회. [SJ] X/D summary는 position별 표시와 동일한 captured result set을 사용한다.

| 요소 | 내용 |
|------|------|
| 출처 | 분석/계산 단계 (내부) |
| 자극 | 하나의 측정 결과가 여러 표시(그래프/숫자)로 전달됨 |
| 대상 산출물 | 수치 표시값과 여러 그래프 표시 |
| 환경 | 평소처럼 측정 중 (검증은 Sim/Playback) |
| 응답 | 한 프레임에 함께 표시되는 모든 값·그래프가 하나의 측정 결과에서 파생되어 일치함; [SJ] X/D sequence summary는 표시된 position별 result set에서 산출 |
| 응답 척도 | 기지 기준 입력의 10분 Sim/Playback 실행(QAS-10) 동안, 샘플링된 전체 프레임에서: 동시에 표시되는 모든 표시 쌍이 동일 측정 결과의 값을 표시(표시 반올림 이내) — 불일치 0회; 각 표시는 소스 결과 식별자를 노출(trace 로그/디버그 오버레이)하여 검사 가능; [SJ] X/D source mismatch 0건 |

**측정값 근거**
- **불일치 0회** (grounded) — 일치는 조정 가능한 성능 수치가 아니라 정합성 요구: Project Plan은 표시값과 그래프가 동일한 underlying events와 일치할 것을 요구하고(draft 1), 브리프는 "Correctness"를 드라이버로 명시. 스냅샷 ID 등 태그된 공유 스냅샷은 권고 전술이며 필수 메커니즘이 아님 — 요구사항은 관찰 가능한 행위로만 기술(리뷰).
- **기지 입력 10분 관측 구간** (anchored) — QAS-1/2의 실행 길이와 QAS-10 하네스를 재사용하여 재현 가능.

### QAS-5 · Accuracy & Availability (Graceful Degradation) — 잡음·약신호 환경
> 주변 잡음이 섞이거나 약한 신호가 들어오는 열악한 환경에서, 시스템은 필요한 소리를 보존하며 잡음을 걸러내고, 신호 품질이 임계 이하면 잘못된 값 대신 "신호 약함"을 표시한다: SNR ≥ 14 dB에서 1,000비트 이상 기준 비트 감지율 ≥ 95%, 일오차 ≤ ±3 s/d; 임계 미만에서는 "신호 약함"만 표시하고 잘못된 값 0회. [SJ] Invalid/low-confidence position result는 X/D 계산에서 제외(규칙은 FR-04-06 소유).

| 요소 | 내용 |
|------|------|
| 출처 | 주변 잡음 / 약한 신호(외부) |
| 자극 | 잡음이 섞이거나 신호가 약하게 들어옴 |
| 대상 산출물 | 잡음 제거 / 비트 감지 부분과 신호 품질 표시 |
| 환경 | 열악한 작업 환경 — Sim/Playback 입력에 보정된 잡음을 통제·일정 SNR로 주입하여 재현(SNR 정의: 비트당 임펄스 피크 대 분석 대역 내 잡음 RMS, 방법은 [SNR] 기준) |
| 응답 | (Accuracy) 잡음 하에서 비트를 감지하고 rate를 허용오차 내로 계산; (Availability) 품질 임계 미만이면 우아하게 성능 저하 — 어떤 값도 아닌 "신호 약함"을 표시; [SJ] invalid/low-confidence 결과를 X/D에서 제외(FR-04-06) |
| 응답 척도 | 생성기의 기지 비트 스케줄·프로그래밍된 rate 대비, 1,000비트 이상 기준: SNR ≥ 14 dB에서 감지율 ≥ 95%, 일오차 ≤ ±3 s/d; 임계 미만: "신호 약함"만 표시, 잘못된 값 0회(잘못된 값 = "신호 약함" 플래그 없이 표시된 판독값 중 정답 대비 오차가 허용오차 초과); [SJ] invalid/low-confidence 값의 X/D 포함 0건 |

**측정값 근거**
- **SNR ≥ 14 dB** (실측 anchored; 합격 기준으로서는 provisional) — WeiShi-mic 시험 녹음 9개의 클린 실측 = 30–51 dB(1 ms envelope 방법; 최악 파일 중앙 비트 33.4 dB / 약비트 30.4 dB) [SNR]; Sim realistic 모드 ≈ 45 dB, clean 설정 ≈ 58 dB [Code]. 따라서 14 dB는 최악 클린 캡처보다 ≥ 16 dB 낮은 심한 열화 조건 — 도달하려면 의도적 잡음 주입이 필요. 주의: 전체-신호-RMS 지표로는 동일 최악 파일이 15.1 dB로 읽힘 — 14 dB를 "샘플 최저치보다 1 dB 낮춘 값"으로 설명하지 말 것(지표가 바뀌고, 열화 마진이 0이 되며, 커플링 약화와 주변 잡음을 혼동) [SNR §Definition Sensitivity]; draft 1의 해당 표현은 폐기.
- **일오차 ≤ ±3 s/d** (anchored) — 잡음 유발 오차를 가장 엄격한 Witschi 등급 대역의 반폭 이내로 제한(Chronometer −2…+6 s/d; 참고: Gent's −5…+15, Lady's −5…+25) [TC].
- **감지율 ≥ 95%** (provisional) — 문서·코드 어디에도 근거 없음; 베이스라인은 연속 12회 누락 시에만 sync loss 선언 [Code].
- **≥ 1,000비트** (feasible) — 18,000–28,800 BPH에서 캡처 약 2.1–3.3분; 시험 녹음은 ~45초당 229–366비트 [SNR].
- **정답 = 합성 신호 + 보정 잡음 주입** — 기준 장비도 같은 잡음에 노출되는 음향 계측기라서 둘이 같이 틀려도 "일치"로 통과 가능(순환성, 리뷰). 생성기의 기지 비트 스케줄·프로그래밍된 rate가 정답; 기준 장비 판독값은 클린 조건 sanity check 용도만.

### QAS-6 · Accuracy (Measurement Correctness) — 비트 위치 정밀 검출
> 평소처럼 측정하는 동안 새 비트(틱/톡)가 도착하면, 시스템은 그 onset과 peak 위치를 정확히 찾아내고 모든 처리 단계(획득 → 필터링 → 이벤트 검출 → 계산, Draft 기준)를 관통하여 시간 정밀도를 보존하며, onset/peak 위치 오차 ≤ 0.1 ms를 만족한다. 0.1 ms 정답은 실제 하드웨어로 얻을 수 없으므로 위치가 알려진 합성 신호로 검증한다.

| 요소 | 내용 |
|------|------|
| 출처 | 시계 비트 (외부 입력 스트림) |
| 자극 | 새 비트(틱/톡)가 입력 스트림에 도착함 |
| 대상 산출물 | 비트 감지 / 시간 계산 부분 |
| 환경 | 평소처럼 측정 중; 96,000 SPS 목표와 48,000 SPS 최소에서 검증 (C-6) |
| 응답 | onset과 peak 위치를 정확히 찾아내고, 모든 처리 단계를 관통하여 시간 정밀도를 보존함 |
| 응답 척도 | 위치가 알려진 합성 비트 ≥ 1,000개(Sim mode, FR-05-05 / FR-12-16; onset/peak는 FR-08-06 기준)에 대해 onset/peak 위치 최대 오차 ≤ 0.1 ms; 96,000 SPS(= 9.6샘플)와 48,000 SPS(= 4.8샘플 — 서브샘플 보간 필요)에서 검증; 실제 하드웨어 불요(QAS-10) |

**측정값 근거**
- **≤ 0.1 ms** (grounded) — ① 기준 계측기의 beat error 스펙과 일치(X1 해상도 0.1 ms / 정확도 ± 0.1 ms [X1]); ② Draft의 0.6 ms "양호" beat error 기준의 약 1/6 → 임상적으로 유의한 beat error 차이를 해상 가능; ③ 베이스라인 표시와 Sim 입력 모두 이미 0.1 ms 단위 [Code].
- **샘플 환산** (derived) — 0.1 ms = 48/96/192k에서 4.8 / 9.6 / 19.2 샘플(draft 1의 "96k에서 약 10샘플"을 9.6으로 교정); 최악 케이스는 48k 최소 레이트 → 서브샘플 보간 필요 — 베이스라인 검출기가 이미 서브샘플 보간 수행(onset 선형, peak 포물선) [Code]이므로 실현 가능.
- **합성 검증, ≥ 1,000비트** — 실제 하드웨어는 0.1 ms 정답 제공 불가; QAS-10 하네스로 위치가 선험적으로 알려진 Sim 신호 사용; 표본 크기는 QAS-5와 동일.

### QAS-7 · Modifiability (Extensibility) — 새 측정/필터/그래프 추가
> 일정이 촉박한 개발 상황에서 개발자가 새 그래프·필터 단계·파생 측정값을 추가할 때, 기존 코드를 크게 뜯어고치지 않고 점진적으로 추가할 수 있다 — 종류별 변경 예산과 회귀 0건. (신규 단위의 격리 테스트 가능성은 QAS-10이 규율.)

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 |
| 자극 | 새 그래프, 새 필터 단계, 또는 새 파생 측정값을 추가하려고 함 |
| 대상 산출물 | 시스템(측정·표시 기능을 담은 코드베이스) |
| 환경 | 개발 중, 일정이 촉박함 |
| 응답 | 기존 코드를 크게 뜯어고치지 않고 점진적으로 추가함; 격리 테스트는 QAS-10 |
| 응답 척도 | 새 그래프/표시 탭: 기존 모듈 변경 ≤ 1개(등록/배선부만), 분석/획득 코드 변경 0건. 새 필터 단계(F0–F3 참조): 파이프라인 등록 지점 변경 ≤ 1개, 하류 필터·획득부 무변경. 새 파생 측정값: 계산 레지스트리 변경 ≤ 1개, 획득/표시 프레임워크 변경 0건. 전 종류 공통: 회귀 0건 — 기존 기능 회귀 테스트 셋(QAS-10, 하드웨어 불요)이 변경 전후 모두 통과. (pass/fail이 아닌 참고용 계획 목표: 그래프 1종당 약 5인일.) |

**측정값 근거**
- **종류별 등록/배선 지점 ≤ 1개** (anchored) — Project Plan은 5주 일정 안에서 책임을 분리하며 점진적으로 확장하라고 요구하고, 필수 그래프가 약 11종(draft 1); 좁은 변경 표면이 그 일정을 가능케 하는 조건. 그래프·필터·측정값은 변경 프로파일이 달라 종류별 예산으로 분리(리뷰).
- **회귀 0건** — "기존 기능 회귀 테스트 셋이 변경 전후 통과"로 조작화(리뷰: 검출 방법 없는 0은 무의미).
- **약 5인일** (참고용) — 직접 근거가 없는 일정 추정값; 작업량은 아키텍처가 아니라 개발자 숙련도를 측정하므로 pass/fail에서 제외(리뷰).

### QAS-8 · Modifiability (Modularity) — 한 곳에서 고치기
> 유지보수 중 개발자가 한 가지 책임을 변경할 때, 변경은 그 책임의 모듈 안에 갇힌다: 사전 정의된 대표 단일 책임 변경 시나리오에 대해 각 변경이 ≤ 1개 모듈만 건드리고 전파(ripple) 0건. 횡단 변경(공유 타입, 파이프라인 관통 필드)은 명시적으로 범위 밖.

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 |
| 자극 | 단일 책임 하나를 변경해야 함 (예: 한 표시의 포맷, 한 계산식, 한 경보 규칙) |
| 대상 산출물 | 변경 대상 책임을 소유한 모듈 |
| 환경 | 유지보수 중 |
| 응답 | 한 가지 책임 변경이 다른 책임에 영향을 주지 않음 |
| 응답 척도 | 사전 정의된 대표 단일 책임 변경 시나리오 ≥ 3건에 대해: 각 변경이 ≤ 1개 모듈만 수정(자기 테스트 제외; 모듈은 정의 절 기준); ripple 0건 — 책임 경계 밖의 어떤 모듈도 소스/테스트 수정 불요. 횡단 변경은 범위 밖. |

**측정값 근거**
- **"1개 파일"이 아닌 ≤ 1개 모듈** ([JYP] 반영) — 파일 단위는 이상적인 경우에도 모듈성을 잘못 측정(인터페이스+구현, 코드+테스트는 정상적으로 2개 이상 파일에 걸침); 모듈 단위로 측정하여 QAS-7/9와 일관화.
- **대표 시나리오 ≥ 3건, 횡단 제외** — "전파 0건"은 단일 책임 경계 안에서만 성립; 대표 시나리오가 주장을 검증 가능하게 함(리뷰).
- **동기** — 베이스라인 `MainWindow.cpp`에 약 1,540줄의 여러 책임이 집중 [Code](draft 1); 이는 회피할 결합 리스크로 기술하며, 제공된 베이스라인 구조에 대한 단정이 아님(리뷰).

### QAS-9 · Modifiability (Portability) — 다른 장치/OS에서 실행
> 새 사운드 장치를 지원하거나 새 OS로 포팅할 때(필수 플랫폼 쌍은 C-3이 고정), 플랫폼 특화 관심사는 추상 계층 뒤에 격리된다: 새 사운드 장치는 어댑터 모듈 1개, 새 OS 포팅은 플랫폼 추상 계층에 국한 — 둘 다 도메인 코드 변경 0줄. (설계 시점 관심사; 런타임 장치 분리/복구는 QAS-12.)

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 |
| 자극 | 새 사운드 장치를 지원하거나, C-3 쌍 외의 새 OS로 포팅함 |
| 대상 산출물 | 장치 케이스: 오디오 입력 어댑터 계층. OS 케이스: 플랫폼 추상 계층(GUI/Qt, 스레딩, 파일 경로, 빌드 툴체인) |
| 환경 | 개발/유지보수 시점, 기존 코드베이스 대상; 필수 플랫폼 = Windows 11 x64와 Raspberry Pi OS ARM64 (C-3); Qt 베이스라인은 C-5 |
| 응답 | 추상 계층을 통해 새 OS / 사운드 장치를 지원함 |
| 응답 척도 | 새 사운드 장치: 어댑터 모듈 1개 변경/추가, 도메인 코드 변경 0줄(정의 절 기준). 새 OS: 변경이 플랫폼 추상 계층에 국한, 도메인 코드 변경 0줄; 회귀 테스트 셋(QAS-10)이 C-3 두 플랫폼 모두에서 통과 |

**측정값 근거**
- **장치 ≠ OS 분리** (리뷰) — OS 포팅은 사운드 입력만이 아니라 GUI/Qt·스레딩·파일시스템·빌드를 관통; 장치 케이스는 어댑터 모듈 1개 예산, OS 케이스는 별도의 현실적 예산으로 분리.
- **도메인 코드 0줄** (anchored) — Draft는 플랫폼 특화 관심사 분리와 도메인 계산 보존을 요구; 베이스라인도 이미 Linux/Windows audio와 분석 핵심이 분리되어 있어 [Code](draft 1) 구조적 근거가 있음. "1개 모듈"은 현재 상태가 아니라 목표 기준.

### QAS-10 · Testability — 부분 격리 테스트
> 테스트 중 개발자/테스터가 사운드 분석 단계나 입력 부분만 따로 테스트하려고 할 때, 각 핵심 분석 단계와 사운드 입력 부분은 실제 하드웨어 없이 가짜 입력 주입으로 독립 확인할 수 있다. Sim mode는 onset/peak 위치와 비트 스케줄이 선험적으로 알려진 합성 신호를 생성한다 — QAS-2/5/6/13의 ground truth. [SJ] X/D summary는 재현 가능하고 역추적 가능하다.

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 / 테스터 |
| 자극 | 사운드 분석 단계 또는 입력 부분만 따로 테스트하려고 함 |
| 대상 산출물 | 핵심 분석 단계(정의 절 기준), 사운드 입력 부분 |
| 환경 | 테스트 중, 오디오 하드웨어가 없는 호스트 |
| 응답 | 가짜 입력 주입으로 부분별 독립 확인; onset/peak 위치·비트 스케줄이 선험적으로 알려진 합성 신호 생성; [SJ] 반복 가능한 X/D 결과를 산출하고 산출에 쓰인 included/excluded position result를 제시 |
| 응답 척도 | 열거된 핵심 분석 단계의 line coverage ≥ 80%; 모든 핵심 단계와 사운드 입력 소스가 자기 인터페이스 경유 Sim/Playback 주입으로 구동 가능 — 계약(contract) 테스트가 오디오 장치 없는 호스트에서 통과; Sim 신호는 onset/peak 위치를 선험적으로 보유(FR-05-05 / FR-12-16); [SJ] 표준 포지션 셋(CH/CB/6H/9H/3H/12H, FR-01-03 / FR-04-04)을 커버하는 동일 데이터셋 3회 반복 실행 시 X/D 값 동일; X/D 역추적: 모든 (X, D) summary에 대해 포함/제외 position result를 시스템 출력에서 열거 가능 — summary의 100%에서 검증 |

**측정값 근거**
- **하드웨어 없는 격리** (grounded) — Draft의 Sim mode와 베이스라인의 `WatchSynthStream`, `SimWorker`, `PlaybackWorker`, WAV fixture [Code]가 이미 하드웨어 없이 입력을 주입(draft 1).
- **line coverage ≥ 80%** (provisional) — 외부 근거가 없는 팀 품질 목표; 분모를 정의 절의 핵심 단계 목록으로 고정해야 퍼센트가 의미를 가짐(리뷰).
- **계약 테스트 기준** — draft 1의 "하드웨어 없이 실행 가능한 단위 테스트 100%"를 대체 — 그 척도는 동어반복(작성된 테스트 집합의 속성일 뿐, 아키텍처의 격리 가능성을 측정하지 않음)(리뷰).
- **기지 위치 합성 신호** — QAS-2/5/6/13이 ground truth로 의존하므로 추가(리뷰: draft 1에서는 교차 참조가 댕글링이었음).
- **3회 반복 / 역추적 100% [SJ]** — X/D의 재현성·감사 가능성; 반복 횟수는 테스트 프로토콜 선택(provisional).

### QAS-11 · Usability — 저해상도 터치스크린에서 읽기·조작
> Raspberry Pi 5의 800×480 터치스크린에서 사용자가 측정값을 읽고 모드를 전환할 때, 핵심 측정값은 스크롤/확대 없이 가독성 있게 표시되고 주요 기능은 터치만으로 조작 가능하다. 물리 크기(mm)가 규범 기준이며, 픽셀 환산치는 패널 크기 확정 전까지 참고용. [SJ] Position/sequence review 중 active position과 X/D summary를 빠르게 식별 가능.

| 요소 | 내용 |
|------|------|
| 출처 | 사용자(시계공 / 측정자) |
| 자극 | 800×480 터치스크린에서 측정값을 읽고 모드를 전환함 |
| 대상 산출물 | GUI(스펙트로그램/스코프/수치 표시와 컨트롤) |
| 환경 | Raspberry Pi 5 + 800×480 터치 디스플레이, 평소 사용 중. 패널 물리 크기 미확정(Draft 자기모순: 헤더 "8 Inch" vs 본문 "5-inch" — C-1 참조). 베이스라인 GUI는 1280×750 고정으로 800×480 레이아웃이 없어 재레이아웃이 필수 작업 [Code] |
| 응답 | 핵심 측정값을 가독성 있게 표시; 주요 기능을 터치만으로 조작 가능; [SJ] active/selected position과 X/D를 관련 측정값 근처에 표시 |
| 응답 척도 | 주요 측정값(일오차·비트오차·진폭)을 스크롤/확대 없이 동시 표시; 글리프 높이 ≥ 1.9 mm(작업 거리 40 cm에서 약 16 arcmin), 대비 ≥ 4.5:1 (WCAG AA) — "≥ 24 px"는 참고용으로만 유지; 모든 주요 터치 타깃 물리 크기 ≥ 9 mm(픽셀 환산치는 참고용, 패널 크기 확정 후 재산출); 주요 모드 도달 ≤ 2 탭; [SJ] 대표 사용자 ≥ 3명이 sequence-review 화면에서 시작하는 시간 측정 과업에서 시도의 ≥ 90%에서 active position 5초 이내, X/D 10초 이내 식별. 터치 = 단일 탭/드래그; 멀티터치 제스처는 범위 밖([JYP]) |

**측정값 근거**
- **물리 mm 규범, px 참고** (리뷰) — "9 mm ≈ 48 px"는 약 135 ppi(7인치 800×480 패널)에서만 성립; Draft 자체가 8인치(≈ 117 ppi → 9 mm ≈ 41 px)와 5인치(≈ 187 ppi → ≈ 66 px)를 동시에 기술하므로 pass/fail이 환산에 의존하면 안 됨. 미해결 질문은 C-1에 기록.
- **터치 타깃 ≥ 9 mm** (anchored) — 통용되는 터치 인체공학 타깃 크기 기준(draft 1의 근거); 물리 기준으로 유지.
- **글리프 ≥ 1.9 mm / 40 cm에서 16 arcmin + 대비 ≥ 4.5:1** (derived) — 측정 불가능한 "작업 거리에서 판독 가능"을 피험자 없이 검증 가능한 지각 사양으로 교체(16 arcmin 가독성 관행 + WCAG AA 대비)(리뷰).
- **≤ 2 탭** (provisional) — 주요 모드 도달을 제한하는 팀 기준; 800×480 자체는 Draft의 직접 제약(C-2).
- **[SJ] 5초/10초 식별** — 측정 가능한 시간 과업으로 전환(사용자 ≥ 3명, 시도의 ≥ 90%)(리뷰: 시간 한계만으로는 프로토콜 부재).
- **[JYP] 터치 범위** — "터치로 조작"은 제공된 하드웨어에서 파생한 가정이지 Draft의 명시 요구가 아님; 단일 탭/드래그로 한정 — 멀티터치(swipe/pinch)는 Draft에 근거 없음.

### QAS-12 · Availability (Recoverability) — 오디오 장치 분리·스트림 오류
> 평소처럼 측정하는 동안 오디오 입력 장치가 분리되거나, 장치가 연결된 상태에서 입력 스트림이 복구 가능한 오류(예: ALSA xrun)를 일으키면, 시스템은 크래시 없이 오류를 감지·통지하고, 마지막 유효 판독값(stale 플래그)과 기캡처 데이터를 보존하며, fault 해소 후 10초 이내에 수동 재시작 없이 자동 재개한다.

| 요소 | 내용 |
|------|------|
| 출처 | 사운드 장치(외부) |
| 자극 | 측정 중 장치가 분리되거나, 장치가 연결된 상태에서 입력 스트림이 복구 가능한 오류를 일으킴 |
| 대상 산출물 | 사운드 입력 부분 / 시스템 |
| 환경 | 평소처럼 측정 중 |
| 응답 | 크래시 없이 오류를 감지하고 사용자에게 알림; 마지막 유효 판독값을 stale 플래그와 함께 계속 표시하고 기캡처 데이터를 보존; fault 해소 시 자동 재개 |
| 응답 척도 | 활성 측정 중 unplug/replug ≥ 20회 + 주입 스트림 오류 ≥ 5회에 걸쳐: 크래시 0회; "장치 없음"/"입력 오류" 표시 ≤ 5초; fault 해소 후 자동 재개 ≤ 10초, 전 시행 충족; fault 구간 내내 최근 유효 판독값이 stale 플래그와 함께 계속 표시; 기캡처 sequence/trace 데이터 손실 0건; 데이터 손상 0건 — 손상 = 복구 후 레코드가 (a) fault 전후 샘플 혼입, (b) torn 버퍼 샘플 포함, (c) fault 경계에서 비단조 타임스탬프 중 하나에 해당 |

**측정값 근거**
- **자동 재개 ≤ 10초** (derived, provisional) — 스트림 재오픈 후 베이스라인 재고착(re-lock) 경로 ≈ 2.5–3.5초(검출기 warmup 200 ms + BPH auto-detect 1.5 s + sync 획득 ≈ 0.8–1.7 s) [Code] → 약 3× 마진. 주의: 베이스라인에는 재연결 처리가 **없음** — 장치 소실 시 워커가 종료될 뿐 [Code] — 본 시나리오는 신규 능력을 규정.
- **표시 ≤ 5초** (provisional) — 직접 출처 없음; 팀 근거(draft 1): Draft의 명확한 오류 표시 요구("사용자가 추측하게 두지 말 것")와 약 2초 주기의 상태 갱신 → 5초 ≈ 갱신 주기 2회 + 여유.
- **마지막 판독값 보존, 데이터 손실 0** (grounded) — Draft의 "preserve the last useful reading"; (a)/(b)/(c) 정의와 함께 "데이터 손상 0"을 조작화(리뷰).
- **시행 횟수 ≥ 20 / ≥ 5** (provisional) — 테스트 프로토콜 선택; 분리와 스트림 오류 두 경로를 따로 검증(리뷰).

### QAS-13 · Accuracy (Computed Values) — 일오차·진폭·비트오차 vs Ground Truth
> 클린 조건에서 시스템이 기지 파라미터(BPH, Error Rate, Amplitude, Beat Error)와 설정된 lift angle로 생성된 Sim 신호를 측정할 때, 표시되는 계산값이 주입된 정답과 일치한다: 1,000비트 이상 기준 일오차 ≤ ±1 s/d, 진폭 ≤ ±5°, 비트오차 ≤ ±0.1 ms. 기존 미커버였던 클린 조건 정확도 공백 — 특히 어떤 시나리오도 한정하지 않던 amplitude — 을 해소한다.

| 요소 | 내용 |
|------|------|
| 출처 | 기지 파라미터를 가진 Sim 신호 생성기 (내부 ground truth) |
| 자극 | 프로그래밍된 rate/amplitude/beat error를 가진 Sim 신호에 대한 측정 실행 |
| 대상 산출물 | 계산 단계(rate, lift angle 포함 진폭, beat error) |
| 환경 | 클린 조건(잡음 주입 없음), Sim mode에서 Realistic OFF(기본값 ON — 해제 필요), 96,000 SPS |
| 응답 | 검출 이벤트로부터 rate, 진폭, beat error를 계산·표시; 설정된 lift angle과 BPH가 계산에 실제로 반영됨을 입증 가능 |
| 응답 척도 | 프로그래밍된 값 대비, 1,000비트 이상 기준: \|일오차\| ≤ 1 s/d; \|진폭 오차\| ≤ 5°(설정 lift angle 기준, 기본 52°); \|비트오차 오차\| ≤ 0.1 ms; FR-04-05 / FR-06-01..04가 표시하는 값들을 커버 |

**측정값 근거**
- **일오차 ≤ ±1 s/d** (anchored, provisional) — X1 계측 정확도(± 0.1 s/d [X1])의 10×이자 가장 엄격한 등급 대역(Chronometer −2…+6 s/d [TC])의 1/8 수준; 표시 단위 0.1 s/d [Code].
- **진폭 ≤ ±5°** (derived, provisional) — Amp = 3600λ/(π·n·t_AC) [EQ]의 오차 전파: worked example(230° @ t_AC = 9 ms)에서 \|dAmp/dt_AC\| ≈ 25.6°/ms → QAS-6의 0.1 ms 타이밍 예산 ≈ 2.6° → ±5° ≈ 2× 마진. 기준점: X1 진폭 정확도 ± 0.4° [X1]; 표시 단위 1° [Code].
- **비트오차 ≤ ±0.1 ms** (grounded) — X1 정확도 스펙과 동일 [X1]; QAS-6와 정합.
- **Sim ground truth** (grounded) — Draft의 Simulation Parameters; Sim 범위: Error Rate ± 999 s/d, Amplitude 100–360°(기본 300°), Beat Error ± 10 ms(step 0.1), BPH 3,600–43,200(기본 28,800); lift angle 기본 52°("52° is common" [EQ]; X1 범위 10–90°) [Code]. 클린 검증은 Realistic OFF 필수 — 기본값은 ON [Code].
- **≥ 1,000비트** (feasible) — QAS-5와 동일.

### QAS-14 · Usability (Session Continuity) — 리셋 없는 일시정지·탐색·뷰 전환
> 평소처럼 측정하는 동안 사용자가 표시를 일시정지하거나, 캡처 데이터를 앞뒤로 탐색하거나, 그래프 탭/분석 뷰를 전환해도 세션과 기록 데이터는 보존된다: 리셋 0회, 데이터 손실 0건, 일시정지 중에도 캡처 지속, 복귀 시 일시정지 구간 데이터 무손실.

| 요소 | 내용 |
|------|------|
| 출처 | 사용자(시계공 / 측정자) |
| 자극 | 라이브 세션 중 일시정지 / 앞뒤 탐색 / 그래프 탭·분석 뷰 전환 |
| 대상 산출물 | GUI 세션 상태, 캡처 버퍼, 획득 파이프라인 |
| 환경 | 정상 인터랙티브 사용 중 (장치 fault 아님 — 그것은 QAS-12) |
| 응답 | 세션과 기록 데이터를 보존; 일시정지 중에도 캡처 지속; 요청 구간을 렌더링 |
| 응답 척도 | 스크립트화된 실행(10분 라이브 세션 중 pause/seek/전환 ≥ 20회) 기준: 세션 리셋 0회; 캡처 데이터 손실 0건(전후 레코드 수/해시 검증); 탐색 뷰 렌더링은 선택 후 ≤ 500 ms; 복귀 시 일시정지 구간 데이터 전체 존재 |

**측정값 근거**
- **리셋 0 / 손실 0** (grounded) — 브리프 원문 그대로: "all graphs can run continuously … without losing the recorded signal or forcing a reset"; FR-05-06/07, FR-08-03, FR-12-17/18.
- **렌더링 ≤ 500 ms** (provisional) — 직접 근거 없음; redraw 작업셋이 10 s 그래프 히스토리로 한정되므로 [Code] 실현 가능성은 있음.
- **≥ 20회 조작** (provisional) — 테스트 프로토콜 선택.

### QAS-15 · Usability (Alert Annunciation) — 이상·허용범위 이탈 경보
> 평소처럼 측정하는 동안 판독값이 정의된 허용 대역을 벗어나면 — 진폭 270°–300° 밖(FR-02-09), 느리게 감(FR-02-05), trace 선 간격이 허용 범위를 벗어남(FR-06-11), trace 기울기 ≥ 45°(FR-06-13) — GUI는 2초 이내에 관련 판독값 근처에 명확한 경보를 표시하여, 시계 문제인지 소프트웨어 문제인지 사용자가 추측하게 두지 않는다(Draft, Usability 절).

| 요소 | 내용 |
|------|------|
| 출처 | 허용 대역을 벗어나는 분석 결과 (내부) |
| 자극 | 계산된 판독값이 허용 범위 초과 또는 fault 조건에 진입함 |
| 대상 산출물 | 경보/표시 로직과 GUI 인디케이터 |
| 환경 | 평소처럼 측정 중; 검증 시 조건은 Sim 파라미터로 유발 |
| 응답 | 관련 판독값 근처에 명확하고 귀속 가능한 경보를 표시함 |
| 응답 척도 | 각 조건을 유발하는 Sim 테스트 셋 기준: 조건 계산 후 경보 표시 ≤ 2초; 경보 누락 0건; 허용 대역 내에서 거짓 경보 0건; FR-02-05 / FR-02-09 / FR-06-11 / FR-06-13 추적 |

**측정값 근거**
- **경보 ≤ 2초** (anchored) — X1의 최소 integration time과 동일(Diagram integration 2–240 s; 자동표 시작 "0–2 h → 2 s") [X1]; 베이스라인 averaging 옵션도 2초부터 시작 [Code] — 첫 계산 결과보다 빠른 경보는 의미가 없음.
- **허용 대역** (anchored) — 270°는 Witschi의 기준 진폭(DVm @ 270° [X1]); 건강 범위 260–310° [TC]; 대역 양 끝값이 Sim 기본값과 일치(clean 설정 270° / UI 기본 300° — QAS-13에서 인용한 것과 동일한 UI 기본값) [Code]. 비트오차 참고: Draft 0.6 ms "양호"; [TC] 허용 0.0–0.5 ms, 결함 ≈ 3 ms.
- **누락 0 / 거짓 경보 0** (grounded) — 경보 정확성은 경보 FR들과 Draft의 usability 서사("사용자가 추측하게 두지 말 것")에 추적됨.

## Scope Notes — 보류된 드라이버

부재가 누락이 아닌 문서화된 결정임을 기록:

- **AI / TinyML 온디바이스 PoC** (킥오프 System Requirement, "where feasible"): time-box 일정 때문에 Milestone 1 범위 밖; Milestone 2에서 Integrability 관심사로 재검토.
- **Security, Deployability**: 범위 밖 — 네트워크 노출이 없는 로컬 작업대 계측기; 배포는 Qt 빌드 플로(C-5).
- **시작/모드 전환 시간** (Start → 첫 유효 판독; Live↔Playback↔Sim 전환): 식별된 공백; Planned Experiments 후 한계값 설정. 전환 시 세션 보존은 QAS-14가 커버.
- **인터랙티브 타이밍 포인트/구간 선택 품질** (G08/G10): FR로 실현; 전용 품질 척도는 보류.

## Constraints

| ID | 제약사항 |
|----|----------|
| C-1 | 시스템은 터치스크린이 연결된 Raspberry Pi 5(8 GB RAM, 128 GB microSD)에서 실행되어야 한다. 미해결 질문: Draft가 패널을 헤더 "8 Inch" / 본문 "5-inch"로 자기모순 기술 — 확정 크기를 여기에 기록하며, QAS-11의 픽셀 환산치를 결정한다. |
| C-2 | 시스템은 Raspberry Pi 5에 연결된 저해상도(800×480) 디스플레이에서 GUI를 올바르게 렌더링하고 동작해야 한다 (사용성 척도: QAS-11). |
| C-3 | 시스템은 Windows 11 (x64) PC와 Raspberry Pi OS(Debian 기반, 64-bit/ARM64)를 실행하는 Raspberry Pi 5 모두에서 실행되어야 한다. (추가 플랫폼의 변경 비용: QAS-9.) |
| C-4 | (운영 전제 조건) 호스트 오디오 장치는 측정 전 OS 오디오 믹서에서 Auto Gain Control 비활성을 설정·확인해야 하며, 시스템은 AGC가 꺼진 입력을 전제로 동작한다. 베이스라인은 이미 시작 시 양 OS에서 AGC를 프로그램적으로 비활성화한다 [Code]. |
| C-5 | 시스템은 제공된 Qt 기반 TimeGrapher 베이스라인(TimeGrapher_v10.5_Student, Qt Creator 프로젝트)을 확장하여 구현해야 하며, 처음부터 새로 구축하지 않는다. (툴체인: Qt 6 + Qt 5 fallback, CMake ≥ 3.16, C++17.) |
| C-6 | 시스템은 정의된 샘플레이트 운영점 — 48,000 SPS(최소), 96,000 SPS(목표), 192,000 SPS(스트레치) — 을 지원해야 한다. (베이스라인 코드는 48k/96k/192k에 더해 384k 제공, 기본 48k; WeiShi 시험 녹음은 48/96/192k에 걸침.) |
