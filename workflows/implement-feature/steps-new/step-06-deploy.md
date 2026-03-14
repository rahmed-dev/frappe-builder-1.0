---
name: "Deploy Code to Frappe Bench"
step: 6
mode: "new"
description: "Write files, build assets, migrate database, and clear cache"
variables:
  - files_written
  - build_result
  - migration_result
  - cache_cleared
---

# Step 7: Deploy Code to Frappe Bench

**Goal:** Write all code to files, build, migrate, and prepare for testing.

---

## MANDATORY EXECUTION RULES

<critical>
- Write files to CORRECT paths following Frappe conventions
- Verify file writes succeed before proceeding
- Run bench build and check for JS/CSS errors
- Run bench migrate and watch for schema errors
- Clear cache and restart to ensure changes are loaded
- STOP if build or migration fails - DO NOT proceed to testing
</critical>

---

## Session Variables (Available)

- `{{bench_path}}` - Path to Frappe bench
- `{{app}}` - Frappe app name
- `{{app_path}}` - Full path: `{{bench_path}}/apps/{{app}}`
- `{{default_site}}` - Default site name

---

## Step Instructions

### Phase A: Write Files to Frappe App

Write all implemented code to the correct file paths:

**DocType files:**
- JSON: `{{app_path}}/{{app}}/{{module}}/doctype/{{doctype_folder}}/{{doctype_name}}.json`
- Controller: `{{app_path}}/{{app}}/{{module}}/doctype/{{doctype_folder}}/{{doctype_name}}.py`
- Client Script: `{{app_path}}/{{app}}/{{module}}/doctype/{{doctype_folder}}/{{doctype_name}}.js`
- Init: `{{app_path}}/{{app}}/{{module}}/doctype/{{doctype_folder}}/__init__.py`

**API module:**
- `{{app_path}}/{{app}}/{{module}}/api.py`

**Reports:**
- `{{app_path}}/{{app}}/{{module}}/report/{{report_folder}}/{{report_name}}.py`
- `{{app_path}}/{{app}}/{{module}}/report/{{report_folder}}/{{report_name}}.json`

**Track files written:**
```
Files Written:
[ ] DocType JSON
[ ] Controller (Python)
[ ] Client Script (JavaScript)
[ ] API Module
[ ] Reports
[ ] Workflows
```

If any file write fails → report error, offer to retry, DO NOT proceed.

---

### Phase B: Build Assets

```bash
cd {{bench_path}}
bench build --app {{app}}
```

Watch for JS/CSS syntax errors. STOP if build fails — report error with file:line reference and offer to fix.

**Build status:**
```
Build Result: [SUCCESS / FAILED]
Duration: [X] seconds
Errors: [None or list]
```

---

### Phase C: Migrate Database

```bash
cd {{bench_path}}
bench --site {{default_site}} migrate
```

Watch for: duplicate columns, invalid JSON, missing dependencies.

STOP if migration fails — report error and offer to fix.

**Migration status:**
```
Migration Result: [SUCCESS / FAILED]
Duration: [X] seconds
Errors: [None or list]
```

---

### Phase D: Clear Cache and Restart

```bash
cd {{bench_path}}
bench --site {{default_site}} clear-cache
bench restart
```

---

## Deployment Summary

```
DEPLOYMENT SUMMARY
==================
Files Written: [X] total
Build Status: [SUCCESS ✓ / FAILED ✗]
Migration Status: [SUCCESS ✓ / FAILED ✗]
Cache Cleared: [YES ✓]
Bench Restarted: [YES ✓]
Code Location: {{app_path}}/{{app}}/
```

---

## Menu

**[A]** Auto-continue to Step 8 (Validate & Test)
**[P]** Pause here (manually verify deployment before testing)
**[F]** Fix errors and retry deployment
**[C]** Cancel workflow

---

## Success Criteria

- ✅ All files written to correct paths
- ✅ Bench build completed without errors
- ✅ Bench migrate completed without errors
- ✅ Cache cleared and bench restarted

---

## Update State

Update `session.yaml`:
```yaml
workflow_step: 6
current_task: "Deployed code to Frappe bench"
last_action: "Deployed [X] files, build successful, migration successful"
next_action: "Run tests and validate anti-patterns"
updated: "[current timestamp]"
```

---

## Next Step

**If [A]uto-continue:**
**→ Load and execute:** `steps-new/step-07-validate.md`

**If [P]ause:**
STOP here. User can manually verify deployment.

**If [F]ix and retry:**
Fix errors, then re-run failed phase.

**If [C]ancel:**
EXIT workflow. Update state and preserve progress.

---
## ⛔ DEPLOY GATE — Required before proceeding

**Do not proceed until state is written.**

**Ask the user:**
> "Is this feature complete, or is there more work remaining?
> [C] Complete — mark done and update inventory
> [M] More work — record progress, stay in-progress"

---

**If [C] — Complete:**

Write `state/{{active_project}}/session.yaml`:
```yaml
workflow: "implement-feature"
workflow_step: 6
workflow_status: "completed"
last_action: "Deployed {{feature_name}} — marked complete"
next_action: "Manual UI testing, then next feature"
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
workflow: "implement-feature"
workflow_step: 6
workflow_status: "deployed"
last_action: "Deployed {{feature_name}} — more work remaining"
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
