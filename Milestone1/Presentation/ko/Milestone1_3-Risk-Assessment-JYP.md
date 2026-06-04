# Risk Assessment

> TimeGrapher Reference Architecture — Milestone 1
> 팀 5 리스크 통합 정리본 (RiskAssessment.xlsx 기반 최종본)

---

## 1. 평가 방법 (How We Assessed)

본 리스크 평가는 SAP(Software Architecture Practice) 절차를 따른다.

1. **아키텍처 드라이버 우선순위화** — 비즈니스 중요도와 기술적 리스크를 H/M/L로 평가
2. **품질속성 시나리오(QAS)로 정량화** — Source → Stimulus → Artifact → Environment → Response → Response Measure
3. **리스크를 "불확실성(물음표)"으로 식별** — 기능 추가 / 리팩터링 / 통합 / 일정 / 이해 부족으로 분리
4. **영향도(I) × 발생가능성(P)로 랭킹** — 숫자 점수보다 설명 가능한 H/M/L 사용
5. **고위험 항목은 실험(Spike/PoC)으로 검증** — 질문 · 완료기준 · 측정방법 · 데이터셋 · 합격기준 명시
6. **리스크–실험–의사결정 추적성 유지** — 소유자 · 상태(Open/Mitigating/Pass) · 잔여 리스크 관리

### 점수 기준

| 등급 | 영향도 (Impact) | 발생가능성 (Probability) |
|:----:|------|------|
| **Low** | 사용자 영향 없음 또는 우회 가능 | 드물게 발생 |
| **Medium** | 특정/비핵심 기능에서 오류 발생 | 정상 조건에서 발생 가능 |
| **High** | 시스템 실패 또는 서비스 완전 중단 | 거의 항상 발생 |

### 상태(Status) 범례

| 표기 | 의미 |
|:----:|------|
| 🔴 **Open** | 최우선 리스크. 실험/스파이크로 조기 검증 필요 |
| 🟡 **Mitigating** | 완화 방향이 정해져 진행 중 |
| ⚪ **Watch/Pass** | 낮은 우선순위. 관찰만 하거나 현 상태로 진행 |

### 참조 인덱스 (QAS · FR)

각 리스크의 **관련 QAS**는 [Milestone1_QA_Final_1.md](../../Milestone1_QA_Final_1.md), **관련 FR**은 [Milestone1_2-Architectural-Drivers.md](Milestone1_2-Architectural-Drivers.md)를 참조한다.

| QAS | 품질 속성 | B | R |
|----|------|:--:|:--:|
| **QAS-1** | Performance (Latency) — 소리 입력→화면 표시 ≤500ms | H | H |
| **QAS-2** | Accuracy — 비트 위치 ≤0.1ms 정밀 검출 | H | H |
| **QAS-3** | Availability (Graceful Degradation) — 잡음·약신호 시 "신호 약함" | H | H |
| **QAS-4** | Consistency — 표시 간 값 일치(불일치 0) | H | M |
| **QAS-5** | Modifiability (Extensibility) — 새 측정/필터/그래프 추가 | H | M |
| **QAS-6** | Usability — 800×480 터치스크린 가독·조작 | M | M |

> **QAS 갭 표기:** 복구성(device disconnect), 장기 저장 용량, AI 기능 등 일부 리스크는 현 6개 QAS로 직접 커버되지 않는다. 해당 행은 `QAS 갭`으로 표기하며 향후 QAS 보강 후보다. (FR 그룹: **G01–G12** = FR-01~FR-12 디스플레이 기능군)

---

## 2. 리스크 레지스터 (Risk Register)

### A. 실시간 성능 (RPi) — 최대 위험군

| ID | 리스크 | 품질속성 | 관련 QAS | 관련 FR | P | I | 완화 방향 | 상태 / 팀 결정 |
|----|--------|----|------|------|:--:|:--:|--------|--------|
| **R-A1** | RPi5에서 96k(목표)/192k(스트레치) 샘플레이트의 캡처→처리→표시를 실시간 유지 못함 → block drop / missed beat | Performance (Real-Time) | **QAS-1** | FR-08-01, FR-12-04·14, FR-05-03 | H | H | 1주차 spike로 RPi 처리 한계 측정 후 샘플레이트 목표 확정(192k는 stretch로 격하) | 🔴 실험 후 스펙 결정 |
| **R-A2** | 4-필터 동시 파이프라인(F0→F1→F2→F3) + 다중 그래프 탭 동시 렌더 부하로 <20 FPS·UI freeze | Performance | **QAS-1** | FR-12-01·04·05·13 | M~H | H | 공유 입력버퍼 재사용, 비활성 뷰 렌더 중단, FPS 예산 측정 | 🟡 동시/단일 뷰는 성능 확인 후 결정 |
| **R-A3** | 종단 지연 목표(p99 ≤500ms, 평균 ≤100 / 최악 ≤200ms) 미달 | Performance (Latency) | **QAS-1** | FR-08-01, FR-12-04 | M | H | 캡처/처리/표시 단계별 지연 계측·백로그 모니터링 | 🟡 최악 가정 하 최적화 또는 기능 약화 |
| **R-A4** | 장시간 누적(FR-07, 24h+)·연속 실행 시 메모리 누수/증가로 열화 | Reliability (+Performance) | **QAS-1** (연속 실행) | FR-07-01…03·10 | M | M | 장기 RSS 추세 모니터, 버퍼 상한·집계(aggregation) 설계 | 🟡 현 코드 기준 메모리 릭 확인 (실험) |

