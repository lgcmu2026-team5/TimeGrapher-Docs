# Milestone1_QA_draft.md — QAS 리뷰 보고서

> **기준**: SAP (Software Architecture in Practice, Bass·Clements·Kazman) — SEI 6-part Quality Attribute Scenario 프레임워크
> **대상**: `Milestone1_QA_draft.md` (QAS-1~12 + Constraints C-1~C-4, EN/KO 병기)
> **FR 기준 문서**: `Presentation/en/Milestone1_2-Architectural-Drivers.md` (확정본만 참조)
> **방법**: per-QAS 12 + 횡단 7개 차원 독립 리뷰 → 발견사항 123건 전수 적대적 검증(96건 확정, 27건 기각) → 완전성 비평
> **리뷰일**: 2026-06-03

---

## 0. 종합 판정

**구조적으로는 우수한 초안.** 12개 시나리오 모두 6-part가 빠짐없이 채워져 있고, 응답 척도가 정량화되어 있으며, EN↔KO 패리티도 전반적으로 양호하다. freeze(≥2s)·mismatch(snapshot ID) 같은 용어의 조작적 정의, QAS-6↔QAS-10 교차 참조, [JYP]/[SJ] 인라인 리뷰 반영 시도는 강점이다.

**그러나 Milestone 1 평가 기준으로 보면 4개의 시스템 결함이 있다:**

| # | 결함 | 심각도 |
|---|------|--------|
| S1 | **우선순위가 전혀 없음** — Milestone 1 명시 제출물("prioritized architectural drivers", 체크리스트 "Are requirements prioritized?")인데 H/M/L 랭킹·근거가 0건 | **Critical** |
| S2 | **SAP 비표준 분류 7건** — "Dependability (Reliability)"는 SAP top-level QA가 아님(QAS-3/4/5/6), Portability는 Modifiability의 하위 관심사(QAS-9), Testability는 독립 top-level(QAS-10), QAS-2는 Throughput 라벨인데 측정값이 시간(latency) | **Critical** |
| S3 | **임계값 도출 근거 부재** — 500 ms, 100 ms, SNR 14 dB, ±3 s/d, 95%, 20 MB, 80%, 5인일, 5 s/10 s 전부 브리프·도메인 어디에도 출처가 없음. Milestone 1 기준 "measures clearly derived from the overall goals" 위반 | **Major(전반)** |
| S4 | **Environment 미고정** — 성능 시나리오(QAS-1/2)의 "Measuring as usual"이 플랫폼(Pi 5)과 샘플레이트(48k/96k/192k)를 고정하지 않음. 브리프가 명시 경고("PC 성능 ≠ Pi 성능, 타깃 하드웨어에서 검증하라")한 바로 그 누락 | **Major(전반)** |

---

## 1. 분류(SAP Taxonomy) 교정표 — Critical

SAP top-level QA: Availability, Modifiability, Performance, Security, Testability, Usability (+Interoperability/Deployability/Energy/Safety). "Dependability"·"Reliability"·"Portability"는 top-level이 아니다. 잘못된 버킷은 전술(tactics) 선택을 오도한다.

| QAS | 현재 라벨 | 교정안 | 근거 |
|-----|----------|--------|------|
| QAS-2 | Performance (Throughput) | Performance (**per-stage compute budget**) — 또는 진짜 throughput 척도 부여 | 측정값 "p99 computation time ≤ 100 ms"는 시간(latency)이지 처리율이 아님. 진짜 throughput(96k SPS 입력 유지, backlog 무증가)은 현재 "0 dropped blocks" 꼬리절에만 암묵적으로 존재 |
| QAS-3 | Dependability (Reliability) | **Availability** (resource-leak resilience) | 누수·크래시·프리즈 = Availability 전술 카탈로그(resource monitoring, heartbeat, recovery) 영역. QAS-12가 이미 "Availability (Recoverability)"를 올바르게 쓰고 있어 내부 일관성도 깨짐 |
| QAS-4 | Dependability (Reliability) | **Correctness/Integrity (Consistency)** | 결함·복구가 아니라 표시값 일치(value agreement) 문제. 브리프의 "Correctness" 드라이버("displayed values … remain aligned … across the GUI and summaries")에 직접 추적됨. 필요한 전술은 redundancy가 아니라 single-source-of-truth/snapshot |
| QAS-5 | Dependability (Reliability) | **분리 권고**: (a) Availability — graceful degradation("signal weak" 표시, 잘못된 값 0건) / (b) Accuracy — 잡음 하 검출률·일오차 | 한 시나리오에 두 QA가 혼합. 전술이 다름: (a) signal-quality 분류 + degraded-mode UI, (b) 검출 알고리즘 정밀도 |
| QAS-6 | Dependability (Reliability) | **Accuracy (Measurement Correctness)** | onset/peak 위치 오차 vs ground truth = 도메인 드라이버 "Measurement Accuracy, Error Detection, and Handling" 그 자체. 검증 수단이 Testability(QAS-10)일 뿐, 충족 대상 QA는 정확도 |
| QAS-9 | Portability | **Modifiability (Portability)** | SAP에서 Portability는 Modifiability의 하위 관심사(abstraction-layer 전술). QAS-7/8/10의 "Modifiability (X)" 표기 관례와도 정렬됨 |
| QAS-10 | Modifiability (Testability) | **Testability** (독립) | Testability는 SAP 독립 top-level QA. Extensibility/Modularity(QAS-7/8)와 달리 Modifiability 하위가 아님. 통제 전술도 다름(record/playback, specialized interfaces, observability) |

