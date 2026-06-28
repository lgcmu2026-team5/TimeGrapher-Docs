# TimeGrapher Final Presentation Script

> **Team 5 · TimeGrapherNet** — Final LG SW Architect Demo & Presentation
> 순서: 데모 20분 → (셋업 버퍼 10분) → 발표 20분.
> 형식: **[Presenter]** 영어 대사(채점자에게 그대로 말하는 문장) + **[지시문]** 한국어 동작 지시.
>
> 루브릭 동선: Area 1 → 2 → 6 → 3 → 4 → 5 → 7 → Bonus
> *"Develop your demonstration in a way that runs down the rubric."* (Stephen Beck)

---

## 0. 사전 점검 체크리스트 (셋업 10분)

- [ ] **하드웨어**: Raspberry Pi 5 + 디스플레이 + USB 마이크 + 실제 기계식 시계(충분히 감긴 상태). 채점자가 보는 메인은 **Pi 5 실기**여야 함 (Area 4 "on target platform").
- [ ] **비교용 기기**: **Weishi Timegrapher** 준비 — 같은 시계를 두 시스템으로 연속 측정해 rate/amplitude/beat error 수치 비교 (EXP-06, Area 4 Correctness).
- [ ] **정확도 근거 팩**: Weishi vs TimeGrapher 수치표 한 장, Pi latency 로그, 허용오차 기준(Witschi grade ±1 s/d · amplitude ±1° · beat error ±0.1 ms).
- [ ] **역할 분담**: `[Operator]`(앱 조작) / `[Presenter]`(영어 설명) — 팀원 이름 매핑 확정.
- [ ] **백업 입력**: 사전 녹음 WAV(라이브와 같은 시계, 21600 BPH @ 48 kHz) + `43200BPH_synthetic_192000Hz.wav` + Simulation 모드.
- [ ] **앱 실행 옵션**: 상태바 latency 통계 표시. 필요 시 `--analysis-log` 켜기.
- [ ] **Settings 사전 세팅**: lift angle, accept band(Error Rate / Amplitude / Beat Error 정상범위) 미리 설정.
- [ ] **TinyML 모델 확인**: ONNX 모델 파일이 빌드에 포함되어 있는지 확인. 신호품질 confidence indicator가 status bar에 표시되는지 테스트.
- [ ] **탭 리허설**: 13개 탭 위치를 손에 익혀, 탭당 30–45초 안에 설명 가능하도록.

---

## 전체 타임라인

### 데모 (20분)

| # | 구간 | 시간 | 채우는 Rubric |
|---|---|---|---|
| 1 | 오프닝 & 라이브 락온 | 1:30 | Area 1 baseline, Area 6 health |
| 2 | 12개 필수 디스플레이 투어 | 8:00 | **Area 1 (60점)** |
| 3 | SoundPrint / Rate·Scope 개선 + AI 기능 | 3:30 | **Area 2 (25점)** |
| 4 | GUI: unplug/replug · 노이즈 필터 · A/C 동기 · 공간활용 | 3:30 | **Area 6 (25점)** |
| 5 | 라이브 정확도·지연 근거 | 2:00 | Area 4 (데모 측), Area 3 연결 |
| 6 | Bonus: Health Radar + 진단 | 1:15 | **Bonus (8+7점)** |
| 7 | 클로징 | 0:15 | — |

> ⏱ 시간 압박 시 자르는 순서: ⑥ → ④의 공간활용 → ②에서 유사 디스플레이 묶기.
> 절대 안 자르는 것: Area 1 핵심 12개, AI 기능 (Area 2), unplug/replug (Area 6), 정확도·지연 근거 (Area 4).

### 발표 (20분)

| # | 슬라이드 | 시간 | 채우는 Rubric |
|---|---|---|---|
| 1 | 타이틀 & 구현 표면 | 0:45 | — |
| 2 | 품질속성 & 트레이드오프 (accuracy 최우선) | 4:30 | **Area 3 (20점)** |
| 3 | 문제 & 접근: Qt/C++ → Avalonia/.NET | 1:30 | Area 5 (이식성), ADR-001 |
| 4 | 아키텍처 개요: Layers · Core 무의존 · CI 강제 경계 | 3:00 | **Area 5 (20점)** |
| 5 | 성능·지연·정확성 근거 (Pi 5 실측) | 4:30 | **Area 4 (25점)** |
| 6 | 확장성 심화: 새 측정/필터/탭 추가 | 2:00 | **Area 5 (20점)** |
| 7 | AI 활용 (TinyML + 개발 전반) | 3:00 | **Area 7 (15점)** |
| 8 | 클로징 & Q&A | 0:45 | — |

---

# PART 1 — DEMO (20분)

---

## 1. 오프닝 & 라이브 락온 (1:30)
> ▣ RUBRIC: Area 1 baseline (Rate/Scope · Sound Print), Area 6 system health/readiness

**[지시문]** Pi 5 화면을 채점자에게 향하게 두고, 실제 시계를 마이크 앞에 거치. 앱은 켜져 있고 입력은 **Live** 선택 상태. **Start** 클릭 후 2–3초 대기.

**[Presenter]**
> "Good morning. We are Team 5. This is **TimeGrapher** — it listens to a mechanical watch through a microphone and measures how accurate the watch is, in real time. Everything you see now is running **live on a Raspberry Pi 5**, the target platform."

**[지시문]** Rate/Scope 탭에서 정류파형·트리거·tic/toc 레이트 점이 안정되는 것을 가리킨다.

**[Presenter]**
> "On the **Rate/Scope** view: the blue trace is the rectified signal, the red line is the trigger threshold, and these points are the rate of the tick and the tock — already settling into two stable lines. The status bar shows the system is healthy and synchronized, with end-to-end latency shown here."

**[지시문]** Sound Print 탭으로 전환.

**[Presenter]**
> "And this is **Sound Print** — each column is one beat's acoustic envelope. A clean, repeating pattern means clean detection. These two are our baseline views; everything else builds on them."

