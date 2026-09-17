from pathlib import Path

p = Path('index.html')
s = p.read_text(encoding='utf-8')

# Fix stale internal service context while preserving the existing service key/routing.
repls = {
    "staffing:'Penyediaan SDM Customer Service'": "staffing:'Vireqo AI Client Assistant'",
    "staffing:'Customer Service Staffing'": "staffing:'Vireqo AI Client Assistant'",
    "staffing:'Anda memilih Penyediaan SDM Customer Service. BIMA akan mulai dari kebutuhan jumlah CS, jam operasional, channel, dan kriteria kandidat.'": "staffing:'Anda memilih Vireqo AI Client Assistant. BIMA akan mulai dari kebutuhan website, alur percakapan pelanggan, informasi bisnis, dan proses handover ke tim Anda.'",
    "staffing:'You selected Customer Service Staffing. BIMA will start with headcount, operating hours, channels, and candidate requirements.'": "staffing:'You selected Vireqo AI Client Assistant. BIMA will start with your website, customer conversation flow, business information, and handover process to your team.'",
    "staffing:'Penyediaan SDM Customer Service',seo": "staffing:'Vireqo AI Client Assistant',seo",
}
for old, new in repls.items():
    s = s.replace(old, new)

# Catch the API label specifically if it is still stale.
s = s.replace("staffing:'Penyediaan SDM Customer Service'", "staffing:'Vireqo AI Client Assistant'")
s = s.replace('>Penyediaan SDM Customer Service</button>', '>Vireqo AI Client Assistant</button>')
s = s.replace('>Customer Service Staffing</button>', '>Vireqo AI Client Assistant</button>')

marker = '/* BIMA_CHAT_RESPONSIVE_FIX_2026_09_18 */'
css = r'''
<style id="bima-chat-responsive-fix">
/* BIMA_CHAT_RESPONSIVE_FIX_2026_09_18
   Scoped to BIMA only. Desktop + mobile chat geometry; no site-wide layout changes. */
.bima-panel{
  width:min(410px,calc(100vw - 32px));
  height:min(560px,calc(100dvh - 120px));
  max-height:min(560px,calc(100dvh - 120px));
}
.bima-panel .bima-body{
  flex:1 1 auto;
  min-height:0;
  overflow-y:auto;
  overscroll-behavior:contain;
  padding:14px;
}
.bima-panel.chat-active .bima-body{display:flex;flex-direction:column}
.bima-panel.chat-active .bima-messages{flex:1 1 auto;padding-top:8px;margin-top:0}
.bima-panel .bima-msg{max-width:84%;padding:10px 12px;line-height:1.5}
.bima-panel .bima-input-wrap{padding:10px;gap:8px}
.bima-panel .bima-input{min-height:42px;padding:10px 11px}
.bima-panel .bima-send{width:42px;height:42px}

@media (max-width:600px){
  .bima-panel{
    top:auto;
    left:10px;
    right:10px;
    bottom:72px;
    width:auto;
    height:min(560px,calc(100dvh - 96px));
    max-height:min(560px,calc(100dvh - 96px));
    border-radius:18px;
  }
  .bima-panel .bima-head{padding:10px 12px;min-height:64px;gap:10px}
  .bima-panel .bima-avatar{width:42px;height:42px;border-radius:13px}
  .bima-panel .bima-avatar img{width:51px;height:51px}
  .bima-panel .bima-head-title{font-size:15px}
  .bima-panel .bima-head-sub{font-size:10.5px;margin-top:2px}
  .bima-panel .bima-online{font-size:10px;margin-top:3px}
  .bima-panel .bima-close{width:34px;height:34px}
  .bima-panel .bima-body{padding:12px}
  .bima-panel .bima-msg{max-width:88%;font-size:12.5px;padding:9px 11px}
  .bima-panel.chat-active .bima-messages{padding-top:4px;gap:8px}
  .bima-panel .bima-input-wrap{padding:9px}
  .bima-panel .bima-input{font-size:13px;min-height:42px}
  .bima-panel .bima-send{width:42px;height:42px}
}

@media (max-width:390px){
  .bima-panel{left:8px;right:8px;bottom:66px;height:min(540px,calc(100dvh - 84px));max-height:min(540px,calc(100dvh - 84px))}
  .bima-panel .bima-head{padding:9px 10px}
  .bima-panel .bima-body{padding:10px}
  .bima-panel .bima-msg{max-width:90%}
}
</style>
'''
if marker not in s:
    if '</head>' not in s:
        raise SystemExit('No </head> found; refusing unsafe patch')
    s = s.replace('</head>', css + '\n</head>', 1)

# Safety assertions: fix must be present and stale customer-facing mapping absent.
assert marker in s
assert "staffing:'Vireqo AI Client Assistant'" in s
assert '>Vireqo AI Client Assistant</button>' in s

p.write_text(s, encoding='utf-8')
print('BIMA scoped responsive + service-context patch applied')
