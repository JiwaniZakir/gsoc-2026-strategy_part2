# Open Source Contribution Playbook — Blitz Edition

This is the speed-optimized version of contribution tactics. The goal: get PRs merged and mentors knowing your name within 5 days, not 5 weeks.

---

## 1. Blitz-Mode Mindset

You have 5 days and 5 projects. Standard "take it slow" advice does not apply.

**The Rules:**
1. **No perfect PRs.** Good and submitted beats perfect and pending.
2. **Draft PR first, then finish.** Creating a draft PR signals intent to maintainers within hours, not days.
3. **Address feedback immediately.** When a reviewer comments, respond within 2 hours during waking hours. This alone puts you in the top 5% of applicants.
4. **Post intros before PRs.** A cold PR with no prior introduction gets slower review than one from someone the community has seen.
5. **Multiple PRs per day is fine** — as long as each is focused, small, and passes CI. Don't batch scope; batch submissions.

---

## 2. Speed-PR Framework: 0-to-Submitted in 2 Hours

### Step 1: Issue Selection (15 min)

Find issues that match ALL of these:
- `good-first-issue` OR `documentation` OR `bug` label
- Has clear, bounded scope (not "redesign X" or "refactor Y")
- No recent activity from another contributor
- Filed in the last 6 months (so the codebase is current)

**Speed filter:** If you can't describe the fix in one sentence, skip it. Pick the next one.

### Step 2: Claim & Orient (10 min)

Post on the issue before coding:

```
I'd like to work on this. My approach:
1. [Step 1]
2. [Step 2]

Starting now — will have a draft PR up within a couple hours.
```

This signals momentum. You don't need approval first for `good-first-issue` items — just post and start.

### Step 3: Branch + Fix (45 min)

```bash
git checkout -b fix/issue-NNN-short-description
# Make the change
# Run tests/linting
```

Keep it small. If you notice related issues, make a note and open a separate PR. Do NOT scope-creep.

### Step 4: Draft PR Immediately (5 min)

Push and open as a draft the moment you have *something* running — even if tests aren't perfect yet:

```bash
git push origin fix/issue-NNN-short-description
# Open PR, mark as Draft
```

Draft PRs get eyes on them fast. Maintainers can start reviewing context before you finish.

### Step 5: Polish & Convert (25 min)

- Fix remaining issues
- Run the full test suite
- Write a complete PR description (see template below)
- Convert Draft → Ready for Review
- Post a message in the community channel: "Opened PR #NNN for issue #MMM"

**Total time: ~2 hours per PR.** You can do 3–4 per day across different repos.

---

## 3. PR Description Template (Copy-Paste This Every Time)

```markdown
## What
[One sentence: what this PR does]

## Why
[Why this change matters — reference the issue]
Closes #[issue number]

## How
- [Change 1]
- [Change 2]
- [Change 3, if any]

## Testing
- [x] Tests pass locally (`cargo test` / `npm test` / `pytest`)
- [x] Linting passes
- [x] No unrelated changes
- [ ] New tests added (if applicable)

## Notes for Reviewer
[Any context that helps review speed — design decision, tradeoff, question]
```

**Why this works:** Reviewers know exactly what to look at. Faster review = faster merge.

---

## 4. Getting PRs Merged in 24–48 Hours

The bottleneck is almost never code quality — it's communication latency. Optimize that.

### Tactic 1: Announce in Discord When PR is Ready

Don't just push the PR and wait. Post in the relevant channel:

```
Just opened PR #NNN implementing [what] for issue #MMM.
Would appreciate a review when you have a moment — it's a focused [X lines] change.
```

This is not spamming. One message is expected. Maintainers often miss GitHub notifications but see Discord.

### Tactic 2: Address Feedback Immediately

The moment you get review comments:
1. Read them all before responding to any
2. Respond to every comment — even to say "Fixed in [commit hash]"
3. Push the fix
4. Post: "Addressed all feedback in [commit hash]. CI green."

Response within 2 hours collapses a 3-day review cycle to same-day.

### Tactic 3: Make CI Green Before Posting

Maintainers will not review a PR with red CI. Run this locally before opening:

**TypeScript/Node (Accord):** `npm test && npm run lint && npm run build`

**Rust (dora-rs):** `cargo fmt --all && cargo clippy --workspace && cargo test --workspace`

**Python (GreedyBear/VulnerableCode/OCF):** `ruff check . && ruff format . && pytest`

Never submit with known CI failures.

### Tactic 4: Small PRs Merge Faster

The data is clear: PRs under 200 lines merge 3× faster than PRs over 500 lines. If you're over 200 lines:
- Can it be split? Usually yes.
- PR 1: The refactor (no behavior change)
- PR 2: The feature using the refactor

Two smaller PRs often merge before one large one would get a first review.

### Tactic 5: Assign a Reviewer

On GitHub, use the right-sidebar to request a review from a maintainer you've already interacted with. Don't request from someone who hasn't seen your work yet — find the person who commented on related issues.

---

## 5. Multiple PRs Per Day: Cross-Repo Strategy

During the 5-day blitz, target at least one PR submission to a different project each day.

**Sample Day:**
- 10:00 — PR to Accord (docs)
- 14:00 — PR to GreedyBear (bug fix)
- 19:00 — PR to Open Climate Fix (test)

