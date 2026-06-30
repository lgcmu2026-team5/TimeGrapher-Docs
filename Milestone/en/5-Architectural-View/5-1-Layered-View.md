# TIMEGRAPHER LAYERED VIEW – Permission-Based Architecture

This view shows which layers are permitted to use which lower layers. It defines the *allowed* dependencies that govern every module dependency in the rest of the view set — not implementation details. It is the foundational constraint of the architecture: all other views must respect the directions established here.

![TimeGrapher layered view](../../assets/LAYER.png)

## Element Catalog

**Key concepts**

- **Relaxed Layering**: Upper layers can skip intermediate layers and use any lower layer they need.
- **Upward Dependency Forbidden**: Only downward flow is allowed (App → Core; never Core → App).
- **Sidecar Layer**: Common external utilities and frameworks are placed in a sidecar layer accessible by permitted layers.

**Layers**

- **Layer 1 – Entry Points & UI**: App (Avalonia UI), Verify (console), Test Suites.
- **Layer 2 – Platform Adapters**: WindowsAudio (NAudio), LinuxAudio (PipeWire / ALSA tools).
- **Layer 3 – Portable Core**: `TimeGrapher.Core` (analysis, detection, metrics — no external dependencies).
- **External dependency – External Tech** (sidecar): Avalonia, ScottPlot, NAudio, xUnit.

**Permission rules**

```text
App → Platform Adapters
App → Core
Platform Adapters → Core
App & Platform Adapters → External Tech
Core → Nothing (zero dependencies)
```

## Behavior

N/A. This is a static permission view; runtime interaction among these layers is documented in the [Run Lifecycle Sequence View](5-4-Run-Lifecycle-Sequence-View.md) and the [Run Lifecycle State Machine View](5-5-Run-Lifecycle-State-Machine-View.md).

## Related ADRs

- [ADR-004 — Separate App, Test, and Verify Module Structure](../ADR/ADR-004.md): establishes the module separation that the layer boundaries enforce.
- [ADR-001 — Switch the UI Framework to Avalonia UI + .NET + C#](../ADR/ADR-001.md): defines the External Tech placed in the sidecar layer.

## Related views

- [Module Uses View](5-2-Module-Uses-View.md) — refines these permission rules into the actual «use» dependencies between modules.
- [MVVM View](5-3-MVVM-View.md) — applies the downward-only rule inside the App.
