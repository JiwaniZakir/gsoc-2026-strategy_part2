# Open Climate Fix: Engagement Guide

**Priority:** #2
**Community:** OCF Slack (primary) + GitHub Discussions
**Key contacts:** peterdudfield (@peterdudfield)

---

## Channels

| Channel | URL | Notes |
|---------|-----|-------|
| **OCF Slack** | Check README for invite link | Primary channel — join `#gsoc` if exists, otherwise `#general` |
| **GitHub Discussions (quartz)** | https://github.com/openclimatefix/open-source-quartz-solar-forecast/discussions | For longer design discussions |
| **GitHub Issues (pvnet)** | https://github.com/openclimatefix/pvnet/issues | **Primary PR target** |
| **GitHub Issues (quartz)** | https://github.com/openclimatefix/open-source-quartz-solar-forecast/issues | Secondary PR target |

---

## Mentor Profiles

### peterdudfield (@peterdudfield)
- 150 commits, primary maintainer and decision-maker
- Merge velocity: SLOW (last merge March 16, before that Feb 23)
- Style: community-friendly, approachable
- Timezone: UK (OCF is UK-based) — post 08:00–16:00 UTC for best response time
- **Approach:** Be patient with review times. Multiple PRs mean multiple chances at visibility.

### aryanbhosale (@aryanbhosale)
- 47 commits, regular contributor
- Good for: implementation questions, pvnet-specific questions
- **Approach:** Technical discussion partner while waiting for peterdudfield reviews

---

## Day 1 — March 19: Join + First Intro

### Join OCF Slack

Find the invite link in the quartz-solar-forecast README. Join and look for `#gsoc-2026` or `#solar-forecasting`.

### Post Intro (After First pvnet PR)

```
Hi Open Climate Fix! I'm Zakir — ML/AI developer applying for GSoC 2026
on the error adjustment (TabPFN) project.

Background relevant here:
- Built spectra: RAG evaluation toolkit — confidence scoring for ML pipeline
  outputs, which is the core challenge for an error adjuster
- Built aegis: intelligence platform — tabular feature engineering for structured prediction
- Merged to huggingface/transformers — large ML Python codebase navigation

The TabPFN adjuster framing is elegant: instead of building a better base model,
learn the systematic residuals. This generalizes across sites and seasons without
retraining the base model.

I've set up both quartz-solar and pvnet environments. Just submitted PR #[N]
to pvnet on [issue].

GitHub: JiwaniZakir
```

---

## Day 2 — March 20: Technical Question

### Post Design Question (GitHub Discussion or Slack)

```
Hi @peterdudfield — design question for the TabPFN error adjustment proposal.

For the adjuster integration point, I see two options:

Option A: Post-processing layer (pure residual learner)
  raw = run_forecast(site, start, end)
  adjusted = raw + tabpfn_adjuster.predict(raw, meta_features)

  Pro: Backward compatible, easily toggleable (run_forecast(apply_adjuster=True))
  Con: Adjuster only sees the raw forecast, not the original weather features

Option B: Feature-augmented
  adjusted = run_forecast(site, start, end, use_adjuster=True)
  # Internally: adjuster features concatenated with weather features

  Pro: More information for the adjuster
  Con: Tightly couples adjuster to base model internals

My preference: Option A — TabPFN works well as a residual learner, and
Option A keeps the existing model completely untouched.

Is this how the project is envisioned?
```

---

## Day 3 — March 21: pvnet PR + Proposal Share

### Post Proposal Outline

```markdown
# [GSoC 2026] TabPFN Error Adjustment — Proposal Outline

Sharing for early mentor feedback.

## Deliverables

1. TabPFNAdjuster class: (raw_forecast, meta_features) → residual
2. Training pipeline: builds historical (forecast, actual) dataset from HF Hub
3. API integration: run_forecast(apply_adjuster=True) opt-in
4. Evaluation framework: MAE/RMSE before/after across sites + seasons
5. pvnet integration: same adjuster architecture for pvnet outputs
6. CI benchmarks: automated regression tests for adjustment quality

## Questions for Mentors

1. pvnet integration: same class, or separate adjuster subclass for pvnet's data format?
2. Training data: canonical dataset of (forecast, actual) pairs, or build the
   collection pipeline as a deliverable?

GitHub: JiwaniZakir
```

