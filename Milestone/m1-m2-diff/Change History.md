# Change History

## Comment Follow-up Status

| Comment excerpt | Follow-up | Milestone/en section |
|---|---|---|
| "The project plan is a very dynamic document. As progress is made it should (ideally) be updated. You have redundant plan information. There are mermaid segments, then there's the plan in Quire, and there's a text version in the md file. That creates excessive maintenance burden that can lead to inconsistencies. It also creates confusion to the reader. The plan should be in one place (e.g., quire)." | Kept the detailed WBS in Quire; kept only the Quire link and notation guide in the milestone document. | `1-Project-Plan.md` > `Legend (timeline-based)` |
| "I'm looking at the quire WBS. You could keep it, but I suggest: please keep it English only, in the main doc give some explanation about the notation (colors, curved lines), make sure the user names are not in Korean." | Updated project-plan names/labels to English and also updated Quire assignee naming to `Jae-hong`. | `1-Project-Plan.md` > `Team Roles`<br>`1-Project-Plan.md` > `Legend (timeline-based)` |
| "Tasks for implementation were missing in the plan when we had M1 interviews." | Added implementation planning and G01-G12 task entries for Milestone2. | `2-Architectural-Drivers.md` > `Functional Requirements` |
| "For each QA scenario, you are showing \"Related requirements\". I think you should say \"Related requirements in the project description\" for clarity. That's what it is, right? For each QAS you also have a list of related FRs. These are your own FRs. If the team sees value in creating that list, OK. But keep in mind you create the burden of updating the list if FRs change." | Renamed the QAS related-requirements label and reduced FR cross-reference maintenance burden. | `2-Architectural-Drivers.md` > `Quality Attribute Scenarios` |
| "Good to see QAS-1 was updated from 500 to 83/125ms." | Updated latency target to beat-period-based budgets. | `2-Architectural-Drivers.md` > `QAS-2 · Performance (Latency)` |
| "For ease of reference, the prioritization could be informed where the QA scenario is described instead of a separate section." | Moved QAS priority/rationale into each QAS section. | `2-Architectural-Drivers.md` > `Quality Attribute Scenarios` |
| "For consistency you should say technical experiment instead of spike when they mean the same thing. Same for \"PoC\". By the way, my impression is that GenAI is creating a good chunk of the documentation. Ok, but try to give it some directions to promote consistency. Maybe have that in the AGENTS.md file if using the IDE agent." | Standardized milestone wording on `technical experiment`. | `4-Planned-Experiments.md` > `Terminology` |
| "In the Risk-Assessment document, you can remove the section header \"APPENDIX\". That's NOT an appendix, it's the main part of that document. Also, in the summary table, the red dot is fine but it should be after the ID." | Removed APPENDIX wording and moved planned-experiment marker after the risk ID. | `3-Risk-Assessment.md` > `Risk Summary` |
| "Days ago, the team seemed determined to use C# and Avalonia. Looking at the documentation, the decision is not clear. This uncertainty at this point of the project is a major risk. However, that is listed as a risk. Why?" | Clarified .NET/C# + Avalonia decision through experiment results and ADR-001. | `ADR-001.md` > `Decision`<br>`4-Planned-Experiments.md` > `EXP-01`<br>`4-Planned-Experiments.md` > `EXP-02` |
| "Rich description. However, the feeling is the team is a little behind in finding answer for technical risks with the experiments. EXP-03 is an example." | Expanded EXP-03 with the selected real-time GUI architecture strategy. | `4-Planned-Experiments.md` > `EXP-03: GUI real-time rendering design patterns` |
| "Several of the patterns listed can enhance modifiability and extensibility. That's good, but mind the high priority QA rmts." | Kept QAS-1 Accuracy and QAS-2 Performance as top-priority drivers. | `2-Architectural-Drivers.md` > `QAS-1 · Accuracy`<br>`2-Architectural-Drivers.md` > `QAS-2 · Performance (Latency)` |
| "In your git repo, your files should not say \"Milestone1\". So, instead of \"Milestone1_1-Project-Plan.md\" it should be \"1-Project-Plan.md\". These files can be updated continuously until the end of the project. You should not copy & paste to other files with prefix \"Milestone2\" and \"Milestone3\". Git keeps the history of all changes." | Consolidated milestone docs under numbered filenames without milestone prefixes. | `0-Index.md` > `Presentation Documents` |

## Additions by File in Milestone2

- `1-Project-Plan.md`
  - Quire link and timeline notation guide
- `2-Architectural-Drivers.md`
  - FR
    - Added `FR-07-12`
    - Removed `FR-10-09`, `FR-10-12`
    - Updated FR implementation status
  - QAS
    - Added `QAS-1 Accuracy`
    - Updated QAS numbering
- `3-Risk-Assessment.md`
  - RISK
    - Added no new Risk ID
    - Updated risk status values: Resolved / In progress / Accepted
- `4-Planned-Experiments.md`
  - EXP
    - Added EXP-06 Measurement accuracy
    - Updated EXP-01/02/03/05 results
- `6-Architectural-View.md`
  - Layered View
  - Module Uses View
  - MVVM View
  - Deployment View
  - Run Lifecycle C&C Sequence View
  - Run Lifecycle State Machine View
- Architecture decision records(ADR)
  - ADR-001: Avalonia UI + .NET + C# adoption
  - ADR-002: Worker-Level Partial Pipe-and-Filter
  - ADR-003: MVVM for App UI
  - ADR-004: App/Test/Verify module separation