> EN 헤더와 KO 헤더(QAS-3: L33/L190 등) 양쪽 모두 수정할 것.

---

## 2. 시나리오별 확정 발견사항

### QAS-1 · Performance (Latency)

| 심각도 | 발견사항 | 권고 |
|--------|----------|------|
| Major | **500 ms 임계값 무근거.** 브리프는 "minimize end-to-end latency"와 측정·보고 의무만 부여, 수치 목표 없음. 28,800 BPH 기준 비트 주기 ~125 ms → 500 ms는 약 4비트 주기의 지연인데 왜 허용되는지 설명 없음 | 비트 주기 기반 도출 한 줄 추가(예: "≤ 4 beat periods @28,800 BPH, 체감 실시간 기준") 또는 provisional 표기. QAS-2의 100 ms 예산과의 관계(나머지 400 ms는 어디에 쓰이나)도 명시 |
| Major | **Environment "Measuring as usual" 미고정** — 플랫폼·샘플레이트에 따라 결과가 달라져 재현 불가 | "Live, Raspberry Pi 5 (8 GB), 96,000 SPS objective(48,000 min에서도 충족), GUI 활성, 연속 부하" 로 고정 |
| Major | **"0 dropped blocks / 0 missed beats / 10-min" 절이 QAS-2와 verbatim 중복** — 하나의 시스템 속성을 두 시나리오가 이중 계상 | 단일 소유자를 QAS-2(keep-up)로 지정하고 QAS-1에서는 삭제(필요시 "per QAS-2" 전제로만 참조). QAS-3도 이미 "per QAS-2"로 위임하는 패턴을 따름 |
| Minor | narrative "under 500 ms"(<) vs 표 "≤ 500 ms" 연산자 불일치(EN/KO 동일하게 존재) | "≤"로 통일 (KO "미만"→"이하"). QAS-2도 동일 수정 |

### QAS-2 · Performance (Throughput)

| 심각도 | 발견사항 | 권고 |
|--------|----------|------|
| Critical | **라벨↔척도 불일치** (§1 참조). 진짜 throughput 척도 부재 | 권고안: "96,000 SPS objective(48,000 min) 입력을 지속 유지: 분석 backlog(큐 깊이) 증가 추세 0, dropped blocks 0 over 10-min" 을 주 척도로, 100 ms 예산은 보조(수단)로 강등 |
| Major | **100 ms 예산이 블록 도착 주기와 미연결 → "0 dropped blocks"와 자기모순 가능.** 블록 크기 미정. 블록이 100 ms보다 자주 도착하면 p99=100 ms는 곧 backlog 누적·드롭을 의미 | 블록 크기 N과 샘플레이트를 명시하고 예산을 도착 주기에 결박: "p99 ≤ 0.8 × (N / fs), fs = 96,000 SPS 기준(48k에서 재확인)" |
| Major | **"분석 처리(버퍼링·표시 제외)" 경계 미정의** — 어느 타임스탬프 사이를 재는지 두 엔지니어가 다르게 측정 | 계측 지점 명명: t_block_handed_to_analysis → t_result_produced, 포함 단계(비트 검출, rate/amp/beat-error 계산) 열거 |
| Major | **"0 missed beats" ground truth 부재** — Live에서는 진짜 비트 수를 알 수 없음 | "missed beat" 정의 + Sim/Playback 기지(旣知) 비트 스케줄 대조로 검증 방법 명시(QAS-6/10 연계) |
| Minor | Source("The analysis/computation stage")가 artifact 자신 — 자기자극 구조 | Source = "오디오 입력/획득 파이프라인(샘플레이트 주기로 블록 전달)" |

