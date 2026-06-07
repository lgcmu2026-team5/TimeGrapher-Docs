# Milestone1 — Risk Assessment

> English version above, Korean version below. (위쪽은 영어 버전, 아래쪽은 한국어 버전입니다.)

> Risks threatening the project, grouped by area and rated by probability and impact (High/Medium/Low).

## Terminology

| Term | Meaning |
|------|---------|
| Sample rate (48k/96k/192k) | Audio samples per second — 96k means 96,000 samples per second |
| block drop / missed beat | Processing falls behind the input, discarding audio blocks or missing beats |
| FPS | Frames Per Second — screen updates per second; low FPS means a stuttering UI |
| p99 | The 99th-percentile value — everything except the slowest 1 % falls within this value |
| RSS | The memory a process actually occupies — steady growth suggests a leak |
| Rate | Seconds the watch gains or loses per day (s/d) |
| Beat error | Asymmetry between the tick and tock intervals (ms) |
| Amplitude | Swing angle of the balance wheel (°) — a key indicator of watch health |
| SNR | Signal-to-Noise Ratio (dB) — higher means a cleaner signal |
| Lift angle | A per-caliber constant used in the amplitude calculation — a wrong value yields a wrong amplitude |
| Ground truth | The known correct value used as the verification reference |
| Sim / Playback | Sim = synthetic watch-signal generator mode (ground truth known in advance); Playback = replay of a recorded file |
| AGC | Auto Gain Control — automatic microphone volume adjustment; must be off before measuring or it distorts the signal |
| WASAPI / ALSA | The audio I/O systems of Windows / Linux — platform differences surface when porting |
| spike | A small experiment to quickly probe a technical limit before real implementation |
| TinyML | Lightweight AI models that run directly on small devices (e.g., RPi) |
| regression | A code change breaking something that used to work |
| QAS / FR | QAS = quality attribute scenario (QA Final doc); FR = functional requirement (Architectural Drivers doc) |

## Risk Matrix

> Range ratings are placed by the higher side: Medium~High → High, Low~Medium → Medium.

| Probability / Impact | High | Medium | Low |
|----------------------|------|--------|-----|
| High | R-A1, R-A2, R-B1, R-B2, R-F1, R-F6 | - | - |
| Medium | R-A3, R-A5, R-D1 | R-A4, R-C1, R-D2, R-D3, R-E1, R-F3, R-F4, R-F5 | - |
| Low | - | R-F2 | R-E2 |

## A. Real-Time Performance (RPi)

- **R-A1 — The RPi5 fails to keep up with high sample rates (96k/192k) in real time and loses sound data (block drop / missed beat)**
  - **Quality attribute**: Performance (Throughput)
  - **Evidence**: pdf (p.25 Real Time Performance), QAS-1
  - **Probability / Impact**: High / High
  - **Mitigation**: Week-1 spike to measure the RPi's processing limit, then fix the sample-rate target (192k demoted to stretch)
  - **Tradeoff point**: the sample rate trades measurement precision (more samples per 0.1 ms) against Performance (this risk)
  - **Comment**: Use the week-1 spike result to set the final sample-rate target

- **R-A2 — Rendering four filters (F0→F3) plus multiple graphs at once makes the screen stutter (<20 FPS · UI freeze)**
  - **Quality attribute**: Performance
  - **Evidence**: FR-12-01, FR-12-04, QAS-1
  - **Probability / Impact**: Medium~High / High
  - **Mitigation**: Reuse a shared input buffer, stop rendering inactive views, measure an FPS budget
  - **Tradeoff point**: showing 4 views at once trades Usability (QAS-5) against Performance
  - **Comment**: Decide 4 simultaneous views vs one-at-a-time after the performance check

- **R-A3 — The sound-to-screen 0.5 s (p99 ≤ 500 ms) target is missed**
  - **Quality attribute**: Performance (Latency)
  - **Evidence**: QAS-1
  - **Probability / Impact**: Medium / High
  - **Mitigation**: Instrument capture/processing/display latency per stage; monitor backlog
  - **Comment**: For the worst case, optimize resources/processes or migrate to reduced features

