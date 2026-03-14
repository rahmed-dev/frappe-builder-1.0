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

## MCP State Enforcement Server

Build an MCP server to make state cascade reliable without prompt rules or human intervention.
Design documented in `docs/mcp-state-enforcement.md`.

- [ ] Build MCP server (Python or Node.js) with `complete_component(feature_id, component_id, notes)` tool
  - [ ] Tool writes `features/{feature_id}.yaml`, recalculates `progress X/Y`
  - [ ] Server cascades to `inventory.yaml` automatically — model never touches inventory
  - [ ] Tool response returns minimal confirmation only (`{ ok, updated }`) to avoid context bloat
- [ ] Write `PostToolUse` hook script — detects Write/Edit/Bash calls and updates `session.yaml` automatically
- [ ] Write checkbox diff hook — detects `[ ]` → `[x]` changes in feature files and triggers cascade (ad-hoc work fallback)
- [ ] Add `complete_component` workflow gate step to `implement-feature` workflow steps
- [ ] Wire MCP server into `claude-settings.json.template`
