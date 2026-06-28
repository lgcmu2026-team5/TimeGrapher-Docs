# TimeGrapher 최종 발표 스크립트 (한국어) — Part 1: 데모

> **Team 5 · TimeGrapherNet** — 최종 LG SW Architect 데모 & 발표
> 순서: 데모 20분 → (셋업 버퍼 10분) → 발표 20분.
> 형식: **[발표자]** 한국어 대사 + **[지시문]** 동작 지시.
>
> 루브릭 동선: Area 1 → 2 → 6 → 3 → 4 → 5 → 7 → Bonus
> *"루브릭 순서를 따라 데모를 구성하라."* (Stephen Beck)

---

## 0. 사전 점검 체크리스트 (셋업 10분)

- [ ] **하드웨어**: Raspberry Pi 5 + 디스플레이 + USB 마이크 + 실제 기계식 시계(충분히 감긴 상태). 채점자가 보는 메인은 **Pi 5 실기**여야 함 (Area 4 "on target platform").
- [ ] **비교용 기기**: **Weishi Timegrapher** 준비 — 같은 시계를 두 시스템으로 연속 측정해 rate/amplitude/beat error 수치 비교 (EXP-06, Area 4 Correctness).
- [ ] **정확도 근거 팩**: Weishi vs TimeGrapher 수치표 한 장, Pi latency 로그, 허용오차 기준(Witschi grade ±1 s/d · amplitude ±1° · beat error ±0.1 ms).
- [ ] **역할 분담**: `[Operator]`(앱 조작) / `[발표자]`(설명) — 팀원 이름 매핑 확정.
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

# PART 1 — 데모 (20분)

---

## 1. 오프닝 & 라이브 락온 (1:30)
> ▣ RUBRIC: Area 1 baseline (Rate/Scope · Sound Print), Area 6 system health/readiness

**[지시문]** Pi 5 화면을 채점자에게 향하게 두고, 실제 시계를 마이크 앞에 거치. 앱은 켜져 있고 입력은 **Live** 선택 상태. **Start** 클릭 후 2–3초 대기.

**[발표자]**
> "안녕하세요. 저희는 팀 5입니다. 이것은 **TimeGrapher**입니다 — 마이크를 통해 기계식 시계 소리를 듣고, 시계의 정확도를 실시간으로 측정하는 시스템입니다. 지금 화면에 보이는 모든 것은 목표 플랫폼인 **Raspberry Pi 5에서 라이브로 실행** 중입니다."

**[지시문]** Rate/Scope 탭에서 정류파형·트리거·tic/toc 레이트 점이 안정되는 것을 가리킨다.

**[발표자]**
> "**Rate/Scope** 화면을 보면: 파란색 트레이스는 정류 신호, 빨간 선은 트리거 임계값이고, 이 점들이 틱과 톡의 레이트입니다 — 이미 두 개의 안정적인 선으로 수렴하고 있습니다. 상태바는 시스템이 정상이고 동기화되었음을 보여주며, 엔드투엔드 지연 시간도 여기서 확인할 수 있습니다."

**[지시문]** Sound Print 탭으로 전환.

**[발표자]**
> "이것은 **Sound Print**입니다 — 각 열이 한 박자의 음향 엔벌로프입니다. 깨끗하게 반복되는 패턴은 정확한 검출을 의미합니다. 이 두 탭이 기준 화면이고, 나머지 모든 기능은 이 위에 구축됩니다."

---

## 2. 12개 필수 디스플레이 투어 (8:00)
> ▣ RUBRIC: **Area 1 — Additional Real-Time Graphs and Diagnostic Displays (60점, 12 × 5점)**

> 동선 원칙: 각 탭에서 ① 무엇을 보는지 ② 이 시계에 대해 무엇을 말해주는지 1–2문장. 탭당 30–45초.
> 각 탭마다 **축/색/마커/판정 영역**을 먼저 짚고, "지금 이 화면에서는 정상/비정상이 어떻게 보이는지"를 말한다.

