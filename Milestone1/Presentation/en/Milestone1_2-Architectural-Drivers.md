# Architectural Drivers

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
| FR-G02-01 | mandatory | The Trace Display shall provide the user with a graph of rate deviation over time. |
| FR-G02-02 | mandatory | The Trace Display shall provide the user with a graph of amplitude over time. |
| FR-G02-03 | mandatory | The Trace Display shall provide the user with rate deviation and amplitude as a vertically stacked graph. |
| FR-G02-04 | mandatory | The Trace Display shall provide the user with rate deviation and amplitude as two separate graphs. |
| FR-G02-05 | mandatory | The Trace Display shall provide the user with a smoothing function for the daily rate (s/d) measurement. |
| FR-G02-06 | mandatory | The Trace Display shall provide the user with an alert when the rate indicates the watch is running late. |
| FR-G02-07 | mandatory | The Trace Display shall provide the user with descriptive text or labels for each graph. |
| FR-G02-08 | mandatory | The Trace Display shall provide the user with an average value and a rolling average that updates over time. |
| FR-G02-09 | mandatory | The Trace Display shall provide the user with long-term summary information for both measurements (rate deviation and amplitude). |
| FR-G02-10 | mandatory | The Trace Display shall provide the user with an alert when the measured amplitude falls outside the 270°–300° range. |
 
### G03 · Rate and Amplitude Stability Over Time (Vario Display)
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-G03-01 | mandatory | The Vario Display shall provide the user with information showing the long-term stability of both measurements (rate deviation and amplitude). |
| FR-G03-02 | mandatory | The Vario Display shall provide the user with the minimum value of rate deviation. |
| FR-G03-03 | mandatory | The Vario Display shall provide the user with the maximum value of rate deviation. |
| FR-G03-04 | mandatory | The Vario Display shall provide the user with the average value of rate deviation. |
| FR-G03-05 | mandatory | The Vario Display shall provide the user with the standard deviation of rate deviation. |
| FR-G03-06 | mandatory | The Vario Display shall provide the user with the elapsed measurement time of rate deviation. |
| FR-G03-07 | mandatory | The Vario Display shall provide the user with the current value of rate deviation. |
| FR-G03-08 | mandatory | The Vario Display shall provide the user with the minimum value of amplitude. |
| FR-G03-09 | mandatory | The Vario Display shall provide the user with the maximum value of amplitude. |
| FR-G03-10 | mandatory | The Vario Display shall provide the user with the average value of amplitude. |
| FR-G03-11 | optional | The Vario Display should provide the user with the standard deviation of amplitude. |
| FR-G03-12 | mandatory | The Vario Display shall provide the user with the elapsed measurement time of amplitude. |
| FR-G03-13 | mandatory | The Vario Display shall provide the user with the current value of amplitude. |
| FR-G03-14 | mandatory | The Vario Display shall provide the user with the acceptable minimum–maximum range of each measurement shown as a green zone on the graph. |
| FR-G03-15 | mandatory | The Vario Display shall provide the user with the minimum/maximum value of each measurement shown as blue arrows on the graph. |
| FR-G03-16 | mandatory | The Vario Display shall provide the user with the average value of each measurement shown as a red arrow on the graph. |
| FR-G03-17 | optional | The Vario Display should provide the user with the maximum–minimum difference of each measurement. |
 
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
| FR-04-09 | desired | The Multi-Position Sequence Display should provide the user with indicators that help reveal possible balance-wheel unbalance. |
 
