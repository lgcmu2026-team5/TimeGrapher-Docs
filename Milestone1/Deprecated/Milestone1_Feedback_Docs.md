# QAS-1 Latency, Risk, and Experiment Addendum

> 적용 대상: `Milestone1_2-Architectural-Drivers.md`, `Milestone1_3-Risk-Assessment.md`, `Milestone1_4-Planned-Experiments.md`
>
> 목적: QAS-1의 500 ms 기준을 TimeGrapher의 실제 실시간 비트 처리 예산에 맞게 수정하고, 관련 성능 리스크, 아키텍처 tactic, 실험 계획, 실험 결과, 결론을 한 파일에 정리한다.

## 1. QAS-1 수정안: Performance (Latency)

아래 내용은 `Milestone1_2-Architectural-Drivers.md`의 `QAS-1 · Performance (Latency) -- 소리 입력에서 화면 표시까지`를 대체하기 위한 수정안이다.

### QAS-1 · Performance (Latency) -- 소리 입력에서 화면 표시까지

> **한 줄 요약: 최고 목표 비트율인 43200 BPH에서도 한 비트 주기 안에 분석 결과가 GUI에 표시되어야 한다.**
>
> Raspberry Pi 5에서 Live, Playback, 또는 Simulation으로 측정하는 동안 시계 소리가 입력 파이프라인에 들어오면, 시스템은 해당 입력 블록을 분석하고 GUI에 표시해야 한다. 시스템은 (1) 오디오 샘플 블록이 캡처된 시점, (2) 그 블록의 beat detection 및 measurement 처리가 완료된 시점, (3) 해당 waveform segment, marker, computed reading이 GUI에 표시된 시점 사이의 지연을 기록해야 한다. 총 end-to-end latency는 capture time과 display time의 차이이다. 시스템은 capture-to-processing latency, processing-to-display latency, total end-to-end latency의 평균값과 최악값을 ms 단위로 보고하고, dropped audio blocks/samples 및 missed beat detections를 보고해야 한다.

**관련 요구사항**

- "The system shall record the time difference between (1) when an audio sample block is captured, (2) when that block is processed for beat detection and measurement, and (3) when the corresponding waveform segment and computed readings are displayed in the GUI."
- "Teams shall report capture-to-processing latency, processing-to-display latency, and total end-to-end latency in milliseconds, together with average and worst-case values, as well as counts of dropped audio blocks and missed beat detections."

| 요소 | 내용 |
|------|------|
| 자극유발원 | 시계 소리 또는 동일한 구조의 Simulation/Playback 입력 |
| 자극 | 오디오 샘플 블록이 캡처되어 분석 파이프라인에 들어옴 |
| 대상 | 입력 버퍼, beat detection/measurement 처리, GUI waveform/marker/computed-reading 표시 |
| 환경 | Raspberry Pi 5 + 연결된 디스플레이에서 GUI 실행. Live 마이크를 우선하되, 마이크가 없으면 같은 앱 파이프라인을 통과하는 Playback/Simulation으로 보조 검증 |
| 응답 | 입력 블록을 분석하고 대응되는 waveform segment, marker, computed reading을 GUI에 표시하며, capture-to-processing, processing-to-display, total end-to-end latency를 기록 |
| 응답측정 | 지원 BPH에서 total end-to-end latency의 worst-case가 해당 BPH의 한 비트 주기를 넘지 않아야 한다. 최고 목표 43200 BPH에서는 **worst-case E2E ≤ 83.3 ms**. 기준 28800 BPH에서는 **worst-case E2E ≤ 125.0 ms**. 각 실행은 capture-to-processing 평균/최악, processing-to-display 평균/최악, total E2E 평균/최악, dropped audio blocks/samples, missed beat detections를 보고한다. 합격 조건은 dropped audio blocks/samples = 0, missed beat detections = 0이다. |

### 측정값 근거

기존 `p99 ≤ 500 ms`는 일반 GUI 반응성 기준으로는 의미가 있지만, TimeGrapher의 실시간 성능 기준으로는 너무 느슨하다. TimeGrapher는 사용자의 클릭에 반응하는 앱이 아니라, 주기적으로 들어오는 시계 비트를 놓치지 않고 분석해야 하는 실시간 음향 측정 앱이다. 따라서 latency 예산은 사람이 느끼는 500 ms가 아니라 **시계의 비트 주기**에서 나온다.

비트 주기 계산:

```text
beat_period_ms = 3600 s / BPH * 1000 ms/s
```

