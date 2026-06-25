# Final Demo — 발표(슬라이드) 대본 (20분)

> **Team 5 · TimeGrapherNet** — Final LG SW Architect Presentation
> 순서: 데모 20분 → (셋업 버퍼) → **발표 20분**(본 문서). 데모와 같은 순번(3번째).
> 형식: **영어 대사** + **한글 지시문(슬라이드/포인팅/주의)**.
>
> 작성 원칙: 발표 슬라이드로 채점하는 항목을 **루브릭 순서대로** 커버한다.
> - Area 3 Quality Attribute Tradeoffs (20점) — slides + demo
> - Area 4 Performance·Latency·Correctness (25점) — slides + demo
> - Area 5 Extensibility (20점) — slides
> - Area 7 Use of AI in Building the Software (15점) — slides
> - (Area 2의 AI 기능 "문제 설명" 부분도 슬라이드에서 보강)
>
> 각 구간 `▣ RUBRIC` + `▣ SLIDE` 표기. 채점자가 슬라이드에서 위치를 바로 찾게 한다.
>
> Piazza 답변 반영 원칙:
> - CI/CD는 좋은 engineering practice지만 **application/demo 자체가 아니다**. 본문에서는 CI를 supporting evidence로만 쓰고, 실제 앱 기능·운영·정확도 개선을 중심에 둔다.
> - 하지만 CI/CD 자동화를 설계·작성·디버깅하는 데 AI를 활용한 것은 **Area 7: Use of AI in Building the Software** 에서 강하게 말할 수 있다.
> - Accuracy는 "테스트가 있다"가 아니라 **runtime tradeoff를 선택했고, 기준기와 비교했고, 실험으로 근거를 남겼다**로 설명한다.
> - 발표 톤은 "곧 출시할 LG application"처럼 focused and product-minded 해야 한다.
>
> SW Architect 문서 활용 원칙:
> - `Milestone/en/2-Architectural-Drivers.md`의 **QAS-1~6**를 슬라이드 4~6의 근거 라벨로 사용한다.
> - `Milestone/en/ADR/ADR-001~004.md`는 "우리가 왜 이 구조를 선택했는가"를 설명하는 발표 근거다.
> - `Milestone/en/3-Risk-Assessment.md`, `4-Planned-Experiments.md`, `Milestone2 Review Q&A.md`는 수치·위험·남은 한계를 말할 때 사용한다.
>
> 작년 1등 발표자료 참고 원칙:
> - 따라 할 것은 화려함이 아니라 **문제 → 실험 → 아키텍처 결정 → 결과**를 한 흐름으로 묶는 방식이다.
> - 우리 발표는 TimeGrapher가 실제로 구현한 프로그램 표면을 먼저 보이고, 그 뒤에 QAS/ADR/EXP 근거를 붙인다.

---

## 슬라이드 구성 한눈에 (20분)

| # | 슬라이드 | 시간 | 채우는 Rubric |
|---|---|---|---|
| 1 | 타이틀 & 구현 프로그램 표면 | 0:45 | — |
| 2 | 문제 & 접근: Qt/C++ → Avalonia/.NET, 단일 코드베이스 | 1:30 | Area 5(이식성), ADR-001 |
| 3 | 아키텍처 개요: Layers · Core 무의존 · CI 강제 경계 | 3:00 | **Area 5 (20점)** |
| 4 | 품질속성 & 트레이드오프 (accuracy 최우선) | 4:30 | **Area 3 (20점)** |
| 5 | 성능·지연·정확성 근거 (Pi 5 실측) | 4:30 | **Area 4 (25점)** |
| 6 | 확장성 심화: 새 측정/필터/탭 추가 | 2:00 | **Area 5 (20점)** |
| 7 | TinyML + 개발 전반 AI 사용 + CI/CD 자동화 | 3:00 | **Area 7 (15점)** |
| 8 | 클로징 & Q&A | 0:45 | — |

