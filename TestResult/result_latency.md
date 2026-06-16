# QAS-2 Latency Experiment Plan & Results

> 목적: 실제 GUI 실행에서 수집하는 `--analysis-log` CSV를 기반으로 QAS-2 latency를 재측정한다. **기존 측정 결과는 폐기했다.** 아래 2개 조건 × 입력 모드 매트릭스로 다시 측정한다.

> **폐기 안내**: 이전 버전 문서는 28800 BPH @ 48 kHz(Sim), 43200 BPH @ 192 kHz(Sim), 21600 BPH @ 48 kHz(WAV), 28800 BPH @ 384 kHz(WAV) 네 건의 결과를 담고 있었다. 조건 집합이 설계 목표와 정합하지 않아 전부 폐기하고, 아래의 정리된 두 조건으로 재측정한다.

## 1. 실험 개요

QAS-2은 오디오 입력 블록이 캡처된 시점부터 beat detection/measurement 처리 완료 시점, 그리고 대응 waveform/marker/computed reading이 GUI에 표시된 시점까지의 latency를 보고하도록 요구한다. 이번 실험은 TimeGrapher.App을 실제 디스플레이 GUI로 실행하고, `--analysis-log <csv>`로 각 GUI 표시 프레임의 latency를 수집한다.

실험 목적은 다음 두 조건에서 total end-to-end latency가 비트 주기 예산 안에 들어오는지 확인하는 것이다.

| 조건 | BPH | Sample rate | 비트 주기 예산 |
|---|---:|---:|---:|
| 기준 조건 | 21600 BPH | 48 kHz | 166.667 ms |
| 최고 목표 조건 | 43200 BPH | 192 kHz | 83.333 ms |

비트 주기 계산식:

```text
beat_period_ms = 3600 s / BPH * 1000 ms/s
```

측정은 **Raspberry Pi 5(주 대상)** 와 **Windows(참고)** 두 플랫폼에서 각각 수행한다. QAS-2 판정의 기준 플랫폼은 배포 대상인 Raspberry Pi 5이며, Windows 결과는 개발 PC 참고치로만 기록한다.

## 2. 실험 환경

| 항목 | Raspberry Pi 5 (주 대상) | Windows (참고) |
|---|---|---|
| Hardware | Raspberry Pi 5 | 개발 PC |
| OS | Debian GNU/Linux 13 (trixie), arm64 | Windows 11 |
| 오디오 백엔드 | ALSA | WASAPI |
| GUI session | labwc Wayland + XWayland `:0` | Windows 데스크톱 |
| App build | linux-arm64 self-contained build | win-x64 build |
| 측정 옵션 | `./TimeGrapher.App --analysis-log <csv>` | `TimeGrapher.App.exe --analysis-log <csv>` |
| 입력 모드 | Live(USB 마이크) / Playback / Simulation | Live(USB 마이크) / Playback / Simulation |
| 활성 탭 | Rate/Scope | Rate/Scope |

Live 마이크 경로는 USB 마이크가 capture source로 감지된 상태에서 측정한다. 직전 측정 시점에는 Pi에서 capture source가 감지되지 않아 Live를 수행하지 못했으므로, 이번 재측정에서는 마이크 확보가 선행 조건이다.

## 3. 측정 방법

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

상세 통계의 `avg`, `p95`, `p99`, `worst`는 누적 평균 컬럼이 아니라 각 row의 per-frame latency 컬럼에서 다시 계산한다.

Percentile 계산 방식은 nearest-rank 방식이다.

```text
index = ceil(percentile * frame_count) - 1
```

**길이 통일**: CSV는 GUI에 표시되는 프레임마다 한 row를 기록하므로 row 수는 run 길이에 비례한다. 각 run을 넉넉히 돌린 뒤, 분석 단계에서 비교 대상 CSV들의 **공통 최소 프레임 수**만큼 앞부분을 잘라 동일 프레임 수 기준으로 통계를 계산한다.

