# 타임그래퍼 통합 아키텍처 뷰 (TIMEGRAPHER UNIFIED ARCHITECTURAL VIEW)

> 이 뷰는 TimeGrapher 시스템의 정적 모듈 의존성, MVVM 계층 구조, 실행 수명 주기 동작(상태 전이 및 호출 순서), 그리고 외부 배포 환경을 단일 컨텍스트로 요약하여 보여줍니다.

## 1. Primary Presentation

아래 서브섹션에서 MVVM 구조와 Module Uses 뷰를 각각 제시한다.

- **1-1. TIMEGRAPHER MVVM VIEW – Responsibility Separation:** View Layer, ViewModel Layer, Model Layer 간의 하향식 단방향 의존성(«use») — 각 컴포넌트의 책임 분리를 나타낸다.
- **1-2. TIMEGRAPHER MODULE USES VIEW – Actual Dependencies & Internal Decomposition:** 프로젝트 수준(App, Core, 플랫폼 어댑터) 및 Core 내부 서브모듈 간의 구문적(syntactic) 사용 의존성을 나타낸다.

### 1-1. TIMEGRAPHER MVVM VIEW – Responsibility Separation

**표기:** 계층마다 색을 칠하고(View Layer / ViewModel Layer / Model Layer), 회색 상자는 **모듈**(관련 클래스 묶음)이다. 모든 의존성은 *사용하는* 모듈에서 *사용되는* 모듈로 향하는 점선 **«use»** 화살표로 그린다.

**의존 흐름(«use» 화살표):**
- View Layer의 세 모듈은 `MainWindowViewModel`을 **사용**한다.
- `MainWindowViewModel`은 두 조정 모듈을 **사용**한다.
- 조정 모듈은 Core 모듈을 **사용**하고, `Core.Analysis · Detection`과 `Platform.*`은 결국 `Core.Shared`를 **사용**한다.

**핵심 제약:**
- **단방향 의존:** View Layer → ViewModel Layer → Model Layer. ViewModel은 Avalonia/View 타입을 갖지 않으며(`ViewModelPurityTests`가 잠금), Model(`Core`)은 의존성이 0이라 UI 없이 빌드·테스트된다.
- **바인딩은 의존이 아니라 제어를 역전한다:** 런타임에 UI 갱신은 Model Layer → ViewModel Layer → View Layer로 흐르지만 이는 이벤트·바인딩을 통한 *데이터 흐름*이지 컴파일 의존이 아니므로, «use» 그래프는 비순환·하향을 유지한다.

![MVVM responsibility flow](../assets/MVVM.png)

### 1-2. TIMEGRAPHER MODULE USES VIEW – Actual Dependencies & Internal Decomposition

App, Core, platform adapters, Verify 사이의 module uses 관계를 보여준다. 여기서 platform adapters는 그림의 `WindowsAudio`와 `LinuxAudio`를 의미하며, OS-specific audio dependency가 `TimeGrapher.Core`로 들어오지 않도록 분리된 modules이다.

![Module Uses View - Project-level modules](../assets/module-uses-project.ko.svg)

- `TimeGrapher.App` uses `TimeGrapher.Core`.
- `TimeGrapher.App` conditionally uses `WindowsAudio` or `LinuxAudio`.
- `WindowsAudio`와 `LinuxAudio`는 `TimeGrapher.Core`를 사용한다.
- `TimeGrapher.Verify` uses `TimeGrapher.Core`.
- `TimeGrapher.Core`는 App, Verify, platform adapters를 사용하지 않는다.

### Core-Internal Module Uses

`TimeGrapher.Core`를 주요 domain modules로 분해하고, 각 module이 어떤 Core 내부 module을 사용하는지 보여준다.

![Module Uses View - Core internal modules](../assets/module-uses-core.ko.svg)

