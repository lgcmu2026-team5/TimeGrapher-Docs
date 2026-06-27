# 수요일 데모/발표 준비 치트시트

가장 중요한 전제:

- **데모 350점**
- **발표 150점**
- 루브릭에는 데모 항목과 발표 항목이 섞여 있음
- 그래서 순서는 무조건 **루브릭 순서대로** 간다

한 문장 전략:

> 데모는 "보여주기", 발표는 "왜 이 구조가 맞는지와 근거 설명"이다.

## 전체 운영 원칙

데모 시작 20초 안에 반드시 말하기:

> "We organized the demo in the same order as the rubric, so you can check each scoring item as we show it."

각 구간 시작마다 반드시 말하기:

> "This covers rubric Area X."

평가자가 좋아할 포인트:

- 화면을 그냥 넘기지 말고, 각 화면이 어떤 루브릭 항목인지 이름을 말한다.
- 없는 기능을 있다고 말하지 않는다.
- 미완/제한은 "remaining validation item"으로 정직하게 말한다.
- CI/CD는 정확도 증명이 아니라 regression guard라고 말한다.
- AI는 timing control을 하지 않고 advisory signal-quality classifier라고 말한다.

## 데모 350점 운영 순서

20분 기준. 시간이 더 있으면 Area 1, 4, 6을 늘린다.

| 시간 | 루브릭 | 핵심 행동 |
|---:|---|---|
| 0:00-1:00 | 시작 | Pi 5, live input, rubric-order demo 선언 |
| 1:00-8:30 | Area 1 | 12개 필수 graph/display를 빠르게 전부 보여줌 |
| 8:30-11:00 | Area 2 | Sound Print, Rate/Scope 개선, ONNX signal-quality classifier |
| 11:00-13:00 | Area 3 | Accuracy-first tradeoff 짧게 설명 |
| 13:00-15:00 | Area 4 | Pi latency/performance/correctness evidence |
| 15:00-16:15 | Area 5 | 새 tab/display 추가 구조 설명 |
| 16:15-18:15 | Area 6 | UI 개선, unplug/replug, A/C marker, readiness |
| 18:15-19:00 | Area 7 | AI 사용 방식과 검증 |
| 19:00-20:00 | Area 8 + Bonus | UI 품질, Health radar/diagnosis 가능하면 시연 |

## Area 1: 12개 필수 화면 빠른 멘트

각 항목은 30초 안쪽으로 간다. 운영자는 tab을 열고, 발표자는 한 문장만 말한다.

| 순서 | 탭 | 말할 핵심 |
|---:|---|---|
| 1 | Positions | "This covers Watch-Position Testing." |
| 2 | Trace | "This covers Trace Display." |
| 3 | Vario | "This covers Rate and Amplitude Stability." |
| 4 | Positions | "This covers Multi-Position Sequence." |
| 5 | Beat Noise | "This covers Beat-Noise Scope." |
| 6 | Beat Error | "This covers Beat Error Display and Diagnostic Trace." |
| 7 | Long-Term | "This covers Long-Term Performance." |
| 8 | Escapement | "This covers Escapement Analyzer." |
| 9 | Spectrogram | "This covers Time-Frequency Spectrogram." |
| 10 | Waveforms | "This covers Waveform Comparison." |
| 11 | Sweep | "This covers synchronized Scope Sweep." |
| 12 | Filter Scope | "This covers Multiple Filter Views." |

Area 1 마무리 문장:

> "That is the full Area 1 set: twelve required displays, driven by the same live analysis frame rather than separate calculators."

## Area 2: 개선 + AI

반드시 말할 내용:

- Sound Print는 event marker/readability 개선
- Rate/Scope는 trigger, event marker, live measurement clarity 개선
- ONNX classifier는 실제 앱 composition root에서 로드됨
- 실패하면 heuristic fallback
- AI는 advisory이고 measurement timing을 변경하지 않음

안전한 문장:

> "The AI feature is an on-device ONNX signal-quality classifier. The app loads the ONNX model and falls back to a deterministic heuristic if the model cannot load."

> "The classifier is advisory: it annotates trust and warning state, but it cannot create beats, retime beats, or move the BPH/PLL lock."

