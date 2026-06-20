# ADR 2A: 실시간 오디오 분석에 Partial Pipe-and-Filter 적용 - 정확한 버전

## Status

Proposed

## Context

TimeGrapher는 시계 소리를 입력받아 rate, amplitude, beat error, beat-noise trace, graph output으로 변환한다. 전체 runtime 흐름은 다음처럼 단계적으로 나뉜다.

```text
input worker
  -> bounded ring buffer
  -> analysis worker
  -> latest-wins GUI/render path
```

이 구조는 입력, 분석, 화면 표시가 서로를 직접 막지 않도록 concurrent boundary를 둔다. input worker는 오디오를 계속 ring buffer에 적재하고, analysis worker는 ring buffer에서 block을 읽어 분석하며, GUI/render path는 최신 frame을 화면에 반영한다.

하지만 analysis worker 내부의 처리 흐름은 별도 thread/queue로 나뉜 full Pipe-and-Filter가 아니다.

```text
audio block
  -> HPF
  -> envelope
  -> detector
  -> metrics/projectors
  -> analysis frame
```

이 내부 단계들은 하나의 analysis thread 안에서 block 단위로 순차 실행되는 synchronous staged chain이다.

## Decision

TimeGrapher에는 Pipe-and-Filter를 full application이 아니라 partial application으로 적용한다.

Worker 간 경계에서는 staged pipeline과 concurrency를 사용한다.

- input worker -> bounded ring buffer -> analysis worker
- analysis worker -> latest-wins GUI/render path
- analysis worker -> bounded recording queue

그러나 analysis worker 내부의 HPF, envelope, detector, metrics/projectors 단계는 별도 thread나 queue로 분리하지 않는다.

## Rationale

Pipe-and-Filter의 장점은 데이터를 단계별로 변환하고 각 단계의 책임을 명확히 나눌 수 있다는 점이다. TimeGrapher는 전체 분석 흐름에서 이 장점을 활용한다.

하지만 analysis worker 내부는 beat budget 안에서 빠르게 끝나야 하는 hot path이다. 28800 BPH 기준 beat 하나는 125 ms마다 들어오므로, 분석 처리가 입력 속도를 따라가지 못하면 backlog가 쌓인다.

이 내부 단계에 full Pipe-and-Filter를 적용하면 다음 비용이 추가된다.

- stage 간 enqueue/dequeue 비용
- thread synchronization, lock, signal 비용
- buffer/message allocation 또는 copy 비용
- scheduler 대기에 따른 latency 증가
- audio block과 event 순서를 보장하기 위한 추가 로직
- detector, sync PLL, rolling metrics 상태 관리 복잡도 증가

현재 HPF, envelope, detector, metrics/projectors는 같은 analysis worker 안에서 순차 호출될 때 충분히 단순하고 예측 가능하다. 따라서 내부 hot path는 synchronous staged chain으로 유지하는 것이 실시간 성능과 구조적 단순성에 더 유리하다.

## Consequences

Positive:

- worker 간 concurrency로 input, analysis, GUI가 서로 직접 막히지 않는다.
- analysis worker 내부 hot path는 불필요한 queue/thread overhead를 피한다.
- block 처리 순서와 detector/metrics 상태 일관성을 단순하게 유지한다.
- architecture documentation이 실제 코드 구조를 과장하지 않는다.

Negative / trade-offs:

- analysis worker 내부 stage 자체는 parallel speedup을 제공하지 않는다.
- 각 내부 stage가 독립적으로 deploy되는 runtime filter는 아니다.
- 문서에서는 Pipe-and-Filter를 partial application으로 명확히 설명해야 한다.
