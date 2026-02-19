# Implement Feature Workflow

**Purpose:** Real-world iterative feature development. Supports quick ad-hoc features without a formal TSD, and resuming work on features already in the inventory.

**Architecture:** Bi-modal (New Feature OR Resume from Inventory)

---

## Critical Context

<critical>The workflow execution engine is governed by: {project-root}/.bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: workflow.yaml</critical>
<critical>This is a Frappe-specific workflow - Frappe bench awareness is MANDATORY</critical>

---

## Workflow Orchestration Pattern (BMAD v6)

This workflow follows BMAD v6 best practices:

- **Just-In-Time Loading**: Load step files only when needed, not upfront
- **Step Independence**: Each step is self-contained with its own instructions
- **State Management**: Track progress via session.yaml updates (project config stays in active.yaml)
- **Menu-Driven**: User controls flow at key decision points
- **Data Separation**: Reference materials in data/ folder, loaded JIT by steps
- **Bi-Modal**: Two distinct execution paths (New vs Resume) sharing common implementation steps

---

## MAKER Integration: Load Active Project State

**BEFORE proceeding, ensure project state is loaded:**

**Load project config:**
Read from: `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/active.yaml`
- `{{project}}` - Project name
- `{{app}}` - Current Frappe app
- `{{bench_path}}` - Path to Frappe bench

**Load session state:**
Read from: `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/session.yaml`
- `{{current_feature}}` - Current feature ID (if resuming)
- `{{current_component}}` - Current component being worked on
- `{{current_task}}` - Current task description
- `{{workflow}}` - Active workflow name (set to "implement-feature")
- `{{workflow_step}}` - Current step number
- `{{last_action}}` - Last action taken
- `{{next_action}}` - Next action to take

**Derived session variables:**
- `{{app}}` - Frappe app name (from active.yaml)
- `{{app_path}}` - Full path: `{{bench_path}}/apps/{{app}}`
- `{{docs_path}}` - Documents directory: `{{app_path}}/docs`

**Code Output Path:**
- All code: `{{app_path}}/{{app}}/`

---

## Mode Selection

Ask the user:

```
What would you like to do?

[N] New Ad-Hoc Feature   - Implement a new feature without a formal TSD
[R] Resume from Inventory - Continue work on an existing feature

Select mode:
```

**Wait for user input before proceeding.**

---

## Mode Routing

### If user selects [N] - New Feature

Update `session.yaml`:
```yaml
workflow: "implement-feature"
workflow_step: 1
current_task: "Gathering feature requirements"
updated: "[current timestamp]"
```

Load and execute: `steps-new/step-01-gather-requirements.md`

---

### If user selects [R] - Resume from Inventory

Update `session.yaml`:
```yaml
workflow: "implement-feature"
workflow_step: 1
current_task: "Selecting feature from inventory"
updated: "[current timestamp]"
```

Load and execute: `steps-resume/step-01-select-feature.md`

---

## Workflow Steps Overview

### Mode: New Feature (steps-new/)
1. **Gather Requirements** - Interactive requirements gathering from user
2. **Quick Spec** - Create lightweight feature spec (no formal TSD needed)
3. **Identify Components** - Identify DocTypes, scripts, reports, APIs to build
4. **Implement Server** - Implement server-side business logic
5. **Implement Client** - Implement client-side UI behavior (minimal)
6. **Deploy** - Write files + bench build + migrate + clear cache
7. **Validate** - Run tests + scan for anti-patterns
8. **Complete** - State update + completion report

### Mode: Resume from Inventory (steps-resume/)
1. **Select Feature** - Display feature inventory, user selects which to resume
2. **Load Context** - Load feature state and understand where work left off
3. **Identify Components** - Identify remaining components (adapted from spec)
4. **Implement Server** - Implement server-side business logic
5. **Implement Client** - Implement client-side UI behavior (minimal)
6. **Deploy** - Write files + bench build + migrate + clear cache
7. **Validate** - Run tests + scan for anti-patterns
8. **Complete** - State update + completion report

---

## Step Transitions

Each step file includes:
- **Frontmatter** - Step metadata (name, description, variables)
- **MANDATORY EXECUTION RULES** - Critical constraints
- **Step Instructions** - What to do
- **Menu Options** - Where appropriate
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

**→ Wait for user mode selection [N/R], then load appropriate step-01.**
