# TIMEGRAPHER 기술 담당자 인터뷰 정리

- **프로젝트**: Software Architecture Training Course - TIMEGRAPHER 설계 및 구현
- **인터뷰 목적**: 기술 담당자와 요구사항 및 품질 속성 시나리오에 대한 공감대 형성
- **정리 기준**: 자동 전사 원문을 기반으로 중복 발화와 잡음은 정리하고, 요구사항·품질 속성·제약·테스트·후속 조치 관점에서 의미 있는 내용을 빠짐없이 재구성

---

## 1. 전체 결론

이번 인터뷰의 핵심은 **TIMEGRAPHER의 실시간성은 절대적인 즉시성 요구가 아니라, 정확도와 신뢰도를 해치지 않는 범위에서 latency를 최소화하는 best-effort 목표**라는 점이다.

기술 담당자는 특히 다음을 강조했다.

1. **정확도(Accuracy)가 최우선 품질 속성이다.**
   - 빠르게 표시하더라도 값이 틀리면 의미가 없다.
   - 현재 코드에서는 잘못된 입력이나 bad value가 들어오면 표시 숫자가 크게 튈 수 있으므로, bad data를 버리거나 완화하는 처리가 필요하다.

2. **Latency는 그래프 표시 latency와 수치 표시 latency를 분리해서 정의해야 한다.**
   - 파형 그래프의 시각적 표시 latency와 beat rate, beat error, amplitude 등 계산된 숫자의 표시 latency는 다른 문제다.
   - 수치 표시는 일정한 integration time이 필요하므로 500ms 목표는 특히 숫자 표시에는 비현실적일 수 있다.

3. **500ms 목표는 재검토가 필요하다.**
   - 팀이 제안한 “10분 실행 기준 P99 display latency < 500ms”는 처음에는 괜찮아 보인다고 반응했으나, 이후 수치 표시 latency 관점에서는 integration time 때문에 500ms가 어려울 수 있다고 설명했다.
   - 5초 수준은 가능할 수 있다는 대화가 있었으나, 최종 확정값은 아니며 BPH별 integration time 자료를 찾아야 한다.

4. **SNR 30dB에서 95% detection 같은 robust/graceful degradation 수치는 실험으로 검증해야 한다.**
   - 기술 담당자는 해당 SNR 수치를 직접 측정하지 않았으므로 확답할 수 없다고 했다.
   - 제공된 녹음 파일, 팀 보유 시계, synthetic data를 사용해 실제 측정해야 한다.

5. **테스트 입력을 통제해야 한다.**
   - detection rate를 세려면 입력 ground truth가 필요하다.
   - 이상적인 신호를 만들고 noise를 추가하거나, 제공된 sample data를 이용해 synthetic data를 생성하는 방식이 권장되었다.

6. **PC/Windows 오디오 입력 처리 기능이 결과를 망칠 수 있다.**
   - Automatic Gain Control, audio enhancement, input audio processing이 켜져 있으면 알고리즘 결과가 크게 왜곡될 수 있다.
   - PC에서 실행할 경우 해당 기능들을 꺼야 하며, 끌 수 없다면 다른 알고리즘 또는 필터링이 필요할 수 있다.

7. **UI/Usability 기준은 실제 디스플레이 스펙을 다시 확인해야 한다.**
   - 팀이 800px 기준으로 생각한 내용은 잘못되었을 가능성이 크다.
   - 실제 Raspberry Pi용 디스플레이는 800px보다 크며, 툴킷 안의 디스플레이 pamphlet/spec 문서를 확인해야 한다.

8. **요구사항 문서에서 `shall/will/required`와 `should`의 의미를 구분해야 한다.**
   - `shall`, `will`, `required`는 실제 요구사항으로 봐야 한다.
   - `should`는 선호/권장에 가깝고, 현실적으로 반드시 만족하지 못해도 되는 경우가 있다.

---

## 2. 인터뷰 목적 및 배경

팀은 TIMEGRAPHER 프로젝트에서 다음 목적을 가지고 기술 담당자와 인터뷰를 진행했다.

- 요구사항에 대한 공감대 형성
- 품질 속성 시나리오의 값이 합리적인지 확인
- 프로젝트 문서의 용어 해석 확인
- latency, robustness, consistency, modifiability, usability 등 주요 품질 속성의 우선순위 확인
- Raspberry Pi 및 PC 실행 환경 관련 제약 확인
- 테스트 방법 및 데모 준비 방향 확인

팀은 기술 담당자를 시스템의 고객 또는 이해관계자 관점으로 보고, 이미 작성한 품질 속성 시나리오의 response measure 값이 수용 가능한지 검토받고자 했다.

---

## 3. 요구사항 용어 해석

### 3.1 `shall`, `will`, `required`

기술 담당자는 문서에서 다음 표현은 실제 요구사항으로 해석해도 된다고 확인했다.

- `shall`
- `will`
- `required`

즉, 이 표현들이 들어간 항목은 아키텍처 설계와 구현에서 반드시 고려해야 한다.

### 3.2 `should`

`should`는 현실 세계에서는 “하면 좋다”, “선호한다”는 의미에 가깝다고 설명했다.

- 반드시 만족해야 하는 절대 요구사항은 아니다.
- 만족하지 못하더라도 설득 가능한 이유가 있으면 허용될 수 있다.
- 예: “The system should work in real time”이라고 되어 있어도, 완전한 hard real-time을 의미하지 않을 수 있다.

### 3.3 요구사항 문서 해석 시 주의점

문서의 “real time” 표현은 다음처럼 해석해야 한다.

- 가능하면 빠르게 처리해야 한다.
- 하지만 신호 특성상 필요한 구간을 다 보기 전에는 계산할 수 없는 값이 있다.
- 정확도와 신뢰도를 희생하면서 즉시 표시하는 것은 바람직하지 않다.
- latency와 reliability/accuracy 사이의 trade-off를 명확히 설명해야 한다.

---

## 4. 실시간성 및 latency에 대한 핵심 설명

### 4.1 TIMEGRAPHER에서 지연이 불가피한 이유

기술 담당자는 신호 처리 관점에서 다음을 설명했다.

- 신호의 일부만 보고는 특정 이벤트를 확정할 수 없다.
- 예를 들어 A 이벤트와 C 이벤트를 모두 확인해야 어떤 beat가 유효한지 판단할 수 있다.
- C를 보기 전에는 A가 확정된 것인지 판단하지 못할 수 있다.
- 따라서 capture 후 GUI에 표시될 때까지 일정 지연이 생기는 것은 자연스럽다.
- 일부 계산은 전체 구간 또는 필요한 신호 구간을 본 뒤에만 가능하다.

### 4.2 허용 가능한 지연의 기준

기술 담당자의 입장은 다음과 같다.

- latency는 가능한 한 줄여야 한다.
- 단, latency를 줄이기 위해 reliability나 accuracy를 희생해서는 안 된다.
- 계산이 필요한 신호 구간을 기다리는 지연은 허용 가능하다.
- 중요한 것은 “왜 이 latency가 필요한지”를 설명할 수 있어야 한다는 점이다.

### 4.3 두 종류의 display latency

기술 담당자는 display latency를 반드시 두 가지로 나누어 봐야 한다고 했다.

