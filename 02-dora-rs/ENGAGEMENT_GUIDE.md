# dora-rs Community Engagement Guide

## Quick Start Checklist

- [ ] Clone repo and build locally
- [ ] Join Discord server
- [ ] Introduce yourself in GSoC channel
- [ ] Read this entire guide
- [ ] Understand issue assignment workflow
- [ ] Schedule first mentor sync
- [ ] Review non-trivial change discussion process

## Discord Community

### Server Structure
- **Invite Link:** https://discord.com/channels/1146393916472561734/1346181173277229056
- **Main Channel:** #general (project announcements)
- **GSoC Channel:** #gsoc-2026 (mentors, applicants, accepted students)
- **Help Channel:** #help (questions from users)
- **Development:** #development (code discussions, PR previews)
- **Announcements:** #announcements (releases, important updates)

### Introduction Template

When joining, post in #gsoc-2026:

```
Hello dora-rs community! 👋

I'm [Your Name], and I'm interested in contributing to dora-rs as part of
Google Summer of Code 2026.

Background: [Brief description - e.g., "I'm a 3rd year CS student with
experience in systems programming and Rust"]

Interest Area: [Which of the 10 GSoC projects interest you most? Or are you
exploring?]

Goals: [What do you want to learn from this experience? What do you hope to
accomplish?]

Looking forward to getting involved!
```

### Community Norms

**Be Respectful**
- Assume good intent
- Disagree with ideas, not people
- No harassment or discrimination

**Stay On Topic**
- Use threading for side discussions
- Use appropriate channels
- Keep #general for announcements

**Provide Context**
- Share error messages, not just "it doesn't work"
- Include environment info (OS, Rust version)
- Link to relevant code/issues

**Search Before Asking**
- Check Discord history (Ctrl+F)
- Search GitHub issues
- Check documentation
- Then ask if still unclear

## GitHub Issue Workflow

### Finding Issues to Work On

#### Filtering By Difficulty
```
Good Starting Points:
- label:good-first-issue
- label:documentation
- label:bug
- label:help-wanted

Intermediate:
- label:enhancement
- label:refactor
- no label assigned (sometimes)

Advanced:
- label:design
- label:architecture
```

#### Filtering by Area (for Testing Infrastructure)
```
Testing Related:
- search: "test" in title
- related issues: #1456, #1454, #1452, #1450, #1448, #1124

Code Quality:
- search: "coverage" OR "regression"
```

### Assignment Process

**Step 1: Find an issue you want to work on**
```
Read the issue carefully:
- What is the problem?
- What should the solution look like?
- Are there any dependencies?
- Do maintainers seem to want it fixed?
```

**Step 2: Check if it's already assigned**
```
Look for "Assignees" section. If empty, proceed. If assigned,
check the assignee's recent activity. If silent >2 weeks, could
ask to take over (respectfully).
```

**Step 3: Comment with @dora-bot command**
```
In the issue comment box, write:

"I'd like to work on this for GSoC. [Optional: brief explanation of approach]

@dora-bot assign me"
```

**Step 4: Wait for acknowledgment**
```
Maintainers will typically:
- Approve and assign (proceed)
- Ask questions (answer them first)
- Suggest different approach (discuss)

Don't start coding until assigned.
```

**Step 5: Unassign if needed**
```
If you get stuck or can't continue:

"I need to pause on this for now.

@dora-bot unassign me"

(Will also auto-unassign after 2 weeks of no progress)
```

### Non-Trivial Change Discussion

**What Requires Discussion First?**
- New features (not just bug fixes)
- Significant refactoring
- API design changes
- New dependencies
- Anything affecting the public interface
- Testing Infrastructure design (definitely!)

**What Doesn't?**
- Fixing obvious typos
- Improving error messages (small change)
- Adding a test for existing functionality
- Updating documentation to match code
- Reformatting or minor style fixes

**How to Discuss**

1. **Create an issue (if none exists)**
   ```
   Title: [Proposal] Description of what you want to do

   Description:
   - What problem does this solve?
   - Why is it important?
   - How do you plan to implement it? (high level)
   - Are there any concerns or alternatives?
   ```

2. **Link to the issue in your PR**
   ```
   In your PR description:
   "Closes #1234"
   or
   "Related to #1234"
   ```

3. **Be open to feedback**
   ```
   If mentors suggest a different approach:
   - Ask clarifying questions
   - Explain your original thinking
   - Be willing to change your approach
   - Aim for consensus
   ```

4. **For Testing Infrastructure specifically**
   ```
   When proposing the dora-test-utils API:

   "I'm proposing we structure testing utilities as follows:

   Core Modules:
   - MockNode: for isolated node testing
   - TestFixture: for setting up dataflows
   - RegressionHelper: for snapshot testing

   I've sketched out the API here: [link/code]

   Thoughts? @AlexZhang @ZunHuanWu"
   ```

