# Wednesday Final Demo Runbook

[English](3-Wednesday-Runbook.md) | [한국어](3-Wednesday-Runbook.ko.md)

This runbook is the scoring-first operating version for Wednesday.

Known scoring priority from the team: **demo 350 points, presentation 150 points**.
The available rubric mixes demo and presentation evidence, so the safest strategy is:

1. Run the **demo in rubric order** so graders can check items while watching.
2. Use the **presentation to explain the architecture, tradeoffs, evidence, and AI use** behind what they just saw.
3. Repeat the rubric area name out loud at every transition.

## Operating Principle

Say this early:

> "We organized the demo in the same order as the rubric, so you can check each scoring item as we show it."

Do not make the grader infer why a screen matters. For every screen, say:

> "This covers rubric Area X: [item name]."

## Team Roles

| Role | Job |
|---|---|
| Presenter | Speaks the English scoring lines. Does not operate the mouse unless needed. |
| Operator | Runs the app, switches tabs, handles live/playback/simulation fallback. |
| Evidence navigator | Opens slide/evidence screenshots if the live path fails or time is short. |

## Demo Hardware And Backup Stack

Primary demo path:

- Raspberry Pi 5 target platform
- USB microphone or watch sensor
- Real mechanical watch
- TimeGrapher app on `main`
- Witschi or equivalent commercial reference if available

Backup path, in this order:

1. Live input on Pi.
2. Playback WAV recorded from the same watch.
3. Simulation mode for deterministic screens.
4. Static evidence slide/screenshot only if the app cannot show the item live.

Use the backup path without apologizing. Say:

> "For repeatability in the scoring room, I am switching to playback/simulation for this item. It exercises the same analysis pipeline and display path."

## Demo Timing Plan For 350 Points

Assume a 20 minute demo unless the schedule gives more time. If time changes, keep the order and scale the middle sections.

| Time | Rubric | Demo Goal |
|---:|---|---|
| 0:00-1:00 | Setup | State target platform, live input, and rubric-order plan. |
| 1:00-8:30 | Area 1 | Show all 12 required real-time graphs/diagnostic displays. |
| 8:30-11:00 | Area 2 | Show Sound Print improvement, Rate/Scope improvement, ONNX signal-quality classifier path. |
| 11:00-13:00 | Area 3 | State accuracy-first tradeoffs in the live app. |
| 13:00-15:00 | Area 4 | Show Pi latency/performance/correctness evidence. |
| 15:00-16:15 | Area 5 | Show extensibility through tab catalog/frame consumer pattern. |
| 16:15-18:15 | Area 6 | Show GUI improvements, unplug/replug, A/C markers, health/readiness feedback. |
| 18:15-19:00 | Area 7 | State AI use in product and development, with verification. |
| 19:00-20:00 | Area 8 + Bonus | Show UI polish, Health radar, diagnosis/classification if enabled. |

## Demo Script

### 0. Opening

Operator:

- Show app already running on Raspberry Pi 5.
- Confirm input mode is Live if possible.
- Keep Witschi/reference device visible if available.

Presenter:

> "Good morning. We are Team 5. This is TimeGrapher: it listens to a mechanical watch and measures rate, amplitude, beat error, and signal quality in real time."

> "The most important grading item today is the live demo, so we organized this demonstration in rubric order. I will call out each rubric area as we cover it."

> "The primary path is live input on Raspberry Pi 5. If room noise or hardware setup interferes, we will switch to playback or simulation for repeatability; those modes use the same analysis and display pipeline."

### 1. Area 1 - Required Real-Time Graphs And Diagnostic Displays

Goal: do not linger. This is a scoring sweep. About 30 to 35 seconds per item.

Say before the sweep:

> "Area 1 is the required real-time graph and diagnostic display set. We will now run through all twelve required displays."