## 4. 실험 매트릭스 및 측정 절차

2개 조건 × 입력 모드 = **플랫폼당 5 run** (43200 BPH @ 192 kHz는 Live 제외).

| 조건 | Simulation | Playback | Live |
|---|---|---|---|
| 21600 BPH @ 48 kHz | run | run (Live 녹음 WAV) | run (실제 무브먼트) |
| 43200 BPH @ 192 kHz | run | run (합성 WAV) | 해당 없음 (하이비트 무브먼트 미보유) |

→ 플랫폼당 5 run. Raspberry Pi 5(주)와 Windows(참고)에서 각각 수행하므로 총 10 run.

입력 모드별 절차:

1. **Live** — 캡처 sample rate를 48 kHz로 설정하고 실제 무브먼트를 USB 마이크로 캡처한다. record 세션을 켜고 `--analysis-log`로 측정하면 live CSV와 함께 float32 mono WAV이 동시에 저장된다. 43200 BPH는 하이비트 무브먼트를 확보하지 못해 Live를 수행하지 않는다.
2. **Playback** — 21600 BPH는 Live에서 저장한 WAV을 동일 sample rate로 재생한다. 43200 BPH는 실녹음 WAV이 없어 합성 WAV(`sample/43200BPH_synthetic_192000Hz.wav`)을 재생한다.
3. **Simulation** — BPH와 sample rate를 직접 설정해 독립적으로 측정한다.

**43200 BPH @ 192 kHz Playback용 합성 WAV 출처**: 앱 Simulation과 동일한 `WatchSynthStream` 생성기(Clean config, pcmPeak 0.35, noise 0)로 생성한 float32 mono 192 kHz · 60초 파일이다. `TimeGrapher.Verify` 검증에서 `detected_bph=43200`, `sync_status=Synced`로 확인했다. 실제 음향 녹음이 아니라 합성 신호이므로, 해당 조건의 Playback은 실음향 디코딩이 아닌 파일 디코딩 경로 검증으로 한정된다.

## 5. 결과

**측정 대기(TBD).** 재측정 후 아래 표를 채운다.

### 5.1 Raspberry Pi 5 (주 대상)

| Condition | Input | Frames | E2E avg | E2E p95 | E2E p99 | E2E worst | Budget | Worst usage | Drop | Miss | Result |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 21600 BPH @ 48 kHz | Simulation | 1035 | 6.176 ms | 10.722 ms | 12.398 ms | 41.975 ms | 166.667 ms | 25.2% | 0 | 0 | Pass |
| 21600 BPH @ 48 kHz | Playback | 1035 | 6.335 ms | 11.146 ms | 12.985 ms | 43.939 ms | 166.667 ms | 26.4% | 0 | 0 | Pass |
| 21600 BPH @ 48 kHz | Live | 1035 | 3.908 ms | 6.424 ms | 9.132 ms | 40.378 ms | 166.667 ms | 24.2% | 0 | 0 | Pass |
| 43200 BPH @ 192 kHz | Simulation | 1035 | 7.133 ms | 12.358 ms | 13.834 ms | 34.003 ms | 83.333 ms | 40.8% | 0 | 0 | Pass |
| 43200 BPH @ 192 kHz | Playback | 1035 | 6.830 ms | 11.834 ms | 13.807 ms | 34.562 ms | 83.333 ms | 41.5% | 0 | 0 | Pass |

Raspberry Pi 5 5 run은 모두 비트 주기 예산 안에 들어왔고 dropped audio samples·missed beat detections가 0이었다(공통 최소 프레임 1035 기준). 측정 CSV는 `csv/pi/`에 있다.

#### Raspberry Pi 5 per-leg 상세 (avg / p95 / p99 / worst, ms)

