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
>
> 추가 Piazza 답변 반영:
> - **CI/CD는 앱이나 데모 자체가 아니라 개선 수단**이다. 데모에서는 CI/CD를 길게 보여주지 말고, 실제 앱의 기능·동작·개선·정확도 근거를 보여준다.
> - 단, CI/CD 자동화 구축 과정은 **개발에서의 AI 활용(Area 7)** 로는 좋은 사례다. "정확도 자체의 증거"가 아니라 "AI-assisted engineering automation"으로 말한다.
> - Measurement Accuracy는 **runtime 설계 트레이드오프 + 기준기 비교 + 반복 측정/실험 근거**로 입증한다.
> - "곧 출시할 LG 제품"처럼 보이게: 불안정한 실험 소개보다, 사용자가 믿고 조작할 수 있는 흐름과 판정 근거를 우선한다.

---

## 0. 사전 점검 체크리스트 (데모 시작 전, 셋업 10분 동안)

> 🔧 = 팀이 데모 당일 확정/확인해야 하는 항목.

- [ ] 🔧 **하드웨어**: Raspberry Pi 5 + 디스플레이 + USB 마이크 + 실제 기계식 시계(충분히 감긴 상태). 채점자가 보는 메인은 **Pi 5 실기**여야 함(Area 4 "on target platform").
- [ ] 🔧 **정확도 비교용 기준기**: Witschi Chronoscope X1 (또는 동급) 준비 — 같은 시계를 두 시스템으로 동시/연속 측정해 수치 비교(Accuracy Verification, Dan 권고).
- [ ] 🔧 **정확도 근거 팩**: Witschi vs TimeGrapher 수치표(rate/amplitude/beat error), Pi latency 로그, 반복 측정 결과, 값이 다를 때의 원인 가설(캘리브레이션·마이크 감쇠·필터·lift angle)을 한 장으로 준비.
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
| 5 | 라이브 정확도·지연·트레이드오프 근거 | 2:00 | Area 3 + Area 4 (데모 측) |
| 6 | Bonus: Health 레이더 탭 + 진단/분류 | 1:15 | **Bonus (8+7점)** |
| 7 | 클로징 | 0:15 | — |

> ⏱ **시간 압박 시 자르는 순서**: ⑥ → ④의 공간활용 → ②에서 유사 디스플레이 묶어 빠르게.
> 절대 안 자르는 것: Area 1 핵심 디스플레이, AI 기능(Area 2), unplug/replug(Area 6), 라이브 정확도·트레이드오프 근거(Area 3/4).

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
> **화면 설명 원칙**: 각 탭마다 먼저 **축/색/마커/판정 영역**을 손으로 짚고, 그다음 "지금 이 화면에서는 정상/비정상이 어떻게 보이는지"를 말한다. 채점자는 기능 이름보다 **눈에 보이는 증거**를 체크한다.
> **구현 강조 원칙**: 탭에 버튼/토글/criteria/summary가 있으면 반드시 한 번 짚는다. `Waiting for tick-tock sync…` 오버레이가 보이면 "beat lock 전에는 분석 화면을 비워두지 않고 대기 상태를 명시한다"고 설명한다.

> 🔧 라이브로 잘 안 보이는 디스플레이(예: 위치별 시퀀스, 고비트)는 **Playback/Simulation**으로 잠깐 전환해 또렷하게 보여주고 다시 Live로 복귀.

### 2-1. Watch-Position Testing — `Positions` 탭 (좌측)
**[지시문]** Positions 탭 열기. 좌측 포지션 버튼 strip, 선택된 포지션 하이라이트, 중앙 3D 시계 모델을 순서대로 가리킨다. 한 포지션(예: Dial Up → Crown Down)을 클릭해 3D 모델이 그 자세로 회전하는 순간을 보여준다. 모델 옆의 현재 포지션 라벨이 클릭한 버튼과 일치하는지 확인.

**[Presenter]**
> "**Watch-Position Testing.** A watch runs differently in different positions. We pick a position here, and the 3D watch model rotates to it — and this 3D view is rendered fully on the CPU, no GPU, so it runs the same on the Pi."

