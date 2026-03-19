# GSoC 2026 Proposal: APAP and MCP Server Hardening

**Applicant:** Zakir Jiwani
**GitHub:** github.com/JiwaniZakir
**Email:** jiwzakir@gmail.com
**Timezone:** EST (UTC-5)
**Availability:** Full-time, 35 hrs/week
**Organization:** Accord Project (Linux Foundation)
**Project Title:** APAP and MCP Server Hardening
**Duration:** 12 weeks / 175 hours
**Difficulty:** Medium
**Mentors:** Niall Roche, Dan Selman

---

## Synopsis

The Accord Project's APAP server and experimental MCP server integration currently lack production-hardening: comprehensive system tests are missing, error handling is inconsistent across endpoints, and the MCP surface area has no formal validation or documentation. This project delivers a production-ready MCP server with 100+ system tests, a complete error-handling framework with typed error classes, and developer documentation sufficient for third parties to build AI-integrated legal applications on top of Accord without writing a single line of bridge code.

---

## Problem Statement

### Current State

The Accord Project has a mature APAP server for managing legal templates and generating agreements. An experimental MCP server was added to expose these capabilities to AI clients (Claude, ChatGPT), but it remains:

- **Undertested:** No system-level test suite covers the MCP protocol surface
- **Fragile:** Error propagation is inconsistent — some endpoints return raw exceptions, others swallow errors silently
- **Undocumented:** No integration guide exists for developers wanting to connect AI clients to Accord
- **Unvalidated:** Input validation is absent from several API endpoints, enabling malformed requests to reach the template engine

### Why This Matters

Legal tech AI is growing fast. Accord Project is uniquely positioned to be the standard platform for legal contract automation over MCP — but only if the MCP server is reliable enough for production use. Right now, a developer trying to build a Claude plugin for legal document generation has:

1. No test suite to verify their integration works
2. No documentation describing what tools/resources the MCP server exposes
3. No reliable error messages when something goes wrong

This project eliminates all three gaps.

---

## Technical Approach

### Component 1: System Testing Framework (Weeks 1–3)

Build a comprehensive Jest-based test suite covering the MCP server's full surface area.

**Test Categories:**

| Category | Count | Scope |
|----------|-------|-------|
| MCP Resource Tests | 25+ | All exposed resources validated |
| MCP Tool Tests | 20+ | All tools: input/output verified |
| APAP Integration Tests | 25+ | End-to-end template → agreement flows |
| Error Path Tests | 20+ | Malformed input, missing auth, edge cases |
| Performance Benchmarks | 10+ | Response time SLAs under load |

**Implementation:**
```typescript
// Example system test pattern (target state)
describe('MCP Tool: generateAgreement', () => {
  it('returns valid agreement for well-formed template', async () => {
    const client = createTestMcpClient();
    const result = await client.callTool('generateAgreement', {
      templateId: 'test-template-001',
      params: { party1: 'Acme Corp', amount: 5000 }
    });
    expect(result.type).toBe('agreement');
    expect(result.content).toContain('Acme Corp');
  });

  it('returns typed ValidationError for missing required params', async () => {
    const client = createTestMcpClient();
    await expect(
      client.callTool('generateAgreement', { templateId: 'test-template-001' })
    ).rejects.toThrow(ValidationError);
  });
});
```

**Deliverable:** `tests/system/` directory with 100+ tests, CI integrated, coverage report ≥80%.

---

### Component 2: Error Handling Framework (Weeks 4–5)

Replace ad-hoc error handling with a typed error hierarchy and consistent API responses.

**Error Class Hierarchy:**
```typescript
// src/errors/index.ts
export class AccordError extends Error {
  constructor(
    public readonly code: string,
    public readonly httpStatus: number,
    message: string,
    public readonly details?: Record<string, unknown>
  ) {
    super(message);
    this.name = 'AccordError';
  }
}

export class ValidationError extends AccordError {
  constructor(message: string, public readonly field?: string) {
    super('VALIDATION_ERROR', 400, message, { field });
  }
}

export class TemplateNotFoundError extends AccordError {
  constructor(templateId: string) {
    super('TEMPLATE_NOT_FOUND', 404, `Template not found: ${templateId}`);
  }
}

export class TemplateCompilationError extends AccordError {
  constructor(message: string, public readonly line?: number) {
    super('TEMPLATE_COMPILATION_ERROR', 422, message, { line });
  }
}

export class McpProtocolError extends AccordError {
  constructor(message: string) {
    super('MCP_PROTOCOL_ERROR', 400, message);
  }
}
```