| 구분 | 의미 | 요구사항 정의 시 주의점 |
|---|---|---|
| **Graph / visual signal latency** | 입력 파형 또는 tick signal이 GUI 그래프에 보이는 지연 | 비교적 짧은 latency 목표를 둘 수 있음 |
| **Display numbers latency** | beat rate, beat error, amplitude, seconds/day 등 계산된 수치가 갱신되는 지연 | integration time이 필요하므로 500ms 같은 목표는 비현실적일 수 있음 |

팀이 처음에는 display latency를 단일 지표로 보고 있었으나, 인터뷰 후에는 그래프 표시와 수치 표시를 분리해야 한다는 결론이 나왔다.

---

## 5. 도메인 설명: TIMEGRAPHER가 왜 필요한가

기술 담당자는 TIMEGRAPHER가 시계 수리/조정 과정에서 어떻게 쓰이는지 설명했다.

### 5.1 Watchmaker의 사용 시나리오

일반적으로 watchmaker는 다음 상황에서 TIMEGRAPHER를 사용한다.

1. 기계식 시계를 수리하거나 서비스한다.
2. 시계를 TIMEGRAPHER 위에 올린다.
3. 다음 값을 확인한다.
   - beat error
   - amplitude
   - beat rate 또는 rate
   - seconds/day 오차
4. 수치에 따라 기계적 조정을 수행한다.
5. 조정 결과를 다시 TIMEGRAPHER로 확인한다.

### 5.2 주요 측정값

| 측정값 | 의미 | 인터뷰에서 언급된 중요성 |
|---|---|---|
| **Beat error** | balance wheel이 양방향으로 동일하게 움직이는지와 관련된 시간 차이 | 조정 중 실시간성이 중요. 지연이 크면 overshoot 가능 |
| **Amplitude** | balance wheel이 움직이는 각도/진폭 | 수리 상태가 좋으면 정상이어야 하며, watchmaker가 직접 쉽게 조정하는 값은 아님 |
| **Rate / Beat rate / seconds per day** | 시계가 빠르거나 느린 정도 | regulator 또는 free-sprung 구조에 따라 조정 방식이 다름 |

### 5.3 기계식 조정 방식

기술 담당자는 시계 구조에 따라 조정 방식이 다르다고 설명했다.

#### Regulator pin 방식

- regulator pin을 움직여 시계의 빠르기/느리기를 조정한다.
- hair spring의 유효 길이를 길게 또는 짧게 바꾸는 방식으로 rate가 바뀐다.
- 조정자가 과하게 움직이면 시계가 너무 빨라지거나 느려질 수 있다.

#### Beat error 조정

- balance wheel이 한 방향과 반대 방향으로 같은 정도 움직이도록 맞추는 것이 중요하다.
- beat error는 조정 중 바로 확인할 수 있어야 한다.
- 표시가 너무 늦으면 조정자가 overshoot하거나, 결과 확인에 시간이 오래 걸린다.

#### Free-sprung / Microstella screw 방식

- 일부 시계는 free-sprung movement를 사용한다.
- Rolex 예시처럼 balance wheel 가장자리의 microstella screw를 조정해 회전 특성을 바꾼다.
- balance에 여러 개의 작은 screw가 있으며, 이를 조이거나 풀어 rate를 조정한다.
- rate 조정을 위해서는 시계를 멈춰야 하는 경우가 있다.

### 5.4 현재 코드의 beat error 측정 범위

기술 담당자는 현재 코드가 beat error 차이를 약 **10ms 정도까지 측정할 수 있다**고 설명했다.

이 수치는 요구사항 또는 테스트 기준으로 바로 확정된 것은 아니지만, 현재 코드의 기능 이해에 중요한 정보다.

---

## 6. 코드 빌드 및 실행 상태

### 6.1 Raspberry Pi에서 빌드/실행

기술 담당자는 팀이 코드를 Raspberry Pi에서 빌드했는지 확인했다.

팀의 답변:

- Raspberry Pi에서 빌드/실행 여부를 확인했다.
- “동작한다”는 수준까지 확인했다.

기술 담당자의 반응:

- “동작한다”는 것과 “잘 동작한다”는 것은 다르다.
- 현재 코드를 실제로 실행해 보면 구조와 동작 방식을 어느 정도 이해할 수 있다.
- 팀은 코드를 더 실험해 보면서 개선 방향을 파악해야 한다.

### 6.2 PC에서 실행 시 주의점

PC에서 실행할 경우 특히 Windows 오디오 설정이 문제를 일으킬 수 있다.

- Windows 최근 업데이트로 새로운 오디오 관련 기능이 추가되었을 수 있다.
- PC는 기본적으로 끄지 말아야 할 기능을 켜두거나, 꺼야 할 기능을 켜둘 수 있다.
- 그 결과 timegrapher의 입력 신호가 변형되어 알고리즘이 제대로 동작하지 않을 수 있다.

---

## 7. 품질 속성 시나리오 검토 결과

팀은 다음 품질 속성을 준비했다.

- Performance / latency
- Robustness 또는 graceful degradation
- Consistency
- Modifiability
- Usability
- Constraints

인터뷰 중 기술 담당자는 여기에 **Accuracy**가 명시적으로 더 중요하게 다뤄져야 한다고 강조했다.

---

## 8. Performance / Latency

### 8.1 팀이 제안한 초기 시나리오

팀은 다음과 같은 성능 시나리오를 제안했다.

- 10분 실행 기준
- processing latency 또는 display latency 측정
- P99 기준
- display latency < 500ms

원문에서 팀은 P99를 “fastest 99% of the signal”이라고 설명했으나, 문서화 시에는 **P99 = 99th percentile latency**인지, 또는 “99%의 샘플이 특정 latency 이하”인지 명확히 써야 한다.

### 8.2 기술 담당자 피드백

초기에는 500ms가 “probably okay”로 보인다는 반응이 있었지만, 이후 설명에서 이 값은 특히 **수치 표시 latency**에는 적절하지 않을 수 있음이 드러났다.

핵심 피드백:

- display latency는 그래프와 수치를 분리해야 한다.
- beat rate, beat error, amplitude 같은 숫자는 integration time이 필요하다.
- 500ms 안에 수치를 안정적으로 계산하는 것은 어려울 수 있다.
- latency를 줄이는 것보다 정확하고 신뢰 가능한 값을 표시하는 것이 중요하다.

### 8.3 5초 목표에 대한 대화

팀은 500ms가 어렵다면 5초는 어떠냐고 질문했다.

기술 담당자 반응:

- 5초는 가능할 수 있다는 뉘앙스가 있었다.
- 하지만 최종 확정값은 아니다.
- 시계의 BPH에 따라 필요한 integration time이 달라질 수 있다.
- BPH 기반 integration time table 또는 관련 자료를 찾아야 한다.

### 8.4 수정 권장안

성능 요구사항은 다음처럼 분리하는 것이 좋다.

| 항목 | 기존 접근 | 수정 권장 |
|---|---|---|
| Graph latency | display latency < 500ms로 통합 | graph/visual signal latency로 별도 정의 |
| Numeric display latency | display latency < 500ms로 통합 | beat rate/beat error/amplitude 계산 latency로 별도 정의 |
| Integration time | 명확하지 않음 | BPH별 필요한 integration time을 조사해 정의 |
| 정확도와의 관계 | latency 중심 | accuracy를 우선하고 latency를 그다음으로 둠 |

