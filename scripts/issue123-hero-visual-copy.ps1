$ErrorActionPreference = 'Stop'
$Path = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\index.html'))
$Backup = "$Path.issue123-hero-visual.bak"
if (-not (Test-Path $Path)) { throw "index.html not found: $Path" }
if ((git branch --show-current).Trim() -ne 'issue-123-vireqo-commercial-refresh') { throw 'STOP: wrong branch.' }
if (git status --porcelain -- index.html) { throw 'STOP: index.html already has uncommitted changes.' }
$content = [System.IO.File]::ReadAllText($Path, [System.Text.UTF8Encoding]::new($true))
[System.IO.File]::Copy($Path, $Backup, $true)
try {
  foreach ($needle in @('<span data-i18n="t18">Website & Landing Page</span>','<span data-i18n="t20">AI Client Assistant</span>','<span data-i18n="t21">Ask BIMA</span>')) {
    if (([regex]::Matches($content,[regex]::Escape($needle))).Count -ne 1) { throw "STOP: checkpoint target mismatch: $needle" }
  }
  if ($content.Contains('issue123-dashboard-float')) { throw 'STOP: dashboard hero visual already exists.' }

  $fabPos = $content.IndexOf('bima-fab')
  if ($fabPos -lt 0) { throw 'STOP: BIMA launcher not found.' }
  $start = [Math]::Max(0,$fabPos-12000)
  $len = [Math]::Min(50000,$content.Length-$start)
  $window = $content.Substring($start,$len)
  $avatar = [regex]::Match($window,'data:image/(?:png|jpeg|webp);base64,[A-Za-z0-9+/=]+')
  if (-not $avatar.Success) { throw 'STOP: existing BIMA avatar not isolated safely.' }

  $avatarPattern = '(?s)<div class="hv-avatar">.*?</div>\s*<div>\s*<div class="hv-name">BIMA</div>'
  if (([regex]::Matches($content,$avatarPattern)).Count -ne 1) { throw 'STOP: hero BIMA avatar block mismatch.' }
  $avatarHtml = '<div class="hv-avatar"><img src="' + $avatar.Value + '" alt="BIMA" style="width:100%;height:100%;object-fit:cover;border-radius:inherit;display:block"></div><div><div class="hv-name">BIMA</div>'
  $content = [regex]::Replace($content,$avatarPattern,[System.Text.RegularExpressions.MatchEvaluator]{param($m) $avatarHtml},1)

  # Match the existing AI float card by its i18n keys so the script never embeds the emoji literal.
  $anchorPattern = '(?s)<div class="hv-float hv-float-2">.*?<span data-i18n="t20">AI Client Assistant</span>.*?<span data-i18n="t21">Ask BIMA</span>.*?</div>\s*</div>\s*</div>'
  $anchorMatch = [regex]::Match($content,$anchorPattern)
  if (-not $anchorMatch.Success) { throw 'STOP: hero AI card anchor mismatch.' }
  $card = '<div class="hv-float hv-float-3 issue123-dashboard-float"><div class="hv-float-icon">D</div><div><div class="hv-float-title"><span data-i18n="t47">Dashboard Customer Service</span></div><div class="hv-float-sub"><span data-i18n="t50">Pantau performa tim CS secara real-time</span></div></div></div>'
  $content = $content.Substring(0,$anchorMatch.Index+$anchorMatch.Length) + $card + $content.Substring($anchorMatch.Index+$anchorMatch.Length)

  $desktop = '.hv-float-2{right:-20px;bottom:35px;animation-delay:1s}'
  if (([regex]::Matches($content,[regex]::Escape($desktop))).Count -ne 1) { throw 'STOP: desktop CSS anchor mismatch.' }
  $desktopAdd = $desktop + [Environment]::NewLine + '        .hv-float-3{left:50%;bottom:-22px;transform:translateX(-50%);animation-delay:2s;min-width:245px}' + [Environment]::NewLine + '        .hv-float-3:hover{transform:translateX(-50%) translateY(-4px)}'
  $content = $content.Replace($desktop,$desktopAdd)

  $mobile = '.hv-float-2{right:-8px;bottom:18px}'
  if (([regex]::Matches($content,[regex]::Escape($mobile))).Count -ne 1) { throw 'STOP: mobile CSS anchor mismatch.' }
  $mobileAdd = $mobile + [Environment]::NewLine + '            .hv-float-3{left:50%;bottom:-12px;min-width:210px;max-width:82%;padding:9px 12px}'
  $content = $content.Replace($mobile,$mobileAdd)

  if (([regex]::Matches($content,'issue123-dashboard-float')).Count -ne 1) { throw 'VERIFY FAILED: dashboard visual count.' }
  if (-not $content.Contains('alt="BIMA"')) { throw 'VERIFY FAILED: BIMA avatar.' }
  [System.IO.File]::WriteAllText($Path,$content,[System.Text.UTF8Encoding]::new($true))
  Write-Host 'PATCH COMPLETE: Issue 123 hero visual triad.' -ForegroundColor Green
  Write-Host 'Website + Ask BIMA + Customer Service Dashboard.' -ForegroundColor Cyan
  git diff --check -- index.html
  git diff --stat -- index.html
}
catch {
  [System.IO.File]::Copy($Backup,$Path,$true)
  throw ('Patch failed; index.html restored. ' + $_.Exception.Message)
}
