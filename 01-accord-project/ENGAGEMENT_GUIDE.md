# Accord Project Community Engagement Guide

## Getting Started with the Accord Project Community

Welcome to the Accord Project community! This guide will help you navigate the community channels, connect with mentors, engage with existing issues, and establish yourself as a contributor to the project.

## Discord Community Onboarding

### Joining the Discord Server

**Discord Link:** https://discord.gg/accordproject

**Steps to Join:**
1. Click the Discord invite link
2. Create account if needed (free)
3. Accept server rules and policies
4. Wait for verification if required
5. Browse available channels

### Channel Overview

#### Primary Channels

**#general**
- Project announcements
- Community news
- Major updates
- Where to post: General discussions, non-technical topics

**#technology-cicero**
- Technical discussions
- Code reviews
- Architecture questions
- Implementation details
- **Your Primary Channel for GSoC**

**#introductions**
- New member introductions
- Get to know the community
- First place to introduce yourself

**#help**
- Quick questions
- Debugging assistance
- Community support
- Best for: "How do I...?" questions

**#resources**
- Links to documentation
- Important guides
- Tooling recommendations
- Tutorial links

**#announcements**
- Official project announcements
- GSoC updates
- Release notes
- Read-only channel

### Your First Discord Message

**When:** Within first 2 days of joining
**Where:** #introductions channel

**Message Template:**

```
👋 Hi everyone! I'm [Your Full Name] from [Location/Country].

I'm interested in contributing to the Accord Project for GSoC 2026,
specifically the "APAP and MCP Server Hardening" project.

A bit about me:
- Background: [e.g., "Software Engineer with 3 years of JavaScript/TypeScript experience"]
- Interests: [e.g., "Smart contracts, legal tech, AI integration"]
- What I've explored so far: [e.g., "I've read the architecture docs and reviewed concerto repo"]

What I'm looking forward to:
- Learning the Accord codebase
- Contributing meaningful code
- Working with mentors Niall Roche and Dan Selman
- Building production-ready MCP integration

Feel free to reach out if you have questions or want to chat! 🚀
```

**Why This Works:**
- Personal touch shows genuine interest
- Specific project mention shows research
- Background helps community place you
- Makes it easier for mentors to identify you
- Shows enthusiasm and professionalism

### Engaging in #technology-cicero

**Best Practices:**
1. **Be respectful** - Community-first approach
2. **Search first** - Check if question already answered
3. **Be specific** - Include code snippets, error messages
4. **Use threads** - Reply in threads to keep organized
5. **Show effort** - Demonstrate you've researched
6. **Ask for help** - Don't be shy about blockers

**Example Messages:**

**Good Technical Question:**
```
Hi @niall, I've been exploring the template-engine and noticed the
parser handles string interpolation in Section 3.2 of the code.

I'm trying to understand how template variables are validated.
I looked at TemplateVariable.ts but noticed it doesn't seem to
validate against Concerto models.

Should template variables be validated at parse time or runtime?
And is there an existing validation flow I should be following?

Relevant code: [Link to GitHub file]
```

**Good Issue Discussion:**
```
Re: #1234 - MCP server error handling

I've started work on improving error handling per this issue.
I'm implementing:

1. Custom error classes for different error types
2. Consistent error response format with code + message
3. Validation at endpoint entry points

Question: Should validation errors return 400 or 422? I noticed
the codebase uses both - should we standardize?

Current implementation: [Link to PR]
```

### Discord Etiquette

**Do:**
- ✅ Use threads for discussions to keep channels organized
- ✅ Mention mentors respectfully (use @mention)
- ✅ Search for answers before asking
- ✅ Provide context and error messages
- ✅ Say thank you and acknowledge help
- ✅ Share your progress and learnings
- ✅ Ask clarifying questions

**Don't:**
- ❌ Spam or multi-message in quick succession
- ❌ Direct message mentors without introduction
- ❌ Ask questions already answered in docs
- ❌ Share sensitive information (keys, passwords)
- ❌ Post long code blocks (use GitHub links)
- ❌ Go off-topic in technical channels
- ❌ Complain without constructive suggestions

## Mentor Communication Strategy

### Meet Your Mentors

#### Niall Roche
- **Role:** Primary mentor, APAP server expert
- **Expertise:** System architecture, server implementation, testing
- **Discord Handle:** @niall or check server directory
- **Timezone:** Check profile for availability
- **Best Contact:** Discord #technology-cicero or GitHub PR reviews

#### Dan Selman
- **Role:** Co-mentor, template engine & MCP protocol expert
- **Expertise:** Template processing, MCP integration, language design
- **Discord Handle:** @dan.selman or check server directory
- **Timezone:** Check profile for availability
- **Best Contact:** Discord #technology-cicero or GitHub discussions

### Building Mentor Relationships

**Timeline:**
- **Week 1:** Introduction via Discord public message
- **Week 2:** First technical question in #technology-cicero
- **Week 3:** First GitHub PR for code review
- **Week 4:** Request for design feedback on GSoC approach
- **Ongoing:** Regular updates, questions, and progress sharing

