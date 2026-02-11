# Anti-Patterns Checklist

Common Frappe anti-patterns, security vulnerabilities, and code quality issues to scan for during validation.

---

## CRITICAL Anti-Patterns (Security & Data Integrity)

### 1. Missing @frappe.whitelist() Decorator

**❌ Anti-Pattern:**
```python
# Function is exposed but not whitelisted
def get_sensitive_data(user):
    return frappe.db.get_list("Private Data", filters={"user": user})
```

**✅ Correct:**
```python
@frappe.whitelist()
def get_sensitive_data(user):
    frappe.has_permission("Private Data", "read", throw=True)
    return frappe.db.get_list("Private Data", filters={"user": user})
```

**Impact:** Function not accessible from client, or worse - security risk if somehow exposed
**Severity:** CRITICAL
**Scan Pattern:** Python functions without `@frappe.whitelist()` that appear to be API endpoints

---

### 2. SQL Injection Risks

**❌ Anti-Pattern:**
```python
# String concatenation in SQL
user_input = frappe.form_dict.get("name")
data = frappe.db.sql(f"SELECT * FROM `tabUser` WHERE name = '{user_input}'")

# String formatting
data = frappe.db.sql("SELECT * FROM `tabUser` WHERE name = '%s'" % name)

# Unsafe condition building
conditions = f"status = '{status}' AND date = '{date}'"
```

**✅ Correct:**
```python
# Parameterized query
data = frappe.db.sql("""
    SELECT * FROM `tabUser`
    WHERE name = %(name)s
""", {"name": user_input})

# Multiple parameters
data = frappe.db.sql("""
    SELECT * FROM `tabDocType`
    WHERE status = %(status)s AND date = %(date)s
""", {"status": status, "date": date})
```

**Impact:** SQL injection vulnerability - attacker can execute arbitrary SQL
**Severity:** CRITICAL
**Scan Pattern:**
- `frappe.db.sql(` with f-strings or `.format()`
- `frappe.db.sql(` with `%` string formatting
- `frappe.db.sql(` with `+` string concatenation

---

### 3. Missing Permission Checks in API Endpoints

**❌ Anti-Pattern:**
```python
@frappe.whitelist()
def delete_record(docname):
    # No permission check - anyone can delete!
    frappe.delete_doc("Important DocType", docname)
    return {"status": "deleted"}
```

**✅ Correct:**
```python
@frappe.whitelist()
def delete_record(docname):
    frappe.has_permission("Important DocType", "delete", doc=docname, throw=True)
    frappe.delete_doc("Important DocType", docname)
    return {"status": "deleted"}
```

**Impact:** Unauthorized users can perform privileged operations
**Severity:** CRITICAL
**Scan Pattern:** `@frappe.whitelist()` functions without `frappe.has_permission()` call

---

### 4. Direct Database Modifications Without Validation

**❌ Anti-Pattern:**
```python
# Bypasses controller validation and hooks
frappe.db.set_value("Sales Order", order_name, "status", "Completed")
frappe.db.sql("UPDATE `tabSales Order` SET status = 'Completed'")
```

**✅ Correct:**
```python
# Use get_doc and save to trigger validations and hooks
doc = frappe.get_doc("Sales Order", order_name)
doc.status = "Completed"
doc.save()  # Triggers validate(), before_save(), etc.
```

**Impact:** Business logic, validations, and hooks are bypassed
**Severity:** CRITICAL
**Scan Pattern:**
- `frappe.db.set_value()` used for business-critical fields
- `frappe.db.sql("UPDATE ...)` queries

---

## HIGH-Priority Anti-Patterns (Code Quality & Logic)

### 5. Business Logic in Client Scripts

**❌ Anti-Pattern:**
```javascript
// Complex business logic on client
frappe.ui.form.on('Sales Order', {
    calculate_total: function(frm) {
        let total = 0;
        frm.doc.items.forEach(item => {
            let tax_rate = get_tax_rate(item.tax_category);  // Complex logic
            let discount = calculate_discount(item, frm.doc.customer_group);
            let item_total = (item.qty * item.rate) * (1 + tax_rate) * (1 - discount);
            total += item_total;
        });

        // Discount rules
        if (frm.doc.customer_group === 'Wholesale' && total > 10000) {
            total = total * 0.95;
        }

        frm.set_value('grand_total', total);
    }
});
```

**✅ Correct:**
```javascript
// Call server method for business logic
frappe.ui.form.on('Sales Order', {
    calculate_total: function(frm) {
        frappe.call({
            method: 'app.api.calculate_order_total',
            args: { doc: frm.doc },
            callback: function(r) {
                frm.set_value('grand_total', r.message.total);
                frm.set_value('tax_amount', r.message.tax);
                frm.set_value('discount_amount', r.message.discount);
            }
        });
    }
});
```

**Impact:** Inconsistent calculations, users can bypass logic, hard to maintain
**Severity:** HIGH
**Scan Pattern:**
- Complex calculations in client scripts (loops, conditions, multiple operations)
- Tax/discount/pricing logic in JavaScript
- Validation rules in client scripts

