# 수요일 예상 질문 및 즉석 동작 시나리오

전제:

- 데모: **20분**
- 발표: **20분**
- 평가자가 데모 중간에 "그거 해봐요", "이 경우는요?", "이 화면에서 바꿔보세요"처럼 즉석 동작을 요구할 수 있음
- 대응 원칙은 **짧게 답하고, 바로 화면으로 증명**하는 것

핵심 문장:

> "Sure. I will show that directly in the running app."

불안정하거나 준비 안 된 요구는 이렇게 처리:

> "For repeatability in this room, I will switch to playback/simulation. It uses the same analysis and display pipeline."

## 1. 데모 중 즉석 동작 요구 대응표

| 평가자 요구 | 바로 할 동작 | 보여줄 화면 | 말할 문장 |
|---|---|---|---|
| "Start from scratch." | Stop/Reset 후 Start | Rate/Scope, status bar | "I am restarting the run. The app warms up, locks BPH, and then publishes trusted readings." |
| "Pause and resume." | Pause 클릭 후 Resume/Start | Trace 또는 Long-Term | "Pause stops live updates without losing the session context; resume continues measurement." |
| "Switch to another tab." | 요구한 tab으로 즉시 이동 | 해당 tab | "All tabs are reading the same analysis frame, so this is another interpretation of the same measurement." |
| "Show all required displays." | Area 1 checklist 순서대로 빠르게 tab 이동 | 12개 tab | "This is the rubric Area 1 sweep; each screen maps to one required display." |
| "Use a different watch position." | Positions에서 다른 position 선택 | Positions | "The selected position, label, and 3D orientation stay synchronized." |
| "Show multi-position result." | Positions의 sequence/summary 영역 가리킴 | Positions | "The system stores readings per position and compares cross-position consistency." |
| "Show beat error." | Beat Error tab 이동 | Beat Error | "This is the signed beat error and the tic/toc timing evidence behind it." |
| "Show the beat waveform." | Beat Noise 또는 Waveforms 이동 | Beat Noise/Waveforms | "Here the A/C markers reveal whether beat timing is repeatable." |
| "Show spectrogram." | Spectrogram tab 이동 | Spectrogram | "This is time-frequency energy; beat energy appears as periodic vertical bursts." |
| "Show filter views." | Filter Scope tab 이동 | Filter Scope | "Same input, four filter views, one synchronized measurement path." |
| "Zoom or change sweep." | Sweep 1x/2x/3x 전환 | Sweep | "The waveform remains synchronized to the beat period while the window changes." |
| "Change settings or thresholds." | Settings/accept band 열기 | Settings or graph band | "The accept bands are shared, so verdicts and graph warnings use the same thresholds." |
| "Use playback instead of live." | Input을 Playback으로 변경, WAV 선택, Start | Rate/Scope | "Playback is our repeatable fallback; it exercises the same analysis pipeline." |
| "Use simulation." | Simulation 선택 후 Start | Rate/Scope + tabs | "Simulation gives a deterministic signal so we can demonstrate behavior without room-noise risk." |
| "Unplug the microphone." | 안전하면 USB mic 제거 | Status/device list | "The app detects the device loss, stops cleanly, and reports what the user should do." |
| "Plug it back in." | USB mic 재연결, device refresh/reselect, Start | Status + Rate/Scope | "After reconnect, the device list refreshes and the user can start a new run." |
| "Make noise or tap the sensor." | 시계/센서 주변을 한 번 가볍게 탭 | Signal quality, Rate/Scope, Beat Noise | "The app reports signal quality; the classifier is advisory and does not retime beats." |
| "Show AI working." | Signal-quality warning/overlay 또는 clean 상태 설명 | Status/overlay/code slide fallback | "The ONNX classifier annotates trust. In clean input no warning is expected; in noisy/weak input the warning appears." |
| "Show performance evidence." | latency/evidence slide or stats 표시 | EXP-02 slide/table | "The current all-tab Pi check passed at 36.46 ms worst E2E against an 83.333 ms budget, with Drop 0 and Miss 0." |
| "Show code extensibility." | InfoTabCatalog 또는 slide 열기 | Code/slide | "A new display is local: catalog entry, optional frame consumer, renderer. Core stays independent." |
| "Show Witschi comparison." | 비교표 있으면 표시 | comparison slide/table | "This is the same watch measured on TimeGrapher and Witschi under the same setup." |
| "What if Witschi comparison is not ready?" | 미완 상태 인정 | correctness slide | "The clean synthetic reference pass is complete; Witschi is the remaining real-world validation item." |

