# GreedyBear Community Engagement Guide

## Quick Start: Getting Connected

### Step 1: Join Discord (Do This First!)

**Why Discord?** Honeynet Project prefers Discord for real-time communication. Email is slow; Discord gets you answers fast.

**Action:**
1. Go to: https://www.honeynet.org/ (find Discord link in footer/nav)
2. Join the Honeynet workspace
3. Find: **#gsoc-2026** or **#greedybear** channel
4. Read pinned messages (project info, mentors, schedule)

### Step 2: Introduce Yourself

**Post in #gsoc-2026 or #greedybear:**

```
Hello! I'm [Your Name] from [Your Country/University].
I'm interested in GreedyBear for GSoC 2026, specifically
the Event Collector API project.

Background:
- [3-5 years Python experience, etc.]
- [React experience if frontend work interests you]
- [Any honeypot/security experience]

I've already:
- Cloned the repo locally
- Read the ARCHITECTURE.md and CONTRIBUTING.md
- Set up the dev environment with ./gbctl init --dev --elastic-local
- Explored the /api directory structure

Next, I'd like to understand [specific area].
Any guidance appreciated! GitHub: @your-username
```

**Why this approach?**
- Shows you've done homework (mandatory)
- Establishes timezone and availability
- Sets tone: serious, prepared, respectful

### Step 3: Set Up Discord Notifications

- [ ] Enable notifications for #gsoc-2026 and #greedybear
- [ ] Set status to your timezone (mentors across EU/US)
- [ ] Add bio with GitHub username

---

## The Three Mentors

### Tim Leonhard — Frontend Lead
- **Expertise:** React, UI/UX, frontend architecture
- **On Discord:** @tim.leonhard (or similar)
- **Contact for:** React-related questions, frontend implementation
- **Timezone:** Likely EU (check status)
- **Style:** Direct, pragmatic feedback

**If you ask Tim:**
- "How should I structure the React component for token management?"
- "The Certego-UI library doesn't have X component, what do we use?"
- "Performance issue in frontend dashboard, thoughts on optimization?"

### Matteo Lodi — Backend Architect & Project Creator
- **Expertise:** Django, system design, backend infrastructure
- **On Discord:** @matteo.lodi (or similar)
- **Contact for:** Core API design, database queries, task queue logic
- **Timezone:** Likely EU
- **Style:** Thorough, designs-first approach

**If you ask Matteo:**
- "For Event Collector API, is token-per-service better than token-per-user?"
- "N+1 query issue in events listing, how would you approach?"
- "Django Q2 migration implications for new cronjob tasks?"

### Other Project Members
- 29 contributors means multiple experienced people
- Check GitHub profiles for focus areas (issues, PRs, expertise)
- Respectfully tag in discussions if relevant

---

## Before Contacting Mentors: The Golden Rule

### Read Documentation First — Not Optional

The **most important rule** in Honeynet's contributing guidelines:

> "Read ALL documentation and install project locally BEFORE asking questions"

**What this means:**
- Don't ask "How do I set up Django?" (it's in docs)
- Don't ask "Where is the API code?" (explore /greedybear/api/)
- Don't ask "What's Django Q2?" (read /docs/ARCHITECTURE.md)
- DO ask "I read X approach in the code, but I'm confused about Y implementation detail"

**Mentors get annoyed by questions that could be self-answered.** They're volunteers.

### Self-Teaching Checklist

Before asking in Discord, verify you've:

- [ ] **Cloned repo:** `git clone https://github.com/intelowlproject/GreedyBear.git`
- [ ] **Set up environment:** `./gbctl init --dev --elastic-local`
- [ ] **Verified it works:** `docker ps` shows greedybear containers running
- [ ] **Read CONTRIBUTING.md:** Available in repo root
- [ ] **Read ARCHITECTURE.md:** In /docs or repo
- [ ] **Explored /greedybear/api/:** Understand existing viewsets, serializers
- [ ] **Read Django-REST-Framework basics:** Official DRF tutorial (30min read)
- [ ] **Looked at recent PRs:** #882, #856, #846, #789 — understand patterns
- [ ] **Examined issue #1070, #1089, #1073:** Understand scope
- [ ] **Ran tests locally:** Verify setup with `docker exec greedybear_uwsgi python3 manage.py test`
- [ ] **Searched existing discussions:** GitHub Issues, past Discord messages

