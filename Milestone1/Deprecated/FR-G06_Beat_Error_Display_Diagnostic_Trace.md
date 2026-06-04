# FR-G06 Beat Error Display & Diagnostic Trace

## Functional Requirements

| ID | Priority | Functional Requirement | Requirement Basis |
|---|---|---|---|
| FR-G06-01 | Mandatory | [EN] The system shall provide a beat error display and diagnostic trace.<br>[KO] 시스템은 비트 에러 디스플레이 및 진단 트레이스를 제공해야 한다. | [EN] Project Plan Draft p.18: Student teams shall implement a Beat Error Display and Diagnostic Trace that presents both numerical measurements and a corresponding graphical trace for diagnostic interpretation.<br>[KO] Project Plan Draft p.18은 학생팀이 수치 측정값과 진단 해석용 그래픽 trace를 함께 제공하는 Beat Error Display and Diagnostic Trace를 구현해야 한다고 제시한다. |
| FR-G06-02 | Mandatory | [EN] The system shall display rate, amplitude, beat error, and BPH with numeric values and units.<br>[KO] 시스템은 rate, amplitude, beat error, BPH를 숫자와 단위로 보여주어야 한다. | [EN] Project Plan Draft p.18 requires numeric values for rate, amplitude, beat error, and beats per hour; p.6 also states that the Measurement Summary Bar displays rate (s/d), amplitude (deg), beat error (ms), and bph in real time.<br>[KO] Project Plan Draft p.18은 rate, amplitude, beat error, beats per hour 수치 표시를 요구하며, p.6도 Measurement Summary Bar가 rate(s/d), amplitude(deg), beat error(ms), bph를 실시간 표시한다고 설명한다. |
| FR-G06-03 | Mandatory | [EN] The system shall display tick/tock trace lines that represent watch timing behavior.<br>[KO] 시스템은 시계의 타이밍 동작을 나타내는 틱/톡 트레이스 선을 보여주어야 한다. | [EN] Project Plan Draft p.18 requires one or more trace lines that visually represent watch timing behavior; p.6 describes the Rate Error graph as showing the timing relationship between tic and tac events.<br>[KO] Project Plan Draft p.18은 시계의 타이밍 동작을 시각적으로 나타내는 하나 이상의 trace line을 요구하며, p.6은 Rate Error graph가 tic/tac event 사이의 타이밍 관계를 보여준다고 설명한다. |
| FR-G06-04 | Mandatory | [EN] The system shall display the measurement values from FR-G06-02 and the trace lines from FR-G06-03 at the same time.<br>[KO] 시스템은 FR-G06-02, FR-G06-03을 동시에 보여주어야 한다. | [EN] Project Plan Draft p.18 requires numeric values for rate, amplitude, beat error, and BPH together with trace lines; this directly requires simultaneous numeric and graphical diagnostic presentation.<br>[KO] Project Plan Draft p.18은 rate, amplitude, beat error, BPH 수치값을 trace line과 함께 보여줄 것을 요구하므로, 수치 표시와 그래픽 진단 표시의 동시 제공을 직접 뒷받침한다. |
| FR-G06-05 | Desired | [EN] The system should distinguish tick trace lines from tock trace lines in the display.<br>[KO] 시스템은 틱, 톡 트레이스 선을 구분해서 디스플레이 해야 한다. | [EN] Project Plan Draft p.6 describes two lines for tic/tac timing behavior and explains that their separation indicates beat error; p.18 also discusses the case where two lines are shown and their separation is evaluated.<br>[KO] Project Plan Draft p.6은 tic/tac 타이밍 동작을 나타내는 두 선과 그 분리가 beat error를 의미한다고 설명하며, p.18도 두 선이 표시되는 경우와 그 간격 평가를 설명한다. |
| FR-G06-06 | Mandatory | [EN] The system shall calculate the spacing between tick/tock trace lines.<br>[KO] 시스템은 틱/톡 트레이스 선의 간격을 계산해야 한다. | [EN] Project Plan Draft p.18 states that, when two lines are shown, the system shall alert the user if their separation exceeds an acceptable range; evaluating this condition requires calculating or determining trace-line separation.<br>[KO] Project Plan Draft p.18은 두 선이 표시될 때 그 separation이 acceptable range를 초과하면 사용자에게 알릴 것을 요구하므로, 이를 판단하기 위해 trace line 간격 계산 또는 판정이 필요하다. |
| FR-G06-07 | Desired | [EN] The system should allow the user to configure the allowed range for trace-line spacing.<br>[KO] 시스템은 트레이스 선 간격의 허용범위를 사용자가 설정할 수 있어야 한다. | [EN] Project Plan Draft p.18 establishes an acceptable range for separation alerts, and p.10 encourages enhanced GUI interaction and additional derived timing measures. User configuration of the allowed range is a desired extension of that alert threshold basis.<br>[KO] Project Plan Draft p.18은 separation alert를 위한 acceptable range 개념을 제시하고, p.10은 향상된 GUI 상호작용과 추가 timing measure 표시를 장려한다. 허용범위 사용자 설정은 이 경고 임계값 근거를 확장한 desired 요구사항이다. |
| FR-G06-08 | Mandatory | [EN] The system shall maintain an allowed-range setting for trace-line spacing.<br>[KO] 시스템은 트레이스 선 간격의 허용범위 설정값을 가지고 있어야 한다. | [EN] Project Plan Draft p.18 requires an alert when two trace lines exceed an acceptable range, which implies the system must maintain a tolerance or allowed-range basis for separation comparison.<br>[KO] Project Plan Draft p.18은 두 trace line의 separation이 acceptable range를 초과할 때 alert를 요구하므로, 시스템은 separation 비교를 위한 허용범위 또는 tolerance 기준을 가지고 있어야 한다. |
| FR-G06-09 | Mandatory | [EN] The system GUI shall warn the user when the spacing between trace lines exceeds the allowed range.<br>[KO] 시스템 GUI는 트레이스 선의 간격이 허용범위를 넘어서면 사용자에게 경고를 보내야 한다. | [EN] Project Plan Draft p.18 explicitly states that, when two lines are shown, the system shall alert the user if their separation exceeds an acceptable range.<br>[KO] Project Plan Draft p.18은 두 선이 표시될 때 separation이 acceptable range를 초과하면 시스템이 사용자에게 alert해야 한다고 명시한다. |
| FR-G06-10 | Mandatory | [EN] The system shall measure the slope of the trace lines.<br>[KO] 시스템은 트레이스 선의 기울기를 측정할 수 있어야 한다. | [EN] Project Plan Draft p.18 requires the line display to be consistent with numeric values, explains that positive readings correspond to positively sloped traces, and defines excessive positive or negative slope as a fault indicator.<br>[KO] Project Plan Draft p.18은 line display가 numeric value와 일관되어야 하고 positive reading이 positive slope trace와 대응해야 하며, 과도한 양/음의 slope를 fault indicator로 설명한다. |
| FR-G06-11 | Mandatory | [EN] The system GUI shall indicate a defect condition when the trace-line slope is 45 degrees or greater.<br>[KO] 시스템 GUI는 트레이스 선의 기울기가 45도 이상이 되면 결함 상태임을 알려야 한다. | [EN] Project Plan Draft p.18 states that, if the slope becomes excessively positive or negative, such as greater than 45 degrees in magnitude, the GUI shall indicate a major fault condition.<br>[KO] Project Plan Draft p.18은 slope가 양 또는 음의 방향으로 과도해져 magnitude가 45도보다 큰 경우 GUI가 major fault condition을 표시해야 한다고 제시한다. |