- **R-A4 — Long continuous runs (24h+) leak memory and degrade or crash**
  - **Quality attribute**: Dependability (Reliability) (+Performance)
  - **Evidence**: FR-07-10
  - **Probability / Impact**: Medium / Medium
  - **Mitigation**: Monitor the long-term RSS trend; design buffer caps and aggregation
  - **Comment**: First verify memory leaks in the current code (experiment)

- **R-A5 — With the Avalonia framework, a bug may make GPU-accelerated rendering on the RPi5 slower than SW rendering, causing real-time graph (Rate/Scope) updates to stutter**
  - **Quality attribute**: Performance (Latency)
  - **Evidence**: Multiple reports of GPU-acceleration slowdowns on RPi/embedded in Avalonia GitHub — #18807, #18942, #19288, #18127. pdf (p.25 Real Time Performance)
  - **Probability / Impact**: Medium / High
  - **Mitigation**: Week-1 spike to A/B-measure rendering backends (GLX/EGL/Software) on a real RPi5, then fix the backend. If the accelerated path is slow, switch to Software rendering (a one-line setting, no feature loss)
  - **Tradeoff point**: the rendering backend trades UI frame stability against CPU usage (Software rendering competes with the audio-analysis threads for CPU)
  - **Comment**: Similar reports are widespread but the causes vary (app-side bugs, resolution, driver path), so measurement on our workload is needed. Decide keep/change of the rendering-backend default from the week-1 spike (Planned Experiments, Experiment 1)

## B. Signal Processing / Measurement Trustworthiness

- **R-B1 — If tick/tock positions can't be found to 0.1 ms, rate, beat error, and amplitude are all contaminated**
  - **Quality attribute**: Dependability (Reliability)
  - **Evidence**: FR-08-04…06, FR-06-01…04
  - **Probability / Impact**: High / High
  - **Mitigation**: Early-verify the detection algorithm on a synthetic-signal bench (ground truth known)
  - **Comment**: Confirm the current logic works; improve if needed

- **R-B2 — Noisy or weak signals may produce misleading values instead of a graceful "signal weak" response**
  - **Quality attribute**: Availability (Graceful Degradation)
  - **Evidence**: QAS-2
  - **Probability / Impact**: Medium~High / High
  - **Mitigation**: Filtering and signal-quality judgment; isolate bad data behind a "signal weak" indication
  - **Comment**: Test per noise level; improve the logic if needed

## C. Architecture / Extensibility

- **R-C1 — Without up-front design of the filter/marker extension structure (e.g., adding F4), late-stage cost soars**
  - **Quality attribute**: Modifiability (Extensibility)
  - **Evidence**: FR-12-01, QAS-4
  - **Probability / Impact**: Medium / Medium
  - **Mitigation**: Pre-design a Filter interface (strategy) and a plug-in registration scheme
  - **Comment**: Better modularization should cover it

## D. Hardware / Platform

- **R-D1 — If AGC stays on or the microphone couples poorly, the signal distorts and every measurement collapses**
  - **Quality attribute**: Dependability (Reliability)
  - **Evidence**: pdf (p.29 Raspberry Pi OS — Auto Gain Control)
  - **Probability / Impact**: Medium / High
  - **Mitigation**: From day one, make AGC-off and coupling verification an environment checklist
  - **Comment**: Must be stated in the user guide

- **R-D2 — Developing on Windows, demoing on RPi — platform differences (WASAPI/ALSA audio backends) surface late**
  - **Quality attribute**: Portability (+Performance)
  - **Evidence**: pdf (p.29 System Software)
  - **Probability / Impact**: Medium / Medium
  - **Mitigation**: Isolate audio I/O behind a port-adapter; verify early and regularly on the RPi
  - **Comment**: The RPi runs in parallel throughout the project, so risk is low

