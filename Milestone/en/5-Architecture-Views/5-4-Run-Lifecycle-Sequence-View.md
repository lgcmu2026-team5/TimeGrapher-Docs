# TimeGrapher Run Lifecycle Sequence View - Measurement Analysis Loop

This runtime view covers the object call flow from User → View → ViewModel → `RunCommandService` → Model (`RunSessionController` and Workers). It complements the static structure in the [MVVM View](5-3-MVVM-View.md) by showing how those elements interact over time. The measurement analysis loop is expanded in a referenced sequence diagram because it contains the recurring cycle that requires the most precision.

**Notation:** UML sequence diagram.

## Primary Presentation

**Run lifecycle overview** keeps the whole lifecycle in one sequence diagram. The detailed analysis loop is folded behind a `ref` and expanded in the referenced diagram.

![Run lifecycle overview](../../assets/Sequence-run-lifecycle-level1.svg)

## Element Catalog

Roles and code references for each lifeline. `MasterAudioBuffer` and `Core pipeline` appear only in the referenced measurement-analysis diagram.

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

**Variability — input source:** Runtime behavior branches on the `CurrentMode` value among Live (real capture), Playback (file playback), and Simulation (synthetic signal) workers.

## Behavior

**Measurement analysis loop** expands the measurement `ref` from the overview diagram. The loop condition and timing constraint are shown inside the diagram.

![Measurement analysis loop](../../assets/Sequence-run-lifecycle-level2.svg)

Label rule: User-to-system arrows describe user intent or action; object-to-object arrows use operation signatures.

## Related ADRs

- [ADR-002 — Apply Worker-Level Partial Pipe-and-Filter](../ADR/ADR-002.md): rationale for the one-way analysis pipeline and the input↔analysis shared buffer shown in the loop.
- [ADR-003 — Adopt the MVVM Pattern for the App's UI](../ADR/ADR-003.md): rationale for the `RunCommandService` State Pattern that drives this sequence.

## Related views

- [Run Lifecycle State Machine View](5-5-Run-Lifecycle-State-Machine-View.md) — the control states these sequences move between.
- [MVVM View](5-3-MVVM-View.md) — the static layer structure of the lifelines above.
- [Worker Pipeline View](5-7-Worker-Pipeline-View.md) — the worker/queue structure behind the measurement-analysis loop.
