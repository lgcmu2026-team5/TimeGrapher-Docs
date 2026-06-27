# 수요일 최종 데모 운영본

[English](3-Wednesday-Runbook.md) | [한국어](3-Wednesday-Runbook.ko.md)

이 문서는 수요일 최종 데모를 **채점 우선**으로 운영하기 위한 한국어 버전이다.

팀 기준으로 확인된 점수 비중:

- **데모 350점**
- **발표 150점**

루브릭에는 데모에서 보여줄 내용과 발표에서 설명할 내용이 조금 섞여 있다. 그래서 가장 안전한 전략은 다음과 같다.

1. **데모는 루브릭 순서대로** 진행해서 채점자가 보면서 바로 체크할 수 있게 한다.
2. **발표는 방금 본 데모 뒤의 아키텍처, tradeoff, 근거, AI 사용 방식**을 설명한다.
3. 각 구간이 바뀔 때마다 반드시 rubric area 이름을 입으로 말한다.

## 운영 원칙

데모 초반에 반드시 말할 문장:

> "We organized the demo in the same order as the rubric, so you can check each scoring item as we show it."

채점자가 화면의 의미를 추측하게 두지 않는다. 화면마다 다음 구조로 말한다.

> "This covers rubric Area X: [item name]."

## 팀 역할

| 역할 | 할 일 |
|---|---|
| Presenter | 채점용 영어 문장을 말한다. 필요할 때가 아니면 마우스를 잡지 않는다. |
| Operator | 앱 조작, tab 전환, live/playback/simulation fallback 처리 |
| Evidence navigator | live path가 실패하거나 시간이 부족할 때 evidence slide/screenshot을 연다. |

## 데모 하드웨어 및 백업 경로

기본 데모 경로:

- Raspberry Pi 5 target platform
- USB microphone 또는 watch sensor
- 실제 mechanical watch
- `main` 기준 TimeGrapher 앱
- 가능하면 Witschi 또는 동급 commercial reference

백업 경로 우선순위:

1. Pi에서 Live input
2. 같은 watch로 녹음한 Playback WAV
3. deterministic 화면을 위한 Simulation mode
4. 앱에서 직접 보여줄 수 없을 때만 static evidence slide/screenshot

백업으로 전환할 때는 미안해하지 말고 이렇게 말한다.

> "For repeatability in the scoring room, I am switching to playback/simulation for this item. It exercises the same analysis pipeline and display path."

## 350점 데모 시간 계획

데모는 **20분 고정**으로 가정한다. 시간이 바뀌어도 순서는 유지하고 중간 구간만 압축/확장한다.

| 시간 | 루브릭 | 데모 목표 |
|---:|---|---|
| 0:00-1:00 | Setup | target platform, live input, rubric-order plan 선언 |
| 1:00-8:30 | Area 1 | 12개 필수 real-time graph/diagnostic display 전부 시연 |
| 8:30-11:00 | Area 2 | Sound Print 개선, Rate/Scope 개선, ONNX signal-quality classifier path |
| 11:00-13:00 | Area 3 | live app 기준 accuracy-first tradeoff 설명 |
| 13:00-15:00 | Area 4 | Pi latency/performance/correctness evidence |
| 15:00-16:15 | Area 5 | tab catalog/frame consumer 구조로 extensibility 설명 |
| 16:15-18:15 | Area 6 | GUI 개선, unplug/replug, A/C markers, health/readiness feedback |
| 18:15-19:00 | Area 7 | AI 사용 방식과 검증 설명 |
| 19:00-20:00 | Area 8 + Bonus | UI polish, Health radar, diagnosis/classification 가능하면 시연 |

## 데모 대본

### 0. Opening

Operator:

- Raspberry Pi 5에서 앱이 이미 실행된 상태를 보여준다.
- 가능하면 input mode가 Live인지 확인한다.
- Witschi/reference 장비가 있으면 화면 또는 옆에 보이게 둔다.

Presenter:

