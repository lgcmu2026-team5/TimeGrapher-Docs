# Glossary

> Consolidated glossary for the Team 5 · Milestone 1 presentation documents. Terms are defined once here so every section can reference them consistently. At present all entries originate in [Milestone 1-2 · Architectural Drivers](Milestone1_2-Architectural-Drivers.md); this file is the shared home for terminology as the remaining sections are filled in.

## Domain Terms

Watch-domain vocabulary used throughout the functional requirements.

| Term | Definition |
|------|------------|
| Tick / Tock (A / C beat) | The two alternating escapement noises produced on each swing of the balance. **A = tick**, **C = tock** (see FR-08-04). The Beat-Noise Scope marks the C beat. |
| Tic / Tac | Alternative spelling of tick / tock used for the Scope 2 traces; **tic = tick = A** and **tac = tock = C**. Treated as the same pair of beat events. |
| T1, T2, T3 | The characteristic timing feature points within a single beat's acoustic waveform (the successive escapement events of one beat). They are the reference events that the filter views F0–F3 help locate and identify, and are distinct from the beat-level A/C labels. |
| Lift angle | The angular travel of the balance during which the escapement delivers impulse. A per-caliber constant (commonly ~40°–60°) provided as input and used to derive amplitude from the beat signal. |
| BPH (beats per hour) | The number of balance beats (semi-oscillations) per hour — the watch's nominal operating frequency. Typical values: 18000, 21600, 28800 BPH. |
| Beat number | Synonym for the watch's nominal beat rate expressed in BPH; together with the selected interval it parameterizes the Scope 2 measurement cycle. |
| Nominal (beat) rate | The watch's designed/target beat rate (in BPH or beats per second). "Nominal rate" and "nominal beat rate" denote the same quantity; it is used as the synchronization and reference value in the Scope Sweep display. |
| Timing test | A measurement run that produces the watch's primary timing results (daily rate, amplitude, beat error, nominal beat rate). The "most recent timing test" is the latest such run whose results are retained for later reference (see FR-11-05…08). |
| Balance-wheel unbalance | A poising error of the balance-and-hairspring assembly that makes the rate differ between vertical positions; it is revealed by a large rate spread across vertical positions (see FR-04-09). |
| Onset / Peak | Signal feature points on a beat's acoustic waveform used as the marker measurement reference: **Onset** = the leading edge (start) of the beat noise; **Peak** = the point of maximum amplitude (see FR-08-06). |

## Quality-Attribute & Measurement Terms

Metrics, units, and standards referenced by the quality attribute scenarios.

| Term | Definition |
|------|------------|
| p99 | The 99th-percentile value — everything except the slowest 1 % falls within this value |
| Google INP | Interaction to Next Paint — Google's web metric for the time from user input to the next screen update (good ≤ 200 ms / poor > 500 ms) |
| SPS | Samples Per Second — the audio sampling rate |
| SNR | Signal-to-Noise Ratio (dB) — higher means a cleaner signal |
| person-days | The amount of work one person completes in one day |
| Rate | Seconds the watch gains or loses per day (s/d) |
| Beat error | Asymmetry between the tick and tock intervals (ms) |
| Amplitude | Swing angle of the balance wheel (°) — a key indicator of watch health |
| Sim / Playback | Sim = synthetic watch-signal generator mode (ground truth known in advance); Playback = replay of a recorded file |
| SMPTE | Society of Motion Picture and Television Engineers — source of the viewing-distance / viewing-angle guideline |
| ISO 9241-303 | International ergonomics standard for electronic displays — source of the character-size guideline |
| Glyph | The visual shape of a single character on screen |
| arcmin | Minute of arc (1° = 60 arcmin) — unit for how large something appears to the eye |
