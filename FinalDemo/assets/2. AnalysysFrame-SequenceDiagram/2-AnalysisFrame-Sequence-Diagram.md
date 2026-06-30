# AnalysisFrame Sequence Diagram Speaker Notes

![AnalysisFrame sequence diagram](<2. ForPresentation_AnalysisFrame sequence diagram.drawio.png>)

Draw.io source: [2. ForPresentation_AnalysisFrame sequence diagram.drawio](<2. ForPresentation_AnalysisFrame sequence diagram.drawio>)

Rendered preview: [2. ForPresentation_AnalysisFrame sequence diagram.drawio.png](<2. ForPresentation_AnalysisFrame sequence diagram.drawio.png>)

Related detailed source: [backup/2. AnalysisFrame sequence diagram.drawio](<backup/2. AnalysisFrame sequence diagram.drawio>)

## Slide Purpose

이 그림은 `AnalysisFrame`이 Core 분석 결과에서 UI graph rendering까지 전달되는 **runtime message order**를 보여주는 Sequence Diagram이다.

핵심 메시지는 다음과 같다.

- Core는 graph renderer를 직접 호출하지 않고 `AnalysisFrame DTO`를 event/call parameter로 전달한다.
- Router는 등록된 graph consumer들에게 frame을 전달해 가벼운 state/cache를 갱신하게 한다.
- 실제 rendering payload 준비와 drawing은 현재 선택된 active graph 쪽으로 제한된다.

## What This View Shows

1. `Core Analysis Worker`가 분석 결과를 `AnalysisFrame DTO`로 묶는다.
2. frame은 `AnalysisFrameReady(frame)` 같은 event/call parameter로 scheduler에 전달된다.
3. `Frame Render Scheduler`는 최신 frame을 UI routing 흐름으로 넘긴다.
4. `AnalysisFrame Router`는 모든 registered graph consumer에게 frame을 관찰하게 한다.
5. 각 consumer는 필요한 lightweight state/cache만 갱신한다.
6. `activeTabId`로 선택된 active consumer만 selected graph payload를 준비한다.
7. selected graph renderer가 payload를 실제 graph view로 렌더링한다.

## Component Roles

| Component | Role | Presentation Point |
|---|---|---|
| Core Analysis Worker | 분석 결과 생산 | Core는 graph renderer를 직접 알지 않고 `AnalysisFrame DTO`만 발행한다. |
| Frame Render Scheduler | latest-frame handoff / UI dispatch | 분석 흐름과 UI rendering 흐름 사이에서 최신 frame 중심으로 전달한다. |
| AnalysisFrame Router | graph routing control | frame을 graph consumer들에게 전달하고 active graph를 선택한다. |
| Registered Graph Consumers | runtime에 등록된 graph consumer들 | 모든 consumer가 frame을 관찰하지만, 기본 작업은 lightweight update에 머문다. |
| Active Graph Consumer | 현재 선택된 tab의 consumer | 실제 rendering을 위한 selected graph payload를 준비한다. |
| Selected Graph Renderer | graph view rendering | 준비된 payload를 plot/image 같은 실제 화면 표현으로 변환한다. |

## Presenter Script

이 Sequence Diagram은 `AnalysisFrame`이 Core에서 UI graph까지 전달되는 실행 순서를 보여줍니다.

먼저 Core Analysis Worker가 detection과 metrics 결과를 하나의 `AnalysisFrame DTO`로 묶습니다. 중요한 점은 Core가 특정 graph renderer를 직접 호출하지 않는다는 것입니다. Core는 안정적인 DTO 계약만 발행하고, 어떤 graph를 어떻게 보여줄지는 UI 쪽 routing과 rendering 구조가 담당합니다.

그 다음 Frame Render Scheduler가 최신 frame을 UI route로 넘깁니다. 이 단계는 분석 thread와 UI rendering 흐름을 분리하는 역할을 합니다. UI가 모든 frame을 무조건 무겁게 렌더링하는 대신, 최신 frame 중심으로 화면 갱신이 일어나도록 흐름을 제어합니다.

Router는 등록된 graph consumer들에게 frame을 전달합니다. 여기서 모든 consumer가 frame을 보지만, 이 작업은 실제 drawing이 아니라 lightweight state/cache update입니다. 예를 들어 inactive graph도 최신 metadata나 history 상태를 유지할 수 있습니다.

마지막으로 `activeTabId`에 의해 선택된 active consumer만 selected graph payload를 준비하고, selected graph renderer가 실제 graph view를 그립니다. 따라서 graph가 늘어나도 Core hot path를 직접 건드리지 않고, consumer와 renderer 쪽 변경으로 graph display를 확장할 수 있습니다.

## Relation To Other Views

- Pipe-and-Filter/Dataflow View는 `AnalysisFrame DTO`가 어디서 만들어져 UI 쪽으로 넘어오는지 보여준다.
- 이 Sequence Diagram은 그 frame이 UI 내부에서 router, consumer, renderer로 어떻게 전달되는지 보여준다.
- Uses View는 같은 구조를 runtime 순서가 아니라 static dependency와 변경 영향 관점에서 보여준다.

## If Asked

**Q. 왜 `AnalysisFrame`을 lifeline participant로 그리지 않았나?**  
`AnalysisFrame`은 상호작용 주체라기보다 event/call parameter로 전달되는 DTO payload이다. 그래서 participant가 아니라 message payload로 표현하는 것이 더 정확하다.

**Q. 모든 consumer가 frame을 받는 이유는?**  
inactive graph도 최신 상태를 유지해야 할 수 있기 때문이다. 다만 이 단계는 rendering이 아니라 lightweight state/cache update이다.

**Q. Uses View의 `Graph Consumer Contract`와 여기의 `Registered Graph Consumers`는 무슨 관계인가?**  
Uses View는 static dependency를 보여주기 때문에 contract를 표시한다. Sequence Diagram의 registered consumers는 그 contract를 구현한 runtime 객체들이다.

## One-Sentence Summary

`AnalysisFrame DTO`는 Core와 UI graph rendering 사이의 안정적인 전달 계약이고, Router는 “all consumers update lightly, active consumer renders” 방식으로 변경 영향과 rendering 비용을 분리한다.