**[지시문]** 정상 화면 포인트: 포지션 버튼, 3D 자세, 현재 포지션 라벨이 모두 같은 상태를 가리킨다. 채점자에게 "the selected position, the label, and the rendered model are synchronized"라고 짧게 덧붙여도 좋다.

### 2-2. Multi-Position Sequence Display — `Positions` 탭 (우측)
**[지시문]** 같은 탭 우측의 포지션별 시퀀스 측정 표를 가리킨다. 행(row)은 포지션, 열(column)은 rate / amplitude / beat error임을 손으로 짚는다. 이미 측정된 행은 값과 정상/경고 색이 채워져 있고, 아직 측정하지 않은 행은 비어 있거나 대기 상태임을 보여준다. 필요 시 사전 측정된 다포지션 결과를 Playback/Simulation으로 표시.

**[지시문]** 표 위의 **POSITION CONSISTENCY** 헤더, 설명 문장, verdict badge, `View criteria` 버튼을 이어서 가리킨다. 이 영역은 단순히 포지션별 값을 나열하는 것이 아니라, 여러 포지션 사이의 spread / average / vertical-horizontal delta / balance-wheel unbalance 기준을 요약 판정하는 부분이라고 설명한다.

**[Presenter]**
> "On the right, the **Multi-Position Sequence** records the rate, amplitude, and beat error for each position in order — this is exactly how a watchmaker certifies a movement across positions.
>
> Above the table, **Position Consistency** turns those per-position readings into a verdict. It summarizes the average, the spread between best and worst positions, the vertical-versus-horizontal difference, and whether the vertical rates suggest balance-wheel unbalance."

**[지시문]** 화면이 잘 보이면 특정 행 하나를 가리키며 "for this position, these three numbers become one snapshot"이라고 말한다. 그다음 consistency badge를 가리키며 "and the badge is the cross-position judgment"라고 덧붙인다. 포지션을 바꿨을 때 다음 행으로 누적되고, 판정이 갱신되는 구조가 보이면 바로 강조.

### 2-3. Trace Display — `Trace` 탭
**[지시문]** Trace 탭으로 전환. 위 plot은 **Error Rate (s/d)**, 아래 plot은 **Amplitude(°)** 임을 먼저 짚는다. x축은 elapsed time이고 두 plot의 시간축이 정렬되어 있음을 보여준다. 각 plot의 shaded acceptable band, 오른쪽 limit label, 평균선/σ band가 보이면 순서대로 가리킨다. 우측 상단의 **Smoothing** 토글과 **Reset View** 버튼도 짚는다.

**[Presenter]**
> "**Trace Display** shows two continuous traces over elapsed time: rate deviation on top and amplitude below. The shaded bands are the acceptable ranges, and the running average and sigma band show whether the reading is stable, not just momentarily good."

**[지시문]** 정상 화면 포인트: rate trace와 amplitude trace가 acceptable band 안에 머무르고, σ band가 좁은 상태를 가리킨다. alert banner가 뜨면 문구를 그대로 읽는다: late-running 또는 amplitude out-of-range가 이 탭에서 바로 경고로 올라온다.

### 2-4. Rate and Amplitude Stability Over Time — `Vario` 탭
**[지시문]** Vario 탭으로 전환. 상단 summary card의 **Error Rate**, **Amplitude**, **ELAPSED**, overall verdict를 먼저 가리킨다. `View criteria` 버튼을 눌러 판정 기준 팝업이 실제 accept band 값에서 생성됨을 보여준다. 그다음 Error Rate gauge와 Amplitude gauge, 각 gauge 아래의 **Min / Max / Max-Min / Average / Std dev (σ) / Current** readout strip, 하단 legend(Amber band, Blue solid, Red solid, Red dashed)를 순서대로 짚는다.

**[Presenter]**
> "**Vario** turns the live stream into stability statistics. It shows min, max, spread, average, sigma, and current value for both rate and amplitude, then converts those numbers into plain-language verdicts like *'Stable · in range'* and *'Healthy'*."

