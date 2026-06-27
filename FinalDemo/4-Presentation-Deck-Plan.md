# Wednesday Presentation Deck Plan

This is the presentation counterpart to `3-Wednesday-Runbook.md`.

Known scoring priority: **demo 350 points, presentation 150 points**.
The presentation should not repeat the whole live tour. It should explain the architecture and evidence behind the demo, still in rubric order.

Target length: 20 minutes.

## Presentation Strategy

The demo answers: "Does it work?"

The presentation answers:

1. Why the architecture is credible.
2. Why the tradeoffs were intentional.
3. What evidence supports performance, latency, correctness, and extensibility.
4. How AI was used safely in the product and in development.

Opening line:

> "The demo followed the rubric from the running system. The presentation follows the same rubric from the architecture and evidence side."

## Slide Outline

| Slide | Time | Rubric | Purpose |
|---:|---:|---|---|
| 1 | 0:45 | Setup | Re-anchor the app and target platform. |
| 2 | 1:30 | Area 1 recap | Show the 12-display coverage matrix. |
| 3 | 2:00 | Area 2 | Explain enhancements and ONNX classifier safety. |
| 4 | 3:00 | Area 3 | Quality attributes and tradeoffs, accuracy first. |
| 5 | 3:00 | Area 4 | Performance/latency evidence on RPi5. |
| 6 | 2:00 | Area 4 | Correctness evidence and Witschi status. |
| 7 | 3:00 | Area 5 | Extensible architecture and dependency boundaries. |
| 8 | 1:30 | Area 6 | GUI usability and operational resilience. |
| 9 | 2:00 | Area 7 | AI in product and development, with verification. |
| 10 | 1:15 | Area 8 + Bonus + close | UI value, bonus, limitations, final ask. |

## Slide 1 - Running Product, Not A Mockup

Visual:

- One app screenshot on Raspberry Pi 5.
- Small labels: Live / Playback / Simulation, .NET 8, Avalonia, Core engine.

Speaker:

> "This is the same application you just saw running. TimeGrapher listens to a mechanical watch and computes rate, amplitude, beat error, and signal-quality feedback in real time. The application runs from one .NET 8/Avalonia codebase on Windows and Raspberry Pi 5."

## Slide 2 - Area 1 Coverage Matrix

Visual:

- 12-item checklist with tab names.
- Use green check marks only for items actually shown in the demo.

Speaker:

> "Area 1 was the largest demo surface. We showed all twelve required real-time displays. The architectural point is that they are not twelve separate calculators. They are views over the same analysis frame, which prevents inconsistent numbers across screens."

Include:

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

- Sound Print before/after or annotated screenshot.
- Rate/Scope annotated screenshot.
- Small architecture box: `App -> TimeGrapher.Inference -> ISignalQualityClassifier -> Core`.

Speaker:

> "Area 2 has three parts in our system: Sound Print readability, Rate/Scope measurement clarity, and the AI feature."

> "The AI feature is an on-device ONNX signal-quality classifier. The app tries to load the embedded ONNX model and falls back to a deterministic heuristic if loading fails. The important safety design is that this classifier is advisory: it annotates trust and warning state, but it cannot create events, retime events, or alter BPH/PLL synchronization."

Evidence to cite:

- `src/TimeGrapher.App/Views/MainWindow.axaml.cs`: composition root loads `OnnxSignalQualityClassifier.LoadOrElse`.
- `src/TimeGrapher.Inference/OnnxSignalQualityClassifier.cs`: model implementation.
- `src/TimeGrapher.Core/Analysis/DetectorMetricsEngine.cs`: quality assessment is read-only annotation.

## Slide 4 - Area 3 Quality Attributes And Tradeoffs

Visual:

- Pyramid or table:
  - Accuracy first
  - Performance/latency
  - Portability
  - Modifiability
  - Usability/testability as supporting attributes

Speaker:

> "Area 3 asks for quality-attribute tradeoffs. Our priority order is accuracy first, then real-time performance, portability, and modifiability. That order shaped the implementation."

> "We accept warm-up before reporting a trusted rate. We spend CPU on high sample rates when they improve timestamp resolution. And under load, we degrade visualization first rather than measurement: latest-wins rendering may skip intermediate visual frames, but the analysis history and measured values are preserved."

> "That is the central tradeoff: protect the number first, then recover the picture."

Include one limitation:

> "The remaining accuracy validation item is the Witschi commercial comparison if not completed before Wednesday. We report it as a remaining validation item, not as a hidden success."

## Slide 5 - Area 4 Performance And Latency Evidence

Visual:

- Table from EXP-02.
- Highlight the current all-tab check.

Use these exact numbers:

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

- Three-column evidence stack:
  - Known synthetic reference
  - Witschi commercial comparison
  - Verify/adverse tests

Speaker if Witschi data is complete:

> "For correctness, we use three layers. First, a known synthetic reference where the generator gives the expected rate, amplitude, and beat error. Second, a Witschi commercial comparison on the same watch. Third, automated Verify/adverse fixtures so we do not regress weak-signal and noisy-signal behavior."

Speaker if Witschi data is not complete:

> "For correctness, the known synthetic reference pass is complete and the Witschi comparison remains the final real-world validation item. We are explicit about that because architectural evaluation should separate achieved evidence from remaining risk."

Do not say:

- "CI/CD proves accuracy."

Say:

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

Evidence to cite:

- `InfoTabCatalog.cs`
- `AnalysisFrame`
- Core dependency boundary tests
- ADR-001 through ADR-004

## Slide 8 - Area 6 GUI Modifications

Visual:

- Before/after or annotated current UI.
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

Mention risk:

> "The risk is over-claiming. We mitigated that by downgrading claims when the code did not fully support them, and by keeping the AI classifier away from timing control."

## Slide 10 - Area 8, Bonus, Close

Visual:

- Current UI screenshot.
- Health radar screenshot if stable.
- Short limitation list.

Speaker:

> "For Best UI, our goal is a readable measurement instrument, not a decorative dashboard. The user can see whether the watch is synchronized, whether readings are trustworthy, and which diagnostic view explains the problem."

If Health bonus is stable:

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

## Final Prep Checklist

- [ ] Update the actual deck to follow slides 1-10.
- [ ] Put the Area number in the slide title or top-right corner.
- [ ] Add exact EXP-02 latency table.
- [ ] Add Witschi comparison table if available.
- [ ] Add one screenshot for each critical demo area.
- [ ] Mark Health/bonus as enabled only if stable in the live build.
- [ ] Rehearse transition from demo to presentation:

> "The demo showed the scoring items in the running system. Now we will show the architecture and evidence behind those items, in the same rubric order."

