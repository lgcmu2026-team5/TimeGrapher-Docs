# Planned Experiments

**Contents** — [Risk-to-Experiment Map](#risk-to-experiment-map) · [EXP-01](#exp-01-avalonia-rendering-backend-on-the-rpi5) · [EXP-02](#exp-02-rpi5-real-time-sample-rate-ceiling) · [EXP-03](#exp-03-gui-real-time-rendering-design-patterns) · [EXP-04](#exp-04-on-device-tinyml-inference-feasibility) · [EXP-05](#exp-05-long-run-stability-24h) · [EXP-06](#exp-06-measurement-accuracy) · [Integrated Schedule](#integrated-schedule) · [Common Approval Criteria](#common-approval-criteria)

## Terminology

The terms used in this document are defined in the consolidated [Glossary](7-Glossary.md).

## Risk-to-Experiment Map

> Priority: **High** / **Mid** (no Low-priority experiments in this milestone).

| Experiment | Risks Addressed | Related QAS | Priority | Core Question |
|---|---|---|---|---|
| [EXP-01](#exp-01-avalonia-rendering-backend-on-the-rpi5) | [R-05](3-Risk-Assessment.md#a-real-time-performance-rpi) | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) | **High** | If we choose C#, how do we remove the Avalonia-on-RPi5 rendering risk? |
| [EXP-02](#exp-02-rpi5-real-time-sample-rate-ceiling) | [R-01](3-Risk-Assessment.md#a-real-time-performance-rpi), [R-03](3-Risk-Assessment.md#a-real-time-performance-rpi) | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) | **High** | What is the highest sample rate the RPi5 can process in real time? |
| [EXP-03](#exp-03-gui-real-time-rendering-design-patterns) | [R-02](3-Risk-Assessment.md#a-real-time-performance-rpi) | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display), [QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--adding-a-new-measurementfiltergraph) | **High** | Which design patterns should we apply first to improve GUI real-time performance? |
| [EXP-04](#exp-04-on-device-tinyml-inference-feasibility) | [R-17](3-Risk-Assessment.md#f-project--process) | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display), [QAS-3](2-Architectural-Drivers.md#qas-3) | Mid | Can we add TinyML inference and still hold real-time behavior and trustworthiness? |
| [EXP-05](#exp-05-long-run-stability-24h) | [R-04](3-Risk-Assessment.md#a-real-time-performance-rpi) | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) | Mid | Do memory/latency degrade over long runs? |
| [EXP-06](#exp-06-measurement-accuracy) | [R-06](3-Risk-Assessment.md#b-signal-processing--measurement-trustworthiness) | [QAS-1](2-Architectural-Drivers.md#qas-1--accuracy--from-acoustic-event-detection-to-computed-watch-metrics) | **High** | Does measurement accuracy — confirmed first on the Realistic-off simulation — agree within tolerance with the commercial Weishi Timegrapher? |

## EXP-01: Avalonia rendering backend on the RPi5

**Risks:** [R-05](3-Risk-Assessment.md#a-real-time-performance-rpi) · **QAS:** [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) · **Priority:** High

### Results & Decisions

- **Decision**: keep the default (GPU-first). GPU acceleration is faster than Software.
- **Pi5 measurement**: GLX 59.2 FPS (mean 16.9 ms) · EGL 60.0 FPS (16.7 ms) · Software 43.6 FPS (22.9 ms). Both GPU backends hit the display refresh ceiling (~60 Hz, 16.7 ms vsync), and Software was slower.
- **HW acceleration confirmed**: the GL renderer logged as `V3D 7.1.10.2` (the RPi5 GPU) — not an llvmpipe fallback.

**FPS by backend (RPi5, higher is better)**

```mermaid
%%{init: {"themeVariables": {"xyChart": {"plotColorPalette": "#A50034, #999999"}}}}%%
xychart-beta horizontal
    title "RPi5 FPS by rendering backend (gray line = 60 FPS display ceiling)"
    x-axis ["GLX(GPU)", "EGL(GPU)", "Software(CPU)"]
    y-axis "FPS" 0 --> 70
    bar [59.2, 60.0, 43.6]
    line [60, 60, 60]
```

### Objective

When adopting the C# path, use a technical experiment to resolve the risk that — as in numerous Avalonia GitHub issues — a bug makes GPU-accelerated rendering on the RPi5 *slower* than even SW rendering, stuttering the real-time graphs. Core question:

- On the RPi5, is GPU-accelerated rendering (GLX/EGL) actually slower than software rendering? (Community reports: ~80 ms accelerated vs 6–12 ms software — if true, the real-time graphs stutter.)

The answer drives the design decision **"which Avalonia rendering backend to lock for RPi5 deployment."** Impact scope: app startup config and the RPi deployment guide.

**Why this experiment:** multiple community reports flag slow GPU-accelerated rendering on RPi/embedded Linux (Avalonia GitHub `#18807, #18942, #19288, #18127`), but the causes differ across reports (app-side bugs, resolution, driver path) and none measure our workload's conditions. The backend can only be fixed by measuring on the real device.

### Status

Complete

### Deliverables

- A reusable benchmark test
- Per-backend (GLX / EGL / Software) frame-time comparison table (FPS, mean, p95, p99)
- Determination of HW acceleration vs software fallback, based on the actually-active renderer
- Rendering-backend recommendation (keep the default, or force Software)

### Resources Needed

- RPi5 (monitor connected, SSH access) — shared team device
- Windows dev PC (cross-build for the RPi)
- Effort: ~1.0 person-day

### Experiment Description

1. **Build the benchmark test** — add a diagnostic measurement mode to the app: lock each rendering backend (GLX/EGL/Software) with no fallback, drive the real graph pipeline under a heavy per-frame redraw load (using a synthetic Sim signal), and collect frame intervals over a fixed window — while recording which GL renderer is actually active to tell HW acceleration from software fallback.
2. **Verify the benchmark on Windows** with a short measurement (end-to-end sanity check).
3. **Deploy to the RPi5 and measure** — run each of the three backends with a warmup followed by ~30 s of measurement.
4. **Compare results → derive the backend recommendation** — record it here and in [Risk Assessment (R-05)](3-Risk-Assessment.md#a-real-time-performance-rpi).

**Completion criteria (met):** ① all three backends measured, ② the active-renderer (HW-acceleration) status confirmed, and ③ a backend recommendation derived — all three were met, completing the experiment.

### Duration

- 6/9–6/10

### Links & References

- [Rendering-backend A/B measurement results — result_renderer.md](../../TestResult/result_renderer.md)
- Original report: [Avalonia Discussion #18807 — Poor Linux performance when using hardware acceleration](https://github.com/AvaloniaUI/Avalonia/discussions/18807)
- Related case: [Discussion #18942 — RPi high-resolution full-repaint degradation](https://github.com/AvaloniaUI/Avalonia/discussions/18942)
- [Avalonia docs — Running on RPi5 via DRM](https://docs.avaloniaui.net/docs/guides/platforms/rpi/running-on-raspbian-lite-via-drm)

## EXP-02: RPi5 real-time sample-rate ceiling

**Risks:** [R-01](3-Risk-Assessment.md#a-real-time-performance-rpi), [R-03](3-Risk-Assessment.md#a-real-time-performance-rpi) · **QAS:** [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) · **Priority:** High

### Results & Decisions

- **Decision**: Base at 48 kHz, top support at 192 kHz.
- **Results**: Both conditions pass. Worst-case E2E latency at 43200@192k is ~41 % of budget (34.6 / 83.3 ms) on the RPi5. The 43200 Playback used a verified synthetic WAV (`WatchSynthStream`) since no real recording exists.

**Worst-case E2E latency as % of beat-period budget (RPi5, lower is better, 100% = budget)**

```mermaid
%%{init: {"themeVariables": {"xyChart": {"plotColorPalette": "#A50034, #999999"}}}}%%
xychart-beta horizontal
    title "RPi5 worst-case latency / budget per run (gray line = 100% budget)"
    x-axis ["21600@48k Sim", "21600@48k Play", "21600@48k Live", "43200@192k Sim", "43200@192k Play"]
    y-axis "Budget usage (%)" 0 --> 110
    bar [25.2, 26.4, 24.2, 40.8, 41.5]
    line [100, 100, 100, 100, 100]
```

### Objective

Confirm whether the input → analysis → display pipeline meets real-time requirements on the RPi5 Live environment.

- Q1. Which sample rate runs stably without block drop?
- Q2. Does worst-case total end-to-end latency stay within one beat period? (43200 BPH: 83.3 ms · 21600 BPH: 166.7 ms)

### Status

Complete

### Deliverables

- Per-condition / per-input-mode / per-platform latency comparison table (avg/p95/p99/worst)
- Block-drop / missed-beat statistics table
- Input-mode (Sim/Playback/Live) and platform (Pi/Windows) comparison table
- Sample-rate target proposal (Go/No-Go)

### Resources Needed

- 1× RPi5 (primary), Windows dev PC (reference)
- Live input (real movement + USB microphone), Playback WAV (21600 BPH from the Live recording, 43200 BPH synthetic)
- Latency/drop logging code
- Effort: 1.5 person-days

### Experiment Description

1. Measure both conditions (21600@48k, 43200@192k) across Simulation/Playback/Live — 43200 excludes Live, 5 runs per platform, on RPi5 (primary) and Windows (reference).
2. Compare total latency (avg/p95/p99/worst), block drop, and missed beat per condition / input mode / platform. Truncate to the common-minimum frame count across CSVs.
3. Judge worst-case E2E ≤ one beat period and drop=0 / miss=0 on the RPi5 (Windows is reference).

### Duration

- 6/9–6/10: Prepare instrumentation code
- 6/11: Run measurements
- 6/12–6/13: Analyze results and derive the recommendation

### Links & References

- [QAS-2 latency measurement results — result_latency.md](../../TestResult/result_latency.md)

## EXP-03: GUI real-time rendering design patterns

**Risks:** [R-02](3-Risk-Assessment.md#a-real-time-performance-rpi) · **QAS:** [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display), [QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--adding-a-new-measurementfiltergraph) · **Priority:** High

### Results & Decisions

- **Decision**: adopt a Pipe-and-Filter flow + concurrency tactics (Producer–Consumer · Observer · Latest-Wins · fixed buffer pool).
- **Results**: [see Results & Analysis below](#results--analysis)

### Objective

Resolve the bottleneck where, under the single-threaded synchronous call chain, processing load spilled onto the UI main thread and froze the screen. Grounded in Bass, Clements & Kazman's *Software Architecture in Practice (SAP)*, verify a pattern/tactic combination that secures real-time behavior without harming portability (Portability) or modifiability (Modifiability).

- Core questions:

- Q1. Under a 28800 BPH (125 ms per beat) load, what concurrency / data-copy structure keeps the UI thread unblocked?
- Q2. Can we eliminate LOH pollution and GC spikes caused by large-snapshot churn (Sound Print ~2.67 MB, Spectrogram ~1.92 MB)?
- Q3. What structure satisfies UI-render-cycle isolation and new-tab/graph extensibility (modifiability) at the same time?

### Status

Complete

### Deliverables

- Pipe-and-Filter data-flow centered audio analysis-to-visualization pipeline architecture definition
- Concurrency-isolation render scheduler (Latest-Wins) and data-copy buffering (fixed buffer pool) design
- Long-run memory/aggregation bounding structure (`DecimatingSeries`) definition
- Architecture trade-off analysis for the adopted patterns/tactics

### Resources Needed

- **Hardware**: RPi5 (CanaKit 16GB RAM), Windows 11 build PC
- **Target source**: `AnalysisFrameRouter.cs`, `SoundPrintFrameProjector.cs`, `AnalysisWorker.cs`, `DecimatingSeries.cs` core modules
- **Instrumentation**: Stopwatch-based real-time latency tracking (`--analysis-log`)
- **Effort**: 2.0 person-days

### Experiment Description

This technical experiment verifies the adopted architecture patterns/tactics for improving GUI real-time rendering across three items.

1. **Pipe-and-Filter data-flow verification** — the watch-sound signal follows a streaming flow of `Capture → Detection → Measurement → Visualization`. Build the pipeline where the audio capture buffer passes through each analysis stage into the final visualization artifacts (`SoundPrint`, `Spectrogram`) and test the stages' independent replaceability. (Maps to the design-pattern table: `Pipe-and-Filter` — overall flow, `Strategy` — input source / filter stages.)
2. **Concurrency-isolation tactic verification** — isolate `AnalysisWorker` on a dedicated `ThreadPriority.Highest` thread so the UI thread only renders. Input↔analysis is delivered via a shared-buffer **Producer–Consumer**, and result frames via an **Observer** fan-out (`AnalysisFrameRouter`'s `ObserveFrame`/`RenderFrame`) that consumers (tabs) subscribe to. To prevent cross-thread interference, combine a **fixed buffer pool (PublishBufferCount = 3) rotation** with a **Latest-Wins scheduler** (`AnalysisFrameRenderScheduler`) that discards frames exceeding the refresh rate. Measure whether the analysis worker's deadline stays isolated from UI lag at 28800 BPH (125 ms).
3. **DecimatingSeries data-bounding verification** — to stop the graph point count from accumulating in proportion to run time, analyze the normal operation of the aggregation structure that, on reaching the fixed capacity limit, merges adjacent point pairs to halve resolution while preserving each bucket's min/max.

### Results & Analysis

This experiment analyzes, from a benefits/trade-offs perspective, which quality attributes the adopted patterns/tactics gain (and how) and what is given up in return, grounded in SAP theory.

#### 1. Pipe-and-Filter data flow — benefits and trade-offs

- **Applied structure**: formalize input → analysis → display as a one-way `Pipe-and-Filter` flow, and isolate `AnalysisWorker` on a dedicated thread (`ThreadPriority.Highest`) so the UI only renders.

- **Benefits**
  - **Maximized modifiability/extensibility (QAS-5)**: each processing stage is encapsulated as an independent stage behind a standard interface (`IAnalysisFrameConsumer`, etc.), so a UI tab structure or a new analysis filter (e.g., a new measurement graph) can be injected without modifying existing code.
  - **Improved reusability/portability**: the dependency between business logic and the GUI framework (Avalonia) is decoupled, making the backend analysis pipeline easy to reuse or port to another OS environment.
- **Trade-offs**
  - **Data-copy overhead**: each time data passes from stage to stage, a large signal snapshot (Sound Print ~2.67 MB, Spectrogram ~1.92 MB) is transferred, increasing copy cost.
  - **Mitigation**: instead of allocating on the heap every time in normal execution, reuse fixed-size buffer blocks to fundamentally block GC spikes and LOH (Large Object Heap) pollution (Zero Churn).

#### 2. Concurrency-isolation tactic — benefits and trade-offs

- **Benefits**
  - **Root-cause fix for UI blocking (QAS-2)**: even when heavy graphics computation or frame rendering runs, an asynchronous barrier is formed that never intrudes on the core analysis thread's cycle.
  - **Performance defense via Latest-Wins**: even if the UI refresh rate slips, the previous frame held in the single slot is coalesced into / discarded for the latest frame, so no cascading delay from backlog accumulation occurs.
- **Trade-offs**
  - **Frame drop / recency bias**: because intermediate frames are discarded to match the UI render cycle and only the latest data is shown, momentary loss of intermediate frames occurs.
  - **Mitigation and justification**: for a real-time monitoring system, expressing the "recency of the current state" without lag matters more than showing past frames with delay, which fits the key quality attributes (performance and usability), so this loss is an architecturally acceptable trade-off. The long-term metric history, however, is supplemented by separately combining a `DecimatingSeries` structure so it aggregates losslessly even across Latest-Wins coalescing.

### Duration

- 6/8–6/9: Bottleneck analysis and candidate-pattern shortlist
- 6/10–6/13: Pattern technical experiment and comparative measurement
- 6/15: SAP judgment and application-priority finalization

### Links & References

- NA

## EXP-04: On-device TinyML inference feasibility

**Risks:** [R-17](3-Risk-Assessment.md#f-project--process) · **QAS:** [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display), [QAS-3](2-Architectural-Drivers.md#qas-3) · **Priority:** Mid

### Results & Decisions

TO-DO: Record the TinyML feature decision (Adopt / Conditional / Hold) and the adoption conditions.

### Objective

Verify whether adding TinyML-based classification (e.g., signal-quality, bad-data rejection) on-device on the RPi keeps real-time behavior and measurement trustworthiness. Core questions:

- Q1. After adding TinyML inference, are end-to-end latency and frame-refresh stability still within the allowed range?
- Q2. Does TinyML classification help reduce mis-display in weak-signal / noisy segments?

### Status

In progress

### Deliverables

- Model size / inference time / CPU-usage comparison table
- TinyML on/off performance comparison table (latency, frame time, mis-display rate, confusion matrix)
- Adoption decision memo (Go / Conditional / No-Go)

### Resources Needed

- 1× RPi5 (physical device)
- TinyML inference runtime (TFLite or equivalent)
- Labeled validation dataset (Sim/Playback)
- Performance logging tools (latency, frame time, CPU/RAM)
- Effort: 1.5 person-days

### Experiment Description

1. Run TinyML off/on with the same input and measure the baseline and the change in latency, frame stability, and resource usage.
2. Compare classification accuracy and mis-display rate (weak-signal / noisy segments) together to weigh feature value against performance cost.
3. Per SAP criteria, judge whether real-time behavior is preserved and finalize the Adopt / Conditional / Hold decision and the fallback path.

### Duration

- TBD

### Links & References

- NA

## EXP-05: Long-run stability (24h+)

**Risks:** [R-04](3-Risk-Assessment.md#a-real-time-performance-rpi) · **QAS:** [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--from-sound-input-to-screen-display) · **Priority:** Mid

### Results & Decisions

- **Decision**: keep the current architecture design (no degradation observed in 24-hour measurement on RPi5).
- **Results**: 
  - Memory (RSS) no leak: RSS stayed flat at about **406 MB** across the run. All 48 thirty-minute segment means were within 405–408 MB range. A single transient peak of 447 MB recovered immediately.
  - CPU no late-run degradation: normalized instantaneous usage held nearly constant at about **36%** of total 4-core capacity (~1.4 of the RPi5's 4 cores). The rising curve is a `ps` artifact (cumulative average converging from 27.8% to steady-state ~36%), not real degradation. Standard deviation was 1.6 percentage points.
- **Policy**: For new computations, filters, graphs, or AI features, perform the same long-term measurement to check for regression. CPU stays at ~36% of 4-core capacity (~1.4 cores), so the remaining headroom (~64%, ≈2.6 cores) is available for additional load.

**Trend over time (0–24h)**

> Data collected during the 24-hour continuous run, shown as 30-minute segment means.

```mermaid
%%{init: {"themeVariables": {"xyChart": {"plotColorPalette": "#A50034, #999999"}}}}%%
xychart-beta
    title "Process CPU usage trend (0–24h, gray line = 100% full 4-core capacity)"
    x-axis "Elapsed time (h)" 0 --> 24
    y-axis "CPU usage (% of 4-core capacity)" 0 --> 100
    line [31.9, 33.4, 33.5, 33.8, 34.0, 34.0, 34.3, 34.3, 34.5, 34.5, 34.7, 34.8, 34.8, 34.9, 35.0, 35.0, 35.0, 35.1, 35.3, 35.3, 35.3, 35.3, 35.3, 35.4, 35.5, 35.5, 35.5, 35.5, 35.5, 35.5, 35.5, 35.6, 35.8, 35.8, 35.8, 35.8, 35.8, 35.8, 35.8, 35.8, 35.8, 35.8, 35.8, 35.9, 36.0, 36.0, 36.0, 36.0]
    line [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100]
```

```mermaid
%%{init: {"themeVariables": {"xyChart": {"plotColorPalette": "#A50034"}}}}%%
xychart-beta
    title "Process memory (RSS) trend (0–24h, no leak → flat)"
    x-axis "Elapsed time (h)" 0 --> 24
    y-axis "RSS (MB)" 380 --> 440
    line [406.1, 406.3, 406.2, 406.6, 407.0, 406.6, 406.5, 406.0, 407.6, 407.2, 406.1, 407.3, 405.9, 406.1, 406.9, 406.0, 406.6, 406.1, 406.0, 406.4, 407.2, 405.9, 407.3, 406.1, 406.1, 406.5, 406.2, 406.5, 406.0, 407.0, 406.3, 406.3, 406.0, 406.1, 406.1, 406.4, 405.8, 407.1, 406.0, 406.2, 406.4, 407.6, 406.6, 406.3, 407.0, 406.2, 407.1, 406.5]
```

### Objective

Check for memory growth, latency degradation, and crash risk under long continuous runs (24h+). Core questions:

- Q1. Is the RSS growth trend at a leak-suspect level?
- Q2. Does latency/performance degrade in the later part of a long run?

### Status

Complete

### Deliverables

- 6h/24h resource-usage trend graphs ✓ (trend graphs above)
- Long-run stability report ✓ (flat RSS / no leak, no CPU degradation)
- Buffer-cap / object-lifetime management policy ✓ (keep as-is, re-measure when new load is added)

### Resources Needed

- A Pi (or equivalent) capable of long continuous runs
- Long-term RSS/CPU/latency logging tools
- Effort: 1.0 person-day (setup) + run wait

### Experiment Description

1. After a 6h preliminary check, run 24h continuously and collect memory, latency, and error trends continuously.
2. Compare early vs late performance to check for leak suspicion, throughput drop, and latency degradation.
3. Per SAP criteria, judge stability pass/fail and finalize the buffer/memory operating policy.

### Duration

- 6/16–6/17: Long-run performance data collection
- 6/18: Results analysis

### Links & References

- NA

## EXP-06: Measurement accuracy

**Risks:** [R-06](3-Risk-Assessment.md#b-signal-processing--measurement-trustworthiness) · **QAS:** [QAS-1](2-Architectural-Drivers.md#qas-1--accuracy--from-acoustic-event-detection-to-computed-watch-metrics) · **Priority:** High

### Results & Decisions

A first pass on the **Realistic-off** simulation (clean signal) confirmed that rate, amplitude, and beat error are measured normally. It will next be validated by a comparison test against a commercial unit, the **Weishi Timegrapher**.

### Objective

Verify detection/computation accuracy on signals with a known reference, as a check on [R-06](3-Risk-Assessment.md#b-signal-processing--measurement-trustworthiness) (if A/C events aren't found to 0.1 ms, every metric is contaminated). **Turning Realistic off** removes noise and variability from the synthetic signal, so the rate, amplitude, and beat error set on the generator become the reference. Pass/Fail uses the commercial Weishi Timegrapher's tolerances — **rate ±1 s/d · amplitude ±1° · beat error ±0.1 ms** (all three from the Weishi spec; the rate ±1 s/d also coincides with the [QAS-1](2-Architectural-Drivers.md#qas-1--accuracy--from-acoustic-event-detection-to-computed-watch-metrics) target).

- Q1. (First pass) On the Realistic-off simulation, are rate, amplitude, and beat error within the tolerances above?
- Q2. (Follow-up) Measuring the same watch on the commercial Weishi Timegrapher, do the readings agree within the same tolerances?

### Status

In progress — first pass (Realistic-off simulation) complete; commercial comparison test to follow

### Deliverables

- Per-metric (rate, amplitude, beat error) error table vs reference + Pass/Fail
- (Follow-up) Weishi Timegrapher comparison table

### Resources Needed

- RPi5 (primary), Windows PC (reference)
- Sim generator (Realistic off), reference values
- A Weishi Timegrapher + the same watch, for the comparison
- Error-logging code
- Effort: ~1.5 person-days

### Experiment Description

Confirm with a known-reference simulation first, then compare against the commercial unit. Pass/Fail uses the same tolerances in both stages (rate ±1 s/d, amplitude ±1°, beat error ±0.1 ms).

1. **Realistic-off simulation (first pass)**: measure rate, amplitude, and beat error on a clean synthetic signal over ≥1,000 beats and judge Pass/Fail against the tolerances.
2. **Commercial comparison (follow-up)**: measure the same watch on both the Weishi Timegrapher and this system, and judge whether the two readings agree within the same tolerances.

Judge each stage on the RPi5 (Windows is reference) and record the results in [R-06](3-Risk-Assessment.md#b-signal-processing--measurement-trustworthiness).

### Duration

- D1–D2: First pass (Realistic-off simulation) / Follow-up: commercial comparison test

### Links & References

- NA

## Integrated Schedule

- Week 1: EXP-01, EXP-02, EXP-03, EXP-06
- Week 2: EXP-04
- Week 3: EXP-05, and re-runs of unresolved items

## Common Approval Criteria

- Pass/fail judgment completed for the High-priority experiments (performance/robustness)
- QAS-2, QAS-3 threshold values finalized
- Adoption/rejection decision rationale recorded together with the experiment logs
