# Risk Assessment

> 프로젝트를 위협하는 리스크를 영역별로 정리하고, 발생 확률과 영향(High/Medium/Low)으로 등급화했다.

**목차** — [용어 설명](#용어-설명) · [리스크 요약](#리스크-요약) · [A. 실시간 성능](#a-실시간-성능-rpi) · [B. 신호처리](#b-신호처리--측정-신뢰성) · [C. 아키텍처](#c-아키텍처--확장성) · [D. 하드웨어/플랫폼](#d-하드웨어--플랫폼) · [E. 사용성/UI](#e-사용성--ui-1280800) · [F. 프로젝트/프로세스](#f-프로젝트--프로세스) · [G. 기타](#g-기타-또는-카테고리화-되지-않음)

## 용어 설명

이 문서에서 사용되는 용어는 통합 [Glossary](7-Glossary.md)에 정의되어 있다 — **플랫폼·엔지니어링 용어**(및 도메인/품질 속성 섹션) 참조.

## 리스크 요약

> 구분: **T** = 기술(Technical), **NT** = 비기술(Non-technical)
>
> **P** = 발생 확률(Probability), **I** = 영향(Impact) — **H** = High, M = Medium, L = Low
>
> 🔴 = 계획된 실험이 있는 리스크([Planned Experiments](4-Planned-Experiments.md) 참조)
>
> **상태** — 해결 / 진행중 / 수용

Risk ID | 상태 | 리스크 타이틀 | 구분 | QAS | P | I
--------|------|--------------|------|-----|---|---
[R-01](#a-실시간-성능-rpi) 🔴 | 해결 | RPi5가 고속 샘플레이트(96k/192k)를 실시간으로 못 따라가 소리 데이터를 놓친다 | T | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지) | **L** | **H**
[R-02](#a-실시간-성능-rpi) 🔴 | 해결 | 필터 4개 + 그래프 여러 개 동시 렌더링으로 화면이 버벅인다 | T | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지)<br>[QAS-6](2-Architectural-Drivers.md#qas-6--usability--터치스크린에서-읽기조작) | M | **H**
[R-03](#a-실시간-성능-rpi) 🔴 | 해결 | 분석·표시가 비트 주기 예산(83.3 ms @ 43200 BPH)을 넘겨 backlog·stale 표시·block drop·missed beat가 발생한다 | T | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지) | M | **H**
[R-04](#a-실시간-성능-rpi) 🔴 | 해결 | 장시간(24h+) 연속 실행 시 메모리가 새서 느려지거나 죽는다 | T | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지) | **L** | M
[R-05](#a-실시간-성능-rpi) 🔴 | 해결 | 종결: RPi5 latency/rendering 확인 후 .NET (C#) + Avalonia UI 개발 결정 | T | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지) | L | L
[R-06](#b-신호처리--측정-신뢰성) 🔴 | 진행중 | A·C 이벤트 위치를 0.1 ms 정밀도로 못 찾아 일오차·비트 에러·진폭 전부 오염된다 | T | [QAS-1](2-Architectural-Drivers.md#qas-1--accuracy--음향-이벤트-검출에서-시계-지표-계산까지의-정확도)<br>[QAS-3](2-Architectural-Drivers.md#qas-3)<br>[QAS-4](2-Architectural-Drivers.md#qas-4--consistency--표시-간-값-일치) | **H** | **H**
[R-07](#b-신호처리--측정-신뢰성) | 진행중 | 시끄럽거나 약한 신호에서 "신호 약함" 대신 오해를 부르는 값을 표시한다 | T | [QAS-3](2-Architectural-Drivers.md#qas-3) | M | **H**
[R-08](#c-아키텍처--확장성) | 해결 | 필터/마커 확장 구조를 미리 설계하지 않아 후반 비용이 급증한다 | T | [QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--새-측정필터그래프-추가) | M | M
[R-09](#d-하드웨어--플랫폼) | 해결 | AGC를 끄지 않거나 마이크 결합이 나빠 신호가 왜곡된다 | T | [QAS-3](2-Architectural-Drivers.md#qas-3) | M | **H**
[R-10](#d-하드웨어--플랫폼) | 해결 | Windows 개발–RPi 데모 간 플랫폼 차이(WASAPI/ALSA)가 늦게 드러난다 | T | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지) | M | M
[R-11](#d-하드웨어--플랫폼) | 해결 | 샘플레이트 3종(48/96/192k) 지원이 타이밍 복잡도를 키운다 | T | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지) | M | M
[R-12](#e-사용성--ui-1280800) | 해결 | 작은 화면에 요약바 + 그래프 + 스코프 스트립을 가독성 있게 다 못 담는다 | T | [QAS-6](2-Architectural-Drivers.md#qas-6--usability--터치스크린에서-읽기조작) | M | M
[R-13](#e-사용성--ui-1280800) | 수용 | 터치 정확도·인식률이 떨어질 수 있다 | T | [QAS-6](2-Architectural-Drivers.md#qas-6--usability--터치스크린에서-읽기조작) | L | L
[R-14](#f-프로젝트--프로세스) | 해결 | 3주 안에 12개 기능 + AI 전부 불가능 — 우선순위 실패 시 핵심이 빠진다 | NT | QAS-ALL | M | **H**
[R-15](#f-프로젝트--프로세스) | 해결 | 베이스라인 코드 이해에 시간이 걸려 착수가 늦어진다 | NT | [QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--새-측정필터그래프-추가) | L | M
[R-16](#f-프로젝트--프로세스) | 해결 | Qt/C++·DSP·RPi 학습곡선으로 구현 품질이 흔들린다 | NT | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지)<br>[QAS-3](2-Architectural-Drivers.md#qas-3) | L | M
[R-17](#f-프로젝트--프로세스) 🔴 | 진행중 | AI/TinyML 기능 시도 시 on-device 불확실성이 커진다 | T | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지)<br>[QAS-3](2-Architectural-Drivers.md#qas-3) | M | M
[R-18](#f-프로젝트--프로세스) | 수용 | GenAI 생성 코드를 검증 없이 수용하면 그럴듯하지만 틀린 코드가 들어온다 | NT | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지)<br>[QAS-3](2-Architectural-Drivers.md#qas-3)<br>[QAS-4](2-Architectural-Drivers.md#qas-4--consistency--표시-간-값-일치) | M | M
[R-19](#f-프로젝트--프로세스) | 수용 | 테스트용 RPi5가 한 대뿐이라 실사용 검증 일정이 안 나온다 | NT | [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지) | **H** | **H**
[R-20](#g-기타-또는-카테고리화-되지-않음) | 수용 | 의사소통 — 영어 대화 시 이해관계자 간 정확한 의사전달이 안 될 수 있다 | NT | - | L | L
[R-21](#g-기타-또는-카테고리화-되지-않음) | 수용 | 테스트 환경 부족 — 장비 1대, 테스트룸·unit test 없음으로 로직 변경 시 regression을 놓칠 수 있다 | NT | - | L | L
[R-22](#g-기타-또는-카테고리화-되지-않음) | 수용 | 장시간 검증 곤란 — 24시간 연속 같은 항목은 실제 검증·평가가 어렵다 | NT | - | L | L
[R-23](#g-기타-또는-카테고리화-되지-않음) | 수용 | 저장량 증가 — 장시간 녹음 시 파일 크기가 커진다 | T | - | L | L
[R-24](#g-기타-또는-카테고리화-되지-않음) | 수용 | RPi5 디버깅 곤란 — 상태 파악·디버깅이 어렵다 | T | - | L | L
[R-25](#g-기타-또는-카테고리화-되지-않음) | 수용 | 데이터 구조 불확실 — 음성 버퍼·측정 데이터 저장 구조가 미정이다 | T | - | L | L
[R-26](#g-기타-또는-카테고리화-되지-않음) | 수용 | 저장 속도 병목 — SD 카드 쓰기가 녹음 생성 속도보다 느릴 수 있다 | T | - | L | L

## A. 실시간 성능 (RPi)

- **🔴 R-01 — RPi5가 고속 샘플레이트(96k/192k)를 실시간으로 따라가지 못해 소리 데이터를 놓친다 (block drop / missed beat)**
  - **상태**: 해결
  - **리스크 근거**: pdf (p.25 Real Time Performance), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지), [C-1](2-Architectural-Drivers.md#설계-제약사항)
  - **발생 확률 / 영향**: Low / High
  - **등급 근거**
    - P-Low: [EXP-02](4-Planned-Experiments.md#exp-02-rpi5-실시간-샘플레이트-상한) 측정에서 43200 BPH @ 192 kHz가 RPi5에서 worst-case E2E 예산의 약 41% 수준으로 동작했고 block drop·missed beat가 0이었다. 고속 샘플레이트 실시간 처리가 실측으로 확인됨.
    - I-High: 소리 데이터 손실은 핵심 측정 자체를 망가뜨림(발생 시 영향은 그대로 큼).
  - **결과**: 48k 기본 / 192k 최고로 확정. [EXP-02](4-Planned-Experiments.md#exp-02-rpi5-실시간-샘플레이트-상한)에서 최악 조건 43200 BPH @ 192 kHz가 예산 약 41%(drop·miss 0)로 통과해 192k를 정식 지원으로 격상. 96k 직접 측정·CPU/RAM·이미지 탭은 추가 확인이 남은 조건부 해결.

- **🔴 R-02 — 필터 4개(F0→F3) + 그래프 여러 개를 동시에 그리면 화면이 버벅인다(<20 FPS·UI freeze)**
  - **상태**: 해결
  - **리스크 근거**: [FR-12-01](2-Architectural-Drivers.md#g12--scope-function-with-multiple-filter-views), [FR-12-04](2-Architectural-Drivers.md#g12--scope-function-with-multiple-filter-views), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지), [QAS-6](2-Architectural-Drivers.md#qas-6--usability--터치스크린에서-읽기조작)
  - **발생 확률 / 영향**: Medium / High
  - **등급 근거**
    - P-Medium: 끊김은 렌더링 부하에 좌우되고 비활성 뷰 컬링으로 줄일 수 있음.
    - I-High: UI 멈춤·버벅임은 최우선 드라이버 [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지)을 직접 위반.
  - **결과**: [EXP-03](4-Planned-Experiments.md#exp-03-gui-실시간-렌더링-디자인-패턴)에서 Pipe-and-Filter + 동시성 택틱(전용 분석 스레드·Latest-Wins·고정 버퍼)으로 UI 병목 제거. 28800 BPH 부하에서 렌더 예산(33/100 ms) 내 수렴. Latest-Wins의 프레임 유실은 실시간 모니터 특성상 용인하고 장기 히스토리는 `DecimatingSeries`로 보완 → 소스 반영으로 종결.

- **🔴 R-03 — 분석·표시가 비트 주기 예산(83.3 ms @ 43200 BPH)을 넘겨 backlog·stale 표시·block drop·missed beat가 발생한다**
  - **상태**: 해결
  - **리스크 근거**: [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지) — 한 비트 주기 = 3600 s ÷ BPH (43200 BPH: 83.3 ms · 21600 BPH: 166.7 ms)
  - **발생 확률 / 영향**: Medium / High
  - **등급 근거**
    - P-Medium: 처리·렌더 부하가 샘플레이트·BPH·활성 탭·그래프 수에 따라 커져 예산을 넘길 수 있음.
    - I-High: 예산 초과가 지속되면 backlog·stale 표시, 최악엔 block drop·missed beat로 측정값이 오염됨.
  - **결과**: 분석/UI 스레드 분리 + Latest-Wins·bounded buffer로 대응. [EXP-02](4-Planned-Experiments.md#exp-02-rpi5-실시간-샘플레이트-상한)의 21600@48k·43200@192k × Live/Playback/Simulation 측정에서 RPi5·Windows 모두 예산 내 Pass(drop 0, miss 0)로 backlog/stale 위험 통제. 신규 연산·필터·그래프·AI Feature 추가 시 동일 기준 재측정.

- **🔴 R-04 — 장시간(24h+) 연속 실행 시 메모리가 새서 느려지거나 죽는다**
  - **상태**: 해결
  - **리스크 근거**: [FR-07-10](2-Architectural-Drivers.md#g07--long-term-performance-graph), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지)
  - **발생 확률 / 영향**: Low / Medium
  - **등급 근거**
    - P-Low: [EXP-05](4-Planned-Experiments.md#exp-05-장시간-24h-실행-안정성) 24h+ 연속 실행 측정에서 RSS가 약 406 MB로 평탄(전 구간 변화 -1.6 MB)했고 후반부 CPU/지연 열화가 없어 누수 의심 수준이 아님을 실측 확인.
    - I-Medium: 선택적 24h+ 기능에만 영향, 점진적이며 재시작으로 복구 가능하고 값은 정확.
  - **결과**: [EXP-05](4-Planned-Experiments.md#exp-05-장시간-24h-실행-안정성) 24h+ 연속 가동에서 RSS 약 406 MB 평탄(변화 -1.6 MB)·CPU ~1.4코어·열화 없음으로 **Pass**. 추가 상한/집계 없이 현행 유지로 24h 안정성 충족. 신규 부하 추가 시 동일 절차(0.5초 RSS/CPU 로깅)로 재측정.

- **🔴 R-05 — 종결: RPi5 latency/rendering 확인 후 .NET (C#) + Avalonia UI 개발 결정**
  - **상태**: 해결
  - **리스크 근거**: [QAS-2 latency 결과](../../TestResult/result_latency.md)에서 Simulation 및 WAV 재생 조건이 모두 통과했다. worst-case E2E latency는 비트 주기 예산 안에 있었고, dropped audio samples와 missed beat detections는 모두 0이었다. [렌더링 백엔드 결과](../../TestResult/result_renderer.md)에서도 Avalonia-on-RPi5 성능 저하 보고는 재현되지 않았고, GLX/EGL GPU 렌더링은 약 60 FPS에 도달했으며 SW 렌더링이 더 느렸다.
  - **발생 확률 / 영향**: Low / Low
  - **등급 근거**
    - P-Low: 현재 RPi5 앱 워크로드가 latency 예산을 충족했고 Avalonia GPU 경로에서도 보고된 성능 저하가 나타나지 않음.
    - I-Low: Avalonia 선택에 대해 남은 아키텍처 리스크가 확인되지 않았고, 기본 GPU 우선 렌더링 경로를 사용할 수 있음.
  - **결과**: latency([EXP-02](4-Planned-Experiments.md#exp-02-rpi5-실시간-샘플레이트-상한) · [result_latency.md](../../TestResult/result_latency.md))가 예산 내 Pass(drop·miss 0)이고 렌더링([EXP-01](4-Planned-Experiments.md#exp-01-rpi5-avalonia-렌더링-백엔드) · [result_renderer.md](../../TestResult/result_renderer.md))에서 보고된 GPU 저하가 미재현(GLX/EGL ~60 FPS) → **리스크 없음으로 종결**, .NET (C#) + Avalonia UI(GPU 우선)로 확정. 배포·렌더 워크로드가 크게 바뀔 때만 재측정.

## B. 신호처리 / 측정 신뢰성

- **🔴 R-06 — A·C 이벤트 위치를 0.1 ms 정밀도로 못 찾으면 일오차·비트 에러·진폭 전부가 오염된다**
  - **상태**: 진행중
  - **리스크 근거**: [FR-08-04…06](2-Architectural-Drivers.md#g08--escapement-analyzer-and-marker-line-display), [FR-06-01…04](2-Architectural-Drivers.md#g06--beat-error-display-and-diagnostic-trace), [QAS-1](2-Architectural-Drivers.md#qas-1--accuracy--음향-이벤트-검출에서-시계-지표-계산까지의-정확도), [QAS-3](2-Architectural-Drivers.md#qas-3), [QAS-4](2-Architectural-Drivers.md#qas-4--consistency--표시-간-값-일치)
  - **발생 확률 / 영향**: High / High
  - **등급 근거**
    - P-High: 실제 잡음 신호에서 0.1 ms 정밀 A·C 이벤트 검출은 본질적으로 어려움.
    - I-High: 일오차·비트 에러·진폭 세 핵심 지표를 전부 오염.
  - **완화 방향**: 합성신호(정답 known) 벤치로 검출 알고리즘 조기 검증([EXP-06](4-Planned-Experiments.md#exp-06-측정-정확도)에서 Realistic Off 시뮬레이션으로 1차 확인 후 상용 Weishi Timegrapher 비교 예정)
  - **현 상태**: A·C 검출(서브샘플 보간 — C-peak 포물선·A-onset 선형)·비트 에러·진폭이 `Detector.cs`·`WatchMetrics.cs`에 구현됐고, 합성신호 테스트(`SyntheticDetectorTests`, `AdverseScenarios`)로 1차 동작을 확인(EXP-06 Realistic Off). 명시적 0.1 ms 허용오차 검증과 상용 Weishi 비교는 미완.
  - **코멘트**: 현 로직 기준으로 정상동작 확인 및 필요 시 로직 개선 필요

- **R-07 — 시끄럽거나 약한 신호에서 "신호 약함" 대신 오해를 부르는 값을 표시할 수 있다**
  - **상태**: 진행중
  - **리스크 근거**: [QAS-3](2-Architectural-Drivers.md#qas-3)
  - **발생 확률 / 영향**: Medium / High
  - **등급 근거**
    - P-Medium: 약/잡음 신호 처리는 불확실하나 노이즈 레벨별 테스트로 확인 가능.
    - I-High: "신호 약함" 대신 틀린 값을 보이면 사용자를 적극 오도.
  - **완화 방향**: 필터링·신호품질 판정, bad-data는 "signal weak" 표시로 격리
  - **현 상태**: 명시적 "signal weak" 상태 표시·사용자 안내 UI 구현이 진행 중이다.
  - **코멘트**: 노이즈 레벨 별 테스트 및 필요 시 로직 개선

## C. 아키텍처 / 확장성

- **R-08 — 필터/마커 확장 구조(예: F4 추가)를 미리 설계하지 않으면 후반 비용이 급증한다**
  - **상태**: 해결
  - **리스크 근거**: [FR-12-01](2-Architectural-Drivers.md#g12--scope-function-with-multiple-filter-views), [QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--새-측정필터그래프-추가)
  - **발생 확률 / 영향**: Medium / Medium
  - **등급 근거**
    - P-Medium: 선설계가 없으면 확장 구조를 놓칠 수 있음.
    - I-Medium: 후반 비용은 늘지만 리팩터링으로 한정되고 기능 실패는 없음.
  - **결과**: 측정 필터는 F0~F3 4종으로 스코프가 고정 구현돼 있고(`ScopeFilters.cs`·`MultiFilterScopeLanes.cs`, FR-12 충족), F4 등 신규 필터를 추가하는 시나리오 자체가 없으므로 확장 구조 미선설계로 인한 후반 비용이 발생하지 않음 → 종결. 향후 확장이 실제로 필요해지면 Filter 인터페이스(strategy)·plug-in 등록 선설계를 재검토.

## D. 하드웨어 / 플랫폼

- **R-09 — AGC를 끄지 않거나 마이크 결합이 나쁘면 신호가 왜곡돼 모든 측정이 망가진다**
  - **상태**: 해결
  - **리스크 근거**: pdf (p.29 Raspberry Pi OS — Auto Gain Control), [QAS-3](2-Architectural-Drivers.md#qas-3), [C-4](2-Architectural-Drivers.md#설계-제약사항)
  - **발생 확률 / 영향**: Medium / High
  - **등급 근거**
    - P-Medium: AGC는 기본값 켜짐+잊기 쉬운 수동 단계지만 체크리스트로 충분히 예방 가능.
    - I-High: 신호 왜곡 시 모든 측정이 무너짐.
  - **결과**: 앱이 AGC를 직접 끄지 못하므로(NAudio 한계, `SystemAudioControl.cs`) 사용자 매뉴얼(`manual/controls.html` — "마이크 설정(AGC·결합)")에 AGC off·커플링 검증을 환경 체크리스트로 명시해 종결. Live 입력에만 해당하며(Playback/Simulation 무관, Linux는 기본 AGC 미적용), 측정 전 점검 단계로 예방 가능.

- **R-10 — Windows에서 개발하고 RPi에서 데모 — 오디오 백엔드(WASAPI/ALSA) 등 플랫폼 차이가 늦게 드러난다**
  - **상태**: 해결
  - **리스크 근거**: pdf (p.29 System Software), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지), [C-3](2-Architectural-Drivers.md#설계-제약사항)
  - **발생 확률 / 영향**: Medium / Medium
  - **등급 근거**
    - P-Medium: WASAPI/ALSA 차이는 가능성 있으나 RPi 병행 구동으로 조기 발견.
    - I-Medium: 재작업을 유발할 뿐 영구 실패는 아님.
  - **결과**: 오디오 I/O를 포트-어댑터로 격리하고 RPi를 처음부터 병행 검증(EXP-02/05 실제 RPi5 수행)해 "늦게 드러남"을 차단. 차이는 어댑터 한정 재작업으로 봉쇄돼 리스크 낮음으로 종결.

- **R-11 — 샘플레이트 3종(48/96/192k) 지원이 타이밍 복잡도를 키운다**
  - **상태**: 해결
  - **리스크 근거**: pdf (p.25 Real Time Performance), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지)
  - **발생 확률 / 영향**: Medium / Medium
  - **등급 근거**
    - P-Medium: 샘플레이트 3종은 타이밍 복잡도를 키워 미세 오류 가능성 있음.
    - I-Medium: 어댑터 정규화로 한정되는 문제.
  - **결과**: 지원 범위를 48k 기본 / 192k 최고로 확정([EXP-02](4-Planned-Experiments.md#exp-02-rpi5-실시간-샘플레이트-상한))하고 어댑터 정규화로 복잡도를 입력단에 국한. 192k가 예산 내 통과해 "복잡도가 실시간성을 깬다"는 실패 경로가 닫힘.

## E. 사용성 / UI (1280×800)

- **R-12 — 작은 화면에 요약바 + 그래프 + 스코프 스트립을 가독성(글자 ≥ 2.9 mm·터치 ≥ 9 mm) 있게 다 못 담는다**
  - **상태**: 해결
  - **리스크 근거**: pdf (p.27 8 Inch Touchscreen for Raspberry Pi), [QAS-6](2-Architectural-Drivers.md#qas-6--usability--터치스크린에서-읽기조작), [C-2](2-Architectural-Drivers.md#설계-제약사항)
  - **발생 확률 / 영향**: Medium / Medium
  - **등급 근거**
    - P-Medium: 작은 화면에 모든 패널을 가독성 있게 담기는 빠듯함.
    - I-Medium: 가독성에만 영향, 레이아웃으로 완화 가능하고 데이터 손실 없음.
  - **결과**: 핵심값 우선 레이아웃 + 탭 분할(≤2탭)로 정보를 분산하고 가독성 기준(글자 ≥2.9 mm·터치 ≥9 mm)을 크기 테스트로 확인. 데이터 손실 없는 표시 문제라 레이아웃 결정으로 종결.

- **R-13 — 터치 정확도·인식률이 떨어질 수 있다**
  - **상태**: 수용
  - **리스크 근거**: [QAS-6](2-Architectural-Drivers.md#qas-6--usability--터치스크린에서-읽기조작)
  - **발생 확률 / 영향**: Low / Low
  - **등급 근거**
    - P-Low: 터치는 대부분 OS가 처리하고 일반적으로 안정적.
    - I-Low: 최악이라도 경미한 조작 불편으로 우회 쉬움.
  - **결과**: 터치는 대부분 OS가 처리해 일반적으로 안정적이고 최악이라도 경미한 조작 불편에 그쳐 별도 대응이 불필요. App 레벨에서 제어 가능하면 실험으로 최적값을 확인하되, OS 레벨로 정의되면 현 상태로 진행한다.

## F. 프로젝트 / 프로세스

- **R-14 — 3주 안에 12개 기능 + AI 전부는 불가능 — 우선순위에 실패하면 핵심이 빠진다**
  - **상태**: 해결
  - **리스크 근거**: pdf (p.5 Objective — "feasible, well-architected subset"), QAS-ALL
  - **발생 확률 / 영향**: Medium / High
  - **등급 근거**
    - P-Medium: 범위 초과는 실재하나 우선순위 동결로 관리 가능.
    - I-High: 핵심 기능이 빠지면 제품 본질이 무너짐.
  - **결과**: 범위를 "feasible subset"으로 동결하고 AI를 optional로 분리(R-17/EXP-04)해 핵심 경로를 일정 압박과 분리. 버릴 건 버리는 플래닝으로 관리되는 프로세스 리스크로 통제.

- **R-15 — 제공 베이스라인 코드(TimeGrapher_v10.4) 이해에 시간이 걸려 착수가 늦어진다**
  - **상태**: 해결
  - **리스크 근거**: pdf (p.29 GUI Code), [QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--새-측정필터그래프-추가)
  - **발생 확률 / 영향**: Low / Medium
  - **등급 근거**
    - P-Low: AI 보조 코드 분석으로 막힐 확률 낮음.
    - I-Medium: 착수 지연은 일정에 영향이나 프로젝트를 깨지는 않음.
  - **결과**: 코드 reading·모듈 맵을 1주차 태스크로 일정화하고 AI 보조로 가속. .NET 재구현 산출물이 나와 "이해 지연으로 착수 못 함" 시나리오가 소멸해 종결.

- **R-16 — Qt/C++·DSP·RPi 학습곡선으로 구현 품질이 흔들린다**
  - **상태**: 해결
  - **리스크 근거**: pdf (p.29 Qt and Qt Creator), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지), [QAS-3](2-Architectural-Drivers.md#qas-3)
  - **발생 확률 / 영향**: Low / Medium
  - **등급 근거**
    - P-Low: AI 활용·페어링으로 학습곡선 완화.
    - I-Medium: 품질 흔들림은 구현 전반에 영향이나 치명적이지 않음.
  - **결과**: 초기 technical experiment(EXP-01~03/05)로 위험 영역(렌더링·실시간·동시성)을 조기 학습하고 AI·페어링으로 학습곡선을 완화. 핵심 난제가 실험 단계에서 검증·구현돼 품질 위험이 소거됨.

- **🔴 R-17 — AI/TinyML 기능을 시도하면 on-device 불확실성이 커진다**
  - **상태**: 진행중
  - **리스크 근거**: pdf (p.12 AI Feature), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지), [QAS-3](2-Architectural-Drivers.md#qas-3)
  - **발생 확률 / 영향**: Medium / Medium
  - **등급 근거**
    - P-Medium: 시도 시 on-device AI 불확실성이 실재.
    - I-Medium: 선택 스코프이며 룰베이스 폴백이 있음.
  - **완화 방향**: optional 스코프로 분리, 미달 시 룰베이스 폴백
  - **현 상태**: TinyML 소켓(`IBeatEventGate`)과 룰베이스 폴백(`PllMatchGate`)은 구현돼 주입 가능하나, ONNX/TFLite 모델·추론은 미구현. [EXP-04](4-Planned-Experiments.md#exp-04-온디바이스-tinyml-추론-타당성) 진행중(채택 여부 미결).
  - **코멘트**: 우선 Windows 진행 후 RPi5에서 동작성 검토 후 반영 결정

- **R-18 — GenAI 생성 코드를 검증 없이 수용하면 그럴듯하지만 틀린 코드가 들어온다 (특히 DSP/동시성/실시간 영역)**
  - **상태**: 수용
  - **리스크 근거**: pdf (p.30 Project Deliverables), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지), [QAS-3](2-Architectural-Drivers.md#qas-3), [QAS-4](2-Architectural-Drivers.md#qas-4--consistency--표시-간-값-일치)
  - **발생 확률 / 영향**: Medium / Medium
  - **등급 근거**
    - P-Medium: DSP/동시성에서 그럴듯하지만 틀린 GenAI 코드는 흔함.
    - I-Medium: 의무 검증으로 반영 전 차단.
  - **결과**: [ADR-004](ADR/ADR-004.md)에서 App / test / verify 모듈 분리를 확정하고, TDD와 자동화 테스트를 모든 커밋 전 필수 게이트로 강제해 GenAI 생성 코드에 대한 구조적 안전망을 마련했다. 그럴듯하지만 틀린 코드는 TDD로 작성된 단위 테스트와 verify 모듈(합성신호 벤치)이 1차로 차단하고, 그 위에 테스트 통과 여부를 객관적 기준으로 삼는 팀 코드 리뷰가 2차로 확인한다. 이 2중 게이트가 갖춰져 있으므로 추가 대응이 불필요하다.

- **R-19 — 테스트용 RPi5가 한 대뿐이라 실사용 검증 일정이 안 나온다**
  - **상태**: 수용
  - **리스크 근거**: pdf (p.26 System Hardware — Raspberry Pi), [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지)
  - **발생 확률 / 영향**: High / High
  - **등급 근거**
    - P-High: RPi5 한 대를 팀이 공유해 일정 충돌이 거의 확실.
    - I-High: 실기기 검증 부재는 RPi 의존 주장 전체의 신뢰를 떨어뜨림.
  - **결과**: 검증 대부분을 Simulation/Playback 기반(하드웨어 불요)으로 설계해 RPi5 의존을 최소화하고 실기기는 성능 측정 등 필수 항목에만 배정하므로, 장비 1대 제약에 대한 추가 대응이 불필요. 추가로 RPi5 1대를 확보해 장비를 2대로 운용할 수 있어 일정 충돌 여지가 더 줄었다.

## G. 기타 또는 카테고리화 되지 않음

- **R-20 — 의사소통** — 영어 대화 시 이해관계자 간 정확한 의사전달이 안 될 수 있다
  - **발생 확률 / 영향**: Low / Low
- **R-21 — 테스트 환경 부족** — 장비 1대, 테스트룸·unit test 없음 → 로직 변경 시 regression을 놓칠 수 있다
  - **발생 확률 / 영향**: Low / Low
- **R-22 — 장시간 검증 곤란** — 24시간 연속 같은 항목은 실제 검증·평가가 어렵다
  - **발생 확률 / 영향**: Low / Low
- **R-23 — 저장량 증가** — 장시간 녹음 시 파일 크기가 커진다
  - **발생 확률 / 영향**: Low / Low
- **R-24 — RPi5 디버깅 곤란** — 상태 파악·디버깅이 어렵다 → 로그 메시지 남기기로 실험 가능
  - **발생 확률 / 영향**: Low / Low
- **R-25 — 데이터 구조 불확실** — 음성 버퍼·측정 데이터 저장 구조가 미정이다
  - **발생 확률 / 영향**: Low / Low
- **R-26 — 저장 속도 병목** — SD 카드 쓰기가 녹음 생성 속도보다 느릴 수 있다 → SD 스펙 확인 + 실녹음 테스트
  - **발생 확률 / 영향**: Low / Low