### G05 · Beat-Noise Scope Display
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-G05-01 | mandatory | The Beat-Noise Scope Display shall provide the user with a Beat-Noise Scope tab in the Tabbed Graph Panel that can be displayed without restarting the program. |
| FR-G05-02 | mandatory | The Beat-Noise Scope Display shall provide the user with two related views, Scope 1 and Scope 2. |
| FR-G05-03 | mandatory | The Beat-Noise Scope Display shall provide the user with Live, Playback, and Sim modes, including pause and forward/backward navigation through captured data without data loss. |
| FR-G05-10 | mandatory | Scope 1 shall provide the user with a waveform display of the watch's alternating tick/tock beat noises. |
| FR-G05-11 | mandatory | Scope 1 shall provide the user with selectable time ranges of 20 ms, 200 ms, and 400 ms. |
| FR-G05-12 | mandatory | Scope 1 shall provide the user with the most recent beat noises as small strips beneath the current waveform after sufficient measurement time. |
| FR-G05-13 | mandatory | Scope 1 shall provide the user with the ability to select one of the accumulated prior beat strips for enlarged viewing. |
| FR-G05-14 | mandatory | Scope 1 shall provide the user with an option to display the signal as its absolute value (\|x\|) for improved readability. |
| FR-G05-15 | mandatory | Scope 1 shall provide the user with identification of the relevant A and C beats and a visual marker for the C beat. |
| FR-G05-16 | mandatory | Scope 1 shall provide the user with the lift angle associated with the displayed beat pattern. |
| FR-G05-20 | mandatory | Scope 2 shall provide the user with tic and tac beat noises displayed on two horizontal axes. |
| FR-G05-21 | mandatory | Scope 2 shall provide the user with a fixed 20 ms time range. |
| FR-G05-22 | mandatory | Scope 2 shall provide the user with an averaging toggle (ON/OFF) via a Σ control. |
| FR-G05-23 | mandatory | Scope 2 shall provide the user with combined beat noises that reduce random noise and improve signal clarity when averaging is ON. |
| FR-G05-24 | mandatory | Scope 2 shall provide the user with a measurement cycle, determined by the watch's beat number and selected interval, that completes after 50 tic and 50 tac intervals. |
| FR-G05-25 | mandatory | Scope 2 shall provide the user with the average amplitude on each horizontal axis using arrows at the end of the cycle. |
| FR-G05-26 | mandatory | Scope 2 shall provide the user with the two averaged beat-noise traces without assuming a fixed tic/tac axis assignment. |
| FR-G05-27 | mandatory | Scope 2 shall provide the user with intermediate averaging results, such as after 10 or 20 intervals. |
 
### G06 · Beat Error Display and Diagnostic Trace
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-G06-01 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with a beat error display and a diagnostic trace. |
| FR-G06-02 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with the rate, amplitude, beat error, and BPH values with numbers and units. |
| FR-G06-03 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with tick/tock trace lines that represent the watch's timing behavior. |
| FR-G06-04 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with the measurement values (rate, amplitude, beat error, BPH) and the tick/tock trace lines simultaneously. |
| FR-G06-05 | optional | The Beat Error Display and Diagnostic Trace should provide the user with the tick and tock trace lines as visually distinguished elements. |
| FR-G06-06 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with the spacing between the tick/tock trace lines. |
| FR-G06-07 | optional | The Beat Error Display and Diagnostic Trace should provide the user with the ability to configure the acceptable range of the trace-line spacing. |
| FR-G06-08 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with a defined acceptable range for the trace-line spacing. |
| FR-G06-09 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with a warning when the trace-line spacing exceeds the acceptable range. |
| FR-G06-10 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with the slope of the trace lines. |
| FR-G06-11 | mandatory | The Beat Error Display and Diagnostic Trace shall provide the user with a fault-state indication when the trace-line slope reaches 45 degrees or more. |
 