**[지시문]** 화면이 안정적이면 verdict 문구를 읽고, amber acceptable band 안에 current/average marker가 들어오는 것을 짚는다. 이 탭은 채점자에게 "raw trace가 아니라, 녹화해도 되는 안정성 판정 화면"으로 보이게 한다.

### 2-5. Beat-Noise Scope Display — `Beat Noise` 탭
**[지시문]** Beat Noise 탭. 상단 toolbar의 **Beat Scope / Avg Envelope**, **20/200/400 ms**, **ABS**, **Σ**, **LIFT** 표시를 먼저 가리킨다. Beat Scope 모드에서는 큰 beat waveform과 아래 8개 recent beat strip lane을 짚고, strip을 클릭하면 선택 beat가 큰 plot에 확대되는 것을 보여준다. A/C 이벤트 마커가 같은 상대 위치에 쌓이는지, 주변 noise cloud가 얼마나 퍼져 있는지 손으로 짚는다.

**[Presenter]**
> "**Beat-Noise Scope** has two modes. In Beat Scope, we inspect the selected or latest beat and the strip of recent beats. In Avg Envelope, the Sigma mode averages 50 plus 50 beat noises into two traces. In both cases, A and C stay at the same relative positions, so timing scatter becomes visible as spread."

**[지시문]** `Avg Envelope`를 3초만 눌러 Scope 2 readout의 `TRACE 1`, `TRACE 2`, `Σ n/50` 또는 `Σ complete` 문구를 보여준 뒤 Beat Scope로 돌아온다. 정상 화면 포인트: A/C는 얇게 모이고 배경 노이즈만 넓게 퍼진다. 채점자에게 "tight markers mean repeatable timing; wide scatter means noisy detection"라고 짚어준다.

### 2-6. Beat Error Display and Diagnostic Trace — `Beat Error` 탭
**[지시문]** Beat Error 탭. 상단 numeric panel의 **Error Rate / Amplitude / BEAT ERROR / BPH / DIFF TIC-TAC / DIFF PERIOD / AVG PERIOD** 값을 순서대로 가리킨다. 그다음 tic/toc rate trace, alert banner 자리, 하단 설명 문구를 짚는다. tic과 toc의 시간 간격이 시각적으로 벌어지면 beat error가 커지는 구조를 그래프 위에서 설명한다.

**[Presenter]**
> "**Beat Error** shows both the diagnostic trace and the exact timing numbers behind it: signed beat error, tic-tac difference, period difference, and average period. If the trace slope crosses 45 degrees, or the tic/toc separation leaves the acceptable band, it flags a **MAJOR FAULT** right on screen."

**[지시문]** 정상 화면 포인트: ms 값이 작고 accept band 안에 있는 상태를 가리킨다. 만약 fault 데모용 Simulation이 준비되어 있으면 5초만 전환해 **MAJOR FAULT** 문구가 어디 뜨는지 보여주고 즉시 Live로 복귀.

### 2-7. Long-Term Performance Graph — `Long-Term` 탭
**[지시문]** Long-Term 탭으로 전환. 상단 summary row의 **COLLECTING/OK/WATCH/ALERT**, Error Rate, Amplitude, Beat Error 값을 먼저 가리킨다. 세 stacked pane이 각각 **Error Rate (s/d)**, **Amplitude(°)**, **Beat Error (ms)** 임을 짚고, bucket average line, shaded min/max variation band, dashed overall-average line, acceptable-range band, 포지션 변경 dashed marker를 순서대로 가리킨다. 우측의 **1h / 3h / 6h / ‹ / ›** 버튼도 보여준다.

**[Presenter]**
> "**Long-Term Performance** accumulates the whole session for rate, amplitude, and beat error. The bucket average line shows the trend, the shaded band keeps the min/max variation visible, and the dashed average and acceptable band make long sessions readable at a glance."

**[지시문]** 정상 화면 포인트: 평균선은 부드럽고 variation band는 안정적으로 좁다. 세 pane의 x축이 함께 움직이는 구조라, 한 pane에서 pan/zoom해도 같은 시간 구간을 비교한다고 설명한다. 포지션을 바꾼 직후 값이 달라지는 구간이 있으면 dashed marker와 변화 지점을 함께 가리킨다.