### QAS-3 · No Degradation Over Long Runs

| 심각도 | 발견사항 | 권고 |
|--------|----------|------|
| Critical | **분류 오류** → Availability (§1) | 재라벨 |
| Major | **"RSS ≤ 20 MB / 5-min" 임계 무근거 + 누수 검출 의도와 모순 가능** — 20 MB/5min 미만으로 새는 프로세스는 통과하면서 장시간엔 고갈; 정상적 일회성 할당은 20 MB를 넘을 수 있음 | 추세 기반 척도로 교체: "환경에 정의된 장기 구간(≥2 h, [JYP] 권고) 동안 임의 30분 창의 RSS 선형 기울기 ≤ X MB/h(통계적 검정 방법 명시)". 절대 캡을 유지하려면 8 GB 헤드룸에서 도출한 프로세스 예산을 먼저 선언 |
| Minor | **[JYP] 코멘트(10분→≥2h)가 여전히 본문에 미적용** — 코멘트와 척도가 모순된 채 공존 | [JYP] 권고를 본문에 반영하고 코멘트는 해소 처리 |
| Minor | Source "The system" 퇴화(자기자극) | Source = 오퍼레이터/장기 성능 테스트(FR-07)가 연속 측정을 개시 |
| Minor | narrative의 "(keeping up … per QAS-2)" 전제가 표에는 없음 | Environment 셀에 전제 추가(EN/KO 모두) |
| Minor | freeze 검출 방법 미정(렌더 heartbeat 등) + 2 s 근거 미연결 | 검출 메커니즘 한 줄 + responsive-GUI 목표와의 관계 명시 |

### QAS-4 · Consistent Values Across Displays

| 심각도 | 발견사항 | 권고 |
|--------|----------|------|
| Critical | **분류 오류** → Correctness/Integrity (§1) | 재라벨 |
| Major | **설계 처방 + 자기참조** — snapshot ID라는 특정 메커니즘을 요구사항에 박고, 척도도 그 메커니즘으로 정의("different snapshot IDs"). 설계안이 아니라 목표로만 평가 가능해야 함 | Response를 관찰 가능 행위로: "한 프레임에 함께 표시되는 모든 값·그래프는 단일 측정 결과에서 파생되어 상호 일치한다." snapshot ID는 비구속 권고 전술로 강등 |
| Major | **관측 창·입력·관측 방법 부재** — 몇 프레임을, 어떤 입력으로, 어떻게 snapshot ID를 읽어 검사하는지 없음 | "10-min Sim/Playback 연속 실행, 샘플링된 전 프레임에서 표시 쌍 전수 비교, 각 표시는 소스 스냅샷을 로그/디버그 오버레이로 노출" 추가 |

### QAS-5 · Under Noisy or Weak Signals

| 심각도 | 발견사항 | 권고 |
|--------|----------|------|
| Critical | **분류 오류 + 두 QA 혼합** → Availability + Accuracy 분리 (§1) | 분리 또는 명시적 이중 라벨 |
| Critical | **ground truth 순환성** — 기준 장비(WeiShi)도 같은 잡음에 노출되는 음향 계측기. 둘이 같이 틀려도 ±3 s/d "일치"로 통과 가능. 기준 장비 자체 정확도도 미정 → ±3 s/d 인증의 분해능 부재. QAS-6은 이미 "실기기 ground truth 불가"를 인정하고 합성 신호로 전환했는데 QAS-5가 역행 | 잡음 케이스는 **Sim 합성 신호 + 보정된 잡음 주입**으로: 검출률은 주입된 기지 비트 수 대비, 일오차는 프로그래밍된 rate 대비. 기준 장비는 클린 조건 sanity check로 강등 |
| Major | **SNR 14 dB·95%·±3 s/d·1,000 beats 전부 무근거** — 팀의 다른 문서(Junsung QAS, QA-02)는 SNR을 이미 "실험 후 확정(TBD)"으로 처리해 자체 모순 | 각 수치에 출처 한 줄 또는 **provisional(실험 확정 예정)** 표기로 통일 |
| Major | **SNR 계산·잡음 주입 방법 미정** — 임펄스성 신호에서 무엇을 신호/잡음으로 재는지(피크 vs RMS, 대역, 창), 14 dB를 어떻게 만들어 유지하는지 없음 → 재현 불가 | 신호 측정량·잡음 기준 대역·적분 창·주입 방법(Playback/Sim 믹싱) 명시 |
| Major | **"0 wrong values" 미정의** — 비검출과 오검출의 구분, 집계 창 없음. ≥95% 검출(≈5% 미검출 허용)과의 경계 모호 | 정의 예: "'signal weak' 플래그 없이 표시된 수치 중 ground truth 대비 허용오차 초과인 것"; 평가 창 명시 |
| Major | **[SJ] X/D 제외 규칙이 FR-04-06과 중복** — "X = 유효 포지션의 평균"은 기능 규칙(FR 소유). 같은 규칙이 QAS-4/5/10/11 네 곳에 다른 프레이밍으로 산재 | 포함/제외 정의는 FR-04-06 한 곳에 두고, QAS-5는 품질 측면(잡음 시 invalid 처리)만 참조 |

