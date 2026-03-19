# VulnerableCode Community Engagement Guide

## Introduction

This guide walks you through joining the VulnerableCode community, establishing communication channels, and preparing to contribute to the GSoC 2026 NLP/ML project.

---

## Step 1: Join Gitter Chat

### Why Gitter?
- Real-time discussion with maintainers and contributors
- Quickest way to ask questions
- Community announcements
- Debugging help from experienced developers

### How to Join

1. **Visit:** https://gitter.im/aboutcode-org/vulnerablecode
2. **Sign In:** Use your GitHub account (or create one)
3. **Join Channel:** Click "Join" on the VulnerableCode room

### First Message Template

Post a brief introduction in the `#general` or main channel:

```
Hi everyone! I'm [Your Name] from [Your Location/University].
I'm interested in GSoC 2026 with the NLP/ML project for
vulnerability detection. I have experience with [Python/Django/NLP/etc].
Looking forward to contributing!
```

**Expected Response:** Maintainers or contributors will welcome you within hours.

### Gitter Etiquette

- **Search before asking:** Use Gitter search (top-right icon) for common questions
- **Use threads:** Reply in threads to keep conversations organized
- **Paste code:** Use code blocks with syntax highlighting:
  ```gitter
  ```python
  def hello():
      print("Code here")
  ```
  ```
- **Be respectful:** Inclusive, welcoming community — be professional
- **Avoid spam:** Don't cross-post the same question to multiple channels

---

## Step 2: Set Up GitHub Communication

### GitHub Account & Configuration

1. **Create/Update GitHub Profile**
   - Add profile picture
   - Write a short bio
   - Link to personal website/blog if applicable
   - This is your professional identity in open source

2. **Subscribe to Repository Notifications**
   - Go to https://github.com/aboutcode-org/vulnerablecode
   - Click "Watch" → Select "Custom" → Check:
     - [ ] Releases
     - [ ] Discussions
     - [ ] All pull request reviews
     - [ ] Pull requests from forks
   - (Optional) Create custom notification rules in GitHub Settings → Notifications

3. **Enable Email Notifications**
   - Settings → Notifications → "Email" section
   - Choose frequency (immediately, daily digest, or weekly)
   - This ensures you catch important updates

### GitHub Issue Engagement Strategy

**Read-First Approach:**

Before commenting on any issue:
1. Read the full issue (all comments)
2. Check the linked PRs and commits
3. Search for related issues using keywords
4. Only comment if adding new information or perspective

**Example Comment on GSoC Issue:**

```markdown
Hey @Pombredanne, thanks for opening this. I've been exploring
the aboutcode.pipeline framework and have a question about
integration with the NLP extractor.

Question: Should the confidence score be stored as a separate
model field, or embedded in the vulnerability metadata?

I'm thinking field approach for easier filtering in API queries,
but happy to discuss trade-offs.

Referencing: PR #XXX, Issue #251
```

