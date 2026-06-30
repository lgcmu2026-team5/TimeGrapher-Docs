# TIMEGRAPHER MVVM VIEW – Responsibility Separation

이 뷰는 App 내부에서 View Layer, ViewModel Layer, Model Layer 간의 하향식 단방향 «use» 의존성을 보여주며, 각 컴포넌트의 책임 분리를 나타낸다.

**표기:** 3가지 계층으로 분리하며(View Layer / ViewModel Layer / Model Layer), 회색 상자는 **모듈**(관련 클래스 묶음)이다. 모든 의존성은 *사용하는* 모듈에서 *사용되는* 모듈로 향하는 점선 **«use»** 화살표로 그린다.

![MVVM responsibility flow](../../assets/MVVM.png)

**의존 흐름(«use» 화살표):**

- View Layer의 세 모듈은 `MainWindowViewModel`을 **사용**한다.
- `MainWindowViewModel`은 두 조정 모듈을 **사용**한다.
- 조정 모듈은 Core 모듈을 **사용**하고, `Core.Analysis · Detection`과 `Platform.*`은 결국 `Core.Shared`를 **사용**한다.

**핵심 제약:**

- **단방향 의존:** View Layer → ViewModel Layer → Model Layer. ViewModel은 Avalonia/View 타입을 갖지 않으며(`ViewModelPurityTests`가 잠금), Model(`Core`)은 의존성이 0이라 UI 없이 빌드·테스트된다.
- **바인딩은 의존이 아니라 제어를 역전한다:** 런타임에 UI 갱신은 Model Layer → ViewModel Layer → View Layer로 흐르지만 이는 이벤트·바인딩을 통한 *데이터 흐름*이지 컴파일 의존이 아니므로, «use» 그래프는 비순환·하향을 유지한다.

## Element Catalog

아래 표는 각 요소의 계층, 모듈명, 주요 책임을 정리한다.

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

## Behavior

이 뷰에서는 N/A. 이 요소들의 런타임 상호작용은 [Run Lifecycle Sequence View](5-4-Run-Lifecycle-Sequence-View.md)(호출 순서)와 [Run Lifecycle State Machine View](5-5-Run-Lifecycle-State-Machine-View.md)(제어 상태)에서 다룬다.

## Related ADRs

- [ADR-003 — App 화면 구조에 MVVM 패턴 채택](../ADR/ADR-003.md): 이 ADR에 기록된 결정을 위 구조가 실현한다.

**설계 근거(요약)**

- **결정**: MVC 스타일의 거대한 `MainWindow`에 섞여 있던 UI 상태·명령·실행 오케스트레이션을 MVVM의 세 역할로 분리했다. View는 렌더링/플랫폼/세션 배선, ViewModel은 바인딩 가능한 상태와 명령, `RunCommandService`는 State Pattern 기반 실행 상태 머신을 담당한다.
- **근거**: 관심사 분리로 수정용이성(Modifiability)·시험용이성(Testability)을 높인다. ViewModel은 도메인을 직접 호출하지 않아 윈도 없이 단위 테스트가 가능하다. 서비스↔View 결합은 명령 본문용 `IRunCommandRunner`와 서비스→View 콜백용 `IRunCommandOperations`로 역전한다.
- **기각한 대안**: View가 `Func`/`Action` 델리게이트로 명령 본문을 ViewModel에 주입하던 MVC 잔재 방식은 결합도를 높인다고 판단되어 기각되었다. 명령 본문을 ViewModel 쪽 명령 경로에 두도록 `IRunCommandRunner` 주입 방식으로 대체했다.
- **의도된 예외**: Playback 자연 종료와 애플리케이션 종료는 worker 완료 또는 창 닫힘 콜백에서 시작되므로 View가 직접 처리하고 `RunCommandService`를 우회한다.

## Related views

- [Module Uses View](5-2-Module-Uses-View.md) — 이 App 역할들이 속한 프로젝트 수준 모듈.
- [Run Lifecycle Sequence View](5-4-Run-Lifecycle-Sequence-View.md) — 이 계층들을 가로지르는 런타임 호출 흐름.
- [Run Lifecycle State Machine View](5-5-Run-Lifecycle-State-Machine-View.md) — `RunCommandService`가 오케스트레이션하는 실행 제어 상태.
