# FR Integrated Quality Attributes (FR-04 Format)

## Quality Attributes

### QA-INT-01 Cross-View Measurement Consistency

**Scenario**

[EN] When a user reviews one measurement session across position/sequence/scope/filter views, the system uses the same input signal and time axis to present rate, amplitude, beat error, and derived summaries (X, D) consistently.

[KO] 사용자가 하나의 측정 세션 결과를 position/sequence/scope/filter 뷰에서 검토할 때, 시스템은 동일한 입력 신호와 시간축을 사용하여 rate, amplitude, beat error 및 요약값(X, D)을 일관되게 표시한다.

**Quality Attribute Rationale**

[EN] Accurateness is selected because cross-view inconsistency makes diagnostic conclusions invalid.

[KO] 뷰 간 표시 불일치가 진단 결론을 무효화하므로 Accurateness를 선택한다.

| Field | Description |
|---|---|
| ID | QA-INT-01 |
| Priority | [EN] P1<br>[KO] 최우선 |
| Merged Source | QA-01-01, QA-04-02, QA-05-03, QA-12-03 |
| Quality Attribute | [EN] Accurateness<br>[KO] 정확성 |
| Source of Stimulus | [EN] Measurement session review process<br>[KO] 측정 세션 검토 프로세스 |
| Stimulus | [EN] The same session is inspected through multiple analysis views.<br>[KO] 동일 세션이 여러 분석 뷰로 확인된다. |
| Artifact | [EN] Position/Sequence/Scope/Filter displays and summary calculation<br>[KO] Position/Sequence/Scope/Filter 표시 및 요약 계산 |
| Environment | [EN] Live, Playback, or Sim mode<br>[KO] Live, Playback 또는 Sim 모드 |
| Response | [EN] The system presents consistent values from the same captured data and shared time axis across views.<br>[KO] 시스템은 동일 캡처 데이터와 공유 시간축 기반으로 뷰 간 일관된 값을 표시한다. |
| Response Measure | [EN] Cross-view reference mismatch = 0, time-axis alignment error = 0 sample, amplitude error <= +/-5deg for verification signals.<br>[KO] 뷰 간 참조 불일치 0건, 시간축 정렬 오차 0 sample, 검증 신호 기준 amplitude 오차 <= +/-5deg. |

### QA-INT-02 Graceful Degradation for Low-Quality Input

**Scenario**

[EN] When the input signal is weak, noisy, partially missing, clipped, or absent, the system marks affected outputs as invalid or low-confidence and clearly shows a no-signal state while continuing normal operation.

[KO] 입력 신호가 약함, noisy, 부분 누락, clipped, 또는 무신호일 때 시스템은 영향을 받은 결과를 invalid 또는 low-confidence로 표시하고 no-signal 상태를 명확히 보여주며 정상 동작을 유지한다.

**Quality Attribute Rationale**

[EN] Accurateness is selected because low-quality input must never be treated as normal valid measurement.

[KO] 저품질 입력 결과를 정상 valid 결과로 취급하면 안 되므로 Accurateness를 선택한다.

| Field | Description |
|---|---|
| ID | QA-INT-02 |
| Priority | [EN] P1<br>[KO] 최우선 |
| Merged Source | QA-01-03, QA-G06-03, QA-12-05 |
| Quality Attribute | [EN] Accurateness<br>[KO] 정확성 |
| Source of Stimulus | [EN] Acoustic input signal quality state<br>[KO] 음향 입력 신호 품질 상태 |
| Stimulus | [EN] Signal quality drops below reliable measurement conditions or input is absent.<br>[KO] 신호 품질이 신뢰 가능한 측정 조건 이하로 떨어지거나 입력이 부재한다. |
| Artifact | [EN] Measurement validity handling and signal-state display<br>[KO] 측정 유효성 처리 및 신호 상태 표시 |
| Environment | [EN] Live, Playback, or Sim mode under non-ideal conditions<br>[KO] 비이상 조건의 Live, Playback 또는 Sim 모드 |
| Response | [EN] The system downgrades affected outputs and displays explicit state information without stopping operation.<br>[KO] 시스템은 영향 결과의 신뢰도를 낮춰 표시하고 동작 중단 없이 상태 정보를 명시한다. |
| Response Measure | [EN] Affected results marked invalid/low-confidence = 100%, affected results shown as normal valid = 0, session continuity maintained.<br>[KO] 영향 결과 invalid/low-confidence 처리율 100%, 영향 결과의 정상 valid 오표시 0건, 세션 연속성 유지. |