> ⏱ 자르는 순서: ⑥ 일부 → ⑦ 회고 압축. 절대 안 자르는 것: Area 3 트레이드오프, Area 4 수치 근거.

---

## 1. 타이틀 & 구현 프로그램 표면 (0:45)
> ▣ SLIDE 1: "Windows & Raspberry Pi 5, one codebase" + 구현 화면 범위

**[Presenter]**
> "We're Team 5. TimeGrapher listens to a mechanical watch and measures its accuracy in real time. The program you just saw is not a mock-up: it has live, playback, and simulation inputs, and it exposes the required measurement displays — Rate/Scope, Beat Error, Trace, Vario, Long-Term, Sweep, Escapement, Positions, Beat Noise, Waveforms, Filter Scope, Sound Print, and Spectrogram.
>
> We rebuilt it from the original Qt/C++ version into **Avalonia and C# on .NET 8**, so a **single codebase** runs on both Windows and the Raspberry Pi 5. In this presentation we'll explain the architecture and show the evidence behind that running application."

---

## 2. 문제 & 접근 (1:30)
> ▣ RUBRIC: Area 5(이식성) · ADR-001
> ▣ SLIDE 2: Qt/C++ → Avalonia/.NET 전환 이유, 단일 코드베이스 다이어그램

**[Presenter]**
> "The original was Qt and C++. We made a deliberate architectural choice to move to Avalonia and .NET — documented in ADR-001. The driver was **portability with one codebase**: the same source produces a Windows build and a Raspberry Pi build, and only the per-OS audio backend changes. That decision is what lets accuracy, performance, and UI work carry over to the Pi without a separate port."

> 🔧 SLIDE에 `ADR-001 · Qt/C++ → Avalonia/.NET/C#`와 rejected alternatives 1줄을 넣는다: Qt/C++은 팀 역량·LGPL·빌드 복잡도, Electron은 embedded footprint, MAUI는 Linux support, Flutter는 Dart mismatch 때문에 제외.

---

## 3. 아키텍처 개요 (3:00)
> ▣ RUBRIC: **Area 5 — Extensibility (modular, separates concerns) 6점 + 이해가능/유지보수 4점**
> ▣ SLIDE 3: Layer 다이어그램 (App → Core / Platform.*, Platform.* → Core), Core "zero dependency"

**[지시문]** Layer 다이어그램을 가리킨다 (`Milestone/assets/LAYER.png` 또는 module-uses 뷰).

**[Presenter]**
> "The architecture is three layers. The **Core** is the analysis engine — detection, measurement, image generation, the simulator — and it has **zero dependencies** on UI or OS. The **App** is the Avalonia UI. The **Platform** assemblies wrap each OS's microphone stack. Dependencies only point downward: App and Platform both depend on Core, never the reverse.
>
> And this boundary isn't just a diagram — **our CI enforces it**. A test fails the build if Core ever imports a UI, platform, or audio type, and it checks that each OS build only bundles its own audio backend. The architecture rule is a failing test, not a comment."

**[지시문]** 입력 워커 계약 다이어그램(IAudioInputWorker / ILiveAudioWorker)으로 전환.

**[Presenter]**
> "All three inputs — live mic, WAV playback, and the simulator — implement one small interface. Core only knows that contract, so a new input or a new OS backend drops in without touching the engine. This is the Adapter boundary, and it's why the Pi mic backend (PipeWire/ALSA) and the Windows backend (NAudio) coexist behind the same Core."
>
> "The same frame fan-out is what makes the display tour possible. Rate/Scope, Beat Error, Trace, Vario, Long-Term, Sweep, Escapement, Positions, Beat Noise, Waveforms, Filter Scope, Sound Print, and Spectrogram are different views over the same measured analysis frame, not separate competing calculators."

