# Planned Experiments

> Technical experiments that buy down the highest-priority risks, organized along SAP (Software Architecture Practice) principles. Each experiment ties to the risks and quality-attribute scenarios (QAS) it de-risks and ends in a pass/fail decision recorded against measured results.

**Contents** — [Risk-to-Experiment Map](#risk-to-experiment-map) · [EXP-01](#exp-01-rpi5-real-time-sample-rate-ceiling) · [EXP-02](#exp-02-gui-real-time-rendering-design-patterns) · [EXP-03](#exp-03-avalonia-rendering-backend-on-the-rpi5) · [EXP-04](#exp-04-on-device-tinyml-inference-feasibility) · [EXP-05](#exp-05-long-run-stability-24h) · [EXP-06](#exp-06-readability-and-touch-target-ui-thresholds) · [Integrated Schedule](#integrated-schedule) · [Common Approval Criteria](#common-approval-criteria)

## Terminology

The terms used in this document are defined in the consolidated [Glossary](Milestone1_6-Glossary.md). Risks (`R-*`) are defined in [Risk Assessment](Milestone1_3-Risk-Assessment.md); quality-attribute scenarios (`QAS-*`) in [Architectural Drivers](Milestone1_2-Architectural-Drivers.md).

## Risk-to-Experiment Map

> Priority: **High** / **Mid** (no Low-priority experiments in this milestone).

| Experiment | Risks Addressed | Related QAS | Priority | Core Question |
|---|---|---|---|---|
| [EXP-01](#exp-01-rpi5-real-time-sample-rate-ceiling) | [R-A1](Milestone1_3-Risk-Assessment.md#a-real-time-performance-rpi), [R-A3](Milestone1_3-Risk-Assessment.md#a-real-time-performance-rpi) | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display) | **High** | What is the highest sample rate the RPi5 can process in real time? |
| [EXP-02](#exp-02-gui-real-time-rendering-design-patterns) | [R-F2](Milestone1_3-Risk-Assessment.md#f-project--process) | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display), [QAS-4](Milestone1_2-Architectural-Drivers.md#qas-4--modifiability-extensibility--adding-a-new-measurementfiltergraph) | **High** | Which design patterns should we apply first to improve GUI real-time performance? |
| [EXP-03](#exp-03-avalonia-rendering-backend-on-the-rpi5) | [R-A5](Milestone1_3-Risk-Assessment.md#a-real-time-performance-rpi) | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display) | **High** | If we choose C#, how do we remove the Avalonia-on-RPi5 rendering risk? |
| [EXP-04](#exp-04-on-device-tinyml-inference-feasibility) | [R-F4](Milestone1_3-Risk-Assessment.md#f-project--process) | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display), [QAS-2](Milestone1_2-Architectural-Drivers.md#qas-2--availability-graceful-degradation--under-noisy-or-weak-signals) | Mid | Can we add TinyML inference and still hold real-time behavior and trustworthiness? |
| [EXP-05](#exp-05-long-run-stability-24h) | [R-A4](Milestone1_3-Risk-Assessment.md#a-real-time-performance-rpi) | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display) | Mid | Do memory/latency degrade over long runs? |
| [EXP-06](#exp-06-readability-and-touch-target-ui-thresholds) | [R-E1](Milestone1_3-Risk-Assessment.md#e-usability--ui-1280800), [R-E2](Milestone1_3-Risk-Assessment.md#e-usability--ui-1280800) | [QAS-5](Milestone1_2-Architectural-Drivers.md#qas-5--usability--reading-and-operating-on-the-touchscreen) | Mid | What font-size / touch-target thresholds satisfy both readability and touch recognition? |

## EXP-01: RPi5 real-time sample-rate ceiling

**Risks:** [R-A1](Milestone1_3-Risk-Assessment.md#a-real-time-performance-rpi), [R-A3](Milestone1_3-Risk-Assessment.md#a-real-time-performance-rpi) · **QAS:** [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display) · **Priority:** High

### Results & Recommendations

TO-DO: After measurement, record the final recommended sample rate (48k/96k/192k) and the rationale for the choice.

### Objective

Confirm whether the input → analysis → display pipeline meets real-time requirements in the Pi5 Live environment. Core questions:

- Q1. Which sample rate runs stably without block drop?
- Q2. Does processing + display latency meet p99 ≤ 500 ms?

### Status

Planned

### Expected Deliverables

- Per-sample-rate performance comparison table (p50/p95/p99)
- Block-drop / missed-beat statistics table
- WAV-fixture vs Live-input comparison table
- Sample-rate target proposal (Go/No-Go)

### Resources Needed

- 1× Raspberry Pi 5 (physical device)
- Live input + Playback WAV fixture (TimeGrapherTestFilesWeishiMic)
- Latency/drop logging code
- Effort: 1.5 person-days

### Experiment Description

1. Run 48k/96k/192k under common Live/Playback conditions and measure the latency and stability of the input → analysis → display path.
2. Compare total latency, block drop, missed beat, and CPU/RAM per sample rate to derive an operable threshold.
3. Per SAP criteria, judge whether p99 latency and the no-drop condition are met, and finalize the default sample rate (Go/No-Go).

### Duration

- D1–D2: Prepare instrumentation code
- D3: Run measurements
- D4: Analyze results and derive the recommendation

### Links & References

- NA

## EXP-02: GUI real-time rendering design patterns

**Risks:** [R-F2](Milestone1_3-Risk-Assessment.md#f-project--process) · **QAS:** [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display), [QAS-4](Milestone1_2-Architectural-Drivers.md#qas-4--modifiability-extensibility--adding-a-new-measurementfiltergraph) · **Priority:** High

### Results & Recommendations

TO-DO: Record the priority and application scope of the design patterns chosen for GUI performance improvement.

### Objective

To improve GUI real-time performance, compare—from a technical-attribute perspective—the design patterns to apply on the rendering/refresh path, and finalize the patterns to apply first within the milestone. Core questions:

- Q1. For the current GUI bottleneck, which pattern (e.g., Producer-Consumer, Double Buffering, Object Pool) is effective?
- Q2. Once applied, how do the patterns rank in frame stability, latency, and implementation difficulty?
- Q3. Can the team agree on a first-priority pattern set that fits the short schedule?

### Status

Planned

### Expected Deliverables

- GUI-performance pattern comparison table (effect, application difficulty, schedule impact)
- Priority pattern set (1st / 2nd) and the list of target modules
- PoC scope and verification checklist for the pattern application

### Resources Needed

- TimeGrapher_v10.4 source code
- C++/Qt and concurrency/rendering pattern references
- Profiling / frame-time measurement tools
- Code-review session participants (2–4 people)
- Effort: 2.0 person-days

### Experiment Description

1. Identify the GUI refresh-path bottleneck and shortlist applicable design-pattern candidates.
2. Compare candidate patterns with small PoCs, measuring latency, frame stability, and implementation difficulty.
3. Per SAP criteria, finalize the first-priority pattern set and decide the milestone application scope.

### Duration

- D1–D2: Bottleneck analysis and candidate-pattern shortlist
- D3–D4: Pattern PoC and comparative measurement
- D5: SAP judgment and application-priority finalization

### Links & References

- NA

## EXP-03: Avalonia rendering backend on the RPi5

**Risks:** [R-A5](Milestone1_3-Risk-Assessment.md#a-real-time-performance-rpi) · **QAS:** [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display) · **Priority:** High

### Results & Recommendations

TO-DO: Under the C#-selection scenario, record the Avalonia UI rendering-backend lock policy and the deployment default.

### Objective

When adopting the C# path for development efficiency (C# experts on the team), use a technical experiment to resolve the risk that Avalonia UI's GPU-accelerated rendering on the RPi5 may be slower than SW rendering. Core questions:

- Q1. Among GLX/EGL/Software on the RPi5, which backend shows the most stable frame performance on the real workload?
- Q2. Can we finalize an operating default that meets ≥10 Hz graph refresh and minimal UI freeze?

### Status

Planned

### Expected Deliverables

- Per-backend Avalonia performance comparison table (FPS, p95/p99 frame time, freeze count)
- HW/SW renderer-identification log (GL context info)
- C# deployment default policy (backend lock value, fallback rule on failure)

### Resources Needed

- Raspberry Pi 5 device (monitor / SSH)
- Avalonia benchmark build (CLI measurement mode)
- Frame-time collection and result-logging tools
- Effort: 1.0 person-days

### Experiment Description

1. Run Avalonia under GLX/EGL/Software each, collecting frame time, FPS, and freeze metrics under identical load.
2. Check whether SW rendering outperforms the GPU-accelerated path and select the backend suited to real operation.
3. Per SAP criteria, judge refresh-rate/stability satisfaction and finalize the C# default-backend deployment policy.

### Duration

- D6–D7

### Links & References

- NA

## EXP-04: On-device TinyML inference feasibility

**Risks:** [R-F4](Milestone1_3-Risk-Assessment.md#f-project--process) · **QAS:** [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display), [QAS-2](Milestone1_2-Architectural-Drivers.md#qas-2--availability-graceful-degradation--under-noisy-or-weak-signals) · **Priority:** Mid

### Results & Recommendations

TO-DO: Record the TinyML feature decision (Adopt / Conditional / Hold) and the adoption conditions.

### Objective

Verify whether adding TinyML-based classification (e.g., signal-quality, bad-data rejection) on-device on the RPi keeps real-time behavior and measurement trustworthiness. Core questions:

- Q1. After adding TinyML inference, are end-to-end latency and frame-refresh stability still within the allowed range?
- Q2. Does TinyML classification help reduce mis-display in weak-signal / noisy segments?

### Status

Planned

### Expected Deliverables

- Model size / inference time / CPU-usage comparison table
- TinyML on/off performance comparison table (latency, frame time, mis-display rate, confusion matrix)
- Adoption decision memo (Go / Conditional / No-Go)

### Resources Needed

- 1× Raspberry Pi 5 (physical device)
- TinyML inference runtime (TFLite or equivalent)
- Labeled validation dataset (Sim/Playback)
- Performance logging tools (latency, frame time, CPU/RAM)
- Effort: 1.5 person-days

### Experiment Description

1. Run TinyML off/on with the same input and measure the baseline and the change in latency, frame stability, and resource usage.
2. Compare classification accuracy and mis-display rate (weak-signal / noisy segments) together to weigh feature value against performance cost.
3. Per SAP criteria, judge whether real-time behavior is preserved and finalize the Adopt / Conditional / Hold decision and the fallback path.

### Duration

- D7–D8

### Links & References

- NA

## EXP-05: Long-run stability (24h+)

**Risks:** [R-A4](Milestone1_3-Risk-Assessment.md#a-real-time-performance-rpi) · **QAS:** [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--from-sound-input-to-screen-display) · **Priority:** Mid

### Results & Recommendations

TO-DO: Record the long-run stability conclusion and the buffer/memory policy recommendation.

### Objective

Check for memory growth, latency degradation, and crash risk under long continuous runs (24h+). Core questions:

- Q1. Is the RSS growth trend at a leak-suspect level?
- Q2. Does latency/performance degrade in the later part of a long run?

### Status

Planned

### Expected Deliverables

- 6h/24h resource-usage trend graphs
- Long-run stability report
- Buffer-cap / object-lifetime management policy

### Resources Needed

- A Pi (or equivalent) capable of long continuous runs
- Long-term RSS/CPU/latency logging tools
- Effort: 1.0 person-days (setup) + run wait

### Experiment Description

1. After a 6h preliminary check, run 24h continuously and collect memory, latency, and error trends continuously.
2. Compare early vs late performance to check for leak suspicion, throughput drop, and latency degradation.
3. Per SAP criteria, judge stability pass/fail and finalize the buffer/memory operating policy.

### Duration

- D8–D10

### Links & References

- NA

## EXP-06: Readability and touch-target UI thresholds

**Risks:** [R-E1](Milestone1_3-Risk-Assessment.md#e-usability--ui-1280800), [R-E2](Milestone1_3-Risk-Assessment.md#e-usability--ui-1280800) · **QAS:** [QAS-5](Milestone1_2-Architectural-Drivers.md#qas-5--usability--reading-and-operating-on-the-touchscreen) · **Priority:** Mid

### Results & Recommendations

TO-DO: Record the font-size thresholds (minimum/recommended), the touch-target threshold, and the final UI-layout recommendation.

### Objective

Verify whether readability and touch operability can be secured when the summary bar + graphs + scope strip are shown together on a small screen. Core questions:

- Q1. How does user satisfaction change as font size is varied in steps?
- Q2. What is the minimum UI threshold that satisfies both font readability and touch recognition at once?

### Status

Planned

### Expected Deliverables

- Survey-result table of user satisfaction per font-size step
- Touch success rate and mis-touch rate per font-size / touch-target combination
- UI threshold proposal: minimum letter height (mm), recommended letter height (mm), minimum touch target (mm), mode-switch tab structure

### Resources Needed

- Raspberry Pi 5 + 1280×800 touch display
- UI experiment build (switchable font-size / touch-target presets)
- 8–12 participants (mix of team members + external users recommended)
- Survey tool (Google Forms or equivalent)
- Effort: 1.5 person-days

### Experiment Description

1. On a fixed layout, vary the font-size / touch-target combination in steps, perform the same task, and collect readability and operability data.
2. Compare objective metrics (completion time, error rate, touch success rate, mis-touch rate) with subjective metrics (satisfaction survey) to derive minimum/recommended UI thresholds.
3. Per SAP criteria, judge readability/touchability pass/fail and lock in the final layout recommendation.

### Duration

- D9: Prepare the experiment build and finalize the survey questions
- D10: Rehearse with 2 pilot participants
- D11–D12: Run the main experiment (8–12 people) and analyze results

### Links & References

- NA

## Integrated Schedule

- Week 1: EXP-01, EXP-02, EXP-03
- Week 2: EXP-04, EXP-06
- Week 3: EXP-05, EXP-06 (extended verification), and re-runs of unresolved items

## Common Approval Criteria

- Pass/fail judgment completed for the High-priority experiments (performance/robustness)
- QAS-1, QAS-2 threshold values finalized
- Adoption/rejection decision rationale recorded together with the experiment logs