---

## 2. 12개 필수 디스플레이 투어 (8:00)
> ▣ RUBRIC: **Area 1 — Additional Real-Time Graphs and Diagnostic Displays (60점, 12 × 5점)**

> 동선 원칙: 각 탭에서 ① 무엇을 보는지 ② 이 시계에 대해 무엇을 말해주는지 1–2문장. 탭당 30–45초.
> 각 탭마다 **축/색/마커/판정 영역**을 먼저 짚고, "지금 이 화면에서는 정상/비정상이 어떻게 보이는지"를 말한다.

### 2-1. Watch-Position Testing — `Positions` 탭 (좌측)
> ▣ RUBRIC: Watch-Position Testing (5점)

**[지시문]** Positions 탭 열기. 좌측 포지션 버튼 strip과 3D 시계 모델을 가리킨다. 포지션(예: Dial Up → Crown Down)을 클릭해 3D 모델이 회전하는 것을 보여준다.

**[Presenter]**
> "**Watch-Position Testing.** A watch runs differently in different positions. We pick a position here — CH, CB, 6H, 9H, 3H, 12H, plus intermediates — the 3D watch model rotates to it, and the currently active position is highlighted so the watchmaker always knows which reading they're taking."

---

### 2-2. Multi-Position Sequence Display — `Positions` 탭 (우측)
> ▣ RUBRIC: Multi-Position Sequence Display (5점)

**[지시문]** 같은 탭 우측 포지션별 시퀀스 측정 표를 가리킨다. 행은 포지션, 열은 rate / amplitude / beat error. Position Consistency 헤더와 verdict badge, `View criteria` 버튼을 순서대로 짚는다.

**[Presenter]**
> "On the right, the **Multi-Position Sequence** records rate, amplitude, and beat error for each position in order — up to ten positions. Above the table, **Position Consistency** converts those per-position readings into a verdict: average X, spread D between best and worst, vertical-versus-horizontal delta, and whether the vertical rates suggest balance-wheel unbalance."

---

### 2-3. Trace Display — `Trace` 탭
> ▣ RUBRIC: Trace Display (5점)

**[지시문]** Trace 탭으로 전환. 위 plot은 Error Rate (s/d), 아래는 Amplitude(°). shaded acceptable band, 평균선, σ band, Smoothing 토글을 순서대로 짚는다.

**[Presenter]**
> "**Trace Display** shows two continuous traces over elapsed time: rate deviation on top and amplitude below. The shaded bands are the acceptable ranges. The rolling average updates continuously — smoothing short-term noise — and alerts fire here if rate goes negative or amplitude leaves the 270–300° window."

---

### 2-4. Rate and Amplitude Stability — `Vario` 탭
> ▣ RUBRIC: Rate and Amplitude Stability Over Time (5점)

**[지시문]** Vario 탭. 상단 summary card의 verdict, Error Rate / Amplitude gauge, 각 gauge 아래의 Min / Max / Max-Min / Average / Std dev / Current readout strip, amber acceptable band를 순서대로 짚는다.

**[Presenter]**
> "**Vario** turns the live stream into stability statistics — minimum, maximum, spread, average, sigma, and current value for both rate and amplitude, then converts those numbers into plain-language verdicts like *'Stable · in range'* and *'Healthy.'*"

---

### 2-5. Beat-Noise Scope Display — `Beat Noise` 탭
> ▣ RUBRIC: Beat-Noise Scope Display (5점)

**[지시문]** Beat Noise 탭. toolbar의 Beat Scope / Avg Envelope, 20/200/400 ms, Σ 버튼을 가리킨다. Scope 1에서 큰 beat waveform과 8개 recent strip lane, A/C 이벤트 마커를 짚는다. strip을 클릭해 선택 beat가 확대되는 것을 보여준다.

**[Presenter]**
> "**Beat-Noise Scope** has two scopes. Scope 1: the live waveform with selectable 20, 200, or 400 ms time range — recent beat strips accumulate below for comparison. Scope 2: the Σ toggle averages 50 tick and 50 tock intervals, so random noise cancels out. A and C event markers stay at the same relative position in both scopes."

**[지시문]** Avg Envelope를 3초 보여준 뒤 Beat Scope로 복귀.

---

### 2-6. Beat Error Display and Diagnostic Trace — `Beat Error` 탭
> ▣ RUBRIC: Beat Error Display and Diagnostic Trace (5점)

**[지시문]** Beat Error 탭. 상단 numeric panel의 Error Rate / Amplitude / BEAT ERROR / BPH / DIFF TIC-TAC 값을 순서대로 가리킨다. tic/toc rate trace, acceptable range shaded band, slope를 짚는다.

**[Presenter]**
> "**Beat Error** shows both the diagnostic trace and the exact timing numbers: signed beat error, tic-tac difference, period difference, and average period. The two trace lines — tick in blue, tock in orange — represent timing behavior over time. If the slope reaches 45 degrees, or the tic/toc separation leaves the acceptable band, it flags a **MAJOR FAULT** right on screen."

---

### 2-7. Long-Term Performance Graph — `Long-Term` 탭
> ▣ RUBRIC: Long-Term Performance Graph (5점)

**[지시문]** Long-Term 탭. 세 stacked pane(Error Rate / Amplitude / Beat Error), bucket average line, shaded min/max variation band, dashed overall-average, acceptable-range band, 우측 1h/3h/6h 버튼을 순서대로 가리킨다.

**[Presenter]**
> "**Long-Term Performance** accumulates the whole session for rate, amplitude, and beat error. The bucket average line shows the trend; updates become less frequent as elapsed time grows — so the graph stays readable for 24-hour runs. The shaded band keeps min/max variation visible, and tolerance limit lines let the trace be read against its target range."

---

### 2-8. Escapement Analyzer and Marker-Line Display — `Escapement` 탭
> ▣ RUBRIC: Escapement Analyzer and Marker-Line Display (5점)