## Email Communication

### When to Email vs. Discord/GitHub

**Use Discord (preferred):**
- Quick questions
- Status updates
- Mentoring discussions
- Community engagement

**Use GitHub Issues (for record):**
- Technical decisions
- Design discussions
- Long-term decisions
- Anything that will be referenced later

**Use Email (rare):**
- Privacy concerns
- Conflicts to resolve
- Very detailed technical write-ups

### Mentor Contact

**Primary: Discord**
- DM or mention @Alex Zhang or @ZunHuan Wu
- Best for async collaboration

**Fallback: Create an issue**
- Add labels: @testing-infrastructure @help
- Mentors monitor these

**Before Emailing:**
- Try Discord first
- Give them 48 hours to respond
- Be specific about what you need

## PR Submission Checklist

Before pushing a PR:

### Code Quality
- [ ] Runs `cargo fmt --all` ✓ (formatting)
- [ ] Runs `cargo clippy --workspace` ✓ (linting)
- [ ] Runs `cargo test --workspace` ✓ (tests pass)
- [ ] Code follows Rust conventions
- [ ] No unnecessary dependencies added
- [ ] No console.log/debug prints left in

### Documentation
- [ ] Public APIs have doc comments
- [ ] Examples added if new functionality
- [ ] README updated if needed
- [ ] CONTRIBUTING.md referenced if relevant

### Git Hygiene
- [ ] Commits have clear, descriptive messages
- [ ] No merge commits (rebase if needed)
- [ ] Branch name is descriptive
- [ ] No accidental files committed

### PR Itself
- [ ] Title is clear and descriptive
- [ ] Description explains the "why"
- [ ] Links to related issues
- [ ] Screenshots/examples if visual changes
- [ ] Checklist items marked in PR template

### Before Posting
- [ ] Re-read your own changes (catch silly mistakes)
- [ ] Verify CI checks locally if possible
- [ ] Ask yourself: "Would I review this favorably?"

## Response Time Expectations

### GitHub Issues
- Maintainers: 24-72 hours for assignment approval
- Community: 12-48 hours for answers
- Be patient; they're volunteers

### Discord
- @mentions: Usually within 12 hours
- General questions: 24 hours
- Urgent blocker? Use multiple channels + mention

### PR Reviews
- Initial review: 2-5 days
- Follow-up on comments: 1-2 days
- Final approval: 1-3 days

**If Waiting Too Long:**
- Politely bump after 5 days: "Friendly bump—still blocked on review"
- Ask in Discord for help
- Check if issue/PR has comments from maintainers

## Handling Feedback and Criticism

### When Reviewers Suggest Changes

**Professional Response:**
```
"Good point! I was thinking about this, and I can see how
[their suggestion] would be better because [reason]. Let me
update the PR."

(Make changes, push commits, re-request review)
```

**If You Disagree:**
```
"I understand your concern about [X]. I chose [Y] because
[rationale]. Would this alternative address your concern?
[link to code change]"

(Let them respond; if still no agreement, ask for
third-party input or let maintainers decide)
```

### What NOT to Do
- Don't get defensive
- Don't blame others
- Don't delete and rewrite (breaks review history)
- Don't force-push without explanation
- Don't demand immediate review

### Learning from Rejection

If a PR is rejected:
```
"Thanks for the feedback. I understand this approach doesn't
align with the project's direction. Lessons learned:
[what you'll do differently]

I'll look for another issue to work on. Let me know if you'd
like to discuss design before I start something new."
```

## Escalation: When You Need Help

### Minor Blocker (Can wait 24 hours)
1. Post in Discord #help with clear description
2. Include: What you're trying to do, what you tried, what failed
3. Tag relevant person if known

### Moderate Blocker (Can wait 12 hours)
1. Discord direct message to mentor
2. Also post in #gsoc-2026 so others can help
3. Provide context and what you've already tried

### Critical Blocker (Immediate action needed)
1. Discord: @AlexZhang or @ZunHuanWu with [URGENT]
2. Explain: What's blocked? Why is it blocking you?
3. What help do you need?
4. Follow up with issue link or GitHub comment

## Visibility and Accountability

### Staying Visible During GSoC

**Weekly Updates (pick one channel):**

Discord (preferred):
```
Weekly status in #gsoc-2026:

**Week X Summary:**
- [x] Completed: [deliverable]
- [x] Completed: [deliverable]
- [ ] In progress: [deliverable]
- Blockers: [if any]
- Next week: [plan]
```

