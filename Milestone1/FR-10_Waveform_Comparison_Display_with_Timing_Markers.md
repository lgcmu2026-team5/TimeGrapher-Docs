## 2. Waveform Comparison Display

### QAS-1: Performance
- **Source of Stimulus:** Incoming waveform data  
- **Stimulus:** Multiple waveforms rendered simultaneously  
- **Environment:** Real-time mode  
- **Artifact:** Rendering engine  
- **Response:** System renders aligned waveforms in real time  
- **Response Measure:** Latency ≤ 200ms, FPS ≥ 30

**Sentence:**  
When multiple waveforms need to be rendered simultaneously in real-time mode, the system renders aligned waveforms using the rendering engine, ensuring latency remains below 200 milliseconds and frame rate stays above 30 FPS.

---

### QAS-2: Usability
- **Source of Stimulus:** User  
- **Stimulus:** User compares beats  
- **Environment:** GUI interaction  
- **Artifact:** Waveform display UI  
- **Response:** System provides aligned lanes and markers  
- **Response Measure:** Comparison within 5 seconds, ≥ 90% success rate

**Sentence:**  
When a user attempts to compare beats during GUI interaction, the system provides aligned lanes and timing markers in the waveform display UI, enabling comparison within 5 seconds with at least a 90% success rate.

---

### QAS-3: Flexibility
- **Source of Stimulus:** Advanced user  
- **Stimulus:** User requests marker configuration changes  
- **Environment:** Configurable UI  
- **Artifact:** Display configuration module  
- **Response:** System enables or disables markers  
- **Response Measure:** Response ≤ 0.5s

**Sentence:**  
When an advanced user requests marker configuration changes in a configurable UI environment, the system enables or disables markers via the display configuration module within 0.5 seconds.
