# SciTools Understand 메트릭 용어 사전

PROJ 11 · TimeGrapher 리포트(2026-05-31 생성)에서 실제로 사용된 메트릭 컬럼명과 정식 명칭·설명 정리.
컬럼명·괄호 안 정식명은 **리포트 HTML에 박힌 그대로**이며, 개념의 원조 출처도 함께 표기.

> 출처 구분
> - **복잡도 메트릭** = Thomas McCabe(1976) 원조. Understand가 `Cyclomatic`/`Essential` 등으로 표시.
> - **OO 메트릭** = Chidamber & Kemerer(CK suite, 1994) 원조. Understand가 `LCOM`/`CBO`/`DIT` 등으로 표시.
> - **크기/카운트 메트릭** = Understand 자체 라인/문장 집계.

---

## 1. Program Unit Complexity — 복잡도 (McCabe)

리포트 파일: `progunitcomp_metrics_*.html` (제목 "Program Unit Complexity")

| Understand 컬럼 | 정식 명칭 | 설명 | 해석 기준 |
|---|---|---|---|
| **Cyclomatic** | Cyclomatic Complexity (McCabe) | 코드의 **분기(갈림길) 개수** + 1. `if`/`for`/`while`/`case`마다 +1. 독립 실행 경로 수. | 1–10 정상 · 11–20 복잡 · 21–50 위험 · 50+ 테스트 불가 |
| **Modified** | Modified Cyclomatic Complexity | Cyclomatic 변형. `switch` 문 전체를 분기 **1개**로 계산(각 `case`를 세지 않음). | Cyclomatic과 함께 비교용 |
| **Strict** | Strict Cyclomatic Complexity | 엄격판. `&&`, `\|\|`, `?:` 같은 **논리·조건 연산자까지** 분기로 계산. Cyclomatic ≤ Strict. | 가장 보수적(높게 나옴) |
| **Essential** | Essential Complexity (McCabe) | 잘 구조화된 제어흐름을 모두 접은 뒤 **남는 복잡도**. `break`/`goto`/중간 `return`처럼 구조를 가로지르는 흐름이 많을수록 높음. = "스파게티 정도". | 1 완전 구조화 · 2–4 약간 꼬임 · 4 초과 = 깔끔히 분해 불가 |
| **Nesting** | Maximum Nesting Level | 블록 **중첩 깊이**의 최댓값(if 안의 if 안의 for …). | 깊을수록 가독성·테스트성 저하 |
| **Path Count** | Path Count | 함수를 지나는 **가능한 실행 경로 수**. 분기·루프 조합으로 지수적 증가. | 클수록 전수 테스트 불가능 |
| **Path Count Log** | Path Count (log₁₀) | Path Count의 상용로그값(자릿수). | 6 ≈ 백만 단위 |

**예시 — `tg_process`** (`progunitcomp_metrics_T.html`):
Cyclomatic **37** / Modified 37 / Strict 45 / Essential **14** / Nesting 4 / Path Count **1,179,367** / Log 6
→ 크고(37) + 꼬여서(14) 리팩터링 1순위. 비교로 `tg_detector_process`는 Cyclomatic 30이지만 Essential **3**이라 크지만 구조는 단정.

---

## 2. Class OO Metrics — 객체지향 (CK suite)

리포트 파일: `classoom_*.html` (제목 "Class OO Metrics"). 괄호 안은 리포트가 표기한 정식명.

