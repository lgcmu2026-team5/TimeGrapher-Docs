# Experiment 1 Results: RPi5 Rendering-Backend Performance A/B Measurement

- Experiment plan: [PLANNED_EXPERIMENTS.md](PLANNED_EXPERIMENTS.md)
- Target risk: R-A2 (with Avalonia, a bug could make GPU-accelerated rendering on the RPi5 slower than SW rendering, stuttering graph updates)
- Date: 2026-06-06 (Week-1 technical experiment, completed same day)

## One-line Conclusion

**The report did not reproduce in our app. GPU acceleration was actually faster than SW rendering, so the rendering setting stays at the default (GPU-first).**

## Experiment Environment

| Item | Value |
|------|----|
| Device | Raspberry Pi 5 (4-core Cortex-A76, 16 GB) |
| OS / session | Debian 13 (trixie), labwc (Wayland) via XWayland |
| Graphics driver | Mesa 25.0.7 (V3D) |
| Display / window size | 1280×800 monitor, app window 1280×722 (effectively full screen) |
| Workload | Sim mode (28800 bph) driving the real analysis→render pipeline, forcing a Rate/Scope graph redraw every composition frame |
| Measurement | Per backend: 5 s warmup + 30 s measurement, collecting frame-interval statistics |

## Measurement Results

| Rendering backend | GL renderer | FPS | mean | p50 | p95 | p99 | max |
|--------------|-----------|:---:|:---:|:---:|:---:|:---:|:---:|
| GLX (GPU-accelerated) | Broadcom V3D 7.1.10.2 | 59.2 | 16.9 ms | 16.4 ms | 18.6 ms | 21.0 ms | 476.7 ms* |
| EGL (GPU-accelerated) | Broadcom V3D 7.1.10.2 | 60.0 | 16.7 ms | 16.3 ms | 19.2 ms | 21.7 ms | 31.0 ms |
| Software (CPU) | — | 43.6 | 22.9 ms | 22.2 ms | 30.0 ms | 33.7 ms | 38.2 ms |

\* A one-off frame delay during the 30 s measurement (p99 is 21.0 ms, so judged a startup transient)

## Interpretation

1. **Both GPU-accelerated backends reached the display refresh ceiling (~60 Hz).**
   The 16.7–16.9 ms mean matches the vsync interval (16.7 ms); i.e. the GPU could go faster but is bound by the 60 Hz display.
   The reported "~80 ms accelerated" did not reproduce anywhere.
2. **True hardware acceleration was confirmed.**
   The GL renderer string was recorded as `V3D 7.1.10.2` (the RPi5's VideoCore GPU).
   Had it been the software fallback (llvmpipe), the measurement would have been invalid.
3. **SW rendering was actually slower** (43.6 fps, 22.9 ms mean) — the opposite direction of the report.
   That said, 43.6 fps still exceeds the 30 fps hardware-display bar, so any backend is sufficient for screen updates.
   Note that SW rendering is not vsync-synchronized (possible tearing) and uses more CPU, competing with the audio-analysis thread — another reason to keep the GPU default.

## Completion Criteria

| Completion criterion | Met |
|-----------|:---:|
| ① All three backends (GLX/EGL/Software) measured for 30 s | O |
| ② Hardware acceleration confirmed via the GL renderer string | O |
| ③ Backend recommendation derived | O |

## Action Items

1. **Do not change the rendering setting.** Keep the Avalonia default (GPU-first, Software fallback).

## Reference: Windows Measurement (same harness, same protocol)

To also cross-check the harness, we measured on a Windows dev PC (Intel Arc integrated GPU, 1280×750 window).
Windows is not the target of R-A2 and is for reference only.

| Rendering backend | GL renderer | FPS | mean | p50 | p95 | p99 |
|--------------|-----------|:---:|:---:|:---:|:---:|:---:|
| ANGLE (default, D3D11) | ANGLE Direct3D11 | 57.8 | 17.3 ms | 16.7 ms | 18.1 ms | 33.7 ms |
| WGL (direct OpenGL) | Intel Arc Graphics (GL 4.0) | 61.6 | 16.2 ms | 15.9 ms | 17.3 ms | 31.7 ms |
| Software (CPU) | — | 58.8 | 17.0 ms | 15.9 ms | 31.5 ms | 32.2 ms |

All three modes reached the display refresh ceiling (~60 Hz) — on Windows, no backend makes a difference.
Unlike the RPi5, Software also reaches 60 fps here because the desktop CPU is fast enough.
(The Windows default is ANGLE — a layer translating OpenGL calls to Direct3D11 — not GLX/WGL.)

## How to Reproduce

```bash
# On the RPi5 (after deploying a linux-arm64 self-contained publish)
DISPLAY=:0 ./TimeGrapher.App --render-bench --render-mode=glx      --bench-label=pi5-glx
DISPLAY=:0 ./TimeGrapher.App --render-bench --render-mode=egl      --bench-label=pi5-egl
DISPLAY=:0 ./TimeGrapher.App --render-bench --render-mode=software --bench-label=pi5-sw
# Results are printed to stdout as a single "RENDER_BENCH_RESULT {json}" line

# On Windows (reference measurement)
TimeGrapher.App.exe --render-bench --render-mode=angle    --bench-label=win-angle
TimeGrapher.App.exe --render-bench --render-mode=wgl      --bench-label=win-wgl
TimeGrapher.App.exe --render-bench --render-mode=software --bench-label=win-sw
```
