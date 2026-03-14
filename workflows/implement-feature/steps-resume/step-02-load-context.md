---
name: "Load Feature Context"
step: 2
mode: "resume"
description: "Load the selected feature's state file and understand where work left off"
variables:
  - feature_context
  - remaining_components
  - last_completed_step
  - resume_point
---

# Step 2: Load Feature Context

**Goal:** Load the selected feature's full state, understand progress so far, and establish the resume point.

---

## MANDATORY EXECUTION RULES

<critical>
- Read the feature yaml file fully
- Understand which components are done vs remaining
- Identify the last completed workflow step
- Summarise progress clearly for the user
- Ask user to confirm the resume point before proceeding
- DO NOT skip components that are already completed
</critical>

---

## Session Variables (Available)

From Step 1:
- `{{selected_feature_id}}` - Feature ID chosen
- Feature detail yaml loaded

---

## Step Instructions

### 1. Parse Feature State File

Read `state/{{active_project}}/features/{{selected_feature_id}}.yaml`.

Extract:
- **Feature type** (ad-hoc, doctype, report, etc.)
- **Status** (planned, in-progress, completed, on-hold)
- **Spec/TSD path** (if any)
- **Components** with their individual statuses
- **Progress** (completed/total counts)
- **Notes** - any context from previous sessions

Also check `session.yaml` for:
- `last_action` - what was done last
- `next_action` - what was planned next
- `workflow_step` - last recorded step

### 2. Present Progress Summary

Display clearly to the user:

```
RESUMING FEATURE: {{selected_feature_id}}
==========================================

Feature: [Feature Name or description]
Type: [ad-hoc / doctype / report / etc.]
Started: [date]
Spec: [path or "No formal spec"]

COMPONENTS STATUS
-----------------
✓ Completed:
  • [Component 1] - [status details]
  • [Component 2] - [status details]

⏳ In Progress:
  • [Component 3] - [last known state]

○ Remaining:
  • [Component 4] - not started
  • [Component 5] - not started

PROGRESS: [X] / [Y] components ([Z]%)

LAST SESSION NOTES:
  Last action: [last_action from active.yaml]
  Planned next: [next_action from active.yaml]
```

### 3. Load Spec or Context (if available)

**If a spec file exists:**
```
Loading spec from: [spec path]
```
Read the spec to refresh understanding of the full feature requirements.

**If context.md exists** (`state/{{active_project}}/context.md`):
```
Loading session context from: context.md
```
Read to understand implementation decisions made in previous sessions.

**If neither exists:**
Work from the feature yaml alone — ask user to clarify any gaps.

### 4. Confirm Resume Point

Ask the user:

```
Based on the state file, it looks like the best place to resume is:
→ Step [X]: [Step name] — [reason, e.g., "scaffolding was done, ready for server logic"]

Would you like to:
[C] Continue from Step [X] (recommended)
[O] Start from a different step (specify which)
[S] Start from scratch (Step 3 - Identify)
```

Wait for response.

### 5. Set Resume Variables

Based on user's choice, store:
- `{{resume_step}}` - which step to load next
- `{{remaining_components}}` - components still to be built

---

## Success Criteria

- ✅ Feature state file fully parsed
- ✅ Progress clearly presented to user
- ✅ Spec/context loaded if available
- ✅ Resume point confirmed by user
- ✅ Remaining components identified

---

## Update State

Update `session.yaml`:
```yaml
workflow_step: 2
current_feature: "{{selected_feature_id}}"
current_task: "Loaded context for {{selected_feature_id}}, ready to resume"
last_action: "Loaded feature context, resuming from step {{resume_step}}"
next_action: "Resume implementation from step {{resume_step}}"
updated: "[current timestamp]"
```

---

## Next Step

Based on user's confirmed resume point:

**→ Load and execute the appropriate step:**

- Resume from Identify → `steps-resume/step-03-identify.md`
- Resume from Scaffold → `steps-resume/step-04-scaffold.md`
- Resume from Server → `steps-resume/step-05-implement-server.md`
- Resume from Client → `steps-resume/step-06-implement-client.md`
- Resume from Deploy → `steps-resume/step-07-deploy.md`
- Resume from Validate → `steps-resume/step-08-validate.md`
- Resume from Complete → `steps-resume/step-09-complete.md`

Default (if unsure): `steps-resume/step-03-identify.md`

---
## ⛔ STATE GATE — Required before proceeding

**Do not load the next step file until the write below is confirmed.**

**Write `state/{{active_project}}/session.yaml`:**
```yaml
workflow: "implement-feature"
workflow_step: 2
workflow_status: "in-progress"
last_action: "Loaded context for {{selected_feature_id}}, resume point confirmed at step {{resume_step}}"
next_action: "Resume implementation from step {{resume_step}}"
updated: "{{ISO timestamp}}"
```

**If the write fails → HALT. Report the failure. Do not proceed.**