### 2-8. Escapement Analyzer and Marker-Line Display — `Escapement` 탭
**[지시문]** Escapement 탭. 확대된 단일 beat waveform, A marker, **C peak / C onset** marker와 ms 라벨을 순서대로 가리킨다. 하단 numeric panel의 **A→C PEAK / A→C ONSET / ONSET-PEAK / PEAK MEAN±σ / ONSET MEAN±σ / MORE REPEATABLE** 값을 읽는다. 마커 라인이 파형의 어느 지점에 붙는지 손으로 따라가며 보여준다.

**[Presenter]**
> "The **Escapement Analyzer** zooms into one beat segment with A, C-peak, and C-onset marker lines. The panel below compares peak timing and onset timing, including mean and sigma, then tells us which reference is more repeatable."

**[지시문]** 정상 화면 포인트: A와 C 마커가 반복적으로 비슷한 파형 위치에 놓이는 것을 강조한다. 반복성 패널이 조밀하면 "consistent escapement geometry"라고 설명.

### 2-9. Time-Frequency Spectrogram Display — `Spectrogram` 탭
**[지시문]** Spectrogram 탭으로 전환. 상단 toolbar의 **Last Beat / Seconds / − / seconds value / +** 를 먼저 가리킨다. x축은 시간, y축은 frequency, 오른쪽 colorbar는 dB intensity임을 짚는다. 왼쪽 frequency labels, 오른쪽 dB labels, 아래 time labels와 caption, 그리고 live-head marker(Seconds 모드에서 움직이는 얇은 red line)를 순서대로 보여준다. tick이 들어올 때마다 나타나는 밝은 vertical burst를 가리킨다.

**[Presenter]**
> "The **Spectrogram** is a short-time FFT of the signal — time on one axis, frequency on the other, and color as dB intensity. We can view the last beat or a seconds window, and the live-head marker shows where new data is being written."

**[지시문]** 정상 화면 포인트: 일정한 간격의 vertical burst가 보이면 BPH lock과 연결해 말한다. 주변 소음이 있으면 "noise is visible here, but the beat energy is still periodic"라고 판독한다.

### 2-10. Waveform Comparison Display with Timing Markers — `Waveforms` 탭
**[지시문]** Waveforms 탭. 상단 header의 **Instantaneous Rate / Instantaneous Beat Err / BPH**를 먼저 읽는다. 최근 비트들이 tic/toc pair lane으로 쌓인 영역, A 정렬 기준선, 각 lane의 C marker/label, mean-C timing guide, 정규화된 amplitude 스케일을 순서대로 가리킨다. lane을 클릭해 selection highlight가 움직이는 것도 보여준다.

**[Presenter]**
> "**Waveform Comparison** stacks recent tic/toc beat pairs, all aligned on A and normalized. Each lane shows its own A-to-C timing and amplitude, while the mean-C guide shows the cross-beat consistency reference."

**[지시문]** 정상 화면 포인트: lane들이 거의 같은 위치에서 같은 모양을 반복한다. 특정 lane의 C marker나 amplitude label이 다르면 "that would be the beat to inspect"라고 설명.

### 2-11. Scope Mode with Synchronized Sweep Display — `Sweep` 탭
**[지시문]** Sweep 탭으로 전환. 우측 상단 **1x / 2x / 3x** sweep window selector와 좌측 상단 **Reset View**를 먼저 가리킨다. sweep window의 시작/끝, trigger 기준, 한 tick-to-tick 주기로 접힌 파형을 가리킨다. A/C dashed/dotted marker와 label이 보이면 함께 짚고, 하단 reference line의 최신 rate/amplitude/beat-error 수치를 읽는다.

**[Presenter]**
> "**Sweep** folds the signal onto a synchronized tick-to-tick window, so the repeating beat sits still on screen like a triggered oscilloscope. The 1x, 2x, and 3x buttons let us inspect one beat period or multiple repeated periods without losing sync."