| BPH | 초당 비트 수 | 비트 주기 |
|---:|---:|---:|
| 21600 | 6 beats/s | 166.7 ms |
| 28800 | 8 beats/s | 125.0 ms |
| 36000 | 10 beats/s | 100.0 ms |
| 43200 | 12 beats/s | 83.3 ms |

따라서 최고 목표 BPH인 43200에서는 한 비트가 **83.3 ms**마다 들어온다. 입력 처리와 GUI 표시가 이 주기보다 지속적으로 늦으면 stale data, backlog, dropped audio blocks/samples, missed beat detections가 발생할 수 있다. QAS-1의 pass/fail 기준은 이 물리적 주기에서 도출되어야 한다.

## 2. Risk Assessment 추가안

아래 내용은 `Milestone1_3-Risk-Assessment.md`에 추가하기 위한 리스크 수정안이다.

### 리스크 요약 테이블 추가 행

| Risk ID | 리스크 타이틀 | 구분 | QAS | P | I |
|---|---|---|---|---|---|
| 🔴 R-27 | 비트 주기 예산 안에 분석과 GUI 표시가 끝나지 않아 backlog, stale display, dropped samples, missed beats가 발생한다 | T | [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--소리-입력에서-화면-표시까지) | M | **H** |

### Appendix A 추가 리스크

