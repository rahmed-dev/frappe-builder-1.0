# Module Architecture
# Frappe-Builder | Internal Reference

## What This Module Is

Frappe-Builder is a BMAD extension module that provides a complete AI-assisted SDLC ecosystem for Frappe/ERPNext development. It installs 8 specialized agents and 12 workflows into a BMAD-powered Claude Code workspace.

The core idea: instead of one general-purpose agent handling all development tasks, each phase of the SDLC has a dedicated specialist with domain-specific knowledge, vocabulary, and output formats.

---

## Why 8 Agents

The number maps directly to the SDLC phases of a Frappe project, with one extra for orchestration and one for debugging:

| # | Agent | Phase | Output |
|---|-------|-------|--------|
| 1 | frappe-nexus | Orchestration / Routing | Routing decisions, project orientation |
| 2 | erpnext-ba | Requirements (Phase 1) | BRD (Business Requirements Document) |
| 3 | frappe-architect | Design (Phase 2) | TSD (Technical Specification Document) |
| 4 | frappe-planner | Planning (Phase 3) | Roadmap, feature sequence, task breakdown |
| 5 | frappe-dev | Implementation (Phase 4) | Code: DocTypes, controllers, scripts, APIs |
| 6 | frappe-debugger | Debugging (anytime) | Root cause analysis, fix recommendations |
| 7 | qa-specialist | Testing (Phase 5) | Test scenarios, unittest code |
| 8 | doc-writer | Documentation (Phase 6) | User guides, quick-reference cards |

**Why not more or fewer?**
- Fewer would mean one agent doing too much (losing domain focus)
- More would fragment tasks too granularly (e.g., separate agents for DocType vs API)
- 8 maps cleanly to the natural hand-off points in a Frappe project

---

## Module Structure

```
frappe-builder/
├── module.yaml                  # BMAD module manifest
├── module-help.csv              # BMAD installer registry (20 entries)
├── config.yaml                  # User config template (bench path, site, language)
├── TODO.md                      # Internal task tracking
│
├── agents/                      # 8 agent definition files
│   ├── frappe-nexus.agent.yaml
│   ├── erpnext-ba.agent.yaml
│   ├── frappe-architect.agent.yaml
│   ├── frappe-planner.agent.yaml
│   ├── frappe-dev.agent.yaml
│   ├── frappe-debugger.agent.yaml
│   ├── qa-specialist.agent.yaml
│   └── doc-writer.agent.yaml
│
├── workflows/                   # 12 workflows
│   ├── implement-feature/       # Full step-file arch (8 new + 8 resume steps)
│   ├── implement-phase/         # Full step-file arch (11 steps)
│   └── [10 others]/             # Lightweight instructions.md pattern
│
├── standards/                   # Shared behavioral contracts
│   └── state-management.md      # 3-level cascade protocol (authoritative)
│
├── state/                       # Runtime state (per project, per session)
│   ├── active-project.txt
│   ├── templates/
│   └── {project-name}/
│       ├── active.yaml
│       ├── session.yaml
│       ├── inventory.yaml
│       ├── decisions.yaml
│       └── features/
│
├── knowledge/                   # Agent KB files (loaded JIT)
└── docs/                        # Internal architecture reference (this folder)
```

---

## Key Design Decisions

**1. Specialists over generalists**
Each agent has a narrow domain. The BA doesn't know how to code; the Dev doesn't write BRDs. This keeps agents focused and reduces prompt drift.

**2. Nexus as thin router, not fat controller**
Nexus routes users to the right specialist but does not execute SDLC tasks itself. It holds context and coordinates handoffs. This prevents Nexus from becoming a bottleneck.

**3. Custom state instead of BMAD sidecar**
See `docs/state-management-design.md` for full rationale.

**4. Two-tier workflow architecture**
Two action workflows use full BMAD v6 step-file architecture (for complex, multi-step code generation). Ten documentation workflows use lightweight `instructions.md` (for single-pass document generation). See `docs/workflow-patterns.md`.

**5. hasSidecar: false for all agents**
All agents use the custom 3-level state cascade instead of BMAD's sidecar system. hasSidecar is declared false on all 8 agents to make this explicit.
