# TimeGrapher Layered View - Dependency Rules

This view shows which layers may use which lower layers. It defines the dependency rules that govern the rest of the view set; implementation-level module dependencies are documented in the [Module Uses View](5-2-Module-Uses-View.md).

## Primary Presentation

![TimeGrapher layered view](../../assets/LAYER.png)

## Element Catalog

**Key concepts**

- **Direct lower-layer use**: Upper layers may use any lower layer when the dependency direction remains downward.
- **Upward Dependency Forbidden**: Only downward flow is allowed (App → Core; never Core → App).
- **Sidecar Layer**: Common external utilities and frameworks are placed in a sidecar layer accessible by permitted layers.

**Layers**

- **Entry Points & UI**: App (Avalonia UI), Verify (console), Test Suites.
- **Platform Adapters**: WindowsAudio (NAudio), LinuxAudio (PipeWire / ALSA tools).
- **Portable Core**: `TimeGrapher.Core` (analysis, detection, metrics — no external dependencies).
- **External dependency – External Tech** (sidecar): Avalonia, ScottPlot, NAudio, xUnit.

**Dependency rules**

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
