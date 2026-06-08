# Risk Assessment

## Technical Risks

| ID | Risk Description | Quality Attribute | Probability | Impact |
|----|-----------------|-------------------|-------------|--------|
| RISK-01 | Raspberry Pi cannot sustain real-time audio processing at high sample rates (96k / 192k); audio blocks are dropped and beats are missed. | QAS-1 | High | High |
| RISK-02 | End-to-end latency from acoustic capture to GUI display exceeds the p99 ≤ 500 ms target when processing and rendering loads combine. | QAS-1 | Medium | High |
| RISK-03 | Tick/tock event detection or marker placement is inaccurate; timing errors cascade into rate, amplitude, beat error, and BPH calculations. | QAS-2<br>QAS-3 | High | High |
| RISK-04 | Noisy, weak, or corrupted acoustic input produces misleading measurement values instead of triggering a graceful "signal weak" indication. | QAS-2 | High | High |
| RISK-05 | The same measurement result is displayed differently across simultaneous views (e.g., Trace, Beat Error display, and Scope show conflicting derived values in the same frame). | QAS-3 | Medium | High |
| RISK-06 | Rendering F0–F3 filter views (G12, all mandatory) plus multiple graph panels simultaneously drops the frame rate below acceptable levels on the RPi. | QAS-1<br>QAS-5 | Medium | High |
| RISK-07 | The 1280×800 touchscreen cannot legibly display the summary bar, graph panels, and scope strips simultaneously while meeting the ≥ 2.9 mm character height and ≥ 9 mm touch-target constraints. | QAS-5 | Medium | Medium |
| RISK-08 | Long-duration measurements (24 h+, desired in FR-07-10) grow memory and disk usage without bound, eventually degrading performance or causing a crash. | QAS-1 | Medium | Medium |
| RISK-09 | Without an up-front extensibility structure (e.g., strategy interface for filters and graphs), adding a new feature — F4, a new marker type, or a new graph — requires changes spread across multiple existing modules. | QAS-4 | Medium | Medium |
| RISK-10 | Audio I/O differences between Windows (WASAPI) and Raspberry Pi (ALSA) cause timing or behavior divergence, and the gap is not discovered until late in the schedule. | QAS-1 | Medium | Medium |
| RISK-11 | AGC is left enabled on the microphone or the microphone coupling is poor; the input signal is distorted and all measurements become unreliable from the start. | QAS-2 | Medium | High |
| RISK-12 | The optional TinyML / AI scope adds on-device inference overhead and implementation uncertainty that may conflict with the real-time latency target or undermine measurement reliability. | QAS-1<br>QAS-2 | Low | Medium |
| RISK-13 | Supporting three sample rates (48k / 96k / 192k) simultaneously adds timing and normalization complexity that can introduce subtle measurement errors. | QAS-1 | Medium | Medium |
| RISK-14 | Touch accuracy or recognition on the 1280×800 panel may be poor, making controls difficult to operate reliably. | QAS-5 | Low | Low |

## Non-Technical Risks

| ID | Risk Description | Quality Attribute | Probability | Impact |
|----|-----------------|-------------------|-------------|--------|
| RISK-15 | The 12 mandatory feature groups (G01–G12) plus optional AI/TinyML scope cannot all be implemented at sufficient quality within the 5-week milestone schedule. | QAS-1<br>QAS-2<br>QAS-3<br>QAS-4<br>QAS-5 | High | High |
| RISK-16 | Understanding and safely modifying the provided baseline code (TimeGrapher v10.4) takes time and delays the start of implementation. | QAS-4 | Low | Medium |
| RISK-17 | The combined Qt / C++ · DSP · Raspberry Pi learning curve undermines implementation quality across all features. | QAS-1<br>QAS-2 | Medium | Medium |
| RISK-18 | GenAI-generated code accepted without adversarial verification introduces plausible-but-wrong logic, especially in DSP, concurrency, and real-time sections. | QAS-1<br>QAS-2<br>QAS-3 | Medium | Medium |
| RISK-19 | Only one Raspberry Pi 5 is available for testing; real-hardware verification of performance and latency targets cannot be scheduled reliably within the milestone window. | QAS-1 | High | High |

