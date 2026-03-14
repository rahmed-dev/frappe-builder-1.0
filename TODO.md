# Frappe-Builder Module TODO

## Module Architecture Documentation

- [x] Create `docs/` folder for internal module architecture and technical reference
  - [x] `docs/module-architecture.md` — Overall design decisions, why 8 agents, how they relate to each other
  - [x] `docs/state-management-design.md` — Rationale for custom 3-level state cascade (session → feature → inventory), design trade-offs vs BMAD sidecar
  - [x] `docs/agent-ecosystem-design.md` — Agent responsibilities, handoff protocol, orchestration model (Nexus as router)
  - [x] `docs/workflow-patterns.md` — Why implement-feature uses full step-file architecture while others use lightweight instructions.md pattern

## Pending

- [x] Validate module with agent sub-process deep validation (8 built agents)
- [x] Validate implement-feature and implement-phase workflows with workflow sub-process deep validation
- [x] Implement state cascade enforcement via blocking gates across all workflows (replaced MCP server approach — gates embedded directly in step files; deploy gate uses [C]/[M] prompt to capture completion state when step-08 is skipped)
