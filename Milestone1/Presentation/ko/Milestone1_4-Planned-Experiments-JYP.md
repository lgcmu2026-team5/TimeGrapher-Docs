# Planned Experiments

> TimeGrapher Reference Architecture — Milestone 1
> [Milestone1_3-Risk-Assessment-JYP.md](Milestone1_3-Risk-Assessment-JYP.md)의 🔴/🟡 리스크를 검증·완화하기 위한 실험 계획

---

## 1. 개요 (How These Map to Risks)

각 실험은 리스크 레지스터의 고위험 항목을 **실험(Spike/PoC)으로 조기 검증**한다는 SAP 절차 5단계를 구체화한 것이다. 모든 실험은 다음 6요소를 명시한다.

- **질문/가설** — 무엇을 모르는가 (리스크의 "물음표")
- **방법** — 셋업·절차
- **데이터셋** — Sim / Playback / WAV fixture / Live
- **측정** — 무엇을 어떻게 잴 것인가
- **합격 기준** — 관련 QAS의 응답 척도를 그대로 사용
- **의사결정** — 결과가 무엇을 확정/변경하는가

합격 기준은 가능한 한 [Milestone1_QA_Final_1.md](../../Milestone1_QA_Final_1.md)의 응답 척도를 재사용하여 추적성을 유지한다.

### 상태 / 우선순위 범례

| 표기 | 의미 |
|:----:|------|
| 🔴 **Critical** | 최우선. Week 1–2 내 착수, 결과가 스펙/아키텍처를 좌우 |
| 🟡 **Important** | 완화 검증. 중반 진행 |
| ⚪ **Optional** | 여유 시 / 스코프 확정 후 |

---

## 2. 실험 요약 (Summary)

| EXP | 제목 | 관련 리스크 | QAS / FR | 주차 | 우선 |
|----|------|--------|------|:--:|:--:|
| **EXP-1** | RPi5 실시간 처리 한계 & 샘플레이트 상한 | R-A1, R-A3 | QAS-1 / FR-08-01·12-04 | W1 | 🔴 |
| **EXP-2** | 동시 필터·다중 그래프 FPS 예산 | R-A2, R-C4 | QAS-1 / FR-12-01·04·05 | W2 | 🔴 |
| **EXP-3** | 비트 onset/peak 검출 정확도 (합성신호) | R-B1, R-B4 | QAS-2 / FR-08-04·05-13 | W1–2 | 🔴 |
| **EXP-4** | 잡음 강건성 & graceful degradation | R-B2 | QAS-3 / FR-12-08·05-17 | W2–3 | 🔴 |
| **EXP-5** | 모듈 분리 골격 스파이크 + 확장성 측정 | R-C1, R-C3, R-F2 | QAS-5 / G01–G12 | W1 | 🔴 |
| **EXP-6** | 회귀 데이터셋 구축 + 시료 공유 계획 | R-G3, R-F6 | (검증 기반) / G01–G12 | W1→상시 | 🔴 |
| **EXP-7** | 장기 연속 실행 메모리/안정성 | R-A4, R-H1 | QAS-1 / FR-07 | W3–4 | 🟡 |
| **EXP-8** | SD 저장 처리량 / aging | R-H2, R-H3 | QAS-1(전제) / FR-07 | W2 | 🟡 |
| **EXP-9** | 800×480 가독성·터치 타깃 | R-E1, R-E2, R-E3 | QAS-6 / FR-06-06·01-05 | W2–3 | 🟡 |
| **EXP-10** | 오디오 장치 분리/복구 | R-D4 | QAS 갭(Availability) / FR-05-03 | W3 | 🟡 |
| **EXP-11** | 뷰 간 일관성 검사 | R-C2 | QAS-4 / FR-12-05·06-06 | W3 | 🟡 |
| **EXP-12** | AGC/마이크 커플링 환경 검증 | R-D1, R-D2, R-D3 | QAS-2·3 / FR-08-01 | W1 | 🟡 |
| **EXP-13** | AI/TinyML on-Pi 타당성 | R-F4 | QAS 갭(AI scope) / — | W4–5 | ⚪ |

---

## 3. 상세 실험 카드 (Critical)

### EXP-1 · RPi5 실시간 처리 한계 & 샘플레이트 상한
**관련 리스크** R-A1, R-A3 · **QAS** QAS-1 · **FR** FR-08-01, FR-12-04, FR-12-14, FR-05-03 · **주차** W1 · 🔴

