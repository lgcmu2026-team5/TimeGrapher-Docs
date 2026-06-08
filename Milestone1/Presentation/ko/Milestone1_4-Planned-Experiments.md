# Planned Experiments

> SAP(Software Architecture Practice) 원칙에 따라 최우선 리스크를 줄이기 위한 기술 실험. 각 실험은 자신이 해소하는 리스크와 품질속성 시나리오(QAS)에 연결되며, 측정 결과를 근거로 한 합격/불합격(pass/fail) 판정으로 마무리한다.

**목차** — [리스크-실험 매핑](#리스크-실험-매핑) · [EXP-01](#exp-01-rpi5-실시간-샘플레이트-상한) · [EXP-02](#exp-02-gui-실시간-렌더링-디자인-패턴) · [EXP-03](#exp-03-rpi5-avalonia-렌더링-백엔드) · [EXP-04](#exp-04-온디바이스-tinyml-추론-타당성) · [EXP-05](#exp-05-장시간-24h-실행-안정성) · [EXP-06](#exp-06-글자-가독성과-터치-타깃-ui-기준) · [통합 일정](#통합-일정) · [공통 승인 기준](#공통-승인-기준)

## 용어 설명

이 문서에서 사용되는 용어는 통합 [Glossary](Milestone1_6-Glossary.md)에 정의되어 있다. 리스크(`R-*`)는 [Risk Assessment](Milestone1_3-Risk-Assessment.md), 품질속성 시나리오(`QAS-*`)는 [Architectural Drivers](Milestone1_2-Architectural-Drivers.md)에 정의되어 있다.

## 리스크-실험 매핑

> 우선순위: **High** / **Mid** (이번 Milestone에 Low 우선순위 실험은 없음).

| 실험 | 대응 리스크 | 관련 QAS | 우선순위 | 핵심 질문 |
|---|---|---|---|---|
| [EXP-01](#exp-01-rpi5-실시간-샘플레이트-상한) | [R-A1](Milestone1_3-Risk-Assessment.md#a-실시간-성능-rpi), [R-A3](Milestone1_3-Risk-Assessment.md#a-실시간-성능-rpi) | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--소리-입력에서-화면-표시까지) | **High** | Pi5에서 실시간 처리 가능한 샘플레이트 상한은? |
| [EXP-02](#exp-02-gui-실시간-렌더링-디자인-패턴) | [R-F2](Milestone1_3-Risk-Assessment.md#f-프로젝트--프로세스) | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--소리-입력에서-화면-표시까지), [QAS-4](Milestone1_2-Architectural-Drivers.md#qas-4--modifiability-extensibility--새-측정필터그래프-추가) | **High** | GUI 실시간 성능 개선을 위해 어떤 디자인 패턴을 우선 적용할 것인가? |
| [EXP-03](#exp-03-rpi5-avalonia-렌더링-백엔드) | [R-A5](Milestone1_3-Risk-Assessment.md#a-실시간-성능-rpi) | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--소리-입력에서-화면-표시까지) | **High** | C# 선택 시 Avalonia UI의 RPi5 렌더링 리스크를 어떻게 해소할 것인가? |
| [EXP-04](#exp-04-온디바이스-tinyml-추론-타당성) | [R-F4](Milestone1_3-Risk-Assessment.md#f-프로젝트--프로세스) | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--소리-입력에서-화면-표시까지), [QAS-2](Milestone1_2-Architectural-Drivers.md#qas-2--availability-graceful-degradation--잡음약신호-환경) | Mid | TinyML 추론을 추가해도 실시간성과 신뢰성을 유지할 수 있는가? |
| [EXP-05](#exp-05-장시간-24h-실행-안정성) | [R-A4](Milestone1_3-Risk-Assessment.md#a-실시간-성능-rpi) | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--소리-입력에서-화면-표시까지) | Mid | 장시간 실행에서 메모리/지연 열화가 발생하는가? |
| [EXP-06](#exp-06-글자-가독성과-터치-타깃-ui-기준) | [R-E1](Milestone1_3-Risk-Assessment.md#e-사용성--ui-1280800), [R-E2](Milestone1_3-Risk-Assessment.md#e-사용성--ui-1280800) | [QAS-5](Milestone1_2-Architectural-Drivers.md#qas-5--usability--터치스크린에서-읽기조작) | Mid | 가독성과 터치 인식을 동시에 만족하는 글자 크기/터치 타깃 기준은 무엇인가? |

## EXP-01: RPi5 실시간 샘플레이트 상한

**리스크:** [R-A1](Milestone1_3-Risk-Assessment.md#a-실시간-성능-rpi), [R-A3](Milestone1_3-Risk-Assessment.md#a-실시간-성능-rpi) · **QAS:** [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--소리-입력에서-화면-표시까지) · **우선순위:** High

### 결과 및 권장 사항

TO-DO: 측정 완료 후 최종 권장 샘플레이트(48k/96k/192k)와 채택 근거를 기록한다.

### 목적

Pi5 Live 환경에서 입력 → 분석 → 표시 파이프라인이 실시간 요구를 만족하는지 확인한다. 핵심 질문은 다음과 같다.

- Q1. 어떤 샘플레이트가 block drop 없이 안정적으로 동작하는가?
- Q2. processing + display latency가 p99 ≤ 500 ms를 만족하는가?

### 상태

계획됨

### 예상 산출물

- 샘플레이트별 성능 비교표(p50/p95/p99)
- block drop / missed beat 통계표
- WAV fixture vs Live 입력 비교 결과표
- 샘플레이트 목표안(Go/No-Go)

### 필요한 자원

- Raspberry Pi 5 실장비 1대
- Live 입력 + Playback WAV fixture(TimeGrapherTestFilesWeishiMic)
- 지연/드롭 로깅 코드
- 작업 공수: 1.5 person-days

### 실험 설명

1. 48k/96k/192k를 Live/Playback 공통 조건으로 실행해 입력 → 분석 → 표시 경로의 지연과 안정성을 측정한다.
2. 샘플레이트별 total latency, block drop, missed beat, CPU/RAM을 비교해 운영 가능한 기준값을 도출한다.
3. SAP 기준으로 p99 지연과 무드롭 조건 충족 여부를 판정하고 기본 샘플레이트(Go/No-Go)를 확정한다.

### 기간

- D1–D2: 계측 코드 준비
- D3: 측정 실행
- D4: 결과 분석 및 권고안 도출

### 링크 및 참고 자료

- NA

## EXP-02: GUI 실시간 렌더링 디자인 패턴

**리스크:** [R-F2](Milestone1_3-Risk-Assessment.md#f-프로젝트--프로세스) · **QAS:** [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--소리-입력에서-화면-표시까지), [QAS-4](Milestone1_2-Architectural-Drivers.md#qas-4--modifiability-extensibility--새-측정필터그래프-추가) · **우선순위:** High

### 결과 및 권장 사항

TO-DO: GUI 성능 개선용 디자인 패턴 우선순위와 적용 범위를 기록한다.

### 목적

GUI 실시간 성능 개선을 위해 렌더링/갱신 경로에 적용할 디자인 패턴을 기술속성 관점에서 비교하고, Milestone 내 우선 적용 패턴을 확정한다. 핵심 질문은 다음과 같다.

- Q1. 현재 GUI 병목에 대해 어떤 패턴(예: Producer-Consumer, Double Buffering, Object Pool)이 효과적인가?
- Q2. 패턴 적용 시 프레임 안정성, 지연, 구현 난이도 관점에서 우선순위는 어떻게 되는가?
- Q3. 팀이 단기 일정 내 적용 가능한 1순위 패턴 조합으로 합의할 수 있는가?

### 상태

계획됨

### 예상 산출물

- GUI 성능 개선 패턴 비교표(효과, 적용 난이도, 일정 영향)
- 우선 적용 패턴 세트(1순위/2순위)와 적용 대상 모듈 목록
- 패턴 적용 PoC 범위 및 검증 체크리스트

### 필요한 자원

- TimeGrapher_v10.4 소스코드
- C++/Qt 및 동시성/렌더링 패턴 레퍼런스
- 프로파일링/프레임타임 측정 도구
- 코드 리뷰 세션 참여 인원(2–4명)
- 작업 공수: 2.0 person-days

### 실험 설명

1. GUI 갱신 경로 병목을 식별하고 적용 가능한 디자인 패턴 후보를 추린다.
2. 후보 패턴을 소규모 PoC로 비교해 지연, 프레임 안정성, 구현 난이도를 측정한다.
3. SAP 기준으로 1순위 패턴 조합을 확정하고 Milestone 적용 범위를 결정한다.

### 기간

- D1–D2: 병목 분석 및 패턴 후보 도출
- D3–D4: 패턴 PoC 및 비교 측정
- D5: SAP 판정 및 적용 우선순위 확정

### 링크 및 참고 자료

- NA

## EXP-03: RPi5 Avalonia 렌더링 백엔드

**리스크:** [R-A5](Milestone1_3-Risk-Assessment.md#a-실시간-성능-rpi) · **QAS:** [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--소리-입력에서-화면-표시까지) · **우선순위:** High

### 결과 및 권장 사항

TO-DO: C# 선택 기준에서 Avalonia UI 렌더링 백엔드 고정 정책과 배포 기본값을 기록한다.

### 목적

개발 효율(C# 전문가 보유)을 위해 C# 경로를 채택할 때, Avalonia UI가 RPi5에서 GPU 가속 렌더링이 SW 렌더링보다 느려질 수 있는 리스크를 기술실험으로 해소한다. 핵심 질문은 다음과 같다.

- Q1. RPi5에서 GLX/EGL/Software 중 어떤 백엔드가 실제 워크로드에서 가장 안정적인 프레임 성능을 보이는가?
- Q2. 10Hz 이상 그래프 갱신율과 UI freeze 최소화 기준을 만족하는 운영 기본값을 확정할 수 있는가?

### 상태

계획됨

### 예상 산출물

- Avalonia 백엔드별 성능 비교표(FPS, p95/p99 프레임타임, freeze 횟수)
- 하드웨어/소프트웨어 렌더러 판별 로그(GL 컨텍스트 정보)
- C# 배포 기본 정책(백엔드 고정값, 실패 시 폴백 규칙)

### 필요한 자원

- Raspberry Pi 5 실장비(모니터/SSH)
- Avalonia 벤치 실행 빌드(CLI 측정 모드)
- 프레임타임 수집 및 결과 로그 도구
- 작업 공수: 1.0 person-days

### 실험 설명

1. Avalonia를 GLX/EGL/Software로 각각 실행해 동일 부하에서 프레임타임, FPS, freeze 지표를 수집한다.
2. GPU 가속 대비 SW 렌더링 성능 역전 여부를 확인하고 실제 운영에 적합한 백엔드를 선정한다.
3. SAP 기준으로 갱신율/안정성 충족 여부를 판정해 C# 배포 기본 백엔드 정책을 확정한다.

### 기간

- D6–D7

### 링크 및 참고 자료

- NA

## EXP-04: 온디바이스 TinyML 추론 타당성

**리스크:** [R-F4](Milestone1_3-Risk-Assessment.md#f-프로젝트--프로세스) · **QAS:** [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--소리-입력에서-화면-표시까지), [QAS-2](Milestone1_2-Architectural-Drivers.md#qas-2--availability-graceful-degradation--잡음약신호-환경) · **우선순위:** Mid

### 결과 및 권장 사항

TO-DO: TinyML 기능 채택 여부(채택/조건부 채택/보류)와 채택 조건을 기록한다.

### 목적

TinyML 기반 분류(예: signal-quality, bad-data-rejection)를 RPi 온디바이스로 추가했을 때 실시간성과 측정 신뢰성을 유지할 수 있는지 검증한다. 핵심 질문은 다음과 같다.

- Q1. TinyML 추론 추가 후에도 end-to-end 지연과 프레임 갱신 안정성이 허용 범위에 있는가?
- Q2. TinyML 분류가 약신호/잡음 구간의 오표시를 줄이는 데 기여하는가?

### 상태

계획됨

### 예상 산출물

- 모델 크기/추론시간/CPU 점유율 비교표
- TinyML on/off 성능 비교표(지연, 프레임타임, 오표시율, confusion matrix)
- 채택 여부 결정 메모(Go/Conditional/No-Go)

### 필요한 자원

- Raspberry Pi 5 실장비 1대
- TinyML 추론 런타임(TFLite 또는 동등 도구)
- 검증용 라벨 데이터셋(Sim/Playback)
- 성능 로깅 도구(지연, 프레임타임, CPU/RAM)
- 작업 공수: 1.5 person-days

### 실험 설명

1. TinyML off/on 상태를 동일 입력으로 실행해 지연, 프레임 안정성, 자원 사용량의 기준선과 변화를 측정한다.
2. 분류 정확도와 오표시율(약신호/잡음 구간)을 함께 비교해 기능 가치와 성능 비용을 동시에 평가한다.
3. SAP 기준으로 실시간성 유지 여부를 판정해 채택/조건부 채택/보류와 폴백 경로를 확정한다.

### 기간

- D7–D8

### 링크 및 참고 자료

- NA

## EXP-05: 장시간 24h+ 실행 안정성

**리스크:** [R-A4](Milestone1_3-Risk-Assessment.md#a-실시간-성능-rpi) · **QAS:** [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--소리-입력에서-화면-표시까지) · **우선순위:** Mid

### 결과 및 권장 사항

TO-DO: 장시간 실행 안정성 결론과 버퍼/메모리 정책 권고안을 기록한다.

### 목적

장시간 실행(24h+)에서 메모리 증가, 지연 악화, 크래시 위험을 확인한다. 핵심 질문은 다음과 같다.

- Q1. RSS 증가 추세가 누수 의심 수준인가?
- Q2. 장시간 후반부에서 지연/성능 열화가 발생하는가?

### 상태

계획됨

### 예상 산출물

- 6h/24h 자원 사용 추세 그래프
- 장시간 안정성 리포트
- 버퍼 상한/객체 수명 관리 정책

### 필요한 자원

- 장시간 실행 가능한 Pi 또는 동등 환경
- RSS/CPU/지연 장기 로깅 도구
- 작업 공수: 1.0 person-days(셋업) + 실행 대기

### 실험 설명

1. 6h 예비 검증 후 24h 장시간 실행으로 메모리, 지연, 오류 추세를 연속 수집한다.
2. 전반부/후반부 성능을 비교해 누수 의심, 처리량 저하, 지연 악화 여부를 확인한다.
3. SAP 기준으로 안정성 합격 여부를 판정하고 버퍼/메모리 운영 정책을 확정한다.

### 기간

- D8–D10

### 링크 및 참고 자료

- NA

## EXP-06: 글자 가독성과 터치 타깃 UI 기준

**리스크:** [R-E1](Milestone1_3-Risk-Assessment.md#e-사용성--ui-1280800), [R-E2](Milestone1_3-Risk-Assessment.md#e-사용성--ui-1280800) · **QAS:** [QAS-5](Milestone1_2-Architectural-Drivers.md#qas-5--usability--터치스크린에서-읽기조작) · **우선순위:** Mid

### 결과 및 권장 사항

TO-DO: 글자 크기 기준안(최소/권장), 터치 타깃 기준안, 최종 UI 레이아웃 권고안을 기록한다.

### 목적

작은 화면에서 요약바 + 그래프 + 스코프 스트립을 동시에 표시할 때 가독성과 터치 조작성을 확보할 수 있는지 검증한다. 핵심 질문은 다음과 같다.

- Q1. 글자 크기를 단계적으로 변경할 때 사용자 만족도는 어떻게 달라지는가?
- Q2. 글자 가독성 만족도와 터치 인식률을 동시에 만족하는 최소 UI 기준은 무엇인가?

### 상태

계획됨

### 예상 산출물

- 글자 크기 단계별 사용자 만족도 설문 결과표
- 글자 크기/터치 타깃 조합별 터치 성공률 및 오터치율 표
- UI 기준안: 최소 글자 높이(mm), 권장 글자 높이(mm), 최소 터치 타깃(mm), 모드 전환 탭 구조

### 필요한 자원

- Raspberry Pi 5 + 1280×800 터치 디스플레이
- UI 실험 빌드(글자 크기/터치 타깃 프리셋 전환 가능)
- 실험 참가자 8–12명(팀원 + 외부 사용자 혼합 권장)
- 설문 도구(구글폼 또는 동등 도구)
- 작업 공수: 1.5 person-days

### 실험 설명

1. 고정 레이아웃에서 글자 크기/터치 타깃 조합을 단계별로 바꿔 동일 태스크를 수행하고 읽기성과 조작성 데이터를 수집한다.
2. 객관 지표(완료시간, 오류율, 터치 성공률, 오터치율)와 주관 지표(만족도 설문)를 함께 비교해 최소/권장 UI 기준을 도출한다.
3. SAP 기준으로 가독성·터치성 합격 여부를 판정하고 최종 레이아웃 권고안을 확정한다.

### 기간

- D9: 실험 빌드 준비 및 설문 문항 확정
- D10: 파일럿 2명으로 리허설
- D11–D12: 본 실험(8–12명) 수행 및 결과 분석

### 링크 및 참고 자료

- NA

## 통합 일정

- Week 1: EXP-01, EXP-02, EXP-03
- Week 2: EXP-04, EXP-06
- Week 3: EXP-05, EXP-06(확장 검증) 및 미해결 항목 재실험

## 공통 승인 기준

- High 우선순위 실험(성능/강건성) pass/fail 판정 완료
- QAS-1, QAS-2 임계값 수치 확정
- 채택/기각 의사결정 근거가 실험 로그와 함께 기록됨
