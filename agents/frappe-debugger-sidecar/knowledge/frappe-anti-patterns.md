# Frappe Anti-Patterns - What NOT to Do

## Overview

This document catalogs common Frappe anti-patterns - things that "work" but are wrong, risky, or unmaintainable. Each anti-pattern includes WHY it's wrong, the RISK, and the Frappe-native ALTERNATIVE.

---

## Critical Anti-Patterns (Security/Data Risk)

### 1. SQL Injection Vulnerability

#### ❌ WRONG
```python
item_code = request_data.get("item_code")
results = frappe.db.sql(f"SELECT * FROM `tabItem` WHERE item_code = '{item_code}'")
```

#### ✅ RIGHT
```python
item_code = request_data.get("item_code")
results = frappe.db.sql("SELECT * FROM `tabItem` WHERE item_code = %s", (item_code,))
```

**Why Wrong:** String concatenation allows SQL injection attacks.
**Risk:** CRITICAL - Attacker can read/modify/delete any data in database.
**Fix:** Always use parameterized queries (`%s` placeholders).

---

### 2. Missing @frappe.whitelist() Decorator

#### ❌ WRONG
```python
def my_api_method(param):
    """Exposed API but no decorator"""
    return process(param)
```

#### ✅ RIGHT
```python
@frappe.whitelist()
def my_api_method(param):
    """Properly exposed API"""
    return process(param)
```

**Why Wrong:** Without decorator, method is NOT accessible via frappe.call().
**Risk:** HIGH - API doesn't work, OR if it somehow works, bypasses security checks.
**Fix:** Always decorate with `@frappe.whitelist()`.

---

### 3. Missing Permission Checks

#### ❌ WRONG
```python
@frappe.whitelist()
def delete_item(item_code):
    frappe.delete_doc("Item", item_code)
```

#### ✅ RIGHT
```python
@frappe.whitelist()
def delete_item(item_code):
    if not frappe.has_permission("Item", "delete"):
        frappe.throw(_("No permission"), frappe.PermissionError)
    frappe.delete_doc("Item", item_code)
```

**Why Wrong:** Any user can call API and delete data.
**Risk:** CRITICAL - Unauthorized data modification/deletion.
**Fix:** Check permissions with `frappe.has_permission()`.

---

### 4. Exposing Sensitive Data Without Checks

#### ❌ WRONG
```python
@frappe.whitelist()
def get_all_salaries():
    return frappe.get_all("Salary Slip", fields=["employee", "gross_pay"])
```

#### ✅ RIGHT
```python
@frappe.whitelist()
def get_employee_salary(employee):
    # Check user can only see their own salary
    if frappe.session.user != employee and not frappe.has_permission("Salary Slip", "read"):
        frappe.throw(_("No permission"), frappe.PermissionError)

    return frappe.get_all(
        "Salary Slip",
        filters={"employee": employee},
        fields=["employee", "gross_pay"]
    )
```

**Why Wrong:** Exposes sensitive data to all users.
**Risk:** CRITICAL - Privacy violation, data leakage.
**Fix:** Filter data by user permissions, check access rights.

---

## Important Anti-Patterns (Performance/Maintainability)

### 5. Client-Side Filtering (Performance Issue)

#### ❌ WRONG
```javascript
frappe.call({
    method: 'frappe.client.get_list',
    args: {
        doctype: 'Item',
        fields: ['name', 'item_name', 'status']
    },
    callback: function(r) {
        // Filtering 10,000 items in browser (SLOW!)
        let active_items = r.message.filter(item => item.status === 'Active');
        display_items(active_items);
    }
});
```

#### ✅ RIGHT
```javascript
frappe.call({
    method: 'frappe.client.get_list',
    args: {
        doctype: 'Item',
        fields: ['name', 'item_name', 'status'],
        filters: {status: 'Active'}  // Filter on SERVER (FAST!)
    },
    callback: function(r) {
        display_items(r.message);
    }
});
```

