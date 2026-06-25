# Final Demo — 라이브 시연 대본 (20분)

> **Team 5 · TimeGrapherNet** — Final LG SW Architect Demo
> 시연 순서: **3번째** (Team 4 → Team 3 → **Team 5** → Team 2 → Team 1)
> 구성: 데모 20분 → (10분 셋업 버퍼) → 발표 20분. 본 문서는 **데모 20분**용.
> 형식: **영어 대사**(채점자에게 그대로 말하는 문장) + **한글 지시문**(무대 동작·클릭·주의).
>
> 작성 원칙 (Stephen Beck Piazza 답변 반영):
> *"develop your demonstration in a way that runs down the rubric."*
> → 데모 동선이 채점 루브릭 순서(Area 1 → 2 → 4 → 6 → Bonus)를 그대로 따라간다.
> 각 구간 머리에 `▣ RUBRIC` 으로 어떤 채점 항목을 채우는지 표기 — 채점자가 따라오기 쉽게,
> 발표 중 슬라이드/화면에서 해당 위치를 가리킨다.

---

## 0. 사전 점검 체크리스트 (데모 시작 전, 셋업 10분 동안)

> 🔧 = 팀이 데모 당일 확정/확인해야 하는 항목.

- [ ] 🔧 **하드웨어**: Raspberry Pi 5 + 디스플레이 + USB 마이크 + 실제 기계식 시계(충분히 감긴 상태). 채점자가 보는 메인은 **Pi 5 실기**여야 함(Area 4 "on target platform").
- [ ] 🔧 **정확도 비교용 기준기**: Witschi Chronoscope X1 (또는 동급) 준비 — 같은 시계를 두 시스템으로 동시/연속 측정해 수치 비교(Accuracy Verification, Dan 권고).
- [ ] 🔧 **역할 분담 확정**: `[Operator]`(앱 조작) / `[Presenter]`(영어 설명). 본 대본의 대사·동작에 실제 팀원 이름을 매핑.
- [ ] **백업 입력 준비** (라이브 마이크 중심이되 재현 안정성 확보):
  - 사전 녹음 WAV (라이브와 같은 시계, 21600 BPH @ 48 kHz) — 마이크 장애 시 **Playback**로 즉시 대체.
  - `sample/43200BPH_synthetic_192000Hz.wav` — 고비트(43200 BPH) 디스플레이 시연용(실물 고비트 무브먼트 없음).
  - **Simulation** 모드 — 어떤 디스플레이도 재현 가능한 최후 안전망.
- [ ] **앱 실행 옵션**: 상태바 지연(latency) 통계가 보이도록 실행. 측정 로그가 필요하면 `--measurement-log`/`--analysis-log` 켜기.
- [ ] **Settings 사전 세팅**: lift angle(시계 모델값), accept band(Error Rate/Amplitude/Beat Error 정상범위) 미리 설정 → 모든 그래프·판정이 같은 기준으로 정상/경고 색을 칠함.
- [ ] **탭 사전 이동 리허설**: 13개 탭 위치를 손에 익혀, 한 탭당 30–45초 안에 설명 가능하도록.
- [ ] **소음 환경**: 데모장 주변 소음 확인. 핸들링 노이즈 필터링 시연(시계 톡톡 두드리기) 동선 확보.

---

## 막 구성 한눈에 (20분 타임라인)

| # | 구간 | 시간 | 채우는 Rubric |
|---|---|---|---|
| 1 | 오프닝 & 라이브 락온 | 2:00 | Area 1 baseline, Area 6 health/status |
| 2 | 12개 필수 디스플레이 투어 | 8:00 | **Area 1 (60점)** |
| 3 | Sound Print / Rate·Scope 개선 + AI 기능 | 3:30 | **Area 2 (25점)** |
| 4 | GUI: unplug/replug · 노이즈 필터 · A/C 동기 · 공간활용 | 3:30 | **Area 6 (25점)** |
| 5 | 라이브 정확도·지연 근거 (두 시스템 비교) | 2:00 | Area 4 (데모 측) |
| 6 | Bonus: 진단/분류 판정 | 0:45 | Bonus |
| 7 | 클로징 | 0:15 | — |

