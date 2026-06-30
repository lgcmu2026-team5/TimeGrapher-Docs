# TimeGrapher Run Lifecycle Sequence View - Measurement Analysis Loop

이 런타임 뷰는 User → View → ViewModel → `RunCommandService` → Model(`RunSessionController` 및 Workers)로 이어지는 객체 간 호출 흐름을 다룬다. [MVVM View](5-3-MVVM-View.md)의 정적 구조를, 그 요소들이 시간에 따라 어떻게 상호작용하는지 보여줌으로써 보완한다. 측정 분석 루프는 반복 주기를 포함해 가장 세분화가 필요하므로 참조된 sequence diagram에서 확장한다.

**표기:** UML sequence diagram.

## Primary Presentation

**실행 수명주기 개요**는 실행 수명주기 전체를 하나의 sequence diagram에 담는다. 세부 분석 반복은 `ref`로 접고 참조된 다이어그램에서 펼친다.

![실행 수명주기 개요](../../assets/Sequence-run-lifecycle-level1.svg)

## Element Catalog

각 lifeline의 역할을 정리한다. `MasterAudioBuffer`와 `Core pipeline`은 참조된 측정 분석 다이어그램에서만 등장한다.

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

**가변성 — 입력 소스:** 런타임 `CurrentMode` 값에 따라 Live(실제 캡처), Playback(재생), Simulation(합성 신호) 워커 중 하나로 동작이 분기된다.

## Behavior

**측정 중 분석 반복 흐름**은 overview diagram의 측정 `ref`를 펼친 뷰다. 반복 조건과 시간 제약은 다이어그램 안에 표시한다.

![측정 중 분석 반복 흐름](../../assets/Sequence-run-lifecycle-level2.svg)

라벨 규칙: User↔시스템 화살표는 사용자의 의도/행위, 객체 간 화살표는 오퍼레이션 시그니처다.

## Related ADRs

- [ADR-002 — Worker-Level Partial Pipe-and-Filter 적용](../ADR/ADR-002.md): 루프에 나타나는 단방향 분석 파이프라인과 입력↔분석 공유 버퍼의 근거.
- [ADR-003 — App 화면 구조에 MVVM 패턴 채택](../ADR/ADR-003.md): 이 시퀀스를 구동하는 `RunCommandService` State Pattern의 근거.

## Related views

- [Run Lifecycle State Machine View](5-5-Run-Lifecycle-State-Machine-View.md) — 이 시퀀스가 오가는 제어 상태.
- [MVVM View](5-3-MVVM-View.md) — 위 lifeline들의 정적 계층 구조.
- [Worker Pipeline View](5-7-Worker-Pipeline-View.md) — 측정 분석 루프 뒤의 worker/queue 구조.
