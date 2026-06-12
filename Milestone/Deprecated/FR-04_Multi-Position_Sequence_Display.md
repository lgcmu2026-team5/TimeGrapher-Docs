# FR-04 Multi-Position Sequence Display

## Functional Requirements

| ID | Priority | Functional Requirement | Requirement Basis |
|---|---|---|---|
| FR-04-01 | Mandatory | [EN] The system shall provide a display for reviewing multiple watch-position results as one measurement sequence.<br>[KO] 시스템은 여러 watch-position 결과를 하나의 measurement sequence로 검토할 수 있는 display를 제공해야 한다. | [EN] Project Plan Draft p.16: Multi-Position Sequence Display requires reviewing multiple position results as one sequence.<br>[KO] Project Plan Draft p.16의 Multi-Position Sequence Display는 여러 position 결과를 하나의 sequence로 검토하는 기능을 요구한다. |
| FR-04-02 | Mandatory | [EN] The system shall support a sequence containing multiple measured positions.<br>[KO] 시스템은 여러 measured position을 포함하는 sequence를 지원해야 한다. | [EN] Project Plan Draft p.16 states that Sequence Display Mode shall support a complete measurement cycle across multiple watch test positions.<br>[KO] Project Plan Draft p.16은 Sequence Display Mode가 여러 watch test position에 걸친 complete measurement cycle을 지원해야 한다고 제시한다. |
| FR-04-03 | Mandatory | [EN] The system shall support capturing and reviewing up to 10 position results in one sequence.<br>[KO] 시스템은 하나의 sequence 안에서 최대 10개의 position result를 캡처하고 검토할 수 있어야 한다. | [EN] Project Plan Draft p.16: Multi-Position Sequence Display defines sequence review for up to 10 positions.<br>[KO] Project Plan Draft p.16의 Multi-Position Sequence Display는 최대 10개 position의 sequence 검토를 제시한다. |
| FR-04-04 | Mandatory | [EN] The system shall include the supported standard positions in a sequence when those positions are selected for measurement.<br>[KO] 시스템은 표준 position들이 측정 대상으로 선택된 경우 해당 position들을 sequence에 포함해야 한다. | [EN] Project Plan Draft p.13 defines the standard watch positions, and Project Plan Draft p.16 requires sequence measurement across multiple watch test positions.<br>[KO] Project Plan Draft p.13은 표준 watch position을 정의하고, Project Plan Draft p.16은 여러 watch test position에 걸친 sequence measurement를 요구한다. |
| FR-04-05 | Mandatory | [EN] The system shall display rate, amplitude, and beat error for each measured position in the sequence.<br>[KO] 시스템은 sequence 안의 각 measured position에 대해 rate, amplitude, beat error를 표시해야 한다. | [EN] Project Plan Draft p.16 states that, for each position, the system shall calculate and display rate, amplitude, and beat error; TimeGrapher Equations v1 provides the measurement basis for those values.<br>[KO] Project Plan Draft p.16은 각 position에 대해 rate, amplitude, beat error를 계산 및 표시해야 한다고 제시하며, TimeGrapher Equations v1은 해당 측정값의 계산 근거를 제공한다. |
| FR-04-06 | Mandatory | [EN] The system shall calculate and display X as the mean rate value of valid measured positions in the sequence.<br>[KO] 시스템은 sequence 안의 valid measured position들의 rate 평균값을 X로 계산하고 표시해야 한다. | [EN] Project Plan Draft p.16 defines X as the mean of all test positions, Project Plan Draft p.26 supports preventing weak or unreliable results from producing misleading outputs, and TimeGrapher Equations v1 provides the rate measurement basis.<br>[KO] Project Plan Draft p.16은 X를 모든 test position의 평균으로 정의하고, Project Plan Draft p.26은 약하거나 신뢰하기 어려운 결과가 오해를 유발하는 출력을 만들지 않아야 함을 제시하며, TimeGrapher Equations v1은 rate 측정값의 계산 근거를 제공한다. |
| FR-04-07 | Mandatory | [EN] The system shall calculate and display D as the difference between the maximum and minimum valid rate values in the sequence.<br>[KO] 시스템은 sequence 안의 valid rate 값 중 최대값과 최소값의 차이를 D로 계산하고 표시해야 한다. | [EN] Project Plan Draft p.16 defines D as the difference between the largest and smallest measured value, Project Plan Draft p.26 supports preventing weak or unreliable results from producing misleading outputs, and TimeGrapher Equations v1 provides the rate measurement basis.<br>[KO] Project Plan Draft p.16은 D를 measured value의 최대값과 최소값 차이로 정의하고, Project Plan Draft p.26은 약하거나 신뢰하기 어려운 결과가 오해를 유발하는 출력을 만들지 않아야 함을 제시하며, TimeGrapher Equations v1은 rate 측정값의 계산 근거를 제공한다. |
| FR-04-08 | Mandatory | [EN] The system shall exclude invalid or low-confidence position results from X and D calculations.<br>[KO] 시스템은 invalid 또는 low-confidence position result를 X와 D 계산에서 제외해야 한다. | [EN] Project Plan Draft p.16 requires sequence summary values, and Project Plan Draft p.26 states that weak, noisy, or partially missing signals should not produce unstable or misleading outputs.<br>[KO] Project Plan Draft p.16은 sequence summary value 계산을 요구하고, Project Plan Draft p.26은 약하거나 noisy하거나 부분적으로 누락된 신호가 불안정하거나 오해를 유발하는 출력을 만들지 않아야 한다고 제시한다. |
| FR-04-09 | Mandatory | [EN] The system shall use the same captured position measurement values for both per-position result presentation and sequence summary calculation.<br>[KO] 시스템은 position별 결과 표시와 sequence summary 계산에 동일하게 캡처된 position 측정값을 사용해야 한다. | [EN] Project Plan Draft p.16 states that, for each position, the system shall calculate and display rate, amplitude, and beat error, and shall also compute summary values across the sequence; TimeGrapher Equations v1 defines the measurement basis for those values.<br>[KO] Project Plan Draft p.16은 각 position에 대해 rate, amplitude, beat error를 계산 및 표시하고 sequence 전체 summary value도 계산해야 한다고 제시하며, TimeGrapher Equations v1은 해당 측정값의 계산 근거를 제공한다. |
| FR-04-10 | Desired | [EN] The system should support comparison between horizontal and vertical position groups when such grouping is available.<br>[KO] 시스템은 position group 정보가 있을 때 horizontal과 vertical position group 간 비교를 지원하는 것이 바람직하다. | [EN] Project Plan Draft p.16: Multi-Position Sequence Display should support comparisons between vertical and horizontal positions.<br>[KO] Project Plan Draft p.16의 Multi-Position Sequence Display는 vertical 및 horizontal position 간 비교를 지원하는 것이 바람직하다고 제시한다. |

