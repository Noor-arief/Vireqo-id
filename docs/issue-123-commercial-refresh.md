# Issue #123 — Vireqo Commercial Refresh

Working branch: `issue-123-vireqo-commercial-refresh`

## Safety rules
- Preserve BIMA runtime/API/session/WhatsApp behavior.
- Preserve existing responsive/layout behavior unless the checklist explicitly requires a visual change.
- Customer-facing copy must stay synchronized in Indonesian and English.
- Client isolation remains hard: no cross-client knowledge, session, credential, or data sharing.
- Use the locked BIMA avatar asset already present in the product; do not generate/substitute another BIMA face.
- Never reconstruct or replace the large `index.html` from truncated connector output. Large-file changes must come from the complete source and pass a narrow diff check.
- Do not repeat completed or failed procedures; move to a different recovery path.
- Do not mix Vireqo/BIMA work with other projects.
- Update this roadmap immediately when a step is completed.
- APPROVED HERO IS NOW LOCKED: do not alter Hero copy, proportions, artwork, CTA layout, or desktop composition unless the user explicitly requests a new Hero change.

## Locked commercial baseline
Four product cards only:
1. Website & Landing Page — public starter pricing mulai Rp799.000; requirements outside the standard starter scope use a Custom Quote.
2. CS Dashboard — base Rp1.500.000; external database/hosting/services such as Supabase are not included and are quoted separately when needed.
3. Vireqo AI Client Assistant — subscription-based; plan/pricing follows the AI Assistant subscription baseline.
4. Website + AI Client Assistant bundle — website build fee plus the selected AI Assistant subscription; domain is excluded.

Domain is not included. Customer may purchase it independently; if Vireqo assists, domain selection and cost follow the chosen provider/TLD pricing.

Website scope follows the onboarding form. Two revision rounds are included; additional revisions are charged based on complexity. Seven days of post-go-live support covers defects/support only; new features or design changes are additional work.

## Implementation checklist

### Phase 0 — Safety / commercial baseline
- [x] Create isolated working branch from current main.
- [x] Lock four-product commercial baseline and pricing rules in roadmap.
- [x] Lock safety rules: preserve BIMA runtime, responsive behavior, client isolation, bilingual copy, and approved BIMA avatar.
- [x] Lock rule to update roadmap immediately after completed work.

### Phase 1 — Hero / positioning foundation
- [x] Hero positioning copy baseline added in ID + EN.
- [x] Refresh hero floating-card copy for Website & Landing Page + AI Client Assistant / Ask BIMA.
- [x] Replace legacy synthetic Hero illustration with the approved Vireqo artwork containing Website/Landing Page, Ask BIMA/AI Client Assistant, and CS Dashboard.
- [x] Restore approved desktop Hero proportions: wide readable copy column + balanced artwork column; remove the narrow one-word-per-line regression.
- [x] Preserve approved mobile breakpoint rules in the Step 3 Hero patch.
- [x] Preserve runtime anchors for `hamburgerBtn`, `mobileMenu`, `bimaFab`, and `data-i18n` during the Step 3 repair.
- [x] Limit Hero production repair to `index.html` / approved Hero asset scope; BIMA runtime and other projects untouched.
- [x] Restore exact approved Hero lock from saved approved checkpoint after regression.
- [x] Production Hero desktop visual accepted by user on 27 Sep 2026; this composition is now locked and must not be changed without explicit instruction.
- [x] Production Hero mobile visual acceptance — automated Chromium acceptance at 390×844 passed on 27 Sep 2026 (heading + approved Hero artwork visible and correctly bounded).
- [x] Verify ID/EN switch interactively in production browser — desktop and mobile Chromium click tests passed on 27 Sep 2026.
- [x] Verify mobile hamburger interactively in production browser — button visibility, `aria-expanded=true`, and menu visibility passed on 27 Sep 2026.
- [x] Verify Ask BIMA interactively after Hero deployment — desktop and mobile FAB/panel-open tests passed on 27 Sep 2026.
- [x] PHASE 1 COMPLETE — production acceptance suite passed against `https://vireqo.id` on 27 Sep 2026.

### Phase 2 — Four-product commercial presentation
- [ ] Replace legacy six-service presentation with exactly four product cards.
- [ ] Add final baseline pricing and clear inclusions/exclusions to product cards.
- [ ] Add Website + AI Assistant bundle pricing logic (website fee + selected AI subscription).
- [ ] Add domain exclusion/optional assistance disclosure.
- [ ] Add two-revision policy.
- [ ] Add seven-day post-go-live support scope and additional-work boundary.
- [ ] Add CS Dashboard external database/hosting cost disclosure.

### Phase 3 — FAQ / legal alignment
- [ ] Add bilingual FAQ (ID + EN).
- [ ] Align cancellation/refund wording with existing legal pages; do not invent conflicting policy.
- [ ] Align Privacy/Terms with existing legal pages and commercial scope.

### Phase 4 — BIMA commercial knowledge
- [ ] Update BIMA product knowledge only after commercial catalog is finalized.
- [ ] Remove legacy BIMA knowledge/routes for Training CS, CS staffing/old consulting, and SEO where they conflict with the four-product catalog.

### Phase 5 — SEO / routing / regression
- [ ] Update SEO/meta/schema/customer-facing positioning in ID + EN.
- [ ] Align CTA/service routing with the four-product catalog.
- [ ] Regression: existing legal navigation works.
- [ ] Final commercial-refresh diff review before final merge.

## Hero production checkpoint — 27 Sep 2026
- Current approved production restore commit: `523aa4b4b6eb2e5db5b1a4ac8c9349ea1ffda241`.
- GitHub Pages build/deploy for this commit: successful.
- Desktop Hero visually accepted by user after production refresh.
- Approved composition is locked; do not touch it in subsequent phases.
- Phase 1 production acceptance suite passed after runner fix commit `1643a496f7c362b9e17d321914ab798bcade1c62`.
- Phase 1 is complete. Next work begins at Phase 2 only.

## Current source audit findings
Legacy positioning still exists below the Hero, including six-service wording, Customer Service Training, SEO consulting, old CS/team wording, old How It Works copy, footer positioning, and BIMA service mappings. These belong to later roadmap phases and must not be mixed into the locked Hero.