### QAS-6 · Pinpointing Beats Precisely

| 심각도 | 발견사항 | 권고 |
|--------|----------|------|
| Critical | **분류 오류** → Accuracy (§1) | 재라벨 |
| Major | **"maintain timing precision throughout" 무측정** — 척도는 per-beat 위치 오차뿐. "throughout"이 시간적 드리프트인지 파이프라인 단계 관통(도메인 원문: "preserve timing precision throughout acquisition, filtering, event detection, and calculation")인지 모호 | 도메인 의미로 재서술("모든 처리 단계를 관통하여") + 통계량·표본 명시("합성 비트 ≥N개에 대해 최대 오차 ≤ 0.1 ms") |
| Major | **"so beat error is resolved down to 0.1 ms" 혼동** — 검출 위치 정확도와 표시 분해능은 다른 양. 인과("so")도 성립 안 함(beat error는 두 시점의 차) | 해당 절 삭제 또는 별도 검증 방법을 가진 독립 절로 분리 |
| Major | **QAS-10 교차 참조가 댕글링** — QAS-10에는 "기지 onset/peak 합성 신호" 능력·척도가 실제로 없음 | QAS-10에 해당 능력 추가(아래 QAS-10 참조) |
| Major | **샘플 환산 부정확 + 단일 레이트 고정** — 0.1 ms = 9.6 샘플@96k(10이 아님); 48k(min)에서는 4.8 샘플 → 서브샘플 보간 필수인데 언급 없음; 192k=19.2 | "≤ 0.1 ms (= 4.8/9.6/19.2 samples @48k/96k/192k; worst case는 48k min)"로 교정, 검증 대상 레이트 명시 (EN L70/L79, KO L227/L236) |
| Minor | 0.1 ms 자체의 도출 근거 미기재 | "0.6 ms '양호' beat error 임계(Draft)의 1/6 수준이라 임상적으로 유의한 차이를 해상" 류의 한 줄 추가 |
| Minor | 활성 FR 미인용 | Sim mode(FR-05-05/FR-12-16), Onset/Peak 정의(FR-08-06, Glossary) 참조 추가 |

### QAS-7 · Adding a New Graph

| 심각도 | 발견사항 | 권고 |
|--------|----------|------|
| Major | **"≤ 5 person-days"는 아키텍처-판정 불가 척도** — 설계가 아니라 개발자 숙련도의 함수. Milestone 1 actionability("설계가 지원하는지 판정 가능") 위반 | pass/fail 척도에서 제외, 참고용 계획 추정치로 강등(산정 범위 명시). 구조 척도(≤1 module, 0 regressions)가 주 척도 |
| Major | **"0 regressions" 검출 방법 부재** — 회귀 스위트/기존 기능 목록 없이는 0의 의미 없음 | "기존 기능 회귀 테스트 셋을 변경 전후 재실행, 기존 통과 테스트 실패 0건"으로 정의, QAS-10 연계 |
| Major | **Stimulus(측정/필터/그래프 3종) vs 척도(그래프만) 불일치** — 필터(G12 F0–F3)·파생 측정값 추가는 터치 프로파일이 다름 | 종류별 척도 부여(그래프: 등록부 1개 / 필터: 파이프라인 등록 지점 1개, 하류 무변경 / 측정값: 계산 레지스트리 1개) 또는 stimulus를 그래프로 축소 |
| Minor | "test in isolation"의 척도가 QAS-7에 없음(QAS-10이 소유) | "(격리 테스트 가능성은 QAS-10이 규율)" 교차 참조 |
| Minor | narrative "completing within schedule"이 표에 없는 무정량 결과 | narrative에서 삭제, "tight schedule"은 Environment 맥락으로만 |

### QAS-8 · Fixing in One Place

