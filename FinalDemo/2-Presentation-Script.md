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

---

## 슬라이드 구성 한눈에 (20분)

| # | 슬라이드 | 시간 | 채우는 Rubric |
|---|---|---|---|
| 1 | 타이틀 & 한 줄 소개 | 0:45 | — |
| 2 | 문제 & 접근: Qt/C++ → Avalonia/.NET, 단일 코드베이스 | 1:30 | Area 5(이식성), ADR-001 |
| 3 | 아키텍처 개요: Layers · Core 무의존 · CI 강제 경계 | 3:00 | **Area 5 (20점)** |
| 4 | 품질속성 & 트레이드오프 (accuracy 최우선) | 4:30 | **Area 3 (20점)** |
| 5 | 성능·지연·정확성 근거 (Pi 5 실측) | 4:30 | **Area 4 (25점)** |
| 6 | 확장성 심화: 새 측정/필터/탭 추가 | 2:00 | **Area 5 (20점)** |
| 7 | 개발에서의 AI 사용 + 회고 | 3:00 | **Area 7 (15점)** |
| 8 | 클로징 & Q&A | 0:45 | — |

> ⏱ 자르는 순서: ⑥ 일부 → ⑦ 회고 압축. 절대 안 자르는 것: Area 3 트레이드오프, Area 4 수치 근거.

---

## 1. 타이틀 & 한 줄 소개 (0:45)
> ▣ SLIDE 1: 제품 스크린샷 + "Windows & Raspberry Pi 5, one codebase"

**[Presenter]**
> "We're Team 5. TimeGrapher listens to a mechanical watch and measures its accuracy in real time. We rebuilt it from the original Qt/C++ version into **Avalonia and C# on .NET 8**, so a **single codebase** runs on both Windows and the Raspberry Pi 5. In this presentation we'll explain the architecture and show the evidence behind what you just saw."

---

## 2. 문제 & 접근 (1:30)
> ▣ RUBRIC: Area 5(이식성) · ADR-001
> ▣ SLIDE 2: Qt/C++ → Avalonia/.NET 전환 이유, 단일 코드베이스 다이어그램

**[Presenter]**
> "The original was Qt and C++. We made a deliberate architectural choice to move to Avalonia and .NET — documented in ADR-001. The driver was **portability with one codebase**: the same source produces a Windows build and a Raspberry Pi build, and only the per-OS audio backend changes. That decision is what lets accuracy, performance, and UI work carry over to the Pi without a separate port."

> 🔧 SLIDE에 ADR-001 제목과 결정 근거 1줄 인용 권장.

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

### 4-2. accuracy를 최우선으로 둔 증거 (5점) — **가장 중요한 5점**
**[지시문]** accuracy 전용 tactic 목록 슬라이드. 측정 수치(recall/precision)와 함께.

**[Presenter]**
> "Accuracy was the top priority, and we can show it in the architecture. The whole pipeline preserves timing precision — capture, filtering, detection, measurement — because every reading depends on tiny timing differences at high sample rates.
>
> Concretely, the detector defends accuracy by default: an **adaptive noise floor** for weak signals, **PLL-guided onset gating** so an early noise crossing can't steal a beat, a **regime guard with hysteresis** so a single impulse can't flush the lock, **detection-gap handling** so one missed beat never flips the sign of the rate, and a **rate warm-up** that withholds a reading until the regression is trustworthy.
>
> These aren't optional toggles — they're the default detection behavior. On our adverse test scenarios, recall and precision recover from near-zero to above 0.95 on weak and noisy signals. And every graph, badge, and verdict reads its accept band from **one shared source**, so the system never shows two different answers for the same reading."

### 4-3. 트레이드오프 설명 (5점)
**[지시문]** 트레이드오프 표 슬라이드.

