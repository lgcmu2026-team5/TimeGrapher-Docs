# Architectural Drivers

## Glossary

The following domain terms are used throughout the functional requirements below. They are defined here once so the requirements can reference them consistently.

| Term | Definition |
|------|------------|
| Tick / Tock (A / C beat) | The two alternating escapement noises produced on each swing of the balance. **A = tick**, **C = tock** (see FR-08-04). The Beat-Noise Scope marks the C beat. |
| Tic / Tac | Alternative spelling of tick / tock used for the Scope 2 traces; **tic = tick = A** and **tac = tock = C**. Treated as the same pair of beat events. |
| T1, T2, T3 | The characteristic timing feature points within a single beat's acoustic waveform (the successive escapement events of one beat). They are the reference events that the filter views F0–F3 help locate and identify, and are distinct from the beat-level A/C labels. |
| Lift angle | The angular travel of the balance during which the escapement delivers impulse. A per-caliber constant (commonly ~40°–60°) provided as input and used to derive amplitude from the beat signal. |
| BPH (beats per hour) | The number of balance beats (semi-oscillations) per hour — the watch's nominal operating frequency. Typical values: 18000, 21600, 28800 BPH. |
| Beat number | Synonym for the watch's nominal beat rate expressed in BPH; together with the selected interval it parameterizes the Scope 2 measurement cycle. |
| Nominal (beat) rate | The watch's designed/target beat rate (in BPH or beats per second). "Nominal rate" and "nominal beat rate" denote the same quantity; it is used as the synchronization and reference value in the Scope Sweep display. |
| Timing test | A measurement run that produces the watch's primary timing results (daily rate, amplitude, beat error, nominal beat rate). The "most recent timing test" is the latest such run whose results are retained for later reference (see FR-11-05…08). |
| Balance-wheel unbalance | A poising error of the balance-and-hairspring assembly that makes the rate differ between vertical positions; it is revealed by a large rate spread across vertical positions (see FR-04-09). |
| Onset / Peak | Signal feature points on a beat's acoustic waveform used as the marker measurement reference: **Onset** = the leading edge (start) of the beat noise; **Peak** = the point of maximum amplitude (see FR-08-06). |

## Functional Requirements

### G01 · Watch-Position Testing
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-01-01 | mandatory | The Watch-Position Testing shall provide the user with the ability to test a mechanical watch in standard measurement positions. |
| FR-01-02 | mandatory | The Watch-Position Testing shall provide the user with the current watch position in the GUI. |
| FR-01-03 | mandatory | The Watch-Position Testing shall provide the user with the standard position set comprising horizontal positions CH and CB and vertical positions 6H, 9H, 3H, and 12H. |
| FR-01-04 | desired | The Watch-Position Testing should provide the user with support for intermediate positions. |
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
| FR-03-14 | desired | The Vario Display should provide the user with the acceptable minimum–maximum range of each measurement, visually distinguished on the graph. |
| FR-03-15 | desired | The Vario Display should provide the user with the minimum/maximum value of each measurement, visually distinguished on the graph. |
| FR-03-16 | desired | The Vario Display should provide the user with the average value of each measurement, visually distinguished on the graph. |
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
| FR-04-08 | desired | The Multi-Position Sequence Display should provide the user with a comparison between vertical and horizontal positions. |
| FR-04-09 | desired | The Multi-Position Sequence Display should provide the user with indicators that can reveal possible balance-wheel unbalance. |

