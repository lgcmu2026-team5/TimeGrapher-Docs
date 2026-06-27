# 수요일 발표 슬라이드 구성안

[English](4-Presentation-Deck-Plan.md) | [한국어](4-Presentation-Deck-Plan.ko.md)

이 문서는 `3-Wednesday-Runbook.ko.md`의 발표용 짝이다.

확인된 점수 비중:

- **데모 350점**
- **발표 150점**

발표는 live tour를 다시 반복하지 않는다. 방금 데모에서 본 내용을 기반으로, 그 뒤의 **아키텍처와 근거**를 루브릭 순서대로 설명한다.

목표 발표 시간: **20분**

## 발표 전략

데모가 답하는 질문:

> "Does it work?"

발표가 답해야 하는 질문:

1. 왜 이 아키텍처가 신뢰할 만한가
2. 왜 이 tradeoff가 의도적인 선택인가
3. performance, latency, correctness, extensibility를 뒷받침하는 evidence는 무엇인가
4. AI를 product와 development에서 어떻게 안전하게 사용했는가

발표 시작 문장:

> "The demo followed the rubric from the running system. The presentation follows the same rubric from the architecture and evidence side."

## 슬라이드 구성

| Slide | Time | Rubric | Purpose |
|---:|---:|---|---|
| 1 | 0:45 | Setup | 앱과 target platform 다시 고정 |
| 2 | 1:30 | Area 1 recap | 12-display coverage matrix |
| 3 | 2:00 | Area 2 | 개선 사항과 ONNX classifier safety 설명 |
| 4 | 3:00 | Area 3 | Quality attributes and tradeoffs, accuracy first |
| 5 | 3:00 | Area 4 | RPi5 performance/latency evidence |
| 6 | 2:00 | Area 4 | Correctness evidence and Witschi status |
| 7 | 3:00 | Area 5 | Extensible architecture and dependency boundaries |
| 8 | 1:30 | Area 6 | GUI usability and operational resilience |
| 9 | 2:00 | Area 7 | Product/development AI use and verification |
| 10 | 1:15 | Area 8 + Bonus + close | UI value, bonus, limitations, final ask |

## Slide 1 - Running Product, Not A Mockup

Visual:

- Raspberry Pi 5에서 실행 중인 앱 screenshot 1장
- 작은 label: Live / Playback / Simulation, .NET 8, Avalonia, Core engine

Speaker:

> "This is the same application you just saw running. TimeGrapher listens to a mechanical watch and computes rate, amplitude, beat error, and signal-quality feedback in real time. The application runs from one .NET 8/Avalonia codebase on Windows and Raspberry Pi 5."

## Slide 2 - Area 1 Coverage Matrix

Visual:

- 12-item checklist와 tab 이름
- demo에서 실제로 보여준 항목만 green check

Speaker:

> "Area 1 was the largest demo surface. We showed all twelve required real-time displays. The architectural point is that they are not twelve separate calculators. They are views over the same analysis frame, which prevents inconsistent numbers across screens."

포함할 표:

| Required item | App tab |
|---|---|
| Watch-position testing | Positions |
| Trace display | Trace |
| Rate/amplitude stability | Vario |
| Multi-position sequence | Positions |
| Beat-noise scope | Beat Noise |
| Beat error and diagnostic trace | Beat Error |
| Long-term performance | Long-Term |
| Escapement marker-line analyzer | Escapement |
| Spectrogram | Spectrogram |
| Waveform comparison | Waveforms |
| Synchronized sweep | Sweep |
| Multiple filter views | Filter Scope |

## Slide 3 - Area 2 Enhancements And ONNX Signal Quality

Visual:

- Sound Print before/after 또는 annotated screenshot
- Rate/Scope annotated screenshot
- 작은 architecture box: `App -> TimeGrapher.Inference -> ISignalQualityClassifier -> Core`

Speaker:

> "Area 2 has three parts in our system: Sound Print readability, Rate/Scope measurement clarity, and the AI feature."

> "The AI feature is an on-device ONNX signal-quality classifier. The app tries to load the embedded ONNX model and falls back to a deterministic heuristic if loading fails. The important safety design is that this classifier is advisory: it annotates trust and warning state, but it cannot create events, retime events, or alter BPH/PLL synchronization."