### QA-INT-03 Real-Time Throughput and Non-Blocking Update

**Scenario**

[EN] During high-rate continuous measurement input, the system updates statistics, waveform, filter, and sequence displays concurrently without visible GUI freezes or measurement interruption.

[KO] 고빈도 연속 측정 입력 중 시스템은 통계, 파형, 필터, 시퀀스 표시를 GUI freeze나 측정 중단 없이 동시 갱신한다.

**Quality Attribute Rationale**

[EN] Performance is selected because dropped blocks or UI stalls directly reduce real-time diagnostic value.

[KO] 블록 드롭이나 UI 멈춤은 실시간 진단 가치를 직접 저하시켜 Performance를 선택한다.

| Field | Description |
|---|---|
| ID | QA-INT-03 |
| Priority | [EN] P1<br>[KO] 최우선 |
| Merged Source | QA-04-04, QA-05-01, QA-12-02, QA-03-01 |
| Quality Attribute | [EN] Performance<br>[KO] 성능 |
| Source of Stimulus | [EN] Continuous high-rate measurement stream<br>[KO] 연속 고속 측정 스트림 |
| Stimulus | [EN] High-frequency data arrives while multiple views are active.<br>[KO] 다중 뷰 활성 상태에서 고빈도 데이터가 유입된다. |
| Artifact | [EN] Real-time processing and rendering pipeline<br>[KO] 실시간 처리 및 렌더링 파이프라인 |
| Environment | [EN] Target Raspberry Pi environment, normal operation<br>[KO] 타깃 Raspberry Pi 환경의 정상 동작 |
| Response | [EN] The system sustains non-blocking updates and keeps measurement acquisition running.<br>[KO] 시스템은 비차단 갱신을 유지하고 측정 수집을 지속한다. |
| Response Measure | [EN] Visible GUI freeze = 0, dropped audio block = 0, concurrent rendering performance maintained (e.g., >=20 FPS for 4-view, >=30 FPS for scope).<br>[KO] 가시적 GUI freeze 0회, dropped audio block 0, 동시 렌더링 성능 유지 (예: 4-view >=20 FPS, scope >=30 FPS). |

### QA-INT-04 Immediate Alerting for Critical Conditions

**Scenario**

[EN] When measured values exceed configured critical thresholds (e.g., running-late, amplitude out-of-range, severe slope defect), the system issues an immediate visual alert and records the alert event.

[KO] 측정값이 설정된 임계 이상 조건(예: running-late, amplitude 범위 이탈, 심각한 기울기 결함)을 만족하면, 시스템은 즉시 시각 경고를 표시하고 알림 이벤트를 기록한다.

**Quality Attribute Rationale**

[EN] Reliability is selected because critical conditions must be detected and communicated without delay.

[KO] 임계 상태를 지연 없이 감지하고 전달해야 하므로 Reliability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-INT-04 |
| Priority | [EN] P1<br>[KO] 최우선 |
| Merged Source | QA-02-03, QA-02-06, QA-G06-02 |
| Quality Attribute | [EN] Reliability<br>[KO] 신뢰성 |
| Source of Stimulus | [EN] Real-time monitoring and threshold evaluation<br>[KO] 실시간 모니터링 및 임계치 평가 |
| Stimulus | [EN] A critical threshold violation or defect signature is detected.<br>[KO] 임계치 위반 또는 결함 징후가 감지된다. |
| Artifact | [EN] Alert engine, warning UI, and event log<br>[KO] 알림 엔진, 경고 UI, 이벤트 로그 |
| Environment | [EN] Continuous monitoring during measurement<br>[KO] 측정 중 연속 모니터링 |
| Response | [EN] The system displays immediate warning feedback and logs the condition.<br>[KO] 시스템은 즉시 경고를 표시하고 상태를 로그에 기록한다. |
| Response Measure | [EN] Critical alert latency <= 0.2 s, general defect identification <= 5 s, alert miss count = 0 for threshold violations.<br>[KO] 중요 경보 지연 <= 0.2초, 일반 결함 판별 <= 5초, 임계치 위반 대비 경보 누락 0건. |

