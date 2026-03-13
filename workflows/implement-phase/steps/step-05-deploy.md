---
name: "Deploy Code to Frappe Bench"
step: 5
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
- `{{app}}` - Frappe app name
- `{{app_path}}` - Full path: `{{bench_path}}/apps/{{app}}`
- `{{default_site}}` - Default site name (from config or detect)

---

## Step Instructions

### Phase A: Write Files to Frappe App

#### 1. Write DocType Files

For each DocType implemented:

**A. DocType JSON:**
- Path: `{{app_path}}/{{app}}/{{module}}/doctype/{{doctype_folder}}/{{doctype_name}}.json`
- Ensure valid JSON structure
- Verify field definitions are correct

**B. DocType Controller (Python):**
- Path: `{{app_path}}/{{app}}/{{module}}/doctype/{{doctype_folder}}/{{doctype_name}}.py`
- Include proper imports
- Verify class name matches DocType name

**C. Client Script (JavaScript):**
- Path: `{{app_path}}/{{app}}/{{module}}/doctype/{{doctype_folder}}/{{doctype_name}}.js`
- Verify frappe.ui.form.on syntax

**D. `__init__.py`:**
- Path: `{{app_path}}/{{app}}/{{module}}/doctype/{{doctype_folder}}/__init__.py`
- Can be empty or import controller

#### 2. Write API Files

**API Module:**
- Path: `{{app_path}}/{{app}}/{{module}}/api.py`
- Verify all functions have @frappe.whitelist() decorator

#### 3. Write Report Files

For each report:

**A. Report Python:**
- Path: `{{app_path}}/{{app}}/{{module}}/report/{{report_folder}}/{{report_name}}.py`
- Verify execute(filters) function exists

**B. Report JSON:**
- Path: `{{app_path}}/{{app}}/{{module}}/report/{{report_folder}}/{{report_name}}.json`
- Contains report metadata

#### 4. Write Workflow Files

For each workflow:

**Workflow JSON:**
- Path: `{{app_path}}/{{app}}/{{module}}/workflow/{{workflow_name}}.json`
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
bench build --app {{app}}
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

---

## Continue in Part B

**→ Load and execute:** `steps/step-05b-deploy.md`

Part B covers: Phase C (migrate), Phase D (clear cache + restart), deployment summary, error handling, menu and state update.
