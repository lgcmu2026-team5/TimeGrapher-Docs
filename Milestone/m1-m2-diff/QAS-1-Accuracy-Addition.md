# QAS-1 Accuracy Addition

## Rationale (English)

**QAS-1 · Accuracy — From Acoustic Event Detection to Computed Watch Metrics** has been added as a new Quality Attribute Scenario in the milestone documents.

### Reasons for Addition

1. **Project Requirements Document**: Accuracy is explicitly specified in the project requirements as a foundational concern. The document emphasizes that the system must detect acoustic events with sufficient precision and preserve timing accuracy throughout the entire pipeline (acquisition → filtering → event detection → calculation).

2. **Stakeholder Input**: During meetings with key stakeholders (Customer representatives Dan and Steve), accuracy was consistently highlighted as a critical quality attribute. Both emphasized that all downstream measurements (rate, beat error, amplitude, lift angle, BPH, and balance-wheel frequency) are derived from event detection precision. Any error in this foundational stage propagates into all computed outputs.

3. **Architectural Significance**: Without explicit accuracy requirements, the system could optimize for performance or reliability at the expense of measurement correctness. By making accuracy a top-level quality attribute scenario, we ensure that the architecture preserves timing precision and prioritizes clean signal measurement on known reference values (Sim/Playback mode).

### Content

QAS-1 defines:
- **Stimulus**: Clean acoustic signal data flowing through the acquisition → filtering → event detection → calculation pipeline
- **Response**: Correct identification of onset (A event) and peak (C event) of each beat
- **Response Measure**: Computed rate must be within ±1.0 s/d of reference over ≥ 1,000 consecutive beats (on clean Sim/Playback input with known reference values)
- **Rationale for Threshold**: ±1.0 s/d represents one-eighth of the tightest Witschi chronometer grade band, ensuring measured values are trustworthy indicators

### Renumbering Impact

With the addition of QAS-1, all subsequent quality attribute scenarios have been renumbered:
- QAS-1 (Accuracy) — new addition
- QAS-2 (Performance/Latency, formerly QAS-1)
- QAS-3 (Reliability, formerly QAS-2)
- QAS-4 (Consistency, formerly QAS-3)
- QAS-5 (Modifiability/Extensibility, formerly QAS-4)
- QAS-6 (Usability, formerly QAS-5)

All internal cross-references and links have been updated across all milestone documents.

---

## 근거 (한국어)

**QAS-1 · Accuracy — 음향 이벤트 검출에서 시계 지표 계산까지의 정확도**가 마일스톤 문서에 새로운 Quality Attribute Scenario로 추가되었습니다.

### 추가 사유

1. **프로젝트 요구사항 문서**: 정확도는 프로젝트 요구사항 문서에 명시적으로 지정되어 있습니다. 문서는 시스템이 음향 이벤트를 충분한 정밀도로 검출하고 전체 파이프라인(취득 → 필터링 → 이벤트 검출 → 계산)에서 타이밍 정확도를 유지해야 함을 강조합니다.

2. **이해관계자 입력**: 핵심 이해관계자(고객 담당자 Dan과 Steve)와의 미팅에서 정확도는 지속적으로 중요한 Quality Attribute로 강조되었습니다. 두 담당자 모두 모든 후속 측정값(rate, beat error, amplitude, lift angle, BPH, balance-wheel frequency)이 이벤트 검출 정밀도에서 파생되며, 이 기초 단계의 모든 오류가 모든 계산된 출력에 전파된다는 점을 강조했습니다.

3. **아키텍처 중요성**: 명시적인 정확도 요구사항이 없으면, 시스템이 측정 정확성을 희생하면서 성능이나 신뢰성을 최적화할 수 있습니다. 정확도를 최상위 Quality Attribute Scenario로 정립함으로써, 아키텍처가 타이밍 정밀도를 유지하고 알려진 참조값에 대한 깨끗한 신호 측정을 우선시하도록 보장합니다(Sim/Playback 모드).

### 내용

QAS-1은 다음을 정의합니다:
- **자극(Stimulus)**: 취득 → 필터링 → 이벤트 검출 → 계산 파이프라인을 통과하는 깨끗한 음향 신호 데이터
- **응답(Response)**: 각 비트의 시작(A 이벤트)과 피크(C 이벤트)를 정확하게 식별
- **응답 측정(Response Measure)**: 계산된 rate는 참조값 대비 ±1.0 s/d 이내여야 하며, 연속 1,000개 이상의 비트에서 유지(깨끗한 Sim/Playback 입력, 알려진 참조값)
- **임계값 근거**: ±1.0 s/d는 가장 까다로운 Witschi chronometer 등급 범위의 1/8을 나타내며, 측정값이 신뢰할 수 있는 지표임을 보장

### 번호 재정렬의 영향

QAS-1 추가에 따라 모든 후속 Quality Attribute Scenario가 재번호화되었습니다:
- QAS-1 (Accuracy) — 신규 추가
- QAS-2 (Performance/Latency, 이전 QAS-1)
- QAS-3 (Reliability, 이전 QAS-2)
- QAS-4 (Consistency, 이전 QAS-3)
- QAS-5 (Modifiability/Extensibility, 이전 QAS-4)
- QAS-6 (Usability, 이전 QAS-5)

모든 마일스톤 문서에 걸쳐 모든 내부 교차참조 및 링크가 업데이트되었습니다.