### Reaching Out to Mentors

**When to Reach Out:**
- Have a specific technical question
- Hit a blocker after researching
- Need guidance on approach
- Ready for design review
- Seeking feedback on proposal
- Weekly update during GSoC

**How to Reach Out (Priority Order):**

**1. Public Discord Thread (Preferred)**
```
Hi @niall @dan.selman,

I have a question about [specific topic] in the context of [issue #XXX].

[Describe the problem/question clearly]

I've already [tried X, reviewed Y docs, looked at Z code].

What would be the recommended approach for [specific next step]?

Thanks!
```

**2. GitHub Discussion (For Design Decisions)**
- Post in GitHub Discussions tab
- Tag mentors with @niall and @dan.selman
- Link relevant code
- Clear problem statement

**3. GitHub PR Comments (For Code Review)**
- Ask questions directly on PR
- Request specific feedback
- Wait for async response
- Be responsive to feedback

**4. Direct Message (Only If Urgent)**
```
Hi Niall,

I'm currently blocked on [specific issue]. After trying [approaches],
I think I need your guidance on [specific question].

Quick question: [Your question]

Would appreciate any guidance when you have time. Thanks!
```

### Mentor Response Expectations

**Timeline:**
- Async questions: 24-48 hours typical response
- Urgent blockers: Mention in public Discord for visibility
- PR reviews: 48 hours for initial feedback
- Sync meetings: Confirm availability first

**How to Respond to Feedback:**
1. Thank mentor for feedback
2. Address each point specifically
3. Implement changes
4. Reply when ready for review
5. Ask if anything else needed

## GitHub Engagement

### Finding Issues to Work On

#### Issue Labels to Look For
- `good-first-issue` - Perfect for starting
- `help-wanted` - Community-reviewed issues
- `documentation` - Docs improvements
- `bug` - Bugs to fix
- `enhancement` - Features to add
- `testing` - Test improvements

#### Recommended Repositories for Starting

**1. techdocs (50+ open issues)**
- Best for: Documentation, tutorials, examples
- Difficulty: Easy to Medium
- Time commitment: 2-4 hours per issue
- Skills needed: Writing, understanding existing code

**2. template-playground (91+ open issues)**
- Best for: React, UI/UX, bug fixes
- Difficulty: Easy to Medium
- Time commitment: 3-6 hours per issue
- Skills needed: React, JavaScript, CSS

**3. template-engine (20+ open issues)**
- Best for: TypeScript, testing, parsing
- Difficulty: Medium
- Time commitment: 4-8 hours per issue
- Skills needed: TypeScript, testing, algorithms

**4. concerto (176 stars, maintained)**
- Best for: TypeScript, language features
- Difficulty: Medium to Hard
- Time commitment: 6-12 hours per issue
- Skills needed: TypeScript, compiler design

#### How to Find Good First Issues

**Method 1: GitHub Filters**
```
Go to: https://github.com/accordproject/[repo]/issues
Filter: "good-first-issue"
Sort by: Recently updated
```

**Method 2: Browse by Repository**
```
Visit each repo:
- techdocs
- template-playground
- template-engine
- concerto

Look at open issues with "help-wanted" or no assignee
```

**Method 3: Ask Mentors**
```
Discord message in #technology-cicero:

"Hi @niall @dan.selman, I'm looking for good first issues to work on
this week. What would you recommend for someone with [your skills]?"
```

### Claiming an Issue

**Steps:**
1. **Find Issue:** Browse issues with recommended labels
2. **Read Thoroughly:** Understand the problem and requirements
3. **Check Comments:** See if anyone is already working on it
4. **Search for Context:** Look at related PRs or discussions
5. **Ask if Needed:** Comment with questions before starting
6. **Claim the Issue:** Comment "I'd like to work on this" or similar
7. **Wait for Response:** Maintainer may acknowledge or provide guidance
8. **Start Work:** Create branch and begin implementation

**Claim Comment Template:**
```
Hi! I'd like to work on this issue.

I have experience with [relevant skills], and I've reviewed
[relevant code/docs]. My approach would be:

1. [Step 1]
2. [Step 2]
3. [Step 3]

Does this sound like the right direction? Any specific requirements
or edge cases I should be aware of?

Looking forward to contributing! 🚀
```

### PR Discussion Best Practices

**When Creating a PR:**
- ✅ Reference the issue number: "Closes #123"
- ✅ Provide clear description of changes
- ✅ Include any breaking changes
- ✅ Link to relevant documentation
- ✅ Be responsive to feedback

**When Receiving Feedback:**
- ✅ Thank reviewers for feedback
- ✅ Address each comment specifically
- ✅ Explain your reasoning if disagreeing
- ✅ Ask clarifying questions
- ✅ Push fixes and re-request review

