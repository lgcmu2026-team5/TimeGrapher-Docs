# JD Documentation Work Package

This folder contains the JD documentation work package discussed on 2026-06-20.

## Files

- `MODULE_USES_VIEW_JD.md`: module uses / dependency view draft for TimeGrapher.
- `ADR-002-partial-pipe-and-filter.md`: ADR draft explaining why TimeGrapher uses a partial Pipe-and-Filter style instead of a fully concurrent pipeline.

## Scope

- The diagram scope is runtime source structure.
- The view starts with project-level dependencies, then refines into folder/module-level dependencies.
- It intentionally does not list every `.cs` file.
- `bin/`, `obj/`, generated files, and publish outputs are excluded.
