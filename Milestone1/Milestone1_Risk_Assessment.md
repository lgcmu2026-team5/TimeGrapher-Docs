# Milestone1 — Risk Assessment

> P = 발생 확률(Probability), I = 영향(Impact) — H/M/L 등급.

## A. 실시간 성능 (RPi) — 최대 위험군

- **R-A1 — RPi5에서 96k(목표)/192k(스트레치) 샘플레이트 캡처→처리→표시를 실시간 유지 못 함 → block drop / missed beat**
  - 품질요소: Performance (Real-Time)
  - 근거: Draft Real-Time Perf(p.25), QAS-1/2, QA-INT-03
  - P / I: H / H
  - 완화 방향: 1주차 spike로 RPi 처리 한계 측정 후 샘플레이트 목표 확정(192k는 stretch로 격하)
  - 코멘트: 실험 진행 후 스펙 결정

- **R-A2 — 4-필터 동시 파이프라인(F0→F1→F2→F3) + 다중 그래프 탭 동시 렌더 부하로 <20 FPS·UI freeze**
  - 품질요소: Performance
  - 근거: FR-12 / QA-12-02, QA-INT-03
  - P / I: M~H / H
  - 완화 방향: 공유 입력버퍼 재사용, 비활성 뷰 렌더 중단, FPS 예산 측정
  - 코멘트: 4개 동시 뷰 / 1개씩 뷰는 성능 확인 후 결정

- **R-A3 — 종단 지연 목표(p99 ≤500ms, QA-INT-05 평균≤100/최악≤200ms) 미달**
  - 품질요소: Performance (Latency)
  - 근거: QAS-1, QA-INT-05
  - P / I: M / H
  - 완화 방향: 캡처/처리/표시 단계별 지연 계측·백로그 모니터링
  - 코멘트: 최악의 경우로 고려해서 리소스/프로세스 최적화 또는 기능 약화로 마이그레이션

- **R-A4 — 장시간 누적(FR-07, 24h+)·연속 실행 시 메모리 누수/증가로 열화**
  - 품질요소: Reliability(Dependability) (+Performance)
  - 근거: QAS-3, QA-INT-08
  - P / I: M / M
  - 완화 방향: 장기 RSS 추세 모니터, 버퍼 상한·집계(aggregation) 설계
  - 코멘트: 현 코드 기준으로 메모리 릭 확인 (실험)

## B. 신호처리 / 측정 정확도

- **R-B1 — 비트 onset/peak 검출 정밀도 ≤0.1ms(≈10샘플@96k) 달성 곤란 → rate·beat error·amplitude 전반 오염**
  - 품질요소: Accurateness (Measurement Accuracy)
  - 근거: QAS-6
  - P / I: H / H
  - 완화 방향: 합성신호(정답 known) 벤치로 검출 알고리즘 조기 검증(QAS-10 연계)
  - 코멘트: 현 로직 기준으로 정상동작 확인 및 필요 시 로직 개선 필요

- **R-B2 — 주변소음/약신호(SNR≥14dB, 검출률≥95%) 환경에서 오검출·오측정**
  - 품질요소: Robustness/Reliability (+Accurateness)
  - 근거: QAS-5, QA-INT-02
  - P / I: M~H / H
  - 완화 방향: 필터링·신호품질 판정, bad-data는 "signal weak" 표시로 격리
  - 코멘트: 노이즈 레벨 별 테스트 및 필요 시 로직 개선

- **R-B3 — amplitude가 lift angle·A–C 구간에 의존 → 설정 오류 시 진폭 오산**
  - 품질요소: Accurateness(Correctness)
  - 근거: Draft, FR-05(lift angle)
  - P / I: M / M
  - 완화 방향: lift angle 입력 검증·기본값 가이드, 산식 단위 테스트
  - 코멘트: 패스

- **R-B4 — 0.1ms급 정답(ground truth)을 실HW로 못 얻음 → 합성신호 검증 의존, "정확함" 입증·데모 신뢰성 리스크**
  - 품질요소: Testability (+Accurateness)
  - 근거: QAS-6/10
  - P / I: M / M
  - 완화 방향: Sim/Playback 재현 테스트, 검증 시나리오 사전 정의
  - 코멘트: 패스

