# FR-03 Rate and Amplitude Stability Over Time

## Functional Requirements

| ID | Priority | Functional Requirement | Requirement Basis |
|---|---|---|---|
| FR-03-01 | Mandatory | [EN] The TimeGrapher System shall provide Vario Display information showing the long-term stability of both measurements (rate deviation / amplitude).<br>[KO] TimeGrapher System은 두 측정값(오차율 편차 / 진동각)에 대해 장기 안정성을 보여주는 Vario Display 정보를 제공해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): requires a Vario Display showing long-term stability of rate deviation and amplitude.<br>[KO] Project Plan Draft의 Rate and Amplitude Stability Over Time은 오차율 편차·진동각의 장기 안정성을 보여주는 Vario Display를 요구한다. |
| FR-03-02 | Mandatory | [EN] The TimeGrapher System shall provide the minimum value of the rate deviation.<br>[KO] TimeGrapher System은 오차율 편차에 대한 최소값을 제공해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): requires continuously updated key statistics for rate deviation, including the minimum.<br>[KO] Project Plan Draft는 오차율 편차의 핵심 통계(최소값 포함)를 지속 갱신하도록 요구한다. |
| FR-03-03 | Mandatory | [EN] The TimeGrapher System shall provide the maximum value of the rate deviation.<br>[KO] TimeGrapher System은 오차율 편차에 대한 최대값을 제공해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): requires the maximum statistic for rate deviation.<br>[KO] Project Plan Draft는 오차율 편차의 최대값 통계를 요구한다. |
| FR-03-04 | Mandatory | [EN] The TimeGrapher System shall provide the average value of the rate deviation.<br>[KO] TimeGrapher System은 오차율 편차에 대한 평균값을 제공해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): requires the average statistic for evaluating adjustment quality.<br>[KO] Project Plan Draft는 조정 품질 평가를 위한 오차율 편차 평균값을 요구한다. |
| FR-03-05 | Mandatory | [EN] The TimeGrapher System shall provide the standard deviation of the rate deviation.<br>[KO] TimeGrapher System은 오차율 편차에 대한 표준편차를 제공해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): standard deviation supports adjustment-quality evaluation.<br>[KO] Project Plan Draft는 조정 품질 평가를 위한 오차율 편차 표준편차를 요구한다. |
| FR-03-06 | Mandatory | [EN] The TimeGrapher System shall provide the elapsed measurement time for the rate deviation.<br>[KO] TimeGrapher System은 오차율 편차에 대한 경과된 측정 시간을 제공해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): requires the elapsed measurement time context for the rate-deviation statistics.<br>[KO] Project Plan Draft는 오차율 편차 통계의 경과 측정 시간 정보를 요구한다. |
| FR-03-07 | Mandatory | [EN] The TimeGrapher System shall provide the current value of the rate deviation.<br>[KO] TimeGrapher System은 오차율 편차에 대한 현재값을 제공해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): requires the current rate-deviation value alongside the long-term statistics.<br>[KO] Project Plan Draft는 장기 통계와 함께 오차율 편차 현재값을 요구한다. |
| FR-03-08 | Mandatory | [EN] The TimeGrapher System shall provide the minimum value of the amplitude.<br>[KO] TimeGrapher System은 진동각에 대한 최소값을 제공해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): requires the minimum amplitude statistic.<br>[KO] Project Plan Draft는 진동각 최소값 통계를 요구한다. |
| FR-03-09 | Mandatory | [EN] The TimeGrapher System shall provide the maximum value of the amplitude.<br>[KO] TimeGrapher System은 진동각에 대한 최대값을 제공해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): requires the maximum amplitude statistic.<br>[KO] Project Plan Draft는 진동각 최대값 통계를 요구한다. |
| FR-03-10 | Mandatory | [EN] The TimeGrapher System shall provide the average value of the amplitude.<br>[KO] TimeGrapher System은 진동각에 대한 평균값을 제공해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): requires the average amplitude statistic for adjustment-quality evaluation.<br>[KO] Project Plan Draft는 조정 품질 평가를 위한 진동각 평균값을 요구한다. |
| FR-03-11 | Optional | [EN] The TimeGrapher System shall provide the standard deviation of the amplitude.<br>[KO] TimeGrapher System은 진동각에 대한 표준편차를 제공해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): amplitude standard deviation is a useful but optional adjustment-quality statistic.<br>[KO] Project Plan Draft에서 진동각 표준편차는 유용하나 선택적인 조정 품질 통계이다. |
| FR-03-12 | Mandatory | [EN] The TimeGrapher System shall provide the elapsed measurement time for the amplitude.<br>[KO] TimeGrapher System은 진동각에 대한 경과된 측정 시간을 제공해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): requires the elapsed measurement time context for the amplitude statistics.<br>[KO] Project Plan Draft는 진동각 통계의 경과 측정 시간 정보를 요구한다. |
| FR-03-13 | Mandatory | [EN] The TimeGrapher System shall provide the current value of the amplitude.<br>[KO] TimeGrapher System은 진동각에 대한 현재값을 제공해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): requires the current amplitude value alongside the long-term statistics.<br>[KO] Project Plan Draft는 장기 통계와 함께 진동각 현재값을 요구한다. |
| FR-03-14 | Mandatory | [EN] The TimeGrapher System shall display the acceptable minimum-to-maximum range of each measurement as a green region on the graph.<br>[KO] TimeGrapher System은 각 측정값의 허용 가능한 최소값–최대값에 대해 녹색 영역으로 그래프에 표시해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): the acceptable range and the actual measured values must be clearly distinguished.<br>[KO] Project Plan Draft는 허용 가능한 범위와 실제 측정값을 명확히 구분하도록 요구한다. |
| FR-03-15 | Mandatory | [EN] The TimeGrapher System shall display the minimum/maximum value of each measurement as blue arrows on the graph.<br>[KO] TimeGrapher System은 각 측정값의 최소값/최대값을 청색 화살표로 그래프에 표시해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): min/max indicators must be clearly distinguishable from the acceptable range.<br>[KO] Project Plan Draft는 최소/최대 표시기가 허용 범위와 명확히 구분되도록 요구한다. |
| FR-03-16 | Mandatory | [EN] The TimeGrapher System shall display the average value of each measurement as a red arrow on the graph.<br>[KO] TimeGrapher System은 각 측정값의 평균값을 적색 화살표로 그래프에 표시해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): the average indicator must be clearly distinguishable on the graph.<br>[KO] Project Plan Draft는 평균 표시기가 그래프에서 명확히 구분되도록 요구한다. |
| FR-03-17 | Optional | [EN] The TimeGrapher System shall provide the maximum-minimum difference for each measurement.<br>[KO] TimeGrapher System은 각 측정값에 대한 최대값–최소값 차이를 제공해야 한다. | [EN] Project Plan Draft (Rate and Amplitude Stability Over Time): the max-min difference is a useful but optional adjustment-quality statistic.<br>[KO] Project Plan Draft에서 최대–최소 차이는 유용하나 선택적인 조정 품질 통계이다. |