**Time Investment:** 4-6 hours of self-study before first real question

---

## How to Ask Great Questions

### Template for Effective Questions

```
[CONTEXT]
I've been working on [issue #XXX / feature Y].
I read [specific documentation/code section].

[PROBLEM]
I'm trying to [specific goal].
I expected [what should happen].
Instead, I got [actual result / error].

[WHAT I'VE TRIED]
1. [Approach A] — resulted in [outcome]
2. [Approach B] — resulted in [outcome]

[SPECIFIC QUESTION]
Looking at [code snippet/docs], I'm confused about [specific thing].
Should I [option 1] or [option 2]?

[CONTEXT LINKS]
- GitHub issue: #1070
- Code file: /greedybear/api/views.py (lines 42-58)
- PR reference: #789 (similar pattern)
```

### Example: Good Question

```
Hi Tim, I'm working on the Event Collector API frontend
(integrating token management UI).

I've read the existing auth components in /frontend/src/components/auth/
and the Certego-UI docs. I need to build a token generation form.

Certego-UI has FormInput and Button components, but I don't see
a "copy-to-clipboard" component. Looking at your pattern in the
password-change feature (#846), you used a custom wrapper.

Should I:
1. Extend Certego-UI with a new component?
2. Create a local custom component in /components/?
3. Use a third-party library like react-copy-to-clipboard?

Looking at the codebase, I don't see precedent for third-party clipboard libs.
What's the team preference?

PR reference: #846 (password change)
```

### Example: Bad Question (Don't Do This)

```
Hi guys, how do I make the API token work?
The docs are confusing. Can someone explain authentication to me?
```

**Why bad:**
- No context (which docs? which part?)
- No self-research shown
- Vague ("how do I make it work")
- Demands teaching rather than help

---

## Communication Channels & When to Use Them

### Discord (Real-Time, Async)
**When:** Quick questions, status updates, blockers
**Expected Response Time:** 4-24 hours
**Tone:** Casual but professional
**Good for:**
- "I'm stuck on X, here's the error"
- "Does the team prefer A or B design?"
- "I'm starting Issue #1070, any tips?"

**Bad for:**
- Long technical discussions (use PR comments instead)
- Sensitive/private info (use email)
- Formal decisions (use GitHub Issues)

### GitHub Issues & Discussions
**When:** Detailed technical discussion, design decisions, specs
**Expected Response Time:** 2-7 days
**Tone:** Professional, documented
**Good for:**
- "Here's my approach to event validation, thoughts?"
- Proposing a new feature
- Discussing architectural trade-offs
- Referencing code with line numbers

**Bad for:**
- Time-sensitive unblocking
- Casual catch-ups
- Questions about process

### GitHub PR Comments
**When:** Code review, feedback on specific implementation
**Expected Response Time:** 1-3 days
**Tone:** Professional, specific to code
**Good for:**
- Asking about a reviewer's suggestion
- Explaining design choice in context
- Discussing edge case handling

**Bad for:**
- General project questions
- Design discussions (use Issues for architecture)

### Email (project@honeynet.org)
**When:** Formal inquiries, privacy, urgent escalation
**Expected Response Time:** 5-10 business days
**Tone:** Professional, formal
**Good for:**
- Account issues, admin requests
- Sensitive personal info
- Formal complaints/concerns

**Bad for:**
- Technical questions (Discord/Issues better)
- Casual communication
- Urgent help (too slow)

---

## Weekly Communication Rhythm

### Suggested Schedule

**Monday Morning**
- Post brief status: "This week I'm tackling Issue #1089 (feeds filter).
  Got approval from @maintainer. Plan to have draft PR by Wednesday."

**Mid-Week (If Blocked)**
- Post specific blocker in Discord with context
- Link to related code/docs
- Tag appropriate mentor