근거로 언급할 코드:

- `src/TimeGrapher.App/Views/MainWindow.axaml.cs`: composition root에서 `OnnxSignalQualityClassifier.LoadOrElse` 로드
- `src/TimeGrapher.Inference/OnnxSignalQualityClassifier.cs`: model implementation
- `src/TimeGrapher.Core/Analysis/DetectorMetricsEngine.cs`: quality assessment가 read-only annotation

## Slide 4 - Area 3 Quality Attributes And Tradeoffs

Visual:

- Pyramid 또는 table:
  - Accuracy first
  - Performance/latency
  - Portability
  - Modifiability
  - Usability/testability as supporting attributes

Speaker:

> "Area 3 asks for quality-attribute tradeoffs. Our priority order is accuracy first, then real-time performance, portability, and modifiability. That order shaped the implementation."

> "We accept warm-up before reporting a trusted rate. We spend CPU on high sample rates when they improve timestamp resolution. And under load, we degrade visualization first rather than measurement: latest-wins rendering may skip intermediate visual frames, but the analysis history and measured values are preserved."

> "That is the central tradeoff: protect the number first, then recover the picture."

제한 사항 하나를 반드시 포함:

> "The remaining accuracy validation item is the Witschi commercial comparison if not completed before Wednesday. We report it as a remaining validation item, not as a hidden success."

## Slide 5 - Area 4 Performance And Latency Evidence

Visual:

- EXP-02 table
- current all-tab check 강조

정확히 넣을 숫자:

| Condition | Input | Worst E2E | Budget | Usage | Drop | Miss |
|---|---|---:|---:|---:|---:|---:|
| 21600 BPH @ 48 kHz | Simulation | 41.975 ms | 166.667 ms | 25.2% | 0 | 0 |
| 21600 BPH @ 48 kHz | Playback | 43.939 ms | 166.667 ms | 26.4% | 0 | 0 |
| 21600 BPH @ 48 kHz | Live | 40.378 ms | 166.667 ms | 24.2% | 0 | 0 |
| 43200 BPH @ 192 kHz | Simulation | 34.003 ms | 83.333 ms | 40.8% | 0 | 0 |
| 43200 BPH @ 192 kHz | Playback | 34.562 ms | 83.333 ms | 41.5% | 0 | 0 |
| 43200 BPH @ 192 kHz current all-tab check | Simulation | 36.46 ms | 83.333 ms | 43.8% | 0 | 0 |

Speaker:

> "Area 4 asks whether real-time performance and latency are real on the target platform. EXP-02 measured capture-to-display latency on the Raspberry Pi 5. The hardest current all-tab case is 43200 BPH at 192 kHz, with 36.46 ms worst E2E latency against an 83.333 ms one-beat-period budget. Drop count is zero and miss count is zero."

## Slide 6 - Area 4 Correctness Evidence

Visual:

- 3-column evidence stack:
  - Known synthetic reference
  - Witschi commercial comparison
  - Verify/adverse tests

Witschi data가 완료된 경우:

> "For correctness, we use three layers. First, a known synthetic reference where the generator gives the expected rate, amplitude, and beat error. Second, a Witschi commercial comparison on the same watch. Third, automated Verify/adverse fixtures so we do not regress weak-signal and noisy-signal behavior."

Witschi data가 완료되지 않은 경우:

> "For correctness, the known synthetic reference pass is complete and the Witschi comparison remains the final real-world validation item. We are explicit about that because architectural evaluation should separate achieved evidence from remaining risk."

말하지 말 것:

- "CI/CD proves accuracy."

대신 말할 것:

> "CI/CD protects the evidence from regression; it does not replace runtime validation."

## Slide 7 - Area 5 Extensibility Architecture

Visual:

- Layer diagram:
  - `TimeGrapher.App`
  - `TimeGrapher.Core`
  - `TimeGrapher.Platform.*`
  - `TimeGrapher.Inference`
  - `TimeGrapher.Verify`

Speaker:

