---
name: sync-adr
description: Project-local TimeGrapher-Docs Markdown-only workflow for syncing the copied ADR document set from the latest lgcmu2026-team5/TimeGrapher-Net docs/ADR source into Milestone/en/ADR, Milestone/ko/ADR, and the shared Milestone/assets. Use when the user asks to refresh, resync, update, or verify the imported TimeGrapher-Net ADR copy, including Source/Synced-at headers and assets, without using a bundled script.
---

# Sync ADR

Use this skill only inside the `D:\TimeGrapher-Docs` checkout. Keep the copied ADR set aligned with `https://github.com/lgcmu2026-team5/TimeGrapher-Net/tree/main/docs/ADR`.

This skill intentionally has no bundled sync script. Execute the workflow directly with ordinary Git/file operations available in the current shell, then verify the result.

## Layout

The local layout differs from upstream `docs/ADR`. Upstream keeps `en/`, `ko/`, and `assets/` as siblings under `docs/ADR`; locally the ADRs are split by language and the assets are unified under `Milestone/assets`:

| Upstream `docs/ADR` | Local target |
| --- | --- |
| `en/*.md` | `Milestone/en/ADR/*.md` |
| `ko/*.md` | `Milestone/ko/ADR/*.md` |
| `assets/*` | `Milestone/assets/*` (shared, overlay only) |

Consequences:

- Imported ADR Markdown lives one directory deeper than the assets folder, so upstream asset links written as `](../assets/...)` must be rewritten to `](../../assets/...)` during sync.
- `Milestone/assets` is **shared** with non-ADR presentation images (e.g. `LAYER.png`, `MVC.png`, `USE.png`). Never wipe this directory; only overlay the upstream ADR asset files onto it.
- There is no special local ADR-004 copy. `ADR-004.md` is a normal synced file in both `en/ADR` and `ko/ADR`.

## Managed Copy

Source:

- repo: `https://github.com/lgcmu2026-team5/TimeGrapher-Net.git`
- ref: `main`
- source path: `docs/ADR`

Target (only these are managed):

- `Milestone/en/ADR/*.md`
- `Milestone/ko/ADR/*.md`
- the upstream-originated asset files inside `Milestone/assets`

## Workflow

1. Inspect the worktree before changing files.

```powershell
git -c safe.directory=D:/TimeGrapher-Docs status --short --branch --untracked-files=all
```

2. Clone the source repo to a temp directory with sparse checkout for `docs/ADR`, then record `HEAD`.

```powershell
$tmp = Join-Path $env:TEMP ("tgnet-adr-" + [guid]::NewGuid().ToString("N"))
git clone --depth=1 --filter=blob:none --branch main --sparse https://github.com/lgcmu2026-team5/TimeGrapher-Net.git $tmp
git -C $tmp sparse-checkout set docs/ADR
$commit = (git -C $tmp rev-parse HEAD).Trim()
$src = Join-Path $tmp "docs/ADR"
```

3. Replace the managed targets. Clear and recopy the per-language ADR Markdown, but only **overlay** the assets.

```powershell
$root = "D:\TimeGrapher-Docs\Milestone"

foreach ($lang in @("en", "ko")) {
    $dir = Join-Path $root "$lang\ADR"
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Get-ChildItem $dir -Filter *.md -File | Remove-Item -Force
    Copy-Item -Path (Join-Path $src "$lang\*.md") -Destination $dir -Force
}

# Shared assets: overlay only. Do NOT delete the directory — it also holds presentation images.
Copy-Item -Path (Join-Path $src "assets\*") -Destination (Join-Path $root "assets") -Recurse -Force
```

Before running deletion commands, ensure `$root` is exactly `D:\TimeGrapher-Docs\Milestone` and that removals are scoped to `*.md` files inside `en\ADR` and `ko\ADR`. Do not use broad recursive deletes, and never recursively delete `Milestone\assets`.

4. Add sync headers and retarget asset links in each imported Markdown file. The header path uses the language subfolder, and `](../assets/` is rewritten to `](../../assets/` to match the local layout.

```powershell
$utf8 = New-Object System.Text.UTF8Encoding($false)
foreach ($lang in @("en", "ko")) {
    $dir = Join-Path $root "$lang\ADR"
    foreach ($file in Get-ChildItem $dir -Filter *.md -File) {
        $body = [System.IO.File]::ReadAllText($file.FullName, $utf8)
        $body = $body.Replace("](../assets/", "](../../assets/")
        $header = "> Source: https://github.com/lgcmu2026-team5/TimeGrapher-Net/blob/$commit/docs/ADR/$lang/$($file.Name)`n> Synced at: $commit`n`n"
        [System.IO.File]::WriteAllText($file.FullName, $header + $body, $utf8)
    }
}
```

5. Verify source parity manually:

- For non-Markdown assets, compare SHA-256 hashes between each file under `$src/assets` and the matching file under `$root/assets`.
- For Markdown files, verify the first two lines contain the current `$commit`, then compare the target body after the first blank line with the matching source file — accounting for the `](../assets/` → `](../../assets/` rewrite.
- Confirm every `](../../assets/...)` link in the imported ADRs resolves to an existing file in `Milestone/assets`.
- Re-run if any managed file is missing or differs.

6. Inspect Git changes.

```powershell
git -c safe.directory=D:/TimeGrapher-Docs diff --stat -- Milestone/en/ADR Milestone/ko/ADR Milestone/assets
git -c safe.directory=D:/TimeGrapher-Docs diff --name-status -- Milestone/en/ADR Milestone/ko/ADR Milestone/assets
git -c safe.directory=D:/TimeGrapher-Docs diff --check -- Milestone/en/ADR Milestone/ko/ADR Milestone/assets
```

7. Run the terminology checks from `AGENTS.md` before reporting terminology as clean. Treat GC spike wording as a performance phenomenon, not the banned engineering-check term.

8. If the user asks to commit/push, use the normal Git workflow after verification. Commit only ADR sync paths and directly related project-local skill changes.

## Reporting

Report:

- the source commit hash used for sync
- files changed according to Git
- whether source parity verification passed (assets hashes, headers, and asset-link resolution)
- terminology scan result, with context for benign `spike` matches if present
- any upstream assets removed at source that still linger in `Milestone/assets` (this skill overlays, it does not prune stale ADR assets)
