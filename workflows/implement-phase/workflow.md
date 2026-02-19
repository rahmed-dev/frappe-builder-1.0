# Implement Phase Workflow

**Purpose:** Formal, phased development from Technical Specification Documents (TSD). For big, structured projects with proper planning and documentation.

**Architecture:** Single-modal (TSD-based only)

---

## Critical Context

<critical>The workflow execution engine is governed by: {project-root}/.bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: workflow.yaml</critical>
<critical>This is a Frappe-specific workflow - Frappe bench awareness is MANDATORY</critical>
<critical>You may use Claude Code skills if you find an appropriate one in the skill list for the current task.</critical>

---

## Workflow Orchestration Pattern (BMAD v6)

This workflow follows BMAD v6 best practices:

- **Just-In-Time Loading**: Load step files only when needed, not upfront
- **Step Independence**: Each step is self-contained with its own instructions
- **State Management**: Track progress via session.yaml updates (project config stays in active.yaml)
- **Menu-Driven**: User controls flow (Auto/Pause/Cancel at key decision points)
- **Data Separation**: Reference materials in data/ folder, loaded JIT by steps

---

## MAKER Integration: Load Active Project State

**BEFORE proceeding, ensure project state is loaded:**

**Load project config:**
Read from: `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/active.yaml`
- `{{project}}` - Project name
- `{{app}}` - Current Frappe app
- `{{site}}` - Active site
- `{{bench_path}}` - Path to Frappe bench

**Load session state:**
Read from: `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/session.yaml`
- `{{current_feature}}` - Current feature ID
- `{{current_component}}` - Current component being worked on
- `{{current_task}}` - Current task description
- `{{workflow}}` - Active workflow name
- `{{workflow_step}}` - Current step number
- `{{last_action}}` - Last action taken
- `{{next_action}}` - Next action to take

**Derived session variables:**
- `{{app}}` - Frappe app name (from active.yaml)
- `{{app_path}}` - Full path: `{{bench_path}}/apps/{{app}}`
- `{{docs_path}}` - Documents directory: `{{app_path}}/docs`

**Code Output Path:**
- All code: `{{app_path}}/{{app}}/`

**Benefits:**
- Lighter context (<200 tokens vs loading full memories)
- Always current state
- Quick project summary
- Task awareness

---

## Pre-Execution Validation

### 1. Check for TSD Path

**CRITICAL**: This workflow requires a Technical Specification Document (TSD).

Ask user: "Please provide the TSD path (e.g., `tsd/feature-name.md`):"

**If no TSD provided:**
- STOP execution
- Inform user: "This workflow requires a TSD. Use `/bmad-frappe-builder-implement-feature` for ad-hoc features without TSD."
- EXIT workflow

**If TSD provided:**
- Validate file exists
- Store path in `{{tsd_path}}`
- Update session.yaml: `tsd: {{tsd_path}}`
- Proceed to Step 1

---

## Workflow Execution

### Initialize Workflow State

Update `session.yaml`:
```yaml
workflow: "implement-phase"
workflow_step: 1
current_task: "Loading Technical Specification Document"
updated: "[current timestamp]"
```

---

### Route to Step 1

Load and execute: `steps/step-01-load-tsd.md`

**DO NOT load all steps upfront** - steps are loaded Just-In-Time as workflow progresses.

---

## Workflow Steps Overview

This workflow consists of 7 focused steps:

1. **Load TSD** - Load and understand Technical Specification Document
2. **Identify Components** - Identify DocTypes, scripts, reports, APIs to build
3. **Implement Server** - Implement server-side business logic
4. **Implement Client** - Implement client-side UI behavior (minimal)
5. **Deploy** - Write files + bench build + migrate + clear cache
6. **Validate** - Run tests + scan for anti-patterns
7. **Complete** - State update + completion report

---

## Step Transitions

Each step file includes:
- **Frontmatter** - Step metadata (name, description, variables)
- **MANDATORY EXECUTION RULES** - Critical constraints
- **Step Instructions** - What to do
- **Menu Options** - (A)uto-continue, (P)ause, (C)ancel where appropriate
- **Success Criteria** - How to know step completed
- **Next Step** - Explicit routing to next step file

**Navigation:**
- Steps route explicitly to next step
- Step files handle their own menu logic
- Workflow.md does NOT manage step flow after initial routing

---

## Data Files (Reference Materials)

Located in `data/` folder, loaded JIT by steps:

- **scaffolding-patterns.md** - DocType JSON, controller, report, API, client script templates
- **server-patterns.md** - Validation, hooks, frappe.utils, permissions, queries, API whitelisting
- **client-patterns.md** - frappe.ui.form.on, frappe.call, type conversion, buttons, dependencies
- **anti-patterns-checklist.md** - Common mistakes to avoid (SQL injection, missing @whitelist, etc.)

**DO NOT load data files now** - steps load them when needed.

---

## Frappe Bench Context

**CRITICAL**: This workflow operates in Frappe bench environment.

All bash commands assume:
- Frappe bench is at `{{bench_path}}`
- Active site is configured
- Current app is `{{app}}`

Commands will be executed from bench directory.

---

## Error Handling

If at any point:
- **Build fails** → Report error, offer to fix, retry
- **Migration fails** → Report error, offer to fix, retry
- **Tests fail** → Report failures, offer to fix specific tests
- **User cancels** → Update state, preserve progress, EXIT gracefully

---

## Next Action

**→ Load and execute:** `steps/step-01-load-tsd.md`