### B. 신호처리 / 측정 정확도 — 최대 위험군

| ID | 리스크 | 품질속성 | 관련 QAS | 관련 FR | P | I | 완화 방향 | 상태 / 팀 결정 |
|----|--------|----|------|------|:--:|:--:|--------|--------|
| **R-B1** | 비트 onset/peak 검출 정밀도 ≤0.1ms(≈10샘플@96k) 달성 곤란 → rate·beat error·amplitude 전반 오염 | Accurateness (Measurement) | **QAS-2** | FR-08-04…06, FR-05-13, FR-06-01…04 | H | H | 합성신호(정답 known) 벤치로 검출 알고리즘 조기 검증 | 🔴 현 로직 확인 및 필요 시 개선 |
| **R-B2** | 주변소음/약신호(SNR≥14dB, 검출률≥95%)에서 오검출. bad-data가 정상값처럼 표시되어 X/D 요약 오염 | Robustness/Availability (+Accuracy) | **QAS-3** (+QAS-2) | FR-12-08, FR-05-17…18, FR-04-06 | M~H | H | 신호품질 판정, bad-data는 "signal weak"로 격리·X/D 제외 | 🔴 노이즈 레벨별 테스트 및 개선 |
| **R-B3** | amplitude가 lift angle·A–C 구간에 의존 → 설정 오류 시 진폭 오산 | Accurateness (Correctness) | **QAS-2** | FR-05-14, FR-06-02 | M | M | lift angle 입력 검증·기본값 가이드, 산식 단위 테스트 | ⚪ Pass |
| **R-B4** | 0.1ms급 정답(ground truth)을 실HW로 못 얻음 → 합성신호 검증 의존, "정확함" 입증·데모 신뢰성 리스크 | Testability (+Accuracy) | **QAS-2** | FR-05-04·05, FR-08-02 | M | M | Sim/Playback 재현 테스트, 검증 시나리오 사전 정의 | ⚪ Pass |
| **R-B5** | Scope2 tic/tac 축 비보장(50/50 평균 사이클) 등 도메인 특수 로직 구현 오류 | Correctness | **QAS-2·QAS-4** | FR-05-15·17·21 | L~M | M | 축 비보장 전제 명시, 사이클 경계 단위 테스트 | ⚪ Pass (FR-05 전용) |

### C. 아키텍처 / 확장성

| ID | 리스크 | 품질속성 | 관련 QAS | 관련 FR | P | I | 완화 방향 | 상태 / 팀 결정 |
|----|--------|----|------|------|:--:|:--:|--------|--------|
| **R-C1** | 베이스라인 GUI가 단일 god-screen(MainWindow) → 5주 내 모듈 분리 실패 시 모든 FR 추가가 ripple | Modifiability | **QAS-5** | G01–G12 전반 | M | H | 1주차에 acquisition/processing/calc/presentation 분리 골격화 | 🟡 코드 재구성/리팩토링 과제 |
| **R-C2** | 뷰 간 일관성(동일 snapshot, 불일치 0)을 위한 공유 측정 모델 부재 시 표시값 divergence | Correctness (Consistency) | **QAS-4** | FR-12-05, FR-06-06, FR-04-05…07, FR-02-07…08 | M | H | snapshot ID 기반 단일 데이터원·공유 시간축 모델 | 🟡 완화 방향대로 진행 |
| **R-C3** | 필터/마커 확장 추상화(예: F4 추가 ≤2파일) 초기 미설계 시 후반 비용 급증 / 신규 그래프 side effect | Modifiability | **QAS-5** | FR-12-01, FR-05-01 | M | M | Filter 인터페이스(strategy)·plug-in 등록 방식 선설계 | 🟡 모듈화 강화로 대응 |
| **R-C4** | 성능 개선을 위한 concurrency 도입 시 race condition·디버깅·테스트 복잡도 증가 | Reliability (+Testability) | **QAS-1·QAS-4** | FR-12-04·05 | M | M | 락프리 버퍼·스레드 경계 명확화, 동시성 단위 테스트 | 🟡 크리티컬 패스만 lock-free, UI는 비동기 |

