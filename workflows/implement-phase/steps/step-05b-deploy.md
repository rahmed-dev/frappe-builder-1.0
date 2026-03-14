---
name: "Deploy Code to Frappe Bench (Part B)"
step: "5b"
description: "Migrate database, clear cache, restart bench and verify deployment"
variables:
  - migration_result
  - cache_cleared
---

# Step 5b: Deploy — Migrate, Clear Cache & Verify

---

## MANDATORY EXECUTION RULES

<critical>
- STOP if migration fails — DO NOT proceed to testing
- STOP if bench restart fails — DO NOT proceed
- Report all errors with file/line references
</critical>

---

### Phase C: Migrate Database

#### 7. Run bench migrate

**Command:**
```bash
cd {{bench_path}}
bench --site {{default_site}} migrate
```

**Watch for errors:**
- Duplicate column errors
- Invalid JSON in DocType definition
- Missing dependencies (other DocTypes, modules)
- Data integrity violations
- Foreign key constraint failures

**Common Migration Errors:**

**A. Duplicate Column:**
```
Error: Duplicate column name 'field_name'
```
→ Field already exists, check if DocType was modified before

**B. Invalid JSON:**
```
Error: Invalid JSON in DocType definition
```
→ Check DocType JSON file for syntax errors

**C. Missing Dependency:**
```
Error: DocType 'Parent DocType' not found
```
→ Ensure all linked DocTypes exist

**If migration fails:**
- Capture full error message, identify the problematic DocType
- Report to user with details, offer to fix
- DO NOT proceed until migration succeeds

---

### Phase D: Clear Cache and Restart

#### 8. Clear cache

```bash
cd {{bench_path}}
bench --site {{default_site}} clear-cache
```

#### 9. Restart bench

```bash
cd {{bench_path}}
bench restart
```

---

## Deployment Summary

```
DEPLOYMENT SUMMARY
==================

Files Written: [X] files
├─ DocTypes: [X]
├─ Controllers: [X]
├─ Client Scripts: [X]
├─ API Module: [1]
├─ Reports: [X]
└─ Workflows: [X]

Build Status:      [SUCCESS ✓ / FAILED ✗]
Migration Status:  [SUCCESS ✓ / FAILED ✗]
Cache Cleared:     [YES ✓]
Bench Restarted:   [YES ✓]

Code Location: {{app_path}}/{{app}}/
```

---

## Error Handling

**If deployment fails at any stage:**
1. Stop the workflow immediately
2. Report the error clearly with file/line references
3. Offer to fix the error
4. Retry the failed step after fix
5. DO NOT skip to next step until current step succeeds

---

## Menu

**Deployment completed successfully?**

**[A]** Auto-continue to Step 6 (Validate & Test)
**[P]** Pause here (manually verify deployment before testing)
**[C]** Cancel workflow

**Deployment failed?**

**[F]** Fix errors and retry deployment
**[C]** Cancel workflow

---

## Success Criteria

- ✅ All files written to correct paths
- ✅ Bench build completed without errors
- ✅ Bench migrate completed without errors
- ✅ Cache cleared successfully
- ✅ Bench restarted successfully

---

## Update State

Update `session.yaml`:
```yaml
workflow_step: 5
current_task: "Deployed code to Frappe bench"
last_action: "Deployed [X] files, build successful, migration successful"
next_action: "Run tests and validate anti-patterns"
updated: "[current timestamp]"
```

---

## Next Step

**If [A]uto-continue:**
**→ Load and execute:** `steps/step-06-validate.md`

**If [P]ause:**
STOP here. User can manually verify deployment.

**If [C]ancel:**
EXIT workflow. Update state and preserve progress.

**If [F]ix and retry:**
Fix errors, then re-run Phase B, C, or D as needed.

---
## ⛔ DEPLOY GATE — Required before proceeding

**Do not proceed until state is written.**

**Ask the user:**
> "Is this phase complete, or is there more work remaining?
> [C] Complete — mark done and update inventory
> [M] More work — record progress, stay in-progress"

---

**If [C] — Complete:**

Write `state/{{active_project}}/session.yaml`:
```yaml
workflow: "implement-phase"
workflow_step: 5
workflow_status: "completed"
last_action: "Deployed phase components — marked complete"
next_action: "Manual UI testing, then next phase or feature"
updated: "{{ISO timestamp}}"
```

Update `state/{{active_project}}/features/{{feature_id}}.yaml`:
```yaml
# All components:
status: "completed"
progress: "N/N"
notes: "Deployed and complete. Tests: manual."
completed: "{{today's date}}"
```

Update `state/{{active_project}}/inventory.yaml`:
```yaml
features:
  {{feature_id}}:
    status: "completed"
    progress: "N/N"
    notes: "Deployed and complete."
```

---

**If [M] — More work:**

Write `state/{{active_project}}/session.yaml`:
```yaml
workflow: "implement-phase"
workflow_step: 5
workflow_status: "deployed"
last_action: "Deployed phase components — more work remaining"
next_action: "Continue implementation in next session"
updated: "{{ISO timestamp}}"
```

Update `state/{{active_project}}/features/{{feature_id}}.yaml`:
```yaml
# Deployed components only:
status: "in-progress"
progress: "X/N"   # only count components fully done
notes: "Partially complete. Remaining: {{what is left}}."
```

Update `state/{{active_project}}/inventory.yaml`:
```yaml
features:
  {{feature_id}}:
    status: "in-progress"
    progress: "X/N"
    notes: "Partially complete. Remaining: {{what is left}}."
```

**If any write fails → HALT. Report the failure. Do not proceed.**
