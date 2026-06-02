# ARCHI-265 — TimeGrapher Architecture Documentation

기계식 시계 음향 타이밍 계측기 **TimeGrapher** (Qt / C++17) 의 소프트웨어 아키텍처 산출물 모음입니다.
현재 소스 코드를 코드 레벨로 분석해 재구성한 **현행(As-Is)** 구조와, 리팩터링을 가정한 **목표(To-Be)** 구조를
UML 다이어그램으로 제공합니다.

> LG-CMU Software Architecture Studio 2026

## Live (GitHub Pages)

🔗 **https://ssam1221.github.io/ARCHI-265/**

## 문서 목록

| 문서 | 구분 | 설명 |
| --- | --- | --- |
| [index.html](index.html) | Landing | 산출물 목록 + 각 문서 하이퍼링크 |
| [Architecture_UML.html](Architecture_UML.html) | **As-Is** | 현재 소스를 정적 분석해 재구성한 현행 아키텍처. 계층 구조 · 클래스 다이어그램 · 스레딩 · DSP 파이프라인 · 런타임 시퀀스 · 파일 맵 (6 탭) |
| [Architecture_UML_Ideal.html](Architecture_UML_Ideal.html) | **To-Be** | 현행 코드의 구조적 문제를 개선한 목표 아키텍처. 계층형 + 헥사고날(Ports & Adapters) 기준의 의존성 규칙과 마이그레이션 경로 (7 탭) |

## 분석 대상 개요

TimeGrapher는 시계의 틱 소리를 마이크 · WAV 파일 · 합성 신호로 입력받아, 스트리밍 DSP + 검출 코어를 거쳐
박자수(BPH) · 일오차(rate error) · 진폭(amplitude) · 비트 오차(beat error)를 실시간으로 계측/시각화하는
데스크톱 애플리케이션입니다.

- **현행 핵심 구조**: 생산자–소비자(워커 스레드 → 공유 링버퍼 → GUI 스레드) + Qt와 분리된 순수 C 검출 코어(`libtimegrapher`)
- **목표 구조**: God Object(`MainWindow`)를 계층(Presentation / Application / Domain / Ports / Adapters / Core)으로 분해

## 로컬에서 보기

별도 빌드가 필요 없는 정적 HTML입니다.

```bash
# 1) 가장 간단: index.html 더블클릭

# 2) 또는 정적 서버로 (상대 경로/렌더링 동작 확인)
python -m http.server 8000
# → http://localhost:8000 접속
```

> 다이어그램은 [Mermaid.js](https://mermaid.js.org/)(CDN)로 렌더링되므로 **처음 열 때 인터넷 연결**이 필요합니다.

## 기술 스택

- 정적 HTML + CSS (의존성/빌드 도구 없음)
- 다이어그램: Mermaid.js v10 (CDN 로드)

## GitHub Pages 배포 방법

1. 이 저장소(`index.html`, `Architecture_UML.html`, `Architecture_UML_Ideal.html`, `README.md`)를 **레포 루트**에 푸시
2. **Settings → Pages → Build and deployment**
   - Source: `Deploy from a branch`
   - Branch: `main` / 폴더 `/ (root)` → **Save**
3. 1~2분 후 https://ssam1221.github.io/ARCHI-265/ 에서 확인

> ⚠️ Pages URL 경로는 대소문자를 구분합니다. 저장소명이 `ARCHI-265` 이므로 URL도 `ARCHI-265` 여야 합니다.
> 모든 문서 링크는 같은 폴더 기준 상대 경로라서, 위 파일들이 같은 디렉터리에 있으면 그대로 동작합니다.