## Quality Attributes

### QA-04-01 Accurate Sequence Summary

**Scenario**

[EN] When a sequence contains CH, CB, 6H, 9H, 3H, and 12H results with at least one invalid or low-confidence result, the system calculates X and D from valid rate values only.

[KO] CH, CB, 6H, 9H, 3H, 12H 결과와 최소 1개의 invalid 또는 low-confidence result를 포함한 sequence에서, 시스템은 valid rate 값만 사용하여 X와 D를 계산한다.

**Quality Attribute Rationale**

[EN] Accurateness is selected because X and D must be calculated only from the valid rate values in the sequence.

[KO] X와 D는 sequence 안의 valid rate 값만으로 계산되어야 하므로 Accurateness를 선택한다.

| Field | Description |
|---|---|
| ID | QA-04-01 |
| Quality Attribute | [EN] Accurateness<br>[KO] 정확성 |
| Source of Stimulus | [EN] Measurement sequence processing<br>[KO] 측정 sequence 처리 프로세스 |
| Stimulus | [EN] Sequence summary values are calculated from captured position results.<br>[KO] 캡처된 position result로부터 sequence summary 값이 계산된다. |
| Artifact | [EN] Sequence summary<br>[KO] Sequence summary |
| Environment | [EN] At least two valid position results are available in one sequence.<br>[KO] 하나의 sequence 안에 최소 두 개의 valid position result가 있는 상태 |
| Response | [EN] The system calculates X from valid rate values and D from the maximum and minimum valid rate values.<br>[KO] 시스템은 valid rate 값으로 X를 계산하고, valid rate 값의 최대값과 최소값으로 D를 계산한다. |
| Response Measure | [EN] For a sequence containing CH, CB, 6H, 9H, 3H, and 12H results with at least one invalid or low-confidence position result, displayed X and D match the expected values calculated from valid rate values only within the displayed numeric precision, with 0 calculation mismatches for that sequence result set.<br>[KO] CH, CB, 6H, 9H, 3H, 12H 결과와 최소 1개의 invalid 또는 low-confidence position result를 포함한 sequence에서 표시된 X와 D는 표시되는 숫자 정밀도 이내에서 valid rate 값만으로 계산한 기대값과 일치하며, 해당 sequence result set의 calculation mismatch는 0건이다. |