### G07 · Long-Term Performance Graph
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-G07-01 | mandatory | The Long-Term Performance Graph shall provide the user with a long-term performance graph. |
| FR-G07-02 | mandatory | The Long-Term Performance Graph shall provide the user with a display of the long-term performance graph. |
| FR-G07-03 | mandatory | The Long-Term Performance Graph shall provide the user with a recording of the watch's rate over an extended period of time. |
| FR-G07-04 | mandatory | The Long-Term Performance Graph shall provide the user with a recording of the watch's amplitude over an extended period of time. |
| FR-G07-05 | mandatory | The Long-Term Performance Graph shall provide the user with a recording of the watch's beat error over an extended period of time. |
| FR-G07-06 | mandatory | The Long-Term Performance Graph shall provide the user with the changes in rate over time. |
| FR-G07-07 | mandatory | The Long-Term Performance Graph shall provide the user with the changes in amplitude over time. |
| FR-G07-08 | mandatory | The Long-Term Performance Graph shall provide the user with the changes in beat error over time. |
| FR-G07-09 | optional | The Long-Term Performance Graph should provide the user with periodic updates of the graph during the test. |
| FR-G07-10 | optional | The Long-Term Performance Graph should provide the user with overall average values. |
| FR-G07-11 | optional | The Long-Term Performance Graph should provide the user with a visual indication of the variation range. |
| FR-G07-12 | optional | The Long-Term Performance Graph should provide the user with support for long-duration tests. |
| FR-G07-13 | mandatory | The Long-Term Performance Graph shall provide the user with a reduced update frequency as elapsed time increases. |
| FR-G07-14 | optional | The Long-Term Performance Graph should provide the user with maintained readability. |
 
### G08 · Escapement Analyzer and Marker-Line Display
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-G08-01 | mandatory | The Escapement Analyzer and Marker-Line Display shall provide the user with a visualization of real-time microphone input. |
| FR-G08-02 | mandatory | The Escapement Analyzer and Marker-Line Display shall provide the user with a visualization of stored recording files. |
| FR-G08-03 | mandatory | The Escapement Analyzer and Marker-Line Display shall provide the user with a pause/capture mode for analysis. |
| FR-G08-05 | mandatory | The Escapement Analyzer and Marker-Line Display shall provide the user with vertical markers at the tick (A) and tock (C) event points to be analyzed. |
| FR-G08-06 | mandatory | The Escapement Analyzer and Marker-Line Display shall provide the user with the elapsed time between markers in milliseconds. |
| FR-G08-07 | mandatory | The Escapement Analyzer and Marker-Line Display shall provide the user with the ability to change the marker measurement reference based on signal feature points (Onset, Peak, etc.). |

### G09 · Time-Frequency Spectrogram Display
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-G09-01 | mandatory | The Time-Frequency Spectrogram Display shall provide the user with a time-frequency spectrogram that shows how the watch's acoustic energy is distributed across time and frequency. |
| FR-G09-02 | mandatory | The Time-Frequency Spectrogram Display shall present the spectrogram to the user with time on the horizontal axis, frequency on the vertical axis, and signal strength as color intensity. |
| FR-G09-03 | optional | The Time-Frequency Spectrogram Display should provide the user with the ability to inspect either the most recent beat or a selected recent time window. |
| FR-G09-04 | optional | The Time-Frequency Spectrogram Display should provide the user with the ability to view recurring energy structures at characteristic frequency ranges. |
| FR-G09-05 | optional | The Time-Frequency Spectrogram Display should provide the user with the ability to compare one beat with the next. |
| FR-G09-06 | optional | The Time-Frequency Spectrogram Display should provide the user with a color scale or legend for interpreting relative signal strength. |
 
### G10 · Waveform Comparison Display with Timing Markers
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-G10-01 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with a waveform comparison display that includes timing markers. |
| FR-G10-02 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with multiple beat waveforms presented in aligned lanes. |
| FR-G10-03 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with the ability to compare waveform shape across beats. |
| FR-G10-04 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with the ability to compare waveform spacing across beats. |
| FR-G10-05 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with the ability to compare waveform consistency across beats. |
| FR-G10-06 | optional | The Waveform Comparison Display with Timing Markers should provide the user with overlaid waveform displays that include vertical guide markers. |
| FR-G10-07 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with the rate value. |
| FR-G10-08 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with the beat error value. |
| FR-G10-09 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with the beats per hour value. |
| FR-G10-10 | optional | The Waveform Comparison Display with Timing Markers should provide the user with the ability to compare successive beats. |
| FR-G10-11 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with the ability to identify landmarks in the waveform signal. |
| FR-G10-12 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with the ability to inspect changes in waveform structure between beats. |
| FR-G10-13 | optional | The Waveform Comparison Display with Timing Markers should provide the user with the ability to decompose the waveform signal. |
| FR-G10-14 | mandatory | The Waveform Comparison Display with Timing Markers shall provide the user with signal envelopes for each beat. |
| FR-G10-15 | optional | The Waveform Comparison Display with Timing Markers may provide the user with degree-based reference markers. |
| FR-G10-16 | optional | The Waveform Comparison Display with Timing Markers may provide the user with time-based reference markers. |

