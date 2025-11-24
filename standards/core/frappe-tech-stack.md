# Frappe Tech Stack Reference

Quick reference for Frappe/ERPNext architecture and technology choices.

## Architecture

**Client-Server Pattern:**
```
Browser (Desk UI)
    ↓ frappe.call()
Server (@frappe.whitelist())
    ↓ frappe.db.*
MariaDB
```

**Technology Stack:**
- **Backend:** Python 3.10+, Frappe Framework
- **Frontend:** JavaScript (ES6+), jQuery, frappe.ui
- **Database:** MariaDB 10.6+
- **Queue:** Redis
- **Web Server:** Nginx + Gunicorn
- **Search:** Full-text (MariaDB) or Elasticsearch

## Request Flow

```
1. User action in Browser
2. frappe.call({method: "app.module.method", args: {...}})
3. Hits @frappe.whitelist() decorated Python function
4. Function uses frappe.db.* for database operations
5. Response returns to browser as JSON
6. JavaScript updates UI
```

## Core Modules

| Module | Purpose | Common Usage |
|--------|---------|--------------|
| frappe.db | Database operations | All CRUD: get_value, get_all, set_value, sql |
| frappe.utils | Utility functions | Date/time, numbers, strings, validation |
| frappe.ui | UI components | Dialog, DataTable, Form, List, Tree |
| frappe.permissions | Access control | has_permission, get_user_permissions |
| frappe.model | Document operations | get_doc, new_doc, delete_doc |
| frappe.cache | Caching layer | redis_cache, cache_manager |
| frappe.email | Email handling | sendmail, get_email_queue |
| frappe.queue | Background jobs | enqueue, enqueue_doc |

## 4-Tier Framework

**Customization Strategy (Configure-First Approach):**

| Tier | Method | Dev Time | When to Use | Example |
|------|--------|----------|-------------|---------|
| **1. Standard** | Use ERPNext as-is | 0 min | Feature exists OOTB | Sales Order workflow |
| **2. Configure** | Customize + Custom Fields | 5-30 min | Extend existing DocType | Add "Delivery Notes" field to SO |
| **3. Scripts** | Server/Client Scripts | 30 min - 4 hrs | Add behavior without app | Auto-calculate discount |
| **4. Custom App** | Full development | Days - Weeks | New business logic/DocTypes | Complete CRM customization |

**Decision Tree:**
```
Need feature?
├─ ERPNext has it? → Tier 1 (Standard)
├─ Can extend existing DocType? → Tier 2 (Configure)
├─ Simple automation? → Tier 3 (Scripts)
└─ Complex/Multiple DocTypes? → Tier 4 (Custom App)
```

## API Patterns

### Server-Side (Python)

**Database Queries:**
```python
# Single field
value = frappe.db.get_value("DocType", name, "field")

# Single document
doc = frappe.get_doc("DocType", name)

# Multiple documents with filters
docs = frappe.get_all("DocType",
    filters={"status": "Open"},
    fields=["name", "customer", "total"])

# Raw SQL (parameterized)
data = frappe.db.sql("""
    SELECT name, total FROM `tabSales Order`
    WHERE customer=%s AND status=%s
""", (customer, status), as_dict=True)
```

**Whitelisted Methods:**
```python
@frappe.whitelist()
def my_api_method(doctype, name):
    # ALWAYS check permissions first
    if not frappe.has_permission(doctype, "read", name):
        frappe.throw("No permission")

    doc = frappe.get_doc(doctype, name)
    return doc.as_dict()
```

### Client-Side (JavaScript)

**Call Server:**
```javascript
frappe.call({
    method: "app.module.method",
    args: {arg1: "value1", arg2: "value2"},
    callback: function(r) {
        if (!r.exc) {
            console.log(r.message);
        }
    }
});
```