---

## Day 4 — March 22: Alignment

### If peterdudfield Responded

```
Thanks @peterdudfield! Very helpful.

Based on your feedback:
1. [Their point] → I'll change [X] to [Y]
2. [Their point] → Added [specific thing] to the scope

For pvnet: I'll treat it as a secondary deliverable demonstrating the
adjuster generalizes. Core first, then expand scope.

Updated draft: [link to gist]
```

### If No Response Yet (peterdudfield is slow — expected)

Post on the relevant GitHub issue directly:
```
Hi — I've submitted PRs to both quartz-solar and pvnet this week
as part of my GSoC 2026 application (error adjustment project).
Would appreciate any feedback on the integration design direction
when you have a moment.
```

---

## Day 5 — March 23: Final Summary

```
GSoC 2026 contribution summary (Open Climate Fix):

PRs this week:
- PR #[N] (pvnet): [description] — [status]
- PR #[N] (quartz-solar): CI speed fix — [status]
- PR #[N] (pvnet): [second contribution] — [status]

Key learning that shaped the proposal: [specific technical insight
about pvnet/quartz-solar architecture you'd only know from the code]

Thanks for the community engagement!
GitHub: JiwaniZakir
```

---

## Managing Slow Review Velocity

peterdudfield's merge cadence is ~every 3 weeks. Don't let this kill momentum.

1. Submit all PRs, don't wait for reviews before starting the next
2. Stay active in Slack regardless of PR status
3. On Day 4: polite bump — "Friendly note on PR #[N] — no rush, also opened #[N+1]"
4. Open PRs with visible activity are still strong evidence for evaluators

---

## Climate Tech Narrative (For Proposals + Outreach)

Don't just say "I care about climate change." Make it specific:

> "Solar forecasting accuracy directly affects grid operators' willingness to accept more renewable generation. A 10% improvement in forecast MAE reduces curtailment of solar power. TabPFN's approach to learning site-specific residuals is the right tool because it generalizes without massive training sets — critical for new installations with limited history."

This shows you understand the domain impact AND why the specific technical approach is justified.

---

## Response Templates

### When peterdudfield Reviews Your PR

```
Thanks for the review!

1. [Comment 1]: [What you changed and why it's better now]
2. [Comment 2]: Good catch — added a test for this edge case.
3. [Comment 3]: I was using [approach] for [reason]. Happy to switch
   to [their preference] — makes sense for [their reason].

pytest passes. CI green. Ready for re-review!
```

---

**Last Updated:** March 19, 2026 (post-intelligence rewrite)

---

## Day 1 — March 19: Join and Land

### Community Intro

Post in OCF Slack `#open-source-dev` or GitHub Discussions:
```
Hi Open Climate Fix! I'm Zakir — ML/AI developer applying for GSoC 2026
on the Quartz Solar error adjustment project (TabPFN adjuster).

Background: I've worked with tabular ML models and uncertainty quantification
in spectra (RAG evaluation toolkit) and aegis (intelligence platform).
The TabPFN approach to forecast error correction is technically interesting —
learning systematic residuals in-context, no retraining infrastructure needed.

I've set up the local environment, run the test suite (all passing), and
explored the prediction pipeline. Just submitted PR #NNN on [first issue].

GitHub: JiwaniZakir
```

### Issue Claim Template

Post on any issue before starting work:
```
I'd like to work on this as a GSoC 2026 applicant (error adjustment project).

I've reviewed the codebase and understand the scope. My approach:
1. [Step 1]
2. [Step 2]

Will post a draft PR once I have something working.
```

---

## Day 2 — March 20: Technical Engagement

### Open a GitHub Discussion on Adjuster Design

Title: `[Design] TabPFN Adjuster Integration — GSoC 2026 Proposal`

