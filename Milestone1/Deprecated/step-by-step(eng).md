# Project Execution Scenario (Based on Milestone 1)

## 1. Project Context

- **Architecture Documentation**: None — only source code is provided; the baseline architecture is not given.
- **Scale**: Approximately 10K LOC / 6K SLOC — *excluding QCustomPlot library code*. A relatively small codebase.
- **Goals (Two Axes)**
  - **Functional requirements**: Add the **10 mandatory features**.
  - **Quality requirements**: Improve the **quality attributes** (performance, modifiability, etc.) surrounding the added/existing features. → *Do not focus only on features.* (Professor's feedback: "the context is too focused on the features." Quality requirements always accompany the features.)
- **Educational Goal (most important)**: This studio project is a *mechanism* for practicing **software architecture activities** rather than the product itself — eliciting quality attribute requirements, choosing tactics (tactics), discussing trade-offs, exploring/mitigating technical risks, etc. The objective is **not** to build a "killer product with all features and a nice GUI," but to **properly understand architecture-related practices.**
- **Real-World Goal (Demo)**: Five teams implement the same assignment and give a final **demonstration**. Making a **product that runs well and does not break during the demo** to please the customers (Dan · Steve · Jason) is a natural prerequisite. (Must be met, independent of the educational goal.)
- **Position of Refactoring**: Refactoring is not a goal in itself but a *means* to add features cleanly through **better code structure**. → Therefore, repeat **by feature (group)**: "refactor only the necessary area → add that feature." (Not refactoring everything in batch then adding all at once; features with no structural issues can be added directly without refactoring.)

---

## 2. Execution Scenario

### Preliminary Work. Understanding the Baseline Code (As-Is) — *Informal · Non-Deliverable*

- Understand the existing code as the **starting point** for building new features on top. However, **this is not a milestone deliverable.**
- **Method (professor's recommendation)**: Rather than auto-extracting the structure from code with a tool, **browse and explore the code directly in the IDE**. Since the codebase is small, skim it to grasp the structure rather than reading line by line, and if needed, **draw a few boxes yourself** — this is more useful than running a tool.
- **Why not rely on tool auto-extraction**: Mechanically extracting structure from code produces a *white noise* diagram with too many boxes, because the tool cannot distinguish the *architectural relevance* of code modules (which modules are structurally central vs. mere utilities). Refining that into a meaningful diagram takes great effort and iteration, and **does not directly help the milestones.** → Do it lightly only when helpful; don't spend much time on it.
- **Understand tool**: Use is *optional*. Automated technical-debt/violation analysis is not needed for this evaluation. (The technical-debt analysis that was actually run did not work due to an *"Unable to find a VS installation"* configuration error, so its "0 violations / 0 technical debt" numbers were meaningless.) Obtain structural/dependency understanding by **reading the code directly.**
- **The architecture document we will produce is for "our solution"**: The software architecture description required in M2/M3 targets **our solution (added/restructured on top of the existing code), not the baseline.** Documenting the baseline architecture is not an M1/M2 requirement.

### Step 1. Requirements Analysis → Deriving Architectural Drivers

The deliverable of requirements analysis is **Architectural Drivers**, consisting of the following:

#### Stakeholders / Customers

- **Stakeholder** = anyone interested in the project (general term).
- **Customers**: **Dan · Steve · Jason** (the solvent side). They receive the product.
- **Dan's dual role**: both a **technical consultant** for the baseline implementation and a **customer**.

#### Functional Requirements

- **The primary driver of this assignment.** The 10 features to add + core existing features that *form the structure*.
- Understanding/organizing each feature *enough to judge the design* is the core M1 work (grading criterion: "Are functional requirements well understood?").
- **Classification of the 10 features**: ① Features that *require refactoring because they touch structure* vs features that *can be implemented directly*; ② Cluster features that share structural concerns (e.g., N features of the "add new chart type" kind). → This classification jointly determines the "feature types" in the Modifiability scenarios below and the refactoring scope.

#### Quality Attribute Requirements

- Express **Performance, Modifiability**, etc. as **testable/measurable scenarios** (stimulus → response → response measure).
- Modifiability — tailored to the *feature types* clustered above: e.g., "When 〔feature type A〕 is added, only 〔module X〕 is modified and integrated within an average of N person-days." Not abstract "maintain well," but **concretely localizing impact when adding the feature types in scope.**
- **Authoring procedure (professor's recommendation)**: Asking customers to "give us the QA requirements" rarely works. → **We draft first** the reasonable, *measurable* scenarios (with values) as short sentences, then ask the customers to **review**: **"Is this correct? Any values that should change?"** (Customers are better at reviewing than creating.) → **Capture it in writing as soon as possible** (before the deadline).
- **On the subjectivity of the response measure**: A value like "10 person-days" looking subjective is a common comment. But *effort* is in fact **measurable** — when a new change request later comes in, you measure the time spent. Setting a reasonable value takes organizational/team experience (an experienced architect has a sense of "what is doable in 10 person-days in this environment/team"), and a design that makes plugging easy (e.g., the micro-kernel pattern) makes that value achievable.

#### Constraints

- **Hardware**: Must run on the **Raspberry Pi 5**.
- **OS**: Must run on **both Windows and Linux** (cross-platform).
- (+ The existing structure identified in the preliminary work also constrains new features.)

#### Prioritization

- Set priorities among the 10 features + quality attributes (H/M/L).

> ⚠️ **The "Why" of refactoring = to add these 10 features cleanly and satisfy the quality attributes.** Drivers contain not *refactoring itself* but the *functional requirements + quality (Modifiability·Performance) drivers* that justify it. The actual refactoring design takes shape in the Step 2 loop and is organized in Step 3 (as *candidate* approaches for M1); final confirmation happens in M2/M3.

### Step 2. Rough Approaches Sketch ↔ Risk / Experiment (Loop)

Not a linear phase but an **iterative loop**. (※ This is a simple risk-driven process and is **not following ADD (Attribute-Driven Design)** — no need to read or apply ADD.)

1. "To add these 10 features and meet the quality goals, how must we change the existing structure?" — conceive candidate patterns/tactics (notional approaches).
2. Identify **uncertain/risky points** against the drivers. **Risk = a question mark** — a point where "we're not sure this idea/tactic will work." (Both functional and non-functional.)
   - Feature-addition risks: "Feature 〔K〕 cannot be implemented on the existing structure / needs major changes," "some feature requirements are unclear," "feature conflicts," "difficulty integrating external dependencies like QCustomPlot," "feature addition degrades performance/memory."
   - Refactoring risks: "legacy refactoring without tests → regression risk," "the existing structure resists the intended refactoring," "module X not yet fully understood."
   - Schedule/Scope: "10 features + refactoring not finished within the deadline."
3. Resolve large risks with **technical experiments (spikes / prototypes / proof-of-concept)**. Two forms:
   - (a) **Validate an idea**: "Implement feature 〔K〕 as a small prototype to check feasibility on the existing structure," "build a prototype with multithreading to test a 2x performance improvement."
   - (b) **Compare alternatives**: when unsure which of two options is better, build both and choose by data. E.g., "receiving audio data from a buffer vs. a stream — measure performance/accuracy of both prototypes and pick one."
   - Record experiment information following a **template** (state the question and completion criteria).
4. **Refine** the approach with experiment results → return to step 1 and loop.

> The **to-be refactoring design takes shape in this loop.** To design an experiment, at least rough approaches must exist first to give it a target.

### Step 3. Final Architectural Approaches

- When the loop stabilizes (risks become acceptable), organize the **design decisions** mapped to the drivers.
- **M1 scope**: Merely **mentioning** the architectural approaches *under consideration* is sufficient (professor's recommendation). Final confirmation and view documentation are for M2/M3.
- This design decision = **the refactoring to-be structure + the design for adding the 10 features on top** → the **center** of the architectural-level design. For each approach, state *which driver (functional / quality) it satisfies and how.*

### (Parallel) Project Plan

- Separately from the above flow, incorporate the actual **construction tasks** (by feature: refactor the necessary area → add that feature), sequence, roles, and timeline.
- Sequencing principle: by feature (group), repeat "refactor necessary area → add that feature" (not in batch; features with no structural issues are added directly).

---

## 3. Milestone 1 Deliverables Mapping

> Document structure recommended by the professor: **(0) Introduction / Project Context → (1) Requirements (functional + quality) → (2) Risks & Experiments → (3) Architectural Approaches (mention those under consideration)**. Architecture documents/diagrams of the baseline are not required.
>
> *The (0)–(3) above is the professor's **4-part document skeleton**, while the 0–5 numbers in the table below are a separate numbering that expands it into **6 deliverables** (Requirements = Architectural Drivers (2), Risks & Experiments = Risk Assessment (3) + Planned Experiments (4), Approaches = (5); Project Plan (1) is a parallel item). All parenthesized numbers in the body and §4 refer to the **table numbers below.***

| M1 Deliverable | Scenario Step | Key Content |
|---|---|---|
| 0. Introduction / Project Context | §1 | Project context (summary), two-axis goals (functional + quality), customers |
| 1. Project Plan | Parallel | Roles, tasks, timeline, construction tasks (by feature: refactor necessary area → add), experiment plan |
| 2. Architectural Drivers | Step 1 | **10 features** + quality (Modifiability·Performance, measurable) + constraints + prioritization |
| 3. Risk Assessment | Step 2 | functional/non-functional risks — **feature addition (implementation difficulty, unclear requirements, conflicts, integration), refactoring (regression, resistance), insufficient code understanding, schedule** — as impact·probability **H/M/L** |
| 4. Planned Experiments | Step 2 | Spikes that validate uncertain approaches (state question and completion criteria) |
| 5. Architectural Approaches | Step 3 | *Candidate* design approaches mapped to drivers (refactoring to-be + feature-addition design) |

> **Risk ranking notation (professor's recommendation)**: Prefer **H/M/L** (plus N/A if needed) for impact·probability. Numeric (0–10, etc.) scores are also allowed *if* you can justify each value (e.g., a domain with objective figures like a "30%" weather forecast), but in this project it is hard to explain "why 7 and not 8." → Use **H/M/L** because it is simple and easy to justify (per risk-management literature). Rank along the two axes of *impact × probability.*

---

## 4. Where Refactoring Fits

Refactoring does not fit in a single slot but **is distributed across dimensions**.

| Dimension | Location |
|---|---|
| Why (motivation) | Architectural Drivers (2) — **Adding 10 features** + the quality (Modifiability·Performance) drivers for it |
| What to change to (to-be design) | **Architectural Approaches (5) — the center** |
| What could go wrong | Risk Assessment (3) |
| Validate uncertain refactoring | Planned Experiments (4) |
| When, who, concrete tasks | Project Plan (1) |

---

## 5. Core Principles / Caveats

- **Refactoring for feature addition**: Refactoring is not a goal but a *localized means to add features easily*. **By feature (group)**, repeat "refactor only the necessary area if needed → add that feature"; features with no structural issues are added directly.
- **Baseline analysis is a non-deliverable**: Auto-extracting/documenting the existing architecture with a tool is not an M1/M2 requirement and does not directly help the milestones. Gain code understanding by **reading directly**, and don't spend time on automated analysis.
- **Code comprehension (observation) vs. refactoring (intervention)**: Code comprehension is *non-destructive observation*, so it may be done before requirements; but refactoring is *intervention (modification)*, so it is done after understanding the drivers/requirements (which features to add).
- **QA scenarios: we draft first → customers review**: We draft with measurable values and have the customers (Dan · Steve · Jason) review. **Capture in writing as soon as possible.**
- **Risk ranking is H/M/L**: Numeric scores are possible if justifiable, but in this project justification is hard, so use the 3 levels (+ N/A if needed) — simple and easy to justify.
- **Not following ADD**: The risk/experiment process is simple — take the baseline as the starting point, look at the requirements, and resolve question marks (risks) with experiments.
- **M1 is the planning phase**: Actual code refactoring/feature addition happens in construction *after* experiments validate it. M1 documents contain "the drivers (10 features + quality) are these → we'll refactor/design like this (under consideration) → the risks are these and we'll validate them this way." (No actual code.)
- **Approaches ↔ Risk/Experiment is a loop**: Not a clean sequence but co-evolution. The Approaches finalized in the document are the output of this loop, so they come later in the table of contents (Step 5).
- **Our solution's architecture document**: The architecture description produced in M2/M3 targets our solution, not the baseline.
- **Viewtype / style confirmation is a later phase**: Actual view documentation comes after this loop stabilizes. Outside M1 scope.
