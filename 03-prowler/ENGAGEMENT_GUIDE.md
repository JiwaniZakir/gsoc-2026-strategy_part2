# prowler — Day-by-Day Engagement Guide

## Communication Channels

| Channel | URL | When to Use |
|---------|-----|-------------|
| GitHub Issues | https://github.com/prowler-cloud/prowler/issues | Contribution tracking |
| Slack | prowler-cloud.slack.com | Community, mentors, GSoC |
| GitHub Discussions | https://github.com/prowler-cloud/prowler/discussions | GSoC proposals |

---

## Day 1 — March 19: Introduction Post

**Where:** Prowler Slack (#general or #gsoc channel) + GitHub Discussions

**Critical context:** Zakir has MERGED PRs in prowler. Lead with this — it's the strongest possible opening.

**Message template (Slack):**
```
Hi prowler team,

I'm Zakir Jiwani (GitHub: JiwaniZakir) — I've already had PRs merged in prowler
and I'm interested in applying for GSoC 2026 to do more substantial work here.

I just submitted a new PR today ([GitHub PR link]) for issue #8660 (GitHub check:
dismiss stale reviews).

For GSoC, I'm considering focusing on:
- New checks for underserved services (GitHub, GCP DNS, Azure CAE)
- Compliance framework extensions
- API/dashboard improvements

Are there specific areas the team is prioritizing for GSoC 2026? I'd love to align
my proposal with what's actually useful rather than what's just easy.

Happy to jump on a call or discuss async.

Zakir
```

**Why this works:** You're not asking "what can I work on" from zero. You're a returning contributor providing context. This changes the entire dynamic.

---

## Day 2 — March 20: Issue Comment + Claim

**On each issue you're targeting (#7287, #10148):**
```
I'm working on a PR for this. Implementation approach:

1. [Specific service client changes needed]
2. [Check logic - what condition triggers PASS/FAIL]
3. [Compliance mapping - which CIS/NIST controls this maps to]

Expected to submit the PR [today/tomorrow]. Any guidance on edge cases appreciated.
```

**Why claim issues before submitting:** Prevents parallel PRs on the same issue and shows you're organized.

---

## Day 3 — March 21: GSoC Proposal Discussion

**Where:** GitHub Discussions (new post)

**Subject:** "GSoC 2026 Proposal — Expanding Cloud Provider Coverage in Prowler"

```
Hi,

I'm Zakir (existing prowler contributor — JiwaniZakir). I've submitted 3 PRs this week:
- [PR link 1]: GitHub check for stale review dismissal
- [PR link 2]: GCP Cloud DNS logging check
- [PR link 3]: Azure CAE enforcement check

For GSoC 2026, I'm proposing to systematically expand coverage in underserved areas:

**Title:** "Expanding Multi-Cloud Security Coverage: GitHub, GCP, and Azure Check Expansion"

**Deliverables:**
1. 15–20 new GitHub provider checks (branch protection, org security, secret scanning)
2. 10+ new GCP checks (DNS, VPC, IAM, logging)
3. 8+ new Azure checks (Entra ID, Conditional Access, Defender)
4. Compliance mapping for all new checks to CIS and NIST frameworks
5. Integration tests and documentation

This is based on the open issue backlog (#8660, #7287, #10148, etc.) and the pattern
that new provider checks are exactly what the community requests most.

Would any of the core team be interested in mentoring this? I'm happy to adjust scope
and direction based on your feedback.

Zakir
```

---

## Day 4 — March 22: Technical Depth Signal

**Action:** On one of your open PRs, add a follow-up comment showing you thought beyond just the immediate fix:

```
After implementing this check, I noticed a few adjacent issues worth addressing:

1. The [service]_client.py doesn't currently cache API responses — for accounts with
   many [resources], this could cause rate limiting. Worth a separate PR?
2. The compliance mapping for this check maps to CIS [version], but I see the codebase
   uses CIS [other version] elsewhere — should this be standardized?

Not blocking this PR — just flagging for follow-up.
```

This kind of comment shows you're thinking about the codebase holistically, not just closing tickets.

---

## Day 5 — March 23: Final Summary + Submit

**Where:** Slack (reply to your Day 1 message)

```
Week summary for @team:

PRs submitted:
- PR #X: [Check name] — [status]
- PR #Y: [Check name] — [status]
- PR #Z: [Check name] — [status]
- PR #W: Redis SSL env var — [status]

GSoC proposal submitted today. Really enjoyed contributing to prowler this week —
the codebase is well-structured and the security domain is exactly where I want to
be building expertise.

Thanks for the code reviews, especially @[reviewer] for the detailed feedback on [specific thing].
```

---

## Do's and Don'ts

**Do:**
- Reference your existing merged PRs in every intro — it's your biggest differentiator
- Use the exact same code style as existing checks (ruff-compliant, same class structure)
- Map each check to compliance frameworks (CIS, NIST, SOC 2) in your PR body
- Run `ruff check` and `pytest` before every PR

**Don't:**
- Submit a check without tests — maintainers will reject it
- Forget to add the check to the provider's check list (whatever registration mechanism prowler uses)
- Submit multiple checks in a single PR — each check should be a standalone PR
- Change code style or add abstractions not requested — prowler's style is intentional
