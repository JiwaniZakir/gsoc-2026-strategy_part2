# Accord Project Architecture & Technical Overview

## Monorepo Structure

Accord Project uses a **monorepo architecture** with npm workspaces, enabling multiple interconnected packages that work together seamlessly. This structure allows developers to:
- Share code across packages efficiently
- Maintain consistent versions and dependencies
- Simplify cross-package testing and integration
- Streamline build and release processes

### Core Package Organization

```
accordproject/
├── packages/
│   ├── concerto/                 # Schema language & compiler
│   ├── template-engine/          # TemplateMark processing
│   ├── template-playground/      # Web UI for templates
│   ├── web-components/           # React components
│   ├── template-archive/         # Template storage
│   ├── concerto-cli/             # CLI tools
│   ├── apap-server/              # APAP server implementation
│   └── mcp-server/               # MCP protocol server
├── techdocs/                      # Documentation & wiki
└── package.json                   # Workspace root config
```

## Key Components for GSoC

### 1. **Concerto** (Schema Language)
- **Stars:** 176
- **Commits:** 5824
- **Purpose:** Core schema language for defining agreement structures
- **Technologies:** TypeScript, JavaScript
- **Key Files:** Compiler, type system, AST (Abstract Syntax Tree) processor
- **Maturity:** Production-ready, extensive test coverage

**Role in Architecture:** Concerto defines the data structures and types used throughout the Accord Project ecosystem. All agreements and templates rely on Concerto models for validation and type checking.

### 2. **Template Engine**
- **Purpose:** Processes TemplateMark (template language) into JSON
- **Process:**
  - Input: TemplateMark template definitions with embedded logic
  - Processing: Parse templates, apply models, generate JSON structure
  - Output: AgreementMark (JSON representation of agreements)
- **Technologies:** TypeScript, JavaScript
- **Key Components:** Parser, compiler, code generator

**Role in Architecture:** Acts as the transformation layer between human-readable templates and structured agreement data.

### 3. **APAP Server** (Accord Project Asset Protocol)
- **Purpose:** Exposes agreement processing capabilities via HTTP/REST API
- **Responsibilities:**
  - Template management and validation
  - Agreement generation and processing
  - Model compilation and validation
  - Asset storage and retrieval
  - Error handling and logging

**Key Endpoints:**
- `POST /compile` - Compile Concerto models
- `POST /generate` - Generate agreements from templates
- `GET /templates` - List available templates
- `POST /validate` - Validate agreement data

**Technologies:** Node.js, Express/Fastify, TypeScript, PostgreSQL

### 4. **MCP Server** (Model Context Protocol)
- **Purpose:** Wraps APAP capabilities for AI client integration
- **Implementation:** Experimental support already exists
- **Target Clients:** Claude (Anthropic), ChatGPT (OpenAI), other MCP-compatible AI tools
- **Protocol:** MCP (Model Context Protocol) v1.0+

**Key Features (GSoC Focus):**
- Expose template operations to AI clients
- Implement system tests for MCP operations
- Write comprehensive MCP integration documentation
- Improve error handling and data validation
- Add support for interactive template parameters

**Technologies:** TypeScript, MCP Protocol, Node.js

### 5. **Template Playground**
- **Purpose:** Web-based UI for template development and testing
- **Technologies:** React, web-components
- **Issues:** 91+ open (good entry point for contributions)
- **Features:** Template editor, live preview, validation feedback

**Role in Architecture:** Provides visual interface for template creators to test and debug templates before deployment.

### 6. **Web Components**
- **Purpose:** Reusable React components for Accord tools
- **Use Cases:** Template forms, agreement viewers, validation UI
- **Integration:** Used across template-playground and other UIs

### 7. **Concerto CLI**
- **Purpose:** Command-line interface for Accord tools
- **Commands:** Compile, generate, validate, list templates
- **Target Users:** Developers, automation systems, CI/CD pipelines

## Data Flow Architecture

### Complete Processing Pipeline

```
┌─────────────────────────────────────────────────────────────────────┐
│                        DEVELOPER WORKFLOW                            │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  TemplateMark    │
                    │   Definition     │
                    └──────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │ Template Engine  │
                    │    (Parser)      │
                    └──────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │   Concerto       │
                    │  Model Compiler  │
                    └──────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │   AgreementMark  │
                    │  (JSON Schema)   │
                    └──────────────────┘
                              │
        ┌─────────────────────┴─────────────────────┐
        │                                           │
        ▼                                           ▼
┌──────────────────┐                      ┌──────────────────┐
│  APAP Server     │                      │  Template        │
│  (REST API)      │                      │  Playground      │
└──────────────────┘                      │  (Web UI)        │
        │                                 └──────────────────┘
        │                                         │
        │                              ┌──────────┘
        │                              ▼
        │                    ┌──────────────────┐
        │                    │   User Input     │
        │                    │   (Agreement)    │
        │                    └──────────────────┘
        │                              │
        └──────────────────┬───────────┘
                           │
                           ▼
        ┌──────────────────────────────┐
        │    MCP Server                │
        │  (AI Protocol Wrapper)       │
        └──────────────────────────────┘
                           │
        ┌──────────────────┬───────────────────┐
        │                  │                   │
        ▼                  ▼                   ▼
    ┌────────┐        ┌────────┐        ┌────────────┐
    │ Claude │        │ChatGPT │        │ Other MCP  │
    │        │        │        │        │ Clients    │
    └────────┘        └────────┘        └────────────┘
```

### Data Transformation Steps

