# AnalysisFrame Sequence Diagram Speaker Notes

Draw.io source: [2. ForPresentation_AnalysisFrame sequence diagram.drawio](<2. ForPresentation_AnalysisFrame sequence diagram.drawio>)

Related detailed source: [2. AnalysisFrame sequence diagram.drawio](<2. AnalysisFrame sequence diagram.drawio>)

## Slide Purpose

이 그림은 `AnalysisFrame`이 Core 분석 결과에서 UI graph rendering까지 전달되는 흐름을 보여주는 발표용 sequence view이다.

강조할 메시지는 하나다.

`AnalysisFrame`은 Core와 UI 사이의 DTO 계약이고, Router는 모든 graph consumer에는 가벼운 상태 갱신 기회를 주되 실제 rendering work는 현재 선택된 active graph에만 집중시킨다.

## What This View Shows

1. Core 분석 worker가 한 번의 분석 결과를 `AnalysisFrame DTO`로 만든다.
2. `Frame Render Scheduler`가 최신 frame을 UI route로 넘긴다.
3. `AnalysisFrame Router`가 등록된 모든 graph consumer에 최신 frame을 관찰하게 한다.
4. 모든 consumer는 필요한 lightweight state/cache만 업데이트한다.
5. `activeTabId`로 선택된 active consumer만 selected graph payload를 준비한다.
6. selected graph renderer가 그 payload를 실제 graph view로 렌더링한다.

## Component Roles

| Component | Role | Presentation Point |
|---|---|---|
| Core Analysis Worker | 분석 결과 생산자 | Core는 graph renderer를 직접 알지 않고 `AnalysisFrame DTO`만 발행한다. |
| Frame Render Scheduler | UI dispatch / latest-frame handoff | 분석 frame을 UI rendering 흐름으로 넘기고, UI work가 과도하게 쌓이지 않도록 최신 frame 중심으로 연결한다. |
| AnalysisFrame Router | graph routing control | 모든 consumer를 업데이트하되, active graph만 render path로 보낸다. |
| Registered Graph Consumers | inactive 포함 전체 graph consumer | 최신 frame을 보고 필요한 상태/cache만 가볍게 갱신한다. |
| Active Graph Consumer | 현재 선택된 tab의 consumer | 실제 rendering에 필요한 selected graph payload를 준비한다. |
| Selected Graph Renderer | graph-specific renderer | 준비된 payload를 plot/image 등 실제 화면 표현으로 변환한다. |

## Presenter Script

이 sequence diagram은 `AnalysisFrame`이 Core에서 UI graph까지 어떻게 전달되는지 보여줍니다.

먼저 Core Analysis Worker가 detection, metrics, projection 같은 분석 결과를 하나의 `AnalysisFrame DTO`로 묶습니다. 중요한 점은 Core가 특정 graph renderer를 직접 호출하지 않는다는 것입니다. Core는 안정적인 DTO 계약만 발행하고, 어떤 graph를 보여줄지는 UI 쪽 routing에서 결정됩니다.

그 다음 Frame Render Scheduler가 최신 frame을 UI route로 전달합니다. 이 단계는 분석 흐름과 UI rendering 흐름을 분리하는 역할을 합니다. UI가 모든 frame을 무조건 즉시 렌더링하는 것이 아니라, 최신 frame 중심으로 rendering 부담을 관리할 수 있습니다.

Router는 두 단계로 동작합니다. 먼저 등록된 모든 graph consumer에 frame을 전달해서 lightweight state/cache를 업데이트합니다. 예를 들어 inactive graph도 최신 metadata, history, image state 같은 정보를 유지할 수 있습니다. 하지만 이 단계는 render가 아니라 가벼운 상태 갱신입니다.

이후 `activeTabId`로 선택된 active consumer만 selected graph payload를 준비합니다. 즉 실제 graph rendering work는 현재 사용자가 보고 있는 graph 하나에 집중됩니다. 이 구조 덕분에 graph가 늘어나도 Core hot path를 건드리지 않고, UI rendering 비용도 active graph 중심으로 제한할 수 있습니다.

마지막으로 selected graph renderer가 payload를 실제 화면으로 그립니다. Rate/Scope, Spectrogram, Beat Noise, Beat Error 같은 graph는 서로 다른 payload와 renderer를 가질 수 있지만, 전체 흐름은 같은 `AnalysisFrame` 계약과 router 구조를 통해 연결됩니다.

## Why This Matters Architecturally

이 뷰는 runtime message order를 보여주는 sequence view이다.

발표에서 연결할 QAS는 주로 다음 두 가지다.

- Modifiability: 새 graph를 추가할 때 Core analysis logic을 직접 수정하지 않고 consumer/renderer 쪽 변경으로 제한할 수 있다.
- Performance / resource control: 모든 graph를 매 frame마다 무겁게 렌더링하지 않고, active graph 중심으로 rendering work를 제한한다.

## If Asked

**Q. 왜 `AnalysisFrame`을 lifeline으로 그리지 않았나?**  
`AnalysisFrame`은 상호작용의 주체라기보다 event/call parameter로 전달되는 DTO payload이다. 그래서 participant가 아니라 message payload로 표현하는 것이 이 그림의 의도에 더 맞다.

**Q. 왜 모든 consumer가 frame을 받나?**  
inactive graph도 최신 상태를 유지해야 할 수 있기 때문이다. 다만 이 단계는 rendering이 아니라 lightweight state/cache update이다.

**Q. 왜 active consumer만 graph payload를 준비하나?**  
모든 graph를 매 frame 렌더링하면 UI 비용이 커진다. 현재 선택된 graph만 render path에 올려 display work를 제한한다.

## One-Sentence Summary

`AnalysisFrame DTO`는 Core와 UI graph rendering 사이의 안정적인 전달 계약이고, Router는 “all consumers update lightly, active consumer renders” 방식으로 변경 영향과 rendering 비용을 분리한다.
