# TimeGrapher Worker Pipeline View - Runtime Analysis Flow

This runtime view shows the worker-level Pipe-and-Filter structure used while a measurement run is active. It is the architecture view for the diagram referenced by [ADR-002](../ADR/ADR-002.md).

**Notation:** UML-style component and connector diagram.

## Primary Presentation

![Worker-level partial Pipe-and-Filter](../../assets/worker-level-partial-pipe-and-filter.svg)

Editable source: [worker-level-partial-pipe-and-filter.drawio](../../assets/worker-level-partial-pipe-and-filter.drawio)

## Element Catalog

| Element | Type | Responsibility |
|---|---|---|
| Input worker | Worker/filter | Captures live audio, playback audio, or simulated audio and writes blocks to the shared buffer. |
| MasterAudioBuffer | Bounded pipe | Decouples input production from analysis consumption. |
| Analysis worker | Worker/filter | Reads audio blocks, runs detection/metrics/imaging, and emits `AnalysisFrame` results. |
| Optional TinyML classifier | Leaf component | Produces `SignalQuality` labels through `ISignalQualityClassifier`; ONNX loading stays outside `TimeGrapher.Core` and falls back to the heuristic classifier. |
| Latest-wins frame scheduler | Pipe | Keeps the UI responsive by delivering the newest frame instead of queueing stale frames. |
| UI/render path | Final consumer | Renders the active tab and status/warning overlays from the newest `AnalysisFrame`. |
| Recording queue and writer | Pipe + consumer | Saves measurement data without blocking analysis. |

## Behavior

1. The selected input source writes audio blocks into `MasterAudioBuffer`.
2. `AnalysisWorker` consumes blocks on a dedicated analysis thread and keeps the internal DSP/metrics chain synchronous to avoid per-stage queue overhead.
3. The optional TinyML classifier adds non-destructive signal-quality labels. Weak/noisy/unstable signal is reported through `AnalysisFrame.SignalQuality` and UI warnings; the classifier does not discard or rewrite rate, amplitude, or beat-error measurements.
4. The latest-wins scheduler sends only the newest frame to the UI/render path. Rendering is active-tab focused, so tab selection changes which graph is drawn without forcing every graph tab to render every frame.
5. Recording uses a separate bounded queue so file I/O does not block input capture or analysis.

This view supports **QAS-2 Performance** by separating input, analysis, rendering, and recording; **QAS-3 Reliability** by reporting weak/noisy/unstable signal state; and **QAS-4 Consistency** by producing each `AnalysisFrame` from one analysis cycle.

## Related ADRs

- [ADR-002 — Apply Worker-Level Partial Pipe-and-Filter](../ADR/ADR-002.md): records why the worker-level pipeline is used and why the analysis hot path remains synchronous.

## Related views

- [Run Lifecycle Sequence View](5-4-Run-Lifecycle-Sequence-View.md) — call order during the measurement loop.
- [Module Uses View](5-2-Module-Uses-View.md) — static module dependencies behind these workers.
- [Deployment View](5-6-Deployment-View.md) — hardware/runtime node where the pipeline executes.