### D. 하드웨어 / 플랫폼 / 가용성

| ID | 리스크 | 품질속성 | 관련 QAS | 관련 FR | P | I | 완화 방향 | 상태 / 팀 결정 |
|----|--------|----|------|------|:--:|:--:|--------|--------|
| **R-D1** | AGC 미차단(C-4)·마이크 커플링 불량 → 신호 왜곡으로 전 측정 신뢰도 붕괴 | Accurateness (+Reliability) | **QAS-2·QAS-3** | FR-08-01 | M | H | 착수 즉시 AGC off·커플링 검증을 환경 체크리스트화 | 🟡 사용자 가이드 문서에 명시 |
| **R-D2** | Windows↔RPi 포팅(C-3) — 오디오 백엔드(WASAPI/ALSA) 차이; 개발은 Win·데모는 RPi라 성능 격차 노출 | Portability (+Performance) | **QAS-1** | FR-08-01, FR-05-03·14…16 | M | M | 오디오 I/O를 포트-어댑터로 격리, RPi 조기·정기 검증 | ⚪ RPi 병행 진행하므로 리스크 낮음 |
| **R-D3** | 샘플레이트/장치 가변(48/96/192k) 지원이 타이밍·복잡도 증가 | Portability (+Accuracy) | **QAS-1·QAS-2** | FR-05-03…05, FR-08-01 | M | M | 지원 샘플레이트 범위 명시, 어댑터에서 정규화 | 🟡 가능 스펙 명시 (마이크 스펙 등) |
| **R-D4** | 측정 중 오디오 장치 disconnect·복구 가능 스트림 오류 시 crash·데이터 손실·수동 재시작 필요 | Availability (Recoverability) | **QAS 갭** (Availability) | FR-05-03, FR-08-01 | M | H | unplug/replug·stream error 주입 테스트, crash 0·자동 재개·fault 표시 | 🟡 복구 메뉴/예외 감지·상태 저장 |

### E. 사용성 / UI (800×480)

| ID | 리스크 | 품질속성 | 관련 QAS | 관련 FR | P | I | 완화 방향 | 상태 / 팀 결정 |
|----|--------|----|------|------|:--:|:--:|--------|--------|
| **R-E1** | 저해상도 터치스크린에 요약바+다중 그래프+scope strip을 가독성(≥24px·≥9mm) 있게 못 담음 | Usability | **QAS-6** | FR-06-06, FR-01-05, FR-04-03, FR-02-06 | M | M | 핵심 측정값 우선 레이아웃, 탭 기반 분할, ≤2탭 내비 | 🟡 크기 조절 테스트 진행 |
| **R-E2** | 12종+ FR 디스플레이가 제한된 화면 공간 경쟁 → 정보 과밀 | Usability | **QAS-6** | FR-05-01, G01–G12 | M | M | 우선순위 기반 표시 집합 선정, 보조 정보는 토글 | ⚪ Tab으로 구분, 현 상태 진행 |
| **R-E3** | 터치스크린 터치 시 정확도·인식률 저하 가능 | Usability | **QAS-6** | FR-06-06, FR-04-03 | L | L | 터치 민감도·인식 범위 실험적 확인 | ⚪ App 레벨 제어 가능 시 실험 |

### F. 프로젝트 / 프로세스