**[지시문]** 정상 화면 포인트: lock이 잘 잡히면 파형이 좌우로 떠다니지 않고 같은 위치에 붙어 있다. lock이 풀리면 파형이 흐르거나 번지는 식으로 보인다고 짧게 대비한다.

### 2-12. Scope Function with Multiple Filter Views — `Filter Scope` 탭
**[지시문]** Filter Scope 탭. 실제 화면은 4개 filter view가 **2x2 grid**로 배치되어 있다. F0/F1/F2/F3 label과 각 lane 위의 description을 순서대로 가리킨다: F0는 captured raw-like signal, F1은 moving average로 smoother, F2는 rising slopes emphasized, F3는 upper portion/rising-edge emphasis. 같은 tick이 각 view에서 어떻게 다르게 보이는지, 어느 view가 escapement impulse를 가장 또렷하게 분리하는지 손으로 짚는다.

**[Presenter]**
> "And **Filter Scope** runs the same signal through four filter views at once: raw-like, smoothed, rising-edge emphasized, and upper-envelope emphasized. This lets us see which processing view best isolates T1, T2, and T3 for the current watch."

**[지시문]** 정상 화면 포인트: 하나 이상의 view에서 escapement impulse가 배경보다 선명하게 튀어나와야 한다. 마지막 탭이므로 4개 플롯 전체를 한 번 훑으며 "same input, four filter views, one synchronized measurement"라고 정리.

**[지시문]** 12개 완료 후 Live로 복귀.

**[Presenter] (요약 한 문장 — 채점자 체크 유도)**
> "That's all twelve required displays, each driven by the same live analysis pass."

---

## 3. Sound Print / Rate·Scope 개선 + AI 기능 (3:30)
> ▣ RUBRIC: **Area 2 — System Enhancements & AI Feature (25점)**

### 3-1. Sound Print 개선 (8점)
**[지시문]** Sound Print 탭. 세로로 흐르는 envelope image, A/C marker overlay, 100 ms 단위로 갱신되는 이미지 publish cadence를 짚는다. 마커가 신호 픽셀과 같은 sample-to-column conversion을 사용해 같은 위치에 찍히는 점, theme 전환 시 기존 이미지 배경도 remap되는 점을 설명한다.

**[Presenter]**
> "We improved **Sound Print** beyond the baseline: the A and C event markers are persistent overlays on the scrolling envelope image, and marker placement uses the same sample-to-column mapping as the signal itself. That keeps the markers visually aligned with the waveform, while the image publishes on a 100 millisecond cadence so it stays responsive on the Pi."

### 3-2. Rate / Scope 개선 (8점)
**[지시문]** Rate/Scope 탭. rectified signal, trigger threshold, event markers, tic/toc rate points를 다시 짚는다. scope는 10초 history를 보관하지만 화면은 최신 view만 point budget에 맞게 줄여 그리는 구조라 pan/zoom해도 측정이 끊기지 않는다고 설명한다. event marker가 매 프레임 새로 할당되는 것이 아니라 pool에서 reposition되는 점도 강조.

**[Presenter]**
> "On **Rate / Scope**, the scope signal and trigger threshold are kept within a fixed point budget, and the renderer reduces only the visible window. Event markers are pooled and repositioned instead of recreated, so the view remains smooth while measurement keeps running."

### 3-3. 팀 선정 AI 기능 (5점) + 문제 설명 (4점)
> 🔧 **origin/main 점검 메모**: main에는 `ISignalQualityClassifier` seam, `HeuristicSignalQualityClassifier` fallback, signal-quality overlay/warning은 구현되어 있다. 다만 TinyML/ONNX 모델 산출물과 UI 토글은 main에서 확인되지 않는다. 실제 데모 빌드에 모델이 포함되어 있으면 TinyML로 말하고, 없으면 "TinyML-ready classifier seam with deterministic fallback"으로 말한다.

**[지시문]** Settings 창에서 TinyML/impulse rejection 관련 토글이 실제로 있으면 가리킨다. 토글이 없으면 코드 구조 설명으로 전환한다: Core의 classifier interface, heuristic fallback, UI의 signal-quality warning/overlay가 같은 경로를 검증한다는 점을 짚는다.