### 2-1. Watch-Position Testing — `Positions` 탭 (좌측)
> ▣ RUBRIC: Watch-Position Testing (5점)

**[지시문]** Positions 탭 열기. 좌측 포지션 버튼 strip과 3D 시계 모델을 가리킨다. 포지션(예: Dial Up → Crown Down)을 클릭해 3D 모델이 회전하는 것을 보여준다.

**[발표자]**
> "**시계 자세 테스트**입니다. 시계는 놓인 자세에 따라 다르게 작동합니다. 여기서 자세를 선택하면 — CH, CB, 6H, 9H, 3H, 12H, 그리고 중간 자세들 — 3D 시계 모델이 해당 방향으로 회전하고, 현재 활성화된 자세가 하이라이트되어 시계사가 어떤 측정값을 보고 있는지 항상 알 수 있습니다."

---

### 2-2. Multi-Position Sequence Display — `Positions` 탭 (우측)
> ▣ RUBRIC: Multi-Position Sequence Display (5점)

**[지시문]** 같은 탭 우측 포지션별 시퀀스 측정 표를 가리킨다. 행은 포지션, 열은 rate / amplitude / beat error. Position Consistency 헤더와 verdict badge, `View criteria` 버튼을 순서대로 짚는다.

**[발표자]**
> "오른쪽에는 **다중 자세 시퀀스** 기록이 있습니다 — 각 자세별로 레이트, 진폭, 비트 에러를 최대 10개 자세까지 순서대로 기록합니다. 표 위의 **Position Consistency**는 자세별 측정값을 판정으로 변환합니다: 평균 X, 최상과 최하의 차이 D, 수직-수평 델타, 그리고 수직 레이트가 밸런스 휠 불균형을 시사하는지 여부를 알려줍니다."

---

### 2-3. Trace Display — `Trace` 탭
> ▣ RUBRIC: Trace Display (5점)

**[지시문]** Trace 탭으로 전환. 위 plot은 Error Rate (s/d), 아래는 Amplitude(°). shaded acceptable band, 평균선, σ band, Smoothing 토글을 순서대로 짚는다.

**[발표자]**
> "**Trace 디스플레이**는 경과 시간에 따른 두 개의 연속 트레이스를 보여줍니다: 위는 레이트 편차, 아래는 진폭입니다. 음영 처리된 밴드가 허용 범위입니다. 롤링 평균이 지속적으로 업데이트되어 단기 노이즈를 평활화하고, 레이트가 음수가 되거나 진폭이 270–300° 창을 벗어나면 여기서 경보가 발생합니다."

---

### 2-4. Rate and Amplitude Stability — `Vario` 탭
> ▣ RUBRIC: Rate and Amplitude Stability Over Time (5점)

**[지시문]** Vario 탭. 상단 summary card의 verdict, Error Rate / Amplitude gauge, 각 gauge 아래의 Min / Max / Max-Min / Average / Std dev / Current readout strip, amber acceptable band를 순서대로 짚는다.

**[발표자]**
> "**Vario**는 라이브 스트림을 안정성 통계로 변환합니다 — 레이트와 진폭 모두에 대해 최솟값, 최댓값, 범위, 평균, 표준편차, 현재값을 보여주고, 이 수치들을 *'안정 · 범위 내'*, *'정상'* 같은 평이한 언어의 판정으로 변환합니다."

---

### 2-5. Beat-Noise Scope Display — `Beat Noise` 탭
> ▣ RUBRIC: Beat-Noise Scope Display (5점)

**[지시문]** Beat Noise 탭. toolbar의 Beat Scope / Avg Envelope, 20/200/400 ms, Σ 버튼을 가리킨다. Scope 1에서 큰 beat waveform과 8개 recent strip lane, A/C 이벤트 마커를 짚는다. strip을 클릭해 선택 beat가 확대되는 것을 보여준다.

