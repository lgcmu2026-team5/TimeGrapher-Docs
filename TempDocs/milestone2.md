# Milestone 2 Review Q&A

---

## Project Plan

---

### How has the plan changed? / 계획이 어떻게 변경되었는가?

**English**

Several significant changes were made since Milestone 1:

1. **QAS-2 criterion replaced.** The original latency target (p99 ≤ 500 ms) was replaced with a beat-period-based hard deadline: ≤ 83.3 ms at 43200 BPH @ 192 kHz and ≤ 166.7 ms at 21600 BPH @ 48 kHz. This change was driven by M1 feedback (#98) recognizing that 500 ms is a GUI-responsiveness limit, not a real-time beat-analysis limit.

2. **Platform decision locked.** Qt/C++ was replaced by .NET (C#) + Avalonia UI after EXP-01 confirmed GPU-accelerated rendering (GLX/EGL ≈ 60 FPS) on the RPi5 was viable. This also eliminated R-16 (learning curve risk).

3. **Sample rate range confirmed.** The stretch goal of 192 kHz was elevated to a fully supported rate after EXP-02 showed 43200 BPH @ 192 kHz running at only ~41% of the latency budget with zero block drops.

4. **Architecture changed from MVC to MVVM.** The legacy MVC-style MainWindow was refactored into three MVVM roles (View / ViewModel / RunCommandService with State Pattern), driven by QAS-5 modifiability requirements.

5. **Documentation consolidated.** Separate per-milestone documents were merged into one evolving document set (M1 feedback #172), reducing version drift.

6. **ADR set introduced.** Four Architecture Decision Records (ADR-001 through ADR-004) were written in M2 to formally capture key decisions.

**한국어**

Milestone 1 이후 다음과 같은 주요 변경사항이 있었습니다:

1. **QAS-2 기준 교체.** 기존 지연 목표(p99 ≤ 500 ms)가 비트 주기 기반 하드 데드라인(43200 BPH @ 192 kHz에서 ≤ 83.3 ms, 21600 BPH @ 48 kHz에서 ≤ 166.7 ms)으로 교체되었습니다. M1 피드백(#98)을 반영한 것으로, 500 ms는 GUI 반응 속도 기준이지 실시간 비트 분석 기준이 아님을 인식한 결과입니다.

2. **플랫폼 결정 확정.** EXP-01에서 RPi5의 GPU 가속 렌더링(GLX/EGL ≈ 60 FPS)이 실용적임을 확인한 후, Qt/C++를 .NET(C#) + Avalonia UI로 전환하고 이를 고정했습니다. R-16(학습 곡선 리스크)도 이로써 해소되었습니다.

3. **샘플 레이트 범위 확정.** EXP-02에서 43200 BPH @ 192 kHz가 지연 예산의 ~41%만 사용하고 블록 드롭이 없음을 확인하여, 192 kHz가 완전 지원 레이트로 격상되었습니다.

4. **아키텍처 MVC → MVVM 전환.** 기존 MVC 스타일 MainWindow를 View / ViewModel / RunCommandService(State Pattern) 세 가지 MVVM 역할로 분리했습니다. QAS-5 수정성 요구사항이 동인이었습니다.

5. **문서 통합.** 마일스톤별로 분리되어 있던 문서를 하나의 진화형 문서 세트로 통합했습니다(M1 피드백 #172).

6. **ADR 세트 신설.** 핵심 결정을 공식화하기 위해 M2에서 ADR-001~004를 작성했습니다.

---

### Has the team been actively assessing risk and updating the plan accordingly? / 팀이 리스크를 지속적으로 평가하고, 그에 따라 계획을 업데이트하고 있는가?

**English**

Yes. The evidence is concrete:

- **10 risks resolved** (R-01 through R-05, R-08 through R-12) with specific experimental evidence cited for each resolution.
- **Risk statuses updated** based on experiment outcomes: R-01 and R-03 moved from Medium probability to Low/Resolved after EXP-02 measured actual latency; R-04 moved to Resolved after EXP-05 confirmed flat RSS over 24 hours.
- **Risk probability re-graded:** R-01 downgraded from Medium/High to Low/High after measurement.
- **New risks added as discovered:** R-19 (single RPi5) was accepted with the mitigation note that a second RPi5 was later obtained.
- **M1 feedback directly fed risk updates:** the QAS-2 criterion change (M1 feedback #98) was reflected in R-01, R-02, R-03 risk descriptions within days.
- **R-06 and R-07 remain "In progress"** with explicit current-status notes and outstanding items listed, showing active tracking rather than stale entries.

**한국어**

네, 구체적인 증거가 있습니다:

- **10개 리스크 해소** (R-01~R-05, R-08~R-12): 각 해소에 실험적 근거가 명시되어 있습니다.
- **리스크 상태가 실험 결과에 따라 업데이트:** EXP-02 측정 후 R-01·R-03이 중간/해소로 전환; EXP-05에서 RSS 플랫 확인 후 R-04가 해소됨.
- **리스크 확률 재산정:** R-01이 실측 후 중간(Medium) → 낮음(Low)으로 하향됨.
- **발견 시 신규 리스크 추가:** R-19(RPi5 1대)는 이후 2대 확보로 완화 조치가 기재됨.
- **M1 피드백이 리스크 업데이트에 직결:** QAS-2 기준 변경(M1 피드백 #98)이 며칠 내에 R-01, R-02, R-03 설명에 반영됨.
- **R-06, R-07은 "진행 중"으로 명시적인 현황 주석과 미완 항목이 기재되어** 방치가 아닌 능동적 추적 중임을 보여줍니다.

---

### Does the team have a plan for any remaining significant issues/risks? / 남아있는 주요 문제나 리스크에 대한 대응 계획이 있는가?

**English**

Yes. Three open risks remain with explicit plans:

| Risk | Status | Plan |
|------|--------|------|
| **R-06** — A/C event detection accuracy (< 0.1 ms) | In progress | EXP-06 Step 1 (Realistic-off simulation) completed 2026-06-21; Step 2 (Weishi Timegrapher comparison) planned 2026-06-22 to 2026-06-25 |
| **R-07** — Noisy/weak signals produce misleading values | In progress | "Signal weak" UI state in progress; test per noise level planned; rule: improve the logic if needed |
| **R-17** — On-device TinyML uncertainty | In progress | EXP-04 planned for Milestone 3 (2026-06-23 to 2026-06-25); rule-based fallback (`PllMatchGate`) implemented as safety net |

**한국어**

네. 3개의 미해소 리스크에 대해 구체적인 계획이 존재합니다:

| 리스크 | 상태 | 대응 계획 |
|--------|------|-----------|
| **R-06** — A/C 이벤트 검출 정확도(0.1 ms 미만) | 진행 중 | EXP-06 1단계(Realistic-off 시뮬레이션) 2026-06-21 완료; 2단계(Weishi Timegrapher 비교) 2026-06-22~25 예정 |
| **R-07** — 노이즈·약한 신호 시 오도값 표시 | 진행 중 | "신호 약함" UI 상태 구현 중; 노이즈 레벨별 테스트 계획; 필요 시 로직 개선 |
| **R-17** — 온디바이스 TinyML 불확실성 | 진행 중 | EXP-04가 Milestone 3(2026-06-23~25) 예정; 규칙 기반 폴백(`PllMatchGate`) 이미 구현됨 |

---

### Does the team have a reasonable construction plan? / 현실적인 구축(구현) 계획을 가지고 있는가?

**English**

Yes. The construction plan is feature-allocated, team-member-assigned, and time-bounded:

- **12 functional feature groups (G01–G12)** were assigned to three sub-teams. As of 2026-06-21 (today is 2026-06-22), 11 of 12 are complete; G09 has two sub-items (FR-09-04, FR-09-05) still in progress with a target of 2026-06-23.
- **QAS-5 budget of 8 person-days per feature** was used as the workload reference (16 days × 6 members ÷ 12 features).
- Milestone 3 (2026-06-23 to 2026-07-01) carries: EXP-04 (TinyML), EXP-06 Step 2 (Weishi), zoom-in/out for all graph tabs (G01–G12), Setting Options, Presentation preparation, and Demonstration.
- The plan distinguishes mandatory from optional scope, with the AI feature explicitly isolated as optional with a rule-based fallback.

One concern: the "Project Plan Review" task (#117) was marked "할 일 (To Do)" in the CSV and did not complete in Milestone 2, suggesting the formal plan document itself may not have been fully updated for M2.

**한국어**

네. 구현 계획은 기능별로 할당되고, 팀원별로 배정되며, 기간이 명시되어 있습니다:

- **12개 기능 그룹(G01–G12)**이 3개 소팀에 배분되었습니다. 2026-06-21 기준으로 12개 중 11개 완료; G09만 일부 항목(FR-09-04, FR-09-05)이 2026-06-23 목표로 진행 중입니다.
- **QAS-5의 피처당 8인일 예산**(16일 × 6명 ÷ 12 피처)을 공수 기준으로 사용했습니다.
- Milestone 3(2026-06-23 ~ 2026-07-01)에는 EXP-04(TinyML), EXP-06 2단계(Weishi), 전 탭 줌 인/아웃(G01~G12), Settings 옵션, 발표 준비, 시연 준비가 포함됩니다.
- 필수 범위와 선택 범위를 명확히 구분하고 AI 기능을 규칙 기반 폴백과 함께 선택 범위로 격리했습니다.

한 가지 주의사항: "Project Plan Review" 태스크(#117)가 CSV에서 "할 일(미완)"로 남아 있어, M2 공식 계획 문서 자체의 업데이트가 완전히 이루어지지 않았을 수 있습니다.

---

## Experiments / Results

---

### What experiments have been conducted? / 어떤 실험들이 수행되었는가?

**English**

Five technical experiments have been completed; one is in progress:

| Experiment | Status | Completion date |
|------------|--------|-----------------|
| **EXP-01** — Avalonia rendering backend on RPi5 | Complete | 2026-06-10 |
| **EXP-02** — RPi5 real-time sample-rate ceiling | Complete | 2026-06-15 |
| **EXP-03** — GUI real-time rendering design patterns | Complete | 2026-06-21 |
| **EXP-05** — Long-run stability (24h+) | Complete | 2026-06-16 |
| **EXP-06 Step 1** — Measurement accuracy (Realistic-off simulation) | Complete | 2026-06-21 |
| **EXP-06 Step 2** — Measurement accuracy (Weishi comparison) | In progress | Planned 2026-06-22~25 |
| **EXP-04** — On-device TinyML inference feasibility | In progress | Planned M3 (2026-06-23~25) |

**한국어**

5개의 technical experiment가 완료되었고, 1개가 진행 중입니다:

| 실험 | 상태 | 완료일 |
|------|------|--------|
| **EXP-01** — RPi5에서의 Avalonia 렌더링 백엔드 | 완료 | 2026-06-10 |
| **EXP-02** — RPi5 실시간 샘플레이트 상한 | 완료 | 2026-06-15 |
| **EXP-03** — GUI 실시간 렌더링 설계 패턴 | 완료 | 2026-06-21 |
| **EXP-05** — 장기 안정성(24시간+) | 완료 | 2026-06-16 |
| **EXP-06 1단계** — 측정 정확도(Realistic-off 시뮬레이션) | 완료 | 2026-06-21 |
| **EXP-06 2단계** — 측정 정확도(Weishi 비교) | 진행 중 | 2026-06-22~25 예정 |
| **EXP-04** — 온디바이스 TinyML 추론 타당성 | 진행 중 | M3(2026-06-23~25) 예정 |

---

### Have the results addressed the open questions/issues? / 실험 결과가 기존의 의문점이나 문제를 해결했는가?

**English**

Largely yes, with one significant item still outstanding:

- **EXP-01**: Confirmed GPU-first rendering is safe on RPi5 (GLX ≈ 59.2 FPS, EGL ≈ 60 FPS). The reported community slowdown was not reproduced. → R-05 closed.
- **EXP-02**: Confirmed 43200 BPH @ 192 kHz uses only ~41% of the 83.3 ms budget (worst-case 36.46 ms) with zero block drops and zero missed beats on RPi5. → R-01, R-03 resolved.
- **EXP-03**: Confirmed that Pipe-and-Filter + Producer–Consumer + Latest-Wins + fixed buffer pool eliminates UI-thread blocking. All 13 tabs measured below 83.3 ms budget (slowest: Filter Scope at 36.46 ms). → R-02 resolved.
- **EXP-05**: Confirmed RSS flat at ~406 MB over 24 hours with no CPU degradation. → R-04 resolved.
- **EXP-06 Step 1**: First pass on clean Realistic-off simulation confirmed rate, amplitude, and beat error are within tolerance. **Step 2 (commercial Weishi comparison) is still outstanding** — the most significant remaining open question for R-06 / QAS-1.

**한국어**

대부분 해결되었으나, 한 가지 중요한 항목이 아직 미완입니다:

- **EXP-01**: RPi5에서 GPU 우선 렌더링이 안전함을 확인(GLX ≈ 59.2 FPS, EGL ≈ 60 FPS). 커뮤니티에서 보고된 느린 현상은 재현되지 않음 → R-05 해소.
- **EXP-02**: 43200 BPH @ 192 kHz가 83.3 ms 예산의 ~41%만 사용(최악 36.46 ms), RPi5에서 블록 드롭·비트 미검출 0 확인 → R-01, R-03 해소.
- **EXP-03**: Pipe-and-Filter + Producer–Consumer + Latest-Wins + 고정 버퍼 풀이 UI 스레드 블로킹을 제거함 확인. 13개 탭 전부 83.3 ms 예산 이내(최악 Filter Scope 36.46 ms) → R-02 해소.
- **EXP-05**: 24시간 동안 RSS ~406 MB로 플랫, CPU 저하 없음 확인 → R-04 해소.
- **EXP-06 1단계**: Realistic-off 시뮬레이션에서 rate·amplitude·beat error가 허용 오차 이내임을 1차 확인. **2단계(상업용 Weishi Timegrapher 비교)는 아직 미완** — R-06 / QAS-1에 대한 가장 중요한 미결 의문 사항.

---

### What experiments remain? / 앞으로 남아있는 실험은 무엇인가?

**English**

- **EXP-06 Step 2** (Weishi Timegrapher comparison) — planned 2026-06-22 to 2026-06-25. This is the verification that closes R-06 and satisfies QAS-1.
- **EXP-04** (On-device TinyML inference feasibility) — planned Milestone 3 (2026-06-23 to 2026-06-25). Addresses R-17. A Go/Conditional/No-Go decision on TinyML adoption will be the output.

**한국어**

- **EXP-06 2단계** (Weishi Timegrapher 비교) — 2026-06-22~25 예정. R-06을 해소하고 QAS-1을 충족하는 검증입니다.
- **EXP-04** (온디바이스 TinyML 추론 타당성) — Milestone 3(2026-06-23~25) 예정. R-17을 다루며, TinyML 채택에 대한 Go/Conditional/No-Go 결정을 산출합니다.

---

### Are the experiments focused on issues relevant to the overall goals? / 해당 실험들은 시스템 전체 목표와 관련된 문제에 집중하고 있는가?

**English**

Yes, with a clear mapping:

- **EXP-01, 02, 03, 05** → QAS-2 (Performance/Latency) — the highest-ranked quality attribute (Rank 1).
- **EXP-06** → QAS-1 (Accuracy) — directly tests whether the core measurement purpose of the system (rate, amplitude, beat error) is trustworthy.
- **EXP-04** → QAS-2 + QAS-3 — tests whether the optional AI enhancement can be added without breaking real-time behavior or measurement reliability.

All experiments were targeted at the top-rated risks (High probability × High impact) and the top QAS priorities, confirming deliberate focus rather than opportunistic exploration.

**한국어**

네, 명확한 매핑이 존재합니다:

- **EXP-01, 02, 03, 05** → QAS-2(성능/지연) — 최우선 품질 속성(순위 1).
- **EXP-06** → QAS-1(정확도) — 시스템의 핵심 측정 목적(rate, amplitude, beat error)의 신뢰성을 직접 검증.
- **EXP-04** → QAS-2 + QAS-3 — 선택 AI 기능 추가 시 실시간 동작 또는 측정 신뢰성이 깨지지 않는지 검증.

모든 실험이 최고 등급 리스크(고확률 × 고영향)와 최우선 QAS에 집중되어 있어, 기회주의적 탐색이 아닌 의도적 집중을 보여줍니다.

---

## Architecture

---

### Module View / 코드 구조 관점

**English**

The team created two module views:

**1. MVVM Responsibility Flow** — shows one-way «use» dependencies across three layers:
- **View Layer** (Main Window, Graph Tabs Window, Graph Rendering) → uses `MainWindowViewModel`
- **ViewModel Layer** (`MainWindowViewModel`, Run/session coordination, Input/display coordination) → uses Core modules
- **Model Layer** (`Core.Analysis·Detection`, `Core.Metrics·AudioIo·Imaging`, `Core.Shared`, `Platform.WindowsAudio·LinuxAudio`) → no upward dependencies

Key constraint: ViewModel holds no Avalonia/View types (enforced by `ViewModelPurityTests`). The Model (`Core`) has zero external dependencies.

**2. Project-Level Module Uses** — shows that `TimeGrapher.App` uses `TimeGrapher.Core` and conditionally `WindowsAudio` or `LinuxAudio`; `TimeGrapher.Verify` uses `Core`; `Core` depends on nothing.

**3. Core-Internal Module Uses** — decomposes Core into `Analysis`, `Detection`, `Detection.Scoring`, `Metrics`, `Imaging`, `AudioIo`, `Sim`, and `Shared`, with `Shared` having zero dependencies.

**한국어**

팀은 두 가지 모듈 뷰를 작성했습니다:

**1. MVVM 책임 흐름** — 세 레이어 간의 단방향 «use» 의존성을 보여줍니다:
- **View Layer** (Main Window, Graph Tabs Window, Graph Rendering) → `MainWindowViewModel` 사용
- **ViewModel Layer** (`MainWindowViewModel`, Run/세션 조정, 입력/표시 조정) → Core 모듈 사용
- **Model Layer** (`Core.Analysis·Detection`, `Core.Metrics·AudioIo·Imaging`, `Core.Shared`, `Platform.WindowsAudio·LinuxAudio`) → 상향 의존 없음

핵심 제약: ViewModel은 Avalonia/View 타입을 보유하지 않음(`ViewModelPurityTests`로 강제). Model(`Core`)은 외부 의존성이 없음.

**2. 프로젝트 수준 모듈 Uses** — `TimeGrapher.App`이 `TimeGrapher.Core`와 조건부로 `WindowsAudio` 또는 `LinuxAudio`를 사용; `TimeGrapher.Verify`가 `Core`를 사용; `Core`는 아무것도 의존하지 않음.

**3. Core 내부 모듈 Uses** — Core를 `Analysis`, `Detection`, `Detection.Scoring`, `Metrics`, `Imaging`, `AudioIo`, `Sim`, `Shared`로 분해하며, `Shared`는 의존성이 없음.

---

### Runtime / C&C View / 실행 관점

**English**

The runtime view is presented through two sequence diagrams and one state machine:

**Runtime Data Flow (from Architectural Approaches):**
`Input Sources (Live/Playback/Sim)` → `Shared Audio Buffer` → `Analysis Worker (Detector → Metrics → SoundImage → Recorder)` → `AnalysisFrame` → `UI Thread`

This is a one-way Pipe-and-Filter flow. The analysis worker runs on a dedicated `ThreadPriority.Highest` thread; the UI thread only renders.

**Level 1 Sequence Diagram:** covers the full run lifecycle — User → View → ViewModel → RunCommandService → Model (RunSessionController + workers).

**Level 2 Sequence Diagram:** expands the analysis loop — `MasterAudioBuffer` → `AnalysisWorker` → `Core pipeline (Detection / Metrics / Projectors)` — showing the recurring cycle that must complete within one beat period.

**State Machine:** defines transitions among Stopped → Starting → Running ⇄ Paused → Stopping → StopFailed, managed by `RunCommandService` using the State Pattern.

Key C&C connectors: Producer–Consumer shared buffer (input↔analysis), Observer fan-out (`AnalysisFrameRouter`), Latest-Wins scheduler (analysis→UI).

**한국어**

런타임 뷰는 2개의 시퀀스 다이어그램과 1개의 상태 머신으로 제시됩니다:

**런타임 데이터 흐름:**
`입력 소스(Live/Playback/Sim)` → `공유 오디오 버퍼` → `분석 워커(Detector → Metrics → SoundImage → Recorder)` → `AnalysisFrame` → `UI 스레드`

이는 단방향 Pipe-and-Filter 흐름입니다. 분석 워커는 `ThreadPriority.Highest` 전용 스레드에서 실행되며, UI 스레드는 렌더링만 수행합니다.

**Level 1 시퀀스 다이어그램:** User → View → ViewModel → RunCommandService → Model(RunSessionController + workers)로 이어지는 전체 실행 생명주기를 다룹니다.

**Level 2 시퀀스 다이어그램:** `MasterAudioBuffer` → `AnalysisWorker` → `Core 파이프라인(Detection / Metrics / Projectors)`으로 이어지는 분석 루프를 전개하며, 하나의 비트 주기 안에 완료되어야 하는 반복 주기를 보여줍니다.

**상태 머신:** Stopped → Starting → Running ⇄ Paused → Stopping → StopFailed 간의 전이를 State Pattern으로 관리합니다.

주요 C&C 커넥터: Producer–Consumer 공유 버퍼(입력↔분석), Observer 팬아웃(`AnalysisFrameRouter`), Latest-Wins 스케줄러(분석→UI).

---

### Deployment View / 배포 관점

**English**

The deployment view shows three stages:

1. **Develop & Share** — Developers work on Windows PCs in C#/.NET and push code to the Git server (GitHub).
2. **Verify & Build** — On each push, CI/CD (GitHub Actions, completed 2026-06-20) runs build/test verification; on `tag v*`, it builds separate deploy targets for Windows (x64) and Raspberry Pi (ARM64).
3. **Deploy & Install** — Built targets are distributed over the network and installed on each node.

**Runtime hardware allocation:**
- **Raspberry Pi 5** (8 GB RAM, 128 GB microSD, 1280×800 touchscreen): the primary production target. Runs `LinuxAudio` adapter (ALSA/PipeWire), Avalonia UI (GPU-first via GLX/EGL), and the full analysis pipeline.
- **Windows 11 PC** (x64): the development and reference measurement platform. Runs `WindowsAudio` adapter (NAudio/WASAPI).

**External signal path:** Mechanical watch → microphone/pickup → USB audio → audio input of each node. This path is independent of the software deployment flow.

**한국어**

배포 뷰는 3단계를 보여줍니다:

1. **개발 & 공유** — 개발자들이 Windows PC에서 C#/.NET으로 작업하고 Git 서버(GitHub)에 push합니다.
2. **검증 & 빌드** — 각 push마다 CI/CD(GitHub Actions, 2026-06-20 완료)가 빌드/테스트 검증을 수행; `tag v*` 이벤트에서 Windows(x64)와 Raspberry Pi(ARM64) 별도 배포 타겟을 빌드합니다.
3. **배포 & 설치** — 빌드된 타겟이 네트워크를 통해 배포되고 각 노드에 설치됩니다.

**런타임 하드웨어 할당:**
- **Raspberry Pi 5** (8 GB RAM, 128 GB microSD, 1280×800 터치스크린): 주요 프로덕션 타겟. `LinuxAudio` 어댑터(ALSA/PipeWire), Avalonia UI(GLX/EGL GPU 우선), 전체 분석 파이프라인 실행.
- **Windows 11 PC** (x64): 개발 및 기준 측정 플랫폼. `WindowsAudio` 어댑터(NAudio/WASAPI) 실행.

**외부 신호 경로:** 기계식 시계 → 마이크/픽업 → USB 오디오 → 각 노드의 오디오 입력. 이 경로는 소프트웨어 배포 흐름과 독립적입니다.

---

## 추가 검토 사항 / Additional Review Items

---

### Have experiments led to architecture refinement? / 실험 결과를 통해 아키텍처가 개선되었는가?

**English**

Yes, directly and substantially:

- **EXP-01** → locked the Avalonia GPU-first rendering backend (no forced SW fallback needed). Architecture startup config was updated.
- **EXP-02** → fixed the supported sample rate range (48k base / 192k top) and determined that a single latency gate (≤ one beat period) is the right criterion, replacing the original p99 ≤ 500 ms criterion.
- **EXP-03** → introduced the Pipe-and-Filter + concurrency tactics that became the permanent architecture: dedicated analysis thread at `ThreadPriority.Highest`, `AnalysisFrameRouter` Observer fan-out, Latest-Wins scheduler, fixed buffer pool (`PublishBufferCount = 3`), and `DecimatingSeries` for long-term data bounding. These are now in production source (`AnalysisFrameRouter.cs`, `DecimatingSeries.cs`, `AnalysisWorker.cs`).
- **EXP-05** → confirmed no need for additional buffer caps or aggregation structures; keeps the current architecture.
- **MVC → MVVM refactoring** was also an architecture refinement driven by QAS-5 feedback and the modifiability demands from M1 review.

**한국어**

네, 직접적이고 실질적으로 개선되었습니다:

- **EXP-01** → Avalonia GPU 우선 렌더링 백엔드 고정(SW 폴백 불필요). 앱 시작 설정이 업데이트됨.
- **EXP-02** → 지원 샘플레이트 범위(48k 기본 / 192k 상한) 확정, 원래 p99 ≤ 500 ms 기준을 "비트 주기 이내" 단일 게이트로 교체.
- **EXP-03** → Pipe-and-Filter + 동시성 전술이 영구 아키텍처로 채택: 전용 분석 스레드(`ThreadPriority.Highest`), `AnalysisFrameRouter` Observer 팬아웃, Latest-Wins 스케줄러, 고정 버퍼 풀(`PublishBufferCount = 3`), `DecimatingSeries`. 현재 프로덕션 소스에 반영됨.
- **EXP-05** → 추가적인 버퍼 캡이나 집계 구조가 필요 없음을 확인; 현재 아키텍처 유지.
- **MVC → MVVM 리팩토링**도 QAS-5 피드백과 M1 리뷰의 수정성 요구사항에 의해 촉발된 아키텍처 개선임.

---

### Does the team understand the approaches and tradeoffs? / 선택한 아키텍처 접근 방식과 그 트레이드오프를 충분히 이해하고 있는가?

**English**

Yes. EXP-03 contains an explicit SAP-grounded trade-off analysis:

- **Pipe-and-Filter benefits:** maximized modifiability (new tabs/filters inject without changing existing code); improved portability (backend decoupled from Avalonia).
- **Pipe-and-Filter cost:** data-copy overhead when passing large snapshots (SoundPrint ~2.67 MB, Spectrogram ~1.92 MB). **Mitigation acknowledged:** fixed buffer pool eliminates GC spikes and LOH pollution.
- **Concurrency-isolation benefits:** UI never blocks even under heavy rendering; Latest-Wins prevents backlog accumulation.
- **Concurrency cost:** intermediate frames are dropped (frame drop / recency bias). **Mitigation acknowledged and justified:** for a real-time monitor, showing the latest state without lag is more important than preserving past frames; long-term history is supplemented by `DecimatingSeries`.

The team explicitly names which SAP tactics apply to which QAS, demonstrating conceptual fluency, not just implementation.

**한국어**

네. EXP-03에 SAP(Software Architecture in Practice) 기반의 명시적 트레이드오프 분석이 포함되어 있습니다:

- **Pipe-and-Filter 이점:** 수정성 극대화(새 탭/필터가 기존 코드 변경 없이 주입 가능); 이식성 향상(백엔드가 Avalonia에서 분리됨).
- **Pipe-and-Filter 비용:** 대용량 스냅샷(SoundPrint ~2.67 MB, Spectrogram ~1.92 MB) 전달 시 데이터 복사 오버헤드. **완화 방법 명시:** 고정 버퍼 풀로 GC 스파이크와 LOH 오염 제거.
- **동시성 격리 이점:** 무거운 렌더링 중에도 UI 스레드가 블로킹되지 않음; Latest-Wins가 백로그 누적을 방지.
- **동시성 비용:** 중간 프레임이 드롭됨(프레임 드롭 / 최신 편향). **완화 방법과 근거 명시:** 실시간 모니터에서는 지연 없이 최신 상태를 보여주는 것이 더 중요하며, 장기 이력은 `DecimatingSeries`로 보완함.

팀은 어떤 SAP 전술이 어떤 QAS에 적용되는지를 명시적으로 연결하고 있어, 단순 구현을 넘어 개념적 이해를 보여줍니다.

---

### Do architectural approaches align with system goals? / 아키텍처가 시스템 목표와 잘 맞는가?

**English**

Yes, the alignment is explicit:

| Goal | Architecture response |
|------|----------------------|
| Real-time beat processing (QAS-2) | Dedicated analysis thread + Latest-Wins + bounded buffers → verified to 43.8% of budget |
| Measurement accuracy (QAS-1) | Single AnalysisFrame source → all displays share identical data (QAS-4); sub-sample interpolation in Detector.cs |
| Reliability under noise (QAS-3) | Signal-quality gating; "signal weak" UI state; rule-based fallback (`PllMatchGate`) |
| Modifiability (QAS-5) | One-way layer rule enforced by `ViewModelPurityTests`; IAnalysisFrameConsumer extension point; ≤ 1 existing module changed per new feature |
| Usability on small touchscreen (QAS-6) | Key-readings-first layout; physical-size-based legibility rules (≥ 2.9 mm letters, ≥ 9 mm touch targets) |
| Cross-platform (C-3) | Adapter pattern isolating `WindowsAudio` (WASAPI) and `LinuxAudio` (ALSA/PipeWire) |

**한국어**

네, 정렬이 명시적입니다:

| 목표 | 아키텍처 대응 |
|------|--------------|
| 실시간 비트 처리(QAS-2) | 전용 분석 스레드 + Latest-Wins + 유한 버퍼 → 예산의 43.8% 사용으로 검증됨 |
| 측정 정확도(QAS-1) | 단일 AnalysisFrame 소스 → 모든 표시가 동일 데이터 공유(QAS-4); Detector.cs의 서브샘플 보간 |
| 노이즈 하 신뢰성(QAS-3) | 신호 품질 게이팅; "신호 약함" UI 상태; 규칙 기반 폴백(`PllMatchGate`) |
| 수정성(QAS-5) | `ViewModelPurityTests`로 단방향 레이어 규칙 강제; IAnalysisFrameConsumer 확장점; 새 기능당 기존 모듈 수정 ≤ 1 |
| 소형 터치스크린 사용성(QAS-6) | 핵심 수치 우선 레이아웃; 물리 크기 기반 가독성 규칙(글자 ≥ 2.9 mm, 터치 타겟 ≥ 9 mm) |
| 크로스플랫폼(C-3) | `WindowsAudio`(WASAPI)와 `LinuxAudio`(ALSA/PipeWire)를 격리하는 Adapter 패턴 |

---

### Are there significant concerns not yet addressed? / 아직 해결되지 않은 중요한 우려사항이 있는가?

**English**

Two significant concerns remain:

1. **R-06 / EXP-06 Step 2 (A/C detection vs. Weishi Timegrapher)** — The clean-signal first pass passed, but the commercial comparison test — which validates the algorithm against real-world watch noise — has not been done. This is the most critical remaining validation for the system's core purpose.

2. **R-07 (Weak/noisy signal handling)** — The "signal weak" UI and underlying logic are described as "in progress." Until tested at defined SNR levels and confirmed to suppress misleading outputs at SNR < 30 dB, QAS-3 is not formally satisfied.

Minor concerns:
- EXP-04 (TinyML) result is open; if adopted, R-17 requires re-running EXP-02/03 under TinyML load to confirm no budget regression.
- G09 FR-09-04 and FR-09-05 remain in progress as of 2026-06-21.

**한국어**

두 가지 중요한 우려사항이 남아 있습니다:

1. **R-06 / EXP-06 2단계(A/C 검출 vs. Weishi Timegrapher)** — 깨끗한 신호 1차 검증은 통과했으나, 실제 시계 노이즈 환경에서 알고리즘을 검증하는 상업용 비교 테스트가 아직 수행되지 않았습니다. 시스템 핵심 목적에 대한 가장 중요한 미완 검증입니다.

2. **R-07(약한/노이즈 신호 처리)** — "신호 약함" UI와 기반 로직이 "진행 중"으로 기술되어 있습니다. 정의된 SNR 레벨에서 테스트되고 SNR < 30 dB에서 오도값 출력이 억제됨이 확인될 때까지 QAS-3은 공식적으로 충족되지 않습니다.

부가적 우려사항:
- EXP-04(TinyML) 결과가 미확정; 채택 시 R-17은 TinyML 부하 하에서 EXP-02/03 재실행을 요구합니다.
- G09 FR-09-04, FR-09-05가 2026-06-21 기준 진행 중입니다.

---

### Has the architecture been evaluated? / 아키텍처에 대한 평가가 수행되었는가?

**English**

Yes, through multiple complementary mechanisms:

1. **Quantitative experiment-based evaluation** — EXP-01 through EXP-05 produced pass/fail measurements against defined QAS thresholds (latency budget, frame rate, RSS trend). These are scenario-based evaluations in the ATAM sense.

2. **Automated structural tests** — `ViewModelPurityTests` enforces the one-way dependency rule at build time. `SyntheticDetectorTests` and `AdverseScenarios` unit tests verify algorithm behavior against known synthetic inputs (EXP-06 Step 1).

3. **ADR-based documented rationale** — Four ADRs record the reasoning behind platform selection (ADR-001 to ADR-004, completed 2026-06-21), including rejected alternatives and rationale.

4. **SAP trade-off analysis** — EXP-03's Results & Analysis section explicitly evaluates each applied pattern/tactic against SAP criteria, naming what is gained and what is given up.

What has not been done: a formal ATAM workshop or structured scenario walkthrough by an external reviewer. The evaluations to date are all internal.

**한국어**

네, 복수의 상호보완적 메커니즘을 통해 평가가 수행되었습니다:

1. **정량적 실험 기반 평가** — EXP-01~05가 정의된 QAS 임계값(지연 예산, 프레임 레이트, RSS 추세)에 대한 Pass/Fail 측정값을 산출했습니다. ATAM 의미의 시나리오 기반 평가에 해당합니다.

2. **자동화된 구조 테스트** — `ViewModelPurityTests`가 빌드 타임에 단방향 의존성 규칙을 강제합니다. `SyntheticDetectorTests`와 `AdverseScenarios` 단위 테스트가 알고리즘 동작을 알려진 합성 입력에 대해 검증합니다(EXP-06 1단계).

3. **ADR 기반 문서화된 근거** — 4개의 ADR이 플랫폼 선택 결정(ADR-001~004, 2026-06-21 완료)의 근거를 기록하며, 거부된 대안과 이유를 포함합니다.

4. **SAP 트레이드오프 분석** — EXP-03의 결과 및 분석 섹션이 각 적용 패턴/전술을 SAP 기준으로 명시적으로 평가하며, 무엇을 얻고 무엇을 포기하는지를 기술합니다.

아직 수행되지 않은 것: 외부 검토자에 의한 공식 ATAM 워크숍 또는 구조화된 시나리오 워크스루. 지금까지의 평가는 모두 내부적으로 이루어졌습니다.
