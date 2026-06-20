# ADR 작성 가이드 (ADR_CREATE_GUIDE)

> 새 ADR을 추가하거나 기존 ADR을 고칠 때 **반드시 이 문서를 먼저 읽고** 기준에 맞춘다.
> 기준 템플릿: [pmerson/ADR-template](https://github.com/pmerson/ADR-template) (README + ADR-template.md).

---

## 0. 이 가이드의 한 줄 요약

**ADR은 "구현 전에 내리는 결정"의 기록이다.** 따라서 본문은 *장래형 결정*으로 쓰고, **이미 존재하는 코드 산출물(클래스·파일·필드·설정값)을 근거로 인용하지 않는다.** 코드와의 정합성 추적은 ADR이 아니라 **검증 맵**(`0-Index.md`의 `SAP 적용도` 칸 + [`SAP_TACTICS_ANALYSIS.md`](../../../04.TimeGrapher-Net/docs/for-ai/SAP_TACTICS_ANALYSIS.md))이 담당한다.

> 자기 점검: Decision/Rationale에 `*.cs`·`*.csproj`·클래스명·필드명·API명을 적고 있다면, 그건 "결정"이 아니라 "사후 문서화"다 — 멈추고 개념 수준으로 바꿔라.

---

## 1. 위치·번호·등록

- **ADR 본문**: 이 폴더(`TimeGrapher-Reference/TempDocs/ADR/`)의 `ADR-00x.md` (한 결정 = 한 파일, 1~2쪽).
- **인덱스**: 같은 폴더의 `0-Index.md`.
- 번호는 이어서 부여한다(현재 001~008 → 다음은 009). 번호는 재사용·재배치하지 않는다.
- 새 ADR을 만들면 `0-Index.md`에 **세 곳**을 갱신한다:
  1. **등록 표**에 행 추가 (제목 · 핵심 결정 · `SAP 적용도` · 상태 · 링크).
  2. **결정 관계(의존 그래프)** 에 상·하위/대체 관계 한 줄 추가.
  3. **검토 반영 이력**에 추가 사실 한 줄.

---

## 2. 섹션별 작성 규칙

ADR은 다음 6개 섹션만 쓴다. 순서·이름 고정.

### Title — `ADR N: 결정의 짧은 제목`
- 결정을 한 구절로. 코드 클래스명을 제목에 넣지 않는다(개념어 사용).

### Context (제목 없이 첫 문단)
- 결정을 부르는 **힘(forces)**: 기술적·비용·프로젝트 제약. "왜 지금 결정해야 하는가."
- 아직 *결정·구현 이야기는 하지 않는다*. 요구·제약·리스크만.

### Decision
- **장래형·능동태로 결정을 서술한다** ("~을 채택한다 / 분리한다 / 도입한다", 영문 기준 "We will…").
- **개념·역할 수준**으로 적는다. "무엇을 만들지"이지 "어떤 클래스를 만들었는지"가 아니다.
- 여러 후보 중 하나를 고르는 결정이면, 고른 것을 분명히 쓴다(기각 사유는 Rationale).

### Rationale
- 그 결정을 고른 **이유(품질속성·택틱)**.
- **기각한 주요 대안과 그 사유**를 반드시 포함한다(템플릿이 명시적으로 요구).
- 결정 시점에 알 수 있는 *힘*만 쓴다. 테스트·코드 파일명을 증거로 들지 않는다.

### Status
- **값 하나만**: `Proposed` | `Accepted` | `Deprecated` | `Superseded`.
- 뒤에 텍스트를 붙이는 경우는 **딱 둘뿐**:
  - `Deprecated` — 왜 폐기했는지.
  - `Superseded by ADR NNN` — 어느 ADR이 대체하는지.
- ⚠ "구현 완료", 파일명, `SAP ✓` 같은 **as-built 증거를 Status에 붙이지 않는다.**
- 신규 ADR은 `Proposed`로 시작하고, 팀이 합의하면 `Accepted`로 바꾼다.

### Consequences
- 결정을 적용하면 **예상되는 결과** — 긍정·부정 **모두** 나열(트레이드오프 포함).
- 장래형으로("~이 증가한다 / ~에 그칠 수 있다"). **검증 등급(SAP ✓/△)이나 검증 문서 참조를 넣지 않는다** — 그건 검증 맵의 몫.
- 다른 ADR로 이어지는 영향은 `(ADR 00x)`로 상호참조한다.

---

## 3. 식별자 규칙 (가장 자주 틀리는 부분)

| 본문에 **써도 되는 것** (결정의 내용) | 본문에서 **빼는 것** (구현 산출물) |
| :--- | :--- |
| 채택하는 외부 기술·표준 (예: C#/.NET, Avalonia, NAudio, WASAPI) | 내부 클래스·파일·필드·메서드명 (예: `AnalysisWorker`, `*.cs`, `_runSessionToken`) |
| 디자인 패턴·SAP 택틱 명칭 (예: Strategy, State, `introduce concurrency`) | 빌드·설정 산출물 (예: `*.csproj`, `ci.yml`, RID 문자열 `win-x64`) |
| 설계 수치·예산 (예: 비트당 125 ms, 30초 링버퍼, 3버퍼) | 구체 API·호출명 (예: `ThreadPriority.Highest`, `RenderFrame`, `stackalloc`) |
| 계층·역할 개념어 (예: Core, 분석 엔진, 표준 인터페이스, 단일 어댑터) | 검증 등급·문서 참조 (예: `SAP ✓`, "…△ 항목") |
| 다른 ADR·기술 실험 상호참조 (예: ADR 002, EXP-01) | 테스트·증거 파일명 (예: `*Tests.cs`, fake 구현명) |

**개념화 예시** (실제 교정 사례):
- `AnalysisWorker` 전용 스레드(`ThreadPriority.Highest`) → **분석 엔진 전용 고우선순위 스레드**
- `IAnalysisFrameConsumer`로 캡슐화 → **표준 인터페이스로 캡슐화**
- `Select-String`으로 `NAudio` 토큰 차단 → **텍스트 검사로 OS·플랫폼 의존 토큰 차단**
- 고정 용량 `DecimatingSeries` → **고정 용량 감쇠 시계열(decimating series)**

---

## 4. ADR ↔ 검증 맵 분리 원칙

- **ADR** = 구현 전 *결정*. 순수하게 유지(코드 산출물 없음).
- **검증 맵** = 결정이 코드에 어떻게 구현·검증됐는지의 *추적*.
  - `0-Index.md`의 `SAP 적용도` 칸(✓ 완전 / △ 부분)이 결정↔택틱 정합도를 요약.
  - [`SAP_TACTICS_ANALYSIS.md`](../../../04.TimeGrapher-Net/docs/for-ai/SAP_TACTICS_ANALYSIS.md)가 코드 file:line 근거로 ✓/△를 검증.
- 새 ADR이 어떤 SAP 택틱·패턴을 구현한다면, 그 정합도는 **검증 맵 쪽에 기록**하고 ADR 본문에는 남기지 않는다.

---

## 5. 신규 ADR 체크리스트

작성 후 아래를 모두 만족하는지 확인한다.

- [ ] 다음 번호로 `ADR-00x.md` 생성, 6개 섹션 순서 준수.
- [ ] Context는 힘/제약만 — 해법을 미리 말하지 않음.
- [ ] Decision은 장래형·개념 수준 — 내부 코드 식별자 0개.
- [ ] Rationale에 **기각한 대안과 사유** 포함.
- [ ] Status는 값 하나(신규는 보통 `Proposed`) — as-built 군더더기 없음.
- [ ] Consequences는 긍·부정 모두 — 검증 등급/문서 참조 없음.
- [ ] §3 표 기준으로 식별자 점검(아래 grep으로 자기검증).
- [ ] `0-Index.md` 세 곳(표·의존 그래프·이력) 갱신.
- [ ] 구현·검증되면 `SAP 적용도` 칸과 `SAP_TACTICS_ANALYSIS.md`에 정합도 기록, Status를 `Accepted`로.

**자기검증 grep** (매칭이 나오면 본문에 산출물이 남은 것):

```powershell
rg -n "\.cs\b|\.csproj|\.yml|ThreadPriority|stackalloc|Select-String|win-x64|win-arm64|linux-x64|linux-arm64|SAP\s*[✓△]" .\ADR-*.md
```

---

## 6. 복사용 스켈레톤

```markdown
# ADR N: <결정의 짧은 제목 (개념어)>

<Context: 이 결정을 부르는 힘 — 기술·비용·프로젝트 제약. 해법은 아직 쓰지 않는다.>

## Decision
<장래형·개념 수준으로 "무엇을 한다"를 서술. 내부 코드 식별자 금지.>

## Rationale
* **<품질속성/택틱>**: <왜 이 결정인가>
* **<채택> (vs. <기각 대안> 기각)**: <고른 이유 + 기각 사유>

## Status
Proposed

## Consequences
* <긍정적 결과/예상 효과>
* <부정적 결과/트레이드오프>  (영향이 이어지면 (ADR 00x) 상호참조)
```
