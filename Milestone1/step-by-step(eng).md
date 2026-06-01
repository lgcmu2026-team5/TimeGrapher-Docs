# Project Execution Scenario (Based on Milestone 1)

## 1. Project Context

- **Architecture Documentation**: None (only source code provided)
- **Scale**: Approximately 10K LOC / 6K SLOC — *excluding QCustomPlot library code*
- **Goal**: **Feature Addition — 10 features** (functional requirements). *This is the only project objective; future maintainability improvements are not goals.*
  - **Refactoring** is not a separate objective but rather a **means** to add the 10 features cleanly.
- **Core Nature**: Refactoring in this project is **"preparatory refactoring for feature addition"**. It is *not the goal* but a **localized means** to make it easier to implement specific features. → Therefore, repeat **by feature (group)**: "refactor the necessary area if needed → add that feature" iteratively. (Not refactoring everything in batch and then adding features all at once; features with no structural issues can be added directly without refactoring.)
- **Premise**: The scale is relatively small, so a *full Reconstruction first* sequential approach is practically feasible. However, **abstraction at the module level, not class level** to restore the structure.

---

## 2. Execution Scenario

### Step 1. Reconstruction (Understanding the As-Is)

- **Non-destructive observation** of the current structure through reverse engineering from the code.
- Deliverable: **Current functionality** + **Current structure**.
  - Current structure = *Constraint* and *refactoring target* for adding new features.
- Since it is non-destructive, it can be performed even before requirements analysis.
- Abstraction level: Module/Package (≈ 6~12 boxes). Do not expand classes directly.
- **Tool**: **Understand** (SciTools) — extract structure and hot spots *precisely* via dependency graphs, call graphs, and metrics.
  - Since the course emphasized **LLM limitations** (hallucinations, omissions, inability to reliably analyze the structure/dependencies of the entire codebase), structural and dependency facts for reconstruction are obtained from static analysis tools like Understand rather than LLMs.

### Step 2. Requirements Analysis → Deriving Architectural Drivers

The deliverable of requirements analysis is **Architectural Drivers**, which consists of the following:

#### Functional Requirements

- **The primary driver of this project.** The 10 features to be added + core existing features that *form the structure*.
- Understanding and organizing each feature *to the extent that design decisions can be made* is the core work of M1 (grading criterion: "Are functional requirements well understood?").
- **Classification of 10 features**: ① Features that *require refactoring because they impact structure* vs features that *can be implemented directly*, ② Features that share structural concerns clustered together (e.g., "add new chart type" types N). → This classification determines both the "feature types" and the refactoring scope in the Modifiability scenario below.

#### Quality Attribute Requirements

- Modifiability — **limited to adding these 10 features** (future general maintainability is not a goal). Expressed as **measurable scenarios** tailored to the *feature types* clustered above.
- Example: "When 〔feature type A〕 is added, only 〔module X〕 needs to be modified for integration within an average of N days".
- Not abstractly "maintain well" but **concretely localize impact when adding these 10 features**.

#### Constraints

- Existing architecture structure identified in Step 1.

#### Prioritization

- Set priorities among the 10 features + quality attributes.

> ⚠️ **The "Why" of Refactoring = To add these 10 features cleanly.** Functional requirements drive the direction of refactoring. Drivers contain *functional requirements + Modifiability drivers* that justify refactoring, not *refactoring itself*. The actual refactoring design emerges in Step 4 (Approaches).

### Step 3. Rough Approaches Sketch ↔ Risk / Experiment (Loop)

Not a linear phase but an **iterative loop**.

1. "To add these 10 features, how must we change the existing structure?" — Conceive candidate patterns and tactics (notional approaches = preparatory refactoring design).
2. Identify **uncertain/risky points** against the drivers. (Both functional and non-functional)
   - Feature addition risks: "Feature 〔K〕 cannot be implemented on the existing structure / requires major changes", "Some feature requirements are unclear", "Feature conflicts", "External dependency integration difficulty (e.g., QCustomPlot)", "Feature addition degrades performance/memory"
   - Refactoring/reconstruction risks: "Legacy refactoring without tests → regression risk", "Existing structure resists the intended refactoring", "Module X not yet fully understood"
   - Schedule/Scope: "10 features + refactoring incomplete within deadline"