| 심각도 | 발견사항 | 권고 |
|--------|----------|------|
| Minor | **검증 절차 부재** — [JYP]가 모듈 단위·대표 시나리오·횡단 제외까지 처방했지만, "ripple" 판정 규칙과 실행 절차는 여전히 없음 | [JYP] 위에 추가: "사전 정의된 단일 책임 변경 시나리오 N≥3건 실행; 책임 경계 밖 모듈의 소스/테스트 수정 발생 = ripple; 각 케이스 ≤1 모듈, ripple 0" |
| Minor | **Artifact가 베이스라인을 사실로 단정** — "모든 기능이 한데 뭉쳐 있던 메인 화면"은 브리프의 베이스라인 설명(Summary Bar + Tabbed Panel + Control Panel로 이미 분리)과 상충 | 중립 표현으로: "변경 대상 책임을 소유한 모듈". 과거 엉킴은 회피할 리스크로 격하 |
| — | **[JYP] 코멘트 자체는 타당 — 그러나 본문 척도가 여전히 "1 file"** | [JYP] 권고("≤1 module 제외 자기 테스트")를 본문에 적용 |

### QAS-9 · Running on Other Devices/OSes

| 심각도 | 발견사항 | 권고 |
|--------|----------|------|
| Major | **분류 오류** → Modifiability (Portability) (§1) | 재라벨 (EN L105, KO L262) |
| Major | **Artifact(사운드 입력부)로는 OS 포팅 불가** — OS 이전은 GUI/Qt·스레딩·파일경로·빌드 툴체인까지 관통(C-2/C-3). 현재 범위로는 "0 lines of domain code" 예산이 OS 케이스에 비현실적 | **분리**: (a) 사운드 장치 포팅 — Artifact=오디오 입력 어댑터, 척도 유지 / (b) OS 포팅 — Artifact=플랫폼 추상 계층, 별도 현실적 예산 |
| Major | **"module"·"domain code" 미정의 + 시험 방법 부재** — QAS-7/8/9가 공유할 모듈 경계 정의가 어디에도 없음 | 정의 노트 1곳 신설(또는 Milestone 2 module view 참조 예고): 모듈 = 단일 인터페이스 뒤의 응집 단위(자기 테스트 제외); domain code = 분석·계산 단계(획득/플랫폼/배선 제외, Draft의 5-계층 분리 인용) |
| Major | **Environment 순환** — "When porting or adding"은 Stimulus 재진술 | "개발/유지보수 시점, 기존 코드베이스 대상, 타깃 = C-3의 두 플랫폼 + 신규 1종" |
| Minor | Portability를 desired QA로 명시한 소스 없음 — 실제 드라이버는 Draft의 "platform-specific concerns 분리" | 해당 드라이버와 C-3로 추적 명시 |
| Minor | QAS-12와 artifact 중복(사운드 입력부) | 설계시(QAS-9) vs 런타임(QAS-12) 구분 한 줄 |

### QAS-10 · Testing Parts in Isolation

| 심각도 | 발견사항 | 권고 |
|--------|----------|------|
| Major | **분류 오류** → Testability 독립 (§1) | 재라벨 (EN L117, KO L274) |
| Major | **"≥ 80%" 무근거 + "core analysis stages" 미열거** — 분모가 없어 커버리지가 무의미. QAS-2/6도 같은 미정의 집합에 의존 | 핵심 분석 단계를 1곳에서 열거(비트 검출, onset/peak 위치, rate/amplitude/beat-error 계산, X/D 집계)하고 QAS-2/6/10이 참조; 커버리지 유형(line/branch) 명시; 80%는 팀 선택 목표임을 표기 |
| Major | **"100% of unit tests runnable without real hardware"는 동어반복** — 팀이 작성한 테스트 집합의 속성일 뿐, 아키텍처의 격리 가능성을 측정 안 함(테스트 1개면 통과) | "각 핵심 단계가 소스 인터페이스 경유 Sim/Playback 주입만으로 구동 가능(계약 테스트가 무오디오 호스트에서 통과)"으로 교체 |
| Major | **QAS-6이 의존하는 능력 부재** — 기지 onset/peak 합성 신호 생성·검증 능력이 척도에 없음 | Response/척도에 추가: "Sim mode가 onset/peak 샘플 위치가 선험적으로 알려진 합성 비트 신호를 생성(BPH/Beat Error 파라미터에서 유도) → QAS-6 위치 정확도 검증 지원" |
| Minor | 사운드 입력부가 artifact에는 있는데 척도에는 없음 | 입력부 격리 척도 1줄 추가(위 계약 테스트로 겸용 가능) |
| Minor | narrative "Sim/Playback input" vs 척도 "standard-position input" 불일치 | "표준 포지션 셋(CH/CB/6H/9H/3H/12H, FR-01-03/FR-04-04)을 커버하는 동일 Sim/Playback 데이터셋 3회 반복"으로 단일화 |
| Minor | "X/D trace-back coverage = 100%" 미정의(모집단·증거 기준) | "테스트 셋의 모든 (X,D)에 대해 포함/제외 포지션 집합을 시스템 출력에서 열거 가능; 전 summary에서 검증" |