## Quality Attributes

### QA-G06-01 Trace Visualization Latency

**Scenario**

[EN] When the user provides watch operating sound under normal conditions, the system visualizes the trace lines within 100 ms.

[KO] 사용자가 정상상황에서 시계 동작 소리를 입력하면, 시스템은 트레이스 선을 100ms 이내에 시각화한다.

**Quality Attribute Rationale**

[EN] Performance is selected because Project Plan Draft p.25 requires real-time acquisition, processing, analysis, and display on Raspberry Pi while maintaining a responsive GUI.

[KO] Project Plan Draft p.25가 Raspberry Pi에서 responsive GUI를 유지하며 실시간 acquire, process, analyze, display를 수행해야 한다고 요구하므로 Performance를 선택한다.

| Field | Description |
|---|---|
| ID | QA-G06-01 |
| Quality Attribute | [EN] Performance<br>[KO] 성능 |
| Source of Stimulus | [EN] User<br>[KO] 사용자 |
| Stimulus | [EN] Watch operating sound is provided as input.<br>[KO] 시계 동작 소리가 입력된다. |
| Artifact | [EN] System diagnostic trace display<br>[KO] 시스템 진단 trace display |
| Environment | [EN] Normal operating condition<br>[KO] 정상상황 |
| Response | [EN] The system visualizes the trace lines.<br>[KO] 시스템은 트레이스 선을 시각화한다. |
| Response Measure | [EN] Trace lines are visualized within 100 ms.<br>[KO] 트레이스 선이 100ms 이내에 시각화된다. |