**[지시문]** Escapement 탭. 확대된 단일 beat waveform, A marker, C peak / C onset marker와 ms 라벨을 순서대로 가리킨다. 하단 numeric panel의 A→C PEAK / A→C ONSET / PEAK MEAN±σ / ONSET MEAN±σ / MORE REPEATABLE 값을 읽는다.

**[Presenter]**
> "The **Escapement Analyzer** zooms into one beat with A, C-peak, and C-onset marker lines. The panel compares peak timing and onset timing including mean and sigma, then tells us which reference is more repeatable. You can pause and capture for detailed inspection, and the marker reference point — onset vs peak — is selectable from the toolbar."

---

### 2-9. Time-Frequency Spectrogram — `Spectrogram` 탭
> ▣ RUBRIC: Time-Frequency Spectrogram Display (5점)

**[지시문]** Spectrogram 탭. x축 시간, y축 frequency, 오른쪽 colorbar(dB), Last Beat / Seconds 토글, live-head marker를 순서대로 가리킨다. tick이 들어올 때마다 나타나는 vertical burst를 짚는다.

**[Presenter]**
> "The **Spectrogram** is a short-time FFT — time on one axis, frequency on the other, color as dB intensity. We can view the last beat or a seconds window. The live-head marker shows where new data is being written. Periodic vertical bursts confirm beat lock."

---

### 2-10. Waveform Comparison Display with Timing Markers — `Waveforms` 탭
> ▣ RUBRIC: Waveform Comparison Display with Timing Markers (5점)

**[지시문]** Waveforms 탭. 상단 header의 Instantaneous Rate / Beat Err / BPH를 읽는다. tic/toc pair lane들, A 정렬 기준선, C marker/label, mean-C timing guide, signal envelopes를 순서대로 가리킨다.

**[Presenter]**
> "**Waveform Comparison** stacks recent tic/toc beat pairs, all aligned on A. You can compare waveform shape, spacing, and consistency across beats — signal envelopes are overlaid. Vertical guide markers help identify T1, T2, T3 landmarks. Rate, beat error, and BPH all appear in the header from the same source frame."

---

### 2-11. Scope Mode with Synchronized Sweep Display — `Sweep` 탭
> ▣ RUBRIC: Scope Mode with Synchronized Sweep Display (5점)

**[지시문]** Sweep 탭. 우측 상단 1x / 2x / 3x sweep window selector, A/C dashed marker, 하단 reference line의 rate/amplitude/beat-error 수치를 가리킨다.

**[Presenter]**
> "**Sweep** folds the signal onto a synchronized tick-to-tick window — like a triggered oscilloscope. When the watch is exactly on rate, the beat pattern appears stationary. When it's fast or slow, the pattern drifts — immediately visible without looking at numbers. The 1x, 2x, 3x buttons let us inspect one or multiple beat periods."

---

### 2-12. Scope Function with Multiple Filter Views — `Filter Scope` 탭
> ▣ RUBRIC: Scope Function with Multiple Filter Views (5점)

**[지시문]** Filter Scope 탭. F0/F1/F2/F3 label이 2×2 grid로 배치된 화면. 각 label과 description을 순서대로 가리킨다: F0(raw-like), F1(moving average), F2(rising slopes emphasized), F3(upper envelope). 같은 tick이 각 view에서 어떻게 다르게 보이는지 손으로 짚는다.

**[Presenter]**
> "**Filter Scope** runs the same signal through four filter views simultaneously: raw-like, smoothed, rising-edge emphasized, and upper-envelope emphasized — all on the same time axis. This lets us see which processing view best isolates T1, T2, and T3 for the current watch. All four update together in real time."

**[지시문]** 12개 완료 후 Live로 복귀.

**[Presenter]**
> "That's all twelve required displays, each driven by the same live analysis pass."

---

## 3. SoundPrint / Rate·Scope 개선 + AI 기능 (3:30)
> ▣ RUBRIC: **Area 2 — System Enhancements & AI Feature (25점)**

### 3-1. SoundPrint 개선 (8점)

**[지시문]** Sound Print 탭. 세로로 흐르는 envelope image, A/C marker overlay, 100 ms 갱신 cadence를 짚는다. 마커가 신호 픽셀과 같은 sample-to-column conversion을 사용해 같은 위치에 찍히는 점을 설명한다.

**[Presenter]**
> "We improved **Sound Print** beyond the baseline: the A and C event markers are persistent overlays on the scrolling envelope image. Marker placement uses the same sample-to-column mapping as the signal itself — so the markers are visually aligned with the acoustic features, not approximated. The image publishes on a 100 millisecond cadence so it stays responsive on the Pi. You can verify detection accuracy visually here without switching to another tab."

---

### 3-2. Rate / Scope 개선 (8점)

**[지시문]** Rate/Scope 탭. rectified signal, trigger threshold, event markers, tic/toc rate points를 다시 짚는다. scope는 10초 history를 보관하지만 화면은 point budget에 맞게 visible window만 렌더링하는 구조라 pan/zoom해도 측정이 끊기지 않음을 설명한다.

**[Presenter]**
> "On **Rate / Scope**, we added a configurable measurement window selector and a peak-hold indicator. The display keeps a 10-second history but renders only the visible window within a fixed point budget — so you can freeze a window, inspect it, and resume without dropping measurements. Event markers are pooled and repositioned instead of recreated each frame, keeping the view smooth on the Pi."

---

### 3-3. AI 기능 — TinyML Signal Quality Classifier (5점 + 문제 설명 4점)

**[지시문]** status bar의 signal quality confidence indicator를 가리킨다. Settings 창에서 classifier 관련 토글이 있으면 함께 보여준다.

**[Presenter]**
> "Our AI feature is the **TimeGrapher.Inference module** — an ONNX-based signal quality classifier running on-device on the Raspberry Pi 5. It classifies each beat into four categories: **Good, Noisy, WeakSignal, or Unstable**, using eight signal-shape features extracted per beat. The confidence result appears here in the status header in real time."