---

## 9. Robustness / Graceful Degradation

### 9.1 팀이 제안한 초기 시나리오

팀은 robustness 또는 graceful degradation에 대해 다음과 같은 값을 제안했다.

- SNR >= 30dB
- detection rate >= 95%
- detected signal과 undetected signal을 count해서 측정

원문에는 “over000 bits/beats”처럼 전사가 불명확한 부분이 있었다. 문서화 시 정확한 단위와 수치를 다시 확인해야 한다.

### 9.2 기술 담당자 피드백

기술 담당자는 SNR 30dB와 95% detection rate에 대해 확답하지 않았다.

이유:

- 본인이 해당 SNR 값을 실제로 측정해본 것은 아니다.
- 현재 코드가 어느 정도의 noise level을 기대하는지 정확히 알 수 없다.
- 제공된 녹음 파일에서는 동작할 수 있지만, 실제 환경에서는 다를 수 있다.
- 마이크와 PC 오디오 설정, 주변 소음이 큰 영향을 준다.

### 9.3 입력 통제의 필요성

기술 담당자는 “어떻게 input을 control할 것인가?”를 질문했다.

이는 robustness 테스트의 핵심이다.

- 단순히 실제 시계 소리를 녹음해 detection 여부를 세는 것만으로는 부족하다.
- ground truth가 있어야 detection rate를 계산할 수 있다.
- noise level과 SNR을 통제해야 한다.

### 9.4 권장 테스트 방법

기술 담당자는 다음 방식을 제안 또는 승인했다.

1. **Ideal signal 생성**
   - 먼저 noise가 없는 이상적인 신호를 만든다.
   - beat event의 위치를 알고 있어야 한다.

2. **Noise 추가**
   - 일정 noise floor를 추가한다.
   - SNR을 변화시키며 detection 성능을 측정한다.

3. **Synthetic data 생성**
   - 제공된 sample data를 synthetic data 생성의 기반으로 사용할 수 있다.
   - 가능하면 다른 사람이 synthetic data를 만들어 blind test에 가깝게 하는 것도 좋다.

4. **제공 녹음 파일 사용**
   - 제공된 recording files를 baseline으로 사용할 수 있다.
   - 팀이 SNR 30dB 값을 선택한 이유도 제공된 recording files에서 동작했기 때문인 것으로 보인다.

5. **팀 보유 시계로 테스트**
   - 팀이 가진 실제 시계도 사용해야 한다.
   - 기술 담당자는 “너희 시계로도 테스트해보라”고 했다.
   - 프로젝트 키트 또는 준비물에는 두 종류의 시계가 있는 것으로 언급되었으므로, 두 종류 모두 테스트하는 것이 좋다.

6. **조용한 환경에서 측정**
   - 마이크는 주변 대화 소리도 잡는다.
   - 사람이 말하는 소리도 detection에 영향을 준다.
   - 테스트 시 조용한 장소가 필요하다.

### 9.5 수정 권장안

robustness 요구사항은 다음처럼 정의하는 것이 좋다.

| 항목 | 수정 방향 |
|---|---|
| SNR 기준 | 30dB를 tentative 값으로 두고 실험으로 검증 |
| Detection rate | 95% 목표는 유지 가능하나, ground truth 기반 synthetic data로 측정 |
| Noise 조건 | white noise, ambient noise, speech noise 등 조건을 구분 가능 |
| 환경 조건 | quiet room, PC enhancement off, AGC off 여부를 명시 |
| 실패 시 동작 | 잘못된 값을 표시하기보다 confidence 낮음, hold, discard, smoothing 등 graceful degradation 정의 |

---

## 10. Consistency

### 10.1 팀이 제안한 초기 시나리오

팀은 consistency에 대해 “zero mismatch”를 제안했다.

### 10.2 기술 담당자 피드백

기술 담당자는 다음처럼 반응했다.

- zero mismatch는 이상적이다.
- 가능하면 그렇게 하는 것이 좋다.
- 현실적으로는 “가능한 한 0에 가깝게” 접근해야 한다.

### 10.3 해석

consistency는 다음처럼 해석할 수 있다.

- 동일한 입력에 대해 동일한 detection/계산 결과가 나와야 한다.
- GUI의 그래프와 숫자 표시가 서로 모순되지 않아야 한다.
- detection pipeline과 display pipeline이 같은 beat event를 참조해야 한다.
- 내부 상태와 화면 표시 값이 불일치하지 않아야 한다.

### 10.4 수정 권장안

| 항목 | 권장 정의 |
|---|---|
| 목표 | mismatch = 0을 이상 목표로 설정 |
| 현실적 기준 | 테스트 케이스 기준 불일치율을 측정하고 최대 허용치를 정의 |
| 측정 대상 | graph event, numeric display, log/internal state 간 일치성 |
| 처리 방식 | bad data 발생 시 표시를 튀게 하지 않고 discard/hold/mark invalid |

---

## 11. Modifiability

### 11.1 팀이 제안한 방향

팀은 modifiability를 개발팀 작업량 또는 주어진 시간 기준으로 계산한 것으로 보인다.

전사상 “SK I mean we calculate according to our given time”처럼 들리며, 정확한 산식은 원문만으로는 불명확하다.

### 11.2 기술 담당자 피드백

기술 담당자는 다음을 설명했다.

- 과거 학생들은 GUI를 완전히 다시 설계하거나 다른 언어로 재작성하기도 했다.
- 이번 팀이 반드시 그렇게 해야 한다는 뜻은 아니다.
- 주어진 코드와 제품은 실제 완성품과 다르다.
- 현재 제공된 것은 학생들이 작업하고 개선하기 위한 기반이다.
- 더 나은 방식이 있으면 자유롭게 개선할 수 있다.

### 11.3 Qt / C++ 관련 언급

기술 담당자는 다음을 물었다.

- Qt로 계속 할 것인지
- Qt를 바꿀 것인지
- 팀원 중 C++를 아는 사람이 얼마나 있는지

이는 구현 기술 선택이 modifiability와 관련 있음을 의미한다.

### 11.4 수정 권장안

modifiability 시나리오는 다음처럼 구체화할 수 있다.

| 변경 유형 | 예시 | 측정 기준 후보 |
|---|---|---|
| UI 레이아웃 변경 | 버튼 크기, 글자 크기, 그래프 위치 변경 | 몇 시간/몇 파일 수정 이내 |
| Signal processing algorithm 교체 | detection threshold, filtering, outlier rejection 변경 | pipeline interface 유지 여부 |
| Display metric 추가/수정 | beat error 표시 방식 변경 | GUI와 backend 영향 범위 |
| Runtime platform 설정 변경 | PC/Raspberry Pi audio config 차이 반영 | 설정 파일 또는 adapter로 분리 가능 여부 |

---

## 12. Usability

### 12.1 팀이 제안한 초기 기준

팀은 usability를 다음 관점으로 제안했다.

