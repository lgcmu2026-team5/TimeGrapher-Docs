# PROJ 11 · TimeGrapher — Understand 리포트 특이사항 분석

- **대상**: SciTools Understand 정적 분석 리포트 (LG Team#5 · TimeGrapher, Qt/C++)
- **리포트 생성**: 2026-05-31 17:44 (정적 HTML export)
- **분석 작성**: 2026-06-01
- **분석 방법**: 3개 독립 렌즈(① 메트릭/복잡도 ② 아키텍처/의존성 ③ 코드품질/리스크) 병렬 분석 → 교차검증·중복제거 합산. 이후 소스 라인 추적으로 버그 후보 3종 추가 검증.

## 프로젝트 메트릭

| 항목 | 값 |
|------|----:|
| Files | 34 |
| Program Units | 305 |
| Lines (전체) | 10,638 |
| Code Lines | 6,028 |
| Comment Lines | 2,368 |
| Blank Lines | 1,186 |
| Inactive Lines | 977 |
| Statements | 2,839 |

> 🆕 = 정적 메트릭 표에는 드러나지 않고 소스 라인 추적으로 확인한 항목.

---

## 🔴 HIGH

| # | 특이사항 | 근거 |
|---|---------|------|
| H1 | **리포트 이상: `LinuxAudio.cpp` 통째 미분석** (Code 0 / Units 0, 931줄 전체 inactive). Windows 환경 export로 `#if Q_OS_LINUX` 전부 비활성 → 리눅스 오디오 절반의 메트릭·결함이 리포트에 없음. inactive 977의 거의 전부(931)가 이것 | `file_metrics_L.html` |
| H2 | **메모리 누수 확정**: `CreateEvents()`가 `new RollingAverage`×2 + `new RollingLeastSquares`×2 할당, 소멸자는 `delete ui`만, `EventsReset()`은 `Reset()`만 호출. delete 없음. `free()`/`new` 혼용도 발견 | `2491.html` 144·147·160·161·597 |
| H3 | **DSP 코어 극단 복잡도**: `tg_process` CC 37 / Strict 45 / **Essential 14** / 경로 1,179,367 · `tg_detector_process` CC 30 / 경로 130,753 (단 Essential 3 → 구조는 상대적으로 덜 꼬임) | `progunitcomp_metrics_T.html` |
| H4 | **MainWindow god class**: LCOM 96 / CBO 48 / RFC 75 / NIV 44 / WMC 75, 1541줄·1295코드·64유닛(전체 코드 ≈21.5%). GUI + 오디오 + 3개 워커 + DSP 컨텍스트 + 렌더링 집중 | `classoom_M.html`, `file_metrics_M.html` |
| H5 | **🆕 `mLastA` 미가드 사용**: A 이벤트 경로(960행)는 `if(mHaveLastA)`로 보호되나, **C PEAK 경로(992행)는 가드 없이 `delta = val - mLastA`**. `mLastA`가 초기화 경고에 잡혀 있어, 첫 C 이벤트가 첫 A 이벤트보다 먼저 도착하면 미초기화 값으로 계산 → 잘못된 측정 | `2491.html` 960·992 |

## 🟠 MEDIUM

| # | 특이사항 | 근거 |
|---|---------|------|
| M1 | **리포트 이상: Complex Files 차트(figure8) 데이터 완전 공백** (Complex Entities는 정상) — 파일 단위 복잡도 집계 누락 | `projectoverview.html:688` |
| M2 | **거대 파일**: MainWindow.cpp 1541 · WindowsAudio.cpp 1473 · SoundImageRenderer.cpp 1042 · Detector.cpp 970. SoundImageRenderer는 2번째 대형 엔티티(1266 CountLine) | `file_metrics_*.html` |
| M3 | **Win/Linux 오디오 비대칭 + 공통 추상화 부재**: WindowsAudio(WASAPI, 1473줄/28유닛) ≫ LinuxAudio(ALSA, 931줄). 공통 인터페이스 없이 `#if` 전처리 분기로 직접 호출 | `2491.html:131`, `881.html` |
| M4 | **`ProcessSamples` 복잡도**: CC 21, **Nesting 6**, 145줄, 경로 3,094 | `progunitcomp_metrics_M.html` |
| M5 | **`find_c_onset`**: CC 19, 중첩 깊이 5 (타이밍 검출 핵심 로직) | `progunitcomp_metrics_F.html` |
| M6 | **`StartPlayback`**: CC 16 / Strict 21, 141줄 | `progunitcomp_metrics_T.html` |
| M7 | **🆕 WAV chunk 스캔 견고성**: `file->read(chunkId,4)` 반환값·`in >> chunkSize` 스트림 상태 미확인 → garbage `chunkSize`로 `file->seek` 폭주. 손상/비정상 WAV 취약 | `2459.html` 99–109 |
| M8 | **🆕 `mAvalableRates[currentIndex()]` OOB 가능**: 1534행은 `index<0`/`index+1>count` 가드가 있으나, **1381행은 무방비** — 디바이스 null이면 콤보가 비고 `currentIndex()` = -1 → OOB 읽기 | `2491.html` 1381 vs 1534 |
| M9 | **수동 `Mutex.lock/unlock`** (QMutexLocker RAII 미사용) → lock~unlock 사이 예외/조기 return 시 데드락·미해제 위험. *QMutex 자체는 존재* | `SharedAudio.h`(50.html) |
| M10 | **`tg_process` 실패 시 silent return** — 로그만 남기고 측정을 조용히 누락 | `2491.html:935` |
| M11 | **스레드 종료가 `deleteLater` 시그널에만 의존** — 소멸 전 명시적 wait/join 부재 | `2491.html` 626·665 |

## 🟡 LOW / INFO

| # | 특이사항 | 근거 |
|---|---------|------|
| L1 | **PlaybackWorker dead code**: 미사용 멤버 `mFrameCount`·`mSampleCount`, 미사용 지역변수 `chunkSize`·`fdelta` | `unusedobj_P.html` |
| L2 | **식별자 오타 + 명명 혼재**: `CreateDectectors`(선언+정의 2곳), `mAvalableRates`(Available 오타), camelCase ↔ T접두(`TPlaybackWorker`, `TMasterAudioDataRaw`) 혼재 | `2491.html` |
| L3 | **도메인 매직넘버 산재**: 48000, 52(mLiftAngle), 10(RollingAverage) 등 인라인 리터럴 | `2491.html` 99·100·144 |
| L4 | **Uninitialized 경고 ~238건** (WindowsAudio 91 · MainWindow 54 등) — 다수는 선언 직후 대입되는 지역변수, AudioWorker.h 멤버(FrameCount/SampleCount/Timer/mRawAudio)는 주의 필요 | `uninitializeditems_*.html` |
| L5 | **Unused 객체 ~377건** (WindowsAudio 184 집중) — 다수 MOC 생성물/`[unnamed]`, 일부 순수 dead code | `unusedobj_*.html` |
| I1 | Program Units 305 vs 함수 172 괴리 → 클래스·구조체·멤버·변수·typedef·매크로로 설명되는 **정상** | `title_overview.html` |
| I2 | inactive 977줄(9.2%) → 사실상 전부 H1(LinuxAudio 미분석)에서 비롯 | `projmetrics.html` |

---

## ❌ 교차검증으로 걸러낸 주장 (오탐/과장)

| # | 분석가 주장 | 실제 |
|---|------------|------|
| X1 | "Private=0 → 캡슐화 결핍" | 클래스 **선언 스코프**의 접근성 지표일 뿐, 멤버 접근지정자와 무관. 정상 → info로 강등 |
| X2 | "tg_process 주석비율 0.00" | tg_process(326줄)/tg_detector_process(344줄) 혼동. 실제 0.49 / 0.81 (평균 0.39보다 높음) |
| X3 | "DSP 핵심 함수 주석 부족" | 실측 양호(0.49·0.81). 성립 안 함 |
| X4 | "tg_process 실패 시 계속 실행" | 실제 935행 `return`으로 중단 (silent 누락 문제는 M10으로 유효) |
| X5 | "공유버퍼 보호장치 없음" | `QMutex Mutex` 실재, lock/unlock 사용 중. 진짜 약점은 RAII 미사용(M9) |
| X6 | "Essential: tg_process 4" | 실제 14 (오히려 구조적 환원이 더 어려운 상태) |
| X7 | "Win/Linux 코드 중복(high)" | LinuxAudio가 미분석값(0)이라 중복 근거 무효. 본질은 H1 |

---

## 권고 (우선순위)

1. **리포트 재생성** — Linux 매크로가 활성인 환경(또는 양 플랫폼 모두 분석 대상)에서 다시 export해 `LinuxAudio.cpp`(931줄)를 포함. 현재 리포트는 리눅스 경로 결론을 일반화할 수 없음. (H1)
2. **메모리 누수 수정** — Rolling* 4개를 `std::unique_ptr`/`QScopedPointer`로 RAII화, `free()`/`new`-`delete` 혼용 통일. (H2)
3. **버그 후보 3종 우선 확인** — `mLastA` 가드 추가(H5), WAV chunk read/스트림 상태 검사(M7), `mAvalableRates[currentIndex()]` 경계 가드(M8).
4. **DSP 분해** — `tg_process`/`tg_detector_process`를 검출·필터·이벤트계산 서브함수로 분해 + 단위테스트. Essential 14인 `tg_process` 최우선. (H3)
5. **MainWindow 분리** — 오디오 스레드 제어/DSP 파이프라인/이벤트·메트릭/렌더링 연동을 협력 클래스로 추출해 LCOM·CBO·RFC 완화. (H4)
6. **오디오 백엔드 추상화** — `AudioBackend` 인터페이스로 Windows/Linux 구현 분리, `ConfigureSoundCard`의 전처리 분기 캡슐화. (M3)
7. **동기화 안전성** — 모든 수동 `Mutex.lock/unlock`을 `QMutexLocker`로 전환. (M9)
8. **정리** — `CreateDectectors`/`mAvalableRates` 오타 수정, PlaybackWorker 미사용 멤버·변수 제거, 매직넘버(48000/52/10) 명명 상수화. (L1~L3)
