# ADR 2: 실시간 오디오 분석에 Partial Pipe-and-Filter 적용

## Status

Proposed

## Context

TimeGrapher는 시계 소리를 입력받아 rate, amplitude, beat error, beat-noise trace, graph output으로 변환한다. runtime path는 자연스럽게 다음 단계형 구조를 가진다.

```text
audio input -> HPF -> envelope -> detector -> metrics/projectors -> rendering
```

이 시스템에는 real-time constraint도 있다. 28800 BPH 기준으로 beat 하나는 125 ms마다 들어온다. 따라서 analysis path는 backlog를 쌓지 않아야 하고, UI rendering이 detection을 막아서는 안 된다.

교과서적인 Pipe-and-Filter architecture를 완전히 적용하면 각 단계를 독립 filter로 만들고 queue 또는 stream으로 연결할 수 있다. 하지만 그렇게 하면 가장 뜨거운 DSP path에 synchronization, queueing, allocation, latency cost가 추가된다.

## Decision

Analysis flow에는 Pipe-and-Filter를 partial architectural style로 적용한다. 완전한 concurrent pipeline으로 만들지는 않는다.

핵심 DSP path는 analysis worker 내부의 synchronous staged chain으로 유지한다. 각 단계의 책임은 분리하지만, 모든 단계를 독립 thread나 queue로 나누지는 않는다.

Concurrent boundary는 real-time behavior를 보호하는 곳에만 둔다.

- input worker -> bounded audio/ring buffer -> analysis worker
- analysis worker -> bounded recording queue
- analysis frame -> latest-wins UI render scheduler

## Rationale

이 결정은 Pipe-and-Filter의 장점인 staged transformation과 명확한 responsibility 분리를 유지한다.

반면 이 시스템에 비용이 큰 부분은 피한다. HPF, envelope, detector, metrics 사이에 추가 queue를 넣으면 latency와 synchronization overhead가 늘어난다. 이 단계들은 beat budget 안에서 빠르게 처리되어야 하는 cheap streaming operation이므로, 완전한 concurrent pipeline으로 분리할 실익이 크지 않다.

문서도 실제 code structure와 일치해야 한다. TimeGrapher code는 staged data-flow 형태를 가지지만, full independent-filter pipeline은 아니다. 따라서 architecture analysis에서는 Pipe-and-Filter를 full application이 아니라 partial application으로 설명해야 한다.

## Consequences

Positive:

- Analysis path를 staged transformation으로 설명하기 쉽다.
- 각 단계의 책임을 이해하고 test하기 쉽다.
- 가장 뜨거운 DSP path에서 불필요한 queue/thread overhead를 피한다.
- Architecture documentation이 실제 code를 과장하지 않고 설명한다.

Negative / trade-offs:

- 각 filter가 독립적으로 deploy되는 runtime component는 아니다.
- 내부 DSP stage 자체가 parallel speedup을 제공하지는 않는다.
- 문서에서는 반드시 "partial Pipe-and-Filter"라고 명확히 써야 한다.

Follow-up documentation work:

- 이 ADR을 module uses view와 architecture tactics analysis에서 link한다.
- Pipe-and-Filter는 partial application으로 유지한다.
