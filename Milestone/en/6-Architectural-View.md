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

## 5. TIMEGRAPHER RUN LIFECYCLE C&C VIEW - Sequence Diagram

Only the measurement flow is expanded into a Level 2 child view because it contains the recurring loop that needs the most detail.

### Document Roadmap

| Page | Contents |
| --- | --- |
| Level 1 | Run lifecycle overview |
| Level 2 | Measurement analysis loop, expanded from the Level 1 `ref` |

### 5-1. Primary Presentation · Level 1 · Run Lifecycle Overview

Level 1 keeps the whole lifecycle on one page. The detailed analysis loop is folded behind a `ref` and expanded in Level 2.

![Level 1 run lifecycle overview](../assets/Sequence-run-lifecycle-level1.svg)

### 5-2. Behavior · Level 2 · Measurement Analysis Loop

Level 2 expands the measurement `ref` from Level 1. The loop condition and timing constraint are shown inside the diagram.

![Level 2 measurement analysis loop](../assets/Sequence-run-lifecycle-level2.svg)

### 5-3. Notation

The common notation follows the legend below.

![UML sequence diagram notation legend](../assets/Sequence-run-lifecycle-notation.svg)

Label rule: User-to-system arrows describe user intent or action; object-to-object arrows use operation signatures.

### 5-4. Element Catalog

Roles and code references for each lifeline. `MasterAudioBuffer` and `Core pipeline` appear only in Level 2.

| Lifeline | MVVM layer | Responsibility |
| --- | --- | --- |
| User | (actor) | User |
| View (`MainWindow`) | View | Receives UI events, renders, marshals to the UI thread, drives input/analysis worker lifecycle through `RunSessionController`, and implements the service's `IRunCommandOperations` callback port |
| ViewModel (`MainWindowViewModel`) | ViewModel | Exposes `PlayPauseCommand`/`ResetCommand` and observable `RunState`/`StatusText`; does not call the domain directly |
| RunCommandService | App service (State Pattern) | Orchestrates start/pause/stop, updates ViewModel state, and calls the View through `IRunCommandOperations` |
| RunSessionController | Model boundary | Owns run session tokens, input worker attach/stop, and analysis worker lifecycle |
| Input worker | Model | Live=`AudioCaptureWorker`, Playback=`PlaybackWorker`, Simulation=`SimWorker` |
| MasterAudioBuffer | Model | Shared input/analysis audio ring buffer |
| AnalysisWorker | Model | Analysis thread |
| Core pipeline | Model | Detection / Metrics / Projectors |

### 5-5. Variability

The only variation point is the input source: Live / Playback / Simulation. Runtime behavior branches on `CurrentMode`.

### 5-6. Design Rationale

- **Decision**: Split the UI state, commands, and run orchestration that had been mixed into the old MVC-style `MainWindow` into three MVVM roles: View for rendering/platform/session wiring, ViewModel for bindable state and commands, and RunCommandService for the State Pattern-based run state machine.
- **Rationale**: The separation improves modifiability and testability. The ViewModel can be unit-tested without a window because it does not call the domain directly. Service-to-View coupling is inverted through `IRunCommandRunner` for command bodies and `IRunCommandOperations` for service-to-View callbacks.
- **Rejected alternative**: The MVC remnant where the View injected command bodies into the ViewModel through `Func`/`Action` delegates. This was replaced by injecting `IRunCommandRunner`, so command bodies belong to the ViewModel-side command path.
- **Intentional exception**: Playback natural completion and application shutdown are handled directly by the View because they originate from worker completion or window closing callbacks, bypassing `RunCommandService`.

## 6. TIMEGRAPHER RUN LIFECYCLE STATE MACHINE VIEW

This view presents the `RunCommandService` control states (State Pattern) and `MainWindowViewModel.RunState` (`RunUiState`) as a state machine. Object call order is covered by the C&C view; control-state transitions are covered here.

![Run state machine](../assets/Statemachine-run-lifecycle.svg)

### 6-1. Scope

The base state value for this state machine is `RunUiState`. `RunCommandService` selects the state object matching the current `RunUiState` (`StoppedState`, `RunningState`, and so on), and each state object allows or ignores `StartAsync`, `TogglePause`, `StopRunWithoutReset`, `StopRunAndRefreshDevices`, and `Reset`.

Actual worker creation, worker stop, recording close, and device restoration are delegated to the View implementation through the `IRunCommandOperations` port. This view therefore shows which state the app moves to, while detailed input worker and analysis worker calls remain in the sequence view.

### 6-2. States

| State | Code-level meaning |
| --- | --- |
| `Stopped` | Default non-measuring state. Run settings can be changed, and `StartAsync` is allowed. |
| `Starting` | Start is in progress. Duplicate start, stop, and reset commands are ignored. |
| `Running` | Input and analysis workers are active. Pause or stop intent is allowed. |
| `Paused` | Workers remain alive, but input is held by the pause gate. Resume or Reset is allowed. |
| `Stopping` | Stop intent is being processed. If stop is not finished yet, the Stop/Reset retry surface remains available. |
| `StopFailed` | Full stop failed because worker stop timed out or recording close failed. Stop/Reset retry repeats the same pending intent. |

### 6-3. Notation

The common state-machine notation follows the legend below.

![UML state machine notation legend](../assets/Statemachine-run-lifecycle-notation.svg)