## Area 3: Tradeoff

짧게만 말하고 발표에서 자세히 설명한다.

> "Our highest priority is measurement accuracy. We accept warm-up before trusting BPH, spend CPU on higher sample rates when needed, and under load we degrade visualization first, not measurement."

## Area 4: 성능/지연/정확도

외워야 할 숫자:

- 43200 BPH @ 192 kHz current all-tab check
- worst E2E latency: **36.46 ms**
- budget: **83.333 ms**
- budget usage: **43.8%**
- Drop: **0**
- Miss: **0**

말할 문장:

> "The current all-tab check passed at 36.46 ms worst E2E latency against an 83.333 ms one-beat-period budget, with Drop 0 and Miss 0."

Witschi 비교가 준비됐으면:

> "For correctness, we compare the same watch against the Witschi reference and show rate, amplitude, and beat error side by side."

Witschi 비교가 아직이면:

> "The clean synthetic reference pass is complete. The Witschi commercial comparison is the remaining real-world validation item, and we report it as a remaining limitation."

## Area 5: 확장성

짧은 구조:

- Core는 UI/platform 독립
- App은 tab/renderer를 조립
- Platform은 OS audio adapter
- Inference는 classifier seam의 leaf implementation
- 새 display는 catalog entry + consumer + renderer

말할 문장:

> "A new display is local: add a tab catalog entry, a frame consumer if needed, and a renderer over the existing immutable analysis frame. The Core engine stays independent of UI and platform code."

## Area 6: GUI

가능하면 실제로 보여줄 것:

- mic unplug/replug
- 상태 메시지
- A/C marker
- signal-quality/readiness
- settings/accept bands

말할 문장:

> "The GUI is designed for repeated measurement work: input state, run state, measurement readiness, signal quality, and acceptable bands remain visible."

## Area 7: AI 사용

제품 AI:

- ONNX signal-quality classifier
- deterministic fallback
- advisory safety boundary

개발 AI:

- porting support
- debugging
- tests
- documentation
- architecture review
- CI/CD workflow design

말할 문장:

> "We used AI as a fast collaborator, not as an authority. Every AI-assisted result had to pass tests, Verify scenarios, architecture boundary checks, and live Pi measurements."

## 발표 150점 운영 순서

발표는 루브릭 순서로 "근거"를 설명한다.

| 슬라이드 | 루브릭 | 핵심 |
|---:|---|---|
| 1 | 시작 | Running product, Pi 5, one codebase |
| 2 | Area 1 | 12 display coverage matrix |
| 3 | Area 2 | Enhancements + ONNX classifier |
| 4 | Area 3 | QA priority and tradeoffs |
| 5 | Area 4 | Pi latency/performance evidence |
| 6 | Area 4 | Correctness evidence + Witschi status |
| 7 | Area 5 | Architecture extensibility |
| 8 | Area 6 | GUI usability and resilience |
| 9 | Area 7 | AI in product and development |
| 10 | Area 8 + Bonus | UI value, Health/diagnosis, close |

발표 시작 문장:

> "The demo showed the scoring items in the running system. Now we will show the architecture and evidence behind those items, in the same rubric order."

## 오늘 반드시 준비할 것

- [ ] 실제 Pi에서 앱 실행 확인
- [ ] Live mic 입력 확인
- [ ] Playback WAV fallback 준비
- [ ] Simulation fallback 준비
- [ ] 12개 tab이 실제로 보이는지 확인
- [ ] Health tab이 안정적이면 bonus로 사용, 아니면 claim 제거
- [ ] ONNX classifier가 load되는지 확인
- [ ] Witschi 비교표 준비 또는 remaining validation 문장 준비
- [ ] EXP-02 latency 표를 발표 슬라이드에 넣기
- [ ] 각 슬라이드 제목에 Area 번호 넣기

## 절대 하지 말 것

- "CI/CD가 정확도를 증명한다"고 말하지 않기
- ONNX가 beat timing을 제어한다고 말하지 않기
- Witschi 비교가 끝나지 않았는데 끝났다고 말하지 않기
- Health bonus가 불안정한데 bonus full claim 하지 않기
- 금지된 P-o-C 표현을 말하지 않기