**Friday (Or PR Ready)**
- Announce PR ready for review
- Link PR and brief description
- Ask for specific feedback areas if complex

**After Review Feedback**
- Respond within 24 hours
- Show you've made changes
- Ask clarifying questions if feedback is unclear

### Good Status Example

```
Weekly Update:

This Week:
✓ Completed Issue #1083 (session_id handling)
  - PR #XXX merged

In Progress:
→ Issue #1089 (feeds filter)
  - API endpoint designed (posted in PR #YYY as draft)
  - Waiting on feedback about filter validation logic

Next Week:
→ Issue #1087 (training data export)
  - Already reviewed the codebase
  - Thinking about chunking strategy for large datasets

Blockers: None at the moment

Overall: On track for Phase 2 timeline
```

---

## GitHub Profile & Visibility

### Your GitHub Presence Matters

Mentors will look at:
- **Your contributions:** Any honeypot/security projects?
- **Code quality:** Do your recent PRs show good practices?
- **Communication:** Are your commit messages clear? Do you write good PR descriptions?
- **Activity:** Consistent contributions or sporadic?

### GitHub Profile Setup

```
Username: @your-github-handle (make it findable)

Bio: "GSoC 2026 contributor @ GreedyBear (Honeynet Project).
Backend developer, Python & Django specialist.
Interested in cybersecurity and honeypot technology."

Location: [Your city] (helps for timezone sync)

Website: [Blog or portfolio, optional but good]

Pinned Repos:
  - Link to your best project (shows quality)
  - Your fork of GreedyBear (shows interest)
```

### During GSoC

**Mentors will track:**
- Issue assignments (public record)
- PR activity (frequency, quality)
- Commits (message quality, frequency)
- Response times to feedback

---

## Common Questions & Etiquette

### "Can I start working on Issue #1070?"

**Right Way:**
1. Comment on the issue: "I'd like to work on this for GSoC 2026.
   I've reviewed the codebase and understand the scope.
   Here's my proposed approach: [brief technical outline]"
2. Wait for assignment
3. Timeline starts (1 week to draft PR)