> ⏱ **시간 압박 시 자르는 순서**: ⑥ → ④의 공간활용 → ②에서 유사 디스플레이 묶어 빠르게.
> 절대 안 자르는 것: Area 1 핵심 디스플레이, AI 기능(Area 2), unplug/replug(Area 6), 라이브 정확도(Area 4).

---

## 1. 오프닝 & 라이브 락온 (2:00)
> ▣ RUBRIC: Area 1 baseline(Rate/Scope·Sound Print), Area 6 system health/readiness

**[지시문]** Pi 5 화면을 채점자에게 향하게 두고, 실제 시계를 마이크 앞에 거치. 앱은 켜져 있고 입력은 **Live** 선택 상태.

**[Presenter]**
> "Good morning. We are Team 5. This is **TimeGrapher** — it listens to a mechanical watch through a microphone and measures how accurate the watch is, in real time. Everything you see now is running **live on a Raspberry Pi 5**, the target platform."

**[지시문]** **Start** 클릭. 상태바와 Rate/Scope 탭을 가리킨다.

**[Presenter]**
> "The moment we start, the system auto-detects the beat rate — the BPH — and locks onto it. The status bar shows the system is healthy and synchronized. Down here you can see the throughput and the end-to-end latency."

**[지시문]** 시계 거치 직후 락이 잡힐 때까지 2–3초 대기. **Rate/Scope** 탭에서 정류파형·트리거·tic/toc 레이트 점이 안정되는 것을 가리킨다.

**[Presenter]**
> "On the **Rate/Scope** view: the blue trace is the rectified signal, the red line is the trigger threshold, and these points are the rate of the tick and the tock. They are already settling into two stable lines — that means the watch is keeping good time."

**[지시문]** **Sound Print** 탭으로 전환. 비트별 엔벨로프 이미지가 세로 줄로 쌓이는 것을 가리킨다.

**[Presenter]**
> "And this is **Sound Print** — each column is one beat's acoustic envelope. A clean, repeating pattern means clean detection. These two — Rate/Scope and Sound Print — are our baseline views; everything else builds on them."

---

## 2. 12개 필수 디스플레이 투어 (8:00)
> ▣ RUBRIC: **Area 1 — Additional Real-Time Graphs and Diagnostic Displays (60점, 12 × 5점)**

> **동선 원칙**: 채점자가 12개를 빠짐없이 체크하도록, 탭을 **루브릭 표 순서에 가깝게** 돈다.
> 각 탭에서 ① 무엇을 보는지 ② 이 시계에 대해 무엇을 말해주는지 1–2문장. 한 탭 30–45초.
> **[지시문]**: 탭 전환 시 채점자에게 *"This covers the rubric item: ___"* 라고 명시하면 체크가 빨라진다.

> 🔧 라이브로 잘 안 보이는 디스플레이(예: 위치별 시퀀스, 고비트)는 **Playback/Simulation**으로 잠깐 전환해 또렷하게 보여주고 다시 Live로 복귀.

### 2-1. Watch-Position Testing — `Positions` 탭 (좌측)
**[지시문]** Positions 탭 열기. 좌측 포지션 버튼 strip과 3D 시계 모델을 가리킨다. 한 포지션(예: Dial Up) 클릭 → 3D 모델이 그 자세로 회전.

**[Presenter]**
> "**Watch-Position Testing.** A watch runs differently in different positions. We pick a position here, and the 3D watch model rotates to it — and this 3D view is rendered fully on the CPU, no GPU, so it runs the same on the Pi."