**Standardized Error Response Format:**
```json
{
  "error": {
    "code": "TEMPLATE_COMPILATION_ERROR",
    "message": "Unexpected token at line 42: expected } but got ,",
    "httpStatus": 422,
    "details": { "line": 42, "suggestion": "Check closing braces in template clause" },
    "requestId": "req-2026-abc123",
    "timestamp": "2026-03-19T14:30:00Z"
  }
}
```

**Middleware Integration:**
```typescript
// src/middleware/errorHandler.ts
export function errorHandlerMiddleware(
  err: unknown,
  req: Request,
  res: Response,
  next: NextFunction
): void {
  if (err instanceof AccordError) {
    res.status(err.httpStatus).json({
      error: {
        code: err.code,
        message: err.message,
        details: err.details,
        requestId: req.headers['x-request-id'] ?? generateRequestId(),
        timestamp: new Date().toISOString()
      }
    });
    return;
  }
  // Unexpected errors: log + return generic 500
  logger.error('Unexpected error', { err, path: req.path });
  res.status(500).json({ error: { code: 'INTERNAL_ERROR', message: 'Internal server error' } });
}
```

**Deliverable:** `src/errors/` module, middleware integrated across all APAP + MCP endpoints, error documentation.

---

### Component 3: Input Validation Layer (Week 6)

Add Zod-based schema validation to all APAP and MCP endpoints.

```typescript
// src/validation/schemas.ts
import { z } from 'zod';

export const GenerateAgreementSchema = z.object({
  templateId: z.string().min(1).max(255),
  params: z.record(z.unknown()),
  options: z.object({
    format: z.enum(['pdf', 'docx', 'json']).optional(),
    locale: z.string().optional()
  }).optional()
});

export const UploadTemplateSchema = z.object({
  name: z.string().min(1).max(255),
  content: z.string().min(1),
  version: z.string().regex(/^\d+\.\d+\.\d+$/)
});
```

**Deliverable:** Validation schemas for all endpoints, 100% of API inputs validated at the boundary.

---

### Component 4: MCP Documentation & Developer Guide (Weeks 7–9)

Create the documentation that currently doesn't exist.

**Documentation Set:**

1. **MCP Integration Guide** (20+ pages)
   - MCP protocol overview (5 pages)
   - Accord MCP server architecture (5 pages)
   - All resources and tools documented with examples (10 pages)

2. **Tutorials** (3 complete tutorials)
   - "Build a Claude Plugin for Legal Documents" (TypeScript)
   - "Integrate ChatGPT with Accord Project" (JavaScript)
   - "Run Accord Templates from Python via MCP" (Python)

3. **API Reference** (auto-generated + hand-curated)
   - All endpoints, parameters, response shapes, error codes

4. **Troubleshooting Guide**
   - 20+ FAQs based on common integration errors
   - Debug mode instructions
   - Performance tuning tips

---

### Component 5: New MCP Tools & Feature Extensions (Weeks 10–11)

Expand the MCP surface to expose more Accord capabilities to AI clients.

**New MCP Tools:**

| Tool Name | Description |
|-----------|-------------|
| `validateTemplate` | Validate template syntax and return structured errors |
| `searchTemplates` | Semantic search across template library |
| `compareAgreements` | Diff two generated agreements |
| `extractTemplateParams` | Return parameterized fields from a template |
| `bulkGenerateAgreements` | Generate multiple agreements from one template |

**Developer Experience:**
- CLI tool for local MCP server testing: `npx accord-mcp-test`
- Debug mode that logs all MCP protocol messages
- VSCode extension improvements for template authoring

---

### Component 6: Performance Testing & Hardening (Week 12)

**Load Testing:**
- Target: 1,000 concurrent MCP requests
- Measure: p50/p95/p99 latency, error rate
- Fix: Connection pooling, caching for compiled templates

**Security Hardening:**
- Input sanitization audit (prevent injection via template params)
- Rate limiting for MCP endpoints
- CORS configuration review

**Deliverable:** Benchmark report with before/after numbers; all critical-path optimizations merged.

---

## Week-by-Week Timeline

