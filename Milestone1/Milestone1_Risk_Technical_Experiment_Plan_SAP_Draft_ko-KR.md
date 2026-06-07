# Milestone1 리스크 대응 기술실험 계획 (SAP 원칙 기반, 템플릿 정렬본)

## 리스크-실험 매핑 요약

| 실험 ID | 대응 리스크 | 관련 QAS | 우선순위 | 핵심 질문 |
|---|---|---|---|---|
| EXP-A1 | R-A1, R-A3 | QAS-1 | High | Pi5에서 실시간 처리 가능한 샘플레이트 상한은? |
| EXP-F2S | R-F2 | QAS-1, QAS-4 | High | TimeGrapher_v10.4 구조를 빠르게 이해하고 실시간 최적화를 위한 C++ 설계 패턴을 제안할 수 있는가? |
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
1. 48k/96k/192k를 동일 입력 조건에서 각각 10분 실행한다.
2. 입력 타입을 분리해 반복 측정한다.
- Playback WAV fixture
- Live 마이크 입력
3. capture->processing, processing->display, total latency를 기록한다.
4. block drop, missed beat, CPU/RAM을 수집한다.
5. SAP 시나리오 기준으로 측정 결과를 판단한다.
	- Source: 마이크 입력 스트림
	- Stimulus: 연속 오디오 입력 도착
	- Artifact: 입력-분석-표시 파이프라인
	- Environment: RPi5 Live/Playback
	- Response: 실시간 처리 및 화면 갱신
	- Response Measure: total latency p99 <= 500 ms, 96k에서 dropped block=0, missed beat=0
6. 의사결정을 명시한다.
- 96k 기준 미달 시 48k를 기본 운영 샘플레이트로 고정
- 192k는 stretch 목표로 분리

### 기간
- D1-D2: 계측 코드 준비
- D3: 측정 실행
- D4: 결과 분석 및 권고안 도출

### 링크 및 참고 자료
- Milestone1_Risk_Assessment.md
- Milestone1_Architectural_Drivers_QAS.md

## 실험 2: EXP-F4 (R-F4)

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
1. 기준선(Baseline)으로 TinyML 미적용 상태의 지연/프레임타임/오표시율을 측정한다.
2. Windows 환경에서 모델 후보를 선검증한 뒤 RPi5로 이식해 동일 입력으로 반복 측정한다.
3. 실시간 그래프 렌더링 성능 검증 항목을 참조해 다음 공통 성능 지표를 함께 기록한다.
- p95 FPS 또는 프레임타임 안정성
- UI freeze 횟수
- end-to-end latency p99
- CPU/RAM 증가량
4. TinyML on/off의 signal weak 오표시율 및 검출률 차이를 비교한다.
5. 분류 성능 지표를 함께 기록한다.
- confusion matrix
- false accept / false reject
6. SAP 시나리오 기준으로 평가한다.
	- Source: 온디바이스 TinyML 추론 요청
	- Stimulus: 실시간 입력 중 분류 추론 수행
	- Artifact: 분석 파이프라인 + TinyML 모듈
	- Environment: RPi5 Live/Playback
	- Response: 실시간 분석/표시 유지 + 분류 결과 반영
	- Response Measure: total latency p99 기준 유지, UI freeze 0회, 오표시율 감소, false accept/reject 허용 범위 내
7. 채택 실패 시 폴백 전략을 명시한다.
- TinyML 보류 시 규칙기반(signal weak 게이팅) 경로 유지

### 기간
- D7-D8

### 링크 및 참고 자료
- Milestone1_Risk_Assessment.md
- Milestone1_Architectural_Drivers_QAS.md

