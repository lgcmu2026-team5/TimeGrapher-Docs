# Milestone1 Jae-hong Oh

> English version above, Korean version below. (위쪽은 영어 버전, 아래쪽은 한국어 버전입니다.)
>
> Functional Requirements have been split into per-feature files (see `FR-G09_Time-Frequency_Spectrogram_Display.md`, `FR-G11_Scope_Mode_with_Synchronized_Sweep_Display.md`). This file keeps the Quality Attribute Scenarios and Constraints. (기능 요구사항은 기능별 파일로 분리되었습니다. 이 파일에는 품질 속성 시나리오와 제약사항만 남깁니다.)
>
> **rev.2 (2026-06-03)** — SAP 6-part review applied (see `review_result.md`): SAP taxonomy re-categorization (QAS-2/3/4/5/6/9/10), threshold derivations and **(provisional)** markings, environment pinning to the target platform and sample rates, measure deduplication, [JYP] comments applied to the body, three added scenarios (QAS-13–15), constraints C-5/C-6 added. Thresholds marked **(provisional)** are team-chosen targets to be confirmed by the Planned Experiments before Milestone 2.
>
> **rev.3 (2026-06-03)** — Threshold grounding added: each numeric threshold is now tied to evidence from the Witschi X1 manual / Training Course / Equations doc, the TimeGrapher baseline code, or a measured SNR analysis of the WeiShi test recordings. See the **Threshold Grounding** table (G1–G19) and `SNR-Analysis-WeishiMic.md`. Inline tags such as "(provisional — G6)" point into that table.

## Measure Definitions (shared by the scenarios below)

