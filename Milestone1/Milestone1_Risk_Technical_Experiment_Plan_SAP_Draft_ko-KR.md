# Milestone1 리스크 대응 기술실험 계획 (SAP 원칙 기반, 템플릿 정렬본)

## 리스크-실험 매핑 요약

| 실험 ID | 대응 리스크 | 관련 QAS | 우선순위 | 핵심 질문 |
|---|---|---|---|---|
| EXP-A1 | R-A1, R-A3 | QAS-1 | High | Pi5에서 실시간 처리 가능한 샘플레이트 상한은? |
| EXP-F2S | R-F2 | QAS-1, QAS-4 | High | 실시간 성능 개선을 위해 C++ 경로와 C# 경로 중 무엇을 우선 채택해야 하는가? |
| EXP-F4 | R-F4 | QAS-1, QAS-2 | Mid | TinyML 추론을 추가해도 실시간성과 신뢰성을 유지할 수 있는가? |
| EXP-A4 | R-A4 | QAS-1 | Mid | 장시간 실행에서 메모리/지연 열화가 발생하는가? |
| EXP-E1E3 | R-E1, R-E3 | QAS-5 | Mid | 글자 크기/터치 타깃 조합 중 가독성과 터치 인식 만족도를 동시에 만족하는 UI 기준은 무엇인가? |

현재 문서에서 Low 우선순위 실험은 없음.

## 실험 1: EXP-A1 (R-A1, R-A3)

### 결과 및 권장 사항
TO-DO: 측정 완료 후 최종 권장 샘플레이트(48k/96k/192k)와 채택 근거를 기록한다.

### 목적
Pi5 Live 환경에서 입력-분석-표시 파이프라인이 실시간 요구를 만족하는지 확인한다.
핵심 질문은 다음과 같다.
- Q1. 어떤 샘플레이트가 block drop 없이 안정적으로 동작하는가?
- Q2. processing+display latency가 p99 <= 500 ms를 만족하는가?

### 상태
계획됨

### 예상 산출물
- 샘플레이트별 성능 비교표(p50/p95/p99)
- block drop/missed beat 통계표
- WAV fixture vs Live 입력 비교 결과표
- 샘플레이트 목표안(Go/No-Go)

### 필요한 자원
- Raspberry Pi 5 실장비 1대
- Live 입력 + Playback WAV fixture(TimeGrapherTestFilesWeishiMic)
- 지연/드롭 로깅 코드
- 작업 공수: 1.5 person-days

### 실험 설명
1. 48k/96k/192k를 Live/Playback 공통 조건으로 실행해 입력-분석-표시 경로의 지연과 안정성을 측정한다.
2. 샘플레이트별 total latency, block drop, missed beat, CPU/RAM을 비교해 운영 가능한 기준값을 도출한다.
3. SAP 기준으로 p99 지연과 무드롭 조건 충족 여부를 판정하고 기본 샘플레이트(Go/No-Go)를 확정한다.

### 기간
- D1-D2: 계측 코드 준비
- D3: 측정 실행
- D4: 결과 분석 및 권고안 도출

### 링크 및 참고 자료
- Milestone1_Risk_Assessment.md
- Milestone1_Architectural_Drivers_QAS.md

## 실험 2: EXP-F2S (R-F2)

### 결과 및 권장 사항
TO-DO: GUI 렌더링 속도 개선 관점의 C++ vs C# 비교 결과와 우선 채택 경로를 기록한다.

### 목적
RPi5 환경에서 GUI 렌더링 지연과 프레임 끊김을 줄이기 위해 C++ 경로와 C# 경로를 동일 기준으로 비교하고, Milestone 내 즉시 적용 가능한 개선 경로를 결정한다.
핵심 질문은 다음과 같다.
- Q1. C# 렌더링 백엔드(GLX/EGL/Software) 중 어떤 경로가 GUI 갱신율 10Hz 이상을 가장 안정적으로 만족하는가?
- Q2. C++ 경로의 병목 개선 활동이 GUI 렌더링 체감 성능 개선에 기여할 수 있는가?
- Q3. 두 경로를 SAP 기준(Response Measure)으로 비교해 1순위 실행안을 합의할 수 있는가?

### 상태
계획됨

### 예상 산출물
- 백엔드별 측정 결과표(GLX/EGL/Software: FPS, p95/p99 프레임타임, 프리즈 횟수)
- C++ vs C# 개선활동 비교표(효과, 구현 난이도, 일정 리스크)
- 최종 권고안(1순위 즉시 적용안 + 2순위 후속 실험안)

### 필요한 자원
- TimeGrapher_v10.4 소스코드
- C++/Qt 레퍼런스 문서
- Avalonia 앱 실행 환경 및 RPi5 장비
- 프로파일링/프레임타임 측정 도구
- 작업 공수: 2.0 person-days

