# ADR 2A: 실시간 오디오 분석에 Partial Pipe-and-Filter 적용 - 정확한 버전

## Status

Proposed

## Context

TimeGrapher는 시계 소리를 입력받아 rate, amplitude, beat error, beat-noise trace, graph output으로 변환한다. 전체 runtime 흐름은 worker-level에서 다음 Pipe-and-Filter-style 구조로 나뉜다.

```text
┌────────────────────┐       ╔══════════════════════╗       ┌────────────────────┐       ╔════════════════════════════╗       ┌────────────────────┐
│      FILTER        │       ║        PIPE          ║       │      FILTER        │       ║            PIPE            ║       │   FILTER / SINK    │
│                    │       ║                      ║       │                    │       ║                            ║       │                    │
│   Input worker     │──────▶║  bounded ring buffer ║──────▶│  Analysis worker   │──────▶║ latest-wins frame scheduler║──────▶│  UI/render path    │
│                    │       ║                      ║       │                    │       ║                            ║       │                    │
└────────────────────┘       ╚══════════════════════╝       └────────────────────┘       ╚════════════════════════════╝       └────────────────────┘
```

이 구조에서 Input worker와 Analysis worker는 filter/component 역할을 한다. bounded ring buffer는 두 worker 사이에서 오디오 sample을 전달하고 속도 차이를 흡수하는 pipe/connector 역할을 한다. Analysis worker가 만든 frame은 latest-wins frame scheduler를 통해 UI/render path로 전달되며, 이 scheduler가 Analysis worker와 UI/render path 사이의 pipe/connector 역할을 한다. UI/render path는 최종 filter 또는 sink에 가깝다.

이 worker-level 구조는 입력, 분석, 화면 표시가 서로를 직접 막지 않도록 concurrent boundary를 둔다. Input worker는 오디오를 계속 ring buffer에 적재하고, Analysis worker는 ring buffer에서 block을 읽어 분석하며, UI/render path는 최신 frame을 화면에 반영한다.

따라서 Pipe-and-Filter를 판단할 때는 두 레벨을 구분해야 한다.

- Worker 간 흐름: filter 역할을 하는 worker/path와 pipe 역할을 하는 connector가 분리된 staged runtime pipeline이다.
- Worker 내부 흐름: 각 worker 내부 처리 단계는 별도 pipe/connector, filter thread, queue로 다시 쪼개지 않는다.

특히 Analysis worker 내부의 처리 흐름은 full Pipe-and-Filter가 아니라 synchronous staged chain이다.

```text
Analysis worker 내부

audio block from ring buffer
  -> HPF
  -> envelope
  -> detector
  -> metrics/projectors
  -> analysis frame
```

이 내부 단계들은 하나의 analysis thread 안에서 block 단위로 순차 실행된다. 즉 worker 간에는 concurrent boundary가 있지만, worker 내부 hot path는 synchronous하게 처리된다.

## Decision

TimeGrapher에는 Pipe-and-Filter를 full application이 아니라 worker-level partial application으로 적용한다.

Worker 간 경계에서는 staged pipeline과 concurrency를 사용한다.

- Input worker -> bounded ring buffer -> Analysis worker
- Analysis worker -> latest-wins UI/render path
- Analysis worker -> bounded recording queue

그러나 worker 내부 단계는 별도 thread나 queue로 다시 분리하지 않는다. 특히 Analysis worker 내부의 HPF, envelope, detector, metrics/projectors 단계는 synchronous staged chain으로 유지한다.

## Rationale

Pipe-and-Filter의 장점은 데이터를 단계별로 변환하고 각 단계의 책임을 명확히 나눌 수 있다는 점이다. TimeGrapher는 worker-level runtime 흐름에서 이 장점을 활용한다. Input worker, Analysis worker, UI/render path는 서로 다른 책임을 가진 단계이며, ring buffer와 latest-wins render scheduling은 단계 간 속도 차이를 흡수한다.

하지만 worker 내부까지 같은 방식으로 쪼개는 것은 별개의 결정이다. 특히 Analysis worker 내부는 beat budget 안에서 빠르게 끝나야 하는 hot path이다. 28800 BPH 기준 beat 하나는 125 ms마다 들어오므로, 분석 처리가 입력 속도를 따라가지 못하면 backlog가 쌓인다.

이 내부 단계에 full Pipe-and-Filter를 적용하면 다음 비용이 추가된다.

- stage 간 enqueue/dequeue 비용
- thread synchronization, lock, signal 비용
- buffer/message allocation 또는 copy 비용
- scheduler 대기에 따른 latency 증가
- audio block과 event 순서를 보장하기 위한 추가 로직
- detector, sync PLL, rolling metrics 상태 관리 복잡도 증가

현재 HPF, envelope, detector, metrics/projectors는 같은 Analysis worker 안에서 순차 호출될 때 충분히 단순하고 예측 가능하다. 따라서 worker 간에는 concurrent Pipe-and-Filter-style pipeline을 두고, worker 내부 hot path는 synchronous staged chain으로 유지하는 것이 실시간 성능과 구조적 단순성에 더 유리하다.

## Consequences

Positive:

- worker 간 concurrency로 input, analysis, UI rendering이 서로 직접 막히지 않는다.
- worker-level 구조를 Pipe-and-Filter 관점으로 설명하면서도 실제 코드 구조를 과장하지 않는다.
- Analysis worker 내부 hot path는 불필요한 queue/thread overhead를 피한다.
- block 처리 순서와 detector/metrics 상태 일관성을 단순하게 유지한다.

Negative / trade-offs:

- worker 내부 stage 자체는 parallel speedup을 제공하지 않는다.
- 각 worker 내부 stage가 독립적으로 deploy되는 runtime filter는 아니다.
- UI 쪽은 실제 코드상 별도 "GUI worker"라고 부르기보다 UI/render path로 표현해야 한다.
- 문서에서는 Pipe-and-Filter를 worker-level partial application으로 명확히 설명해야 한다.