**[발표자]**
> "**Beat-Noise Scope**에는 두 개의 스코프가 있습니다. 스코프 1: 20, 200, 400 ms 중 선택 가능한 시간 범위의 라이브 파형 — 최근 비트 스트립이 비교를 위해 아래에 누적됩니다. 스코프 2: Σ 토글이 틱과 톡 인터벌 각 50개를 평균 내어 랜덤 노이즈를 제거합니다. A와 C 이벤트 마커는 두 스코프 모두에서 같은 상대 위치에 표시됩니다."

**[지시문]** Avg Envelope를 3초 보여준 뒤 Beat Scope로 복귀.

---

### 2-6. Beat Error Display and Diagnostic Trace — `Beat Error` 탭
> ▣ RUBRIC: Beat Error Display and Diagnostic Trace (5점)

**[지시문]** Beat Error 탭. 상단 numeric panel의 Error Rate / Amplitude / BEAT ERROR / BPH / DIFF TIC-TAC 값을 순서대로 가리킨다. tic/toc rate trace, acceptable range shaded band, slope를 짚는다.

**[발표자]**
> "**Beat Error** 탭은 진단 트레이스와 정확한 타이밍 수치 모두를 보여줍니다: 부호 있는 비트 에러, 틱-탁 차이, 주기 차이, 평균 주기. 두 트레이스 선 — 파란색이 틱, 주황색이 톡 — 은 시간에 따른 타이밍 동작을 나타냅니다. 기울기가 45도에 달하거나, 틱/톡 간격이 허용 밴드를 벗어나면 화면에 **MAJOR FAULT** 표시가 뜹니다."

---

### 2-7. Long-Term Performance Graph — `Long-Term` 탭
> ▣ RUBRIC: Long-Term Performance Graph (5점)

**[지시문]** Long-Term 탭. 세 stacked pane(Error Rate / Amplitude / Beat Error), bucket average line, shaded min/max variation band, dashed overall-average, acceptable-range band, 우측 1h/3h/6h 버튼을 순서대로 가리킨다.

**[발표자]**
> "**Long-Term 성능 그래프**는 레이트, 진폭, 비트 에러에 대한 전체 세션 데이터를 누적합니다. 버킷 평균선이 추세를 보여주고, 경과 시간이 길어질수록 업데이트 빈도가 낮아져 24시간 운행에도 그래프가 읽기 쉽게 유지됩니다. 음영 밴드는 최소/최대 변동을 가시화하고, 허용 한계선을 통해 트레이스가 목표 범위에 대해 어느 위치에 있는지 확인할 수 있습니다."

---

### 2-8. Escapement Analyzer and Marker-Line Display — `Escapement` 탭
> ▣ RUBRIC: Escapement Analyzer and Marker-Line Display (5점)

**[지시문]** Escapement 탭. 확대된 단일 beat waveform, A marker, C peak / C onset marker와 ms 라벨을 순서대로 가리킨다. 하단 numeric panel의 A→C PEAK / A→C ONSET / PEAK MEAN±σ / ONSET MEAN±σ / MORE REPEATABLE 값을 읽는다.

**[발표자]**
> "**Escapement Analyzer**는 A, C-peak, C-onset 마커 선과 함께 한 박자를 확대해 보여줍니다. 패널은 평균과 시그마를 포함한 피크 타이밍과 온셋 타이밍을 비교하고, 어느 기준이 더 재현성이 높은지 알려줍니다. 상세 검사를 위해 일시정지 및 캡처가 가능하며, 마커 기준점 — 온셋 vs 피크 — 은 도구모음에서 선택할 수 있습니다."

---

### 2-9. Time-Frequency Spectrogram — `Spectrogram` 탭
> ▣ RUBRIC: Time-Frequency Spectrogram Display (5점)

**[지시문]** Spectrogram 탭. x축 시간, y축 frequency, 오른쪽 colorbar(dB), Last Beat / Seconds 토글, live-head marker를 순서대로 가리킨다. tick이 들어올 때마다 나타나는 vertical burst를 짚는다.

**[발표자]**
> "**스펙트로그램**은 단시간 FFT입니다 — 한 축은 시간, 다른 축은 주파수, 색상은 dB 강도입니다. 마지막 비트 또는 초 단위 창으로 볼 수 있습니다. 라이브 헤드 마커는 새 데이터가 기록되는 위치를 보여줍니다. 주기적인 수직 버스트가 비트 락을 확인해줍니다."