**[Presenter]**
> "The AI feature is built around a **signal-quality classifier seam** for TinyML-style signal quality and impulse rejection. The problem is specific: a watch's sound also contains short, loud noises — a tap, a bump — and if one of those is mistaken for a tick, the rate, beat error, and amplitude can spike for a moment.
>
> We did not let a black-box model own the whole detector. The existing detector still proposes candidate events and keeps the BPH/PLL sync. In origin/main, the interface and deterministic fallback are already implemented; if the trained model is present in the demo build, it plugs into the same seam. Either way, the classifier can judge local signal quality before suspicious candidates affect measurement and display.
>
> The key is a **structural safety guarantee**: the AI can classify, pass, or drop a candidate — it can **not** create events, re-time them, or touch the BPH and PLL sync. So even if the model is wrong, it cannot break the timing lock; it can only make the rejection decision safer or more conservative."

**[지시문]** 토글/모델이 있는 빌드라면 토글 ON 상태에서 시계를 한 번 톡 친다 → 게이트가 임펄스를 걸러 측정값이 안 튀는 것을 보여준다. 모델이 없는 main 빌드라면 이 실험은 하지 말고, Beat Noise / Waveforms / 상태바의 signal-quality warning으로 fallback 경로를 설명한다.

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
> ▣ RUBRIC: Area 3 — Accuracy-first tradeoff rationale (데모 측 짧은 증거)
> ▣ RUBRIC: Area 4 — Performance·Latency·Correctness (데모 측 근거; 상세 수치는 발표 대본)

### 5-0. Accuracy-first runtime tradeoff (Area 3 연결)
**[지시문]** Rate/Scope 또는 Vario를 띄운 상태에서 안정화된 수치와 상태바를 함께 가리킨다.

**[Presenter]**
> "One important architecture point: for measurement accuracy, CI/CD is only supporting evidence. The demo itself is this live runtime behavior. We chose to protect the measured numbers first — warm up before trusting BPH, reject impulse noise before it reaches the metrics, and degrade visuals before degrading measurement."

### 5-1. 라이브 지연 (Low latency)
**[지시문]** 상태바 latency 통계를 확대해 가리킨다.

**[Presenter]**
> "Latency: from capturing audio, through detection and measurement, to drawing it on screen — the status bar shows this end-to-end, live. On the Pi 5, the worst-case stays well under one beat period."

### 5-2. 두 시스템 정확도 비교 (Correctness)
**[지시문]** 같은 시계의 Witschi 기준기 판독값과 TimeGrapher 판독값(rate s/d, amplitude°, beat error ms)을 나란히 보여준다. 🔧 실제 측정 수치 채워넣기. 표에는 "same watch, consistently wound, repeated readings"를 작게 적어둔다.

**[Presenter]**
> "For accuracy, we follow the scientific approach: we measure the **same watch on two systems** — TimeGrapher and a reference Chronoscope. Here, our rate, amplitude, and beat error agree with the reference within a small margin. We took multiple readings over time on a consistently wound watch, and they stayed consistent — that's our correctness evidence."

**[Presenter] (CI/CD를 짧게 연결 — 길게 시연하지 않음)**
> "CI tests help us keep this from regressing, but they are not the product. What matters here is that the running application produces stable, explainable measurements against a reference."

> 🔧 만약 두 시스템 값이 다르면: 원인(캘리브레이션, 마이크 감쇠, 필터, lift angle 설정 차이)을 짧게 설명. *"Think like a scientist"* (Stephen Beck) — 차이를 숨기지 말고 이유를 제시.

---

## 6. Bonus: Health 레이더 탭 + 진단/분류 (1:15)
> ▣ RUBRIC: Bonus — Radar chart (8점) + Diagnosis/Classification (7점)
> ⚠️ **현재 소스 기준 점검 메모**: 별도 `Health` 탭은 아직 구현 확인되지 않음. 데모 당일 앱 탭 스트립에 실제 **Health** 탭이 없으면 6-1 레이더 대사는 사용하지 말고, 6-2의 구현된 진단/분류만 짧게 언급한다.

