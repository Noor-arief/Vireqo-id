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
  # Checkpoint de6ec99 already contains the approved Website + Ask BIMA hero labels.
  # This patch only completes the visual triad with Customer Service Dashboard and
  # reuses the already-embedded BIMA avatar. No new image asset is generated.
  $required = @(
    '<span data-i18n="t18">Website & Landing Page</span>',
    '<span data-i18n="t20">AI Client Assistant</span>',
    '<span data-i18n="t21">Ask BIMA</span>'
  )
  foreach ($needle in $required) {
    $count = ([regex]::Matches($content, [regex]::Escape($needle))).Count
    if ($count -ne 1) { throw "STOP: expected exactly 1 checkpoint target [$needle], found $count" }
  }

  if ($content.Contains('issue123-dashboard-float')) {
    throw 'STOP: Customer Service Dashboard hero visual already exists.'
  }

  # Reuse an existing embedded BIMA avatar from the live document. We deliberately
  # do not store/copy a second base64 asset in the repository.
  $avatarMatch = [regex]::Match(
    $content,
    '(?is)<[^>]*class="[^"]*bima[^\"]*avatar[^\"]*"[^>]*>.*?(?:src|background-image\s*:\s*url\()\s*[=:\(]?\s*["'']?(?<uri>data:image/(?:png|jpeg|webp);base64,[A-Za-z0-9+/=]+)'
  )
  if (-not $avatarMatch.Success) {
    # Fallback: locate the first embedded image in the BIMA launcher neighbourhood.
    $fabPos = $content.IndexOf('bima-fab')
    if ($fabPos -lt 0) { throw 'STOP: could not locate existing BIMA launcher/avatar source.' }
    $windowStart = [Math]::Max(0, $fabPos - 12000)
    $windowLen = [Math]::Min(50000, $content.Length - $windowStart)
    $window = $content.Substring($windowStart, $windowLen)
    $avatarMatch = [regex]::Match($window, '(?<uri>data:image/(?:png|jpeg|webp);base64,[A-Za-z0-9+/=]+)')
  }
  if (-not $avatarMatch.Success) { throw 'STOP: existing BIMA avatar is embedded but could not be isolated safely; no write performed.' }
  $bimaAvatar = $avatarMatch.Groups['uri'].Value

  # Replace only the generic avatar inside the hero's Ask BIMA mockup.
  $heroAvatarPattern = '(?s)<div class="hv-avatar">.*?</div>\s*<div>\s*<div class="hv-name">BIMA</div>'
  $heroAvatarMatches = [regex]::Matches($content, $heroAvatarPattern)
  if ($heroAvatarMatches.Count -ne 1) { throw "STOP: expected exactly 1 hero BIMA avatar block, found $($heroAvatarMatches.Count)" }
  $heroAvatarReplacement = '<div class="hv-avatar"><img src="' + $bimaAvatar + '" alt="BIMA" style="width:100%;height:100%;object-fit:cover;border-radius:inherit;display:block"></div><div><div class="hv-name">BIMA</div>'
  $content = [regex]::Replace($content, $heroAvatarPattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $heroAvatarReplacement }, 1)

  # Add a third compact floating card after the existing AI Client Assistant card.
  # Existing t47/t50 translations are reused, so no new i18n keys are introduced.
  $anchor = '<div class="hv-float hv-float-2"><div class="hv-float-icon">💬</div><div><div class="hv-float-title"><span data-i18n="t20">AI Client Assistant</span></div><div class="hv-float-sub"><span data-i18n="t21">Ask BIMA</span></div></div></div>'
  $anchorCount = ([regex]::Matches($content, [regex]::Escape($anchor))).Count
  if ($anchorCount -ne 1) { throw "STOP: expected exactly 1 hero AI card anchor, found $anchorCount" }
  $dashboardCard = '<div class="hv-float hv-float-3 issue123-dashboard-float"><div class="hv-float-icon">📊</div><div><div class="hv-float-title"><span data-i18n="t47">Dashboard Customer Service</span></div><div class="hv-float-sub"><span data-i18n="t50">Pantau performa tim CS secara real-time</span></div></div></div>'
  $content = $content.Replace($anchor, $anchor + $dashboardCard)

  # Minimal scoped CSS. Does not alter existing card positions or hero layout.
  $cssAnchor = '.hv-float-2{right:-20px;bottom:35px;animation-delay:1s}'
  $cssCount = ([regex]::Matches($content, [regex]::Escape($cssAnchor))).Count
  if ($cssCount -ne 1) { throw "STOP: expected exactly 1 hv-float-2 CSS anchor, found $cssCount" }
  $cssPatch = $cssAnchor + "`n        .hv-float-3{left:50%;bottom:-22px;transform:translateX(-50%);animation-delay:2s;min-width:245px}`n        .hv-float-3:hover{transform:translateX(-50%) translateY(-4px)}"
  $content = $content.Replace($cssAnchor, $cssPatch)

  # Mobile: keep the third card compact and inside the hero visual bounds.
  $mobileAnchor = '.hv-float-2{right:-8px;bottom:18px}'
  $mobileCount = ([regex]::Matches($content, [regex]::Escape($mobileAnchor))).Count
  if ($mobileCount -ne 1) { throw "STOP: expected exactly 1 mobile hv-float-2 CSS anchor, found $mobileCount" }
  $mobilePatch = $mobileAnchor + "`n            .hv-float-3{left:50%;bottom:-12px;min-width:210px;max-width:82%;padding:9px 12px}"
  $content = $content.Replace($mobileAnchor, $mobilePatch)

  # Verification before write.
  if (([regex]::Matches($content, 'issue123-dashboard-float')).Count -ne 1) { throw 'VERIFY FAILED: dashboard visual count is not 1.' }
  if (([regex]::Matches($content, '<img src="data:image/(?:png|jpeg|webp);base64,[^"]+" alt="BIMA"')).Count -lt 1) { throw 'VERIFY FAILED: hero did not receive reused BIMA avatar.' }

  [System.IO.File]::WriteAllText($Path, $content, [System.Text.UTF8Encoding]::new($true))

  Write-Host 'PATCH COMPLETE: Issue #123 hero visual triad.' -ForegroundColor Green
  Write-Host 'Hero now represents Website + Ask BIMA + Customer Service Dashboard.' -ForegroundColor Cyan
  Write-Host 'Existing BIMA avatar reused; no generated/replacement asset added.' -ForegroundColor Cyan
  Write-Host 'Product cards, BIMA runtime, backend, SEO, FAQ, legal and unrelated sections untouched.' -ForegroundColor Cyan
  git diff --check -- index.html
  git diff --stat -- index.html
}
catch {
  [System.IO.File]::Copy($Backup, $Path, $true)
  throw "Patch failed and index.html was restored. $($_.Exception.Message)"
}
