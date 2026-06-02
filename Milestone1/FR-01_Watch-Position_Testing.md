# FR-01 Watch-Position Testing

## Functional Requirements

| ID | Priority | Functional Requirement | Requirement Basis |
|---|---|---|---|
| FR-01-01 | Mandatory | [EN] The system shall support measuring a mechanical watch by selected physical watch position.<br>[KO] 시스템은 선택된 물리적 시계 position 기준으로 기계식 시계를 측정할 수 있어야 한다. | [EN] Project Plan Draft p.13: Test Positions require position-based measurement for mechanical watches.<br>[KO] Project Plan Draft p.13의 Test Positions는 기계식 시계를 position 기준으로 측정해야 함을 제시한다. |
| FR-01-02 | Mandatory | [EN] The system shall support at least the six standard positions: CH, CB, 6H, 9H, 3H, and 12H.<br>[KO] 시스템은 최소한 CH, CB, 6H, 9H, 3H, 12H의 여섯 가지 표준 position을 지원해야 한다. | [EN] Project Plan Draft p.13: Test Positions define the standard positions used for position testing.<br>[KO] Project Plan Draft p.13의 Test Positions는 position testing에 사용할 표준 position을 정의한다. |
| FR-01-03 | Mandatory | [EN] The system shall identify the active watch position used for the current measurement.<br>[KO] 시스템은 현재 측정에 사용되는 active watch position을 식별해야 한다. | [EN] Project Plan Draft p.13 states that the system shall identify the current position in the GUI.<br>[KO] Project Plan Draft p.13은 시스템이 GUI에서 current position을 식별해야 한다고 제시한다. |
| FR-01-04 | Mandatory | [EN] The system shall display the active watch position together with the current measurement values.<br>[KO] 시스템은 현재 측정값과 함께 active watch position을 표시해야 한다. | [EN] Project Plan Draft p.13 states that the GUI shall clearly indicate the active test position while measurements are being taken.<br>[KO] Project Plan Draft p.13은 측정이 진행되는 동안 GUI가 active test position을 명확히 표시해야 한다고 제시한다. |
| FR-01-05 | Mandatory | [EN] The system shall associate rate, amplitude, and beat error with the active watch position when a position measurement is captured.<br>[KO] 시스템은 position 측정 결과가 캡처될 때 rate, amplitude, beat error를 active watch position과 연결해야 한다. | [EN] Project Plan Draft p.13 requires the GUI to show the orientation associated with displayed results, and TimeGrapher Equations v1 defines rate, amplitude, and beat error measurement values.<br>[KO] Project Plan Draft p.13은 표시된 결과와 연결된 orientation을 사용자가 알 수 있어야 한다고 제시하며, TimeGrapher Equations v1은 rate, amplitude, beat error 측정값의 계산 근거를 제공한다. |
| FR-01-06 | Mandatory | [EN] The system shall mark a position result as invalid or low-confidence when the signal is not sufficient for a reliable position measurement.<br>[KO] 시스템은 신호가 신뢰 가능한 position 측정에 충분하지 않을 때 해당 position 결과를 invalid 또는 low-confidence로 표시해야 한다. | [EN] Project Plan Draft p.26 states that weak, noisy, or partially missing signals should not produce unstable or misleading outputs.<br>[KO] Project Plan Draft p.26은 약하거나 noisy하거나 부분적으로 누락된 신호가 불안정하거나 오해를 유발하는 출력을 만들지 않아야 한다고 제시한다. |
| FR-01-07 | Desired | [EN] The system should support additional or intermediate positions when the selected measurement procedure requires them.<br>[KO] 시스템은 선택된 측정 절차가 요구하는 경우 추가 position 또는 intermediate position을 지원하는 것이 바람직하다. | [EN] Project Plan Draft p.13: Test Positions include support for intermediate positions when used.<br>[KO] Project Plan Draft p.13의 Test Positions는 사용되는 경우 intermediate position 지원을 포함한다. |

## Quality Attributes

### QA-01-01 Accurate Position Association

**Scenario**

[EN] When a result is captured for CH, CB, 6H, 9H, 3H, or 12H while that position is active, the system associates the measured rate, amplitude, and beat error with exactly one matching position identifier.

[KO] CH, CB, 6H, 9H, 3H, 12H 중 하나의 position이 active인 상태에서 결과가 캡처되면, 시스템은 측정된 rate, amplitude, beat error를 정확히 하나의 일치하는 position 식별자와 연결한다.

**Quality Attribute Rationale**

[EN] Accurateness is selected because each measurement result must be linked to the actual watch position where it was measured.

[KO] 각 측정 결과가 실제로 측정된 watch position과 정확히 연결되어야 하므로 Accurateness를 선택한다.