- 그래프가 읽을 수 있어야 한다.
- 버튼이 읽을 수 있어야 한다.
- 전체 UI 요소가 readable해야 한다.
- 대문자 높이 >= 2.9mm 기준을 제시했다.
- touch target 관련해서 9mm 기준도 언급되었다.

### 12.2 기술 담당자 피드백: 디스플레이 크기/해상도 오류

기술 담당자는 팀이 800px 기준으로 생각한 것이 잘못되었을 가능성을 지적했다.

핵심 내용:

- Raspberry Pi 5에서 사용하는 디스플레이는 800px보다 크다.
- 팀은 실제보다 작은 화면으로 가정하고 있었을 수 있다.
- 문서 또는 draft의 디스플레이 이미지/스펙이 잘못되었을 수 있다.
- 기술 담당자는 “That’s wrong. Fix that.”이라고 하며 수정 필요성을 지적했다.
- 디스플레이 관련 pamphlet/spec이 툴킷 안에 있으니 확인해야 한다.

### 12.3 팀 내부에서 언급된 수치

전사상 다음 값들이 언급되었다.

- 800px: 팀이 처음 가정한 화면 크기 또는 문서에 있던 값
- 1000 이상: 실제 디스플레이가 800보다 크다는 맥락
- 1200 x 1153: 팀원이 본 application size 또는 draft 하단 device stack 관련 이미지에서 본 값으로 보임
- 2.9mm: 글자 높이 기준으로 제시
- 9mm: touch target 폭으로 언급

정확한 디스플레이 해상도와 물리 크기는 반드시 원본 spec 문서로 다시 확인해야 한다.

### 12.4 수정 권장안

| 항목 | 수정 방향 |
|---|---|
| Readability | 실제 디스플레이 물리 크기와 해상도 기준으로 재계산 |
| Touch target | 9mm 기준을 적용할지 확인하고, 버튼/조작부에만 적용 |
| Font height | 2.9mm 기준의 출처와 적용 범위 명확화 |
| Graph readability | tick pattern, scale, labels, numerical readout를 구분해 평가 |
| UI layout | 800px 기준 설계를 버리고 실제 화면 기준으로 재설계 |

---

## 13. Accuracy: 인터뷰 중 새롭게 강조된 최우선 품질 속성

### 13.1 기술 담당자의 지적

기술 담당자는 팀이 accuracy를 충분히 언급하지 않았다고 지적했다.

핵심 발언의 의미:

- display numbers의 accuracy가 매우 중요하다.
- 현재 코드를 실행해 보면 bad value가 들어올 때 숫자가 이상하게 튈 수 있다.
- 이런 bad data를 그대로 화면에 보여주면 사용자가 잘못된 조정을 할 수 있다.
- bad data를 버릴 수 있어야 한다.

### 13.2 정확도가 latency보다 중요한 이유

기술 담당자는 priority를 다음처럼 제안했다.

1. Accuracy
2. Latency 또는 Performance
3. Consistency
4. Modifiability
5. Usability

팀은 처음에 performance를 최우선으로 두고 있었으나, 기술 담당자의 조언에 따라 accuracy를 먼저 고려하기로 했다.

### 13.3 Architecture 관점의 의미

Accuracy를 최우선으로 두면 다음 설계 결정이 중요해진다.

- raw signal preprocessing
- noise filtering
- event detection confidence
- invalid beat rejection
- outlier rejection
- smoothing 또는 rolling average
- metric calculation window
- graph display와 numeric display의 동기화
- bad data 발생 시 UI 표시 정책

### 13.4 수정 권장안

Accuracy 시나리오를 별도 품질 속성으로 추가하는 것이 좋다.

예시:

| 항목 | 권장 내용 |
|---|---|
| Source | Mechanical watch audio signal 또는 synthetic ground-truth signal |
| Stimulus | 정상 tick signal에 noise, missing beat, false peak, outlier가 섞임 |
| Environment | Raspberry Pi 실행, 조용한 환경, audio enhancement/AGC off |
| Artifact | Signal processing pipeline, metric calculator, GUI numeric display |
| Response | 잘못된 beat를 discard하거나 confidence 낮음으로 처리하고, 표시 수치가 비정상적으로 튀지 않음 |
| Response measure | synthetic ground truth 기준 오차, invalid value discard rate, false detection rate, metric stability 등을 실험으로 결정 |

---

## 14. 제약 조건 및 실행 환경

### 14.1 Raspberry Pi

팀은 시스템이 Raspberry Pi에서 동작해야 하는 것으로 이해하고 있었다.

기술 담당자는 이를 확인했고, 팀도 Raspberry Pi 실행을 기준으로 한다고 답했다.

### 14.2 PC 실행은 선택적/테스트용으로 보임

PC에서 실행할 수는 있지만, PC 오디오 stack이 신호를 변형할 수 있다.

따라서 최종 실행 환경이 Raspberry Pi인지 PC인지에 따라 다음이 달라진다.

- microphone input path
- audio driver behavior
- audio enhancement 설정
- AGC 설정
- sampling rate/bit depth
- filter 필요성
- UI resolution

### 14.3 Microphone 및 주변 소음

마이크는 매우 민감하다.

- 시계 소리뿐 아니라 주변 대화도 잡는다.
- 조용한 환경에서 테스트해야 한다.
- 테스트 중 말소리나 움직임이 detection에 영향을 줄 수 있다.

### 14.4 Windows audio settings

기술 담당자는 Windows 11에서 control panel/sound/microphone properties/advanced 또는 enhancements 관련 설정을 찾으려 했다.

확인해야 할 설정:

- Automatic Gain Control off
- Audio enhancement off
- input enhancement off
- microphone processing off
- 필요 시 sample rate/bit depth 확인

전사상 설정 메뉴는 한국어 Windows 환경에서 찾기 어려웠고, 어떤 장비에서는 해당 탭이 보이지 않았다. 마이크가 enabled되어 있지 않거나 장치가 해당 기능을 제공하지 않을 가능성도 언급되었다.

### 14.5 AGC/Enhancement가 켜져 있을 때의 영향

기술 담당자는 다음을 분명히 말했다.

- Automatic Gain Control이 켜져 있으면 결과를 망칠 수 있다.
- PC의 input audio enhancement도 결과를 망칠 수 있다.
- 이런 설정을 끄지 못하면 알고리즘이나 필터링을 다르게 해야 할 수 있다.

---

## 15. 테스트 전략 정리

### 15.1 반드시 해야 할 테스트

| 테스트 | 목적 | 입력 | 측정값 |
|---|---|---|---|
| 제공 recording file 테스트 | baseline 확인 | 제공 샘플 | detection rate, numeric stability |
| Synthetic ideal signal 테스트 | ground truth 기반 accuracy 확인 | 직접 생성한 clean signal | event detection correctness |
| Synthetic noise 추가 테스트 | SNR별 graceful degradation 확인 | clean signal + noise | detection rate, false positive/negative |
| 실제 팀 보유 시계 테스트 | 현실 입력 검증 | 실제 watch audio | latency, stability, usability |
| 두 종류의 시계 테스트 | watch type 차이 확인 | 프로젝트 시계 2종 또는 보유 시계 2종 | algorithm robustness |
| 조용한 환경 vs 소음 환경 테스트 | 환경 영향 확인 | ambient/speech noise 포함 | degradation behavior |
| PC audio setting on/off 테스트 | AGC/enhancement 영향 확인 | 동일 입력 | metric distortion 여부 |
| Bad data/outlier 테스트 | display stability 확인 | false peak/missing beat/outlier | number jump 방지 여부 |

