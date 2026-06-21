---
name: check-doc
description: Check whether a target document conforms to the "Seven Rules for Sound Technical Documentation" recorded in DocRules/DocRules.md. The document to check MUST be supplied as an argument; if none is given, ask the user which document to check and stop.
---

# Check Doc

Evaluate whether a **specific target document** follows the seven documentation rules defined in `D:\TimeGrapher-Docs\DocRules\DocRules.md`.

## Required input — the document to check

This skill always operates on a document the user names. It never picks a default and never guesses.

- If the invocation includes a path or reference to a target document, use that document.
- **If no target document was provided (e.g. the user ran `/check-doc` with no argument), do not proceed.** Reply asking which document to check — for example:

  > 어떤 문서를 점검할까요? 점검할 문서 경로를 함께 알려주세요. 예: `/check-doc Milestone/ko/ADR/ADR-002.md`

  — and then stop. Wait for the user to re-invoke the skill with the document. Do not read the rulebook, scan the repo, or pick a likely file in the meantime.

Do not evaluate `DocRules.md` itself unless the user explicitly asks for it; it is the rulebook, not the subject.

## Workflow

1. Confirm a target document was provided. If not, ask for it and stop (see above).
2. Read the rulebook `D:\TimeGrapher-Docs\DocRules\DocRules.md`. It is the authoritative source of the seven rules; re-read it each run in case it changed.
3. Read the full target document.
4. Evaluate the document against each of the seven rules using the rubric below. Base every judgment on the document's actual text and cite concrete evidence (section headings or line numbers).
5. Produce the report in the format below.

## Per-rule rubric

For each rule give a verdict — **Pass / Partial / Fail / N/A** — with evidence and, for anything below Pass, a concrete fix.

1. **Write from the reader's point of view** — Is the intended reader identifiable? Is information ordered by the reader's task rather than by implementation/internal order? Any unexplained jargon, acronyms, or assumed background?
2. **Avoid unnecessary repetition** — Is each kind of information stated once in one authoritative place? Flag duplicated content, especially copies that differ slightly.
3. **Avoid ambiguity** — Are terms and relationships unambiguous? For diagrams: distinct symbols per element/relation type, a notation key, explained lines/colors, consistent symbology, and clear element names (compare against the naming table in the rules).
4. **Use a standard organization** — Does it follow a recognizable template/structure for its document type (e.g. ADR, architecture view, technical experiment)? Is it organized for reference (TOC / searchable headings)? Are incomplete sections marked `TO-DO` / `TBD` / `N/A` rather than left blank?
5. **Record your rationale** — Are design decisions explained, including which significant alternatives were rejected and why?
6. **Keep documentation current, but not too current** — Is the content up to date and internally consistent with its own rules? Are diagrams that may diverge from code updated, or at least marked out of date, rather than silently stale?
7. **Review documentation** — Is there evidence of review appropriate to the document type (status/approval, reviewers, review notes)?

Honor `AGENTS.md` terminology: treat `technical experiment` as canonical — do not flag it as jargon, and never recommend banned substitutes (Spike/PoC/prototype/etc.). Treat `GC spike` as a performance phenomenon.

## Report format

Write the report in the target document's primary language when practical.

1. **Header** — the document path checked, and the `DocRules.md` revision/path it was checked against.
2. **Summary table** — one row per rule: `Rule | Verdict | One-line note`.
3. **Details** — per rule, the supporting evidence (cite headings/line numbers) and a concrete, actionable fix for every Partial/Fail.
4. **Overall verdict** — one of: conforms / minor issues / significant issues — plus the top 3 prioritized fixes.

Keep findings specific and grounded in the document's actual text. Do not invent issues to fill the table; use `N/A` when a rule does not apply to the document type.
