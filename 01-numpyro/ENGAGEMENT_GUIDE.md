# numpyro — Day-by-Day Engagement Guide

## Communication Channels

| Channel | URL | When to Use |
|---------|-----|-------------|
| GitHub Discussions | https://github.com/pyro-ppl/numpyro/discussions | Primary — tech questions, GSoC discussion |
| Pyro Forum | https://forum.pyro.ai | Community discussions, modeling questions |
| GitHub Issues | https://github.com/pyro-ppl/numpyro/issues | Bug reports, feature requests |

---

## Day 1 — March 19: Introduction Post

**Where:** GitHub Discussions (new discussion, category: "General")

**Subject:** "Interested in GSoC 2026 — existing contributor looking to deepen involvement"

**Message template:**
```
Hi NumPyro community,

I'm Zakir Jiwani (GitHub: JiwaniZakir), a Python/ML developer interested in contributing to NumPyro
for GSoC 2026 under the NumFOCUS umbrella.

I've been working with probabilistic programming and have an existing PR in this repo. I'm now looking
to make more substantial contributions in the lead-up to GSoC.

A few questions:
1. Are there specific GSoC 2026 project ideas that the team is prioritizing for numpyro?
2. For issue #1117 (Automatic Structured Variational Inference) — is this still considered a GSoC-scale
   project, or has the scope changed?
3. Is there a preferred communication channel for GSoC applicants?

I've already submitted PR #[your-existing-PR] and am currently working on:
- [#189] User-contributed examples (tutorial notebook in progress)
- [#1872] CatTransform implementation

Happy to discuss any of these or take direction on where contributions are most needed.

Thanks,
Zakir
```

---

## Day 2 — March 20: Pyro Forum Engagement

**Where:** https://forum.pyro.ai

**Action:** Find an active thread about NUTS/MCMC/diagnostics and leave a substantive technical reply.
Don't just say "I have this problem too" — add a code snippet, diagnosis, or suggestion.

**Alternatively:** Post a question about a modeling pattern you're implementing in your tutorial notebook.
This demonstrates real usage rather than just contribution hunting.

---

## Day 3 — March 21: Proposal Feedback Request

**Where:** GitHub Discussions (new discussion)

**Subject:** "GSoC 2026 proposal draft — feedback requested on ASVGD project"

**Message template:**
```
Hi,

Following up on my previous intro post — I've been working on a GSoC 2026 proposal for NumPyro
focused on [chosen idea, e.g., Automatic Structured Variational Inference or improved diagnostics].

Here's a brief outline:

**Title:** [Proposal title]

**Problem:** [1-2 sentences on the gap/limitation]

**Proposed deliverables:**
1. [Deliverable 1]
2. [Deliverable 2]
3. [Deliverable 3]

**My background:** I've merged PRs in pyro-ppl/numpyro (PR #X) and huggingface/transformers.
I have hands-on experience with JAX, Bayesian inference, and probabilistic programming.

I'd love feedback on:
- Is this scope appropriate for a 90/175-hour project?
- Are there existing approaches I should be aware of?
- Would any of the current mentors be interested in supervising this?

Full draft available to share.

Thanks,
Zakir
```

---

## Day 4 — March 22: Issue Comments

**Target:** Leave substantive comments on 2-3 open issues:
- [#1117](https://github.com/pyro-ppl/numpyro/issues/1117) — share a design sketch for ASVGD
- [#810](https://github.com/pyro-ppl/numpyro/issues/810) — note your PR progress
- Any other open issue where you've done analysis

**Template for issue comment:**
```
I've been looking into this issue and here's my analysis:

[Technical diagnosis]

I'm planning a PR that would:
1. [Step 1]
2. [Step 2]

Draft implementation sketch:
```python
[code]
```

Does this approach align with what the team has in mind? Happy to iterate before submitting.
```

---

## Day 5 — March 23: Final Thank-You + Summary

**Where:** GitHub Discussions (reply to your original intro post)

**Message:**
```
Update: In preparation for GSoC 2026, I've submitted the following PRs over the past week:

- PR #X: [Title] — [status: open/merged/under review]
- PR #Y: [Title] — [status]
- PR #Z: [Title] — [status]

My GSoC proposal (submitted today) is focused on [title].

Thank you to @[mentor] and @[reviewer] for the code review feedback — it's been extremely helpful.
Looking forward to a productive summer!
```

---

## Do's and Don'ts

**Do:**
- Ask technical questions that show you've read the code
- Reference specific line numbers, function names, test files
- Respond to PR feedback within 24 hours
- Express genuine interest in probabilistic programming, not just GSoC

**Don't:**
- Ask "what can I work on?" without doing research first
- Submit multiple trivial PRs (typo fixes only)
- Ghost reviewers after initial PR submission
- Submit the same issue as a PR without commenting first