### QA-04-02 Accurate Measurement Across Positions

**Scenario**

[EN] When standard position results are collected into one sequence, the values displayed per position and the values used for the sequence summary refer to the same captured result set.

[KO] 표준 position 결과가 하나의 sequence로 수집되면, position별로 표시되는 값과 sequence summary에 사용되는 값은 동일한 captured result set을 참조한다.

**Quality Attribute Rationale**

[EN] Accurateness is selected because the values shown for each position and the values used for the sequence summary must come from the same captured result set.

[KO] position별로 표시되는 값과 sequence summary에 사용되는 값이 동일한 captured result set에서 나와야 하므로 Accurateness를 선택한다.

| Field | Description |
|---|---|
| ID | QA-04-02 |
| Quality Attribute | [EN] Accurateness<br>[KO] 정확성 |
| Source of Stimulus | [EN] Measurement acquisition process<br>[KO] 측정 수집 프로세스 |
| Stimulus | [EN] Measurements from multiple positions are collected into one sequence.<br>[KO] 여러 position의 측정값이 하나의 sequence로 수집된다. |
| Artifact | [EN] Position results and sequence summary<br>[KO] Position results 및 sequence summary |
| Environment | [EN] Same sequence measurement session<br>[KO] 동일한 sequence measurement session |
| Response | [EN] The system uses the same captured rate, amplitude, beat error, and validity status for per-position result presentation and sequence summary behavior.<br>[KO] 시스템은 position별 결과 표시와 sequence summary 동작에 동일하게 캡처된 rate, amplitude, beat error, validity status를 사용한다. |
| Response Measure | [EN] For a sequence containing CH, CB, 6H, 9H, 3H, and 12H results, 100% of displayed per-position values used for sequence summary can be traced to the same captured results, and inconsistent result references are 0 cases.<br>[KO] CH, CB, 6H, 9H, 3H, 12H 결과를 포함한 sequence에서 sequence summary에 사용된 표시 position 값의 100%는 동일한 captured result로 추적될 수 있으며, 불일치하는 result reference는 0건이다. |

### QA-04-03 Sequence Result Readability

**Scenario**

[EN] When the user reviews a sequence containing up to 10 position results, the display supports identifying fastest rate, slowest rate, excluded positions, X, and D within 10 seconds.

[KO] 사용자가 최대 10개의 position result를 포함한 sequence를 검토할 때, display는 가장 빠른 rate, 가장 느린 rate, 제외된 position, X, D를 10초 이내에 식별할 수 있도록 지원한다.

**Quality Attribute Rationale**

[EN] Usability is selected because the user must quickly compare sequence results and identify excluded positions, X, and D.

[KO] 사용자가 sequence result를 빠르게 비교하고 제외된 position, X, D를 식별해야 하므로 Usability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-04-03 |
| Quality Attribute | [EN] Usability<br>[KO] 사용성 |
| Source of Stimulus | [EN] User<br>[KO] 사용자 |
| Stimulus | [EN] The user reviews a multi-position sequence after or during measurement.<br>[KO] 사용자가 측정 후 또는 측정 중 multi-position sequence를 검토한다. |
| Artifact | [EN] Multi-Position Sequence Display<br>[KO] Multi-Position Sequence Display |
| Environment | [EN] Sequence contains multiple position results.<br>[KO] sequence에 여러 position result가 포함된 상태 |
| Response | [EN] The system presents per-position values, validity status, X, and D in a way that supports comparison across positions.<br>[KO] 시스템은 position 간 비교가 가능하도록 position별 값, validity status, X, D를 표시한다. |
| Response Measure | [EN] During review or demo, fastest rate, slowest rate, excluded positions, X, and D can be identified within 10 seconds for a sequence containing up to 10 position results.<br>[KO] review 또는 demo 중 최대 10개의 position result를 포함한 sequence에서 가장 빠른 rate, 가장 느린 rate, 제외된 position, X, D를 10초 이내에 식별할 수 있다. |

### QA-04-04 Real-Time Display Update

**Scenario**

[EN] During a 1-minute measurement run at 48,000 samples/sec, position or sequence display updates occur without visible GUI freeze or measurement interruption while latency and dropped or missed event counts are recorded.

[KO] 48,000 samples/sec에서 1분 measurement run을 수행하는 동안, position 또는 sequence display update는 눈에 띄는 GUI freeze나 measurement interruption 없이 수행되며 latency와 dropped 또는 missed event count가 기록된다.

**Quality Attribute Rationale**