## Quality Attributes

### QA-03-01 Continuous Statistics Update

**Scenario**

[EN] When several new measurement data points arrive per second from the collection engine, the system continuously recalculates the key statistics (minimum, maximum, average, etc.) without delay and updates the screen.

[KO] 수집 엔진으로부터 초당 여러 건의 신규 계측 데이터가 유입될 때, 시스템은 핵심 통계 수치(최소, 최대, 평균 등)를 지연 없이 지속적으로 재계산하고 화면에 업데이트한다.

**Quality Attribute Rationale**

[EN] Performance is selected because the key statistics must be continuously updated as new measurements arrive (FR-03-02 to FR-03-13).

[KO] 신규 측정값 유입에 따라 핵심 통계 수치를 지속해서 업데이트해야 하므로(FR-03-02 ~ FR-03-13) Performance를 선택한다.

| Field | Description |
|---|---|
| ID | QA-03-01 |
| Quality Attribute | [EN] Performance<br>[KO] 성능 |
| Source of Stimulus | [EN] Data collection module<br>[KO] 데이터 수집 모듈 |
| Stimulus | [EN] Continuous influx of real-time new measurement data.<br>[KO] 실시간 신규 계측 데이터 연속 유입. |
| Artifact | [EN] Statistics computation module and numeric display UI<br>[KO] 통계 연산 모듈 및 수치 표시 UI |
| Environment | [EN] During long continuous measurement (increased computation overhead)<br>[KO] 장시간 연속 측정 중 (연산 오버헤드 증가 상태) |
| Response | [EN] Continuously recalculates the rolling average and statistics from real-time data and refreshes the UI without interruption.<br>[KO] 실시간 데이터를 바탕으로 이동 평균 및 통계치를 끊김 없이 재계산하여 UI에 갱신한다. |
| Response Measure | [EN] Statistics update rate ≥ 1 Hz, and UI rendering maintained at 60 FPS.<br>[KO] 통계 데이터 갱신 주기 1Hz 이상, UI 렌더링 속도 60 FPS 유지. |

