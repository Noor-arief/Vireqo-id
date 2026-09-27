$ErrorActionPreference = 'Stop'
$index = Join-Path $PSScriptRoot '..\index.html'
$roadmap = Join-Path $PSScriptRoot '..\docs\issue-123-commercial-refresh.md'
$text = [IO.File]::ReadAllText($index)
$tag = 'Phase 1 mobile trust-badge hotfix'
if ($text -notmatch [regex]::Escape($tag)) {
  $css = @"

/* Phase 1 mobile trust-badge hotfix: desktop untouched */
@media(max-width:860px){
  .hero .badge{display:none !important}
}
"@
  $text = $text.Replace('</style>', $css + "`r`n</style>")
  [IO.File]::WriteAllText($index, $text, [Text.UTF8Encoding]::new($false))
}
$doc = [IO.File]::ReadAllText($roadmap)
$line = '- [x] Real-device mobile correction: hide `Trusted Digital Partner for SMEs` Hero badge at <=860px; desktop Hero remains unchanged.'
if ($doc -notmatch [regex]::Escape($line)) {
  $anchor = '- [x] PHASE 1 COMPLETE'
  $doc = $doc.Replace($anchor, $line + "`r`n" + $anchor)
  [IO.File]::WriteAllText($roadmap, $doc, [Text.UTF8Encoding]::new($false))
}
if (-not (Select-String -Path $index -SimpleMatch '.hero .badge{display:none !important}')) { throw 'Badge CSS verification failed' }
git add index.html docs/issue-123-commercial-refresh.md
git commit -m 'fix: hide mobile Hero trust badge only'
git push origin HEAD:main
Write-Host 'DONE: mobile Hero trust badge hidden; desktop untouched; roadmap updated.' -ForegroundColor Green