### QA-G06-02 Abnormal Beat Defect Warning

**Scenario**

[EN] When the user provides abnormal watch operating sound under normal conditions, the system identifies the defect and warns the user within 5 seconds.

[KO] 사용자가 정상상황에서 비정상적인 시계 동작 소리를 입력하면, 시스템은 5초 이내 결함을 판별하고 사용자에게 경고한다.

**Quality Attribute Rationale**

[EN] Usability is selected because Project Plan Draft p.18 says the feature is intended to help users identify beat error, instability, and likely adjustment problems more easily than with numeric readings alone.

[KO] Project Plan Draft p.18이 이 기능의 목적을 수치만 사용할 때보다 beat error, instability, likely adjustment problem을 더 쉽게 식별하도록 돕는 것이라고 설명하므로 Usability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-G06-02 |
| Quality Attribute | [EN] Usability<br>[KO] 사용성 |
| Source of Stimulus | [EN] User<br>[KO] 사용자 |
| Stimulus | [EN] Abnormal watch operating sound is provided as input.<br>[KO] 비정상 시계 동작 소리가 입력된다. |
| Artifact | [EN] System GUI warning behavior<br>[KO] 시스템 GUI 경고 동작 |
| Environment | [EN] Normal operating condition<br>[KO] 정상상황 |
| Response | [EN] The system warns the user when a defect is detected.<br>[KO] 시스템은 결함 발생 시 사용자에게 경고한다. |
| Response Measure | [EN] The defect is identified within 5 seconds.<br>[KO] 결함은 5초 이내에 판별된다. |

### QA-G06-03 No Signal Handling

**Scenario**

[EN] When the user removes the watch operating sound input under normal conditions, the system displays No signal and waits for input.

[KO] 사용자가 정상상황에서 시계 동작 소리 입력을 제거하면, 시스템은 데이터 부재(No signal)를 표시하고 입력을 기다린다.

**Quality Attribute Rationale**

[EN] Availability is selected because Project Plan Draft p.26 requires graceful degradation when the signal is weak, noisy, or partially missing rather than unstable or misleading outputs.

[KO] Project Plan Draft p.26이 신호가 weak, noisy, partially missing인 경우 unstable 또는 misleading output 대신 graceful degradation을 제공해야 한다고 요구하므로 Availability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-G06-03 |
| Quality Attribute | [EN] Availability<br>[KO] 가용성 |
| Source of Stimulus | [EN] User<br>[KO] 사용자 |
| Stimulus | [EN] Watch operating sound input is absent.<br>[KO] 시계 동작 소리의 입력이 없다. |
| Artifact | [EN] System signal-state display<br>[KO] 시스템 신호 상태 display |
| Environment | [EN] Normal operating condition<br>[KO] 정상상황 |
| Response | [EN] The system displays No signal.<br>[KO] 시스템은 데이터 부재(No signal)를 표시한다. |
| Response Measure | [EN] The system waits for data input while continuing normal operation.<br>[KO] 시스템은 데이터 입력을 기다리며 정상 동작한다. |

## Traceability Summary

| Requirement | Related QA | Notes |
|---|---|---|
| FR-G06-01 to FR-G06-04 | QA-G06-01, QA-G06-02 | Project Plan Draft p.18 requires numeric measurements and graphical trace lines for diagnostic interpretation. |
| FR-G06-05 to FR-G06-09 | QA-G06-01, QA-G06-02 | Project Plan Draft p.6 and p.18 connect tic/tac line separation with beat error and require alerting when separation exceeds an acceptable range. |
| FR-G06-10 to FR-G06-11 | QA-G06-02 | Project Plan Draft p.18 connects trace slope with positive/negative readings and requires major fault indication above 45 degrees magnitude. |
| FR-G06-01 to FR-G06-04 | QA-G06-03 | Project Plan Draft p.26 supports graceful handling of weak, noisy, or missing signals. |