**Why Wrong:** Fetches ALL data, then filters in browser.
**Risk:** HIGH - Slow performance, high memory usage, poor UX.
**Fix:** Always filter on server-side (database level).

---

### 6. N+1 Query Problem

#### ❌ WRONG
```python
# Fetches items (1 query), then customer for EACH item (N queries)
items = frappe.get_all("Sales Order Item", fields=["parent", "item_code"])
for item in items:
    order = frappe.get_doc("Sales Order", item.parent)  # N queries!
    customer = order.customer
```

#### ✅ RIGHT
```python
# Single query with join
items = frappe.get_all(
    "Sales Order Item",
    fields=["parent", "item_code", "parent.customer as customer"],  # Join parent
)
# Access: item.customer (no additional queries)
```

**Why Wrong:** Executes N+1 queries (1 + N) instead of 1 query.
**Risk:** HIGH - Extremely slow with large datasets.
**Fix:** Use joins or fetch related data in single query.

---

### 7. Custom HTML/CSS Instead of Frappe UI

#### ❌ WRONG
```javascript
frm.fields_dict.html_field.$wrapper.html(`
    <div class="custom-modal">
        <input type="text" id="my-field" class="form-control">
        <button onclick="submitData()" class="btn btn-primary">Submit</button>
    </div>
`);
```

#### ✅ RIGHT
```javascript
let d = new frappe.ui.Dialog({
    title: 'Enter Details',
    fields: [
        {fieldname: 'my_field', fieldtype: 'Data', label: 'My Field'}
    ],
    primary_action_label: 'Submit',
    primary_action(values) {
        submitData(values.my_field);
    }
});
d.show();
```

**Why Wrong:** Custom HTML breaks on Frappe upgrades, inconsistent UI.
**Risk:** MEDIUM - Maintenance burden, upgrade compatibility issues.
**Fix:** Use `frappe.ui.Dialog`, `frappe.ui.form`, and other native components.

---

### 8. Not Using frappe.utils (Reinventing the Wheel)

#### ❌ WRONG
```python
from datetime import datetime, timedelta

# Custom date handling
today = datetime.now().date()
future_date = today + timedelta(days=7)
formatted = future_date.strftime("%Y-%m-%d")
```

#### ✅ RIGHT
```python
from frappe.utils import getdate, add_days, formatdate

# Frappe date handling (timezone-aware, user format support)
today = getdate()
future_date = add_days(today, 7)
formatted = formatdate(future_date)  # Respects user's date format
```

**Why Wrong:** Custom code doesn't respect user timezone/format settings.
**Risk:** MEDIUM - Timezone bugs, wrong date display for users.
**Fix:** Always use `frappe.utils` for dates, numbers, strings.

**Common frappe.utils Functions:**
- `getdate()` - Get date object
- `add_days(date, days)` - Add days to date
- `add_months(date, months)` - Add months
- `add_years(date, years)` - Add years
- `get_datetime(date)` - Get datetime object
- `now_datetime()` - Current datetime with timezone
- `flt(value, precision)` - Convert to float
- `cint(value)` - Convert to int
- `fmt_money(amount, currency)` - Format money

---

### 9. Unnecessary Data Fetching

#### ❌ WRONG
```python
# Fetching entire document when only need one field
doc = frappe.get_doc("Sales Order", name)
customer = doc.customer
```

#### ✅ RIGHT
```python
# Fetch only needed field (much faster!)
customer = frappe.db.get_value("Sales Order", name, "customer")
```

**Why Wrong:** Loads entire document (all fields, child tables, etc.).
**Risk:** MEDIUM - Slow performance, unnecessary database load.
**Fix:** Use `frappe.db.get_value()` for single field, `frappe.db.get_all()` with specific fields.

---

### 10. Missing ignore_permissions in Schedulers

#### ❌ WRONG
```python
def daily_cleanup():
    """Daily scheduled task"""
    # PermissionError! Background jobs don't have user context
    orders = frappe.get_all("Sales Order", filters={"status": "Draft"})
    for order in orders:
        process(order)
```