| Module | 책임 | Uses |
|---|---|---|
| `Analysis` | 분석 worker와 결과 frame 생성을 조정한다. | `Detection`, `Detection.Scoring`, `Metrics`, `Imaging`, `AudioIo`, `Shared` |
| `Detection` | watch signal event와 sync 상태를 검출한다. | `Shared` |
| `Detection.Scoring` | candidate event의 채택/거절 기준을 제공한다. | `Detection` |
| `Metrics` | rate, amplitude, beat error를 계산한다. | `Shared` |
| `Imaging` | 시계 소리의 시각화용 sound image와 시간-주파수 spectrogram 데이터를 만든다. | `Shared` |
| `AudioIo` | 오디오 녹음을 WAV 파일로 저장하는 writer 계약과 구현을 제공한다. | `Shared` |
| `Sim` | synthetic input source를 제공한다. | `Shared` |
| `Shared` | Core 내부 모듈들이 함께 쓰는 공통 데이터 타입과 계약을 제공한다. | 없음 |

---

## 2. Element Catalog

아래 표는 Primary Presentation에서 참조한 각 요소의 계층, 모듈명, 주요 책임을 정리한다.

| 계층 | 모듈 | 하는 일 |
|---|---|---|
| **View Layer** | Main Window | 메인 창 — 전체 레이아웃·컨트롤, 창 열고 닫기. |
| | Graph Tabs Window | 측정 탭을 호스팅하고 분석 프레임을 활성 탭으로 보낸다. |
| | Graph Rendering | 프레임 데이터로 그래프와 수치 표시를 그린다. |
| **ViewModel Layer** | MainWindowViewModel | View가 바인딩하는 UI 상태·바인딩 속성을 보유하고 커맨드를 노출한다. |
| | Run · session coordination | 분석을 시작·정지·일시정지하고, 시작부터 끝까지 진행을 관리한다(`RunCommandService`, `RunSessionController`). |
| | Input · display coordination | 오디오 입력 장치를 열거·선택하고 표시 상태를 준비한다(`AudioDeviceController`). |
| **Model Layer** | Core.Analysis · Detection | 분석 엔진 — tick/tock 비트를 검출하고 BPH·sync를 계산한다. |
| | Core.Metrics · AudioIo · Imaging | 일오차/진폭/비트에러 계산, WAV 입출력, 사운드 이미지 생성. |
| | Core.Shared | 모든 서브모듈이 공유하는 공통 계약·데이터 타입(프레임, 버퍼). 다른 모듈에 의존하지 않음. |
| | Platform.WindowsAudio · LinuxAudio | OS 계층에서 라이브 오디오를 캡처한다(Windows WASAPI, Linux ALSA/PipeWire). |

---

## 3. Behavior

이 섹션은 1번 항목에서 정의한 구조적 요소들이 런타임에 어떻게 상호작용하는지 보완 설명합니다.

### 3-1. TIMEGRAPHER RUN LIFECYCLE C&C VIEW – Measurement Analysis Loop

User → View → ViewModel → RunCommandService → Model(RunSessionController 및 Workers)로 이어지는 객체 간 호출 흐름을 다룬다. 측정 분석 루프는 반복 주기를 포함해 가장 세분화가 필요하므로 Level 2 자식 뷰로 분리한다.

| Page | 내용 |
| --- | --- |
| Level 1 | 실행 수명주기 개요 |
| Level 2 | Level 1의 `ref`에서 펼친 측정 중 분석 반복 흐름 |

**Level 1 · 실행 수명주기 개요**

Level 1은 실행 수명주기 전체를 한 장에 담는다. 세부 분석 반복은 `ref`로 접고 Level 2에서 펼친다.

![Level 1 실행 수명주기 개요](../assets/Sequence-run-lifecycle-level1.svg)

**Level 2 · 측정 중 분석 반복 흐름**

Level 2는 Level 1의 측정 `ref`를 펼친 뷰다. 반복 조건과 시간 제약은 다이어그램 안에 표시한다.

![Level 2 측정 중 분석 반복 흐름](../assets/Sequence-run-lifecycle-level2.svg)

**표기**

공통 표기는 아래 범례 이미지를 따른다.

![UML 시퀀스 다이어그램 표기 범례](../assets/Sequence-run-lifecycle-notation.svg)

라벨 규칙: User↔시스템 화살표는 사용자의 의도/행위, 객체 간 화살표는 오퍼레이션 시그니처다.

**Lifeline 카탈로그**

각 lifeline의 역할을 정리한다. `MasterAudioBuffer`와 `Core pipeline`은 Level 2에서만 등장한다.