| Run | Leg | avg | p95 | p99 | worst |
|---|---|---:|---:|---:|---:|
| 21600@48k Sim | capture-to-processing | 0.782 | 1.758 | 2.733 | 36.966 |
| 21600@48k Sim | processing-to-display | 5.394 | 10.029 | 11.862 | 13.776 |
| 21600@48k Sim | total end-to-end | 6.176 | 10.722 | 12.398 | 41.975 |
| 21600@48k Playback | capture-to-processing | 0.899 | 2.174 | 3.119 | 37.247 |
| 21600@48k Playback | processing-to-display | 5.436 | 10.330 | 11.966 | 20.757 |
| 21600@48k Playback | total end-to-end | 6.335 | 11.146 | 12.985 | 43.939 |
| 21600@48k Live | capture-to-processing | 2.639 | 4.598 | 6.110 | 14.011 |
| 21600@48k Live | processing-to-display | 1.269 | 3.138 | 4.114 | 31.752 |
| 21600@48k Live | total end-to-end | 3.908 | 6.424 | 9.132 | 40.378 |
| 43200@192k Sim | capture-to-processing | 1.457 | 3.099 | 4.186 | 28.522 |
| 43200@192k Sim | processing-to-display | 5.676 | 11.144 | 12.541 | 21.247 |
| 43200@192k Sim | total end-to-end | 7.133 | 12.358 | 13.834 | 34.003 |
| 43200@192k Playback | capture-to-processing | 1.351 | 2.697 | 3.673 | 29.313 |
| 43200@192k Playback | processing-to-display | 5.479 | 10.608 | 12.580 | 19.695 |
| 43200@192k Playback | total end-to-end | 6.830 | 11.834 | 13.807 | 34.562 |

### 5.2 Windows (참고)

| Condition | Input | Frames | E2E avg | E2E p95 | E2E p99 | E2E worst | Budget | Worst usage | Drop | Miss | Result |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 21600 BPH @ 48 kHz | Simulation | 787 | 13.723 ms | 17.623 ms | 18.651 ms | 22.619 ms | 166.667 ms | 13.6% | 0 | 0 | Pass |
| 21600 BPH @ 48 kHz | Playback | 787 | 11.453 ms | 17.517 ms | 18.423 ms | 34.846 ms | 166.667 ms | 20.9% | 0 | 0 | Pass |
| 21600 BPH @ 48 kHz | Live | 787 | 10.996 ms | 20.026 ms | 21.194 ms | 26.038 ms | 166.667 ms | 15.6% | 0 | 0 | Pass |
| 43200 BPH @ 192 kHz | Simulation | 787 | 15.186 ms | 17.824 ms | 19.071 ms | 26.352 ms | 83.333 ms | 31.6% | 0 | 0 | Pass |
| 43200 BPH @ 192 kHz | Playback | 787 | 13.946 ms | 17.763 ms | 18.731 ms | 24.061 ms | 83.333 ms | 28.9% | 0 | 0 | Pass |

Windows 5 run은 모두 비트 주기 예산 안에 들어왔고 dropped audio samples·missed beat detections가 0이었다(공통 최소 프레임 787 기준). 측정 CSV는 `csv/win/`에 있다.

#### Windows per-leg 상세 (avg / p95 / p99 / worst, ms)

