# FR 통합 품질속성 (SAP 기준 재작성본)

## 품질속성 시나리오 (측정/테스트 가능 형태)

### QA-01 Cross-View Measurement Consistency

**Scenario**

동일 측정 세션을 Position/Sequence/Scope/Filter 뷰에서 동시에 조회할 때, 시스템은 동일 캡처 스냅샷 ID와 동일 시간축 기준으로 계산된 값을 각 뷰에 배치해 프레임 간 참조 불일치가 발생하지 않도록 표시한다.

**Quality Attribute Rationale**

뷰 간 참조 불일치는 진단 결론의 신뢰도를 훼손하므로 정확성이 핵심이다.

| Field | Description |
|---|---|
| ID | QA-01 |
| Quality Attribute | Accuracy (정확성) |
| Source of Stimulus | 사용자의 다중 뷰 검토 요청 |
| Stimulus | 동일 세션 데이터 동시 조회 |
| Artifact | Position/Sequence/Scope/Filter 표시 모듈 및 X/D 계산 모듈 |
| Environment | Live / Playback / Sim 모드 |
| Response | 각 뷰가 동일 snapshot ID와 시간축을 참조해 렌더링된다. |
| Response Measure | 동일 프레임 내 snapshot ID 불일치 0건, 시간축 정렬 오차 <= 1 sample, 검증 신호 기준 amplitude 오차 <= +/-5deg |
| Test Method | 동일 입력 재생 후 프레임별 snapshot ID/시간축/출력 로그 비교 |

### QA-02 Graceful Degradation for Low-Quality Input

**Scenario**

입력 신호가 약함/노이즈/클리핑/누락/무신호 상태로 판정되면 시스템은 해당 구간의 수치값을 화면에 표기하지 않고 invalid 또는 low-confidence 상태만 표시하며 세션은 유지한다.

**Quality Attribute Rationale**

저품질 입력에서 잘못된 수치 표시를 방지하는 것이 정확성 확보의 핵심이다.

| Field | Description |
|---|---|
| ID | QA-02 |
| Quality Attribute | Accuracy (정확성) |
| Source of Stimulus | 입력 신호 품질 저하 상태 |
| Stimulus | 품질 판정 모듈이 저품질/무신호 상태를 감지 |
| Artifact | 신호 품질 분류, 유효성 판정, 상태 표시 모듈 |
| Environment | 비이상 조건의 Live / Playback / Sim |
| Response | 저품질 구간의 수치 출력은 억제하고 상태 플래그만 노출한다. |
| Response Measure | 영향 구간 invalid/low-confidence 표시율 100%, 영향 구간 수치값 표기 0건, 세션 리셋 0회 |
| Test Method | 약신호/클리핑/무신호 데이터셋 재생 후 표시 텍스트 및 값 필드 점검 |
| Comment | SNR 임계치(예: 14 dB)와 허용 오차는 실험 결과 기반으로 최종 확정 예정 |

### QA-03 Real-Time Throughput and Non-Blocking Multi-View Update

**Scenario**

소리 데이터가 연속 입력되는 상태에서 시스템은 구성된 다중 뷰(동시 활성 뷰 수 N) 갱신을 유지하고 통계 갱신/렌더링/수집이 서로 블로킹되지 않도록 동작한다.

**Quality Attribute Rationale**

실시간 측정 도구는 데이터 수집 지속성과 다중 뷰 갱신 유지가 필수다.

| Field | Description |
|---|---|
| ID | QA-03 |
| Quality Attribute | Performance (성능) |
| Source of Stimulus | 연속 소리 데이터 입력 스트림 |
| Stimulus | 연속 입력 중 다중 뷰 동시 활성 |
| Artifact | 수집/통계/렌더링 파이프라인 |
| Environment | Raspberry Pi 타깃 정상 운영 |
| Response | 수집을 유지하면서 다중 뷰를 비차단 갱신한다. |
| Response Measure | 10분 연속 실행 기준 dropped audio block 0건, UI freeze(>=2s 무갱신) 0회, 통계 갱신 주기 >= 1Hz, 동시 뷰 N 유지율 100% |
| Test Method | 연속 입력 스트레스 테스트 + 뷰 유지 상태/FPS/오디오 드롭 로그 수집 |
| Comment | N(동시 활성 뷰 수)은 운영 시나리오 실험 후 확정 예정 |

### QA-04 Alert UI Update and Timeout Monitoring

**Scenario**

모니터링 중 화면 갱신 지연 또는 무갱신 상태가 발생하면 시스템은 경고 UI를 표시하고 이벤트 로그를 기록한다.

**Quality Attribute Rationale**

경고 발생 조건과 경고 표시 시간을 명시적으로 관리해야 테스트 가능성이 확보된다.

