# Milestone 2 Review Q&A

---

## Project Plan

---

### 계획이 어떻게 변경되었는가?

Milestone 1 이후 다음과 같은 주요 변경사항이 있었습니다:

<details>
<summary><strong>1. QAS-2 기준 교체.</strong></summary>

기존 지연 목표(p99 ≤ 500 ms)가 비트 주기 기반 하드 데드라인(43200 BPH @ 192 kHz에서 ≤ 83.3 ms, 21600 BPH @ 48 kHz에서 ≤ 166.7 ms)으로 교체되었습니다. M1 피드백(#98)을 반영한 것으로, 500 ms는 GUI 반응 속도 기준이지 실시간 비트 분석 기준이 아님을 인식한 결과입니다. → [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지)

</details>

<details>
<summary><strong>2. 플랫폼 결정 확정.</strong></summary>

[EXP-01](4-Planned-Experiments.md#exp-01-rpi5-avalonia-렌더링-백엔드)에서 RPi5의 GPU 가속 렌더링(GLX/EGL ≈ 60 FPS)이 실용적임을 확인한 후, Qt/C++를 .NET(C#) + Avalonia UI로 전환하고 이를 고정했습니다. [R-16](3-Risk-Assessment.md#f-프로젝트--프로세스)(학습 곡선 리스크)도 이로써 해소되었습니다.

</details>

<details>
<summary><strong>3. 샘플 레이트 범위 확정.</strong></summary>

[EXP-02](4-Planned-Experiments.md#exp-02-rpi5-실시간-샘플레이트-상한)에서 43200 BPH @ 192 kHz가 지연 예산의 ~41%만 사용하고 블록 드롭이 없음을 확인하여, 192 kHz가 완전 지원 레이트로 격상되었습니다.

</details>

<details>
<summary><strong>4. 아키텍처 MVC → MVVM 전환.</strong></summary>

기존 MVC 스타일 MainWindow를 View / ViewModel / RunCommandService(State Pattern) 세 가지 MVVM 역할로 분리했습니다. [QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--새-측정필터그래프-추가) 수정성 요구사항이 동인이었습니다.

</details>

<details>
<summary><strong>5. 문서 통합.</strong></summary>

마일스톤별로 분리되어 있던 문서를 하나의 진화형 문서 세트로 통합했습니다(M1 피드백 #172).

</details>

<details>
<summary><strong>6. ADR 세트 신설.</strong></summary>

핵심 결정을 공식화하기 위해 M2에서 [ADR-001](ADR/ADR-001.md), [ADR-002](ADR/ADR-002.md), [ADR-003](ADR/ADR-003.md), [ADR-004](ADR/ADR-004.md)를 작성했습니다.

</details>

---

### 팀이 리스크를 지속적으로 평가하고, 그에 따라 계획을 업데이트하고 있는가?

네, 구체적인 증거가 있습니다:

- **10개 리스크 해소** ([R-01](3-Risk-Assessment.md#a-실시간-성능-rpi)~[R-05](3-Risk-Assessment.md#a-실시간-성능-rpi), [R-08](3-Risk-Assessment.md#c-아키텍처--확장성)~[R-12](3-Risk-Assessment.md#e-사용성--ui-1280800)): 각 해소에 실험적 근거가 명시되어 있습니다.
- **리스크 상태가 실험 결과에 따라 업데이트:** [EXP-02](4-Planned-Experiments.md#exp-02-rpi5-실시간-샘플레이트-상한) 측정 후 [R-01](3-Risk-Assessment.md#a-실시간-성능-rpi)·[R-03](3-Risk-Assessment.md#a-실시간-성능-rpi)이 중간/해소로 전환; [EXP-05](4-Planned-Experiments.md#exp-05-장시간-24h-실행-안정성)에서 RSS 플랫 확인 후 [R-04](3-Risk-Assessment.md#a-실시간-성능-rpi)가 해소됨.
- **리스크 확률 재산정:** [R-01](3-Risk-Assessment.md#a-실시간-성능-rpi)이 실측 후 중간(Medium) → 낮음(Low)으로 하향됨.
- **발견 시 신규 리스크 추가:** [R-19](3-Risk-Assessment.md#f-프로젝트--프로세스)(RPi5 1대)는 이후 2대 확보로 완화 조치가 기재됨.
- **M1 피드백이 리스크 업데이트에 직결:** [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지) 기준 변경(M1 피드백 #98)이 며칠 내에 [R-01](3-Risk-Assessment.md#a-실시간-성능-rpi), [R-02](3-Risk-Assessment.md#a-실시간-성능-rpi), [R-03](3-Risk-Assessment.md#a-실시간-성능-rpi) 설명에 반영됨.
- **[R-06](3-Risk-Assessment.md#b-신호처리--측정-신뢰성), [R-07](3-Risk-Assessment.md#b-신호처리--측정-신뢰성)은 "진행 중"으로 명시적인 현황 주석과 미완 항목이 기재되어** 방치가 아닌 능동적 추적 중임을 보여줍니다.

---

### 남아있는 주요 문제나 리스크에 대한 대응 계획이 있는가?

네. 3개의 미해소 리스크에 대해 구체적인 계획이 존재합니다:

| 리스크 | 상태 | 대응 계획 |
|--------|------|-----------|
| **[R-06](3-Risk-Assessment.md#b-신호처리--측정-신뢰성)** — A/C 이벤트 검출 정확도(0.1 ms 미만) | 진행 중 | [EXP-06](4-Planned-Experiments.md#exp-06-측정-정확도) 1단계(Realistic-off 시뮬레이션) 2026-06-21 완료; 2단계(Weishi Timegrapher 비교) 2026-06-22~25 예정 |
| **[R-07](3-Risk-Assessment.md#b-신호처리--측정-신뢰성)** — 노이즈·약한 신호 시 오도값 표시 | 진행 중 | "신호 약함" UI 상태 구현 중; 노이즈 레벨별 테스트 계획; 필요 시 로직 개선 |
| **[R-17](3-Risk-Assessment.md#f-프로젝트--프로세스)** — 온디바이스 TinyML 불확실성 | 진행 중 | [EXP-04](4-Planned-Experiments.md#exp-04-온디바이스-tinyml-추론-타당성)가 Milestone 3(2026-06-23~25) 예정; 규칙 기반 폴백(`PllMatchGate`) 이미 구현됨 |

---

### 현실적인 구축(구현) 계획을 가지고 있는가?

네. 구현 계획은 기능별로 할당되고, 팀원별로 배정되며, 기간이 명시되어 있습니다:

- **12개 기능 그룹([G01–G12](2-Architectural-Drivers.md#functional-requirements))**이 3개 소팀에 배분되었습니다. 2026-06-21 기준으로 12개 중 11개 완료; [G09](2-Architectural-Drivers.md#g09--time-frequency-spectrogram-display)만 일부 항목(FR-09-04, FR-09-05)이 2026-06-23 목표로 진행 중입니다.
- **[QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--새-측정필터그래프-추가)의 피처당 8인일 예산**(16일 × 6명 ÷ 12 피처)을 공수 기준으로 사용했습니다.
- Milestone 3(2026-06-23 ~ 2026-07-01)에는 [EXP-04](4-Planned-Experiments.md#exp-04-온디바이스-tinyml-추론-타당성)(TinyML), [EXP-06](4-Planned-Experiments.md#exp-06-측정-정확도) 2단계(Weishi), 전 탭 줌 인/아웃([G01–G12](2-Architectural-Drivers.md#functional-requirements)), Settings 옵션, 발표 준비, 시연 준비가 포함됩니다.
- 필수 범위와 선택 범위를 명확히 구분하고 AI 기능을 규칙 기반 폴백과 함께 선택 범위로 격리했습니다.


---

## 실험 / 결과

---

### 어떤 실험들이 수행되었는가?

4개의 technical experiment가 완료되었고, 2개가 진행 중입니다:

| 실험 | 상태 | 완료일 |
|------|------|--------|
| **[EXP-01](4-Planned-Experiments.md#exp-01-rpi5-avalonia-렌더링-백엔드)** — RPi5에서의 Avalonia 렌더링 백엔드 | 완료 | 2026-06-10 |
| **[EXP-02](4-Planned-Experiments.md#exp-02-rpi5-실시간-샘플레이트-상한)** — RPi5 실시간 샘플레이트 상한 | 완료 | 2026-06-15 |
| **[EXP-03](4-Planned-Experiments.md#exp-03-gui-실시간-렌더링-디자인-패턴)** — GUI 실시간 렌더링 설계 패턴 | 완료 | 2026-06-21 |
| **[EXP-05](4-Planned-Experiments.md#exp-05-장시간-24h-실행-안정성)** — 장기 안정성(24시간+) | 완료 | 2026-06-16 |
| **[EXP-06](4-Planned-Experiments.md#exp-06-측정-정확도) 1단계** — 측정 정확도(Realistic-off 시뮬레이션) | 완료 | 2026-06-21 |
| **[EXP-06](4-Planned-Experiments.md#exp-06-측정-정확도) 2단계** — 측정 정확도(Weishi 비교) | 진행 중 | 2026-06-22~25 예정 |
| **[EXP-04](4-Planned-Experiments.md#exp-04-온디바이스-tinyml-추론-타당성)** — 온디바이스 TinyML 추론 타당성 | 진행 중 | M3(2026-06-23~25) 예정 |

---

### 실험 결과가 기존의 의문점이나 문제를 해결했는가?

대부분 해결되었으나, 한 가지 중요한 항목이 아직 미완입니다:

- **[EXP-01](4-Planned-Experiments.md#exp-01-rpi5-avalonia-렌더링-백엔드)**: RPi5에서 GPU 우선 렌더링이 안전함을 확인(GLX ≈ 59.2 FPS, EGL ≈ 60 FPS). 커뮤니티에서 보고된 느린 현상은 재현되지 않음 → [R-05](3-Risk-Assessment.md#a-실시간-성능-rpi) 해소.
- **[EXP-02](4-Planned-Experiments.md#exp-02-rpi5-실시간-샘플레이트-상한)**: 43200 BPH @ 192 kHz가 83.3 ms 예산의 ~41%만 사용(최악 36.46 ms), RPi5에서 블록 드롭·비트 미검출 0 확인 → [R-01](3-Risk-Assessment.md#a-실시간-성능-rpi), [R-03](3-Risk-Assessment.md#a-실시간-성능-rpi) 해소.
- **[EXP-03](4-Planned-Experiments.md#exp-03-gui-실시간-렌더링-디자인-패턴)**: Pipe-and-Filter + Producer–Consumer + Latest-Wins + 고정 버퍼 풀이 UI 스레드 블로킹을 제거함 확인. 13개 탭 전부 83.3 ms 예산 이내(최악 Filter Scope 36.46 ms) → [R-02](3-Risk-Assessment.md#a-실시간-성능-rpi) 해소.
- **[EXP-05](4-Planned-Experiments.md#exp-05-장시간-24h-실행-안정성)**: 24시간 동안 RSS ~406 MB로 플랫, CPU 저하 없음 확인 → [R-04](3-Risk-Assessment.md#a-실시간-성능-rpi) 해소.
- **[EXP-06](4-Planned-Experiments.md#exp-06-측정-정확도) 1단계**: Realistic-off 시뮬레이션에서 rate·amplitude·beat error가 허용 오차 이내임을 1차 확인. **2단계(상업용 Weishi Timegrapher 비교)는 아직 미완** — [R-06](3-Risk-Assessment.md#b-신호처리--측정-신뢰성) / [QAS-1](2-Architectural-Drivers.md#qas-1--accuracy--음향-이벤트-검출에서-시계-지표-계산까지의-정확도)에 대한 가장 중요한 미결 의문 사항.

---

### 앞으로 남아있는 실험은 무엇인가?

- **[EXP-06](4-Planned-Experiments.md#exp-06-측정-정확도) 2단계** (Weishi Timegrapher 비교) — 2026-06-22~25 예정. [R-06](3-Risk-Assessment.md#b-신호처리--측정-신뢰성)을 해소하고 [QAS-1](2-Architectural-Drivers.md#qas-1--accuracy--음향-이벤트-검출에서-시계-지표-계산까지의-정확도)을 충족하는 검증입니다.
- **[EXP-04](4-Planned-Experiments.md#exp-04-온디바이스-tinyml-추론-타당성)** (온디바이스 TinyML 추론 타당성) — Milestone 3(2026-06-23~25) 예정. [R-17](3-Risk-Assessment.md#f-프로젝트--프로세스)을 다루며, TinyML 채택에 대한 Go/Conditional/No-Go 결정을 산출합니다.

---

### 해당 실험들은 시스템 전체 목표와 관련된 문제에 집중하고 있는가?

네, 명확한 매핑이 존재합니다:

- **[EXP-01](4-Planned-Experiments.md#exp-01-rpi5-avalonia-렌더링-백엔드), [EXP-02](4-Planned-Experiments.md#exp-02-rpi5-실시간-샘플레이트-상한), [EXP-03](4-Planned-Experiments.md#exp-03-gui-실시간-렌더링-디자인-패턴), [EXP-05](4-Planned-Experiments.md#exp-05-장시간-24h-실행-안정성)** → [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지)(성능/지연)
- **[EXP-06](4-Planned-Experiments.md#exp-06-측정-정확도)** → [QAS-1](2-Architectural-Drivers.md#qas-1--accuracy--음향-이벤트-검출에서-시계-지표-계산까지의-정확도)(정확도) — 시스템의 핵심 측정 목적(rate, amplitude, beat error)의 신뢰성을 직접 검증.
- **[EXP-04](4-Planned-Experiments.md#exp-04-온디바이스-tinyml-추론-타당성)** → [QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지) + [QAS-3](2-Architectural-Drivers.md#qas-3--reliability--잡음약신호-환경) — 선택 AI 기능 추가 시 실시간 동작 또는 측정 신뢰성이 깨지지 않는지 검증.

모든 실험이 최고 등급 리스크(고확률 × 고영향)와 최우선 QAS에 집중되어 있어, 기회주의적 탐색이 아닌 의도적 집중을 보여줍니다.

---

## 아키텍처

---

### 코드 구조 관점

우리는 두 가지 모듈 뷰를 작성했습니다:

<details>
<summary><strong><a href="5-Architectural-View.md#1-1-timegrapher-mvvm-view--responsibility-separation">1. TIMEGRAPHER MVVM VIEW – Responsibility Separation</a></strong></summary>

세 레이어 간의 단방향 «use» 의존성을 보여줍니다:
- **View Layer** (Main Window, Graph Tabs Window, Graph Rendering) → `MainWindowViewModel` 사용
- **ViewModel Layer** (`MainWindowViewModel`, Run/세션 조정, 입력/표시 조정) → Core 모듈 사용
- **Model Layer** (`Core.Analysis·Detection`, `Core.Metrics·AudioIo·Imaging`, `Core.Shared`, `Platform.WindowsAudio·LinuxAudio`) → 상향 의존 없음

핵심 제약: ViewModel은 Avalonia/View 타입을 보유하지 않음(`ViewModelPurityTests`로 강제). Model(`Core`)은 외부 의존성이 없음.

</details>

<details>
<summary><strong><a href="5-Architectural-View.md#1-2-timegrapher-module-uses-view--actual-dependencies--internal-decomposition">2-1. TIMEGRAPHER MODULE USES VIEW – Actual Dependencies & Internal Decomposition</a></strong></summary>

어떤 모듈이 어떤 모듈을 사용하도록 구조화되어 있는지를 보여줍니다. 전체 프로젝트 수준에서 App·Core·플랫폼 오디오 어댑터·Verify의 관계를 표현하며, 핵심은 Core가 중심에 있고 App·Verify·`WindowsAudio`·`LinuxAudio`가 Core를 사용한다는 점입니다. `WindowsAudio`·`LinuxAudio`(platform adapters)는 OS별 오디오 의존성이 Core 안으로 들어오지 않도록 경계를 만듭니다.

</details>

<details>
<summary><strong><a href="5-Architectural-View.md#core-internal-module-uses">2-2. Core-Internal Module Uses</a></strong></summary>

Core를 확대한 내부 뷰입니다. `Analysis`가 분석 흐름을 조정하며 `Detection`·`Metrics`·`Imaging`·`AudioIo` 도메인 모듈을 사용합니다. `Shared`는 Core 내부 모듈들이 공통으로 사용하는 타입과 계약(`AnalysisFrame`, 공유 오디오 버퍼, 분석 worker 입출력 계약, sync/signal 상태 타입 등)을 모아둔 영역으로, 다른 Core 모듈에 의존하지 않습니다.

</details>

---

### 실행 관점

런타임 뷰는 2개의 시퀀스 다이어그램과 1개의 상태 머신으로 제시됩니다:

<details>
<summary><strong><a href="5-Architectural-View.md#3-1-timegrapher-run-lifecycle-cc-view--measurement-analysis-loop">런타임 데이터 흐름</a></strong></summary>

`입력 소스(Live/Playback/Sim)` → `공유 오디오 버퍼` → `분석 워커(Detector → Metrics → SoundImage → Recorder)` → `AnalysisFrame` → `UI 스레드`

이는 단방향 Pipe-and-Filter 흐름입니다. 분석 워커는 `ThreadPriority.Highest` 전용 스레드에서 실행되며, UI 스레드는 렌더링만 수행합니다.

</details>

<details>
<summary><strong><a href="5-Architectural-View.md#3-1-timegrapher-run-lifecycle-cc-view--measurement-analysis-loop">Level 1 시퀀스 다이어그램</a></strong></summary>

User → View → ViewModel → RunCommandService → Model(RunSessionController + workers)로 이어지는 전체 실행 생명주기를 다룹니다.

</details>

<details>
<summary><strong><a href="5-Architectural-View.md#3-1-timegrapher-run-lifecycle-cc-view--measurement-analysis-loop">Level 2 시퀀스 다이어그램</a></strong></summary>

`MasterAudioBuffer` → `AnalysisWorker` → `Core 파이프라인(Detection / Metrics / Projectors)`으로 이어지는 분석 루프를 전개하며, 하나의 비트 주기 안에 완료되어야 하는 반복 주기를 보여줍니다.

</details>

<details>
<summary><strong><a href="5-Architectural-View.md#3-2-timegrapher-run-lifecycle-behavior-view--control-state-transitions">상태 머신</a></strong></summary>

Stopped → Starting → Running ⇄ Paused → Stopping → StopFailed 간의 전이를 State Pattern으로 관리합니다.

</details>

주요 C&C 커넥터: Producer–Consumer 공유 버퍼(입력↔분석), Observer 팬아웃(`AnalysisFrameRouter`), Latest-Wins 스케줄러(분석→UI).

---

### 배포 관점

[배포 뷰](5-Architectural-View.md#4-timegrapher-system-deployment-view--hardware--external-signal-path)는 3단계를 보여줍니다:

<details>
<summary><strong>1. 개발 & 공유</strong></summary>

개발자들이 Windows PC에서 C#/.NET으로 작업하고 Git 서버(GitHub)에 push합니다.

</details>

<details>
<summary><strong>2. 검증 & 빌드</strong></summary>

각 push마다 CI/CD(GitHub Actions, 2026-06-20 완료)가 빌드/테스트 검증을 수행; `tag v*` 이벤트에서 Windows(x64)와 Raspberry Pi(ARM64) 별도 배포 타겟을 빌드합니다.

</details>

<details>
<summary><strong>3. 배포 & 설치</strong></summary>

빌드된 타겟이 네트워크를 통해 배포되고 각 노드에 설치됩니다.

</details>

<details>
<summary><strong>런타임 하드웨어 할당</strong></summary>

- **Raspberry Pi 5** (8 GB RAM, 128 GB microSD, 1280×800 터치스크린): 주요 프로덕션 타겟. `LinuxAudio` 어댑터(ALSA/PipeWire), Avalonia UI(GLX/EGL GPU 우선), 전체 분석 파이프라인 실행.
- **Windows 11 PC** (x64): 개발 및 기준 측정 플랫폼. `WindowsAudio` 어댑터(NAudio/WASAPI) 실행.

</details>

<details>
<summary><strong>외부 신호 경로</strong></summary>

기계식 시계 → 마이크/픽업 → USB 오디오 → 각 노드의 오디오 입력. 이 경로는 소프트웨어 배포 흐름과 독립적입니다.

</details>

---

## 추가 검토 사항

---

### 실험 결과를 통해 아키텍처가 개선되었는가?

네, 직접적이고 실질적으로 개선되었습니다:

- **[EXP-01](4-Planned-Experiments.md#exp-01-rpi5-avalonia-렌더링-백엔드)** ([ADR-001](ADR/ADR-001.md)) → Avalonia GPU 우선 렌더링 백엔드 고정(SW 폴백 불필요). 앱 시작 설정이 업데이트됨.
- **[EXP-02](4-Planned-Experiments.md#exp-02-rpi5-실시간-샘플레이트-상한)** → 지원 샘플레이트 범위(48k 기본 / 192k 상한) 확정, 원래 p99 ≤ 500 ms 기준을 "비트 주기 이내" 단일 게이트로 교체.
- **[EXP-03](4-Planned-Experiments.md#exp-03-gui-실시간-렌더링-디자인-패턴)** ([ADR-002](ADR/ADR-002.md)) → Pipe-and-Filter + 동시성 전술이 영구 아키텍처로 채택: 전용 분석 스레드(`ThreadPriority.Highest`), `AnalysisFrameRouter` Observer 팬아웃, Latest-Wins 스케줄러, 고정 버퍼 풀(`PublishBufferCount = 3`), `DecimatingSeries`. 현재 프로덕션 소스에 반영됨.
- **[EXP-05](4-Planned-Experiments.md#exp-05-장시간-24h-실행-안정성)** → 추가적인 버퍼 캡이나 집계 구조가 필요 없음을 확인; 현재 아키텍처 유지.
- **MVC → MVVM 리팩토링** ([ADR-003](ADR/ADR-003.md))도 [QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--새-측정필터그래프-추가) 피드백과 M1 리뷰의 수정성 요구사항에 의해 촉발된 아키텍처 개선임.

---

### 선택한 아키텍처 접근 방식과 그 트레이드오프를 충분히 이해하고 있는가?

네. [EXP-03](4-Planned-Experiments.md#exp-03-gui-실시간-렌더링-디자인-패턴)에 SAP(Software Architecture in Practice) 기반의 명시적 트레이드오프 분석이 포함되어 있습니다:

- **Pipe-and-Filter 이점:** 수정성 극대화(새 탭/필터가 기존 코드 변경 없이 주입 가능); 이식성 향상(백엔드가 Avalonia에서 분리됨).
- **Pipe-and-Filter 비용:** 대용량 스냅샷(SoundPrint ~2.67 MB, Spectrogram ~1.92 MB) 전달 시 데이터 복사 오버헤드. **완화 방법 명시:** 고정 버퍼 풀로 GC 스파이크와 LOH 오염 제거.
- **동시성 격리 이점:** 무거운 렌더링 중에도 UI 스레드가 블로킹되지 않음; Latest-Wins가 백로그 누적을 방지.
- **동시성 비용:** 중간 프레임이 드롭됨(프레임 드롭 / 최신 편향). **완화 방법과 근거 명시:** 실시간 모니터에서는 지연 없이 최신 상태를 보여주는 것이 더 중요하며, 장기 이력은 `DecimatingSeries`로 보완함.

---

### 아키텍처가 시스템 목표와 잘 맞는가?

네, 정렬이 명시적입니다:

| 목표 | 아키텍처 대응 |
|------|--------------|
| 측정 정확도([QAS-1](2-Architectural-Drivers.md#qas-1--accuracy--음향-이벤트-검출에서-시계-지표-계산까지의-정확도)) | 단일 AnalysisFrame 소스 → 모든 표시가 동일 데이터 공유([QAS-4](2-Architectural-Drivers.md#qas-4--consistency--표시-간-값-일치)); Detector.cs의 서브샘플 보간 |
| 실시간 비트 처리([QAS-2](2-Architectural-Drivers.md#qas-2--performance-latency--소리-입력에서-화면-표시까지)) | 전용 분석 스레드 + Latest-Wins + 유한 버퍼 → 예산의 43.8% 사용으로 검증됨 ([ADR-002](ADR/ADR-002.md)) |
| 노이즈 하 신뢰성([QAS-3](2-Architectural-Drivers.md#qas-3--reliability--잡음약신호-환경)) | 신호 품질 게이팅; "신호 약함" UI 상태; 규칙 기반 폴백(`PllMatchGate`) |
| 수정성([QAS-5](2-Architectural-Drivers.md#qas-5--modifiability-extensibility--새-측정필터그래프-추가)) | `ViewModelPurityTests`로 단방향 레이어 규칙 강제 ([ADR-003](ADR/ADR-003.md)); IAnalysisFrameConsumer 확장점; 새 기능당 기존 모듈 수정 ≤ 1; App/test/verify 모듈 분리로 6인 팀의 병렬 개발 및 머지 충돌 최소화; TDD 기반 테스트 스위트가 genAI 보조 코드 리뷰의 자동화된 안전망 제공 ([ADR-004](ADR/ADR-004.md)) |
| 소형 터치스크린 사용성([QAS-6](2-Architectural-Drivers.md#qas-6--usability--터치스크린에서-읽기조작)) | 핵심 수치 우선 레이아웃; 물리 크기 기반 가독성 규칙(글자 ≥ 2.9 mm, 터치 타겟 ≥ 9 mm) |
| 크로스플랫폼([C-3](2-Architectural-Drivers.md#설계-제약사항)) | `WindowsAudio`(WASAPI)와 `LinuxAudio`(ALSA/PipeWire)를 격리하는 Adapter 패턴 ([ADR-001](ADR/ADR-001.md)) |

---

### 아직 해결되지 않은 중요한 우려사항이 있는가?

두 가지 중요한 우려사항이 남아 있습니다:

1. **[R-06](3-Risk-Assessment.md#b-신호처리--측정-신뢰성) / [EXP-06](4-Planned-Experiments.md#exp-06-측정-정확도) 2단계(A/C 검출 vs. Weishi Timegrapher)** — 깨끗한 신호 1차 검증은 통과했으나, 실제 시계 노이즈 환경에서 알고리즘을 검증하는 상업용 비교 테스트가 아직 수행되지 않았습니다. 시스템 핵심 목적에 대한 가장 중요한 미완 검증입니다.

2. **[R-07](3-Risk-Assessment.md#b-신호처리--측정-신뢰성)(약한/노이즈 신호 처리)** — "신호 약함" UI와 기반 로직이 "진행 중"으로 기술되어 있습니다. 정의된 SNR 레벨에서 테스트되고 SNR < 30 dB에서 오도값 출력이 억제됨이 확인될 때까지 [QAS-3](2-Architectural-Drivers.md#qas-3--reliability--잡음약신호-환경)은 공식적으로 충족되지 않습니다.

부가적 우려사항:
- [EXP-04](4-Planned-Experiments.md#exp-04-온디바이스-tinyml-추론-타당성)(TinyML) 결과가 미확정; 채택 시 [R-17](3-Risk-Assessment.md#f-프로젝트--프로세스)은 TinyML 부하 하에서 [EXP-02](4-Planned-Experiments.md#exp-02-rpi5-실시간-샘플레이트-상한)/[EXP-03](4-Planned-Experiments.md#exp-03-gui-실시간-렌더링-디자인-패턴) 재실행을 요구합니다.

---

### 아키텍처에 대한 평가가 수행되었는가?

네, 복수의 상호보완적 메커니즘을 통해 평가가 수행되었습니다:

1. **정량적 실험 기반 평가** — [EXP-01](4-Planned-Experiments.md#exp-01-rpi5-avalonia-렌더링-백엔드)~[EXP-05](4-Planned-Experiments.md#exp-05-장시간-24h-실행-안정성)가 정의된 QAS 임계값(지연 예산, 프레임 레이트, RSS 추세)에 대한 Pass/Fail 측정값을 산출했습니다.

2. **자동화된 구조 테스트** — `ViewModelPurityTests`가 빌드 타임에 단방향 의존성 규칙을 강제합니다. `SyntheticDetectorTests`와 `AdverseScenarios` 단위 테스트가 알고리즘 동작을 알려진 합성 입력에 대해 검증합니다([EXP-06](4-Planned-Experiments.md#exp-06-측정-정확도) 1단계).

3. **ADR 기반 문서화된 근거** — 4개의 ADR이 플랫폼 선택 결정([ADR-001](ADR/ADR-001.md), [ADR-002](ADR/ADR-002.md), [ADR-003](ADR/ADR-003.md), [ADR-004](ADR/ADR-004.md))의 근거를 기록하며, 거부된 대안과 이유를 포함합니다.

4. **SAP 트레이드오프 분석** — [EXP-03](4-Planned-Experiments.md#exp-03-gui-실시간-렌더링-디자인-패턴)의 결과 및 분석 섹션이 각 적용 패턴/전술을 SAP 기준으로 명시적으로 평가하며, 무엇을 얻고 무엇을 포기하는지를 기술합니다.

