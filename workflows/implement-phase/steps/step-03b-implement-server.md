---
name: "Implement Server-Side Logic (Part B)"
step: "3b"
description: "frappe.utils patterns, scheduled jobs, and best practices"
variables:
  - server_logic_implemented
  - validations_added
  - hooks_implemented
---

# Step 3b: Server Logic — frappe.utils, Scheduled Jobs & Best Practices

---

## MANDATORY EXECUTION RULES

<critical>
- Use frappe.utils for ALL date/number/formatting operations
- Use ignore_permissions in scheduled jobs (no user context)
- Follow DO/DON'T checklist before marking implementation complete
</critical>

---

### 2B. Use frappe.utils for Common Operations

```python
from frappe.utils import (
    flt, cint, cstr,          # Type conversion
    getdate, add_days, date_diff,  # Date operations
    fmt_money, comma_and,     # Formatting
    validate_email_address    # Validation
)

@frappe.whitelist()
def calculate_maintenance_cost(maintenance_request):
    """Calculate total maintenance cost"""
    doc = frappe.get_doc("Asset Maintenance Request", maintenance_request)

    parts_cost = flt(doc.parts_cost)
    labor_cost = flt(doc.labor_cost)
    overhead = flt(parts_cost + labor_cost) * 0.15
    total = parts_cost + labor_cost + overhead

    return {
        "parts_cost": parts_cost,
        "labor_cost": labor_cost,
        "overhead": overhead,
        "total_cost": total,
        "formatted_total": fmt_money(total, currency=doc.currency)
    }
```

---

### 3. Implement Scheduled Jobs

```python
def daily_maintenance_reminder():
    """
    Scheduled job: Send reminders for pending maintenance
    Runs daily at 9 AM
    """
    from frappe.utils import add_days, today

    pending_requests = frappe.get_all(
        "Asset Maintenance Request",
        filters={
            "status": "Pending",
            "schedule_date": ["<=", add_days(today(), 3)]
        },
        fields=["name", "asset", "assigned_to"],
        ignore_permissions=True  # Required — no user context in scheduled jobs
    )

    for request in pending_requests:
        if request.assigned_to:
            frappe.sendmail(
                recipients=[request.assigned_to],
                subject=f"Maintenance Reminder: {request.name}",
                message=f"Asset {request.asset} requires maintenance soon."
            )
```

---

### 4. Follow Best Practices

**✅ DO:**
- Use `frappe.get_doc()` to load documents
- Use `frappe.db.get_value()` for single field lookups
- Use parameterized queries with `%(param)s` syntax
- Use `frappe.throw()` for user-facing errors
- Use `frappe.log_error()` for system errors
- Check permissions before data access
- Convert types with `flt()`, `cint()`, `cstr()`

**❌ DON'T:**
- Use string concatenation in SQL queries
- Use `frappe.db.sql()` without parameters
- Put business logic in client scripts
- Use custom date/number formatting
- Skip permission checks
- Use bare `except:` clauses
- Access `frappe.db` directly from client

---

## Implementation Checklist

```
Server Logic Implementation:
[ ] DocType Controllers
    [✓] Validation logic
    [✓] Hook methods
    [✓] Custom methods
[ ] API Endpoints
    [✓] Permission checks
    [✓] Parameterized queries
    [✓] Error handling
[ ] Scheduled Jobs
    [✓] Background tasks
    [✓] ignore_permissions where needed
```

---

## Menu

What would you like to do?

**[A]** Auto-continue to Step 4 (Implement Client Logic)
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
workflow_step: 3
current_task: "Implemented server-side business logic"
last_action: "Completed [X] controllers, [Y] APIs, [Z] scheduled jobs"
next_action: "Implement client-side UI behavior"
updated: "[current timestamp]"
```

---

## Next Step

**If [A]uto-continue:**
**→ Load and execute:** `steps/step-04-implement-client.md`

**If [P]ause:**
STOP here. User can review server logic and resume later.

**If [C]ancel:**
EXIT workflow. Update state and preserve progress.