## 2. 평가자가 물을 가능성이 높은 질문

### Q1. "이게 진짜 Raspberry Pi에서 도는 건가요?"

짧은 답:

> "Yes. The demo path is Raspberry Pi 5, and the latency evidence is measured on the Pi target platform."

추가 근거:

- EXP-02 RPi5 latency table
- 43200 BPH @ 192 kHz current all-tab check: 36.46 ms worst E2E / 83.333 ms budget / Drop 0 / Miss 0

### Q2. "왜 정확도가 제일 중요하다고 했나요?"

짧은 답:

> "Because every feature depends on event timing. If A/C timing is wrong, rate, amplitude, beat error, and all graphs become misleading."

화면으로 보일 것:

- Rate/Scope event markers
- Beat Error timing numbers
- Escapement A/C markers

### Q3. "정확도는 어떻게 증명하나요?"

Witschi 비교가 준비된 경우:

> "We use three layers: known synthetic reference, Witschi comparison on the same watch, and Verify/adverse regression tests."

Witschi 비교가 미완인 경우:

> "The known synthetic reference pass is complete. The Witschi comparison is the remaining real-world validation item, so we report it as remaining validation rather than claiming it is done."

주의:

- CI/CD가 정확도를 증명한다고 말하지 않는다.
- CI/CD는 regression guard라고 말한다.

### Q4. "CI/CD가 정확도 증명 아닌가요?"

답:

> "No. CI/CD protects validated behavior from regression. Accuracy itself comes from runtime design, reference comparison, and technical experiment results."

### Q5. "ONNX/TinyML이 실제로 앱에 연결되어 있나요?"

답:

> "Yes. The App composition root loads `OnnxSignalQualityClassifier.LoadOrElse(...)`. If the ONNX model cannot load, it falls back to the deterministic heuristic."

추가:

> "It is advisory only. It annotates signal quality and trust; it cannot create events, retime events, or change BPH/PLL lock."

### Q6. "AI가 틀리면 측정값이 틀어지지 않나요?"

답:

> "No by architecture. The classifier does not control timing. It only reports quality. The detector and metrics remain deterministic, and the model cannot move measured events."

### Q7. "왜 ONNX가 advisory인가요? 직접 reject하면 더 좋아 보이지 않나요?"

답:

> "Because timing is safety-critical for this app. We chose a conservative boundary: AI can warn about trust, but cannot own timing. That reduces the risk of a plausible but wrong model changing the measurement."

### Q8. "새로운 graph를 추가하려면 얼마나 바꿔야 하나요?"

답:

> "A new display is local: add one tab catalog entry, a frame consumer if needed, and a renderer over the existing analysis frame. Core does not need to know about the UI tab."

화면으로 보일 것:

- `InfoTabCatalog.cs`
- existing renderer/consumer naming pattern

### Q9. "12개 화면이 서로 다른 계산을 하나요?"

답:

> "No. They are different interpretations of the same analysis frame. That prevents display mismatch."

### Q10. "왜 Avalonia/.NET으로 바꿨나요?"

답:

> "The main driver was one codebase for Windows and Raspberry Pi 5. Platform audio is isolated behind adapters, while Core analysis stays platform-independent."

### Q11. "Qt/C++보다 느리지 않나요?"

답:

> "That was a risk, so we measured it. On the Pi 5, the current all-tab 43200 BPH @ 192 kHz check stays at 36.46 ms worst E2E against an 83.333 ms budget."

### Q12. "왜 visualization을 먼저 degrade한다고 했나요?"

답:

