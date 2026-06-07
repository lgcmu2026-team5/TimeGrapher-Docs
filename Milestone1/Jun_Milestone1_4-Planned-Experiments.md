# Planned Experiments

## Purpose

Each experiment below addresses a specific open question or risk that will affect the outcome of the project. An experiment is included only when the answer is not yet known before running it and the result directly gates an architectural or design decision before Milestone 2.

## Experiment Summary

| ID | Experiment | Linked Risk | Linked QAS | Priority |
|----|------------|-------------|------------|----------|
| EXP-01 | RPi real-time sample-rate limit | RISK-01, RISK-02, RISK-06, RISK-13 | QAS-1 | High |
| EXP-02 | Beat detection precision | RISK-03 | QAS-2, QAS-3 | High |
| EXP-03 | Signal quality under noise and AGC | RISK-04, RISK-11 | QAS-2 | High |
| EXP-04 | Display consistency across simultaneous views | RISK-05 | QAS-3 | High |
| EXP-05 | Extensibility boundary test | RISK-09, RISK-15, RISK-16 | QAS-4 | Medium |
| EXP-06 | Small-screen legibility and touch validation | RISK-07, RISK-14 | QAS-5 | Medium |
| EXP-07 | Long-run memory stability | RISK-08 | QAS-1 | Medium |
| EXP-08 | Platform portability and AGC check | RISK-10, RISK-11 | QAS-1 | Medium |

---

## EXP-01 — RPi Real-Time Sample-Rate Limit

**Key Question** At which sample rate can the RPi5 process audio in real time without block drops, and does the full pipeline meet p99 ≤ 500 ms under simultaneous multi-view rendering?

**Approach**
- Run the same 10-minute Playback file at 48k, 96k, and 192k in separate sessions on the RPi5.
- Instrument the capture callback to count block drops and measure callback duration.
- Record CPU %, RSS, and missed-beat count at each sample rate.
- Separately measure rendering FPS with 1 and 4 filter views active.
- Inject timestamps at capture, analysis completion, and first paint; compute p99 for each stage and total.

**Completion Criteria** Experiment is complete when: a sample rate is selected with zero block drops and CPU headroom ≥ 20%; total p99 latency is measured and a pass / fail verdict against QAS-1 (p99 ≤ 500 ms) is recorded; a go / no-go decision on 192k is documented; sample-rate normalization behavior in the adapter is confirmed (RISK-13).

---

## EXP-02 — Beat Detection Precision

**Key Question** Can the existing tick/tock detection algorithm locate beat events to within 0.1 ms precision against a known ground truth, and what is the downstream impact on rate, beat error, and amplitude if it cannot?

**Approach**
- Generate synthetic Sim signals across BPH (18000 / 21600 / 28800), SNR (∞ / 30 / 20 dB), and amplitude (180° / 270° / 310°).
- Run the beat-detection module and compare detected timestamps to known ground-truth values.
- Compute detection error p50 / p95 / p99 per condition.
- Propagate the worst-case timing error analytically through the rate and beat-error formulas.

**Completion Criteria** Experiment is complete when: onset error p95 is measured across all conditions; a pass / fail verdict is recorded against the 0.1 ms target; if the target is not met, a specific improvement or replacement plan for the detection algorithm is documented before Milestone 2.

---

## EXP-03 — Signal Quality Under Noise and AGC

**Key Question** Does the noise-filtering and beat-detection pipeline meet QAS-2 gates at SNR ≥ 30 dB, and does the system show "signal weak" — never a misleading value — below that threshold?

**Approach**
- Generate Sim signals at calibrated SNR levels: 50 / 40 / 30 / 20 / 15 dB.
- For each SNR level, run ≥ 1,000 beats and record detection rate, rate error, and display state (value vs. "signal weak").
- Repeat with AGC enabled to confirm signal distortion is detectable.
- Identify the SNR threshold where both QAS-2 gates (≥ 95% detection, ≤ ±3 s/d rate error) break.

**Completion Criteria** Experiment is complete when: detection rate and rate error are measured at each SNR level; the SNR threshold for "signal weak" is defined; it is verified that no numeric output appears below the threshold; the AGC-off environment checklist step is validated.

---

## EXP-04 — Display Consistency Across Simultaneous Views

