# PROJ 11 · TimeGrapher — SW Architecture 개선 스토리

- **맥락**: CMU Software Architecture 교육 과정 과제. 핵심 서사는 *버그 수정*이 아니라 **아키텍처 결함(smell) 식별 → 아키텍처 기법(전술·스타일·패턴)으로 개선 → 품질속성이 측정 가능하게 향상**.
- **근거 데이터**: SciTools Understand 정적 분석 리포트 (LG Team#5 · TimeGrapher, Qt/C++). 생성 2026-05-31.
- **작성**: 2026-06-01
- **분석 방법**: 3개 독립 렌즈 병렬 분석 → 교차검증 합산 → 소스 라인 추적 검증 → 아키텍처 관점 재구성.

> 각 스토리: **결함(Architectural Smell)** → **영향 품질속성** → **개선(아키텍처 기법)** → **Before→After 측정 지표**(Understand로 재측정해 입증).

---

## ① [최우선] MainWindow God Class 해체 — 관심사 분리

- **결함**: UI 클래스가 GUI + 오디오 스레드 제어 + 샘플 처리 + WAV 기록 + 그래프 갱신 + 측정값 계산을 모두 보유. SRP·정보은닉(Parnas) 위반.
- **근거**: `classoom_M.html` — LCOM **96** / CBO **48** / RFC **75** / NIM 74 / NIV **44** / WMC **75**, DIT 1. `file_metrics_M.html` — 1541줄·1295코드·64유닛(전체 코드 ≈21.5%).
- **품질속성**: Modifiability, Testability, Conceptual Integrity.
- **개선**: 책임 분해 — `UI(View)` ↔ `Application/Controller` ↔ `Domain(측정·이벤트)` ↔ `Audio I/O` ↔ `Rendering`. **Mediator / MVP 패턴 + 수정성 전술**(encapsulate, use-an-intermediary, restrict dependencies).
- **Before→After 지표**: LCOM 96 → <30, CBO 48 → 대폭↓, WMC 75 → 분산, 단일 1541줄 파일 → N개 응집 모듈.

## ② [최우선] 레이어링 정립 — UI / 도메인(DSP) 경계 분리

- **결함**: UI가 C 스타일 DSP 컨텍스트(`tg_context`/`tg_config`)를 **직접 소유**. C 절차형 DSP와 C++/Qt OO가 한 클래스에 혼재 → 레이어 경계 부재. DIT=1(상속/추상화 거의 없음).
- **근거**: `2491.html` 99–161 (mCtx/mCfg 직접 생성·소유), `progunitcomp_metrics_T.html`, `object_xref_M.html`.
- **품질속성**: Modifiability, Conceptual Integrity, Reusability.
- **개선**: **Layered Architecture** 도입 + DSP를 **Facade**로 감싸 도메인 인터페이스로만 의존(C 구조체 직접 노출 제거). 의존성 방향을 상위→하위 단방향으로 고정.
- **Before→After 지표**: UI→DSP 직접 참조 edge 제거(`object_xref_M.html` 기준), 레이어 간 의존 위반 0건.

## ③ 플랫폼 추상화 — `#ifdef` 분기를 Ports & Adapters로

- **결함**: Windows(WASAPI 1473줄/28유닛) vs Linux(ALSA 931줄)를 **공통 인터페이스 없이 전처리 분기**(`#if Q_OS_WIN / Q_OS_LINUX`)로 처리. 변동점(variation point)이 코드 전역에 산재.
- **근거**: `file_metrics_W.html` / `file_metrics_L.html`, `2491.html:131` `ConfigureSoundCard`가 `WindowsSetSoundParameters` / `LinuxSetSoundParameters` 직접 호출.
  - *부수 증거*: 리포트가 Windows에서 export돼 `LinuxAudio.cpp`(931줄)가 Code 0 / Units 0으로 **통째 미분석**된 것 자체가 `#ifdef` 변동점·추상화 부재의 징후.
- **품질속성**: **Portability**, Modifiability, Testability(목 주입 가능).
- **개선**: `IAudioBackend` 포트 정의 → `WindowsAudioBackend` / `LinuxAudioBackend` 어댑터. **Strategy / Bridge + defer-binding 전술**. 컴파일타임 `#ifdef` → 인터페이스 다형성.
- **Before→After 지표**: 플랫폼 `#ifdef` 분기 개수 → 단일 팩토리로 수렴, 신규 플랫폼 추가 시 변경 모듈 1개.

## ④ DSP 코어 모듈 분해 — Pipe-and-Filter 스타일

- **결함**: 신호처리 컴포넌트가 거대 단일 절차(`tg_process` CC 37 / Essential 14 / 경로 1,179,367, `tg_detector_process` CC 30 / 경로 130,753)로 내부 구조 없음 → 도메인 모듈 분해 부족.
- **근거**: `progunitcomp_metrics_T.html`. (`find_c_onset` CC 19·중첩 5, `ProcessSamples` CC 21·중첩 6도 동일 징후)
- **품질속성**: Modifiability, Testability, Reusability, (Performance 분석 용이성).
- **개선**: 신호 흐름을 **Pipe-and-Filter** 단계(필터 → 검출 → 이벤트 계산)로 분해. 각 필터는 독립 모듈·독립 테스트. *오디오 앱 도메인에 가장 자연스러운 아키텍처 스타일.*
- **Before→After 지표**: 함수 CC 37 → 단계별 <10, Essential 14 → 환원, 단위테스트 커버리지 부여.

## ⑤ 동시성 아키텍처 명시화 — Producer/Consumer + Thread-safe 컴포넌트

- **결함**: 3개 워커(Audio/Playback/Sim)와 공유 버퍼(`TMasterAudioDataRaw`)를 **MainWindow가 중앙에서 생성·제어**, 동기화는 전역 수동 `Mutex.lock/unlock`, 종료는 `deleteLater` 시그널에만 의존 → 동시성 모델이 암묵적·산재.
- **근거**: `SharedAudio.h`(50.html) `QMutex Mutex`, `2491.html` 626·665(워커 생성/종료).
- **품질속성**: **Reliability / Availability(실시간 오디오)**, Modifiability.
- **개선**: Producer-Consumer 스타일 명시화 + 공유 버퍼를 **Monitor Object(스레드 안전 컴포넌트)**로 캡슐화 + 워커 수명관리를 별도 `AudioCoordinator`로 이관. 동기화 전술: 수동 lock → **`QMutexLocker`(RAII)**.
- **Before→After 지표**: 공유 상태 접근 지점 캡슐화(MainWindow의 lock/unlock 호출 제거), 워커 제어 책임이 MainWindow에서 분리.

---

## 구현 범위 (아키텍처 스토리에서 제외 — 별도 처리)

> 발견은 했으나 *아키텍처 개선 서사*가 아닌 코딩/도구 이슈. 보고서에선 "병행 정리" 정도로만 언급 권장.

| 항목 | 분류 | 비고 |
|------|------|------|
| 메모리 누수(Rolling* delete 누락), `mLastA` 미가드, WAV chunk read 미확인, `mAvalableRates` OOB | 구현 결함 | ②/⑤ 개선의 **부수 효과**로 자연 해소된다고 엮으면 스토리 강화 가능 |
| Complex Files 차트 공백, Program Units 305 vs 함수 172 괴리 | Understand 산출 아티팩트 | 결함 아님 |
| 오타(`CreateDectectors`/`mAvalableRates`), 매직넘버(48000/52/10), dead code | 코드 품질 | 정리 대상 |

---

## 서사 요약

> "정적 분석(Understand)으로 **정량 메트릭**(LCOM·CBO·RFC·CC·결합 그래프)을 측정해 5개 아키텍처 결함을 식별하고, 각각을 **레이어링·Ports&Adapters·Pipe-and-Filter·Mediator·Monitor Object** 등 아키텍처 기법으로 처방한 뒤, **동일 메트릭 재측정**으로 수정성·이식성·신뢰성 향상을 입증한다."