| 항목 | 내용 |
|------|------|
| 질문/가설 | RPi5(8GB)에서 캡처→처리→표시를 실시간 유지할 수 있는 **최대 샘플레이트**는? 96k 목표가 달성 가능한가, 192k는 stretch로 격하해야 하는가? |
| 방법 | Live 입력과 Playback WAV fixture를 48k/96k/192k에서 각각 10분 연속 실행. 캡처·분석완료·화면표시 3지점에 타임스탬프. 단계별 지연·dropped-block·missed-beat 카운터·렌더 갱신 지연을 로깅 |
| 데이터셋 | TimeGrapherTestFilesWeishiMic의 48k/96k/192k WAV fixture + Live 마이크 |
| 측정 | (1) processing latency p99, (2) display latency p99, (3) 종단 p99, (4) dropped blocks, (5) missed beats |
| 합격 기준 | **종단 p99 ≤ 500 ms** (게이트), 96k에서 **dropped blocks = 0 · missed beats = 0**. 48k 최소에서도 충족 |
| 의사결정 | 샘플레이트 목표 확정(96k 채택 / 192k stretch 여부). 미달 시 R-A3 완화 경로(리소스 최적화 vs 기능 약화) 발동 |

### EXP-2 · 동시 필터·다중 그래프 FPS 예산
**관련 리스크** R-A2, R-C4 · **QAS** QAS-1 · **FR** FR-12-01, FR-12-04, FR-12-05, FR-12-13 · **주차** W2 · 🔴

| 항목 | 내용 |
|------|------|
| 질문/가설 | 4-필터(F0→F3) + 다중 그래프 탭을 동시 렌더할 때 RPi5가 ≥20 FPS·UI 응답성을 유지하는가? "전부 동시 표시" vs "활성 1뷰" 중 무엇이 필요한가? |
| 방법 | 공유 입력버퍼 재사용 on/off, 비활성 뷰 렌더 중단 on/off의 4조합으로 FPS·CPU·UI freeze 빈도 측정. 동시 표시 탭 수를 1→4로 스윕 |
| 데이터셋 | 96k Playback fixture (안정적 재현) + Live |
| 측정 | FPS(평균·최저), CPU 점유, UI freeze 횟수(>200ms 무응답), 입력 따라가기 여부 |
| 합격 기준 | 핵심 동시 표시 구성에서 **FPS ≥ 20**, freeze 0, dropped block 0. (미달 시 동시 표시 뷰 수 축소) |
| 의사결정 | "4개 동시 뷰 vs 1뷰씩" UI 정책 확정, 비활성 뷰 렌더 중단 채택 여부 |

### EXP-3 · 비트 onset/peak 검출 정확도 (합성신호)
**관련 리스크** R-B1, R-B4 · **QAS** QAS-2 · **FR** FR-08-04…06, FR-05-13, FR-06-01…04 · **주차** W1–2 · 🔴

| 항목 | 내용 |
|------|------|
| 질문/가설 | 현 검출 로직이 onset/peak를 **≤ 0.1 ms** 오차로 찾는가? 48k에서 서브샘플 보간이 필요한가? |
| 방법 | Sim mode Realistic OFF, 위치가 알려진 합성 비트 생성. 검출 결과를 programmed ground truth와 비교. 48k/96k 각각 수행 |
| 데이터셋 | 합성 비트 ≥ 1,000개 (rate·amplitude·beat error known) |
| 측정 | onset/peak 위치 최대 오차(ms·samples), rate·amplitude·beat error 오차 |
| 합격 기준 | **onset/peak 최대 오차 ≤ 0.1 ms** (48k = 4.8샘플 → 서브샘플 보간 확인). 1,000비트 전체에서 유지 |
| 의사결정 | 현 로직 채택 vs 검출 알고리즘 개선 착수. 서브샘플 보간 필요성 확정 |

### EXP-4 · 잡음 강건성 & graceful degradation
**관련 리스크** R-B2 · **QAS** QAS-3 · **FR** FR-12-08, FR-05-17…18, FR-04-06 · **주차** W2–3 · 🔴