### QA-03-02 Long-Term Cumulative Statistics

**Scenario**

[EN] When an engineer requests the Vario Display to evaluate the watch's quality and consistency over a long period, the system provides the long-term cumulative statistics aligned consistently along the time axis together with trend lines.

[KO] 엔지니어가 긴 기간 동안의 시계 품질과 일관성을 평가하기 위해 Vario Display 조회를 요청할 때, 시스템은 장기 누적 통계 데이터를 시간 축에 따라 일관성 있게 정렬하여 추세선과 함께 제공한다.

**Quality Attribute Rationale**

[EN] Performance is selected because the user must be able to evaluate the watch's quality and consistency over longer periods, not just instantaneous values (FR-03-01 to FR-03-13).

[KO] 사용자가 순간 값만이 아니라 더 긴 기간의 시계 품질과 일관성을 평가할 수 있어야 하므로(FR-03-01 ~ FR-03-13) Performance를 선택한다.

| Field | Description |
|---|---|
| ID | QA-03-02 |
| Quality Attribute | [EN] Performance<br>[KO] 성능 |
| Source of Stimulus | [EN] Watch engineer<br>[KO] 시계 엔지니어 |
| Stimulus | [EN] A request to view the Vario Display and cumulative statistics.<br>[KO] Vario Display 및 누적 통계 데이터 조회 요청. |
| Artifact | [EN] Statistical analysis engine and Vario visualization module<br>[KO] 통계 분석 엔진 및 Vario 시각화 모듈 |
| Environment | [EN] Environment with multi-day measurement data accumulated<br>[KO] 장시간(수 일) 계측 데이터가 누적된 환경 |
| Response | [EN] Aligns minimum/maximum/average/standard deviation along the time axis and outputs them as a visualization chart.<br>[KO] 최소/최대/평균/표준편차를 시간 흐름의 축에 따라 정렬하고 시각화 차트로 출력한다. |
| Response Measure | [EN] 0 MB memory leak during long-term data computation, and ≤ 0.5 s to display on re-query.<br>[KO] 장기 데이터 연산 시 메모리 누수 0MB, 재조회 시 화면 표시까지 0.5초 이내. |

### QA-03-03 Range vs. Measured-Value Distinction

**Scenario**

[EN] When an engineer monitors the screen, the system renders the designated color regions and arrow indicators at precise coordinates to improve the distinction between the acceptable range and the actual measured values (minimum/maximum/average) on the graph.

[KO] 엔지니어가 화면을 모니터링할 때, 시스템은 그래프 내 허용 가능한 범위와 실제 측정값(최소/최대/평균)의 구분성 향상을 위해 지정된 색상 영역과 화살표 표시기를 명확한 좌표에 렌더링한다.

**Quality Attribute Rationale**

[EN] Usability is selected because the acceptable range and the actual measured values must be clearly distinguished (FR-03-14 to FR-03-16).

[KO] 허용 가능한 범위와 실제 측정값을 명확하게 구분해야 하므로(FR-03-14 ~ FR-03-16) Usability를 선택한다.