**[지시문]** 시계를 한 번 톡 친다 → confidence indicator 변화 확인. 일반 beat와 비교해 보여준다.

**[Presenter]**
> "The problem it addresses: a watch's sound also contains short, loud transients — a tap, a bump — and if one is mistaken for a tick, rate, beat error, and amplitude can spike. Watch — I tap once. The classifier flags this beat as suspect before it reaches the metrics, so the measurement stays clean.
>
> The key architectural safety guarantee: the classifier can accept or veto a candidate beat — it **cannot** create events, re-time them, or touch the BPH and PLL sync. So even if the model is wrong in one direction, it cannot break the timing lock."

---

## 4. GUI: unplug/replug · 노이즈 필터 · A/C 동기 · 공간활용 (3:30)
> ▣ RUBRIC: **Area 6 — Remote UI / GUI Modifications (25점)**

### 4-1. 센서/마이크 unplug & replug (5점)

**[지시문]** 라이브 측정 중 **USB 마이크를 물리적으로 뽑는다.**

**[Presenter]**
> "Now I'll unplug the microphone while it's running."

**[지시문]** 상태바에 "Live audio stopped unexpectedly. Please check your device connection." 메시지와 장치 목록 자동 갱신을 가리킨다.

**[Presenter]**
> "The system detects it immediately — stops cleanly, tells the user exactly what happened, and refreshes the device list. No crash, no frozen graph. This is handled by an explicit run-state machine."

**[지시문]** 마이크를 다시 꽂고 → 장치 재선택 → Start. 정상 복귀.

**[Presenter]**
> "I plug it back in, re-select the device, start again — and we're measuring live once more."

---

### 4-2. 핸들링 노이즈 필터링 (4점)

**[지시문]** 측정 중 시계/센서를 손가락으로 톡톡 두드린다. A/C는 유지되고 탭 노이즈는 걸러지는 것을 가리킨다.

**[Presenter]**
> "Handling the watch creates loud impulses that look like beats. We filter that handling noise using regime guard and impulse rejection, while preserving the real A and C events. A single impulse — like a door slam — is debounced over a few beats, so one bump can't wipe out the lock or the history."

---

### 4-3. Beat-Synchronized A/C 표시 (4점)

**[지시문]** Beat Noise 또는 Waveforms 탭. A와 C가 매 사이클 **같은 상대 위치**에 놓이는 것을 가리킨다.

**[Presenter]**
> "For beat-synchronized display: every cycle, A and C are placed at the **same relative location** on the graph — beat-aligned, not wall-clock-aligned. Irregular timing shows up as positional deviation from that fixed reference, so you don't have to chase it across the screen."

---

### 4-4. 화면 공간 활용 (4점) + 가독성 (4점)

**[지시문]** Settings 창을 열어 덜 사용하는 옵션(accept band, 샘플링 파라미터, CSV 로그)이 정리된 것을 보여준다. 메인 화면이 그래프 중심임을 강조.

**[Presenter]**
> "Less-used controls — sampling parameters, accept bands, logging options — live in a separate **Settings** window, so the main screen stays focused on the graphs. The three key readings — rate, beat error, amplitude — are always visible in the top status bar regardless of which tab is active. Touch targets are at least 9 mm, letter height at least 2.9 mm — meeting our QAS-6 usability scenario for the 1280×800 Pi touchscreen."

---

### 4-5. 시스템 건강 / 측정 준비 피드백 (4점)

**[지시문]** 상태바의 latency, signal level meter, detection confidence를 가리킨다. Vario의 overall verdict도 함께 짚는다.

**[Presenter]**
> "The status bar provides at-a-glance system health: signal level, detection confidence, latency, and run state. If the signal is weak, a yellow indicator fires. If detection rate drops below 95%, red. And Vario gives a measurement-readiness verdict — *'OK — stable enough to record'*, *'WATCH'*, or *'ALERT — service required'* — so the user always knows when a reading can be trusted."

---

## 5. 라이브 정확도 & 지연 근거 (2:00)
> ▣ RUBRIC: Area 4 (데모 측), Area 3 연결

### 5-1. 라이브 지연

**[지시문]** 상태바 latency 수치를 확대해 가리킨다.

**[Presenter]**
> "Latency: from capturing audio through detection and measurement to drawing it on screen — the status bar shows this end-to-end, live. On the Pi 5 at 43200 BPH / 192 kHz, worst-case stayed at 36.46 ms — only 44% of the 83.3 ms budget, with zero dropped blocks and zero missed beats."

---

### 5-2. 두 시스템 정확도 비교

**[지시문]** 같은 시계의 Weishi Timegrapher 판독값과 TimeGrapher 판독값(rate s/d, amplitude°, beat error ms)을 나란히 보여준다. 허용오차 기준은 Witschi 등급 기준 ±1 s/d / ±1° / ±0.1 ms.

**[Presenter]**
> "For accuracy, we measure the **same watch on two systems** — TimeGrapher and the Weishi Timegrapher reference. Our rate, amplitude, and beat error agree within the Witschi grade tolerance: ±1 s/d, ±1°, ±0.1 ms. We took multiple readings on a consistently wound watch — they stayed consistent. That's our correctness evidence. CI tests protect this from regressing, but the live agreement is the primary proof."

---

## 6. Bonus: Health Radar + 진단/분류 (1:15)
> ▣ RUBRIC: Bonus — Radar chart (8점) + Diagnosis/Classification (7점)

### 6-1. Watch Health Radar — `Watch Health Radar` 탭

**[지시문]** 탭 스트립에서 Watch Health Radar 탭을 연다. 6개 포지션(CH·CB·12H·3H·6H·9H) 축의 레이더, healthy-zone amber band, target 점선, 측정 다각형을 가리킨다.