| Rubric item | App tab | What to point at | Presenter line |
|---|---|---|---|
| Watch-Position Testing | Positions | Six position controls, selected position, 3D watch orientation | "This covers Watch-Position Testing. The selected watch position, label, and rendered orientation stay synchronized, so the user can record how the same watch behaves in each physical position." |
| Trace Display | Trace | Rate trace, amplitude trace, acceptable bands | "This covers Trace Display. Rate and amplitude are tracked over elapsed time, with acceptable bands and stability context rather than a single momentary number." |
| Rate and Amplitude Stability Over Time | Vario | Min/max/spread/average/current, verdict badges | "This covers Rate and Amplitude Stability. Vario summarizes spread, average, sigma, and current value so the user can judge whether the watch is stable." |
| Multi-Position Sequence Display | Positions | Per-position table or sequence summary | "This covers Multi-Position Sequence. The app stores readings per position and summarizes cross-position consistency." |
| Beat-Noise Scope Display | Beat Noise | Beat waveform, recent beat strip, A/C markers, average envelope | "This covers Beat-Noise Scope. It lets us inspect individual beats and averaged envelopes, with A and C markers showing timing repeatability." |
| Beat Error Display and Diagnostic Trace | Beat Error | Beat error value, tic/toc difference, diagnostic trace | "This covers Beat Error Display and Diagnostic Trace. It shows the signed beat error and the timing evidence behind it." |
| Long-Term Performance Graph | Long-Term | Rate/amplitude/beat-error panes, trend lines | "This covers Long-Term Performance. The session history is preserved and summarized for longer-running behavior." |
| Escapement Analyzer and Marker-Line Display | Escapement | A marker, C peak/onset marker, repeatability stats | "This covers Escapement Analyzer. The marker lines make the internal timing of each beat inspectable." |
| Time-Frequency Spectrogram Display | Spectrogram | Time axis, frequency axis, color intensity | "This covers Spectrogram. It shows how the watch sound energy changes over time and frequency." |
| Waveform Comparison Display with Timing Markers | Waveforms | Stacked beats, A alignment, C markers | "This covers Waveform Comparison. Recent beats are aligned so timing drift or irregularity is visible." |
| Scope Mode with Synchronized Sweep Display | Sweep | 1x/2x/3x sweep, stable triggered waveform | "This covers synchronized Sweep. The beat waveform is folded into a trigger-like scope view so repeated cycles sit still." |
| Scope Function with Multiple Filter Views | Filter Scope | Four filter views | "This covers Multiple Filter Views. The same signal is shown through several processing views to make different beat features visible." |

Close Area 1:

> "That is the full Area 1 set: twelve required displays, driven by the same live analysis frame rather than separate calculators."

### 2. Area 2 - System Enhancements And AI Feature

Presenter:

> "Area 2 asks for system enhancements and an AI feature. We show three things: Sound Print improvement, Rate/Scope improvement, and an on-device signal-quality classifier."

Sound Print:

> "Sound Print is improved with persistent event-marker overlays and a responsive image update path. The marker mapping follows the same sample-to-column conversion as the waveform, so the markers explain the sound image instead of floating separately from it."

Rate/Scope:

> "Rate/Scope is improved for measurement clarity and responsiveness. The display keeps the live signal, trigger threshold, event markers, and tic/toc rate points together, while rendering stays bounded so the Pi remains responsive."

AI feature:

> "The AI feature is an on-device ONNX signal-quality classifier. The app loads the ONNX model at the composition root and falls back to a deterministic heuristic if the model cannot load."

> "The safety point is important: the classifier is advisory. It annotates whether the live readings should be trusted, but it does not create beats, retime beats, or move the BPH/PLL lock. A bad model prediction cannot move the measured rate, amplitude, or beat error."

Show if visible:

- Signal quality warning/overlay/readiness text.
- If warning is not visible in clean signal, say it is clean and therefore no warning is expected.

### 3. Area 3 - Quality Attribute Tradeoffs

Keep this short in the demo. The presentation expands it.

Presenter:

> "Area 3 is quality-attribute tradeoffs. Our highest priority is measurement accuracy. That led to several deliberate tradeoffs: we accept warm-up time before trusting BPH, we spend CPU on higher sample rates when needed, and when the system is under load we degrade visualization first, not measurement."

> "The live app shows that decision: the measured values come from one analysis frame, and display tabs interpret that frame rather than recalculating competing answers."

### 4. Area 4 - Performance, Latency, Correctness

Presenter:

> "Area 4 is performance, latency, and correctness. This is running on the Raspberry Pi 5 target platform."

