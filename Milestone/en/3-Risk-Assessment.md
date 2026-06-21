# Risk Assessment

> Risks threatening the project, grouped by area and rated by probability and impact (High/Medium/Low).

**Contents** — [Terminology](#terminology) · [Risk Summary](#risk-summary) · [A. Real-Time Performance](#a-real-time-performance-rpi) · [B. Signal Processing](#b-signal-processing--measurement-trustworthiness) · [C. Architecture](#c-architecture--extensibility) · [D. Hardware/Platform](#d-hardware--platform) · [E. Usability/UI](#e-usability--ui-1280800) · [F. Project/Process](#f-project--process) · [G. Other](#g-other--uncategorized)

## Terminology

The terms used in this document are defined in the consolidated [Glossary](7-Glossary.md) — see **Platform & Engineering Terms** (and the Domain / Quality-Attribute sections).

## Risk Summary

> Type: **T** = Technical, **NT** = Non-technical
>
> **P** = Probability, **I** = Impact (**H** = High, M = Medium, L = Low)
>
> 🔴 = risk has a planned experiment (see [Planned Experiments](4-Planned-Experiments.md))
>
> **Status** — Resolved / In progress / Accepted

Risk ID | Status | Risk Title | Type | QAS | P | I
--------|--------|-----------|------|-----|---|---
[R-01](#a-real-time-performance-rpi) 🔴 | Resolved | RPi5 fails to keep up with high sample rates (96k/192k) and loses sound data | T | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) | **L** | **H**
[R-02](#a-real-time-performance-rpi) 🔴 | Resolved | Rendering four filters + multiple graphs at once makes the screen stutter | T | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display)<br>[QAS-6](2-Architectural-Drivers.md#qas-6--usability--reading-and-operating-on-the-touchscreen) | M | **H**
[R-03](#a-real-time-performance-rpi) 🔴 | Resolved | Analysis + display exceed the beat-period budget (83.3 ms @ 43200 BPH) — backlog, stale display, block drop, missed beats | T | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) | M | **H**
[R-04](#a-real-time-performance-rpi) 🔴 | Resolved | Long continuous runs (24h+) leak memory and degrade or crash | T | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) | **L** | M
[R-05](#a-real-time-performance-rpi) 🔴 | Resolved | Closed: .NET (C#) + Avalonia UI selected after RPi5 latency/rendering checks | T | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) | L | L
[R-06](#b-signal-processing--measurement-trustworthiness) 🔴 | In progress | A/C event positions not found to 0.1 ms — rate, beat error, amplitude all contaminated | T | [QAS-1](2-Architectural-Drivers.md#qas-1--accuracy--from-acoustic-event-detection-to-computed-watch-metrics)<br>[QAS-3](2-Architectural-Drivers.md#qas-3)<br>[QAS-4](2-Architectural-Drivers.md#qas-4--consistency--consistent-values-across-displays) | **H** | **H**
[R-07](#b-signal-processing--measurement-trustworthiness) | In progress | Noisy/weak signals produce misleading values instead of a graceful "signal weak" | T | [QAS-3](2-Architectural-Drivers.md#qas-3) | M | **H**
[R-08](#c-architecture--extensibility) | Resolved | No up-front filter/marker extension design — late-stage cost soars | T | [QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--adding-a-new-measurementfiltergraph) | M | M
[R-09](#d-hardware--platform) | Resolved | AGC left on or poor microphone coupling distorts the signal | T | [QAS-3](2-Architectural-Drivers.md#qas-3) | M | **H**
[R-10](#d-hardware--platform) | Resolved | Platform differences (WASAPI/ALSA) between Windows dev and RPi demo surface late | T | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) | M | M
[R-11](#d-hardware--platform) | Resolved | Supporting three sample rates (48/96/192k) adds timing complexity | T | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) | M | M
[R-12](#e-usability--ui-1280800) | Resolved | Small screen can't legibly hold summary bar + graphs + scope strip | T | [QAS-6](2-Architectural-Drivers.md#qas-6--usability--reading-and-operating-on-the-touchscreen) | M | M
[R-13](#e-usability--ui-1280800) | Accepted | Touch accuracy or recognition may be poor | T | [QAS-6](2-Architectural-Drivers.md#qas-6--usability--reading-and-operating-on-the-touchscreen) | L | L
[R-14](#f-project--process) | Resolved | Everything (12 features + AI) can't fit in 3 weeks — prioritization failure drops essentials | NT | QAS-ALL | M | **H**
[R-15](#f-project--process) | Resolved | Understanding the baseline code takes time and delays the start | NT | [QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--adding-a-new-measurementfiltergraph) | L | M
[R-16](#f-project--process) | Resolved | Qt/C++·DSP·RPi learning curve shakes implementation quality | NT | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display)<br>[QAS-3](2-Architectural-Drivers.md#qas-3) | L | M
[R-17](#f-project--process) 🔴 | In progress | Attempting the AI/TinyML feature raises on-device uncertainty | T | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display)<br>[QAS-3](2-Architectural-Drivers.md#qas-3) | M | M
[R-18](#f-project--process) | Accepted | Accepting GenAI-generated code unverified lets in plausible-but-wrong code | NT | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display)<br>[QAS-3](2-Architectural-Drivers.md#qas-3)<br>[QAS-4](2-Architectural-Drivers.md#qas-4--consistency--consistent-values-across-displays) | M | M
[R-19](#f-project--process) | Accepted | Only one test RPi5 — real-use verification doesn't fit the schedule | NT | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) | **H** | **H**
[R-20](#g-other--uncategorized) | Accepted | Communication — meaning may be lost between stakeholders when conversing in English | NT | - | L | L
[R-21](#g-other--uncategorized) | Accepted | Insufficient test environment — one device, no test room, no unit tests; regressions may slip through | NT | - | L | L
[R-22](#g-other--uncategorized) | Accepted | Long-run verification difficulty — items like 24-hour continuous runs are hard to actually verify | NT | - | L | L
[R-23](#g-other--uncategorized) | Accepted | Growing storage — long recordings make files large | T | - | L | L
[R-24](#g-other--uncategorized) | Accepted | RPi5 debugging difficulty — hard to inspect state or debug | T | - | L | L
[R-25](#g-other--uncategorized) | Accepted | Uncertain data structures — audio buffer and measurement-data storage structures are undecided | T | - | L | L
[R-26](#g-other--uncategorized) | Accepted | Storage-speed bottleneck — SD-card writes may be slower than recording generation | T | - | L | L

## A. Real-Time Performance (RPi)

- **🔴 R-01 — The RPi5 fails to keep up with high sample rates (96k/192k) in real time and loses sound data (block drop / missed beat)**
  - **Status**: Resolved
  - **Risk evidence**: pdf (p.25 Real Time Performance), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display), [C-1](2-Architectural-Drivers.md#design-constraints)
  - **Probability / Impact**: Low / High
  - **Grading rationale**
    - P-Low: [EXP-02](4-Planned-Experiments.md#exp-02-rpi5-real-time-sample-rate-ceiling) measured 43200 BPH @ 192 kHz running at about 41% of the worst-case E2E budget on the RPi5 with zero block drop / missed beats. High-rate real-time processing is confirmed by measurement.
    - I-High: lost audio data breaks the core measurement outright (the impact, if it occurs, remains high).
  - **Result**: Fixed at 48 kHz base / 192 kHz top. [EXP-02](4-Planned-Experiments.md#exp-02-rpi5-real-time-sample-rate-ceiling) measured the tightest case (43200 BPH @ 192 kHz) at ~41% of the worst-case budget with drop/miss = 0, promoting 192k to a fully supported rate. Conditional resolution: direct 96 kHz measurement, CPU/RAM headroom, and image tabs remain to be checked.

- **🔴 R-02 — Rendering four filters (F0→F3) plus multiple graphs at once makes the screen stutter (<20 FPS · UI freeze)**
  - **Status**: Resolved
  - **Risk evidence**: [FR-12-01](2-Architectural-Drivers.md#g12--scope-function-with-multiple-filter-views), [FR-12-04](2-Architectural-Drivers.md#g12--scope-function-with-multiple-filter-views), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display), [QAS-6](2-Architectural-Drivers.md#qas-6--usability--reading-and-operating-on-the-touchscreen)
  - **Probability / Impact**: Medium / High
  - **Grading rationale**
    - P-Medium: stutter depends on rendering load and is reducible by culling inactive views.
    - I-High: a frozen/stuttering UI directly violates the top driver [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display).
  - **Result**: [EXP-03](4-Planned-Experiments.md#exp-03-gui-real-time-rendering-design-pattern) removed the UI bottleneck with a Pipe-and-Filter flow + concurrency tactics (dedicated analysis thread · Latest-Wins · fixed buffer pool). Under 28800 BPH load the chain converges within the render budget (33/100 ms). Latest-Wins frame drop is acceptable for a real-time monitor, and long-term history is preserved via `DecimatingSeries` → closed with the structure landed in source.

- **🔴 R-03 — Analysis + display exceed the beat-period budget (83.3 ms @ 43200 BPH), causing backlog, stale display, block drop, and missed beats**
  - **Status**: Resolved
  - **Risk evidence**: [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) — one beat period = 3600 s ÷ BPH (43200 BPH: 83.3 ms · 21600 BPH: 166.7 ms)
  - **Probability / Impact**: Medium / High
  - **Grading rationale**
    - P-Medium: processing/rendering load grows with sample rate, BPH, active tab, and graph count, so the budget may be exceeded.
    - I-High: sustained overrun builds backlog and stale display; at worst, block drop / missed beats contaminate the measurements.
  - **Result**: Addressed with separated analysis/UI threads + Latest-Wins rendering and bounded buffers/queues. [EXP-02](4-Planned-Experiments.md#exp-02-rpi5-real-time-sample-rate-ceiling) measured 21600 BPH @ 48 kHz and 43200 BPH @ 192 kHz across Live/Playback/Simulation, both passing within budget on RPi5 and Windows (drop=0, miss=0), so backlog/stale risk is controlled. Re-measure on the same criteria when a new computation, filter, graph, or AI Feature is added.

- **🔴 R-04 — Long continuous runs (24h+) leak memory and degrade or crash**
  - **Status**: Resolved
  - **Risk evidence**: [FR-07-10](2-Architectural-Drivers.md#g07--long-term-performance-graph), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display)
  - **Probability / Impact**: Low / Medium
  - **Grading rationale**
    - P-Low: [EXP-05](4-Planned-Experiments.md#exp-05-long-run-stability-24h) 24h+ continuous-run measurement showed RSS flat at about 406 MB (change -1.6 MB across the run) with no late-run CPU/latency degradation, confirming it is not at a leak-suspect level.
    - I-Medium: hits only the optional 24h+ feature, is gradual, and is restart-recoverable with values staying correct.
  - **Result**: [EXP-05](4-Planned-Experiments.md#exp-05-long-run-stability-24h) ran 24h+ continuously with RSS flat at ~406 MB (change -1.6 MB), CPU steady at ~1.4 cores, and no late-run degradation → **Pass**. 24h stability is met with no extra caps/aggregation. Re-measure with the same procedure (0.5 s RSS/CPU logging) when new load is added.

- **🔴 R-05 — Closed: .NET (C#) + Avalonia UI selected after RPi5 latency/rendering checks**
  - **Status**: Resolved
  - **Risk evidence**: [QAS-2 latency result](../../TestResult/result_latency.md) passed all Simulation and WAV replay conditions: worst-case E2E latency stayed inside the beat-period budget, dropped audio samples = 0, and missed beat detections = 0. The [rendering backend result](../../TestResult/result_renderer.md) also did not reproduce the reported Avalonia-on-RPi5 slowdown: GLX/EGL GPU rendering reached about 60 FPS and SW rendering was slower.
  - **Probability / Impact**: Low / Low
  - **Grading rationale**
    - P-Low: the current RPi5 app workload met the latency budget and the Avalonia GPU path did not show the reported slowdown.
    - I-Low: no remaining architecture risk is identified for choosing Avalonia; the default GPU-first rendering path is acceptable.
  - **Result**: Latency ([EXP-02](4-Planned-Experiments.md#exp-02-rpi5-real-time-sample-rate-ceiling) · [result_latency.md](../../TestResult/result_latency.md)) passed within budget (drop/miss = 0) and rendering ([EXP-01](4-Planned-Experiments.md#exp-01-avalonia-rendering-backend-on-the-rpi5) · [result_renderer.md](../../TestResult/result_renderer.md)) did not reproduce the reported GPU slowdown (GLX/EGL ~60 FPS) → **closed as no remaining risk**, fixing implementation on .NET (C#) + Avalonia UI (GPU-first). Re-test only if the deployment or rendering workload changes substantially.

## B. Signal Processing / Measurement Trustworthiness

- **🔴 R-06 — If A/C event positions can't be found to 0.1 ms, rate, beat error, and amplitude are all contaminated**
  - **Status**: In progress
  - **Risk evidence**: [FR-08-04…06](2-Architectural-Drivers.md#g08--escapement-analyzer-and-marker-line-display), [FR-06-01…04](2-Architectural-Drivers.md#g06--beat-error-display-and-diagnostic-trace), [QAS-1](2-Architectural-Drivers.md#qas-1--accuracy--from-acoustic-event-detection-to-computed-watch-metrics), [QAS-3](2-Architectural-Drivers.md#qas-3), [QAS-4](2-Architectural-Drivers.md#qas-4--consistency--consistent-values-across-displays)
  - **Probability / Impact**: High / High
  - **Grading rationale**
    - P-High: sub-0.1 ms A/C event detection on real noisy signals is genuinely hard.
    - I-High: it contaminates all three core metrics (rate, beat error, amplitude).
  - **Mitigation**: Early-verify the detection algorithm on a synthetic-signal bench (ground truth known) — confirmed first on the Realistic-off simulation in [EXP-06](4-Planned-Experiments.md#exp-06-measurement-accuracy), with a follow-up comparison against the commercial Weishi Timegrapher
  - **Current status**: A/C detection (sub-sample interpolation — parabolic for the C-peak, linear for the A-onset), beat error, and amplitude are implemented in `Detector.cs` and `WatchMetrics.cs`, and synthetic-signal tests (`SyntheticDetectorTests`, `AdverseScenarios`) confirm first-pass behavior (EXP-06 Realistic-off). An explicit 0.1 ms tolerance check and the commercial Weishi comparison remain outstanding.
  - **Comment**: Confirm the current logic works; improve if needed

- **R-07 — Noisy or weak signals may produce misleading values instead of a graceful "signal weak" response**
  - **Status**: In progress
  - **Risk evidence**: [QAS-3](2-Architectural-Drivers.md#qas-3)
  - **Probability / Impact**: Medium / High
  - **Grading rationale**
    - P-Medium: weak/noisy-signal handling is uncertain but testable per noise level.
    - I-High: showing wrong values instead of "signal weak" actively misleads the user.
  - **Mitigation**: Filtering and signal-quality judgment; isolate bad data behind a "signal weak" indication
  - **Current status**: Noise-floor estimation, SNR gating, and validity flags (`Detector.cs`, `WatchMetrics.cs`) isolate invalid values as `----`, but an explicit "signal weak" state display and user-guidance UI are not yet implemented (planned as an AI Feature).
  - **Comment**: Test per noise level; improve the logic if needed

## C. Architecture / Extensibility

- **R-08 — Without up-front design of the filter/marker extension structure (e.g., adding F4), late-stage cost soars**
  - **Status**: Resolved
  - **Risk evidence**: [FR-12-01](2-Architectural-Drivers.md#g12--scope-function-with-multiple-filter-views), [QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--adding-a-new-measurementfiltergraph)
  - **Probability / Impact**: Medium / Medium
  - **Grading rationale**
    - P-Medium: without up-front design the extension structure can be missed.
    - I-Medium: it raises later cost but is contained by refactoring and breaks no function.
  - **Result**: The measurement filters are fixed at four (F0–F3) in scope (`ScopeFilters.cs`, `MultiFilterScopeLanes.cs`, FR-12 met), and there is no scenario to add a new filter such as F4, so the late-stage cost of an unplanned extension does not arise → closed. If extension genuinely becomes needed later, revisit pre-designing a Filter interface (strategy) and a plug-in registration scheme.

## D. Hardware / Platform

- **R-09 — If AGC stays on or the microphone couples poorly, the signal distorts and every measurement collapses**
  - **Status**: Resolved
  - **Risk evidence**: pdf (p.29 Raspberry Pi OS — Auto Gain Control), [QAS-3](2-Architectural-Drivers.md#qas-3), [C-4](2-Architectural-Drivers.md#design-constraints)
  - **Probability / Impact**: Medium / High
  - **Grading rationale**
    - P-Medium: AGC defaults on and is an easily-forgotten manual step, yet fully preventable by checklist.
    - I-High: a distorted signal collapses every measurement.
  - **Result**: Since the app cannot turn AGC off directly (NAudio limitation, `SystemAudioControl.cs`), the user manual (`manual/controls.html` — "Microphone setup (AGC & coupling)") now states AGC-off and coupling verification as an environment checklist, closing the risk. It applies to the Live input only (Playback/Simulation unaffected; Linux applies no AGC by default) and is preventable as a pre-measurement check.

- **R-10 — Developing on Windows, demoing on RPi — platform differences (WASAPI/ALSA audio backends) surface late**
  - **Status**: Resolved
  - **Risk evidence**: pdf (p.29 System Software), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display), [C-3](2-Architectural-Drivers.md#design-constraints)
  - **Probability / Impact**: Medium / Medium
  - **Grading rationale**
    - P-Medium: WASAPI/ALSA divergence is likely but caught early by running the RPi in parallel.
    - I-Medium: it causes rework, not a permanent failure.
  - **Result**: Isolated audio I/O behind a port-adapter and verified the RPi in parallel from the start (EXP-02/05 were run on the RPi5), preventing late surfacing. Any divergence is contained as adapter-only rework, so the risk is closed as low.

- **R-11 — Supporting three sample rates (48/96/192k) adds timing complexity**
  - **Status**: Resolved
  - **Risk evidence**: pdf (p.25 Real Time Performance), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display)
  - **Probability / Impact**: Medium / Medium
  - **Grading rationale**
    - P-Medium: three sample rates add timing complexity where subtle errors are plausible.
    - I-Medium: the issue is confined to normalization handled in the adapter.
  - **Result**: Fixed the supported range at 48k base / 192k top ([EXP-02](4-Planned-Experiments.md#exp-02-rpi5-real-time-sample-rate-ceiling)) and confined complexity to the input stage via adapter normalization. With 192k passing within budget, the "complexity breaks real-time" failure path is closed.

## E. Usability / UI (1280×800)

- **R-12 — The small screen can't legibly hold the summary bar + multiple graphs + scope strip (letters ≥ 2.9 mm · touch ≥ 9 mm)**
  - **Status**: Resolved
  - **Risk evidence**: pdf (p.27 8 Inch Touchscreen for Raspberry Pi), [QAS-6](2-Architectural-Drivers.md#qas-6--usability--reading-and-operating-on-the-touchscreen), [C-2](2-Architectural-Drivers.md#design-constraints)
  - **Probability / Impact**: Medium / Medium
  - **Grading rationale**
    - P-Medium: fitting all panels legibly on the small screen is tight.
    - I-Medium: it affects only readability, is mitigable by layout, and loses no data.
  - **Result**: Spread information via a key-readings-first layout + tab-based split (≤ 2-tap navigation) and verified the legibility criteria (letters ≥ 2.9 mm · touch ≥ 9 mm) with size-adjustment tests. As a display problem that loses no data, it is closed by the layout decision.

- **R-13 — Touch accuracy or recognition may be poor**
  - **Status**: Accepted
  - **Risk evidence**: [QAS-6](2-Architectural-Drivers.md#qas-6--usability--reading-and-operating-on-the-touchscreen)
  - **Probability / Impact**: Low / Low
  - **Grading rationale**
    - P-Low: touch is largely OS-handled and generally reliable.
    - I-Low: at worst a minor operability annoyance, easily worked around.
  - **Result**: Touch is largely OS-handled and generally reliable, and at worst it is a minor operability annoyance, so no separate response is needed. If controllable at app level, experiment for optimal values; if defined at OS level, proceed as is.

## F. Project / Process

- **R-14 — Everything (12 features + AI) can't fit in 3 weeks — failing to prioritize drops the essentials**
  - **Status**: Resolved
  - **Risk evidence**: pdf (p.5 Objective — "feasible, well-architected subset"), QAS-ALL
  - **Probability / Impact**: Medium / High
  - **Grading rationale**
    - P-Medium: scope overrun is real but manageable by freezing priorities.
    - I-High: dropping essential features would gut the product.
  - **Result**: Scoped to a "feasible subset" by freezing FR priorities and splitting AI off as optional (isolated via R-17/EXP-04), decoupling the critical path from schedule pressure. Controlled as a process risk managed by planning well and dropping what must be dropped.

- **R-15 — Understanding the provided baseline code (TimeGrapher_v10.4) takes time and delays the start**
  - **Status**: Resolved
  - **Risk evidence**: pdf (p.29 GUI Code), [QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--adding-a-new-measurementfiltergraph)
  - **Probability / Impact**: Low / Medium
  - **Grading rationale**
    - P-Low: AI-assisted code reading lowers the chance of getting stuck.
    - I-Medium: a slow start delays but does not break the project.
  - **Result**: Scheduled code-reading and a module map as a week-1 task and accelerated it with AI assistance. With the .NET reimplementation delivered, the "can't start due to comprehension delay" scenario no longer holds, so it is closed.

- **R-16 — The Qt/C++·DSP·RPi learning curve shakes implementation quality**
  - **Status**: Resolved
  - **Risk evidence**: pdf (p.29 Qt and Qt Creator), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display), [QAS-3](2-Architectural-Drivers.md#qas-3)
  - **Probability / Impact**: Low / Medium
  - **Grading rationale**
    - P-Low: AI assistance and pairing ease the learning curve.
    - I-Medium: quality wobble affects implementation broadly but not fatally.
  - **Result**: Front-loaded learning in the risky areas (rendering, real-time, concurrency) via early technical experiments (EXP-01~03/05), eased by AI and pairing. With the core challenges already validated and implemented, the path by which the learning curve shakes quality is eliminated.

- **🔴 R-17 — Attempting the AI/TinyML feature raises on-device uncertainty**
  - **Status**: In progress
  - **Risk evidence**: pdf (p.12 AI Feature), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display), [QAS-3](2-Architectural-Drivers.md#qas-3)
  - **Probability / Impact**: Medium / Medium
  - **Grading rationale**
    - P-Medium: on-device AI uncertainty is real if the feature is attempted.
    - I-Medium: it is optional scope with a rule-based fallback.
  - **Mitigation**: Separate as optional scope; rule-based fallback if it falls short
  - **Current status**: The TinyML socket (`IBeatEventGate`) and the rule-based fallback (`PllMatchGate`) are implemented and injectable, but no ONNX/TFLite model or inference exists yet. [EXP-04](4-Planned-Experiments.md#exp-04-on-device-tinyml-inference-feasibility) is in progress (adoption undecided).
  - **Comment**: Windows first, then assess operability on the RPi5 before adopting

- **R-18 — Accepting GenAI-generated code unverified lets in plausible-but-wrong code (esp. DSP / concurrency / real-time)**
  - **Status**: Accepted
  - **Risk evidence**: pdf (p.30 Project Deliverables), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display), [QAS-3](2-Architectural-Drivers.md#qas-3), [QAS-4](2-Architectural-Drivers.md#qas-4--consistency--consistent-values-across-displays)
  - **Probability / Impact**: Medium / Medium
  - **Grading rationale**
    - P-Medium: plausible-but-wrong GenAI code is common in DSP/concurrency.
    - I-Medium: caught by mandatory verification before it ships.
  - **Result**: The mentor recommends using GenAI, and mandatory verification (unit tests, synthetic-signal bench + code review) blocks bad code before it ships while the whole team understands the core algorithms, so no extra response is needed.

- **R-19 — Only one test RPi5 — real-use verification doesn't fit the schedule**
  - **Status**: Accepted
  - **Risk evidence**: pdf (p.26 System Hardware — Raspberry Pi), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display)
  - **Probability / Impact**: High / High
  - **Grading rationale**
    - P-High: one shared RPi5 makes a scheduling clash near-certain.
    - I-High: missing real-device verification undermines every RPi-dependent claim.
  - **Result**: Most verification is designed to run Simulation/Playback-based (no hardware required), minimizing RPi5 dependence, and the real device is scheduled only for must-have items such as performance measurement, so the single-device constraint needs no extra response. An additional RPi5 unit has also been obtained, allowing two devices to run in parallel and further reducing scheduling contention.

## G. Other / Uncategorized

- **R-20 — Communication** — meaning may be lost between stakeholders when conversing in English
  - **Probability / Impact**: Low / Low
- **R-21 — Insufficient test environment** — one device, no test room, no unit tests → regressions may slip through logic changes
  - **Probability / Impact**: Low / Low
- **R-22 — Long-run verification difficulty** — items like 24-hour continuous runs are hard to actually verify and assess
  - **Probability / Impact**: Low / Low
- **R-23 — Growing storage** — long recordings make files large
  - **Probability / Impact**: Low / Low
- **R-24 — RPi5 debugging difficulty** — hard to inspect state or debug → leaving log messages is experimentally possible
  - **Probability / Impact**: Low / Low
- **R-25 — Uncertain data structures** — audio buffer and measurement-data storage structures are undecided
  - **Probability / Impact**: Low / Low
- **R-26 — Storage-speed bottleneck** — SD-card writes may be slower than recording generation → check SD specs + real recording test
  - **Probability / Impact**: Low / Low
