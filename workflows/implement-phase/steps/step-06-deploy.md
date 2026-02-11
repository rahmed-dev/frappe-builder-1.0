---
name: "Deploy Code to Frappe Bench"
step: 6
description: "Write files, build assets, migrate database, and clear cache"
variables:
  - files_written
  - build_result
  - migration_result
  - cache_cleared
---

# Step 6: Deploy Code to Frappe Bench

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
- `{{current_app}}` - Frappe app name
- `{{app_path}}` - Full path: `{{bench_path}}/apps/{{current_app}}`
- `{{default_site}}` - Default site name (from config or detect)

---

## Step Instructions

### Phase A: Write Files to Frappe App

#### 1. Write DocType Files

For each DocType implemented:

**A. DocType JSON:**
- Path: `{{app_path}}/{{current_app}}/{{module}}/doctype/{{doctype_folder}}/{{doctype_name}}.json`
- Ensure valid JSON structure
- Verify field definitions are correct

**B. DocType Controller (Python):**
- Path: `{{app_path}}/{{current_app}}/{{module}}/doctype/{{doctype_folder}}/{{doctype_name}}.py`
- Include proper imports
- Verify class name matches DocType name

**C. Client Script (JavaScript):**
- Path: `{{app_path}}/{{current_app}}/{{module}}/doctype/{{doctype_folder}}/{{doctype_name}}.js`
- Verify frappe.ui.form.on syntax

**D. `__init__.py`:**
- Path: `{{app_path}}/{{current_app}}/{{module}}/doctype/{{doctype_folder}}/__init__.py`
- Can be empty or import controller

#### 2. Write API Files

**API Module:**
- Path: `{{app_path}}/{{current_app}}/{{module}}/api.py`
- Verify all functions have @frappe.whitelist() decorator

#### 3. Write Report Files

For each report:

**A. Report Python:**
- Path: `{{app_path}}/{{current_app}}/{{module}}/report/{{report_folder}}/{{report_name}}.py`
- Verify execute(filters) function exists

**B. Report JSON:**
- Path: `{{app_path}}/{{current_app}}/{{module}}/report/{{report_folder}}/{{report_name}}.json`
- Contains report metadata

#### 4. Write Workflow Files

For each workflow:

**Workflow JSON:**
- Path: `{{app_path}}/{{current_app}}/{{module}}/workflow/{{workflow_name}}.json`
- Verify states and transitions are valid

#### 5. Verify All Files Written

Track file writes:

```
Files Written:
[✓] DocTypes: X files
[✓] Controllers: X files
[✓] Client Scripts: X files
[✓] API Module: 1 file
[✓] Reports: X files
[✓] Workflows: X files

Total: [X] files written successfully
```

**If any file write fails:**
- Report the error
- Show file path and error message
- Offer to retry
- DO NOT proceed until all files written

---

### Phase B: Build Assets

#### 6. Run bench build

**Command:**
```bash
cd {{bench_path}}
bench build --app {{current_app}}
```

**Watch for errors:**
- JavaScript syntax errors
- CSS compilation errors
- Asset bundling issues
- Webpack errors

**Expected output:**
```
✓ Built js/app.bundle.js
✓ Built css/app.bundle.css
```

**If build fails:**
- Capture full error message
- Identify the problematic file (usually shown in error)
- Report to user with file:line reference
- Offer to fix the error
- DO NOT proceed to migration until build succeeds

**Build status:**
```
Build Result: [SUCCESS / FAILED]
Errors: [List errors if any]
Duration: [X seconds]
```

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

**Expected output:**
```
Migrating {{site_name}}
Executing patches...
✓ Migrated to version X.Y.Z
```

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
- Capture full error message
- Identify the problematic DocType or patch
- Report to user with details
- Offer to fix the error
- DO NOT proceed until migration succeeds

**Migration status:**
```
Migration Result: [SUCCESS / FAILED]
Errors: [List errors if any]
Duration: [X seconds]
```

---

### Phase D: Clear Cache and Restart

#### 8. Clear cache

**Command:**
```bash
cd {{bench_path}}
bench --site {{default_site}} clear-cache
```

**Purpose:**
- Remove cached Python bytecode
- Clear Redis cache
- Refresh metadata
- Clear form customizations cache

#### 9. Restart bench

**Command:**
```bash
cd {{bench_path}}
bench restart
```

**Purpose:**
- Reload Python code changes
- Restart background workers
- Apply new configurations

**Expected output:**
```
Restarting frappe-bench-workers...
Restarting frappe-bench-web...
Done
```

---

## Deployment Summary

Provide comprehensive deployment summary:

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

Build Status: [SUCCESS ✓ / FAILED ✗]
├─ Duration: [X] seconds
└─ Errors: [None / List errors]

Migration Status: [SUCCESS ✓ / FAILED ✗]
├─ Duration: [X] seconds
└─ Errors: [None / List errors]

Cache Cleared: [YES ✓]
Bench Restarted: [YES ✓]

Code Location: {{app_path}}/{{current_app}}/
```

---

## Error Handling

**If deployment fails at any stage:**

1. **Stop the workflow immediately**
2. **Report the error clearly** with file/line references
3. **Offer to fix the error** (syntax, structure, etc.)
4. **Retry the failed step** after fix
5. **DO NOT skip to next step** until current step succeeds

**Retry logic:**
- Fix reported error
- Re-run failed command
- Verify success
- Continue workflow

---

## Menu

**Deployment completed successfully?**

**[A]** Auto-continue to Step 7 (Validate & Test)
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
- ✅ No deployment errors reported

---

## Update State

Update `active.yaml`:
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
**→ Load and execute:** `steps/step-07-validate.md`

**If [P]ause:**
STOP here. User can manually verify deployment.

**If [C]ancel:**
EXIT workflow. Update state and preserve progress.

**If [F]ix and retry:**
Fix errors, then re-run Phase B, C, or D as needed.
