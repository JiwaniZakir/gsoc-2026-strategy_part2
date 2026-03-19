# Accord Project - GSoC 2026 Strategy

## Organization Overview

**Accord Project** is a Linux Foundation initiative dedicated to creating open-source tools and standards for smart legal contracts and agreement automation. Founded over 7 years ago, the project has grown to become a leading open-source platform for contract markup, template management, and agreement processing.

### Mission
Accord Project develops open-source tools and standards that enable developers to build intelligent contract applications with confidence. The project focuses on separating legal logic from implementation details, providing a language-agnostic approach to smart contracts and agreement processing.

### History
- **Founded:** 2016 as part of the Linux Foundation Hyperledger project
- **Evolution:** Evolved from blockchain-focused contracts to a broader agreement automation platform
- **Community:** Active open-source community with contributors from leading enterprises and independent developers
- **Maturity:** 7+ years of development, stable APIs, production-ready components

## GSoC 2026 Project

### Project Title
**APAP and MCP Server Hardening**

### Project Type
- **Duration:** 12 weeks
- **Hours:** 175 hours
- **Difficulty:** Medium
- **Status:** Available for GSoC 2026

### Full Description
This project focuses on extending and hardening the Accord Project Asset Protocol (APAP) server and implementing robust MCP (Model Context Protocol) server integration. The goal is to expose template operations and agreement processing capabilities to modern AI clients such as ChatGPT and Claude, enabling seamless integration of legal contract workflows into AI-powered applications.

**Key Objectives:**
1. Extend existing experimental MCP server support with production-ready features
2. Implement comprehensive system tests for APAP and MCP functionality
3. Create detailed documentation and tutorials for MCP integration
4. Improve error handling and data validation in server components
5. Enhance developer experience through improved tooling and examples

**Expected Outcomes:**
- Production-ready MCP server implementation
- Complete system test coverage
- Comprehensive documentation and tutorials
- Functional extensions for template operations exposure
- Improved developer experience and onboarding

## Technology Stack

### Core Technologies
- **Language:** TypeScript, JavaScript
- **Runtime:** Node.js
- **Package Manager:** npm with workspaces/lerna for monorepo management
- **Frontend:** React for web-based tools
- **Database:** PostgreSQL for data persistence
- **Protocol:** MCP (Model Context Protocol)

### Key Development Tools
- **Code Quality:** ESLint for linting, TypeScript strict mode
- **Testing:** Jest-based test suites
- **CI/CD:** GitHub Actions for continuous integration
- **Build System:** npm scripts, monorepo with npm workspaces

### Protocol & Standards
- **MCP Protocol:** For AI client integration
- **License:** Apache 2.0
- **Code Style:** Conventional commits, strict TypeScript

## Key Repositories

| Repository | Stars | Description | Commits |
|---|---|---|---|
| **concerto** | 176 | Core schema language and compiler | 5824 |
| **template-engine** | - | TemplateMark processing, JSON transformation | - |
| **template-playground** | - | Web UI for template development and testing | 91+ issues |
| **web-components** | - | React components for UI integration | - |
| **template-archive** | - | Template storage and management | - |
| **concerto-cli** | - | Command-line interface for Accord tools | - |
| **techdocs** | - | Documentation and GSoC project ideas | 50+ issues |

**GitHub Organization:** https://github.com/accordproject

## Mentors

### Niall Roche
- **Role:** Primary mentor
- **Expertise:** APAP server, system architecture
- **Communication:** Discord (@niall), GitHub

### Dan Selman
- **Role:** Co-mentor
- **Expertise:** Template engine, MCP protocol
- **Communication:** Discord (@dan.selman), GitHub

**Note:** Mentors are available through Discord for questions, guidance, and code reviews.

## Communication Channels

### Primary Channels
1. **Accord Project Discord:** https://discord.gg/accordproject
   - Channel: `#technology-cicero` for technical discussions
   - Channel: `#general` for announcements and community updates

2. **GitHub Issues & Discussions:** https://github.com/accordproject
   - Technical issues, bug reports, feature requests
   - Pull request reviews and discussions

3. **Direct Mentor Communication:**
   - Niall Roche (Discord, GitHub)
   - Dan Selman (Discord, GitHub)

### Community Contributions
- Active, responsive community
- Regular code reviews on pull requests
- Support through Discord channels
- Concerto Discord Channel for specific questions

## Contribution Guidelines

All Accord Project repositories follow standardized contribution guidelines focused on code quality, collaboration, and community engagement.

### Quick Start
1. Fork the relevant repository from https://github.com/accordproject
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/repo-name`
3. Install dependencies: `npm install`
4. Create a feature branch: `git checkout -b feat/your-feature-name`
5. Make changes following code style guidelines
6. Run tests: `npm test`
7. Submit pull request with clear description

### Code Standards
- **Language:** TypeScript with strict mode enabled
- **Linting:** ESLint configuration must pass without warnings
- **Testing:** Jest test suites required for new features
- **Commits:** Conventional commit format (feat:, fix:, docs:, test:, refactor:)
- **Documentation:** Inline comments and README updates as needed

### Pull Request Process
- Link related GitHub issues in PR description
- Reference the Accord Project Contribution Guidelines
- Provide clear description of changes
- Ensure CI/CD pipeline passes (GitHub Actions)
- Address reviewer feedback promptly
- Keep commits clean and atomic

### Build & Test
- **Install:** `npm install` in package directory
- **Build:** `npm run build`
- **Test:** `npm test`
- **Lint:** `npm run lint`

## GSoC Resources

### Official GSoC 2026 Ideas List
- **URL:** https://github.com/accordproject/techdocs/wiki/Google-Summer-of-Code-2026-Ideas-List
- **Content:** Complete project descriptions, difficulty levels, time estimates
- **Updates:** Regularly updated with new projects and clarifications

### Related GSoC 2026 Projects
- **Agentic Workflow** (90 hours, Medium)
- **Concerto Graphical Editor** (175 hours, Medium)
- **Template Logic Support** (175 hours, Medium)
- **New Concerto Runtime in Rust** (175 hours, Hard)
- **Testing for Code Generation** (90 hours, Easy)
- **LLM Template Logic Executor** (175 hours, Medium)

## Recent Project Contributors

The Accord Project benefits from contributions by experienced developers:
- Sanket Shevkar
- Matt Roberts
- Priyanshu Singh
- Diana Lease
- Ertugrul Karademir
- Jamie Shorten

## Key Dates (GSoC 2026)

- **Student Application Deadline:** TBD
- **Project Announcement:** TBD
- **Coding Begins:** TBD
- **Midterm Evaluation:** TBD
- **Final Submission:** TBD

## Next Steps

1. **Explore:** Review the techdocs and key repositories
2. **Engage:** Join the Accord Project Discord and introduce yourself in `#technology-cicero`
3. **Contribute:** Start with small issues in techdocs (50+ open), template-playground (91+ open), or template-engine
4. **Connect:** Reach out to mentors Niall Roche and Dan Selman on Discord
5. **Propose:** Develop a detailed proposal based on the MCP Server Hardening project description

## Additional Resources

- **Main Website:** https://accordproject.org
- **GitHub Organization:** https://github.com/accordproject
- **Discord:** Accord Project Discord Server
- **License:** Apache 2.0
- **Contact:** Mentors via Discord, community via GitHub Issues

---

**Last Updated:** March 2026
**GSoC 2026 Status:** Available
**Difficulty:** Medium
**Duration:** 12 weeks (175 hours)