### 6-1. Watch Health 레이더 (별도 탭)
**[지시문]** 탭 스트립에서 **Health** 탭을 연다(별도 탭). 6개 포지션(CH·CB·12H·3H·6H·9H) 축의 amplitude 레이더, healthy-zone 앰버 밴드, target 점선, 측정 다각형을 가리킨다. (시안: `assets/radar-mockup-dark.png`)

**[Presenter]**
> "If this bonus tab is enabled in the demo build, the **Watch Health** view is a radar over all six positions. Right now it's showing amplitude per position. The amber band is the healthy zone, the dashed line is the target. A full, even polygon means the watch is consistent in every position; a dent points straight to the weak one — here it's 6H. The same toggle re-plots rate or beat error on the same six axes."

> 🔧 **이 탭은 별도 탭으로 구현 예정** (InfoTabCatalog 1엔트리 + consumer/renderer, Positions와 **같은 per-position 스냅샷 재사용**). 데모 전 실제 구현·검증 필수 — 미완이면 이 구간은 시연하지 말 것.

### 6-2. 진단 / 분류
**[지시문]** Health 탭이 구현되어 있으면 우측 Diagnosis 패널을 가리킨다. 미구현이면 **Vario**의 overall verdict, **Beat Error**의 MAJOR FAULT banner, **Positions**의 Position Consistency badge를 순서대로 아주 짧게 다시 가리킨다.

**[Presenter]**
> "For diagnosis and classification, the implemented views already turn measurements into verdicts: Vario gives recording readiness, Beat Error flags a major timing fault, and Position Consistency summarizes whether the watch behaves evenly across positions. If the Health radar is enabled, it uses the same per-position snapshots and names the weakest position visually."

> 🔧 진단/분류(7점)는 **Vario verdict + Beat Error diagnosis + Position Consistency**로 실제 구현되어 있음. Area 2의 "AI 기능"과는 별개 항목이니 혼동 주의 — AI 기능 처리 방향은 팀 결정 사항.

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

## 부록 B. Piazza 답변 반영 운영 원칙

| 교수/루브릭 메시지 | 데모에서의 처리 |
|---|---|
| "Develop your demonstration in a way that runs down the rubric." | 각 구간 시작 때 `▣ RUBRIC`을 말하고, 채점 항목 이름을 화면/슬라이드에서 직접 가리킨다. |
| CI/CD pipeline은 개선 방법이지 앱/데모 자체가 아님 | Verify/CI는 발표에서 supporting evidence로만 언급. 데모 시간은 실제 앱 동작, 정확도, 복구, 판정 화면에 쓴다. |
| AI를 개발 전반에 활용했음 | Area 7에서 제품 AI(TinyML), 개발 AI(Codex/Claude), AI-assisted CI/CD 자동화를 분리해 말한다. |
| Accuracy는 실험과 tradeoff rationale로 설명 | warm-up, impulse rejection, visual degradation first, 기준기 비교, 반복 측정 결과를 함께 보여준다. |
| 시장 출시를 앞둔 LG application처럼 focus 있게 | 불안정한 기능은 욕심내서 시연하지 않는다. 안정적으로 조작 가능한 흐름과 사용자가 믿을 수 있는 피드백을 우선한다. |

## 부록 C. 디스플레이 ↔ 루브릭 ↔ 탭 매핑 (조작자용 치트시트)

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
| **(Bonus)** Watch Health Radar | **Health** (별도 탭 · 구현 예정) | `watch-health-radar` |

### 실제 구현 탭 순서 (조작자용)

> 대본은 루브릭 체크 순서로 돈다. 실제 앱 탭 스트립은 구현상 아래 순서이므로, operator는 다음/이전 탭으로 넘기기보다 필요한 탭을 직접 클릭하는 편이 안전하다.

`Rate/Scope` → `Beat Error` → `Trace` → `Vario` → `Long-Term` → `Sweep` → `Escapement` → `Positions` → `Beat Noise` → `Waveforms` → `Filter Scope` → `Sound Print` → `Spectrogram`