| Lifeline | MVVM 레이어 | 책임 |
| --- | --- | --- |
| User | (actor) | 사용자 |
| View (`MainWindow`) | View | UI 이벤트 수신, 렌더링·스레드 마샬링, `RunSessionController`로 입력·분석 worker 수명 구동, 서비스의 `IRunCommandOperations` 콜백 포트 구현 |
| ViewModel (`MainWindowViewModel`) | ViewModel | `PlayPauseCommand`/`ResetCommand`와 관찰 가능한 `RunState`/`StatusText`를 노출한다. 도메인을 직접 호출하지 않는다. |
| RunCommandService | App service (State Pattern) | 시작/일시정지/정지 오케스트레이션, ViewModel 상태 갱신, `IRunCommandOperations`를 통한 View 호출 |
| RunSessionController | Model boundary | 실행 세션 token, 입력 worker attach/stop, 분석 worker 수명 관리 |
| Input worker | Model | Live=`AudioCaptureWorker`, Playback=`PlaybackWorker`, Simulation=`SimWorker` |
| MasterAudioBuffer | Model | 입력↔분석 공유 오디오 ring buffer |
| AnalysisWorker | Model | 분석 스레드 |
| Core pipeline | Model | Detection / Metrics / Projectors |

### 3-2. TIMEGRAPHER RUN LIFECYCLE BEHAVIOR VIEW – Control State Transitions

Stopped, Starting, Running, Paused, Stopping, StopFailed 상태 간의 전이 규칙을 정의한다.

![Run 상태 머신](../assets/Statemachine-run-lifecycle.svg)

**범위**

이 상태 머신의 기준 상태 값은 `RunUiState`다. `RunCommandService`는 현재 `RunUiState`에 맞는 상태 객체(`StoppedState`, `RunningState` 등)를 선택하고, 각 상태 객체가 `StartAsync`, `TogglePause`, `StopRunWithoutReset`, `StopRunAndRefreshDevices`, `Reset` 명령을 허용하거나 무시한다.

실제 worker 생성·정지·recording close·장치 복원은 `IRunCommandOperations` 포트를 통해 View 쪽 구현으로 위임된다. 따라서 이 뷰는 "어떤 상태로 넘어가는가"를 표현하고, 입력 worker/분석 worker의 상세 호출 순서는 시퀀스 뷰에 둔다.

**상태**

| State | 코드 기준 의미 |
| --- | --- |
| `Stopped` | 측정 중이 아닌 기본 상태. 시작 전 설정을 바꿀 수 있고, `StartAsync`가 허용된다. |
| `Starting` | 시작 절차 진행 중. 중복 시작·정지·리셋 명령은 무시된다. |
| `Running` | 입력 worker와 분석 worker가 동작 중인 상태. Pause 또는 stop intent가 허용된다. |
| `Paused` | worker는 살아 있고 입력만 pause gate에 걸린 상태. Resume 또는 Reset이 허용된다. |
| `Stopping` | stop intent를 수행 중인 상태. 정지가 아직 끝나지 않은 경우 Stop/Reset 재시도 표면이 유지된다. |
| `StopFailed` | worker stop timeout 또는 recording close 실패로 완전 정지에 실패한 상태. Stop/Reset 재시도로 같은 pending intent를 다시 수행한다. |

**표기**

상태 머신 공통 표기는 아래 범례 이미지를 따른다.

![UML 상태 머신 표기 범례](../assets/Statemachine-run-lifecycle-notation.svg)

---

## 4. TIMEGRAPHER SYSTEM DEPLOYMENT VIEW – Hardware & External Signal Path

시스템이 상호작용하는 외부 엔티티와 경계를 보여준다. 아래 배포 뷰는 소프트웨어 전달 경로와 런타임 오디오 신호 경로를 함께 나타낸다.

![배포 뷰 다이어그램](../assets/deployment-view-detailed.svg)

**배포 Target(릴리스):** <https://github.com/lgcmu2026-team5/TimeGrapher-Net/releases>

**배포 흐름 (3단계):**