| 항목 | 내용 |
|------|------|
| 질문/가설 | 잡음·약신호에서 검출률·정확도를 유지하는가? 임계 미만에서 **잘못된 값 대신 "signal weak"**로 격리되고 X/D에서 제외되는가? |
| 방법 | Sim/Playback 입력에 보정된 잡음을 일정 SNR로 주입(noise injection). SNR을 14 dB 부근으로 스윕하며 검출·격리 동작 관찰 |
| 데이터셋 | 합성 비트 ≥ 1,000개 + 주입 잡음(기지 SNR) |
| 측정 | SNR≥14dB 검출률·일오차, 임계 미만 "signal weak" 표시율·잘못된 값 수, X/D invalid 포함 수 |
| 합격 기준 | SNR ≥ 14 dB에서 **검출 ≥ 95% · 일오차 ≤ ±3 s/d**; 임계 미만 **잘못된 값 0 · "signal weak"만 표시**; X/D invalid 포함 **0** |
| 의사결정 | 신호품질 판정 임계값 확정, bad-data 격리 로직 채택/개선 |

### EXP-5 · 모듈 분리 골격 스파이크 + 확장성 측정
**관련 리스크** R-C1, R-C3, R-F2 · **QAS** QAS-5 · **FR** G01–G12 (예: FR-05-01, FR-12-01, FR-04-06) · **주차** W1 · 🔴

| 항목 | 내용 |
|------|------|
| 질문/가설 | 베이스라인 god-screen을 acquisition/processing/calc/presentation으로 분리하면, 새 그래프/필터/측정값 추가가 **등록 지점 한 곳**으로 제한되는가? |
| 방법 | 1주차에 4계층 분리 골격을 세우고, 시범으로 새 그래프 1종·새 필터 1종·새 측정값 1종을 추가하며 변경 모듈/위치 수를 카운트 |
| 데이터셋 | 베이스라인 코드(TimeGrapher_v10.4) + 회귀 테스트 셋(EXP-6) |
| 측정 | 추가당 변경된 기존 모듈 수, 회귀 테스트 통과 여부 |
| 합격 기준 | 새 그래프 ≤ 1 모듈, 새 필터 ≤ 1 등록점, 새 측정값 ≤ 1 레지스트리 변경, **회귀 0건** |
| 의사결정 | 모듈 경계·plug-in 등록 방식 확정. R-F2(코드 이해)도 모듈 맵 산출로 동시 완화 |

### EXP-6 · 회귀 데이터셋 구축 + 시료 공유 계획
**관련 리스크** R-G3, R-F6, R-B4 · **QAS** 검증 기반(QAS-2·3·5의 측정 전제) · **FR** G01–G12 · **주차** W1 → 상시 · 🔴

| 항목 | 내용 |
|------|------|
| 질문/가설 | 하드웨어 1대·시료 1개 제약 하에서 timing·accuracy·degradation·sequence를 **반복 재현**할 regression dataset을 만들 수 있는가? |
| 방법 | Sim/Playback/WAV fixture 기반 고정 입력 셋 정리. 동일 입력 3회 반복 실행으로 재현성 확인. 시료(시계) 공유 캘린더·예약 슬롯 운영 |
| 데이터셋 | Sim 시나리오 + Playback WAV + Live 캘리브레이션 1회분 |
| 측정 | X/D 결과 재현성(3회 일치), included/excluded position trace 일치, 실행 간 편차 |
| 합격 기준 | 동일 입력 3회에서 **X/D 결과 일치**, trace 일치. 변경 시 즉시 재실행 가능한 자동 스크립트 확보 |
| 의사결정 | 이후 모든 실험의 검증 토대 확정. 시료 부족(R-F6) → 가속/단축 테스트 + Sim 대체 비중 결정 |

---

## 4. 보조 실험 (Important / Optional)