---

### 2-10. Waveform Comparison Display with Timing Markers — `Waveforms` 탭
> ▣ RUBRIC: Waveform Comparison Display with Timing Markers (5점)

**[지시문]** Waveforms 탭. 상단 header의 Instantaneous Rate / Beat Err / BPH를 읽는다. tic/toc pair lane들, A 정렬 기준선, C marker/label, mean-C timing guide, signal envelopes를 순서대로 가리킨다.

**[발표자]**
> "**파형 비교 디스플레이**는 최근 틱/톡 비트 쌍을 모두 A에 정렬하여 쌓아 보여줍니다. 비트 간 파형 모양, 간격, 일관성을 시각적으로 비교할 수 있으며 신호 엔벌로프가 겹쳐집니다. 수직 가이드 마커는 T1, T2, T3 랜드마크를 식별하는 데 도움을 줍니다. 레이트, 비트 에러, BPH가 모두 같은 소스 프레임에서 헤더에 표시됩니다."

---

### 2-11. Scope Mode with Synchronized Sweep Display — `Sweep` 탭
> ▣ RUBRIC: Scope Mode with Synchronized Sweep Display (5점)

**[지시문]** Sweep 탭. 우측 상단 1x / 2x / 3x sweep window selector, A/C dashed marker, 하단 reference line의 rate/amplitude/beat-error 수치를 가리킨다.

**[발표자]**
> "**Sweep**은 신호를 트리거된 오실로스코프처럼 동기화된 틱-투-틱 창에 접어 보여줍니다. 시계가 정확히 레이트에 맞을 때 비트 패턴이 정지해 보입니다. 빠르거나 느릴 때는 패턴이 흘러 — 숫자를 보지 않아도 즉시 알 수 있습니다. 1x, 2x, 3x 버튼으로 하나 또는 여러 박자 주기를 검사할 수 있습니다."

---

### 2-12. Scope Function with Multiple Filter Views — `Filter Scope` 탭
> ▣ RUBRIC: Scope Function with Multiple Filter Views (5점)

**[지시문]** Filter Scope 탭. F0/F1/F2/F3 label이 2×2 grid로 배치된 화면. 각 label과 description을 순서대로 가리킨다: F0(raw-like), F1(moving average), F2(rising slopes emphasized), F3(upper envelope). 같은 tick이 각 view에서 어떻게 다르게 보이는지 손으로 짚는다.

**[발표자]**
> "**Filter Scope**는 같은 신호를 네 개의 필터 뷰로 동시에 보여줍니다: 원신호에 가까운 F0, 평활화된 F1, 상승 에지를 강조한 F2, 상단 엔벌로프를 강조한 F3 — 모두 같은 시간 축으로. 현재 시계에 대해 어떤 처리 뷰가 T1, T2, T3를 가장 잘 분리하는지 확인할 수 있습니다. 네 개가 실시간으로 함께 업데이트됩니다."

**[지시문]** 12개 완료 후 Live로 복귀.

**[발표자]**
> "이것으로 12개의 필수 디스플레이를 모두 보여드렸습니다. 모두 같은 라이브 분석 패스에서 구동됩니다."

---

## 3. SoundPrint / Rate·Scope 개선 + AI 기능 (3:30)
> ▣ RUBRIC: **Area 2 — System Enhancements & AI Feature (25점)**

### 3-1. SoundPrint 개선 (8점)

**[지시문]** Sound Print 탭. 세로로 흐르는 envelope image, A/C marker overlay, 100 ms 갱신 cadence를 짚는다. 마커가 신호 픽셀과 같은 sample-to-column conversion을 사용해 같은 위치에 찍히는 점을 설명한다.