### G11 · Scope Mode with Synchronized Sweep Display
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-G11-01 | mandatory | The Scope Mode with Synchronized Sweep Display shall provide the user with a display of the watch's acoustic signal in a fixed sweep window, similar to an oscilloscope. |
| FR-G11-02 | optional | The Scope Mode with Synchronized Sweep Display should provide the user with a display of the processed signal that combines the upper and lower halves of the waveform. |
| FR-G11-03 | optional | The Scope Mode with Synchronized Sweep Display should provide the user with the ability to configure the sweep time as a multiple of the watch's tick interval. |
| FR-G11-04 | optional | The Scope Mode with Synchronized Sweep Display should provide the user with a synchronized display in which the beat pattern stays visually stable near the nominal rate and drifts when the watch is fast or slow. |
| FR-G11-05 | optional | The Scope Mode with Synchronized Sweep Display may provide the user with reference values (daily rate, amplitude, beat error, nominal beat rate) from the most recent timing test. |

### G12 · Scope Function with Multiple Filter Views
| ID | Grade | Requirement |
|----|-------|-------------|
| FR-G12-01 | mandatory | The Scope Function with Multiple Filter Views shall provide the user with four filter views — F0, F1, F2, F3 — over the same watch signal. |
| FR-G12-02 | mandatory | The Scope Function with Multiple Filter Views shall provide the user with the ability to switch among the four filters and compare how each one changes the waveform and the visibility of key events (T1, T2, T3). |
| FR-G12-03 | mandatory | The Scope Function with Multiple Filter Views shall provide the user with real-time updates of all filter views as measurements are acquired and processed. |
| FR-G12-04 | mandatory | The Scope Function with Multiple Filter Views shall provide the user with all filter views rendered from the same input signal data and the same time axis. |
| FR-G12-10 | mandatory | F0 shall provide the user with the signal as captured, formatted to fit the screen and mirrored symmetrically around its average value, treated as the closest available representation of the raw watch signal. |
| FR-G12-11 | mandatory | F1 shall provide the user with a moving-average-filtered view of the F0 signal that smooths the waveform envelope and removes a large portion of background noise. |
| FR-G12-12 | mandatory | The Scope Function with Multiple Filter Views shall provide the user with documentation noting that low-amplitude signal components may become less visible in F1 mode. |
| FR-G12-13 | mandatory | F2 shall provide the user with a view that builds on F1 by emphasizing rising slopes and attenuating falling slopes to make beat features stand out, especially T3 (and to some extent T2). |
| FR-G12-14 | optional | F2 may provide the user with an attenuation function that decays after a local rise. |
| FR-G12-15 | mandatory | F3 shall provide the user with a view of only the upper portion of the signal relative to its average value, applying emphasis to rising edges and attenuation to falling portions, to support identification of T1 and especially T3. |
| FR-G12-20 | mandatory | Each filter view shall provide the user with its filter label (F0/F1/F2/F3). |
| FR-G12-21 | mandatory | The Scope Function with Multiple Filter Views shall provide the user with a UI to display the four filters simultaneously or switch between them for comparison. |
| FR-G12-22 | mandatory | The filter views shall provide the user with Live, Playback, and Sim modes, including pause and navigation through captured data. |
