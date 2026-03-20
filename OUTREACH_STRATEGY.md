# Outreach Strategy — GSoC 2026

> Updated March 19, 2026 — New data-driven top 5.
> Detailed outreach per project with channels, message templates, and timing.

---

## Master Outreach Calendar

| Day | numpyro | kolibri | prowler | AOSSIE | GreedyBear |
|-----|---------|---------|---------|--------|-----------|
| Mar 19 | GitHub Discussions intro | GitHub Discussions intro | Slack intro | Gitter intro | Slack intro |
| Mar 20 | Issue comment on #1872 | Issue comment on #14264 | Claim #7287 | PictoPy issue comment | Claim #1087 |
| Mar 21 | Proposal outline post | Proposal outline post | Slack proposal | Proposal outline | Slack proposal |
| Mar 22 | Comment on open PRs | Review another contributor's PR | Technical depth comment | GitLab wiki review | Review open PR |
| Mar 23 | Final thank-you summary | Final thank-you summary | Final summary | Final summary | Final summary |

---

## 1. numpyro (pyro-ppl/numpyro) — Priority #1

**Score: 69.26 | Merge Rate: 92.9%**

### Channels
| Channel | URL | Priority |
|---------|-----|---------|
| GitHub Discussions | https://github.com/pyro-ppl/numpyro/discussions | PRIMARY |
| Pyro Forum | https://forum.pyro.ai | Secondary |

### Day 1 — Introduction Post (GitHub Discussions)

```
Subject: GSoC 2026 interest — existing contributor, looking to deepen involvement

Hi NumPyro community,

I'm Zakir Jiwani (GitHub: JiwaniZakir), a Python/ML developer with hands-on JAX
and probabilistic programming experience. I have an existing PR in this repo and
I'm applying for GSoC 2026 under the NumFOCUS umbrella.

This week I'm working on:
- [#189] User-contributed tutorial notebook (Bayesian linear regression with UQ)
- [#1872] CatTransform and constraints.cat implementation

For GSoC, I'm interested in the ASVGD project (issue #1117) or a combination of
diagnostic improvements + new transforms.

Questions:
1. Which GSoC ideas are the team prioritizing for 2026?
2. Is there a mentor I should connect with early?

Thanks, Zakir
```

### Key Issues to Reference
- #1872 — CatTransform (good first issue)
- #810 — Weighted statistics in summary (good first issue)
- #1117 — ASVGD (GSoC-scale)
- #189 — Tutorial notebooks (easy entry)

### Mentor Targets
- **Du Phan** (@fehiepsi on GitHub) — primary maintainer
- **Martin Jankowiak** — core contributor

---

## 2. kolibri (learningequality/kolibri) — Priority #2

**Score: 59.58 | Merge Rate: 82.6%**

### Channels
| Channel | URL | Priority |
|---------|-----|---------|
| GitHub Discussions | https://github.com/learningequality/kolibri/discussions | PRIMARY |
| Community Forums | https://community.learningequality.org | Secondary |

### Day 1 — Introduction Post

```
Subject: GSoC 2026 — starting Vue Testing Library migration contributions

Hi Learning Equality team,

I'm Zakir Jiwani (GitHub: JiwaniZakir), a Python/Django and Vue.js developer
applying for GSoC 2026 with Kolibri.

I'm starting with the Vue Testing Library migration issues (#14262–#14265) — they're
well-scoped and clearly needed. I have my first PR ready today (#14265).

For GSoC, I'm proposing a systematic testing modernization + accessibility project
that completes the VTL migration and adds axe-core integration for WCAG 2.1 compliance.

Questions:
1. Which GSoC project areas is Learning Equality prioritizing for 2026?
2. Is there a CLA to sign before contributing?
3. Who should I reach out to about GSoC mentorship?

Zakir
```

### Key Issues to Reference
- #14265 — Device auth tests → VTL migration
- #14264 — Device settings tests → VTL migration
- #14263 — Device transfer modal tests → VTL migration
- #14262 — Device content tree tests → VTL migration
- #14347 — QTI Viewer accessibility

### Mentor Targets
- **rtibbles** (Richard Tibbles) — core developer
- Check learningequality.org/gsoc for 2026 mentors

### Mission Alignment Note
Always include 1 sentence about the mission:
> "Offline-first education for developing countries is one of the clearest examples of software creating direct real-world impact — I want to contribute to tools that actually reach students who need them."

---

## 3. prowler (prowler-cloud/prowler) — Priority #3

**Score: 53.16 | Merge Rate: 62.5% | Zakir has MERGED PRs**

### Channels
| Channel | URL | Priority |
|---------|-----|---------|
| Slack | prowler-cloud.slack.com | PRIMARY |
| GitHub Discussions | https://github.com/prowler-cloud/prowler/discussions | Secondary |

### Day 1 — Slack Introduction

```
Hi prowler team,

I'm Zakir Jiwani (JiwaniZakir on GitHub) — I've already had PRs merged in prowler
and I'm interested in GSoC 2026.

I submitted a new check today: [PR link] — GitHub check for stale review dismissal
(issue #8660).

For GSoC, I'm proposing a systematic expansion of GitHub, GCP, and Azure check coverage
(30+ new checks with compliance mappings). There's a large backlog of good-first-issue
checks that nobody has tackled systematically.

Is there a GSoC coordinator or mentor I should reach out to directly?

Zakir
```

