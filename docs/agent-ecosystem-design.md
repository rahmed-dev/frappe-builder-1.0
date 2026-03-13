# Agent Ecosystem Design
# Frappe-Builder | Internal Reference

## Overview

8 agents, one orchestrator, a clean handoff chain. Each specialist owns one SDLC phase. Nexus routes between them and holds project-level context.

---

## Agent Responsibilities

### frappe-nexus — Orchestrator & Router

**Role:** Entry point for all user interactions. Does not execute SDLC tasks.

**Responsibilities:**
- Assess where the user is in their project
- Route to the correct specialist with an explanation of why
- Track handoffs in session.yaml (`specialist` field)
- Provide shortcuts to all 7 specialists via `*ba`, `*arch`, `*plan`, `*dev`, `*debug`, `*qa`, `*docs`
- Orchestrate full-cycle flows (`*full-cycle`, `*quick-build`, `*troubleshoot`)

**What it does NOT do:** Write BRDs, design DocTypes, generate code, write tests, create user guides.

---

### erpnext-ba — Business Analyst (Phase 1)

**Role:** Converts business requirements into structured BRDs.

**Specialization:** ERPNext-first thinking — maps every requirement to Standard/Configure/Custom before recommending custom code. Knows ERPNext modules (Accounting, HR, Assets, Manufacturing, etc.) deeply.

**Input:** Messy business requirements from stakeholder conversation.
**Output:** Business Requirements Document (BRD) with gap analysis and build recommendations.

**Hands off to:** frappe-architect (BRD → TSD)

---

### frappe-architect — Solution Architect (Phase 2)

**Role:** Translates BRD into technical design.

**Specialization:** Frappe 4-tier framework (Standard → Configure → Scripts → Custom). Designs DocType structures, UX using Frappe native components, API contracts, workflow states.

**Input:** BRD from ERPNext BA.
**Output:** Technical Specification Document (TSD) with full component inventory and implementation guidance.

**Hands off to:** frappe-planner (TSD → sequenced roadmap)

---

### frappe-planner — Implementation Planner (Phase 3)

**Role:** Sequences the TSD into a buildable roadmap.

**Specialization:** Dependency analysis and parallel/sequential task identification. Divides work between User tasks (configuration in ERPNext UI) and Developer tasks (code).

**Input:** TSD from Frappe Architect.
**Output:** Feature roadmap with phased delivery and dependency-aware sequencing.

**Hands off to:** frappe-dev (roadmap → code)

---

### frappe-dev — Developer (Phase 4)

**Role:** Implements code from TSD/roadmap.

**Specialization:** Frappe-native code — DocTypes (JSON), controllers (Python), client scripts (JavaScript), APIs (`@frappe.whitelist()`), reports, scheduled jobs. Production-ready, parameterized, permission-checked.

**Input:** TSD and feature roadmap.
**Output:** Working code deployed to the Frappe bench.

**Hands off to:** qa-specialist (code → tests) or frappe-debugger (errors)

---

### frappe-debugger — Debugger (anytime)

**Role:** Diagnoses errors and catches anti-patterns.

**Specialization:** Frappe error log analysis, Python tracebacks, JavaScript console errors, common Frappe-specific failure modes (migration errors, permission errors, hook failures).

**Input:** Error messages, logs, or suspicious code.
**Output:** Root cause diagnosis and specific fix recommendations.

**Hands off to:** frappe-dev (fix implementation) or frappe-architect (if the error reveals a design flaw)

**Note:** The Debugger is available at any phase — not just after implementation.

---

### qa-specialist — QA & Testing (Phase 5)

**Role:** Generates test coverage for implemented features.

**Specialization:** Thinks like a real-world user — lazy, mistake-prone, edge-case-generating. Creates manual test scenarios and Frappe `unittest` code.

**Input:** Implemented feature (DocTypes, APIs, workflows).
**Output:** Test scenario checklist and Python unittest files.

**Hands off to:** frappe-dev (if tests reveal bugs) or doc-writer (feature is tested, ready to document)

---

### doc-writer — Documentation (Phase 6)

**Role:** Creates end-user documentation.

**Specialization:** ERPNext UI terminology (DocType not "form", Submit not "approve", Desk not "dashboard"). Anti-fluff 2–3 page guides. Task-oriented, active voice, no jargon.

**Input:** TSD or feature description.
**Output:** User guide (`.md`) and quick-reference card.

---

## Handoff Protocol

```
User Request
     │
     ▼
frappe-nexus  ──routes──▶  erpnext-ba
                                │ BRD
                                ▼
                          frappe-architect
                                │ TSD
                                ▼
                          frappe-planner
                                │ Roadmap
                                ▼
                          frappe-dev  ◀──────── frappe-debugger
                                │ Code              ▲ errors
                                ▼                   │
                          qa-specialist  ───bugs────┘
                                │ Tests pass
                                ▼
                          doc-writer
                                │ Guide
                                ▼
                          Done
```

**State at each handoff:**
- The handing-off agent writes `session.yaml` with `specialist: [target-agent]`, `last_action`, `next_action`
- The receiving agent loads `session.yaml` on activation and resumes from that context
- No verbal handoff is required — state is the handoff

---

## Agent Type Classification

| Agent | Type | Reasoning |
|-------|------|-----------|
| frappe-nexus | Primary / Orchestrator | Entry point, routes and coordinates |
| erpnext-ba | Specialist | Phase-specific, deep domain knowledge |
| frappe-architect | Specialist | Phase-specific, deep domain knowledge |
| frappe-planner | Specialist | Phase-specific, deep domain knowledge |
| frappe-dev | Specialist | Phase-specific, deep domain knowledge |
| frappe-debugger | Specialist | Cross-phase, triggered by errors |
| qa-specialist | Utility | Phase-specific but also ad-hoc use |
| doc-writer | Utility | Phase-specific but also ad-hoc use |
