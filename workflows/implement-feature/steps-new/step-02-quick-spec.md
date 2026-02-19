---
name: "Create Quick Spec"
step: 2
mode: "new"
description: "Produce a lightweight feature spec from the gathered requirements"
variables:
  - quick_spec
  - components_overview
  - spec_path
---

# Step 2: Create Quick Spec

**Goal:** Produce a concise, implementation-ready spec from the requirements gathered in Step 1. This replaces a formal TSD for ad-hoc features.

---

## MANDATORY EXECUTION RULES

<critical>
- Keep the spec concise - target 1-2 pages max
- Focus on WHAT to build, not HOW (implementation comes later)
- Spec must include: components, behaviours, validations, data model changes
- Save the spec to the docs folder so it persists for future sessions
- DO NOT start implementation yet - spec must be confirmed first
</critical>

---

## Session Variables (Available)

From Step 1:
- `{{feature_name}}` - Feature name
- `{{feature_id}}` - Feature ID (kebab-case)
- `{{business_goal}}` - Business goal
- `{{affected_doctypes}}` - DocTypes involved
- `{{app_path}}` - Full path to app

---

## Step Instructions

### 1. Draft the Quick Spec

Write a structured spec document:

```markdown
# Quick Spec: {{feature_name}}

**Feature ID:** {{feature_id}}
**Date:** [today]
**Status:** In Progress

## Goal
{{business_goal}}

## Components to Build

### DocType Changes
- [List any new DocTypes or field additions]

### Server Logic
- [List validations, hooks, API methods needed]

### Client Logic
- [List UI behaviours, auto-fills, custom buttons]

### Reports (if any)
- [List any reports needed]

## Behaviours
1. [Behaviour 1 - specific and actionable]
2. [Behaviour 2]

## Validations
1. [Validation rule 1]
2. [Validation rule 2]

## Permissions
- [Role: what they can do]

## Edge Cases
- [Edge case 1 and how to handle it]

## Out of Scope
- [What this feature deliberately does NOT do]
```

### 2. Review with User

Present the spec and ask:

```
Here's your quick spec. Please review:

[Paste the spec]

Is this correct? Any missing items or changes needed?
[A] Approve and continue to implementation
[E] Edit (tell me what to change)
```

Wait for response. Edit if needed, re-confirm before proceeding.

### 3. Save the Spec

Save to: `{{app_path}}/docs/features/{{feature_id}}-spec.md`

If the docs/features/ directory doesn't exist, create it.

---

## Success Criteria

- ✅ Spec covers all components and behaviours from requirements
- ✅ Spec is concise and implementation-ready
- ✅ User has approved the spec
- ✅ Spec saved to docs/features/ folder

---

## Update State

Update `session.yaml`:
```yaml
workflow_step: 2
current_task: "Quick spec created and approved"
last_action: "Created quick spec for {{feature_name}}"
next_action: "Identify components to implement"
updated: "[current timestamp]"
```

Update `features/{{feature_id}}.yaml`:
```yaml
spec: "docs/features/{{feature_id}}-spec.md"
```

---

## Next Step

**→ Load and execute:** `steps-new/step-03-identify.md`

Continue to component identification.