**[발표자]**
> "**Sound Print**를 기준 구현 이상으로 개선했습니다: A와 C 이벤트 마커가 스크롤되는 엔벌로프 이미지 위에 영구 오버레이로 표시됩니다. 마커 배치는 신호 자체와 동일한 샘플-투-컬럼 매핑을 사용하므로 — 마커가 음향 특징과 시각적으로 정렬되어 있으며, 근사치가 아닙니다. 이미지는 100밀리초 주기로 발행되어 Pi에서도 반응성이 유지됩니다. 다른 탭으로 전환하지 않고도 여기서 직접 검출 정확도를 시각적으로 확인할 수 있습니다."

---

### 3-2. Rate / Scope 개선 (8점)

**[지시문]** Rate/Scope 탭. rectified signal, trigger threshold, event markers, tic/toc rate points를 다시 짚는다. scope는 10초 history를 보관하지만 화면은 point budget에 맞게 visible window만 렌더링하는 구조라 pan/zoom해도 측정이 끊기지 않음을 설명한다.

**[발표자]**
> "**Rate / Scope**에 설정 가능한 측정 창 선택기와 피크 홀드 표시기를 추가했습니다. 디스플레이는 10초 히스토리를 유지하지만 고정된 포인트 예산 내에서 보이는 창만 렌더링합니다 — 그래서 창을 고정하고 검사한 뒤 재개해도 측정이 끊기지 않습니다. 이벤트 마커는 매 프레임 재생성하는 대신 풀링되고 재배치되어 Pi에서도 화면이 매끄럽게 유지됩니다."

---

### 3-3. AI 기능 — TinyML 신호 품질 분류기 (5점 + 문제 설명 4점)

**[지시문]** status bar의 signal quality confidence indicator를 가리킨다. Settings 창에서 classifier 관련 토글이 있으면 함께 보여준다.

**[발표자]**
> "저희 AI 기능은 **TimeGrapher.Inference 모듈**입니다 — Raspberry Pi 5 온디바이스에서 실행되는 ONNX 기반 신호 품질 분류기입니다. 박자당 추출된 여덟 개의 신호 형상 특징을 사용해 각 박자를 네 가지 범주로 분류합니다: **Good(정상), Noisy(노이즈), WeakSignal(약신호), Unstable(불안정)**. 신뢰도 결과가 실시간으로 상태 헤더에 표시됩니다."

**[지시문]** 시계를 한 번 톡 친다 → confidence indicator 변화 확인. 일반 beat와 비교해 보여준다.

**[발표자]**
> "이 기능이 해결하는 문제: 시계 소리에는 짧고 큰 충격음도 포함됩니다 — 톡 두드리기, 부딪힘 — 이것이 틱으로 오인되면 레이트, 비트 에러, 진폭이 급변할 수 있습니다. 보세요 — 한 번 두드립니다. 분류기가 이 박자를 의심 박자로 플래그 처리해 측정값에 도달하기 전에 차단합니다. 그래서 측정값이 깨끗하게 유지됩니다.
>
> 핵심 아키텍처 안전 보장: 분류기는 후보 박자를 수락하거나 거부할 수 있습니다 — 이벤트를 **생성하거나**, 재타이밍하거나, BPH와 PLL 동기화를 건드릴 수 **없습니다**. 그래서 모델이 어느 방향으로 틀려도 타이밍 락을 깨뜨릴 수 없습니다."

---

## 4. GUI: unplug/replug · 노이즈 필터 · A/C 동기 · 공간활용 (3:30)
> ▣ RUBRIC: **Area 6 — Remote UI / GUI Modifications (25점)**

### 4-1. 센서/마이크 unplug & replug (5점)

**[지시문]** 라이브 측정 중 **USB 마이크를 물리적으로 뽑는다.**

**[발표자]**
> "이제 실행 중에 마이크를 뽑겠습니다."

**[지시문]** 상태바에 "Live audio stopped unexpectedly. Please check your device connection." 메시지와 장치 목록 자동 갱신을 가리킨다.

**[발표자]**
> "시스템이 즉시 감지합니다 — 깔끔하게 중지하고, 사용자에게 정확히 무슨 일이 일어났는지 알려주며, 장치 목록을 갱신합니다. 충돌도, 그래프 멈춤도 없습니다. 명시적인 실행 상태 머신이 이것을 처리합니다."

