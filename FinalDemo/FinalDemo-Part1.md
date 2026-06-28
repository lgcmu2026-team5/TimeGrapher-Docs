# TimeGrapher Final Presentation Script — Part 1: Demo

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

### 발표 (20분) — 상세는 Part2 파일 참조

| # | 슬라이드 | 시간 | 채우는 Rubric |
|---|---|---|---|
| 1 | 타이틀 & 구현 표면 | 0:45 | — |
| 2 | 품질속성 & 트레이드오프 (accuracy 최우선) | 4:30 | **Area 3 (20점)** |
| 3 | 성능·지연·정확성 근거 (Pi 5 실측) | 4:00 | **Area 4 (25점)** |
| 4 | 아키텍처 개요: 기술 선택 · Layers · Core 무의존 · CI 강제 경계 | 3:30 | **Area 5 (20점)** |
| 5 | 확장성 심화: 새 측정/필터/탭 추가 | 2:00 | **Area 5 (20점)** |
| 6 | AI 활용 (TinyML + 개발 전반) | 3:00 | **Area 7 (15점)** |
| 7 | UI Enhancement (SoundPrint · Rate/Scope · GUI) | 1:30 | Area 2·6 |
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