### 2-2. Multi-Position Sequence Display — `Positions` 탭 (우측)
**[지시문]** 같은 탭 우측의 포지션별 시퀀스 측정 표를 가리킨다. (필요 시 사전 측정된 다포지션 결과를 보여줌.)

**[Presenter]**
> "On the right, the **Multi-Position Sequence** records the rate, amplitude, and beat error for each position in order — this is exactly how a watchmaker certifies a movement across positions."

### 2-3. Trace Display — `Trace` 탭
**[Presenter]**
> "**Trace Display** plots the running rate over time as two lines — tick and tock. If the watch is stable, the lines stay flat and parallel; drift or instability shows up immediately as a slope or spread."

### 2-4. Rate and Amplitude Stability Over Time — `Vario` 탭
**[지시문]** Vario 게이지와 상단/하단 판정 텍스트를 가리킨다.

**[Presenter]**
> "**Vario** shows rate and amplitude stability with live gauges and a plain-language verdict — for example *'Stable · in range'* or *'Healthy'*. This is the at-a-glance answer to *'is this watch good?'*"

### 2-5. Beat-Noise Scope Display — `Beat Noise` 탄
**[지시문]** Beat Noise 탭. A/C 세그먼트가 같은 상대 위치에 쌓이는 것을 가리킨다.

**[Presenter]**
> "**Beat-Noise Scope** overlays each beat's A and C events at the same relative position, so any timing scatter — the 'noise' between beats — becomes visible as spread."

### 2-6. Beat Error Display and Diagnostic Trace — `Beat Error` 탭
**[지시문]** Beat Error 탭. tic/toc 레이트 트레이스 + 숫자 패널 + 진단 문구를 가리킨다.

**[Presenter]**
> "**Beat Error** shows the separation between tick and tock in milliseconds, with a diagnostic panel. If the trace slope crosses 45 degrees, or the tic/toc separation leaves the acceptable band, it flags a **MAJOR FAULT** right on screen."

### 2-7. Long-Term Performance Graph — `Long-Term` 탭
**[Presenter]**
> "**Long-Term Performance** accumulates the whole session — bucket averages with min/max variation bands — and stays cheap to draw even after hours of running, because the history is decimated as it grows. Dashed markers show where we switched positions."

### 2-8. Escapement Analyzer and Marker-Line Display — `Escapement` 탭
**[지시문]** Escapement 탭. A/C 마커 라인과 ms 라벨, onset-vs-peak 반복성 패널을 가리킨다.

**[Presenter]**
> "The **Escapement Analyzer** zooms into one beat segment with A and C marker lines and millisecond labels, plus an onset-versus-peak repeatability panel — this is where you read the escapement's behavior directly."

### 2-9. Time-Frequency Spectrogram Display — `Spectrogram` 탭
**[Presenter]**
> "The **Spectrogram** is a short-time FFT of the signal — time on one axis, frequency on the other. The tick energy shows up as bright vertical bursts, which helps separate real escapement sound from background noise."

### 2-10. Waveform Comparison Display with Timing Markers — `Waveforms` 탭
**[지시문]** Waveforms 탭. 최근 비트들이 A 정렬·정규화되어 레인으로 쌓이고 A / mean-C 타이밍 가이드가 보이는 것을 가리킨다.

**[Presenter]**
> "**Waveform Comparison** stacks the recent beats, all aligned on A and normalized, with the A and mean-C timing guides — so you can see beat-to-beat consistency at a glance, and spot any beat that misbehaves."

### 2-11. Scope Mode with Synchronized Sweep Display — `Sweep` 탭
**[Presenter]**
> "**Sweep** folds the signal onto one tick-to-tick window — a synchronized sweep — so the repeating beat sits still on screen, like a triggered oscilloscope."

### 2-12. Scope Function with Multiple Filter Views — `Filter Scope` 탭
**[지시문]** Filter Scope 탭. 4개 스택 플롯(서로 다른 필터 대역)을 가리킨다.