**Key Question** Does every numeric readout and graph rendered in the same frame derive from a single shared measurement result, with zero mismatches over a 10-minute run?

**Approach**
- Instrument every display widget to log (frame ID, result ID, displayed value).
- Run 10 minutes of Sim/Playback on known input; collect all display logs.
- For each frame, verify all widgets share the same result ID.
- Compare displayed values for the same derived quantity across widgets within display rounding.

**Completion Criteria** Experiment is complete when: a mismatch count is recorded over a 10-minute run; a pass / fail verdict is recorded against the QAS-3 target of zero mismatches; if mismatches are found, the root cause (fan-out architecture vs. per-view local computation) is identified and a fix is proposed.

---

## EXP-05 — Extensibility Boundary Test

**Key Question** When a new filter or graph is added to the codebase, how many existing modules must be changed — and does the architecture stay within the QAS-4 target of ≤ 1 existing module?

**Approach**
- Choose a representative new feature (e.g., a moving-average filter or histogram display).
- Implement it fully; run `git diff --name-only` to list all touched files.
- Classify each touched file: new file (expected), existing common module (≤ 1 allowed), existing feature module (0 allowed).
- If > 1 existing module is changed, identify the coupling point and propose a redesign.

**Completion Criteria** Experiment is complete when: the module-touch count is recorded; a pass / fail verdict is recorded against the QAS-4 target (≤ 1 existing module changed, ≤ 8 person-days); a module dependency map of the baseline code is produced (RISK-16); if the target is missed, a specific refactoring plan for the acquisition–processing boundary is documented before Milestone 2.

---

## EXP-06 — Small-Screen Legibility and Touch Validation

**Key Question** Does the GUI layout on the 800×480 touchscreen simultaneously show rate, beat error, and amplitude at ≥ 2.9 mm character height with primary controls at ≥ 9 mm touch targets?

**Approach**
- Build the candidate layout and display it on the actual RPi5 panel (or accurate 116 PPI emulation).
- Measure uppercase letter height in the summary bar using a physical ruler or pixel-scale conversion (1 px ≈ 0.219 mm at 116 PPI on an 8-inch 800×480 panel).
- Measure the physical size of every primary touch control.
- Verify rate / beat error / amplitude are visible simultaneously without scroll or zoom.

**Completion Criteria** Experiment is complete when: character height and touch-target size are measured and recorded; a pass / fail verdict is recorded against the QAS-5 targets (≥ 2.9 mm, ≥ 9 mm, three values simultaneously visible); touch recognition reliability is confirmed or noted as OS-level fixed (RISK-14); if any criterion fails, the specific layout change required is documented and re-tested.

---

## EXP-07 — Long-Run Memory Stability

**Key Question** Do memory and disk usage remain bounded over a 24-hour continuous run, and is there a measurable growth trend that would lead to degradation or crash?

**Approach**
- Run the full pipeline on Playback input for 6 hours; log RSS, CPU, and latency p99 every minute.
- Fit a linear trend to RSS over the last 4 hours; flag as a leak if slope > 0.5 MB/h.
- If the 6-hour result is stable, extend to a 24-hour unattended run.

**Completion Criteria** Experiment is complete when: RSS growth rate is measured and classified as stable or leaking; a pass / fail verdict is recorded (stable = RSS growth < 0.5 MB/h, zero crashes, p99 latency does not degrade vs. first hour); buffer-cap and aggregation policy is defined and documented before Milestone 2.

---

## EXP-08 — Platform Portability and AGC Check

**Key Question** Does audio I/O behavior match between Windows (WASAPI) and Raspberry Pi OS (ALSA), and is AGC provably off and not distorting the signal?

**Approach**
- Run the same Playback file on Windows and on the RPi5; compare block timing, latency, and measurement output.
- Verify that the audio adapter layer abstracts all platform-specific behavior.
- Toggle AGC on and off; confirm that AGC-on degrades signal quality detectably and that AGC-off produces clean input.
- Document AGC-off and microphone-coupling verification as a mandatory environment checklist step.

**Completion Criteria** Experiment is complete when: timing and measurement output are compared across both platforms and any differences are recorded; the audio adapter is confirmed to handle all platform differences; the AGC-off check is validated and added to the environment checklist as a required pre-measurement step.