1. **Template Definition** → Developer writes TemplateMark
2. **Template Parsing** → Template engine parses syntax
3. **Model Compilation** → Concerto compiler generates JSON schema
4. **Schema Generation** → AgreementMark JSON structure created
5. **API Exposure** → APAP server exposes via REST endpoints
6. **AI Integration** → MCP server wraps for AI client access
7. **Agreement Processing** → AI clients use MCP to generate agreements

## Technology Stack Details

### Languages & Runtimes
- **Primary Language:** TypeScript
- **Runtime:** Node.js 16+ (LTS versions)
- **Package Manager:** npm (v7+ for workspace support)

### Frontend
- **Framework:** React
- **Component Library:** Custom web-components
- **UI/UX:** Template Playground for visual development

### Backend
- **Server:** Express or Fastify (depending on package)
- **Database:** PostgreSQL for persistent storage
- **API Style:** REST, with MCP protocol support

### Development & Quality
- **Linting:** ESLint with strict configuration
- **Type Safety:** TypeScript with strict mode (`"strict": true`)
- **Testing:** Jest test framework
- **CI/CD:** GitHub Actions workflows
- **Code Style:** Conventional commits, Prettier for formatting

### Build & Deployment
- **Package Manager Workspaces:** npm workspaces for monorepo
- **Build Tool:** TypeScript compiler (tsc)
- **Testing Pipeline:** `npm test` in each package
- **Version Management:** Semantic versioning, consistent dependencies

## Build & Development Workflow

### Prerequisites
- Node.js 16+ (LTS recommended)
- npm 7+
- Git

### Installation
```bash
# Clone repository
git clone https://github.com/accordproject/[repo-name]
cd [repo-name]

# Install dependencies (workspace-aware)
npm install

# Install specific package dependencies
npm install --workspace=packages/concerto
```

### Development
```bash
# Build all packages
npm run build

# Build specific package
npm run build --workspace=packages/template-engine

# Run tests
npm test

# Run tests for specific package
npm test --workspace=packages/concerto

# Lint code
npm run lint

# Watch mode for development
npm run watch
```

### Testing
- **Framework:** Jest
- **Coverage:** Aim for 80%+ coverage
- **Test Types:** Unit tests, integration tests
- **Command:** `npm test` or `npm test -- --watch`

### CI/CD Pipeline
- **Trigger:** Push to main, pull requests
- **Workflow:** GitHub Actions
- **Checks:**
  - ESLint validation
  - TypeScript compilation
  - Jest test suite
  - Code coverage thresholds
  - Build verification

## Architecture Diagram: MCP Integration

```
┌──────────────────────────────────────────────────────────────┐
│                      AI CLIENT LAYER                          │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  Claude (Anthropic)   │  ChatGPT (OpenAI)   │  Other Tools   │
│         (MCP)         │       (MCP)          │    (MCP)       │
│                                                               │
└───────────────────────────┬──────────────────────────────────┘
                            │ MCP Protocol
                            ▼
            ┌───────────────────────────────┐
            │      MCP Server               │
            │  - Resource handlers          │
            │  - Tool definitions           │
            │  - Prompt templates           │
            └───────────┬───────────────────┘
                        │
                        ▼
            ┌───────────────────────────────┐
            │    APAP Server (REST API)     │
            │  - Template operations        │
            │  - Agreement generation       │
            │  - Model compilation          │
            │  - Asset management           │
            └───────────┬───────────────────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        ▼               ▼               ▼
    ┌────────┐    ┌──────────┐   ┌──────────┐
    │Template│    │ Concerto │   │PostgreSQL│
    │Engine  │    │ Compiler │   │Database  │
    └────────┘    └──────────┘   └──────────┘
```

## Key Design Patterns

### 1. **Monorepo with Workspaces**
- Shared code across packages
- Unified dependency management
- Simplified cross-package testing

### 2. **Protocol-Based Integration**
- APAP: RESTful HTTP API for general access
- MCP: Standardized protocol for AI integration
- Separation of concerns between layers

### 3. **Type-First Development**
- TypeScript strict mode for type safety
- Concerto models define all data structures
- Runtime validation of agreement data

### 4. **Composable Components**
- Web components for UI reusability
- Modular package structure
- Plugin-like architecture for templates

## GSoC 2026 Focus Areas

### 1. **MCP Server Hardening**
- Extend experimental MCP server to production-ready status
- Implement comprehensive error handling
- Add system-level tests for all MCP operations
- Performance optimization and stress testing

### 2. **Documentation & DX**
- Write tutorials for MCP integration
- Create example applications
- Improve error messages and debugging
- Document architecture and design decisions

### 3. **Feature Extensions**
- Add new template operations exposed via MCP
- Support interactive parameter input
- Implement advanced agreement generation features
- Add support for agreement validation and analysis

### 4. **Testing Infrastructure**
- Create system test framework
- Add integration tests across packages
- Implement end-to-end testing for MCP workflows
- Set up performance benchmarks

## Code Quality Standards

### TypeScript Configuration
```json
{
  "compilerOptions": {
    "strict": true,
    "esModuleInterop": true,
    "resolveJsonModule": true,
    "declaration": true,
    "sourceMap": true
  }
}
```

### ESLint Enforcement
- Strict rule set across all packages
- Automatic code formatting with Prettier
- Pre-commit hooks (husky) for validation

### Testing Requirements
- Unit tests for all new functions
- Integration tests for package interactions
- Jest configuration with coverage thresholds
- Automated test execution in CI/CD

## Communication & Collaboration

### Code Review Process
- All changes require pull requests
- Mentors and community members review code
- CI/CD must pass before merge
- Conventional commit messages required

### Documentation
- Inline code comments for complex logic
- README files in each package
- Architecture documentation
- API documentation via TSDoc comments

---

**Last Updated:** March 2026
**Architecture Version:** 1.0
**Last Review:** Active GSoC 2026 cycle
