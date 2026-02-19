---
name: "Complete Implementation"
step: 7
description: "Update state and deliver brief completion report"
variables:
  - completion_summary
  - state_updated
---

# Step 8: Complete

**Goal:** Update all state files and give the user a concise completion report.

---

## MANDATORY EXECUTION RULES

<critical>
- Update session.yaml and inventory.yaml before reporting
- Report must be brief: components built, deploy status, test result
- Surface any unresolved issues clearly
</critical>

---

## Step Instructions

### 1. Update State

Update `session.yaml`:
```yaml
workflow: "implement-phase"
workflow_step: 7
workflow_status: "completed"
current_feature: "{{feature_name}}"
current_task: "Implementation complete"
last_action: "Completed {{feature_name}} - [X] components deployed and tested"
next_action: "Test manually in UI, generate tests, create user documentation"
specialist: "frappe-dev"
updated: "[current timestamp]"
```

Update `inventory.yaml`:
```yaml
features:
  {{feature_id}}:
    status: "completed"
    progress: "7/7"
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