> ▣ SLIDE 보조: MVVM·Pipe-and-Filter를 **정직하게** 표기 (△ 부분 적용). 과잉 주장 금지 — SAP 학습 포인트.

**[Presenter] (정직성 포인트 — 가산점)**
> "We also assessed our patterns honestly. Our MVVM is partial — start/stop lifecycle still lives in code-behind — and our DSP chain is pipe-and-filter in structure but a single synchronous thread. Knowing exactly *where* a pattern is fully applied versus partially applied was part of what we learned."

---

## 4. 품질속성 & 트레이드오프 (4:30)
> ▣ RUBRIC: **Area 3 — Quality Attribute Tradeoff Discussion (20점)**
> - 주요 QA 식별 5점 / 트레이드오프 설명 5점 / **accuracy 최우선** 입증 5점 / 달성·한계 5점
> ▣ SLIDE 4: QA 우선순위 피라미드 (Accuracy 최상단), 트레이드오프 표

### 4-1. 주요 품질속성 식별 (5점)
**[Presenter]**
> "Four quality attributes drive this system: **accuracy** first, then **performance** — it has to keep up in real time — **portability** — one codebase, two platforms — and **modifiability**, so new displays and measurements are cheap to add. Availability and testability support these."

**[지시문]** QAS 표를 슬라이드 한쪽에 작게 둔다: `QAS-1 Accuracy ±1.0 s/d`, `QAS-2 latency ≤ one beat period`, `QAS-3 noisy signal ≥95% detection at SNR ≥30 dB`, `QAS-4 0 display mismatches`, `QAS-5 ≤1 existing module changed`, `QAS-6 2.9 mm letters / 9 mm touch targets`.

**[Presenter]**
> "These are not generic quality words. We turned them into measurable scenarios. Accuracy is QAS-1: clean reference input must be within **plus or minus one second per day** over at least one thousand beats. Performance is QAS-2: the worst-case end-to-end latency must stay within **one beat period**. Consistency is QAS-4: all displays in the same frame must come from one source data set, with zero mismatches."

### 4-2. accuracy를 최우선으로 둔 증거 (5점) — **가장 중요한 5점**
**[지시문]** accuracy 전용 tactic 목록 슬라이드. 측정 수치(recall/precision)와 함께.

**[Presenter]**
> "Accuracy was the top priority, and we can show it in the architecture. The whole pipeline preserves timing precision — capture, filtering, detection, measurement — because every reading depends on tiny timing differences at high sample rates.
>
> Concretely, the detector defends accuracy by default: an **adaptive noise floor** for weak signals, **PLL-guided onset gating** so an early noise crossing can't steal a beat, a **regime guard with hysteresis** so a single impulse can't flush the lock, **detection-gap handling** so one missed beat never flips the sign of the rate, and a **rate warm-up** that withholds a reading until the regression is trustworthy.
>
> These aren't optional toggles — they're the default detection behavior. On our adverse test scenarios, recall and precision recover from near-zero to above 0.95 on weak and noisy signals. And every graph, badge, and verdict reads its accept band from **one shared source**, so the system never shows two different answers for the same reading."

**[Presenter] (Piazza 답변 연결 — CI/CD 위치 정리)**
> "We also asked whether CI/CD testing with recorded reference data should be our main answer for measurement accuracy. The feedback was clear: CI/CD is a good way to improve and protect the system, but it is not the application or the demo. So our accuracy story starts with runtime design choices and live/reference validation; CI is the regression guard behind those choices."

### 4-3. 트레이드오프 설명 (5점)
**[지시문]** 트레이드오프 표 슬라이드.

