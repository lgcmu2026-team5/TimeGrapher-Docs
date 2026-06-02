# FR-02 Trace Display

## Functional Requirements

| ID | Priority | Functional Requirement | Requirement Basis |
|---|---|---|---|
| FR-02-01 | Mandatory | [EN] The TimeGrapher System shall record the rate deviation over time and display it as a graph on the screen.<br>[KO] TimeGrapher System은 시간에 따른 오차율 편차(rate deviation)를 기록하고 그래프를 화면에 표시해야 한다. | [EN] Project Plan Draft (Trace Display): requires recording the rate deviation over time and displaying it as a graph.<br>[KO] Project Plan Draft의 Trace Display는 시간에 따른 오차율 편차를 기록·그래프 표시하도록 요구한다. |
| FR-02-02 | Mandatory | [EN] The TimeGrapher System shall record the amplitude over time and display it as a graph on the screen.<br>[KO] TimeGrapher System은 시간에 따른 진동각(amplitude)을 기록하고 그래프를 화면에 표시해야 한다. | [EN] Project Plan Draft (Trace Display): requires recording the amplitude over time and displaying it as a graph.<br>[KO] Project Plan Draft의 Trace Display는 시간에 따른 진동각을 기록·그래프 표시하도록 요구한다. |
| FR-02-03 | Mandatory | [EN] The TimeGrapher System shall display vertically stacked graphs for the rate deviation and the amplitude.<br>[KO] TimeGrapher System은 오차율 편차와 진동각에 대해 수직으로 쌓인 그래프를 화면에 표시해야 한다. | [EN] Project Plan Draft (Trace Display): supports a vertically stacked layout of the rate-deviation and amplitude graphs.<br>[KO] Project Plan Draft의 Trace Display는 오차율 편차·진동각 그래프의 수직 스택 배치를 지원한다. |
| FR-02-04 | Mandatory | [EN] The TimeGrapher System shall display two separate graphs for the rate deviation and the amplitude.<br>[KO] TimeGrapher System은 오차율 편차와 진동각에 대해 두 개의 분리된 그래프를 화면에 표시해야 한다. | [EN] Project Plan Draft (Trace Display): supports a layout that separates the rate-deviation and amplitude graphs.<br>[KO] Project Plan Draft의 Trace Display는 오차율 편차·진동각 그래프를 분리하는 배치를 지원한다. |
| FR-02-05 | Mandatory | [EN] The TimeGrapher System shall provide a smoothing function for the daily-rate (s/d) measurement values.<br>[KO] TimeGrapher System은 일일 오차(s/d) 측정값에 대한 평활화 함수(smoothing function)를 제공해야 한다. | [EN] Project Plan Draft (Trace Display): short-term fluctuations should not make the graph hard to interpret, so a smoothing function for daily-rate values is required.<br>[KO] Project Plan Draft의 Trace Display는 단기 변동이 그래프 해석을 어렵게 하지 않도록 일일 오차값 평활화 함수를 요구한다. |
| FR-02-06 | Mandatory | [EN] The TimeGrapher System shall raise an alert to the user when the rate indicates the watch is running late.<br>[KO] TimeGrapher System은 오차율이 시계가 느려지고 있음(running late)을 나타낼 때 사용자에게 알림(alert)을 발생시켜야 한다. | [EN] Project Plan Draft (Trace Display): requires alerting the user when the rate indicates the watch is running late.<br>[KO] Project Plan Draft의 Trace Display는 시계가 느려질 때 사용자 알림을 발생시키도록 요구한다. |
| FR-02-07 | Mandatory | [EN] The TimeGrapher System shall be able to include descriptive text or labels for each graph.<br>[KO] TimeGrapher System은 각 그래프에 대한 설명 텍스트나 라벨을 포함시킬 수 있어야 한다. | [EN] Project Plan Draft (Trace Display): requires descriptive text/labels per graph to help the user understand the output.<br>[KO] Project Plan Draft의 Trace Display는 사용자가 출력을 이해하도록 그래프별 설명 텍스트/라벨을 요구한다. |
| FR-02-08 | Mandatory | [EN] The TimeGrapher System shall provide an average and a rolling average that updates over time.<br>[KO] TimeGrapher System은 평균 및 시간에 따라 업데이트되는 이동 평균(rolling average)을 제공해야 한다. | [EN] Project Plan Draft (Trace Display): requires an average and a time-updated rolling average.<br>[KO] Project Plan Draft의 Trace Display는 평균과 시간에 따라 갱신되는 이동 평균을 요구한다. |
| FR-02-09 | Mandatory | [EN] The TimeGrapher System shall provide long-term summary information for both measurements (rate deviation / amplitude).<br>[KO] TimeGrapher System은 두 측정값(오차율 편차 / 진동각)에 대한 장기 요약 정보를 제공해야 한다. | [EN] Project Plan Draft (Trace Display): requires long-term summary information so short-term behavior and long-term stability can both be evaluated.<br>[KO] Project Plan Draft의 Trace Display는 단기 동작과 장기 안정성을 모두 평가하도록 장기 요약 정보를 요구한다. |
| FR-02-10 | Mandatory | [EN] The TimeGrapher System shall raise an alert to the user when the measured amplitude falls outside the 270°–300° range.<br>[KO] TimeGrapher System은 측정된 진동각이 270°–300° 범위를 벗어나는 경우 사용자에게 알림(alert)을 발생시켜야 한다. | [EN] Project Plan Draft (Trace Display): the amplitude display must show whether the watch stays within the normal operating range, commonly treated as 270°–300°.<br>[KO] Project Plan Draft의 Trace Display는 진동각이 정상 작동 범위(일반적으로 270°–300°) 내에 있는지 표시하도록 요구한다. |