### 15.2 테스트 입력 생성 방식

권장 절차:

1. 기준 BPH를 정한다.
2. 이상적인 tick sequence를 생성한다.
3. A/C event 또는 beat event의 ground truth timestamp를 저장한다.
4. noise amplitude를 조절해 SNR을 단계별로 만든다.
5. 알고리즘에 입력한다.
6. detection result와 ground truth를 비교한다.
7. false positive, false negative, missed detection, latency, numeric error를 측정한다.

### 15.3 AI를 활용한 테스트

기술 담당자는 본인이 AI를 사용해 코드를 테스트한 경험이 있다고 말했다.

활용 가능성:

- 테스트 케이스 생성
- synthetic data 생성 보조
- edge case 탐색
- 알고리즘이 할 수 있는 것과 없는 것 파악
- parameter adjustment 후보 찾기

단, AI가 만든 테스트도 ground truth와 재현 가능한 절차를 갖춰야 한다.

---

## 16. Trade-off에 대한 조언

기술 담당자는 팀이 앞으로 많은 trade-off를 해야 할 것이라고 했다.

### 16.1 예상 trade-off

| Trade-off | 설명 |
|---|---|
| Accuracy vs Latency | 더 빨리 표시하면 덜 정확할 수 있고, 더 정확하려면 더 긴 integration time이 필요할 수 있음 |
| Robustness vs Sensitivity | 작은 tick까지 잡으려 하면 noise도 잡을 수 있음 |
| Responsiveness vs Stability | 숫자를 자주 갱신하면 튈 수 있고, smoothing하면 반응이 느려질 수 있음 |
| UI detail vs Readability | 많은 정보를 표시하면 작은 화면에서 읽기 어려울 수 있음 |
| Modifiability vs Implementation speed | 구조를 깔끔히 나누면 변경은 쉬워지지만 초기 구현 시간이 늘 수 있음 |
| PC compatibility vs Raspberry Pi focus | PC 오디오 처리를 고려하면 복잡해지고, Raspberry Pi만 타깃으로 하면 범위가 줄어듦 |

### 16.2 평가에서 중요한 점

기술 담당자는 trade-off 자체보다 **그 trade-off를 정당화할 수 있어야 한다**고 했다.

즉, 팀은 다음을 문서화해야 한다.

- 어떤 선택지를 비교했는가
- 어떤 품질 속성을 우선했는가
- 왜 그 선택이 TIMEGRAPHER 사용 맥락에 더 적합한가
- 어떤 실험 결과 또는 근거가 있는가
- 선택으로 인해 포기한 것은 무엇인가

---

## 17. 품질 속성 우선순위 수정안

### 17.1 인터뷰 전 팀의 우선순위

팀은 performance를 높은 우선순위로 두고 있었던 것으로 보인다.

### 17.2 기술 담당자 피드백 후 수정 우선순위

권장 우선순위:

| 순위 | 품질 속성 | 이유 |
|---:|---|---|
| 1 | **Accuracy** | 잘못된 값은 watchmaker의 조정을 망칠 수 있음 |
| 2 | **Latency / Performance** | 조정 중 feedback이 너무 늦으면 overshoot 또는 작업 지연 발생 |
| 3 | **Consistency** | 그래프, 내부 상태, 숫자 표시가 서로 맞아야 신뢰 가능 |
| 4 | **Modifiability** | 알고리즘/GUI/환경 설정을 프로젝트 중 빠르게 바꿀 수 있어야 함 |
| 5 | **Usability** | readable graph/button/number가 필요하지만, accuracy/latency보다 후순위 |

Availability는 대화 중 단어가 언급되었으나, 구체적인 시나리오나 response measure는 논의되지 않았다.

---

## 18. 수정된 품질 속성 시나리오 초안

아래는 인터뷰 내용을 반영한 문서화용 초안이다. 확정 수치는 실험 후 갱신해야 한다.

### 18.1 QA-ACC-01: Numeric display accuracy

| 항목 | 내용 |
|---|---|
| Source | Mechanical watch signal 또는 synthetic ground-truth signal |
| Stimulus | 정상 tick signal에 noise, false peak, missing event, outlier가 포함됨 |
| Artifact | Signal processing pipeline, beat detector, metric calculator, numeric display |
| Environment | Raspberry Pi 실행, 조용한 환경, AGC/audio enhancement off |
| Response | 유효한 beat만 사용해 beat rate/beat error/amplitude를 계산하고, bad value는 discard 또는 invalid 처리 |
| Response measure | ground truth 대비 오차 범위는 실험으로 결정. bad value로 인해 표시 숫자가 비정상적으로 튀지 않아야 함 |
| Status | 새로 추가 필요 |

### 18.2 QA-LAT-01: Graph display latency

| 항목 | 내용 |
|---|---|
| Source | Watch audio input |
| Stimulus | tick signal이 capture됨 |
| Artifact | Signal capture pipeline, GUI graph |
| Environment | 10분 연속 실행, Raspberry Pi, 정상 부하 상태 |
| Response | 입력 신호가 GUI graph에 표시됨 |
| Response measure | P99 graph latency 목표를 별도 정의. 500ms 후보는 유지 가능하나 실험 필요 |
| Status | 기존 display latency에서 분리 필요 |

### 18.3 QA-LAT-02: Numeric metric latency

| 항목 | 내용 |
|---|---|
| Source | Watch audio input |
| Stimulus | beat event sequence가 capture됨 |
| Artifact | Beat detector, metric calculator, numeric display |
| Environment | 10분 연속 실행, Raspberry Pi |
| Response | beat rate, beat error, amplitude 등 계산된 숫자가 갱신됨 |
| Response measure | 500ms는 비현실적일 수 있음. BPH별 integration time을 근거로 목표 설정. 5초는 후보이나 미확정 |
| Status | 기존 latency 요구사항 수정 필요 |

### 18.4 QA-ROB-01: Detection robustness under noise

| 항목 | 내용 |
|---|---|
| Source | Synthetic signal generator 또는 controlled recording |
| Stimulus | SNR을 조절한 watch tick signal 입력 |
| Artifact | Beat detector |
| Environment | AGC/audio enhancement off, controlled input |
| Response | beat event를 detection하고 false/missed detection을 기록 |
| Response measure | SNR >= 30dB에서 detection >= 95%는 tentative. 실험으로 검증 필요 |
| Status | 값 검증 필요 |

### 18.5 QA-CON-01: Consistency between internal state and display

| 항목 | 내용 |
|---|---|
| Source | Beat detector output |
| Stimulus | 정상 signal 및 outlier 포함 signal 처리 |
| Artifact | Internal event model, graph display, numeric display |
| Environment | 10분 연속 실행 |
| Response | graph와 numeric display가 동일한 event stream 또는 일관된 계산 결과를 반영 |
| Response measure | mismatch = 0을 이상 목표로 설정. 현실적 허용치와 측정 방식은 테스트 후 확정 |
| Status | 기존 zero mismatch 목표 유지 가능하나 측정 방식 구체화 필요 |