**[Presenter]**
> "Prioritizing accuracy cost us elsewhere, and we made those tradeoffs on purpose:
>
> - **Accuracy vs. latency.** A longer warm-up before reporting BPH and rate means the first reading is later — we accept that delay to avoid showing a wrong number early.
> - **Accuracy vs. performance.** A higher sample rate gives finer timestamp resolution but costs more CPU per beat. We support up to 192 kHz and verified it still fits the budget on the Pi.
> - **Worker-level Pipe-and-Filter vs. hot-path latency.** ADR-002 says we separate input, analysis, rendering, and recording at worker boundaries, but we deliberately keep the detector and metrics as one synchronous hot path. A full internal Pipe-and-Filter would look cleaner architecturally, but queueing and scheduling between every stage would spend the beat-period budget.
> - **The key one — measurement vs. visualization.** When the system falls behind its deadline, our runtime strategy degrades the *visuals first* — latest-wins rendering can skip intermediate frames and widen publish intervals — but it **never drops or interpolates a measurement**. Long-term history is still preserved through decimation. We protect the number and sacrifice the picture, then recover the picture when we catch up."

**[Presenter] (실험/rationale 강조)**
> "For each tradeoff, we treated it as an experiment: what improves the chosen quality attribute, what does it cost in latency or CPU, and when does the cost stop being worth it? That is why we show both the live behavior and the measurements, not just the design intent."

### 4-4. 달성한 것과 남은 한계 (5점) — 정직성
**[Presenter]**
> "What we achieved: the main real-time risks are resolved in the risk register. R-01 and R-03 — high sample rate and beat-period overrun — are resolved by measurement. R-04 — long continuous run degradation — passed a 24-hour run with memory flat around 406 MB and CPU steady around 36 percent of four-core capacity.
>
> What remains: the clean synthetic accuracy pass is done, but the commercial Weishi/Witschi comparison is still the critical real-world validation if we have not completed it before demo day. TinyML also stays conditional unless the trained model is actually in the demo build. We report those limits because honest architectural evaluation is stronger than pretending the risk disappeared."

---

## 5. 성능·지연·정확성 근거 (4:30)
> ▣ RUBRIC: **Area 4 — Performance, Latency, Correctness (25점)**
> - Pi 실시간 8점 / 저지연 6점 / 정확성 6점 / 근거 5점
> ▣ SLIDE 5: 지연 측정 표 (Pi 5), 두 시스템 비교, 테스트 수

### 5-1. Pi 5 실시간 (8점) + 저지연 (6점)
**[지시문]** 지연 측정은 새로 축약한 막대 그래프보다 `Milestone/en/4-Planned-Experiments.md`의 **EXP-02 Results & Decisions 표**를 직접 인용한다. 슬라이드는 표를 작게 재구성하되, 조건/입력/E2E worst/budget/usage/drop/miss/result 값은 원문 그대로 둔다.

**[Presenter]**
> "We measured the real end-to-end latency on the Pi 5 — capture to processing to display — from the app's own logs, across simulation, playback, and live input.
>
> The slide quotes EXP-02 directly. On 2026-06-11, the 21600 BPH at 48 kHz runs passed across Simulation, Playback, and Live with worst E2E latencies of **41.975**, **43.939**, and **40.378 ms** against a **166.667 ms** budget. The tighter 43200 BPH at 192 kHz runs passed in Simulation and Playback with **34.003** and **34.562 ms** against an **83.333 ms** budget. Then the 2026-06-21 current all-tab check passed at **36.46 ms**, **43.8%** of the same 83.333 ms budget.
>
> The important part is that every EXP-02 row has **Drop 0, Miss 0, Result Pass**. So real-time on the target platform isn't a claim — it's a planned experiment result with the exact conditions and thresholds shown."

> 🔧 SLIDE 근거 라벨: `Source: 4-Planned-Experiments.md · EXP-02 / EXP-05 / QAS-2`. EXP-05는 24h stability 보조 근거로만 둔다: RSS 약 406 MB, CPU 약 36% of 4-core capacity.

