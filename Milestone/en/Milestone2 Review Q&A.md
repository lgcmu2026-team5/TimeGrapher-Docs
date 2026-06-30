# Milestone 2 Review Q&A

---

## Project Plan

---

### How has the plan changed?

Several significant changes were made since Milestone 1:

<details>
<summary><strong>1. QAS-2 criterion replaced.</strong></summary>

The original latency target (p99 ≤ 500 ms) was replaced with a beat-period-based hard deadline: ≤ 83.3 ms at 43200 BPH @ 192 kHz and ≤ 166.7 ms at 21600 BPH @ 48 kHz. This change was driven by M1 feedback (#98) recognizing that 500 ms is a GUI-responsiveness limit, not a real-time beat-analysis limit. → [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display)

</details>

<details>
<summary><strong>2. Platform decision locked.</strong></summary>

Qt/C++ was replaced by .NET (C#) + Avalonia UI after [EXP-01](4-Planned-Experiments.md#exp-01-avalonia-rendering-backend-on-the-rpi5) confirmed GPU-accelerated rendering (GLX/EGL ≈ 60 FPS) on the RPi5 was viable. This also eliminated [R-16](3-Risk-Assessment.md#f-project--process) (learning curve risk).

</details>

<details>
<summary><strong>3. Sample rate range confirmed.</strong></summary>

The stretch goal of 192 kHz was elevated to a fully supported rate after [EXP-02](4-Planned-Experiments.md#exp-02-rpi5-real-time-sample-rate-ceiling) showed 43200 BPH @ 192 kHz running at only ~41% of the latency budget with zero block drops.

</details>

<details>
<summary><strong>4. Architecture changed from MVC to MVVM.</strong></summary>

The legacy MVC-style MainWindow was refactored into three MVVM roles (View / ViewModel / RunCommandService with State Pattern), driven by [QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--adding-a-new-measurementfiltergraph) modifiability requirements.

</details>

<details>
<summary><strong>5. Documentation consolidated.</strong></summary>

Separate per-milestone documents were merged into one evolving document set (M1 feedback #172), reducing version drift.

</details>

<details>
<summary><strong>6. ADR set introduced.</strong></summary>

Four Architecture Decision Records ([ADR-001](ADR/ADR-001.md), [ADR-002](ADR/ADR-002.md), [ADR-003](ADR/ADR-003.md), [ADR-004](ADR/ADR-004.md)) were written in M2 to formally capture key decisions.

</details>

---

### Has the team been actively assessing risk and updating the plan accordingly?

Yes. The evidence is concrete:

- **10 risks resolved** ([R-01](3-Risk-Assessment.md#a-real-time-performance-rpi) through [R-05](3-Risk-Assessment.md#a-real-time-performance-rpi), [R-08](3-Risk-Assessment.md#c-architecture--extensibility) through [R-12](3-Risk-Assessment.md#e-usability--ui-1280800)) with specific experimental evidence cited for each resolution.
- **Risk statuses updated** based on experiment outcomes: [R-01](3-Risk-Assessment.md#a-real-time-performance-rpi) and [R-03](3-Risk-Assessment.md#a-real-time-performance-rpi) moved from Medium probability to Low/Resolved after [EXP-02](4-Planned-Experiments.md#exp-02-rpi5-real-time-sample-rate-ceiling) measured actual latency; [R-04](3-Risk-Assessment.md#a-real-time-performance-rpi) moved to Resolved after [EXP-05](4-Planned-Experiments.md#exp-05-long-run-stability-24h) confirmed flat RSS over 24 hours.
- **Risk probability re-graded:** [R-01](3-Risk-Assessment.md#a-real-time-performance-rpi) downgraded from Medium/High to Low/High after measurement.
- **New risks added as discovered:** [R-19](3-Risk-Assessment.md#f-project--process) (single RPi5) was accepted with the mitigation note that a second RPi5 was later obtained.
- **M1 feedback directly fed risk updates:** the [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) criterion change (M1 feedback #98) was reflected in [R-01](3-Risk-Assessment.md#a-real-time-performance-rpi), [R-02](3-Risk-Assessment.md#a-real-time-performance-rpi), [R-03](3-Risk-Assessment.md#a-real-time-performance-rpi) risk descriptions within days.
- **[R-06](3-Risk-Assessment.md#b-signal-processing--measurement-trustworthiness) and [R-07](3-Risk-Assessment.md#b-signal-processing--measurement-trustworthiness) remain "In progress"** with explicit current-status notes and outstanding items listed, showing active tracking rather than stale entries.

---

### Does the team have a plan for any remaining significant issues/risks?

Yes. Three open risks remain with explicit plans:

| Risk | Status | Plan |
|------|--------|------|
| **[R-06](3-Risk-Assessment.md#b-signal-processing--measurement-trustworthiness)** — A/C event detection accuracy (< 0.1 ms) | In progress | [EXP-06](4-Planned-Experiments.md#exp-06-measurement-accuracy) Step 1 (Realistic-off simulation) completed 2026-06-21; Step 2 (Weishi Timegrapher comparison) planned 2026-06-22 to 2026-06-25 |
| **[R-07](3-Risk-Assessment.md#b-signal-processing--measurement-trustworthiness)** — Noisy/weak signals produce misleading values | In progress | "Signal weak" UI state in progress; test per noise level planned; rule: improve the logic if needed |
| **[R-17](3-Risk-Assessment.md#f-project--process)** — On-device TinyML uncertainty | In progress | [EXP-04](4-Planned-Experiments.md#exp-04-on-device-tinyml-inference-feasibility) planned for Milestone 3 (2026-06-23 to 2026-06-25); rule-based fallback (`PllMatchGate`) implemented as safety net |

---

### Does the team have a reasonable construction plan?

Yes. The construction plan is feature-allocated, team-member-assigned, and time-bounded:

- **12 functional feature groups ([G01–G12](2-Architectural-Drivers.md#functional-requirements))** were assigned to three sub-teams. As of 2026-06-21 (today is 2026-06-22), 11 of 12 are complete; [G09](2-Architectural-Drivers.md#g09--time-frequency-spectrogram-display) has two sub-items (FR-09-04, FR-09-05) still in progress with a target of 2026-06-23.
- **[QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--adding-a-new-measurementfiltergraph) budget of 8 person-days per feature** was used as the workload reference (16 days × 6 members ÷ 12 features).
- Milestone 3 (2026-06-23 to 2026-07-01) carries: [EXP-04](4-Planned-Experiments.md#exp-04-on-device-tinyml-inference-feasibility) (TinyML), [EXP-06](4-Planned-Experiments.md#exp-06-measurement-accuracy) Step 2 (Weishi), zoom-in/out for all graph tabs ([G01–G12](2-Architectural-Drivers.md#functional-requirements)), Setting Options, Presentation preparation, and Demonstration.
- The plan distinguishes mandatory from optional scope, with the AI feature explicitly isolated as optional with a rule-based fallback.

---

## Experiments / Results

---

### What experiments have been conducted?

Four technical experiments have been completed; two are in progress:

| Experiment | Status | Completion date |
|------------|--------|-----------------|
| **[EXP-01](4-Planned-Experiments.md#exp-01-avalonia-rendering-backend-on-the-rpi5)** — Avalonia rendering backend on RPi5 | Complete | 2026-06-10 |
| **[EXP-02](4-Planned-Experiments.md#exp-02-rpi5-real-time-sample-rate-ceiling)** — RPi5 real-time sample-rate ceiling | Complete | 2026-06-15 |
| **[EXP-03](4-Planned-Experiments.md#exp-03-gui-real-time-rendering-design-patterns)** — GUI real-time rendering design patterns | Complete | 2026-06-21 |
| **[EXP-05](4-Planned-Experiments.md#exp-05-long-run-stability-24h)** — Long-run stability (24h+) | Complete | 2026-06-16 |
| **[EXP-06](4-Planned-Experiments.md#exp-06-measurement-accuracy) Step 1** — Measurement accuracy (Realistic-off simulation) | Complete | 2026-06-21 |
| **[EXP-06](4-Planned-Experiments.md#exp-06-measurement-accuracy) Step 2** — Measurement accuracy (Weishi comparison) | In progress | Planned 2026-06-22~25 |
| **[EXP-04](4-Planned-Experiments.md#exp-04-on-device-tinyml-inference-feasibility)** — On-device TinyML inference feasibility | In progress | Planned M3 (2026-06-23~25) |

---

### Have the results addressed the open questions/issues?

Largely yes, with one significant item still outstanding:

- **[EXP-01](4-Planned-Experiments.md#exp-01-avalonia-rendering-backend-on-the-rpi5)**: Confirmed GPU-first rendering is safe on RPi5 (GLX ≈ 59.2 FPS, EGL ≈ 60 FPS). The reported community slowdown was not reproduced. → [R-05](3-Risk-Assessment.md#a-real-time-performance-rpi) closed.
- **[EXP-02](4-Planned-Experiments.md#exp-02-rpi5-real-time-sample-rate-ceiling)**: Confirmed 43200 BPH @ 192 kHz uses only ~41% of the 83.3 ms budget (worst-case 36.46 ms) with zero block drops and zero missed beats on RPi5. → [R-01](3-Risk-Assessment.md#a-real-time-performance-rpi), [R-03](3-Risk-Assessment.md#a-real-time-performance-rpi) resolved.
- **[EXP-03](4-Planned-Experiments.md#exp-03-gui-real-time-rendering-design-patterns)**: Confirmed that Pipe-and-Filter + Producer–Consumer + Latest-Wins + fixed buffer pool eliminates UI-thread blocking. All 13 tabs measured below 83.3 ms budget (slowest: Filter Scope at 36.46 ms). → [R-02](3-Risk-Assessment.md#a-real-time-performance-rpi) resolved.
- **[EXP-05](4-Planned-Experiments.md#exp-05-long-run-stability-24h)**: Confirmed RSS flat at ~406 MB over 24 hours with no CPU degradation. → [R-04](3-Risk-Assessment.md#a-real-time-performance-rpi) resolved.
- **[EXP-06](4-Planned-Experiments.md#exp-06-measurement-accuracy) Step 1**: First pass on clean Realistic-off simulation confirmed rate, amplitude, and beat error are within tolerance. **Step 2 (commercial Weishi comparison) is still outstanding** — the most significant remaining open question for [R-06](3-Risk-Assessment.md#b-signal-processing--measurement-trustworthiness) / [QAS-1](2-Architectural-Drivers.md#qas-1--accuracy--from-acoustic-event-detection-to-computed-watch-metrics).

---

### What experiments remain?

- **[EXP-06](4-Planned-Experiments.md#exp-06-measurement-accuracy) Step 2** (Weishi Timegrapher comparison) — planned 2026-06-22 to 2026-06-25. This is the verification that closes [R-06](3-Risk-Assessment.md#b-signal-processing--measurement-trustworthiness) and satisfies [QAS-1](2-Architectural-Drivers.md#qas-1--accuracy--from-acoustic-event-detection-to-computed-watch-metrics).
- **[EXP-04](4-Planned-Experiments.md#exp-04-on-device-tinyml-inference-feasibility)** (On-device TinyML inference feasibility) — planned Milestone 3 (2026-06-23 to 2026-06-25). Addresses [R-17](3-Risk-Assessment.md#f-project--process). A Go/Conditional/No-Go decision on TinyML adoption will be the output.

---

### Are the experiments focused on issues relevant to the overall goals?

Yes, with a clear mapping:

- **[EXP-01](4-Planned-Experiments.md#exp-01-avalonia-rendering-backend-on-the-rpi5), [EXP-02](4-Planned-Experiments.md#exp-02-rpi5-real-time-sample-rate-ceiling), [EXP-03](4-Planned-Experiments.md#exp-03-gui-real-time-rendering-design-patterns), [EXP-05](4-Planned-Experiments.md#exp-05-long-run-stability-24h)** → [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) (Performance/Latency)
- **[EXP-06](4-Planned-Experiments.md#exp-06-measurement-accuracy)** → [QAS-1](2-Architectural-Drivers.md#qas-1--accuracy--from-acoustic-event-detection-to-computed-watch-metrics) (Accuracy) — directly tests whether the core measurement purpose of the system (rate, amplitude, beat error) is trustworthy.
- **[EXP-04](4-Planned-Experiments.md#exp-04-on-device-tinyml-inference-feasibility)** → [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) + [QAS-3](2-Architectural-Drivers.md#qas-3--reliability--under-noisy-or-weak-signals) — tests whether the optional AI enhancement can be added without breaking real-time behavior or measurement reliability.

All experiments were targeted at the top-rated risks (High probability × High impact) and the top QAS priorities, confirming deliberate focus rather than opportunistic exploration.

---

## Architecture

---

### Module View

We created two module views:

<details>
<summary><strong><a href="5-Architecture-Views/5-3-MVVM-View.md">1. TIMEGRAPHER MVVM VIEW – Responsibility Separation</a></strong></summary>

Shows one-way «use» dependencies across three layers:
- **View Layer** (Main Window, Graph Tabs Window, Graph Rendering) → uses `MainWindowViewModel`
- **ViewModel Layer** (`MainWindowViewModel`, Run/session coordination, Input/display coordination) → uses Core modules
- **Model Layer** (`Core.Analysis·Detection`, `Core.Metrics·AudioIo·Imaging`, `Core.Shared`, `Platform.WindowsAudio·LinuxAudio`) → no upward dependencies

Key constraint: ViewModel holds no Avalonia/View types (enforced by `ViewModelPurityTests`). The Model (`Core`) has zero external dependencies.

</details>

<details>
<summary><strong><a href="5-Architecture-Views/5-2-Module-Uses-View.md">2-1. TIMEGRAPHER MODULE USES VIEW – Actual Dependencies & Internal Decomposition</a></strong></summary>

Shows how modules are structured to use each other. At the project level it maps the relationships among App, Core, platform adapters, and Verify: Core sits at the center, with App, Verify, `WindowsAudio`, and `LinuxAudio` all depending on it. `WindowsAudio` and `LinuxAudio` (platform adapters) form a boundary that keeps OS-specific audio dependencies out of Core.

</details>

<details>
<summary><strong><a href="5-Architecture-Views/5-2-Module-Uses-View.md#core-internal-module-uses">2-2. Core-Internal Module Uses</a></strong></summary>

A zoomed-in view of Core internals. `Analysis` orchestrates the analysis flow and uses the domain modules `Detection`, `Metrics`, `Imaging`, and `AudioIo`. `Shared` collects the common types and contracts used across Core-internal modules — `AnalysisFrame`, the shared audio buffer, analysis worker I/O contracts, and sync/signal state types — and depends on no other Core module.

</details>

---

### Runtime / C&C View

The runtime view is presented through two sequence diagrams and one state machine:

<details>
<summary><strong><a href="5-Architecture-Views/5-4-Run-Lifecycle-Sequence-View.md">Runtime Data Flow</a></strong></summary>

`Input Sources (Live/Playback/Sim)` → `Shared Audio Buffer` → `Analysis Worker (Detector → Metrics → SoundImage → Recorder)` → `AnalysisFrame` → `UI Thread`

This is a one-way Pipe-and-Filter flow. The analysis worker runs on a dedicated `ThreadPriority.Highest` thread; the UI thread only renders.

</details>

<details>
<summary><strong><a href="5-Architecture-Views/5-4-Run-Lifecycle-Sequence-View.md">Level 1 Sequence Diagram</a></strong></summary>

Covers the full run lifecycle — User → View → ViewModel → RunCommandService → Model (RunSessionController + workers).

</details>

<details>
<summary><strong><a href="5-Architecture-Views/5-4-Run-Lifecycle-Sequence-View.md">Level 2 Sequence Diagram</a></strong></summary>

Expands the analysis loop — `MasterAudioBuffer` → `AnalysisWorker` → `Core pipeline (Detection / Metrics / Projectors)` — showing the recurring cycle that must complete within one beat period.

</details>

<details>
<summary><strong><a href="5-Architecture-Views/5-5-Run-Lifecycle-State-Machine-View.md">State Machine</a></strong></summary>

Defines transitions among Stopped → Starting → Running ⇄ Paused → Stopping → StopFailed, managed by `RunCommandService` using the State Pattern.

</details>

Key C&C connectors: Producer–Consumer shared buffer (input↔analysis), Observer fan-out (`AnalysisFrameRouter`), Latest-Wins scheduler (analysis→UI).

---

### Deployment View

The [deployment view](5-Architecture-Views/5-6-Deployment-View.md) shows three stages:

<details>
<summary><strong>1. Develop & Share</strong></summary>

Developers work on Windows PCs in C#/.NET and push code to the Git server (GitHub).

</details>

<details>
<summary><strong>2. Verify & Build</strong></summary>

On each push, CI/CD (GitHub Actions, completed 2026-06-20) runs build/test verification; on `tag v*`, it builds separate deploy targets for Windows (x64) and Raspberry Pi (ARM64).

</details>

<details>
<summary><strong>3. Deploy & Install</strong></summary>

Built targets are distributed over the network and installed on each node.

</details>

<details>
<summary><strong>Runtime hardware allocation</strong></summary>

- **Raspberry Pi 5** (8 GB RAM, 128 GB microSD, 1280×800 touchscreen): the primary production target. Runs `LinuxAudio` adapter (ALSA/PipeWire), Avalonia UI (GPU-first via GLX/EGL), and the full analysis pipeline.
- **Windows 11 PC** (x64): the development and reference measurement platform. Runs `WindowsAudio` adapter (NAudio/WASAPI).

</details>

<details>
<summary><strong>External signal path</strong></summary>

Mechanical watch → microphone/pickup → USB audio → audio input of each node. This path is independent of the software deployment flow.

</details>

---

## Additional Review Items

---

### Have experiments led to architecture refinement?

Yes, directly and substantially:

- **[EXP-01](4-Planned-Experiments.md#exp-01-avalonia-rendering-backend-on-the-rpi5)** ([ADR-001](ADR/ADR-001.md)) → locked the Avalonia GPU-first rendering backend (no forced SW fallback needed). Architecture startup config was updated.
- **[EXP-02](4-Planned-Experiments.md#exp-02-rpi5-real-time-sample-rate-ceiling)** → fixed the supported sample rate range (48k base / 192k top) and determined that a single latency gate (≤ one beat period) is the right criterion, replacing the original p99 ≤ 500 ms criterion.
- **[EXP-03](4-Planned-Experiments.md#exp-03-gui-real-time-rendering-design-patterns)** ([ADR-002](ADR/ADR-002.md)) → introduced the Pipe-and-Filter + concurrency tactics that became the permanent architecture: dedicated analysis thread at `ThreadPriority.Highest`, `AnalysisFrameRouter` Observer fan-out, Latest-Wins scheduler, fixed buffer pool (`PublishBufferCount = 3`), and `DecimatingSeries` for long-term data bounding. These are now in production source (`AnalysisFrameRouter.cs`, `DecimatingSeries.cs`, `AnalysisWorker.cs`).
- **[EXP-05](4-Planned-Experiments.md#exp-05-long-run-stability-24h)** → confirmed no need for additional buffer caps or aggregation structures; keeps the current architecture.
- **MVC → MVVM refactoring** ([ADR-003](ADR/ADR-003.md)) was also an architecture refinement driven by [QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--adding-a-new-measurementfiltergraph) feedback and the modifiability demands from M1 review.

---

### Does the team understand the approaches and tradeoffs?

Yes. [EXP-03](4-Planned-Experiments.md#exp-03-gui-real-time-rendering-design-patterns) contains an explicit SAP-grounded trade-off analysis:

- **Pipe-and-Filter benefits:** maximized modifiability (new tabs/filters inject without changing existing code); improved portability (backend decoupled from Avalonia).
- **Pipe-and-Filter cost:** data-copy overhead when passing large snapshots (SoundPrint ~2.67 MB, Spectrogram ~1.92 MB). **Mitigation acknowledged:** fixed buffer pool eliminates GC spikes and LOH pollution.
- **Concurrency-isolation benefits:** UI never blocks even under heavy rendering; Latest-Wins prevents backlog accumulation.
- **Concurrency cost:** intermediate frames are dropped (frame drop / recency bias). **Mitigation acknowledged and justified:** for a real-time monitor, showing the latest state without lag is more important than preserving past frames; long-term history is supplemented by `DecimatingSeries`.

---

### Do architectural approaches align with system goals?

Yes, the alignment is explicit:

| Goal | Architecture response |
|------|----------------------|
| Measurement accuracy ([QAS-1](2-Architectural-Drivers.md#qas-1--accuracy--from-acoustic-event-detection-to-computed-watch-metrics)) | Single AnalysisFrame source → all displays share identical data ([QAS-4](2-Architectural-Drivers.md#qas-4--consistency--consistent-values-across-displays)); sub-sample interpolation in Detector.cs |
| Real-time beat processing ([QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display)) | Dedicated analysis thread + Latest-Wins + bounded buffers → verified to 43.8% of budget ([ADR-002](ADR/ADR-002.md)) |
| Reliability under noise ([QAS-3](2-Architectural-Drivers.md#qas-3--reliability--under-noisy-or-weak-signals)) | Signal-quality gating; "signal weak" UI state; rule-based fallback (`PllMatchGate`) |
| Modifiability ([QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--adding-a-new-measurementfiltergraph)) | One-way layer rule enforced by `ViewModelPurityTests` ([ADR-003](ADR/ADR-003.md)); IAnalysisFrameConsumer extension point; ≤ 1 existing module changed per new feature; App/test/verify module separation enables 6-member parallel development with minimal merge conflicts; TDD-based test suite provides an automated safety net for AI-assisted code review ([ADR-004](ADR/ADR-004.md)) |
| Usability on small touchscreen ([QAS-6](2-Architectural-Drivers.md#qas-6--usability--reading-and-operating-on-the-touchscreen)) | Key-readings-first layout; physical-size-based legibility rules (≥ 2.9 mm letters, ≥ 9 mm touch targets) |
| Cross-platform ([C-3](2-Architectural-Drivers.md#design-constraints)) | Adapter pattern isolating `WindowsAudio` (WASAPI) and `LinuxAudio` (ALSA/PipeWire) ([ADR-001](ADR/ADR-001.md)) |

---

### Are there significant concerns not yet addressed?

Two significant concerns remain:

1. **[R-06](3-Risk-Assessment.md#b-signal-processing--measurement-trustworthiness) / [EXP-06](4-Planned-Experiments.md#exp-06-measurement-accuracy) Step 2 (A/C detection vs. Weishi Timegrapher)** — The clean-signal first pass passed, but the commercial comparison test — which validates the algorithm against real-world watch noise — has not been done. This is the most critical remaining validation for the system's core purpose.

2. **[R-07](3-Risk-Assessment.md#b-signal-processing--measurement-trustworthiness) (Weak/noisy signal handling)** — The "signal weak" UI and underlying logic are described as "in progress." Until tested at defined SNR levels and confirmed to suppress misleading outputs at SNR < 30 dB, [QAS-3](2-Architectural-Drivers.md#qas-3--reliability--under-noisy-or-weak-signals) is not formally satisfied.

Minor concerns:
- [EXP-04](4-Planned-Experiments.md#exp-04-on-device-tinyml-inference-feasibility) (TinyML) result is open; if adopted, [R-17](3-Risk-Assessment.md#f-project--process) requires re-running [EXP-02](4-Planned-Experiments.md#exp-02-rpi5-real-time-sample-rate-ceiling)/[EXP-03](4-Planned-Experiments.md#exp-03-gui-real-time-rendering-design-patterns) under TinyML load to confirm no budget regression.

---

### Has the architecture been evaluated?

Yes, through multiple complementary mechanisms:

1. **Quantitative experiment-based evaluation** — [EXP-01](4-Planned-Experiments.md#exp-01-avalonia-rendering-backend-on-the-rpi5) through [EXP-05](4-Planned-Experiments.md#exp-05-long-run-stability-24h) produced pass/fail measurements against defined QAS thresholds (latency budget, frame rate, RSS trend).

2. **Automated structural tests** — `ViewModelPurityTests` enforces the one-way dependency rule at build time. `SyntheticDetectorTests` and `AdverseScenarios` unit tests verify algorithm behavior against known synthetic inputs ([EXP-06](4-Planned-Experiments.md#exp-06-measurement-accuracy) Step 1).

3. **ADR-based documented rationale** — Four ADRs record the reasoning behind each architectural decision ([ADR-001](ADR/ADR-001.md), [ADR-002](ADR/ADR-002.md), [ADR-003](ADR/ADR-003.md), [ADR-004](ADR/ADR-004.md)), including rejected alternatives and rationale.

4. **SAP trade-off analysis** — [EXP-03](4-Planned-Experiments.md#exp-03-gui-real-time-rendering-design-patterns)'s Results & Analysis section explicitly evaluates each applied pattern/tactic against SAP criteria, naming what is gained and what is given up.