- **R-B5 — Scope2 tic/tac 축 비보장(50/50 평균 사이클) 등 도메인 특수 로직 구현 오류**
  - 품질요소: Correctness
  - 근거: FR-05-15/17
  - P / I: L~M / M
  - 완화 방향: 축 비보장 전제 명시, 사이클 경계 단위 테스트
  - 코멘트: FR-05 전용이어서 패스

## C. 아키텍처 / 확장성

- **R-C3 — 필터/마커 확장 추상화(예: F4 추가 ≤2파일) 초기 미설계 시 후반 비용 급증**
  - 품질요소: Modifiability/Extensibility
  - 근거: QA-12-01, QA-INT-09
  - P / I: M / M
  - 완화 방향: Filter 인터페이스(strategy)·plug-in 등록 방식 선설계
  - 코멘트: 모듈화를 더 잘 하면 될 듯함

## D. 하드웨어 / 플랫폼

- **R-D1 — AGC 미차단(C-4)·마이크 커플링 불량 → 신호 왜곡으로 전 측정 신뢰도 붕괴**
  - 품질요소: Accurateness (+Reliability)
  - 근거: Draft Hardware/OS(p.28), C-4
  - P / I: M / H
  - 완화 방향: 착수 즉시 AGC off·커플링 검증을 환경 체크리스트화
  - 코멘트: 사용자 가이드 문서에 명시 필요

- **R-D2 — Windows↔RPi 포팅(C-3) — 오디오 백엔드(WASAPI/ALSA) 차이; 개발은 Win·데모는 RPi라 성능 격차 노출**
  - 품질요소: Portability (+Performance)
  - 근거: C-3, QAS-9
  - P / I: M / M
  - 완화 방향: 오디오 I/O를 포트-어댑터로 격리, RPi 조기·정기 검증
  - 코멘트: 프로젝트 진행하면서 RPi에도 진행할 것이어서 리스크 낮음

- **R-D3 — 샘플레이트/장치 가변(48/96/192k) 지원이 타이밍·복잡도 증가**
  - 품질요소: Portability (+Accurateness)
  - 근거: Draft, FR-05
  - P / I: M / M
  - 완화 방향: 지원 샘플레이트 범위 명시, 어댑터에서 정규화
  - 코멘트: 가능 스펙 명시 (마이크 스펙 등)

## E. 사용성 / UI (800×480)

- **R-E1 — 저해상도 터치스크린에 요약바+다중 그래프+scope strip을 가독성(≥24px·≥9mm) 있게 못 담음**
  - 품질요소: Usability
  - 근거: QAS-11, C-2
  - P / I: M / M
  - 완화 방향: 핵심 측정값 우선 레이아웃, 탭 기반 분할, ≤2탭 내비
  - 코멘트: 크기 조절 테스트 진행

- **R-E2 — 12종+ FR 디스플레이가 제한된 화면 공간 경쟁 → 정보 과밀**
  - 품질요소: Usability
  - 근거: Draft(기능 12종), C-2
  - P / I: M / M
  - 완화 방향: 우선순위 기반 표시 집합 선정, 보조 정보는 토글
  - 코멘트: Tab으로 구분할 것이므로 문제 없음 (현상태 진행)

- **R-E3 — 터치스크린에 사용자가 터치 시, 터치 정확도나 인식률이 떨어질 수 있음**
  - 품질요소: Usability
  - P / I: L / L
  - 완화 방향: 터치 민감도나 터치 범위인식을 실험적으로 가능하면 확인
  - 코멘트: App 레벨에서 제어 가능하면 실험 후 최적의 값 확인, OS 레벨에서 정의되면 현 상태 진행

## F. 프로젝트 / 프로세스