**[지시문]** 마이크를 다시 꽂고 → 장치 재선택 → Start. 정상 복귀.

**[발표자]**
> "다시 꽂고, 장치를 재선택하고, 시작합니다 — 그러면 다시 라이브로 측정합니다."

---

### 4-2. 핸들링 노이즈 필터링 (4점)

**[지시문]** 측정 중 시계/센서를 손가락으로 톡톡 두드린다. A/C는 유지되고 탭 노이즈는 걸러지는 것을 가리킨다.

**[발표자]**
> "시계를 다루다 보면 박자처럼 보이는 큰 충격파가 생깁니다. 저희는 레짐 가드와 임펄스 거부를 사용해 핸들링 노이즈를 필터링하면서, 실제 A와 C 이벤트는 보존합니다. 문 닫는 소리 같은 단일 충격도 몇 박자 동안 디바운싱되어, 한 번의 충격으로 락이나 히스토리가 날아가지 않습니다."

---

### 4-3. Beat-Synchronized A/C 표시 (4점)

**[지시문]** Beat Noise 또는 Waveforms 탭. A와 C가 매 사이클 **같은 상대 위치**에 놓이는 것을 가리킨다.

**[발표자]**
> "박자 동기화 표시에 대해: 매 사이클마다 A와 C가 그래프의 **같은 상대 위치**에 배치됩니다 — 박자 정렬이지, 벽시계 정렬이 아닙니다. 불규칙한 타이밍은 그 고정 기준점에서의 위치 편차로 나타나므로, 화면을 가로질러 쫓아다닐 필요가 없습니다."

---

### 4-4. 화면 공간 활용 (4점) + 가독성 (4점)

**[지시문]** Settings 창을 열어 덜 사용하는 옵션(accept band, 샘플링 파라미터, CSV 로그)이 정리된 것을 보여준다. 메인 화면이 그래프 중심임을 강조.

**[발표자]**
> "덜 사용하는 컨트롤들 — 샘플링 파라미터, 허용 밴드, 로깅 옵션 — 은 별도의 **Settings** 창으로 분리되어, 메인 화면이 그래프에 집중됩니다. 세 가지 핵심 수치 — 레이트, 비트 에러, 진폭 — 는 어떤 탭이 활성화되어 있든 상단 상태바에 항상 표시됩니다. 터치 영역은 최소 9mm, 글자 높이는 최소 2.9mm로 — Pi 터치스크린 1280×800에 대한 저희 QAS-6 사용성 시나리오를 충족합니다."

---

### 4-5. 시스템 건강 / 측정 준비 피드백 (4점)

**[지시문]** 상태바의 latency, signal level meter, detection confidence를 가리킨다. Vario의 overall verdict도 함께 짚는다.

**[발표자]**
> "상태바는 시스템 건강을 한눈에 보여줍니다: 신호 레벨, 검출 신뢰도, 지연 시간, 실행 상태. 신호가 약하면 노란색 표시등이 켜집니다. 검출률이 95% 아래로 떨어지면 빨간색이 됩니다. 그리고 Vario는 측정 준비 판정을 줍니다 — *'OK — 기록하기에 충분히 안정'*, *'주의'*, 또는 *'경보 — 점검 필요'* — 그래서 사용자는 언제 측정값을 신뢰할 수 있는지 항상 알 수 있습니다."

---

## 5. 라이브 정확도 & 지연 근거 (2:00)
> ▣ RUBRIC: Area 4 (데모 측), Area 3 연결

### 5-1. 라이브 지연

**[지시문]** 상태바 latency 수치를 확대해 가리킨다.

**[발표자]**
> "지연 시간: 오디오 캡처부터 검출, 측정, 화면 출력까지 — 상태바가 이 엔드투엔드를 라이브로 보여줍니다. Pi 5에서 43200 BPH / 192 kHz로 측정한 최악의 경우 36.46 ms — 83.3 ms 예산의 44%에 불과하며, 드롭된 블록과 놓친 박자는 모두 0입니다."

