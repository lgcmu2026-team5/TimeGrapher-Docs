# Architectural Drivers

**Contents** — [Functional Requirements (FR)](#functional-requirements) · [Quality Attribute Scenarios (QAS)](#quality-attribute-scenarios) · [Priority](#priority) · [Design COnstraints](#design-constraints)

## Glossary

The domain terms used throughout the functional requirements below are defined in the consolidated [Glossary](Milestone1_6-Glossary.md) — see **Domain Terms**.

## Functional Requirements

### G01 · Watch-Position Testing
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-01-01 | mandatory | The Watch-Position Testing shall provide the user with the ability to test a mechanical watch in standard measurement positions. |
| FR-01-02 | mandatory | The Watch-Position Testing shall provide the user with the current watch position in the GUI. |
| FR-01-03 | mandatory | The Watch-Position Testing shall provide the user with the standard position set comprising horizontal positions CH and CB and vertical positions 6H, 9H, 3H, and 12H. |
| FR-01-04 | recommended | The Watch-Position Testing should provide the user with support for intermediate positions. |
| FR-01-05 | mandatory | The Watch-Position Testing shall provide the user with a clear indication of the active test position while measurements are being taken. |
| FR-01-06 | mandatory | The Watch-Position Testing shall provide the user with measurement results associated with the active test position. |

### G02 · Trace Display
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-02-01 | mandatory | The Trace Display shall provide the user with a graph of rate deviation over time. |
| FR-02-02 | mandatory | The Trace Display shall provide the user with a graph of amplitude over time. |
| FR-02-03 | optional | The Trace Display may provide the user with rate deviation and amplitude as either a vertically stacked graph or two separate graphs. |
| FR-02-04 | mandatory | The Trace Display shall provide the user with a smoothing function for the daily rate (s/d) measurement. |
| FR-02-05 | mandatory | The Trace Display shall provide the user with an alert when the rate indicates the watch is running late. |
| FR-02-06 | mandatory | The Trace Display shall provide the user with descriptive text or labels for each graph. |
| FR-02-07 | mandatory | The Trace Display shall provide the user with an average value and a rolling average that updates over time. |
| FR-02-08 | mandatory | The Trace Display shall provide the user with long-term summary information for both measurements (rate deviation and amplitude). |
| FR-02-09 | mandatory | The Trace Display shall provide the user with an alert when the measured amplitude falls outside the 270°–300° range. |

### G03 · Rate and Amplitude Stability Over Time (Vario Display)
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-03-01 | mandatory | The Vario Display shall provide the user with information showing the long-term stability of both measurements (rate deviation and amplitude). |
| FR-03-02 | mandatory | The Vario Display shall provide the user with the minimum value of rate deviation. |
| FR-03-03 | mandatory | The Vario Display shall provide the user with the maximum value of rate deviation. |
| FR-03-04 | mandatory | The Vario Display shall provide the user with the average value of rate deviation. |
| FR-03-05 | mandatory | The Vario Display shall provide the user with the standard deviation of rate deviation. |
| FR-03-06 | mandatory | The Vario Display shall provide the user with the elapsed measurement time of rate deviation. |
| FR-03-07 | mandatory | The Vario Display shall provide the user with the current value of rate deviation. |
| FR-03-08 | mandatory | The Vario Display shall provide the user with the minimum value of amplitude. |
| FR-03-09 | mandatory | The Vario Display shall provide the user with the maximum value of amplitude. |
| FR-03-10 | mandatory | The Vario Display shall provide the user with the average value of amplitude. |
| FR-03-11 | mandatory | The Vario Display shall provide the user with the standard deviation of amplitude. |
| FR-03-12 | mandatory | The Vario Display shall provide the user with the elapsed measurement time of amplitude. |
| FR-03-13 | mandatory | The Vario Display shall provide the user with the current value of amplitude. |
| FR-03-14 | recommended | The Vario Display should provide the user with the acceptable minimum–maximum range of each measurement, visually distinguished on the graph. |
| FR-03-15 | recommended | The Vario Display should provide the user with the minimum/maximum value of each measurement, visually distinguished on the graph. |
| FR-03-16 | recommended | The Vario Display should provide the user with the average value of each measurement, visually distinguished on the graph. |
| FR-03-17 | optional | The Vario Display may provide the user with the maximum–minimum difference of each measurement. |

### G04 · Multi-Position Sequence Display
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-04-01 | mandatory | The Multi-Position Sequence Display shall provide the user with a sequence display within the GUI. |
| FR-04-02 | mandatory | The Multi-Position Sequence Display shall provide the user with a complete measurement cycle across multiple watch test positions. |
| FR-04-03 | mandatory | The Multi-Position Sequence Display shall provide the user with the ability to capture and review results from up to 10 test positions in a single sequence. |
| FR-04-04 | mandatory | The Multi-Position Sequence Display shall provide the user with support for at least the CH, CB, 6H, 9H, 3H, and 12H positions. |
| FR-04-05 | mandatory | The Multi-Position Sequence Display shall provide the user with the rate, amplitude, and beat error for each measured position. |
| FR-04-06 | mandatory | The Multi-Position Sequence Display shall provide the user with X, the mean value of all valid test positions. |
| FR-04-07 | mandatory | The Multi-Position Sequence Display shall provide the user with D, the difference between the largest and smallest measured value. |
| FR-04-08 | recommended | The Multi-Position Sequence Display should provide the user with a comparison between vertical and horizontal positions. |
| FR-04-09 | recommended | The Multi-Position Sequence Display should provide the user with indicators that can reveal possible balance-wheel unbalance. |

### G05 · Beat-Noise Scope Display
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-05-01 | mandatory | The Beat-Noise Scope Display shall provide the user with a Beat-Noise Scope tab in the Tabbed Graph Panel that can be displayed without restarting the program. |
| FR-05-02 | mandatory | The Beat-Noise Scope Display shall provide the user with two related views, Scope 1 and Scope 2. |
| FR-05-03 | mandatory | The Beat-Noise Scope Display shall provide the user with a Live mode. |
| FR-05-04 | mandatory | The Beat-Noise Scope Display shall provide the user with a Playback mode. |
| FR-05-05 | mandatory | The Beat-Noise Scope Display shall provide the user with a Sim mode. |
| FR-05-06 | recommended | The Beat-Noise Scope Display should provide the user with a pause control. |
| FR-05-07 | recommended | The Beat-Noise Scope Display should provide the user with forward/backward navigation through captured data. |
| FR-05-08 | mandatory | Scope 1 shall provide the user with a waveform display of the watch's alternating tick/tock beat noises. |
| FR-05-09 | mandatory | Scope 1 shall provide the user with selectable time ranges of 20 ms, 200 ms, and 400 ms. |
| FR-05-10 | mandatory | Scope 1 shall provide the user with the most recent beat noises as small strips beneath the current waveform after sufficient measurement time. |
| FR-05-11 | recommended | Scope 1 should provide the user with the ability to select one of the accumulated prior beat strips for enlarged viewing. |
| FR-05-12 | optional | Scope 1 may provide the user with an option to display the signal as its absolute value (\|x\|) for improved readability. |
| FR-05-13 | mandatory | Scope 1 shall provide the user with identification of the relevant A and C events and a visual marker for the C event. |
| FR-05-14 | mandatory | Scope 1 shall provide the user with the lift angle associated with the displayed beat pattern. |
| FR-05-15 | mandatory | Scope 2 shall provide the user with tick and tock beat noises displayed on two horizontal axes. |
| FR-05-16 | mandatory | Scope 2 shall provide the user with a fixed 20 ms time range. |
| FR-05-17 | mandatory | Scope 2 shall provide the user with an averaging toggle (ON/OFF) via a Σ control. |
| FR-05-18 | mandatory | Scope 2 shall provide the user with combined beat noises that reduce random noise and improve signal clarity when averaging is ON. |
| FR-05-19 | mandatory | Scope 2 shall provide the user with a measurement cycle, determined by the watch's beat number and selected interval, that completes after 50 tick and 50 tock intervals. |
| FR-05-20 | mandatory | Scope 2 shall provide the user with the average amplitude on each horizontal axis using arrows at the end of the cycle. |
| FR-05-21 | recommended | Scope 2 should provide the user with the two averaged beat-noise traces without assuming a fixed tick/tock axis assignment. |
| FR-05-22 | optional | Scope 2 may provide the user with intermediate averaging results, such as after 10 or 20 intervals. |

### G06 · Beat Error Display and Diagnostic Trace
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-06-01 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with the rate value with numbers and units. |
| FR-06-02 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with the amplitude value with numbers and units. |
| FR-06-03 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with the beat error value with numbers and units. |
| FR-06-04 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with the BPH value with numbers and units. |
| FR-06-05 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with tick/tock trace lines that represent the watch's timing behavior. |
| FR-06-06 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with the measurement values (rate, amplitude, beat error, BPH) and the tick/tock trace lines simultaneously. |
| FR-06-07 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with the tick and tock trace lines as visually distinguished elements. |
| FR-06-08 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with the spacing between the tick/tock trace lines. |
| FR-06-09 | optional | The Beat Error Display and Diagnostic Trace may provide the user with the ability to configure the acceptable range of the trace-line spacing. |
| FR-06-10 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with a defined acceptable range for the trace-line spacing. |
| FR-06-11 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with a warning when the trace-line spacing exceeds the acceptable range. |
| FR-06-12 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with the slope of the trace lines. |
| FR-06-13 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with a fault-state indication when the trace-line slope reaches 45 degrees or more. |

### G07 · Long-Term Performance Graph
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-07-01 | mandatory | The Long-Term Performance Graph shall provide the user with a recording of the watch's rate over an extended period of time. |
| FR-07-02 | mandatory | The Long-Term Performance Graph shall provide the user with a recording of the watch's amplitude over an extended period of time. |
| FR-07-03 | mandatory | The Long-Term Performance Graph shall provide the user with a recording of the watch's beat error over an extended period of time. |
| FR-07-04 | mandatory | The Long-Term Performance Graph shall provide the user with the changes in rate over time. |
| FR-07-05 | mandatory | The Long-Term Performance Graph shall provide the user with the changes in amplitude over time. |
| FR-07-06 | mandatory | The Long-Term Performance Graph shall provide the user with the changes in beat error over time. |
| FR-07-07 | recommended | The Long-Term Performance Graph should provide the user with periodic updates of the graph during the test. |
| FR-07-08 | recommended | The Long-Term Performance Graph should provide the user with overall average values. |
| FR-07-09 | recommended | The Long-Term Performance Graph should provide the user with a visual indication of the variation range. |
| FR-07-10 | recommended | The Long-Term Performance Graph should provide the user with support for long-duration tests. |
| FR-07-11 | recommended | The Long-Term Performance Graph should provide the user with a reduced update frequency as elapsed time increases. |

### G08 · Escapement Analyzer and Marker-Line Display
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-08-01 | mandatory | The Escapement Analyzer and Marker-Line Display shall provide the user with a visualization of real-time microphone input. |
| FR-08-02 | mandatory | The Escapement Analyzer and Marker-Line Display shall provide the user with a visualization of stored recording files. |
| FR-08-03 | recommended | The Escapement Analyzer and Marker-Line Display should provide the user with a pause/capture mode for analysis. |
| FR-08-04 | mandatory | The Escapement Analyzer and Marker-Line Display shall provide the user with markers at the A and C event points to be analyzed. |
| FR-08-05 | mandatory | The Escapement Analyzer and Marker-Line Display shall provide the user with the elapsed time between markers in milliseconds. |
| FR-08-06 | recommended | The Escapement Analyzer and Marker-Line Display should provide the user with the ability to change the marker measurement reference based on signal feature points (Onset, Peak, etc.). |

### G09 · Time-Frequency Spectrogram Display
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-09-01 | mandatory | The Time-Frequency Spectrogram Display shall provide the user with a time-frequency spectrogram that shows how the watch's acoustic energy is distributed across time and frequency. |
| FR-09-02 | mandatory | The Time-Frequency Spectrogram Display shall present the spectrogram to the user with time on the horizontal axis, frequency on the vertical axis, and signal strength as color intensity. |
| FR-09-03 | recommended | The Time-Frequency Spectrogram Display should provide the user with the ability to inspect either the most recent beat or a selected recent time window. |
| FR-09-04 | recommended | The Time-Frequency Spectrogram Display should provide the user with the ability to view recurring energy structures at characteristic frequency ranges. |
| FR-09-05 | recommended | The Time-Frequency Spectrogram Display should provide the user with the ability to compare one beat with the next. |
| FR-09-06 | recommended | The Time-Frequency Spectrogram Display should provide the user with a color scale or legend for interpreting relative signal strength. |

### G10 · Waveform Comparison Display with Timing Markers
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-10-01 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with multiple beat waveforms presented in aligned lanes. |
| FR-10-02 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with the ability to compare waveform shape across beats. |
| FR-10-03 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with the ability to compare waveform spacing across beats. |
| FR-10-04 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with the ability to compare waveform consistency across beats. |
| FR-10-05 | recommended | The Waveform Comparison Display with Timing Markers should provide the user with overlaid waveform displays that include vertical guide markers. |
| FR-10-06 | recommended | The Waveform Comparison Display with Timing Markers should provide the user with the rate value. |
| FR-10-07 | recommended | The Waveform Comparison Display with Timing Markers should provide the user with the beat error value. |
| FR-10-08 | recommended | The Waveform Comparison Display with Timing Markers should provide the user with the beats per hour value. |
| FR-10-09 | recommended | The Waveform Comparison Display with Timing Markers should provide the user with the ability to compare successive beats. |
| FR-10-10 | recommended | The Waveform Comparison Display with Timing Markers should provide the user with the ability to identify landmarks in the waveform signal. |
| FR-10-11 | recommended | The Waveform Comparison Display with Timing Markers should provide the user with the ability to inspect changes in waveform structure between beats. |
| FR-10-12 | recommended | The Waveform Comparison Display with Timing Markers should provide the user with the ability to decompose the waveform signal. |
| FR-10-13 | recommended | The Waveform Comparison Display with Timing Markers should provide the user with signal envelopes for each beat. |
| FR-10-14 | optional | The Waveform Comparison Display with Timing Markers may provide the user with degree-based reference markers. |
| FR-10-15 | optional | The Waveform Comparison Display with Timing Markers may provide the user with time-based reference markers. |

### G11 · Scope Mode with Synchronized Sweep Display
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-11-01 | mandatory | The Scope Mode with Synchronized Sweep Display shall provide the user with a display of the watch's acoustic signal in a fixed sweep window, similar to an oscilloscope. |
| FR-11-02 | recommended | The Scope Mode with Synchronized Sweep Display should provide the user with a display of the processed signal that combines the upper and lower halves of the waveform. |
| FR-11-03 | recommended | The Scope Mode with Synchronized Sweep Display should provide the user with the ability to configure the sweep time as a multiple of the watch's tick interval. |
| FR-11-04 | recommended | The Scope Mode with Synchronized Sweep Display should provide the user with a synchronized display in which the beat pattern stays visually stable near the nominal rate and drifts when the watch is fast or slow. |
| FR-11-05 | optional | The Scope Mode with Synchronized Sweep Display may provide the user with the daily rate reference value from the most recent timing test. |
| FR-11-06 | optional | The Scope Mode with Synchronized Sweep Display may provide the user with the amplitude reference value from the most recent timing test. |
| FR-11-07 | optional | The Scope Mode with Synchronized Sweep Display may provide the user with the beat error reference value from the most recent timing test. |
| FR-11-08 | optional | The Scope Mode with Synchronized Sweep Display may provide the user with the nominal beat rate reference value from the most recent timing test. |

### G12 · Scope Function with Multiple Filter Views
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-12-01 | mandatory | The Scope Function with Multiple Filter Views shall provide the user with four filter views — F0, F1, F2, F3 — over the same watch signal. |
| FR-12-02 | recommended | The Scope Function with Multiple Filter Views should provide the user with the ability to compare how each filter changes the waveform. |
| FR-12-03 | recommended | The Scope Function with Multiple Filter Views should provide the user with the ability to compare how each filter changes the visibility of key events (T1, T2, T3). |
| FR-12-04 | mandatory | The Scope Function with Multiple Filter Views shall provide the user with updates of all filter views as measurements are acquired and processed. |
| FR-12-05 | mandatory | The Scope Function with Multiple Filter Views shall provide the user with all filter views rendered from the same input signal data and the same time axis. |
| FR-12-06 | mandatory | F0 shall provide the user with the signal as captured, formatted to fit the screen, treated as the closest available representation of the raw watch signal. |
| FR-12-07 | mandatory | F0 shall provide the user with the signal mirrored symmetrically around its average value. |
| FR-12-08 | mandatory | F1 shall provide the user with a moving-average-filtered view of the F0 signal that smooths the waveform envelope and removes a large portion of background noise. |
| FR-12-09 | mandatory | F2 shall provide the user with a view that builds on F1 by emphasizing rising slopes and attenuating falling slopes to make beat features stand out, especially T3 (and to some extent T2). |
| FR-12-10 | optional | F2 may provide the user with an attenuation function that decays after a local rise. |
| FR-12-11 | mandatory | F3 shall provide the user with a view of only the upper portion of the signal relative to its average value, applying emphasis to rising edges and attenuation to falling portions, to support identification of T1 and especially T3. |
| FR-12-12 | mandatory | Each filter view shall provide the user with its filter label (F0/F1/F2/F3). |
| FR-12-13 | recommended | The Scope Function with Multiple Filter Views should provide the user with a UI to display the four filters simultaneously or switch between them for comparison. |
| FR-12-14 | mandatory | The filter views shall provide the user with a Live mode. |
| FR-12-15 | mandatory | The filter views shall provide the user with a Playback mode. |
| FR-12-16 | mandatory | The filter views shall provide the user with a Sim mode. |
| FR-12-17 | recommended | The filter views should provide the user with a pause control. |
| FR-12-18 | recommended | The filter views should provide the user with navigation through captured data. |

## Quality Attribute Scenarios

### Terminology

The metric, unit, and standard terms used in the scenarios below are defined in the consolidated [Glossary](Milestone1_6-Glossary.md) — see **Quality-Attribute & Measurement Terms**.

### QAS-1 · Performance (Latency) — From Sound Input to Screen Display
> **In one line: sound reaches the microphone → the result is on screen within 0.5 s.**
>
> While measuring live on the Raspberry Pi 5, when watch sound enters the input → analysis → display flow through the microphone, the system processes data that must be rendered in real time, shows it on screen, and reports the three latency components — over a 10-min run, (1) capture-to-processing latency p99 and (2) processing-to-display latency p99 are reported, and (3) total end-to-end (capture-to-display) latency must be **p99 ≤ 500 ms**.

**Why this attribute**
- The Plan demands it — and even prescribes the three-part split: *"Teams shall report capture-to-processing latency, processing-to-display latency, and total end-to-end latency in milliseconds."*
- An event arrives and the response is measured in **time** → that is Performance (Latency) by SAP's definition.

| Element | Content |
|---------|---------|
| Source | Watch sound (external) |
| Stimulus | Sound arrives at the microphone |
| Artifact | The input → analysis → display flow — timestamped at each point |
| Environment | Live measurement on the Raspberry Pi 5 (8 GB) |
| Response | Process data that must be rendered in real time, show it on screen, and report the three latency components |
| Response Measure | Over a 10-min run: (1) capture-to-processing latency — p99 (2) processing-to-display latency — p99 (3) total end-to-end latency — **p99 ≤ 500 ms** (the pass/fail gate) |

**Why these numbers**
- **≤ 500 ms** — p99 (the slowest 1 %) sits at Google's INP (Interaction to Next Paint) boundary just before "poor" (good ≤ 200 ms · needs improvement ≤ 500 ms · poor > 500 ms); adopted as the maximum allowable limit for the final display update.

**Related FRs** — [FR-08-01](#g08--escapement-analyzer-and-marker-line-display), [FR-12-04](#g12--scope-function-with-multiple-filter-views), [FR-05-03](#g05--beat-noise-scope-display), [FR-12-14](#g12--scope-function-with-multiple-filter-views) (Live display and low-latency feedback features)

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

**Related FRs** — [FR-12-08](#g12--scope-function-with-multiple-filter-views), [FR-05-17…18](#g05--beat-noise-scope-display) (noise filtering, averaging)

### QAS-3 · Consistency — Consistent Values Across Displays
> **In one line: every number and graph on screen comes from the same source data.**
>
> While measuring as usual, when the analysis/computation stage fans one set of source data out to multiple graph and numeric displays, everything rendered in the same frame derives from that same source data and agrees — **0 mismatches** over a 10-min run.

**Why this attribute**
- Plan §Correctness: *"remaining internally consistent across the GUI, derived measurements, and longer-term summaries"* — *"calculations and visualizations are based on the same underlying data."*
- That Plan section bundles multiple demands: stay internally consistent (→ **this scenario**) and stay usable under noise (→ [QAS-2](#qas-2--availability-graceful-degradation--under-noisy-or-weak-signals)). This scenario measures only consistency, so that is its name — "Correctness" would overclaim the other parts.

| Element | Content |
|---------|---------|
| Source | The analysis/computation stage (internal) |
| Stimulus | One set of source data fans out to multiple displays (graphs/numbers) |
| Artifact | Numeric readouts and graph displays |
| Environment | Measuring as usual (verified via Sim/Playback) |
| Response | Everything shown in one frame derives from one set of source data and agrees |
| Response Measure | Over a 10-min run on known input: **0 mismatches** across all simultaneously shown displays (within display rounding); each display exposes its source-data identity, so the check is observable |

**Why these numbers**
- **0** is the only sensible target — consistency is a correctness-class property, not a tunable number.
- The check is genuinely verifiable because each display exposes which source data it came from.

**Related FRs** — [FR-12-05](#g12--scope-function-with-multiple-filter-views), [FR-06-06](#g06--beat-error-display-and-diagnostic-trace), [FR-02-07…08](#g02--trace-display) (views and summaries showing the same data)

### QAS-4 · Modifiability (Extensibility) — Adding a New Measurement/Filter/Graph
> **In one line: adding a new graph, filter, or measurement touches one place.**
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

**Related FRs** — [FR-06-06](#g06--beat-error-display-and-diagnostic-trace), [FR-01-05](#g01--watch-position-testing), [FR-04-03](#g04--multi-position-sequence-display), [FR-02-06](#g02--trace-display), [FR-06-11·13](#g06--beat-error-display-and-diagnostic-trace) (at-a-glance readings, position indication, alerts)

## Priority

ATAM style: each scenario carries an (**I**mportance, **D**ifficulty) pair, H/M/L. The H/H scenarios shape the architecture most.

| Priority | QAS | Quality | I | D | Rationale |
|----------|-----|---------|---|---|-----------|
| 1 | [QAS-1](#qas-1--performance-latency--from-sound-input-to-screen-display) | Performance (Latency) | H | H | The result must appear quickly, and the Pi may be the bottleneck |
| 2 | [QAS-2](#qas-2--availability-graceful-degradation--under-noisy-or-weak-signals) | Availability | H | H | Noisy or weak signals are likely in actual use |
| 3 | [QAS-3](#qas-3--consistency--consistent-values-across-displays) | Consistency | H | M | Users should not see different values for the same result |
| 4 | [QAS-4](#qas-4--modifiability-extensibility--adding-a-new-measurementfiltergraph) | Modifiability | H | M | Many required features still need to be added |
| 5 | [QAS-5](#qas-5--usability--reading-and-operating-on-the-touchscreen) | Usability | M | M | The small touchscreen limits layout choices |

## Design COnstraints

| ID | Design Constraint |
|----|-------------------|
| C-1 | The system shall run on a Raspberry Pi 5 (8 GB RAM, 128 GB microSD) with a touchscreen attached. |
| C-2 | The system shall render and operate the GUI correctly on the 1280×800 display connected to the Raspberry Pi 5. |
| C-3 | The system shall run on both a Windows 11 (x64) PC and a Raspberry Pi 5 running Raspberry Pi OS (Debian-based, 64-bit/ARM64). |
| C-4 | The system shall operate with Auto Gain Control turned off. |