### QA-INT-05 Capture-to-Display Latency

**Scenario**

[EN] When a new beat event occurs or a user triggers analysis control (marker/mode), the corresponding waveform, markers, and analysis view are shown with low end-to-end latency.

[KO] 새 beat 이벤트가 발생하거나 사용자가 분석 제어(마커/모드)를 수행하면, 해당 파형, 마커, 분석 화면이 낮은 end-to-end 지연으로 표시된다.

**Quality Attribute Rationale**

[EN] Performance is selected because perceived responsiveness is essential for real-time diagnosis.

[KO] 실시간 진단에서 체감 반응성이 핵심이므로 Performance를 선택한다.

| Field | Description |
|---|---|
| ID | QA-INT-05 |
| Priority | [EN] P2<br>[KO] 높음 |
| Merged Source | QA-05-02, QA-G06-01, QA-G08-01 |
| Quality Attribute | [EN] Performance<br>[KO] 성능 |
| Source of Stimulus | [EN] Beat event and user analysis interaction<br>[KO] 비트 이벤트 및 사용자 분석 상호작용 |
| Stimulus | [EN] Event occurrence or analysis UI manipulation.<br>[KO] 이벤트 발생 또는 분석 UI 조작. |
| Artifact | [EN] Capture-process-display path and analysis-mode transition<br>[KO] 캡처-처리-표시 경로 및 분석 모드 전환 |
| Environment | [EN] Live operation and interactive analysis<br>[KO] 라이브 동작 및 상호작용 분석 |
| Response | [EN] The updated visualization appears quickly without blocking interaction.<br>[KO] 상호작용 차단 없이 갱신 시각화가 빠르게 나타난다. |
| Response Measure | [EN] Average latency <= 100 ms, worst-case <= 200 ms, analysis mode entry <= 100 ms.<br>[KO] 평균 지연 <= 100ms, 최악 지연 <= 200ms, 분석 모드 진입 <= 100ms. |

### QA-INT-06 Diagnostic Usability and Readability

**Scenario**

[EN] While reviewing results, users can identify position, range status, abnormal values, and summary indicators quickly from non-overlapping layout, clear labels, colors, and markers.

[KO] 결과 검토 중 사용자는 겹침 없는 레이아웃과 명확한 라벨/색상/마커를 통해 position, 범위 상태, 이상값, 요약 지표를 빠르게 식별한다.

**Quality Attribute Rationale**

[EN] Usability is selected because operators must make fast and correct comparisons during diagnosis.

[KO] 운영자가 진단 중 빠르고 정확한 비교를 수행해야 하므로 Usability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-INT-06 |
| Priority | [EN] P2<br>[KO] 높음 |
| Merged Source | QA-01-02, QA-02-01, QA-02-04, QA-03-03, QA-04-03, QA-12-04 |
| Quality Attribute | [EN] Usability<br>[KO] 사용성 |
| Source of Stimulus | [EN] User during measurement/review<br>[KO] 측정/리뷰 중 사용자 |
| Stimulus | [EN] User tries to interpret and compare displayed diagnostics.<br>[KO] 사용자가 표시된 진단 정보를 해석/비교한다. |
| Artifact | [EN] Diagnostic UI layout, labels, help, and marker rendering<br>[KO] 진단 UI 레이아웃, 라벨, 도움말, 마커 렌더링 |
| Environment | [EN] Real-time monitoring or post-run review<br>[KO] 실시간 모니터링 또는 사후 리뷰 |
| Response | [EN] The system supports fast recognition and comparison with clear visual hierarchy.<br>[KO] 시스템은 명확한 시각 계층으로 빠른 인식과 비교를 지원한다. |
| Response Measure | [EN] Key item identification within 5 to 10 s, UI overlap errors = 0, comparison task success >= 90 to 95%.<br>[KO] 핵심 항목 식별 5~10초 이내, UI 오버랩 오류 0건, 비교 작업 성공률 >= 90~95%. |

### QA-INT-07 Session Continuity for Review and Analysis

**Scenario**

