---
name: "Identify Components to Build"
step: 3
mode: "resume"
description: "Create detailed checklist of all components to implement from the quick spec"
variables:
  - component_checklist
  - doctypes_list
  - scripts_list
  - reports_list
  - apis_list
---

# Step 3: Identify Components to Build

**Goal:** Create a detailed implementation checklist from the quick spec approved in Step 2.

---

## MANDATORY EXECUTION RULES

<critical>
- Build COMPLETE checklist of all components
- Specify exact details for each component (names, purposes, dependencies)
- Include DocType field specifications
- Identify server vs client logic clearly
- DO NOT skip to implementation without this checklist
</critical>

---

## Session Variables (Available)

From Step 2:
- Quick spec content (feature name, behaviours, validations, components)
- `{{feature_id}}` - Feature ID
- `{{feature_name}}` - Feature name

---

## Step Instructions

### 1. Identify DocTypes

For each DocType to be created or modified:

**List:**
- DocType name
- Purpose (1-line description)
- New vs existing modification
- Key fields (name, type, options)
- Child tables (if any)
- Permissions (which roles)

**Example:**
```
DocType: Asset Maintenance Request
Purpose: Track maintenance requests for company assets
Type: New (Standard)
Fields:
  - asset (Link to Asset) *required
  - maintenance_type (Select: Preventive/Corrective)
  - description (Text Editor)
  - assigned_to (Link to User)
  - status (Select: Open/In Progress/Completed)
Permissions: Asset Manager, Asset User (read-only)
```

### 2. Identify Server Scripts

For each server-side component:

**A. DocType Controllers (Hooks)**
- DocType name
- Hook type (before_save, on_submit, on_cancel, validate, etc.)
- Purpose (validation, calculation, side-effects)

**B. API Endpoints**
- Function name
- Parameters (with types)
- Return value
- Purpose and permission requirements

**C. Scheduled Jobs (if any)**
- Job name, frequency, purpose

### 3. Identify Client Scripts

For each client-side component:

**List:**
- DocType name
- Trigger event (refresh, field change, button click)
- Purpose (show/hide fields, auto-calculate, custom button)
- Logic summary

### 4. Identify Reports (if any)

**List:**
- Report name and type (Query / Script)
- Purpose, key columns, filters
- Data source (which DocTypes)

### 5. Build Implementation Checklist

```
IMPLEMENTATION CHECKLIST
========================

[ ] DOCTYPES (X total)
    [ ] DocType Name 1 - Purpose
    [ ] DocType Name 2 - Purpose

[ ] SERVER SCRIPTS (Y total)
    [ ] Controller hooks for DocType 1
    [ ] API endpoint: function_name_1
    [ ] Scheduled job: job_name

[ ] CLIENT SCRIPTS (Z total)
    [ ] Client script for DocType 1

[ ] REPORTS (N total)
    [ ] Query Report: Report Name 1

[ ] OTHER COMPONENTS
    [ ] Print Format / Web Form / Workflow (if any)
```

---

## Success Criteria

- ✅ Complete checklist of ALL components
- ✅ Each component has clear specifications
- ✅ Implementation order is logical (dependencies first)
- ✅ No ambiguity about what to build

---

## Update State

Update `session.yaml`:
```yaml
workflow_step: 3
current_task: "Identified components to build"
last_action: "Created implementation checklist with [X] components"
next_action: "Implement server-side business logic"
updated: "[current timestamp]"
```

---

## Next Step

**→ Load and execute:** `steps-resume/step-04-implement-server.md`
