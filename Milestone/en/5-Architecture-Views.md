# TimeGrapher Architecture Views

> This is the architecture view set for TimeGrapher. Each view lives in its own file and follows the same [architecture view template](https://github.com/pmerson/architecture-view-template): **Primary Presentation → Element Catalog → Behavior → Related ADRs → Related views**.

## View Index

| # | View | What it shows |
|---|------|---------------|
| 5-1 | [Layered View](5-Architecture-Views/5-1-Layered-View.md) | Layer dependency rules — which layers may use which lower layers. |
| 5-2 | [Module Uses View](5-Architecture-Views/5-2-Module-Uses-View.md) | Actual «use» dependencies among project modules, plus the Core-internal decomposition. |
| 5-3 | [MVVM View](5-Architecture-Views/5-3-MVVM-View.md) | View / ViewModel / Model responsibility separation and one-way dependency. |
| 5-4 | [Run Lifecycle Sequence View](5-Architecture-Views/5-4-Run-Lifecycle-Sequence-View.md) | Runtime call sequence for the run lifecycle and measurement analysis loop. |
| 5-5 | [Run Lifecycle State Machine View](5-Architecture-Views/5-5-Run-Lifecycle-State-Machine-View.md) | Control state transitions (Stopped → Running ⇄ Paused → Stopping → StopFailed). |
| 5-6 | [Deployment View](5-Architecture-Views/5-6-Deployment-View.md) | Runtime hardware nodes, the deployed app, and the external signal path. |
| 5-7 | [Worker Pipeline View](5-Architecture-Views/5-7-Worker-Pipeline-View.md) | Worker-level Pipe-and-Filter runtime structure, including the optional TinyML signal-quality path. |

## View Categories

- **Module views (static structure):** Layered View, Module Uses View, MVVM View.
- **Runtime / behavior views:** Run Lifecycle Sequence View, Run Lifecycle State Machine View, Worker Pipeline View.
- **Deployment view:** Deployment View.

## How to Read This Set

Start with the **Layered View** for the foundational dependency rules, then the **Module Uses View** and **MVVM View** for the static structure that realizes them. The **Run Lifecycle** and **Worker Pipeline** views show runtime behavior, and the **Deployment View** shows the physical/runtime infrastructure. Each view's *Related views* section links to its neighbors, and *Related ADRs* link to the decisions that justify it.