[EN] When users pause live measurement and navigate historical data or switch to analysis mode, the system preserves recorded data and session context without reset.

[KO] 사용자가 라이브 측정을 pause하고 과거 데이터를 탐색하거나 분석 모드로 전환할 때, 시스템은 세션 리셋 없이 기록 데이터와 세션 맥락을 유지한다.

**Quality Attribute Rationale**

[EN] Availability is selected because continuity is required for reliable inspection and comparison.

[KO] 신뢰 가능한 검토/비교를 위해 연속성이 필요하므로 Availability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-INT-07 |
| Priority | [EN] P2<br>[KO] 높음 |
| Merged Source | QA-05-04, QA-G08-03 |
| Quality Attribute | [EN] Availability<br>[KO] 가용성 |
| Source of Stimulus | [EN] User navigation and mode transition during review<br>[KO] 리뷰 중 사용자 탐색 및 모드 전환 |
| Stimulus | [EN] Pause, historical navigation, and analysis-mode entry requests.<br>[KO] pause, 과거 탐색, 분석 모드 진입 요청. |
| Artifact | [EN] Session state, recorded data buffer, and review display<br>[KO] 세션 상태, 기록 데이터 버퍼, 리뷰 표시 |
| Environment | [EN] Live and paused operation in one session<br>[KO] 단일 세션의 라이브/일시정지 동작 |
| Response | [EN] The system keeps session continuity and displays requested data without loss.<br>[KO] 시스템은 데이터 손실 없이 세션 연속성을 유지하며 요청 화면을 제공한다. |
| Response Measure | [EN] Session reset = 0, recorded data loss = 0, redisplay after selection <= 200 ms.<br>[KO] session reset 0회, recorded data loss 0, 선택 후 재표시 <= 200ms. |

### QA-INT-08 Long-Term Analytics Responsiveness

**Scenario**

[EN] When long-duration accumulated data is requested (e.g., 24h or more), the system loads and displays long-term trends and statistics quickly without degrading short-term UI responsiveness.

[KO] 장시간 누적 데이터(예: 24시간 이상) 조회를 요청하면, 시스템은 단기 UI 반응성을 저하시키지 않고 장기 추세/통계를 빠르게 로드 및 표시한다.

**Quality Attribute Rationale**

[EN] Performance is selected because long-term analysis must remain practical in operational use.

[KO] 장기 분석이 실제 운영에서 사용 가능해야 하므로 Performance를 선택한다.

| Field | Description |
|---|---|
| ID | QA-INT-08 |
| Priority | [EN] P2<br>[KO] 높음 |
| Merged Source | QA-02-05, QA-03-02 |
| Quality Attribute | [EN] Performance<br>[KO] 성능 |
| Source of Stimulus | [EN] User request for long-term trend/statistics<br>[KO] 장기 추세/통계 조회 사용자 요청 |
| Stimulus | [EN] Large historical dataset is queried for integrated dashboard display.<br>[KO] 대용량 히스토리 데이터가 통합 대시보드 표시를 위해 조회된다. |
| Artifact | [EN] Long-term data store, statistics engine, and dashboard view<br>[KO] 장기 데이터 저장소, 통계 엔진, 대시보드 뷰 |
| Environment | [EN] Large accumulated dataset condition<br>[KO] 대용량 누적 데이터 환경 |
| Response | [EN] The system returns integrated long-term results while preserving interactive responsiveness.<br>[KO] 시스템은 상호작용 반응성을 유지하며 통합 장기 결과를 제공한다. |
| Response Measure | [EN] 24h dashboard load <= 2 s, re-query display <= 0.5 s, memory leak during long computation = 0 MB.<br>[KO] 24시간 대시보드 로드 <= 2초, 재조회 표시 <= 0.5초, 장기 연산 메모리 누수 0MB. |

### QA-INT-09 Extensibility and Localized Change

**Scenario**

[EN] When teams add or modify filters, marker algorithms, labels, or sequence summary fields, the system supports localized implementation without major redesign of acquisition or core display modules.

[KO] 팀이 필터, 마커 알고리즘, 라벨, 시퀀스 요약 필드를 추가/수정할 때 시스템은 획득 및 핵심 표시 모듈의 대규모 재설계 없이 국소 변경으로 반영을 지원한다.