#### ✅ RIGHT
```python
def daily_cleanup():
    """Daily scheduled task"""
    # Scheduler needs ignore_permissions=True
    orders = frappe.get_all(
        "Sales Order",
        filters={"status": "Draft"},
        ignore_permissions=True
    )
    for order in orders:
        process(order)
```

**Why Wrong:** Scheduled tasks run without user context → PermissionError.
**Risk:** HIGH - Background jobs fail silently.
**Fix:** Always use `ignore_permissions=True` in scheduled tasks.

---

## Minor Anti-Patterns (Code Quality)

### 11. console.log() in Production Code

#### ❌ WRONG
```javascript
frappe.ui.form.on('Sales Order', {
    refresh: function(frm) {
        console.log('Form loaded', frm.doc);  // LEFT IN PRODUCTION!
        // ... actual code ...
    }
});
```

#### ✅ RIGHT
```javascript
frappe.ui.form.on('Sales Order', {
    refresh: function(frm) {
        // No console.log in production
        // ... actual code ...
    }
});
```

**Why Wrong:** Logging large objects slows browser, clutters console.
**Risk:** LOW - Performance degradation, unprofessional.
**Fix:** Remove all `console.log()` before production. Use `frappe.logger()` if needed.

---

### 12. Not Converting Form Values (Type Errors)

#### ❌ WRONG
```python
@frappe.whitelist()
def calculate(qty, rate):
    # TypeError if qty/rate are strings (JS sends strings!)
    total = qty * rate
    return total
```

#### ✅ RIGHT
```python
from frappe.utils import flt, cint

@frappe.whitelist()
def calculate(qty, rate):
    # Always convert form values
    qty = cint(qty) if qty else 0
    rate = flt(rate)
    total = qty * rate
    return total
```

**Why Wrong:** JavaScript form sends "10" (string), not 10 (int).
**Risk:** MEDIUM - TypeError crashes API.
**Fix:** Always convert with `flt()` or `cint()` at API boundary.

---

### 13. Not Disabling Submit Button in Dialogs

#### ❌ WRONG
```javascript
let d = new frappe.ui.Dialog({
    title: 'Enter Details',
    fields: [{fieldname: 'field1', fieldtype: 'Data'}],
    primary_action(values) {
        frappe.call({
            method: 'app.method',
            args: values,
            callback: function(r) {
                d.hide();
            }
        });
    }
});
d.show();
```

#### ✅ RIGHT
```javascript
let d = new frappe.ui.Dialog({
    title: 'Enter Details',
    fields: [{fieldname: 'field1', fieldtype: 'Data'}],
    primary_action(values) {
        // Prevent duplicate submissions
        d.get_primary_btn().prop('disabled', true);

        frappe.call({
            method: 'app.method',
            args: values,
            callback: function(r) {
                d.hide();
            },
            error: function() {
                // Re-enable if error
                d.get_primary_btn().prop('disabled', false);
            }
        });
    }
});
d.show();
```

**Why Wrong:** User can click "Submit" multiple times → duplicate records.
**Risk:** MEDIUM - Duplicate data creation.
**Fix:** Disable button on click, re-enable on error.

---

### 14. Missing frappe.db.commit() in Scheduler Loops

#### ❌ WRONG
```python
def daily_task():
    """Process 10,000 records"""
    records = frappe.get_all("DocType", ignore_permissions=True)
    for rec in records:
        process(rec)  # All 10,000 in single transaction!
    # If error at record 9999, ALL 10,000 rollback!
```

#### ✅ RIGHT
```python
def daily_task():
    """Process 10,000 records"""
    records = frappe.get_all("DocType", ignore_permissions=True)
    for rec in records:
        try:
            process(rec)
            frappe.db.commit()  # Commit per record (safe!)
        except Exception as e:
            frappe.log_error(title=f"Error: {rec.name}", message=str(e))
```

**Why Wrong:** Single transaction = all-or-nothing. One error = all lost.
**Risk:** MEDIUM - Data loss on error in large batch jobs.
**Fix:** Commit per record in loops, catch exceptions individually.