**[Presenter]**
> "As a bonus feature, the **Watch Health Radar** tab renders a polar chart using measurements from all completed positions. Right now it's showing amplitude per position. The amber band is the healthy zone, the dashed line is the target. A full, even polygon means the watch is consistent in every position; a dent points straight to the weak one. The same chart re-plots rate or beat error on the same six axes."

---

### 6-2. 진단 / 분류

**[지시문]** Vario의 overall verdict, Beat Error의 MAJOR FAULT banner, Positions의 Position Consistency badge를 순서대로 짚는다.

**[Presenter]**
> "For diagnosis and classification, the implemented views turn measurements into verdicts: Vario gives recording readiness, Beat Error flags a major timing fault at 45-degree slope, and Position Consistency summarizes whether the watch behaves evenly across positions — naming the weakest axis visually on the radar."

---

## 7. 클로징 (0:15)

**[Presenter]**
> "To sum up — twelve real-time displays, an architecture that keeps accuracy first, all running live on the Pi 5. We'll go deeper into the architecture and the evidence in the presentation. Thank you."

---

## 부록 A. 라이브 장애 대응

| 증상 | 즉시 대응 | 대사 |
|---|---|---|
| 마이크 락온 실패 | **Playback**(사전 녹음 WAV)으로 전환 | "Let me switch to a recording of the same watch so it's easier to see." |
| 마이크 장애/잡음 폭주 | Simulation 모드 | (위와 동일) |
| 고비트(43200) 디스플레이 | `43200BPH_synthetic_192000Hz.wav` Playback | "For a high-beat movement we use a 192 kHz recording." |
| 특정 탭 렌더 느림 | 상태바 *"Display quality was reduced…"* 를 기능으로 설명 | "Notice it protects measurement by easing the visuals first — that's by design." |
| 앱 멈춤 | Reset → 재시작 | "The run-state machine lets us recover cleanly with Reset." |

---

## 부록 B. 디스플레이 ↔ 루브릭 ↔ 탭 매핑

| Rubric (Area 1) | 탭 이름 | 탭 순서 |
|---|---|---|
| Watch-Position Testing | Positions (좌) | 8 |
| Multi-Position Sequence Display | Positions (우) | 8 |
| Trace Display | Trace | 3 |
| Rate and Amplitude Stability Over Time | Vario | 5 |
| Beat-Noise Scope Display | Beat Noise | 9 |
| Beat Error Display and Diagnostic Trace | Beat Error | 2 |
| Long-Term Performance Graph | Long-Term | 6 |
| Escapement Analyzer and Marker-Line Display | Escapement | 7 |
| Time-Frequency Spectrogram Display | Spectrogram | 13 |
| Waveform Comparison Display with Timing Markers | Waveforms | 10 |
| Scope Mode with Synchronized Sweep Display | Sweep | 4 |
| Scope Function with Multiple Filter Views | Filter Scope | 11 |
| (baseline) | Rate/Scope | 1 |
| (baseline) | Sound Print | 12 |
| **(Bonus)** Watch Health Radar | Watch Health Radar | 별도 |

> 실제 앱 탭 순서: `Rate/Scope` → `Beat Error` → `Trace` → `Vario` → `Long-Term` → `Sweep` → `Escapement` → `Positions` → `Beat Noise` → `Waveforms` → `Filter Scope` → `Sound Print` → `Spectrogram`

---

---

# PART 2 — PRESENTATION (20분)

---

## 슬라이드 1. 타이틀 & 구현 표면 (0:45)

**[Presenter]**
> "We're Team 5. TimeGrapher listens to a mechanical watch and measures its accuracy in real time. The program you just saw is not a mock-up: it has live, playback, and simulation inputs, and exposes all twelve required measurement displays — Rate/Scope, Beat Error, Trace, Vario, Long-Term, Sweep, Escapement, Positions, Beat Noise, Waveforms, Filter Scope, Sound Print, and Spectrogram.
>
> We rebuilt it from the original Qt/C++ version into **Avalonia and C# on .NET 8**, so a **single codebase** runs on both Windows and the Raspberry Pi 5."

---

## 슬라이드 2. 품질속성 & 트레이드오프 (4:30)
> ▣ RUBRIC: **Area 3 — Quality Attribute Tradeoff Discussion (20점)**
> 주요 QA 식별 5점 / 트레이드오프 설명 5점 / accuracy 최우선 입증 5점 / 달성·한계 5점

### 2-1. 주요 QA 식별 (5점)

**[지시문]** QAS 우선순위 슬라이드.

**[Presenter]**
> "Six quality attributes drive this system, prioritized in this order. That ordering was itself a decision — through discussion with Dan and Steve, we settled on **Accuracy** as the top priority. A timegrapher's only job is to produce correct readings; if the rate is wrong, everything else is meaningless. After that: **Performance/Latency**, **Reliability**, **Consistency**, **Modifiability**, and **Usability**. These are not generic quality words — we turned each one into a measurable scenario.
>
> QAS-1 (Accuracy): clean reference input within ±1.0 s/d of a known reference over ≥1,000 beats. QAS-2 (Latency): worst-case E2E latency within one beat period — 83.3 ms at 43200 BPH. QAS-3 (Reliability): at SNR ≥ 30 dB over ≥1,000 beats, detection ≥ 95% and displayed rate within ±3 s/d of the reference; below threshold, show 'signal weak'. QAS-4 (Consistency): all displays in the same frame from one source data set, zero mismatches. QAS-5 (Modifiability): a new graph, filter, or measurement touches ≤1 existing module. QAS-6 (Usability): 2.9 mm letter height, 9 mm touch targets on the Pi 1280×800 screen."

---

### 2-2. Accuracy를 최우선으로 둔 증거 (5점)

**[지시문]** QAS-1 목표 + Verify 모듈 + Core.Detection 구현 전술 슬라이드.

