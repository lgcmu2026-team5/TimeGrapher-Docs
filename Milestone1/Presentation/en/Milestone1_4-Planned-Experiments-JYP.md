# Planned Experiments

> TimeGrapher Reference Architecture — Milestone 1
> Experiment plan to validate/mitigate the 🔴/🟡 risks in [Milestone1_3-Risk-Assessment-JYP.md](Milestone1_3-Risk-Assessment-JYP.md)

---

## 1. How These Map to Risks

Each experiment concretizes SAP step 5 — **validate high risks early via experiments (Spike/PoC)**. Every experiment states the same six elements:

- **Question/Hypothesis** — what is unknown (the risk's "question mark")
- **Method** — setup and procedure
- **Dataset** — Sim / Playback / WAV fixture / Live
- **Measurement** — what is measured and how
- **Pass criteria** — reuse the related QAS response measure verbatim
- **Decision** — what the result confirms or changes

Pass criteria reuse the response measures from [Milestone1_QA_Final_1.md](../../Milestone1_QA_Final_1.md) wherever possible, to keep traceability.

### Status / Priority Legend

| Mark | Meaning |
|:----:|------|
| 🔴 **Critical** | Top priority. Start in Week 1–2; the result drives spec/architecture |
| 🟡 **Important** | Mitigation validation; mid-project |
| ⚪ **Optional** | If time allows / after scope is fixed |

---

## 2. Summary

| EXP | Title | Related Risks | QAS / FR | Week | Pri |
|----|------|--------|------|:--:|:--:|
| **EXP-1** | RPi5 real-time ceiling & max sample rate | R-A1, R-A3 | QAS-1 / FR-08-01·12-04 | W1 | 🔴 |
| **EXP-2** | Concurrent filters / multi-graph FPS budget | R-A2, R-C4 | QAS-1 / FR-12-01·04·05 | W2 | 🔴 |
| **EXP-3** | Beat onset/peak detection accuracy (synthetic) | R-B1, R-B4 | QAS-2 / FR-08-04·05-13 | W1–2 | 🔴 |
| **EXP-4** | Noise robustness & graceful degradation | R-B2 | QAS-3 / FR-12-08·05-17 | W2–3 | 🔴 |
| **EXP-5** | Module-separation spike + extensibility measure | R-C1, R-C3, R-F2 | QAS-5 / G01–G12 | W1 | 🔴 |
| **EXP-6** | Build regression dataset + specimen-sharing plan | R-G3, R-F6 | (verification basis) / G01–G12 | W1→ongoing | 🔴 |
| **EXP-7** | Long-run memory / stability | R-A4, R-H1 | QAS-1 / FR-07 | W3–4 | 🟡 |
| **EXP-8** | SD-card write throughput / aging | R-H2, R-H3 | QAS-1 (precondition) / FR-07 | W2 | 🟡 |
| **EXP-9** | 800×480 readability & touch targets | R-E1, R-E2, R-E3 | QAS-6 / FR-06-06·01-05 | W2–3 | 🟡 |
| **EXP-10** | Audio device disconnect / recovery | R-D4 | QAS gap (Availability) / FR-05-03 | W3 | 🟡 |
| **EXP-11** | Cross-view consistency check | R-C2 | QAS-4 / FR-12-05·06-06 | W3 | 🟡 |
| **EXP-12** | AGC / mic-coupling environment check | R-D1, R-D2, R-D3 | QAS-2·3 / FR-08-01 | W1 | 🟡 |
| **EXP-13** | AI/TinyML on-Pi feasibility | R-F4 | QAS gap (AI scope) / — | W4–5 | ⚪ |

---

## 3. Detailed Cards (Critical)

### EXP-1 · RPi5 Real-Time Ceiling & Max Sample Rate
**Risks** R-A1, R-A3 · **QAS** QAS-1 · **FR** FR-08-01, FR-12-04, FR-12-14, FR-05-03 · **Week** W1 · 🔴

| Item | Content |
|------|------|
| Question | What is the **max sample rate** at which RPi5 (8GB) keeps capture→process→display real-time? Is 96k achievable; must 192k be demoted to stretch? |
| Method | Run Live input and Playback WAV at 48k/96k/192k, 10 min each. Timestamp at capture / analysis-done / on-screen. Log per-stage latency, dropped-block, missed-beat counters, render-update delay |
| Dataset | 48k/96k/192k WAV fixtures (TimeGrapherTestFilesWeishiMic) + Live mic |
| Measurement | (1) processing latency p99, (2) display latency p99, (3) end-to-end p99, (4) dropped blocks, (5) missed beats |
| Pass criteria | **End-to-end p99 ≤ 500 ms** (gate); at 96k **dropped blocks = 0 · missed beats = 0**. Holds at the 48k minimum too |
| Decision | Fix the sample-rate target (adopt 96k / decide 192k stretch). If failing, trigger R-A3 mitigation path (resource optimization vs feature downgrade) |

### EXP-2 · Concurrent Filters / Multi-Graph FPS Budget
**Risks** R-A2, R-C4 · **QAS** QAS-1 · **FR** FR-12-01, FR-12-04, FR-12-05, FR-12-13 · **Week** W2 · 🔴

| Item | Content |
|------|------|
| Question | When rendering 4 filters (F0→F3) + multiple graph tabs at once, does RPi5 hold ≥20 FPS and UI responsiveness? Is "show all at once" or "one active view" needed? |
| Method | Measure FPS/CPU/UI-freeze frequency across 4 combos of shared-buffer-reuse on/off × inactive-view-render-stop on/off. Sweep simultaneous tabs from 1→4 |
| Dataset | 96k Playback fixture (stable repro) + Live |
| Measurement | FPS (avg/min), CPU usage, UI freeze count (>200ms unresponsive), input keep-up |
| Pass criteria | In the core simultaneous config, **FPS ≥ 20**, 0 freezes, 0 dropped blocks. (If failing, reduce simultaneous views) |
| Decision | Fix the "4 concurrent views vs one at a time" UI policy; decide whether to stop rendering inactive views |

### EXP-3 · Beat Onset/Peak Detection Accuracy (Synthetic)
**Risks** R-B1, R-B4 · **QAS** QAS-2 · **FR** FR-08-04…06, FR-05-13, FR-06-01…04 · **Week** W1–2 · 🔴

| Item | Content |
|------|------|
| Question | Does current detection locate onset/peak within **≤ 0.1 ms**? Is sub-sample interpolation required at 48k? |
| Method | Sim mode Realistic OFF, generate beats with known positions. Compare detection against programmed ground truth. Run at 48k and 96k |
| Dataset | ≥ 1,000 synthetic beats (known rate · amplitude · beat error) |
| Measurement | Max onset/peak position error (ms, samples); rate · amplitude · beat-error error |
| Pass criteria | **Max onset/peak error ≤ 0.1 ms** (at 48k = 4.8 samples → confirm sub-sample interpolation). Holds across all 1,000 beats |
| Decision | Adopt current logic vs start detector improvement; confirm need for sub-sample interpolation |

### EXP-4 · Noise Robustness & Graceful Degradation
**Risks** R-B2 · **QAS** QAS-3 · **FR** FR-12-08, FR-05-17…18, FR-04-06 · **Week** W2–3 · 🔴

| Item | Content |
|------|------|
| Question | Does it hold detection/accuracy under noise/weak signal? Below threshold, is bad data isolated as **"signal weak" rather than a wrong value** and excluded from X/D? |
| Method | Inject calibrated noise into Sim/Playback at a held SNR. Sweep SNR around 14 dB and observe detection/isolation behavior |
| Dataset | ≥ 1,000 synthetic beats + injected noise (known SNR) |
| Measurement | Detection rate / rate error at SNR≥14dB; "signal weak" rate & wrong-value count below threshold; X/D invalid-inclusion count |
| Pass criteria | At SNR ≥ 14 dB: **detection ≥ 95% · rate error ≤ ±3 s/d**; below threshold: **0 wrong values · "signal weak" only**; X/D invalid inclusion **0** |
| Decision | Fix the signal-quality threshold; adopt/improve bad-data isolation logic |

### EXP-5 · Module-Separation Spike + Extensibility Measure
**Risks** R-C1, R-C3, R-F2 · **QAS** QAS-5 · **FR** G01–G12 (e.g. FR-05-01, FR-12-01, FR-04-06) · **Week** W1 · 🔴

| Item | Content |
|------|------|
| Question | If the baseline god-screen is split into acquisition/processing/calc/presentation, is adding a new graph/filter/measurement confined to **one registration point**? |
| Method | In Week 1, stand up a 4-layer skeleton; as a trial, add 1 new graph, 1 new filter, 1 new measurement, counting changed modules/locations |
| Dataset | Baseline code (TimeGrapher_v10.4) + regression test set (EXP-6) |
| Measurement | Existing modules changed per addition; regression-test pass |
| Pass criteria | New graph ≤ 1 module, new filter ≤ 1 registration point, new measurement ≤ 1 registry change, **0 regressions** |
| Decision | Fix module boundaries & plug-in registration. Also mitigates R-F2 (code understanding) via the module map |

### EXP-6 · Build Regression Dataset + Specimen-Sharing Plan
**Risks** R-G3, R-F6, R-B4 · **QAS** verification basis (precondition for QAS-2·3·5 measures) · **FR** G01–G12 · **Week** W1 → ongoing · 🔴

| Item | Content |
|------|------|
| Question | Under the one-device, one-specimen constraint, can we build a regression dataset that **repeatably reproduces** timing, accuracy, degradation, sequence behavior? |
| Method | Curate a fixed input set from Sim/Playback/WAV fixtures. Run the same input 3× to confirm reproducibility. Operate a specimen (watch) sharing calendar with reserved slots |
| Dataset | Sim scenarios + Playback WAV + one Live calibration capture |
| Measurement | X/D reproducibility (3× agreement), included/excluded position trace agreement, run-to-run variance |
| Pass criteria | Across 3 runs of the same input, **X/D results agree** and traces agree. Have an automation script for immediate rerun on change |
| Decision | Fix the verification basis for all later experiments. Specimen shortage (R-F6) → decide accelerated/shortened tests + Sim-substitution share |

---

## 4. Supporting Experiments (Important / Optional)

| EXP | Question | Method / Dataset | Pass criteria | Decision |
|----|------|--------|--------|--------|
| **EXP-7** Long-run memory | Is there a memory leak/degradation over 24h+ continuous run? | Long run on current code, log RSS trend & aggregation buffer / repeated Playback | Long-term RSS non-growing (converges within cap); estimate 24h by combining hourly results | Adopt buffer caps & aggregation (R-A4) |
| **EXP-8** SD write throughput | Does DDR→flash (SD) write speed keep up with audio generation rate? | Check SD spec + measured recording throughput, RAM-buffer/backpressure test / Live recording | Generation rate ≤ sustained write rate, 0 overflow, 0 data loss | Fix SD grade & buffer policy (R-H2, R-H3) |
| **EXP-9** Touchscreen read/operate | Can 800×480 hold the 3 key values legibly and be finger-operable? | Pixel-level sizing prototype + ≥3 representative users timed / mockup screens | Glyph ≥ 1.9 mm·contrast ≥ 4.5:1, touch ≥ 9 mm, primary mode ≤ 2 taps, active position ≤ 5s · X/D ≤ 10s (≥90%) | Fix priority layout & tab split (R-E1·E2·E3) |
| **EXP-10** Disconnect/recovery | Does it recover from audio device disconnect / stream error mid-measurement? | Unplug/replug & stream-error injection cycles / Live | 0 crashes, auto-resume, fault indication, 0 data corruption | Adopt recovery menu, exception detection, state save (R-D4) |
| **EXP-11** Cross-view consistency | Does one measurement result agree across all views and X/D? | Expose snapshot ID, run 10-min known input, compare simultaneous displays / Playback | **0 mismatches** among simultaneous displays (within rounding), X/D source mismatch 0 | Fix single source of truth & shared time-axis model (R-C2) |
| **EXP-12** AGC/coupling check | Does un-disabled AGC / poor coupling collapse measurement trust? | Compare AGC on/off, good/poor coupling / Live | With AGC off + good coupling, signal distortion within tolerance; checklist established | Fix environment checklist & user-guide items (R-D1·D2·D3) |
| **EXP-13** AI/TinyML on-Pi | Does a small model run on Pi with PC-equivalent results & acceptable latency? | Verify on Windows → port to RPi5 and compare; evaluate small-model candidates / labeled Sim/Playback | Confusion matrix · false accept/reject within tolerance; on-device latency within tolerance | Decide AI inclusion vs rule-based fallback (R-F4) — *optional scope* |

---

## 5. Traceability Matrix (Risk → Experiment → Decision)

| Risk | Experiment | Decision confirmed/changed |
|------|------|--------|
| R-A1, R-A3 | EXP-1 | Sample-rate target (96k/192k), latency mitigation path |
| R-A2, R-C4 | EXP-2 | Simultaneous-display policy, async/lock-free boundary |
| R-A4, R-H1 | EXP-7 | Buffer caps & aggregation, long-term verification approach |
| R-B1, R-B4 | EXP-3 | Detector adopt/improve, sub-sample interpolation |
| R-B2 | EXP-4 | Signal-quality threshold, bad-data isolation |
| R-C1, R-C3, R-F2 | EXP-5 | Module boundaries & plug-in registration, code map |
| R-C2 | EXP-11 | Single source of truth, shared time-axis |
| R-D1·D2·D3 | EXP-12 | Environment checklist, port-adapter, supported sample rates |
| R-D4 | EXP-10 | Recovery menu, exception detection, state save |
| R-E1·E2·E3 | EXP-9 | Priority layout, tab split, touch targets |
| R-F6, R-G3, R-B4 | EXP-6 | Verification basis, specimen sharing, accelerated tests |
| R-H2, R-H3 | EXP-8 | SD grade & buffer policy, checkpoint save |
| R-F4 | EXP-13 | AI inclusion vs rule-based fallback (optional) |

> R-F1 (5-week time-box), R-F5 (GenAI hallucination), R-F7 (English communication) are not single experiments but managed continuously at the **process level** (priority freeze, code review & adversarial verification, ko/en documentation).

---

*Basis: [Milestone1_3-Risk-Assessment-JYP.md](Milestone1_3-Risk-Assessment-JYP.md) · QAS: [Milestone1_QA_Final_1.md](../../Milestone1_QA_Final_1.md) · FR: [Milestone1_2-Architectural-Drivers.md](Milestone1_2-Architectural-Drivers.md)*