3. Resolve large risks with **technical experiments (spikes)**.
   - Example: "Implement feature 〔K〕 as a small prototype to verify feasibility on the existing structure", "On a branch with module X refactored using pattern Y, measure whether adding the target feature touches only that module", "Attach characterization tests to verify behavior preservation"
4. **Refine** the approach based on experimental results → Return to step 1 and loop.

> The **to-be design of refactoring takes shape in this loop.** To design an experiment, at least rough approaches must exist first to target them.

### Step 4. Finalize Architectural Approaches

- When the loop stabilizes (risks become acceptable), **design decisions** mapped to drivers are finalized.
- This design decision = **Refactoring to-be structure + Design for adding 10 features on top**. → The **center** of architectural-level design content.
- For each approach, explicitly state *which driver (functionality / Modifiability) it satisfies and how*.

### (Parallel) Project Plan

- Separately from the above flow, incorporate actual **construction tasks** (by feature: refactor necessary area → add that feature), sequence, roles, and timeline into the plan.
- Sequence principle: By feature (group), repeat "refactor necessary area → add that feature" (not in batch; features with no structural issues can be added directly).

---

## 3. Milestone 1 Deliverables Mapping

| M1 Deliverable | Scenario Step | Key Content |
|---|---|---|
| 1. Project Plan | Parallel | Roles, tasks, timeline, construction tasks (by feature: refactor necessary area → add), experiment plan |
| 2. Architectural Drivers | Step 2 | **10 features** + Modifiability (measurable) + constraints + prioritization |
| 3. Risk Assessment | Step 3 | Project-wide functional/non-functional risks — **feature addition (implementation difficulty, unclear requirements, conflicts, integration), refactoring (regression, resistance), reconstruction (insufficient understanding), schedule** — as probability and impact (H/M/L) |
| 4. Planned Experiments | Step 3 | Spikes to validate uncertain approaches (questions and completion criteria specified) |
| 5. Architectural Approaches | Step 4 | Design decisions mapped to drivers (refactoring to-be + feature addition design) |

---

## 4. Where Refactoring Fits

Refactoring does not fit in a single slot but **is distributed across multiple dimensions**.

| Dimension | Location |
|---|---|
| Why (motivation) | Architectural Drivers (2) — **Adding 10 features** + Modifiability drivers for this |
| What to change to (to-be design) | **Architectural Approaches (5) — the center** |
| What could go wrong | Risk Assessment (3) |
| Validate uncertain refactoring | Planned Experiments (4) |
| When, who, concrete tasks | Project Plan (1) |

---

## 5. Core Principles / Caveats

- **Refactoring for Feature Addition**: Refactoring is not a goal but a *localized means to easily add 10 features*. **By feature (group)**, repeat "refactor necessary area if needed → add that feature" iteratively; features with no structural issues can be added directly without refactoring.
- **Observation vs. Intervention**: Reconstruction is *observation (non-destructive)*, so it can be done before requirements analysis, but Refactoring is *intervention (modification)*, so it is done after understanding drivers and requirements (which features to add).
- **M1 is the Planning Phase**: Actual code refactoring/feature addition execution is in construction *after* experiments validate it. M1 documents contain "this is how we reconstructed it → this is the driver (10 features + Modifiability) → this is how we'll refactor/design → these are the risks and how we'll validate them". (Actual code ✕)
- **Approaches ↔ Risk/Experiment is a Loop**: Not a clean linear sequence but co-evolution. The Approaches finalized in the document are the output of this loop, so they come later in the table of contents (Step 5).
- **Viewtype / Style Confirmation is a Later Phase**: Actual view documentation comes after this loop stabilizes. Outside the M1 scope.