## 실험 3: EXP-A4 (R-A4)

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
1. 6시간 단기 검증 후 24시간 확장 검증을 수행한다.
2. 1분 단위로 RSS, CPU, latency, 오류카운트를 기록한다.
3. 전반부 대비 후반부의 지연/처리량 변화를 분석한다.
4. 24시간 연속 검증이 어려운 경우 1시간 단위 결과를 조합해 24시간 추정치를 산출한다.
5. SAP 시나리오 기준으로 합격 여부를 판단한다.
	- Source: 장시간 연속 입력
	- Stimulus: 24h 지속 실행
	- Artifact: 버퍼/집계/표시 루프
	- Environment: Pi 장시간 실행
	- Response: 안정 동작 유지
	- Response Measure: 크래시 0회, RSS가 상한 내 수렴(비증가 추세), p99 latency 악화 없음

### 기간
- D8-D10

### 링크 및 참고 자료
- Milestone1_Risk_Assessment.md
- Milestone1_Architectural_Drivers_QAS.md

## 실험 4: EXP-E1E3 (R-E1, R-E3)

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
1. 화면 레이아웃(요약바 + 그래프 + 스코프)은 고정하고 글자 크기만 단계적으로 바꾼다.
2. 글자 크기 조건을 최소 4단계로 준비한다.
- A: 2.4 mm
- B: 2.9 mm
- C: 3.2 mm
- D: 3.6 mm
3. 각 글자 크기 조건마다 동일 태스크를 수행시킨다.
- T1: 요약바에서 rate/beat error/amplitude 읽기
- T2: 그래프 모드 전환 버튼 터치
- T3: 스코프 관련 컨트롤 3회 연속 터치
- T4: active position 확인
- T5: X/D 확인
4. 각 조건마다 객관 지표를 기록한다.
- 읽기 완료 시간
- 읽기 오류율
- 터치 성공률
- 오터치율
- 재시도 횟수
5. 각 조건 종료 직후 별도 만족도 설문을 실시한다(7점 Likert).
- 문항 S1: 화면 글자가 읽기 쉬웠다
- 문항 S2: 원하는 버튼을 정확히 터치할 수 있었다
- 문항 S3: 전체 화면 구성이 답답하지 않았다
- 문항 S4: 실사용 가능하다고 느꼈다
6. SAP 시나리오 기준으로 결과를 판정한다.
- Source: 사용자(시계공/운영자)
- Stimulus: 작은 화면에서 값 읽기와 터치 조작 수행
- Artifact: GUI 요약바 + 그래프 + 스코프 + 터치 인터랙션
- Environment: RPi5 1280x800 실장비
- Response: 값 읽기 가능, 터치 조작 성공, 사용자 만족도 확보
- Response Measure:
	- 글자 높이 2.9 mm 이상 조건에서 만족도 평균 5.0/7 이상
	- 명암 대비 4.5:1 이상
	- 터치 타깃 9 mm 이상 조건에서 터치 성공률 95% 이상
	- 오터치율 5% 이하
	- 주요 태스크 완료율 95% 이상
	- 주요 모드 진입 <= 2탭
	- active position 확인 <= 5초(90% 이상), X/D 확인 <= 10초(90% 이상)

### 기간
- D9: 실험 빌드 준비 및 설문 문항 확정
- D10: 파일럿 2명으로 리허설
- D11-D12: 본 실험(8-12명) 수행 및 결과 분석

### 링크 및 참고 자료
- Milestone1_Risk_Assessment.md
- Milestone1_Architectural_Drivers_QAS.md
- technical-experiment-template_ko-KR.md

## 실험 5: EXP-F2S (R-F2)

### 결과 및 권장 사항
TO-DO: 코드 이해 산출물(모듈맵/콜플로우)과 실시간 최적화 설계 패턴 제안서(채택 우선순위 포함)를 기록한다.

### 목적
제공 베이스라인 코드(TimeGrapher_v10.4) 이해 지연 리스크를 줄이고, C++ 숙련 인원이 적은 팀에서도 실시간 성능 최적화를 추진할 수 있는 설계 기준을 만든다.
핵심 질문은 다음과 같다.
- Q1. 핵심 실행 경로(입력-분석-표시)를 팀이 공통으로 설명 가능한 수준까지 단기간에 파악할 수 있는가?
- Q2. 실시간 성능 병목을 줄이기 위한 C++ 설계 패턴을 우선순위로 제안할 수 있는가?

