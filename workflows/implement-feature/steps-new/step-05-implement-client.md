---
name: "Implement Client-Side UI Behavior"
step: 5
mode: "new"
description: "Implement minimal client-side logic for UI behavior only (no business logic)"
variables:
  - client_logic_implemented
  - form_behaviors_added
---

# Step 6: Implement Client-Side UI Behavior

**Goal:** Implement minimal client-side logic for UI behavior ONLY.

---

## MANDATORY EXECUTION RULES

<critical>
- Client scripts are ONLY for UI behavior (not business logic)
- Business logic MUST remain on server-side
- ALWAYS convert form values (string → int/float) before calculations
- Use frappe.call() to invoke server-side methods
- Use frm.set_value() to update form fields
- Handle null/undefined values properly
- DO NOT put validations, calculations, or data operations in client scripts
</critical>

---

## Reference Materials

**Load patterns:** `data/client-patterns.md`

This file contains:
- frappe.ui.form.on pattern
- frappe.call pattern
- Type conversion (parseInt/parseFloat)
- Custom button pattern
- Field dependency patterns
- Auto-fill and auto-calculation patterns

---

## Session Variables (Available)

From Steps 4 & 5:
- Scaffolded client script stubs
- Server-side API methods available to call

---

## Step Instructions

### 1. Valid vs Invalid Client Script Use Cases

**✅ Valid (UI behavior only):**
- Show/hide fields based on other field values
- Enable/disable fields conditionally
- Auto-fill fields from server data via frappe.call()
- Add custom buttons that invoke server methods
- Display messages and confirmations
- Set field filters (set_query)
- Refresh form sections

**❌ Invalid (belongs on server):**
- Complex calculations or business logic
- Data validation
- Database queries
- Permission enforcement
- Creating or updating other documents

### 2. Implement from Quick Spec

For each client-side behaviour identified in the spec:

**A. Field dependencies** - show/hide, enable/disable based on field values

**B. Auto-fill** - on field change, call server to fetch and populate related fields

**C. Simple display calculations** - always convert with parseInt()/parseFloat() first
   - For complex calculations, call the server method instead

**D. Custom buttons** - add to refresh handler, call server methods with frappe.call()

**E. Link field filters** - use frm.set_query() in setup handler

Refer to `data/client-patterns.md` for complete code templates for each pattern.

### 3. Track Implementation

```
Client Script Implementation:
[ ] Field dependencies (show/hide/enable/disable)
[ ] Auto-fill on field change
[ ] Calculations or server calls
[ ] Custom buttons
[ ] Link field filters
[ ] Child table handlers (if any)
```

---

## Menu

What would you like to do?

**[A]** Auto-continue to Step 7 (Deploy Code)
**[P]** Pause here (review client scripts before deployment)
**[C]** Cancel workflow

---

## Success Criteria

- ✅ All UI behaviors from spec implemented
- ✅ No business logic in client scripts
- ✅ Form values converted with parseInt/parseFloat before use
- ✅ frappe.call() used for server communication
- ✅ Null/undefined values handled safely
- ✅ No console.log() statements in production code

---

## Update State

Update `session.yaml`:
```yaml
workflow_step: 5
current_task: "Implemented client-side UI behavior"
last_action: "Completed [X] client scripts with [Y] behaviors"
next_action: "Deploy code to Frappe bench"
updated: "[current timestamp]"
```

---

## Next Step

**If [A]uto-continue:**
**→ Load and execute:** `steps-new/step-06-deploy.md`

**If [P]ause:**
STOP here. User can review client scripts and resume later.

**If [C]ancel:**
EXIT workflow. Update state and preserve progress.
