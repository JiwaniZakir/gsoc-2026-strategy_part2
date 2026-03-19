# AI Contribution Engine — How to Generate 2–3 High-Quality PRs Per Day

> This is NOT a guide for submitting AI slop. It's a guide for using Claude as
> a pair programmer to do in 2 hours what would otherwise take 8 hours — while
> you retain judgment, understand every line, and make the PR genuinely good.

---

## The Core Workflow

```
1. Identify issue → understand what's needed
2. Claude analyzes codebase → finds the right files and patterns
3. Claude writes fix + tests + PR description simultaneously
4. Human reviews every line → edits for naturalness, correctness, fit
5. Run CI locally → verify before submitting
6. Submit PR + continue to next issue while this one is in review
```

**Time per PR (with this workflow):** 45–90 minutes
**Time per PR (traditional):** 3–6 hours

---

## Phase 1: Issue Intelligence Gathering

Before writing a single line of code, use Claude to understand the issue deeply.

### Prompt: Initial Issue Analysis
```
I'm working on issue #[N] in [repo]. Here's the issue description:
[paste issue text]

And here are the relevant files:
[paste file contents or file paths]

Help me:
1. Understand exactly what needs to change
2. Identify which files need to be modified
3. Spot any edge cases or traps I should know about
4. Assess: is this actually easy, or harder than it looks?
```

### Prompt: Find the Right Files
```
In this Python/JavaScript/Rust codebase, I need to fix [describe behavior].

Here's the directory structure:
[paste ls output or tree]

Here's the error/behavior I'm trying to fix:
[describe]

Which files should I look at first? What search terms should I use?
```

---

## Phase 2: Code Generation

### Prompt: Generate the Fix
```
Here's the file that needs to change:
[paste full file content]

Here's what the issue asks for:
[issue description]

Here's the pattern used elsewhere in the codebase for similar things:
[paste similar example]

Write the exact diff I need. Requirements:
- Follow the existing code style exactly (naming, spacing, patterns)
- Don't add imports I don't need
- Don't refactor anything that isn't being changed
- Keep it minimal — smallest change that fixes the issue
```

### Prompt: Generate Tests Simultaneously
```
Here's the fix I'm making:
[paste the diff]

Here's how tests are structured in this project:
[paste an existing test file]

Write the test(s) I need. Requirements:
- Follow the exact test structure already used
- Test the specific behavior described in the issue
- Include at least one edge case
- Name test functions in the same style as existing tests
- Don't over-test — only what's needed to prove this works
```

### Prompt: Generate PR Description
```
I've made the following changes:
[paste diff]

The issue I'm closing is:
[issue title and number]

Write a PR description with:
- "What": one sentence
- "Why": one sentence referencing the issue
- "How": 2–3 bullets on technical approach
- "Testing": what tests were added

Keep it concise. Don't pad it out. Maintainers read hundreds of these.
```

---

## Phase 3: Quality Control (Human Review Checklist)

Before submitting any AI-assisted PR, verify every item:

### Code Quality
- [ ] **Every line makes sense to me** — I can explain what it does and why
- [ ] **Follows the codebase's actual style** — not generic "good practice", the local conventions
- [ ] **No unnecessary imports added**
- [ ] **No unnecessary refactoring** — only changes what the issue needs
- [ ] **No AI hallucinations** — e.g., calling methods that don't exist, importing nonexistent packages
- [ ] **Variable/function names match the codebase style**

### Tests
- [ ] **Tests actually test the behavior described in the issue**
- [ ] **Tests use the same fixtures/helpers as existing tests**
- [ ] **Tests are not trivially passing** (e.g., `assert True`)
- [ ] **Tests would fail without my fix** (the real test of a test)

### PR Hygiene
- [ ] **CI passes locally** — run the actual test command before pushing
- [ ] **Lint/format passes** — ruff, eslint, cargo clippy, etc. depending on project
- [ ] **PR title uses conventional commits format** if required
- [ ] **Issue linked** (`Closes #NNN`)
- [ ] **PR template filled in completely** (GreedyBear especially)
- [ ] **No unrelated changes** — don't opportunistically fix other things
- [ ] **Branch name follows project convention**