| Field | Description |
|---|---|
| ID | QA-01-01 |
| Quality Attribute | [EN] Accurateness<br>[KO] 정확성 |
| Source of Stimulus | [EN] Measurement acquisition process<br>[KO] 측정 수집 프로세스 |
| Stimulus | [EN] A position measurement result is captured while a watch position is active.<br>[KO] watch position이 활성화된 상태에서 position 측정 결과가 캡처된다. |
| Artifact | [EN] Position result<br>[KO] Position result |
| Environment | [EN] Live, Playback, or Sim measurement mode<br>[KO] Live, Playback 또는 Sim 측정 모드 |
| Response | [EN] The system associates the captured rate, amplitude, and beat error with exactly one active watch position.<br>[KO] 시스템은 캡처된 rate, amplitude, beat error를 정확히 하나의 active watch position과 연결한다. |
| Response Measure | [EN] For the standard positions CH, CB, 6H, 9H, 3H, and 12H, 100% of captured valid position results have exactly one matching position identifier, and ambiguous or duplicate position associations are 0 cases.<br>[KO] 표준 position CH, CB, 6H, 9H, 3H, 12H 각각에 대해 캡처된 valid position result의 100%는 정확히 하나의 일치하는 position 식별자를 가지며, 모호하거나 중복된 position 연결은 0건이다. |

### QA-01-02 Active Position Visibility

**Scenario**

[EN] While measuring or reviewing a position result, the user checks the GUI and identifies the active or selected position near the displayed measurement values within 5 seconds.

[KO] position result를 측정하거나 검토하는 동안 사용자는 GUI를 확인하고 표시된 측정값 근처에서 active 또는 selected position을 5초 이내에 식별한다.

**Quality Attribute Rationale**

[EN] Usability is selected because the user must quickly identify the active or selected position in the GUI.

[KO] 사용자가 GUI에서 active 또는 selected position을 빠르게 식별해야 하므로 Usability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-01-02 |
| Quality Attribute | [EN] Usability<br>[KO] 사용성 |
| Source of Stimulus | [EN] User<br>[KO] 사용자 |
| Stimulus | [EN] The user observes the GUI during position-based measurement.<br>[KO] 사용자가 position 기반 측정 중 GUI를 확인한다. |
| Artifact | [EN] TimeGrapher GUI<br>[KO] TimeGrapher GUI |
| Environment | [EN] Measurement is running or a position result is being reviewed.<br>[KO] 측정이 진행 중이거나 position result를 검토하는 상태 |
| Response | [EN] The system shows the active or selected position near the corresponding measurement values.<br>[KO] 시스템은 active 또는 selected position을 해당 측정값 근처에 표시한다. |
| Response Measure | [EN] During review or demo, the active or selected position can be identified within 5 seconds for each displayed measurement result without opening a separate dialog.<br>[KO] review 또는 demo 중 각 표시된 measurement result에 대해 active 또는 selected position을 별도 dialog 없이 5초 이내에 식별할 수 있다. |

### QA-01-03 Invalid Position Handling

**Scenario**

[EN] When CH, CB, 6H, 9H, 3H, or 12H is measured under weak, noisy, partially missing, or clipped signal conditions, the system marks the affected result as invalid or low-confidence instead of showing it as a normal valid result.

[KO] CH, CB, 6H, 9H, 3H, 12H가 weak, noisy, partially missing, clipped signal condition에서 측정되면, 시스템은 영향을 받은 결과를 정상 valid result로 표시하지 않고 invalid 또는 low-confidence로 표시한다.

**Quality Attribute Rationale**

[EN] Accurateness is selected because a result from a weak, noisy, partially missing, or clipped signal must not be treated as an accurate normal measurement.

[KO] weak, noisy, partially missing, clipped signal에서 나온 결과가 정확한 정상 측정값처럼 취급되면 안 되므로 Accurateness를 선택한다.

| Field | Description |
|---|---|
| ID | QA-01-03 |
| Quality Attribute | [EN] Accurateness<br>[KO] 정확성 |
| Source of Stimulus | [EN] Watch acoustic signal<br>[KO] 시계 음향 신호 |
| Stimulus | [EN] The input signal is weak, noisy, missing, clipped, or otherwise insufficient during position measurement.<br>[KO] position 측정 중 입력 신호가 약하거나, noisy하거나, 누락되거나, clipped되거나, 그 밖의 이유로 충분하지 않다. |
| Artifact | [EN] Position result<br>[KO] Position result |
| Environment | [EN] Live, Playback, or Sim measurement mode<br>[KO] Live, Playback 또는 Sim 측정 모드 |
| Response | [EN] The system marks the affected position result as invalid or low-confidence instead of presenting it as a normal valid result.<br>[KO] 시스템은 영향을 받은 position result를 정상 valid result로 표시하지 않고 invalid 또는 low-confidence로 표시한다. |
| Response Measure | [EN] For CH, CB, 6H, 9H, 3H, and 12H measurements under weak, noisy, partially missing, or clipped signal conditions, 100% of affected position results are marked invalid or low-confidence, and 0 affected results are shown as normal valid results.<br>[KO] weak, noisy, partially missing, clipped signal condition에서 측정된 CH, CB, 6H, 9H, 3H, 12H 결과에 대해 영향을 받은 position result의 100%는 invalid 또는 low-confidence로 표시되며, 정상 valid result로 표시되는 영향 결과는 0건이다. |

## Traceability Summary

| Requirement | Related QA | Notes |
|---|---|---|
| FR-01-01 to FR-01-05 | QA-01-01, QA-01-02 | Position measurement must identify the active position and attach measured values to it. |
| FR-01-06 | QA-01-03 | Invalid or low-confidence position results must not be treated as normal valid results. |
| FR-01-07 | QA-01-01 | Additional or intermediate positions must still be associated with the correct captured measurement values when used. |