```
Working on my GSoC proposal for the error adjustment project.
Wanted to share my integration design and get feedback.

Proposed API (backward compatible):
  run_forecast(site, timestamp)                # Unchanged
  run_forecast(site, timestamp, apply_adjuster=True)  # New opt-in

The adjuster:
1. Loads last N days of (forecast, actual) pairs for the site
2. Builds features: forecast value, time of day, season, weather vars
3. Fits TabPFN in-context on that history
4. Predicts residual for the new forecast
5. Returns adjusted value + confidence interval

Design question:
Should the adjuster be a class (TabPFNAdjuster) with fit/predict methods,
or a module-level function? Class seems better for testability and
eventual per-site caching.

Also: What's the current data format for historical (forecast, actual) pairs?
Is there existing infrastructure for loading site-specific history?
```

This shows you've thought through the implementation deeply.

---

## Day 3 — March 21: Show ML Depth

### Post a Finding from Your Exploration

```
While exploring the prediction pipeline, I noticed [specific observation
about current error patterns, e.g., how residuals are or aren't calculated].

For the TabPFN adjuster, this means [implication for design].

Specifically: [concrete question about how to handle this].
```

This signals you're reading the code to understand it, not just to find something to change.

---

## Day 4 — March 22: Mentor Alignment

### Share Proposal Summary

```
Hi — finalizing my GSoC proposal for the error adjustment project.
Quick check on priorities:

Core deliverables (12 weeks):
1. TabPFNAdjuster class: fit/predict with uncertainty intervals
2. Feature engineering: time, season, weather features
3. run_forecast(apply_adjuster=True) integration
4. POST /forecast/adjusted REST endpoint
5. Benchmark: 10-15% MAE improvement target
6. Documentation + example notebook

Stretch (if ahead):
7. React dashboard component (adjusted vs. raw visualization)
8. Per-site context caching for production performance

Question: Is the React dashboard component expected in scope, or
should I treat it as optional? I want to be realistic about 13 weeks.

Also: Do you have test sites I should use for the MAE benchmark evaluation?
```

---

## Day 5 — March 23: Final Summary

### Post Contribution Summary

```
Week 1 summary (GSoC applicant for error adjustment):

PRs submitted:
- PR #NNN: [description] — [status]
- PR #MMM: [description] — [status]

Technical learnings:
- [Observation about current model error patterns]
- [How TabPFN will fit into the existing architecture]

Submitting proposal tomorrow. Thank you for the engagement this week!
```

---

## Response Templates

### When a Maintainer Reviews Your PR

```
Thanks for the review!

1. Re: [type annotation comment]: Added missing types in commit [hash].
2. Re: [test comment]: Added test for [edge case] — now covers [scenario].
3. Re: [approach comment]: You're right about [concern]. Changed to
   [new approach] because [reason]. Cleaner and [benefit].

pytest passing. CI green. Ready for re-review!
```

### When Discussing TabPFN Architecture

```
Thanks for the feedback on [design question].

Based on your input, I'm updating the approach:

Original: [what I proposed]
Updated: [what I'm now planning, based on feedback]

Reason for change: [why their feedback made sense]

Does this updated approach look right to you?
```

---

## OCF-Specific Norms

| Norm | Why |
|------|-----|
| Comment before coding | Prevents duplicate work, ensures alignment |
| pytest must pass | CI is strict — don't submit with failures |
| Type annotations | Python code should be typed |
| Jupyter notebooks OK | For exploration, but production code goes in .py files |
| Small focused PRs | Review speed correlates inversely with PR size |

---

## Zakir's ML Edge

The strongest differentiator for this proposal is showing you understand *why* TabPFN is the right tool, not just that you can use it.

**Key talking points:**
1. **spectra** (RAG eval): quality scoring from features — same structure as predicting forecast error from weather features
2. **In-context learning for small tabular data:** TabPFN was designed for this; gradient boosting/XGBoost needs more data. For per-site historical pairs (30–90 days), TabPFN wins.
3. **Uncertainty quantification matters here:** Grid operators don't just want a point prediction — they need a confidence interval for dispatch decisions.

Reference these specific points in every mentor interaction.

---

**Last Updated:** March 19, 2026

---

## Communication Channels Overview

### 1. Email (Formal Communication)

**Primary Contacts:**
- **quartz.support@openclimatefix.org** — Project-specific support, technical questions, GSoC mentorship
- **info@openclimatefix.org** — General inquiries, organizational matters

