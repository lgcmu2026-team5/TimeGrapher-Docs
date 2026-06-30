# TIMEGRAPHER RUN LIFECYCLE STATE MACHINE VIEW – Control State Transitions

This runtime view defines the transition rules among the `Stopped`, `Starting`, `Running`, `Paused`, `Stopping`, and `StopFailed` states. It shows *which state the app moves to*; the detailed worker and analysis call order lives in the [Run Lifecycle Sequence View](5-4-Run-Lifecycle-Sequence-View.md).

![Run state machine](../../assets/Statemachine-run-lifecycle.svg)

**Scope.** The base state value for this state machine is `RunUiState`. `RunCommandService` selects the state object matching the current `RunUiState` (`StoppedState`, `RunningState`, and so on), and each state object allows or ignores `StartAsync`, `TogglePause`, `StopRunWithoutReset`, `StopRunAndRefreshDevices`, and `Reset`. Actual worker creation, worker stop, recording close, and device restoration are delegated to the View implementation through the `IRunCommandOperations` port.

## Element Catalog

| State | Code-level meaning |
| --- | --- |
| `Stopped` | Default non-measuring state. Run settings can be changed, and `StartAsync` is allowed. |
| `Starting` | Start is in progress. Duplicate start, stop, and reset commands are ignored. |
| `Running` | Input and analysis workers are active. Pause or stop intent is allowed. |
| `Paused` | Workers remain alive, but input is held by the pause gate. Resume or Reset is allowed. |
| `Stopping` | Stop intent is being processed. If stop is not finished yet, the Stop/Reset retry surface remains available. |
| `StopFailed` | Full stop failed because worker stop timed out or recording close failed. Stop/Reset retry repeats the same pending intent. |

## Behavior

The state machine diagram above is itself the behavior model for this view. The common state-machine notation follows the legend below.

![UML state machine notation legend](../../assets/Statemachine-run-lifecycle-notation.svg)

## Related ADRs

- [ADR-003 — Adopt the MVVM Pattern for the App's UI](../ADR/ADR-003.md): rationale for the State Pattern implemented by `RunCommandService` that this state machine describes.

## Related views

- [Run Lifecycle Sequence View](5-4-Run-Lifecycle-Sequence-View.md) — the call sequences that occur within these states.
- [MVVM View](5-3-MVVM-View.md) — where `RunCommandService` sits in the layer structure.