[EN] Performance is selected because the display must update during measurement without visible GUI freeze or measurement interruption.

[KO] 측정 중에도 display가 눈에 띄는 GUI freeze 또는 measurement interruption 없이 갱신되어야 하므로 Performance를 선택한다.

| Field | Description |
|---|---|
| ID | QA-04-04 |
| Quality Attribute | [EN] Performance<br>[KO] 성능 |
| Source of Stimulus | [EN] Measurement acquisition and processing pipeline<br>[KO] 측정 수집 및 처리 파이프라인 |
| Stimulus | [EN] Position or sequence information changes while measurement data is being acquired and processed.<br>[KO] 측정 데이터가 수집 및 처리되는 동안 position 또는 sequence 정보가 변경된다. |
| Artifact | [EN] GUI display for position and sequence results<br>[KO] position 및 sequence result를 표시하는 GUI |
| Environment | [EN] Normal measurement operation on the target Raspberry Pi environment<br>[KO] target Raspberry Pi 환경에서의 정상 측정 동작 |
| Response | [EN] The system updates position and sequence display information without visibly freezing the GUI or interrupting ongoing measurement acquisition.<br>[KO] 시스템은 GUI가 눈에 띄게 멈추거나 진행 중인 측정 수집이 중단되지 않도록 position 및 sequence display 정보를 갱신한다. |
| Response Measure | [EN] During a 1-minute measurement run at the 48,000 samples/sec minimum target, visible GUI freeze and measurement interruption are observed 0 times, and latency, dropped audio block count, and missed beat detection count are recorded.<br>[KO] 48,000 samples/sec minimum target에서 1분 measurement run 동안 눈에 띄는 GUI freeze와 measurement interruption은 0회 관찰되며, latency, dropped audio block count, missed beat detection count가 기록된다. |

### QA-04-05 Controlled Data Testability

**Scenario**

[EN] When a tester runs the same Sim or Playback input set for CH, CB, 6H, 9H, 3H, and 12H three times, the sequence inclusion, exclusion, X, and D verification results remain identical.

[KO] 테스터가 CH, CB, 6H, 9H, 3H, 12H에 대한 동일한 Sim 또는 Playback input set을 3회 실행하면, sequence inclusion, exclusion, X, D 검증 결과는 동일하게 유지된다.

**Quality Attribute Rationale**

[EN] Testability is selected because sequence inclusion, invalid-position exclusion, X, and D must be verified repeatedly using the same Sim or Playback data.

[KO] 동일한 Sim 또는 Playback data로 sequence inclusion, invalid-position exclusion, X, D를 반복 검증할 수 있어야 하므로 Testability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-04-05 |
| Quality Attribute | [EN] Testability<br>[KO] 테스트 용이성 |
| Source of Stimulus | [EN] Tester<br>[KO] 테스터 |
| Stimulus | [EN] A tester verifies sequence inclusion, invalid-position exclusion, X calculation, and D calculation using Sim or Playback data for CH, CB, 6H, 9H, 3H, and 12H.<br>[KO] 테스터가 CH, CB, 6H, 9H, 3H, 12H에 대한 Sim 또는 Playback data를 사용하여 sequence inclusion, invalid-position exclusion, X calculation, D calculation을 검증한다. |
| Artifact | [EN] Sequence inclusion/exclusion behavior and X/D calculation results<br>[KO] Sequence 포함/제외 동작 및 X/D 계산 결과 |
| Environment | [EN] Development or integration test environment using Sim or Playback input data for CH, CB, 6H, 9H, 3H, and 12H<br>[KO] CH, CB, 6H, 9H, 3H, 12H에 대한 Sim 또는 Playback input data를 사용하는 개발 또는 통합 테스트 환경 |
| Response | [EN] The system behavior can be verified without requiring live watch hardware for every test case.<br>[KO] 시스템 동작은 모든 테스트 케이스마다 live watch hardware를 요구하지 않고 검증될 수 있다. |
| Response Measure | [EN] When the same Sim or Playback input set for CH, CB, 6H, 9H, 3H, and 12H is executed 3 times, included positions, excluded values, X, and D produce identical verification results across the 3 runs.<br>[KO] CH, CB, 6H, 9H, 3H, 12H에 대한 동일한 Sim 또는 Playback input set을 3회 실행했을 때 included position, excluded value, X, D는 3회 실행 간 동일한 verification result를 생성한다. |

### QA-04-06 Position and Sequence Extensibility

**Scenario**

[EN] When a project enhancement requests one intermediate position label or one sequence summary field, the change can be described as localized and the affected files and rationale are recorded for review.

