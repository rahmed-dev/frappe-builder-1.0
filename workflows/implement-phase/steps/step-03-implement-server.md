---
name: "Implement Server-Side Logic"
step: 3
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

---

## Continue in Part B

**→ Load and execute:** `steps/step-03b-implement-server.md`

Part B covers: frappe.utils patterns, scheduled jobs, best practices, checklist, menu and state update.