- **R-D3 — Supporting three sample rates (48/96/192k) adds timing complexity**
  - **Quality attribute**: Portability (+Reliability)
  - **Evidence**: pdf (p.25 Real Time Performance)
  - **Probability / Impact**: Medium / Medium
  - **Mitigation**: State the supported sample-rate range; normalize in the adapter
  - **Comment**: State the feasible spec (microphone spec, etc.)

## E. Usability / UI (800×480)

- **R-E1 — The small screen can't legibly hold the summary bar + multiple graphs + scope strip (letters ≥ 2.9 mm · touch ≥ 9 mm)**
  - **Quality attribute**: Usability
  - **Evidence**: pdf (p.27 8 Inch Touchscreen for Raspberry Pi), QAS-5
  - **Probability / Impact**: Medium / Medium
  - **Mitigation**: Key-readings-first layout, tab-based split, ≤ 2-tap navigation
  - **Comment**: Run size-adjustment tests

- **R-E2 — Touch accuracy or recognition may be poor**
  - **Quality attribute**: Usability
  - **Probability / Impact**: Low / Low
  - **Mitigation**: Experimentally check touch sensitivity and touch-area recognition if possible
  - **Comment**: If controllable at app level, experiment for optimal values; if defined at OS level, proceed as is

## F. Project / Process

- **R-F1 — Everything (12 features + AI) can't fit in 5 weeks — failing to prioritize drops the essentials**
  - **Quality attribute**: All QAs (esp. Performance · Reliability)
  - **Evidence**: pdf (p.5 Objective — "feasible, well-architected subset")
  - **Probability / Impact**: Medium~High / High
  - **Mitigation**: Freeze FR priorities, split AI off as optional, critical path first
  - **Comment**: Plan well and drop what must be dropped

- **R-F2 — Understanding the provided baseline code (TimeGrapher_v10.4) takes time and delays the start**
  - **Quality attribute**: Modifiability (onboarding · maintenance)
  - **Evidence**: pdf (p.29 GUI Code)
  - **Probability / Impact**: Low / Medium
  - **Mitigation**: Make code-reading sessions and a module map a week-1 task
  - **Comment**: Risk lowered by using AI

- **R-F3 — The Qt/C++ · DSP · RPi learning curve shakes implementation quality**
  - **Quality attribute**: All QAs (overall implementation quality)
  - **Evidence**: pdf (p.29 Qt and Qt Creator)
  - **Probability / Impact**: Low~Medium / Medium
  - **Mitigation**: Role split and pairing; early learning via small spikes
  - **Comment**: Risk lowered by using AI

- **R-F4 — Attempting the AI/TinyML feature raises on-device uncertainty**
  - **Quality attribute**: Dependability (Reliability) — signal-quality classification
  - **Evidence**: pdf (p.12 AI Feature)
  - **Probability / Impact**: Medium (if attempted) / Medium
  - **Mitigation**: Separate as optional scope; rule-based fallback if it falls short
  - **Comment**: Windows first, then assess operability on the RPi 5 before adopting

- **R-F5 — Accepting GenAI-generated code unverified lets in plausible-but-wrong code (esp. DSP / concurrency / real-time)**
  - **Quality attribute**: Reliability · Performance · (Testability)
  - **Evidence**: pdf (p.30 Project Deliverables)
  - **Probability / Impact**: Medium / Medium
  - **Mitigation**: Mandatory adversarial verification of generated code (unit tests, synthetic-signal bench); understand the core algorithms; confirm GenAI usage policy with mentors
  - **Comment**: See mitigation (code review, whole team understands the algorithms)

- **R-F6 — Only one test Pi5 — real-use verification doesn't fit the schedule**
  - **Quality attribute**: Modifiability (Testability)
  - **Evidence**: pdf (p.26 System Hardware — Raspberry Pi)
  - **Probability / Impact**: High / High
  - **Mitigation**: Design most verification to run Sim/Playback-based (no hardware required), minimizing Pi5 dependence; schedule the real device only for must-have items such as performance measurement

## G. Other / Uncategorized

