# AnalysisFrame Module Uses View Speaker Notes

![AnalysisFrame module uses view](<4-ForPresentation_AnalysisFrame-Module-Uses-View.drawio.png>)

Draw.io source: [4-ForPresentation_AnalysisFrame-Module-Uses-View.drawio](<4-ForPresentation_AnalysisFrame-Module-Uses-View.drawio>)

Rendered preview: [4-ForPresentation_AnalysisFrame-Module-Uses-View.drawio.png](<4-ForPresentation_AnalysisFrame-Module-Uses-View.drawio.png>)

Archived source: [backup/4-AnalysisFrame-Module-Uses-View.drawio](<backup/4-AnalysisFrame-Module-Uses-View.drawio>)

## Slide Purpose

이 그림은 `AnalysisFrame` 기반 graph rendering 구조를 **Module Uses View** 관점에서 보여준다.

앞의 Sequence Diagram이 runtime message order를 보여준다면, 이 Uses View는 같은 구조를 **code-level dependency 방향**과 **변경 영향 범위**로 다시 보여준다.

핵심 메시지는 다음과 같다.

- Core analysis는 graph UI를 직접 사용하지 않고 `AnalysisFrame DTO` 계약만 만든다.
- App routing module은 frame을 UI routing 흐름으로 넘기고, graph consumer contract를 통해 graph display 쪽과 연결된다.
- Graph display module은 selected graph renderer와 graph-specific renderer implementations에 변경을 모은다.
- Graph 추가나 display 변경이 Detection/Metrics hot path로 번지는 것을 줄인다.

## How To Read This View

- 화살표는 runtime data flow가 아니라 `<<uses>> dependency`를 의미한다.
- 화살표 방향은 “사용하는 쪽에서 사용되는 쪽”으로 향한다.
- 박스 안의 이름은 class 목록이 아니라 발표용 architecture role이다.
- `Graph Consumer Contract`는 static view 표현이다. Sequence Diagram의 `Registered Graph Consumers`는 이 contract를 구현한 runtime 객체들로 설명하면 된다.

## Dependency Interpretation

1. `Core Analysis Worker`는 detection과 metrics 결과를 `AnalysisFrame DTO`로 만든다.
2. `AnalysisFrame DTO`는 Core와 UI graph rendering 사이의 shared data contract이다.
3. `Frame Render Scheduler`는 최신 frame을 UI routing 흐름으로 넘기는 역할을 한다.
4. `AnalysisFrame Router`는 active tab 기준으로 graph consumer 쪽 routing을 담당한다.
5. `Graph Consumer Contract`는 router와 graph display 구현 사이의 정적 접점이다.
6. `Selected Graph Renderer`는 active graph payload를 실제 화면 표현으로 넘긴다.
7. `Graph-specific Renderer Implementations`는 각 graph별 drawing logic을 담는다.
8. `External modules (Avalonia UI)`는 내부 변경 대상이 아니라 UI toolkit 의존성을 축약해서 표시한 것이다.

## Why `Graph Consumer Contract` Is Used Here

Sequence Diagram에서는 `Registered Graph Consumers`라고 표현했다. 그것은 runtime에 등록된 consumer 객체들의 흐름을 보여주기 위한 표현이다.

하지만 Uses View는 static/module view이기 때문에 runtime collection을 그대로 그리기보다, router가 의존하는 정적 계약인 `Graph Consumer Contract`로 표현하는 것이 더 적합하다.

발표에서는 이렇게 연결하면 된다.

> Sequence Diagram에서 보였던 registered graph consumers는 Uses View의 `Graph Consumer Contract`를 구현한 runtime 객체들입니다.

## Modifiability Point

새 graph를 추가할 때 변경 범위는 대체로 다음 위치로 제한된다.

| Area | Expected Change |
|---|---|
| App routing module | 새 graph consumer를 routing/catalog에 연결한다. |
| Graph Consumer Contract | 기존 contract를 구현한다. 보통 contract 자체는 유지한다. |
| Graph display module | selected renderer와 graph-specific renderer implementation을 추가하거나 수정한다. |
| AnalysisFrame DTO | 새 graph가 기존 payload로 표현되지 않을 때만 확장한다. |
| Core Analysis Worker | 새 payload 생산이 필요할 때만 제한적으로 수정한다. |

중요한 표현은 “zero-change”가 아니라 **bounded and predictable change**이다. 새 display를 추가할 때 Detection/Metrics hot path를 직접 수정하지 않는 것이 이 view에서 강조할 점이다.

## Presenter Script

이 그림은 앞의 sequence diagram과 같은 구조를 static dependency 관점에서 보여줍니다.

왼쪽의 Core analysis module은 분석 결과를 만들고 `AnalysisFrame DTO`로 정리합니다. 중요한 점은 Core가 graph renderer나 tab UI를 직접 사용하지 않는다는 것입니다. Core는 stable DTO contract를 만들고, UI 쪽은 이 DTO를 읽어 graph display를 구성합니다.

오른쪽의 App routing module은 frame이 UI routing 흐름으로 들어오는 부분입니다. Frame Render Scheduler가 최신 frame을 넘기고, AnalysisFrame Router가 active tab 기준으로 graph consumer 쪽 흐름을 결정합니다. Uses View는 static view이기 때문에 runtime에 등록된 여러 consumer를 직접 그리지 않고, `Graph Consumer Contract`로 표현했습니다.

아래의 Graph display module은 실제 display 변경이 모이는 영역입니다. Selected Graph Renderer는 active graph payload를 화면 표현으로 넘기고, Graph-specific Renderer Implementations는 각 graph별 drawing logic을 담습니다. 따라서 새 graph를 추가할 때 변경은 주로 routing/catalog, consumer implementation, graph-specific renderer 쪽으로 제한됩니다.

External modules는 내부 아키텍처 변경 대상이 아니라 Avalonia UI 같은 외부 UI 기술 의존성을 표시한 것입니다.

이 view의 결론은 graph display 확장이 Core analysis hot path와 직접 섞이지 않도록 dependency boundary를 둔다는 점입니다.

## If Asked

**Q. Sequence Diagram과 무엇이 다른가?**  
Sequence Diagram은 runtime message order를 보여준다. Uses View는 code-level dependency 방향과 변경 영향 범위를 보여준다.

**Q. 왜 `Registered Graph Consumers`를 Uses View에 그대로 쓰지 않았나?**  
그 표현은 runtime에 등록된 객체 목록처럼 보인다. Uses View는 static/module view이므로 router가 의존하는 `Graph Consumer Contract`로 표현하는 것이 더 정확하다.

**Q. 화살표가 data flow와 반대로 보일 수 있는데 괜찮은가?**  
괜찮다. Uses View의 화살표는 data flow가 아니라 dependency direction이다. 예를 들어 runtime에서는 Core가 frame을 UI로 넘기지만, code dependency 관점에서는 UI code가 `AnalysisFrame DTO` type을 사용하므로 DTO contract에 의존한다.

**Q. 이 view가 설명하는 QAS는 무엇인가?**  
주로 Modifiability이다. 새 graph나 display 변경이 consumer/renderer/routing 쪽의 예측 가능한 지점에 제한되고, Detection/Metrics hot path로 번지는 것을 줄이는 구조를 설명한다.

## One-Sentence Summary

이 Uses View는 `AnalysisFrame DTO`와 `Graph Consumer Contract`를 중심으로 Core analysis와 graph-specific rendering dependency를 분리하고, graph display 변경을 UI rendering 쪽의 예측 가능한 지점으로 제한하는 구조를 보여준다.