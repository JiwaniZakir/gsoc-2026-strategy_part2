# Accord Project: Day-by-Day Engagement Guide

**Community:** Accord Project Discord (`#technology-cicero`)
**GitHub Org:** https://github.com/accordproject
**Mentors:** Niall Roche, Dan Selman

---

## Day 1 — March 19: First Contact

### Action 1: Join Discord + Post Intro

Post in `#introductions` then cross-post relevant excerpt to `#technology-cicero`:

```
Hi Accord community! I'm Zakir — CS student with ML/systems background.
Applying for GSoC 2026 on "APAP and MCP Server Hardening."

I've been exploring LangGraph and MCP integrations in personal projects,
so the intersection of legal contract templates + AI protocol is
genuinely interesting to me — not just as a GSoC target.

I just submitted PR #NNN to [techdocs/template-playground] as a first
contribution while I get familiar with the codebase.

Looking forward to contributing!
GitHub: JiwaniZakir
```

**Key elements:** Reference the PR immediately. Mention a specific technical interest. Link GitHub.

### Action 2: Claim First Issue

On the issue you selected:
```
I'd like to work on this for GSoC 2026 (applying for APAP/MCP Hardening).
I've reviewed the codebase and understand the scope.

My approach:
1. [Step 1 — specific]
2. [Step 2 — specific]

Starting now, will have a draft PR within ~2 hours.
```

---

## Day 2 — March 20: Technical Depth

### Action 1: Ask a Smart Technical Question

In `#technology-cicero` — after your PR is in, signal you're going deeper:

```
Hi @niall @dan.selman — working on understanding the MCP server
architecture for my GSoC proposal.

I looked at [specific file, e.g., src/mcp/handlers.ts] and noticed that
[specific observation]. Does this mean [your interpretation]?

I'm asking because I want to make sure the testing approach I'm designing
actually covers the right invariants — rather than just testing the happy path.
```

**Rules for this message:**
- Reference an exact file and observation
- Show you've formed a hypothesis
- Connect it to something concrete (your proposal)

### Action 2: Leave a Code Review Comment

Find a PR open >3 days in the Accord repos:
- Look at `accordproject/template-playground/pulls`
- Leave a substantive comment: not "LGTM" but an actual observation
- Example: "One edge case this might miss: [scenario]. Worth adding a test for?"

---

## Day 3 — March 21: Establish Presence

### Action 1: Follow Up on PR Feedback

If your Day 1 PR received comments:
- Respond to every comment within 2 hours
- Push fixes
- Post: "Updated in commit [hash]. Let me know if there's anything else!"

If no comments yet:
- Post in Discord: "Quick note — PR #NNN has been up since yesterday. No rush, just wanted to make sure it's visible. Happy to make any adjustments."

### Action 2: Share a Technical Finding

In `#technology-cicero`, share something you discovered:
```
Small finding while exploring the template-engine tests:
[Specific observation, e.g., "The string interpolation function doesn't
have a test for nested template variables — I can see this would fail
in [specific scenario]."]

Is this a known gap, or should I open an issue?
```

This shows you're reading code proactively, not just fixing assigned issues.

---

## Day 4 — March 22: Mentor Feedback on Proposal

### Action: Share Proposal Outline

In `#technology-cicero` (or DM to @niall if you've already built rapport):
```
Hi Niall/Dan — I've drafted my GSoC proposal for APAP/MCP Hardening
and would appreciate a sanity check before I finalize it.

Key deliverables I'm planning:
1. 100+ system tests (MCP + APAP integration)
2. Typed error class hierarchy + consistent API error format
3. Zod-based input validation for all endpoints
4. MCP Integration Guide (20+ pages) + 3 tutorials
5. 5 new MCP tools (validateTemplate, searchTemplates, etc.)

Does this align with what you'd most like to see accomplished?
Any priorities I should shift?

Happy to share the full draft if useful.
```

**Why this works:** You're asking for alignment, not approval. This shows you've thought it through and are open to guidance.

---

## Day 5 — March 23: Final Visibility

### Action 1: Contribution Summary

Post in `#technology-cicero`:
```
GSoC contribution summary before I submit my proposal tomorrow:

PRs submitted this week:
- PR #NNN: [techdocs fix] — [status]
- PR #MMM: [template-playground fix] — [status]
- PR #PPP: [template-engine/MCP addition] — [status]

Learned a lot about [specific technical area] through this process,
which directly shaped my proposal approach.

Thanks for the reviews and guidance this week!
```

### Action 2: Thank Mentors Specifically

If Niall or Dan reviewed your PR or answered a question:
- Reply to the specific comment/answer
- Note what you did with it: "Took your advice on [X] — changed approach to [Y]"

---

## Ongoing: Response Templates

### When Your PR Gets Reviewed

```
Thanks for the feedback! I've addressed the comments:

1. **[Comment 1]:** Changed [what] to [what]. Reason: [why this is better]
2. **[Comment 2]:** Good catch — I didn't consider [edge case]. Fixed in commit [hash].
3. **[Comment 3]:** I'm using [approach] because [specific reason]. Happy to discuss alternatives.

Updated in commit [hash]. CI green. Ready for re-review when you have a moment!
```

### When Asking for Help on a Blocker

```
I'm stuck on [specific thing] in [specific file]:

Context: I'm trying to [goal]
Current approach: [what I've tried]
Problem: [specific error or unexpected behavior]
Attempted: [other things I tried that didn't work]

Specific question: [one clear question]

Code snippet: [link to exact line or paste]
```

### Polite Bump (After 48h with No Response)

```
Friendly bump on PR #NNN when you have bandwidth.
In the meantime, I've also opened PR #MMM on [different thing].
```

---

## Key Links

| Resource | URL |
|----------|-----|
| Discord | https://discord.gg/accordproject |
| Main Org | https://github.com/accordproject |
| techdocs issues | https://github.com/accordproject/techdocs/issues |
| template-playground issues | https://github.com/accordproject/template-playground/issues |
| MCP Spec | https://spec.modelcontextprotocol.io/ |

---

## What Mentors Are Looking For

Based on Accord Project's past GSoC selections:

1. **Specificity:** Vague interest in "legal tech" is ignored. Specific knowledge of the codebase is noticed.
2. **Responsiveness:** Responding to code review within hours (not days) signals reliability.
3. **Proposal alignment:** Proposals that reference the project roadmap and specific open issues get shortlisted.
4. **Not just GSoC:** Contributors who engage even on issues outside their GSoC scope show genuine interest.

**Zakir's edge:** LangGraph/MCP background is directly relevant to MCP hardening. Mention the specific overlap in every interaction.

---

**Last Updated:** March 19, 2026
