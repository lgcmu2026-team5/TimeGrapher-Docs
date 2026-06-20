# JD 문서 작업 패키지

이 폴더는 2026-06-20에 논의한 JD 담당 architecture 문서 작업 패키지다.

## 파일

- `MODULE_USES_VIEW_JD.ko.md`: TimeGrapher module uses / dependency view 한글 초안.
- `ADR-002-partial-pipe-and-filter.ko.md`: TimeGrapher가 완전한 concurrent pipeline 대신 부분 Pipe-and-Filter 스타일을 사용하는 이유를 정리한 한글 ADR 초안.

## 범위

- diagram 범위는 runtime source structure다.
- 먼저 project-level dependency를 보여주고, 그 다음 folder/module-level dependency로 세분화한다.
- 모든 `.cs` 파일을 전부 나열하지 않는다.
- `bin/`, `obj/`, generated files, publish outputs는 제외한다.