## Quality Attributes

### QA-02-01 Simultaneous Graph Readability

**Scenario**

[EN] When an engineer views the rate-deviation and amplitude graphs at the same time, the on-screen text labels and Y-axis scales are rendered without any visual overlap.

[KO] 엔지니어가 오차율 편차 그래프와 진동각 그래프를 동시에 조회할 때, 화면의 텍스트 라벨과 Y축 스케일이 겹침 없이 렌더링된다.

**Quality Attribute Rationale**

[EN] Usability is selected because the rate-deviation and amplitude graphs (FR-02-01/02) must be clearly visible and easy to interpret without overlapping elements.

[KO] 오차율 편차·진동각 그래프(FR-02-01/02)가 겹침 없이 명확히 보이고 해석하기 쉬워야 하므로 Usability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-02-01 |
| Quality Attribute | [EN] Usability<br>[KO] 사용성 |
| Source of Stimulus | [EN] Engineer<br>[KO] 엔지니어 |
| Stimulus | [EN] A request to view the graphs simultaneously.<br>[KO] 그래프 동시 조회 요청. |
| Artifact | [EN] UI and graph display components<br>[KO] UI 및 그래프 디스플레이 컴포넌트 |
| Environment | [EN] Real-time data update state<br>[KO] 실시간 데이터 업데이트 상태 |
| Response | [EN] Text, labels, and line weights are rendered clearly without visual overlap.<br>[KO] 텍스트, 라벨, 선 굵기 등이 시각적으로 겹침 없이 명확히 렌더링된다. |
| Response Measure | [EN] 0 overlap errors between UI components and a 0% user data-misreading rate.<br>[KO] UI 컴포넌트 간 오버랩 오류 0건, 사용자 데이터 오독률 0%. |

### QA-02-02 Smoothing of Short-Term Noise

**Scenario**

[EN] When a large volume of data containing short-term noise arrives from the measurement sensor, the system applies a smoothing function to remove residual-vibration flickering and convert it into a smooth trend.

[KO] 계측 센서로부터 단기 노이즈가 포함된 대량의 데이터가 유입될 때, 시스템은 평활화 함수를 적용하여 잔진동 플리커링을 제거하고 부드러운 트렌드로 변환한다.

**Quality Attribute Rationale**

[EN] Performance is selected because short-term fluctuations must not make the graph hard to interpret; the smoothing function (FR-02-05) must process incoming data in real time.

