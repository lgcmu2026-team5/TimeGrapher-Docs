# Risk Assessment

> TimeGrapher Reference Architecture — Milestone 1
> Team 5 consolidated risk register (final version, based on RiskAssessment.xlsx)

---

## 1. How We Assessed

This risk assessment follows the SAP (Software Architecture Practice) process.

1. **Prioritize architectural drivers** — rate business importance and technical risk as H/M/L
2. **Quantify with quality-attribute scenarios (QAS)** — Source → Stimulus → Artifact → Environment → Response → Response Measure
3. **Identify risks as "uncertainties (question marks)"** — separate feature-addition / refactoring / integration / schedule / knowledge-gap risks
4. **Rank by Impact (I) × Probability (P)** — use explainable H/M/L rather than numeric scores
5. **Validate high risks via experiments (Spike/PoC)** — state the question, exit criteria, measurement method, dataset, and pass criteria
6. **Keep risk–experiment–decision traceability** — track owner, status (Open/Mitigating/Pass), and residual risk

### Scoring Guide

| Grade | Impact | Probability |
|:----:|------|------|
| **Low** | User unaffected, or a workaround exists | Rarely occurs |
| **Medium** | Errors in specific / non-critical functions | Can occur under normal conditions |
| **High** | System failure or complete service disruption | Almost always occurs |

### Status Legend

| Mark | Meaning |
|:----:|------|
| 🔴 **Open** | Top-priority risk. Needs early validation via experiment/spike |
| 🟡 **Mitigating** | Mitigation direction set and in progress |
| ⚪ **Watch/Pass** | Low priority. Monitor only or proceed as-is |

### Reference Index (QAS · FR)

Each risk's **Related QAS** references [Milestone1_QA_Final_1.md](../../Milestone1_QA_Final_1.md); its **Related FR** references [Milestone1_2-Architectural-Drivers.md](Milestone1_2-Architectural-Drivers.md).

| QAS | Quality Attribute | B | R |
|----|------|:--:|:--:|
| **QAS-1** | Performance (Latency) — sound input→screen ≤500ms | H | H |
| **QAS-2** | Accuracy — locate beats within ≤0.1ms | H | H |
| **QAS-3** | Availability (Graceful Degradation) — "signal weak" under noise | H | H |
| **QAS-4** | Consistency — values agree across displays (0 mismatches) | H | M |
| **QAS-5** | Modifiability (Extensibility) — add new measurement/filter/graph | H | M |
| **QAS-6** | Usability — read/operate on the 800×480 touchscreen | M | M |

> **QAS-gap note:** Some risks — recoverability (device disconnect), long-term storage capacity, AI features — are not directly covered by the current 6 QAS. Those rows are marked `QAS gap` and are candidates for future QAS additions. (FR group: **G01–G12** = the FR-01…FR-12 display feature groups.)

---

## 2. Risk Register

### A. Real-Time Performance (RPi) — Highest-Risk Group

| ID | Risk | Quality Attribute | Related QAS | Related FR | P | I | Mitigation | Status / Team Decision |
|----|------|----|------|------|:--:|:--:|--------|--------|
| **R-A1** | On RPi5, capture→process→display can't stay real-time at 96k (target)/192k (stretch) → block drop / missed beat | Performance (Real-Time) | **QAS-1** | FR-08-01, FR-12-04·14, FR-05-03 | H | H | Week-1 spike to measure RPi limits, then fix sample-rate target (demote 192k to stretch) | 🔴 Decide spec after experiment |
| **R-A2** | Concurrent 4-filter pipeline (F0→F1→F2→F3) + simultaneous multi-graph rendering → <20 FPS / UI freeze | Performance | **QAS-1** | FR-12-01·04·05·13 | M~H | H | Reuse shared input buffers, stop rendering inactive views, measure FPS budget | 🟡 Concurrent vs single view after perf check |
| **R-A3** | End-to-end latency target (p99 ≤500ms; avg ≤100 / worst ≤200ms) not met | Performance (Latency) | **QAS-1** | FR-08-01, FR-12-04 | M | H | Per-stage latency instrumentation, backlog monitoring | 🟡 Worst-case: optimize or downgrade feature |
| **R-A4** | Long-term accumulation (FR-07, 24h+) / continuous run causes memory leak/growth → degradation | Reliability (+Performance) | **QAS-1** (continuous run) | FR-07-01…03·10 | M | M | Long-term RSS trend monitoring, buffer caps & aggregation design | 🟡 Verify memory leak on current code (experiment) |

### B. Signal Processing / Measurement Accuracy — Highest-Risk Group