**WHY THIS WORKS:** "I've already had PRs merged" changes the entire conversation. Lead with it every time.

### Key Issues to Reference
- #8660 — GitHub: dismiss stale reviews
- #7287 — GCP: Cloud DNS logging
- #10148 — Azure: CAE enforcement
- #8832 — Redis SSL env var config

### Mentor Targets
- **pumasecurity** — core team
- **jfuentesmontes** — core team

---

## 4. AOSSIE (Agora + PictoPy) — Priority #4

**Score: 53.00 | Confirmed umbrella org**

### Channels
| Channel | URL | Priority |
|---------|-----|---------|
| Gitter | https://gitter.im/AOSSIE/ | PRIMARY |
| GitLab Wiki | https://gitlab.com/aossie/aossie/-/wikis/ | GSoC ideas |
| Email | gsoc@aossie.org | Formal inquiry |

### Day 1 — Gitter Introduction

```
Hi AOSSIE team,

I'm Zakir Jiwani (JiwaniZakir on GitHub), applying for GSoC 2026 with AOSSIE.

My background: Python/ML developer with experience in transformers, computer vision,
FastAPI, and Django. I've merged PRs in huggingface/transformers and prowler-cloud/prowler.

I'm particularly interested in PictoPy — the combination of local-first AI and computer
vision is compelling. I submitted a PR to Agora today (#[number] — Scoverage CI coverage)
and am planning Python contributions to PictoPy this week.

Questions:
1. Is PictoPy in scope for GSoC 2026?
2. Which AOSSIE sub-projects are prioritized for 2026?
3. Is there a wiki page with the 2026 ideas list?

Zakir
```

### Key Issues to Reference
- Agora #15 — Add Scoverage (easy, establishes presence)
- PictoPy — any open issues (check repo: https://github.com/AOSSIE-Org/PictoPy/issues)

### Mentor Targets
- **Thushan Ganegedara** — AOSSIE admin
- Check AOSSIE GitLab wiki for sub-project mentors

---

## 5. GreedyBear (honeynet/GreedyBear) — Priority #5

**Score: 49.72 | Confirmed (Honeynet umbrella)**

### Channels
| Channel | URL | Priority |
|---------|-----|---------|
| Slack | honeynet.slack.com | PRIMARY |
| GitHub Issues | https://github.com/intelowlproject/GreedyBear/issues | Contributions |
| Honeynet GSoC | https://www.honeynet.org/gsoc/ | Official process |

### Day 1 — Slack Introduction

```
Hi Honeynet team,

I'm Zakir Jiwani (JiwaniZakir on GitHub), a Python/Django developer applying for
GSoC 2026 with GreedyBear under the Honeynet Project.

Background: Merged PRs in prowler-cloud/prowler (cloud security) and
huggingface/transformers. Django REST, scikit-learn, and threat intelligence are all
areas I'm comfortable with.

First PR submitted today: [link] — fixing the cronjob exception swallowing issue (#1085).

For GSoC, I'm interested in the ML pipeline (multi-model support) + feed system
improvements.

Who should I contact about GSoC 2026 mentorship?

Zakir
```

### Key Issues to Reference
- #1085 — Cronjob exception propagation (easy, quick win)
- #1087 — ML training data validation
- #1093 — Feeds sorting regression
- #1092 — Feed generation refactor

### Mentor Targets
- **Matteo Lodi** (@mattebit) — primary maintainer, very responsive
- **Eshaan Bansal** — IntelOwl maintainer

### ⚠️ GreedyBear Rules
- **Ruff linting MANDATORY** — zero violations before submitting
- **1-week review rule** — ping if no review in 7 days
- **1 issue = 1 PR** — don't combine changes

---

## Universal Message Templates

### Issue Comment (Before Starting Work)
```
I'm planning to work on this issue. My approach:
1. [Technical diagnosis]
2. [Proposed fix]
3. [Test plan]

Expected PR by [date]. Let me know if there's a preferred implementation approach
or if this is already being worked on.
```

### PR Description Template
```
## Summary
[1-2 sentences on what the PR does and why]

## Changes
- [Specific change 1]
- [Specific change 2]

## Testing
- Ran [test command] — all tests pass
- Added [N] new tests for [specific behavior]

## Related Issues
Closes #[issue number]
```

### Mentor Outreach (After 2+ PRs)
```
Hi @[mentor],

I've submitted [N] PRs to [project] this week:
- [PR link 1]: [brief description] — [status]
- [PR link 2]: [brief description] — [status]

I'm applying for GSoC 2026 and drafting a proposal focused on [topic].
Would you be open to giving feedback on the proposal direction before I submit?

Happy to share a draft or discuss async.

Zakir
```

---

## What NOT to Do

❌ **Don't ask "What can I work on?"** — Do your research, propose specific issues.

❌ **Don't submit trivial PRs only** — Typo fixes alone signal you're padding, not contributing.

❌ **Don't ghost after submitting** — Respond to review feedback within 24 hours every time.

❌ **Don't submit before checking CI** — Every PR should have green CI before the first review request.

❌ **Don't combine unrelated changes** — One PR per issue. Reviewers hate multi-topic PRs.

❌ **Don't miss the Ruff check for GreedyBear** — Guaranteed rejection without review.

❌ **Don't skip the mission paragraph for Kolibri** — Learning Equality selects contributors who understand why this work matters.

---

**Last Updated:** March 19, 2026
