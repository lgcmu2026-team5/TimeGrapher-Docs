# ADR 2A: Worker-Level Partial Pipe-and-Filter 적용

## Status

Accepted

## Context

TimeGrapher의 실시간 오디오 분석은 worker-level에서 Pipe-and-Filter-style runtime flow를 가진다. 여기서 worker/path는 filter 또는 sink에 가깝고, bounded connector는 pipe 역할을 한다.

```mermaid
flowchart LR
    classDef filter fill:#e8f3ff,stroke:#2563eb,stroke-width:2px,color:#0f172a;
    classDef pipe fill:#fff7ed,stroke:#f97316,stroke-width:2px,color:#0f172a;
    classDef sink fill:#ecfdf5,stroke:#16a34a,stroke-width:2px,color:#0f172a;

    input["Input worker<br/>filter"]:::filter
    ring{{"Bounded ring buffer<br/>pipe / connector"}}:::pipe
    analysis["Analysis worker<br/>filter"]:::filter
    scheduler{{"Latest-wins frame scheduler<br/>pipe / connector"}}:::pipe
    ui["UI/render path<br/>filter / sink"]:::sink

    input --> ring --> analysis --> scheduler --> ui
```

Analysis worker 내부는 별도 pipe/queue/thread로 쪼개지지 않는다. 내부 DSP/metrics path는 같은 analysis thread에서 block 단위로 순차 실행되는 synchronous staged chain이다.

```mermaid
flowchart LR
    classDef stage fill:#f8fafc,stroke:#64748b,stroke-width:1.5px,color:#0f172a;
    classDef boundary fill:#fefce8,stroke:#ca8a04,stroke-width:1.5px,color:#0f172a;

    block["Audio block<br/>from ring buffer"]:::boundary
    hpf["HPF"]:::stage
    envelope["Envelope"]:::stage
    detector["Detector"]:::stage
    metrics["Metrics / Projectors"]:::stage
    frame["Analysis frame"]:::boundary

    block --> hpf --> envelope --> detector --> metrics --> frame
```

따라서 이 ADR은 worker-level flow에는 Pipe-and-Filter를 적용하고, worker 내부 hot path에는 적용하지 않는 결정을 기록한다.

## Decision

TimeGrapher는 Pipe-and-Filter를 worker-level partial application으로 적용한다.

Worker-level flow는 다음 filter/pipe 경계를 기준으로 설명한다.

- Input worker -> bounded ring buffer -> Analysis worker
- Analysis worker -> latest-wins frame scheduler -> UI/render path
- Analysis worker -> bounded recording queue

Analysis worker 내부의 HPF, envelope, detector, metrics/projectors는 별도 filter thread나 queue로 분리하지 않고 synchronous staged chain으로 유지한다.

## Rationale

Worker-level Pipe-and-Filter는 입력, 분석, 렌더링의 책임과 concurrency boundary를 명확히 한다. Ring buffer와 latest-wins frame scheduler는 producer/consumer 속도 차이를 흡수하며, UI rendering이 input capture나 detection을 직접 막지 않게 한다.

Analysis worker 내부는 28800 BPH 기준 125 ms beat budget 안에서 처리되어야 하는 hot path이다. 이 내부 chain을 full Pipe-and-Filter로 분리하면 다음 비용이 추가된다.

- stage 간 queueing, synchronization, scheduling latency
- buffer/message allocation 또는 copy
- audio block과 event 순서 보장 로직
- detector, sync PLL, rolling metrics 상태 관리 복잡도 증가

따라서 worker 간에는 Pipe-and-Filter-style concurrency를 두고, Analysis worker 내부는 synchronous chain으로 유지하는 것이 실시간 성능과 구조적 단순성에 더 유리하다.

## Consequences

Positive:

- worker-level runtime flow를 Pipe-and-Filter 관점으로 명확히 설명한다.
- input, analysis, UI rendering이 서로 직접 막히지 않는다.
- Analysis worker 내부 hot path에서 불필요한 queue/thread overhead를 피한다.
- block 처리 순서와 detector/metrics 상태 일관성을 단순하게 유지한다.

Negative / trade-offs:

- worker 내부 stage는 parallel speedup을 제공하지 않는다.
- Analysis worker 내부 stage는 독립 runtime filter가 아니다.
- 이 결정은 full Pipe-and-Filter가 아니라 worker-level partial application으로 설명해야 한다.
