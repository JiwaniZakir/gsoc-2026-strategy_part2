# AOSSIE Agora — Day-by-Day Engagement Guide

## Communication Channels

| Channel | URL | When to Use |
|---------|-----|-------------|
| Gitter | https://gitter.im/AOSSIE/ | PRIMARY — most active channel |
| GitLab Wiki | https://gitlab.com/aossie/aossie/-/wikis/ | GSoC ideas, org info |
| GitHub Issues | https://github.com/AOSSIE-Org/Agora/issues | Agora contributions |
| GitHub Issues | https://github.com/AOSSIE-Org/PictoPy/issues | PictoPy contributions |
| Email | gsoc@aossie.org | Official GSoC application inquiries |

---

## Day 1 — March 19: Introduction on Gitter

**Where:** https://gitter.im/AOSSIE/ (main room or #agora room)

**Message template:**
```
Hi AOSSIE team,

I'm Zakir Jiwani (GitHub: JiwaniZakir), a Python/ML developer interested in GSoC 2026
with AOSSIE.

I've been looking at both Agora and PictoPy. My background is Python/ML (transformers,
LangChain, computer vision), so PictoPy looks like a strong fit technically.

I've submitted a PR today to Agora (#[PR number] — Scoverage CI coverage) and am
planning contributions to PictoPy this week.

Questions:
1. Is there a 2026 GSoC ideas page I should reference?
2. Is PictoPy an active GSoC sub-project for 2026?
3. Is there a mentor for PictoPy I should reach out to directly?

Happy to work across multiple AOSSIE sub-projects — I just want to contribute where
it's most useful.

Zakir
```

---

## Day 2 — March 20: Engage on Specific Issues

**On PictoPy issues you're targeting:**
```
I'm working on this — will have a PR by end of today.

Quick question: are there any style preferences for type annotations in this codebase?
I see some files use Python 3.9+ syntax (list[str] vs List[str]) — which should I
standardize to?
```

This is the right kind of question — it shows you've read the code and are thinking
about consistency, not just implementing blindly.

---

## Day 3 — March 21: Proposal Discussion on Gitter

**Message:**
```
Following up on my intro — here are my PRs so far:
- Agora PR #X: Scoverage coverage report
- PictoPy PR #Y: Type annotations + docstrings for core module
- PictoPy PR #Z: FastAPI endpoint tests

For GSoC, I'm interested in proposing a PictoPy project focused on:
1. Improving the image clustering and recommendation engine with better ML models
2. Adding a proper test suite (currently limited coverage)
3. Improving FastAPI documentation and adding OpenAPI spec

Is this the kind of proposal AOSSIE is looking for? I'd love to sync with a mentor
before writing the full proposal.
```

---

## Day 4 — March 22: GitLab Engagement

**Check the AOSSIE GitLab wiki** for 2026 project ideas:
https://gitlab.com/aossie/aossie/-/wikis/

If there's a project idea that directly matches your skills and no one else has claimed it,
comment on the wiki discussion or email gsoc@aossie.org to express interest.

---

## Day 5 — March 23: Final Summary

**Where:** Gitter (reply to your intro thread)

```
End of week summary:

Agora contributions:
- PR #X: [title] — [status]

PictoPy contributions:
- PR #Y: [title] — [status]
- PR #Z: [title] — [status]
- PR #W: [title] — [status]

GSoC proposal submitted today. I'm applying for the [PictoPy / AOSSIE] track.
Thanks to @[mentor] for the guidance this week — the feedback on [specific issue] was helpful.
```

---

## AOSSIE-Specific Notes

### Gitter Etiquette
- Be specific about which sub-project you're discussing (Agora, PictoPy, etc.)
- AOSSIE mentors are researchers and academics — they appreciate technical depth
- Don't just list what you're doing — explain *why* your approach is correct

### Understanding AOSSIE's Structure
- AOSSIE is an umbrella org with many semi-independent sub-projects
- Each sub-project may have different mentors and different activity levels
- Check which sub-projects had slots in 2024/2025 to understand what's currently active

### If PictoPy Doesn't Have Slots
Alternative AOSSIE Python projects to check:
- **CarbonFootprint** — environmental data Python
- **AgoraWeb** — Play/Scala backend but Vue.js frontend (partial JS fit)
- Check the 2026 ideas page — new projects appear each year

---

## Do's and Don'ts

**Do:**
- Join Gitter before submitting your first PR
- Read the AOSSIE GitLab wiki thoroughly (contains org-specific info not on GitHub)
- Mention your ML background prominently — AOSSIE values research-oriented contributors
- Check if there's a CLA or contributor agreement to sign

**Don't:**
- Submit only Agora (Scala) PRs if you don't know Scala well
- Ignore PictoPy because it's less known — it's actually a better fit
- Apply without reading the GSoC ideas page — proposals that miss the ideas page are easily rejected