**What to Avoid:**
- "+1" or "interested!" comments (use reactions instead)
- Asking private questions (keep discussion in issue for others' benefit)
- Commenting without reading all existing discussion
- Off-topic tangents (stay focused)

### Using GitHub Reactions

Instead of "+1 I'm interested":
- Use emoji reactions (👍 👎 👀 ❤️)
- Less noise, cleaner thread
- Maintainers see aggregate reactions in sidebar

---

## Step 3: Attend & Participate in Weekly Meetings

### Meeting Schedule

**Day:** [Day of week - typically Thursday or Wednesday]
**Time:** [Timezone - typically UTC with recording for async]
**Duration:** 45-60 minutes

**Current attendees:** Pombredanne, Keshav-space, contributors, GSoC students

### How to Join

1. **Watch for Gitter Announcement**
   - Pombredanne posts link ~15 minutes before meeting
   - Link typically: Zoom, Jitsi, or Google Meet URL

2. **Join Early**
   - Log in 5 minutes before start time
   - Test your audio/video

3. **Prepare Agenda Items** (optional)
   - If you have a topic, mention in Gitter: "I have a question about [topic] for this week's meeting"
   - Pombredanne will add to agenda

### During the Meeting

**What to Expect:**
- Quick status updates from each contributor (1-2 min each)
- Technical discussions on PRs/design
- Q&A time for blockers or questions
- Roadmap/planning discussion

**Best Practices:**
- Keep camera on (helps engagement)
- Raise hand (or unmute) to speak
- Stay on topic; use Gitter for tangents
- Take notes if you find it helpful
- Say something! Even "I'm listening and learning" is good to share

**Example Status Update:**

> "Hi, I'm Zakir. This week I completed the entity recognition module
> for CVE ID extraction (PR #XXX). Accuracy on test set is 94%.
> Next week: integrating with the importer and starting ML confidence scoring.
> I had a question about the data model schema — should I update the existing
> Vulnerability model or create a new AugmentedVulnerability? Happy to discuss."

### Recording & Async Access

- Meetings are recorded (usually posted to GitHub Discussions within 24hrs)
- If you can't attend live, watch recording and comment async
- Post questions/comments on related GitHub issue

---

## Step 4: Read & Understand GSoC-Tagged Issues

### Finding GSoC Issues

1. Go to: https://github.com/aboutcode-org/vulnerablecode/issues
2. Filter: `label:GSoC` or search `is:open label:GSoC`
3. Current count: 24 issues tagged GSoC (as of early 2026)

### Understanding Issue Labels

| Label | Meaning | Action |
|-------|---------|--------|
| `GSoC` | Part of Google Summer of Code scope | Review, discuss with mentors |
| `easy` | Beginner-friendly | Start here for first contribution |
| `good-first-issue` | Suitable for newcomers | Perfect for Phase 1 |
| `documentation` | Docs work | Low barrier to entry |
| `nlp` or `ml` | Related to NLP/ML project | Core GSoC focus |
| `enhancement` | New feature | Medium difficulty |
| `bug` | Fix existing issue | Varies in difficulty |

### Deep-Read Strategy

Pick 3-5 GSoC issues and read thoroughly:

**For Each Issue:**
1. Read title and description carefully
2. Skim all comments (understand context)
3. Check linked PRs and branches
4. Note dependencies (e.g., "blocked by issue #XXX")
5. Assess effort level (small, medium, large)
6. Write down 2-3 questions for mentors

**Example Reading Notes:**

```
Issue #251: Process unstructured data sources, such as issues
- Goal: Extract vulnerability info from mailing lists, changelogs, etc.
- Current: Manual data entry only
- Proposed: NLP/ML pipeline
- Dependencies: Update data models (Vulnerability.extraction_confidence)
- Potential data sources: Full-disclosure list, PyPI changelogs, GitHub issues
- Questions for mentors:
  1. Which data source should we prioritize?
  2. Do you have labeled training data available?
  3. Should we use existing NLP libraries (spaCy) or train custom models?
```

### Comment on Issues Thoughtfully

**Before Commenting:**
- Do I have relevant expertise or perspective?
- Have I read all existing comments?
- Am I adding new information, not repeating?

**Example Substantive Comment:**

```markdown
I've been exploring this issue and think the approach could follow
the existing importer pattern. Here's what I'm thinking:

1. Create `UnstructuredDataImporter` class inheriting from `BaseImporter`
2. Implement `fetch_data()` to pull from mailing list archives
3. Implement `nlp_extract()` using spaCy NER for entity recognition
4. Store confidence scores in a new field: `Vulnerability.extraction_confidence`

I'm familiar with spaCy from my previous project at [Company/School].
Happy to lead the NLP component if approved.

Referencing: the Debian importer pattern from vulnerablecode/importers/debian/
```

---

## Step 5: Set Up Mentor Communication

### Primary Mentors

**Pombredanne** (Founder, Extremely Active)
- GitHub: @pombredanne
- Gitter: Direct messages OK
- Responds: Usually within 24 hours
- Best for: Architecture decisions, project direction, code reviews
- Meeting: Weekly Thursday meetings (see Step 3)

**Keshav-space** (Active Contributor)
- GitHub: @keshav-space
- Gitter: Direct messages OK
- Responds: Usually within 48 hours
- Best for: Implementation details, testing patterns, debugging
- Meeting: Also attends weekly meetings

### How to Message Mentors

**Gitter Direct Messages:**
1. Click mentor's avatar → "Start direct conversation"
2. Keep it brief and specific:
   ```
   Hi Pombredanne, quick question on the architecture:

   Should the NLP confidence score be a separate model field
   or embedded in Vulnerability.metadata? I'm leaning toward
   field for API filtering, but wanted your input.

   Zakir
   ```

**GitHub Mentions:**
- Use `@pombredanne` or `@keshav-space` on relevant issues/PRs
- Adds your message to their notification inbox
- Use for technical discussions needing context

**Email (Last Resort):**
- Only if urgent and no response on Gitter/GitHub within 2 days
- Ask for email in Gitter first ("Do you have office hours I can reach you at?")

### Setting Expectations

- **Response time:** 24-48 hours expected, sometimes within hours
- **Availability:** Mentors have other commitments; be patient
- **Questions:** Ask early and often; don't get blocked waiting
- **Meeting time:** Weekly meetings are primary sync point

---

## Step 6: Understand Communication Norms

### AboutCode Community Values

**From CONTRIBUTING.rst:**

1. **Inclusivity** — All backgrounds welcome; no gatekeeping
2. **Transparency** — Decisions discussed publicly
3. **Quality** — Code reviews are thorough and constructive
4. **Documentation** — Well-documented code and decisions
5. **Openness** — Feedback is welcome, even critical

### Dos and Don'ts

**DO:**
- Ask questions (no stupid questions in open source)
- Share work-in-progress (WIP PRs welcome)
- Comment with questions and ideas
- Link related issues/PRs
- Document your decisions and rationale
- Thank mentors and reviewers explicitly
- Celebrate small wins with the community

**DON'T:**
- Spam or cross-post the same question multiple places
- Demand immediate responses
- Go silent for weeks (update status regularly)
- Comment without reading context
- Push back on code review feedback defensively
- Hard-code decisions without consulting maintainers
- Work in isolation (share progress, ask early)

### Example Good Communications

```
Gitter message (asking for help):
---
Hi @Pombredanne, I'm working on the entity recognition module
and hit a wall on linking packages to CVEs in the same sentence.
The current regex approach misses ~15% of cases. Do you have
suggestions for:
1. Dependency parsing approach?
2. Existing libraries you prefer (spaCy, NLTK, etc.)?

WIP PR: #XXX (not ready for review, just for context)
---

GitHub comment (proposing approach):
---
I'm thinking we should use spaCy's named entity recognition
for package detection because:
1. Pre-trained models available
2. Easy to fine-tune on vulnerability data
3. Aligns with aboutcode's Python stack

Alternative: Rule-based regex (simpler, less accurate)

Thoughts? Happy to prototype both approaches and compare.
---

Gitter (status update):
---
**Weekly Status (Week 5)**
✅ Entity recognition module complete (CVE IDs, packages, versions)
✅ Achieved 94% accuracy on test set
🔄 Now: Training ML confidence scorer on 200 labeled examples
⚠️ Blocker: Need clarification on version format (e.g., ">=1.0" vs "1.0+")
📅 Next: Submit PR for entity recognition by Friday

Questions/feedback welcome!
---
```

---

## Step 7: Engage with GSoC-Specific Resources

### Google Summer of Code Portal

1. **GSoC Website:** https://summerofcode.withgoogle.com
2. **AboutCode GSoC Org Page:** Search for AboutCode in GSoC portal
3. **Check for:**
   - Official mentor list
   - Project descriptions
   - Application deadline
   - Student stipend details
   - Timeline for 2026 (typically May-August)

### AboutCode GSoC Specific

- **Gitter Channel:** May have dedicated `#gsoc` or `#gsoc-2026` channel
- **Discussions:** Look for "GSoC 2026" tags on GitHub Discussions
- **Planning Issues:** Epic issues for GSoC projects (e.g., Issue #251)

### Pre-GSoC Engagement Strategy

**Months Before Application (March-April 2026):**
1. Join Gitter and introduce yourself
2. Attend 2-3 weekly meetings
3. Contribute Phase 1 (documentation) PR
4. Comment thoughtfully on 3-5 GSoC issues
5. Have first mentor conversation about NLP/ML approach

**Application Phase (April-May 2026):**
1. Finalize proposal with mentor feedback
2. Share draft proposal on GitHub or Gitter for comments
3. Reference your Phase 1-2 contributions
4. Show enthusiasm and understanding of codebase

**After Selection (May-August 2026):**
1. Attend every weekly meeting
2. Post weekly status updates
3. Engage actively on issues/PRs
4. Ask questions early, don't hide blockers

---

## Templates for Communication

### Gitter Introduction Message

```
Hi everyone! I'm [Your Name] from [Your Location/University].
I'm a [year] student studying [major] with experience in
[Python/Django/NLP/etc.].

I'm interested in contributing to VulnerableCode, specifically
the NLP/ML project for extracting vulnerability info from
unstructured sources (GSoC 2026 idea #251).

I've [read the docs / set up the repo locally / reviewed some issues]
and am excited to get started. Looking forward to meeting everyone!

Feel free to reach out with pointers on where to start. Thanks!
```

### First Mentor Message

```
Hi @Pombredanne, thanks for maintaining this great project!

I'm interested in the NLP/ML vulnerability extraction project
(issue #251). I've familiarized myself with the aboutcode.pipeline
framework and the existing importers.

Quick question: What data sources should I prioritize for the initial
implementation? (e.g., mailing lists, changelogs, GitHub issues)

Would love to chat more about the technical approach. Happy to jump
on a call or discuss in the weekly meeting.

Thanks!
```

### Issue Comment (Proposing Approach)

```
Hi @Pombredanne and @keshav-space, I've been thinking about this issue
and have a proposal for the NLP/ML approach:

**Pipeline Design:**
1. Data sources: mailing lists, changelogs, CVE text
2. Entity recognition: Use spaCy NER + custom rules for CVE IDs, packages
3. Relation extraction: Link packages to CVEs in context
4. Confidence scoring: Train ML model on labeled examples

**Benefits:**
- Leverages existing aboutcode.pipeline framework
- Integrates with current Django models
- Allows confidence threshold filtering in API

**Questions:**
- Do you have labeled training data available?
- Should we start with one data source or multiple in parallel?

Excited to work on this. Happy to share more detailed design doc.
```

### Weekly Status Update (Gitter)

```
**Week 4 Status Update**

✅ Completed:
- Entity recognition module for CVE IDs (test coverage: 89%)
- Integrated with aboutcode.pipeline framework
- PR #XXX merged

🔄 In Progress:
- ML confidence scoring (training on 200 labeled examples)
- API endpoint for NLP results

⚠️ Blockers:
- Need clarification on version range format (e.g., ">=1.0" vs "1.0+")
  (asked on issue #XXX)

📅 Next Week:
- Submit confidence scoring PR
- Start integration testing

Questions/feedback welcome!
```

---

## Building Relationships

### Beyond Technical Discussion

**Mentors and community members appreciate:**
- Genuine interest in learning
- Ownership of problems (don't just ask, offer solutions)
- Respect for their time (prepare before asking)
- Celebrating others' contributions ("Great PR, loved how you...")
- Sharing knowledge back (help other contributors)

### Long-Term Community Involvement

**Post-GSoC Opportunities:**
- Continue as regular contributor
- Help review PRs from other GSoC students
- Mentor future contributors (pay it forward)
- Present at security/open-source conferences
- Write blog posts about vulnerabilitycode

---

## Troubleshooting Communication Issues

### If You Don't Get a Response

**24 hours, no response:**
1. Re-check your message (is it clear? does it need context?)
2. Post in Gitter public channel (not DM) if it was private
3. Link on related GitHub issue

**48 hours, still no response:**
1. Assume mentors are busy (they have other commitments)
2. Move forward with what you know (don't get blocked)
3. Post in weekly meeting: "Waiting on answer to X, proceeding with Y"

**Repeated non-response to a specific question:**
1. Ask differently (maybe your framing was unclear)
2. Propose an approach yourself (show thinking)
3. Ask: "Should I proceed with approach A while we clarify B?"

### If There's Conflict or Misunderstanding

1. **Assume good intent** — Open source culture values professionalism
2. **Step back** — Don't respond in anger, sleep on it
3. **Reframe privately** — DM mentor: "I felt dismissed by comment X, did I misunderstand?"
4. **Escalate if needed** — Contact other mentor or GSoC admin

---

## Engagement Checklist

Use this before starting contributions:

- [ ] GitHub account set up with profile picture and bio
- [ ] Gitter account joined and introductory message posted
- [ ] GitHub notifications configured
- [ ] Read 3-5 GSoC-tagged issues thoroughly
- [ ] Attended at least one weekly meeting (or watched recording)
- [ ] Messaged Pombredanne with one substantive question
- [ ] Set up local dev environment (`python manage.py migrate` works)
- [ ] Reviewed CONTRIBUTING.rst and DCO requirements
- [ ] Identified 2-3 Phase 1 issues to start with (docs/easy fixes)
- [ ] Bookmarked all key resources (docs URL, Gitter, GitHub issues)

---

## Key Contacts Quick Reference

| Person | Role | Platform | Response Time |
|--------|------|----------|---|
| Pombredanne | Founder, Primary Mentor | Gitter, GitHub, Meetings | 24hrs |
| Keshav-space | Contributor, Secondary Mentor | Gitter, GitHub, Meetings | 48hrs |
| GSoC Admin | Program coordination | GSoC portal, email | 48-72hrs |
| Community | Questions, debugging | Gitter channel | 1-24hrs |

---

## Final Thoughts

The VulnerableCode community is welcoming and invested in mentoring new contributors. Your engagement quality matters more than quantity — one thoughtful comment is worth more than ten "me too" reactions.

Focus on:
1. **Understanding deeply** before asking
2. **Contributing meaningfully** even if small
3. **Communicating clearly** and respectfully
4. **Showing ownership** of your work
5. **Building relationships** beyond the code

**You've got this. Welcome to VulnerableCode!**