| Term | Definition |
|------|------------|
| Module | A cohesive code unit behind a single interface (interface + implementation; its own tests excluded). The counting unit for QAS-7/8/9. The concrete decomposition is fixed by the Milestone-2 module view. |
| Domain code | The analysis/calculation logic — beat detection, time calculation, rate/amplitude/beat-error computation, X/D aggregation — excluding signal-acquisition, platform/OS, GUI, and registration/wiring code (per the Draft's separation of acquisition / processing / calculation / presentation / platform concerns). |
| Core analysis stages | The enumerated set: beat/onset detection, onset/peak location, rate and rate-deviation computation, beat-error computation, amplitude (incl. lift angle) computation, X/D sequence aggregation. Shared by QAS-2/6/10 (coverage denominator; line coverage). |
| Sample-rate operating points | 48,000 SPS (minimum acceptable), 96,000 SPS (objective), 192,000 SPS (stretch goal) — see C-6. |
| Provisional | A threshold the team chose without a numeric basis in the project brief; to be confirmed or revised by experiment (Planned Experiments) before Milestone 2. Where evidence exists it is cited in the Threshold Grounding table below. |

## Threshold Grounding (Evidence)

Sources: **[X1]** = `Witschi-Chronoscope-X1-G3-Instruction-Manual.md`, **[TC]** = `Witschi-Training-Course.md`, **[EQ]** = `TimeGrapher-Equations_v0.docx.md`, **[SETUP]** = `TimeGrapher-GUI-Set-Up-Instructions.md` (all under `../Project/md/`); code refs = TimeGrapher baseline (`../../TimeGrapher/`); **[SNR]** = `SNR-Analysis-WeishiMic.md` (measured, this folder). Status: *grounded* = directly supported by a source; *anchored* = team value with a cited reference point; *derived* = computed from cited sources; *provisional* = no basis found, experiment required.

| ID | Threshold | Basis | Status |
|----|-----------|-------|--------|
| G1 | QAS-1 · 500 ms p99 end-to-end | Beat period 125 ms @ 28,800 BPH ([EQ]:157; Sim default BPH = 28,800 — `MainWindow.cpp:273`) → 500 ms ≈ 4 beat periods. Baseline structural display path ≈ ≥ 70 ms: 20 ms Linux/Pi block cadence (`SimWorker.cpp:11-12`) + fixed 50 ms envelope-alignment delay line (`Timegrapher.cpp:107-108`) → > 7× headroom remains for analysis + render on the Pi. | provisional (anchored) |
| G2 | QAS-2 · block cadence & 0.8× budget | Baseline delivery: Sim/Playback emit 20 ms blocks on Linux/Pi, 10 ms on Windows (`SimWorker.cpp:8-22`; `PlaybackWorker.cpp:9-21`) = 960 samples @ 48k; Live blocks are ALSA-driven, variable size (`AudioWorker.cpp:71-73`, no setBufferSize); detector consumes ≤ 4096-sample slices (`MainWindow.cpp:28`) ≈ 85.3 / 42.7 / 21.3 ms @ 48/96/192k; ring buffer 30 s (`SharedAudio.h:8`). 0.8× rule at the 20 ms Pi cadence → p99 ≤ 16 ms/block. | grounded |
| G3 | QAS-2 · missed-beat observability | tg library defaults: auto_detect 1.5 s, sync_loss_misses 12, event refractory 2.0 ms, sync tolerance 3% (`Timegrapher.cpp:240-248`) — per-beat detections and sync-loss are observable from the library. | grounded |
| G4 | QAS-3 · ≥ 2 h (≥ 6 h) run | The reference instrument's own long-run bands: Trace/Vario auto-integration table starts at "0–2 h → 2 s" ([X1]:672); measuring time up to 99:59:58 h ([X1]:674); Vario long-time stability tracking up to 100 h ([TC]:243). ≥ 2 h = the X1's first long-run band boundary. | anchored |
| G5 | QAS-3 · RSS ε / CPU 70·90% | Baseline memory shape is fixed-at-Start: 30 s ring buffer allocated once = 5.76 / 11.52 / 23.04 MB @ 48/96/192k (`SharedAudio.h:8`; `MainWindow.cpp:618-619`); graph history pruned beyond 10 s (`MainWindow.cpp:27,1050`) → steady state should show no structural growth; ε covers allocator/Qt caches. CPU 70/90%: no source found (workers run TimeCriticalPriority — `MainWindow.cpp:635`). | memory anchored / CPU provisional |
| G6 | QAS-5 · SNR ≥ 14 dB | Measured clean baseline: 9 WeiShi-mic recordings = 30–51 dB SNR (1 ms-envelope method; worst = `21600BPH_8215_InCase` 33.4 dB median-beat / 30.4 dB weak-beat) — [SNR]. Sim realistic mode ≈ 45 dB peak ratio (pcm 0.40 — `MainWindow.cpp:1383` / noise 0.0022 — `WatchSynthStream.cpp:147`; noise band 700 Hz–18 kHz — `:119-120`); clean config ≈ 58 dB (noise 0.0005 — `:83`). → 14 dB is a severe-degradation target ≥ 16 dB below the worst clean capture; reaching it requires deliberate noise injection. CAUTION — definition sensitivity: under a whole-signal-RMS metric the same worst file reads 15.1 dB (≈ 18 dB lower on identical data); do NOT rationalize 14 dB as "1 dB below the sample minimum" — that framing uses the RMS metric, places the acceptance bound at the clean floor (zero degradation margin), and conflates weak coupling with ambient noise (see [SNR] §Definition Sensitivity). | anchored (measured); acceptance bound provisional |
| G7 | QAS-5 · ±3 s/d under noise | Witschi grade tolerance table: Chronometer −2…+6, Gent's −5…+15, Lady's −5…+25 s/d ([TC]:334-336). ±3 s/d keeps the noise-induced rate error within the tightest class's band half-width. | anchored |
| G8 | QAS-5/6/13 · ≥ 1,000 beats | 1,000 beats = 125 / 166.7 / 200 s at 28,800 / 21,600 / 18,000 BPH ≈ 2.1–3.3 min of capture; the test recordings carry 229–366 beats per ~45 s — [SNR]. | feasible |
| G9 | QAS-5 · detection ≥ 95% | No basis found in any doc or the code. Baseline declares sync loss only after 12 consecutive misses (`Timegrapher.cpp:248`). | provisional |
| G10 | QAS-6 · 0.1 ms onset/peak | Equals the reference instrument's beat-error spec: X1 Resolution 0.1 ms / Accuracy ± 0.1 ms ([X1]:912); = 1/6 of the Draft's 0.6 ms "good" beat-error bound; baseline display and Sim input already step at 0.1 ms (`MainWindow.cpp:446`; `MainWindow.ui` Sim Beat Error). Feasibility at 48k: the detector already interpolates sub-sample (onset linear — `Detector.cpp:746-760`; peak parabolic — `:267-274`). | grounded |
| G11 | QAS-13 · rate ≤ ±1 s/d | 10× the X1 instrument accuracy (± 0.1 s/d — [X1]:912) and ⅛ of the tightest grade band (Chronometer −2…+6 s/d — [TC]:334-336); display steps at 0.1 s/d (`MainWindow.cpp:436`; [X1] 0.1/0.01 selectable). | anchored (provisional) |
| G12 | QAS-13 · amplitude ≤ ±5° | Error propagation: Amp = 3600λ/(π·n·t_AC) ([EQ]:270); worked example 230° @ t_AC = 9 ms ([EQ]:278-282) → \|dAmp/dt_AC\| = Amp/t_AC ≈ 25.6°/ms → QAS-6's 0.1 ms budget ≈ 2.6° → ±5° ≈ 2× margin. Reference points: X1 amplitude accuracy ± 0.4° ([X1]:912); display unit 1° (`MainWindow.cpp:441`). | derived (provisional) |
| G13 | QAS-13 · beat error ≤ ±0.1 ms | Equals the X1 beat-error Accuracy spec, ± 0.1 ms ([X1]:912). | grounded |
| G14 | QAS-13 · Sim ground-truth params | Sim UI ranges: Error Rate ±999 s/d step 1 (`MainWindow.ui:603-642`), Amplitude 100–360° default 300° (`:494-533`), Beat Error ±10 ms step 0.1 (`:552-581`), BPH 3600–43,200 default 28,800 (`MainWindow.cpp:81-86,273`). Lift angle default 52° (`MainWindow.cpp:100`; [EQ]:262 "52° is common"; [X1] range 10–90°), UI 30–70°. Clean verification requires Realistic OFF (default is ON — `MainWindow.ui:582-602`; clean noise 0.0005 vs realistic 0.0022 — `WatchSynthStream.cpp:83,147`). | grounded |
| G15 | QAS-12 · 5 s / 10 s | Baseline re-lock path after a stream re-open: detector warmup 200 ms (`Detector.cpp:142`) + BPH auto-detect 1.5 s (`Timegrapher.cpp:247`) + sync acquisition (≥ 6–8 events ≈ 0.8–1.7 s) ≈ 2.5–3.5 s → 10 s ≈ 3× margin. Note: the baseline has NO reconnect handling today — device loss just ends the worker (`AudioWorker.cpp:43-47`; state handler logs only — `:28-31`) — so QAS-12 specifies a new capability. 5 s indication: no basis. | 10 s derived (provisional) / 5 s provisional |
| G16 | QAS-15 · 2 s alert & bands | 2 s = the X1's minimum integration time (Diagram integration 2–240 s — [X1]:666; auto table "0–2 h → 2 s" — [X1]:672); the baseline's averaging options also start at 2 s (`MainWindow.cpp:88`). Beat error: Draft 0.6 ms "good" vs [TC] acceptable 0.0–0.5 ms / defective ≈ 3 ms ([TC]:283-285, 334-336). Amplitude: 270° is Witschi's canonical reference amplitude (DVm @ 270° — [X1]:412); healthy range 260–310° ([TC]:135); the band endpoints equal the Sim defaults — clean config 270° (`WatchSynthStream.cpp:84`) and UI default 300° (`MainWindow.ui:494-533`). | anchored |
| G17 | QAS-11 · 800×480 layout | The baseline GUI is hard-fixed at 1280×750 (geometry + maximumSize — `MainWindow.ui:5-18,888-896`) with no 800×480/fullscreen path → re-layout for the C-2 panel is required baseline work. Panel physical size: [SETUP] states none (absence verified) — the 5″/8″ open question stands. | contradiction documented |
| G18 | C-4 / C-5 / C-6 | C-4: the baseline already disables AGC programmatically and sets mic capture volume to 50% on both OSes (`MainWindow.cpp:40-47` + `LinuxAudio`/`WindowsAudio` implementations). C-5: v10.5 confirmed ([SETUP]:11, 97-98); toolchain Qt 6 (Qt 5 fallback), CMake ≥ 3.16, C++17 (`CMakeLists.txt`). C-6: code offers {48k, 96k, 192k, **384k**} with default 48k (`MainWindow.cpp:1246, 99`); synth accepts 44.1k–384k (`WatchSynthStream.cpp:12-13`); the test recordings span 48/96/192k ([SNR]). | grounded |
| G19 | QAS-14 · 500 ms seek render | No direct basis; redraw working set is bounded by the 10 s graph history (`MainWindow.cpp:27`). | provisional |

## QAS Priorities

Per the Milestone-1 requirement that drivers be prioritized. B = business importance, R = technical risk/difficulty (H/M/L).

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
| QAS-10 | Testability | H | M | Enables the ground-truth verification of QAS-2/5/6/13 and the regression safety of QAS-7 |
| QAS-11 | Usability (Touchscreen) | M | M | Fixed 800×480 panel; largely layout discipline once sizes are pinned |
| QAS-12 | Availability (Recoverability) | M | M | Bench-workflow resilience; standard device-fault handling |
| QAS-13 | Accuracy (Computed Values) | H | M | Closes the amplitude/beat-error accuracy gap; Sim ground truth makes it testable |
| QAS-14 | Usability (Session Continuity) | M | M | Explicit, repeated brief requirement ("without losing the recorded signal or forcing a reset") |
| QAS-15 | Usability (Alert Annunciation) | M | L | FR-anchored alerts (FR-02-05/09, FR-06-11/13); "don't leave the user guessing" |

**Top architecture-shaping drivers:** QAS-1/2 (real-time performance on the Pi), QAS-5/6/13 (measurement accuracy and noise robustness), QAS-7/10 (extensibility and testability within the schedule).

## Quality Attribute Scenarios

### QAS-1 · Performance (Latency) — From Sound Input to Screen Display
> While measuring on the target platform, when sound arrives at the microphone, the system processes it through the input → analysis → display flow and shows it on screen, with p99 (99th-percentile) end-to-end latency (sound arrival → on-screen display) ≤ 500 ms (provisional — G1: ≈ 4 beat periods at the typical 28,800 BPH and > 7× the baseline's ~70 ms structural display path; chosen as the perceived-real-time display bound, since the brief mandates minimizing and reporting latency but sets no number). Keeping up with the input rate (no dropped blocks / missed beats) is owned by QAS-2 and is a precondition of this measurement.

| Element | Content |
|---------|---------|
| Source | The microphone / watch (external) |
| Stimulus | Sound arrives at the microphone |
| Artifact | The full input → analysis → display flow |
| Environment | Live measurement on the Raspberry Pi 5 (8 GB, per C-1) at the 96,000 SPS objective rate — must also hold at the 48,000 SPS minimum (per C-6) — GUI active, continuous normal load (the brief warns PC performance does not transfer to the Pi) |
| Response | Process and show on screen |
| Response Measure | p99 end-to-end latency (sound arrival → on-screen) ≤ 500 ms (provisional — G1; ≈ 4 beat periods @ 28,800 BPH), measured over a 10-min continuous run via capture / processing / display timestamps (per the Draft's latency-reporting requirement). Keep-up (0 dropped blocks / 0 missed beats) is a precondition verified by QAS-2. |

### QAS-2 · Performance (Throughput) — Analysis Keep-Up and Compute Budget
> While measuring on the target platform, when audio blocks arrive at the configured sample-rate cadence, the system sustains the input rate without backlog — 0 dropped audio blocks and 0 missed beats over a 10-min continuous run, with no backlog growth trend — and, as the enabling budget, completes each block's analysis within p99 ≤ 80% of the block inter-arrival interval (G2: = 16 ms at the baseline's 20 ms Linux/Pi block cadence).

| Element | Content |
|---------|---------|
| Source | The audio input / acquisition pipeline (delivers blocks at the configured sample-rate cadence) |
| Stimulus | An audio block arrives for analysis |
| Artifact | The analysis processing stage, instrumented from t_block_handed_to_analysis to t_result_produced (includes beat detection and rate/amplitude/beat-error computation; excludes capture buffering and display rendering) |
| Environment | Live measurement on the Raspberry Pi 5 at 96,000 SPS objective — also verified at the 48,000 SPS minimum; 192,000 SPS stretch measured but not gated (per C-6) |
| Response | Sustain the input rate; complete each block's analysis within the compute budget |
| Response Measure | Over a 10-min continuous run at each gated rate: 0 dropped audio blocks (input-callback overrun counter); 0 missed beats vs the known Sim/Playback beat schedule (missed beat = an expected beat with no detection; per QAS-10, observable via the tg library's per-beat events and sync-loss reporting — G3); no backlog (queue-depth) growth trend; p99 per-block compute time ≤ 0.8 × the block inter-arrival interval (G2 — baseline: 20 ms Sim/Playback cadence on Linux/Pi → budget 16 ms/block; Live blocks are ALSA-driven/variable and are measured against the observed inter-arrival interval; detector consumes ≤ 4096-sample slices) |

### QAS-3 · Availability (Resource-Leak Resilience) — No Degradation Over Long Runs
> While measuring continuously on the Raspberry Pi 5 (8 GB) for an extended session, the system continues to deliver correct service without degrading over time — no memory leak, no crash, no UI freeze, no thermal-throttling-induced slowdown — over a ≥ 2-hour continuous run (≥ 6 h for Long-Term Performance Graph use; duration per [JYP] review, now applied — G4: ≥ 2 h is the reference instrument's first long-run integration band, and Witschi Vario tracks stability up to 100 h). Keeping up with the input rate is a precondition verified by QAS-2.

| Element | Content |
|---------|---------|
| Source | The operator starting a long unattended measurement (e.g., a Long-Term Performance test, G07) |
| Stimulus | A continuous measurement runs for an extended period without stopping |
| Artifact | The whole system, Raspberry Pi memory / process health |
| Environment | Continuous run ≥ 2 h (≥ 6 h for long-term-graph use, per [JYP]; G4) on the Raspberry Pi 5 (8 GB) at 96,000 SPS; keep-up per QAS-2 as a precondition |
| Response | Continue correct service without degrading: no resource exhaustion, no crash, no freeze, no thermal throttling |
| Response Measure | Over the full run: linear-fit RSS slope over every 30-min window ≤ 0 + ε (no sustained monotonic growth; ε = measurement-noise allowance, provisional — G5: the baseline's memory shape is fixed-at-Start, 30 s ring buffer + pruned 10 s graph history, so no structural growth is expected); 0 crashes; 0 screen freezes (freeze = no screen update for ≥ 2 s, detected via a render-heartbeat log); mean CPU ≤ 70%, peak ≤ 90% (provisional — G5) and 0 thermal-throttling events reported by the Pi's governor |

### QAS-4 · Correctness (Display Consistency) — Consistent Values Across Displays
> While measuring as usual, when a single measurement result is produced and fanned out to multiple graphs and numbers, every display rendered in the same on-screen frame derives from that single measurement result and is mutually consistent — 0 value mismatches across displays. (A shared tagged snapshot, e.g., a snapshot ID, is a suggested tactic, not a required mechanism.) [SJ] For sequence features, the X/D summary uses the same captured result set as the per-position display.

| Element | Content |
|---------|---------|
| Source | The analysis/computation stage (internal) |
| Stimulus | A single measurement result is produced and fanned out to multiple displays (graphs/numbers) |
| Artifact | Numeric readouts and multiple graph displays |
| Environment | Measuring as usual (Live, or Sim/Playback for verification) |
| Response | All values and graphs shown together in one frame derive from one measurement result and are mutually consistent; [SJ] derive X/D sequence summaries from the displayed per-position result set |
| Response Measure | Over a 10-min Sim/Playback run on a known reference input (per QAS-10), across all sampled frames: every pair of simultaneously shown displays presents values computed from the same measurement result (within display rounding) — 0 mismatches. Each display exposes its source-result identity (e.g., trace log or debug overlay) so the check is observable; [SJ] X/D source mismatch between sequence summary and displayed per-position values = 0 cases |

### QAS-5 · Accuracy & Availability (Graceful Degradation) — Under Noisy or Weak Signals
> In a poor environment where ambient noise mixes in or a weak signal arrives, the system (noise removal / beat detection) filters out noise while preserving the needed sounds, and when signal quality is too low it shows a "signal weak" indication instead of a wrong value. Verified against synthetic Sim/Playback beat signals mixed with calibrated injected noise — ground truth is the generator's known beat schedule and programmed rate (a reference-instrument reading serves only as a clean-condition sanity check; it cannot be ground truth under the injected noise): beat detection rate ≥ 95% (provisional — G9: no domain basis found) and rate error ≤ ±3 s/d (provisional — G7: within the tightest Witschi grade class, Chronometer −2…+6 s/d) at SNR ≥ 14 dB (provisional — G6: clean WeiShi-mic test recordings measure 30–51 dB, so 14 dB stress-tests ≥ 16 dB below the worst clean capture and requires deliberate noise injection), over ≥ 1,000 beats (G8: ≈ 2.1–3.3 min of capture); below that threshold the system shows only "signal weak" and outputs 0 wrong values over the run. [SJ] Invalid or low-confidence position results are excluded from X/D sequence calculations — the inclusion/exclusion rule itself is owned by FR-04-06.

| Element | Content |
|---------|---------|
| Source | Ambient noise / weak signal (external) |
| Stimulus | Noise mixes in or the signal arrives weak |
| Artifact | The noise-removal / beat-detection part and the signal-quality indication |
| Environment | Noisy bench environment, reproduced by mixing calibrated noise into Sim/Playback input at a controlled, held-constant SNR. SNR definition: per-beat impulse peak (A/C events, windowed) vs ambient-noise RMS in the analysis band (= above the baseline's 200 Hz HPF default — `Timegrapher.cpp:243`; cf. Sim noise band 700 Hz–18 kHz); measurement method per `SNR-Analysis-WeishiMic.md` |
| Response | (Accuracy) detect beats and compute rate within tolerance under noise; (Availability) when below the quality threshold, degrade gracefully — show "signal weak" instead of any value; [SJ] exclude invalid/low-confidence position results from X/D (rule per FR-04-06) |
| Response Measure | Against the generator's known beat schedule and programmed rate, over ≥ 1,000 beats: beat detection rate ≥ 95% (provisional — G9) and rate error ≤ ±3 s/d (provisional — G7) at SNR ≥ 14 dB (provisional — G6); below threshold: only "signal weak", and 0 wrong values over the run (wrong value = a displayed reading not flagged "signal weak" whose error vs ground truth exceeds the tolerance above); [SJ] invalid/low-confidence values included in X/D calculations = 0 cases |

### QAS-6 · Accuracy (Measurement Correctness) — Pinpointing Beats Precisely
> While measuring as usual, when a new beat (tick/tock) arrives in the input stream, the system (beat detection / time calculation) determines its onset and peak positions accurately, preserving timing precision through every processing stage (acquisition → filtering → event detection → calculation, per the Draft), locating onset/peak within ≤ 0.1 ms — equal to 4.8 / 9.6 / 19.2 samples at 48k / 96k / 192k SPS, so sub-sample interpolation is required at the 48,000 SPS minimum. Verified against synthetic signals with known onset/peak positions generated by Sim mode (FR-05-05 / FR-12-16; reference points per FR-08-06 and the Glossary; harness per QAS-10), since 0.1 ms ground truth cannot be obtained from real hardware. Rationale for 0.1 ms: ~1/6 of the 0.6 ms "good" beat-error threshold (Draft), so clinically meaningful beat-error differences remain resolvable; it also equals the reference instrument's beat-error resolution/accuracy (Witschi X1: 0.1 ms / ± 0.1 ms), and the baseline detector already locates events with sub-sample interpolation (G10).

| Element | Content |
|---------|---------|
| Source | Watch beat (external input stream) |
| Stimulus | A new beat (tick/tock) arrives in the input stream |
| Artifact | The beat-detection / time-calculation part |
| Environment | Measuring as usual; verified at the 96,000 SPS objective and the 48,000 SPS minimum (per C-6) |
| Response | Determine the arriving beat's onset and peak positions accurately; preserve timing precision through every processing stage (acquisition, filtering, detection, calculation) |
| Response Measure | Maximum onset/peak detection position error ≤ 0.1 ms over ≥ 1,000 synthetic beats with known positions (Sim mode, FR-05-05 / FR-12-16; onset/peak per FR-08-06), verified at 96,000 SPS (= 9.6 samples) and 48,000 SPS (= 4.8 samples; sub-sample interpolation required — already present in the baseline detector); no real hardware (per QAS-10); grounding G10 |

### QAS-7 · Modifiability (Extensibility) — Adding a New Measurement/Filter/Graph
> In a tight-schedule development situation, when a developer wants to add a new graph, a new filter stage, or a new derived measurement, they can add it incrementally without heavily tearing into existing code — with a per-kind change budget and zero regressions. (Isolation testability of the new unit is governed by QAS-10.)

| Element | Content |
|---------|---------|
| Source | Developer |
| Stimulus | Wants to add a new graph, a new filter stage, or a new derived measurement |
| Artifact | The system (codebase holding the measurement/display features) |
| Environment | During development, tight schedule |
| Response | Add incrementally without heavily tearing into existing code; isolation testing per QAS-10 |
| Response Measure | New graph/display tab: ≤ 1 existing module changed (registration/wiring only), 0 changes to analysis/acquisition code. New filter stage (cf. F0–F3, G12): ≤ 1 pipeline registration point changed, downstream filters and acquisition unchanged. New derived measurement: ≤ 1 calculation-registry change, 0 changes to acquisition/display frameworks. All kinds: 0 regressions — the existing-feature regression test set (per QAS-10, runnable without hardware) passes before and after. (Informational planning target, not a pass/fail measure: ≈ 5 person-days per graph, covering design + implementation + unit test.) |

### QAS-8 · Modifiability (Modularity) — Fixing in One Place
> During maintenance, when a developer changes a single responsibility, the change is confined to that responsibility's module: for a predefined set of representative single-responsibility change scenarios, each change touches ≤ 1 module (excluding its own tests) with 0 ripple to other responsibilities. Cross-cutting changes (shared types, pipeline-wide fields) are explicitly out of scope. ([JYP] review applied: measured by module, not file; scoped to a representative scenario set; cross-cutting excluded.)

| Element | Content |
|---------|---------|
| Source | Developer |
| Stimulus | Needs to change a single responsibility (e.g., one display's formatting, one calculation, one alert rule) |
| Artifact | The module owning the responsibility being changed |
| Environment | During maintenance |
| Response | Changing one responsibility has no effect on the others |
| Response Measure | For a predefined set of ≥ 3 representative single-responsibility change scenarios: each change touches ≤ 1 module (excluding its own tests; module per Definitions); 0 ripple — no module outside the responsibility boundary requires a source or test edit. Cross-cutting changes (shared types, pipeline-wide fields) are out of scope (per [JYP]). |

### QAS-9 · Modifiability (Portability) — Running on Other Devices/OSes
> When supporting a new sound device or porting to a new OS (the mandated platform pair is fixed by C-3), platform-specific concerns are isolated behind abstraction layers: adding a new sound device touches one adapter module with no domain-code change; porting to a new OS is confined to the platform-abstraction layer (GUI/Qt, threading, filesystem, build) with no domain-code change. (Design-time concern; run-time device disconnect/recovery is QAS-12.)

| Element | Content |
|---------|---------|
| Source | Developer |
| Stimulus | Supporting a new sound device, or porting to a new OS beyond the C-3 pair |
| Artifact | Device case: the audio-input adapter layer. OS case: the platform-abstraction layer (GUI/Qt, threading, filesystem paths, build toolchain) |
| Environment | Development/maintenance time, against the existing codebase; mandated platforms = Windows 11 x64 and Raspberry Pi OS ARM64 (per C-3); Qt baseline per C-5 |
| Response | Support the new OS / sound device through the abstraction layer |
| Response Measure | New sound device: 1 adapter module changed/added, 0 lines of domain code changed (domain code per Definitions). New OS: changes confined to the platform-abstraction layer, 0 lines of domain code changed; the regression test set (QAS-10) passes on both C-3 platforms |

### QAS-10 · Testability — Testing Parts in Isolation
> During testing, when a developer/tester wants to test just the sound-analysis stages or the input part separately, each core analysis stage and the sound-input part can be checked in isolation by feeding fake input without real hardware. Sim mode generates synthetic beat signals whose onset/peak positions and beat schedule are known a priori (derived from the configured BPH / Error Rate / Beat Error), serving as the ground truth for QAS-2/5/6/13. [SJ] X/D sequence summaries are reproducible with the same Sim/Playback input and traceable to included/excluded position results.

| Element | Content |
|---------|---------|
| Source | Developer / tester |
| Stimulus | Wants to test just the sound-analysis stages or input part separately |
| Artifact | The core analysis stages (per Definitions), the sound-input part |
| Environment | During testing, on a host with no audio hardware |
| Response | Check parts in isolation by feeding fake input without real hardware; generate synthetic beat signals with a priori known onset/peak positions and beat schedule (ground truth for QAS-2/5/6/13); [SJ] produce repeatable X/D sequence results and expose the included/excluded position results used to calculate them |
| Response Measure | Line coverage ≥ 80% (team-chosen target) on the enumerated core analysis stages; every core stage and the sound-input source is drivable via its interface with Sim/Playback injection — contract tests pass on a host with no audio device; Sim's synthetic signals carry a priori known onset/peak sample positions (FR-05-05 / FR-12-16); [SJ] X/D values identical across 3 repeated runs of the same Sim/Playback dataset covering the standard position set (CH/CB/6H/9H/3H/12H, FR-01-03 / FR-04-04); X/D trace-back: for every (X, D) summary, the included and the excluded (invalid/low-confidence) position results are enumerable from system output — verified for 100% of summaries |

### QAS-11 · Usability — Reading and Operating on the Low-Resolution Touchscreen
> While using the device as usual on the Raspberry Pi 5's 800×480 touchscreen, when the user reads measurement values and switches modes, the system presents the key readings legibly without scrolling/zooming and lets the user operate primary functions by touch alone. Physical sizes are the normative criteria; pixel equivalents are advisory until the panel's physical size is confirmed (open question: the Draft states both "8 Inch" in the heading and "5-inch" in the body — see C-1). [SJ] During position and sequence review, the user can quickly identify the active/selected position and X/D summary. [JYP] "operate by touch" is a derived assumption from the provided touchscreen hardware (Draft, Hardware §), scoped to single tap/drag only; multi-touch gestures (swipe, pinch-zoom) are out of scope — zoom/navigate are satisfied by tap-based controls (buttons/sliders).

| Element | Content |
|---------|---------|
| Source | User (watchmaker / operator) |
| Stimulus | Reads measurement values and switches modes on the 800×480 touchscreen |
| Artifact | The GUI (spectrogram/scope/numeric displays and controls) |
| Environment | Raspberry Pi 5 with the 800×480 touch display, in normal use (physical panel size to be confirmed — Draft says 8-inch heading vs 5-inch body; see C-1). Note: the baseline GUI is hard-fixed at 1280×750 with no 800×480 layout, so re-layout for this panel is required baseline work (G17) |
| Response | Present key readings legibly and allow primary functions to be operated by touch alone; [SJ] show active/selected position and X/D near the related measurement values |
| Response Measure | Primary readings (rate, beat error, amplitude) shown simultaneously without scroll/zoom; glyph height of primary readings ≥ 1.9 mm (≈ 16 arcmin at the 40 cm reference working distance) with contrast ≥ 4.5:1 (WCAG AA) — the previous "≥ 24 px font" is retained as an advisory pixel figure only; all primary touch targets ≥ 9 mm physical (the pixel equivalent is advisory and is re-derived once the panel size is confirmed); any primary mode reachable in ≤ 2 taps; [SJ] in a timed task with ≥ 3 representative users starting from the sequence-review screen, the active/selected position is identified within 5 s and X/D within 10 s in ≥ 90% of trials; [JYP] touch = single tap/drag; no multi-touch gesture is required or measured |

### QAS-12 · Availability (Recoverability) — Audio Device Disconnect or Stream Error
> While measuring as usual, when the audio input device is disconnected, or the input stream raises a recoverable error (e.g., an ALSA xrun) with the device still attached, the system detects the fault without crashing, informs the user, preserves the last useful reading (flagged stale) and all previously captured data, and resumes measurement automatically — without a manual restart — within 10 s (provisional — G15: the baseline's re-lock path after a stream re-open is ≈ 2.5–3.5 s, so 10 s gives ≈ 3× margin; note the baseline has no reconnect handling today, so this scenario specifies a new capability) of the fault clearing (device reconnected, or stream successfully re-opened), with a "no device" / "input error" indication within 5 s (provisional — G15), 0 crashes, and 0 data corruption.

| Element | Content |
|---------|---------|
| Source | Sound device (external) |
| Stimulus | The audio input device is disconnected, or the input stream raises a recoverable error (device still attached), during measurement |
| Artifact | The sound-input part / the system |
| Environment | Measuring as usual |
| Response | Detect the fault without crashing; inform the user; keep the last useful reading visible (flagged stale) and preserve all captured data; resume automatically once the fault clears |
| Response Measure | Verified over ≥ 20 unplug/replug cycles and ≥ 5 injected stream errors during active measurement: 0 crashes across all trials; "no device" / "input error" indication ≤ 5 s (provisional — G15); automatic resumption ≤ 10 s (provisional — G15) of the fault clearing on every trial; the most recent valid reading remains visible (flagged stale) throughout the outage; 0 loss of previously captured sequence/trace data; 0 data corruption — corruption = a post-recovery measurement record that (a) mixes pre- and post-fault audio samples, (b) contains samples from a torn/partially-read buffer, or (c) has a non-monotonic timestamp sequence across the fault boundary |

### QAS-13 · Accuracy (Computed Values) — Rate, Amplitude, Beat Error vs Ground Truth
> In clean conditions, when the system measures a Sim-generated signal with known programmed parameters (BPH, Error Rate, Amplitude, Beat Error — the Draft's Simulation Parameters) and a configured lift angle, the displayed computed values match the injected ground truth: rate error ≤ ±1 s/d (provisional — G11: 10× the X1 instrument accuracy of ±0.1 s/d), amplitude error ≤ ±5° (provisional — G12: a 0.1 ms A→C timing error ≈ 2.6° near 230° per the Equations worked example, so ±5° ≈ 2× margin; for the configured lift angle), beat-error error ≤ ±0.1 ms (= the X1 instrument's accuracy spec — G13; consistent with QAS-6), over ≥ 1,000 beats (G8). The configured lift angle and BPH demonstrably flow into the computation (changing the lift angle changes the computed amplitude per the equations document). This closes the previously uncovered clean-condition accuracy gap — in particular amplitude, which no other scenario bounds.

| Element | Content |
|---------|---------|
| Source | The Sim signal generator with known programmed parameters (internal ground truth) |
| Stimulus | A measurement run on a Sim signal with programmed rate / amplitude / beat error |
| Artifact | The calculation stages (rate, amplitude incl. lift angle, beat error) |
| Environment | Clean conditions (no injected noise), Sim mode with Realistic OFF (clean config — G14: default is ON and must be unchecked), 96,000 SPS |
| Response | Compute and display rate, amplitude, and beat error from the detected events |
| Response Measure | Versus the programmed values over ≥ 1,000 beats: \|rate error\| ≤ 1 s/d (provisional — G11); \|amplitude error\| ≤ 5° (provisional — G12) with the configured lift angle (default 52° — G14); \|beat-error error\| ≤ 0.1 ms (per QAS-6; G13); Sim parameter ranges per G14; covers the values displayed by FR-04-05 / FR-06-01..04 |

### QAS-14 · Usability (Session Continuity) — Pause, Seek, and View Switching Without Reset
> While measuring as usual, when the user pauses the display, seeks backward/forward through captured data, or switches the graph tab / analysis view, the session and recorded data are preserved: 0 session resets, 0 loss of captured data, live capture continues in the background during pause, and resuming the live view loses none of the data captured while paused. (Traces to the brief: "all graphs can run continuously … without losing the recorded signal or forcing a reset"; FR-05-06/07, FR-08-03, FR-12-17/18.)

| Element | Content |
|---------|---------|
| Source | User (watchmaker / operator) |
| Stimulus | Pauses, seeks backward/forward, or switches graph tab / analysis view during a live session |
| Artifact | GUI session state, the capture buffer, the acquisition pipeline |
| Environment | Normal interactive operation (not a device fault — that is QAS-12) |
| Response | Preserve the session and recorded data; keep capturing during pause; render the requested region |
| Response Measure | Over a scripted interaction run (≥ 20 pause/seek/switch operations during a 10-min live session): 0 session resets; 0 captured-data loss (verified by record count/hash before vs after); the sought view renders ≤ 500 ms (provisional — G19) after selection; on resume, the full pause-period data is present |

### QAS-15 · Usability (Alert Annunciation) — Fault and Out-of-Tolerance Conditions
> While measuring as usual, when a reading crosses a defined tolerance band — amplitude outside 270°–300° (FR-02-09), the watch running late (FR-02-05), trace-line spacing beyond the acceptable range (FR-06-11), or trace slope ≥ 45° (FR-06-13) — the GUI surfaces a clear alert near the related reading within 2 s (provisional — G16: equals the X1's minimum 2 s integration time, and the baseline's averaging options also start at 2 s) of the condition being computed, so the user is not left to guess whether the watch or the software is at fault (Draft, Usability section).

| Element | Content |
|---------|---------|
| Source | Analysis results crossing tolerance bands (internal) |
| Stimulus | A computed reading enters an out-of-tolerance or fault condition |
| Artifact | The alert/annunciation logic and GUI indicators |
| Environment | Measuring as usual; conditions induced via Sim parameters for verification |
| Response | Surface a clear, attributable alert near the related reading |
| Response Measure | Over a Sim test set that exercises each condition (amplitude out of 270–300°, running late, spacing out of range, slope ≥ 45°): alert displayed ≤ 2 s (provisional — G16) after the condition is computed; 0 missed alerts; 0 false alerts while readings stay within tolerance; traces to FR-02-05 / FR-02-09 / FR-06-11 / FR-06-13; band references per G16 (270° = Witschi reference amplitude; Sim defaults 270°/300°; [TC] beat-error acceptable 0.0–0.5 ms) |

## Scope Notes — Deferred Drivers

Recorded so absences are documented decisions, not oversights (per the Milestone-1 actionability test):

- **AI / TinyML on-device PoC** (kickoff System Requirement, "where feasible"): out of Milestone-1 driver scope due to the time-boxed schedule; to be revisited at Milestone 2 as an Integrability concern (the analysis pipeline should be able to host a signal-quality / bad-data-rejection classifier).
- **Security, Deployability**: out of scope at Milestone 1 — a local bench instrument with no network exposure; deployment is the Qt build flow per C-5.
- **Startup / mode-transition timing** (Start → first valid reading; Live↔Playback↔Sim switch latency): identified gap; bounds to be set after the Planned Experiments. Session preservation across switches is already covered by QAS-14.
- **Interactive timing-point / region selection quality** (FR groups G08/G10 — Escapement Analyzer / Waveform Comparison): realized as FRs; a dedicated quality measure (selection → interval readout ≤ N ms, displayed interval = marker positions ± tolerance) is deferred.

## Constraints

| ID | Constraint |
|----|------------|
| C-1 | The system shall run on a Raspberry Pi 5 (8 GB RAM, 128 GB microSD) with the attached touchscreen. Open question: the Draft states the panel as both "8 Inch" (heading) and "5-inch" (body); the confirmed physical size will be recorded here and drives the QAS-11 pixel equivalents. |
| C-2 | The system shall render and operate the GUI correctly on the low-resolution (800×480) display attached to the Raspberry Pi 5 (usability measures: QAS-11). |
| C-3 | The system shall run on both a Windows 11 (x64) PC and a Raspberry Pi 5 running Raspberry Pi OS (Debian-based, 64-bit/ARM64). (Modifiability cost of additional platforms: QAS-9.) |
| C-4 | (Operating precondition) The host audio device shall have Auto Gain Control disabled, configured and verified in the OS audio mixer (AlsaMixer on Raspberry Pi OS) before measurement; the system presupposes AGC-off input. The baseline already disables AGC programmatically at startup and sets the mic capture volume to 50% on both OSes (G18). |
| C-5 | The system shall be implemented by extending the provided Qt-based TimeGrapher baseline (TimeGrapher_v10.5_Student, a Qt Creator project), not built from scratch. (v10.5 confirmed — G18; toolchain: Qt 6 with Qt 5 fallback, CMake ≥ 3.16, C++17.) |
| C-6 | The system shall support the defined sample-rate operating points: 48,000 SPS (minimum acceptable), 96,000 SPS (objective), and 192,000 SPS (stretch goal). (The baseline code offers 48k/96k/192k and additionally 384k, default 48k; the WeiShi test recordings span 48/96/192k — G18.) |

---

## 측정 정의 (아래 시나리오 공통)

| 용어 | 정의 |
|------|------|
| Module(모듈) | 단일 인터페이스 뒤의 응집된 코드 단위(인터페이스 + 구현, 자기 테스트 제외). QAS-7/8/9의 계수 단위. 구체적 분해는 Milestone 2 module view에서 확정. |
| Domain code(도메인 코드) | 분석·계산 로직 — 비트 감지, 시간 계산, rate/amplitude/beat error 계산, X/D 집계 — 신호 획득, 플랫폼/OS, GUI, 등록/배선 코드는 제외(Draft의 acquisition / processing / calculation / presentation / platform 분리 기준). |
| Core analysis stages(핵심 분석 단계) | 열거 집합: 비트/onset 감지, onset/peak 위치 결정, rate·rate-deviation 계산, beat error 계산, amplitude(lift angle 포함) 계산, X/D sequence 집계. QAS-2/6/10이 공유(커버리지 분모, line coverage 기준). |
| Sample-rate operating points(샘플레이트 운영점) | 48,000 SPS(최소 허용), 96,000 SPS(목표), 192,000 SPS(스트레치) — C-6 참조. |
| Provisional(잠정) | 브리프에 수치 근거가 없어 팀이 선정한 임계값. Milestone 2 전에 실험(Planned Experiments)으로 확정 또는 수정. 근거가 존재하는 값은 아래 측정값 근거 표에 인용. |

## 측정값 근거 (Threshold Grounding)

출처 약어: **[X1]** = `Witschi-Chronoscope-X1-G3-Instruction-Manual.md`, **[TC]** = `Witschi-Training-Course.md`, **[EQ]** = `TimeGrapher-Equations_v0.docx.md`, **[SETUP]** = `TimeGrapher-GUI-Set-Up-Instructions.md` (모두 `../Project/md/`); 코드 참조 = TimeGrapher 베이스라인 (`../../TimeGrapher/`); **[SNR]** = `SNR-Analysis-WeishiMic.md` (실측, 본 폴더). 상태: *grounded* = 출처가 직접 뒷받침 / *anchored* = 인용 기준점을 가진 팀 선정값 / *derived* = 인용 출처로부터 계산 / *provisional* = 근거 없음, 실험 필요.

| ID | 측정값 | 근거 | 상태 |
|----|--------|------|------|
| G1 | QAS-1 · 종단 p99 500 ms | 28,800 BPH의 비트 주기 = 125 ms ([EQ]:157; Sim 기본 BPH = 28,800 — `MainWindow.cpp:273`) → 500 ms ≈ 4비트 주기. 베이스라인의 구조적 표시 경로 ≈ ≥ 70 ms: Linux/Pi 블록 주기 20 ms (`SimWorker.cpp:11-12`) + 고정 50 ms envelope 정렬 지연선 (`Timegrapher.cpp:107-108`) → Pi에서 분석+렌더링에 7× 이상의 여유. | provisional (anchored) |
| G2 | QAS-2 · 블록 주기·0.8× 예산 | 베이스라인 블록 전달: Sim/Playback은 Linux/Pi에서 20 ms, Windows 10 ms 주기 (`SimWorker.cpp:8-22`; `PlaybackWorker.cpp:9-21`) = 48k에서 960 샘플; Live 블록은 ALSA 구동 가변 크기 (`AudioWorker.cpp:71-73`, setBufferSize 미호출); 검출기는 ≤ 4096-샘플 슬라이스 소비 (`MainWindow.cpp:28`) ≈ 48/96/192k에서 85.3/42.7/21.3 ms; 링 버퍼 30 s (`SharedAudio.h:8`). 20 ms Pi 주기에서 0.8× 규칙 → p99 ≤ 16 ms/블록. | grounded |
| G3 | QAS-2 · missed-beat 관측성 | tg 라이브러리 기본값: auto_detect 1.5 s, sync_loss_misses 12, 이벤트 refractory 2.0 ms, sync tolerance 3% (`Timegrapher.cpp:240-248`) — 비트별 검출과 sync-loss가 라이브러리에서 관측 가능. | grounded |
| G4 | QAS-3 · ≥ 2 h (≥ 6 h) | 기준 계측기의 장기 구간: Trace/Vario 자동 integration 표가 "0–2 h → 2 s"로 시작 ([X1]:672); 측정 시간 최대 99:59:58 h ([X1]:674); Vario 장기 안정성 추적 최대 100 h ([TC]:243). ≥ 2 h = X1의 첫 장기 구간 경계. | anchored |
| G5 | QAS-3 · RSS ε / CPU 70·90% | 베이스라인 메모리는 Start 시 고정 할당: 30 s 링 버퍼 1회 할당 = 48/96/192k에서 5.76/11.52/23.04 MB (`SharedAudio.h:8`; `MainWindow.cpp:618-619`); 그래프 히스토리는 10 s 초과분 prune (`MainWindow.cpp:27,1050`) → 정상 상태에서 구조적 증가 없음이 기대됨; ε는 할당자/Qt 캐시 몫. CPU 70/90%: 출처 없음 (워커 스레드는 TimeCriticalPriority — `MainWindow.cpp:635`). | 메모리 anchored / CPU provisional |
| G6 | QAS-5 · SNR ≥ 14 dB | 클린 실측 베이스라인: WeiShi-mic 녹음 9개 = SNR 30–51 dB (1 ms envelope 방법; 최악 = `21600BPH_8215_InCase` 중앙 비트 33.4 dB / 약비트 30.4 dB) — [SNR]. Sim realistic 모드 ≈ 45 dB 피크비 (pcm 0.40 — `MainWindow.cpp:1383` / noise 0.0022 — `WatchSynthStream.cpp:147`; 노이즈 대역 700 Hz–18 kHz — `:119-120`); clean 설정 ≈ 58 dB (noise 0.0005 — `:83`). → 14 dB는 최악 클린 캡처보다 ≥ 16 dB 낮은 심한 열화 조건이며, 도달하려면 의도적 잡음 주입이 필요. 주의 — 정의 민감도: 전체-신호-RMS 지표로는 동일 최악 파일이 15.1 dB로 읽힘(같은 데이터에서 ≈ 18 dB 차이). 14 dB를 "샘플 최저치보다 1 dB 낮춘 값"으로 설명하지 말 것 — 그 프레이밍은 RMS 지표 기준이며, 합격선을 클린 플로어에 붙여 열화 마진을 0으로 만들고, 커플링 약화와 주변 잡음을 혼동함 ([SNR] §Definition Sensitivity 참조). | anchored (실측); 합격 기준으로서는 provisional |
| G7 | QAS-5 · 잡음 하 ±3 s/d | Witschi 등급 허용표: Chronometer −2…+6, Gent's −5…+15, Lady's −5…+25 s/d ([TC]:334-336). ±3 s/d는 가장 엄격한 등급 대역 반폭 이내로 잡음 유발 오차를 제한. | anchored |
| G8 | QAS-5/6/13 · ≥ 1,000비트 | 1,000비트 = 28,800/21,600/18,000 BPH에서 125/166.7/200 s ≈ 캡처 2.1–3.3분; 시험 녹음은 ~45 s당 229–366비트 — [SNR]. | feasible |
| G9 | QAS-5 · 감지율 ≥ 95% | 문서·코드 어디에도 근거 없음. 베이스라인은 연속 12회 누락 시에만 sync loss 선언 (`Timegrapher.cpp:248`). | provisional |
| G10 | QAS-6 · onset/peak 0.1 ms | 기준 계측기 beat error 스펙과 일치: X1 Resolution 0.1 ms / Accuracy ± 0.1 ms ([X1]:912); Draft의 0.6 ms "양호" 기준의 1/6; 베이스라인 표시·Sim 입력 모두 0.1 ms 단위 (`MainWindow.cpp:446`; `MainWindow.ui` Sim Beat Error). 48k 실현성: 검출기가 이미 서브샘플 보간 수행 (onset 선형 — `Detector.cpp:746-760`; peak 포물선 — `:267-274`). | grounded |
| G11 | QAS-13 · 일오차 ≤ ±1 s/d | X1 계측 정확도(± 0.1 s/d — [X1]:912)의 10×, 가장 엄격한 등급 대역(Chronometer −2…+6 s/d — [TC]:334-336)의 1/8 수준; 표시 단위 0.1 s/d (`MainWindow.cpp:436`; [X1] 0.1/0.01 선택). | anchored (provisional) |
| G12 | QAS-13 · 진폭 ≤ ±5° | 오차 전파: Amp = 3600λ/(π·n·t_AC) ([EQ]:270); worked example 230° @ t_AC = 9 ms ([EQ]:278-282) → \|dAmp/dt_AC\| = Amp/t_AC ≈ 25.6°/ms → QAS-6의 0.1 ms 예산 ≈ 2.6° → ±5° ≈ 2× 마진. 기준점: X1 진폭 정확도 ± 0.4° ([X1]:912); 표시 단위 1° (`MainWindow.cpp:441`). | derived (provisional) |
| G13 | QAS-13 · 비트오차 ≤ ±0.1 ms | X1 beat error Accuracy 스펙 ± 0.1 ms와 동일 ([X1]:912). | grounded |
| G14 | QAS-13 · Sim ground-truth 파라미터 | Sim UI 범위: Error Rate ±999 s/d step 1 (`MainWindow.ui:603-642`), Amplitude 100–360° 기본 300° (`:494-533`), Beat Error ±10 ms step 0.1 (`:552-581`), BPH 3600–43,200 기본 28,800 (`MainWindow.cpp:81-86,273`). Lift angle 기본 52° (`MainWindow.cpp:100`; [EQ]:262 "52° is common"; [X1] 범위 10–90°), UI 30–70°. 클린 검증은 Realistic OFF 필수 (기본값은 ON — `MainWindow.ui:582-602`; clean noise 0.0005 vs realistic 0.0022 — `WatchSynthStream.cpp:83,147`). | grounded |
| G15 | QAS-12 · 5 s / 10 s | 스트림 재오픈 후 베이스라인 재고착(re-lock) 경로: 검출기 warmup 200 ms (`Detector.cpp:142`) + BPH auto-detect 1.5 s (`Timegrapher.cpp:247`) + sync 획득(이벤트 ≥ 6–8개 ≈ 0.8–1.7 s) ≈ 2.5–3.5 s → 10 s ≈ 3× 마진. 주의: 베이스라인에는 재연결 처리가 아예 없음 — 장치 소실 시 워커가 종료될 뿐 (`AudioWorker.cpp:43-47`; 상태 핸들러는 로그만 — `:28-31`) → QAS-12는 신규 능력을 규정. 5 s 표시: 근거 없음. | 10 s derived (provisional) / 5 s provisional |
| G16 | QAS-15 · 경보 2 s·허용 대역 | 2 s = X1의 최소 integration time (Diagram integration 2–240 s — [X1]:666; 자동표 "0–2 h → 2 s" — [X1]:672); 베이스라인 averaging 옵션도 2 s부터 시작 (`MainWindow.cpp:88`). 비트오차: Draft 0.6 ms "good" vs [TC] 허용 0.0–0.5 ms / 결함 ≈ 3 ms ([TC]:283-285, 334-336). 진폭: 270°는 Witschi의 기준 진폭 (DVm @ 270° — [X1]:412); 건강 범위 260–310° ([TC]:135); 대역 양 끝값이 Sim 기본값과 일치 — clean 설정 270° (`WatchSynthStream.cpp:84`), UI 기본 300° (`MainWindow.ui:494-533`). | anchored |
| G17 | QAS-11 · 800×480 레이아웃 | 베이스라인 GUI는 1280×750로 고정 (geometry + maximumSize — `MainWindow.ui:5-18,888-896`), 800×480/fullscreen 처리 없음 → C-2 패널용 재레이아웃이 필수 작업. 패널 물리 크기: [SETUP]에 미기재(부재 확인) — 5″/8″ open question 유지. | 모순 기록됨 |
| G18 | C-4 / C-5 / C-6 | C-4: 베이스라인이 시작 시 AGC를 프로그램적으로 비활성화하고 양 OS에서 mic 캡처 볼륨을 50%로 설정 (`MainWindow.cpp:40-47` + `LinuxAudio`/`WindowsAudio` 구현). C-5: v10.5 확정 ([SETUP]:11, 97-98); 툴체인 Qt 6 (Qt 5 fallback), CMake ≥ 3.16, C++17 (`CMakeLists.txt`). C-6: 코드는 {48k, 96k, 192k, **384k**} 제공, 기본 48k (`MainWindow.cpp:1246, 99`); synth 허용 범위 44.1k–384k (`WatchSynthStream.cpp:12-13`); 시험 녹음은 48/96/192k에 걸침 ([SNR]). | grounded |
| G19 | QAS-14 · seek 렌더 500 ms | 직접 근거 없음; redraw 작업셋은 10 s 그래프 히스토리로 한정 (`MainWindow.cpp:27`). | provisional |

## QAS 우선순위

Milestone 1의 "요구사항 우선순위화" 요구에 따름. B = 비즈니스 중요도, R = 기술 리스크/난이도 (H/M/L).

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

### QAS-1 · Performance (Latency) — From Sound Input to Screen Display
> 타깃 플랫폼에서 측정하는 동안 마이크로 소리가 들어오면, 시스템은 입력 → 분석 → 표시 흐름으로 처리하여 화면에 표시하며, p99(99 백분위) 종단 지연 시간(소리 도착 → 화면 표시)이 ≤ 500 ms이다 (provisional — G1: 일반적인 28,800 BPH에서 약 4비트 주기이며 베이스라인의 구조적 표시 경로 ~70 ms의 7배 이상; 브리프는 지연 최소화·보고만 요구하고 수치를 정하지 않으므로 체감 실시간 표시 한계로 팀이 선정). 입력 rate 따라가기(블록 드롭·비트 누락 없음)는 QAS-2가 소유하며 본 측정의 전제 조건이다.

| 요소 | 내용 |
|------|------|
| 출처 | 마이크 / 시계 (외부) |
| 자극 | 마이크로 소리가 들어옴 |
| 대상 산출물 | 전체 입력 → 분석 → 표시 흐름 |
| 환경 | Raspberry Pi 5(8 GB, C-1)에서 Live 측정, 96,000 SPS 목표 레이트 — 48,000 SPS 최소 레이트에서도 충족(C-6) — GUI 활성, 연속 정상 부하 (브리프 경고: PC 성능은 Pi로 이전되지 않음) |
| 응답 | 처리하여 화면에 표시함 |
| 응답 척도 | p99 종단 지연(소리 도착 → 화면) ≤ 500 ms (provisional — G1; 28,800 BPH 기준 약 4비트 주기), 10분 연속 실행 동안 capture/processing/display 타임스탬프로 측정(Draft의 지연 보고 요구에 따름). 입력 따라가기(드롭 0·누락 0)는 QAS-2가 검증하는 전제 조건 |

### QAS-2 · Performance (Throughput) — Analysis Keep-Up and Compute Budget
> 타깃 플랫폼에서 측정하는 동안 설정된 샘플레이트 주기로 오디오 블록이 들어오면, 시스템은 backlog 없이 입력 rate를 유지하고 — 10분 연속 실행 동안 드롭된 오디오 블록 0개, 놓친 비트 0개, backlog 증가 추세 없음 — 그 수단으로서 각 블록의 분석을 블록 도착 간격의 80% 이내(p99)에 완료한다 (G2: 베이스라인의 Linux/Pi 블록 주기 20 ms 기준 = 16 ms).

| 요소 | 내용 |
|------|------|
| 출처 | 오디오 입력/획득 파이프라인 (설정된 샘플레이트 주기로 블록 전달) |
| 자극 | 분석할 오디오 블록이 들어옴 |
| 대상 산출물 | 분석 처리 단계 — t_block_handed_to_analysis부터 t_result_produced까지 계측 (비트 감지와 rate/amplitude/beat error 계산 포함; 캡처 버퍼링·화면 렌더링 제외) |
| 환경 | Raspberry Pi 5에서 Live 측정, 96,000 SPS 목표 — 48,000 SPS 최소에서도 검증; 192,000 SPS 스트레치는 측정만(게이트 아님) (C-6) |
| 응답 | 입력 rate를 유지함; 각 블록의 분석을 연산 예산 내에 완료함 |
| 응답 척도 | 각 게이트 레이트에서 10분 연속 실행 동안: 드롭된 오디오 블록 0개(입력 콜백 overrun 카운터); 기지(旣知) Sim/Playback 비트 스케줄 대비 놓친 비트 0개(놓친 비트 = 기대 비트에 대해 검출이 없는 경우; QAS-10 연계, tg 라이브러리의 비트별 이벤트·sync-loss 보고로 관측 가능 — G3); backlog(큐 깊이) 증가 추세 없음; 블록당 연산 시간 p99 ≤ 0.8 × 블록 도착 간격 (G2 — 베이스라인: Linux/Pi에서 Sim/Playback 20 ms 주기 → 예산 16 ms/블록; Live 블록은 ALSA 구동 가변 크기로 실측 도착 간격 대비 측정; 검출기는 ≤ 4096-샘플 슬라이스 소비) |

### QAS-3 · Availability (Resource-Leak Resilience) — No Degradation Over Long Runs
> Raspberry Pi 5(8 GB)에서 장기 세션으로 연속 측정하는 동안, 시스템은 시간이 지나도 열화 없이 정상 서비스를 계속 제공한다 — 메모리 누수 없음, 크래시 없음, 화면 멈춤 없음, 서멀 스로틀링에 의한 성능 저하 없음 — 연속 ≥ 2시간 실행 기준(Long-Term Performance Graph 용도는 ≥ 6시간; 지속시간은 [JYP] 리뷰 권고를 본문에 적용한 것 — G4: ≥ 2시간은 기준 계측기의 첫 장기 integration 구간 경계이며, Witschi Vario는 최대 100시간까지 안정성을 추적). 입력 rate 따라가기는 QAS-2가 검증하는 전제 조건이다.

| 요소 | 내용 |
|------|------|
| 출처 | 장시간 무인 측정을 시작하는 측정자 (예: Long-Term Performance 테스트, G07) |
| 자극 | 연속 측정이 멈추지 않고 장시간 지속됨 |
| 대상 산출물 | 전체 시스템, Raspberry Pi 메모리/프로세스 상태 |
| 환경 | Raspberry Pi 5(8 GB), 96,000 SPS에서 연속 ≥ 2시간(장기 그래프 용도 ≥ 6시간, [JYP] 적용; G4); 입력 따라가기는 QAS-2 전제 |
| 응답 | 열화 없이 정상 서비스를 계속 제공: 자원 고갈 없음, 크래시 없음, 멈춤 없음, 서멀 스로틀링 없음 |
| 응답 척도 | 전체 실행 동안: 모든 30분 구간에서 RSS 선형 회귀 기울기 ≤ 0 + ε (지속적 단조 증가 없음; ε = 측정 노이즈 허용치, provisional — G5: 베이스라인 메모리는 Start 시 고정 할당(30 s 링 버퍼 + 10 s 그래프 prune)이라 구조적 증가 없음이 기대됨); 크래시 0회; 화면 멈춤 0회(멈춤 = 화면 업데이트 ≥ 2초 미갱신, render-heartbeat 로그로 검출); CPU 평균 ≤ 70%, 피크 ≤ 90% (provisional — G5), Pi governor가 보고하는 서멀 스로틀링 이벤트 0회 |

### QAS-4 · Correctness (Display Consistency) — Consistent Values Across Displays
> 평소처럼 측정하는 동안 하나의 측정 결과가 산출되어 여러 그래프와 숫자로 전달될 때, 한 화면 프레임에 함께 렌더링되는 모든 표시는 그 단일 측정 결과에서 파생되어 상호 일치한다 — 표시 간 값 불일치 0회. (스냅샷 ID 등 태그된 공유 스냅샷은 권고 전술이며 필수 메커니즘이 아니다.) [SJ] Sequence 기능에서는 X/D summary가 position별 표시와 동일한 captured result set을 사용한다.

| 요소 | 내용 |
|------|------|
| 출처 | 분석/계산 단계 (내부) |
| 자극 | 하나의 측정 결과가 산출되어 여러 표시(그래프/숫자)로 전달됨 |
| 대상 산출물 | 수치 표시값과 여러 그래프 표시 |
| 환경 | 평소처럼 측정 중 (검증은 Sim/Playback) |
| 응답 | 한 프레임에 함께 표시되는 모든 값·그래프가 하나의 측정 결과에서 파생되어 상호 일치함; [SJ] 표시된 position별 result set으로부터 X/D sequence summary를 산출함 |
| 응답 척도 | 기지 기준 입력의 10분 Sim/Playback 실행(QAS-10 연계) 동안, 샘플링된 전체 프레임에서: 동시에 표시되는 모든 표시 쌍이 동일한 측정 결과에서 계산된 값을 표시(표시 반올림 이내) — 불일치 0회. 각 표시는 소스 결과 식별자를 노출(trace 로그 또는 디버그 오버레이)하여 검사 가능; [SJ] sequence summary와 표시된 position별 값 사이의 X/D source mismatch 0건 |

### QAS-5 · Accuracy & Availability (Graceful Degradation) — Under Noisy or Weak Signals
> 주변 잡음이 섞이거나 약한 신호가 들어오는 열악한 환경에서, 시스템(잡음 제거/비트 감지)은 필요한 소리를 보존하면서 잡음을 걸러내고, 신호 품질이 임계 이하일 때는 잘못된 값 대신 "신호 약함"을 표시한다. 보정된 잡음을 합성 Sim/Playback 비트 신호에 주입하여 검증한다 — 정답(ground truth)은 생성기의 기지 비트 스케줄과 프로그래밍된 rate (기준 장비 판독값은 클린 조건 sanity check 용도로만 사용; 주입 잡음 하에서는 정답이 될 수 없음): 최소 1,000비트 표본 기준(G8: 캡처 약 2.1–3.3분), SNR ≥ 14 dB (provisional — G6: 클린 WeiShi-mic 시험 녹음 실측 30–51 dB이므로 14 dB는 최악 클린 캡처보다 ≥ 16 dB 낮은 열화 조건이며 의도적 잡음 주입이 필요)에서 비트 감지율 ≥ 95% (provisional — G9: 도메인 근거 없음), 일오차 ≤ ±3 s/d (provisional — G7: 가장 엄격한 Witschi 등급인 Chronometer −2…+6 s/d 이내); 임계 미만 신호는 "신호 약함"만 표시하고 실행 전체에서 잘못된 값 출력 0회. [SJ] Invalid 또는 low-confidence position result는 X/D sequence 계산에서 제외된다 — 포함/제외 규칙 자체는 FR-04-06이 소유.

| 요소 | 내용 |
|------|------|
| 출처 | 주변 잡음 / 약한 신호(외부) |
| 자극 | 잡음이 섞이거나 신호가 약하게 들어옴 |
| 대상 산출물 | 잡음 제거 / 비트 감지 부분과 신호 품질 표시 |
| 환경 | 열악한 작업 환경 — Sim/Playback 입력에 보정된 잡음을 통제·일정하게 유지된 SNR로 주입하여 재현. SNR 정의: 비트당 임펄스 피크(A/C 이벤트, 윈도우 적용) 대 분석 대역 내 주변 잡음 RMS (분석 대역 = 베이스라인 HPF 기본값 200 Hz 이상 — `Timegrapher.cpp:243`; 참고: Sim 노이즈 대역 700 Hz–18 kHz); 측정 방법은 `SNR-Analysis-WeishiMic.md` 기준 |
| 응답 | (Accuracy) 잡음 하에서 비트를 감지하고 rate를 허용오차 내로 계산; (Availability) 품질 임계 미만이면 우아하게 성능 저하 — 어떤 값도 아닌 "신호 약함"을 표시; [SJ] invalid/low-confidence position result를 X/D에서 제외(규칙은 FR-04-06) |
| 응답 척도 | 생성기의 기지 비트 스케줄·프로그래밍된 rate 대비, 최소 1,000비트 기준: SNR ≥ 14 dB (provisional — G6)에서 비트 감지율 ≥ 95% (provisional — G9), 일오차 ≤ ±3 s/d (provisional — G7); 임계 미만: "신호 약함"만 표시, 실행 전체에서 잘못된 값 0회 (잘못된 값 = "신호 약함" 플래그 없이 표시된 판독값 중 정답 대비 오차가 위 허용오차를 초과하는 것); [SJ] invalid/low-confidence 값의 X/D 계산 포함 0건 |

### QAS-6 · Accuracy (Measurement Correctness) — Pinpointing Beats Precisely
> 평소처럼 측정하는 동안 새 비트(틱/톡)가 입력 스트림에 도착할 때, 시스템(비트 감지/시간 계산)은 그 비트의 시작점(onset)과 피크 위치를 정확히 찾아내고 모든 처리 단계를 관통하여(획득 → 필터링 → 이벤트 검출 → 계산, Draft 기준) 시간 정밀도를 보존하며, onset/peak 검출 위치 오차 ≤ 0.1 ms — 48k/96k/192k SPS에서 각각 4.8 / 9.6 / 19.2 샘플에 해당하므로 최소 레이트 48,000 SPS에서는 서브샘플 보간이 필요. 0.1 ms 정답은 실제 하드웨어로 얻을 수 없으므로, Sim mode가 생성하는 onset/peak 위치가 알려진 합성 신호로 검증한다(FR-05-05 / FR-12-16; 기준점은 FR-08-06과 Glossary; 검증 하네스는 QAS-10 연계). 0.1 ms의 근거: 0.6 ms "양호" beat error 임계(Draft)의 약 1/6로, 임상적으로 유의한 beat error 차이를 해상 가능; 기준 계측기의 beat error 해상도/정확도(Witschi X1: 0.1 ms / ± 0.1 ms)와도 일치하며, 베이스라인 검출기는 이미 서브샘플 보간으로 이벤트를 위치시킨다 (G10).

| 요소 | 내용 |
|------|------|
| 출처 | 시계 비트 (외부 입력 스트림) |
| 자극 | 새 비트(틱/톡)가 입력 스트림에 도착함 |
| 대상 산출물 | 비트 감지 / 시간 계산 부분 |
| 환경 | 평소처럼 측정 중; 96,000 SPS 목표와 48,000 SPS 최소 레이트에서 검증 (C-6) |
| 응답 | 도착한 비트의 onset과 peak 위치를 정확히 찾아내고, 모든 처리 단계(획득, 필터링, 검출, 계산)를 관통하여 시간 정밀도를 보존함 |
| 응답 척도 | 위치가 알려진 합성 비트 ≥ 1,000개(Sim mode, FR-05-05 / FR-12-16; onset/peak는 FR-08-06 기준)에 대해 onset/peak 검출 위치 최대 오차 ≤ 0.1 ms, 96,000 SPS(= 9.6 샘플)와 48,000 SPS(= 4.8 샘플, 서브샘플 보간 필요 — 베이스라인 검출기에 이미 존재)에서 검증; 실제 하드웨어 불요(QAS-10 연계); 근거 G10 |

### QAS-7 · Modifiability (Extensibility) — Adding a New Measurement/Filter/Graph
> 일정이 촉박한 개발 상황에서 개발자가 새 그래프, 새 필터 단계, 또는 새 파생 측정값을 추가하려고 할 때, 기존 코드를 크게 뜯어고치지 않고 점진적으로 추가할 수 있으며 — 종류별 변경 예산과 회귀 0건을 만족한다. (신규 단위의 격리 테스트 가능성은 QAS-10이 규율.)

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 |
| 자극 | 새 그래프, 새 필터 단계, 또는 새 파생 측정값을 추가하려고 함 |
| 대상 산출물 | 시스템(측정·표시 기능을 담은 코드베이스) |
| 환경 | 개발 중, 일정이 촉박함 |
| 응답 | 기존 코드를 크게 뜯어고치지 않고 점진적으로 추가함; 격리 테스트는 QAS-10 |
| 응답 척도 | 새 그래프/표시 탭: 기존 모듈 변경 ≤ 1개(등록/배선부만), 분석/획득 코드 변경 0건. 새 필터 단계(F0–F3 참조, G12): 파이프라인 등록 지점 변경 ≤ 1개, 하류 필터·획득부 무변경. 새 파생 측정값: 계산 레지스트리 변경 ≤ 1개, 획득/표시 프레임워크 변경 0건. 전 종류 공통: 회귀 0건 — 기존 기능 회귀 테스트 셋(QAS-10 연계, 하드웨어 불요)이 변경 전후 모두 통과. (pass/fail 척도가 아닌 참고용 계획 목표: 그래프 1종당 약 5인일 — 설계 + 구현 + 단위 테스트 기준.) |

### QAS-8 · Modifiability (Modularity) — Fixing in One Place
> 유지보수 중 개발자가 한 가지 책임을 변경할 때, 그 변경은 해당 책임의 모듈 안에 갇힌다: 사전 정의된 대표 단일 책임 변경 시나리오 집합에 대해, 각 변경은 ≤ 1개 모듈(자기 테스트 제외)만 건드리고 다른 책임으로의 변경 전파(ripple)가 0건이다. 횡단 변경(공유 타입, 파이프라인 관통 필드)은 명시적으로 범위 밖이다. ([JYP] 리뷰 적용: 파일이 아닌 모듈 단위 측정; 대표 시나리오 집합으로 한정; 횡단 변경 제외.)

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 |
| 자극 | 단일 책임 하나를 변경해야 함 (예: 한 표시의 포맷, 한 계산식, 한 경보 규칙) |
| 대상 산출물 | 변경 대상 책임을 소유한 모듈 |
| 환경 | 유지보수 중 |
| 응답 | 한 가지 책임 변경이 다른 책임에 영향을 주지 않음 |
| 응답 척도 | 사전 정의된 대표 단일 책임 변경 시나리오 ≥ 3건에 대해: 각 변경이 ≤ 1개 모듈만 수정(자기 테스트 제외; 모듈은 정의 절 기준); ripple 0건 — 책임 경계 밖의 어떤 모듈도 소스/테스트 수정을 요구하지 않음. 횡단 변경(공유 타입, 파이프라인 관통 필드)은 범위 밖([JYP] 적용). |

### QAS-9 · Modifiability (Portability) — Running on Other Devices/OSes
> 새 사운드 장치를 지원하거나 새 OS로 포팅할 때(필수 플랫폼 쌍은 C-3이 고정), 플랫폼 특화 관심사는 추상 계층 뒤에 격리된다: 새 사운드 장치 추가는 어댑터 모듈 1개만 건드리고 도메인 코드 변경 0줄; 새 OS 포팅은 플랫폼 추상 계층(GUI/Qt, 스레딩, 파일시스템, 빌드)에 국한되고 도메인 코드 변경 0줄. (설계 시점 관심사; 런타임 장치 분리/복구는 QAS-12.)

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 |
| 자극 | 새 사운드 장치를 지원하거나, C-3 쌍 외의 새 OS로 포팅함 |
| 대상 산출물 | 장치 케이스: 오디오 입력 어댑터 계층. OS 케이스: 플랫폼 추상 계층(GUI/Qt, 스레딩, 파일 경로, 빌드 툴체인) |
| 환경 | 개발/유지보수 시점, 기존 코드베이스 대상; 필수 플랫폼 = Windows 11 x64와 Raspberry Pi OS ARM64 (C-3); Qt 베이스라인은 C-5 |
| 응답 | 추상 계층을 통해 새 OS / 사운드 장치를 지원함 |
| 응답 척도 | 새 사운드 장치: 어댑터 모듈 1개 변경/추가, 도메인 코드 변경 0줄(도메인 코드는 정의 절 기준). 새 OS: 변경이 플랫폼 추상 계층에 국한, 도메인 코드 변경 0줄; 회귀 테스트 셋(QAS-10)이 C-3의 두 플랫폼 모두에서 통과 |

### QAS-10 · Testability — Testing Parts in Isolation
> 테스트 중 개발자/테스터가 사운드 분석 단계나 입력 부분만 따로 테스트하려고 할 때, 각 핵심 분석 단계와 사운드 입력 부분은 실제 하드웨어 없이 가짜 입력을 주입하여 독립적으로 확인할 수 있다. Sim mode는 onset/peak 위치와 비트 스케줄이 선험적으로 알려진 합성 비트 신호를 생성하여(설정된 BPH / Error Rate / Beat Error에서 유도) QAS-2/5/6/13의 ground truth가 된다. [SJ] X/D sequence summary는 동일 Sim/Playback input으로 재현 가능하고 included/excluded position result로 역추적 가능하다.

| 요소 | 내용 |
|------|------|
| 출처 | 개발자 / 테스터 |
| 자극 | 사운드 분석 단계 또는 입력 부분만 따로 테스트하려고 함 |
| 대상 산출물 | 핵심 분석 단계(정의 절 기준), 사운드 입력 부분 |
| 환경 | 테스트 중, 오디오 하드웨어가 없는 호스트 |
| 응답 | 실제 하드웨어 없이 가짜 입력을 주입하여 부분별로 독립 확인함; onset/peak 위치와 비트 스케줄이 선험적으로 알려진 합성 비트 신호를 생성함(QAS-2/5/6/13의 ground truth); [SJ] 반복 가능한 X/D sequence result를 산출하고 계산에 사용된 included/excluded position result를 제시함 |
| 응답 척도 | 열거된 핵심 분석 단계의 line coverage ≥ 80% (팀 선정 목표); 모든 핵심 단계와 사운드 입력 소스가 자기 인터페이스 경유 Sim/Playback 주입으로 구동 가능 — 계약(contract) 테스트가 오디오 장치 없는 호스트에서 통과; Sim 합성 신호는 onset/peak 샘플 위치를 선험적으로 보유(FR-05-05 / FR-12-16); [SJ] 표준 포지션 셋(CH/CB/6H/9H/3H/12H, FR-01-03 / FR-04-04)을 커버하는 동일 Sim/Playback 데이터셋 3회 반복 실행 시 X/D 값 동일; X/D 역추적: 모든 (X, D) summary에 대해 포함된/제외된(invalid/low-confidence) position result를 시스템 출력에서 열거 가능 — 전체 summary의 100%에서 검증 |

### QAS-11 · Usability — Reading and Operating on the Low-Resolution Touchscreen
> Raspberry Pi 5의 800×480 터치스크린에서 평소처럼 사용하는 동안 사용자가 측정값을 읽고 모드를 전환할 때, 시스템은 핵심 측정값을 스크롤/확대 없이 가독성 있게 표시하고 주요 기능을 터치만으로 조작할 수 있게 한다. 물리 크기(mm)가 규범 기준이며, 픽셀 환산치는 패널 물리 크기 확정 전까지 참고용이다(미해결 질문: Draft가 헤더에서는 "8 Inch", 본문에서는 "5-inch"로 자기모순 — C-1 참조). [SJ] Position 및 sequence review 중 사용자는 active/selected position과 X/D summary를 빠르게 식별할 수 있다. [JYP] 여기서 "터치로 조작"은 제공된 터치스크린 하드웨어(Draft Hardware 절)에서 파생한 가정이며 단일 탭/드래그 수준으로 한정함. 멀티터치 제스처(swipe·pinch-zoom)는 범위 밖; zoom·navigate는 버튼/슬라이더 등 탭 기반 컨트롤로 충족.

| 요소 | 내용 |
|------|------|
| 출처 | 사용자(시계공 / 측정자) |
| 자극 | 800×480 터치스크린에서 측정값을 읽고 모드를 전환함 |
| 대상 산출물 | GUI(스펙트로그램/스코프/수치 표시와 컨트롤) |
| 환경 | Raspberry Pi 5 + 800×480 터치 디스플레이, 평소 사용 중 (패널 물리 크기는 확정 필요 — Draft 헤더 8인치 vs 본문 5인치; C-1 참조). 참고: 베이스라인 GUI는 1280×750 고정으로 800×480 레이아웃이 없어 본 패널용 재레이아웃이 필수 작업 (G17) |
| 응답 | 핵심 측정값을 가독성 있게 표시하고 주요 기능을 터치만으로 조작 가능하게 함; [SJ] active/selected position과 X/D를 관련 측정값 근처에 표시함 |
| 응답 척도 | 주요 측정값(일오차·비트오차·진폭)을 스크롤/확대 없이 동시 표시; 주요 측정값 글리프 높이 ≥ 1.9 mm(기준 작업 거리 40 cm에서 약 16 arcmin), 대비 ≥ 4.5:1 (WCAG AA) — 기존 "폰트 ≥ 24 px"는 참고용 픽셀 수치로만 유지; 모든 주요 터치 타깃 물리 크기 ≥ 9 mm (픽셀 환산치는 참고용, 패널 크기 확정 후 재산출); 주요 모드 도달 ≤ 2 탭; [SJ] 대표 사용자 ≥ 3명이 sequence-review 화면에서 시작하는 시간 측정 과업에서, 시도의 ≥ 90%에서 active/selected position을 5초 이내, X/D를 10초 이내 식별; [JYP] 터치 = 단일 탭/드래그; 멀티터치 제스처는 요구·측정 대상 아님 |

### QAS-12 · Availability (Recoverability) — Audio Device Disconnect or Stream Error
> 평소처럼 측정하는 동안 오디오 입력 장치가 분리되거나, 장치가 연결된 상태에서 입력 스트림이 복구 가능한 오류(예: ALSA xrun)를 일으킬 때, 시스템은 크래시 없이 오류를 감지하고 사용자에게 알리며, 마지막 유효 판독값(stale 플래그 표시)과 기캡처 데이터를 보존하고, fault 해소(장치 재연결 또는 스트림 재오픈) 후 10초(provisional — G15: 베이스라인의 재고착 경로 ≈ 2.5–3.5초이므로 약 3× 마진; 단 베이스라인에는 재연결 처리가 없어 본 시나리오는 신규 능력을 규정) 이내에 수동 재시작 없이 측정을 자동 재개한다 — "장치 없음"/"입력 오류" 표시 5초(provisional — G15) 이내, 크래시 0회, 데이터 손상 0건.

| 요소 | 내용 |
|------|------|
| 출처 | 사운드 장치(외부) |
| 자극 | 측정 중 오디오 입력 장치가 분리되거나, 장치가 연결된 상태에서 입력 스트림이 복구 가능한 오류를 일으킴 |
| 대상 산출물 | 사운드 입력 부분 / 시스템 |
| 환경 | 평소처럼 측정 중 |
| 응답 | 크래시 없이 오류를 감지하고 사용자에게 알림; 마지막 유효 판독값을 stale 플래그와 함께 계속 표시하고 기캡처 데이터를 보존; fault 해소 시 자동 재개 |
| 응답 척도 | 활성 측정 중 unplug/replug ≥ 20회 + 주입 스트림 오류 ≥ 5회에 걸쳐 검증: 전 시행에서 크래시 0회; "장치 없음"/"입력 오류" 표시 ≤ 5초 (provisional — G15); fault 해소 후 자동 재개 ≤ 10초 (provisional — G15), 전 시행 충족; 정전 구간 동안 최근 유효 판독값이 stale 플래그와 함께 계속 표시됨; 기캡처 sequence/trace 데이터 손실 0건; 데이터 손상 0건 — 손상 = 복구 후 측정 레코드가 (a) fault 전후 오디오 샘플 혼입, (b) torn/부분 판독 버퍼 샘플 포함, (c) fault 경계에서 비단조 타임스탬프 중 하나에 해당하는 경우 |

### QAS-13 · Accuracy (Computed Values) — Rate, Amplitude, Beat Error vs Ground Truth
> 클린 조건에서 시스템이 기지 파라미터(BPH, Error Rate, Amplitude, Beat Error — Draft의 Simulation Parameters)로 생성된 Sim 신호를 설정된 lift angle과 함께 측정할 때, 표시되는 계산값이 주입된 정답과 일치한다: 최소 1,000비트 기준(G8) 일오차 ≤ ±1 s/d (provisional — G11: X1 계측 정확도 ±0.1 s/d의 10×), 진폭 오차 ≤ ±5° (provisional — G12: Equations worked example 기준 A→C 타이밍 오차 0.1 ms ≈ 230° 부근에서 2.6°이므로 ±5° ≈ 2× 마진; 설정된 lift angle 기준), 비트오차 오차 ≤ ±0.1 ms (X1 계측 정확도 스펙과 동일 — G13; QAS-6와 정합). 설정된 lift angle과 BPH가 계산에 실제로 반영됨을 입증 가능해야 한다(lift angle 변경 시 Equations 문서에 따라 계산 진폭이 변함). 본 시나리오는 기존에 미커버였던 클린 조건 정확도 공백 — 특히 어떤 시나리오도 한정하지 않던 amplitude — 을 해소한다.

| 요소 | 내용 |
|------|------|
| 출처 | 기지 파라미터를 가진 Sim 신호 생성기 (내부 ground truth) |
| 자극 | 프로그래밍된 rate/amplitude/beat error를 가진 Sim 신호에 대한 측정 실행 |
| 대상 산출물 | 계산 단계(rate, lift angle 포함 amplitude, beat error) |
| 환경 | 클린 조건(잡음 주입 없음), Sim mode에서 Realistic OFF (clean config — G14: 기본값이 ON이므로 해제 필요), 96,000 SPS |
| 응답 | 검출된 이벤트로부터 rate, amplitude, beat error를 계산하여 표시함 |
| 응답 척도 | 프로그래밍된 값 대비, 최소 1,000비트 기준: \|일오차\| ≤ 1 s/d (provisional — G11); \|진폭 오차\| ≤ 5° (provisional — G12, 설정 lift angle 기준 — 기본 52°, G14); \|비트오차 오차\| ≤ 0.1 ms (QAS-6 연계; G13); Sim 파라미터 범위는 G14; FR-04-05 / FR-06-01..04가 표시하는 값들을 커버 |

### QAS-14 · Usability (Session Continuity) — Pause, Seek, and View Switching Without Reset
> 평소처럼 측정하는 동안 사용자가 표시를 일시정지하거나, 캡처 데이터를 앞뒤로 탐색하거나, 그래프 탭/분석 뷰를 전환해도 세션과 기록 데이터는 보존된다: 세션 리셋 0회, 캡처 데이터 손실 0건, 일시정지 중에도 라이브 캡처는 백그라운드에서 계속되며, 라이브 뷰 복귀 시 일시정지 동안 캡처된 데이터가 손실되지 않는다. (브리프 추적: "all graphs can run continuously … without losing the recorded signal or forcing a reset"; FR-05-06/07, FR-08-03, FR-12-17/18.)

| 요소 | 내용 |
|------|------|
| 출처 | 사용자(시계공 / 측정자) |
| 자극 | 라이브 세션 중 일시정지 / 앞뒤 탐색 / 그래프 탭·모드 전환 |
| 대상 산출물 | GUI 세션 상태, 캡처 버퍼, 획득 파이프라인 |
| 환경 | 정상 인터랙티브 사용 중 (장치 fault 아님 — 그것은 QAS-12) |
| 응답 | 세션과 기록 데이터를 보존; 일시정지 중에도 캡처 지속; 요청된 구간을 렌더링 |
| 응답 척도 | 스크립트화된 인터랙션 실행(10분 라이브 세션 중 pause/seek/전환 ≥ 20회) 기준: 세션 리셋 0회; 캡처 데이터 손실 0건(전후 레코드 수/해시로 검증); 탐색/탭 뷰 렌더링은 선택 후 ≤ 500 ms (provisional — G19); 복귀 시 일시정지 구간 데이터 전체 존재 |

### QAS-15 · Usability (Alert Annunciation) — Fault and Out-of-Tolerance Conditions
> 평소처럼 측정하는 동안 판독값이 정의된 허용 대역을 벗어나면 — 진폭이 270°–300° 밖(FR-02-09), 시계가 느리게 가는 중(FR-02-05), trace 선 간격이 허용 범위 초과(FR-06-11), trace 기울기 ≥ 45°(FR-06-13) — GUI는 해당 조건이 계산된 후 2초(provisional — G16: X1의 최소 integration time 2초와 동일하며, 베이스라인 averaging 옵션도 2초부터 시작) 이내에 관련 판독값 근처에 명확한 경보를 표시하여, 시계 문제인지 소프트웨어 문제인지 사용자가 추측하게 두지 않는다(Draft, Usability 절).

| 요소 | 내용 |
|------|------|
| 출처 | 허용 대역을 벗어나는 분석 결과 (내부) |
| 자극 | 계산된 판독값이 허용 범위 초과 또는 fault 조건에 진입함 |
| 대상 산출물 | 경보/표시 로직과 GUI 인디케이터 |
| 환경 | 평소처럼 측정 중; 검증 시 조건은 Sim 파라미터로 유발 |
| 응답 | 관련 판독값 근처에 명확하고 귀속 가능한 경보를 표시함 |
| 응답 척도 | 각 조건(진폭 270–300° 이탈, 느리게 감, 간격 초과, 기울기 ≥ 45°)을 유발하는 Sim 테스트 셋 기준: 조건 계산 후 경보 표시 ≤ 2초 (provisional — G16); 경보 누락 0건; 허용 대역 내에서 거짓 경보 0건; FR-02-05 / FR-02-09 / FR-06-11 / FR-06-13 추적; 대역 기준점은 G16 (270° = Witschi 기준 진폭; Sim 기본값 270°/300°; [TC] 비트오차 허용 0.0–0.5 ms) |

## Scope Notes — 보류된 드라이버

부재가 누락이 아닌 문서화된 결정임을 기록 (Milestone 1 actionability 기준):

- **AI / TinyML 온디바이스 PoC** (킥오프 System Requirement, "where feasible"): time-box 일정 때문에 Milestone 1 드라이버 범위 밖; Milestone 2에서 Integrability 관심사로 재검토(분석 파이프라인이 signal-quality / bad-data-rejection 분류기를 수용 가능해야 함).
- **Security, Deployability**: Milestone 1 범위 밖 — 네트워크 노출이 없는 로컬 작업대 계측기; 배포는 C-5의 Qt 빌드 플로.
- **시작/모드 전환 시간** (Start → 첫 유효 판독; Live↔Playback↔Sim 전환 지연): 식별된 공백; Planned Experiments 후 한계값 설정 예정. 전환 시 세션 보존은 QAS-14가 이미 커버.
- **인터랙티브 타이밍 포인트/구간 선택 품질** (FR 그룹 G08/G10 — Escapement Analyzer / Waveform Comparison): FR로 실현; 전용 품질 척도(선택 → 구간 판독 반영 ≤ N ms, 표시 구간 = 마커 위치 ± 허용오차)는 보류.

## Constraints

| ID | 제약사항 |
|----|----------|
| C-1 | 시스템은 터치스크린이 연결된 Raspberry Pi 5(8 GB RAM, 128 GB microSD)에서 실행되어야 한다. 미해결 질문: Draft가 패널을 헤더에서는 "8 Inch", 본문에서는 "5-inch"로 기술 — 확정된 물리 크기를 여기에 기록하며, 이는 QAS-11의 픽셀 환산치를 결정한다. |
| C-2 | 시스템은 Raspberry Pi 5에 연결된 저해상도(800×480) 디스플레이에서 GUI를 올바르게 렌더링하고 동작해야 한다 (사용성 척도: QAS-11). |
| C-3 | 시스템은 Windows 11 (x64) PC와 Raspberry Pi OS(Debian 기반, 64-bit/ARM64)를 실행하는 Raspberry Pi 5 모두에서 실행되어야 한다. (추가 플랫폼의 변경 비용: QAS-9.) |
| C-4 | (운영 전제 조건) 호스트 오디오 장치는 측정 전 OS 오디오 믹서(Raspberry Pi OS의 AlsaMixer)에서 Auto Gain Control이 비활성화되어 있음을 설정·확인해야 하며, 시스템은 AGC가 꺼진 입력을 전제로 동작한다. 베이스라인은 이미 시작 시 AGC를 프로그램적으로 비활성화하고 양 OS에서 mic 캡처 볼륨을 50%로 설정한다 (G18). |
| C-5 | 시스템은 제공된 Qt 기반 TimeGrapher 베이스라인(TimeGrapher_v10.5_Student, Qt Creator 프로젝트)을 확장하여 구현해야 하며, 처음부터 새로 구축하지 않는다. (v10.5 확정 — G18; 툴체인: Qt 6 + Qt 5 fallback, CMake ≥ 3.16, C++17.) |
| C-6 | 시스템은 정의된 샘플레이트 운영점 — 48,000 SPS(최소 허용), 96,000 SPS(목표), 192,000 SPS(스트레치) — 을 지원해야 한다. (베이스라인 코드는 48k/96k/192k에 더해 384k도 제공, 기본 48k; WeiShi 시험 녹음은 48/96/192k에 걸침 — G18.) |
