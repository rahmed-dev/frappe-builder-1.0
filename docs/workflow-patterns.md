# Workflow Patterns
# Frappe-Builder | Internal Reference

## Two Workflow Tiers

Frappe-Builder has 12 workflows split across two architectural patterns:

| Pattern | Workflows | When to Use |
|---------|-----------|-------------|
| **Full step-file** (BMAD v6) | implement-feature, implement-phase | Multi-session, multi-phase code generation |
| **Lightweight instructions.md** | All other 10 workflows | Single-pass document generation |

---

## Pattern 1: Full Step-File Architecture (BMAD v6)

### Used by: implement-feature, implement-phase

These two workflows use the full BMAD v6 step-based architecture: a `workflow.yaml` manifest, a `workflow.md` orchestrator, and a `steps/` folder with numbered micro step-files.

**Why step-files for these two:**

1. **Multi-session duration** — A full implementation can span 5–10 conversations. Step files provide exact resume points. `session.yaml` stores `workflow_step: N` and the workflow resumes at that exact file.

2. **Complex branching** — Implementation workflows have menus at each step ([A]uto-continue / [P]ause / [F]ix / [C]ancel). Step files make this branching explicit and navigable.

3. **Size management** — Implementation guidance is large. A single file would be unusable. Step files keep each concern under 250 lines and load JIT (just-in-time), reducing context overhead.

4. **Parallel data loading** — Steps reference `data/` files (server-patterns.md, client-patterns.md, anti-patterns-checklist.md) loaded only when the relevant step runs — not all upfront.

5. **Part-B splitting** — Some steps are naturally two-part (e.g., implement-server has controller logic AND frappe.utils patterns). These split into `step-NNa` + `step-NNb` files, each under the 250-line limit.

### implement-feature structure

```
implement-feature/
├── workflow.yaml         # Manifest (step_count: 8, steps_new, steps_resume)
├── workflow.md           # Orchestrator
├── steps/
│   ├── step-01-gather-requirements.md   (new mode)
│   ├── step-01-select-feature.md        (resume mode)
│   ├── step-02-quick-spec.md / step-02-load-context.md
│   ├── step-03-identify.md              (shared)
│   ├── step-04-implement-server.md      (shared)
│   ├── step-05-implement-client.md      (shared)
│   ├── step-06-deploy.md                (shared)
│   ├── step-07-validate.md              (shared)
│   └── step-08-complete.md              (shared)
└── data/
    ├── server-patterns.md
    ├── client-patterns.md
    └── anti-patterns-checklist.md
```

**Bi-modal design:** Two entry paths (new feature vs resume from inventory) converge at step-03 and share steps 3–8. This avoids duplicating the implementation steps while allowing different context-loading at the start.

### implement-phase structure

```
implement-phase/
├── workflow.yaml         # Manifest (step_count: 11)
├── workflow.md           # Orchestrator
├── steps/
│   ├── step-01-load-tsd.md
│   ├── step-02-identify.md
│   ├── step-03-implement-server.md      ─┐ split pair
│   ├── step-03b-implement-server.md     ─┘
│   ├── step-04-implement-client.md      ─┐ split pair
│   ├── step-04b-implement-client.md     ─┘
│   ├── step-05-deploy.md                ─┐ split pair
│   ├── step-05b-deploy.md               ─┘
│   ├── step-06-validate.md              ─┐ split pair
│   ├── step-06b-validate.md             ─┘
│   └── step-07-complete.md
└── data/
    ├── scaffolding-patterns.md
    ├── server-patterns.md
    ├── client-patterns.md
    └── anti-patterns-checklist.md
```

**TSD-only design:** implement-phase is single-modal (no resume path) — it always starts from a TSD. It is designed for formal, planned projects where a full TSD exists before implementation begins.

**vs implement-feature:** implement-feature is designed for agile, feature-by-feature development with lighter spec requirements. implement-phase is for structured delivery from complete specs.

---

## Pattern 2: Lightweight Instructions.md

### Used by: 10 other workflows

```
workflow-name/
├── workflow.yaml     # Manifest (template: true, instructions: workflow.md)
└── workflow.md       # Full instructions in one file
```

No `steps/` folder. No data files. The entire workflow fits in one `workflow.md`.

**Why lightweight for these:**

1. **Single-pass output** — Document generation (BRD, TSD, roadmap, guide) completes in one conversation. No resume logic needed.

2. **No branching** — These workflows produce a document and finish. No [A]/[P]/[F]/[C] menus at each stage.

3. **Smaller scope** — Generating a BRD or user guide takes 1–3 prompts, not 7–11 steps.

4. **Lower cognitive overhead** — Agents running these workflows don't need step-tracking or JIT data loading. A single `workflow.md` with clear sections is sufficient.

### The 10 lightweight workflows

| Workflow | Agent | Output |
|----------|-------|--------|
| analyze-requirements | erpnext-ba | BRD |
| design-solution | frappe-architect | TSD |
| create-roadmap | frappe-planner | Roadmap |
| sequence-tasks | frappe-planner | Task sequence |
| generate-tests | qa-specialist | Test scenarios + unittest |
| create-guide | doc-writer | User guide |
| diagnose-issue | frappe-debugger | Diagnosis report |
| review-code | frappe-dev / frappe-debugger | Code review report |
| update-kb | any agent | KB entry |
| prepare-release | frappe-dev | Release checklist |

---

## Decision Rule: When to Use Each Pattern

Use **full step-file** when:
- The workflow involves code generation deployed to a real system
- Sessions may be interrupted and resumed mid-workflow
- The workflow has conditional branching at multiple points
- Total content exceeds ~300 lines

Use **lightweight instructions.md** when:
- The output is a document (markdown file), not code
- The workflow completes in a single session
- Linear execution with no branching
- Total instructions fit in ~200 lines