| ID | 리스크 | 위협 대상 QA | 관련 QAS | 관련 FR | P | I | 완화 방향 | 상태 / 팀 결정 |
|----|--------|----|------|------|:--:|:--:|--------|--------|
| **R-F1** | 5주 타임박스 vs 광범위 FR(12 디스플레이 + AI) → 전부 구현 불가, 우선순위 실패 시 핵심 누락 | 전 QA (특히 Perf·Accuracy) | **QAS-1…6 전반** | G01–G12 | M~H | H | FR 우선순위 동결, AI는 optional 분리, 핵심 경로 우선 | 🔴 플래닝 후 진행, 버릴 건 버림 |
| **R-F2** | 베이스라인 코드(TimeGrapher_v10.4) 이해/문서 부재로 착수 지연·현 성능 수준 미파악 | Modifiability | **QAS-5** | G01–G12 | L | M | 코드 reading 세션·모듈 맵 작성을 1주차 태스크화 | ⚪ AI 활용으로 리스크 낮아짐 |
| **R-F3** | Qt/C++·DSP·RPi 학습곡선(팀 역량 램프업) + C++ 개발 경험 부족 | 전 QA | (전반) | — | L~M | M | 역할 분담·페어링, 작은 spike로 조기 학습 | ⚪ AI 활용으로 리스크 낮아짐 |
| **R-F4** | AI/TinyML 기능(선택) 시도 시 on-device 불확실성↑ (데이터셋 부족, 학습/튜닝 시간, PC↔Pi 결과 차이) | Accurateness | **QAS 갭** (AI scope 미확정) | — (AI FR 미도출) | M | M | optional 스코프 분리, 미달 시 룰베이스 폴백, 소규모 모델 사전 검토 | 🟡 Windows 선검증 후 RPi5 반영 결정 |
| **R-F5** | GenAI(코딩 도우미) 과의존·환각 코드 — DSP/동시성/실시간 영역의 그럴듯하나 틀린 코드 수용 시 정확도·성능 리스크 전이 | Correctness·Performance·(Testability) | **QAS-1·QAS-2** | — | M | M | 생성코드 adversarial 검증(단위테스트·합성신호 벤치) 의무화, 핵심 알고리즘 이해 동반, 멘토 확인 | 🟡 코드리뷰 + 팀 전원 알고리즘 이해 |
| **R-F6** | RPi5 테스트 가능 시료(시계)가 하나뿐 → 실사용 Test 검증 일정 미확보 | Testability (test basis) | **QAS 검증 기반 전반** | — | H | H | 가속/단축 테스트 기획, 시료 공유 스케줄링, Sim/Playback 대체 검증 | 🔴 테스트 환경 제약, 일정 리스크 |
| **R-F7** | 이해관계자 간 영어 의사소통으로 정확한 의사전달 실패 가능 | Process | — | — | M | L~M | 핵심 결정 문서화(ko/en 병기), 합의 항목 명시 | ⚪ Watch |

### G. 요구사항 / 검증

| ID | 리스크 | 품질속성 | 관련 QAS | 관련 FR | P | I | 완화 방향 | 상태 / 팀 결정 |
|----|--------|----|------|------|:--:|:--:|--------|--------|
| **R-G1** | 일부 요구 모호/미명세("장시간", doc-vs-FR 등) → 인수기준 불명확·재작업 | Testability (actionability) | (영향: QAS-3 등) | FR-12-12 (사례) | M | L~M | 모호 용어 정량화, 문서화 요구는 FR에서 분리 | ⚪ QA 진행하며 구체화 |
| **R-G2** | 6h/24h 장기 테스트를 데모 시간 내 재현 불가 → 검증 갭 | Testability (verifiability) | **QAS-1** (10분 한정) | FR-07-10 | M | L | 가속 테스트·로그 증빙, 1시간 단위 결과 조합으로 검증 | ⚪ 별도 런으로 처리 |
| **R-G3** | 자동화 테스트 부재(장비 1대, 테스트룸·unit test program 없음) → detector·계산 로직 변경 시 regression 누락 | Testability | **QAS-5** (회귀 0 척도) ·QAS-2·QAS-3 | G01–G12 | M~H | M | regression dataset(Sim/Playback/WAV) 정리, 변경 시 재실행 | 🟡 회귀 데이터셋 우선 구축 |

### H. 데이터 / 저장

| ID | 리스크 | 품질속성 | 관련 QAS | 관련 FR | P | I | 완화 방향 | 상태 / 팀 결정 |
|----|--------|----|------|------|:--:|:--:|--------|--------|
| **R-H1** | 장시간 음성 녹음·long-term 데이터 저장량 과다로 microSD 용량 초과 | Capacity / Reliability | **QAS 갭** | FR-07-01…03·10 | M | M | 다운샘플링·통계만 보관(원형 버퍼), 저장 포맷 관리 | 🟡 SD 스펙 확인 + 녹음 테스트 |
| **R-H2** | 음성 데이터를 DDR→flash(SD) 저장 시 쓰기 속도 < 생성 속도 → 병목·RAM 누적·오버플로우 | Performance / Reliability | **QAS-1** (입력 따라가기 전제) | FR-07 | M | H | SD카드 spec 확인·실측 녹음 테스트, RAM 버퍼링·백프레셔 | 🟡 실험 (Aging 테스트) |
| **R-H3** | 실시간 저장 미지원 → 측정 중 종료 시(예: 9/10 자세 완료) 이전 측정 데이터 소실 | Reliability (Recoverability) | **QAS 갭** | FR-04-03, FR-07 | M | M | 측정 단위 주기적 체크포인트 저장·영속화 | 🟡 검토 |
| **R-H4** | 적절한 data structure 불확실(음성 버퍼 구조 / measurement 저장 구조) | Modifiability | **QAS-5·QAS-1** | FR-07, FR-04 | L~M | M | 버퍼·저장 모델 선설계, 프로토타입으로 검증 | 🟡 설계 과제 |

