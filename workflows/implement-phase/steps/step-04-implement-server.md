---
name: "Implement Server-Side Logic"
step: 4
description: "Implement business logic following Frappe framework patterns (server-side first)"
variables:
  - server_logic_implemented
  - validations_added
  - hooks_implemented
---

# Step 4: Implement Server-Side Business Logic

**Goal:** Implement server-side business logic following Frappe framework best practices.

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

From Step 3:
- Scaffolded controllers and APIs
- Component checklist

---

## Step Instructions

### 1. Implement DocType Controller Logic

For each DocType controller:

**A. Validation Logic (validate method)**

```python
def validate(self):
    """Validation before save"""
    self.validate_required_fields()
    self.validate_dates()
    self.validate_amounts()
    self.calculate_totals()

def validate_required_fields(self):
    """Check required business fields"""
    if not self.asset:
        frappe.throw("Asset is required")

    if self.maintenance_type == "Preventive" and not self.schedule_date:
        frappe.throw("Schedule date required for preventive maintenance")

def validate_dates(self):
    """Validate date logic"""
    from frappe.utils import getdate

    if self.schedule_date and getdate(self.schedule_date) < getdate(frappe.utils.today()):
        frappe.throw("Schedule date cannot be in the past")

def validate_amounts(self):
    """Validate monetary amounts"""
    from frappe.utils import flt

    if flt(self.estimated_cost) < 0:
        frappe.throw("Estimated cost cannot be negative")
```

**B. Hook Methods**

```python
def before_save(self):
    """Logic before document is saved"""
    # Auto-populate fields from linked documents
    if self.asset:
        asset = frappe.get_doc("Asset", self.asset)
        self.asset_category = asset.asset_category
        self.location = asset.location

def after_insert(self):
    """Logic after new document is created"""
    # Send notification
    self.notify_asset_manager()

def on_submit(self):
    """Logic when document is submitted"""
    # Create scheduled job
    self.create_maintenance_schedule()

def on_cancel(self):
    """Logic when document is cancelled"""
    # Cancel related records
    self.cancel_related_schedules()
```

**C. Custom Methods**

```python
def create_maintenance_schedule(self):
    """Create maintenance schedule entry"""
    if self.maintenance_type == "Preventive":
        schedule = frappe.get_doc({
            "doctype": "Maintenance Schedule",
            "maintenance_request": self.name,
            "asset": self.asset,
            "schedule_date": self.schedule_date
        })
        schedule.insert()

def notify_asset_manager(self):
    """Send email notification to asset manager"""
    managers = frappe.get_all("User", filters={
        "role_profile_name": "Asset Manager"
    }, pluck="name")

    for manager in managers:
        frappe.sendmail(
            recipients=[manager],
            subject=f"New Maintenance Request: {self.name}",
            message=f"Asset: {self.asset}<br>Type: {self.maintenance_type}"
        )
```

### 2. Implement API Endpoints

For each API endpoint:

**A. Add Permission Checks**

```python
@frappe.whitelist()
def get_asset_maintenance_history(asset_name):
    """
    Get maintenance history for an asset

    Args:
        asset_name (str): Asset name

    Returns:
        list: List of maintenance records
    """
    # Permission check - MANDATORY
    frappe.has_permission("Asset Maintenance Request", "read", throw=True)

    # Validate input
    if not asset_name:
        frappe.throw("Asset name is required")

    # Use parameterized query
    history = frappe.db.sql("""
        SELECT
            name,
            maintenance_type,
            status,
            schedule_date,
            completion_date
        FROM
            `tabAsset Maintenance Request`
        WHERE
            asset = %(asset)s
        ORDER BY
            schedule_date DESC
    """, {"asset": asset_name}, as_dict=1)

    return history
```

**B. Use frappe.utils for Common Operations**

```python
from frappe.utils import (
    flt, cint, cstr,  # Type conversion
    getdate, add_days, date_diff,  # Date operations
    fmt_money, comma_and,  # Formatting
    validate_email_address  # Validation
)

@frappe.whitelist()
def calculate_maintenance_cost(maintenance_request):
    """Calculate total maintenance cost"""
    doc = frappe.get_doc("Asset Maintenance Request", maintenance_request)

    # Use flt() for monetary calculations
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

### 3. Implement Scheduled Jobs

For background jobs:

```python
def daily_maintenance_reminder():
    """
    Scheduled job: Send reminders for pending maintenance
    Runs daily at 9 AM
    """
    from frappe.utils import add_days, today

    # Use ignore_permissions for scheduled jobs
    pending_requests = frappe.get_all(
        "Asset Maintenance Request",
        filters={
            "status": "Pending",
            "schedule_date": ["<=", add_days(today(), 3)]
        },
        fields=["name", "asset", "assigned_to"],
        ignore_permissions=True
    )

    for request in pending_requests:
        if request.assigned_to:
            # Send reminder email
            frappe.sendmail(
                recipients=[request.assigned_to],
                subject=f"Maintenance Reminder: {request.name}",
                message=f"Asset {request.asset} requires maintenance soon."
            )
```

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

Track implementation progress:

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

**[A]** Auto-continue to Step 5 (Implement Client Logic)
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

Update `active.yaml`:
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
**→ Load and execute:** `steps/step-05-implement-client.md`

**If [P]ause:**
STOP here. User can review server logic and resume later.

**If [C]ancel:**
EXIT workflow. Update state and preserve progress.
