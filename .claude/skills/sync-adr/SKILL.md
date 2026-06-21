---
name: sync-adr
description: Project-local TimeGrapher-Docs Markdown-only workflow for syncing the copied ADR document set from the latest lgcmu2026-team5/TimeGrapher-Net docs/ADR source into Milestone/en/ADR, Milestone/ko/ADR, and the shared Milestone/assets. Use when the user asks to refresh, resync, update, or verify the imported TimeGrapher-Net ADR copy, including Source/Synced-at headers and assets, without using a bundled script.
---

# Sync ADR

Use this skill only inside the `D:\TimeGrapher-Docs` checkout. Keep the copied ADR set aligned with `https://github.com/lgcmu2026-team5/TimeGrapher-Net/tree/main/docs/ADR`.

This skill intentionally has no bundled sync script. Execute the workflow directly with ordinary Git/file operations available in the current shell, then verify the result.

## Shell notes (read first)

These avoid known trial-and-error in this environment:

- **PowerShell variables do not persist between separate tool calls.** `$tmp`, `$src`, `$commit`, `$root` are lost across invocations, so run the clone → copy → header → verify steps that share them **inside a single PowerShell call**. Git-only steps (diff) can be a separate call.
- **Keep deletions narrow.** Only ever remove the specific `*.md` files you are replacing, one file at a time. Never delete `Milestone\assets`, and do not run broad recursive deletes against the working tree.
- **The temp clone lives under `%TEMP%`.** You may simply leave it for the OS to reclaim; cleaning it up is optional and not required for a correct sync.
- Git may warn `LF will be replaced by CRLF` when it touches the synced Markdown. This is a line-ending normalization notice, not an error; ignore it.

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

Run steps 1–5 in a single PowerShell call (they share `$tmp` / `$src` / `$commit` / `$root`).

1. Inspect the worktree before changing files.

```powershell
git -c safe.directory=D:/TimeGrapher-Docs status --short --branch --untracked-files=all
```

2. Clone the source repo to a temp directory with sparse checkout for `docs/ADR`, then record `HEAD`.

```powershell
$root = "D:\TimeGrapher-Docs\Milestone"
$tmp  = Join-Path $env:TEMP ("tgnet-adr-" + [guid]::NewGuid().ToString("N"))
git clone --depth=1 --filter=blob:none --branch main --sparse https://github.com/lgcmu2026-team5/TimeGrapher-Net.git $tmp 2>&1 | Out-Null
git -C $tmp sparse-checkout set docs/ADR 2>&1 | Out-Null
$commit = (git -C $tmp rev-parse HEAD).Trim()
$src = Join-Path $tmp "docs/ADR"
```

3. Replace the managed targets. Overwrite per-language ADR Markdown, remove only stale (upstream-removed) ADRs one file at a time, and **overlay** the assets.

```powershell
foreach ($lang in @("en", "ko")) {
    $dir = Join-Path $root "$lang\ADR"
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    $upstream = @((Get-ChildItem (Join-Path $src $lang) -Filter *.md -File).Name)
    foreach ($local in Get-ChildItem $dir -Filter *.md -File) {
        if ($upstream -notcontains $local.Name) { Remove-Item -LiteralPath $local.FullName -Force }  # stale single file
    }
    Copy-Item -Path (Join-Path $src "$lang\*.md") -Destination $dir -Force
}

# Shared assets: overlay only. Never delete this directory — it also holds presentation images.
Copy-Item -Path (Join-Path $src "assets\*") -Destination (Join-Path $root "assets") -Recurse -Force
```

Ensure `$root` is exactly `D:\TimeGrapher-Docs\Milestone`, keep removals limited to individual `*.md` files under `en\ADR` / `ko\ADR`, and never delete `Milestone\assets`.

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

5. Verify source parity (still inside the same call, while `$src` exists):

```powershell
$assetBase = Join-Path $src "assets"; $tgtBase = Join-Path $root "assets"
$assetOk = $true
foreach ($a in Get-ChildItem -Recurse -File $assetBase) {
    $rel = $a.FullName.Substring($assetBase.Length + 1)
    $tgt = Join-Path $tgtBase $rel
    if (-not (Test-Path $tgt)) { $assetOk = $false; "MISSING asset: $rel" }
    elseif ((Get-FileHash $a.FullName -Algorithm SHA256).Hash -ne (Get-FileHash $tgt -Algorithm SHA256).Hash) { $assetOk = $false; "DIFFER asset: $rel" }
}
$hdrOk = $true; $bodyOk = $true; $linkOk = $true
foreach ($lang in @("en", "ko")) {
    $dir = Join-Path $root "$lang\ADR"
    foreach ($file in Get-ChildItem $dir -Filter *.md -File) {
        $full = [System.IO.File]::ReadAllText($file.FullName, $utf8)
        $lines = $full -split "`n", 3
        if (($lines[0] -notmatch [regex]::Escape($commit)) -or ($lines[1] -notmatch [regex]::Escape($commit))) { $hdrOk = $false; "BAD HEADER: $lang/$($file.Name)" }
        $afterHeader = $full.Substring($full.IndexOf("`n`n") + 2).Replace("](../../assets/", "](../assets/")
        $srcText = [System.IO.File]::ReadAllText((Join-Path $src "$lang\$($file.Name)"), $utf8)
        if ($afterHeader.TrimEnd() -ne $srcText.TrimEnd()) { $bodyOk = $false; "BODY DIFFERS: $lang/$($file.Name)" }
        foreach ($m in [regex]::Matches($full, '\]\((\.\./\.\./assets/[^)]+)\)')) {
            if (-not (Test-Path (Join-Path $dir $m.Groups[1].Value))) { $linkOk = $false; "BROKEN LINK: $lang/$($file.Name) -> $($m.Groups[1].Value)" }
        }
    }
}
"asset=$assetOk header=$hdrOk body=$bodyOk link=$linkOk"
```

Re-run if any managed file is missing or differs. (You may leave the `$tmp` clone in `%TEMP%` for the OS to reclaim.)

6. Inspect Git changes (separate call is fine; no temp variables needed).

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