**[Presenter]**
> "Prioritizing accuracy cost us elsewhere, and we made those tradeoffs on purpose:
>
> - **Accuracy vs. latency.** A longer warm-up before reporting BPH and rate means the first reading is later — we accept that delay to avoid showing a wrong number early.
> - **Accuracy vs. performance.** A higher sample rate gives finer timestamp resolution but costs more CPU per beat. We support up to 192 kHz and verified it still fits the budget on the Pi.
> - **The key one — accuracy vs. visualization.** When the system falls behind its deadline, our **deadline monitor degrades the *visuals first*** — it eases live previews and widens publish intervals — but it **never drops or interpolates a measurement**. We protect the number and sacrifice the picture, then recover the picture when we catch up. That ordering *is* our accuracy-first decision, made executable."

### 4-4. 달성한 것과 남은 한계 (5점) — 정직성
**[Presenter]**
> "What we achieved: accurate, stable readings that match a reference instrument, running in real time on the Pi. What remains: we had no high-beat (43200 BPH) real movement, so that condition is verified with synthetic and playback signals, not real acoustic capture; and the Pi live-mic path depends on a detected USB capture device. We're reporting those limits rather than hiding them."

---

## 5. 성능·지연·정확성 근거 (4:30)
> ▣ RUBRIC: **Area 4 — Performance, Latency, Correctness (25점)**
> - Pi 실시간 8점 / 저지연 6점 / 정확성 6점 / 근거 5점
> ▣ SLIDE 5: 지연 측정 표 (Pi 5), 두 시스템 비교, 테스트 수

### 5-1. Pi 5 실시간 (8점) + 저지연 (6점)
**[지시문]** 지연 측정 표 슬라이드. budget 대비 worst usage % 강조.

**[Presenter]**
> "We measured the real end-to-end latency on the Pi 5 — capture to processing to display — from the app's own logs, across simulation, playback, and live input.
>
> At 21600 BPH and 48 kHz, the live run averaged about **3.9 milliseconds** end-to-end, worst case **40 milliseconds**, against a beat-period budget of **166 milliseconds** — about a quarter of the budget. Even the tightest condition, **43200 BPH at 192 kHz**, had a worst case of **34.6 milliseconds** against an **83 millisecond** budget — roughly 41%. **Zero dropped audio samples, zero missed beats**, every run. So real-time on the target platform isn't a claim — it's measured, with margin."

### 5-2. 정확성 (6점) + 근거 (5점)
**[Presenter]**
> "For correctness we have three kinds of evidence:
>
> 1. **Two-system comparison** — the same watch on TimeGrapher and a reference Chronoscope, with matching rate, amplitude, and beat error.
> 2. **Automated verification** — our `Verify` console checks detected BPH and event-level precision/recall against ground-truth fixtures, and it runs in CI on every change. Nine adverse scenarios — weak signal, noise, impulse storms, gain steps — are gated there.
> 3. **Test suite** — **933 tests** pass across the engine, app, and platform layers.
>
> Together: the live reading matches a reference, the detector is checked against known signals automatically, and the whole thing is regression-guarded."

> 🔧 SLIDE에 실제 두 시스템 비교 수치 + Verify 통과 캡처 넣기.

---

## 6. 확장성 심화 (2:00)
> ▣ RUBRIC: **Area 5 — supports adding new measurements/filters/graphs with limited redesign (6점)**
> ▣ SLIDE 6: "새 디스플레이 추가" before/after — InfoTabCatalog 한 곳 + Frame consumer

**[Presenter]**
> "Adding capability is deliberately cheap. A new display is a single entry in the tab catalog plus one frame-consumer — the analysis engine doesn't change. A new measurement rides the same frame the others already carry. And the AI gate is a defined seam: a future ONNX model implements one interface and is injected at composition, while Core stays dependency-free.
>
> Because the engine is isolated and CI-locked, these additions are **limited, local changes** — which is exactly what 'extensible architecture' should mean."

---

## 7. 개발에서의 AI 사용 + 회고 (3:00)
> ▣ RUBRIC: **Area 7 — Use of AI in Building the Software (15점)**
> - AI 도구 사용 설명 5점 / 사려깊은 활용 5점 / 강점·한계·위험 회고 5점
> ▣ SLIDE 7: AI 워크플로 (Claude Code/Codex + AGENTS.md 가드레일 + for-ai 문서)