### 5-2. 정확성 (6점) + 근거 (5점)
**[Presenter]**
> "For correctness we have three kinds of evidence:
>
> 1. **Two-system comparison** — the same watch on TimeGrapher and a reference Chronoscope, with matching rate, amplitude, and beat error. If the values differ, we explain likely causes such as calibration, microphone attenuation, filter settings, or lift angle instead of hiding the mismatch.
> 2. **Automated verification** — our `Verify` console checks detected BPH and event-level precision/recall against ground-truth fixtures, and it runs in CI on every change. Nine adverse scenarios — weak signal, noise, impulse storms, gain steps — are gated there. This is supporting evidence, not a replacement for the live/reference demo.
> 3. **Test suite** — **933 tests** pass across the engine, app, and platform layers.
>
> Together: the live reading matches a reference, the detector is checked against known signals automatically, and the whole thing is regression-guarded."

> 🔧 SLIDE에 실제 두 시스템 비교 수치 + Verify 통과 캡처 넣기.

---

## 6. 확장성 심화 (2:00)
> ▣ RUBRIC: **Area 5 — supports adding new measurements/filters/graphs with limited redesign (6점)**
> ▣ SLIDE 6: "새 디스플레이 추가" before/after — InfoTabCatalog 한 곳 + Frame consumer

**[지시문]** 새 디스플레이 추가 흐름을 InfoTabCatalog + Frame consumer + renderer로 설명한다. 🔧 Health 레이더가 실제 구현되어 있으면 "값싸게 추가한 새 디스플레이"의 실증 예로 가리킨다. 미구현이면 Positions/Beat Noise/Waveforms처럼 이미 같은 snapshot을 재사용하는 탭들을 예로 든다.

**[Presenter]**
> "Adding capability is deliberately cheap. A new display is one catalog entry, one frame consumer, and one renderer, usually reading a snapshot the engine already produces. Positions, Beat Noise, Waveforms, and Spectrogram all follow that pattern: the engine publishes immutable analysis frames, and the UI adds new interpretations without redesigning the pipeline. If the Health radar is enabled, it is the same pattern again — a new renderer over the existing per-position snapshot.
>
> The measurable target from QAS-5 was: a new graph, filter, or measurement should touch **at most one existing module**, with an eight person-day budget per feature. ADR-003 supports that through MVVM and ViewModel testability; ADR-004 supports it through App, test, and verify module separation, so six members — and AI coding assistants — can work without turning review into a guessing game.
>
> Because the engine is isolated and CI-locked, these additions are **limited, local changes** — which is exactly what 'extensible architecture' should mean."

**[지시문]** 이 슬라이드에서는 "새 탭이 싸다"를 추상적으로만 말하지 말고, 실제 구현된 화면 묶음을 한 번 더 짚는다: `Rate/Scope`, `Beat Error`, `Trace`, `Vario`, `Long-Term`, `Sweep`, `Escapement`, `Positions`, `Beat Noise`, `Waveforms`, `Filter Scope`, `Sound Print`, `Spectrogram`.

---

## 7. TinyML + 개발 전반 AI 사용 + CI/CD 자동화 (3:00)
> ▣ RUBRIC: **Area 7 — Use of AI in Building the Software (15점)**
> - AI 도구 사용 설명 5점 / 사려깊은 활용 5점 / 강점·한계·위험 회고 5점
> ▣ SLIDE 7: AI 워크플로 (TinyML feature + Claude/Codex + CI/CD automation + AGENTS.md 가드레일)

### 7-1. 어떻게 썼는가 (5점)
**[Presenter]**
> "We used AI in three different ways.
>
> First, as a **product feature path**: the app has a signal-quality classifier seam for TinyML-style impulse-rejection decisions, plus a deterministic fallback and signal-quality warnings. If the trained model is present in the demo build, it plugs into this seam; either way, timing control stays outside the model.
>
> Second, as a **development collaborator**: we used Claude Code and Codex throughout the port, debugging, tests, documentation, and architecture review.
>
> Third, as **engineering automation**: AI helped us design and refine the CI/CD pipeline, including automated builds, tests, Verify runs, and release packaging checks. That pipeline is not the product itself, but it protects the product as we change it."

