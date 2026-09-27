$ErrorActionPreference = 'Stop'

$Path = Join-Path $PSScriptRoot '..\index.html'
$Path = [System.IO.Path]::GetFullPath($Path)
$Backup = "$Path.issue123-hero-visual.bak"

if (-not (Test-Path $Path)) { throw "index.html not found: $Path" }

$branch = (git branch --show-current).Trim()
if ($branch -ne 'issue-123-vireqo-commercial-refresh') {
  throw "STOP: run only on issue-123-vireqo-commercial-refresh (current: $branch)"
}

$dirty = git status --porcelain -- index.html
if ($dirty) { throw 'STOP: index.html already has uncommitted changes.' }

$content = [System.IO.File]::ReadAllText($Path, [System.Text.UTF8Encoding]::new($true))
[System.IO.File]::Copy($Path, $Backup, $true)

try {
  $required = @(
    '<span data-i18n="t18">Website & Landing Page</span>',
    '<span data-i18n="t20">AI Client Assistant</span>',
    '<span data-i18n="t21">Ask BIMA</span>'
  )
  foreach ($needle in $required) {
    $count = ([regex]::Matches($content, [regex]::Escape($needle))).Count
    if ($count -ne 1) { throw "STOP: expected exactly 1 checkpoint target [$needle], found $count" }
  }

  if ($content.Contains('issue123-dashboard-float')) { throw 'STOP: dashboard hero visual already exists.' }

  # Extract the existing embedded BIMA avatar. No replacement/generated asset is added.
  $avatarPattern = '(?is)(?<uri>data:image/(?:png|jpeg|webp);base64,[A-Za-z0-9+/=]+)'
  $fabPos = $content.IndexOf('bima-fab')
  if ($fabPos -lt 0) { throw 'STOP: could not locate existing BIMA launcher.' }
  $windowStart = [Math]::Max(0, $fabPos - 12000)
  $windowLen = [Math]::Min(50000, $content.Length - $windowStart)
  $window = $content.Substring($windowStart, $windowLen)
  $avatarMatch = [regex]::Match($window, $avatarPattern)
  if (-not $avatarMatch.Success) { throw 'STOP: existing BIMA avatar could not be isolated safely.' }
  $bimaAvatar = $avatarMatch.Groups['uri'].Value

  $heroAvatarPattern = '(?s)<div class="hv-avatar">.*?</div>\s*<div>\s*<div class="hv-name">BIMA</div>'
  $heroAvatarMatches = [regex]::Matches($content, $heroAvatarPattern)
  if ($heroAvatarMatches.Count -ne 1) { throw "STOP: expected exactly 1 hero BIMA avatar block, found $($heroAvatarMatches.Count)" }
  $heroAvatarReplacement = '<div class="hv-avatar"><img src="' + $bimaAvatar + '" alt="BIMA" style="width:100%;height:100%;object-fit:cover;border-radius:inherit;display:block"></div><div><div class="hv-name">BIMA</div>'
  $content = [regex]::Replace($content, $heroAvatarPattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $heroAvatarReplacement }, 1)

  $anchor = '<div class="hv-float hv-float-2"><div class="hv-float-icon">💬</div><div><div class="hv-float-title"><span data-i18n="t20">AI Client Assistant</span></div><div class="hv-float-sub"><span data-i18n="t21">Ask BIMA</span></div></div></div>'
  $anchorCount = ([regex]::Matches($content, [regex]::Escape($anchor))).Count
  if ($anchorCount -ne 1) { throw "STOP: expected exactly 1 hero AI card anchor, found $anchorCount" }
  $dashboardCard = '<div class="hv-float hv-float-3 issue123-dashboard-float"><div class="hv-float-icon">📊</div><div><div class="hv-float-title"><span data-i18n="t47">Dashboard Customer Service</span></div><div class="hv-float-sub"><span data-i18n="t50">Pantau performa tim CS secara real-time</span></div></div></div>'
  $content = $content.Replace($anchor, $anchor + $dashboardCard)

  $cssAnchor = '.hv-float-2{right:-20px;bottom:35px;animation-delay:1s}'
  if (([regex]::Matches($content, [regex]::Escape($cssAnchor))).Count -ne 1) { throw 'STOP: desktop CSS anchor mismatch.' }
  $cssPatch = $cssAnchor + "`n        .hv-float-3{left:50%;bottom:-22px;transform:translateX(-50%);animation-delay:2s;min-width:245px}`n        .hv-float-3:hover{transform:translateX(-50%) translateY(-4px)}"
  $content = $content.Replace($cssAnchor, $cssPatch)

  $mobileAnchor = '.hv-float-2{right:-8px;bottom:18px}'
  if (([regex]::Matches($content, [regex]::Escape($mobileAnchor))).Count -ne 1) { throw 'STOP: mobile CSS anchor mismatch.' }
  $mobilePatch = $mobileAnchor + "`n            .hv-float-3{left:50%;bottom:-12px;min-width:210px;max-width:82%;padding:9px 12px}"
  $content = $content.Replace($mobileAnchor, $mobilePatch)

  if (([regex]::Matches($content, 'issue123-dashboard-float')).Count -ne 1) { throw 'VERIFY FAILED: dashboard visual count is not 1.' }
  if (-not $content.Contains('alt="BIMA"')) { throw 'VERIFY FAILED: hero did not receive reused BIMA avatar.' }

  [System.IO.File]::WriteAllText($Path, $content, [System.Text.UTF8Encoding]::new($true))
  Write-Host 'PATCH COMPLETE: Issue #123 hero visual triad.' -ForegroundColor Green
  Write-Host 'Hero: Website + Ask BIMA + Customer Service Dashboard.' -ForegroundColor Cyan
  Write-Host 'Existing BIMA avatar reused. Product cards/runtime/backend untouched.' -ForegroundColor Cyan
  git diff --check -- index.html
  git diff --stat -- index.html
}
catch {
  [System.IO.File]::Copy($Backup, $Path, $true)
  throw "Patch failed and index.html was restored. $($_.Exception.Message)"
}
