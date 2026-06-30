# TIMEGRAPHER DEPLOYMENT VIEW – Runtime Infrastructure

This view shows the runtime computing infrastructure for TimeGrapher: hardware nodes, the deployed application, the external signal path, and the connection properties used during measurement.

![Deployment view diagram](../../assets/deployment-view-detailed-en.svg)

## Element Catalog

**Runtime infrastructure**

1. **Mechanical Watch** produces the acoustic tick/tock signal.
2. **Watch Measurement Microphone** captures the signal as mono PCM audio at 48 kHz.
3. **Raspberry Pi 5** runs `TimeGrapher.App` on Raspberry Pi OS (`arm64`) with the bundled .NET 8 runtime.
4. **Approved AI Backend / Gemini** is an optional HTTPS path for AI explanation; local measurement does not depend on it.

**Key runtime properties**

- **Raspberry Pi:** Raspberry Pi 5, ARM64 OS, 16GB RAM.
- **Microphone:** watch measurement microphone, mono PCM at 48 kHz.
- **Runtime environment:** Raspberry Pi OS `arm64`, bundled .NET 8 runtime, Avalonia UI, PipeWire / ALSA tools, `TimeGrapher.App`.

## Behavior

N/A. This is a deployment/infrastructure view; the runtime measurement flow that executes on these nodes is documented in the [Run Lifecycle Sequence View](5-4-Run-Lifecycle-Sequence-View.md).

## Related ADRs

- [ADR-001 — Switch the UI Framework to Avalonia UI + .NET + C#](../ADR/ADR-001.md): rationale for the .NET 8 + Avalonia runtime that targets the Raspberry Pi 5 node.

## Related views

- [Layered View](5-1-Layered-View.md) — the layers whose binaries are deployed to this node.