---

### 15. Not Building App After JS Changes

#### ❌ WRONG
```
1. Edit apps/custom_app/public/js/script.js
2. Refresh browser
3. Changes don't appear!
```

#### ✅ RIGHT
```bash
# After JS changes, ALWAYS build
bench build --app custom_app

# OR watch mode during development
bench watch
```

**Why Wrong:** JS files need to be bundled before browser can see them.
**Risk:** LOW - Confusion, "my changes don't work!"
**Fix:** Run `bench build --app [app]` after JS changes.

---

## Architecture Anti-Patterns

### 16. Business Logic in Client Scripts (Should Be Server-Side)

#### ❌ WRONG
```javascript
frappe.ui.form.on('Sales Order', {
    qty: function(frm) {
        // Complex discount calculation in JavaScript!
        let discount = 0;
        if (frm.doc.customer_type === 'Wholesale') {
            if (frm.doc.qty > 100) discount = 15;
            else if (frm.doc.qty > 50) discount = 10;
            else discount = 5;
        }
        frm.set_value('discount_percentage', discount);
    }
});
```

#### ✅ RIGHT
```python
# In DocType controller (server-side)
class SalesOrder(Document):
    def validate(self):
        self.calculate_discount()

    def calculate_discount(self):
        """Business logic on server (secure, testable, auditable)"""
        if self.customer_type == "Wholesale":
            if self.qty > 100:
                self.discount_percentage = 15
            elif self.qty > 50:
                self.discount_percentage = 10
            else:
                self.discount_percentage = 5
```

```javascript
// Client Script (just triggers refresh)
frappe.ui.form.on('Sales Order', {
    qty: function(frm) {
        frm.trigger('calculate_discount');  // Calls server method
    }
});
```

**Why Wrong:** Business logic in JS can be bypassed, not auditable.
**Risk:** HIGH - Security, data integrity, maintainability.
**Fix:** Business logic in Python (controller), JS only for UI behavior.

---

### 17. Not Using Hooks for Events

#### ❌ WRONG
```python
# Manually calling function from everywhere
from custom_app.custom_module import update_stock

def process_sales_order():
    # ... code ...
    update_stock()  # Manually called
```

#### ✅ RIGHT
```python
# In hooks.py
doc_events = {
    "Sales Order": {
        "on_submit": "custom_app.custom_module.update_stock"
    }
}
```

```python
# In custom_app/custom_module.py
def update_stock(doc, method):
    """Automatically called on Sales Order submit"""
    # ... stock update logic ...
```

**Why Wrong:** Manual calls are fragile, easy to forget.
**Risk:** MEDIUM - Logic not executed, inconsistent behavior.
**Fix:** Use `doc_events` hooks in hooks.py for automatic event handling.

---

### 18. Hardcoding Values (Should Be Configurable)

#### ❌ WRONG
```python
def calculate_tax(amount):
    TAX_RATE = 0.18  # Hardcoded 18% (what if it changes?)
    return amount * TAX_RATE
```

#### ✅ RIGHT
```python
# Create "Tax Settings" DocType with tax_rate field

def calculate_tax(amount):
    settings = frappe.get_single("Tax Settings")
    return amount * flt(settings.tax_rate) / 100
```

**Why Wrong:** Hardcoded values require code changes to update.
**Risk:** MEDIUM - Maintenance burden, deployment for config changes.
**Fix:** Store configuration in Settings DocType, make it user-editable.

---

### 19. Not Using Property Setters

#### ❌ WRONG
```javascript
// Hiding field via Client Script
frappe.ui.form.on('Sales Order', {
    refresh: function(frm) {
        frm.set_df_property('discount', 'hidden', 1);  // Every form load!
    }
});
```

#### ✅ RIGHT
```
Use Customize Form → Property Setter:
DocType: Sales Order
Field: discount
Property: hidden
Value: 1
```

