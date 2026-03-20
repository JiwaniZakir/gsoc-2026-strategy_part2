# GSoC 2026 Proposal — Learning Equality / Kolibri

**Applicant:** Zakir Jiwani | GitHub: JiwaniZakir | jiwzakir@gmail.com
**Organization:** Learning Equality (Kolibri)
**Project Title:** Comprehensive Frontend Testing Modernization and Accessibility Improvements
**Duration:** 350 hours (large project)
**Mentors:** TBD — targeting rtibbles, benjaoming

---

## Synopsis

Kolibri's Vue.js frontend has over 100 component test files written with `@vue/test-utils` in a style that tests implementation details rather than user behavior. This makes tests brittle, harder to maintain, and insufficient for catching accessibility regressions. This project systematically migrates the Device plugin (and adjacent plugins) to Vue Testing Library, adds axe-core accessibility integration, fixes targeted WCAG 2.1 violations, and establishes documented patterns for future contributors.

---

## Background and Motivation

### The Testing Problem

Kolibri's existing Vue tests use `shallowMount` and wrapper-based assertions extensively. This pattern:
- Breaks when components are refactored (tests coupled to internal structure)
- Does not catch accessibility issues (tests don't simulate real user interaction)
- Makes it harder for new contributors to write correct tests

Vue Testing Library (VTL) solves this by testing from the user's perspective — finding elements by role, label, and text rather than CSS selectors.

### The Accessibility Problem

Kolibri serves students in developing countries using diverse devices including assistive technologies. Issues like #14347 (QTI Viewer accessibility) represent a category of bugs that only appear when screen reader users or keyboard-only users interact with the app. No automated accessibility testing currently runs in CI.

---

## Deliverables

### Deliverable 1: Vue Testing Library Migration — Device Plugin (Weeks 1–6)
- Migrate all ~30 test files in `kolibri/plugins/device/assets/test/` from `@vue/test-utils` to `@testing-library/vue`
- Issues: #14262, #14263, #14264, #14265, and remaining device plugin tests
- Each migration PR is small and reviewable (1–3 files per PR)
- Add `@testing-library/user-event` for interaction testing where applicable

**Migration pattern:**
```javascript
// Before
import { shallowMount } from '@vue/test-utils'
const wrapper = shallowMount(Component, { store })
expect(wrapper.find('[data-test="submit"]').text()).toBe('Submit')

// After
import { render, screen } from '@testing-library/vue'
import userEvent from '@testing-library/user-event'
render(Component, { global: { plugins: [store] } })
expect(screen.getByRole('button', { name: /submit/i })).toBeInTheDocument()
await userEvent.click(screen.getByRole('button', { name: /submit/i }))
```

### Deliverable 2: Accessibility Test Integration (Weeks 7–9)
- Add `jest-axe` to the test suite for automated WCAG 2.1 checking
- Add `toHaveNoViolations()` assertion to all newly migrated component tests
- Create a CI step that fails on new accessibility violations
- Fix all axe violations found during migration

```javascript
import { axe, toHaveNoViolations } from 'jest-axe'
expect.extend(toHaveNoViolations)

it('should have no accessibility violations', async () => {
  const { container } = render(DeviceSettingsPage)
  const results = await axe(container)
  expect(results).toHaveNoViolations()
})
```

### Deliverable 3: Targeted WCAG 2.1 Fixes (Weeks 10–12)
- Fix issue #14347: QTI Viewer accessibility (ChoiceInteraction, SimpleChoice, TextEntryInteraction)
- Add missing ARIA labels to Device plugin form controls
- Fix keyboard navigation in modal dialogs
- Ensure all interactive elements are reachable via Tab key

### Deliverable 4: Testing Guidelines Documentation (Weeks 13–14)
- Document testing patterns in `CONTRIBUTING.md` and/or dedicated `docs/testing.md`
- Include: how to use VTL, how to write accessible components, how to run axe checks
- Create a test file template for new contributors

---

## Timeline

| Week | Milestone |
|------|-----------|
| 1–2 | Community bonding: understand codebase structure, set up dev env, start Device plugin audit |
| 3–4 | Migrate first 10 test files (Device auth, settings, transfer modal) |
| 5–6 | Migrate remaining ~20 Device plugin test files |
| 7–8 | Add jest-axe integration, fix violations found during migration |
| 9–10 | Fix #14347 and other targeted WCAG issues |
| 11–12 | Accessibility improvements — keyboard navigation, ARIA improvements |
| 13 | Extend migration to one adjacent plugin (Learn or Facility) |
| 14 | Documentation, cleanup, final PR |

---

## Why This Scope is Right

- 350 hours = ~25 weeks × 14 hrs/week
- Device plugin alone: ~30 files × 3 hrs each = 90 hrs (migration)
- Accessibility integration: ~40 hrs
- WCAG fixes: ~60 hrs
- Documentation + PR review cycles: ~40 hrs
- Buffer for review cycles and adjacent plugin: ~120 hrs

This is a well-scoped GSoC project with clear, measurable deliverables and no risk of scope creep.

---

## About Me

I'm a Python/Django and Vue.js developer with hands-on experience in both layers of the stack.

**Relevant experience:**
- Merged PR in huggingface/transformers — large Python codebase navigation
- Merged PRs in prowler-cloud/prowler — production Python/Django patterns
- Vue.js and Django experience in personal projects (evictionchatbot — React/Vite, Partnerships_OS — Turborepo/pnpm)
- Full-stack development comfort: I can work on the Django REST API and the Vue.js frontend in the same PR if needed

**Why Kolibri:**
The offline-first education problem is compelling. Students in low-resource environments shouldn't have a degraded experience just because of where they live. Improving test coverage and accessibility directly affects the quality of education tools that reach these students.

---

## References

- [Vue Testing Library](https://testing-library.com/docs/vue-testing-library/intro/)
- [jest-axe](https://github.com/nickcolley/jest-axe)
- [WCAG 2.1](https://www.w3.org/TR/WCAG21/)
- [Kolibri issue #14265](https://github.com/learningequality/kolibri/issues/14265)
- [Kolibri issue #14347](https://github.com/learningequality/kolibri/issues/14347)