[KO] 단기적인 변동으로 그래프 해석이 어려워지지 않아야 하며 평활화 함수(FR-02-05)가 유입 데이터를 실시간 처리해야 하므로 Performance를 선택한다.

| Field | Description |
|---|---|
| ID | QA-02-02 |
| Quality Attribute | [EN] Performance<br>[KO] 성능 |
| Source of Stimulus | [EN] Measurement sensor engine<br>[KO] 계측 센서 엔진 |
| Stimulus | [EN] A large influx of short-term noise and micro-fluctuation data.<br>[KO] 단기 노이즈 및 미세 변동 데이터 대량 유입. |
| Artifact | [EN] Data smoothing function and graph view<br>[KO] 데이터 평활화 함수 및 그래프 뷰 |
| Environment | [EN] During real-time measurement and rendering<br>[KO] 실시간 측정 및 렌더링 중 |
| Response | [EN] Displayed as a smooth trend line with flickering removed through the smoothing algorithm.<br>[KO] 평활화 알고리즘을 거쳐 플리커링이 제거된 부드러운 트렌드 선으로 표시된다. |
| Response Measure | [EN] Within 0.5 s from data influx to graph reflection, and ≥ 80% mitigation of abrupt kinks.<br>[KO] 데이터 유입 후 그래프 반영까지 0.5초 이내, 급격한 꺾임 현상 80% 이상 완화. |

### QA-02-03 Amplitude Normal-Range Indication

**Scenario**

[EN] When the amplitude being measured fails to stay within the normal range (270°–300°) and deviates, the system visually highlights it and raises an alert that the watch is in an abnormal operating range within 0.2 s.

[KO] 계측 중인 진동각 값이 정상 범위(270°–300°)를 유지하지 못하고 벗어날 때, 시스템은 시각적으로 강조하여 시계가 비정상 작동 범위에 있다는 알림을 0.2초 이내에 발생시킨다.

**Quality Attribute Rationale**

[EN] Usability is selected because the amplitude portion of the display must show whether the watch stays within its normal operating range, commonly treated as 270°–300° (FR-02-02/10).

[KO] 진동각 디스플레이가 시계의 정상 작동 범위(일반적으로 270°–300°) 유지 여부를 보여줘야 하므로(FR-02-02/10) Usability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-02-03 |
| Quality Attribute | [EN] Usability<br>[KO] 사용성 |
| Source of Stimulus | [EN] TimeGrapher measurement module<br>[KO] 타임그래퍼 계측 모듈 |
| Stimulus | [EN] Amplitude measurement values arrive.<br>[KO] 진동각 측정값 유입. |
| Artifact | [EN] Amplitude display and alert engine<br>[KO] 진동각 디스플레이 및 알림 엔진 |
| Environment | [EN] Normal continuous measurement state<br>[KO] 정상 연속 측정 상태 |
| Response | [EN] Highlights the normal range (270°–300°) with a green band and immediately shows a warning on deviation.<br>[KO] 정상 범위(270°–300°)를 녹색 영역 등으로 강조하고 이탈 시 즉각적 경고를 노출한다. |
| Response Measure | [EN] ≤ 0.2 s latency from out-of-range condition to the visual warning.<br>[KO] 정상 범위 이탈 시 시각적 경고 표시까지 지연 시간 0.2초 이내. |

### QA-02-04 Graph-Reading Guidance

**Scenario**

[EN] When a user requests help to understand how to interpret the graph output interface, the system provides contextual explanation content that makes the graph guide and label meanings easy to understand.

[KO] 사용자가 그래프 출력 인터페이스를 해석하는 방법을 이해하고자 도움말을 요청할 때, 시스템은 그래프 가이드 및 라벨의 의미를 쉽게 이해할 수 있는 컨텍스트 설명 콘텐츠를 제공한다.

**Quality Attribute Rationale**

[EN] Usability is selected because the system must help the user understand how to read the graph output (FR-02-07).