> "Good morning. We are Team 5. This is TimeGrapher: it listens to a mechanical watch and measures rate, amplitude, beat error, and signal quality in real time."

> "The most important grading item today is the live demo, so we organized this demonstration in rubric order. I will call out each rubric area as we cover it."

> "The primary path is live input on Raspberry Pi 5. If room noise or hardware setup interferes, we will switch to playback or simulation for repeatability; those modes use the same analysis and display pipeline."

### 1. Area 1 - Required Real-Time Graphs And Diagnostic Displays

목표: 오래 머물지 않는다. 채점 항목을 빠르게 체크시키는 sweep이다. 항목당 30-35초 정도.

sweep 시작 전에 말할 문장:

> "Area 1 is the required real-time graph and diagnostic display set. We will now run through all twelve required displays."

| Rubric item | App tab | 가리킬 부분 | Presenter line |
|---|---|---|---|
| Watch-Position Testing | Positions | 6개 position control, selected position, 3D watch orientation | "This covers Watch-Position Testing. The selected watch position, label, and rendered orientation stay synchronized, so the user can record how the same watch behaves in each physical position." |
| Trace Display | Trace | rate trace, amplitude trace, acceptable bands | "This covers Trace Display. Rate and amplitude are tracked over elapsed time, with acceptable bands and stability context rather than a single momentary number." |
| Rate and Amplitude Stability Over Time | Vario | min/max/spread/average/current, verdict badges | "This covers Rate and Amplitude Stability. Vario summarizes spread, average, sigma, and current value so the user can judge whether the watch is stable." |
| Multi-Position Sequence Display | Positions | per-position table 또는 sequence summary | "This covers Multi-Position Sequence. The app stores readings per position and summarizes cross-position consistency." |
| Beat-Noise Scope Display | Beat Noise | beat waveform, recent beat strip, A/C markers, average envelope | "This covers Beat-Noise Scope. It lets us inspect individual beats and averaged envelopes, with A and C markers showing timing repeatability." |
| Beat Error Display and Diagnostic Trace | Beat Error | beat error value, tic/toc difference, diagnostic trace | "This covers Beat Error Display and Diagnostic Trace. It shows the signed beat error and the timing evidence behind it." |
| Long-Term Performance Graph | Long-Term | rate/amplitude/beat-error panes, trend lines | "This covers Long-Term Performance. The session history is preserved and summarized for longer-running behavior." |
| Escapement Analyzer and Marker-Line Display | Escapement | A marker, C peak/onset marker, repeatability stats | "This covers Escapement Analyzer. The marker lines make the internal timing of each beat inspectable." |
| Time-Frequency Spectrogram Display | Spectrogram | time axis, frequency axis, color intensity | "This covers Spectrogram. It shows how the watch sound energy changes over time and frequency." |
| Waveform Comparison Display with Timing Markers | Waveforms | stacked beats, A alignment, C markers | "This covers Waveform Comparison. Recent beats are aligned so timing drift or irregularity is visible." |
| Scope Mode with Synchronized Sweep Display | Sweep | 1x/2x/3x sweep, stable triggered waveform | "This covers synchronized Sweep. The beat waveform is folded into a trigger-like scope view so repeated cycles sit still." |
| Scope Function with Multiple Filter Views | Filter Scope | four filter views | "This covers Multiple Filter Views. The same signal is shown through several processing views to make different beat features visible." |

Area 1 마무리 문장:

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

화면에서 보이면 보여줄 것:

- Signal quality warning/overlay/readiness text
- clean signal이라 warning이 없으면, "clean input이므로 warning이 없는 것이 정상"이라고 말한다.

### 3. Area 3 - Quality Attribute Tradeoffs

데모에서는 짧게만 말한다. 자세한 설명은 발표에서 한다.

Presenter:

> "Area 3 is quality-attribute tradeoffs. Our highest priority is measurement accuracy. That led to several deliberate tradeoffs: we accept warm-up time before trusting BPH, we spend CPU on higher sample rates when needed, and when the system is under load we degrade visualization first, not measurement."