| Week | Focus | Key Deliverables |
|------|-------|-----------------|
| 1 | Architecture review, test framework setup | Test scaffold, CI integrated |
| 2 | MCP resource + tool tests (40+ tests) | Test suite running |
| 3 | APAP integration tests, error path tests | 100+ tests, ≥80% coverage |
| 4 | Error class hierarchy + middleware | `AccordError` hierarchy, consistent 4xx/5xx |
| 5 | Validation schemas for all endpoints | Zod schemas, 0 unvalidated inputs |
| 6 | Buffer week: iteration on test/error feedback | All code reviewed + merged |
| 7 | MCP Integration Guide (Part 1) | Architecture + resource docs |
| 8 | Tutorials #1 and #2 | Claude and ChatGPT tutorials |
| 9 | API reference + Tutorial #3 + Troubleshooting | Complete docs set |
| 10 | New MCP tools: validateTemplate, searchTemplates | 2+ new tools |
| 11 | New tools: compare, extract, bulk | 5 total new tools |
| 12 | Performance testing, security hardening, demo | Benchmark report, demo app |

---

## Expected Deliverables

### Code
- 100+ system tests (Jest), ≥80% coverage
- `AccordError` typed error hierarchy (5+ error classes)
- Zod validation schemas for all API endpoints
- 5+ new MCP tools

### Documentation
- MCP Integration Guide (20+ pages)
- 3 complete tutorials with runnable code
- Complete API reference
- Troubleshooting guide (20+ FAQs)

### Metrics
- 20%+ latency improvement on critical paths
- 0 unvalidated API inputs
- ESLint clean, strict TypeScript throughout

---

## About the Applicant

**Zakir Jiwani** | GitHub: [JiwaniZakir](https://github.com/JiwaniZakir) | EST

I'm a CS student who builds at the intersection of AI systems and production infrastructure. My relevant experience:

**AI/Protocol Systems:**
- Built **lattice**, a multi-agent framework with safety guarantees using LangGraph and DSPy — directly relevant to MCP protocol design
- Implemented RAG evaluation pipelines with **spectra** using LangChain and GraphRAG
- Deep familiarity with how LLM tool-use and function-calling protocols work

**TypeScript/Node.js:**
- Built **sentinel**, a Slack community bot in Node.js 20 with 209 tests — mirrors the TypeScript + testing stack in Accord
- Full-stack TypeScript development on **Partnerships_OS** (Turborepo/pnpm monorepo) — matches Accord's monorepo architecture

**Testing & Quality:**
- 338 tests across **aegis** (Python/FastAPI/Celery) — deep experience designing test suites for API servers
- Strong emphasis on typed error handling and validation in all my projects

**Open Source:**
- Active contributions to **openclaw** (TypeScript, AI assistant gateway) — directly comparable to MCP server work

**Why Accord + MCP Specifically:**
I've been watching MCP adoption accelerate. Accord Project is the most technically interesting application of MCP I've seen — legal contracts as a protocol layer for AI. The hardening project solves a real gap: right now the MCP surface is too fragile for developers to rely on it. Making it production-ready unlocks an entire ecosystem. That's the kind of foundational work I want to do.

**Commitment:** Full-time for 12 weeks. Responsive on Discord and GitHub daily. Contributing before the proposal deadline to demonstrate this isn't just words.

---

## Risk Mitigation

| Risk | Mitigation |
|------|-----------|
| MCP spec changes during project | Pin to MCP v1.0+; coordinate with Dan Selman on protocol direction |
| Test framework complexity | Start with simplest test cases; build complexity incrementally |
| Scope creep on documentation | Prioritize Integration Guide + 2 tutorials; 3rd tutorial is stretch |
| 12-week timeline slippage | Buffer week 6 specifically designed for iteration and catch-up |

---

## Questions for Mentors

1. **MCP server repository:** Is the MCP implementation in the main APAP repo or a separate package?
2. **Testing precedent:** Are there existing system tests I should model? Which test file best represents the current pattern?
3. **Priority of new MCP tools:** Of the 5 proposed new tools, which 2 would be most impactful for the community?
4. **Documentation format:** Preferred format for tutorials — MDX, plain Markdown, or integrated into existing docs site?

---

**Status:** Near-final draft — ready for mentor review
**Last Updated:** March 2026
**Submitted by:** Zakir Jiwani (JiwaniZakir)
