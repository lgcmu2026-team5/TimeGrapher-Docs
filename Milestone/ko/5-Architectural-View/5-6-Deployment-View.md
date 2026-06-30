# TIMEGRAPHER SYSTEM DEPLOYMENT VIEW – Hardware & External Signal Path

이 뷰는 시스템이 상호작용하는 외부 엔티티와 경계를 보여준다. 아래 배포 뷰는 소프트웨어 전달 경로와 런타임 오디오 신호 경로를 함께 나타낸다.

![배포 뷰 다이어그램](../../assets/deployment-view-detailed.svg)

## Element Catalog

**배포 Target(릴리스):** <https://github.com/lgcmu2026-team5/TimeGrapher-Net/releases>

**배포 흐름 (3단계)**

1. **개발·공유** — 다수 개발자가 각 PC에서 C#/.NET으로 개발하고, `git push`로 Git 서버에 코드를 모은다.
2. **검증·생성** — Git 서버는 push된 사항에 대해 CI/CD로 build/test를 검증하고, `tag v*`에서 타겟별(Windows / Raspberry Pi) 배포 Target을 생성한다.
3. **배포·설치** — 생성된 Target을 Git 서버 네트워크(LAN)를 통해 연결된 각 노드로 배포·설치한다.

**외부 신호 경로:** 런타임에 기계식 시계의 음향 비트 신호가 마이크/픽업을 거쳐 전기신호로 변환되고, USB 오디오로 각 노드의 오디오 입력에 들어간다. 이는 소프트웨어 배포 경로와는 별도의 독립적인 입력 경로다.

## Behavior

N/A. 이 뷰는 배포/인프라 뷰다. 이 노드 위에서 실행되는 런타임 측정 흐름은 [Run Lifecycle Sequence View](5-4-Run-Lifecycle-Sequence-View.md)에서 다룬다.

## Related ADRs

- [ADR-001 — UI 프레임워크를 Avalonia UI + .NET + C# 로 전환](../ADR/ADR-001.md): 배포 노드를 겨냥한 .NET + Avalonia 런타임의 근거.

## Related views

- [Layered View](5-1-Layered-View.md) — 이 노드에 배포되는 바이너리들의 레이어.