**Wrong Way:**
1. Fork and start coding immediately (might overlap with someone else)
2. Ask in Discord without showing homework (shows you didn't read)

### "My PR got rejected. What do I do?"

1. Read feedback carefully
2. Ask clarifying questions in PR comments
3. If you disagree, explain your reasoning respectfully
4. Make requested changes
5. Push updates to same branch
6. Re-request review

**Don't:** Reopen/resubmit without addressing feedback. Don't get defensive.

### "Mentor hasn't responded in 3 days. Should I chase them?"

**For urgent blockers:**
- Ping in Discord: "@mentor-name, following up on PR #XXX"
- Give them 48 hours
- If still stuck, ask alternative mentor

**For non-urgent:**
- Just wait. They'll get to it.
- Use the time to work on other tasks
- Don't spam/bump multiple times

### "Can I ask about career/salary/job prospects?"

**In Discord:** Yes, but off-topic. "Any folks working at [company] in security?"
**For mentorship:** No. Not their role. (Though they might help informally.)

### "I found a security vulnerability. Who do I tell?"

**Never post publicly.** Email project@honeynet.org immediately with details and "SECURITY" in subject line.

---

## Respect & Professional Behavior

### Do

- [ ] **Be curious** - Ask good questions
- [ ] **Show respect** - Mentors are volunteers giving their time
- [ ] **Be responsive** - Answer reviews within 24 hours
- [ ] **Give context** - Link code, explain what you tried
- [ ] **Admit mistakes** - "I misunderstood, thanks for explaining"
- [ ] **Help others** - Answer beginner questions after you learn
- [ ] **Be punctual** - Make commits regularly (daily if possible)
- [ ] **Document work** - Good commit messages and PR descriptions

### Don't

- [ ] **Don't ask without researching** - "How do I learn Python?"
- [ ] **Don't demand time** - Mentors have day jobs
- [ ] **Don't ghost** - If you disappear, update the issue
- [ ] **Don't argue** - Accept feedback. Discuss if you disagree, politely.
- [ ] **Don't over-commit** - Scope creep is failure, not ambition
- [ ] **Don't ignore feedback** - Read reviews and respond
- [ ] **Don't hard-code personal info** - No API keys, passwords, emails in code
- [ ] **Don't spam issues/PRs** - One per logical change

---

## Discord Tips & Tricks

### Channel Norms

**#gsoc-2026 / #greedybear:**
- Pin important docs/announcements
- Use threads for long discussions (keeps channel clean)
- React with ✅ when you see something resolved
- Use code blocks for error messages:
  ```python
  # Your code here
  ```

### Threading (Keep Channel Clean)

```
Message: "I'm stuck on the rate limiting logic"
  → Click "Reply in thread"
  → Entire conversation stays in thread
  → Channel stays readable
```

### Useful Reactions

- ✅ — resolved/understood
- 👍 — agreement/approval
- 🚀 — launch/merge PR
- 🤔 — question/needs discussion
- ❌ — blocker/issue

### Don't Overuse Direct Messages

- DMs are private (mentors might miss info)
- Use public channels (other developers can learn)
- Exception: Personal/sensitive stuff

---

## Timeline Expectations

### Before GSoC Coding (Now — April)

**March:**
- [ ] Join Discord and introduce yourself
- [ ] Set up environment locally
- [ ] Read all documentation
- [ ] Pick a small issue and start work
- [ ] Submit Phase 1 PR
- [ ] Get feedback and revise

**Early April:**
- [ ] Complete Phase 1 (small contributions)
- [ ] Write GSoC proposal (Event Collector API)
- [ ] Share proposal with mentors for feedback
- [ ] Refine based on their input
- [ ] Submit via GSoC platform

### GSoC Period (May — August)

**May (Start):**
- Official GSoC begins
- Team meeting to finalize approach
- Set up regular check-ins with mentors

**May — August:**
- Weekly progress updates
- Regular PR submissions
- Address feedback
- Expand API based on requirements

**August (End):**
- Final PR/feature complete
- Comprehensive documentation
- Demo/presentation
- Evaluation submission

---

## Building the Relationship

### First Impression Checklist

**First Discord message:**
- [ ] Introduce yourself genuinely (2-3 sentences)
- [ ] Mention you've done homework (cloned, read docs, ran locally)
- [ ] Ask one specific, thoughtful question
- [ ] Link GitHub profile
- [ ] Set availability (timezone + weekly hours)

**Example:**
```
Hi team! I'm Zakir, a backend developer from [City] interested in
GreedyBear for GSoC 2026. I've been working with Django/DRF for 3 years.

I've cloned the repo, run the local setup, and reviewed ARCHITECTURE.md
and the /api directory structure. I'm excited about the Event Collector API project.

Quick question: Looking at the existing auth patterns in /authentication/,
are you already considering token scopes for the injector role, or is that
something I'd need to design?

GitHub: @yourusername | Available ~3 hours/day, timezone [EST/UTC/etc]
```

**Response triggers mentors to:**
- See you're serious (homework done)
- Engage with your specific question
- Offer guidance on your GSoC project

---

## Long-Term Community Building

After GSoC, you could:

1. **Become a maintainer** (if fit)
2. **Write blog posts** about your work (great for visibility)
3. **Present at conferences** (Honeynet does talks at security cons)
4. **Mentor future GSoC students** (full circle!)
5. **Contribute independently** (stay in community)

---

## Final Reminders

✓ **Join Discord first** — that's where the community is
✓ **Do your homework** — read docs before asking
✓ **Ask good questions** — show what you've tried
✓ **Be responsive** — answer feedback within 24 hours
✓ **Communicate regularly** — weekly updates keep you visible
✓ **Respect their time** — mentors are volunteers
✓ **Be genuine** — they value authentic interest in security/honeypots

The Honeynet community is welcoming to serious contributors who show respect and initiative. Engagement now (before GSoC officially starts) sets the tone for the entire project.

---

**Document Version:** 1.0
**Created:** March 18, 2026