### QAS-11 · Low-Resolution Touchscreen

| 심각도 | 발견사항 | 권고 |
|--------|----------|------|
| Major | **"9 mm ≈ 48 px" 환산이 패널 크기 미확정 상태에서 성립 불가** — 이 등식은 ~135 ppi(≈7인치 800×480, 공식 RPi 터치스크린 사양)에서만 성립. 그런데 Draft 자체가 모순(본문 "5-inch" L481 vs 헤더 "8 Inch" L472): 5″≈187 ppi→9 mm≈66 px, 8″≈117 ppi→9 mm≈41 px. 캘리퍼스로 재느냐 픽셀로 세느냐에 따라 pass/fail이 갈림 | **물리 mm를 유일 규범 기준으로** 하고 "(≈48 px)" 괄호는 삭제하거나, 실제 패널 크기를 발주처에 확인·확정한 뒤 그 pitch에서 px를 재유도해 "advisory" 표기. Draft의 5″/8″ 모순은 open question으로 기록 |
| Major | **"readable at ~40 cm" 판정 기준 부재** — 12개 QAS 중 유일한 무정량 절. 과업·성공률·시각 기준 없음 | 피험자 없는 지각 사양으로 교체: "40 cm에서 글리프 각높이 ≥16 arcmin(≈물리 높이 1.9 mm) + 대비 ≥4.5:1(WCAG AA)" — 또는 "≥24 px + 동시표시 + 무스크롤"을 규범으로 삼고 'readable'은 비규범 참고로 강등 |
| Minor | **[SJ] "5초/10초 내 식별" 프로토콜 부재** — 사람-과업 측정인데 피험자 수·시작 상태·성공률 기준 없음 | "대표 사용자 K명, sequence-review 화면에서 시작, ≥90% 시도 성공" 또는 구조 속성(활성 포지션 하이라이트 + X/D 인접 배치, 검사로 확인)으로 전환 |
| Minor | Environment에 패널 물리 크기 미기재(척도가 크기 의존인데) | 확정 크기를 Environment에 기록 |
| Nit | EN narrative "Raspberry Pi"(무세대) vs 표 "Raspberry Pi 5" | 첫 언급부터 "Raspberry Pi 5" |
| — | **[JYP] 멀티터치 범위 제외 코멘트: 타당, 잘 처리됨** | 유지 |

### QAS-12 · Audio Device Disconnect/Reconnect

| 심각도 | 발견사항 | 권고 |
|--------|----------|------|
| Major | **"0 data corruption" 미정의** — 형제 시나리오는 추상어를 정의(QAS-3 freeze, QAS-4 mismatch)했는데 여기만 없음 | 정의 예: "corruption = 재연결 후 측정 레코드가 (a) 단절 전후 샘플 혼입, (b) torn buffer 샘플 포함, (c) 단절 경계에서 비단조 타임스탬프 중 하나에 해당" |
| Major | **에러-비분리 경로 무측정** — Stimulus는 "분리 또는 오류"인데 복구 척도는 재연결 경로만. 장치 부착 상태의 스트림/드라이버 오류(ALSA xrun 등)는 척도 없음 | 분리: (A) 물리 분리→재연결 10 s / (B) 복구 가능 스트림 오류→재오픈 N s. 또는 "fault 해소(재연결 또는 스트림 재오픈) 후 10 s 내 재개"로 일반화 |
| Minor | 5 s/10 s 임계 무근거 | Draft L98("사용자가 추측하게 두지 말 것")로 추적하거나 provisional 표기 |
| Minor | 시험 방법 부재(주입 방식·시행 횟수) | "활성 측정 중 unplug/replug ≥20회 + 주입 스트림 오류 ≥5회, 전 시행에서 충족" |
| Minor | **Draft의 "preserve the last useful reading" 요구 미반영** | "정전 구간 동안 최근 유효 판독 유지(stale 플래그); 재연결 시 기캡처 sequence/trace 데이터 손실 0" 추가 — "0 data corruption"의 조작화도 겸함 |

---

## 3. 커버리지 갭 — 누락 시나리오/기록

브리프·Draft의 명시 목표 중 QAS가 비어 있는 곳:

