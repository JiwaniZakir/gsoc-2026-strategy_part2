# kolibri — Aggressive 5-Day Contribution Plan (Mar 19–23)

**Target: 8–10 PRs in 5 days | Strategy: Vue Testing Library migration + accessibility fixes**

## Day 1 — March 19: Setup + First PR

### Environment Setup (07:00–10:00)
```bash
git clone https://github.com/learningequality/kolibri
cd kolibri

# Python backend
pip install -e ".[dev]"
python -m kolibri manage migrate
python -m kolibri start

# Frontend
cd kolibri/core/assets
yarn install
yarn run dev

# Run backend tests
pytest kolibri/ -x -q --tb=short

# Run frontend tests
yarn run test
```

### PR #1 (10:00–14:00): Vue Testing Library Migration — Issue #14265
**Target:** Migrate Device auth and task panel tests to Vue Testing Library

**What to do:**
1. Read existing tests in `kolibri/plugins/device/assets/test/`
2. Identify tests using old `@vue/test-utils` wrapper approach
3. Rewrite using `@testing-library/vue`:
```javascript
// Before (old style):
import { shallowMount } from '@vue/test-utils'
const wrapper = shallowMount(DeviceAuthPanel)
expect(wrapper.find('.auth-button').exists()).toBe(true)

// After (Vue Testing Library):
import { render, screen } from '@testing-library/vue'
render(DeviceAuthPanel)
expect(screen.getByRole('button', { name: /sign in/i })).toBeInTheDocument()
```
4. Run `yarn run test` to verify pass
5. Submit PR referencing issue #14265

```bash
git checkout -b test/migrate-device-auth-vtl
# after changes:
gh pr create --title "test: migrate Device auth panel tests to Vue Testing Library" \
  --body "Closes #14265 — Rewrites auth and task panel tests using @testing-library/vue, improving test reliability and accessibility coverage."
```

### Community Intro (14:00–16:00)
- Post intro on GitHub Discussions
- Join community forums: https://community.learningequality.org
- Mention your interest in GSoC 2026

---

## Day 2 — March 20: Continue Test Migration

### PR #2: Issue #14264 — Device Settings Tests
Same approach as Day 1. Find `DeviceSettings` component tests and migrate.

Key difference: settings forms have form controls — use Testing Library's `getByLabelText`, `getByRole`:
```javascript
import { render, screen, fireEvent } from '@testing-library/vue'
render(DeviceSettingsForm)
const input = screen.getByLabelText(/facility name/i)
fireEvent.change(input, { target: { value: 'New Facility' } })
expect(screen.getByDisplayValue('New Facility')).toBeInTheDocument()
```

### PR #3: Issue #14263 — Transfer Modal Tests
Migrate `DeviceTransferModal` tests. Transfer modals typically have multiple steps — test each state.

---

## Day 3 — March 21: Accessibility Fix + Deeper Contribution

### PR #4: Issue #14347 — QTI Viewer Accessibility
**Target:** Fix accessibility and spec compliance in QTI Viewer (ChoiceInteraction, SimpleChoice, TextEntryInteraction)

**Approach:**
1. Find QTI viewer component in `kolibri/plugins/html5_app_renderer/` or similar
2. Identify missing ARIA attributes (`role`, `aria-label`, `aria-required`, etc.)
3. Add keyboard navigation support if missing
4. Run with axe-core or similar to verify improvement
5. Write tests for accessibility behavior

**PR body should reference:**
- Specific WCAG 2.1 criteria being addressed
- Which screen reader behavior is being fixed

### Also Day 3: Post Proposal Outline
- Comment on the Testing Library migration meta-issue (if it exists) noting your systematic progress
- Post GSoC proposal outline in GitHub Discussions

---

## Day 4 — March 22: Issue #14262 + Backend Contribution

### PR #5: Issue #14262 — Content Tree Tests
Migrate `DeviceContentTree` or related component tests.

### PR #6 (stretch): Backend Django fix
Browse `kolibri/core/` for any Django issue:
- Missing API endpoint test coverage
- Django migration inconsistency
- REST framework serializer improvement

Backend PRs demonstrate depth beyond frontend-only contributions.

---

## Day 5 — March 23: Polish + Final PRs

### PR #7: Remaining test migration or new accessibility issue
Continue the systematic Vue Testing Library migration. Each file is a separate PR — this is intentional per the issue structure.

### Final checklist:
- All PRs responding to review feedback within 24h
- Proposal draft complete
- Community forum engagement logged

---

## PR Summary Table

| Day | PR | Issue | Type |
|-----|-----|-------|------|
| Mar 19 | #1 | #14265 | Vue Testing Library migration |
| Mar 20 | #2 | #14264 | Vue Testing Library migration |
| Mar 20 | #3 | #14263 | Vue Testing Library migration |
| Mar 21 | #4 | #14347 | Accessibility fix |
| Mar 22 | #5 | #14262 | Vue Testing Library migration |
| Mar 22 | #6 | TBD | Backend Django fix |
| Mar 23 | #7 | TBD | Migration or accessibility |

**Strategy:** The Vue Testing Library migration issues are intentionally split into small, reviewable chunks. Submit them in rapid succession — each one takes 1–2 hours and is a clean, testable change. This approach maximizes PR count while staying within what the team asked for.

---

## Important Notes

- Read `CONTRIBUTING.md` before first PR
- Check if there's a CLA to sign (Learning Equality sometimes requires this)
- Kolibri uses Crowdin for i18n — don't hardcode strings; use `$tr()` for all user-visible text
- Frontend code style: ESLint config is enforced in CI, run `yarn run lint` before submitting
