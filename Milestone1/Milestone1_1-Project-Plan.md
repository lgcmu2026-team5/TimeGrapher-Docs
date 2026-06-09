# Project Plan

## Team Roles

- **Team Lead**: Sungjun Yoon
- **System (dataflow, pipeline)**: Junsung Kim, Jongdae Baek
- **Algorithm (functionality, calculation)**: Sunyoung Oh, Junyoung Park
- **GUI**: Jaehong Oh, Sungjun Yoon

## ARCHI-265 Schedule
🔗 [Quire URL](https://quire.io/w/SUNYOUNG_OH/40?filter=all&share=ud59lcpw1fx35wkwjcub6tdurt5iyg&view=timeline)

## Legend

- 🟡 In Progress
- ⬜ Planned
- ✅ Completed

## Schedule

- ✅ **Milestone 1** — `05.29 ~ 06.07`
  - ✅ Project Plan — `05.29 ~ 06.07`
  - ✅ **Architectural Drivers** — `05.29 ~ 06.07`
    - ✅ **Requirements Analysis** — `06.01 ~ 06.02`
      - ✅ Requirements Analysis Writing (FR-01) — `06.01 ~ 06.03` _(Assigned: YUN, JunSung, Junyoung Park, D, SUNYOUNG OH, Jaehong)_
    - ✅ QA Scenarios — `06.01 ~ 06.03` _(Assigned: YUN, JunSung, Junyoung Park, D, SUNYOUNG OH, Jaehong)_
  - ✅ **Risk Assessment** — `06.03 ~ 06.04`
    - ✅ List up Technical Risks — `06.05 ~ 06.07` _(Assigned: YUN, JunSung, Junyoung Park, D, SUNYOUNG OH, Jaehong)_
    - ✅ List up Non-Technical Risks — `06.05 ~ 06.07` _(Assigned: YUN, JunSung, Junyoung Park, D, SUNYOUNG OH, Jaehong)_
  - ✅ Planned Experiments — `06.06 ~ 06.07` _(Assigned: YUN, JunSung)_
  - ✅ **Architectural Approaches** — `06.07 ~ 06.08` _(Assigned: Jaehong, D)_
    - ✅ Describe Overview-level architecture _(Assigned: YUN, JunSung, Junyoung Park, D, SUNYOUNG OH, Jaehong)_
  - ✅ **Etc** — `05.28 ~ 06.07`
    - ✅ **Milestone 1 Preview Action Items** _(Assigned: YUN, JunSung, Junyoung Park, D, SUNYOUNG OH, Jaehong)_
- 🟡 **Milestone 2** — `06.08 ~ 06.22`
  - 🟡 Project Plan — `06.15` _(Assigned: JunSung)_
  - 🟡 **Experiments/Results** — `06.08 ~ 06.17`
    - 🟡 Verify real-time processing sample rate capability on RPi5 — `06.08 ~ 06.12` _(Assigned: Junyoung Park)_
    - 🟡 TinyML Inference — `06.08 ~ 06.15` _(Assigned: Jaehong)_
    - ⬜ Propose design patterns for real-time optimization (C++ vs C#) — `06.09 ~ 06.12` _(Assigned: JunSung, Jaehong)_
    - ⬜ Memory/latency degradation during long-term execution — `06.15 ~ 06.19` _(Assigned: D)_
    - ⬜ Touch recognition satisfaction — `06.09 ~ 06.10` _(Assigned: JunSung)_
  - ⬜ **Architecture** — `06.10 ~ 06.17`
    - ⬜ UML Diagram — `06.10 ~ 06.12` _(Assigned: YUN, SUNYOUNG OH)_
    - ⬜ Module View — `06.11 ~ 06.13` _(Assigned: YUN, SUNYOUNG OH, Jaehong)_
    - ⬜ C&C View — `06.13 ~ 06.15` _(Assigned: JunSung, YUN)_
    - ⬜ Allocation View — `06.15 ~ 06.17` _(Assigned: D, Jaehong)_
  - ⬜ Implement / Test — `06.11 ~ 06.21` _(Assigned: Jaehong, Junyoung Park, D)_
  - ⬜ Etc — `06.10 ~ 06.22`
- ⬜ **Milestone 3** — `06.23 ~ 06.30`
  - ⬜ Prepare Presentation — `06.23 ~ 06.26` _(Assigned: SUNYOUNG OH, YUN)_
  - ⬜ Prepare Demonstration — `06.26 ~ 06.30` _(Assigned: Jaehong, Junyoung Park, D)_

## Gantt Chart

### Milestone 1 — `05.28 ~ 06.08`

```mermaid
%%{init: {"gantt": {"useWidth": 1200, "barHeight": 24, "fontSize": 12, "sectionFontSize": 12}}}%%
gantt
    title Milestone 1 (Completed)
    dateFormat YYYY-MM-DD
    axisFormat %m.%d

    section Plan
    Project Plan                          :done, 2026-05-29, 2026-06-07

    section Drivers
    Architectural Drivers                 :done, 2026-05-29, 2026-06-07
    Requirements Analysis                 :done, 2026-06-01, 2026-06-02
    Requirements Analysis Writing (FR-01) :done, 2026-06-01, 2026-06-03
    QA Scenarios                          :done, 2026-06-01, 2026-06-03

    section Risk
    Risk Assessment                       :done, 2026-06-03, 2026-06-04
    List up Technical Risks               :done, 2026-06-05, 2026-06-07
    List up Non-Technical Risks           :done, 2026-06-05, 2026-06-07

    section Experiments
    Planned Experiments                   :done, 2026-06-06, 2026-06-07

    section Approaches
    Architectural Approaches              :done, 2026-06-07, 2026-06-08

    section Etc
    M1 Preview Action Items               :done, 2026-05-28, 2026-06-07
```

### Milestone 2 — `06.08 ~ 06.22`

```mermaid
%%{init: {"gantt": {"useWidth": 1200, "barHeight": 24, "fontSize": 12, "sectionFontSize": 12}}}%%
gantt
    title Milestone 2 (In Progress)
    dateFormat YYYY-MM-DD
    axisFormat %m.%d

    section Plan
    Project Plan                          :active, 2026-06-15, 1d

    section Experiments
    Verify RPi5 sample rate               :active, 2026-06-08, 2026-06-12
    TinyML Inference                      :active, 2026-06-08, 2026-06-15
    Design patterns for RT optimization   :2026-06-09, 2026-06-12
    Memory latency degradation            :2026-06-15, 2026-06-19
    Touch recognition satisfaction        :2026-06-09, 2026-06-10

    section Architecture
    UML Diagram                           :2026-06-10, 2026-06-12
    Module View                           :2026-06-11, 2026-06-13
    C&C View                              :2026-06-13, 2026-06-15
    Allocation View                       :2026-06-15, 2026-06-17

    section Implement
    Implement & Test                      :2026-06-11, 2026-06-21

    section Etc
    Etc                                   :2026-06-10, 2026-06-22
```

### Milestone 3 — `06.23 ~ 06.30`

```mermaid
%%{init: {"gantt": {"useWidth": 1200, "barHeight": 24, "fontSize": 12, "sectionFontSize": 12}}}%%
gantt
    title Milestone 3 (Planned)
    dateFormat YYYY-MM-DD
    axisFormat %m.%d

    section Wrap-up
    Prepare Presentation                  :2026-06-23, 2026-06-26
    Prepare Demonstration                 :2026-06-26, 2026-06-30
```

## Timeline

```mermaid
timeline
    title ARCHI-265 Schedule
    section Milestone 1 (05.29 ~ 06.07) ✅
        05.28 ~ 06.07 : ✅ M1 Preview Action Items
        05.29 ~ 06.07 : ✅ Project Plan
                      : ✅ Architectural Drivers
        06.01 ~ 06.03 : ✅ Requirements Analysis
                      : ✅ RA Writing (FR-01)
                      : ✅ QA Scenarios
        06.03 ~ 06.04 : ✅ Risk Assessment
        06.05 ~ 06.07 : ✅ List up Technical Risks
                      : ✅ List up Non-Technical Risks
        06.06 ~ 06.07 : ✅ Planned Experiments
        06.07 ~ 06.08 : ✅ Architectural Approaches
    section Milestone 2 (06.08 ~ 06.22) 🟡
        06.08 ~ 06.12 : 🟡 Verify RPi5 sample rate
        06.08 ~ 06.15 : 🟡 TinyML Inference
        06.09 ~ 06.10 : ⬜ Touch recognition satisfaction
        06.09 ~ 06.12 : ⬜ Design patterns for RT optimization
        06.10 ~ 06.12 : ⬜ UML Diagram
        06.10 ~ 06.22 : ⬜ Etc
        06.11 ~ 06.13 : ⬜ Module View
        06.11 ~ 06.21 : ⬜ Implement / Test
        06.13 ~ 06.15 : ⬜ C&C View
        06.15 : 🟡 Project Plan
        06.15 ~ 06.17 : ⬜ Allocation View
        06.15 ~ 06.19 : ⬜ Memory latency degradation
    section Milestone 3 (06.23 ~ 06.30) ⬜
        06.23 ~ 06.26 : ⬜ Prepare Presentation
        06.26 ~ 06.30 : ⬜ Prepare Demonstration
```