- **🔴 R-27 -- 비트 주기 예산 안에 분석과 GUI 표시가 끝나지 않아 backlog, stale display, dropped samples, missed beats가 발생한다**
  - **근거**: [QAS-1](Milestone1_2-Architectural-Drivers.md#qas-1--performance-latency--소리-입력에서-화면-표시까지), 최고 목표 43200 BPH의 한 비트 주기 83.3 ms, `docs/SAP_TACTICS_ANALYSIS.md`의 실시간 마감 예산 및 record/monitor tactic.
  - **발생 확률 / 영향**: Medium / High
  - **등급 근거**
    - P-Medium: RPi5의 계산 성능과 GUI 렌더링 부하는 입력 샘플레이트, BPH, 활성 탭, 그래프 렌더링 비용에 따라 변한다. 43200 BPH @ 192 kHz는 팀 목표 내에서 가장 공격적인 조건이므로 예산 초과 가능성이 있다.
    - I-High: 처리 시간이 비트 주기를 지속적으로 넘으면 분석 backlog가 쌓이고, 오래된 데이터가 GUI에 표시되며, 최악의 경우 ring buffer drop 또는 missed beat detection으로 측정값 자체가 오염된다.
  - **완화 방향**
    - capture-to-processing, processing-to-display, total E2E latency를 `--analysis-log` CSV로 기록한다.
    - 분석 스레드와 UI 스레드를 분리하고, GUI는 latest-wins 방식으로 최신 프레임만 렌더링한다.
    - 활성 탭만 무거운 렌더링을 수행하고, 비활성 탭은 가벼운 관찰만 수행한다.
    - fixed-size buffer, object pool, decimation, bounded queue를 사용해 실행 시간이 세션 길이에 따라 증가하지 않게 한다.
    - backlog가 비트 주기 단위 예산을 지속적으로 넘으면 `AnalysisDeadlineMonitor`가 시각 품질을 단계적으로 낮춘다.
  - **Tradeoff point**: 더 높은 샘플레이트와 더 많은 그래프/스펙트로그램 렌더링은 측정 정밀도와 진단 가시성을 높이지만, RPi5에서 CPU/GPU 부하와 GUI 표시 지연을 증가시킨다.
  - **검증 방법**: RPi5 + 실제 GUI 디스플레이에서 28800 BPH @ 48 kHz와 43200 BPH @ 192 kHz 조건을 실행하고 CSV의 평균/최악 latency, dropped samples, missed beat detections를 확인한다.

## 3. 성능 향상을 위한 Software Architecture Tactics

아래 tactic은 `docs/SAP_TACTICS_ANALYSIS.md`의 Performance 섹션에서 QAS-1과 직접 관련 있는 항목만 추린 것이다.

| Tactic | 적용 방식 | QAS-1에 대한 효과 |
|---|---|---|
| introduce concurrency | 입력, 분석, 녹음, GUI 렌더링을 분리한다. 분석은 전용 worker thread에서 수행하고 GUI thread는 표시만 담당한다. | GUI가 느려져도 beat detection/measurement가 직접 막히지 않는다. |
| limit event response | 렌더 스케줄러가 최신 프레임 1개만 유지한다. 렌더 중 들어온 중간 프레임은 coalescing하고 일회성 신호는 병합한다. | 오래된 프레임을 줄줄이 그리느라 display latency가 증가하는 상황을 막는다. |
| schedule resources | 모든 탭을 매 프레임 무겁게 그리지 않고, 활성 탭만 `RenderFrame`을 수행한다. | GUI 표시 비용을 현재 사용자가 보는 화면에 집중한다. |
| bound queue sizes | 녹음 큐와 렌더 큐를 bounded 구조로 두고 초과 시 입력/분석 thread를 막지 않게 한다. | file I/O나 GUI 지연이 분석 경로 전체를 멈추지 않게 한다. |
| reduce overhead | rolling statistics, decimation, ArrayPool, bitmap reuse를 사용한다. | 비트당 계산 비용과 allocation 비용을 낮춰 83.3 ms 예산 안에 들어오게 한다. |
| maintain multiple copies of data | 30초 audio ring buffer와 fixed buffer pool을 사용해 생산자와 소비자의 속도 차이를 흡수한다. | 짧은 부하 spike가 곧바로 dropped sample로 이어지지 않는다. |
| bound execution times / manage work requests | backlog를 비트 주기 단위로 감시하고, 지속 초과 시 live preview 중단, publish interval 증가, scope stride 증가 등 단계적 저하를 수행한다. | 예산 초과가 누적될 때 GUI 품질을 낮춰 핵심 분석과 최신 표시를 보존한다. |
| bound resource usage | 장기 히스토리는 고정 용량 decimating series로 유지한다. | 1시간째 비용이 1초째 비용보다 커지는 장기 실행 성능 열화를 막는다. |
| record/monitor | capture timestamp, processing completed timestamp, display timestamp를 같은 Stopwatch clock으로 기록하고 CSV로 평균/최악값과 drop/miss count를 남긴다. | QAS-1의 latency와 missed beat 요구를 직접 관찰 가능하게 만든다. |

## 4. 실험 계획

이 절은 실험 수행 전 계획 형식으로 작성한다.

### EXP-QAS1: RPi5 GUI End-to-End Latency Test

**대응 리스크:** R-01, R-03, R-27  
**관련 QAS:** QAS-1  
**우선순위:** High

### 목적

RPi5에서 실제 GUI를 띄운 상태로 입력 → 분석 → GUI 표시 경로가 비트 주기 예산을 만족하는지 검증한다. 핵심 질문은 다음과 같다.

- Q1. 28800 BPH 기준 한 비트 주기 125.0 ms 안에 total E2E latency worst-case가 들어오는가?
- Q2. 최고 목표 43200 BPH 기준 한 비트 주기 83.3 ms 안에 total E2E latency worst-case가 들어오는가?
- Q3. dropped audio samples와 missed beat detections가 0으로 유지되는가?
- Q4. capture-to-processing과 processing-to-display 중 어느 구간이 latency의 대부분을 차지하는가?

### 실험 환경

- Hardware: Raspberry Pi 5, connected display
- OS/session: Debian 13 trixie, labwc Wayland session, XWayland display `:0`
- App: TimeGrapher.App linux-arm64 self-contained build
- Measurement option: `--analysis-log <csv>`
- Input modes:
  - Primary: Live microphone, if a capture device is available
  - Fallback: Simulation or Playback, if no microphone source is detected

### 절차

1. Pi에서 `--audio-smoke`로 마이크 capture source 존재 여부를 확인한다.
2. `./TimeGrapher.App --analysis-log ~/tg-gui-latency.csv`로 GUI 앱을 실제 디스플레이에 실행한다.
3. GUI에서 입력 모드를 선택한다.
   - Live mic가 있으면 Live로 실행한다.
   - Live mic가 없으면 Simulation/Playback으로 앱 내부 입력 → 분석 → GUI 표시 경로를 검증한다.
4. 28800 BPH @ 48 kHz 조건을 실행하고 CSV를 저장한다.
5. 43200 BPH @ 192 kHz 조건을 실행하고 CSV를 저장한다.
6. 각 CSV에서 마지막 row의 cumulative average/worst 값을 읽어 결과표를 작성한다.
7. dropped samples와 missed beat detections가 0인지 확인한다.

### 승인 기준

| 조건 | 기준 |
|---|---|
| 28800 BPH @ 48 kHz | total E2E worst-case ≤ 125.0 ms |
| 43200 BPH @ 192 kHz | total E2E worst-case ≤ 83.3 ms |
| dropped audio samples | 0 |
| missed beat detections | 0 |
| CSV completeness | capture-to-processing, processing-to-display, end-to-end latency의 평균/최악값 포함 |

## 5. 실험 결과

실험은 RPi5에 실제 디스플레이가 연결된 GUI 세션에서 수행했다. SSH 세션 자체는 headless였지만, 앱은 XWayland `DISPLAY=:0`에 연결하여 실제 Pi 화면에 띄웠다. 실행 중 GUI에서 graph, computed readings, latency status bar가 갱신되는 것을 확인했다.

### 환경 확인

| 항목 | 결과 |
|---|---|
| Pi OS | Debian GNU/Linux 13 (trixie), arm64 |
| Kernel/Userland | aarch64 kernel, arm64 userland |
| GUI session | labwc Wayland + XWayland `:0` |
| Microphone capture source | 없음. `source_count=0`, ALSA capture hardware 없음 |
| Live mic test | 미수행. OS 레벨에서 입력 장치가 없어 Simulation으로 대체 |

### CSV 결과

| 테스트 | CSV frames | capture-to-processing avg / worst | processing-to-display avg / worst | total E2E avg / worst | dropped audio samples | missed beat detections |
|---|---:|---:|---:|---:|---:|---:|
| Simulation 28800 BPH @ 48 kHz | 1181 | 0.764 / 34.246 ms | 5.565 / 17.506 ms | 6.329 / 40.720 ms | 0 | 0 |
| Simulation 43200 BPH @ 192 kHz | 433 | 1.127 / 25.501 ms | 5.504 / 22.354 ms | 6.631 / 30.382 ms | 0 | 0 |

### 원본 CSV 위치

- `~/tg-gui-latency-20260610195614.csv`
- `~/tg-gui-latency-43200-192k-20260610195614.csv`

### 판정

| 테스트 | 기준 | 측정 worst E2E | 판정 |
|---|---:|---:|---|
| 28800 BPH @ 48 kHz | ≤ 125.0 ms | 40.720 ms | Pass |
| 43200 BPH @ 192 kHz | ≤ 83.3 ms | 30.382 ms | Pass |

두 조건 모두 dropped audio samples = 0, missed beat detections = 0이었다. 43200 BPH @ 192 kHz 조건에서도 total E2E worst-case가 30.382 ms로 한 비트 주기 83.3 ms의 약 36.5% 수준이었다.

## 6. 결론

1. QAS-1의 기존 `p99 ≤ 500 ms` 기준은 TimeGrapher의 실시간 측정 특성에 비해 너무 느슨하다. 이 시스템의 latency 기준은 사람이 느끼는 GUI 반응성이 아니라 시계 비트 주기에서 도출해야 한다.
2. 최고 목표 조건인 43200 BPH에서는 한 비트 주기가 83.3 ms이므로, QAS-1의 pass/fail 기준은 `total E2E worst-case ≤ 83.3 ms`가 적절하다. 28800 BPH 기준은 `≤ 125.0 ms`이다.
3. RPi5 실제 GUI 실행 실험에서 Simulation 28800 BPH @ 48 kHz와 Simulation 43200 BPH @ 192 kHz 모두 기준을 만족했다.
4. 이번 결과는 앱 내부 입력/분석/GUI 표시 파이프라인의 성능을 검증한다. 다만 실제 USB microphone Live 경로는 Pi에서 capture source가 감지되지 않아 아직 검증하지 못했다. Live mic 경로는 OS audio stack, device driver, USB microphone buffering jitter가 추가될 수 있으므로, 마이크가 연결되면 같은 `--analysis-log` 방식으로 반복 측정해야 한다.
5. 현재 아키텍처 tactic 조합, 특히 introduce concurrency, latest-wins rendering, active-tab scheduling, bounded resources, record/monitor가 QAS-1 리스크 완화에 직접 기여한다. 실험 결과상 GUI 표시 latency는 평균 약 5.5 ms 수준이고, 총 E2E 평균은 약 6.3-6.6 ms 수준으로 안정적이었다.

## 7. 원본 문서 반영 제안

- `Milestone1_2-Architectural-Drivers.md`
  - QAS-1의 한 줄 요약과 응답측정에서 `p99 ≤ 500 ms`를 제거한다.
  - `worst-case E2E ≤ one beat period` 기준으로 수정한다.
  - 43200 BPH 기준 83.3 ms, 28800 BPH 기준 125.0 ms 계산 근거를 추가한다.
- `Milestone1_3-Risk-Assessment.md`
  - R-27을 추가하거나 R-03을 위 기준으로 재작성한다.
  - 리스크 내용은 "500 ms 목표 미달"이 아니라 "비트 주기 예산 초과로 backlog/stale/drop/missed beat 발생"으로 표현한다.
- `Milestone1_4-Planned-Experiments.md`
  - EXP-02의 질문 Q2를 `p99 ≤ 500 ms`에서 `worst-case E2E ≤ beat period`로 바꾼다.
  - 결과표에 본 실험의 28800 BPH @ 48 kHz와 43200 BPH @ 192 kHz 측정값을 추가한다.
