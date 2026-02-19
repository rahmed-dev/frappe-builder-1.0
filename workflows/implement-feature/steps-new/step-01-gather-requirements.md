---
name: "Gather Feature Requirements"
step: 1
mode: "new"
description: "Interactively gather requirements for the new ad-hoc feature"
variables:
  - feature_name
  - feature_description
  - feature_id
  - business_goal
  - affected_doctypes
---

# Step 1: Gather Feature Requirements

**Goal:** Gather clear, actionable requirements for the new feature through conversation.

---

## MANDATORY EXECUTION RULES

<critical>
- Ask questions ONE group at a time - do NOT dump all questions at once
- Wait for user response before asking next group
- Confirm understanding before proceeding to spec
- Assign a feature_id (kebab-case slug of feature name)
- DO NOT begin implementation without clear requirements
</critical>

---

## Session Variables (Available)

From active.yaml:
- `{{project}}` - Project name
- `{{app}}` - Current Frappe app
- `{{bench_path}}` - Path to Frappe bench

---

## Step Instructions

### 1. Ask: What to Build

Ask the user:

```
Let's define your feature. Please describe:

1. What is the feature name? (e.g., "Auto-Discount on Sales Invoice")
2. What business problem does it solve?
3. Which DocType(s) are involved? (e.g., Sales Invoice, Purchase Order)
```

Wait for response.

### 2. Ask: Scope and Behaviour

Based on their answer, ask follow-up questions:

```
Got it. A few more questions:

4. What should happen automatically vs. what requires user action?
5. Are there any validation rules or conditions?
6. Any calculations or data to be auto-filled?
```

Wait for response.

### 3. Ask: Edge Cases and Constraints

```
Almost there:

7. Are there any roles or permissions involved?
8. Any edge cases we should handle? (e.g., cancelled docs, zero amounts)
9. Any existing workflows or scripts this might interact with?
```

Wait for response.

### 4. Confirm and Summarise

Summarise what you understood:

```
Here's what I'll build:

Feature: [Feature Name]
Feature ID: [kebab-case-id]
Goal: [Business goal in 1-2 sentences]
DocTypes involved: [List]
Key behaviours:
  - [Behaviour 1]
  - [Behaviour 2]
Validations:
  - [Rule 1]
Permissions: [Roles involved]
Edge cases: [List]

Does this capture everything correctly? Any changes?
```

Wait for confirmation. Adjust if needed.

---

## Success Criteria

- ✅ Feature name and ID assigned
- ✅ Business goal is clear and agreed upon
- ✅ Affected DocTypes identified
- ✅ Key behaviours and validations understood
- ✅ User confirmed the summary

---

## Update State

Update `session.yaml`:
```yaml
workflow: "implement-feature"
workflow_step: 1
current_feature: "{{feature_id}}"
current_task: "Gathered requirements for {{feature_name}}"
last_action: "Completed requirements gathering for {{feature_name}}"
next_action: "Create quick spec"
updated: "[current timestamp]"
```

Create feature file `state/{{active_project}}/features/{{feature_id}}.yaml`:
```yaml
type: "ad-hoc"
status: "in-progress"
started: "[today's date]"
tsd: null   # No formal TSD for ad-hoc features

summary:
  name: "{{feature_name}}"
  goal: "{{business_goal}}"
  doctypes: [{{affected_doctypes}}]
  behaviours: []   # Populated in step 2
  validations: []  # Populated in step 2

progress:
  completed: 0
  total: 0

notes: "Requirements gathered in session"
```

---

## Next Step

**→ Load and execute:** `steps-new/step-02-quick-spec.md`

Continue to quick spec creation.