**[Presenter]**
> "And **Filter Scope** runs the same signal through four different filter bands at once — stacked here — so you can choose the view that isolates the escapement sound best for a given watch."

**[지시문]** 12개 완료 후 Live로 복귀.

**[Presenter] (요약 한 문장 — 채점자 체크 유도)**
> "That's all twelve required displays, each driven by the same live analysis pass."

---

## 3. Sound Print / Rate·Scope 개선 + AI 기능 (3:30)
> ▣ RUBRIC: **Area 2 — System Enhancements & AI Feature (25점)**

### 3-1. Sound Print 개선 (8점)
**[지시문]** Sound Print 탭. 개선점(마커 라인, A/C 정렬, 가독성/이벤트 검출 향상)을 가리킨다. 🔧 *팀의 실제 개선 포인트로 문장 교체*.

**[Presenter]**
> "We improved **Sound Print** beyond the baseline: the A and C events are marked and aligned the same way every cycle, and the marker lookup is now constant-time, so even on the Pi the columns keep up with the beat. The result is easier to read and the events are easier to spot."

### 3-2. Rate / Scope 개선 (8점)
**[지시문]** Rate/Scope 또는 Sweep. 개선점(트리거 명확성, 디시메이션 예산으로 끊김 없는 측정, 정상범위 밴드 색)을 가리킨다.

**[Presenter]**
> "On **Rate / Scope**, the points are decimated to a fixed budget on the producer side, so the graph never stalls no matter how long we run. And the accept-range band is shared with every other view — when a reading goes out of range, every graph agrees on it at the same moment."

### 3-3. 팀 선정 AI 기능 (5점) + 문제 설명 (4점)
> 🔧 **데모 전 반드시 확정**: 실제로 ONNX TinyML 모델이 붙어 동작하는지, 아니면 클래식 게이트(`PllMatchGate`)가 같은 자리에서 도는지. 아래 대사는 **현재 코드 상태(시임 + PllMatchGate 셔핑, ONNX는 드롭인 예정)**에 맞춰 정직하게 작성. 모델이 완성됐다면 더 강하게 말해도 됨.

**[지시문]** Settings 창 열기 → `PLL Event Veto (impulse rejection)` 토글을 가리킨다. 토글 ON/OFF로 효과 대비.

**[Presenter]**
> "Our AI feature targets one specific problem: a watch's sound also contains **short, loud noises** — a tap, a bump — and if one of those is mistaken for a tick, the rate, beat error, and amplitude can spike for a moment.
>
> So instead of replacing the detector with a black-box model, we added a **candidate gate**. The existing detector finds candidate events; the gate then **drops the ones that look like noise** before they reach measurement and display.
>
> The key is a **structural safety guarantee**: the gate can only pass or drop a candidate — it can **not** create events, re-time them, or touch the BPH and PLL sync. So even a wrong model can never break the lock. Today this slot ships a classical PLL-match gate, and it's designed so a trained TinyML ONNX model drops straight into the same interface — the architecture is the proof of concept."

**[지시문]** 토글 ON 상태에서 시계를 한 번 톡 친다 → 게이트가 임펄스를 걸러 측정값이 안 튀는 것을 보여준다 (Area 6 노이즈 필터와 연결되는 자연스러운 다리).

**[Presenter]**
> "Watch the readings as I tap once — with the gate on, the spike is rejected and the measurement stays steady."

---

## 4. GUI: unplug/replug · 노이즈 필터 · A/C 동기 · 공간활용 (3:30)
> ▣ RUBRIC: **Area 6 — Remote UI / GUI Modifications (25점)**

### 4-1. 센서/마이크 unplug & replug (5점)
**[지시문]** 라이브 측정 중에 **USB 마이크를 물리적으로 뽑는다.**

**[Presenter]**
> "Now I'll unplug the microphone while it's running."

