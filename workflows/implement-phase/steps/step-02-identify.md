---
name: "Identify Components to Build"
step: 2
description: "Create detailed checklist of all components to implement"
variables:
  - component_checklist
  - doctypes_list
  - scripts_list
  - reports_list
  - apis_list
---

# Step 2: Identify Components to Build

**Goal:** Create a detailed implementation checklist based on TSD requirements.

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

## Step Instructions

### 1. Identify DocTypes

For each DocType to be created or modified:

**List:**
- DocType name
- Purpose (1-line description)
- Type (Standard/Single)
- Key fields (name, type, options)
- Child tables (if any)
- Permissions (which roles)
- Naming pattern (if custom)

**Example:**
```
DocType: Asset Maintenance Request
Purpose: Track maintenance requests for company assets
Type: Standard
Fields:
  - asset (Link to Asset) *required
  - maintenance_type (Select: Preventive/Corrective)
  - description (Text Editor)
  - assigned_to (Link to User)
  - status (Select: Open/In Progress/Completed)
Permissions: Asset Manager, Asset User (read-only)
Naming: AMR-.YYYY.-.#####
```

### 2. Identify Server Scripts

For each server-side component:

**A. DocType Controllers (Hooks)**
- DocType name
- Hook type (before_save, on_submit, on_cancel, etc.)
- Purpose (validation, calculation, side-effects)

**Example:**
```
Controller: Asset Maintenance Request
Hooks:
  - before_save: Validate asset exists and is active
  - on_submit: Create scheduled job for maintenance
  - on_cancel: Cancel related scheduled jobs
```

**B. API Endpoints**
- Function name
- Parameters (with types)
- Return value
- Purpose
- Permission requirements

**Example:**
```
API: get_asset_maintenance_history
Params: asset_name (str)
Returns: List of dict (maintenance records)
Purpose: Fetch maintenance history for asset dashboard
Permissions: Asset User or higher
```

**C. Scheduled Jobs**
- Job name
- Frequency (daily, weekly, cron expression)
- Purpose
- What it does

### 3. Identify Client Scripts

For each client-side component:

**List:**
- DocType name
- Trigger event (refresh, field change, button click)
- Purpose (show/hide fields, auto-calculate, custom button)
- Logic summary

**Example:**
```
Client Script: Asset Maintenance Request
Events:
  - maintenance_type.change: Show/hide preventive schedule fields
  - asset.change: Auto-fill asset details (location, owner)
  - custom_button.add: "View Asset History" → fetch and display
```

### 4. Identify Reports

For each report:

**List:**
- Report name
- Type (Query Report / Script Report)
- Purpose
- Key columns
- Filters
- Data source (which DocTypes/tables)

**Example:**
```
Report: Asset Maintenance Summary
Type: Script Report
Purpose: Show maintenance statistics by asset category
Columns: Category, Total Assets, Pending Requests, Completed, Overdue
Filters: Date Range, Asset Category, Status
Source: Asset Maintenance Request + Asset
```

### 5. Identify Workflows

For each workflow:

**List:**
- Workflow name
- Applies to (DocType)
- States (with allowed roles)
- Transitions (from → to, with conditions)

**Example:**
```
Workflow: Maintenance Request Approval
DocType: Asset Maintenance Request
States:
  - Draft (All)
  - Pending Approval (Asset Manager)
  - Approved (Asset Manager)
  - Completed (Asset User)
Transitions:
  - Draft → Pending Approval (user clicks Submit)
  - Pending Approval → Approved (Asset Manager approves)
  - Approved → Completed (work is done)
```

### 6. Identify Other Components

**Print Formats:**
- Print format name
- DocType
- Purpose

**Customizations:**
- Standard DocType being customized
- Fields being added
- Custom fields specifications

**Web Forms:**
- Form name
- Purpose
- Fields
- Publish settings

---

## Build Implementation Checklist

Create a structured checklist:

```
IMPLEMENTATION CHECKLIST
========================

[ ] DOCTYPES (X total)
    [ ] DocType Name 1 - Purpose
    [ ] DocType Name 2 - Purpose

[ ] SERVER SCRIPTS (Y total)
    [ ] Controller hooks for DocType 1
    [ ] API endpoint: function_name_1
    [ ] API endpoint: function_name_2
    [ ] Scheduled job: job_name

[ ] CLIENT SCRIPTS (Z total)
    [ ] Client script for DocType 1
    [ ] Client script for DocType 2

[ ] REPORTS (N total)
    [ ] Query Report: Report Name 1
    [ ] Script Report: Report Name 2

[ ] WORKFLOWS (M total)
    [ ] Workflow Name 1

[ ] OTHER COMPONENTS
    [ ] Print Format: Format Name
    [ ] Web Form: Form Name
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
workflow_step: 2
current_task: "Identified components to build"
last_action: "Created implementation checklist with [X] components"
next_action: "Implement server-side business logic"
updated: "[current timestamp]"
```

---

## Next Step

**→ Load and execute:** `steps/step-03-implement-server.md`
