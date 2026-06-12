# QAS-1 Latency Experiment Results Detail

> 목적: Raspberry Pi 5 실제 GUI 실행에서 수집한 `--analysis-log` CSV를 기반으로 QAS-1 latency 결과를 상세 정리한다.
>
> 관련 문서: `Milestone1_QAS1_Latency_Risk_Experiment_Addendum.md`

## 1. 실험 개요

QAS-1은 오디오 입력 블록이 캡처된 시점부터 beat detection/measurement 처리 완료 시점, 그리고 대응 waveform/marker/computed reading이 GUI에 표시된 시점까지의 latency를 보고하도록 요구한다. 이번 실험은 Raspberry Pi 5에서 TimeGrapher.App을 실제 디스플레이 GUI로 실행하고, `--analysis-log <csv>`로 각 GUI 표시 프레임의 latency를 수집했다.

실험 목적은 다음 두 조건에서 total end-to-end latency가 비트 주기 예산 안에 들어오는지 확인하는 것이다.

| 조건 | BPH | Sample rate | 비트 주기 예산 |
|---|---:|---:|---:|
| 기준 조건 | 28800 BPH | 48 kHz | 125.0 ms |
| 최고 목표 조건 | 43200 BPH | 192 kHz | 83.3 ms |

비트 주기 계산식:

```text
beat_period_ms = 3600 s / BPH * 1000 ms/s
```

## 2. 실험 환경

| 항목 | 값 |
|---|---|
| Hardware | Raspberry Pi 5 |
| OS | Debian GNU/Linux 13 (trixie), arm64 |
| GUI session | labwc Wayland + XWayland `:0` |
| App build | `TimeGrapher.App` linux-arm64 self-contained build |
| 실행 방식 | Pi 디스플레이에 실제 GUI 표시, SSH로 원격 조작 |
| 측정 옵션 | `./TimeGrapher.App --analysis-log <csv>` |
| 입력 모드 | Simulation |
| Live microphone | 미수행. Pi에서 `source_count=0`, ALSA capture hardware 없음 |

마이크 입력 장치가 OS에서 감지되지 않았기 때문에 Live microphone 경로는 이번 실험에서 제외했다. 대신 Simulation 입력으로 앱 내부 입력 worker, analysis worker, GUI render scheduler, GUI display timestamp까지 포함한 앱 파이프라인을 검증했다.

## 3. 원본 CSV

| 조건 | CSV 위치 | CSV rows |
|---|---|---:|
| Simulation 28800 BPH @ 48 kHz | `~/tg-gui-latency-20260610195614.csv` | 1182 rows = header + 1181 frames |
| Simulation 43200 BPH @ 192 kHz | `~/tg-gui-latency-43200-192k-20260610195614.csv` | 434 rows = header + 433 frames |

CSV 컬럼:

```text
capture_to_processing_ms,
processing_to_display_ms,
end_to_end_latency_ms,
capture_to_processing_avg_ms,
capture_to_processing_worst_ms,
processing_to_display_avg_ms,
processing_to_display_worst_ms,
end_to_end_avg_ms,
end_to_end_worst_ms,
dropped_audio_samples,
missed_beat_detections
```

이번 상세 통계의 `avg`, `p95`, `p99`, `worst`는 누적 평균 컬럼이 아니라 각 row의 per-frame latency 컬럼에서 다시 계산했다.

Percentile 계산 방식은 nearest-rank 방식이다.

```text
index = ceil(percentile * frame_count) - 1
```

## 4. 상세 결과: Simulation 28800 BPH @ 48 kHz

비트 주기 예산: **125.0 ms**

| Latency leg | avg | p95 | p99 | worst |
|---|---:|---:|---:|---:|
| capture-to-processing | 0.764 ms | 1.698 ms | 2.737 ms | 34.246 ms |
| processing-to-display | 5.565 ms | 10.118 ms | 11.802 ms | 17.506 ms |
| total end-to-end | 6.329 ms | 10.900 ms | 12.615 ms | 40.720 ms |

### 안정성 카운터

| Counter | Value |
|---|---:|
| dropped audio samples | 0 |
| missed beat detections | 0 |

### 예산 대비 판정

| Metric | Value |
|---|---:|
| E2E budget | 125.0 ms |
| E2E p99 | 12.615 ms |
| E2E worst | 40.720 ms |
| Worst-case budget usage | 32.6% |
| Worst-case remaining margin | 84.280 ms |
| Result | Pass |

해석:

- 평균 E2E는 6.329 ms로 비트 주기 예산의 약 5.1% 수준이다.
- p99 E2E는 12.615 ms로 비트 주기 예산의 약 10.1% 수준이다.
- worst E2E도 40.720 ms로 125.0 ms 예산 안에 충분히 들어왔다.
- dropped audio samples와 missed beat detections가 모두 0이므로 stale/backlog가 측정 실패로 이어진 증거는 없다.

## 5. 상세 결과: Simulation 43200 BPH @ 192 kHz

비트 주기 예산: **83.3 ms**