### 7-2. 사려깊은 활용 (5점)
**[Presenter]**
> "We applied AI across the lifecycle: the Qt-to-.NET port, generating and maintaining the 933 tests, CI/CD workflow automation, and an AI-driven **performance regression audit** that compared our port against the original C++ line by line, found six performance regressions, and we fixed each with a documented commit.
>
> The important part is that AI output was always checked by executable evidence: tests, CI jobs, Verify fixtures, ADRs, and live Pi measurements. ADR-004 explicitly separates App, test, and Verify so AI-assisted code has a testable review baseline. For the classifier path, we also constrained the model architecturally: it can classify or veto candidates, but it cannot create timing events or change the PLL lock."

### 7-3. 강점·한계·위험 회고 (5점) — 솔직하게
**[Presenter]**
> "Honestly, on the strengths, limits, and risks:
>
> - **Strength** — it let a small team port a large real-time app, add a classifier-based signal-quality path, and automate the build/test/release workflow with traceable history.
> - **Limit** — AI over-claims. Early on it labeled our MVVM and pipe-and-filter as fully applied; we had to verify against the code and **downgrade those claims**. The same applies to TinyML: we only claim what the model actually does in the running app.
> - **Risk** — for a real-time, accuracy-critical system, a plausible-but-wrong AI change or model prediction can silently hurt timing. Our mitigation was structural: the classifier path cannot own timing, CI enforces architecture boundaries, Verify gates adverse signals, and human review checks the generated code and workflows. EXP-04 remains the formal TinyML Go/Conditional/No-Go gate if the trained model is included. **We treated AI as a fast collaborator that must be checked, not as an authority.**"

---

## 8. 클로징 & Q&A (0:45)
**[Presenter]**
> "In short: this is a running watch-measurement application with the required display surface, accuracy first, proven on the Pi 5 with measured latency and a two-system comparison; an architecture that's modular, portable, and CI-enforced; and AI used both in the product through the signal-quality classifier path and in the development process through guarded automation. Thank you — we're happy to take questions."

---

## 부록. 예상 질문 & 답변 (Q&A 대비)