| ID | Risk | Quality Attribute | Related QAS | Related FR | P | I | Mitigation | Status / Team Decision |
|----|------|----|------|------|:--:|:--:|--------|--------|
| **R-B1** | Beat onset/peak detection precision ≤0.1ms (≈10 samples @96k) hard to achieve → contaminates rate, beat error, amplitude | Accurateness (Measurement) | **QAS-2** | FR-08-04…06, FR-05-13, FR-06-01…04 | H | H | Validate detection early on synthetic-signal (known ground truth) bench | 🔴 Verify current logic, improve if needed |
| **R-B2** | Under ambient noise / weak signal (SNR≥14dB, ≥95%), false detection. Bad data shown as normal values → pollutes X/D summary | Robustness/Availability (+Accuracy) | **QAS-3** (+QAS-2) | FR-12-08, FR-05-17…18, FR-04-06 | M~H | H | Signal-quality judgment; isolate bad data as "signal weak", exclude from X/D | 🔴 Test per noise level, improve if needed |
| **R-B3** | Amplitude depends on lift angle and the A–C interval → wrong settings cause amplitude miscalculation | Accurateness (Correctness) | **QAS-2** | FR-05-14, FR-06-02 | M | M | Validate lift-angle input, default guidance, unit-test the formula | ⚪ Pass |
| **R-B4** | 0.1ms-grade ground truth unobtainable on real HW → reliance on synthetic validation; risk to proven accuracy & demo credibility | Testability (+Accuracy) | **QAS-2** | FR-05-04·05, FR-08-02 | M | M | Sim/Playback reproducible tests, predefined validation scenarios | ⚪ Pass |
| **R-B5** | Domain-specific logic errors, e.g. Scope2 tic/tac axis not guaranteed (50/50 average cycle) | Correctness | **QAS-2·QAS-4** | FR-05-15·17·21 | L~M | M | State the no-guaranteed-axis assumption, unit-test cycle boundaries | ⚪ Pass (FR-05 only) |

### C. Architecture / Extensibility

| ID | Risk | Quality Attribute | Related QAS | Related FR | P | I | Mitigation | Status / Team Decision |
|----|------|----|------|------|:--:|:--:|--------|--------|
| **R-C1** | Baseline GUI is a single god-screen (MainWindow) → if module separation fails in 5 weeks, every FR addition ripples | Modifiability | **QAS-5** | G01–G12 overall | M | H | Skeleton out acquisition/processing/calc/presentation separation in Week 1 | 🟡 Restructure/refactor task |
| **R-C2** | Without a shared measurement model for cross-view consistency (same snapshot, 0 mismatch), displayed values diverge | Correctness (Consistency) | **QAS-4** | FR-12-05, FR-06-06, FR-04-05…07, FR-02-07…08 | M | H | Single data source keyed by snapshot ID, shared time-axis model | 🟡 Proceed as planned |
| **R-C3** | Without up-front filter/marker extension abstraction (e.g. add F4 in ≤2 files), late cost spikes / side effects on new graphs | Modifiability | **QAS-5** | FR-12-01, FR-05-01 | M | M | Pre-design a Filter interface (strategy) / plug-in registration scheme | 🟡 Address via stronger modularization |
| **R-C4** | Introducing concurrency for performance raises race-condition, debugging, test complexity | Reliability (+Testability) | **QAS-1·QAS-4** | FR-12-04·05 | M | M | Lock-free buffers, clear thread boundaries, concurrency unit tests | 🟡 Lock-free only on critical path, async for UI |

### D. Hardware / Platform / Availability

| ID | Risk | Quality Attribute | Related QAS | Related FR | P | I | Mitigation | Status / Team Decision |
|----|------|----|------|------|:--:|:--:|--------|--------|
| **R-D1** | AGC not disabled (C-4) / poor mic coupling → signal distortion collapses all measurement trust | Accurateness (+Reliability) | **QAS-2·QAS-3** | FR-08-01 | M | H | Make AGC-off & coupling verification an environment checklist from day one | 🟡 Document in user guide |
| **R-D2** | Windows↔RPi porting (C-3) — audio backend (WASAPI/ALSA) differences; dev on Win, demo on RPi exposes a perf gap | Portability (+Performance) | **QAS-1** | FR-08-01, FR-05-03·14…16 | M | M | Isolate audio I/O behind a port-adapter, verify on RPi early & regularly | ⚪ Low risk — RPi run in parallel |
| **R-D3** | Variable sample rate/device (48/96/192k) support increases timing & complexity | Portability (+Accuracy) | **QAS-1·QAS-2** | FR-05-03…05, FR-08-01 | M | M | Specify supported sample-rate range, normalize in the adapter | 🟡 Specify feasible spec (mic spec, etc.) |
| **R-D4** | Audio device disconnect / recoverable stream error during measurement → crash, data loss, manual restart | Availability (Recoverability) | **QAS gap** (Availability) | FR-05-03, FR-08-01 | M | H | Unplug/replug & stream-error injection tests; 0 crashes, auto-resume, fault indication | 🟡 Recovery menu / exception detection & state save |

