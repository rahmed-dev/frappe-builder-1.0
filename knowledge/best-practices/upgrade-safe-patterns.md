# Upgrade-Safe Development Patterns

> Write code that survives Frappe/ERPNext upgrades without breaking.

## Core Principle

**Never modify core files.** Use Frappe's extension points: hooks, custom apps, Custom Fields, Server/Client Scripts.

## Safe Customization Methods

### Tier 1: Configuration (100% Upgrade-Safe)

```
✅ Custom Fields
✅ Custom Forms (Customize Form)
✅ Workflows
✅ Print Formats
✅ Dashboards
✅ Role Permissions
✅ Property Setter
```

**Why safe:** Stored in database, not code. Survives upgrades automatically.

### Tier 2: Scripts (95% Upgrade-Safe)

```
✅ Server Scripts
✅ Client Scripts
✅ Script Reports
✅ Custom DocTypes (in custom app)
```

**Why safe:** Isolated from core, but may need updates if core APIs change.

### Tier 3: Custom Apps (90% Upgrade-Safe)

```
✅ Custom DocTypes
✅ Custom Pages
✅ Hooks
✅ API Methods
```

**Why safe:** Separate app, but depends on Frappe/ERPNext APIs.

### Tier 4: Core Modifications (0% Upgrade-Safe)

```
❌ Modifying core files
❌ Monkey patching core classes
❌ Changing standard DocTypes
```

**Why unsafe:** Overwritten on upgrade.

## Custom Fields (Best Practice)

### ✅ Safe Pattern

```python
# Create via Custom Field DocType
bench --site site-name console
>>> from frappe.custom.doctype.custom_field.custom_field import create_custom_fields
>>> create_custom_fields({
...     'Sales Order': [
...         {
...             'fieldname': 'customer_po_number',
...             'label': 'Customer PO Number',
...             'fieldtype': 'Data',
...             'insert_after': 'customer'
...         }
...     ]
... })

# Or via fixtures in hooks.py
fixtures = [
    {
        "dt": "Custom Field",
        "filters": [["name", "in", ["Sales Order-customer_po_number"]]]
    }
]
```

### ❌ Unsafe Pattern

```python
# WRONG - modifying core JSON file
# apps/erpnext/erpnext/selling/doctype/sales_order/sales_order.json
{
    "fields": [
        {
            "fieldname": "customer_po_number",  # Added to core!
            "fieldtype": "Data"
        }
    ]
}
```

**Problem:** Overwritten on upgrade.

## Hooks (Best Practice)

### ✅ Safe Pattern

```python
# hooks.py
doc_events = {
    "Sales Order": {
        "on_submit": "my_app.custom.sales_order_submitted"
    }
}

# my_app/custom.py
def sales_order_submitted(doc, method):
    """Custom logic when Sales Order is submitted"""
    if doc.grand_total > 10000:
        send_approval_request(doc)
```

### ❌ Unsafe Pattern

```python
# WRONG - modifying core controller
# apps/erpnext/erpnext/selling/doctype/sales_order/sales_order.py
class SalesOrder(Document):
    def on_submit(self):
        super().on_submit()  # Call original
        # Custom logic added to core
        if self.grand_total > 10000:
            send_approval_request(self)
```

**Problem:** Lost on upgrade.

## Extending Core Classes

### ✅ Safe Pattern (Hooks)

```python
# hooks.py
doc_events = {
    "Task": {
        "validate": "my_app.extensions.task_extensions.validate_task"
    }
}

# my_app/extensions/task_extensions.py
def validate_task(doc, method):
    """Add custom validation without modifying core"""
    if doc.status == 'Completed' and not doc.completed_date:
        frappe.throw('Completed date required')
```

### ⚠️ Use Sparingly (Monkey Patching)

```python
# my_app/overrides.py
import frappe
from erpnext.selling.doctype.sales_order.sales_order import SalesOrder

# Store original method
_original_validate = SalesOrder.validate

def custom_validate(self):
    """Extended validation"""
    _original_validate(self)  # Call original
    # Add custom logic
    if self.custom_field:
        validate_custom_field(self)

# Override
SalesOrder.validate = custom_validate

# Call in hooks.py app_include_py
app_include_py = "my_app/overrides.py"
```

**Risk:** Medium. May break if core method signature changes.

## Custom DocTypes

### ✅ Safe Pattern

```python
# In custom app: my_app/my_app/doctype/my_doctype/
{
    "doctype": "DocType",
    "module": "My App",
    "custom": 1,  # Mark as custom
    "name": "My Custom DocType"
}
```

**Why safe:** Lives in custom app, isolated from core.

### Link to Core DocTypes Safely

```python
# Custom DocType linking to core
{
    "fieldname": "sales_order",
    "fieldtype": "Link",
    "options": "Sales Order"  # Core DocType
}
```

**Safe because:** Uses Link field, not direct modification.

## API Version Compatibility

### ✅ Safe Pattern

```python
# Check if method exists before using
def get_customer_balance(customer):
    # Try new API
    if hasattr(frappe, 'get_customer_outstanding'):
        return frappe.get_customer_outstanding(customer)

    # Fallback to old API
    from erpnext.accounts.utils import get_balance_on
    return get_balance_on(party_type='Customer', party=customer)
```

### ✅ Use Frappe Utils (Stable APIs)

