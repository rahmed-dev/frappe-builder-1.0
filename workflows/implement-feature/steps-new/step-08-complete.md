---
name: "Complete Feature Implementation"
step: 8
mode: "new"
description: "Update state and deliver brief completion report"
variables:
  - completion_summary
  - state_updated
---

# Step 9: Complete

**Goal:** Update all state files and give the user a concise completion report.

---

## MANDATORY EXECUTION RULES

<critical>
- Update session.yaml, features/{id}.yaml, and inventory.yaml before reporting
- Report must be brief: components built, deploy status, test result
- Surface any unresolved issues clearly
</critical>

---

## Step Instructions

### 1. Update State

Update `session.yaml`:
```yaml
workflow: "implement-feature"
workflow_step: 8
workflow_status: "completed"
current_feature: "{{feature_id}}"
current_task: "Feature implementation complete"
last_action: "Completed {{feature_name}} - [X] components deployed and tested"
next_action: "Test manually in UI, generate tests, create user docs"
specialist: "frappe-dev"
updated: "[current timestamp]"
```

Update `features/{{feature_id}}.yaml`:
```yaml
status: "completed"
completed: "[today's date]"
notes: "Implementation complete. Tests: [X/Y passed]. Quality: [status]."
```

Update `inventory.yaml`:
```yaml
features:
  {{feature_id}}:
    status: "completed"
    progress: "8/8"
    notes: "Done. [X] components."
```

---

### 2. Completion Report

```
DONE: {{feature_name}}

Components: [X] DocTypes | [Y] Scripts | [Z] Reports
Deploy:     Build ✓  Migration ✓  Cache ✓
Tests:      [X/Y passed]
Issues:     [None / list critical ones]

Next:
  Test in UI → /bmad-frappe-builder-generate-tests → /bmad-frappe-builder-create-guide
```

---

## Workflow Complete

Return control to user or invoking agent.

---
## ⛔ STATE GATE — Required before completing (aspirational — step-06 deploy gate handles the common case)

**Do not confirm workflow complete until all writes below are confirmed.**

**1. Write `state/{{active_project}}/session.yaml`:**
```yaml
workflow: "implement-feature"
workflow_step: 8
workflow_status: "completed"
last_action: "Completed {{feature_name}} — [X] components deployed and tested"
next_action: "Test manually in UI, generate tests, create user docs"
updated: "{{ISO timestamp}}"
```

**2. Update `state/{{active_project}}/features/{{feature_id}}.yaml`:**
```yaml
status: "completed"
progress: "N/N"
completed: "{{today's date}}"
notes: "Implementation complete. Tests: [X/Y passed]. Quality: [status]."
```

**3. Mirror to `state/{{active_project}}/inventory.yaml` — status changed to completed:**
```yaml
features:
  {{feature_id}}:
    status: "completed"
    progress: "N/N"
    notes: "Implementation complete. Tests: [X/Y passed]."
```

**If any write fails → HALT. Report the failure. Do not proceed.**