[KO] 시스템이 사용자가 그래프 출력을 읽는 방법을 이해하도록 도와야 하므로(FR-02-07) Usability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-02-04 |
| Quality Attribute | [EN] Usability<br>[KO] 사용성 |
| Source of Stimulus | [EN] System user<br>[KO] 시스템 사용자 |
| Stimulus | [EN] A request for an interface/label interpretation guide.<br>[KO] 인터페이스 및 라벨 해석 가이드 요청. |
| Artifact | [EN] Help system and UI tooltips<br>[KO] 도움말 시스템 및 UI 툴팁 |
| Environment | [EN] At first system startup or on a guide request<br>[KO] 시스템 최초 구동 또는 가이드 요청 시 |
| Response | [EN] Clearly shows pop-ups/tooltips explaining how to read the graph and the meaning of the data.<br>[KO] 그래프 읽는 법과 데이터 의미를 설명하는 팝업/툴팁을 명확하게 노출한다. |
| Response Measure | [EN] ≤ 0.1 s from help request to display, and ≥ 95% operation success rate after viewing.<br>[KO] 도움말 요청 후 표시까지 0.1초 이내, 확인 후 조작 성공률 95% 이상. |

### QA-02-05 Integrated Short/Long-Term View Performance

**Scenario**

[EN] When a quality manager requests 24 hours' worth of summary data on the same screen to evaluate both the watch's short-term behavior and long-term stability, the system completes the display within 2 s.

[KO] 품질 관리자가 시계의 단기 동작과 장기 안정성을 모두 평가하기 위해 동일 화면에서 24시간 분량의 요약 데이터를 요청할 때, 시스템은 관련 정보를 2초 이내에 표시 완료한다.

**Quality Attribute Rationale**

[EN] Performance is selected because the user must be able to assess both short-term behavior and long-term stability over an extended period (e.g., a day) within the same interface (FR-02-09).

[KO] 사용자가 동일 인터페이스에서 단기 동작과 장기 안정성을(하루와 같은 확장된 기간 동안) 모두 평가할 수 있어야 하므로(FR-02-09) Performance를 선택한다.

| Field | Description |
|---|---|
| ID | QA-02-05 |
| Quality Attribute | [EN] Performance<br>[KO] 성능 |
| Source of Stimulus | [EN] Quality manager<br>[KO] 품질 관리자 |
| Stimulus | [EN] A request to view integrated long/short-term data in the same interface.<br>[KO] 동일 인터페이스에서 장단기 통합 데이터 조회 요청. |
| Artifact | [EN] Long-term data store and dashboard view<br>[KO] 장기 데이터 저장소 및 대시보드 뷰 |
| Environment | [EN] Normal operation with large accumulated data<br>[KO] 대용량 데이터가 축적된 정상 운영 상태 |
| Response | [EN] Loads large backend data in parallel without harming short-term UI responsiveness and displays it in an integrated view.<br>[KO] 단기 UI 반응성을 저해하지 않고 대용량 백엔드 데이터를 병렬 로드하여 화면에 통합 표시한다. |
| Response Measure | [EN] ≤ 2 s to complete loading the 24-hour integrated short/long-term dashboard.<br>[KO] 24시간 분량의 장단기 통합 대시보드 로드 완료 시간 2초 이내. |

### QA-02-06 Running-Late Alerting

**Scenario**

[EN] When the monitoring engine detects a threshold breach indicating the watch is running late during rate analysis, the system raises an immediate alert so the user becomes aware.

[KO] 모니터링 엔진이 오차율 수치 분석 중 시계가 느려지고 있음(running late)을 나타내는 임계치 초과를 감지했을 때, 시스템은 사용자에게 즉각적인 알림을 발생시켜 인지하도록 한다.

**Quality Attribute Rationale**

[EN] Reliability is selected because the system must be able to indicate when the rate shows the watch is running late (FR-02-06).