```python
# These are stable across versions
from frappe.utils import (
    flt, cint, cstr, nowdate, now,
    add_days, getdate, get_datetime,
    fmt_money, validate_email_address
)
```

## Database Changes

### ✅ Safe Pattern (Custom Fields)

```python
# Add field via Custom Field
# Migrates automatically on bench update
```

### ❌ Unsafe Pattern

```python
# WRONG - direct ALTER TABLE
frappe.db.sql("ALTER TABLE `tabSales Order` ADD COLUMN custom_field VARCHAR(255)")
```

**Problem:** Not tracked, may conflict with core schema.

## Print Formats

### ✅ Safe Pattern

```python
# Create custom print format (don't modify standard)
# My Custom Invoice.html (saved as Custom Print Format)

# Reference core data
{{ doc.customer_name }}
{{ doc.grand_total }}

# Use custom fields
{{ doc.custom_po_number }}
```

### ❌ Unsafe Pattern

```html
<!-- WRONG - modifying standard print format -->
<!-- apps/erpnext/erpnext/selling/print_format/standard/standard.html -->
<!-- Modified core file -->
```

## Client Scripts

### ✅ Safe Pattern

```javascript
// Client Script for Sales Order
frappe.ui.form.on('Sales Order', {
    onload: function(frm) {
        // Don't modify core behavior, add new behavior
        add_custom_buttons(frm);
    }
});

function add_custom_buttons(frm) {
    frm.add_custom_button('Custom Action', () => {
        // Custom logic
    });
}
```

### ❌ Unsafe Pattern

```javascript
// WRONG - overriding core method entirely
frappe.ui.form.on('Sales Order', {
    refresh: function(frm) {
        // Completely replaces core refresh logic!
        // Core buttons, actions lost
    }
});
```

## Upgr ade Testing Checklist

**Before upgrading:**

- [ ] Backup database and files
- [ ] Test in staging environment first
- [ ] Review Frappe/ERPNext release notes
- [ ] Check for deprecated APIs
- [ ] Verify custom apps compatibility
- [ ] Test critical business workflows
- [ ] Check Custom Fields still load
- [ ] Verify print formats work
- [ ] Test whitelisted API methods
- [ ] Check background jobs run
- [ ] Review error logs after upgrade

## Version-Specific Code

### ✅ Safe Pattern

```python
import frappe

def get_customer_data(customer):
    # Check Frappe version
    version = frappe.__version__

    if version.startswith('14.'):
        # ERPNext v14 logic
        return get_customer_v14(customer)
    elif version.startswith('15.'):
        # ERPNext v15 logic
        return get_customer_v15(customer)
    else:
        # Fallback
        return get_customer_legacy(customer)
```

## Fixture Management

### ✅ Safe Pattern

```python
# hooks.py
fixtures = [
    {
        "dt": "Custom Field",
        "filters": [["module", "=", "My App"]]
    },
    {
        "dt": "Property Setter",
        "filters": [["module", "=", "My App"]]
    },
    "Workflow",
    "Workflow State",
    "Workflow Action Master"
]
```

```bash
# Export fixtures
bench --site site-name export-fixtures

# Auto-imported on app install
bench --site site-name install-app my_app
```

## Migration Scripts

### ✅ Safe Pattern

```python
# my_app/patches.txt
my_app.patches.v1_0.migrate_custom_data

# my_app/patches/v1_0/migrate_custom_data.py
import frappe

def execute():
    """Run once on upgrade"""
    # Add custom field data
    for task in frappe.get_all('Task'):
        doc = frappe.get_doc('Task', task.name)
        if not doc.custom_category:
            doc.custom_category = 'General'
            doc.save()

    frappe.db.commit()
```

**Safe because:** Runs once, doesn't modify core files.

## Handling Breaking Changes

### When Core API Changes

```python
# Old API (deprecated in v15)
def old_method():
    return frappe.db.get_value('Customer', customer, 'customer_name')

# New API (v15+)
def new_method():
    return frappe.db.get_value('Customer', customer, 'customer_name')

# Compatible wrapper
def get_customer_name(customer):
    try:
        # Try new method
        return frappe.get_cached_value('Customer', customer, 'customer_name')
    except AttributeError:
        # Fallback to old method
        return frappe.db.get_value('Customer', customer, 'customer_name')
```

## Documentation

### Track Customizations

```markdown
# CUSTOMIZATIONS.md

## Custom Fields
- Sales Order: customer_po_number (Data)
- Task: custom_category (Select)

## Hooks
- Sales Order: on_submit → my_app.custom.sales_order_submitted

## Custom DocTypes
- My Custom DocType

## API Methods
- my_app.api.get_tasks
- my_app.api.process_order

## Dependencies
- Frappe >= 14.0.0
- ERPNext >= 14.0.0
```

## Key Rules

- ✅ NEVER modify core files
- ✅ Use Custom Fields for new fields
- ✅ Use hooks for extending behavior
- ✅ Use fixtures for deployment
- ✅ Test upgrades in staging first
- ✅ Check version compatibility
- ✅ Document all customizations
- ✅ Use stable Frappe APIs (frappe.utils)
- ✅ Wrap deprecated APIs for compatibility
- ✅ Keep custom apps separate from core
- ❌ Don't modify core DocType JSON files
- ❌ Don't change standard Print Formats
- ❌ Don't use undocumented APIs
- ❌ Don't skip testing after upgrade
