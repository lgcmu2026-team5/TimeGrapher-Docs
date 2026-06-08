# tools — Quire ↔ 문서 정합성 점검

Quire에서 내보낸 작업 데이터(`ARCHI-265.json`)와 이 레포의 `Milestone{1,2,3}/` md 문서를 비교해,
**Quire에서 직접 고쳐야 하는 불일치**를 찾아내기 위한 도구 폴더다.

## 구성 파일
| 파일 | 역할 |
|------|------|
| `SYNC.md` | AI 에이전트에게 주는 점검 지시문 (절차·정본 기준·표 형식) |
| `ARCHI-265.json` | Quire에서 내보낸 프로젝트 작업 트리 (입력, git ignore) |
| `RESULT.md` | 점검 결과 — Quire 수정이 필요한 불일치 표 (출력, git ignore) |

## 사용 방법

### 1. Quire에서 JSON 내보내기
- Quire 프로젝트에서 **내보내기 → JSON** 으로 데이터를 추출한다.
- 받은 파일을 `tools/ARCHI-265.json` 으로 저장(덮어쓰기)한다.

### 2. AI 에이전트로 점검 실행
- AI 에이전트(Claude Code 등)에게 **"SYNC.md 읽고 정리해줘"** 라고 요청한다.
- 에이전트가 `SYNC.md` 절차대로 `ARCHI-265.json` ↔ Milestone 문서를 비교하고,
  결과를 `tools/RESULT.md` 에 저장한다.

### 3. RESULT.md 보고 Quire에서 직접 수정
- `RESULT.md` 의 불일치 표를 보고, **각 항목을 Quire에서 직접 수정**한다.
  (레포 문서가 정본이므로 항상 Quire 쪽을 문서에 맞춘다.)
- 수정 후 1번부터 다시 돌리면 0건이 될 때까지 확인할 수 있다.

## 참고
- 정본(source of truth)은 **레포의 Milestone md 문서**다. 불일치는 Quire를 고쳐 맞춘다.
- `ARCHI-265.json` 과 `RESULT.md` 는 매번 갱신되는 산출물이라 git에서 제외한다(`.gitignore`).
