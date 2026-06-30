# TimeGrapher Architecture Views

> TimeGrapher의 아키텍처 뷰 세트다. 각 뷰는 별도 파일로 분리되어 있으며 모두 동일한 [architecture view template](https://github.com/pmerson/architecture-view-template)을 따른다: **Primary Presentation → Element Catalog → Behavior → Related ADRs → Related views**.

## 뷰 목록

| # | 뷰 | 보여주는 것 |
|---|------|---------------|
| 5-1 | [Layered View](5-Architecture-Views/5-1-Layered-View.md) | 레이어 의존 규칙 — 어떤 레이어가 어떤 하위 레이어를 사용할 수 있는가. |
| 5-2 | [Module Uses View](5-Architecture-Views/5-2-Module-Uses-View.md) | 프로젝트 모듈 간 실제 «use» 의존성과 Core 내부 분해. |
| 5-3 | [MVVM View](5-Architecture-Views/5-3-MVVM-View.md) | View / ViewModel / Model 책임 분리와 단방향 의존. |
| 5-4 | [Run Lifecycle Sequence View](5-Architecture-Views/5-4-Run-Lifecycle-Sequence-View.md) | 실행 수명주기와 측정 분석 루프의 런타임 호출 순서. |
| 5-5 | [Run Lifecycle State Machine View](5-Architecture-Views/5-5-Run-Lifecycle-State-Machine-View.md) | 제어 상태 전이(Stopped → Running ⇄ Paused → Stopping → StopFailed). |
| 5-6 | [Deployment View](5-Architecture-Views/5-6-Deployment-View.md) | 런타임 하드웨어 노드, 배포된 앱, 외부 신호 경로. |
| 5-7 | [Worker Pipeline View](5-Architecture-Views/5-7-Worker-Pipeline-View.md) | worker-level Pipe-and-Filter 런타임 구조와 선택적 TinyML signal-quality 경로. |

## 뷰 분류

- **모듈 뷰(정적 구조):** Layered View, Module Uses View, MVVM View.
- **런타임 / 동작 뷰:** Run Lifecycle Sequence View, Run Lifecycle State Machine View, Worker Pipeline View.
- **배포 뷰:** Deployment View.

## 읽는 순서

근간이 되는 의존 규칙을 보려면 **Layered View**부터 시작하고, 이어서 그것을 실현하는 정적 구조인 **Module Uses View**와 **MVVM View**를 본다. **Run Lifecycle**과 **Worker Pipeline** 뷰는 런타임 동작을, **Deployment View**는 물리/런타임 인프라를 보여준다. 각 뷰의 *Related views* 섹션은 이웃 뷰로, *Related ADRs* 는 그 뷰를 뒷받침하는 결정으로 연결된다.