### Naturalness Check
- [ ] **The code reads like it was written by a human familiar with the codebase**
- [ ] **Comments (if any) are in the same voice as existing comments**
- [ ] **PR description is specific, not generic** — references actual file/line numbers

---

## Phase 4: Parallel Pipeline

While PR #1 is in review, start PR #2 immediately. The review cycle is 12–48h per maintainer — don't let that time go to waste.

```
[ PR #1: submitted ] → waiting for review
         ↓
[ PR #2: in progress ] → use AI to generate simultaneously
         ↓
[ PR #3: identified ] → reading issue and codebase now
         ↓
[ PR #1: review received ] → AI helps you draft the response
```

### Prompt: Respond to Code Review Feedback
```
I submitted this PR to a maintainer:
[paste your PR description and diff]

The maintainer left this feedback:
[paste review comment]

Help me:
1. Understand what they want changed
2. Write the updated code
3. Draft my response comment explaining what I changed and why

Rules:
- Be gracious, not defensive
- Acknowledge the feedback before explaining your response
- If they're right, just say so and fix it
- If you disagree, explain your reasoning clearly and offer to discuss
```

### Prompt: Analyze Maintainer Comments
```
This maintainer left a comment on my PR that I'm not sure how to interpret:
[paste comment]

Here's the context (the file they're looking at):
[paste file]

What do they want me to do? What's the right response?
```

---

## Specific Prompts by Contribution Type

### Bug Fix
```
There's a bug reported in issue #[N]:
[paste issue]

Here's the file where the bug lives:
[paste file]

Find the root cause and write:
1. The minimal fix
2. A regression test that would catch this if it regressed
3. PR description

Don't over-engineer. Fix the specific bug, don't redesign the module.
```

### Feature Addition
```
This issue requests a new feature:
[paste issue]

Here's the relevant existing code:
[paste file(s)]

Here's how a similar feature was implemented elsewhere in the same codebase:
[paste similar example]

Write:
1. The feature implementation (following the existing pattern)
2. Tests for the new feature
3. Any documentation updates needed

Keep it consistent with how the codebase already does things.
```

### Documentation
```
This documentation issue needs fixing:
[paste issue]

Here's the current doc:
[paste doc file section]

Here's what's wrong / what needs to be added:
[describe]

Rewrite only the specific section that needs changing. Don't touch
surrounding content.
```

### Test Coverage
```
This function has no tests:
[paste function]

Here's how existing tests for similar functions are structured:
[paste test file]

Write tests that:
1. Cover the happy path
2. Cover the edge cases visible in the function
3. Would catch regressions if the function's behavior changed
4. Match the existing test style exactly
```

### Refactoring / Architecture
```
This issue asks for a refactoring:
[paste issue]

Here's the current code:
[paste file]

Here's what it should look like after:
[describe desired end state]

Write the refactored version. Requirements:
- Same external behavior (no functional changes)
- All existing tests must still pass
- Smaller, clearer, or more consistent with the rest of the codebase
- Explain what you changed and why in a PR description
```

---

## Making AI-Generated PRs Look Natural

### Common Tells to Eliminate

| AI Tell | Fix |
|---------|-----|
| Overly detailed comments on obvious code | Delete them |
| Perfect docstrings on every function | Only add if existing code has them |
| Generic variable names (`result`, `data`, `value`) | Match codebase conventions |
| Over-validated error handling | Match how the codebase actually handles errors |
| Multiple approaches mentioned in PR description | Just describe what you did |
| "This improves readability" without saying how | Be specific or delete |
| Changes that weren't asked for | Revert them |

### What Natural PRs Look Like

Based on PRs that actually got merged in the target repos:

**dora-rs merged PR style:** Short title, brief description, directly references the issue, no extra commentary.

**vulnerablecode merged PR style:** Technical, references specific function/file, includes test output in description.

**GreedyBear merged PR style:** Fills PR template completely, notes what tests were run, brief "what changed" section.