- **Communication** — meaning may be lost between stakeholders when conversing in English
- **Insufficient test environment** — one device, no test room, no unit tests → regressions may slip through logic changes
- **Long-run verification difficulty** — items like 24-hour continuous runs are hard to actually verify and assess
- **Growing storage** — long recordings make files large
- **RPi5 debugging difficulty** — hard to inspect state or debug → leaving log messages is experimentally possible
- **Uncertain data structures** — audio buffer and measurement-data storage structures are undecided
- **Storage-speed bottleneck** — SD-card writes may be slower than recording generation → check SD specs + real recording test

---

# Milestone1 — Risk Assessment (한국어)

> 프로젝트를 위협하는 리스크를 영역별로 정리하고, 발생 확률과 영향(High/Medium/Low)으로 등급화했다.

## 용어 설명

| 용어 | 설명 |
|------|------|
| 샘플레이트 (48k/96k/192k) | 초당 오디오 샘플 수 — 96k는 초당 96,000개 샘플 |
| block drop / missed beat | 처리가 입력을 못 따라가 오디오 블록을 버리거나 비트를 놓치는 것 |
| FPS | Frames Per Second — 초당 화면 갱신 횟수. 낮으면 화면이 버벅임 |
| p99 | 측정값을 작은 순으로 정렬했을 때 99% 지점의 값 — 가장 느린 1%를 제외한 전부가 이 값 이내 |
| RSS | 프로세스가 실제로 점유한 메모리 양 — 계속 늘면 메모리 누수 의심 |
| 일오차 (rate) | 시계가 하루에 빨라지거나 느려지는 초 수 (s/d) |
| 비트오차 (beat error) | 틱과 톡 사이 간격의 비대칭 정도 (ms) |
| 진폭 (amplitude) | 밸런스 휠이 흔들리는 회전 각도 (°) — 시계 건강 상태의 핵심 지표 |
| SNR | Signal-to-Noise Ratio — 신호 대 잡음 비(dB). 클수록 신호가 깨끗함 |
| 구동각 (lift angle) | 진폭 계산에 쓰는 캘리버별 상수 각도 — 잘못 입력하면 진폭이 틀리게 나옴 |
| ground truth | 검증의 기준이 되는 "정답" 값 |
| Sim / Playback | Sim = 합성 시계 신호 생성 모드(정답을 미리 알고 있음); Playback = 녹음 파일 재생 모드 |
| AGC | Auto Gain Control — 마이크 음량 자동 조절 기능. 켜져 있으면 신호가 왜곡되므로 측정 전 꺼야 함 |
| WASAPI / ALSA | Windows / Linux의 오디오 입출력 시스템 — 플랫폼마다 달라 포팅 시 차이가 드러남 |
| spike | 본 구현 전에 기술 한계를 빠르게 확인하는 작은 실험 |
| TinyML | 소형 기기(RPi 등)에서 직접 돌리는 경량 AI 모델 |
| regression | 코드 수정으로 기존에 되던 기능이 깨지는 것 |
| QAS / FR | QAS = 품질 속성 시나리오(QA Final 문서), FR = 기능 요구사항(Architectural Drivers 문서) |

## 리스크 매트릭스

> 범위형 등급은 높은 쪽 기준으로 배치했다: Medium~High → High, Low~Medium → Medium.

| 발생 확률 / 영향 | High | Medium | Low |
|------------------|------|--------|-----|
| High | R-A1, R-A2, R-B1, R-B2, R-F1, R-F6 | - | - |
| Medium | R-A3, R-A5, R-D1 | R-A4, R-C1, R-D2, R-D3, R-E1, R-F3, R-F4, R-F5 | - |
| Low | - | R-F2 | R-E2 |

## A. 실시간 성능 (RPi)