| Understand 컬럼 | 정식 명칭(리포트 표기) | 설명 | 해석 기준 |
|---|---|---|---|
| **LCOM** | Percent Lack of Cohesion | **응집도 결핍 %**. 클래스 메서드들이 서로 다른 멤버 변수를 쓸수록 ↑. 높으면 "한 클래스가 무관한 일을 여럿 함". | 낮을수록 좋음. 목표 <30%, **96%면 사실상 무응집** |
| **DIT** | Max Inheritance Tree | **상속 트리 최대 깊이**. 0/1이면 상속·다형성 거의 없음(평평한 설계). | 적당히(2–4). 1이면 추상화 부재 신호일 수 있음 |
| **IFANIN** | Count of Base Classes | **직접 부모(기반) 클래스 수**. | — |
| **CBO** | Count of Coupled Classes | **결합된 클래스 수**(이 클래스가 의존하는 다른 클래스 개수). 높으면 변경 파급 큼. | 낮을수록 좋음. 높으면 강결합 |
| **NOC** | Count of Derived Classes | **자식(파생) 클래스 수**. | — |
| **RFC** | Count of All Methods | **Response For a Class** — 이 클래스가 호출 가능한 전체 메서드 수(자기+호출하는 것). 높으면 복잡·테스트 부담. | 낮을수록 좋음 |
| **NIM** | Count of Instance Methods | **인스턴스 메서드 개수**. | 너무 많으면 책임 과다 |
| **NIV** | Count of Instance Variables | **인스턴스 변수(필드) 개수**. 많으면 상태 과다 보유. | 너무 많으면 god class 신호 |
| **WMC** | Count of Methods | **Weighted Methods per Class** — 메서드 수(가중치 합). 클래스 전체 복잡도 척도. | 낮을수록 좋음 |

**예시 — `MainWindow`** (`classoom_M.html`):
LCOM **96** / DIT 1 / CBO **48** / RFC **75** / NIM 74 / NIV **44** / WMC **75**
→ 무응집(96) + 강결합(48) + 거대(WMC 75, 변수 44개) = 전형적 **God Class**.

---

## 3. Size & Count — 크기/카운트

리포트 파일: `file_metrics_*.html`("File Metrics"), `progunit_metrics_*.html`("Program Unit Metrics")

| Understand 컬럼 | 정식 명칭 | 설명 |
|---|---|---|
| **Lines** | Count of Lines | 전체 줄 수(코드+주석+공백). |
| **Code** | Count of Code Lines | 코드 줄 수. |
| **Comments** | Count of Comment Lines | 주석 줄 수. |
| **Blanks** | Count of Blank Lines | 공백 줄 수. |
| **Lines-exe** | Lines with Executable code | 실행 코드가 있는 줄. |
| **Lines-dec** | Lines with Declarative code | 선언(타입·변수 정의) 줄. |
| **Stmt-exe** | Executable Statements | 실행 문장 수. |
| **Stmt-dec** | Declarative Statements | 선언 문장 수. |
| **Ratio Comment/Code** | Comment to Code Ratio | 주석/코드 비율. 0.39 = 코드 100줄당 주석 39줄. |
| **Units** | Count of Program Units (파일별) | 파일 안의 함수/구조체 등 프로그램 유닛 수. |

---

## 4. Project Metrics — 프로젝트 전체

리포트 파일: `projmetrics.html`, `title_overview.html` (제목 "Project Metrics")

| 항목 | 설명 | TimeGrapher 값 |
|---|---|---|
| Classes | 클래스 수 | 9 |
| Files | 파일 수 | 34 |
| Program Units | 함수·구조체·변수 등 전체 유닛 | 305 |
| Lines | 전체 줄 수 | 10,638 |
| Lines Code | 코드 줄 | 6,028 |
| Lines Comment | 주석 줄 | 2,368 |
| Lines Blank | 공백 줄 | 1,186 |
| Lines Inactive | **비활성 줄**(`#if`로 컴파일 제외된 코드) | 977 |
| Executable Statements | 실행 문장 | 2,839 |
| Declarative Statements | 선언 문장 | 1,824 |
| Ratio Comment/Code | 주석/코드 비율 | 0.39 |

> 참고: `Lines Inactive 977`의 거의 전부(931)는 Windows에서 리포트를 생성해 `LinuxAudio.cpp`의 `#if Q_OS_LINUX` 블록이 통째로 비활성된 것 — 별도 분석 문서(`understand-analysis.md` H1) 참조.

---

## 용어 표기 권장 (과제 보고서용)

- 정확한 표현: **"Understand가 측정한 McCabe Cyclomatic/Essential Complexity"**, **"CK 객체지향 메트릭(LCOM/CBO/RFC 등)"**
- 즉 *개념·정의*는 McCabe·CK가 원조이고, *이 리포트의 컬럼 라벨*은 Understand가 표시한 이름.