### 18.6 QA-MOD-01: Algorithm/UI modification effort

| 항목 | 내용 |
|---|---|
| Source | Developer |
| Stimulus | detection algorithm, filter, UI layout, display metric 변경 요청 |
| Artifact | Codebase, GUI, signal processing module |
| Environment | Course project development period |
| Response | 제한된 시간 내 변경 가능, 영향 범위가 국소화됨 |
| Response measure | 변경 유형별 수정 파일 수, 소요 시간, regression test 통과 여부 등으로 정의 |
| Status | 팀 기준으로 구체화 필요 |

### 18.7 QA-USE-01: Readability and touch usability

| 항목 | 내용 |
|---|---|
| Source | Watchmaker/user |
| Stimulus | TIMEGRAPHER 화면에서 graph, button, numeric display를 확인/조작 |
| Artifact | GUI |
| Environment | 실제 Raspberry Pi display, 실제 해상도/물리 크기 기준 |
| Response | 글자, 그래프, 버튼이 읽고 조작 가능해야 함 |
| Response measure | font height >= 2.9mm, touch target >= 9mm 등은 후보. 실제 display spec 확인 후 확정 |
| Status | display spec 오류 수정 후 재계산 필요 |

---

## 19. UI 및 디스플레이 관련 조치

### 19.1 확인해야 할 문서

기술 담당자는 툴킷에 디스플레이 pamphlet이 있으니 확인하라고 했다.

확인할 항목:

- 실제 해상도
- 실제 물리 크기
- pixel density
- touch 지원 여부
- recommended orientation
- Raspberry Pi 5와 연결되는 방식
- application window size

### 19.2 수정해야 할 문서 오류

기술 담당자는 draft 또는 문서에 있는 디스플레이 정보가 잘못되었다고 했다.

- “That’s wrong. Fix that.”이라고 명시적으로 말했다.
- 화면이 800px보다 크므로, 800px 기준의 UI 가정은 폐기해야 한다.
- 팀은 문서와 품질 시나리오의 display size 관련 값을 갱신해야 한다.

### 19.3 UI 설계 시 고려사항

- 그래프는 tick pattern을 알아보기 쉬워야 한다.
- 숫자는 조정 중 즉시 해석할 수 있어야 한다.
- 버튼은 touch target 기준을 만족해야 한다.
- 화면 크기가 충분하므로 작은 화면에 억지로 맞춘 layout을 쓸 필요가 없을 수 있다.
- 실제 제품과 제공 코드의 UI는 다를 수 있으므로, 프로젝트 목적에 맞게 개선해도 된다.

---

## 20. Windows 오디오 설정 관련 상세 메모

인터뷰 중 기술 담당자는 한국어 Windows 11 환경에서 마이크/사운드 설정을 찾으려 했다.

### 20.1 찾으려 한 위치

대화상 다음 메뉴들이 언급되었다.

- Control Panel
- Sound
- More sound settings
- Recording
- Microphone
- Properties
- Advanced settings
- Enhancements
- Input settings
- Driver/details/events tab

### 20.2 관찰된 문제

- 어떤 장치에서는 필요한 탭이 보이지 않았다.
- 마이크가 enable되어 있지 않을 수 있다고 했다.
- Windows 11에서는 메뉴 구조가 달라 찾기 어렵다고 했다.
- 한국어 UI에서는 더 찾기 어려웠다.

### 20.3 꺼야 하는 기능

기술 담당자의 의도는 명확하다.

- AGC를 꺼야 한다.
- enhancement를 꺼야 한다.
- microphone input에 적용되는 자동 보정 또는 processing을 꺼야 한다.

이 기능들이 켜져 있으면 TIMEGRAPHER 알고리즘의 입력 신호가 원래 시계 소리가 아니라 가공된 소리가 되어 detection과 metric 계산을 망칠 수 있다.

---

## 21. 팀 구성원 배경 관련 대화

인터뷰 후반에는 팀원들의 배경에 대한 대화가 있었다.

언급된 배경:

- camera 또는 camera signal 처리
- camera ISP
- image signal processing
- 알고리즘 관련 경험
- cloud / web / hotel TV solution
- washing machine 관련 업무
- BSP driver / board support package 개발
- hardware 관련 지식

기술 담당자는 팀원들의 배경이 프로젝트에 도움이 될 수 있다고 평가했다.

특히:

- signal processing 경험은 TIMEGRAPHER 알고리즘 개선에 직접적으로 유용하다.
- camera/ISP 경험도 signal processing 관점에서 도움이 된다.
- BSP/hardware 경험은 Raspberry Pi, audio input, device stack 이해에 도움이 된다.

또한 camera 기반 timegrapher 또는 computer vision 방식도 가능하다는 언급이 있었지만, 프로젝트 키트에는 camera가 없으므로 이번 프로젝트의 직접 범위는 아닌 것으로 정리된다.

---

## 22. 후속 조치 목록

### 22.1 요구사항/문서 수정

- [ ] `shall/will/required`와 `should`의 의미를 요구사항 문서에 반영한다.
- [ ] “real-time”을 hard real-time이 아니라 accuracy-aware best-effort latency로 재정의한다.
- [ ] display latency를 graph latency와 numeric display latency로 분리한다.
- [ ] 500ms 목표가 적용되는 대상을 명확히 한다.
- [ ] numeric display latency는 BPH별 integration time 자료를 근거로 다시 정한다.
- [ ] Accuracy를 최우선 품질 속성으로 추가한다.
- [ ] 품질 속성 우선순위를 accuracy > latency/performance > consistency > modifiability > usability로 수정한다.
- [ ] Availability가 필요한 품질 속성인지 재검토한다. 인터뷰에서는 구체 논의가 없었다.
- [ ] 디스플레이 해상도/물리 크기 오류를 수정한다.
- [ ] UI readability/touch target 기준을 실제 display spec 기준으로 다시 계산한다.

### 22.2 구현/설계 조치

- [ ] bad data/outlier를 버리는 로직을 설계한다.
- [ ] 숫자 표시가 비정상적으로 튀지 않도록 smoothing, hold, invalid 표시, confidence 표시 중 적절한 전략을 선택한다.
- [ ] signal capture, beat detection, metric calculation, GUI display pipeline의 책임을 분리한다.
- [ ] graph display와 numeric display가 서로 다른 latency requirement를 가질 수 있도록 설계한다.
- [ ] detection threshold/filter를 조정 가능하게 만든다.
- [ ] PC와 Raspberry Pi audio input 차이를 abstraction 또는 configuration으로 관리할지 검토한다.
- [ ] Qt/C++ 유지 여부와 변경 범위를 팀 역량 기준으로 결정한다.

### 22.3 테스트 조치

- [ ] 제공된 recording files로 baseline 테스트를 수행한다.
- [ ] 팀 보유 실제 시계로 테스트한다.
- [ ] 프로젝트에 제공된 두 종류의 시계를 모두 테스트한다.
- [ ] synthetic ideal signal을 생성한다.
- [ ] synthetic signal에 noise를 추가해 SNR별 detection 성능을 측정한다.
- [ ] SNR 30dB / detection 95% 목표가 실제로 가능한지 검증한다.
- [ ] quiet room에서 테스트한다.
- [ ] 테스트 중 대화/주변 소음이 detection에 미치는 영향을 확인한다.
- [ ] PC 실행 시 AGC/enhancement on/off 비교 테스트를 수행한다.
- [ ] 10분 연속 실행 테스트를 수행한다.
- [ ] P99 latency 측정 방식을 명확히 하고 측정한다.
- [ ] bad value가 표시 숫자를 흔드는지 테스트한다.

