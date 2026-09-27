param([string]$Path = '.\index.html')
$ErrorActionPreference = 'Stop'

if (-not (Test-Path $Path)) { throw "STOP: index.html not found: $Path" }
$content = [System.IO.File]::ReadAllText((Resolve-Path $Path), [System.Text.Encoding]::UTF8)

$marker = '/* ISSUE123 STEP3 FINAL QA */'
if ($content.Contains($marker)) {
  Write-Host 'STEP3 FINAL QA PATCH ALREADY PRESENT' -ForegroundColor Yellow
  exit 0
}

$styleId = '<style id="issue123-final-approved-hero">'
$stylePos = $content.IndexOf($styleId)
if ($stylePos -lt 0) { throw 'STOP: approved Hero style not found.' }
$styleEnd = $content.IndexOf('</style>', $stylePos)
if ($styleEnd -lt 0) { throw 'STOP: approved Hero style closing tag not found.' }

$qaCss = @'

/* ISSUE123 STEP3 FINAL QA */
html,body{max-width:100%;overflow-x:clip}
.hero{overflow:hidden !important}
@media (min-width:901px){
  .hero{box-sizing:border-box !important}
}
@media (max-width:900px){
  html,body{overflow-x:hidden}
  .hero{overflow:hidden !important}
}
'@

$content = $content.Insert($styleEnd, $qaCss + "`r`n")

# Narrow safety checks: do not write if the approved artwork or core runtime anchors are absent.
$required = @(
  'assets/vireqo-hero-approved.png',
  'id="langBtn"',
  'id="hamburgerBtn"',
  'id="mobileMenu"',
  'bimaFab'
)
foreach ($needle in $required) {
  if (-not $content.Contains($needle)) { throw "STOP: required anchor missing: $needle" }
}

$backup = "$Path.step3-before-final-qa.bak"
Copy-Item $Path $backup -Force
[System.IO.File]::WriteAllText((Resolve-Path $Path), $content, [System.Text.UTF8Encoding]::new($false))

Write-Host 'STEP3 FINAL QA PATCH APPLIED' -ForegroundColor Green
Write-Host 'Horizontal overflow clipped; approved Hero composition preserved.' -ForegroundColor Cyan
Write-Host "Backup: $backup"
git diff --check -- $Path
git diff --stat -- $Path