---

### 6. Not Converting Form Values to Numbers

**❌ Anti-Pattern:**
```javascript
// String arithmetic
let qty = frm.doc.qty;  // "5" (string)
let rate = frm.doc.rate;  // "10" (string)
let total = qty * rate;  // NaN or unexpected result

// Comparison without conversion
if (frm.doc.amount > 1000) {  // String comparison: "500" > "1000" is true!
    // Wrong logic
}
```

**✅ Correct:**
```javascript
// Convert to numbers
let qty = parseInt(frm.doc.qty) || 0;
let rate = parseFloat(frm.doc.rate) || 0;
let total = qty * rate;  // Correct calculation

// Number comparison
if (parseFloat(frm.doc.amount) > 1000) {
    // Correct logic
}
```

**Impact:** Incorrect calculations, wrong logic, data corruption
**Severity:** HIGH
**Scan Pattern:**
- `frm.doc.*` used in arithmetic without `parseInt()` or `parseFloat()`
- Comparisons with numbers without type conversion

---

### 7. Using frappe.db.sql Without Parameters

**❌ Anti-Pattern:**
```python
# No parameters - hard to maintain and error-prone
status = "Open"
data = frappe.db.sql(f"SELECT * FROM `tabTask` WHERE status = '{status}'")

# Even if safe now, dangerous pattern
data = frappe.db.sql("SELECT * FROM `tabTask` WHERE status = 'Open'")
```

**✅ Correct:**
```python
# Always use parameters
data = frappe.db.sql("""
    SELECT * FROM `tabTask`
    WHERE status = %(status)s
""", {"status": "Open"})
```

**Impact:** Potential SQL injection if code is modified, maintenance burden
**Severity:** HIGH
**Scan Pattern:** `frappe.db.sql(` without `%(param)s` or with hardcoded values

---

### 8. Missing ignore_permissions in Scheduled Jobs

**❌ Anti-Pattern:**
```python
def daily_cleanup():
    """Scheduled job"""
    # No user context in scheduled jobs - this fails!
    old_docs = frappe.get_all("Temporary Doc", filters={"status": "Expired"})

    for doc in old_docs:
        frappe.delete_doc("Temporary Doc", doc.name)
```

**✅ Correct:**
```python
def daily_cleanup():
    """Scheduled job"""
    # Use ignore_permissions in scheduled jobs
    old_docs = frappe.get_all(
        "Temporary Doc",
        filters={"status": "Expired"},
        ignore_permissions=True
    )

    for doc in old_docs:
        frappe.delete_doc("Temporary Doc", doc.name, ignore_permissions=True)
```

**Impact:** Scheduled job fails due to permission errors
**Severity:** HIGH
**Scan Pattern:** Functions in `scheduled.py` or `tasks.py` without `ignore_permissions=True`

---

## MEDIUM-Priority Anti-Patterns (Best Practices)

### 9. Not Using frappe.utils for Common Operations

**❌ Anti-Pattern:**
```python
# Custom date handling
from datetime import datetime
date = datetime.strptime(date_string, "%Y-%m-%d")
formatted = date.strftime("%d-%m-%Y")

# Custom number formatting
formatted_amount = f"{amount:,.2f}"

# Custom date arithmetic
from datetime import timedelta
future_date = date + timedelta(days=30)
```

**✅ Correct:**
```python
# Use frappe.utils
from frappe.utils import getdate, formatdate, fmt_money, add_days

date = getdate(date_string)  # Handles various formats
formatted = formatdate(date, "dd-mm-yyyy")
formatted_amount = fmt_money(amount, currency="USD")
future_date = add_days(date, 30)
```

**Impact:** Inconsistent formatting, bugs with edge cases, harder to maintain
**Severity:** MEDIUM
**Scan Pattern:**
- `datetime.strptime` or `datetime.strftime` instead of frappe.utils
- Custom number formatting instead of `fmt_money()`
- `timedelta` instead of frappe.utils date functions

---

### 10. Not Handling Exceptions in Background Jobs

**❌ Anti-Pattern:**
```python
def process_documents():
    """Background job"""
    docs = frappe.get_all("DocType", ignore_permissions=True)

    for doc in docs:
        # If one fails, entire job stops
        process_single_doc(doc.name)
```

**✅ Correct:**
```python
def process_documents():
    """Background job"""
    docs = frappe.get_all("DocType", ignore_permissions=True)

    for doc in docs:
        try:
            process_single_doc(doc.name)
        except Exception as e:
            # Log but continue processing others
            frappe.log_error(
                message=frappe.get_traceback(),
                title=f"Failed to process {doc.name}"
            )
```

**Impact:** One error stops entire job, other documents don't get processed
**Severity:** MEDIUM
**Scan Pattern:** Background job functions without try/except blocks

---

### 11. Using get_doc for List Operations