[KO] 프로젝트 개선 요청으로 intermediate position label 1개 또는 sequence summary field 1개를 추가해야 할 때, 해당 변경은 국소적 변경으로 설명될 수 있으며 영향 파일과 근거가 review를 위해 기록된다.

**Quality Attribute Rationale**

[EN] Modifiability is selected because adding a position label or sequence summary field should be possible with a small, localized change.

[KO] position label 또는 sequence summary field 추가가 작은 국소적 변경으로 가능해야 하므로 Modifiability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-04-06 |
| Quality Attribute | [EN] Modifiability<br>[KO] 변경 용이성 |
| Source of Stimulus | [EN] Project team, mentor, or product owner<br>[KO] 프로젝트 팀, 멘토 또는 제품 책임자 |
| Stimulus | [EN] A new position, position group, sequence metric, or display field needs to be added.<br>[KO] 새로운 position, position group, sequence metric 또는 display field를 추가해야 한다. |
| Artifact | [EN] Position list, sequence result format, and sequence display behavior<br>[KO] position 목록, sequence result 형식, sequence display 동작 |
| Environment | [EN] Development phase<br>[KO] 개발 단계 |
| Response | [EN] The system can be extended without major redesign of acoustic event detection or measurement value calculation.<br>[KO] 시스템은 acoustic event detection 또는 measurement value calculation의 대규모 재설계 없이 확장될 수 있다. |
| Response Measure | [EN] For at least 1 documented change example, adding 1 intermediate position label or 1 sequence summary field is described as a localized change, and the affected files and rationale are recorded for review.<br>[KO] documented change example 최소 1건에서 intermediate position label 1개 또는 sequence summary field 1개 추가가 국소적 변경으로 설명되며, 영향 파일과 근거가 review를 위해 기록된다. |

### QA-04-07 Result Explanation Testability

**Scenario**

[EN] When a tester or reviewer verifies how X or D was produced for a standard-position sequence, the result can be explained by tracing the displayed summary back to included and excluded position results.

[KO] tester 또는 reviewer가 표준 position sequence에서 X 또는 D가 어떻게 생성되었는지 검증하면, 표시된 summary를 포함 및 제외된 position result로 역추적하여 결과를 설명할 수 있다.

**Quality Attribute Rationale**

[EN] Testability is selected because testers or reviewers must be able to verify how X and D were produced from included and excluded position results.

[KO] tester 또는 reviewer가 포함 및 제외된 position result로부터 X와 D가 어떻게 생성되었는지 검증할 수 있어야 하므로 Testability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-04-07 |
| Quality Attribute | [EN] Testability<br>[KO] 테스트 용이성 |
| Source of Stimulus | [EN] Tester or reviewer<br>[KO] 테스터 또는 리뷰어 |
| Stimulus | [EN] A tester or reviewer verifies how a position result, X, or D was produced.<br>[KO] 테스터 또는 리뷰어가 position result, X 또는 D가 어떻게 생성되었는지 검증한다. |
| Artifact | [EN] Position results and sequence summary<br>[KO] Position results 및 sequence summary |
| Environment | [EN] Review, test, or demo preparation<br>[KO] review, test 또는 demo 준비 상황 |
| Response | [EN] The result can be explained using displayed values, position identity, validity status, and summary calculation basis.<br>[KO] 결과는 표시된 값, position identity, validity status, summary calculation basis를 사용하여 설명될 수 있다. |
| Response Measure | [EN] During document review or demo explanation, 100% of X and D values for a sequence containing CH, CB, 6H, 9H, 3H, and 12H results can be traced back to the included and excluded position results.<br>[KO] 문서 review 또는 demo 설명 중 CH, CB, 6H, 9H, 3H, 12H 결과를 포함한 sequence의 X와 D 값 100%는 포함 및 제외된 position result로 역추적될 수 있다. |

## Traceability Summary

| Requirement | Related QA | Notes |
|---|---|---|
| FR-04-01 to FR-04-05 | QA-04-02, QA-04-03 | The sequence display depends on readable per-position values and consistent captured data. |
| FR-04-06 to FR-04-08 | QA-04-01 | X and D must be computed from valid rate values and protected from invalid or low-confidence results. |
| FR-04-09 | QA-04-02, QA-04-07 | Per-position result presentation and sequence calculation must use the same captured result set. |
| FR-04-10 | QA-04-03, QA-04-06 | Horizontal and vertical position comparison supports readable sequence results and controlled position-group extension. |
| FR-04-06 to FR-04-08 | QA-04-05 | Controlled data tests should verify invalid-position exclusion, X, and D. |
