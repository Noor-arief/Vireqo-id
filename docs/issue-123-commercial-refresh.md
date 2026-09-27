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
- [x] Hero positioning copy baseline added in ID + EN.
- [x] Refresh hero floating-card copy for Website & Landing Page + AI Client Assistant / Ask BIMA.
- [x] Replace legacy synthetic Hero illustration with the approved Vireqo artwork containing Website/Landing Page, Ask BIMA/AI Client Assistant, and CS Dashboard.
- [x] Restore approved desktop Hero proportions: wide readable copy column + balanced artwork column; remove the narrow one-word-per-line regression.
- [x] Preserve approved mobile breakpoint rules in the Step 3 Hero patch.
- [x] Preserve runtime anchors for `hamburgerBtn`, `mobileMenu`, `bimaFab`, and `data-i18n` during the Step 3 repair.
- [x] Limit production Step 3 diff to `index.html` + `assets/vireqo-hero-approved.png`.
- [x] Merge Step 3 Hero to `main` via PR #11 (`ee7a440`).
- [x] GitHub Pages production build and deployment for `ee7a440` completed successfully.
- [ ] Browser visual acceptance of production Hero (desktop + mobile) after cache refresh.
- [ ] Verify ID/EN switch interactively in production browser.
- [ ] Verify mobile hamburger interactively in production browser.
- [ ] Verify Ask BIMA interactively after Hero deployment.
- [ ] STEP 3 COMPLETE — check only after the four interactive acceptance items above pass.
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
- [ ] Regression: existing legal navigation works.
- [ ] Final commercial-refresh diff review before final merge.

## Step 3 production checkpoint — 27 Sep 2026
- Approved Hero source checkpoint: `7105436`.
- Deterministic Hero proportion repair: `f8d4eed`.
- Production PR: #11.
- Production squash commit: `ee7a4405481b203a4f2c22a4d927252947891891`.
- Production Pages build/deploy: successful.
- Temporary repair workflow and patch artifact were removed before the production diff was merged.
- Remaining Step 3 work is interactive browser acceptance only; do not start Step 4 before it passes.

## Current source audit findings
Legacy positioning still exists below the Hero, including six-service wording, Customer Service Training, SEO consulting, old CS/team wording, old How It Works copy, footer positioning, and BIMA service mappings. These belong to later roadmap steps and were not mixed into the Step 3 Hero change.