| 심각도 | 갭 | 권고 |
|--------|-----|------|
| Critical | **우선순위 부재** (S1) | 전 QAS에 (비즈니스 중요도, 기술 리스크) H/M/L + 한 줄 근거. 아키텍처를 가장 좌우하는 2–3개(latency, accuracy/correctness, extensibility) 식별 — Milestone 3 발표에서도 요구됨 |
| Major | **클린 조건 계산값 정확도 미커버** — 특히 **amplitude는 어떤 QAS에도 없음**(lift angle 의존, Draft: "incorrect setting will produce incorrect amplitude estimates"). 현재 커버는 QAS-4(일치≠정확), QAS-5(잡음 하 rate만), QAS-6(이벤트 위치만) | 신규 Accuracy QAS: Sim 주입 파라미터(BPH/Error Rate/Amplitude/Beat Error, Draft L175-183)를 ground truth로 클린 조건에서 rate(s/d)·amplitude(°)·beat error(ms) 오차 상한 |
| Major | **샘플레이트 사다리(48k min/96k obj/192k stretch)가 0개 QAS에 등장** — graded 성능 목표인데 성능 척도와 미결박 | QAS-1/2 척도·Environment에 "48k(gating)·96k(gating)·192k(측정만)" 명시 |
| Major | **세션 연속성 미커버** — "all graphs run continuously", "pause/seek 시 기록 손실·리셋 없이"는 반복 명시 요구(FR-05-06/07, FR-08-03, FR-12-17/18의 기반)인데 QAS 없음 | 신규 QAS: pause/seek/탭 전환 시 세션 리셋 0, 기록 손실 0, 복귀 ≤N ms |
| Major | **시작·모드 전환 환경 부재** — 전 QAS가 "Measuring as usual". SAP는 startup/transition 환경 커버를 기대. Live↔Playback↔Sim 전환·Start→첫 판독 시간 무척도 | 시작(Start→첫 유효 판독 ≤N s)·모드 전환(전환 ≤N s, 세션 보존) 시나리오 1–2개 |
| Major | **Pi 자원 예산이 메모리뿐** — 96k 지속 부하에서 CPU 헤드룸·서멀 스로틀링이 브리프가 경고한 바로 그 리스크 | QAS-3 확장 또는 신규: "96k SPS 연속 실행 시 CPU 평균 ≤~70%, 서멀 스로틀링 이벤트 0" |
| Major | **AI/TinyML PoC 무언급** — 양 브리프의 System Requirement인데 QAS도 scope-out 기록도 없음 → 의도적 제외인지 누락인지 구분 불가 | "Deferred Drivers" 노트로 명시적 제외 기록(근거: time-box, "where feasible") 또는 경량 Integrability QAS |
| Major | **경보 어노시에이션(usability 핵심) 미커버** — Draft의 가장 긴 품질 서사("사용자가 추측하게 두지 말 것")와 FR-02-05/09, FR-06-11/13(경보 FR들)에 대응하는 품질 척도 없음. QAS-11은 가독성·탭 도달만 측정 | 신규 Usability QAS: out-of-tolerance(amplitude 270–300° 밖, beat error >0.6 ms, running late) 발생 시 N초 내 경보 표시, 정의된 테스트 셋에서 누락 0 |
| Minor | **Security·Deployability scope 미선언** — 킥오프 Goals가 security를 명시 거명; 선언 없는 부재는 누락과 구분 불가 | "QA Scope" 노트: Milestone 1 범위 외 QA와 한 줄 근거 |
| Minor | 인터랙티브 타이밍 포인트/구간 선택(G08/G10 기반) 품질 척도 없음 | scope 결정 기록 또는 QAS-11 확장(선택→구간 판독 반영 ≤N ms, 표시 구간 = 마커 위치 ± 허용오차) |

---

## 4. Constraints 리뷰

| 항목 | 발견사항 | 권고 |
|------|----------|------|
| **누락 C-5** (Major) | **제공 Qt 베이스라인 위에서 확장**이라는 핵심 외부 부과 제약이 없음 — 언어·프레임워크·IDE를 구속하는 전형적 constraint | "C-5: 시스템은 제공된 Qt 기반 TimeGrapher 베이스라인(TimeGrapher_v10.5_Student, Qt Creator 프로젝트)을 확장하여 구현한다." (버전은 킥오프 기준 v10.5; Draft의 v10.4는 구버전 표기) |
| **누락 C-6** (Major) | 샘플레이트 운영점(48k/96k/192k)이 외부 부과 목표인데 어디에도 anchoring 없음 — QAS-6의 "96,000 SPS"가 출처 없이 떠 있음 | "C-6: 시스템은 정의된 샘플레이트 운영점 — 48,000(min)/96,000(objective)/192,000(stretch) SPS — 을 지원한다." QAS들은 C-6 참조 |
| C-4 (Minor) | AGC-off는 시스템이 보장 가능한 설계 제약이 아니라 **운영 전제조건**(OS 믹서에서 수동 설정·검증) | "C-4 — (운영 전제) 호스트 오디오 장치는 측정 전 AlsaMixer에서 AGC 비활성 확인; 시스템은 AGC-off 입력을 전제로 동작" |
| C-1 (Minor) | 패널 물리 크기 미기재 + 소스 모순(5″ vs 8″) 미해결 — QAS-11 mm 척도의 기반 | 실제 크기 확인 후 C-1(또는 C-2)에 기록; 모순은 open question 로그에 |
| 상호 참조 (Minor) | C-3↔QAS-9, C-2↔QAS-11이 서로 무참조 — 드리프트 위험 | QAS-9 Environment에 "타깃 플랫폼은 C-3이 고정" 한 줄(QAS-9를 C-3의 두 플랫폼으로 한정하지는 말 것 — 가치는 신규 환경에 있음) |

