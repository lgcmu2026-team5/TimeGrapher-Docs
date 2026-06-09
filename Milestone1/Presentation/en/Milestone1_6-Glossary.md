# Glossary

> Consolidated glossary for the Team 5 · Milestone 1 presentation documents — the single source of truth for terminology, so every section can reference it consistently. The terms below are referenced throughout the Milestone 1 presentation documents (Architectural Drivers, Risk Assessment, Planned Experiments, Architectural Approaches).

## Domain Terms

Watch-domain vocabulary used throughout the functional requirements.

| Term | Definition |
|------|------------|
| A / B / C (= T1 / T2 / T3) | The three acoustic events produced within a single beat of a Swiss lever escapement. **A (T1)** = the impulse pin strikes the pallet fork — a clean, repeatable event used to determine rate and beat error; **B (T2)** = an escape-wheel tooth slides on the pallet stone — irregular, not used for measurement; **C (T3)** = the escape-wheel tooth locks and the pallet fork strikes the banking pin — the strongest sound, used together with A to calculate amplitude. Measurement uses the A and C events (see [FR-08-04](Milestone1_2-Architectural-Drivers.md#g08--escapement-analyzer-and-marker-line-display)); the filter views F0–F3 help locate and identify them. |
| tick / tock | The two beats the balance produces in alternation over time — one beat per swing of the balance; the swing one way is the **tick**, the return swing is the **tock**. Beat error is the asymmetry between the successive tick and tock intervals; Scope 2 and the Beat Error trace lines display the tick and tock beats separately. Each beat — whether tick or tock — contains its own A/B/C events, so tick/tock (which beat, over time) and A/B/C (which event, within a beat) are different axes, not the same labels. |
| Lift angle | The angular travel of the balance during which the escapement delivers impulse. A per-caliber constant (commonly ~40°–60°) provided as input and used to derive amplitude from the beat signal. |
| BPH (beats per hour) | The number of balance beats (semi-oscillations) per hour — the watch's nominal operating frequency. Typical values: 18000, 21600, 28800 BPH. |
| Beat number | Synonym for the watch's nominal beat rate expressed in BPH; together with the selected interval it parameterizes the Scope 2 measurement cycle. |
| Nominal (beat) rate | The watch's designed/target beat rate (in BPH or beats per second). "Nominal rate" and "nominal beat rate" denote the same quantity; it is used as the synchronization and reference value in the Scope Sweep display. |
| Timing test | A measurement run that produces the watch's primary timing results (daily rate, amplitude, beat error, nominal beat rate). The "most recent timing test" is the latest such run whose results are retained for later reference (see [FR-11-05…08](Milestone1_2-Architectural-Drivers.md#g11--scope-mode-with-synchronized-sweep-display)). |
| Balance-wheel unbalance | A poising error of the balance-and-hairspring assembly that makes the rate differ between vertical positions; it is revealed by a large rate spread across vertical positions (see [FR-04-09](Milestone1_2-Architectural-Drivers.md#g04--multi-position-sequence-display)). |
| Onset / Peak | Signal feature points on a beat's acoustic waveform used as the marker measurement reference: **Onset** = the leading edge (start) of the beat noise; **Peak** = the point of maximum amplitude (see [FR-08-06](Milestone1_2-Architectural-Drivers.md#g08--escapement-analyzer-and-marker-line-display)). |
| Vario (Display) | The long-term rate-and-amplitude stability view (G03) — surfaces each measurement's min / max / average / standard deviation / elapsed time / current value. |

## Quality-Attribute & Measurement Terms

Metrics, units, and standards referenced by the quality attribute scenarios.

| Term | Definition |
|------|------------|
| p99 | The 99th-percentile value — everything except the slowest 1 % falls within this value |
| Google INP | Interaction to Next Paint — Google's web metric for the time from user input to the next screen update (good ≤ 200 ms / poor > 500 ms) || SNR | Signal-to-Noise Ratio (dB) — higher means a cleaner signal |
| person-days | The amount of work one person completes in one day |
| Rate | Seconds the watch gains or loses per day (s/d) |
| Beat error | Asymmetry between the tick and tock intervals (ms) |
| Amplitude | Swing angle of the balance wheel (°) — a key indicator of watch health |
| Sim / Playback | Sim = synthetic watch-signal generator mode (ground truth known in advance); Playback = replay of a recorded file |
| SMPTE | Society of Motion Picture and Television Engineers — source of the viewing-distance / viewing-angle guideline |
| ISO 9241-303 | International ergonomics standard for electronic displays — source of the character-size guideline |
| Glyph | The visual shape of a single character on screen |
| arcmin | Minute of arc (1° = 60 arcmin) — unit for how large something appears to the eye |
| Witschi / Chronometer grade | Witschi — a watch-timing-machine maker whose accuracy grade bands are an industry reference; **Chronometer** is the tightest band (−2…+6 s/d), the basis for the ±3 s/d tolerance |

## Platform & Engineering Terms

Implementation, platform, and process terms referenced by the risk assessment.

| Term | Definition |
|------|------------|
| RPi5 (Raspberry Pi 5) | The single-board computer the system runs on (8 GB RAM, 128 GB microSD) — the target deployment device, with a 1280×800 8-inch touch display attached, running Raspberry Pi OS (Debian-based, 64-bit/ARM64) |
| Sample rate (48k/96k/192k) | Audio samples per second — 96k means 96,000 samples per second |
| block drop / missed beat | Processing falls behind the input, discarding audio blocks or missing beats |
| FPS | Frames Per Second — screen updates per second; low FPS means a stuttering UI |
| RSS | The memory a process actually occupies — steady growth suggests a leak |
| Ground truth | The known correct value used as the verification reference |
| AGC | Auto Gain Control — automatic microphone volume adjustment; must be off before measuring or it distorts the signal |
| WASAPI / ALSA | The audio I/O systems of Windows / Linux — platform differences surface when porting |
| spike | A small experiment to quickly probe a technical limit before real implementation |
| TinyML | Lightweight AI models that run directly on small devices (e.g., RPi) |
| regression | A code change breaking something that used to work |
| SAP | Software Architecture Practice — the architecture method this milestone follows (referenced as "per SAP criteria") |
| Avalonia / Qt | Candidate cross-platform UI frameworks — Avalonia (.NET / C#) and Qt (C++); the UI stack is still under evaluation, not fixed |
| GLX / EGL | Interfaces for GPU-accelerated (hardware) rendering on Linux — the backends compared against software rendering in EXP-01 |
| QAS / FR / QAS-ALL | QAS = quality attribute scenario (Architectural Drivers doc); QAS-ALL = all quality-attribute scenarios (QAS-1…5); FR = functional requirement (Architectural Drivers doc) |