| Run | Leg | avg | p95 | p99 | worst |
|---|---|---:|---:|---:|---:|
| 21600@48k Sim | capture-to-processing | 0.707 | 1.529 | 2.383 | 11.539 |
| 21600@48k Sim | processing-to-display | 13.016 | 17.015 | 17.746 | 22.257 |
| 21600@48k Sim | total end-to-end | 13.723 | 17.623 | 18.651 | 22.619 |
| 21600@48k Playback | capture-to-processing | 0.521 | 1.054 | 1.739 | 11.092 |
| 21600@48k Playback | processing-to-display | 10.933 | 16.973 | 17.760 | 32.419 |
| 21600@48k Playback | total end-to-end | 11.453 | 17.517 | 18.423 | 34.846 |
| 21600@48k Live | capture-to-processing | 0.662 | 1.332 | 1.935 | 12.159 |
| 21600@48k Live | processing-to-display | 10.334 | 19.234 | 20.430 | 25.142 |
| 21600@48k Live | total end-to-end | 10.996 | 20.026 | 21.194 | 26.038 |
| 43200@192k Sim | capture-to-processing | 0.838 | 1.859 | 2.519 | 12.882 |
| 43200@192k Sim | processing-to-display | 14.347 | 17.041 | 18.350 | 25.574 |
| 43200@192k Sim | total end-to-end | 15.186 | 17.824 | 19.071 | 26.352 |
| 43200@192k Playback | capture-to-processing | 0.778 | 1.751 | 2.301 | 11.189 |
| 43200@192k Playback | processing-to-display | 13.168 | 17.106 | 17.896 | 23.527 |
| 43200@192k Playback | total end-to-end | 13.946 | 17.763 | 18.731 | 24.061 |

Raspberry Pi 5 결과표(§5.1)는 측정 후 같은 방식으로 채운다.

## 6. QAS-2 판정

QAS-2 판정은 배포 대상인 Raspberry Pi 5 결과를 기준으로 한다(Windows는 참고치). Raspberry Pi 5 기준 두 조건 모두 충족한다.

| Requirement | 21600@48k (Sim/Playback/Live) | 43200@192k (Sim/Playback) |
|---|---|---|
| E2E worst-case <= one beat period | Pass (worst 43.939 <= 166.667 ms) | Pass (worst 34.562 <= 83.333 ms) |
| dropped audio samples = 0 | Pass | Pass |
| missed beat detections = 0 | Pass | Pass |
| report avg/p95/p99/worst for latency legs | Pass | Pass |

## 7. 제한 사항

1. Live 경로는 USB 마이크가 capture source로 감지된 상태에서만 측정할 수 있다.
2. 43200 BPH(하이비트) 무브먼트를 확보하지 못해 해당 조건의 Live는 두 플랫폼 모두에서 수행하지 않는다. 또한 같은 이유로 실녹음 WAV이 없어 43200 BPH Playback은 합성 WAV으로 대체했다(§4 출처 참조). 따라서 43200 BPH 조건은 실음향 입력 경로 검증이 빠져 있다.
3. CSV에는 wall-clock timestamp가 없으므로 실행 시간 분포는 frame count와 latency 값으로만 분석한다.
4. 이번 실험은 Rate/Scope 탭이 활성화된 상태의 GUI 결과다. 다른 탭, 특히 Spectrogram/Sound Print 등 이미지 중심 탭은 별도 측정이 필요할 수 있다.

## 8. 결론

Raspberry Pi 5(주 대상)에서 21600 BPH @ 48 kHz, 43200 BPH @ 192 kHz 두 조건을 Simulation/Playback/Live(43200 BPH는 Sim/Playback) 입력 모드로 측정한 결과, worst-case E2E latency가 모두 비트 주기 예산 안에 들어왔고 dropped audio samples·missed beat detections는 전부 0이었다. 가장 빡빡한 43200 BPH @ 192 kHz에서도 worst E2E는 34.562 ms로 예산 83.333 ms의 약 41.5% 수준이었다. Windows(참고) 5 run도 모두 예산 안에 들어왔다. 따라서 QAS-2 latency 목표는 두 조건·세 입력 모드에서 충족한다.

입력 모드별로 보면, Pi에서 Live(21600 BPH)의 E2E avg가 3.908 ms로 Sim/Playback보다 낮았는데, 이는 processing-to-display 평균이 1.269 ms로 가장 짧았기 때문이다. 반면 capture-to-processing은 Live가 2.639 ms로 가장 높아, 실제 캡처 경로의 입력 지연이 반영된 것으로 보인다.
