---
name: "Select Feature from Inventory"
step: 1
mode: "resume"
description: "Display feature inventory and let user select which feature to resume"
variables:
  - selected_feature_id
  - feature_inventory
---

# Step 1: Select Feature from Inventory

**Goal:** Display the feature inventory from active.yaml and let the user select which feature to resume work on.

---

## MANDATORY EXECUTION RULES

<critical>
- Read inventory.yaml to get the features inventory (create from template if missing)
- Display ALL features with their status and progress
- Ask user to select by feature ID or number
- DO NOT proceed without a valid feature selection
- Validate the selected feature file exists before continuing
</critical>

---

## Session Variables (Available)

From active.yaml:
- `{{project}}` - Project name
- `{{app}}` - Current Frappe app
- `{{bench_path}}` - Path to Frappe bench

From inventory.yaml (create from template if missing):
- `{{features}}` - Feature inventory

---

## State Validation (Resilient State v1.1)

**Before proceeding, validate resume state:**

1. **Feature file check:** If `{{current_feature}}` is set in session.yaml, confirm `state/{{active_project}}/features/{{current_feature}}.yaml` exists
   - If missing → warn: "Feature file not found for `{{current_feature}}`. State may be stale — proceeding with inventory selection."
2. **Step integrity:** Confirm `{{workflow_step}}` is a valid integer (not empty or NaN)
   - If invalid → reset to step 1, continue
3. **Timestamp check:** If `{{updated}}` is set and older than 7 days → soft warning: "Last session was over 7 days ago. Verifying state before proceeding."

**Silent pass** if all checks green. **One-line warning** if any check fails. Never block — always recover and continue.

---

## Step Instructions

### 1. Load Feature Inventory

Read `inventory.yaml` (path: `state/{{active_project}}/inventory.yaml`).

**If inventory.yaml does not exist:** Create it from template:
```yaml
features: {}
```

**If features is empty or missing:**
```
No features found in inventory.

To start a new feature, exit this workflow and use:
[N] New Feature mode when invoking implement-feature again.
```
STOP workflow.

### 2. Display Feature Inventory

Present a numbered list:

```
FEATURE INVENTORY
=================
Project: {{project}}

#  Feature ID                      Status        Progress  Notes
── ────────────────────────────── ─────────────  ───────── ──────────────────
1. sales-invoice-enhancements      in-progress   5/9 (55%) Credit validation done
2. asset-maintenance-request       in-progress   2/9 (22%) Scaffolding complete
3. purchase-approval-workflow      planned       0/9  (0%) Not started yet
4. customer-credit-limit           completed     9/9 (100%) Done
```

**Completed features:** Still shown but marked — user may want to re-open or review.

### 3. Ask User to Select

```
Which feature would you like to resume?
Enter the number or feature ID:
```

Wait for response.

### 4. Validate Selection

- If user enters a number → look up by position
- If user enters an ID → match against inventory
- If invalid → show "Not found. Please try again." and re-ask
- If completed feature selected → confirm: "This feature is marked complete. Resume anyway? [Y/N]"

### 5. Load Feature Detail File

Once confirmed, load:
`state/{{active_project}}/features/{{selected_feature_id}}.yaml`

If file not found:
```
Feature file not found: features/{{selected_feature_id}}.yaml
This may mean the feature was created in a previous version.
Would you like to continue with just the inventory summary? [Y/N]
```

---

## Success Criteria

- ✅ Feature inventory displayed clearly
- ✅ User made a valid selection
- ✅ Feature detail file loaded (or gracefully handled if missing)
- ✅ `{{selected_feature_id}}` stored for next step

---

## Update State

Update `session.yaml`:
```yaml
workflow: "implement-feature"
workflow_step: 1
current_feature: "{{selected_feature_id}}"
current_task: "Selected feature to resume: {{selected_feature_id}}"
last_action: "User selected feature: {{selected_feature_id}}"
next_action: "Load feature context and understand where work left off"
updated: "[current timestamp]"
```

---

## Next Step

**→ Load and execute:** `steps-resume/step-02-load-context.md`

Continue to load feature context.