| 질문 | 핵심 답변 |
|---|---|
| "정확도를 어떻게 보장했나?" | 파이프라인 전체 타이밍 보존 + adaptive floor / PLL onset gating / regime guard / detection-gap / rate warm-up(기본 동작) + accept-band 단일 소스. Verify·adverse 수치로 입증. |
| "CI/CD로 정확도를 검증한다고 했는데?" (Son의 Piazza 질문 관련) | CI/CD는 *애플리케이션이 아니라 개선 방법*이다(Stephen Beck). 정확도 주장은 runtime 설계 선택, 기준기 비교, 반복 측정으로 먼저 보여주고, Verify/CI는 그 정확도가 회귀하지 않게 막는 supporting evidence로 둔다. |
| "지연이 정말 실시간인가?" | `4-Planned-Experiments.md` EXP-02 표 그대로 답한다. 21600@48k Sim/Playback/Live와 43200@192k Sim/Playback/current all-tab check 모두 Pass, worst usage 24.2–43.8%, Drop 0 / Miss 0. |
| "두 시스템 값이 다르면?" | 차이를 숨기지 않고 원인(캘리브레이션·마이크 감쇠·필터·lift angle) 가설 + 일관 측정 반복으로 설명. |
| "AI 기능이 진짜 AI인가?" | 데모 빌드에 trained model이 포함되어 있으면 네, TinyML classifier를 signal-quality/impulse-rejection 경로에 적용했다고 말한다. origin/main 기준으로 확실한 증거는 classifier seam + deterministic fallback + signal-quality warning이며, 안전을 위해 이 경로는 이벤트 생성·retiming·BPH/PLL sync를 건드리지 못한다. |
| "레이더 차트는?" | 실제 Health 탭이 있으면 Positions와 같은 per-position 스냅샷 재사용, 카탈로그 1엔트리 + 렌더러로 설명. 없으면 레이더 보너스는 청구하지 않고, 구현된 진단/분류(Vario + Beat Error + Position Consistency)만 정직하게 제시. |
| "CI/CD도 AI 활용으로 말할 수 있나?" | 가능하다. 단, CI/CD는 정확도 자체의 주 증거가 아니라 AI를 활용해 만든 engineering automation이다. Area 7에서 "AI-assisted CI/CD pipeline: build, test, Verify, release packaging 자동화"로 말한다. |
| "Area 2의 AI 기능은 실제로 동작하나?" | TinyML 모델이 실제 데모 빌드에 포함되어 있으면 "동작한다"고 말한다. origin/main만 기준으로는 모델 파일/토글이 확인되지 않으므로, 모델이 빠진 빌드라면 "TinyML-ready seam과 heuristic fallback이 동작한다"고 정직하게 말한다. |
| "확장성 증거?" | 새 탭=카탈로그 1엔트리+consumer, Core 불변. CI가 경계 강제 → 변경 국소화. |
| "SW Architect 문서와 발표가 어떻게 연결되나?" | QAS-1~6가 슬라이드 4~6의 품질속성 기준이고, ADR-001~004가 주요 구조 선택의 rationale이다. Risk/Experiment 문서는 "왜 이 위험을 줄였다고 말할 수 있는지"의 수치 근거다. |
| "Pipe-and-Filter를 적용했나?" | 전체 DSP 내부를 full Pipe-and-Filter로 쪼갠 것은 아니다. ADR-002대로 worker-level partial Pipe-and-Filter다: input → analysis → UI/recording 경계는 분리하지만 detector/metrics hot path는 한 스레드 synchronous chain으로 유지해 latency budget을 지킨다. |
| "MVVM은 완전한가?" | 완전한 교과서식 MVVM이라고 과장하지 않는다. ADR-003의 방향은 View/ViewModel/Model 분리와 ViewModel testability이고, 일부 lifecycle/UI orchestration은 code-behind/service에 남아 있다고 정직하게 말한다. |

> ▣ 전체 정직성 원칙: 없는 기능을 있다고 말하지 않는다. 한계를 먼저 말하면 신뢰가 올라가고, 루브릭의 "limitations remain" 항목(Area 3·4) 점수로 직접 환산된다.

## 부록 B. 발표 슬라이드별 SW Architect 문서 근거

| 슬라이드 | 문서 근거 | 넣을 한 줄 |
|---|---|---|
| 2. Qt/C++ → Avalonia/.NET | `ADR-001` | One codebase for Windows and Raspberry Pi, with OS audio isolated behind adapters. |
| 3. Architecture Overview | `5-Architectural-View.md`, `ADR-002`, `ADR-003` | Core has zero UI/platform dependency; runtime flow is worker-level partial Pipe-and-Filter. |
| 4. Quality Attributes | `2-Architectural-Drivers.md` | QAS are measurable: ±1.0 s/d, ≤ one beat period, ≥95% detection at SNR ≥30 dB, 0 display mismatches. |
| 5. Evidence | `3-Risk-Assessment.md`, `4-Planned-Experiments.md` | R-01/R-03 resolved by EXP-02; R-04 resolved by EXP-05; EXP-06 commercial comparison remains the key final accuracy check if not completed. |
| 6. Extensibility | `QAS-5`, `ADR-004` | New graph/filter/measurement target: ≤1 existing module changed; App/test/verify split supports six-person and AI-assisted development. |
| 7. AI Use | `ADR-004`, `EXP-04`, `R-17/R-18` | AI is useful but checked: tests/Verify/CI/human review are the safety net; TinyML requires the EXP-04 adoption gate. |
