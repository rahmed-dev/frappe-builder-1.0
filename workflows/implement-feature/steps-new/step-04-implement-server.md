---
name: "Implement Server-Side Logic"
step: 4
mode: "new"
description: "Implement business logic following Frappe framework patterns (server-side first)"
variables:
  - server_logic_implemented
  - validations_added
  - hooks_implemented
---

# Step 5: Implement Server-Side Business Logic

**Goal:** Implement all server-side business logic from the quick spec, following Frappe framework best practices.

---

## MANDATORY EXECUTION RULES

<critical>
- Implement server-side logic FIRST (before client-side)
- Use Frappe framework utilities (frappe.utils, frappe.db with params)
- Include permission checks in all API endpoints
- Use frappe.throw() for validation errors
- DO NOT use SQL string concatenation (SQL injection risk)
- DO NOT put business logic in client scripts
- Follow the Single Responsibility Principle
</critical>

---

## Reference Materials

**Load patterns:** `data/server-patterns.md`

This file contains:
- Validation patterns
- Hook patterns (before_save, on_submit, etc.)
- frappe.utils usage examples
- Permission check patterns
- Parameterized query examples
- API whitelisting patterns

---

## Session Variables (Available)

From Steps 3 & 4:
- Component checklist
- Scaffolded controllers and API stubs

---

## Step Instructions

### 1. Implement DocType Controller Logic

For each controller, implement:

**A. Validation logic** in `validate()` method
- Field validation, date checks, amount checks
- Use `frappe.throw()` for user-facing errors
- Use `frappe.utils` for type conversion (flt, cint, getdate)

**B. Hook methods**
- `before_save` - auto-populate from linked docs
- `after_insert` - notifications, side effects
- `on_submit` - create related records
- `on_cancel` - reverse related records

**C. Custom helper methods**
- Single responsibility - one method per action
- Call from hooks, don't inline everything

Refer to `data/server-patterns.md` for patterns and examples.

### 2. Implement API Endpoints

For each `@frappe.whitelist()` function:

**A.** Add permission check (mandatory): `frappe.has_permission(..., throw=True)`

**B.** Validate inputs - throw on missing required params

**C.** Use parameterized queries: `frappe.db.sql("... WHERE x = %(x)s", {"x": val})`

**D.** Return structured response

### 3. Implement Scheduled Jobs (if any)

- Use `ignore_permissions=True` where appropriate for background context
- Use `frappe.utils` for date arithmetic
- Log errors with `frappe.log_error()`

### 4. Best Practices Checklist

**✅ DO:**
- `frappe.get_doc()` to load documents
- `frappe.db.get_value()` for single field lookups
- Parameterized queries with `%(param)s`
- `frappe.throw()` for user errors
- `frappe.log_error()` for system errors
- Convert types with `flt()`, `cint()`, `cstr()`

**❌ DON'T:**
- SQL string concatenation
- `frappe.db.sql()` without parameters
- Business logic in client scripts
- Custom date/number formatting
- Skip permission checks
- Bare `except:` clauses

### 5. Track Implementation Progress

```
Server Logic Progress:
[ ] DocType Controllers
    [ ] validate() methods
    [ ] Hook methods
    [ ] Custom helpers
[ ] API Endpoints
    [ ] Permission checks
    [ ] Parameterized queries
    [ ] Error handling
[ ] Scheduled Jobs (if any)
```

---

## Menu

What would you like to do?

**[A]** Auto-continue to Step 6 (Implement Client Logic)
**[P]** Pause here (review server logic before client scripts)
**[C]** Cancel workflow

---

## Success Criteria

- ✅ All server-side business logic implemented
- ✅ Validations use frappe.throw() for errors
- ✅ Queries are parameterized (no SQL injection)
- ✅ API endpoints have @frappe.whitelist() decorator
- ✅ Permission checks included where needed
- ✅ frappe.utils used for common operations
- ✅ No client-side business logic

---

## Update State

Update `session.yaml`:
```yaml
workflow_step: 4
current_task: "Implemented server-side business logic"
last_action: "Completed [X] controllers, [Y] APIs, [Z] scheduled jobs"
next_action: "Implement client-side UI behavior"
updated: "[current timestamp]"
```

---

## Next Step

**If [A]uto-continue:**
**→ Load and execute:** `steps-new/step-05-implement-client.md`

**If [P]ause:**
STOP here. User can review server logic and resume later.

**If [C]ancel:**
EXIT workflow. Update state and preserve progress.

---
## ⛔ STATE GATE — Required before proceeding

**Do not load the next step file until all writes below are confirmed.**

**1. Write `state/{{active_project}}/session.yaml`:**
```yaml
workflow: "implement-feature"
workflow_step: 4
workflow_status: "in-progress"
last_action: "Implemented server-side logic — [X] controllers, [Y] APIs, [Z] scheduled jobs"
next_action: "Implement client-side UI behavior"
updated: "{{ISO timestamp}}"
```

**2. Update `state/{{active_project}}/features/{{feature_id}}.yaml`:**
```yaml
# Mark server components as in-progress:
{{server_component_id}}:
  status: "in-progress"
notes: "Server-side implementation in progress."
```

**If any write fails → HALT. Report the failure. Do not proceed.**
