# TIMEGRAPHER ARCHITECTURE VIEWS

> This is the architecture view set for TimeGrapher. Each view lives in its own file and follows the same [architecture view template](https://github.com/pmerson/architecture-view-template): a primary presentation (diagram) followed by **Element Catalog → Behavior → Related ADRs → Related views**.

## View Index

| # | View | What it shows |
|---|------|---------------|
| 5-1 | [Layered View](5-Architectural-View/5-1-Layered-View.md) | Permission-based layering — which layers may depend on which (the foundational dependency constraint). |
| 5-2 | [Module Uses View](5-Architectural-View/5-2-Module-Uses-View.md) | Actual «use» dependencies among project modules, plus the Core-internal decomposition. |
| 5-3 | [MVVM View](5-Architectural-View/5-3-MVVM-View.md) | View / ViewModel / Model responsibility separation and one-way dependency. |
| 5-4 | [Run Lifecycle Sequence View](5-Architectural-View/5-4-Run-Lifecycle-Sequence-View.md) | Runtime call sequence for the measurement analysis loop (Level 1 / Level 2). |
| 5-5 | [Run Lifecycle State Machine View](5-Architectural-View/5-5-Run-Lifecycle-State-Machine-View.md) | Control state transitions (Stopped → Running ⇄ Paused → Stopping → StopFailed). |
| 5-6 | [Deployment View](5-Architectural-View/5-6-Deployment-View.md) | Runtime hardware nodes, the deployed app, and the external signal path. |

## View Categories

- **Module views (static structure):** Layered View, Module Uses View, MVVM View.
- **Runtime / behavior views:** Run Lifecycle Sequence View, Run Lifecycle State Machine View.
- **Deployment view:** Deployment View.

## How to Read This Set

Start with the **Layered View** for the foundational dependency rules, then the **Module Uses View** and **MVVM View** for the static structure that realizes them. The two **Run Lifecycle** views show runtime behavior (call sequences and control states), and the **Deployment View** shows the physical/runtime infrastructure. Each view's *Related views* section links to its neighbors, and *Related ADRs* link to the decisions that justify it.