**❌ Anti-Pattern:**
```python
# Inefficient - loads full documents
customers = frappe.get_all("Customer", fields=["name"])
for customer in customers:
    doc = frappe.get_doc("Customer", customer.name)  # Loads full doc
    print(doc.customer_name)
```

**✅ Correct:**
```python
# Efficient - fetch only needed fields
customers = frappe.get_all(
    "Customer",
    fields=["name", "customer_name"]
)
for customer in customers:
    print(customer.customer_name)
```

**Impact:** Poor performance, unnecessary database load
**Severity:** MEDIUM
**Scan Pattern:** `frappe.get_doc()` inside loops over `get_all()` results

---

## LOW-Priority Anti-Patterns (Code Hygiene)

### 12. console.log() Statements in Production

**❌ Anti-Pattern:**
```javascript
frappe.ui.form.on('DocType', {
    refresh: function(frm) {
        console.log("Form loaded:", frm.doc);
        console.log("User:", frappe.session.user);

        // Logic...
    }
});
```

**✅ Correct:**
```javascript
frappe.ui.form.on('DocType', {
    refresh: function(frm) {
        // Remove console.log or use frappe.debug.log() for debug mode only

        // Logic...
    }
});
```

**Impact:** Performance, security (exposing data in console), cluttered logs
**Severity:** LOW
**Scan Pattern:** `console.log(` in JavaScript files

---

### 13. Not Using Translation Function

**❌ Anti-Pattern:**
```python
frappe.throw("This is an error message")
frappe.msgprint("Operation completed")
```

```javascript
frappe.msgprint('Document saved');
```

**✅ Correct:**
```python
from frappe import _

frappe.throw(_("This is an error message"))
frappe.msgprint(_("Operation completed"))
```

```javascript
frappe.msgprint(__('Document saved'));
```

**Impact:** Messages not translatable to other languages
**Severity:** LOW
**Scan Pattern:**
- `frappe.throw(` without `_()`
- `frappe.msgprint(` without `_()` or `__()`

---

### 14. Bare Except Clauses

**❌ Anti-Pattern:**
```python
try:
    risky_operation()
except:  # Catches everything, including KeyboardInterrupt!
    pass
```

**✅ Correct:**
```python
try:
    risky_operation()
except Exception as e:
    frappe.log_error(message=str(e), title="Operation Failed")
```

**Impact:** Hides bugs, catches system exceptions (KeyboardInterrupt, SystemExit)
**Severity:** LOW
**Scan Pattern:** `except:` without exception type

---

### 15. Not Committing in Long-Running Jobs

**❌ Anti-Pattern:**
```python
def long_running_job():
    """Process 10000 documents"""
    for i in range(10000):
        process_document(i)
        # No commit - if it fails at 9999, all lost
```

**✅ Correct:**
```python
def long_running_job():
    """Process 10000 documents"""
    for i in range(10000):
        try:
            process_document(i)

            # Commit every 100 documents
            if i % 100 == 0:
                frappe.db.commit()
        except Exception as e:
            frappe.db.rollback()
            frappe.log_error(str(e))
```

**Impact:** Long-running jobs lose all progress if they fail
**Severity:** LOW
**Scan Pattern:** Long loops without `frappe.db.commit()` calls

---

## Scan Execution Guide

### How to Use This Checklist

1. **Prioritize by severity:**
   - CRITICAL: Must fix before production
   - HIGH: Fix before release or document as known issue
   - MEDIUM: Fix in next iteration
   - LOW: Fix during refactoring

2. **Scan order:**
   - Security issues first (CRITICAL)
   - Logic issues second (HIGH)
   - Best practices third (MEDIUM/LOW)

3. **Report format:**
   ```
   [SEVERITY] Anti-Pattern Name
   File: path/to/file.py
   Line: 45
   Code: frappe.db.sql(f"SELECT * WHERE name = '{name}'")
   Issue: SQL injection risk - string formatting in query
   Fix: Use parameterized query: WHERE name = %(name)s
   ```

4. **Auto-fix criteria:**
   - CRITICAL: Offer to fix immediately
   - HIGH: Offer to fix with user approval
   - MEDIUM/LOW: Document for future work

5. **Known false positives:**
   - `console.log()` in development-only files
   - `frappe.db.set_value()` for non-critical fields (status updates)
   - Scheduled jobs that genuinely need to run as system user

---

## Quick Reference: Severity Levels

**CRITICAL (Security & Data Integrity):**
- SQL injection
- Missing @frappe.whitelist()
- Missing permission checks
- Bypassing validations

**HIGH (Logic & Correctness):**
- Business logic in client scripts
- Not converting form values
- Missing ignore_permissions in scheduled jobs
- Unsafe query patterns

**MEDIUM (Best Practices):**
- Not using frappe.utils
- Not handling exceptions
- Performance issues (inefficient queries)

**LOW (Code Hygiene):**
- console.log() statements
- Missing translations
- Bare except clauses
- Not committing in long jobs