**[Presenter]**
> "Accuracy is our top-ranked quality attribute. The architecture was designed to define that goal precisely and make it verifiable — and the actual achievement is the responsibility of the Core.Detection implementation.
>
> **Architecture level:** QAS-1 sets the target — computed rate within ±1.0 s/d of a known reference over ≥1,000 consecutive beats on clean input. The **Verify module** checks this headlessly on every CI change, running Core directly against synthetic fixtures with known timing references. Because **Core has zero dependencies**, it can be tested in complete isolation — no UI noise, no platform interference.
>
> **Implementation level:** Achieving that target is Core.Detection's job. The key mechanism is **sub-sample interpolation** — linear for A events, parabolic for C events — producing timing precision far beyond integer sample resolution at 192 kHz. Surrounding defense tactics: an **adaptive noise floor** tracking the 75th percentile of silence samples rather than a fixed threshold; **PLL-guided gating** that rejects onset crossings outside the predicted beat window after lock; and a **regime guard** that requires three consecutive qualifying peaks before resetting state — so one impulse cannot destroy a lock.
>
> These are not optional toggles — they are the default detection behavior, always on. **The architecture sets the bar and enforces it through CI; the implementation clears it.**"

---

### 2-3. 트레이드오프 설명 (5점)

**[지시문]** 트레이드오프 표 슬라이드.

**[Presenter]**
> "Quality attributes competed, and every tradeoff was deliberate.
>
> **QAS-1 (Accuracy) vs. QAS-2 (Latency)**: we accepted latency costs to protect accuracy. A longer warm-up before reporting BPH means the first reading arrives later — we accept that delay to avoid showing wrong numbers early. A higher sample rate gives finer timestamp resolution but costs more CPU per beat — we support up to 192 kHz and verified it fits the budget on the Pi before committing.
>
> **QAS-5 (Modifiability) vs. QAS-1/QAS-2 (Accuracy/Latency)**: we separated input, analysis, rendering, and recording at worker boundaries to gain modifiability — but kept the detector and metrics as one **synchronous hot path**. Full pipe-and-filter between every stage would add per-stage queuing that spends the beat-period budget, threatening both latency and accuracy. That is the core tradeoff between modifiability and the top two quality attributes.
>
> **QAS-1 (Accuracy) vs. QAS-2 (Latency / visual responsiveness)**: when the system falls behind its deadline, it degrades the *visuals first* — latest-wins rendering skips intermediate frames — but it **never drops or interpolates a measurement**. We protect the number and sacrifice the picture.
>
> **QAS-3 (Reliability) vs. QAS-1 (Accuracy)**: raising detection rate under noise requires loosening the threshold — but that risks accepting false beats and hurting accuracy. PLL-guided gating and the regime guard manage this tension at the implementation level. The TinyML classifier also addresses this tradeoff, but it is **architecturally constrained**: it can veto candidates but cannot create events or re-time them — so even a wrong model cannot break the timing lock."

---

### 2-4. 달성한 것과 남은 한계 (5점)

**[Presenter]**
> "**What we achieved:**
> QAS-1 (Accuracy): rate within ±1.0 s/d on clean simulation input — passed.
> QAS-2 (Latency): worst-case E2E 36.46 ms at 43200 BPH / 192 kHz — 44% of the 83.3 ms budget. Drop 0 / Miss 0 across all 13 tabs — passed.
> QAS-3 (Reliability): adaptive noise floor, PLL-guided gating, regime guard, and TinyML classifier implemented. Verified against noise, impulse, and gain-step scenarios in Verify `--adverse` mode — passed.
> QAS-4 (Consistency): single AnalysisFrame structure guarantees zero mismatches within a frame — passed by design.
> QAS-5 (Modifiability): all 13 tabs added via InfoTabCatalog pattern, each touching ≤1 existing module — passed.
> QAS-6 (Usability): 2.9 mm letter height, 9 mm touch targets centralized in App.axaml and verified on the Pi touchscreen — passed.
>
> **Limitations that remain:**
> QAS-1: passed on simulation and Verify fixtures, but the real-world validation is measuring the same watch on both TimeGrapher and the Weishi reference device and checking the numbers agree — we show that result in slide 5.
> QAS-3: the TinyML classifier is integrated and running, but how well it classifies across different watch types and real low-SNR conditions has not been fully tested yet.
> We report these limits because honest evaluation is stronger than pretending the risks have disappeared."

---

## 슬라이드 3. 문제 & 접근 (1:30)
> ▣ RUBRIC: Area 5 (이식성) · ADR-001

**[지시문]** ADR-001 슬라이드. Qt/C++ → Avalonia/.NET 전환 이유, rejected alternatives 한 줄씩.

**[Presenter]**
> "The original was Qt and C++. We made a deliberate architectural choice — documented in **ADR-001** — to move to Avalonia and .NET. The driver was **portability with one codebase**: the same source produces a Windows build and a Raspberry Pi build, and only the per-OS audio backend changes.
>
> Rejected alternatives: Qt/C++ (team expertise, LGPL, build complexity), Electron (embedded footprint), MAUI (Linux support), Flutter (Dart mismatch). The decision is what lets accuracy, performance, and UI work carry over to the Pi without a separate port."

---

## 슬라이드 4. 아키텍처 개요 (3:00)
> ▣ RUBRIC: **Area 5 — Extensibility: modular, separates concerns (6점) + understandable/maintainable (4점)**

**[지시문]** Layer 다이어그램 (`assets/LAYER.png` 또는 module-uses 뷰)을 가리킨다.

**[Presenter]**
> "The architecture is three layers. The **Core** is the analysis engine — detection, measurement, image generation, the simulator — and it has **zero dependencies** on UI or OS. The **App** is the Avalonia UI. The **Platform** assemblies wrap each OS's microphone stack. Dependencies only point downward: App and Platform both depend on Core, never the reverse.
>
> This boundary isn't just a diagram — **our CI enforces it**. A test fails the build if Core ever imports a UI, platform, or audio type. The architecture rule is a failing test, not a comment.
>
> All three inputs — live mic, WAV playback, and the simulator — implement one small interface. Core only knows that contract, so a new input or OS backend drops in without touching the engine. And the same frame fan-out is what makes the thirteen-display tour possible: Rate/Scope, Beat Error, Trace, Vario, Long-Term, Sweep, Escapement, Positions, Beat Noise, Waveforms, Filter Scope, Sound Print, and Spectrogram are different views over the same measured analysis frame — not separate competing calculators."