**UI Components:**
```javascript
// Dialog
let d = new frappe.ui.Dialog({
    title: "Select Customer",
    fields: [{fieldname: "customer", fieldtype: "Link", options: "Customer"}],
    primary_action_label: "Submit",
    primary_action: (values) => {
        console.log(values.customer);
        d.hide();
    }
});
d.show();

// Message
frappe.msgprint("Document saved");
frappe.throw("Error occurred"); // Shows error and stops execution
```

## Common Anti-Patterns

**❌ DON'T DO THIS:**

| Anti-Pattern | Why Bad | ✅ Do This Instead |
|--------------|---------|-------------------|
| Custom HTML/CSS | Breaks on updates | Use frappe.ui components |
| Client-side filtering | Loads all data | Server-side filters in get_all |
| SQL string concat | SQL injection | Parameterized queries |
| Skip @frappe.whitelist() | Security hole | Always use decorator + permission check |
| Reinvent frappe.utils | Bugs + maintenance | Use frappe.utils.getdate(), flt(), etc. |
| Business logic in JS | Hard to test/maintain | Keep logic server-side (Python) |
| get_doc for single field | Slow (loads entire doc) | Use get_value() |

## DocType Structure

**Standard DocType Files:**
```
app_name/
└── app_name/
    └── doctype/
        └── sales_order/
            ├── sales_order.json         # DocType definition
            ├── sales_order.py           # Server controller
            ├── sales_order.js           # Client script
            ├── sales_order_list.js      # List view customization
            └── test_sales_order.py      # Unit tests
```

**Controller Hooks (sales_order.py):**
```python
class SalesOrder(Document):
    def validate(self):          # Before save
        self.calculate_total()

    def on_submit(self):         # After submit
        self.create_delivery_note()

    def on_cancel(self):         # On cancel
        self.reverse_stock_entry()

    def on_trash(self):          # Before delete
        self.check_linked_docs()
```

## Hooks System

**hooks.py - App-level configurations:**
```python
# Document events
doc_events = {
    "Sales Order": {
        "validate": "app.module.validate_sales_order",
        "on_submit": "app.module.on_sales_order_submit"
    }
}

# Scheduled jobs
scheduler_events = {
    "daily": ["app.tasks.daily_job"],
    "hourly": ["app.tasks.hourly_job"]
}

# Override standard methods
override_whitelisted_methods = {
    "frappe.desk.form.save.savedocs": "app.overrides.custom_save"
}
```

## Performance Guidelines

**Database:**
- ✅ Use get_value() for single fields
- ✅ Use filters in get_all() (server-side)
- ✅ Add indexes for frequently filtered fields
- ❌ Don't use get_doc() just to read one field
- ❌ Don't filter in JavaScript after loading all records

**Caching:**
```python
# Cache expensive operations
@frappe.cache()
def get_exchange_rate(from_currency, to_currency):
    # Expensive API call
    return rate
```

**Background Jobs:**
```python
# Enqueue long-running operations
frappe.enqueue(
    method="app.tasks.send_bulk_emails",
    queue="long",  # Options: short, default, long
    timeout=3000,
    recipients=recipients
)
```

## Security Checklist

**Every @frappe.whitelist() method MUST:**
- [ ] Check permissions: `frappe.has_permission()`
- [ ] Validate input data
- [ ] Use parameterized queries (never string concat)
- [ ] Sanitize user input if displaying: `frappe.utils.escape_html()`

## Version Compatibility

**Check version-specific features:**
```python
import frappe
if frappe.version.major_version >= 15:
    # v15+ feature
else:
    # Fallback for v14
```

**Common v14 → v15 Changes:**
- Form scripts: refresh() → reload()
- Some API method signatures changed
- New Dashboard 2.0 (optional)

## Related Resources

- **Official Docs:** frappeframework.com/docs
- **ERPNext Docs:** docs.erpnext.com
- **Hussain's Guide:** manual.buildwithhussain.com
- **Source Code:** github.com/frappe/frappe, github.com/frappe/erpnext