| Field | Description |
|---|---|
| ID | QA-03-03 |
| Quality Attribute | [EN] Usability<br>[KO] 사용성 |
| Source of Stimulus | [EN] Monitoring operator<br>[KO] 모니터링 작업자 |
| Stimulus | [EN] Visual observation and identification attempt on the graph screen.<br>[KO] 그래프 화면 시각적 주시 및 식별 시도. |
| Artifact | [EN] Graph renderer (green region, blue/red arrow indicators)<br>[KO] 그래프 렌더러 (녹색 영역, 청/적 화살표 표시기) |
| Environment | [EN] During real-time data plotting<br>[KO] 실시간 데이터 플로팅(Plotting) 중 |
| Response | [EN] Accurately renders the acceptable range (green band), minimum/maximum (blue arrows), and average (red arrow) in the designated colors.<br>[KO] 허용 범위(녹색 밴드), 최소/최대값(청색 화살표), 평균값(적색 화살표)을 지정된 색상으로 정확히 렌더링한다. |
| Response Measure | [EN] 0-pixel arrow coordinate error, and ≥ 98% user color-distinction satisfaction.<br>[KO] 화살표 표기 좌표 오차 0 픽셀, 사용자 색상 구별성 만족도 98% 이상. |

### QA-03-04 Accurate Adjustment-Quality Statistics

**Scenario**

[EN] When a master watchmaker wants to evaluate the overall adjustment quality, the system accurately computes the standard deviation and max-min difference of the rate and amplitude through precise floating-point computation and provides them.

[KO] 마스터 워치메이커가 전반적인 조정 품질(adjustment quality) 평가를 원할 때, 시스템은 오차율과 진동각의 표준편차 및 최대–최소 차이 수치를 정밀한 부동 소수점 연산을 통해 정확하게 산출하여 제공한다.

**Quality Attribute Rationale**

[EN] Performance is selected because the system must help evaluate the overall adjustment quality of the watch through precise, low-latency statistical computation (FR-03-04/05, FR-03-10/11).

[KO] 시스템이 정밀하고 지연이 적은 통계 연산으로 시계의 전반적인 조정 품질 평가를 도와야 하므로(FR-03-04/05, FR-03-10/11) Performance를 선택한다.

| Field | Description |
|---|---|
| ID | QA-03-04 |
| Quality Attribute | [EN] Performance<br>[KO] 성능 |
| Source of Stimulus | [EN] Master watchmaker<br>[KO] 마스터 워치메이커 |
| Stimulus | [EN] A request for overall adjustment-quality analysis data.<br>[KO] 전반적인 조정 품질 분석 데이터 요청. |
| Artifact | [EN] Statistics processing component<br>[KO] 통계 가공 컴포넌트 |
| Environment | [EN] At session end or on an intermediate analysis request<br>[KO] 세션 종료 또는 중간 분석 요청 시 |
| Response | [EN] Precisely computes the standard deviation and max-min difference to the designated number of decimal places and shows them in the UI.<br>[KO] 표준편차 및 최댓값–최솟값 차이 수치를 소수점 아래 지정된 자리까지 정밀 연산하여 UI에 표기한다. |
| Response Measure | [EN] Statistics computation accuracy matches the mechanical actual measurements to the 4th decimal place 100%, with computation latency < 0.1 s.<br>[KO] 통계 연산 수치 정확도가 기계적 실측값과 소수점 4째 자리까지 100% 일치, 연산 지연 0.1초 미만. |

## Traceability Summary

| Requirement | Related QA | Notes |
|---|---|---|
| FR-03-02 to FR-03-13 | QA-03-01 | Per-measurement key statistics (min/max/average/current/elapsed) must update continuously without delay. |
| FR-03-01 to FR-03-13 | QA-03-02 | The Vario Display must present long-term cumulative statistics aligned along the time axis with trends. |
| FR-03-14 to FR-03-16 | QA-03-03 | Acceptable range and measured values must be clearly distinguished with color bands and arrows. |
| FR-03-04, FR-03-05, FR-03-10, FR-03-11, FR-03-17 | QA-03-04 | Standard deviation and max-min difference support accurate adjustment-quality evaluation. |