**Why Wrong:** Client Script runs every form load (unnecessary processing).
**Risk:** LOW - Minor performance impact.
**Fix:** Use Property Setters for static field properties.

---

### 20. Not Registering Overrides in hooks.py

#### ❌ WRONG
```python
# Custom app overrides standard method but NOT registered
# apps/custom_app/overrides/sales_order.py
def custom_validate(self):
    # Custom validation
    pass

# Frappe doesn't know about this!
```

#### ✅ RIGHT
```python
# In hooks.py
override_doctype_class = {
    "Sales Order": "custom_app.overrides.sales_order.CustomSalesOrder"
}
```

```python
# In custom_app/overrides/sales_order.py
from erpnext.selling.doctype.sales_order.sales_order import SalesOrder

class CustomSalesOrder(SalesOrder):
    def validate(self):
        super().validate()  # Call parent
        self.custom_validate()  # Then custom

    def custom_validate(self):
        # Custom validation
        pass
```

**Why Wrong:** Override not registered = not executed.
**Risk:** HIGH - Custom logic silently ignored.
**Fix:** Register all overrides in `hooks.py`.

---

## Diagnostic Anti-Patterns

### 21. Not Checking Logs After Errors

#### ❌ WRONG
```
User: "It's not working"
Developer: "Let me guess what's wrong..."
```

#### ✅ RIGHT
```bash
# ALWAYS check logs first!
tail -50 sites/[site]/logs/error.log
```

**Why Wrong:** Guessing wastes time, logs have the answer.
**Risk:** LOW - Wasted debugging time.
**Fix:** Check error.log, web.log, scheduler.log FIRST.

---

### 22. Not Using EXPLAIN for Slow Queries

#### ❌ WRONG
```
Query is slow...
Developer: "Maybe I need to add an index? Which one?"
```

#### ✅ RIGHT
```bash
bench --site [site] mariadb
> EXPLAIN SELECT * FROM `tabItem` WHERE custom_field = 'value';

# Check "type" column:
# ALL = table scan (BAD!)
# index = using index (GOOD!)
```

**Why Wrong:** Guessing which index to add.
**Risk:** LOW - Wrong index doesn't help.
**Fix:** Use EXPLAIN to see query execution plan.

---

## Quick Reference: Frappe Alternatives

| Instead of... | Use Frappe Built-in... |
|---------------|------------------------|
| `from datetime import datetime` | `from frappe.utils import getdate, add_days` |
| `round(value, 2)` | `from frappe.utils import flt` |
| Custom HTML modal | `frappe.ui.Dialog` |
| Custom email sending | `frappe.sendmail()` |
| Manual permission checks | `frappe.has_permission()` |
| String concatenation in SQL | Parameterized queries (`%s`) |
| Client-side filtering | Server-side filters |
| `frappe.get_doc()` for one field | `frappe.db.get_value()` |
| Hardcoded values | Settings DocType |
| Client Script for business logic | Controller methods (Python) |

---

## Anti-Pattern Detection Checklist

When reviewing code, check for:

**Critical (Security/Data):**
- [ ] SQL injection (string concatenation in queries)
- [ ] Missing @frappe.whitelist() decorators
- [ ] Missing permission checks
- [ ] Exposing sensitive data without checks

**Important (Performance):**
- [ ] Client-side filtering
- [ ] N+1 query problems
- [ ] Unnecessary data fetching
- [ ] Missing indexes on frequently queried fields

**Architecture:**
- [ ] Business logic in Client Scripts (should be server-side)
- [ ] Not using hooks for events
- [ ] Hardcoded values (should be configurable)
- [ ] Custom HTML/CSS instead of frappe.ui

**Code Quality:**
- [ ] console.log() in production
- [ ] Not converting form values (type errors)
- [ ] Not using frappe.utils
- [ ] Not disabling submit buttons
- [ ] Missing frappe.db.commit() in scheduler loops

---

**Use this as your anti-pattern radar. When you see these patterns, flag them immediately and suggest the Frappe-native alternative.**