### 22.4 조사 조치

- [ ] BPH별 integration time table 또는 timegrapher measurement window 관련 자료를 찾는다.
- [ ] 실제 display pamphlet/spec을 확인한다.
- [ ] Windows 11 microphone enhancement/AGC off 방법을 팀 장비 기준으로 문서화한다.
- [ ] Raspberry Pi audio input stack과 sample rate 설정을 확인한다.
- [ ] 현재 코드의 beat error 측정 한계와 계산 방식을 확인한다.

### 22.5 커뮤니케이션 조치

- [ ] 필요하면 기술 담당자에게 추가 미팅을 요청한다.
- [ ] 기술 담당자는 이번 주에 town에 있을 수 있으며, 필요하면 다시 만날 수 있다고 했다.
- [ ] 기술 담당자가 문서의 잘못된 display 부분을 수정하겠다고 했으므로, 업데이트된 문서를 확인한다.

---

## 23. 미해결 질문 및 리스크

### 23.1 미해결 질문

| 질문 | 이유 |
|---|---|
| Numeric display latency의 최종 목표는 몇 초인가? | 500ms는 어려울 수 있고, 5초는 후보일 뿐 확정이 아님 |
| BPH별 필요한 integration time은 얼마인가? | 수치 표시 latency와 accuracy를 결정하는 핵심 자료 |
| SNR 30dB에서 95% detection은 실제로 가능한가? | 기술 담당자도 측정한 적이 없다고 함 |
| 제공된 recording files의 SNR은 어떻게 계산되었는가? | 팀이 30dB 값을 선택한 근거가 recording file 동작 여부였음 |
| 실제 디스플레이 해상도와 물리 크기는 무엇인가? | 800px 가정은 잘못되었을 가능성이 큼 |
| 최종 실행 환경은 Raspberry Pi만인가, PC도 포함인가? | PC 포함 시 오디오 설정 문제가 커짐 |
| beat error, rate, amplitude 각각의 accuracy tolerance는 무엇인가? | accuracy가 최우선이므로 정량 기준 필요 |
| bad data를 버릴 때 UI는 어떻게 보여줄 것인가? | 사용자에게 안정적이고 신뢰 가능한 feedback 제공 필요 |

### 23.2 주요 리스크

| 리스크 | 영향 | 완화 방안 |
|---|---|---|
| 500ms numeric latency 목표를 그대로 유지 | 불가능하거나 부정확한 시스템이 될 수 있음 | graph/numeric latency 분리, integration time 기반 재정의 |
| SNR/detection 기준 검증 부족 | robustness 요구사항이 근거 없는 수치가 됨 | synthetic ground truth 테스트 수행 |
| PC audio enhancement 미해제 | 알고리즘이 실제 시계 소리가 아닌 가공된 입력을 처리 | AGC/enhancement off 절차 문서화 |
| 주변 소음 | false detection 또는 unstable metric 발생 | quiet room, noise test, filtering |
| display spec 오류 | UI 기준과 실제 화면 불일치 | toolkit pamphlet 확인 후 재계산 |
| bad value 표시 | 사용자가 잘못된 시계 조정을 할 수 있음 | outlier rejection, confidence, hold/invalid 표시 |
| trade-off 근거 부족 | 평가에서 설계 결정 방어 어려움 | 모든 trade-off를 실험/도메인 근거와 함께 문서화 |

---

## 24. 결정 사항 요약

| 항목 | 결정 또는 합의 |
|---|---|
| 요구사항 용어 | `shall/will/required`는 필수, `should`는 선호/권장으로 해석 |
| Real-time | hard real-time이 아니라 가능한 빠르게, 단 accuracy/reliability 우선 |
| Latency | graph latency와 numeric display latency를 분리해야 함 |
| 500ms | graph에는 후보가 될 수 있으나 numeric display에는 재검토 필요 |
| 5초 | numeric display latency 후보로 언급되었지만 확정 아님 |
| Accuracy | 최우선 품질 속성으로 추가해야 함 |
| Bad data | 그대로 표시하지 말고 discard/filter/invalid 처리 필요 |
| SNR 30dB/95% detection | 확정된 값 아님. 실험으로 검증 필요 |
| Synthetic data | ideal signal + noise 방식으로 테스트 권장 |
| 제공 recording file | baseline 및 synthetic data 생성 기반으로 사용 가능 |
| 실제 시계 테스트 | 팀 보유 시계와 프로젝트 시계 2종으로 테스트 필요 |
| PC audio | AGC/enhancement/input processing off 필요 |
| Display spec | 800px 가정 오류 가능. toolkit pamphlet 확인 필요 |
| Qt/C++ | 유지 또는 변경 가능. 팀 역량과 modifiability 고려 |
| 추가 미팅 | 필요 시 기술 담당자에게 요청 가능 |

---

## 25. 회의 흐름별 세부 메모

### 25.1 요구사항 합의로 시작

- 팀은 요구사항 공감대를 만들기 위해 인터뷰를 시작했다.
- 기술 담당자에게 품질 속성 시나리오 값을 확인받고자 했다.
- 먼저 요구사항 문서의 `shall`과 `should` 의미를 질문했다.
- 기술 담당자는 `shall/will/required`는 요구사항, `should`는 선호로 해석된다고 설명했다.

### 25.2 Real-time 해석

- 팀은 문서에 “system should work in real time”이라고 되어 있으면 real-time을 반드시 만족하지 않아도 되는지 질문했다.
- 기술 담당자는 real-time은 “가능한 한”이라는 의미에 가깝다고 설명했다.
- 신호를 완전히 보거나 필요한 구간을 확인해야 계산 가능한 값들이 있으므로, 즉시 계산은 불가능할 수 있다.
- latency를 줄이는 것과 confidence/accuracy를 확보하는 것 사이에 trade-off가 있다.

### 25.3 코드 빌드 확인

- 기술 담당자는 Raspberry Pi에서 코드를 빌드했는지 물었다.
- 팀은 동작 여부를 확인했다고 답했다.
- 기술 담당자는 동작한다는 것과 잘 동작한다는 것은 다르며, 직접 실행해 구조와 한계를 확인해야 한다고 했다.

### 25.4 PC 실행 설정 언급

- 기술 담당자는 PC에서 실행할 경우 꺼야 하는 기능이 있다고 했다.
- Windows 최근 업데이트로 오디오 관련 기능이 추가되었을 수 있다고 했다.
- 해당 기능이 켜져 있으면 PC에서 성능이 나빠질 수 있다고 했다.

### 25.5 Performance latency 시나리오 검토

