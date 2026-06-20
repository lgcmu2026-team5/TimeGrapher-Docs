# ADR 2B: 실시간 오디오 분석 흐름에 Pipe-and-Filter 스타일 적용 - 큰 관점 버전

## Status

Proposed

## Context

TimeGrapher는 오디오 입력을 여러 단계로 처리해 시계 측정 결과와 그래프를 만든다. 큰 흐름은 다음과 같다.

```text
audio input
  -> input worker
  -> ring buffer
  -> analysis worker
  -> analysis frame
  -> GUI/render path
```

이 흐름은 입력 데이터를 단계별로 변환한다는 점에서 Pipe-and-Filter 스타일과 잘 맞는다. 각 단계는 서로 다른 책임을 가진다.

- input worker: 오디오 입력 수집
- ring buffer: 입력 생산자와 분석 소비자의 속도 차이 흡수
- analysis worker: DSP, detection, metrics, projector 처리
- GUI/render path: 최신 analysis frame을 화면에 반영

## Decision

TimeGrapher의 실시간 오디오 분석 흐름에 Pipe-and-Filter 스타일을 적용한다.

단, 적용 범위는 시스템 전체 runtime 흐름의 큰 단계에 둔다. input, buffering, analysis, rendering을 분리해 staged pipeline을 만들고, 주요 단계 사이에 concurrency boundary를 둔다.

```text
Input worker
  -> Bounded ring buffer
  -> Analysis worker
  -> Latest-wins GUI/render path
```

Analysis worker 내부의 세부 DSP/metrics 단계는 별도 filter thread로 분리하지 않고 synchronous staged chain으로 유지한다.

```text
HPF -> envelope -> detector -> metrics/projectors
```

## Rationale

Pipe-and-Filter 스타일을 적용하면 TimeGrapher의 오디오 처리 흐름을 이해하기 쉽다. 입력이 여러 단계를 거쳐 분석 결과와 화면 출력으로 바뀌기 때문이다.

또한 worker 단위로 경계를 나누면 실시간 시스템에 필요한 concurrency를 확보할 수 있다.

- input worker는 오디오 입력을 계속 받는다.
- analysis worker는 입력과 독립적으로 block을 처리한다.
- GUI/render path는 분석을 막지 않고 최신 frame만 표시한다.

하지만 Pipe-and-Filter를 analysis worker 내부까지 완전히 적용하지는 않는다. HPF, envelope, detector, metrics/projectors는 빠르게 처리되어야 하는 hot path이며, 각 stage 사이에 queue/thread를 추가하면 오히려 성능 비용이 커질 수 있다.

따라서 TimeGrapher는 큰 runtime 흐름에서는 Pipe-and-Filter의 staged pipeline 구조를 활용하고, 내부 분석 단계에서는 성능과 순서 보장을 위해 synchronous chain을 유지한다.

## Consequences

Positive:

- 전체 오디오 처리 흐름을 Pipe-and-Filter 관점으로 설명할 수 있다.
- input, analysis, GUI/render path가 분리되어 concurrency를 확보한다.
- 실시간 입력이 GUI rendering에 의해 직접 막히지 않는다.
- analysis worker 내부 hot path는 불필요한 queue/thread overhead를 피한다.

Negative / trade-offs:

- analysis worker 내부 stage는 독립 filter runtime component가 아니다.
- 내부 DSP/metrics 단계는 병렬 pipeline이 아니라 순차 처리 chain이다.
- 따라서 이 ADR은 full Pipe-and-Filter가 아니라 큰 흐름 중심의 partial Pipe-and-Filter로 설명해야 한다.