**Example PR Description:**
```markdown
## What
Added comprehensive error handling to the APAP server REST endpoints.

## Why
- Inconsistent error responses made debugging difficult
- No validation of incoming requests
- Error messages didn't provide actionable guidance (closes #123)

## How
1. Created custom error classes (ApiError, ValidationError, etc.)
2. Added input validation middleware
3. Standardized error response format
4. Added logging for debugging

## Changes
- New file: `src/middleware/errorHandler.ts`
- Modified: `src/routes/*.ts` (5 endpoints)
- Tests: Added 30+ test cases

## Testing
Tested locally with Jest (100% coverage for new code)
All existing tests pass

## Related Issues
Closes #123
Related to #124, #125
```

## Community Norms & Culture

### What Makes Accord Project Community Great

1. **Respect** - Everyone's contribution is valued
2. **Openness** - Share ideas and learnings freely
3. **Responsiveness** - Help each other quickly
4. **Quality** - High standards for code and documentation
5. **Inclusivity** - Welcome to all experience levels

### Community Values

**For Technical Questions:**
- Provide context and what you've tried
- Share error messages and code snippets
- Ask follow-up questions if answers unclear
- Help others with similar questions

**For Code Reviews:**
- Be constructive in feedback
- Explain the reasoning behind suggestions
- Suggest improvements without being prescriptive
- Celebrate good implementations

**For Discussions:**
- Stay on topic
- Provide evidence for claims
- Respect different viewpoints
- Assume good intent

## Documentation & Resources

### Essential Documentation
- **Accord Project Docs:** https://docs.accordproject.org/
- **Concerto Language:** https://docs.accordproject.org/docs/spec-language
- **Template Syntax:** https://docs.accordproject.org/docs/spec-template
- **API Reference:** https://docs.accordproject.org/docs/reference
- **MCP Spec:** https://spec.modelcontextprotocol.io/

### GitHub Resources
- **Main Org:** https://github.com/accordproject
- **Contributing Guide:** Usually in CONTRIBUTING.md of each repo
- **Issues:** https://github.com/accordproject/[repo]/issues
- **Discussions:** https://github.com/accordproject/[repo]/discussions

### Learning Path for GSoC
1. **Week 1:** Read README and ARCHITECTURE.md from each repo
2. **Week 2:** Study Concerto language documentation
3. **Week 3:** Learn template syntax and template-engine architecture
4. **Week 4:** Review APAP server code and REST API
5. **Week 5:** Deep-dive into MCP protocol specification
6. **Ongoing:** Read code in repositories, ask questions

## Common Scenarios & Response Templates

### Scenario 1: Introducing Yourself

```
Hi everyone! 👋 I'm [Name], [brief background]. I'm excited to
contribute to the Accord Project for GSoC 2026, particularly the
"APAP and MCP Server Hardening" project.

[What you've explored]
[What interests you about this project]
[Skills you bring]

Happy to answer questions and looking forward to contributing!
```

### Scenario 2: Asking a Technical Question

```
Quick question about [topic]:

I'm working on [context], and I'm trying to understand
[specific thing].

From the code in [file.ts], it looks like [your understanding],
but I'm not sure about [specific part].

Should I approach this by [approach 1], [approach 2], or
[approach 3]?

Thanks for any guidance! 🙏
```

### Scenario 3: Reporting a Bug or Issue

```
I found an issue with [component]:

**Steps to reproduce:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected behavior:** [What should happen]

**Actual behavior:** [What actually happens]

**Error message:** [Include error if applicable]

**Environment:**
- Node.js version: [version]
- npm version: [version]
- OS: [Windows/Mac/Linux]

Let me know if you need more info!
```

### Scenario 4: Asking for Mentor Guidance

```
Hi @niall @dan.selman, I'm working on [issue/feature] and
would appreciate some guidance on the approach.

**Current understanding:**
[Your understanding of the problem]

**Proposed approach:**
1. [Approach step 1]
2. [Approach step 2]
3. [Approach step 3]

**Questions:**
1. [Specific question 1]
2. [Specific question 2]

I've reviewed [relevant code/docs], so any specific feedback
would be great. Thanks! 🙌
```

## Timeline for Integration

**Day 1:** Join Discord and introduce yourself
**Week 1:** Start with techdocs issues, join #technology-cicero
**Week 2:** Make first PR to template-playground or techdocs
**Week 3:** Connect with mentors on technical questions
**Week 4:** Make first contribution to APAP/MCP codebase
**Week 5+:** Regular contributor status, active in discussions

## Success Metrics

By the end of your first month, you should:
- [ ] Joined Accord Project Discord
- [ ] Introduced yourself (public message)
- [ ] Connected with Niall and Dan
- [ ] Made 3-5 meaningful contributions
- [ ] Had PRs reviewed and merged
- [ ] Asked thoughtful questions in #technology-cicero
- [ ] Demonstrated understanding of codebase
- [ ] Built good relationships with community

---

**Last Updated:** March 2026
**Community Lead:** Accord Project Discord
**Contact:** #technology-cicero channel
**Resources:** https://docs.accordproject.org
