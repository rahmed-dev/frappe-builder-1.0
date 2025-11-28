# Plan: [Project Name]
App: [app_name] | BRD: [path] | TSD: [path or "N/A"] | Date: [ISO]
Complexity: [Simple/Medium/Complex] | Token Budget: [1-5k/5-10k/10-15k]

## Summary
| Type | Range | Notes |
|------|-------|-------|
| User Tasks | u1:uX | Configuration (fields/workflows/roles) |
| Developer Tasks | d1:dY | Code (scripts/reports/dashboards/jobs) |
| QA/Docs (optional) | q1:qZ | Tests/docs if included |

## Project Context
**Goal:** [1-sentence primary objective]
**Users:** [Who will use this]
**Success:** [How to measure completion]

---

## Phase 1: [Goal One-Liner]

### User Tasks
- [ ] u1: DocType "[Name]" ([field1], [field2], [child_table]) | TSD: §[section]
- [ ] u2: Field on [DocType]: [field_name] ([Type]) | TSD: §[section]
- [ ] u3: Workflow: [DocType] ([State1→State2→State3]) | TSD: §[section]

### Dev Tasks
- [ ] d4: Validation - [rule] | TSD: §[section]
- [ ] d5: Calc - [what] | TSD: §[section]
- [ ] d6: Client - [behavior] | TSD: §[section]
- [ ] d7: Server - [trigger action] | TSD: §[section]

**Complete when:** [Observable outcome]
**Acceptance:** [How to validate phase success]

---

## Phase 2: [Goal]

### Dev Tasks
- [ ] d8: Report - [what data] | TSD: §[section]
- [ ] d9: Dashboard - [metrics] | TSD: §[section]
- [ ] d10: Background - [scheduled task] | TSD: §[section]

**Complete when:** [Observable outcome]
**Acceptance:** [How to validate]

---

## Phase 3: [Goal]
(Follow same format)

---

## Dependencies

| Task | Needs | Why | Blocker Risk |
|------|-------|-----|--------------|
| d5 | u2 | Field must exist first | Medium |
| d10 | d4-d9 | Core features before automation | Low |

---

## Task Ranges

| Specialist | Phase 1 | Phase 2 | Phase 3 | Total Tasks |
|------------|---------|---------|---------|-------------|
| User | u1:u3 | - | - | 3 |
| Dev | d4:d7 | d8:d10 | d11:d15 | 12 |
| QA | - | q1:q3 | - | 3 |

---

## TSD Section Mapping

**Format:** Task ID → TSD Section Reference

| Task | TSD Section | Topic | Est. Tokens |
|------|-------------|-------|-------------|
| d4 | §3.2.1 | Validation rules | ~150 |
| d5 | §3.2.2 | Calculation logic | ~200 |
| d6 | §3.3.1 | Client-side behavior | ~180 |
| d7 | §3.4.1 | Server-side automation | ~220 |

**Usage:** Dev loads only relevant TSD section per task (not entire TSD)

---

## Critical Decisions

| Decision | Options Considered | Chosen | Rationale |
|----------|-------------------|--------|-----------|
| [Key decision 1] | [A, B, C] | [B] | [Why B] |

---

## Risk Mitigation

| Risk | Impact | Mitigation | Owner |
|------|--------|------------|-------|
| [Risk 1] | High/Med/Low | [How to handle] | [Specialist] |

---

## Token Budget Tracking

**Plan Complexity:** [Simple/Medium/Complex]

| Component | Simple | Medium | Complex |
|-----------|--------|--------|---------|
| Base structure | <1k | <2k | <3k |
| Task definitions | <2k | <3k | <5k |
| Dependencies + mapping | <1k | <2k | <3k |
| Decisions + risks | <1k | <2k | <4k |
| **Total Target** | **<5k** | **<9k** | **<15k** |

---

## Notes
- Dev works autonomously through ranges
- Updates checkboxes as completes
- Returns to Nexus when range complete or blocked
- Uses `/context` to monitor token usage
- Restarts session if context >30k tokens
