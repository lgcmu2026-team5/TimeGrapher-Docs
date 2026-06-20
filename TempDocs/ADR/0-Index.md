# Architecture Decision Records (ADR) — Index

> CMU-LG Software Architecture Course 2026 · Team 5 · TimeGrapherNet
> 기준 교재: Bass·Clements·Kazman, *Software Architecture in Practice* (SAP).
> 각 ADR은 [SAP_TACTICS_ANALYSIS.md](../../../04.TimeGrapher-Net/docs/for-ai/SAP_TACTICS_ANALYSIS.md)의 코드 근거 검증 결과와 정합한다.
> 새 ADR을 추가·수정할 때는 [ADR 작성 가이드](ADR_CREATE_GUIDE.md)를 먼저 읽고 기준에 맞춘다.

---

## 등록된 ADR

| ADR | 제목 | 핵심 결정 | SAP 적용도 | 상태 | 링크 |
| :---: | :--- | :--- | :---: | :---: | :--- |
| **001** | C#/.NET + Avalonia Cross-Platform Stack | 단일 코드베이스로 Windows·RPi5 커버 (C-3) | `Layers` 기반 · Portability | Accepted | [ADR-001](ADR-001.md) |
| **002** | Three-Layer Architecture (App / Platform / Core) | 하향 단방향·비순환 의존, Core 무의존 | `Layers` ✓ · 변경용이성 택틱군 ✓ | Accepted | [ADR-002](ADR-002.md) |
| **003** | Concurrency Isolation for GUI Real-Time Performance | 분석 엔진 전용 고우선순위 스레드 격리, UI는 렌더링 전담 | `introduce concurrency` ✓ | Accepted | [ADR-003](ADR-003.md) |
| **004** | Pipes and Filters for the Audio Processing Pipeline | 단계 분리 + 표준 인터페이스 캡슐화 (단일 스레드 동기 체인, 동시 경계 2곳) | Pipe-and-Filter **△** | Accepted | [ADR-004](ADR-004.md) |
| **005** | Zero-Allocation via Static Triple-Buffer Pool & Latest-Wins | 고정 3버퍼 풀(Double Buffering 구현) + Latest-Wins 스케줄러 | `maintain multiple copies`·`limit event response` ✓ | Accepted | [ADR-005](ADR-005.md) |
| **006** | Strategy-Based Active Tab Routing & Decimating Metrics Aggregation | 활성 탭만 렌더(Strategy 라우팅) + 고정 용량 감쇠 시계열 | `schedule resources`·`bound resource usage` ✓ | Accepted | [ADR-006](ADR-006.md) |
| **007** | CI-Enforced Dependency Boundaries (fitness function) | CI 텍스트 검사로 Core의 OS 의존 차단, 위반 시 빌드 실패 | `restrict dependencies` ✓ (§4-1) | Accepted | [ADR-007](ADR-007.md) |
| **008** | Run-Session Token & State-Based Lifecycle | 단조 토큰으로 stale-response 차단 + State 패턴 생명주기 | `timestamp`·`fault recovery`·State ✓ (§4-3) | Accepted | [ADR-008](ADR-008.md) |

> **적용도 범례** — ✓ 완전 적용 · △ 유사하나 부분 적용. ADR 004는 단계 구조·캡슐화는 충족하나 완전한 비동기 파이프가 아니므로 SAP 기준 △로 정직하게 표기한다.

---

## 결정 관계 (의존 그래프)

- **기반**: ADR 001(스택) → ADR 002(계층) 위에 나머지 결정이 놓인다.
- **계층 강제**: ADR 002의 의존 규칙은 ADR 007(CI 적합성 함수)이 빌드 시점에 강제한다.
- **실시간 성능 체인**: ADR 003(동시성 격리) → ADR 004(Pipe-and-Filter) → ADR 005(Zero-Allocation) → ADR 006(라우팅/바운딩)이 비트당 125 ms 예산을 함께 방어한다.
- **안정성**: ADR 008(토큰/State)이 ADR 003의 비동기 워커에서 발생하는 stale-response를 차단한다.

---

## 검토 반영 이력 (2026-06-19)

- 누락 ADR **001·002**(기반: 스택·계층)와 **007·008**(CI 의존성 경계·run-session 토큰) 신규 작성.
- 파일명을 `gemini-code-*.md` → **`ADR-00x.md`** 로 통일.
- 전 ADR `Status`를 `Proposed` → `Accepted`로 갱신 (코드 구현·검증 완료 반영).
- ADR 004: "전면 도입 / 비동기 채널" 과잉 주장을 **△ 부분 적용**(단일 스레드 동기 체인, 동시 경계 2곳)으로 정정.
- ADR 006: `RenderToAll`을 "탭 전환 복원"에서 **"pause 종료 커서 제거 전용 1회 예외"**로 오귀속 정정.
- ADR 003: "동시성 격리 패턴" → SAP `introduce concurrency` **tactic**으로 용어 정정, 스레드 간 전달을 Shared-Data 링버퍼 + 바운드 큐로 정확화.
- ADR 005: 패턴 명칭을 **Double Buffering(3버퍼 구현)**으로 명확화, 오타 수정.
