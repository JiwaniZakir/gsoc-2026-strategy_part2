# AOSSIE PictoPy — Day-by-Day Engagement Guide

**Focus: PictoPy only. No Agora (Scala).**

## Communication Channels

| Channel | URL | When to Use |
|---------|-----|-------------|
| Gitter | https://gitter.im/AOSSIE/ | PRIMARY — most active channel |
| GitLab Wiki | https://gitlab.com/aossie/aossie/-/wikis/ | GSoC ideas, org info |
| GitHub Issues | https://github.com/AOSSIE-Org/Agora/issues | Agora contributions |
| GitHub Issues | https://github.com/AOSSIE-Org/PictoPy/issues | PictoPy contributions |
| Email | gsoc@aossie.org | Official GSoC application inquiries |

---

## Day 1 — March 20: Introduction on Gitter

**Where:** https://gitter.im/AOSSIE/ (main room or #pictopy room)

**Message template:**
```
Hi AOSSIE team,

I'm Zakir Jiwani (GitHub: JiwaniZakir), a Python/ML developer applying for
GSoC 2026 with AOSSIE — specifically focused on PictoPy.

Background: Merged PRs in huggingface/transformers (CLIP is transformer-based),
graphrag (FAISS-style vector retrieval), and FastAPI production experience.
I've built a RAG evaluation toolkit (spectra) using very similar embedding patterns
to what PictoPy uses.

I've submitted my first PR to PictoPy today: [link] — [brief description]

Questions:
1. Is PictoPy an active GSoC sub-project for 2026? (I see it listed in the ideas wiki)
2. Is there a mentor for PictoPy I should connect with directly?
3. Are there specific improvements the team is prioritizing for this year?

Looking forward to contributing.

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

## Day 3 — March 22: Proposal Discussion on Gitter

**Message:**
```
Following up on my intro — here are my PRs so far:
- PictoPy PR #X: Type annotations + docstrings for core module
- PictoPy PR #Y: FastAPI endpoint tests
- PictoPy PR #Z: CLIP embedder draft (GSoC preview)

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

## Day 5 — March 24: Final Summary

**Where:** Gitter (reply to your intro thread)

```
End of week summary (PictoPy):

- PR #X: [title] — [status]
- PR #Y: [title] — [status]
- PR #Z: [title] — [status]
- PR #W: CLIP + FAISS draft — [status]

GSoC proposal submitted today — PictoPy AI backend enhancement (175h).
Thanks to @[mentor] for the feedback this week.
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
