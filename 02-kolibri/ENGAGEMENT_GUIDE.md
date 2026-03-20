# kolibri — Day-by-Day Engagement Guide

## Communication Channels

| Channel | URL | When to Use |
|---------|-----|-------------|
| GitHub Issues | https://github.com/learningequality/kolibri/issues | Contribution work |
| GitHub Discussions | https://github.com/learningequality/kolibri/discussions | GSoC, community |
| Community Forums | https://community.learningequality.org | Mission discussions |
| GSoC App | https://learningequality.org/gsoc | Official GSoC process |

---

## Day 1 — March 19: Introduction Post

**Where:** GitHub Discussions or Community Forums

**Subject:** "GSoC 2026 applicant — starting Vue Testing Library migration contributions"

**Message template:**
```
Hi Learning Equality team,

I'm Zakir Jiwani (GitHub: JiwaniZakir), a Python/Django and Vue.js developer applying for
GSoC 2026 with Kolibri.

I'm starting with the Vue Testing Library migration issues (#14262–#14265) since they're
well-scoped and clearly needed — but I'd love to understand which improvements the team
considers highest priority for a GSoC project.

My background: I've merged PRs in huggingface/transformers and prowler-cloud/prowler.
I have production Django and Vue.js experience, and I'm genuinely interested in the
ed-tech / offline education problem space.

A few questions:
1. Are there specific GSoC 2026 project ideas that Learning Equality is prioritizing?
2. For the Testing Library migration — is there a preferred order for the issues?
3. Is there a mentor I should reach out to directly about GSoC?

I'll have my first PR (#14265) submitted today.

Thanks,
Zakir
```

---

## Day 2 — March 20: Issue Comment Strategy

**On each issue you're working on (#14264, #14263):**
```
Working on this — will submit a PR today.

Quick question: for components that use `$store` (Vuex) internally — should the migration
use `createStore` from `@testing-library/vue` or mock the store at the module level?
I see both approaches in the codebase and want to be consistent with the preferred style.
```

This shows you've read the code deeply (not just copying a template) and gives the reviewer
context before they see the PR.

---

## Day 3 — March 21: GSoC Proposal Outline

**Where:** GitHub Discussions

**Subject:** "GSoC 2026 proposal — Systematic Vue Testing Library Migration + Accessibility Improvements"

```
Hi,

Following up on my intro post — I've submitted PRs for #14265, #14264, and #14263 this week
and am working through the migration systematically.

I'm drafting a GSoC proposal around a larger version of this work:

**Title:** "Comprehensive Frontend Testing Modernization and Accessibility Improvements in Kolibri"

**Scope:**
1. Complete Vue Testing Library migration for Device plugin (and potentially other plugins)
2. Add accessibility test coverage using axe-core integration in Jest
3. Fix specific WCAG 2.1 issues identified during testing (starting with #14347)
4. Document testing patterns for future contributors

**Why this makes sense as a GSoC project:**
The current migration covers individual components — a GSoC project could tackle this
systematically across all plugins, add CI enforcement, and establish testing patterns
that persist beyond the summer.

Is this a direction the team is interested in? Happy to adjust scope based on mentor feedback.

Draft proposal available to share.

Zakir
```

---

## Day 4 — March 22: Engage Technical Reviewers

**Action:** On your open PRs, respond to every review comment within 2 hours.
If no review yet: leave a comment on the PR saying "Ready for review — tests pass locally,
linting clean. Let me know if you'd like any changes."

**Also:** Find a PR from another contributor that's been open for 3+ days and leave a
substantive code review comment. This is visible to maintainers and shows community citizenship.

---

## Day 5 — March 23: Final Summary

**Where:** GitHub Discussions (reply to your intro post)

```
Weekly update — here's where I landed:

PRs submitted this week:
- PR #X: Migrate Device auth tests to VTL (status: [merged/under review])
- PR #Y: Migrate Device settings tests (status: [])
- PR #Z: QTI Viewer accessibility fixes (status: [])
- ...

GSoC proposal submitted today. Thank you to @[reviewer] for the code review feedback —
especially the note about Vuex store mocking, which saved me from submitting an
inconsistent pattern.

Looking forward to hearing about mentor assignments!
```

---

## Mission Alignment Tip

Learning Equality cares about *why* you're contributing. In your intro post and proposal,
mention something specific about the mission:

> "I'm particularly interested in Kolibri because offline-first education delivery is one of
> those problems where software can have direct real-world impact — students in areas with
> no internet access deserve the same quality of educational tools as anyone else."

This is not just flattery — it's a signal that you'll stick around and do the work, not
just collect a GSoC stipend and disappear.

---

## Do's and Don'ts

**Do:**
- Reference specific component names and file paths in questions
- Ask about testing conventions before submitting (saves revision cycles)
- Mention offline/low-resource use cases when discussing features

**Don't:**
- Submit PRs that break existing test coverage
- Hardcode user-visible strings (always use `$tr()`)
- Ignore CI failures — fix lint errors before submitting
