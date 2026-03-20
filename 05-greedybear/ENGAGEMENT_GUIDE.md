# GreedyBear — Day-by-Day Engagement Guide

## Communication Channels

| Channel | URL | When to Use |
|---------|-----|-------------|
| Honeynet Slack | honeynet.slack.com | PRIMARY — mentors and team are here |
| GitHub Issues | https://github.com/intelowlproject/GreedyBear/issues | Contributions |
| Honeynet GSoC | https://www.honeynet.org/gsoc/ | Official GSoC process |

**To join Honeynet Slack:** Email info@honeynet.org or check the website for invite link.

---

## Day 1 — March 19: Join Slack + Introduction

**Where:** Honeynet Slack — #greedybear or #general channel

**Message template:**
```
Hi Honeynet team,

I'm Zakir Jiwani (GitHub: JiwaniZakir), a Python/Django developer applying for GSoC 2026
with GreedyBear under the Honeynet Project umbrella.

Background: I have merged PRs in huggingface/transformers and prowler-cloud/prowler
(cloud security), and I'm comfortable with Python, Django, REST APIs, and ML (scikit-learn).

I submitted my first GreedyBear PR today (#[PR number] — fixing the cronjob exception
swallowing issue #1085).

A few questions:
1. Are there specific GSoC 2026 project ideas for GreedyBear that the team is excited about?
2. Is there a preferred communication channel for GSoC applicants?
3. Should GSoC contributions focus on GreedyBear specifically, or is IntelOwl also in scope?

Looking forward to contributing more this week.

Zakir
```

---

## Day 2 — March 20: Issue Comment + Technical Depth

**On each issue you're targeting, comment before or when submitting PR:**

For #1087 (ML training data):
```
I've traced the bug — when training_data elements come from the Cowrie honeypot collector,
some records are missing the `ip_reputation` field if the enrichment step timed out.
The fix is to add `.get()` with a sentinel value + skip logic rather than hard-crashing.

PR coming today. Quick question: should missing-field records be skipped entirely,
or filled with a default value (e.g., 0 for numeric features)? Happy to implement
either approach depending on what the ML team prefers.
```

This shows genuine analysis (you traced the root cause) and asks a meaningful technical question.

---

## Day 3 — March 21: Proposal Discussion

**Where:** Honeynet Slack (#gsoc)

**Message:**
```
Hi @mattebit (or whoever is the GSoC coordinator),

I've submitted 3 PRs to GreedyBear this week targeting issues #1085, #1087, and #1093.
I'm drafting a GSoC 2026 proposal and wanted to get early feedback on direction.

My current thinking:

**Title:** "GreedyBear ML Enhancement: Multi-Model Threat Classification and Feed Quality Improvements"

**Deliverables:**
1. Multiple ML model support (XGBoost, Gradient Boosting) with A/B evaluation framework
2. Improved training data validation and error handling (building on #1087)
3. Feed generation refactor (building on #1092) + pagination improvements
4. IntelOwl integration enhancements (if in scope for GSoC)
5. Test coverage improvements

Does this align with what the team has in mind? Any feedback on which of these
is highest priority?

Thanks,
Zakir
```

---

## Day 4 — March 22: Review Other PRs

**Action:** Find 1–2 other open PRs in GreedyBear (not yours) and leave a substantive review comment.

This is visible to maintainers and shows you understand the codebase broadly, not just the specific issues you're working on.

Example review comment:
```
Nice fix. One thought: the ruff check will fail on line 47 due to the unused import `time`.
Also, the test doesn't cover the case where the API returns an empty list — might be
worth adding:

```python
def test_feeds_empty_response():
    # ...
```

Not blocking the PR, just flagging for completeness.
```

---

## Day 5 — March 23: Final Summary + Submit

**Where:** Honeynet Slack + GitHub (comment on your own PRs)

```
Week summary:

PRs submitted to GreedyBear this week:
- #X: Fix cronjob exception swallowing (#1085) — [status]
- #Y: Validate training_data before ML training (#1087) — [status]
- #Z: Fix feeds sorting regression (#1093) — [status]
- #W: Simplify feed generation internals (#1092) — [status]
- #V: Add XGBoost/GradientBoosting alternatives to ML pipeline — [status]

GSoC proposal submitted today. Thank you to @mattebit and the team for
the code review feedback — it made the PRs significantly better.
```

---

## GreedyBear-Specific Do's and Don'ts

**Do:**
- Run `ruff check .` before EVERY PR — this is enforced in CI and PRs without clean ruff are rejected without review
- Keep PRs small (1 issue = 1 PR) — the team prefers many small PRs over one large one
- Comment on issues before working on them if the issue doesn't have an assignee — prevents duplicate work
- Mention security implications when relevant (this is a security tool — security reasoning matters)

**Don't:**
- Submit untested code — GreedyBear requires test coverage for new functionality
- Submit Django model changes without migrations
- Combine multiple unrelated changes in a single PR
- Ignore the 1-week review rule — if no review in 7 days, ping @mattebit on Slack politely