**OCF merged PR style:** Simple, often just a few lines changed, references issue number.

**Accord Project merged PR style:** Conventional commit prefix, links issue, short description.

---

## Daily AI-Assisted PR Workflow Schedule

### Morning Session (08:00–12:00): 1–2 PRs

```
08:00 — Open issues list for priority project (vulnerablecode first)
08:15 — Use Claude to analyze top 2 unclaimed issues
08:30 — Select best issue, use Claude to identify relevant files
09:00 — Generate fix + tests with Claude
09:30 — Review every line, edit for naturalness
10:00 — Run CI locally
10:15 — Submit PR #1
10:30 — While #1 is in review: start issue #2
11:30 — Submit PR #2
12:00 — Break
```

### Afternoon Session (13:00–17:00): 1 PR + Proposals

```
13:00 — Check all PR feedback from morning
13:15 — Use Claude to draft responses to any review comments
13:30 — Push feedback responses
14:00 — Submit PR #3 (different project)
15:00 — Post technical questions to community channels
15:30 — Write proposal section using Claude (Problem Statement or Technical Approach)
17:00 — End coding session
```

### Evening Session (19:00–21:00): Proposals

```
19:00 — Use Claude to draft Timeline section for current proposal
20:00 — Review and edit for accuracy
20:30 — Add personal narrative that only you can write
21:00 — Stop
```

---

## Proposal Writing with AI

AI can write the framework. You have to write the soul.

### AI-Generated Sections (High Quality)
- Technical approach and architecture diagrams (describe it, AI structures it)
- Timeline / milestone table (give AI the deliverables, it formats the weeks)
- "About the Organization" context section
- Technical glossary

### Sections You Must Write Yourself
- Why YOU specifically want to work on this project (personal motivation)
- Why your specific background makes you the right person
- Any personal anecdotes about using or caring about the software
- The "I'll continue contributing after GSoC" commitment

### Prompt: Draft Technical Approach Section
```
I'm writing a GSoC proposal for [project title] at [org].

Here's my proposed deliverable list:
[list deliverables]

Here's what I learned from reading the codebase:
[describe architecture]

Here's the existing code that my work would extend:
[paste relevant code]

Write a Technical Approach section for the proposal that:
1. Describes the current state and why it's a problem
2. Describes my solution at a technical level
3. Shows I understand the existing architecture
4. Makes the deliverables feel concrete and achievable
5. Is 400–600 words

Don't pad it. Be specific.
```

### Prompt: Draft Timeline
```
I have these deliverables for a 12-week GSoC project:
[list deliverables]

The midterm checkpoint is at week 6.

Create a week-by-week timeline where:
- Each week has a specific, concrete output (not "work on X")
- Weeks 1–2 are setup and community bonding
- Midterm (week 6) has a demonstrable deliverable
- Final (week 12) has everything integrated and documented
- Buffer weeks exist before final submission
```

---

## What Claude Cannot Do For You

- **Build rapport with maintainers** — that's all you
- **Know when to push back vs. accept feedback** — requires judgment
- **Understand the political dynamics** of a project (who's the decision maker, who's territorial)
- **Write the personal sections** of your proposal convincingly
- **Decide which issue to work on** — that requires reading between the lines of maintainer comments and competitor PRs
- **Guarantee correctness** — always run tests yourself

---

## Red Lines — Never Cross These

1. **Never submit a PR you haven't read line-by-line.** If a maintainer asks you to explain a line and you can't, you lose credibility permanently.

2. **Never submit AI-generated code to a project that explicitly bans it** (GreedyBear's CONTRIBUTING says "No AI copy-paste" — in that case, use AI only for analysis, write the code yourself).

3. **Never let AI write your personal statement.** Mentors read hundreds of proposals. Generic "I'm passionate about open source" language gets filtered immediately.

4. **Never use AI to respond to a merge conflict or test failure you don't understand.** Fix the root cause, don't patch the symptom.

5. **Never submit a PR where the tests are AI-generated without verifying they'd fail without your fix.** A test that always passes is worse than no test.

---

**Last Updated:** March 19, 2026
