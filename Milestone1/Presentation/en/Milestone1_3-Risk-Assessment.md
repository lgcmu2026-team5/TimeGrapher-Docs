# Risk Assessment

> Risks threatening the project, grouped by area and rated by probability and impact (High/Medium/Low).

**Contents** — [Terminology](#terminology) · [Risk Summary](#risk-summary) · [A. Real-Time Performance](#a-real-time-performance-rpi) · [B. Signal Processing](#b-signal-processing--measurement-trustworthiness) · [C. Architecture](#c-architecture--extensibility) · [D. Hardware/Platform](#d-hardware--platform) · [E. Usability/UI](#e-usability--ui-1280800) · [F. Project/Process](#f-project--process) · [G. Other](#g-other--uncategorized)

## Terminology

The terms used in this document are defined in the consolidated [Glossary](Milestone1_6-Glossary.md) — see **Platform & Engineering Terms** (and the Domain / Quality-Attribute sections).

## Risk Summary

> Type: **T** = Technical, **NT** = Non-technical
>
> **P** = Probability, **I** = Impact (**H** = High, M = Medium, L = Low)

Risk ID | Risk Title | Type | QAS | P | I
--------|-----------|------|-----|---|---
[R-01](#a-real-time-performance-rpi) | RPi5 fails to keep up with high sample rates (96k/192k) and loses sound data | T | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display) | **H** | **H**
[R-02](#a-real-time-performance-rpi) | Rendering four filters + multiple graphs at once makes the screen stutter | T | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display)<br>[QAS-5](Milestone1_2-Architectural-Drivers.md#qas-5--usability--reading-and-operating-on-the-touchscreen) | M | **H**
[R-03](#a-real-time-performance-rpi) | Sound-to-screen 0.5 s (p99 ≤ 500 ms) target is missed | T | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display) | M | **H**
[R-04](#a-real-time-performance-rpi) | Long continuous runs (24h+) leak memory and degrade or crash | T | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display) | M | M
[R-05](#a-real-time-performance-rpi) | Avalonia GPU-accelerated rendering on RPi5 slower than SW rendering, stuttering real-time graphs | T | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display) | M | **H**
[R-06](#b-signal-processing--measurement-trustworthiness) | A/C event positions not found to 0.1 ms — rate, beat error, amplitude all contaminated | T | [QAS-2](Milestone1_2-Architectural-Drivers.md#qas-2--availability-graceful-degradation--under-noisy-or-weak-signals)<br>[QAS-3](Milestone1_2-Architectural-Drivers.md#qas-3--consistency--consistent-values-across-displays) | **H** | **H**
[R-07](#b-signal-processing--measurement-trustworthiness) | Noisy/weak signals produce misleading values instead of a graceful "signal weak" | T | [QAS-2](Milestone1_2-Architectural-Drivers.md#qas-2--availability-graceful-degradation--under-noisy-or-weak-signals) | M | **H**
[R-08](#c-architecture--extensibility) | No up-front filter/marker extension design — late-stage cost soars | T | [QAS-4](Milestone1_2-Architectural-Drivers.md#qas-4--modifiability-extensibility--adding-a-new-measurementfiltergraph) | M | M
[R-09](#d-hardware--platform) | AGC left on or poor microphone coupling distorts the signal | T | [QAS-2](Milestone1_2-Architectural-Drivers.md#qas-2--availability-graceful-degradation--under-noisy-or-weak-signals) | M | **H**
[R-10](#d-hardware--platform) | Platform differences (WASAPI/ALSA) between Windows dev and RPi demo surface late | T | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display) | M | M
[R-11](#d-hardware--platform) | Supporting three sample rates (48/96/192k) adds timing complexity | T | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display) | M | M
[R-12](#e-usability--ui-1280800) | Small screen can't legibly hold summary bar + graphs + scope strip | T | [QAS-5](Milestone1_2-Architectural-Drivers.md#qas-5--usability--reading-and-operating-on-the-touchscreen) | M | M
[R-13](#e-usability--ui-1280800) | Touch accuracy or recognition may be poor | T | [QAS-5](Milestone1_2-Architectural-Drivers.md#qas-5--usability--reading-and-operating-on-the-touchscreen) | L | L
[R-14](#f-project--process) | Everything (12 features + AI) can't fit in 3 weeks — prioritization failure drops essentials | NT | QAS-ALL | M | **H**
[R-15](#f-project--process) | Understanding the baseline code takes time and delays the start | NT | [QAS-4](Milestone1_2-Architectural-Drivers.md#qas-4--modifiability-extensibility--adding-a-new-measurementfiltergraph) | L | M
[R-16](#f-project--process) | Qt/C++·DSP·RPi learning curve shakes implementation quality | NT | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display)<br>[QAS-2](Milestone1_2-Architectural-Drivers.md#qas-2--availability-graceful-degradation--under-noisy-or-weak-signals) | L | M
[R-17](#f-project--process) | Attempting the AI/TinyML feature raises on-device uncertainty | T | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display)<br>[QAS-2](Milestone1_2-Architectural-Drivers.md#qas-2--availability-graceful-degradation--under-noisy-or-weak-signals) | M | M
[R-18](#f-project--process) | Accepting GenAI-generated code unverified lets in plausible-but-wrong code | NT | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display)<br>[QAS-2](Milestone1_2-Architectural-Drivers.md#qas-2--availability-graceful-degradation--under-noisy-or-weak-signals)<br>[QAS-3](Milestone1_2-Architectural-Drivers.md#qas-3--consistency--consistent-values-across-displays) | M | M
[R-19](#f-project--process) | Only one test Pi5 — real-use verification doesn't fit the schedule | NT | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display) | **H** | **H**
[R-20](#g-other--uncategorized) | Communication — meaning may be lost between stakeholders when conversing in English | NT | - | L | L
[R-21](#g-other--uncategorized) | Insufficient test environment — one device, no test room, no unit tests; regressions may slip through | NT | - | L | L
[R-22](#g-other--uncategorized) | Long-run verification difficulty — items like 24-hour continuous runs are hard to actually verify | NT | - | L | L
[R-23](#g-other--uncategorized) | Growing storage — long recordings make files large | T | - | L | L
[R-24](#g-other--uncategorized) | RPi5 debugging difficulty — hard to inspect state or debug | T | - | L | L
[R-25](#g-other--uncategorized) | Uncertain data structures — audio buffer and measurement-data storage structures are undecided | T | - | L | L
[R-26](#g-other--uncategorized) | Storage-speed bottleneck — SD-card writes may be slower than recording generation | T | - | L | L

## A. Real-Time Performance (RPi)

- **R-01 — The RPi5 fails to keep up with high sample rates (96k/192k) in real time and loses sound data (block drop / missed beat)**
  - **Evidence**: pdf (p.25 Real Time Performance), [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display), [C-1](Milestone1_2-Architectural-Drivers.md#design-constraints)
  - **Probability / Impact**: High / High
  - **Grading rationale**
    - P-High: 96k/192k real-time load pushes the RPi5 to its hardware limit, so hitting it is likely.
    - I-High: lost audio data breaks the core measurement outright.
  - **Mitigation**: Week-1 spike to measure the RPi's processing limit, then fix the sample-rate target (192k demoted to stretch)
  - **Tradeoff point**: the sample rate trades measurement precision (more samples per 0.1 ms) against Performance (this risk)
  - **Comment**: Use the week-1 spike result to set the final sample-rate target

- **R-02 — Rendering four filters (F0→F3) plus multiple graphs at once makes the screen stutter (<20 FPS · UI freeze)**
  - **Evidence**: [FR-12-01](Milestone1_2-Architectural-Drivers.md#g12--scope-function-with-multiple-filter-views), [FR-12-04](Milestone1_2-Architectural-Drivers.md#g12--scope-function-with-multiple-filter-views), [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display), [QAS-5](Milestone1_2-Architectural-Drivers.md#qas-5--usability--reading-and-operating-on-the-touchscreen)
  - **Probability / Impact**: Medium / High
  - **Grading rationale**
    - P-Medium: stutter depends on rendering load and is reducible by culling inactive views.
    - I-High: a frozen/stuttering UI directly violates the top driver [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display).
  - **Mitigation**: Reuse a shared input buffer, stop rendering inactive views, measure an FPS budget
  - **Tradeoff point**: showing 4 views at once trades Usability ([QAS-5](Milestone1_2-Architectural-Drivers.md#qas-5--usability--reading-and-operating-on-the-touchscreen)) against Performance
  - **Comment**: Decide 4 simultaneous views vs one-at-a-time after the performance check

- **R-03 — The sound-to-screen 0.5 s (p99 ≤ 500 ms) target is missed**
  - **Evidence**: [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display)
  - **Probability / Impact**: Medium / High
  - **Grading rationale**
    - P-Medium: the 500 ms budget has headroom but the RPi may exceed it under load.
    - I-High: missing it fails the [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display) pass/fail gate.
  - **Mitigation**: Instrument capture/processing/display latency per stage; monitor backlog
  - **Comment**: For the worst case, optimize resources/processes or migrate to reduced features

- **R-04 — Long continuous runs (24h+) leak memory and degrade or crash**
  - **Evidence**: [FR-07-10](Milestone1_2-Architectural-Drivers.md#g07--long-term-performance-graph), [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display)
  - **Probability / Impact**: Medium / Medium
  - **Grading rationale**
    - P-Medium: leaks are plausible but only accumulate over long runs.
    - I-Medium: hits only the optional 24h+ feature, is gradual, and is restart-recoverable with values staying correct.
  - **Mitigation**: Monitor the long-term RSS trend; design buffer caps and aggregation
  - **Comment**: First verify memory leaks in the current code (experiment)

- **R-05 — With the Avalonia framework, a bug may make GPU-accelerated rendering on the RPi5 slower than SW rendering, causing real-time graph (Rate/Scope) updates to stutter**
  - **Evidence**: Multiple reports of GPU-acceleration slowdowns on RPi/embedded in Avalonia GitHub — `#18807, #18942, #19288, #18127`. pdf (p.25 Real Time Performance), [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display)
  - **Probability / Impact**: Medium / High
  - **Grading rationale**
    - P-Medium: GPU-accel slowdowns are widely reported but causes vary, so our workload may be unaffected.
    - I-High: stuttering real-time graphs violate [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display) (a one-line SW-render switch fully mitigates).
  - **Mitigation**: Week-1 spike to A/B-measure rendering backends (GLX/EGL/Software) on a real RPi5, then fix the backend. If the accelerated path is slow, switch to Software rendering (a one-line setting, no feature loss)
  - **Tradeoff point**: the rendering backend trades UI frame stability against CPU usage (Software rendering competes with the audio-analysis threads for CPU)
  - **Comment**: Similar reports are widespread but the causes vary (app-side bugs, resolution, driver path), so measurement on our workload is needed. Decide keep/change of the rendering-backend default from the week-1 spike (Planned Experiments, Experiment 1)

## B. Signal Processing / Measurement Trustworthiness

- **R-06 — If A/C event positions can't be found to 0.1 ms, rate, beat error, and amplitude are all contaminated**
  - **Evidence**: [FR-08-04…06](Milestone1_2-Architectural-Drivers.md#g08--escapement-analyzer-and-marker-line-display), [FR-06-01…04](Milestone1_2-Architectural-Drivers.md#g06--beat-error-display-and-diagnostic-trace), [QAS-2](Milestone1_2-Architectural-Drivers.md#qas-2--availability-graceful-degradation--under-noisy-or-weak-signals), [QAS-3](Milestone1_2-Architectural-Drivers.md#qas-3--consistency--consistent-values-across-displays)
  - **Probability / Impact**: High / High
  - **Grading rationale**
    - P-High: sub-0.1 ms A/C event detection on real noisy signals is genuinely hard.
    - I-High: it contaminates all three core metrics (rate, beat error, amplitude).
  - **Mitigation**: Early-verify the detection algorithm on a synthetic-signal bench (ground truth known)
  - **Comment**: Confirm the current logic works; improve if needed

- **R-07 — Noisy or weak signals may produce misleading values instead of a graceful "signal weak" response**
  - **Evidence**: [QAS-2](Milestone1_2-Architectural-Drivers.md#qas-2--availability-graceful-degradation--under-noisy-or-weak-signals)
  - **Probability / Impact**: Medium / High
  - **Grading rationale**
    - P-Medium: weak/noisy-signal handling is uncertain but testable per noise level.
    - I-High: showing wrong values instead of "signal weak" actively misleads the user.
  - **Mitigation**: Filtering and signal-quality judgment; isolate bad data behind a "signal weak" indication
  - **Comment**: Test per noise level; improve the logic if needed

## C. Architecture / Extensibility

- **R-08 — Without up-front design of the filter/marker extension structure (e.g., adding F4), late-stage cost soars**
  - **Evidence**: [FR-12-01](Milestone1_2-Architectural-Drivers.md#g12--scope-function-with-multiple-filter-views), [QAS-4](Milestone1_2-Architectural-Drivers.md#qas-4--modifiability-extensibility--adding-a-new-measurementfiltergraph)
  - **Probability / Impact**: Medium / Medium
  - **Grading rationale**
    - P-Medium: without up-front design the extension structure can be missed.
    - I-Medium: it raises later cost but is contained by refactoring and breaks no function.
  - **Mitigation**: Pre-design a Filter interface (strategy) and a plug-in registration scheme
  - **Comment**: Better modularization should cover it

## D. Hardware / Platform

- **R-09 — If AGC stays on or the microphone couples poorly, the signal distorts and every measurement collapses**
  - **Evidence**: pdf (p.29 Raspberry Pi OS — Auto Gain Control), [QAS-2](Milestone1_2-Architectural-Drivers.md#qas-2--availability-graceful-degradation--under-noisy-or-weak-signals), [C-4](Milestone1_2-Architectural-Drivers.md#design-constraints)
  - **Probability / Impact**: Medium / High
  - **Grading rationale**
    - P-Medium: AGC defaults on and is an easily-forgotten manual step, yet fully preventable by checklist.
    - I-High: a distorted signal collapses every measurement.
  - **Mitigation**: From day one, make AGC-off and coupling verification an environment checklist
  - **Comment**: Must be stated in the user guide

- **R-10 — Developing on Windows, demoing on RPi — platform differences (WASAPI/ALSA audio backends) surface late**
  - **Evidence**: pdf (p.29 System Software), [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display), [C-3](Milestone1_2-Architectural-Drivers.md#design-constraints)
  - **Probability / Impact**: Medium / Medium
  - **Grading rationale**
    - P-Medium: WASAPI/ALSA divergence is likely but caught early by running the RPi in parallel.
    - I-Medium: it causes rework, not a permanent failure.
  - **Mitigation**: Isolate audio I/O behind a port-adapter; verify early and regularly on the RPi
  - **Comment**: The RPi runs in parallel throughout the project, so risk is low

- **R-11 — Supporting three sample rates (48/96/192k) adds timing complexity**
  - **Evidence**: pdf (p.25 Real Time Performance), [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display)
  - **Probability / Impact**: Medium / Medium
  - **Grading rationale**
    - P-Medium: three sample rates add timing complexity where subtle errors are plausible.
    - I-Medium: the issue is confined to normalization handled in the adapter.
  - **Mitigation**: State the supported sample-rate range; normalize in the adapter
  - **Comment**: State the feasible spec (microphone spec, etc.)

## E. Usability / UI (1280×800)

- **R-12 — The small screen can't legibly hold the summary bar + multiple graphs + scope strip (letters ≥ 2.9 mm · touch ≥ 9 mm)**
  - **Evidence**: pdf (p.27 8 Inch Touchscreen for Raspberry Pi), [QAS-5](Milestone1_2-Architectural-Drivers.md#qas-5--usability--reading-and-operating-on-the-touchscreen), [C-2](Milestone1_2-Architectural-Drivers.md#design-constraints)
  - **Probability / Impact**: Medium / Medium
  - **Grading rationale**
    - P-Medium: fitting all panels legibly on the small screen is tight.
    - I-Medium: it affects only readability, is mitigable by layout, and loses no data.
  - **Mitigation**: Key-readings-first layout, tab-based split, ≤ 2-tap navigation
  - **Comment**: Run size-adjustment tests

- **R-13 — Touch accuracy or recognition may be poor**
  - **Evidence**: [QAS-5](Milestone1_2-Architectural-Drivers.md#qas-5--usability--reading-and-operating-on-the-touchscreen)
  - **Probability / Impact**: Low / Low
  - **Grading rationale**
    - P-Low: touch is largely OS-handled and generally reliable.
    - I-Low: at worst a minor operability annoyance, easily worked around.
  - **Mitigation**: Experimentally check touch sensitivity and touch-area recognition if possible
  - **Comment**: If controllable at app level, experiment for optimal values; if defined at OS level, proceed as is

## F. Project / Process

- **R-14 — Everything (12 features + AI) can't fit in 3 weeks — failing to prioritize drops the essentials**
  - **Evidence**: pdf (p.5 Objective — "feasible, well-architected subset"), QAS-ALL
  - **Probability / Impact**: Medium / High
  - **Grading rationale**
    - P-Medium: scope overrun is real but manageable by freezing priorities.
    - I-High: dropping essential features would gut the product.
  - **Mitigation**: Freeze FR priorities, split AI off as optional, critical path first
  - **Comment**: Plan well and drop what must be dropped

- **R-15 — Understanding the provided baseline code (TimeGrapher_v10.4) takes time and delays the start**
  - **Evidence**: pdf (p.29 GUI Code), [QAS-4](Milestone1_2-Architectural-Drivers.md#qas-4--modifiability-extensibility--adding-a-new-measurementfiltergraph)
  - **Probability / Impact**: Low / Medium
  - **Grading rationale**
    - P-Low: AI-assisted code reading lowers the chance of getting stuck.
    - I-Medium: a slow start delays but does not break the project.
  - **Mitigation**: Make code-reading sessions and a module map a week-1 task
  - **Comment**: Risk lowered by using AI

- **R-16 — The Qt/C++·DSP·RPi learning curve shakes implementation quality**
  - **Evidence**: pdf (p.29 Qt and Qt Creator), [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display), [QAS-2](Milestone1_2-Architectural-Drivers.md#qas-2--availability-graceful-degradation--under-noisy-or-weak-signals)
  - **Probability / Impact**: Low / Medium
  - **Grading rationale**
    - P-Low: AI assistance and pairing ease the learning curve.
    - I-Medium: quality wobble affects implementation broadly but not fatally.
  - **Mitigation**: Role split and pairing; early learning via small spikes
  - **Comment**: Risk lowered by using AI

- **R-17 — Attempting the AI/TinyML feature raises on-device uncertainty**
  - **Evidence**: pdf (p.12 AI Feature), [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display), [QAS-2](Milestone1_2-Architectural-Drivers.md#qas-2--availability-graceful-degradation--under-noisy-or-weak-signals)
  - **Probability / Impact**: Medium / Medium
  - **Grading rationale**
    - P-Medium: on-device AI uncertainty is real if the feature is attempted.
    - I-Medium: it is optional scope with a rule-based fallback.
  - **Mitigation**: Separate as optional scope; rule-based fallback if it falls short
  - **Comment**: Windows first, then assess operability on the RPi 5 before adopting

- **R-18 — Accepting GenAI-generated code unverified lets in plausible-but-wrong code (esp. DSP / concurrency / real-time)**
  - **Evidence**: pdf (p.30 Project Deliverables), [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display), [QAS-2](Milestone1_2-Architectural-Drivers.md#qas-2--availability-graceful-degradation--under-noisy-or-weak-signals), [QAS-3](Milestone1_2-Architectural-Drivers.md#qas-3--consistency--consistent-values-across-displays)
  - **Probability / Impact**: Medium / Medium
  - **Grading rationale**
    - P-Medium: plausible-but-wrong GenAI code is common in DSP/concurrency.
    - I-Medium: caught by mandatory verification before it ships.
  - **Mitigation**: Mandatory adversarial verification of generated code (unit tests, synthetic-signal bench); understand the core algorithms; confirm GenAI usage policy with mentors
  - **Comment**: See mitigation (code review, whole team understands the algorithms)

- **R-19 — Only one test Pi5 — real-use verification doesn't fit the schedule**
  - **Evidence**: pdf (p.26 System Hardware — Raspberry Pi), [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display)
  - **Probability / Impact**: High / High
  - **Grading rationale**
    - P-High: one shared Pi5 makes a scheduling clash near-certain.
    - I-High: missing real-device verification undermines every RPi-dependent claim.
  - **Mitigation**: Design most verification to run Sim/Playback-based (no hardware required), minimizing Pi5 dependence; schedule the real device only for must-have items such as performance measurement

## G. Other / Uncategorized

- **R-20 — Communication** — meaning may be lost between stakeholders when conversing in English
- **R-21 — Insufficient test environment** — one device, no test room, no unit tests → regressions may slip through logic changes
- **R-22 — Long-run verification difficulty** — items like 24-hour continuous runs are hard to actually verify and assess
- **R-23 — Growing storage** — long recordings make files large
- **R-24 — RPi5 debugging difficulty** — hard to inspect state or debug → leaving log messages is experimentally possible
- **R-25 — Uncertain data structures** — audio buffer and measurement-data storage structures are undecided
- **R-26 — Storage-speed bottleneck** — SD-card writes may be slower than recording generation → check SD specs + real recording test
