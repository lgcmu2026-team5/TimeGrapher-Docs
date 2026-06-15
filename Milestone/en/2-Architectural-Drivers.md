# Architectural Drivers

**Contents** — [Functional Requirements (FR)](#functional-requirements) · [Quality Attribute Scenarios (QAS)](#quality-attribute-scenarios) · [Design Constraints](#design-constraints)

## Glossary

The domain terms used throughout the functional requirements below are defined in the consolidated [Glossary](6-Glossary.md) — see **Domain Terms**.

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
| FR-07-12 | optional | The Long-Term Performance Graph may provide the user with the ability to export the recorded rate/amplitude/beat-error time series to a file. |
| FR-07-13 | optional | The Long-Term Performance Graph may provide the user with the ability to toggle the visibility of each measure pane (rate, amplitude, beat error). |
| FR-07-14 | optional | The Long-Term Performance Graph may provide the user with a configurable test-window length or update cadence. |

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

The metric, unit, and standard terms used in the scenarios below are defined in the consolidated [Glossary](6-Glossary.md) — see **Quality-Attribute & Measurement Terms**.

### QAS-1 · Accuracy — From Acoustic Event Detection to Computed Watch Metrics
**Prioritization** — Rank 1 · Importance: H · Difficulty: H · Rationale: All watch metrics are derived from precisely timed acoustic events; any detection error propagates into every computed output.

> **In one line: on a clean signal with known reference values, the system identifies the onset and peak of each beat with enough timing precision to produce a computed rate within ±1.0 s/d of the reference.**
>
> While measuring in Sim or Playback mode with a clean signal and known reference values, when acoustic signal data flows through acquisition, filtering, event detection, and calculation, the system correctly identifies the start/onset (A event) and peak (C event) of each tick and tock beat, preserves timing precision at every pipeline stage, and computes rate, beat error, amplitude, lift angle, BPH, and balance-wheel frequency within the allowed tolerance — on clean Sim/Playback input with no noise injection and known reference values, computed rate must be **within ±1.0 s/d** of the reference over ≥ 1,000 consecutive beats.

**Related requirements in the project description**
- *"The system shall detect the relevant watch events with sufficient accuracy to support meaningful measurement of small timing differences."*
- *"the software must accurately identify the start/onset and peak of the important acoustic signals used to compute watch metrics such as rate, beat error, amplitude, lift angle, beats per hour, and balance-wheel frequency."*
- *"the architecture should preserve timing precision throughout acquisition, filtering, event detection, and calculation."*
- *"Since these measurements are derived from very small timing differences at high sample rates, slight deviations may be significant."*

| Element | Content |
|---------|---------|
| Source | Sim/Playback input with known timing reference and no noise injection (external) |
| Stimulus | Acoustic signal data flows through the acquisition → filtering → event detection → calculation pipeline |
| Artifact | Event detection stage (onset and peak of A and C events) and all derived metric computations (rate, beat error, amplitude, lift angle, BPH, balance-wheel frequency) |
| Environment | Raspberry Pi 5 running Sim/Playback mode; clean input signal with known reference values and no noise injection |
| Response | Identify onset and peak of each beat correctly; compute rate, beat error, amplitude, lift angle, BPH, and balance-wheel frequency from those events; preserve timing precision at every pipeline stage |
| Response Measure | Over ≥ 1,000 consecutive beats on clean Sim/Playback input with known reference and no noise injection: computed rate **within ±1.0 s/d** of the reference |

**Why these numbers**
- **±1.0 s/d** — one-eighth of the tightest Witschi grade band (Chronometer −2…+6 s/d, range 8 s/d); ensures that under clean signal conditions the computed value is a trustworthy indicator of the watch's grade; provisional.
- System behavior under noisy or weak signals — including detection rate and graceful degradation — is a separate concern addressed in QAS-3.

### QAS-2 · Performance (Latency) — From Sound Input to Screen Display
**Prioritization** — Rank 1 · Importance: H · Difficulty: H · Rationale: The result must appear quickly, and the Pi may be the bottleneck.

> **In one line: even at the top target rate of 43200 BPH, the analysis result is on screen within one beat period (83.3 ms).**
>
> While measuring with Live, Playback, or Simulation on the Raspberry Pi 5, when an audio sample block enters the input → analysis → display flow, the system analyzes the block, shows the result on screen, and records the three latency components (capture-to-processing, processing-to-display, total end-to-end) — at every supported BPH, worst-case total end-to-end latency must **not exceed one beat period**: **≤ 83.3 ms** at 43200 BPH, **≤ 125.0 ms** at 28800 BPH.

**Related requirements in the project description**
- *"The system shall record the time difference between (1) when an audio sample block is captured, (2) when that block is processed for beat detection and measurement, and (3) when the corresponding waveform segment and computed readings are displayed in the GUI."*
- *"Teams shall report capture-to-processing latency, processing-to-display latency, and total end-to-end latency in milliseconds, together with average and worst-case values, as well as counts of dropped audio blocks and missed beat detections."*

| Element | Content |
|---------|---------|
| Source | Watch sound, or Sim/Playback input passing through the same pipeline (external) |
| Stimulus | An audio sample block is captured and enters the analysis pipeline |
| Artifact | Input buffer → beat detection/measurement → GUI display — timestamped at each point |
| Environment | Raspberry Pi 5 (8 GB) + connected display. Live microphone preferred; the same path is verified via Sim/Playback when no microphone is available |
| Response | Analyze the input block, show the corresponding waveform / markers / computed readings on screen, and record the three latency components |
| Response Measure | At every supported BPH, worst-case total end-to-end latency ≤ one beat period — **43200 BPH: ≤ 83.3 ms · 28800 BPH: ≤ 125.0 ms** (the pass/fail gate). Report average/worst values for all three latency components, with dropped audio blocks/samples = **0** and missed beat detections = **0** |

**Why these numbers**
- **The latency budget comes from the beat period** — TimeGrapher is not a GUI app reacting to user clicks but a real-time acoustic measurement app that must analyze every periodically arriving watch beat without missing one. If processing and display consistently take longer than one beat period, backlog, stale display, block drop, and missed beats follow.
- The previous criterion, **p99 ≤ 500 ms**, is reasonable as a human-perceived GUI-responsiveness limit but far too loose for real-time beat analysis, so it was replaced with the beat-period-based worst-case criterion.

Beat period = 3600 s ÷ BPH:

| BPH | Beats per second | Beat period |
|---:|---:|---:|
| 21600 | 6 beats/s | 166.7 ms |
| 28800 | 8 beats/s | 125.0 ms |
| 36000 | 10 beats/s | 100.0 ms |
| 43200 | 12 beats/s | 83.3 ms |

<a id="qas-3"></a>

### QAS-3 · Reliability — Under Noisy or Weak Signals
**Prioritization** — Rank 2 · Importance: H · Difficulty: H · Rationale: Noisy or weak signals are likely in actual use.

> **In one line: under noise, keep the measurement service reliable when the signal is good enough, and show the "signal weak" indication while handling weak input appropriately.**
>
> In a noisy working environment, when watch sound mixed with ambient noise — or a weak signal — reaches the noise-removal / beat-detection part, the system either accepts the signal and produces a bounded measurement, or shows the "signal weak" indication while handling weak input appropriately. At SNR ≥ 30 dB, accepted input must meet detection **≥ 95 %** and keep the displayed rate **within ±3 s/d of the Sim/Playback reference rate**.

**Related requirements in the project description**
- *"the system should degrade gracefully when the signal is weak, noisy, or partially missing, rather than producing unstable or misleading outputs"*

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

### QAS-4 · Consistency — Consistent Values Across Displays
**Prioritization** — Rank 3 · Importance: H · Difficulty: M · Rationale: Users should not see different values for the same result.

> **In one line: every number and graph on screen comes from the same source data.**
>
> While measuring as usual, when the analysis/computation stage fans one set of source data out to multiple graph and numeric displays, everything rendered in the same frame derives from that same source data and agrees — **0 mismatches** over a 10-min run.

**Related requirements in the project description**
- *"remaining internally consistent across the GUI, derived measurements, and longer-term summaries"*
- *"calculations and visualizations are based on the same underlying data."*

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

### QAS-5 · Modifiability (Extensibility) — Adding a New Measurement/Filter/Graph
**Prioritization** — Rank 4 · Importance: H · Difficulty: M · Rationale: Many required features still need to be added.

> **In one line: adding a new graph, filter, or measurement touches one place.**
>
> During development under a tight schedule, when a developer adds a new graph, filter, or measurement to the codebase, the addition is incremental without changing codes for the existing graphs — **≤ 1 existing module changed** (common parts only), 8 person-days per feature.

**Related requirements in the project description**
- *"support the addition of new measurements, filters, graphs, and display modes without major redesign of existing code."*

| Element | Content |
|---------|---------|
| Source | Developer |
| Stimulus | Wants to add a new graph, filter stage, or derived measurement |
| Artifact | The codebase holding the measurement/display features |
| Environment | During development, tight schedule |
| Response | Add incrementally without changing codes for the existing graphs |
| Response Measure | New graph / filter / measurement, each: ≤ 1 existing module changed (common parts only), 8 person-days per feature |

**Why these numbers**
- 12 mandatory features in a 3-week schedule — only a bounded touch surface makes that feasible.
- Milestone 2/3 schedule (16 days) × 6 team members / 12 features = 8 person-days per feature.

### QAS-6 · Usability — Reading and Operating on the Touchscreen
**Prioritization** — Rank 5 · Importance: M · Difficulty: M · Rationale: The small touchscreen limits layout choices.

> **In one line: on the small 1280×800 touchscreen, the three key readings are readable at a glance and operable by finger.**
>
> On the Raspberry Pi 5's 1280×800 (8-inch) touchscreen, when the user reads measurement values and switches modes in the GUI, key readings are shown legibly and primary functions operate by touch alone — rate / beat error / amplitude visible simultaneously, uppercase letter height ≥ 2.9 mm, touch targets ≥ 9 mm. Physical sizes (mm) are normative.

**Related requirements in the project description**
- *"The GUI should support ease of use by clearly showing … the calculated values that matter most to the user, such as rate, beat error, amplitude."*

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

## Design Constraints

| ID | Design Constraint |
|----|-------------------|
| C-1 | The system shall run on a Raspberry Pi 5 (8 GB RAM, 128 GB microSD) with a touchscreen attached. |
| C-2 | The system shall render and operate the GUI correctly on the 1280×800 display connected to the Raspberry Pi 5. |
| C-3 | The system shall run on both a Windows 11 (x64) PC and a Raspberry Pi 5 running Raspberry Pi OS (Debian-based, 64-bit/ARM64). |
| C-4 | The system shall operate with Auto Gain Control turned off. |