- **R-A1 — RPi5가 고속 샘플레이트(96k/192k)를 실시간으로 따라가지 못해 소리 데이터를 놓친다 (block drop / missed beat)**
  - **품질요소**: Performance (Throughput)
  - **근거**: pdf (p.25 Real Time Performance), QAS-1
  - **발생 확률 / 영향**: High / High
  - **완화 방향**: 1주차 spike로 RPi 처리 한계 측정 후 샘플레이트 목표 확정(192k는 stretch로 격하)
  - **Tradeoff point**: 샘플레이트는 측정 정밀도(0.1 ms당 샘플 수 증가)↔Performance(본 리스크)의 tradeoff point
  - **코멘트**: 1주차 spike 결과로 최종 샘플레이트 목표 결정

- **R-A2 — 필터 4개(F0→F3) + 그래프 여러 개를 동시에 그리면 화면이 버벅인다(<20 FPS·UI freeze)**
  - **품질요소**: Performance
  - **근거**: FR-12-01, FR-12-04, QAS-1
  - **발생 확률 / 영향**: Medium~High / High
  - **완화 방향**: 공유 입력버퍼 재사용, 비활성 뷰 렌더 중단, FPS 예산 측정
  - **Tradeoff point**: 동시 4뷰 표시는 Usability(QAS-5)↔Performance의 tradeoff point
  - **코멘트**: 4개 동시 뷰 / 1개씩 뷰는 성능 확인 후 결정

- **R-A3 — 소리→화면 0.5초(p99 ≤ 500 ms) 목표를 못 지킨다**
  - **품질요소**: Performance (Latency)
  - **근거**: QAS-1
  - **발생 확률 / 영향**: Medium / High
  - **완화 방향**: 캡처/처리/표시 단계별 지연 계측·백로그 모니터링
  - **코멘트**: 최악의 경우로 고려해서 리소스/프로세스 최적화 또는 기능 약화로 마이그레이션

- **R-A4 — 장시간(24h+) 연속 실행 시 메모리가 새서 느려지거나 죽는다**
  - **품질요소**: Dependability (Reliability) (+Performance)
  - **근거**: FR-07-10
  - **발생 확률 / 영향**: Medium / Medium
  - **완화 방향**: 장기 RSS 추세 모니터, 버퍼 상한·집계(aggregation) 설계
  - **코멘트**: 현 코드 기준으로 메모리 릭 확인 (실험)

- **R-A5 — Avalonia 프레임워크 사용 시 RPi5에서 GPU 가속 렌더링이 버그로 SW 렌더링보다 느려 실시간 그래프(Rate/Scope) 갱신이 끊길 수 있다**
  - **품질요소**: Performance (Latency)
  - **근거**: Avalonia GitHub에 RPi/임베디드의 GPU 가속 성능 저하 보고 다수 — #18807, #18942, #19288, #18127. pdf (p.25 Real Time Performance)
  - **발생 확률 / 영향**: Medium / High
  - **완화 방향**: 1주차 spike로 RPi5 실기기에서 렌더링 백엔드(GLX/EGL/Software) A/B 측정 후 백엔드 확정. 가속 경로가 느리면 Software 렌더링으로 전환(설정 1줄, 기능 손실 없음)
  - **Tradeoff point**: 렌더링 백엔드는 UI 프레임 안정성↔CPU 점유(Software 렌더링은 오디오 분석 스레드와 CPU 경쟁)의 tradeoff point
  - **코멘트**: 유사 보고가 여러 건 퍼져 있으나 원인이 제각각(앱 측 버그, 해상도, 드라이버 경로)이라 우리 워크로드에서의 실측 확인 필요. 1주차 spike(Planned Experiments 실험 1) 결과로 렌더링 백엔드 기본값 유지/변경 결정

## B. 신호처리 / 측정 신뢰성

- **R-B1 — 틱/톡 위치를 0.1 ms 정밀도로 못 찾으면 rate·beat error·amplitude 전부가 오염된다**
  - **품질요소**: Dependability (Reliability)
  - **근거**: FR-08-04…06, FR-06-01…04
  - **발생 확률 / 영향**: High / High
  - **완화 방향**: 합성신호(정답 known) 벤치로 검출 알고리즘 조기 검증
  - **코멘트**: 현 로직 기준으로 정상동작 확인 및 필요 시 로직 개선 필요