### E. Usability / UI (800×480)

| ID | Risk | Quality Attribute | Related QAS | Related FR | P | I | Mitigation | Status / Team Decision |
|----|------|----|------|------|:--:|:--:|--------|--------|
| **R-E1** | Low-res touchscreen can't fit summary bar + multiple graphs + scope strip with adequate readability (≥24px / ≥9mm) | Usability | **QAS-6** | FR-06-06, FR-01-05, FR-04-03, FR-02-06 | M | M | Layout prioritizing core readings, tab-based split, ≤2-tap navigation | 🟡 Run sizing tests |
| **R-E2** | 12+ FR displays compete for limited screen space → information overload | Usability | **QAS-6** | FR-05-01, G01–G12 | M | M | Priority-based display set, secondary info on toggle | ⚪ Separated by tabs, proceed as-is |
| **R-E3** | Touch accuracy / recognition may drop on the touchscreen | Usability | **QAS-6** | FR-06-06, FR-04-03 | L | L | Experimentally verify touch sensitivity & recognition range | ⚪ Experiment if app-level controllable |

### F. Project / Process

| ID | Risk | Threatened QA | Related QAS | Related FR | P | I | Mitigation | Status / Team Decision |
|----|------|----|------|------|:--:|:--:|--------|--------|
| **R-F1** | 5-week time-box vs broad FR set (12 displays + AI) → can't build all; priority failure drops core features | All QA (esp. Perf·Accuracy) | **QAS-1…6 overall** | G01–G12 | M~H | H | Freeze FR priorities, split AI as optional, core path first | 🔴 Plan well, drop what must be dropped |
| **R-F2** | Baseline code (TimeGrapher_v10.4) lacks understanding/docs → onboarding delay, current perf level unknown | Modifiability | **QAS-5** | G01–G12 | L | M | Make code-reading sessions & a module map a Week-1 task | ⚪ Lowered by using AI |
| **R-F3** | Qt/C++·DSP·RPi learning curve (team ramp-up) + limited C++ experience | All QA | (overall) | — | L~M | M | Role division & pairing, small spikes for early learning | ⚪ Lowered by using AI |
| **R-F4** | Optional AI/TinyML feature raises on-device uncertainty (insufficient dataset, training/tuning time, PC↔Pi mismatch) | Accurateness | **QAS gap** (AI scope undefined) | — (AI FR not derived) | M | M | Split as optional scope, rule-based fallback if short; pre-study small models | 🟡 Verify on Windows first, then assess RPi5 |
| **R-F5** | Over-reliance on GenAI / hallucinated code — plausible-but-wrong code in DSP/concurrency/real-time areas transfers to accuracy & perf risk | Correctness·Performance·(Testability) | **QAS-1·QAS-2** | — | M | M | Mandate adversarial verification (unit tests, synthetic-signal bench), understand core algorithms, confirm with mentor | 🟡 Code review + whole team understands algorithms |
| **R-F6** | Only one testable specimen (watch) for RPi5 → no schedule for real-use test validation | Testability (test basis) | **Verification basis (all QAS)** | — | H | H | Plan accelerated/shortened tests, schedule specimen sharing, substitute Sim/Playback validation | 🔴 Test-environment constraint, schedule risk |
| **R-F7** | English communication among stakeholders may fail to convey intent precisely | Process | — | — | M | L~M | Document key decisions (ko/en bilingual), state agreed items | ⚪ Watch |

### G. Requirements / Verification

| ID | Risk | Quality Attribute | Related QAS | Related FR | P | I | Mitigation | Status / Team Decision |
|----|------|----|------|------|:--:|:--:|--------|--------|
| **R-G1** | Some requirements ambiguous/under-specified ("long-term", doc-vs-FR, etc.) → unclear acceptance criteria, rework | Testability (actionability) | (affects QAS-3, etc.) | FR-12-12 (case) | M | L~M | Quantify ambiguous terms, separate documentation requirements from FR | ⚪ Refine during QA |
| **R-G2** | 6h/24h long-term test not reproducible within demo time → verification gap | Testability (verifiability) | **QAS-1** (10-min only) | FR-07-10 | M | L | Accelerated tests + log evidence; combine hourly results | ⚪ Handle as separate run |
| **R-G3** | No test automation (one device, no test room, no unit-test program) → regressions missed when detector/calc logic changes | Testability | **QAS-5** (0-regression measure) ·QAS-2·QAS-3 | G01–G12 | M~H | M | Build a regression dataset (Sim/Playback/WAV), rerun on change | 🟡 Build regression dataset first |

### H. Data / Storage