### 7-1. 어떻게 썼는가 (5점)
**[Presenter]**
> "We used AI coding agents throughout — Claude Code and Codex — but inside guardrails. Every repo has an `AGENTS.md` that constrains the agent: keep Core dependency-free, preserve the existing patterns, write commit rationale in English and Korean, and never refactor outside the request. We also keep architecture views *for the AI* — module, data-model, and tactics documents the agent must read before changing structure."

### 7-2. 사려깊은 활용 (5점)
**[Presenter]**
> "We applied it across the lifecycle: the Qt-to-.NET port, generating and maintaining the 933 tests, and — one we're proud of — an AI-driven **performance regression audit** that compared our port against the original C++ line by line, found six performance regressions, and we fixed each with a documented commit. AI did design discussion, debugging, and documentation, not just code."

### 7-3. 강점·한계·위험 회고 (5점) — 솔직하게
**[Presenter]**
> "Honestly, on the strengths, limits, and risks:
>
> - **Strength** — it let a small team port a large real-time app and keep accuracy tactics intact, with traceable history.
> - **Limit** — it over-claims. Early on it labeled our MVVM and pipe-and-filter as fully applied; we had to verify against the code and **downgrade those claims**. The agent is confident even when wrong.
> - **Risk** — for a real-time, accuracy-critical system, a plausible-but-wrong change can silently hurt timing. Our mitigation was structural: CI-enforced boundaries, golden-master and adverse tests, and a rule that the agent reports suspected bugs instead of silently 'fixing' them. **We treated AI as a fast collaborator that must be checked, not as an authority.**"

---

## 8. 클로징 & Q&A (0:45)
**[Presenter]**
> "In short: accuracy first, proven on the Pi 5 with measured latency and a two-system comparison; an architecture that's modular, portable, and CI-enforced; and AI used with guardrails and honest reflection. Thank you — we're happy to take questions."

---

## 부록. 예상 질문 & 답변 (Q&A 대비)

| 질문 | 핵심 답변 |
|---|---|
| "정확도를 어떻게 보장했나?" | 파이프라인 전체 타이밍 보존 + adaptive floor / PLL onset gating / regime guard / detection-gap / rate warm-up(기본 동작) + accept-band 단일 소스. Verify·adverse 수치로 입증. |
| "CI/CD로 정확도를 검증한다고 했는데?" (Son의 Piazza 질문 관련) | CI/CD는 *애플리케이션이 아니라 개선 방법*이다(Stephen Beck). 우리는 Verify가 ground-truth fixture로 BPH·정밀도/재현율을 매 커밋 검증하게 했고, **데모는 앱과 그 동작**으로 보여준다. |
| "지연이 정말 실시간인가?" | Pi 5 실측: worst E2E가 beat budget의 24–41%, drop/miss 0. 측정 로그 근거 제시. |
| "두 시스템 값이 다르면?" | 차이를 숨기지 않고 원인(캘리브레이션·마이크 감쇠·필터·lift angle) 가설 + 일관 측정 반복으로 설명. |
| "AI 기능이 진짜 AI인가?" | 현재는 시임 + 클래식 게이트(PllMatchGate)가 셔핑, ONNX TinyML이 같은 인터페이스로 드롭인 예정. **구조적 안전 보장**(게이트는 통과/폐기만, 동기화 못 건드림)이 핵심 가치. 🔧 모델 상태 정직히. |
| "레이더 차트는?" | 🔧 미구현이면: Bonus는 진단/분류만 청구한다고 답. (또는 구현 후 청구.) |
| "확장성 증거?" | 새 탭=카탈로그 1엔트리+consumer, Core 불변. CI가 경계 강제 → 변경 국소화. |

> ▣ 전체 정직성 원칙: 없는 기능을 있다고 말하지 않는다. 한계를 먼저 말하면 신뢰가 올라가고, 루브릭의 "limitations remain" 항목(Area 3·4) 점수로 직접 환산된다.