- 팀은 10분 실행, P99, display latency < 500ms를 제안했다.
- 처음에는 기술 담당자가 괜찮을 수 있다고 했다.
- 이후 display latency에는 graph latency와 numeric display latency가 있다는 점을 설명했다.
- numeric display는 beat rate, beat error, seconds/day 등이며 integration time이 필요하므로 500ms는 어려울 수 있다고 했다.
- 팀은 5초로 바꾸는 방안을 물었고, 기술 담당자는 BPH 기반 integration time 자료를 찾아보라고 했다.

### 25.6 Watchmaker workflow 설명

- 기술 담당자는 watchmaker가 시계를 서비스한 뒤 TIMEGRAPHER에 올려 beat error, amplitude, rate를 본다고 설명했다.
- amplitude는 시계가 잘 서비스되었는지 보는 값이며 직접 쉽게 조정하는 값은 아니라고 했다.
- rate는 regulator pin 또는 screw를 통해 조정할 수 있다고 설명했다.
- beat error는 balance wheel의 양방향 움직임 균형과 관련되며, 조정 중 실시간 feedback이 중요하다고 했다.

### 25.7 시계 구조 예시

- regulator pin 방식에서는 hair spring의 유효 길이를 바꿔 시계 속도를 조정한다고 설명했다.
- free-sprung movement에서는 microstella screw를 이용한다고 했다.
- Rolex free-sprung 예시를 찾으며 balance wheel 가장자리 screw를 설명했다.
- rate 조정은 시계를 멈춰야 할 수 있지만 beat error는 조정 중 확인 가능해야 한다고 했다.

### 25.8 Robustness / SNR 검토

- 팀은 SNR 30dB 이상에서 detection 95% 이상을 제안했다.
- 기술 담당자는 그 값을 직접 측정한 적이 없어 확답할 수 없다고 했다.
- input을 어떻게 통제할 것인지 물었다.
- 팀은 ideal signal을 만들고 noise를 추가하는 방법을 언급했고, 기술 담당자는 그렇게 해야 한다고 했다.
- sample data를 synthetic data 생성에 사용할 수 있다고 했다.

### 25.9 테스트 데이터 및 환경

- 제공된 recording files를 사용할 수 있다.
- 팀 보유 시계로도 테스트해야 한다.
- 프로젝트에는 두 종류의 시계가 있는 것으로 언급되었다.
- 마이크는 주변 소리를 많이 잡으므로 조용한 환경에서 테스트해야 한다.
- 팀이 말하는 소리도 입력에 들어가 detection을 방해할 수 있다.

### 25.10 PC 오디오 영향

- Automatic Gain Control이 켜져 있으면 결과가 망가질 수 있다.
- PC input audio enhancement도 결과를 망가뜨릴 수 있다.
- PC에서 실행하려면 설정을 끄거나, 알고리즘/필터를 달리해야 한다.

### 25.11 Consistency 검토

- 팀은 zero mismatch를 제안했다.
- 기술 담당자는 이상적으로 좋다고 했다.
- 현실적으로 가능한 한 0에 가깝게 만들어야 한다.

### 25.12 Modifiability 검토

- 팀은 개발 시간 기준으로 modifiability를 정의한 것으로 보인다.
- 기술 담당자는 과거 학생들이 UI를 완전히 다시 설계하거나 다른 언어로 재작성한 사례를 언급했다.
- 현재 제공된 코드는 실제 제품과 다르며, 개선을 위한 기반이라고 했다.
- 팀은 자유롭게 더 나은 방식으로 만들 수 있다.

### 25.13 Usability 및 display spec 검토

- 팀은 글자 높이 2.9mm, touch target 9mm 등을 언급했다.
- 기술 담당자는 팀이 800px 화면으로 가정하는 것이 잘못되었다고 했다.
- 실제 디스플레이는 800px보다 크며, Raspberry Pi 5에서 더 많은 공간을 사용할 수 있다고 했다.
- draft/document의 display 부분이 잘못된 것으로 보이며 수정해야 한다고 했다.
- toolkit 안의 display pamphlet을 찾아보라고 했다.

### 25.14 Accuracy 우선순위 강조

- 기술 담당자는 accuracy가 충분히 언급되지 않았다고 했다.
- display numbers의 accuracy가 중요하다고 했다.
- 현재 코드에서 bad value가 들어오면 숫자가 크게 튈 수 있으므로, bad data를 버리는 처리가 필요하다고 했다.
- 팀은 performance를 먼저 두었으나, 기술 담당자는 accuracy를 우선해야 한다고 했다.
- 팀은 priority를 accuracy first, performance/latency second로 바꾸기로 했다.

### 25.15 Raspberry Pi 및 constraints

- 팀은 시스템이 Raspberry Pi에서 동작해야 한다고 확인했다.
- 기술 담당자는 해당 제약은 달성하기 쉬운 편이라고 했다.
- audio 설정과 display spec이 주요 확인 사항으로 남았다.

### 25.16 Windows 설정 확인 시도

- 기술 담당자는 control panel sound 설정에서 마이크 속성, advanced, enhancements 관련 설정을 찾으려 했다.
- 한국어 Windows라 메뉴를 찾기 어려웠다.
- 일부 장치에서는 필요한 탭이 보이지 않았다.
- 결국 enhancement 관련 설정을 찾아 끄는 방향으로 정리되었다.

### 25.17 Trade-off 조언

- 기술 담당자는 품질 속성을 문서에서 뽑아내는 것이 어려운 일이라고 했다.
- 앞으로 trade-off는 더 어려울 것이라고 했다.
- trade-off를 할 때는 반드시 정당화해야 하며, 근거를 댈 수 있어야 한다고 했다.
- 평가에서도 이런 justification이 중요하다고 했다.

### 25.18 팀원 배경 확인

- 팀원들은 camera, signal processing, ISP, cloud/web, washing machine, BSP driver 등 다양한 배경을 공유했다.
- 기술 담당자는 이런 배경이 TIMEGRAPHER 프로젝트에 도움이 될 수 있다고 했다.
- camera 기반 computer vision 접근도 가능하지만, kit에 camera가 없으므로 이번 범위는 아닌 것으로 보인다.

### 25.19 종료 및 후속 안내

- 기술 담당자는 실험을 시작하고 own watch setup을 미루지 말라고 했다.
- documentation을 읽으라고 했다.
- 잘못된 display 관련 문서는 수정하겠다고 했다.
- 필요하면 다시 미팅할 수 있다고 했다.
- 이번 주 town에 있을 것 같으니 필요하면 연락하라고 했다.

---

## 26. 최종 정리

이번 인터뷰 이후 TIMEGRAPHER 프로젝트의 요구사항은 다음 방향으로 정리해야 한다.

- 단순히 “빠른 시스템”이 아니라 **정확한 측정값을 안정적으로 제공하는 시스템**으로 정의한다.
- real-time은 hard real-time이 아니라 **사용자가 조정할 때 충분히 빠른 feedback**으로 해석한다.
- graph 표시와 numeric metric 표시는 다른 latency 목표를 가져야 한다.
- 수치 latency는 BPH와 integration time을 근거로 정해야 한다.
- robustness 수치는 실험으로 검증해야 하며, controlled synthetic input이 필요하다.
- PC 오디오 설정과 주변 소음은 핵심 리스크다.
- UI 기준은 실제 display spec 확인 후 재산정해야 한다.
- 모든 trade-off는 accuracy 우선 원칙과 실험 근거로 정당화해야 한다.