**Quality Attribute Rationale**

[EN] Modifiability is selected because recurring enhancement requests must be handled with controlled implementation cost.

[KO] 반복되는 기능 개선 요청을 통제 가능한 구현 비용으로 처리해야 하므로 Modifiability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-INT-09 |
| Priority | [EN] P3<br>[KO] 보통 |
| Merged Source | QA-02-07, QA-04-06, QA-12-01, QA-G08-02 |
| Quality Attribute | [EN] Modifiability<br>[KO] 변경 용이성 |
| Source of Stimulus | [EN] Developer, UI administrator, and project team<br>[KO] 개발자, UI 관리자, 프로젝트 팀 |
| Stimulus | [EN] A change request for filter/marker/label/summary behavior is raised.<br>[KO] 필터/마커/라벨/요약 동작 변경 요청이 발생한다. |
| Artifact | [EN] Configuration, filter pipeline, marker module, and summary schema<br>[KO] 설정, 필터 파이프라인, 마커 모듈, 요약 스키마 |
| Environment | [EN] Development and integration phase<br>[KO] 개발 및 통합 단계 |
| Response | [EN] The change is implemented in localized components with minimal ripple effects.<br>[KO] 변경은 파급 영향이 최소화된 국소 컴포넌트에서 반영된다. |
| Response Measure | [EN] Core module modification minimized, changed-file count limited for feature addition, existing code impact < 10%.<br>[KO] 핵심 모듈 수정 최소화, 기능 추가 시 변경 파일 수 제한, 기존 코드 영향도 < 10%. |

### QA-INT-10 Repeatable Verification and Explainability

**Scenario**

[EN] When testers rerun identical Sim/Playback datasets or reviewers inspect how X/D was produced, the system reproduces identical outputs and allows full trace-back to included/excluded data points.

[KO] 테스터가 동일 Sim/Playback 데이터셋을 반복 실행하거나 리뷰어가 X/D 산출 근거를 확인할 때, 시스템은 동일 결과를 재현하고 포함/제외 데이터 포인트까지 완전 역추적을 제공한다.

**Quality Attribute Rationale**

[EN] Testability is selected because repeatable validation and explainable summaries are required for trustworthy quality assurance.

[KO] 신뢰 가능한 품질 보증을 위해 반복 검증성과 설명 가능성이 필요하므로 Testability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-INT-10 |
| Priority | [EN] P3<br>[KO] 보통 |
| Merged Source | QA-04-05, QA-04-07 |
| Quality Attribute | [EN] Testability<br>[KO] 테스트 용이성 |
| Source of Stimulus | [EN] Tester and reviewer<br>[KO] 테스터 및 리뷰어 |
| Stimulus | [EN] Repeated verification and summary explanation requests are executed.<br>[KO] 반복 검증 및 요약 설명 요청이 수행된다. |
| Artifact | [EN] Sim/Playback verification result and sequence summary traceability<br>[KO] Sim/Playback 검증 결과 및 시퀀스 요약 추적성 |
| Environment | [EN] Development test, integration test, or demo review<br>[KO] 개발 테스트, 통합 테스트, 또는 데모 리뷰 |
| Response | [EN] The system returns reproducible outputs and traceable summary evidence.<br>[KO] 시스템은 재현 가능한 결과와 추적 가능한 요약 근거를 제공한다. |
| Response Measure | [EN] Identical output across 3 repeated runs with same input, X/D trace-back coverage = 100%.<br>[KO] 동일 입력 3회 반복 실행 결과 동일, X/D 역추적 가능률 100%. |

## Traceability Summary

| Requirement | Related QA | Notes |
|---|---|---|
| Integrated P1 correctness and reliability goals | QA-INT-01, QA-INT-02, QA-INT-03, QA-INT-04 | Core diagnostic trust depends on consistency, degradation handling, throughput, and immediate alerting. |
| Integrated P2 operational usability goals | QA-INT-05, QA-INT-06, QA-INT-07, QA-INT-08 | Practical operation requires low latency, readable UI, continuity, and long-term responsiveness. |
| Integrated P3 maintainability and assurance goals | QA-INT-09, QA-INT-10 | Sustainable evolution requires localized change and repeatable validation with explainability. |