> "Area 5 asks whether the architecture supports new requirements. The Core engine has no UI or platform dependency. Platform audio is behind adapters. The App composes renderers and tab definitions. Inference is a leaf implementation of the classifier seam, so ONNX Runtime does not leak into Core."

> "A new display is local: add a catalog entry, a frame consumer when needed, and a renderer over the immutable analysis frame. That is how the display set grew without making twelve competing pipelines."

언급할 근거:

- `InfoTabCatalog.cs`
- `AnalysisFrame`
- Core dependency boundary tests
- ADR-001 through ADR-004

## Slide 8 - Area 6 GUI Modifications

Visual:

- before/after 또는 annotated current UI
- Callouts:
  - Device state
  - Start/stop/pause/reset
  - A/C markers
  - Signal-quality/readiness
  - Settings/accept bands

Speaker:

> "Area 6 is not just visual polish. The GUI makes operational state visible: input mode, run state, measurement readiness, signal quality, and acceptable bands. It also handles microphone disconnect/reconnect without crashing the measurement session."

> "The A/C markers appear consistently across diagnostic views, so the user learns one timing language and sees it everywhere."

## Slide 9 - Area 7 AI In Product And Development

Visual:

- Two lanes:
  - Product AI: ONNX signal-quality classifier
  - Development AI: Codex/Claude, tests, docs, CI/CD

Speaker:

> "Area 7 asks how AI was used. In the product, AI is the ONNX signal-quality classifier with deterministic fallback and a read-only safety boundary. In development, we used AI for porting support, debugging, tests, documentation review, architecture review, and CI/CD workflow design."

> "The control principle was verification. AI-generated or AI-assisted work had to pass tests, Verify scenarios, architecture boundary checks, and live Pi measurements. We used AI as a fast collaborator, not as an authority."

risk 언급:

> "The risk is over-claiming. We mitigated that by downgrading claims when the code did not fully support them, and by keeping the AI classifier away from timing control."

## Slide 10 - Area 8, Bonus, Close

Visual:

- current UI screenshot
- Health radar screenshot, 안정적인 경우만
- 짧은 limitation list

Speaker:

> "For Best UI, our goal is a readable measurement instrument, not a decorative dashboard. The user can see whether the watch is synchronized, whether readings are trustworthy, and which diagnostic view explains the problem."

Health bonus가 안정적인 경우:

> "For bonus, the Health radar summarizes multi-position watch condition, and diagnosis/classification turns measurements into an interpretation."

Close:

> "The result is a running Raspberry Pi TimeGrapher with the required display coverage, an accuracy-first architecture, measured real-time performance, local extensibility for new diagnostics, and AI used within explicit safety and verification boundaries."

## Q&A Answers

| Question | Short answer |
|---|---|
| How do you know it is accurate? | Runtime design protects timing; synthetic reference is complete; Witschi comparison is the real-world final check; Verify/CI prevents regression. |
| Is CI/CD your accuracy proof? | No. CI/CD protects evidence from regression. Runtime validation and reference comparison are the proof path. |
| Is ONNX actually connected? | Yes. The App loads `OnnxSignalQualityClassifier.LoadOrElse(...)`; if ONNX fails, it falls back to heuristic classification. |
| Can AI break the measurement? | No by design. It is advisory and cannot create, retime, or drop beats. |
| Why Avalonia/.NET? | One codebase for Windows and Raspberry Pi 5, with OS audio isolated behind adapters. |
| What is extensible? | New views use tab catalog + frame consumer + renderer over the same analysis frame; Core remains independent. |
| What remains incomplete? | Say only what is true on Wednesday: likely Witschi comparison and any unstable bonus screen. |

## 최종 준비 체크리스트

- [ ] 실제 deck을 slide 1-10 흐름에 맞게 수정
- [ ] slide title 또는 우상단에 Area 번호 표시
- [ ] EXP-02 latency table 정확히 추가
- [ ] Witschi comparison table이 있으면 추가
- [ ] critical demo area마다 screenshot 하나씩 추가
- [ ] Health/bonus는 live build에서 안정적인 경우에만 enabled로 표시
- [ ] 데모에서 발표로 넘어가는 문장 리허설

> "The demo showed the scoring items in the running system. Now we will show the architecture and evidence behind those items, in the same rubric order."