**[지시문]** 상태바에 다음 문구가 뜨는 것을 가리킨다: *"Live audio stopped unexpectedly. Please check your device connection."* 장치 목록이 자동 갱신되는 것을 보여준다.

**[Presenter]**
> "The system detects it immediately — it stops cleanly, tells the user exactly what happened, and refreshes the device list. No crash, no frozen graph. This is handled by an explicit run-state machine."

**[지시문]** 마이크를 다시 꽂고 → 장치 재선택 → **Start**. 정상 복귀.

**[Presenter]**
> "I plug it back in, re-select the device, start again — and we're measuring live once more."

### 4-2. 핸들링 노이즈 필터링 (4점)
**[지시문]** 측정 중 시계/센서를 손가락으로 톡톡 두드린다. A/C는 유지되고 탭 노이즈는 걸러지는 것을 가리킨다.

**[Presenter]**
> "Handling the watch creates taps that look loud. We filter that handling noise — with the regime guard and impulse rejection — while preserving the real A and C events. A single impulse, like a door slam, is debounced over a few beats, so one bump can't wipe out the lock or the history."

### 4-3. 비트 동기화 A/C 표시 (4점)
**[지시문]** Beat Noise 또는 Waveforms 탭. A와 C가 매 사이클 **같은 상대 위치**에 놓이는 것을 가리킨다.

**[Presenter]**
> "For beat-synchronized display: every cycle, A and C are placed at the **same relative location** on the graph. So irregular timing shows up as deviation from that fixed position — you don't have to chase it across the screen."

### 4-4. 화면 공간 활용 + 가독성 (4점 + 4점)
**[지시문]** Settings 창을 열어 자주 안 쓰는 옵션(C-onset, 샘플링 파라미터, accept band, CSV 로그)이 거기로 정리돼 있음을 보여준다. 메인 화면이 그래프 중심으로 깔끔함을 강조.

**[Presenter]**
> "Less-used controls — sampling parameters, accept bands, logging — live in a separate **Settings** window, so the main screen stays focused on the graphs. The instrument look — flat zero-radius corners, the sapphire-crystal theme, light and dark — is consistent across every view."

### 4-5. 시스템 상태/측정 준비 피드백 (4점)
**[지시문]** 상태바의 throughput·latency, 그리고 Vario의 *"OK - Stable enough to record"* 류 판정을 가리킨다.

**[Presenter]**
> "And the system always reports its own health: throughput and latency in the status bar, and a measurement-readiness verdict — *'OK — stable enough to record'*, *'WATCH'*, or *'ALERT — service required'* — so the user knows when the reading can be trusted."

---

## 5. 라이브 정확도 & 지연 근거 (2:00)
> ▣ RUBRIC: Area 4 — Performance·Latency·Correctness (데모 측 근거; 상세 수치는 발표 대본)

### 5-1. 라이브 지연 (Low latency)
**[지시문]** 상태바 latency 통계를 확대해 가리킨다.

**[Presenter]**
> "Latency: from capturing audio, through detection and measurement, to drawing it on screen — the status bar shows this end-to-end, live. On the Pi 5, the worst-case stays well under one beat period."

### 5-2. 두 시스템 정확도 비교 (Correctness)
**[지시문]** 같은 시계의 Witschi 기준기 판독값과 TimeGrapher 판독값(rate s/d, amplitude°, beat error ms)을 나란히 보여준다. 🔧 실제 측정 수치 채워넣기.

**[Presenter]**
> "For accuracy, we follow the scientific approach: we measure the **same watch on two systems** — TimeGrapher and a reference Chronoscope. Here, our rate, amplitude, and beat error agree with the reference within a small margin. We took multiple readings over time on a consistently wound watch, and they stayed consistent — that's our correctness evidence."

> 🔧 만약 두 시스템 값이 다르면: 원인(캘리브레이션, 마이크 감쇠, 필터, lift angle 설정 차이)을 짧게 설명. *"Think like a scientist"* (Stephen Beck) — 차이를 숨기지 말고 이유를 제시.

