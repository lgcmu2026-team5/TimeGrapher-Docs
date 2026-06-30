# 2, 3, 4번 Architecture View 발표 가이드

이 문서는 Final Demo 발표에서 2, 3, 4번 다이어그램을 전체 흐름 안에서 어떻게 연결해 설명할지 정리한 간단 가이드이다.

## 한 줄 요약

| View | 설명 관점 | 발표 핵심 |
|---|---|---|
| 2. AnalysisFrame Sequence Diagram | Runtime message order | `AnalysisFrame`이 UI 내부에서 scheduler, router, consumer, renderer로 전달되는 순서 |
| 3. Pipe-and-Filter / Runtime Dataflow | End-to-end dataflow | watch sound가 입력되어 `AnalysisFrame DTO`로 만들어지고 UI graph로 넘어가는 전체 흐름 |
| 4. Module Uses View | Static dependency / change impact | graph 추가나 변경이 Core hot path가 아니라 routing/consumer/renderer 쪽으로 제한되는 구조 |

## 권장 설명 순서

발표 흐름은 다음 순서가 가장 자연스럽다.

```text
Context Diagram
→ 3. Pipe-and-Filter / Runtime Dataflow
→ 2. AnalysisFrame Sequence Diagram
→ 4. Module Uses View
```

이유는 먼저 전체 데이터 흐름을 보여준 뒤, `AnalysisFrame`이 UI 내부에서 어떻게 처리되는지 확대한 다음, 마지막으로 그 구조가 modifiability를 어떻게 지원하는지 static dependency 관점에서 정리할 수 있기 때문이다.

슬라이드 번호 순서 때문에 2번을 먼저 보여줘야 한다면, 2번을 “UI 내부 상세 흐름”으로 소개하고, 3번에서 전체 dataflow로 한 번 zoom-out한 뒤, 4번에서 dependency와 변경 영향으로 정리하면 된다.

## 2. AnalysisFrame Sequence Diagram 설명법

이 그림은 실행 시간에 frame이 어떤 순서로 전달되는지를 보여준다.

발표 핵심은 다음과 같다.

- Core는 graph renderer를 직접 호출하지 않고 `AnalysisFrame DTO`를 event/call parameter로 넘긴다.
- Router는 registered graph consumers에 frame을 전달해 lightweight state/cache를 갱신하게 한다.
- `activeTabId`로 선택된 active consumer만 실제 rendering payload를 준비한다.
- 따라서 모든 graph를 매번 무겁게 render하지 않고, 현재 선택된 graph 중심으로 rendering 비용을 제한한다.

추천 발화:

> 이 Sequence Diagram은 `AnalysisFrame`이 Core에서 UI graph까지 전달되는 실행 순서를 보여줍니다. 모든 consumer가 frame을 관찰하지만, 실제 rendering payload 준비는 active consumer로 제한됩니다.

## 3. Pipe-and-Filter / Runtime Dataflow 설명법

이 그림은 watch sound가 graph로 보이기까지의 전체 처리 흐름을 보여준다.

발표 핵심은 다음과 같다.

- Audio input, shared data, analysis worker, UI graph view의 책임이 분리되어 있다.
- `AnalysisWorker` 내부에서 detector와 analysis 단계가 순차적으로 실행된다.
- 분석 결과는 `AnalysisFrame DTO`라는 data contract로 정리되어 UI 쪽으로 전달된다.
- 이 그림은 strict pipe-and-filter 구현을 주장하기보다 staged dataflow와 responsibility separation을 설명하기 위한 view이다.

추천 발화:

> 이 그림은 watch sound가 입력되어 analysis worker에서 처리되고, 그 결과가 `AnalysisFrame DTO`로 정리되어 UI graph view로 넘어가는 전체 dataflow를 보여줍니다.

## 4. Module Uses View 설명법

이 그림은 같은 구조를 runtime 순서가 아니라 static dependency와 변경 영향 관점에서 보여준다.

발표 핵심은 다음과 같다.

- Uses View의 화살표는 data flow가 아니라 code-level dependency direction이다.
- Core analysis는 graph UI를 직접 사용하지 않고 `AnalysisFrame DTO` 계약만 만든다.
- `Graph Consumer Contract`는 static view 표현이고, sequence diagram의 registered consumers는 이 contract를 구현한 runtime 객체들이다.
- 새 graph를 추가할 때 변경은 주로 routing/catalog, consumer implementation, graph-specific renderer 쪽으로 제한된다.
- 중요한 표현은 “zero-change”가 아니라 “bounded and predictable change”이다.

추천 발화:

> 앞의 Sequence Diagram이 runtime order를 보여줬다면, 이 Uses View는 같은 구조를 dependency와 change impact 관점에서 보여줍니다. 새 graph를 추가할 때 변경은 Core hot path가 아니라 consumer와 renderer 쪽의 예측 가능한 지점으로 제한됩니다.

## QAS 연결

이 세 그림은 주로 Modifiability를 설명하기 위한 묶음이다.

- `AnalysisFrame DTO`는 Core와 UI 사이의 안정적인 data contract 역할을 한다.
- Router와 Graph Consumer Contract는 graph display 추가를 예측 가능한 지점으로 제한한다.
- Graph-specific renderer implementation은 graph별 drawing logic을 분리한다.
- Detection/Metrics hot path는 display-only graph 추가에서 직접 수정되지 않도록 보호된다.

발표에서는 “보장한다”보다 다음 표현이 안전하다.

> 이 구조는 QAS-5 Modifiability를 지원합니다. 새 graph의 변경은 DTO 확장 여부, routing/catalog 등록, consumer 구현, renderer 구현 같은 예측 가능한 지점에 제한됩니다.