---

## 3. 리스크 매트릭스 (P × I)

| | **I = Low** | **I = Medium** | **I = High** |
|:--:|:--:|:--:|:--:|
| **P = High** | | | 🔴 R-A1, R-B1, R-F6 |
| **P = M~H** | | R-G3 | 🔴 R-A2, R-B2, R-F1 |
| **P = Medium** | R-G2 | R-A4, R-B3·B4, R-C3·C4, R-D2·D3, R-E1·E2, R-F4·F5, R-H1·H3·H4 | R-A3, R-C1·C2, R-D1·D4, R-H2 |
| **P = Low~M** | R-G1, R-F7 | R-B5, R-F3 | |
| **P = Low** | R-E3 | R-F2 | |

> 우상단(🔴)에 가까울수록 최우선. 대각선 위쪽은 조기 실험으로 검증, 아래쪽은 관찰·현 상태 진행.

---

## 4. 최우선 리스크 (Top Priority)

조기 검증/완화가 가장 시급한 리스크:

| 순위 | ID | 한 줄 요약 | 관련 QAS | 왜 최우선인가 |
|:--:|----|--------|----|--------|
| 1 | **R-A1** | RPi5 실시간 처리 실현성 | QAS-1 | 실시간 처리가 실패하면 대부분의 실시간 display 기능이 데모에서 바로 무너짐 |
| 2 | **R-B1 / R-B2** | 검출 정밀도·잡음 강건성 | QAS-2 / QAS-3 | 나쁜 신호를 정상값처럼 보여주면 사용자가 오판하고 FR-04 X/D 요약까지 오염 |
| 3 | **R-F6** | 테스트 시료 1개·테스트 기반 부족 | (QAS 검증 기반) | 시료·자동화 부족으로 실사용 검증 일정 자체가 안 나옴 |
| 4 | **R-C1** | god-screen 모듈 분리 | QAS-5 | 1주차 모듈 분리 실패 시 모든 FR 추가가 ripple → 전체 일정 붕괴 |
| 5 | **R-F1** | 5주 타임박스 vs 광범위 FR | QAS-1…6 전반 | 우선순위 동결 실패 시 핵심 기능 완성도 저하 |

> R-F4(AI 기능 scope 미확정)는 FR/QA scope가 확정되기 전까지 최우선 구현 리스크가 아니라 **별도 후보 기능 리스크**로 추적한다.

---

## 5. 아키텍처 트레이드오프 (참고)

리스크 완화 과정에서 식별된 주요 품질속성 충돌:

| 충돌 속성 1 | 충돌 속성 2 | 원인 (리스크) | 해결/타협 방향 |
|------|------|--------|--------|
| 성능 (QAS-1: 500ms 지연) | 변경 용이성 (QAS-5: 모듈 확장성) | 확장 위해 잘게 쪼개고 중간 브로커를 두면 데이터 복사·컨텍스트 스위칭 오버헤드로 500ms 초과 가능 | UI 확장용 이벤트 버스는 **비동기**, 오디오 캡처~DSP **크리티컬 패스**는 결합 일부 허용하더라도 **lock-free 버퍼**로 고속 통신 |
| 정확도/가용성 (QAS-3: 노이즈 필터링) | 성능 (QAS-1: 96k SPS 처리) | 무거운 필터·복잡한 신호 분석은 96k SPS 실시간 기한 초과 유발 | 필터 연산 복잡도(Big-O) 상한 설정, 무거운 스펙트로그램 등은 **On-demand** 활성화로 분리 |
| 자원 관리 (RPi 메모리) | 유용성 (FR-07: 장기 성능 그래프) | 원시 데이터를 계속 메모리에 쌓으면 OOM | 일정 주기 경과 데이터는 평균/최대/최소 통계만 남기고 **다운샘플링하는 원형 버퍼** 구조 채택 |

---

*출처: RiskAssessment.xlsx (취합 · 정리 · Risk_윤성준 · Risk 김준성 · JD · Risk list_오선영 · Jaehong 시트 통합)*
*QAS 인덱스: [Milestone1_QA_Final_1.md](../../Milestone1_QA_Final_1.md) · FR 인덱스: [Milestone1_2-Architectural-Drivers.md](Milestone1_2-Architectural-Drivers.md)*
