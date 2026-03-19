# Accord Project: 5-Day Blitz Contribution Plan

**Project:** APAP & MCP Server Hardening
**Mentors:** Niall Roche, Dan Selman
**Proposal deadline:** March 24, 2026
**Stack:** TypeScript, Node.js, MCP, PostgreSQL, Jest

---

## Day 1 — March 19: Land Fast

**Target:** First PR submitted and intro posted within the day.

### Hour-by-Hour

**08:00–09:00 — Environment**
```bash
git clone https://github.com/accordproject/techdocs.git
git clone https://github.com/accordproject/template-playground.git
git clone https://github.com/accordproject/template-engine.git
cd template-playground && npm install
cd ../template-engine && npm install
cd ../techdocs && npm install
```
Verify `npm test` passes in all three repos.

**09:00–10:30 — Issue Hunt**
- Browse https://github.com/accordproject/techdocs/issues with `good-first-issue` label
- Browse https://github.com/accordproject/template-playground/issues
- Pick the single most bounded, most impactful issue. Ideal targets:
  - Broken link in docs
  - Missing example in a tutorial
  - Template editor validation error message improvement
  - A test that's missing for an existing function

**10:30–12:00 — First PR**
- Claim the issue with a comment: "I'd like to work on this as a GSoC 2026 applicant for MCP Server Hardening. Starting now — will have a draft PR shortly."
- Create branch: `git checkout -b fix/issue-NNN-description`
- Make the fix
- `npm test && npm run lint && npm run build`
- Push and open as Draft PR, then convert to Ready
- Link the issue in the PR description

**12:00–13:00 — Discord Intro**
Post in `#technology-cicero` (Accord Project Discord):
```
Hi Accord community! I'm Zakir, CS student with ML/systems background
(LangChain, LangGraph, Rust, TypeScript). Applying for GSoC 2026 on
"APAP and MCP Server Hardening."

Just submitted PR #NNN to [techdocs/template-playground] as my first
contribution. Looking forward to diving deeper into the MCP server.

Happy to contribute beyond GSoC — this intersection of legal contracts
+ AI protocol is genuinely interesting work.

GitHub: JiwaniZakir
```

**13:00–15:00 — Second Issue Research**
- Identify a template-playground bug or template-engine test gap
- Do NOT claim yet — read the code and understand the fix first

**15:00–17:00 — MCP Server Exploration**
- Clone: `https://github.com/accordproject/apap-server` (or relevant MCP repo)
- Read the existing MCP server implementation
- Open ARCHITECTURE.md from this repo and cross-reference
- Note 3 specific areas for hardening (error handling, input validation, missing tests)

**17:00–19:00 — Proposal Skeleton**
Write in PROPOSAL_DRAFT.md:
- Synopsis (3 sentences)
- 5 key deliverables (bullet points)
- Top 3 technical questions to ask mentors

---

## Day 2 — March 20: Second Contribution

**Target:** Second PR submitted. Start technical dialogue with mentors.

### Tasks

**08:00–09:00** — Check PR #1 status. If there's feedback, address it immediately.

**09:00–12:00** — **PR #2:** Target template-playground OR template-engine.
- template-playground: bug fix in template editor, form validation, or loading state
- template-engine: add a Jest test for an existing function that lacks coverage
```bash
# Verify before submitting
npm test
npm run lint
# Check coverage
npm test -- --coverage
```

**12:00–14:00** — Post a technical question in `#technology-cicero`:
```
Hi @niall @dan.selman — I've been exploring the MCP server code
and noticed [specific thing in a specific file]. Quick question:

[Your specific technical question referencing file + line]

Asking because I'm designing my GSoC proposal and want to make
sure my testing approach aligns with how the server actually works.
```

**14:00–17:00** — Study APAP server code deeply:
- Map out all REST endpoints
- Note which ones lack input validation
- Note which ones lack system tests
- Document findings (add to ARCHITECTURE.md or private notes)

**17:00–21:00** — Write full Problem Statement + Technical Approach in proposal

---

## Day 3 — March 21: Substance

**Target:** Third PR targeting MCP or APAP codebase directly. Proposal 80% complete.

### Tasks

**09:00–12:00** — **PR #3:** Target the APAP or MCP server directly.
Best targets:
- Add a system test for an existing APAP endpoint
- Add input validation to an endpoint that lacks it
- Fix an inconsistent error response format
- Add a missing JSDoc comment to a core function

This is the most important PR — it's proof you can work in the actual GSoC project area.

```bash
# Accord uses conventional commits
git commit -m "test: add system test for template compilation endpoint"
# or
git commit -m "fix: add input validation to /templates POST endpoint"
```

**12:00–14:00** — Community: review 2 open PRs in Accord repos. Leave substantive comments.

**14:00–16:00** — Respond to any mentor feedback. If you got an answer to Day 2's question, post a follow-up showing you read and implemented the guidance.

**16:00–21:00** — Complete Timeline + Deliverables + About Me sections of proposal.

---

## Day 4 — March 22: Polish + Write

**Target:** Contribution record polished. Proposal review-ready by EOD.

### Tasks

**09:00–11:00** — Address all PR feedback. Every comment gets a response.

**11:00–13:00** — Post proposal draft outline in Discord. Ask:
```
Hi @niall @dan.selman — I've drafted an outline for my GSoC proposal
on APAP/MCP Server Hardening. Key deliverables I'm planning:
1. [Your deliverable 1]
2. [Your deliverable 2]
3. [Your deliverable 3]

Does this align with what you'd most like to see accomplished?
Any area I should prioritize differently?
```

**13:00–21:00** — Write the final proposal. See PROPOSAL_DRAFT.md.

---

## Day 5 — March 23: Final Proposal

**Target:** Proposal submit-ready. All PRs in clean state.

### Tasks

**09:00–12:00** — Final proposal pass: verify every deliverable is specific, every timeline week has a concrete output.

**12:00–14:00** — Post in `#technology-cicero`: brief contribution summary + thank mentors.

**14:00–17:00** — Address any last PR feedback. Verify CI is green on all open PRs.

**17:00–20:00** — Submit proposal to GSoC platform.

---

## March 24: Submit

- Final check: all contribution links in proposal are live GitHub URLs
- Submit on GSoC portal if not done March 23
- Keep watching PR feedback — merges before selection announcement strengthen your candidacy

---

## PR Checklist (Every PR)

- [ ] Branch from correct base (`main` or `develop` — check repo)
- [ ] `npm test` passes locally
- [ ] `npm run lint` passes (ESLint)
- [ ] `npm run build` succeeds (TypeScript compiles)
- [ ] Conventional commit message: `feat:`, `fix:`, `docs:`, `test:`
- [ ] PR description: What / Why / How / Testing
- [ ] Issue linked: `Closes #NNN`
- [ ] No unrelated changes

---

## Key Repositories

| Repo | URL | Purpose |
|------|-----|---------|
| techdocs | accordproject/techdocs | Docs (50+ open issues) |
| template-playground | accordproject/template-playground | React UI (91+ issues) |
| template-engine | accordproject/template-engine | TypeScript core |
| concerto | accordproject/concerto | Language support |
| apap-server | accordproject/apap-server | **GSoC target** |

---

**Last Updated:** March 19, 2026
**Mode:** 5-day blitz
