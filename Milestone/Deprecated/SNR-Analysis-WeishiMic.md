# SNR Analysis — WeiShi-Mic Test Recordings

> Empirical basis for the QAS-5 SNR threshold (referenced as **G6** in `Milestone1_QA_draft2.md`).
> Source data: `../../TimeGrapher/TimeGrapherTestFilesWeishiMic/` (9 WAV files, mono IEEE-float32, 48/96/192 kSPS).
> Analysis date: 2026-06-03.

## Method (matches the QAS-5 SNR definition)

1. Read each WAV (RIFF parsed directly; format tag 3 = IEEE float32, mono), remove DC.
2. Compute a **1 ms non-overlapping RMS envelope**.
3. **Signal level S** = median over beat periods of the per-period peak 1-ms window RMS.
   Beat period from the filename BPH: `period_ms = 3,600,000 / BPH` (28,800 → 125 ms; 21,600 → 166.7 ms; 18,000 → 200 ms).
4. **Noise level N** = 20th percentile of all 1-ms window RMS values (inter-beat ambient floor; 10th percentile also computed as a robustness check).
5. **SNR = 20·log₁₀(S/N)**. "Weak-beat SNR" uses the 10th-percentile beat peak instead of the median (worst beats are what detection must survive).

Analysis script: `/tmp/snr_analysis.py` (pure Python, no external deps; results also in `/tmp/snr_results.json`).

## Results

| File | fs (SPS) | Duration | Beats | SNR (median beat / 20th-pct noise) | Weak-beat SNR (10th-pct beat) |
|------|---------:|---------:|------:|-----------------------------------:|------------------------------:|
| 18000BPH_Watham.wav | 48,000 | 45.9 s | 229 | 50.1 dB | 49.3 dB |
| 21600BPH_8215_InCase.wav | 48,000 | 44.1 s | 264 | **33.4 dB (worst)** | **30.4 dB** |
| 21600BPH_8215_jubilee.wav | 192,000 | 46.1 s | 276 | 49.1 dB | 46.5 dB |
| 21600BPH_NH35.wav | 48,000 | 45.5 s | 272 | 40.3 dB | 37.8 dB |
| 21600BPH_NH39A.wav | 48,000 | 46.8 s | 280 | 41.8 dB | 40.3 dB |
| 21600BPH_ST3600.wav | 48,000 | 45.3 s | 271 | 50.9 dB | 50.1 dB |
| 28800BPH_3135_hulk.wav | 48,000 | 45.9 s | 366 | 50.1 dB | 48.2 dB |
| 28800BPH_3235_FreeSprung.wav | 48,000 | 31.1 s | 248 | 46.5 dB | 43.8 dB |
| 28800BPH_3235_Starbucks.wav | 96,000 | 45.0 s | 360 | 48.5 dB | 46.4 dB |

**Summary:** median-beat SNR min **33.4** / median **48.5** / max **50.9 dB**; weak-beat SNR min **30.4** / median **46.4** / max **50.1 dB**.

## Definition Sensitivity — reconciling the "~15 dB worst sample" reading

The same data yields radically different SNR values under different (all plausible) definitions. Computed on identical files:

| File | Peak-based (QAS-5 definition: median per-beat peak / p20 floor) | Whole-signal RMS / p20 floor ("simple RMS") | p95 envelope / p20 floor |
|------|----:|----:|----:|
| 18000BPH_Watham | 50.1 dB | 32.8 dB | 37.4 dB |
| 21600BPH_8215_InCase | 33.4 dB | **15.1 dB** | 16.2 dB |
| 21600BPH_8215_jubilee | 49.1 dB | 30.5 dB | 31.9 dB |
| 21600BPH_NH35 | 40.3 dB | 21.7 dB | 23.7 dB |
| 21600BPH_NH39A | 41.8 dB | 22.7 dB | 24.8 dB |
| 21600BPH_ST3600 | 50.9 dB | 35.6 dB | 42.9 dB |
| 28800BPH_3135_hulk | 50.1 dB | 33.6 dB | 38.6 dB |
| 28800BPH_3235_FreeSprung | 46.5 dB | 29.5 dB | 34.1 dB |
| 28800BPH_3235_Starbucks | 48.5 dB | 30.2 dB | 31.7 dB |
| **Minimum** | **33.4 dB** | **15.1 dB** | **16.2 dB** |

If you have seen the claim "the weakest sample is ≈ 15 dB by a simple envelope/RMS measure", that is the **whole-signal-RMS metric** (15.1 dB reproduced here) — ~18 dB below the peak-based reading of the *same file*, because the watch signal is impulsive (low duty cycle).

**Why "SNR ≥ 14 dB = 1 dB below the observed sample minimum" is NOT a sound rationale:**
1. Under the RMS metric, 14 dB sits essentially *at the clean-recording floor* — the QAS-5 "noisy/degraded" acceptance condition would then test nothing beyond clean conditions (zero degradation margin), gutting the noise-robustness claim.
2. The "signal weak" suppression clause would cut in just 1 dB below a perfectly measurable clean capture (InCase has 33 dB of impulse-peak headroom) — risking suppression of valid signals on minor coupling variation.
3. The baseline detector thresholds on **peak vs noise floor** (onset_fraction × span above floor — `Detector.cpp`), not on total RMS; and the whole-RMS metric is duty-cycle (BPH) dependent. The peak-based definition is the detection-relevant one, which is why QAS-5 pins it.
4. The InCase file is worst because of **weak mechanical coupling** (in-case capture), not ambient noise — a clean-floor-minus-1-dB number is a category error as a *noise-environment* threshold.

This definition gap (~18 dB on identical data) is precisely why QAS-5 pins the SNR definition operationally (review finding G6/X3).

## Conclusions

1. **Clean WeiShi contact-mic captures sit at 30–51 dB SNR** — far above the QAS-5 threshold. The 14 dB figure is therefore *not* the SNR of the recordings themselves; it represents a **severely degraded condition ≥ 16 dB below the worst clean capture** (30.4 dB weak-beat). This is the correct way to cite it.
2. Cross-check vs the simulator: the Sim's *realistic* mode injects noise at peak ratio ≈ 45 dB (pcm_peak 0.40 — `MainWindow.cpp:1383` / noise_peak 0.0022 — `WatchSynthStream.cpp:147`, band-limited 700 Hz–18 kHz — `:119-120`); *clean* config ≈ 58 dB (noise 0.0005 — `:83`). Both are consistent with the measured recordings — reaching 14 dB for QAS-5 verification **requires deliberate noise injection**, as the QAS-5 environment specifies.
3. Side findings: the recordings span **48k / 96k / 192k SPS** (empirical support for the C-6 operating points), and carry **229–366 beats per ~45 s** — so the QAS "≥ 1,000 beats" sample needs ≈ 2.1–3.3 min of capture (125/166.7/200 s at 28,800/21,600/18,000 BPH), which is feasible.
4. The worst-SNR file (`21600BPH_8215_InCase`) is the in-case capture — physical coupling, not ambient noise, dominates the SNR spread across these files.