**[Presenter] (QAS traceability)**
> "Every boundary in this diagram was motivated by a specific quality requirement:
> **Core zero dependency → QAS-1**: the Verify module runs Core in complete isolation, enabling headless accuracy verification against known references — the architecture does not achieve accuracy, but it makes achievement verifiable.
> **Worker Pipe-and-Filter → QAS-2**: audio processing and rendering are separated; rendering occurs only when a tab is selected, not all thirteen simultaneously.
> **Single AnalysisFrame → QAS-4**: every display derives from the same source object — zero mismatches is structurally guaranteed.
> **InfoTabCatalog pattern → QAS-5**: a new tab requires one catalog entry and one renderer file — no existing analysis module is touched.
> **Centralized App.axaml theme → QAS-6**: font and touch policy live in one place, preventing accidental drift during maintenance."

**[Presenter] (정직성 포인트)**
> "We also assessed our patterns honestly. Our MVVM is partial — start/stop lifecycle still lives in code-behind — and our DSP chain is pipe-and-filter in structure but a single synchronous thread internally. Knowing exactly where a pattern is fully applied versus partially applied was part of what we learned from this course."

---

## 슬라이드 5. 성능·지연·정확성 근거 (4:30)
> ▣ RUBRIC: **Area 4 — Performance, Latency, Correctness (25점)**
> Pi 실시간 8점 / 저지연 6점 / 정확성 6점 / 근거 5점

### 5-1. Pi 5 실시간 + 저지연

**[지시문]** EXP-02 Results 표를 직접 인용한 슬라이드.

**[Presenter]**
> "We measured the real end-to-end latency on the Pi 5 — capture to processing to display — from the app's own logs. The slide quotes EXP-02 directly:
>
> At 21600 BPH / 48 kHz: worst-case E2E 43.9 ms against a 166.7 ms budget — 26.4%.
> At 43200 BPH / 192 kHz: worst-case E2E 36.5 ms against an 83.3 ms budget — 43.8%.
> Current all-tab check (2026-06-21): 36.46 ms, same budget — still 43.8%.
> Every run: Drop 0, Miss 0, Result Pass.
>
> Per-tab: Filter Scope is slowest at 36.46 ms. Escapement is fastest at 15.09 ms. All 13 tabs well inside budget. The key mechanism: the **Latest-Wins scheduler** discards stale frames rather than queuing them, so backlog never accumulates."

---

### 5-2. 정확성 + 근거

**[지시문]** 두 시스템 비교 수치 표와 Verify 통과 캡처 슬라이드.

**[Presenter]**
> "For correctness we have three kinds of evidence:
>
> 1. **Two-system comparison** — the same watch on TimeGrapher and the Weishi Timegrapher reference. Rate, amplitude, and beat error agree within the Witschi grade tolerance: ±1 s/d, ±1°, ±0.1 ms. Multiple readings on a consistently wound watch stayed consistent.
>
> 2. **Automated verification** — our Verify console checks detected BPH and event-level precision/recall against ground-truth fixtures in CI on every change. Adverse scenarios — weak signal, noise, impulse storms, gain steps — are gated there.
>
> 3. **Test suite** — **933 tests** pass across Core, App, and platform layers.
>
> Together: the live reading matches a reference, the detector is checked against known signals automatically, and the whole thing is regression-guarded."

---

## 슬라이드 6. 확장성 심화 (2:00)
> ▣ RUBRIC: **Area 5 — supports adding new measurements/filters/graphs with limited redesign (6점)**

**[지시문]** "새 디스플레이 추가 4단계" 슬라이드. InfoTabCatalog + Frame consumer + Renderer 흐름.

**[Presenter]**
> "Adding capability is deliberately cheap. A new display is four steps:
>
> 1. Add a new property to AnalysisFrame in Core.Shared — one struct field.
> 2. Populate it in AnalysisWorker — one assignment.
> 3. Create a new Renderer class in App.Rendering — a new file, no existing file touched.
> 4. Register the tab in InfoTabCatalog — one line.
>
> The routing infrastructure — AnalysisFrameRouter and AnalysisFrameRenderScheduler — picks it up automatically. The Watch Health Radar is a live example of this pattern: a new renderer over the existing per-position snapshot, one catalog entry.
>
> The measurable target from QAS-5: a new graph or measurement should touch **at most one existing module**, with an eight person-day budget per feature. ADR-004 supports this through App, test, and Verify module separation, so six members — and AI coding assistants — can work without conflict. Because the engine is isolated and CI-locked, additions are **limited, local changes** — which is exactly what extensible architecture should mean."

---

## 슬라이드 7. AI 활용 (3:00)
> ▣ RUBRIC: **Area 7 — Use of AI in Building the Software (15점)**
> 설명 5점 / 사려깊은 활용 5점 / 강점·한계·위험 5점

### 7-1. AI 도구 사용 설명 (5점)

**[Presenter]**
> "Our approach to AI was **agentic engineering** — bringing AI into the team development process in a controlled way, not as individual improvised prompting. Two mechanisms kept AI aligned with our project:
>
> **AGENTS.md** defines our project rules, commit format, and architectural principles. Every AI session starts from this context — AI follows our conventions rather than its own defaults.
> **DocRules.md**, derived from course materials, is our document quality standard. AI drafts documents; we review using this standard; the review results go back to AI for refinement.
>
> This structure means humans make all final decisions, and AI is part of our defined process — not a wildcard.
>
> Application areas: **base code conversion** (Qt/C++ → .NET port), **CI/CD pipeline** design and automation, **933 test** generation. And as a **product feature**: TimeGrapher.Inference is an ONNX signal-quality classifier running on-device on the Pi — architectural constraint means it cannot create events, re-time them, or touch BPH sync."