> "The live app shows that decision: the measured values come from one analysis frame, and display tabs interpret that frame rather than recalculating competing answers."

### 4. Area 4 - Performance, Latency, Correctness

Presenter:

> "Area 4 is performance, latency, and correctness. This is running on the Raspberry Pi 5 target platform."

latency/readiness가 화면에 보이면 가리킨다. 이어서 말한다.

> "Our recorded RPi5 technical experiment shows 43200 BPH at 192 kHz passing with a worst-case end-to-end latency of 36.46 ms against an 83.333 ms one-beat-period budget. Drop count was zero and miss count was zero."

Correctness:

Witschi comparison이 준비된 경우:

> "For correctness, we compare the same watch against the Witschi reference and show rate, amplitude, and beat error side by side."

준비되지 않은 경우:

> "For correctness, the clean synthetic reference pass is complete. The Witschi commercial comparison is the remaining real-world validation item, and we report it as a remaining limitation rather than hiding it."

### 5. Area 5 - Extensibility

데모에서는 길게 하지 않는다. code 또는 architecture slide를 짧게 보여주면 충분하다.

Presenter:

> "Area 5 is architecture extensibility. A new display is local: add a tab catalog entry, a frame consumer if needed, and a renderer over the existing immutable analysis frame. The Core engine stays independent of UI and platform code."

code를 보여줄 경우 `InfoTabCatalog.cs`와 renderer/consumer 하나를 가리킨다.

> "This is why we could add many displays without creating separate pipelines or changing the detector for every view."

### 6. Area 6 - Remote UI / GUI Modifications

Presenter:

> "Area 6 is GUI modification and operational usability."

다음 순서로 보여준다.

1. Layout/readability improvements
2. Device disconnect/reconnect, 안전할 때만
3. A/C beat-synchronized markers
4. Handling-noise 또는 signal-quality feedback
5. Health/readiness/status feedback

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

Health tab이 안정적인 경우:

> "For the bonus, Health radar uses multi-position readings to summarize the watch condition across positions. Diagnosis/classification then turns readings into an interpretation the user can act on."

Health가 데모 당일 안정적이지 않은 경우:

> "The diagnosis/classification path is represented by signal-quality and measurement-readiness feedback. We will not claim a bonus screen that is not stable in the live build."

Closing:

> "To summarize the demo: we covered the rubric in order, showed the required displays, showed enhancements and ONNX signal-quality classification, demonstrated the Pi performance story, and connected the UI back to the architecture. The presentation now explains the architectural evidence behind it."

## 말하면 안 되는 것

- CI/CD가 measurement accuracy를 증명한다고 말하지 않는다. Runtime validation 이후 regression을 막는 장치라고 말한다.
- AI가 timing을 제어한다고 말하지 않는다. Advisory이며 beat를 retime할 수 없다고 말한다.
- Witschi comparison table이 준비되지 않았는데 완료됐다고 말하지 않는다.
- 모든 architecture pattern이 완벽히 적용됐다고 말하지 않는다. 일부는 intentional partial application이라고 말한다.
- 금지된 P-o-C 표현을 쓰지 않는다. "AI feature path", "technical experiment", "adoption gate"라고 말한다.

## 수요일 준비 체크리스트

데모 전:

- [ ] Raspberry Pi 5에서 앱 실행 확인
- [ ] Live microphone path 확인
- [ ] Playback WAV fallback 준비
- [ ] Simulation fallback 준비
- [ ] 12개 display tab이 보이는지 확인
- [ ] Health tab이 보이는지 확인하거나 bonus claim 제거
- [ ] ONNX model이 load되는지 확인하거나 fallback 문장 준비
- [ ] Witschi comparison table 준비 또는 remaining validation으로 표시
- [ ] Operator가 볼 Area 1 twelve-item checklist 출력 또는 화면 고정
- [ ] 20분 timing으로 두 번 리허설