> "Because measurement is more important than visual smoothness. Under load, latest-wins rendering can skip visual frames, but the measurement path and long-term history remain protected."

### Q13. "Handling noise가 들어오면 어떻게 되나요?"

답:

> "The signal-quality path and detector tactics make suspicious input visible to the user. The system avoids silently treating a noisy moment as a trustworthy measurement."

가능 동작:

- sensor를 한 번 탭
- Rate/Scope 또는 signal-quality warning 확인
- Beat Noise에서 scatter/marker 변화 설명

### Q14. "마이크를 뽑으면 어떻게 되나요?"

답:

> "The app detects device loss, stops cleanly, refreshes device state, and lets the user restart after reconnect."

가능 동작:

- unplug/replug 시연
- 불안정하면 말로만 설명하고 playback fallback

### Q15. "Health radar는 bonus인가요?"

Health tab이 안정적인 경우:

> "Yes. Health radar uses multi-position readings to summarize overall watch condition."

불안정한 경우:

> "We will not claim the bonus screen unless it is stable in the live build. The implemented diagnosis path is still visible through signal quality and measurement-readiness feedback."

## 3. 데모 중 장애/실패 대응 스크립트

### Live input이 안 잡힐 때

말하기:

> "The live microphone path is sensitive to room setup, so I am switching to playback for repeatability. It uses the same analysis pipeline."

동작:

1. Stop
2. Playback 선택
3. 준비된 WAV 선택
4. Start
5. 같은 tab에서 계속 진행

### Noise 때문에 그래프가 흔들릴 때

말하기:

> "This is exactly why signal-quality feedback exists. The app should tell the user when readings are less trustworthy instead of hiding that condition."

동작:

- Signal quality/readiness 표시를 가리킴
- 필요하면 Playback으로 전환

### 특정 tab이 비어 있을 때

말하기:

> "This view waits for beat lock and enough history. I will keep the run going for a few seconds; if needed I will use playback so we can show the stable state."

동작:

- 5초 대기
- 여전히 비어 있으면 Playback/Simulation 전환

### Witschi 값과 TimeGrapher 값이 다를 때

말하기:

> "We do not hide the difference. The likely causes are setup-dependent: calibration, microphone attenuation, lift angle, filter settings, and exact sensor placement. The validation question is whether the readings agree within the stated tolerance under the same setup."

### ONNX가 로드되지 않은 것 같을 때

말하기:

> "The app is designed to degrade safely. If ONNX cannot load, the same classifier seam falls back to deterministic heuristic classification. Measurement timing is unaffected either way."

## 4. 20분 데모 중 끼어들기 대응 원칙

평가자가 중간에 질문하면:

1. 질문을 한 문장으로 재확인한다.
2. 바로 실행한다.
3. 루브릭으로 연결한다.
4. 30초 안에 원래 순서로 복귀한다.

예시:

> "Yes, that is Area 6: device recovery. I will unplug and reconnect the microphone now."

복귀 문장:

> "Now I will return to the rubric sequence."

## 5. 20분 발표 중 예상 질문 대응

발표 중 질문은 길게 답하지 않는다. 발표 흐름을 잃으면 손해다.

답변 패턴:

> "Short answer: [answer]. I have a slide for the evidence in Area X, so I will connect it there."

예:

질문: "Is the AI really used?"

답:

> "Short answer: yes, as an ONNX signal-quality classifier with fallback. It is covered in Area 7, and the safety boundary is that it cannot control timing."

질문: "How do you know performance is enough?"

답:

> "Short answer: EXP-02 measured it on the Pi 5. I will show the exact 36.46 ms versus 83.333 ms budget table in Area 4."

## 6. 마지막 Q&A에서 가져갈 메시지

마지막에 어떤 질문이 와도 이 세 줄로 돌아온다:

1. **Accuracy first**: timing is protected before visuals.
2. **Rubric coverage**: all required displays are shown in the running app.
3. **Evidence-backed architecture**: Pi latency, technical experiments, tests, and clear limitations.

마지막 한 문장:

> "The main point is that this is not just a collection of screens; it is a measured, architecture-backed TimeGrapher running on the target platform."

