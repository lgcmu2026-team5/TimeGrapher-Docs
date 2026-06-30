# TimeGrapher Layered View - Dependency Rules

이 뷰는 어떤 레이어가 어떤 하위 레이어를 사용할 수 있는지 보여준다. 나머지 뷰 세트를 지배하는 의존 규칙을 정의하며, 구현 수준의 실제 모듈 의존성은 [Module Uses View](5-2-Module-Uses-View.md)에서 다룬다.

## Primary Presentation

![TimeGrapher layered view](../../assets/LAYER.png)

## Element Catalog

**핵심 개념**

- **Direct lower-layer use**: 의존 방향이 아래로 유지되는 경우 상위 레이어는 필요한 하위 레이어를 직접 사용할 수 있다.
- **Upward Dependency Forbidden**: 의존성 흐름은 아래 방향만 허용한다(App → Core, Core → App 금지).
- **Sidecar Layer**: 공통 외부 유틸리티와 프레임워크는 허용된 레이어가 접근할 수 있는 sidecar 레이어에 둔다.

**레이어**

- **Entry Points & UI**: App(Avalonia UI), Verify(console), Test Suites.
- **Platform Adapters**: WindowsAudio(NAudio), LinuxAudio(PipeWire/ALSA tools).
- **Portable Core**: `TimeGrapher.Core`(analysis, detection, metrics – 외부 의존성 없음).
- **External dependency – External Tech**(sidecar): Avalonia, ScottPlot, NAudio, xUnit.

**의존 규칙**

```text
App → Platform Adapters
App → Core
Platform Adapters → Core
App & Platform Adapters → External Tech
Core → Nothing (zero dependencies)
```

## Behavior

N/A. 이 뷰는 정적 권한 뷰다. 이 레이어들 간의 런타임 상호작용은 [Run Lifecycle Sequence View](5-4-Run-Lifecycle-Sequence-View.md)와 [Run Lifecycle State Machine View](5-5-Run-Lifecycle-State-Machine-View.md)에서 다룬다.

## Related ADRs

- [ADR-004 — AI 활용, TDD 지원, 팀 협업을 위한 App, Test, Verify 모듈 구조 분리](../ADR/ADR-004.md): 레이어 경계가 강제하는 모듈 분리의 근거.
- [ADR-001 — UI 프레임워크를 Avalonia UI + .NET + C# 로 전환](../ADR/ADR-001.md): sidecar 레이어에 두는 External Tech를 정의한다.

## Related views

- [Module Uses View](5-2-Module-Uses-View.md) — 이 권한 규칙을 실제 모듈 간 «use» 의존성으로 구체화한다.
- [MVVM View](5-3-MVVM-View.md) — App 내부에 하향 단방향 규칙을 적용한다.