| Field | Description |
|---|---|
| ID | QA-04 |
| Quality Attribute | Reliability (신뢰성) |
| Source of Stimulus | 화면 갱신 모니터링 모듈 |
| Stimulus | 갱신 지연 감지(>1.0s) 또는 무갱신 감지(>=2.0s) |
| Artifact | 경고 엔진, 경고 UI, 이벤트 로그 |
| Environment | 연속 측정 모니터링 중 |
| Response | 경고 UI를 생성하고 감지 시각/갱신 지연값/세션 ID를 로그에 기록한다. |
| Response Measure | 감지 후 경고 UI 표시 P95 <= 0.5s, 이벤트 로그 기록 P95 <= 0.5s, 경고 누락률 <= 0.1% |
| Test Method | 인위적 화면 지연 주입 테스트(1.2s, 2.0s, 3.0s)로 경고 발생 시점 검증 |

### QA-05 Capture-to-Display Latency

**Scenario**

이벤트(beat 발생, 마커 조작, 모드 전환) 발생 후 시스템은 관련 화면 정보를 1초 이내 표시하고 기본 화면 갱신 주기는 500ms 이하로 유지한다.

**Quality Attribute Rationale**

체감 반응성은 이벤트 이후 화면 반영 시간과 주기적 갱신 시간을 함께 관리해야 한다.

| Field | Description |
|---|---|
| ID | QA-05 |
| Quality Attribute | Performance (성능) |
| Source of Stimulus | beat 이벤트 및 사용자 조작 |
| Stimulus | 이벤트 발생 또는 분석 UI 조작 |
| Artifact | 캡처-처리-표시 경로 및 화면 갱신 스케줄러 |
| Environment | Live 모드 상호작용 분석 |
| Response | 이벤트 관련 정보와 화면을 지연 예산 내 갱신한다. |
| Response Measure | 이벤트 발생 후 관련 화면 표기 <= 1.0s, 주기 갱신 간격 <= 500ms |
| Test Method | 이벤트 타임스탬프와 UI 반영 타임스탬프 비교, 주기 로그 샘플링 |

### QA-06 Diagnostic Usability and Readability

**Scenario**

사용자가 실시간/리뷰 화면에서 오차율·진동각 그래프를 동시에 조회하고 도움말(툴팁/가이드)을 호출하면, 시스템은 겹침 없는 레이아웃과 해석 안내를 제공해 사용자가 지정된 시간 내 핵심 상태를 인지할 수 있게 한다.

**Quality Attribute Rationale**

가독성과 해석 안내는 사용자 인지 시간과 사용성 평가로 검증 가능해야 한다.

| Field | Description |
|---|---|
| ID | QA-06 |
| Quality Attribute | Usability (사용성) |
| Source of Stimulus | 사용자의 해석/비교 과업 |
| Stimulus | 동시 그래프 열람 + 가이드 호출 |
| Artifact | 진단 UI 레이아웃, 라벨/도움말, 마커 렌더링 |
| Environment | 실시간 모니터링 또는 사후 리뷰 |
| Response | 핵심 상태를 구분 표시하고 요청된 안내를 제공한다. |
| Response Measure | 핵심 항목 식별 시간 <= 10s, 가이드 표시 지연 P95 <= 1.0s, 과업 성공률 >= 90%, 사용성 평가(SUS) >= 75 |
| Test Method | 표준 사용자 과업 테스트 + SUS 설문 + UI 충돌 자동 점검 |

### QA-07 Session Continuity for Review and Analysis

**Scenario**

사용자가 pause 후 과거 구간 탐색 또는 분석 모드 전환을 수행해도 시스템은 세션 상태와 기록 데이터를 보존한다.

**Quality Attribute Rationale**

세션 연속성은 리뷰 재현성과 비교 신뢰성의 기반이다.

| Field | Description |
|---|---|
| ID | QA-07 |
| Quality Attribute | Availability (가용성) |
| Source of Stimulus | 사용자 탐색/모드 전환 요청 |
| Stimulus | pause, 과거 탐색, 분석 모드 진입 |
| Artifact | 세션 상태 저장소, 기록 버퍼, 리뷰 표시 모듈 |
| Environment | 단일 세션의 Live/Paused 동작 |
| Response | 세션 리셋 없이 요청 구간을 재표시한다. |
| Response Measure | session reset 0회, recorded data loss 0건, 선택 후 재표시 <= 200ms |
| Test Method | pause/resume/seek 반복 테스트에서 상태 전이 및 데이터 해시 검증 |

### QA-08 Long-Term Data Load and Integrity

**Scenario**

24시간 이상 장기 데이터 조회 요청 시 시스템은 2초 이내에 결과를 로드하며, 기존 수집 데이터의 값과 레코드 무결성은 변경되지 않아야 한다.

**Quality Attribute Rationale**

장기 분석 응답성과 기존 데이터 보존성은 함께 검증되어야 운영 사용성이 확보된다.

