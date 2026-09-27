$ErrorActionPreference = 'Stop'
$path = '.\index.html'
$backup = '.\index.issue123-seo-backup.html'

if (!(Test-Path $path)) { throw 'STOP: index.html not found.' }
Copy-Item $path $backup -Force
$c = Get-Content $path -Raw -Encoding UTF8

$changes = @(
  @('<title>Vireqo | Website, Customer Service &amp; AI Assistant untuk UMKM</title>', '<title>Vireqo | Website, AI Client Assistant &amp; CS Dashboard untuk UMKM</title>'),
  @('<meta content="Vireqo adalah partner digital UMKM Indonesia untuk website profesional, dashboard customer service, training CS, dan Vireqo AI Client Assistant." name="description"/>', '<meta content="Vireqo membantu UMKM membangun website profesional, melayani pelanggan dengan AI Client Assistant, dan memantau performa Customer Service melalui CS Dashboard." name="description"/>'),
  @('<meta content="Vireqo | Website, Customer Service &amp; AI Assistant untuk UMKM" property="og:title"/>', '<meta content="Vireqo | Website, AI Client Assistant &amp; CS Dashboard untuk UMKM" property="og:title"/>'),
  @('<meta content="Vireqo adalah partner digital UMKM Indonesia untuk website profesional, dashboard customer service, training CS, dan Vireqo AI Client Assistant." property="og:description"/>', '<meta content="Vireqo membantu UMKM membangun website profesional, melayani pelanggan dengan AI Client Assistant, dan memantau performa Customer Service melalui CS Dashboard." property="og:description"/>'),
  @('<meta content="Vireqo | Website, Customer Service &amp; AI Assistant untuk UMKM" name="twitter:title"/>', '<meta content="Vireqo | Website, AI Client Assistant &amp; CS Dashboard untuk UMKM" name="twitter:title"/>'),
  @('<meta content="Vireqo adalah partner digital UMKM Indonesia untuk website profesional, dashboard customer service, training CS, dan Vireqo AI Client Assistant." name="twitter:description"/>', '<meta content="Vireqo membantu UMKM membangun website profesional, melayani pelanggan dengan AI Client Assistant, dan memantau performa Customer Service melalui CS Dashboard." name="twitter:description"/>'),
  @('"description": "Vireqo adalah partner digital UMKM Indonesia untuk website profesional, dashboard customer service, training CS, dan Vireqo AI Client Assistant."', '"description": "Vireqo membantu UMKM membangun website profesional, melayani pelanggan dengan AI Client Assistant, dan memantau performa Customer Service melalui CS Dashboard."'),
  @('{"@type": "Offer", "itemOffered": {"@type": "Service", "name": "Training Customer Service"}}, ', ''),
  @('{"@type": "Offer", "itemOffered": {"@type": "Service", "name": "Konsultasi Customer Service"}}, ', ''),
  @('{"@type": "Offer", "itemOffered": {"@type": "Service", "name": "Konsultasi SEO"}}', '{"@type": "Offer", "itemOffered": {"@type": "Service", "name": "Website + Vireqo AI Client Assistant"}}')
)

try {
  foreach ($x in $changes) {
    $old = $x[0]; $new = $x[1]
    $count = ([regex]::Matches($c, [regex]::Escape($old))).Count
    if ($count -ne 1) { throw "STOP: expected exactly 1 occurrence, found $count for: $old" }
    $c = $c.Replace($old, $new)
  }

  # Preserve UTF-8 without BOM; this also cleans the accidental BOM noted in Issue #123.
  [System.IO.File]::WriteAllText((Resolve-Path $path), $c, (New-Object System.Text.UTF8Encoding($false)))

  $verify = @(
    'Training Customer Service',
    'Konsultasi Customer Service',
    'Konsultasi SEO'
  )
  Write-Host "`nSEO PATCH COMPLETE" -ForegroundColor Green
  Write-Host 'SEO head/schema targets synchronized. Legacy body/service copy is intentionally NOT globally removed by this patch.' -ForegroundColor Yellow
}
catch {
  Copy-Item $backup $path -Force
  Write-Host "`n$($_.Exception.Message)" -ForegroundColor Red
  Write-Host 'ROLLBACK COMPLETE — index.html restored.' -ForegroundColor Yellow
  exit 1
}

Write-Host "`nRun next:" -ForegroundColor Cyan
Write-Host 'git diff --check'
Write-Host 'git diff --numstat -- index.html'
Write-Host 'Do not commit or push until the diff is reviewed.'