- **R-B2 — 시끄럽거나 신호가 약한 환경에서 "신호 약함" 대신 오해를 부르는 값을 표시할 수 있다**
  - **품질요소**: Availability (Graceful Degradation)
  - **근거**: QAS-2
  - **발생 확률 / 영향**: Medium~High / High
  - **완화 방향**: 필터링·신호품질 판정, bad-data는 "signal weak" 표시로 격리
  - **코멘트**: 노이즈 레벨 별 테스트 및 필요 시 로직 개선

## C. 아키텍처 / 확장성

- **R-C1 — 필터/마커 확장 구조(예: F4 추가)를 미리 설계하지 않으면 후반 비용이 급증한다**
  - **품질요소**: Modifiability (Extensibility)
  - **근거**: FR-12-01, QAS-4
  - **발생 확률 / 영향**: Medium / Medium
  - **완화 방향**: Filter 인터페이스(strategy)·plug-in 등록 방식 선설계
  - **코멘트**: 모듈화를 더 잘 하면 될 듯함

## D. 하드웨어 / 플랫폼

- **R-D1 — AGC를 끄지 않거나 마이크 결합이 나쁘면 신호가 왜곡돼 모든 측정이 망가진다**
  - **품질요소**: Dependability (Reliability)
  - **근거**: pdf (p.29 Raspberry Pi OS — Auto Gain Control)
  - **발생 확률 / 영향**: Medium / High
  - **완화 방향**: 착수 즉시 AGC off·커플링 검증을 환경 체크리스트화
  - **코멘트**: 사용자 가이드 문서에 명시 필요

- **R-D2 — Windows에서 개발하고 RPi에서 데모 — 오디오 백엔드(WASAPI/ALSA) 등 플랫폼 차이가 늦게 드러난다**
  - **품질요소**: Portability (+Performance)
  - **근거**: pdf (p.29 System Software)
  - **발생 확률 / 영향**: Medium / Medium
  - **완화 방향**: 오디오 I/O를 포트-어댑터로 격리, RPi 조기·정기 검증
  - **코멘트**: 프로젝트 진행하면서 RPi에도 진행할 것이어서 리스크 낮음

- **R-D3 — 샘플레이트 3종(48/96/192k) 지원이 타이밍·복잡도를 키운다**
  - **품질요소**: Portability (+Reliability)
  - **근거**: pdf (p.25 Real Time Performance)
  - **발생 확률 / 영향**: Medium / Medium
  - **완화 방향**: 지원 샘플레이트 범위 명시, 어댑터에서 정규화
  - **코멘트**: 가능 스펙 명시 (마이크 스펙 등)

## E. 사용성 / UI (800×480)

- **R-E1 — 작은 화면에 요약바 + 그래프 + 스코프를 가독성(글자 ≥2.9mm·터치 ≥9mm) 있게 다 못 담는다**
  - **품질요소**: Usability
  - **근거**: pdf (p.27 8 Inch Touchscreen for Raspberry Pi), QAS-5
  - **발생 확률 / 영향**: Medium / Medium
  - **완화 방향**: 핵심 측정값 우선 레이아웃, 탭 기반 분할, ≤2탭 내비
  - **코멘트**: 크기 조절 테스트 진행

- **R-E2 — 터치 정확도·인식률이 떨어질 수 있다**
  - **품질요소**: Usability
  - **발생 확률 / 영향**: Low / Low
  - **완화 방향**: 터치 민감도나 터치 범위인식을 실험적으로 가능하면 확인
  - **코멘트**: App 레벨에서 제어 가능하면 실험 후 최적의 값 확인, OS 레벨에서 정의되면 현 상태 진행

## F. 프로젝트 / 프로세스