### G05 · Beat-Noise Scope Display
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-05-01 | mandatory | The Beat-Noise Scope Display shall provide the user with a Beat-Noise Scope tab in the Tabbed Graph Panel that can be displayed without restarting the program. |
| FR-05-02 | mandatory | The Beat-Noise Scope Display shall provide the user with two related views, Scope 1 and Scope 2. |
| FR-05-03 | mandatory | The Beat-Noise Scope Display shall provide the user with a Live mode. |
| FR-05-04 | mandatory | The Beat-Noise Scope Display shall provide the user with a Playback mode. |
| FR-05-05 | mandatory | The Beat-Noise Scope Display shall provide the user with a Sim mode. |
| FR-05-06 | desired | The Beat-Noise Scope Display should provide the user with a pause control. |
| FR-05-07 | desired | The Beat-Noise Scope Display should provide the user with forward/backward navigation through captured data. |
| FR-05-08 | mandatory | Scope 1 shall provide the user with a waveform display of the watch's alternating tick/tock beat noises. |
| FR-05-09 | mandatory | Scope 1 shall provide the user with selectable time ranges of 20 ms, 200 ms, and 400 ms. |
| FR-05-10 | mandatory | Scope 1 shall provide the user with the most recent beat noises as small strips beneath the current waveform after sufficient measurement time. |
| FR-05-11 | desired | Scope 1 should provide the user with the ability to select one of the accumulated prior beat strips for enlarged viewing. |
| FR-05-12 | optional | Scope 1 may provide the user with an option to display the signal as its absolute value (\|x\|) for improved readability. |
| FR-05-13 | mandatory | Scope 1 shall provide the user with identification of the relevant A and C beats and a visual marker for the C beat. |
| FR-05-14 | mandatory | Scope 1 shall provide the user with the lift angle associated with the displayed beat pattern. |
| FR-05-15 | mandatory | Scope 2 shall provide the user with tic and tac beat noises displayed on two horizontal axes. |
| FR-05-16 | mandatory | Scope 2 shall provide the user with a fixed 20 ms time range. |
| FR-05-17 | mandatory | Scope 2 shall provide the user with an averaging toggle (ON/OFF) via a Σ control. |
| FR-05-18 | mandatory | Scope 2 shall provide the user with combined beat noises that reduce random noise and improve signal clarity when averaging is ON. |
| FR-05-19 | mandatory | Scope 2 shall provide the user with a measurement cycle, determined by the watch's beat number and selected interval, that completes after 50 tic and 50 tac intervals. |
| FR-05-20 | mandatory | Scope 2 shall provide the user with the average amplitude on each horizontal axis using arrows at the end of the cycle. |
| FR-05-21 | desired | Scope 2 should provide the user with the two averaged beat-noise traces without assuming a fixed tic/tac axis assignment. |
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
| FR-07-07 | desired | The Long-Term Performance Graph should provide the user with periodic updates of the graph during the test. |
| FR-07-08 | desired | The Long-Term Performance Graph should provide the user with overall average values. |
| FR-07-09 | desired | The Long-Term Performance Graph should provide the user with a visual indication of the variation range. |
| FR-07-10 | desired | The Long-Term Performance Graph should provide the user with support for long-duration tests. |
| FR-07-11 | desired | The Long-Term Performance Graph should provide the user with a reduced update frequency as elapsed time increases. |

### G08 · Escapement Analyzer and Marker-Line Display
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-08-01 | mandatory | The Escapement Analyzer and Marker-Line Display shall provide the user with a visualization of real-time microphone input. |
| FR-08-02 | mandatory | The Escapement Analyzer and Marker-Line Display shall provide the user with a visualization of stored recording files. |
| FR-08-03 | desired | The Escapement Analyzer and Marker-Line Display should provide the user with a pause/capture mode for analysis. |
| FR-08-04 | mandatory | The Escapement Analyzer and Marker-Line Display shall provide the user with markers at the tick (A) and tock (C) event points to be analyzed. |
| FR-08-05 | mandatory | The Escapement Analyzer and Marker-Line Display shall provide the user with the elapsed time between markers in milliseconds. |
| FR-08-06 | desired | The Escapement Analyzer and Marker-Line Display should provide the user with the ability to change the marker measurement reference based on signal feature points (Onset, Peak, etc.). |

### G09 · Time-Frequency Spectrogram Display
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-09-01 | mandatory | The Time-Frequency Spectrogram Display shall provide the user with a time-frequency spectrogram that shows how the watch's acoustic energy is distributed across time and frequency. |
| FR-09-02 | mandatory | The Time-Frequency Spectrogram Display shall present the spectrogram to the user with time on the horizontal axis, frequency on the vertical axis, and signal strength as color intensity. |
| FR-09-03 | desired | The Time-Frequency Spectrogram Display should provide the user with the ability to inspect either the most recent beat or a selected recent time window. |
| FR-09-04 | desired | The Time-Frequency Spectrogram Display should provide the user with the ability to view recurring energy structures at characteristic frequency ranges. |
| FR-09-05 | desired | The Time-Frequency Spectrogram Display should provide the user with the ability to compare one beat with the next. |
| FR-09-06 | desired | The Time-Frequency Spectrogram Display should provide the user with a color scale or legend for interpreting relative signal strength. |

