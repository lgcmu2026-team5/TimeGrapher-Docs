# ADR 2: 실시간 오디오 분석에 Partial Pipe-and-Filter 적용

## Status

Proposed

## Context

TimeGrapher는 시계 소리를 입력받아 rate, amplitude, beat error, beat-noise trace, graph output으로 변환한다. runtime path는 자연스럽게 다음 단계형 구조를 가진다.

```text
audio input -> HPF -> envelope -> detector -> metrics/projectors -> rendering
```

이 흐름을 그림으로 보면 다음과 같다.

```text
┌────────────────────┐
│ Input worker        │  마이크/파일/합성 입력을 계속 받는다
└─────────┬──────────┘
          │
          │ concurrent boundary
          ▼
┌────────────────────┐
│ Bounded ring buffer │  입력 생산자와 분석 소비자의 속도 차이를 흡수한다
└─────────┬──────────┘
          │
          ▼
┌──────────────────────────────────────────────────────────────┐
│ Analysis worker                                               │
│                                                              │
│  ┌─────┐   ┌──────────┐   ┌──────────┐   ┌────────────────┐ │
│  │ HPF │ ->│ Envelope │ ->│ Detector │ ->│ Metrics        │ │
│  └─────┘   └──────────┘   └──────────┘   │ Projectors     │ │
│                                          └────────────────┘ │
│                                                              │
│  위 단계들은 별도 thread/queue가 아니라 같은 analysis pass 안에서 │
│  순서대로 호출되는 synchronous staged chain이다.                │
└─────────┬──────────────────────────────┬─────────────────────┘
          │                              │
          │ concurrent boundary          │ concurrent boundary
          ▼                              ▼
┌────────────────────┐        ┌──────────────────────────────┐
│ Recording queue     │        │ Latest-wins UI render path   │
│ WAV 저장 지연 흡수  │        │ 최신 frame만 화면에 반영     │
└────────────────────┘        └──────────────────────────────┘
```

따라서 여기서 말하는 Pipe-and-Filter는 "모든 단계를 독립 프로세스나 병렬 파이프라인으로 만든다"는 뜻이 아니다. TimeGrapher에 실제로 적용된 부분은 입력을 여러 처리 단계로 통과시키는 staged transformation이다. 반대로 의도적으로 적용하지 않은 부분은 HPF, envelope, detector, metrics/projectors 사이마다 queue와 thread를 두는 완전한 concurrent pipeline이다.

이 시스템에는 real-time constraint도 있다. 28800 BPH 기준으로 beat 하나는 125 ms마다 들어온다. 따라서 analysis path는 backlog를 쌓지 않아야 하고, UI rendering이 detection을 막아서는 안 된다.

여기서 backlog는 입력은 계속 들어오는데 분석이 그 속도를 따라가지 못해 아직 처리하지 못한 audio sample이 뒤에 밀리는 상태를 뜻한다. 예를 들어 125 ms마다 beat가 들어오는데 한 beat를 처리하는 데 그보다 오래 걸리면, 다음 beat가 도착했을 때 이전 작업이 아직 끝나지 않았을 수 있다. 이런 상태가 반복되면 ring buffer에 처리 대기 sample이 누적되고, 오래된 sample은 eventually drop될 수 있다.

교과서적인 Pipe-and-Filter architecture를 완전히 적용하면 각 단계를 독립 filter로 만들고 queue 또는 stream으로 연결할 수 있다. 하지만 그렇게 하면 가장 뜨거운 DSP path에 synchronization, queueing, allocation, latency cost가 추가된다.

이 비용은 다음 의미다.

- synchronization cost: stage 사이에서 thread-safe하게 데이터를 넘기기 위해 lock, signal, memory barrier 같은 조정이 필요해지는 비용.
- queueing cost: 각 stage 사이에 queue를 두면 enqueue/dequeue와 queue depth 관리가 필요해지는 비용.
- allocation cost: stage별 message, buffer, wrapper object를 만들거나 복사하면서 생기는 메모리 비용.
- latency cost: 한 stage가 끝난 뒤 다음 stage가 scheduler에 의해 실행되기까지 기다리는 시간과 queue에 머무는 시간이 더해지는 비용.

TimeGrapher의 HPF, envelope, detector는 sample stream을 빠르게 훑는 작은 연산이다. 이 단계들을 별도 runtime component로 쪼개면 구조는 더 "파이프라인처럼" 보이지만, 실제 이득보다 실시간 처리 지연과 조정 비용이 더 커질 수 있다. 그래서 hot path는 같은 analysis worker 안에서 동기식 chain으로 유지하고, thread/queue 경계는 real-time behavior를 보호하는 곳에만 둔다.

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
