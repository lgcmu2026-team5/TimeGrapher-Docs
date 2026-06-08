# Architectural Approaches

> Pre-implementation: the structure we plan to build, and why.

**Contents** — [The Architecture at a Glance](#the-architecture-at-a-glance) · [Software Architecture Tactics to Apply](#software-architecture-tactics-to-apply) · [Software Design Patterns to Apply](#software-design-patterns-to-apply)

## The Architecture at a Glance

**input → shared buffer → analysis (worker thread) → one result bundle (AnalysisFrame) → screen (UI thread)**

```mermaid
flowchart LR
    MW[MainWindow<br/>UI coordinator]

    subgraph Input["Input Sources (interchangeable)"]
        AW[TAudioWorker<br/>live mic]
        PW[TPlaybackWorker<br/>WAV playback]
        SW[TSimWorker<br/>synthetic signal]
    end

    BUF[TMasterAudioDataRaw<br/>shared ring buffer]

    subgraph Analysis["Analysis (worker thread)"]
        AN[TAnalysisWorker]
        TG[tg_process<br/>detector core]
        WM[WatchMetrics<br/>rate · beat error · amplitude]
        QG[Signal-quality gate]
        SR[SoundImageRenderer]
        WAV[WavStreamWriter<br/>optional recording → disk]
    end

    DTO[AnalysisFrame<br/>frameId · values · sound image · status · timestamps]

    subgraph Render["Rendering (UI thread)"]
        GR[GraphFrameRenderer]
        G1[Graph 1]
        G2[Graph 2]
        GN[Graph n]
    end

    AW --> BUF
    PW --> BUF
    SW --> BUF

    MW --> AW
    MW --> PW
    MW --> SW
    MW --> AN

    BUF --> AN
    AN --> TG
    TG --> WM
    WM --> QG
    AN --> SR
    SR --> DTO
    AN --> WAV
    QG --> DTO

    DTO --> MW
    MW --> GR
    GR --> G1
    GR --> G2
    GR --> GN
```

- **A one-way flow** — sound in, numbers out — so a pipeline is the natural shape.
- **Heavy analysis on a worker thread; the UI only draws** → the screen never freezes while measuring. (Performance)
- **Every value computed once, delivered as one bundle** → no display ever disagrees with another. (Consistency)
- **Keep measuring while the signal is good enough; below the threshold, show "signal weak" and handle the input appropriately** → a wrong number never reaches the screen. (Availability)

> **Why this shape?** The legacy code lumps capture, analysis, and drawing into one piece, which can't meet a 0.5 s response target or absorb new features. So we split it by role.

## Software Architecture Tactics to Apply

One tactic anchored to each quality goal.

| Quality goal | Tactic | In one line |
|--------------|--------|-------------|
| Performance | introduce concurrency · bound queue/buffer sizes · limit event response | Analysis on a worker thread; bounded buffers; if drawing falls behind, skip stale frames and draw only the newest |
| Availability | graceful degradation | Accept noisy input and keep measuring while the signal is good enough; below the quality threshold, show "signal weak" and handle the input appropriately |
| Consistency | single source of truth (compute once → immutable frame) | Every value computed once and delivered to all displays via one immutable frame — displays cannot disagree |
| Modifiability | increase cohesion · encapsulate · restrict dependencies | Fixed extension points, so a new feature never spreads into existing code |
| Usability | separate the UI (draw-only) · centralize size rules | The UI only draws the frame; letter/touch mm rules live in one renderer, securing legibility and touch use on the small screen |
| Portability & verification | abstract data sources · defer binding | Three inputs unified to one format and swappable; platform-dependent code kept in one place |

## Software Design Patterns to Apply

| Pattern | Where | Role |
|---------|-------|------|
| Strategy | Input sources · filter stages | Mic/playback/Sim and each filter plug in behind one interface, swappable |
| Adapter | Platform audio | Windows (WASAPI) and RPi (ALSA) unified to one capture interface |
| State | Session control | Idle → Measuring ⇄ Paused transitions as state objects (no scattered flags) |
| Observer | Signals/slots (e.g., Qt) | Producers don't know consumers; displays subscribe to the result frame |
| Facade | C detector-core wrapper | Hides the complex C detector core behind one clean call |
| Producer–Consumer | Input ↔ analysis (shared buffer) | Input writes, analysis reads — decoupled so neither waits on the other's pace |
| Pipe-and-Filter | Whole flow | Input → analysis → rendering wired as one-way stages |