**When to Use:**
- Initial introductions
- GSoC-related questions or proposals
- Requesting mentorship
- Scheduling recurring meetings
- Important announcements about your contributions

**Response Time Expectation:** 24-48 hours (they're volunteers/busy)

---

### 2. GitHub Issues (Bug Reports & Feature Requests)

**Location:** Each repository's Issues tab
- Example: github.com/openclimatefix/open-source-quartz-solar-forecast/issues

**When to Use:**
- Report bugs (with reproducible steps)
- Propose features
- Ask for clarification on existing code
- Request documentation improvements

**Format:** Use issue templates if available; otherwise follow structure below

---

### 3. GitHub Discussions (Q&A & Design Discussions)

**Location:** Each repository's Discussions tab
- Example: github.com/openclimatefix/open-source-quartz-solar-forecast/discussions

**When to Use:**
- Architectural questions before coding
- Brainstorming features
- Asking for design feedback
- Sharing ideas or research
- General questions (not bugs)

**Advantage:** Discussion threads are searchable, helping future contributors learn

---

### 4. Pull Requests (Code Contribution)

**Location:** Repository Pull Requests tab

**When to Use:**
- Submitting code changes
- Fixing bugs
- Adding features
- Updating documentation

**Critical Rule:** Comment on the issue FIRST before submitting a PR. See section below.

---

## The "Comment First" Protocol

### Why This Matters

Open Climate Fix explicitly states:
> "Comment on issues before starting work to prevent duplicates and ensure alignment with maintainers."

**Without commenting first, you risk:**
- Duplicating work already in progress
- Building something that doesn't align with project direction
- Creating a PR that gets rejected
- Wasting your time and the reviewer's time

### How to Comment First

#### Step 1: Find an Issue

```
✓ Filter for "good first issue" label
✓ Read the issue title and description carefully
✓ Check if anyone else has already claimed it
✓ Look at the comment history
```

#### Step 2: Post Your Comment

**Template:**

```markdown
Hi @maintainer-name,

I'm interested in working on this issue. Here's my understanding and proposed approach:

## My Understanding
[Explain what the issue is asking for in your own words]

## Proposed Approach
1. [Step 1 of your solution]
2. [Step 2]
3. [Step 3]

## Questions
- [Any clarification needed?]
- [Constraints I should know about?]

I'm planning to start this week and estimate completion by [date].
Let me know if this aligns with your vision!
```

**Real Example:**

```markdown
Hi @jacobbieker,

I'd like to help improve the timezone handling in the forecasting pipeline.
I've identified some edge cases with DST transitions that could cause issues.

## Understanding
The issue is that timezone-aware datetimes don't consistently handle DST changes
across different NWP data sources.

## Proposed Approach
1. Create test cases for DST transitions in test_timezone_utils.py
2. Fix the timezone conversion logic in utils/timezone_utils.py
3. Add documentation on timezone handling best practices
4. Run full test suite to ensure no regressions

## Questions
- Should I handle both UTC and local timezone preferences?
- Are there specific regions/DST rules I should prioritize?

I'm planning to start this week. Thanks!
```

#### Step 3: Wait for Response

**Response Timeline:**
- Maintainers usually respond within 24-48 hours
- If no response in 3-5 days, it's OK to follow up politely
- Some issues may already be assigned (check comments)

**Possible Responses:**
1. **✅ "Go ahead!"** → You have clearance to proceed
2. **⚠️ "Here's feedback..."** → Incorporate feedback and ask clarifying follow-ups
3. **❌ "Thanks, but we're going in a different direction..."** → Appreciate the feedback, look for another issue
4. **❓ "Can you also..."** → Clarify scope and confirm before proceeding

#### Step 4: Create Your Branch

Once approved, create a feature branch following OCF naming conventions:

```bash
# Example for timezone work
git checkout -b fix/timezone-dst-handling

# Example for new feature
git checkout -b feature/tabpfn-adjuster

# Example for documentation
git checkout -b docs/accuracy-benchmarks
```

---

## Issue Comment Templates

### Template 1: Claiming a Simple Task

**Use for:** Documentation, tests, small refactors

```markdown
Hi @maintainer,

I'd like to work on this. Here's my plan:

1. [Specific action 1]
2. [Specific action 2]
3. [Expected outcome]

Timeline: [When you'll submit PR]

Is there anything specific I should keep in mind?
```

### Template 2: Proposing a Larger Change

**Use for:** Features, major refactors, new models

```markdown
Hi team,

I'd like to tackle this issue with the following approach:

## Problem Statement
[What problem are we solving?]

## Proposed Solution
[Technical approach with architecture/code structure]

## Expected Impact
- [Benefit 1]
- [Benefit 2]

## Estimated Effort
[Hours/days, or "unknown - will explore"]

## Questions for Clarification
- [Any design decisions I need your input on?]
- [Dependencies or constraints?]

Thoughts? Happy to adjust the approach based on feedback.
```

### Template 3: Asking for Design Feedback

**Use for:** Before coding, when unsure about approach

```markdown
Hi @maintainers,

I'm interested in implementing [feature/fix]. Before I write code,
I wanted to get your feedback on the design:

## Proposed Architecture
[Describe the design at a high level]

## Alternative Approaches
1. [Alternative 1 - pros/cons]
2. [Alternative 2 - pros/cons]

## Questions
- Which approach aligns better with the project?
- Are there existing patterns I should follow?
- Any foreseen issues with [approach]?

Thanks for the guidance!
```

### Template 4: Following Up If No Response

**Use if:** 48+ hours with no response

```markdown
Hi @maintainer-name,

Just following up on my interest in working on this issue
(comment from [date]). Is there anything else I can provide
to help move forward?

Looking forward to contributing!
```

---

## Pull Request Guidelines

### Before Submitting

**Checklist:**
- [ ] Commented on issue and received approval
- [ ] Created feature branch with proper naming
- [ ] Code follows project style (run linter)
- [ ] Tests pass locally: `pytest`
- [ ] Added tests for new functionality
- [ ] Updated documentation if needed
- [ ] Commits have clear messages
- [ ] Reviewed your own PR first

### PR Description Template

```markdown
## Description
[Brief summary of what this PR does]

## Related Issue
Fixes #[issue number]

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation only

## How Has This Been Tested?
[Describe your testing approach]

Example:
- Added unit tests in test_adjuster.py
- Tested with sites in 3 different timezones
- Verified no regression in existing forecasts

## Checklist:
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix/feature works
- [ ] New and existing unit tests pass locally with my changes

## Additional Notes
[Anything else reviewers should know?]
```

### After Submitting

**Engage Actively:**
1. Respond to comments within 24 hours
2. Ask for clarification if feedback is unclear
3. Don't argue with reviewers—ask questions instead
4. Make requested changes and push as new commits (don't force-push)
5. Thank reviewers for their time

**Example Response:**

```markdown
Thanks for the review! I've addressed your comments:

- Updated the error handling logic per your suggestion
- Added test case for edge case you identified
- Refactored to remove unnecessary complexity

All tests pass locally. Ready for another review!
```

---

## GitHub Discussions Best Practices

### When to Post

**Good for Discussions:**
- "I'm planning to add snow depth feature. Is this still needed?"
- "What's the recommended way to add a new NWP source?"
- "I found an interesting paper on forecast error adjustment. Should we explore this?"

**Not good for Discussions:**
- Bug reports (use Issues instead)
- Code submission (use PRs instead)
- Specific implementation questions (ask in Issue comments instead)

### Discussion Template

```markdown
## Question
[Your question clearly stated]

## Context
[Why are you asking? What are you trying to accomplish?]

## What I've Already Tried
[Show you've done some homework]

## References
[Links to relevant issues, papers, docs]

## Thoughts?
[What's your take or what guidance would help?]
```

---

## Email Template: Initial Introduction

### Scenario: First contact for GSoC interest

```
To: quartz.support@openclimatefix.org
Subject: GSoC 2026 Interest - Solar Forecast Error Adjustment

Hi Open Climate Fix Team,

I'm [Your Name], a [background] developer based in [timezone],
and I'm very interested in contributing to Open Climate Fix
as part of Google Summer of Code 2026.

## About Me
- Background: [Your technical background]
- Experience: [Relevant experience - Python, ML, etc.]
- GitHub: [Your GitHub profile]
- Timezone: [Your timezone for meeting scheduling]

## Why OCF?
[Genuine reason why this organization and project matter to you]

Example: "I'm passionate about renewable energy and believe better
solar forecasting is critical for grid integration. Your Quartz project
is doing exactly that."

## Proposed GSoC Project
I'm interested in the "Adjuster This! TabPFN for Solar Forecast Error
Adjustment" project. I've been exploring the codebase and have already:
- Set up the development environment locally
- Reviewed the architecture and main components
- Started contributing with [documentation/timezone fixes]

I believe this project aligns with my skills and interests.

## Questions for You
1. Is mentorship available for this project in GSoC 2026?
2. Would you be open to discussing the project proposal in more detail?
3. What's the best way to stay engaged with the team before the application deadline?

I'm excited about the opportunity to contribute to climate action through better software!

Best regards,
[Your Name]
[Your GitHub handle]
[Your email]
[Optional: Your LinkedIn or personal website]
```

---

## Email Template: Progress Update

### Scenario: During GSoC, giving a weekly update

```
To: quartz.support@openclimatefix.org
Subject: GSoC Weekly Update - Week 3

Hi [Mentor Name/Team],

Here's my progress for Week 3 of the GSoC project:

## Completed This Week
- [ ] Implemented TabPFN model class (PR #123)
- [ ] Trained baseline adjuster on historical data
- [ ] Created evaluation metrics notebook

## Current MAE
- Raw forecast (GB): 0.19 kW
- With adjuster: 0.17 kW (10% improvement) ✅

## This Week's Challenges
- [Challenge 1 and how I addressed it]
- [Challenge 2 - still working on]

## Next Week's Goals
1. Integrate adjuster into FastAPI backend
2. Create dashboard UI component
3. Add comprehensive test suite

## Questions/Blockers
- [If any, describe and ask for guidance]

Looking forward to our sync call on [day]!

[Your Name]
```

---

## Communication Etiquette

### Do's ✅

- **Be specific** — "My test fails on line 42" vs. "Tests don't work"
- **Show effort** — Demonstrate you've tried to solve it yourself
- **Be grateful** — Thank reviewers and contributors
- **Ask questions** — Maintainers want to help if you ask clearly
- **Be patient** — They're volunteers; be respectful of their time
- **Respond promptly** — If they give feedback, respond within 24 hours
- **Provide context** — Include error messages, code snippets, OS info
- **Use code blocks** — Format code/errors with backticks ```code```

### Don'ts ❌

- **Don't assume** — Ask for clarification if feedback is unclear
- **Don't argue** — Disagree respectfully; ask for reasoning
- **Don't demand** — "Fix this bug now" vs. "Could this bug be addressed?"
- **Don't spam** — Don't create duplicate issues or comments
- **Don't go silent** — If you say you'll do something, follow through
- **Don't submit unfinished work** — PR should be ready for review
- **Don't ignore feedback** — Reviewers spent time; engage seriously
- **Don't be discouraged** — Rejection doesn't mean you're not welcome

---

## Handling Criticism & Feedback

### If Your Idea Gets Rejected

**Scenario:** You propose a feature and they say "not interested"

**Reaction Pattern:**
1. **Take a breath** — It's feedback on the idea, not on you
2. **Ask for reasoning** — "Thanks for the feedback. Can you help me understand the concern?"
3. **Listen** — Actually listen to their reasoning
4. **Adapt** — Apply learnings to your next proposal
5. **Move on** — There are plenty of other issues

**Example Response:**

```markdown
Thanks for considering this. I understand the concern about
[their feedback]. This makes sense given [their reasoning].

I'll look for other ways to contribute. Maybe I can start with
[alternative issue] instead?
```

### If Your PR Gets Major Revision Requests

**Scenario:** You submit a PR and get many requests for changes

**Reaction Pattern:**
1. **Don't take it personally** — Big changes mean it matters
2. **Ask questions** — "Should I refactor X before Y, or together?"
3. **Break it into chunks** — Request focus areas (1, 2, 3 of 5)
4. **Communicate progress** — Push updates, tag for re-review
5. **Keep a good attitude** — This is how you learn

**Example Response:**

```markdown
Thanks for the detailed feedback! I can see the need for these
changes. To make progress clear, I'll address them in this order:

1. Refactor model class architecture (this commit)
2. Update tests (next commit)
3. Documentation updates (final commit)

Pushing part 1 now. Looking forward to continued feedback!
```

---

## Building Community Reputation

### How Contributions Build Credibility

**Small, consistent contributions → Community trust → Opportunities**

**Reputation-Building Activities:**

1. **Submit quality PRs** (even small ones)
   - Well-tested, documented, clear messages
   - Responsive to feedback

2. **Answer others' questions** (in Discussions/Issues)
   - "I had this problem too, here's how I fixed it"
   - Help newer contributors
   - Builds visibility

3. **Create helpful documentation**
   - Blog post about your learnings
   - Improve existing docs
   - Create examples/tutorials

4. **Be responsive**
   - Comment on your issues/PRs quickly
   - Follow through on commitments
   - Show up to meetings on time

5. **Engage meaningfully**
   - Thoughtful code reviews
   - Substantive discussion comments
   - Respect different viewpoints

### Red Flags to Avoid

- Radio silence after PR submission (days without response)
- Ignoring feedback or being defensive
- Claiming credit inappropriately
- Contributing inconsistently then disappearing
- Arguing about design decisions
- Poor code quality or sloppy testing

---

## Sample Engagement Timeline

### Month 1 (Before GSoC)

**Week 1:**
- Email introduction: quartz.support@openclimatefix.org
- Set up development environment
- Explore repository and architecture

**Week 2-3:**
- Find "good first issue" (documentation)
- Comment: "I'd like to work on this, here's my plan"
- Wait for approval (24-48 hours)

**Week 4:**
- Submit PR with documentation improvement
- Actively respond to feedback
- PR merged! 🎉

**Week 5-6:**
- Claim second issue (timezone fixes)
- Submit PR with tests
- Merged! Build credibility ✅

**Week 7-8:**
- Follow-up email with GSoC project proposal
- Respond to feedback on proposal
- Finalize GSoC application

### Month 2-3 (GSoC Period)

**Weekly:**
- Push code commits to feature branch
- Respond to feedback within 24 hours
- Email weekly progress update to mentor

**Bi-weekly:**
- Sync call with mentor (video or Zoom)
- Discuss blockers and next steps

**Major Milestones:**
- Week 2: Error analysis complete
- Week 4: Model training successful
- Week 7: API integration complete
- Week 10: Testing complete
- Week 12: Final PR submitted

### Month 4+ (Post-GSoC)

**Ongoing:**
- Monitor adjuster for issues
- Respond to user questions
- Contribute to related features
- Help newer contributors

---

## Troubleshooting Common Issues

### Issue: I commented on an issue but got no response

**What to do:**
1. Wait 48-72 hours (they might be busy)
2. Re-read the issue to make sure you understood it correctly
3. Look for comments suggesting it's already assigned
4. Post polite follow-up: "Any thoughts on my proposal above?"
5. If still nothing after a week, try a different issue

### Issue: My PR got rejected

**What to do:**
1. Read the rejection reason carefully
2. Ask clarifying questions if confused
3. Look for similar accepted PRs to understand what's wanted
4. Don't argue; accept gracefully
5. Try a different approach or different issue

### Issue: I'm stuck on the technical work

**What to do:**
1. Try to solve it yourself first (search docs, StackOverflow)
2. Comment on your feature branch PR: "I'm stuck on X, here's what I tried"
3. Ask in GitHub Discussions: "Best way to implement feature X?"
4. Email mentor if urgent: "I'm blocked on Y, can we discuss?"

### Issue: Deadline pressure, can't finish GSoC work

**What to do:**
1. **Email mentor immediately** — Don't wait until the deadline
2. Explain: "I'm on track for X, but Y is at risk"
3. Propose revised scope: "What if we deprioritize Z?"
4. Show what you CAN deliver
5. Plan continuation post-GSoC

---

## Key Takeaway

**The OCF community values:**
- Clear communication
- Respectful collaboration
- Quality work
- Consistency and follow-through
- Learning and growth mindset

By following these guidelines, you'll build strong relationships with the maintainers and become a valued community member.

Good luck with your contributions! 🚀