### 상태
계획됨

### 예상 산출물
- TimeGrapher_v10.4 모듈 맵(파일/클래스/책임/의존관계)
- 핵심 콜 플로우 다이어그램(입력 -> DSP/계산 -> 렌더)
- 병목 후보 리스트(CPU, 메모리 할당, 잠금 경합, 렌더링 경로)
- 실시간 최적화 패턴 제안서(패턴별 적용 위치, 기대효과, 리스크)
- 모듈 분리 골격 스파이크 결과(계층 경계/등록 지점)
- 1주 온보딩 스터디 가이드(C++/Qt/동시성 최소 필수 주제)

### 필요한 자원
- TimeGrapher_v10.4 소스코드
- C++/Qt 레퍼런스 문서
- 코드 읽기 세션 참여 인원(2-4명)
- 간단한 프로파일링 도구(호출시간, 할당량, 잠금 대기시간 확인)
- 작업 공수: 2.0 person-days

### 실험 설명
1. 코드 이해 Study를 수행한다.
- Day 1: 엔트리 포인트, 스레드 구조, 오디오 입력 루프 파악
- Day 2: 분석 계산 루프와 UI 렌더 경로 파악
- Day 3: 팀 내 30분 설명 세션(모듈맵, 콜플로우 공유)
2. 실시간 병목 관찰 스파이크를 수행한다.
- 함수 단위 호출시간 상위 구간 추출
- 프레임 루프의 동적 메모리 할당 지점 확인
- 큐/락 사용 구간의 대기시간 확인
3. 모듈 분리 골격 스파이크를 수행한다.
- acquisition / processing / calculation / presentation 4계층 골격 분리
- 새 그래프 1종, 새 필터 1종, 새 측정값 1종을 시범 추가
- 기능 추가 시 변경된 기존 모듈 수와 등록 지점 수를 계측
4. 실시간 최적화 설계 패턴 후보를 제안하고, 현재 구조 적합도를 평가한다.
- DP-1. Producer-Consumer + Ring Buffer: 오디오 캡처와 분석 단계 decouple
- DP-2. Active Object: 분석 작업 비동기 큐잉으로 UI 블로킹 최소화
- DP-3. Strategy Pattern: 필터/알고리즘 교체 비용 축소 및 실험 용이
- DP-4. Double Buffering: 렌더링 데이터 스냅샷 일관성 확보
- DP-5. Object Pool: 프레임 루프 내 빈번한 new/delete 감소
5. 패턴별 우선순위를 결정한다.
- 효과(지연/안정성 개선 가능성)
- 적용 난이도(코드 변경 범위)
- 팀 숙련도 적합성(C++ 경험 수준)
6. SAP 시나리오 기준으로 결과를 판정한다.
- Source: 개발팀(낮은 C++ 숙련도)
- Stimulus: 베이스라인 코드 이해 필요 + 실시간 성능 개선 요구
- Artifact: 입력/분석/표시 코드 구조 및 스레드/큐/메모리 경로
- Environment: Time-boxed Milestone 일정
- Response: 빠른 온보딩 + 적용 가능한 최적화 패턴 제안
- Response Measure:
	- 핵심 모듈 80% 이상에 대해 책임/입출력/호출관계 설명 가능
	- 새 그래프/필터/측정값 추가 시 각 항목별 기존 모듈 변경 <= 1
	- 회귀 테스트 실패 0건
	- 패턴 제안서 3개 이상, 각 패턴에 적용 위치와 기대효과 명시
	- 우선순위 1-2개 패턴에 대해 PoC 범위 정의 완료

### 기간
- D1-D3: 코드 이해 Study + 모듈맵/콜플로우 작성
- D4: 병목 관찰 스파이크
- D5: 패턴 제안서 및 우선순위 결정

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