| ID | Risk | Quality Attribute | Related QAS | Related FR | P | I | Mitigation | Status / Team Decision |
|----|------|----|------|------|:--:|:--:|--------|--------|
| **R-H1** | Long audio recording / long-term data volume exceeds microSD capacity | Capacity / Reliability | **QAS gap** | FR-07-01…03·10 | M | M | Keep only downsampled/statistics (circular buffer), manage storage format | 🟡 Check SD spec + recording test |
| **R-H2** | Saving audio DDR→flash (SD): write speed < generation speed → bottleneck, RAM buildup, overflow | Performance / Reliability | **QAS-1** (input keep-up precondition) | FR-07 | M | H | Verify SD-card spec & real recording test, RAM buffering & backpressure | 🟡 Experiment (aging test) |
| **R-H3** | No real-time save → if app exits mid-measurement (e.g. 9/10 positions done), prior measurement data lost | Reliability (Recoverability) | **QAS gap** | FR-04-03, FR-07 | M | M | Periodic per-measurement checkpointing & persistence | 🟡 Under review |
| **R-H4** | Uncertain which data structure fits (audio buffer / measurement storage structure) | Modifiability | **QAS-5·QAS-1** | FR-07, FR-04 | L~M | M | Pre-design buffer & storage model, validate with a prototype | 🟡 Design task |

---

## 3. Risk Matrix (P × I)

| | **I = Low** | **I = Medium** | **I = High** |
|:--:|:--:|:--:|:--:|
| **P = High** | | | 🔴 R-A1, R-B1, R-F6 |
| **P = M~H** | | R-G3 | 🔴 R-A2, R-B2, R-F1 |
| **P = Medium** | R-G2 | R-A4, R-B3·B4, R-C3·C4, R-D2·D3, R-E1·E2, R-F4·F5, R-H1·H3·H4 | R-A3, R-C1·C2, R-D1·D4, R-H2 |
| **P = Low~M** | R-G1, R-F7 | R-B5, R-F3 | |
| **P = Low** | R-E3 | R-F2 | |

> The closer to the top-right (🔴), the higher the priority. Validate above the diagonal via early experiments; monitor/proceed as-is below it.

---

## 4. Top-Priority Risks

Risks most urgent for early validation/mitigation:

| Rank | ID | One-line summary | Related QAS | Why top priority |
|:--:|----|--------|----|--------|
| 1 | **R-A1** | RPi5 real-time feasibility | QAS-1 | If real-time processing fails, most live-display features collapse immediately in the demo |
| 2 | **R-B1 / R-B2** | Detection precision & noise robustness | QAS-2 / QAS-3 | Showing bad signals as normal values misleads the user and pollutes the FR-04 X/D summary |
| 3 | **R-F6** | One test specimen / weak test basis | (verification basis) | Lack of specimens & automation means no real-use validation schedule at all |
| 4 | **R-C1** | God-screen module separation | QAS-5 | If Week-1 separation fails, every FR addition ripples → whole schedule collapses |
| 5 | **R-F1** | 5-week time-box vs broad FR | QAS-1…6 overall | Failure to freeze priorities lowers core-feature completeness |

> R-F4 (AI feature scope undefined) is tracked as a **separate candidate-feature risk**, not a top implementation risk, until its FR/QA scope is fixed.

---

## 5. Architectural Trade-offs (Reference)

Key quality-attribute conflicts identified while mitigating risks:

| Attribute 1 | Attribute 2 | Cause (risk) | Resolution / Compromise |
|------|------|--------|--------|
| Performance (QAS-1: 500ms latency) | Modifiability (QAS-5: module extensibility) | Fine-grained slicing + a middle broker for extension adds data-copy & context-switch overhead, possibly exceeding 500ms | Make the UI-extension event bus **asynchronous**; keep the audio-capture→DSP **critical path** on a **lock-free buffer**, even if it allows some coupling |
| Accuracy/Availability (QAS-3: noise filtering) | Performance (QAS-1: 96k SPS processing) | Heavy filters / complex signal analysis miss the 96k SPS real-time deadline | Set a Big-O upper bound on filter complexity; isolate heavy items (spectrogram, etc.) to **on-demand** activation |
| Resource management (RPi memory) | Usefulness (FR-07: long-term performance graph) | Continuously accumulating raw data in memory leads to OOM | Adopt a **downsampling circular buffer** that keeps only avg/max/min statistics past a retention window |

---

*Source: RiskAssessment.xlsx (consolidated from sheets 취합 · 정리 · Risk_윤성준 · Risk 김준성 · JD · Risk list_오선영 · Jaehong)*
*QAS index: [Milestone1_QA_Final_1.md](../../Milestone1_QA_Final_1.md) · FR index: [Milestone1_2-Architectural-Drivers.md](Milestone1_2-Architectural-Drivers.md)*
