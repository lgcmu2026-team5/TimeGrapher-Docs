# Glossary

> Team 5 · Milestone 1 발표 문서 전반의 통합 용어집 — 모든 절이 일관되게 참조하는 용어의 단일 원천이다. 아래 용어는 Milestone 1 발표 문서 전반(Architectural Drivers, Risk Assessment, Planned Experiments, Architectural View, Architectural Approaches)에서 사용된다.

## 도메인 용어

기능 요구사항 전반에서 사용되는 시계 도메인 용어.

| 용어 | 정의 |
|------|------|
| A / B / C (= T1 / T2 / T3) | 스위스 레버 탈진기에서 하나의 비트 안에 발생하는 세 개의 음향 이벤트. **A(T1)** = 임펄스핀이 팔레트포크를 타격 — 반복성이 높아 일오차(rate)·비트 에러 산출에 사용; **B(T2)** = 이스케이프휠 톱니가 팔레트 스톤 위를 미끄러짐 — 불규칙하여 측정에 사용하지 않음; **C(T3)** = 이스케이프휠 톱니가 록(lock)되고 팔레트포크가 뱅킹핀을 타격 — 가장 큰 소리로, A와 함께 진폭(amplitude) 산출에 사용. 측정에는 A·C 이벤트를 사용하며([FR-08-04](2-Architectural-Drivers.md#g08--escapement-analyzer-and-marker-line-display) 참조), 필터 뷰 F0–F3가 이들의 위치 파악·식별을 돕는다. |
| tick / tock | 밸런스가 좌우로 번갈아 진동하며 시간축에서 번갈아 나타나는 비트 — 한쪽 진동이 **tick**, 되돌아오는 진동이 **tock**이다. beat error는 연속한 tick·tock 간격의 비대칭이며, 스코프 2와 비트 에러 트레이스 라인은 tick·tock 비트를 각각 나눠 표시한다. tick이든 tock이든 각 비트는 자체적인 A/B/C 이벤트를 가지므로, tick/tock(시간축에서 어느 비트인가)과 A/B/C(한 비트 안에서 어느 이벤트인가)는 서로 다른 축이며 같은 라벨이 아니다. |
| 구동각 (Lift angle) | 탈진기가 임펄스를 전달하는 동안 밸런스가 움직이는 각도. 캘리버별 상수(통상 ~40°–60°)로 입력되며, 비트 신호로부터 진폭을 산출하는 데 사용된다. |
| BPH (시간당 진동수, beats per hour) | 시간당 밸런스 비트(반진동) 수 — 시계의 공칭 동작 주파수. 대표값: 18000, 21600, 28800, 36000, 43200 BPH — 본 프로젝트의 최고 목표는 43200 BPH. |
| 진동수 (Beat number) | BPH로 표현되는 시계의 공칭 진동수와 동의어이며, 선택한 간격과 함께 스코프 2 측정 사이클을 결정한다. |
| 공칭 진동수 (Nominal (beat) rate) | 시계의 설계상 목표 비트 속도(BPH 또는 초당 비트). "nominal rate"와 "nominal beat rate"는 동일한 값을 가리키며, 스코프 스윕 디스플레이의 동기화·참조값으로 사용된다. |
| 타이밍 테스트 (Timing test) | 시계의 주요 타이밍 결과(일오차, 진폭, 비트 에러, 공칭 진동수)를 산출하는 측정 실행. "가장 최근의 타이밍 테스트"는 그 결과가 이후 참조용으로 보존되는 가장 최근 실행을 의미한다([FR-11-05…08](2-Architectural-Drivers.md#g11--scope-mode-with-synchronized-sweep-display) 참조). |
| 밸런스 휠 불균형 (Balance-wheel unbalance) | 수직 자세 간에 일오차가 달라지게 만드는 밸런스-헤어스프링 조립체의 포이징(poising) 오차. 여러 수직 자세에 걸친 큰 일오차 편차로 드러난다([FR-04-09](2-Architectural-Drivers.md#g04--multi-position-sequence-display) 참조). |
| 온셋/피크 (Onset/Peak) | 마커 측정 기준으로 사용되는 비트 음향 파형의 신호 특징점: **Onset** = 비트 소리의 시작(앞 에지), **Peak** = 진폭이 최대인 지점([FR-08-06](2-Architectural-Drivers.md#g08--escapement-analyzer-and-marker-line-display) 참조). |
| Vario (Display) / 바리오 (디스플레이) | 일오차·진폭의 장기 안정성 뷰(G03) — 각 측정 항목의 최소/최대/평균/표준편차/경과시간/현재값을 보여준다. |

## 품질 속성·측정 용어

품질 속성 시나리오에서 참조하는 지표·단위·표준.

| 용어 | 정의 |
|------|------|
| p99 | 측정값을 작은 순으로 정렬했을 때 99% 지점의 값 — 가장 느린 1%를 제외한 전부가 이 값 이내 |
| 비트 주기 (beat period) | 연속한 두 비트 사이의 시간 = 3600 s ÷ BPH — 43200 BPH에서 83.3 ms, 28800 BPH에서 125.0 ms; QAS-2 latency 예산의 근거 |
| E2E (end-to-end) latency | 오디오 블록 캡처부터 화면 표시까지의 총 지연 = capture-to-processing + processing-to-display |
| SNR | Signal-to-Noise Ratio — 신호 대 잡음 비(dB). 클수록 신호가 깨끗함 |
| person-days | 1명이 1일에 처리하는 작업량 단위 |
| 일오차 (rate) | 시계가 하루에 빨라지거나 느려지는 초 수 (s/d) |
| 비트 에러 (beat error) | tick과 tock 간격의 비대칭 정도 (ms) |
| 진폭 (amplitude) | 밸런스 휠이 흔들리는 회전 각도 (°) — 시계 건강 상태의 핵심 지표 |
| Sim / Playback | Sim = 합성 시계 신호 생성 모드(정답을 미리 알고 있음); Playback = 녹음 파일 재생 모드 |
| SMPTE | 미국 영화·TV 기술자 협회 — 화면 시청 거리·시야각 권고 기준의 출처 |
| ISO 9241-303 | 전자 디스플레이 인간공학 국제 표준 — 글자 크기 권고 기준의 출처 |
| 글리프 (glyph) | 화면에 표시되는 글자 한 개의 모양 |
| arcmin | 각도의 분 단위(1° = 60 arcmin) — 눈에 보이는 크기를 재는 단위 |
| Weishi Timegrapher | EXP-06의 side-by-side measurement comparison에 실제로 사용한 상용 timegrapher 장비. Witschi의 오타가 아니라 별도 장비명이다. |
| Witschi / Chronometer 등급 | Witschi — 이 문서에서 industry reference로만 사용하는 워치 타이밍머신 제조사; **Chronometer**는 가장 엄격한 등급(−2…+6 s/d)으로 ±3 s/d 허용폭의 근거. |

## 플랫폼·엔지니어링 용어

리스크 평가에서 참조하는 구현·플랫폼·프로세스 용어.

| 용어 | 정의 |
|------|------|
| RPi5 (Raspberry Pi 5) | 시스템이 구동되는 싱글보드 컴퓨터(8 GB RAM, 128 GB microSD) — 1280×800 8인치 터치 디스플레이가 연결되고 Raspberry Pi OS(Debian 기반, 64-bit/ARM64)를 실행하는 목표 배포 장비 |
| 샘플레이트 (48k/96k/192k) | 초당 오디오 샘플 수 — 96k는 초당 96,000개 샘플 |
| block drop / missed beat | 처리가 입력을 못 따라가 오디오 블록을 버리거나 비트를 놓치는 것 |
| FPS | Frames Per Second — 초당 화면 갱신 횟수. 낮으면 화면이 버벅임 |
| RSS | 프로세스가 실제로 점유한 메모리 양 — 계속 늘면 메모리 누수 의심 |
| ground truth | 검증의 기준이 되는 "정답" 값 |
| AGC | Auto Gain Control — 마이크 음량 자동 조절 기능. 켜져 있으면 신호가 왜곡되므로 측정 전 꺼야 함 |
| WASAPI / ALSA | Windows / Linux의 오디오 입출력 시스템 — 플랫폼마다 달라 포팅 시 차이가 드러남 |
| technical experiment | 본 구현 전에 기술 한계를 빠르게 확인하는 집중 검증 활동 |
| TinyML | 소형 기기(RPi 등)에서 직접 돌리는 경량 AI 모델 |
| regression | 코드 수정으로 기존에 되던 기능이 깨지는 것 |
| SAP | Software Architecture Practice — 본 마일스톤이 따르는 아키텍처 방법론("SAP 기준"으로 참조) |
| Avalonia / Qt | 후보 크로스플랫폼 UI 프레임워크 — Avalonia(.NET / C#), Qt(C++); UI 스택은 아직 검토 중이며 확정되지 않음 |
| GLX / EGL | Linux에서 GPU 가속(하드웨어) 렌더링 인터페이스 — EXP-01에서 소프트웨어 렌더링과 비교하는 백엔드 |
| QAS / FR / QAS-ALL | QAS = 품질 속성 시나리오(Architectural Drivers 문서); QAS-ALL = 모든 품질 속성 시나리오(QAS-1…6); FR = 기능 요구사항(Architectural Drivers 문서) |