---

## 6. Bonus: 진단 / 분류 판정 (0:45)
> ▣ RUBRIC: Bonus — Diagnosis/Classification (최대 7점)

**[지시문]** Vario / Beat Error 탭의 판정 텍스트를 가리킨다.

**[Presenter]**
> "As a bonus, the app already turns the raw numbers into a **diagnosis**. Vario classifies the watch — *Healthy*, *Slightly low*, *Low · service*, *out of range*, *unstable* — and gives an overall call on whether it's safe to record. Beat Error flags a major fault when the trace slope exceeds the 45-degree limit. It's rule-based today, but it's tied directly to the live measured data."

> 🔧 **레이더 차트(Bonus 8점)는 현재 미구현.** 두 가지 선택:
> 1) 데모 전 다포지션 데이터를 radar로 그리는 화면을 추가한다(Positions 데이터 재사용 → 구현 부담 낮음), 또는
> 2) 보너스 레이더는 시연하지 않고 진단/분류만 청구. **없는 기능을 있다고 말하지 말 것.**

---

## 7. 클로징 (0:15)
**[Presenter]**
> "To sum up — twelve real-time displays, an architecture that keeps accuracy first, all running live on the Pi 5. We'll go deeper into the architecture and the evidence in the presentation. Thank you."

**[지시문]** 발표 대본(`2-Presentation-Script.md`)으로 전환.

---

## 부록 A. 라이브 장애 대응 (Robustness 플레이북)

| 증상 | 즉시 대응 | 대사 (자연스럽게) |
|---|---|---|
| 마이크가 락을 못 잡음 | 입력을 **Playback**(사전 녹음 WAV)으로 전환 | "Let me switch to a recording of the same watch so it's easier to see." |
| 마이크 장애/잡음 폭주 | Playback 또는 **Simulation** | (위와 동일) |
| 고비트(43200) 디스플레이 | `43200BPH_synthetic_192000Hz.wav` Playback | "For a high-beat movement we use a 192 kHz recording." |
| 특정 탭 렌더 느림 | 상태바 *"Display quality was reduced…"* 를 **기능으로** 설명 | "Notice it protects measurement by easing the visuals first — that's by design." |
| 앱 멈춤 | Reset → 재시작 (State machine 복구 경로) | "The run-state machine lets us recover cleanly with Reset." |

> 핵심: **모든 장애를 '설계된 동작'으로 프레이밍**한다. 점진적 저하·unplug 복구·백업 입력 전환은 전부 루브릭 점수(Area 4 real-time, Area 6 unplug, Availability)로 환산된다.

## 부록 B. 디스플레이 ↔ 루브릭 ↔ 탭 매핑 (조작자용 치트시트)

| Rubric (Area 1) | 탭 이름 | Tab ID |
|---|---|---|
| Watch-Position Testing | Positions (좌) | `watch-positions` |
| Multi-Position Sequence Display | Positions (우) | `watch-positions` |
| Trace Display | Trace | `trace-display` |
| Rate and Amplitude Stability Over Time | Vario | `rate-amplitude-stability` |
| Beat-Noise Scope Display | Beat Noise | `beat-noise-scope` |
| Beat Error Display and Diagnostic Trace | Beat Error | `beat-error-diag` |
| Long-Term Performance Graph | Long-Term | `long-term-perf` |
| Escapement Analyzer and Marker-Line Display | Escapement | `escapement-analyzer` |
| Time-Frequency Spectrogram Display | Spectrogram | `spectrogram` |
| Waveform Comparison Display with Timing Markers | Waveforms | `waveform-compare` |
| Scope Mode with Synchronized Sweep Display | Sweep | `scope-sweep` |
| Scope Function with Multiple Filter Views | Filter Scope | `multi-filter-scope` |
| (baseline) | Rate/Scope | `rate-scope` |
| (baseline) | Sound Print | `sound-print` |
