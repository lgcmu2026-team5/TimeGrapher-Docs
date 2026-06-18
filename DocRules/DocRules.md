# Seven Rules for Sound Technical Documentation

Source: Section P.5 in [Clements10]
Context: LG Architecture Training Program, Paulo Merson

## Rule Summary

1. Write from the reader's point of view.
2. Avoid unnecessary repetition.
3. Avoid ambiguity.
4. Use a standard organization.
5. Record your rationale.
6. Keep documentation current, but not too current.
7. Review documentation.

## 1. Write from the Reader's Point of View

Good technical documentation starts with the reader:

- Identify who the readers are.
- Find out what they need to know.
- Make the information concise and easy to find.
- Write so readers are more likely to use the document.

Avoid writer-centered documentation. Common warning signs are:

- Topics appear in the random order that occurred to the writer.
- Topics follow the internal order of the computer or implementation rather than the reader's task.
- The writer assumes too much background knowledge, including unfamiliar jargon or acronyms.

## 2. Avoid Unnecessary Repetition

Record each kind of information in one authoritative place. This makes documents easier to use and easier to change.

Repeated information can confuse readers, especially when the repeated versions differ slightly. The reader is then forced to ask:

- Was the difference intentional?
- If it was intentional, why?
- If it was not intentional, which version is correct?

## 3. Avoid Ambiguity

Documentation communicates information and ideas. If the reader misunderstands because the document is ambiguous, the documentation has failed.

Even simple concepts can be confusing. For example, a relation from `A` to `B` might mean several different things:

- `A` uses `B`.
- Data flows from `A` to `B`.
- `A` calls `B` over the network.
- `A` sends a message to `B`.
- `A` instantiates `B`.
- `A` is a subtype of `B`.

For architecture diagrams:

- Use distinct symbols for different types of elements and relations.
- Always add a notation key.
- Explain the meaning of lines and colors.
- If you use a style or pattern, make that clear in the documentation.
- Use consistent symbology across the entire documentation.
- Name your components clearly. Elements in a software architecture diagram must have clear names.

Naming examples:

| Where | Not so good | Good |
| --- | --- | --- |
| Architecture views | "Dynamic view" | "User Account Management Layered view" |
| Code identifiers | `int d; // elapsed time in days` | `int elapsedTimeInDays;` |

## 4. Use a Standard Organization

Establish a standard organization for each type of document. Make sure writers follow it, and make sure readers know what it is.

A standard organization:

- Helps readers navigate and find information.
- Tells writers what to document and where it belongs.
- Helps writers plan the work and measure what remains.
- Lets writers record information as soon as it is known, even if discovery happens out of order.

Templates define standard organizations for document types. Examples:

- technical experiment template: `github.com/pmerson/technical-experiment-template`
- architecture view template: `github.com/pmerson/architecture-view-template`
- architecture decision record (ADR) template: `github.com/pmerson/ADR-template`

### Organize for Reference

A document may be read from cover to cover only once, if at all. A successful document may be referenced hundreds or thousands of times, so information must be easy to find.

Use:

- Search mechanisms for online documents.
- A good table of contents.
- A reader's guide for multi-purpose documents.

### Do Not Leave Incomplete Sections Blank

If a section is incomplete:

- Mark it with `TO-DO` or `TBD` when content will be provided later.
- Mark it with `N/A` when there is no applicable information to record.

## 5. Record Your Rationale

Record why design decisions were made:

- How will you remember the reasoning next week or next year?
- How will the next designer understand the reasoning?
- What significant alternatives were rejected?

Recording rationale requires discipline, but it saves time in the long run and helps avoid repeating the same dead ends. ADRs are useful for this.

## 6. Keep Documentation Current, but Not Too Current

This rule applies throughout the system life cycle.

Documentation that is incomplete or out of date:

- Does not reflect the truth.
- Disobeys its own rules for form and internal consistency.
- Is unlikely to be used.

Documentation that is kept current:

- Provides quick and efficient answers to questions about the software.
- Is more likely to be used.

Build a documentation-based culture:

- When someone asks a question, first point to where the answer lives in the documentation.
- If the information is missing, update the document.
- Make sure the next release contains the updated information.
- Treat documentation as the preferred, authoritative source for information.

### Out-of-Date Diagrams

Design diagrams and their accompanying prose are created to support design discussion. Once the code is written, the diagram has often served its main purpose. It is common for code to eventually differ from the original design.

When a diagram no longer reflects the code:

- Update it if feasible. This is ideal.
- Do not leave it unchanged without warning. This is the worst option.
- Erase it or mark it as out of date when updating is not feasible. This is acceptable.

## 7. Review Documentation

Only intended users can tell whether a document:

- Contains the right information.
- Presents the information in a useful way.
- Satisfies their needs.

Plan reviews with stakeholder representatives. If the document is large, ask different people to review different sections. Ask reviewers specific questions about the content to check how much they understood.

## Contact

Questions: Paulo Merson, pmerson@cmu.edu
