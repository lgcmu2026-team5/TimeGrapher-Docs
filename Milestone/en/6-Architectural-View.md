# Architectural View

> Pre-implementation: the structural views we plan to use, and why.

## 1. LAYERED VIEW – Permission-Based Architecture

**Purpose:** Shows which layers are permitted to use which lower layers. Defines allowed dependencies, not implementation details.

**Key Concept:**
- **Relaxed Layering**: Upper layers can skip intermediate layers and use any lower layer they need.
- **Upward Dependency Forbidden**: Only downward flow (App → Core; never Core → App).
- **Sidecar Layer**: Common external utilities and frameworks are placed in a sidecar layer accessible by permitted layers.

**Layers:**
1. **Layer 1 – Entry Points & UI**: App (Avalonia UI), Verify (console), Test Suites
2. **Layer 2 – Platform Adapters**: WindowsAudio (NAudio), LinuxAudio (PipeWire/ALSA tools)
3. **Layer 3 – Portable Core**: `TimeGrapher.Core` (analysis, detection, metrics – no external dependencies)
- **External dependancy – External Tech**: Avalonia, ScottPlot, NAudio, xUnit

**Permission Rules:**
```text
App → Platform Adapters
App → Core
Platform Adapters → Core
App & Platform Adapters → External Tech
Core → Nothing (zero dependencies)
```

![alt text](../assets/LAYER.png)



---
## 2. TIMEGRAPHER MODULE USES VIEW

**Purpose:** This view shows TimeGrapher module uses relations at two levels. Section 2-1 shows project-level module uses; Section 2-2 shows the internal decomposition of `TimeGrapher.Core`. App-internal UI structure is covered by the TIMEGRAPHER MVVM View; this view focuses on project-level module uses and Core-internal module uses.

**2-1 Project-Level Module Uses:**

Shows module uses relations among App, Core, platform adapters, and Verify. Here, platform adapters refer to `WindowsAudio` and `LinuxAudio` in the diagram; they isolate OS-specific audio dependencies from `TimeGrapher.Core`.

![Module Uses View - Project-level modules](../assets/module-uses-project.en.svg)

- `TimeGrapher.App` uses `TimeGrapher.Core`.
- `TimeGrapher.App` conditionally uses `WindowsAudio` or `LinuxAudio`.
- `WindowsAudio` and `LinuxAudio` use `TimeGrapher.Core`.
- `TimeGrapher.Verify` uses `TimeGrapher.Core`.
- `TimeGrapher.Core` does not use App, Verify, or platform adapters.

**2-2 TimeGrapher.Core Uses:**

Decomposes `TimeGrapher.Core` into its major domain modules and shows which Core-internal modules each one uses.

![Module Uses View - Core internal modules](../assets/module-uses-core.en.svg)

| Module | Responsibility | Uses |
|---|---|---|
| `Analysis` | coordinates the analysis worker and result-frame creation | `Detection`, `Detection.Scoring`, `Metrics`, `Imaging`, `AudioIo`, `Shared` |
| `Detection` | detects watch-signal events and sync state | `Shared` |
| `Detection.Scoring` | provides candidate-event acceptance criteria | `Detection` |
| `Metrics` | computes rate, amplitude, and beat error | `Shared` |
| `Imaging` | builds sound-image and time-frequency spectrogram data for visualizing watch audio | `Shared` |
| `AudioIo` | provides writer contracts and implementations for saving recordings as WAV files | `Shared` |
| `Sim` | provides a synthetic input source | `Shared` |
| `Shared` | provides common data types and contracts shared by Core-internal modules. | none |


## 3. TIMEGRAPHER MVVM VIEW – Responsibility Separation

**Purpose:** Splits the App's UI into three layers — **View Layer**, **ViewModel Layer**, **Model Layer**. Dependencies flow one way, **View Layer → ViewModel Layer → Model Layer**, so a lower layer never knows the layer above it.
- Loose Coupling & Parallel Development
- Modifiability
- Testability (the ViewModel runs without the UI)

**Notation:** Each layer is colored (View Layer / ViewModel Layer / Model Layer); a gray box is a **module** (a group of related classes). Every dependency is a dotted **«use»** arrow drawn from the *using* module to the *used* one.

**Modules (as in the figure):**

| Layer | Module | What it does |
|---|---|---|
| **View Layer** | Main Window | The main window — overall layout, controls, and window lifecycle. |
| | Graph Tabs Window | Hosts the measurement tabs and routes each analysis frame to the active tab. |
| | Graph Rendering | Draws the graphs and numeric readouts from the frame data. |
| **ViewModel Layer** | MainWindowViewModel | Holds the UI state and binding properties the View binds to, and exposes the commands. |
| | Run · session coordination | Drives start / stop / pause and the analysis-session lifecycle (`RunCommandService`, `RunSessionController`). |
| | Input · display coordination | Enumerates and selects audio input devices and prepares display state (`AudioDeviceController`). |
| **Model Layer** | Core.Analysis · Detection | The analysis engine — detects tick/tock beats and computes BPH and sync. |
| | Core.Metrics · AudioIo · Imaging | Computes rate / amplitude / beat error, reads & writes WAV, and builds sound images. |
| | Core.Shared | Common contracts and data types (frames, buffers) shared by every module. |
| | Platform.WindowsAudio · LinuxAudio | Captures live audio from the OS (WASAPI on Windows, ALSA / PipeWire on Linux). |

**Dependency Flow («use» arrows):**
- The three View Layer modules **use** `MainWindowViewModel`.
- `MainWindowViewModel` **uses** the two coordination modules.
- The coordination modules **use** the Core modules; `Core.Analysis · Detection` and `Platform.*` ultimately **use** `Core.Shared`.

**Key Constraint:**
- **One-way dependency:** View Layer → ViewModel Layer → Model Layer. The ViewModel holds no Avalonia/View type (locked by `ViewModelPurityTests`), and the Model (`Core`) has zero dependencies, so it builds and tests without the UI.
- **Binding inverts control, not dependency:** at runtime UI updates flow Model Layer → ViewModel Layer → View Layer through events and binding, but that is *data flow*, not a compile-time dependency — so the «use» graph stays acyclic and downward.

![MVVM responsibility flow](../assets/MVVM.png)

## 4. TIMEGRAPHER SYSTEM DEPLOYMENT VIEW

**Purpose:** Shows both the deployment path — artifacts flowing from the development environment through the Git server to the target nodes (Windows PC, Raspberry Pi) — and the external signal path, where the watch's acoustic beat enters each node through a microphone at runtime.

**Deployment Flow (3 stages):**

1. **Develop & Share** — Multiple developers work on their own PCs in C#/.NET and collect the code on the Git server via `git push`.
2. **Verify & Build** — On each push the Git server runs build/test verification through CI/CD, and on `tag v*` it builds per-target (Windows / Raspberry Pi) deploy Targets.
3. **Deploy & Install** — The built Targets are distributed and installed onto each connected node over the Git server network (LAN).

At runtime there is a separate external input path: the **acoustic beat signal** of a mechanical watch is converted to an electrical signal through a microphone/pickup and enters each node's audio input via **USB audio**.

![Deployment view diagram](../assets/deployment-view-detailed-en.svg)