GitHub (if more detailed):
```
Create issue comment on a "meta" issue or pinned PR:
"Week X status update..."
```

**Visibility Benefits:**
- Mentors can help if you're off track
- Community sees progress
- Accountability keeps you moving
- Shows sustained engagement

### Handling Inactive Periods

If you need to pause:
```
Discord message to mentors:
"I need to pause GSoC work from [date] to [date] due to [reason].
I'll resume on [date]. Current issue: [#number] will be paused.

@dora-bot unassign me (if needed)

Thanks for understanding!"
```

This prevents auto-unassignment surprises.

## Project-Specific Discussions

### Testing Infrastructure Design Discussions

Since Testing Infrastructure is the focus, here's how to structure design discussions:

**Phase 1: Initial Proposal**
```
In an issue titled: "[Proposal] Testing Infrastructure API Design"

Post:
1. Problem statement (why test utils are needed)
2. Proposed solution (high level)
3. API sketch (Rust pseudocode)
4. Example usage (show the happy path)
5. Open questions (what's unclear?)
```

**Phase 2: Feedback Loop**
```
Mentors will review and comment. Your job:
- Ask clarifying questions
- Explain trade-offs
- Refine API based on feedback
- Iterate until consensus
```

**Phase 3: Implementation**
```
Once approved:
- Create dora-test-utils crate (may need discussion)
- Break into PRs:
  * PR 1: Core MockNode struct
  * PR 2: TestFixture framework
  * PR 3: Regression testing helpers
  * PR 4: CI templates
- Each PR references original issue
```

## Red Flags and What to Do

### Red Flag: Assigned Issue Has No Response

**Your move:**
```
"Hi! I'm starting work on this. I'm planning to [your approach].
Any thoughts or concerns?

@dora-bot assign me"
```

Wait for acknowledgment. If none in 24 hours, proceed cautiously.

### Red Flag: PR Review Stalled for 2+ Weeks

**Action:**
```
1. Comment: "Friendly bump—any additional feedback?"
2. If no response in 3 days, ask in Discord
3. If still stuck, ask mentors if someone else can review
```

### Red Flag: Conflicting Feedback from Different Maintainers

**Action:**
```
"Thanks both for the feedback. I'm seeing different suggestions.
What's the best way to resolve this?

Option A (from Reviewer 1): [quote]
Option B (from Reviewer 2): [quote]

My preference: [your take]"
```

Let them agree on direction.

### Red Flag: You're Stuck and Out of Ideas

**Action:**
1. Don't disappear
2. In the GitHub issue: "I'm blocked on [specific thing]. Stuck for [time period]."
3. Discord DM to mentor immediately
4. Describe: What you tried, what you know, what's unclear
5. Ask: "Can we discuss this? Here's what I'm thinking..."

## Calendar and Scheduling

### GSoC Timeline (2026)

```
Mar 18-Apr 2 (2 weeks)  — Proposal period
                          (contribute to project, refine proposal)

Late April              — GSoC selections announced

May 2026                — Coding period begins
                          Work full-time on project

July 2026               — Midterm evaluation
                          Must have completed ~50% of scope

Sept 2026               — Final submission deadline
                          All work must be merged/complete
```

### Mentor Availability (Estimate)

- **Alex Zhang:** PST (UTC-8), availability TBD
- **ZunHuan Wu:** TBD timezone, availability TBD

**How to Sync:**
- Discord (asynchronous preferred)
- Scheduled calls (weekly, 30-60 min)
- GitHub discussions (async, recorded)

## Additional Resources

### Useful Links
- [dora-rs Repository](https://github.com/dora-rs/dora)
- [GSoC 2026 Wiki](https://github.com/dora-rs/dora/wiki/GSoC_2026)
- [Discord Server](https://discord.com/channels/1146393916472561734/1346181173277229056)
- [Rust Book](https://doc.rust-lang.org/book/)
- [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)

### Learning Resources for Testing Infrastructure

**Rust Testing Patterns:**
- Built-in test framework: `#[test]` and `#[cfg(test)]`
- Integration tests: `/tests/` directory
- Property-based testing: `proptest` crate

**Relevant Crates:**
- `mockall` — Procedural macro for mocking
- `test-case` — Parameterized testing
- `criterion` — Benchmarking

**Similar Projects:**
- Tokio's testing utilities
- ROS2's test infrastructure
- Zenoh's testing patterns

### When Stuck, Ask About:
- Testing best practices in Rust
- API design trade-offs
- Async/await patterns
- Performance considerations

---

**Document Version:** 1.0
**Last Updated:** March 18, 2026
**Owner:** zakirjiwani
**Next Review:** April 2026 (after GSoC selections)
