<#
.SYNOPSIS
  Reduce TimeGrapher --analysis-log CSVs to the QAS-1 latency result table.

.DESCRIPTION
  Reads one or more per-frame latency CSVs produced by TimeGrapher.App's
  --analysis-log option, truncates every file to the common-minimum frame
  count (length unification), and recomputes per-leg avg / p95 / p99 / worst
  from the per-frame columns using nearest-rank percentiles. The beat-period
  budget per file is derived from the BPH parsed out of the filename
  (e.g. win_21600_48k_sim.csv -> 21600 BPH -> 166.667 ms).

  Outputs a Markdown table matching result_latency.md section 5, plus the
  per-leg detail and the QAS-1 pass/fail verdict.

.PARAMETER Csv
  CSV files to include in one comparison group (truncated to a shared frame
  count). Accepts globs / a directory.

.EXAMPLE
  ./analyze_latency.ps1 csv/win/*.csv
#>
param(
    [Parameter(Mandatory = $true, Position = 0, ValueFromRemainingArguments = $true)]
    [string[]] $Csv
)

$ErrorActionPreference = 'Stop'

# Expand directories/globs to concrete .csv paths.
$files = @()
foreach ($spec in $Csv) {
    if (Test-Path -PathType Container $spec) {
        $files += Get-ChildItem -Path $spec -Filter *.csv | Select-Object -ExpandProperty FullName
    } else {
        $files += Get-ChildItem -Path $spec | Select-Object -ExpandProperty FullName
    }
}
$files = $files | Sort-Object -Unique
if ($files.Count -eq 0) { throw "No CSV files matched." }

function Get-BudgetMs([string]$path) {
    $name = [System.IO.Path]::GetFileName($path)
    if ($name -match '(\d{4,6})') {
        $bph = [double]$Matches[1]
        return [math]::Round(3600.0 / $bph * 1000.0, 3)
    }
    return [double]::NaN
}

# nearest-rank: index = ceil(p * n) - 1 on the ascending-sorted sample.
function Get-Percentile([double[]]$sorted, [double]$p) {
    $n = $sorted.Count
    if ($n -eq 0) { return [double]::NaN }
    $idx = [math]::Ceiling($p * $n) - 1
    if ($idx -lt 0) { $idx = 0 }
    if ($idx -ge $n) { $idx = $n - 1 }
    return $sorted[$idx]
}

# Load every file's per-frame legs (cols 0,1,2) and final counters (cols 9,10).
$loaded = @()
foreach ($f in $files) {
    $lines = Get-Content -Path $f
    $rows = $lines | Select-Object -Skip 1 | Where-Object { $_.Trim().Length -gt 0 }
    $cap = New-Object 'System.Collections.Generic.List[double]'
    $disp = New-Object 'System.Collections.Generic.List[double]'
    $e2e = New-Object 'System.Collections.Generic.List[double]'
    $lastDrop = 0; $lastMiss = 0
    foreach ($r in $rows) {
        $c = $r.Split(',')
        $cap.Add([double]::Parse($c[0], [Globalization.CultureInfo]::InvariantCulture))
        $disp.Add([double]::Parse($c[1], [Globalization.CultureInfo]::InvariantCulture))
        $e2e.Add([double]::Parse($c[2], [Globalization.CultureInfo]::InvariantCulture))
        if ($c.Length -gt 10) {
            $lastDrop = [uint64]::Parse($c[9], [Globalization.CultureInfo]::InvariantCulture)
            $lastMiss = [uint64]::Parse($c[10], [Globalization.CultureInfo]::InvariantCulture)
        }
    }
    $loaded += [pscustomobject]@{
        File = [System.IO.Path]::GetFileName($f)
        Cap = $cap; Disp = $disp; E2E = $e2e
        Drop = $lastDrop; Miss = $lastMiss
        Frames = $e2e.Count
        Budget = Get-BudgetMs $f
    }
}

$common = ($loaded | Measure-Object -Property Frames -Minimum).Minimum
Write-Host ("Common minimum frame count: {0} (files truncated to this)" -f $common)
Write-Host ""

function Stat([System.Collections.Generic.List[double]]$v, [int]$n) {
    $slice = $v.GetRange(0, $n).ToArray()
    $sorted = [double[]]($slice | Sort-Object)
    $avg = ($slice | Measure-Object -Average).Average
    [pscustomobject]@{
        Avg = $avg
        P95 = Get-Percentile $sorted 0.95
        P99 = Get-Percentile $sorted 0.99
        Worst = $sorted[$sorted.Count - 1]
    }
}

$f3 = { param($x) ('{0:F3}' -f $x) }

Write-Host "## Summary (E2E)"
Write-Host ""
Write-Host "| File | Frames | E2E avg | E2E p95 | E2E p99 | E2E worst | Budget | Worst usage | Drop | Miss | Result |"
Write-Host "|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|"
foreach ($x in $loaded) {
    $e = Stat $x.E2E $common
    $usage = if ($x.Budget -gt 0) { '{0:F1}%' -f ($e.Worst / $x.Budget * 100.0) } else { 'n/a' }
    $pass = ($x.Budget -gt 0) -and ($e.Worst -le $x.Budget) -and ($x.Drop -eq 0) -and ($x.Miss -eq 0)
    $result = if ($pass) { 'Pass' } else { 'FAIL' }
    Write-Host ("| {0} | {1} | {2} | {3} | {4} | {5} | {6} | {7} | {8} | {9} | {10} |" -f `
        $x.File, $common, (& $f3 $e.Avg), (& $f3 $e.P95), (& $f3 $e.P99), (& $f3 $e.Worst), `
        (& $f3 $x.Budget), $usage, $x.Drop, $x.Miss, $result)
}

Write-Host ""
Write-Host "## Per-leg detail (avg / p95 / p99 / worst, ms)"
Write-Host ""
Write-Host "| File | Leg | avg | p95 | p99 | worst |"
Write-Host "|---|---|---:|---:|---:|---:|"
foreach ($x in $loaded) {
    foreach ($leg in @(@('capture-to-processing', $x.Cap), @('processing-to-display', $x.Disp), @('total end-to-end', $x.E2E))) {
        $s = Stat $leg[1] $common
        Write-Host ("| {0} | {1} | {2} | {3} | {4} | {5} |" -f `
            $x.File, $leg[0], (& $f3 $s.Avg), (& $f3 $s.P95), (& $f3 $s.P99), (& $f3 $s.Worst))
    }
}
