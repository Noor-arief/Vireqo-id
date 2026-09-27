$ErrorActionPreference = 'Stop'

$Path = Join-Path $PSScriptRoot '..\index.html'
$Path = [System.IO.Path]::GetFullPath($Path)
$Backup = "$Path.issue123-hero.bak"

if (-not (Test-Path $Path)) { throw "index.html not found: $Path" }

$branch = (git branch --show-current).Trim()
if ($branch -ne 'issue-123-vireqo-commercial-refresh') {
  throw "STOP: run only on issue-123-vireqo-commercial-refresh (current: $branch)"
}

$dirty = git status --porcelain -- index.html
if ($dirty) { throw 'STOP: index.html already has uncommitted changes.' }

$content = [System.IO.File]::ReadAllText($Path, [System.Text.UTF8Encoding]::new($true))
[System.IO.File]::Copy($Path, $Backup, $true)

$changes = @(
  # Visible fallback copy only. Exact span targets prevent touching i18n objects accidentally.
  @('<span data-i18n="t18">Website Siap</span>','<span data-i18n="t18">Website & Landing Page</span>'),
  @('<span data-i18n="t19">Dikerjakan Tim Vireqo</span>','<span data-i18n="t19">Siap untuk Bisnis Anda</span>'),
  @('<span data-i18n="t20">CS Profesional</span>','<span data-i18n="t20">AI Client Assistant</span>'),
  @('<span data-i18n="t21">Respons Cepat dan Ramah</span>','<span data-i18n="t21">Ask BIMA</span>'),

  # Indonesian i18n values.
  @('"t18": "Website Siap"','"t18": "Website & Landing Page"'),
  @('"t19": "Dikerjakan Tim Vireqo"','"t19": "Siap untuk Bisnis Anda"'),
  @('"t20": "CS Profesional"','"t20": "AI Client Assistant"'),
  @('"t21": "Respons Cepat dan Ramah"','"t21": "Ask BIMA"'),

  # English i18n values.
  @('"t18": "Website Delivered"','"t18": "Website & Landing Page"'),
  @('"t19": "Built by the Vireqo Team"','"t19": "Ready for Your Business"'),
  @('"t20": "Professional CS"','"t20": "AI Client Assistant"'),
  @('"t21": "Fast & Friendly Responses"','"t21": "Ask BIMA"')
)

try {
  foreach ($pair in $changes) {
    $old = $pair[0]
    $new = $pair[1]
    $count = ([regex]::Matches($content, [regex]::Escape($old))).Count
    if ($count -ne 1) { throw "STOP: expected exactly 1 occurrence of [$old], found $count" }
    $content = $content.Replace($old, $new)
  }

  # Keep current encoding/BOM to avoid unrelated whole-file encoding churn in this batch.
  [System.IO.File]::WriteAllText($Path, $content, [System.Text.UTF8Encoding]::new($true))

  foreach ($pair in $changes) {
    if ($content.Contains($pair[0])) { throw "VERIFY FAILED: old target remains [$($pair[0])]" }
  }

  Write-Host 'PATCH COMPLETE: Issue #123 hero visual copy only.' -ForegroundColor Green
  Write-Host 'Structure, CSS, animation, JS behavior, BIMA runtime, product cards, SEO, FAQ, legal and backend untouched.' -ForegroundColor Cyan
  git diff --check -- index.html
  git diff --stat -- index.html
}
catch {
  [System.IO.File]::Copy($Backup, $Path, $true)
  throw "Patch failed and index.html was restored. $($_.Exception.Message)"
}
