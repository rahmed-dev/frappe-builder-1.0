---
name: "Load Technical Specification Document"
step: 1
description: "Load and understand the TSD to establish clear build scope"
variables:
  - tsd_path
  - tsd_content
  - build_scope
---

# Step 1: Load Technical Specification Document

**Goal:** Load and understand the Technical Specification Document to establish clear build scope.

---

## MANDATORY EXECUTION RULES

<critical>
- TSD path MUST be provided (already validated by workflow.md)
- TSD file MUST exist and be readable
- Parse and understand complete TSD content
- Extract key requirements and scope
- DO NOT proceed without clear understanding of what to build
</critical>

---

## Session Variables (Available)

From active.yaml:
- `{{tsd_path}}` - Path to Technical Specification Document
- `{{project}}` - Project name
- `{{app}}` - Current Frappe app
- `{{bench_path}}` - Path to Frappe bench
- `{{app_path}}` - Full path to app

---

## Step Instructions

### 1. Load TSD Document

Read the complete TSD from `{{tsd_path}}`:

```
Read file: {{tsd_path}}
```

**If file not found:**
- Report error to user
- Ask for correct path
- Update `{{tsd_path}}` and retry

**If file is sharded (e.g., tsd/feature-name/part-*.md):**
- Read all shard files in sequence
- Assemble complete specification
- Note: Sharded TSDs typically found in `tsd/{{feature-name}}/` directory

### 2. Parse and Understand TSD

Extract key information:

**A. Feature Overview**
- Feature name and purpose
- Business requirements being addressed
- User stories or use cases

**B. Technical Components**
- DocTypes (custom/standard modifications)
- Server Scripts (hooks, validations, custom methods)
- Client Scripts (UI behavior)
- Reports (query/script reports)
- API Endpoints (@frappe.whitelist functions)
- Workflows (state transitions)
- Print Formats
- Scheduled Jobs

**C. Dependencies**
- External apps or modules
- Standard DocTypes being extended
- Existing features that interact with this

**D. Data Model**
- Database tables/fields
- Relationships (link fields, child tables)
- Permissions and role requirements

**E. Business Logic**
- Validation rules
- Calculation logic
- Workflow transitions
- Background job requirements

### 3. Establish Build Scope

Create a clear mental model of what will be built:

**Summary:**
```
Feature: [Feature Name]
DocTypes: [X] new, [Y] modified
Server Scripts: [X] hooks, [Y] methods, [Z] APIs
Client Scripts: [X] form scripts
Reports: [X] query reports, [Y] script reports
Workflows: [X] workflows
Other: [List any special components]
```

Store this summary for reference in subsequent steps.

---

## Success Criteria

- ✅ TSD loaded completely
- ✅ Key components identified and understood
- ✅ Build scope is clear and unambiguous
- ✅ No questions about what needs to be built

---

## Update State

Update `active.yaml`:
```yaml
workflow: "implement-phase"
workflow_step: 1
current_task: "Loaded TSD and established build scope"
tsd: "{{tsd_path}}"
last_action: "Loaded TSD: {{tsd_path}}"
next_action: "Identify components to build"
updated: "[current timestamp]"
```

---

## Next Step

**→ Load and execute:** `steps/step-02-identify.md`

Continue to component identification.