### 실험 설명
1. C# 경로에서 GLX/EGL/Software를 동일 시나리오로 실행해 GUI 프레임타임, FPS, 프리즈 여부를 측정한다.
2. C++ 경로에서 렌더링 영향 구간 병목을 관찰해 즉시 적용 가능한 개선 활동 후보를 정리한다.
3. SAP 기준(Source/Stimulus/Artifact/Environment/Response Measure)으로 두 경로를 비교해 1순위 실행안을 확정한다.

### 기간
- D1-D2: C# 렌더링 백엔드 측정 및 결과 정리
- D3-D4: C++ 병목 개선 활동 정리
- D5: SAP 기준 통합 판정 및 우선 경로 확정

### 링크 및 참고 자료
- Milestone1_Risk_Assessment.md
- Milestone1_Architectural_Drivers_QAS.md
- technical-experiment-template_ko-KR.md

## 실험 3: EXP-F4 (R-F4)

### 결과 및 권장 사항
TO-DO: TinyML 기능 채택 여부(채택/조건부 채택/보류)와 채택 조건을 기록한다.

### 목적
TinyML 기반 분류(예: signal-quality, bad-data-rejection)를 RPi 온디바이스로 추가했을 때 실시간성과 측정 신뢰성을 유지할 수 있는지 검증한다.
핵심 질문은 다음과 같다.
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
- D7-D8

### 링크 및 참고 자료
- Milestone1_Risk_Assessment.md
- Milestone1_Architectural_Drivers_QAS.md

## 실험 4: EXP-A4 (R-A4)

### 결과 및 권장 사항
TO-DO: 장시간 실행 안정성 결론과 버퍼/메모리 정책 권고안을 기록한다.

### 목적
장시간 실행(24h+)에서 메모리 증가, 지연 악화, 크래시 위험을 확인한다.
핵심 질문은 다음과 같다.
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
- D8-D10

### 링크 및 참고 자료
- Milestone1_Risk_Assessment.md
- Milestone1_Architectural_Drivers_QAS.md

## 실험 5: EXP-E1E3 (R-E1, R-E3)

### 결과 및 권장 사항
TO-DO: 글자 크기 기준안(최소/권장), 터치 타깃 기준안, 최종 UI 레이아웃 권고안을 기록한다.

### 목적
작은 화면에서 요약바 + 그래프 + 스코프를 동시에 표시할 때 가독성과 터치 조작성을 확보할 수 있는지 검증한다.
핵심 질문은 다음과 같다.
- Q1. 글자 크기를 단계적으로 변경할 때 사용자 만족도는 어떻게 달라지는가?
- Q2. 글자 가독성 만족도와 터치 인식률을 동시에 만족하는 최소 UI 기준은 무엇인가?

### 상태
계획됨

### 예상 산출물
- 글자 크기 단계별 사용자 만족도 설문 결과표
- 글자 크기/터치 타깃 조합별 터치 성공률 및 오터치율 표
- UI 기준안: 최소 글자 높이(mm), 권장 글자 높이(mm), 최소 터치 타깃(mm), 모드 전환 탭 구조

### 필요한 자원
- Raspberry Pi 5 + 1280x800 터치 디스플레이
- UI 실험 빌드(글자 크기/터치 타깃 프리셋 전환 가능)
- 실험 참가자 8-12명(팀원 + 외부 사용자 혼합 권장)
- 설문 도구(구글폼 또는 동등 도구)
- 작업 공수: 1.5 person-days

### 실험 설명
1. 고정 레이아웃에서 글자 크기/터치 타깃 조합을 단계별로 바꿔 동일 태스크를 수행하고 읽기성과 조작성 데이터를 수집한다.
2. 객관 지표(완료시간, 오류율, 터치 성공률, 오터치율)와 주관 지표(만족도 설문)를 함께 비교해 최소/권장 UI 기준을 도출한다.
3. SAP 기준으로 가독성·터치성 합격 여부를 판정하고 최종 레이아웃 권고안을 확정한다.

### 기간
- D9: 실험 빌드 준비 및 설문 문항 확정
- D10: 파일럿 2명으로 리허설
- D11-D12: 본 실험(8-12명) 수행 및 결과 분석

### 링크 및 참고 자료
- Milestone1_Risk_Assessment.md
- Milestone1_Architectural_Drivers_QAS.md
- technical-experiment-template_ko-KR.md

## 통합 일정
- Week 1: EXP-F2S, EXP-A1
- Week 2: EXP-F4, EXP-E1E3
- Week 3: EXP-A4, EXP-E1E3(확장 검증) 및 미해결 항목 재실험

## 공통 승인 기준
- High 우선순위 실험(성능/강건성) pass/fail 판정 완료
- QAS-1, QAS-2 임계값 수치 확정
- 채택/기각 의사결정 근거가 실험 로그와 함께 기록됨
