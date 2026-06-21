# Repository Agent Instructions

## Milestone Presentation Documents

- The milestone presentation documents live under `Milestone/en` and `Milestone/ko`.
- Keep English and Korean versions aligned when editing paired files under `Milestone/en` and `Milestone/ko`.
- For local Markdown links inside those directories, use the current numbered filenames such as `1-Project-Plan.md`, `2-Architectural-Drivers.md`, `6-Architectural-View.md`, and `7-Glossary.md`.

## Project-local Skills

- For syncing the copied TimeGrapher-Net ADR set into `Milestone/en/ADR`, `Milestone/ko/ADR`, and the shared `Milestone/assets`, use the `sync-adr` skill. Codex reads `.codex/skills/sync-adr/SKILL.md`; Claude Code reads `.claude/skills/sync-adr/SKILL.md`. Keep the two skill files in sync.
- For checking whether a document follows `DocRules/DocRules.md` (the Seven Rules for Sound Technical Documentation), use the `check-doc` skill. It requires the target document as an argument and, if invoked with none, asks which document to check and stops. Codex reads `.codex/skills/check-doc/SKILL.md`; Claude Code reads `.claude/skills/check-doc/SKILL.md`. Keep the two skill files in sync.

## Terminology

- Use `technical experiment` as the canonical term for focused engineering checks that probe a technical limit before implementation.
- Use `technical experiments` only when the sentence is explicitly plural.
- Do not use `Spike`, `spike`, `PoC`, `POC`, `proof of concept`, `prototype`, or similar substitute terms for this meaning.
- In Korean documents, keep the canonical English term `technical experiment`; do not translate it as `기술실험`, `기술 실험`, `개념검증`, `소규모 실험`, or similar phrases.

## Verification Before Reporting

Before saying the terminology is fully normalized, search all Markdown files under `Milestone/en` and `Milestone/ko`, not only the file currently being edited.

Check English variants:

```powershell
rg -n -i "spike|poc|p\\.o\\.c|p-o-c|proof[ _-]?of[ _-]?concept|prototype|prototyping|pilot|trial" .\Milestone\en .\Milestone\ko
```

Check Korean variants:

```powershell
rg -n "스파이크|피오씨|개념검증|개념 검증|프로토타입|시제품|파일럿|시범|소규모 실험|작은 실험|기술실험|기술 실험" .\Milestone\en .\Milestone\ko
```

Also inspect `experiment` / `실험` matches by context. Generic section names such as `Planned Experiments`, `Experiment Description`, `Risk-to-Experiment Map`, and `실험 설명` are normal and do not need to be replaced.