**What makes this work:**
- Each repo has different maintainer timezones (EU vs US)
- While waiting for Repo A review, work on Repo B
- PRs compound over days — by Day 3 you have 6–9 live PRs across repos

**What kills it:**
- Scope-creeping any single PR
- Waiting for feedback before starting the next one
- Not having environments set up for all repos from Day 1

---

## 6. Community Engagement: Speed Version

### Day 1 Intro Template (Post in Each Community)

```
Hi! I'm Zakir — CS student working on AI/ML systems (LangChain, LangGraph, DSPy)
and systems programming (Rust). I'm contributing as a GSoC 2026 applicant for
[project area].

I just submitted PR #NNN (linked) and am starting to work on [next issue].

Looking forward to contributing — happy to answer questions or help other
contributors where I can.

GitHub: JiwaniZakir
```

**Key:** Lead with the PR link. It proves you're a contributor, not just a lurker.

### Engaging in Code Review Without Your Own PR

Even before your PRs are reviewed, add value by reviewing others:
- Find a PR that's been open >3 days with no review
- Leave a substantive comment (not just "LGTM") — "I noticed this edge case..."
- Mention it in Discord: "Left some notes on PR #NNN — hope it helps"

This builds community presence faster than any single PR.

### When to Ask Mentor Questions

Ask exactly one high-quality technical question per project per day. Make it:
- Specific (reference file + line number)
- Show you've read the code
- Have a concrete answer expected ("Should this be X or Y?")

**Do not** ask setup questions, documentation questions, or questions answered in READMEs. That signals you haven't done homework.

---

## 7. Handling the 5-Day Proposal Sprint

Writing proposals while contributing is the hardest part of the blitz. Timebox it.

### Proposal Writing Schedule

| Day | Proposal Work |
|-----|--------------|
| Day 1 (Mar 19) | Write title + 3-sentence synopsis + key deliverables for all 5 |
| Day 2 (Mar 20) | Full Problem Statement + Technical Approach for top 2 |
| Day 3 (Mar 21) | Complete Timeline + Deliverables for all 5 |
| Day 4 (Mar 22) | "Why This Project" + "About Me" for all 5; proposals 1–3 review-ready |
| Day 5 (Mar 23) | Final pass + incorporate mentor feedback + submit |

### Proposal Speed Hack: Reference Your PRs

The strongest signal in a GSoC proposal is a link to a merged PR. Even one merged PR before submission is worth more than 500 words of motivation. In each proposal:

```
I contributed [PR #NNN: description] and [PR #MMM: description].
Through this work I discovered [specific insight about the codebase].
This informs my approach to [GSoC project] because...
```

This takes 3 sentences and dramatically increases your acceptance odds.

---

## 8. What Separates Top Applicants

Based on past GSoC evaluations, top accepted applicants all have:

1. **2+ PRs merged before proposal deadline** — not just submitted
2. **Direct interaction with at least one named mentor** — in Discord or GitHub
3. **A proposal that references specific files/issues** — not generic language
4. **Responsive review cycle** — they addressed feedback within hours, not days
5. **Community visibility** — multiple comments, not just their own PRs

**Bottom line:** A "good enough" proposal + strong contribution history beats a perfect proposal + no contributions. Every time.

---

## 9. Common Blitz Mistakes to Avoid

### Mistake 1: Waiting for Issue Assignment Before Starting
For `good-first-issue` items, post your plan and start. Don't wait 24 hours for a maintainer to say "go ahead." They'll see your PR.

### Mistake 2: Submitting the Same Type of PR to Every Repo
Variety signals range. Documentation fix + bug fix + test improvement looks better than 3 documentation fixes.

### Mistake 3: Not Following Project-Specific Norms
- **dora-rs:** `@dora-bot assign me` in issues. Discuss non-trivial changes first.
- **GreedyBear:** Branch from `develop`. Draft PR within 1 week of assignment. Ruff must pass.
- **Accord:** Conventional commits format. ESLint must pass.
- **VulnerableCode:** Sign DCO before first commit. Follow black/isort formatting.
- **OCF:** Comment on issue first. pytest must pass.

Missing these gets PRs rejected on process, not code quality.

### Mistake 4: Proposal with No Specifics
Bad: "I will implement the feature using best practices."
Good: "I will implement `MockNode` in `dora-test-utils/src/mock_node.rs`, exposing `send_input()` and `receive_output()` APIs, addressing the gap identified in issue #1455."

### Mistake 5: Ghosting PRs Mid-Blitz
If you open a PR on Day 1 and don't respond to Day 2 feedback, you've signaled unreliability. Check every PR you've opened before starting new work each morning.

---

## 10. End-of-Day Checklist

Run this every evening during the blitz:

- [ ] All open PRs have been checked for new feedback
- [ ] All feedback received has been responded to (even just "acknowledged, fixing now")
- [ ] CI is green on all open PRs
- [ ] One meaningful comment made in each community channel today
- [ ] Proposal progress is on schedule (see table in section 7)
- [ ] Tomorrow's first PR target is already identified

If you can check all 6, you're executing a top-10% GSoC campaign.

---

**Last Updated:** March 19, 2026
**Mode:** 5-day blitz, proposals due March 24