[KO] 시스템이 오차율로 시계가 느려지고 있음을 나타낼 수 있어야 하므로(FR-02-06) Reliability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-02-06 |
| Quality Attribute | [EN] Reliability<br>[KO] 신뢰성 |
| Source of Stimulus | [EN] Real-time rate monitoring engine<br>[KO] 실시간 오차율 모니터링 엔진 |
| Stimulus | [EN] The rate exceeds the negative (−) threshold (slowdown detected).<br>[KO] 오차율 음수(−) 방향 임계치 초과 (느려짐 감지). |
| Artifact | [EN] Alert event handler and warning UI<br>[KO] 알림 이벤트 핸들러 및 경고 UI |
| Environment | [EN] During background measurement or real-time monitoring<br>[KO] 백그라운드 계측 또는 실시간 모니터링 중 |
| Response | [EN] Immediately broadcasts an alert event, shows a red warning pop-up on screen, and records a log.<br>[KO] 즉각적으로 알림 이벤트를 브로드캐스팅하여 화면에 적색 경고 팝업을 띄우고 로그를 기록한다. |
| Response Measure | [EN] ≤ 0.1 s from detecting the slowdown state to the warning pop-up appearing on the user's screen.<br>[KO] 느려짐 상태 감지 시점부터 사용자 화면에 경고 알림이 팝업되기까지 시차 0.1초 이내. |

### QA-02-07 Label Configurability

**Scenario**

[EN] When a developer or UI administrator wants to appropriately edit and place the descriptive text or label names of each graph, the architecture allows these to be reflected dynamically through external configuration files without modifying source code.

[KO] 개발자나 UI 관리자가 각 그래프의 설명 텍스트나 라벨 명칭을 적절하게 수정·배치하고자 할 때, 아키텍처는 소스 코드 수정 없이 외부 설정 파일 수정을 통해 이를 동적으로 반영할 수 있다.

**Quality Attribute Rationale**

[EN] Modifiability is selected because descriptive text and labels for explanations must be appropriately attachable and editable (FR-02-07).

[KO] 설명에 대한 텍스트와 라벨을 적절히 달고 수정할 수 있어야 하므로(FR-02-07) Modifiability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-02-07 |
| Quality Attribute | [EN] Modifiability<br>[KO] 변경 용이성 |
| Source of Stimulus | [EN] Developer or UI administrator<br>[KO] 개발자 또는 UI 관리자 |
| Stimulus | [EN] A request to change the graph description text and label names.<br>[KO] 그래프 설명 텍스트 및 라벨 명칭 변경 설정 요청. |
| Artifact | [EN] UI label configuration component and metadata<br>[KO] UI 라벨 설정 컴포넌트 및 메타데이터 |
| Environment | [EN] System configuration change and runtime label loading<br>[KO] 시스템 설정 변경 및 런타임 라벨 로드 시 |
| Response | [EN] Supports text edits and layout placement via external configuration files (JSON/XML) only, without hardcoding in code.<br>[KO] 코드의 하드코딩 없이 외부 설정 파일(JSON/XML)만으로 텍스트 수정 및 레이아웃 배치를 지원한다. |
| Response Measure | [EN] 0 source-code changes for label changes, and applied within 1 minute after the configuration file change.<br>[KO] 라벨 변경 시 소스 코드 수정 0건, 설정 파일 변경 후 적용까지 1분 이내 완료. |

## Traceability Summary

| Requirement | Related QA | Notes |
|---|---|---|
| FR-02-01, FR-02-02 | QA-02-01 | Rate-deviation and amplitude graphs must be readable without overlap. |
| FR-02-03, FR-02-04 | QA-02-01 | Stacked and separated graph layouts support simultaneous readability. |
| FR-02-05 | QA-02-02 | The smoothing function must convert noisy data into a smooth trend in real time. |
| FR-02-02, FR-02-10 | QA-02-03 | Amplitude normal-range (270°–300°) monitoring and alerting. |
| FR-02-07 | QA-02-04, QA-02-07 | Graph labels/help support readability and must be modifiable via configuration. |
| FR-02-08, FR-02-09 | QA-02-05 | Average/rolling average and long-term summary support short- and long-term evaluation. |
| FR-02-06 | QA-02-06 | A running-late condition must raise an immediate alert. |
