# Vireqo Website — Resilience & Security Roadmap
Date: 23 October 2026. Canonical master: https://github.com/Noor-arief/BIMA/issues/1

## P0 — Railway outage / PHP2Shell follow-up (OPEN)
- [x] GitHub static website source inventoried: no tracked .php files. Site pages can remain on GitHub Pages independently of Railway, but AI Client Assistant, BIMA Sales Engine and any dynamic integrations are separate dependencies and may fail.
- [ ] Verify public pages, forms, consultation CTAs, links, and graceful degraded messaging when BIMA, Sales Engine or other Railway APIs are offline. Do not claim live backend merely because landing pages render.
- [ ] Review DNS/custom domains, hosting provider/SSL and API dependencies; export configuration and retain reproducible static rollback from GitHub; test recovery to an alternate static host only if needed.
- [ ] Track independent backend snapshots, email/lead state and brochures under service owner; confirm external, encrypted backup and restore, not just source code.
- [ ] Audit all deployment images/other hosting for PHP2Shell runtime exposure (CVE-2026-109618/109619, 21 Oct patch), patch where present; no causal link established with Railway incident. Reference: https://www.php.net/archive/2026.php
- [ ] Verify credential inventory and rotation after Railway security notice, inspect logs when accessible; avoid secret or customer record commits.
- [ ] Confirm no duplicate lead outreach on recovery; require owner approval for outgoing sales messages.

**Exit:** static website and critical CTAs verified on degraded API conditions; backend owners independently meet BIMA Master Roadmap recovery gates. No production design changes authorized by this roadmap document.
