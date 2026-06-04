# Quality Attribute Scenarios (QAS)

## 1. Long-Term Performance Graph

### QAS-1: Performance
- **Source of Stimulus:** System timer / continuous data input  
- **Stimulus:** Continuous data collection over several hours  
- **Environment:** Long-duration test execution (≥ 6 hours)  
- **Artifact:** Data recording and graph rendering components  
- **Response:** The system reduces update frequency and aggregates data  
- **Response Measure:** CPU ≤ 30%, update latency ≤ 1s, no UI freeze

**Sentence:**  
When continuous data collection occurs over several hours during long-duration test execution, the system reduces update frequency and aggregates data within the data recording and graph rendering components, ensuring CPU usage stays below 30%, update latency remains under 1 second, and no UI freezing occurs.

---

### QAS-2: Scalability
- **Source of Stimulus:** Incoming data stream  
- **Stimulus:** Increasing number of data points  
- **Environment:** Extended runtime  
- **Artifact:** Data storage and visualization module  
- **Response:** System applies sampling or aggregation  
- **Response Measure:** Rendering ≤ 1s, bounded memory usage

**Sentence:**  
When the number of data points increases during extended runtime, the system applies sampling or aggregation in the data storage and visualization module, ensuring rendering time remains under 1 second and memory usage stays bounded.