---

## 5. 기존 [JYP]/[SJ] 인라인 코멘트 처리 상태

| 코멘트 | 판정 | 상태 |
|--------|------|------|
| [JYP] QAS-3 (장기 정의·10분 상향) | **타당** | **미적용** — 본문 척도가 여전히 10분. 적용 후 코멘트 해소 필요 |
| [JYP] QAS-8 (file→module, 대표 시나리오, 횡단 제외) | **타당** | **미적용** — 본문이 여전히 "1 file". 동일 |
| [JYP] QAS-11 (멀티터치 범위 제외) | **타당** | 처리됨 — 유지 |
| [SJ] X/D 스레드 (QAS-4/5/10/11) | **타당, 배치 적절** | 보완 2건: ① QAS-5의 X/D 제외 규칙은 FR-04-06과 중복 → FR로 이관 ② "trace-back coverage" 등 용어 정의 보강(§2 QAS-10) |

---

## 6. 권고 조치 우선순위

**P1 — Milestone 1 제출 전 필수 (심사 기준 직결)**
1. 전 QAS 우선순위 부여 + 랭킹 근거 (§3 첫 행)
2. 분류 교정 7건 (§1) — EN/KO 헤더 동시
3. 임계값마다 도출 근거 한 줄 또는 "provisional(실험 확정)" 표기 통일 (§S3) — Planned Experiments 문서와 연결하면 가장 자연스러움
4. QAS-1/2 Environment에 Pi 5 + 샘플레이트 고정 (§S4)
5. [JYP] QAS-3·QAS-8 코멘트 본문 반영(현재 모순 공존 상태)

**P2 — 정합성·검증가능성**
6. "0 dropped/missed/10-min" 단일 소유자(QAS-2) 지정, QAS-2에 진짜 throughput 척도
7. QAS-5 ground truth를 Sim 합성+잡음 주입으로 전환, SNR 정의 명시
8. QAS-4 설계 처방 제거(관찰 가능 행위로), 관측 방법 추가
9. QAS-6 샘플 환산 교정(9.6), "throughout"·"resolved" 정리, QAS-10에 합성 ground-truth 능력 추가
10. QAS-12 corruption 정의 + 오류 경로 척도 + last-reading 보존
11. "module"/"domain code"/"core analysis stages" 정의 노트 1곳 신설(QAS-2/6/7/8/9/10 공유)
12. QAS-11 mm 단일 규범화 + 패널 크기 확정(open question)

**P3 — 커버리지 보강 (필요 시 Milestone 1엔 scope 노트만)**
13. 신규 QAS 후보: 클린 조건 정확도(Sim ground truth), 세션 연속성(pause/seek), 경보 어노시에이션, 시작/모드 전환, CPU/서멀 예산
14. C-5(Qt 베이스라인)·C-6(샘플레이트) 추가, C-4 재서술
15. AI/TinyML·Security·Deployability scope 선언 노트

**P4 — 폴리시**
16. narrative "under" vs 표 "≤" 통일(QAS-1/2, EN/KO)
17. Source 퇴화 수정(QAS-2/3), QAS-3 전제의 표 반영, QAS-7 "test in isolation"→QAS-10 참조, QAS-9↔QAS-12 구분 노트, QAS-10 입력 표현 단일화

---

*리뷰 산출 통계: 에이전트 114개(리뷰어 19 + 검증자 94 + 비평가 1), 원발견 123건 → 적대적 검증 후 확정 96건(critical 10·major 49·minor 34·nit 3) + 비평가 추가 6건, 기각 27건. 본 보고서는 확정 발견사항을 중복 제거·통합한 것임.*