| Field | Description |
|---|---|
| ID | QA-08 |
| Quality Attribute | Performance (성능) |
| Source of Stimulus | 장기 조회 사용자 요청 |
| Stimulus | 대용량 히스토리 데이터 조회 |
| Artifact | 장기 데이터 저장소, 통계 엔진, 대시보드 뷰 |
| Environment | 대용량 누적 데이터 환경 |
| Response | 장기 결과를 2초 내 반환하고 기존 데이터 무결성을 유지한다. |
| Response Measure | 장기 데이터 로드 완료 <= 2.0s, 조회 전/후 데이터 해시 불일치 0건 |
| Test Method | 조회 전후 데이터셋 해시 비교 + 로드 시간 측정 |

### QA-09 Extensibility and Localized Change

**Scenario**

필터/마커/라벨/시퀀스 요약 필드 변경 요청이 발생하면 핵심 수집 파이프라인 재설계 없이 국소 모듈 변경으로 반영한다.

**Quality Attribute Rationale**

반복되는 기능 개선은 변경 범위를 예측 가능하게 제한해야 한다.

| Field | Description |
|---|---|
| ID | QA-09 |
| Quality Attribute | Modifiability (변경 용이성) |
| Source of Stimulus | 개발/운영 팀 변경 요청 |
| Stimulus | 필터/마커/라벨/요약 스키마 변경 |
| Artifact | 설정, 필터 파이프라인, 마커 모듈, 요약 스키마 |
| Environment | 개발/통합 단계 |
| Response | 국소 컴포넌트 변경으로 기능을 반영한다. |
| Response Measure | 변경 요청 1건당 기존 핵심 모듈 수정 <= 1개, 회귀 결함 0건, 구현 노력 <= 5 인일 |
| Test Method | 대표 변경 시나리오 3종(필터/마커/라벨) 영향도 및 결함 추적 |
| Comment | 핵심 모듈 경계(acquisition core, timing core)는 아키텍처 문서에서 선행 확정 필요 |

### QA-10 Repeatable Verification and Explainability

**Scenario**

동일 Sim/Playback 입력을 반복 실행하거나 X/D 산출 근거를 조회할 때 시스템은 결과와 근거 정보를 제한시간 내 출력하고 동일 결과를 재현한다.

**Quality Attribute Rationale**

재현성과 설명 가능성은 결과 신뢰도와 리뷰 효율을 좌우한다.

| Field | Description |
|---|---|
| ID | QA-10 |
| Quality Attribute | Testability (테스트 용이성) |
| Source of Stimulus | 테스터/리뷰어의 반복 검증 요청 |
| Stimulus | 동일 입력 반복 실행 또는 X/D 근거 조회 |
| Artifact | Sim/Playback 결과, X/D 추적성 모듈 |
| Environment | 개발 테스트/통합 테스트/데모 리뷰 |
| Response | 결과와 trace-back 근거를 제한시간 내 제공한다. |
| Response Measure | 동일 입력 3회 반복 결과 동일(허용 오차 0), X/D trace-back coverage = 100%, 근거 조회 응답 <= 2.0s |
| Test Method | 표준 입력셋 3회 반복 실행 + trace-back API 응답시간 측정 |

### QA-11 Trace Smoothing Readability Performance

**Scenario**

실시간 측정 중 단기 노이즈가 포함된 s/d 데이터가 연속 유입되면 시스템은 500ms 주기의 렌더링 스케줄을 유지하며 평활화 추세선을 생성해 화면에 반영한다.

**Quality Attribute Rationale**

평활화 품질은 전체 처리량과 별도로 독립 검증해야 한다.

| Field | Description |
|---|---|
| ID | QA-11 |
| Quality Attribute | Performance (성능) |
| Source of Stimulus | 측정 센서 데이터 스트림 |
| Stimulus | 단기 노이즈 포함 s/d 데이터 연속 유입 |
| Artifact | 평활화 알고리즘 및 trace 그래프 반영 파이프라인 |
| Environment | 실시간 측정/렌더링 중 |
| Response | 노이즈 완화 추세선을 생성하고 500ms 주기로 화면 반영한다. |
| Response Measure | 렌더링 주기 <= 500ms, 데이터 유입부터 화면 반영까지 P95 <= 0.8s, 스파이크 빈도 50% 이상 감소 |
| Test Method | 노이즈 주입 테스트에서 평활화 전/후 변동성 및 반영 지연 비교 |

## 추적성 요약

| Requirement | Related QA | Notes |
|---|---|---|
| Integrated P1 correctness and reliability goals | QA-01, QA-02, QA-03, QA-04 | 참조 일치/저품질 입력 처리/다중뷰 유지/경고 지연 관리 |
| Integrated P2 operational usability goals | QA-05, QA-06, QA-07, QA-08, QA-11 | 반응성/가독성/세션 연속성/장기 로드/평활화 품질 |
| Integrated P3 maintainability and assurance goals | QA-09, QA-10 | 변경 비용 통제/재현 검증/근거 조회 제한시간 |
