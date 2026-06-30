# TimeGrapher Module Uses View - Actual Dependencies and Internal Decomposition

This view shows the syntactic «use» dependencies among project-level modules (App, Core, platform adapters, Verify) and then decomposes `TimeGrapher.Core` into its Core-internal submodules. It is the concrete realization of the permission rules defined in the [Layered View](5-1-Layered-View.md). Here, *platform adapters* refer to `WindowsAudio` and `LinuxAudio`; they isolate OS-specific audio dependencies from `TimeGrapher.Core`.

## Primary Presentation

![Module Uses View - Project-level modules](../../assets/module-uses-project.en.svg)

## Element Catalog

**Project-level module uses**

- `TimeGrapher.App` uses `TimeGrapher.Core`.
- `TimeGrapher.App` conditionally uses `WindowsAudio` or `LinuxAudio`.
- `WindowsAudio` and `LinuxAudio` use `TimeGrapher.Core`.
- `TimeGrapher.Verify` uses `TimeGrapher.Core`.
- `TimeGrapher.Core` does not use App, Verify, or platform adapters.

### Core-Internal Module Uses

Decomposes `TimeGrapher.Core` into its major domain modules and shows which Core-internal modules each one uses.

![Module Uses View - Core internal modules](../../assets/module-uses-core.en.svg)

| Module | Responsibility | Uses |
|---|---|---|
| `Analysis` | coordinates the analysis worker and result-frame creation | `Detection`, `Detection.Scoring`, `Metrics`, `Imaging`, `AudioIo`, `Shared` |
| `Detection` | detects watch-signal events and sync state | `Shared` |
| `Detection.Scoring` | provides candidate-event acceptance criteria | `Detection` |
| `Metrics` | computes rate, amplitude, and beat error | `Shared` |
| `Imaging` | builds sound-image and time-frequency spectrogram data for visualizing watch audio | `Shared` |
| `AudioIo` | provides writer contracts and implementations for saving recordings as WAV files | `Shared` |
| `Sim` | provides a synthetic input source | `Shared` |
| `Shared` | provides common data types and contracts shared by Core-internal modules | none |

**Variability — OS and deployment target**

The `WindowsAudio` or `LinuxAudio` adapter is used conditionally depending on the OS environment, and deploy targets are built separately for Windows and Raspberry Pi. This is the only point where the project-level «use» graph branches by platform.

## Behavior

N/A. This view is structural. The runtime data flow through these modules is documented in the [Run Lifecycle Sequence View](5-4-Run-Lifecycle-Sequence-View.md).

## Related ADRs

- [ADR-004 — Separate App, Test, and Verify Module Structure](../ADR/ADR-004.md): rationale for the App / Test / Verify split and Core's zero-dependency boundary.
- [ADR-002 — Apply Worker-Level Partial Pipe-and-Filter](../ADR/ADR-002.md): rationale for the Core-internal decomposition into pipeline stages.

## Related views

- [Layered View](5-1-Layered-View.md) — the dependency rules these module uses must obey.
- [MVVM View](5-3-MVVM-View.md) — how the App-side modules are organized into View / ViewModel / Model roles.
- [Worker Pipeline View](5-7-Worker-Pipeline-View.md) — runtime worker and queue boundaries that use these modules.