1. **개발·공유** — 다수 개발자가 각 PC에서 C#/.NET으로 개발하고, `git push`로 Git 서버에 코드를 모은다.
2. **검증·생성** — Git 서버는 push된 사항에 대해 CI/CD로 build/test를 검증하고, `tag v*`에서 타겟별(Windows / Raspberry Pi) 배포 Target을 생성한다.
3. **배포·설치** — 생성된 Target을 Git 서버 네트워크(LAN)를 통해 연결된 각 노드로 배포·설치한다.

**외부 신호 경로:** 런타임에 기계식 시계의 음향 비트 신호가 마이크/픽업을 거쳐 전기신호로 변환되고, USB 오디오로 각 노드의 오디오 입력에 들어간다. 이는 소프트웨어 배포 경로와는 별도의 독립적인 입력 경로다.

---

## 5. Variability Guide

**운영체제 및 배포 타겟:** OS 환경에 따라 `WindowsAudio` 또는 `LinuxAudio` 어댑터를 조건부로 사용하며, 배포 타겟 역시 Windows와 Raspberry Pi용으로 나뉘어 빌드됩니다.

**입력 소스:** 런타임 `CurrentMode` 값에 따라 Live(실제 캡처), Playback(재생), Simulation(합성 신호) 워커 중 하나로 동작이 분기됩니다.

---

## 6. Design Rationale

- **결정**: MVC 스타일의 거대한 `MainWindow`에 섞여 있던 UI 상태·명령·실행 오케스트레이션을 MVVM의 세 역할로 분리했다. View는 렌더링/플랫폼/세션 배선, ViewModel은 바인딩 가능한 상태와 명령, RunCommandService는 State Pattern 기반 실행 상태 머신을 담당한다.
- **근거**: 관심사 분리로 수정용이성(Modifiability)·시험용이성(Testability)을 높인다. ViewModel은 도메인을 직접 호출하지 않아 윈도 없이 단위 테스트가 가능하다. 서비스↔View 결합은 명령 본문용 `IRunCommandRunner`와 서비스→View 콜백용 `IRunCommandOperations`로 역전한다.
- **기각한 대안**: View가 `Func`/`Action` 델리게이트로 명령 본문을 ViewModel에 주입하던 MVC 잔재 방식은 결합도를 높인다고 판단되어 기각되었다. 명령 본문을 ViewModel 쪽 명령 경로에 두도록 `IRunCommandRunner` 주입 방식으로 대체했다.
- **의도된 예외**: Playback 자연 종료와 애플리케이션 종료는 worker 완료 또는 창 닫힘 콜백에서 시작되므로 View가 직접 처리하고 `RunCommandService`를 우회한다.

---

## 7. Related Views

TIMEGRAPHER LAYERED VIEW는 Primary Presentation에서 보여주는 모든 모듈 의존성을 지배하는 권한 규칙을 정의한다. 허용되는 의존 방향과 계층 구조를 명시하여 전체 아키텍처의 근간을 이룬다.

### TIMEGRAPHER LAYERED VIEW – Permission-Based Architecture

**목적:** 어떤 레이어가 어떤 하위 레이어를 사용할 수 있는지 보여준다. 구현 세부사항이 아니라 허용되는 의존성을 정의한다.

**핵심 개념:**
- **Relaxed Layering**: 상위 레이어는 중간 레이어를 건너뛰고 필요한 하위 레이어를 직접 사용할 수 있다.
- **Upward Dependency Forbidden**: 의존성 흐름은 아래 방향만 허용한다(App → Core, Core → App 금지).
- **Sidecar Layer**: 공통 외부 유틸리티와 프레임워크는 허용된 레이어가 접근할 수 있는 sidecar 레이어에 둔다.

**레이어:**
1. **Layer 1 – Entry Points & UI**: App(Avalonia UI), Verify(console), Test Suites
2. **Layer 2 – Platform Adapters**: WindowsAudio(NAudio), LinuxAudio(PipeWire/ALSA tools)
3. **Layer 3 – Portable Core**: `TimeGrapher.Core`(analysis, detection, metrics – 외부 의존성 없음)
- **External dependency – External Tech**: Avalonia, ScottPlot, NAudio, xUnit

**권한 규칙:**
```text
App → Platform Adapters
App → Core
Platform Adapters → Core
App & Platform Adapters → External Tech
Core → Nothing (zero dependencies)
```

![alt text](../assets/LAYER.png)