- **R-F1 — 5주 안에 12개 기능 + AI 전부는 불가능 — 우선순위에 실패하면 핵심이 빠진다**
  - **품질요소**: 전 QA (특히 Performance·Reliability)
  - **근거**: pdf (p.5 Objective — "feasible, well-architected subset")
  - **발생 확률 / 영향**: Medium~High / High
  - **완화 방향**: FR 우선순위 동결, AI는 optional 분리, 핵심 경로 우선
  - **코멘트**: 프로젝트 플래닝 잘 해서 진행하고 버릴 건 버림

- **R-F2 — 제공 베이스라인 코드(TimeGrapher_v10.4) 이해에 시간이 걸려 착수가 늦어진다**
  - **품질요소**: Modifiability (착수·유지보수)
  - **근거**: pdf (p.29 GUI Code)
  - **발생 확률 / 영향**: Low / Medium
  - **완화 방향**: 코드 reading 세션·모듈 맵 작성을 1주차 태스크화
  - **코멘트**: AI 활용하기 때문에 Risk 낮아짐

- **R-F3 — Qt/C++·DSP·RPi 학습곡선으로 구현 품질이 흔들린다**
  - **품질요소**: 전 QA (구현 품질 전반)
  - **근거**: pdf (p.29 Qt and Qt Creator)
  - **발생 확률 / 영향**: Low~Medium / Medium
  - **완화 방향**: 역할 분담·페어링, 작은 spike로 조기 학습
  - **코멘트**: AI 활용하기 때문에 Risk 낮아짐

- **R-F4 — AI/TinyML 기능을 시도하면 on-device 불확실성이 커진다**
  - **품질요소**: Dependability (Reliability) — 신호품질 분류
  - **근거**: pdf (p.12 AI Feature)
  - **발생 확률 / 영향**: Medium(시도 시) / Medium
  - **완화 방향**: optional 스코프로 분리, 미달 시 룰베이스 폴백
  - **코멘트**: 우선 Windows 진행 후 RPi 5에서 동작성 검토 후 반영 결정

- **R-F5 — GenAI 생성 코드를 검증 없이 수용하면 그럴듯하지만 틀린 코드가 들어온다 (특히 DSP/동시성/실시간 영역)**
  - **품질요소**: Reliability·Performance·(Testability)
  - **근거**: pdf (p.30 Project Deliverables)
  - **발생 확률 / 영향**: Medium / Medium
  - **완화 방향**: 생성코드 adversarial 검증(단위테스트·합성신호 벤치) 의무화, 핵심 알고리즘은 이해 동반, GenAI 사용 허용여부 멘토 확인
  - **코멘트**: 완화 방향 참고 (코드리뷰, 우리 모두 알고리즘 이해 등)

- **R-F6 — 테스트용 Pi5가 한 대뿐이라 실사용 검증 일정이 안 나온다**
  - **품질요소**: Modifiability (Testability)
  - **근거**: pdf (p.26 System Hardware — Raspberry Pi)
  - **발생 확률 / 영향**: High / High
  - **완화 방향**: 검증의 대부분을 Sim/Playback 기반(하드웨어 불요)으로 설계해 Pi5 의존 최소화; 실기기는 성능 측정 등 필수 항목에만 일정 배정

## G. 기타 또는 카테고리화 되지 않음

- **의사소통** — 영어 대화 시 이해관계자 간 정확한 의사전달이 안 될 수 있다
- **테스트 환경 부족** — 장비 1대, 테스트룸·unit test 없음 → 로직 변경 시 regression을 놓칠 수 있다
- **장시간 검증 곤란** — 24시간 연속 같은 항목은 실제 검증·평가가 어렵다
- **저장량 증가** — 장시간 녹음 시 파일 크기가 커진다
- **RPi5 디버깅 곤란** — 상태 파악·디버깅이 어렵다 → 로그 메시지 남기기로 실험 가능
- **데이터 구조 불확실** — 음성 버퍼·측정 데이터 저장 구조가 미정이다
- **저장 속도 병목** — SD 카드 쓰기가 녹음 생성 속도보다 느릴 수 있다 → SD 스펙 확인 + 실녹음 테스트
