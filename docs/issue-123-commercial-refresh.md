# Issue #123 — Vireqo Commercial Refresh

Working branch: `issue-123-step3-local-checkpoint`

## Safety rules
- Do not write to `main` until the full batch is reviewed and approved.
- Preserve BIMA runtime/API/session/WhatsApp behavior.
- Preserve existing responsive/layout behavior unless the checklist explicitly requires a visual change.
- Customer-facing copy must stay synchronized in Indonesian and English.
- Client isolation remains hard: no cross-client knowledge, session, credential, or data sharing.
- Use the locked BIMA avatar asset already present in the product; do not generate/substitute another BIMA face.
- Never reconstruct or replace the large `index.html` from truncated connector output. Large-file changes must come from the complete source and pass a narrow diff check.
- Do not repeat completed or already-blocked procedures. Use the local checkpoint bridge only when a connector limitation blocks a narrow change.
- Do not move to the next step until the current step is visually and functionally verified.

## Locked commercial baseline
Four product cards only:
1. Website & Landing Page — base Rp1.500.000.
2. CS Dashboard — base Rp1.500.000; external database/hosting/services such as Supabase are not included and are quoted separately when needed.
3. Vireqo AI Client Assistant — subscription-based; plan/pricing follows the AI Assistant subscription baseline.
4. Website + AI Client Assistant bundle — website build fee plus the selected AI Assistant subscription; domain is excluded.

Domain is not included. Customer may purchase it independently; if Vireqo assists, domain selection and cost follow the chosen provider/TLD pricing.

Website scope follows the onboarding form. Two revision rounds are included; additional revisions are charged based on complexity. Seven days of post-go-live support covers defects/support only; new features or design changes are additional work.

## Implementation checklist
- [x] Create isolated working branch from current main.
- [x] Hero positioning copy baseline added in ID + EN on main before branch isolation.
- [ ] Remove accidental UTF-8 BOM introduced by the hero-copy PowerShell write.
- [x] Refresh hero floating-card copy while preserving the existing HTML/CSS animation structure.
- [x] Hero floating cards now represent Website & Landing Page + AI Client Assistant / Ask BIMA.
- [x] Approved hero artwork transplanted into the local Step 3 checkpoint (`7105436`) without touching production.
- [x] Approved Hero desktop composition restored in the local checkpoint: 47/53 copy/artwork ratio, badge hidden, approved artwork enlarged, CTA area retained.
- [ ] STEP 3 FINAL QA: remove the remaining bottom overflow/gap visible at the fold without changing the approved composition.
- [ ] STEP 3 FINAL QA: verify ID/EN switch after the approved hero transplant.
- [ ] STEP 3 FINAL QA: verify mobile/hamburger behavior after the approved hero transplant.
- [ ] STEP 3 FINAL QA: verify full page sections and BIMA runtime remain present/unchanged.
- [ ] STEP 3 COMPLETE — only check after all four final-QA items above pass.
- [ ] Replace legacy six-service presentation with exactly four product cards.
- [ ] Add final baseline pricing and clear inclusions/exclusions to product cards.
- [ ] Add Website + AI Assistant bundle pricing logic (website fee + selected AI subscription).
- [ ] Add domain exclusion/optional assistance disclosure.
- [ ] Add two-revision policy.
- [ ] Add seven-day post-go-live support scope and additional-work boundary.
- [ ] Add CS Dashboard external database/hosting cost disclosure.
- [ ] Add bilingual FAQ (ID + EN).
- [ ] Align cancellation/refund wording with existing legal pages; do not invent conflicting policy.
- [ ] Align Privacy/Terms with existing legal pages and commercial scope.
- [ ] Update BIMA product knowledge only after commercial catalog is finalized.
- [ ] Remove legacy BIMA knowledge/routes for Training CS, CS staffing/old consulting, and SEO where they conflict with the four-product catalog.
- [ ] Update SEO/meta/schema/customer-facing positioning in ID + EN.
- [ ] Align CTA/service routing with the four-product catalog.
- [ ] Verify desktop and mobile layout.
- [ ] Verify ID/EN switch across all changed sections.
- [ ] Regression: BIMA chat/runtime/session/WhatsApp unchanged.
- [ ] Regression: existing legal navigation works.
- [ ] Final diff review before merge.
- [ ] Explicit approval before merge to `main`.

## Step 3 local checkpoint — 27 Sep 2026
- Local checkpoint commit: `71054367ec33c1061e35ed27a07d9116d7e8bcca` (`checkpoint: step3 working local hero`).
- `index.html` adds only the approved Hero override and replaces the old synthetic Hero visual with `assets/vireqo-hero-approved.png`.
- The approved artwork binary is present in the checkpoint commit.
- Production/main remains untouched.
- Step 3 is NOT complete until the four final-QA items above pass.

## Current source audit findings
Legacy positioning still exists in the current source, including six-service wording, Customer Service Training, SEO consulting, old CS/team wording, old How It Works copy, footer positioning, and BIMA service mappings. These must be migrated deliberately rather than globally replaced.

No production merge is authorized by this document.