---

### 7-2. 사려깊은 활용 (5점)

**[Presenter]**
> "**The review loop**: AI drafts → we review using DocRules.md from course materials → we feed the review back to AI for refinement. This preserved quality without sacrificing speed.
>
> **Concrete example 1: Pipe-and-Filter decision.** The UI thread was freezing during heavy spectrogram computation. We described the bottleneck to Claude and asked for relevant patterns from Bass, Clements & Kazman's SAP. It suggested Producer-Consumer + Latest-Wins scheduler. We validated against the book's quality-attribute analysis and implemented it. EXP-03 confirms the UI thread is now fully decoupled.
>
> **Concrete example 2: ViewModel purity test.** We asked how to enforce 'no Avalonia in ViewModel' mechanically. Claude suggested a reflection-based test. We implemented ViewModelPurityTests — it runs on every CI push.
>
> AI output was always checked by executable evidence: tests, CI jobs, Verify fixtures, ADRs, and live Pi measurements."

---

### 7-3. 강점·한계·위험 (5점)

**[Presenter]**
> "Honestly, on strengths, limits, and risks:
>
> **Strength**: AI was included in the team development process in a controlled way — not individual improvised use. AI followed our conventions via AGENTS.md and DocRules.md; humans made all final decisions. This let a small team port a large real-time app, add an on-device classifier, and automate the build/test/release workflow.
>
> **Limits**: AI required thorough review of excessive output. More specifically: it does not fully understand project context and can make plausible-but-wrong suggestions — functionality must always be tested. It can make mistakes with local environment and branch state. Document quality improves, but deep design intent still needs humans to fill in. UI/UX judgment requires iterative feedback.
>
> **Risk**: for a real-time, accuracy-critical system, a plausible-but-wrong AI change can silently hurt timing. Our mitigation was structural: the classifier path cannot own timing, CI enforces architecture boundaries, Verify gates adverse signals, and human review checks generated code. **We treated AI as a fast collaborator that must be checked — not as an authority.**"

---

## 슬라이드 8. 클로징 & Q&A (0:45)

**[Presenter]**
> "In short: a running watch-measurement application with twelve required displays, accuracy first, proven on the Pi 5 with measured latency and a two-system comparison; an architecture that is modular, portable, and CI-enforced; and AI used both in the product through the signal-quality classifier and in the development process through guarded automation. Thank you — we're happy to take questions."

---

## 부록 C. 예상 Q&A

| 질문 | 핵심 답변 |
|---|---|
| "정확도를 어떻게 보장했나?" | Two levels: **architecture** defines QAS-1 target and enables headless verification via Verify module; **Core.Detection implementation** achieves it — sub-sample interpolation, adaptive noise floor, PLL-guided gating, regime guard. Weishi comparison + Verify adverse fixtures as evidence. |
| "QAS가 아키텍처 결정과 어떻게 연결되나?" | Core zero dependency → QAS-1 verifiability; Pipe-and-Filter → QAS-2 performance; single AnalysisFrame → QAS-4 consistency; InfoTabCatalog → QAS-5 modifiability; centralized App.axaml → QAS-6 usability. |
| "지연이 정말 실시간인가?" | EXP-02 표 그대로: 21600@48k와 43200@192k 모두 Pass, worst usage 24–44%, Drop 0 / Miss 0. |
| "두 시스템 값이 다르면?" | 차이를 숨기지 않고 원인(캘리브레이션·마이크 감쇠·필터·lift angle) 가설 제시. |
| "AI 기능이 진짜 AI인가?" | Yes. ONNX 모델이 on-device에서 동작 중이고, 데모에서 시연했다. 안전을 위해 이 경로는 이벤트 생성·retiming·BPH sync를 건드리지 못하는 구조적 제약이 있다. |
| "레이더 차트는?" | Watch Health Radar 탭에 구현. Positions와 같은 per-position 스냅샷 재사용, 카탈로그 1엔트리 + 렌더러 추가. |
| "확장성 증거?" | 새 탭 = 카탈로그 1엔트리 + consumer. Core 불변. CI가 경계 강제 → 변경 국소화. 13개 탭이 모두 이 패턴. |
| "MVVM은 완전한가?" | 완전한 교과서식 MVVM이라고 과장하지 않는다. View/ViewModel/Model 분리와 ViewModel testability가 방향이고, 일부 lifecycle은 code-behind에 남아 있다. |
| "CI/CD로 정확도를 검증한다고 했는데?" | CI/CD는 개선 방법이지 애플리케이션 자체가 아니다. 정확도 주장은 runtime 설계 선택 + Weishi 비교 + 반복 측정이 먼저. Verify/CI는 그 정확도가 회귀하지 않게 막는 supporting evidence. |

---

## 부록 D. 슬라이드 ↔ SW Architecture 문서 근거

| 슬라이드 | 문서 근거 | 핵심 한 줄 |
|---|---|---|
| 2. Quality Attributes & Tradeoffs | 2-Architectural-Drivers.md (QAS-1~6) | QAS are measurable: ±1.0 s/d, ≤one beat period, ≥95% detection, 0 display mismatches. |
| 3. Qt/C++ → Avalonia/.NET | ADR-001 | One codebase; OS audio isolated behind adapters. |
| 4. Architecture Overview | 5-Architectural-View.md, ADR-002, ADR-003 | Core zero dependency; worker-level partial Pipe-and-Filter. |
| 5. Evidence | 3-Risk-Assessment.md, 4-Planned-Experiments.md | EXP-02 closes R-01/R-03; EXP-05 closes R-04; Weishi comparison closes EXP-06. |
| 6. Extensibility | QAS-5, ADR-004 | New graph/filter/measurement ≤1 existing module changed; App/test/verify split. |
| 7. AI Use | ADR-004, EXP-04, R-17/R-18 | AI is useful but checked: tests/Verify/CI/human review are the safety net. |
