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
  # Visible fallback copy in the existing hero illustration. Structure/CSS/animation untouched.
  @('Website Siap','Website & Landing Page'),
  @('Dikerjakan Tim Vireqo','Siap untuk Bisnis Anda'),
  @('CS Profesional','AI Client Assistant'),
  @('Respons Cepat dan Ramah','Ask BIMA'),

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

  # Preserve UTF-8 BOM because current production file already has it; do not introduce unrelated encoding churn.
  [System.IO.File]::WriteAllText($Path, $content, [System.Text.UTF8Encoding]::new($true))

  $required = @(
    'Website & Landing Page',
    'AI Client Assistant',
    'Ask BIMA',
    'Ready for Your Business'
  )
  foreach ($value in $required) {
    if (-not $content.Contains($value)) { throw "VERIFY FAILED: missing [$value]" }
  }

  Write-Host 'PATCH COMPLETE: Issue #123 hero visual copy only.' -ForegroundColor Green
  Write-Host 'No CSS, JS behavior, BIMA runtime, product cards, SEO, FAQ, legal, or backend intentionally changed.' -ForegroundColor Cyan
  git diff --check -- index.html
  git diff --stat -- index.html
}
catch {
  [System.IO.File]::Copy($Backup, $Path, $true)
  throw "Patch failed and index.html was restored. $($_.Exception.Message)"
}