### G10 · Waveform Comparison Display with Timing Markers
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-10-01 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with multiple beat waveforms presented in aligned lanes. |
| FR-10-02 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with the ability to compare waveform shape across beats. |
| FR-10-03 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with the ability to compare waveform spacing across beats. |
| FR-10-04 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with the ability to compare waveform consistency across beats. |
| FR-10-05 | desired | The Waveform Comparison Display with Timing Markers should provide the user with overlaid waveform displays that include vertical guide markers. |
| FR-10-06 | desired | The Waveform Comparison Display with Timing Markers should provide the user with the rate value. |
| FR-10-07 | desired | The Waveform Comparison Display with Timing Markers should provide the user with the beat error value. |
| FR-10-08 | desired | The Waveform Comparison Display with Timing Markers should provide the user with the beats per hour value. |
| FR-10-09 | desired | The Waveform Comparison Display with Timing Markers should provide the user with the ability to compare successive beats. |
| FR-10-10 | desired | The Waveform Comparison Display with Timing Markers should provide the user with the ability to identify landmarks in the waveform signal. |
| FR-10-11 | desired | The Waveform Comparison Display with Timing Markers should provide the user with the ability to inspect changes in waveform structure between beats. |
| FR-10-12 | desired | The Waveform Comparison Display with Timing Markers should provide the user with the ability to decompose the waveform signal. |
| FR-10-13 | desired | The Waveform Comparison Display with Timing Markers should provide the user with signal envelopes for each beat. |
| FR-10-14 | optional | The Waveform Comparison Display with Timing Markers may provide the user with degree-based reference markers. |
| FR-10-15 | optional | The Waveform Comparison Display with Timing Markers may provide the user with time-based reference markers. |

### G11 · Scope Mode with Synchronized Sweep Display
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-11-01 | mandatory | The Scope Mode with Synchronized Sweep Display shall provide the user with a display of the watch's acoustic signal in a fixed sweep window, similar to an oscilloscope. |
| FR-11-02 | desired | The Scope Mode with Synchronized Sweep Display should provide the user with a display of the processed signal that combines the upper and lower halves of the waveform. |
| FR-11-03 | desired | The Scope Mode with Synchronized Sweep Display should provide the user with the ability to configure the sweep time as a multiple of the watch's tick interval. |
| FR-11-04 | desired | The Scope Mode with Synchronized Sweep Display should provide the user with a synchronized display in which the beat pattern stays visually stable near the nominal rate and drifts when the watch is fast or slow. |
| FR-11-05 | optional | The Scope Mode with Synchronized Sweep Display may provide the user with the daily rate reference value from the most recent timing test. |
| FR-11-06 | optional | The Scope Mode with Synchronized Sweep Display may provide the user with the amplitude reference value from the most recent timing test. |
| FR-11-07 | optional | The Scope Mode with Synchronized Sweep Display may provide the user with the beat error reference value from the most recent timing test. |
| FR-11-08 | optional | The Scope Mode with Synchronized Sweep Display may provide the user with the nominal beat rate reference value from the most recent timing test. |

### G12 · Scope Function with Multiple Filter Views
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-12-01 | mandatory | The Scope Function with Multiple Filter Views shall provide the user with four filter views — F0, F1, F2, F3 — over the same watch signal. |
| FR-12-02 | desired | The Scope Function with Multiple Filter Views should provide the user with the ability to compare how each filter changes the waveform. |
| FR-12-03 | desired | The Scope Function with Multiple Filter Views should provide the user with the ability to compare how each filter changes the visibility of key events (T1, T2, T3). |
| FR-12-04 | mandatory | The Scope Function with Multiple Filter Views shall provide the user with updates of all filter views as measurements are acquired and processed. |
| FR-12-05 | mandatory | The Scope Function with Multiple Filter Views shall provide the user with all filter views rendered from the same input signal data and the same time axis. |
| FR-12-06 | mandatory | F0 shall provide the user with the signal as captured, formatted to fit the screen, treated as the closest available representation of the raw watch signal. |
| FR-12-07 | mandatory | F0 shall provide the user with the signal mirrored symmetrically around its average value. |
| FR-12-08 | mandatory | F1 shall provide the user with a moving-average-filtered view of the F0 signal that smooths the waveform envelope and removes a large portion of background noise. |
| FR-12-09 | mandatory | F2 shall provide the user with a view that builds on F1 by emphasizing rising slopes and attenuating falling slopes to make beat features stand out, especially T3 (and to some extent T2). |
| FR-12-10 | optional | F2 may provide the user with an attenuation function that decays after a local rise. |
| FR-12-11 | mandatory | F3 shall provide the user with a view of only the upper portion of the signal relative to its average value, applying emphasis to rising edges and attenuation to falling portions, to support identification of T1 and especially T3. |
| FR-12-12 | mandatory | Each filter view shall provide the user with its filter label (F0/F1/F2/F3). |
| FR-12-13 | desired | The Scope Function with Multiple Filter Views should provide the user with a UI to display the four filters simultaneously or switch between them for comparison. |
| FR-12-14 | mandatory | The filter views shall provide the user with a Live mode. |
| FR-12-15 | mandatory | The filter views shall provide the user with a Playback mode. |
| FR-12-16 | mandatory | The filter views shall provide the user with a Sim mode. |
| FR-12-17 | desired | The filter views should provide the user with a pause control. |
| FR-12-18 | desired | The filter views should provide the user with navigation through captured data. |