| EXP | 질문 | 방법 / 데이터셋 | 합격 기준 | 의사결정 |
|----|------|--------|--------|--------|
| **EXP-7** 장기 메모리/안정성 | 24h+ 연속 실행 시 메모리 누수·열화가 있는가? | 현 코드로 장기 실행, RSS 추세·집계 버퍼 동작 로깅 / Playback 반복 | 장기 RSS 비증가(상한 내 수렴), 1h 단위 결과 조합으로 24h 추정 | 버퍼 상한·aggregation 설계 채택 (R-A4) |
| **EXP-8** SD 저장 처리량 | DDR→flash(SD) 쓰기 속도가 음성 생성 속도를 따라가는가? | SD spec 확인 + 실측 녹음 throughput, RAM 버퍼링·백프레셔 테스트 / Live 녹음 | 생성률 ≤ 지속 쓰기율, overflow 0, 데이터 소실 0 | SD 등급·버퍼 정책 확정 (R-H2, R-H3) |
| **EXP-9** 터치스크린 가독·조작 | 800×480에 핵심 3값을 가독성 있게 담고 손가락 조작 가능한가? | 픽셀별 크기 시제 + 대표 사용자 ≥3명 시간 측정 / 목업 화면 | 글리프 ≥ 1.9 mm·대비 ≥ 4.5:1, 터치 ≥ 9 mm, 주요 모드 ≤ 2탭, active position ≤ 5s·X/D ≤ 10s (≥90%) | 우선순위 레이아웃·탭 분할 확정 (R-E1·E2·E3) |
| **EXP-10** 장치 분리/복구 | 측정 중 오디오 장치 disconnect·스트림 오류에서 복구되는가? | unplug/replug·stream error 주입 사이클 / Live | crash 0, 자동 재개, fault 표시, 데이터 손상 0 | 복구 메뉴·예외 감지·상태 저장 채택 (R-D4) |
| **EXP-11** 뷰 간 일관성 | 동일 측정 결과가 모든 뷰·X/D에서 일치하는가? | snapshot ID 노출 후 10분 기지 입력 실행, 동시 표시 비교 / Playback | 동시 표시 **불일치 0**(반올림 이내), X/D source mismatch 0 | single source of truth·공유 시간축 모델 확정 (R-C2) |
| **EXP-12** AGC/커플링 검증 | AGC 미차단·커플링 불량이 측정 신뢰도를 붕괴시키는가? | AGC on/off, 커플링 양호/불량 비교 측정 / Live | AGC off·양호 커플링에서 신호 왜곡 임계 내, 체크리스트 정립 | 환경 체크리스트·사용자 가이드 항목 확정 (R-D1·D2·D3) |
| **EXP-13** AI/TinyML on-Pi | 소규모 모델이 Pi에서 PC와 동등 결과·허용 지연으로 동작하는가? | Windows 선검증 → RPi5 이식 비교, 소규모 모델 후보 평가 / labeled Sim/Playback | confusion matrix·false accept/reject 허용 내, on-device 지연 허용 내 | AI 기능 반영/폴백(룰베이스) 결정 (R-F4) — *optional 스코프* |

---

## 5. 추적성 매트릭스 (Risk → Experiment → Decision)

| 리스크 | 실험 | 확정/변경되는 의사결정 |
|------|------|--------|
| R-A1, R-A3 | EXP-1 | 샘플레이트 목표(96k/192k), 지연 완화 경로 |
| R-A2, R-C4 | EXP-2 | 동시 표시 정책, 비동기/락프리 경계 |
| R-A4, R-H1 | EXP-7 | 버퍼 상한·aggregation, 장기 검증 방식 |
| R-B1, R-B4 | EXP-3 | 검출 로직 채택/개선, 서브샘플 보간 |
| R-B2 | EXP-4 | 신호품질 임계, bad-data 격리 |
| R-C1, R-C3, R-F2 | EXP-5 | 모듈 경계·plug-in 등록, 코드 맵 |
| R-C2 | EXP-11 | single source of truth, 공유 시간축 |
| R-D1·D2·D3 | EXP-12 | 환경 체크리스트, 포트-어댑터, 지원 샘플레이트 |
| R-D4 | EXP-10 | 복구 메뉴·예외 감지·상태 저장 |
| R-E1·E2·E3 | EXP-9 | 우선순위 레이아웃, 탭 분할, 터치 타깃 |
| R-F6, R-G3, R-B4 | EXP-6 | 회귀 검증 토대, 시료 공유, 가속 테스트 |
| R-H2, R-H3 | EXP-8 | SD 등급·버퍼 정책, 체크포인트 저장 |
| R-F4 | EXP-13 | AI 반영 vs 룰베이스 폴백 (optional) |

> R-F1(5주 타임박스)·R-F5(GenAI 환각)·R-F7(영어 소통)은 단일 실험이 아니라 **프로세스 차원**(우선순위 동결, 코드리뷰·adversarial 검증, ko/en 문서화)에서 상시 관리한다.

---

*근거: [Milestone1_3-Risk-Assessment-JYP.md](Milestone1_3-Risk-Assessment-JYP.md) · QAS: [Milestone1_QA_Final_1.md](../../Milestone1_QA_Final_1.md) · FR: [Milestone1_2-Architectural-Drivers.md](Milestone1_2-Architectural-Drivers.md)*