| Latency leg | avg | p95 | p99 | worst |
|---|---:|---:|---:|---:|
| capture-to-processing | 1.127 ms | 2.247 ms | 3.252 ms | 25.501 ms |
| processing-to-display | 5.504 ms | 10.401 ms | 12.420 ms | 22.354 ms |
| total end-to-end | 6.631 ms | 11.713 ms | 13.842 ms | 30.382 ms |

### 안정성 카운터

| Counter | Value |
|---|---:|
| dropped audio samples | 0 |
| missed beat detections | 0 |

### 예산 대비 판정

| Metric | Value |
|---|---:|
| E2E budget | 83.333 ms |
| E2E p99 | 13.842 ms |
| E2E worst | 30.382 ms |
| Worst-case budget usage | 36.5% |
| Worst-case remaining margin | 52.951 ms |
| Result | Pass |

해석:

- 43200 BPH는 한 비트가 83.3 ms마다 들어오는 최고 목표 조건이다.
- 평균 E2E는 6.631 ms로 비트 주기 예산의 약 8.0% 수준이다.
- p99 E2E는 13.842 ms로 비트 주기 예산의 약 16.6% 수준이다.
- worst E2E도 30.382 ms로 83.3 ms 예산의 약 36.5% 수준이다.
- dropped audio samples와 missed beat detections가 모두 0이므로 192 kHz 입력에서도 앱 내부 Simulation 파이프라인은 backlog 없이 처리되었다.

## 6. 두 실험 비교

| Condition | Frames | E2E avg | E2E p95 | E2E p99 | E2E worst | Budget | Worst usage | Drop | Miss |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 28800 BPH @ 48 kHz | 1181 | 6.329 ms | 10.900 ms | 12.615 ms | 40.720 ms | 125.0 ms | 32.6% | 0 | 0 |
| 43200 BPH @ 192 kHz | 433 | 6.631 ms | 11.713 ms | 13.842 ms | 30.382 ms | 83.3 ms | 36.5% | 0 | 0 |

관찰:

1. 192 kHz / 43200 BPH 조건에서 capture-to-processing 평균은 0.764 ms에서 1.127 ms로 증가했다. 샘플레이트가 4배가 되면서 분석 입력량이 증가한 영향으로 볼 수 있다.
2. processing-to-display 평균은 두 조건 모두 약 5.5 ms 수준이다. GUI 표시 구간은 샘플레이트보다 render scheduling 및 UI thread 상태의 영향을 더 크게 받는 것으로 보인다.
3. total E2E 평균은 두 조건 모두 약 6-7 ms 수준으로 안정적이다.
4. worst-case는 두 조건 모두 첫 동기화/초기 표시 구간의 transient spike가 반영된 값으로 보이며, 그래도 각 비트 주기 예산 안에 들어왔다.
5. 두 실험 모두 dropped audio samples와 missed beat detections가 0이다.

## 7. QAS-1 판정

QAS-1의 수정 기준을 다음과 같이 적용한다.

| Requirement | 28800 BPH @ 48 kHz | 43200 BPH @ 192 kHz |
|---|---:|---:|
| E2E worst-case <= one beat period | Pass: 40.720 ms <= 125.0 ms | Pass: 30.382 ms <= 83.333 ms |
| dropped audio samples = 0 | Pass | Pass |
| missed beat detections = 0 | Pass | Pass |
| report avg/p95/p99/worst for latency legs | Pass | Pass |

결론적으로, 이번 Pi GUI Simulation 실험 기준으로 QAS-1 latency 목표는 충족한다.

## 8. 제한 사항

1. Live microphone 경로는 아직 검증하지 못했다. Pi에서 capture source가 감지되지 않았기 때문이다.
2. Simulation은 앱 내부의 input worker와 analysis/display path를 검증하지만, USB microphone driver, OS audio stack, real acoustic noise, hardware buffering jitter는 포함하지 않는다.
3. CSV에는 wall-clock timestamp가 없으므로 정확한 실행 시간 분포는 frame count와 latency 값으로만 분석했다.
4. 이번 실험은 Rate/Scope 탭이 활성화된 상태의 GUI 결과다. 다른 탭, 특히 Spectrogram/Sound Print 등 이미지 중심 탭은 별도 측정이 필요할 수 있다.

## 9. 결론

- 기존 500 ms 기준보다 엄격한 beat-period 기준을 적용해도 두 실험 모두 통과했다.
- 최고 목표 조건인 43200 BPH @ 192 kHz에서 E2E p99는 13.842 ms, worst는 30.382 ms로 83.3 ms 예산 안에 들어왔다.
- dropped audio samples와 missed beat detections는 두 실험 모두 0이었다.
- 현재 아키텍처의 핵심 성능 tactic인 analysis/UI thread 분리, latest-wins frame scheduling, active-tab rendering, bounded resource usage, record/monitor 계측이 QAS-1 충족에 기여한 것으로 해석할 수 있다.
- 다음 검증 단계는 USB microphone이 Pi에서 capture source로 잡힌 상태에서 동일한 CSV 로깅을 Live mode로 반복하는 것이다.