---

### 5-2. 두 시스템 정확도 비교

**[지시문]** 같은 시계의 Weishi Timegrapher 판독값과 TimeGrapher 판독값(rate s/d, amplitude°, beat error ms)을 나란히 보여준다. 허용오차 기준은 Witschi 등급 기준 ±1 s/d / ±1° / ±0.1 ms.

**[발표자]**
> "정확도를 위해 **같은 시계를 두 시스템으로** 측정합니다 — TimeGrapher와 Weishi Timegrapher 기준기. 저희의 레이트, 진폭, 비트 에러가 Witschi 등급 허용오차 내에서 일치합니다: ±1 s/d, ±1°, ±0.1 ms. 충분히 감긴 시계로 여러 번 측정해도 일관되게 유지되었습니다. 이것이 저희의 정확도 근거입니다. CI 테스트가 이것이 퇴행하지 않도록 보호하지만, 라이브 일치가 1차 증거입니다."

---

## 6. Bonus: Health Radar + 진단/분류 (1:15)
> ▣ RUBRIC: Bonus — Radar chart (8점) + Diagnosis/Classification (7점)

### 6-1. Watch Health Radar — `Watch Health Radar` 탭

**[지시문]** 탭 스트립에서 Watch Health Radar 탭을 연다. 6개 포지션(CH·CB·12H·3H·6H·9H) 축의 레이더, healthy-zone amber band, target 점선, 측정 다각형을 가리킨다.

**[발표자]**
> "보너스 기능으로 **Watch Health Radar** 탭은 완료된 모든 자세의 측정값을 사용해 극좌표 차트를 렌더링합니다. 지금은 자세별 진폭을 보여주고 있습니다. 황색 밴드가 정상 구역이고, 점선이 목표입니다. 꽉 차고 균일한 다각형은 시계가 모든 자세에서 일관성이 있다는 의미이고, 함몰된 곳은 약한 자세를 바로 가리킵니다. 같은 차트가 동일한 6개 축에서 레이트나 비트 에러를 다시 표시할 수 있습니다."

---

### 6-2. 진단 / 분류

**[지시문]** Vario의 overall verdict, Beat Error의 MAJOR FAULT banner, Positions의 Position Consistency badge를 순서대로 짚는다.

**[발표자]**
> "진단과 분류에 대해: 구현된 뷰들이 측정값을 판정으로 변환합니다 — Vario는 기록 준비 여부를, Beat Error는 45도 기울기에서 주요 타이밍 결함을 플래그하고, Position Consistency는 시계가 자세 전반에 걸쳐 균일하게 동작하는지 요약합니다 — 레이더에서 가장 약한 축을 시각적으로 표시하면서."

---

## 7. 클로징 (0:15)

**[발표자]**
> "정리하면 — 12개의 실시간 디스플레이, 정확도를 최우선으로 하는 아키텍처, 모두 Pi 5에서 라이브로 실행 중입니다. 발표에서 아키텍처와 근거를 더 깊이 다루겠습니다. 감사합니다."

---

## 부록 A. 라이브 장애 대응

| 증상 | 즉시 대응 | 대사 |
|---|---|---|
| 마이크 락온 실패 | **Playback**(사전 녹음 WAV)으로 전환 | "보기 편하도록 같은 시계의 녹음 파일로 전환하겠습니다." |
| 마이크 장애/잡음 폭주 | Simulation 모드 | (위와 동일) |
| 고비트(43200) 디스플레이 | `43200BPH_synthetic_192000Hz.wav` Playback | "고비트 무브먼트에는 192kHz 녹음을 사용합니다." |
| 특정 탭 렌더 느림 | 상태바 *"Display quality was reduced…"* 를 기능으로 설명 | "설계상 시각화보다 측정을 먼저 보호하는 것을 확인하실 수 있습니다." |
| 앱 멈춤 | Reset → 재시작 | "실행 상태 머신이 Reset으로 깔끔하게 복구합니다." |

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