Show latency/readiness if visible. Then say:

> "Our recorded RPi5 technical experiment shows 43200 BPH at 192 kHz passing with a worst-case end-to-end latency of 36.46 ms against an 83.333 ms one-beat-period budget. Drop count was zero and miss count was zero."

Correctness:

If Witschi comparison is ready:

> "For correctness, we compare the same watch against the Witschi reference and show rate, amplitude, and beat error side by side."

If not ready:

> "For correctness, the clean synthetic reference pass is complete. The Witschi commercial comparison is the remaining real-world validation item, and we report it as a remaining limitation rather than hiding it."

### 5. Area 5 - Extensibility

Do not spend long in demo. A quick code or architecture slide is enough.

Presenter:

> "Area 5 is architecture extensibility. A new display is local: add a tab catalog entry, a frame consumer if needed, and a renderer over the existing immutable analysis frame. The Core engine stays independent of UI and platform code."

If showing code, point at `InfoTabCatalog.cs` and one renderer/consumer.

> "This is why we could add many displays without creating separate pipelines or changing the detector for every view."

### 6. Area 6 - Remote UI / GUI Modifications

Presenter:

> "Area 6 is GUI modification and operational usability."

Show these in order:

1. Layout/readability improvements.
2. Device disconnect/reconnect if safe.
3. A/C beat-synchronized markers.
4. Handling-noise or signal-quality feedback.
5. Health/readiness/status feedback.

Lines:

> "The GUI is designed for repeated measurement work: controls are grouped, unnecessary controls move into settings, and the active measurement state remains visible."

> "Now we disconnect the microphone. The app reports the device problem, stops cleanly, and can recover after reconnect. No crash, no frozen graph."

> "The A/C markers are synchronized to the beat cycle across Beat Noise, Escapement, and Waveforms, so the same timing interpretation is visible in multiple views."

> "The signal-quality feedback tells the user when the measurement should be trusted, instead of silently showing suspicious values."

### 7. Area 7 - AI In Building The Software

Presenter:

> "Area 7 asks how we used AI in building the software. We used AI for porting support, debugging, test generation, documentation review, and CI/CD workflow design. But every AI-assisted result was checked by tests, Verify runs, architecture boundary tests, and live Pi measurements."

> "We treated AI as a fast collaborator, not as an authority."

### 8. Area 8 + Bonus

Area 8:

> "For Best UI, the goal is not decorative UI; it is a watchmaker-style tool that makes measurement state readable quickly."

Bonus if Health tab is enabled:

> "For the bonus, Health radar uses multi-position readings to summarize the watch condition across positions. Diagnosis/classification then turns readings into an interpretation the user can act on."

If Health is not stable on demo day:

> "The diagnosis/classification path is represented by signal-quality and measurement-readiness feedback. We will not claim a bonus screen that is not stable in the live build."

Closing:

> "To summarize the demo: we covered the rubric in order, showed the required displays, showed enhancements and ONNX signal-quality classification, demonstrated the Pi performance story, and connected the UI back to the architecture. The presentation now explains the architectural evidence behind it."

## What Not To Say

- Do not say CI/CD proves measurement accuracy. Say it protects regressions after runtime validation.
- Do not say the AI controls timing. It is advisory and cannot retime beats.
- Do not say Witschi comparison is complete unless the table is ready.
- Do not say every architecture pattern is perfectly applied. Say where it is intentionally partial.
- Do not use the banned P-o-C wording; say "AI feature path", "technical experiment", or "adoption gate".

## Wednesday Readiness Checklist

Before demo day:

- [ ] Confirm app launches on Raspberry Pi 5.
- [ ] Confirm live microphone path works.
- [ ] Prepare playback WAV fallback.
- [ ] Prepare simulation fallback.
- [ ] Confirm 12 display tabs are visible.
- [ ] Confirm Health tab is visible or remove bonus claim.
- [ ] Confirm ONNX model loads or know the fallback message.
- [ ] Prepare Witschi comparison table or mark it as remaining validation.
- [ ] Print or pin the Area 1 twelve-item checklist for the operator.
- [ ] Rehearse the 20 minute timing twice.