## Mitigation Actions

| ID | Mitigation Action | Linked Experiment | Note |
|----|-------------------|-------------------|------|
| RISK-01 | Run a week-1 spike on the RPi at 48k / 96k / 192k; fix the sample-rate target based on results; demote 192k to stretch goal if block drops occur. | EXP-01 | |
| RISK-02 | Instrument capture / processing / display latency per stage; if p99 > 500 ms, optimize the bottleneck stage or reduce active feature count. | EXP-01 | |
| RISK-03 | Validate the detection algorithm on Sim ground-truth data before integrating with the GUI; improve or replace if onset error p95 > 0.1 ms. | EXP-02 | |
| RISK-04 | Run noise-injection tests across SNR levels; tune the SNR threshold and filter settings to meet QAS-2 gates; ensure below-threshold output is "signal weak" only. | EXP-03 | |
| RISK-05 | Route all measurement results through a single computation fan-out; instrument each display widget to verify source-result agreement in every frame. | EXP-04 | |
| RISK-06 | Reuse a shared input buffer across views; stop rendering inactive views; measure FPS budget with 1 / 2 / 4 filter views; decide simultaneous vs. tab-based display after experiment. | EXP-01 | |
| RISK-07 | Design key-readings-first layout; use tab-based panel split; validate physical character height (≥ 2.9 mm) and touch-target size (≥ 9 mm) on the actual panel. | EXP-06 | |
| RISK-08 | Monitor RSS trend over a 6–24 h run; define buffer caps and aggregation policy before Milestone 2. | EXP-07 | |
| RISK-09 | Pre-design a filter / graph strategy interface and a plug-in registration scheme; validate by adding a trial feature and counting existing modules touched. | EXP-05 | |
| RISK-10 | Isolate audio I/O behind a platform adapter from week 1; verify behavior on Raspberry Pi OS (ALSA) against Windows (WASAPI) baseline. | EXP-08 | |
| RISK-11 | Make AGC-off and microphone-coupling verification a mandatory environment checklist item from day 1 (constraint C-4); add to the platform portability check. | EXP-08 | |
| RISK-12 | Keep TinyML as optional proof-of-concept; maintain a rule-based fallback; evaluate only after the core real-time pipeline passes performance tests. | — | Scope decision, not a measurement question. The mitigation is a policy choice made up front. |
| RISK-13 | State the supported sample-rate range explicitly; normalize sample-rate-dependent timing in the audio adapter layer. | EXP-01 | |
| RISK-14 | Experimentally verify touch sensitivity and touch-area recognition; if OS-level only, proceed with the current configuration. | EXP-06 | |
| RISK-15 | Freeze implementation sequence to mandatory FRs first; treat desired FRs as a secondary queue; scope AI/TinyML as a separately tracked optional item. | — | Planning and prioritization decision. No data collection needed — the action itself is the mitigation. |
| RISK-16 | Conduct code-reading sessions and produce a module map as a week-1 task; use AI assistance to accelerate baseline comprehension. | EXP-05 | |
| RISK-17 | Apply role split and pairing; run small spikes early to build hands-on familiarity; use AI assistance for Qt / DSP implementation support. | — | Team process decision. Resolved through role assignment and pairing, not through a measurable experiment. |
| RISK-18 | Mandate adversarial verification for all generated code (unit tests, Sim-based bench); ensure the whole team understands the core DSP algorithms; confirm GenAI usage policy with mentors. | — | Code review policy and team agreement. The practice itself is the mitigation — no separate experiment produces a go/no-go decision. |
| RISK-19 | Design the majority of verification to run on Sim / Playback (no hardware required); schedule the real RPi5 only for must-have items such as latency measurement and physical touch validation. | EXP-01<br>EXP-06 | |