- **R-F1 — 5주 타임박스 vs 광범위 FR(12 디스플레이 + AI) → 전부 구현 불가, 우선순위 실패 시 핵심 누락**
  - 위협 대상 QA: 전 QA (특히 Performance·Correctness)
  - 근거: Draft(5주, "feasible subset" 명시)
  - P / I: M~H / H
  - 완화 방향: FR 우선순위 동결, AI는 optional 분리, 핵심 경로 우선
  - 코멘트: 프로젝트 플래닝 잘 해서 진행하고 버릴 건 버림

- **R-F2 — 제공 베이스라인 코드(TimeGrapher_v10.4) 이해/문서 부재로 착수 지연**
  - 위협 대상 QA: Modifiability (착수·유지보수)
  - 근거: Draft System SW(p.27)
  - P / I: L / M
  - 완화 방향: 코드 reading 세션·모듈 맵 작성을 1주차 태스크화
  - 코멘트: AI 활용하기 때문에 Risk 낮아짐

- **R-F3 — Qt/C++·DSP·RPi 학습곡선(팀 역량 램프업)**
  - 위협 대상 QA: 전 QA (구현 품질 전반)
  - 근거: Draft 전반
  - P / I: L~M / M
  - 완화 방향: 역할 분담·페어링, 작은 spike로 조기 학습
  - 코멘트: AI 활용하기 때문에 Risk 낮아짐

- **R-F4 — AI/TinyML 기능(선택) 시도 시 on-device 불확실성↑**
  - 위협 대상 QA: Accurateness (신호품질 분류)
  - 근거: Draft AI Feature
  - P / I: M(시도 시) / M
  - 완화 방향: optional 스코프로 분리, 미달 시 룰베이스 폴백
  - 코멘트: 우선 Windows 진행 후 RPi 5에서 동작성 검토 후 반영 결정

- **R-F5 — GenAI(코딩 도우미) 과의존·환각 코드 — 특히 DSP/동시성/실시간 영역의 그럴듯하나 틀린 코드 수용 시 정확도·성능 리스크로 전이; 얕은 이해로 발표·디버깅 약화**
  - 위협 대상 QA: Correctness·Performance·(Testability)
  - 근거: Draft "Project Deliverables"(Milestone 평가항목: 아키텍처 이해·설명), 본 분석
  - P / I: M / M
  - 완화 방향: 생성코드 adversarial 검증(단위테스트·합성신호 벤치) 의무화, 핵심 알고리즘은 이해 동반, GenAI 사용 허용여부 멘토 확인
  - 코멘트: 완화 방향 참고 (코드리뷰, 우리 모두 알고리즘 이해 등)

- **R-F6 — 테스트 기반 부족 — Pi5 테스트 가능한 시료가 하나밖에 없어 실사용에 대한 Test 검증 일정이 안 나올 것 같다**
  - 근거: 제공된 시료 개수 (프로젝트 진행 환경)
  - P / I: H / H

## G. 요구사항 / 검증

- (식별된 항목 없음)

## H. 기타 또는 카테고리화 되지 않음

- **프로젝트 진행 간 이해관계자들 간의 의사소통 문제** — 영어로 대화 시 정확한 의사전달이 안 될 경우
- **테스트 환경 부족** — 시간적·기능적 관점에서 장비 1대, 테스트룸 없음, unit test program 없음 등; 자동화 테스트가 부족해 detector나 계산 로직 변경 시 regression을 놓칠 수 있음
- **장시간 검증 곤란** — 24시간 연속 등 실제 동작 검증을 하기 어려운 항목에 대한 평가가 어렵지 않을까?
- **데이터 저장량 증가** — 장시간 음성 녹음 처리 시 파일 크기가 커짐
- **RPi5 디버깅 곤란** — RPi5의 상태를 파악하거나 디버깅하기 어려움
  - 메모: 로그 메시지를 남기는 것이 실험적으로 가능함
- **데이터 구조 불확실** — 음성 데이터의 버퍼 구조? measurement data 저장 구조? 등 어떤 data structure가 맞는지 불확실
- **저장 속도 병목 가능성** — 음성 데이터를 DDR에서 flash(SD 카드)로 저장 시 저장 속도가 생성 속도보다 느릴 수 있음
  - 메모: SD카드 spec 확인 및 실제 녹음 테스트
