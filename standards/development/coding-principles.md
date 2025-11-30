# Frappe Coding Principles

Non-negotiable rules for production-ready Frappe code.

## 0. Code Readability & Simplicity (CRITICAL)

**Philosophy:** Code is read 10x more than it's written. Optimize for readability.

### Rule 0.1: Self-Documenting Code

**Descriptive names eliminate need for comments:**

```python
❌ BAD - Cryptic names:
def calc(x, y, z):
    t = x * y
    r = t + z
    return r

✅ GOOD - Self-explanatory:
def calculate_order_total(item_qty, item_rate, tax_amount):
    subtotal = item_qty * item_rate
    total = subtotal + tax_amount
    return total
```

**SQL must be readable:**

```python
❌ BAD - Unclear query:
data = frappe.db.sql("""
    SELECT a, b, c FROM t1
    WHERE d=%s AND e=%s
""", (x, y))

✅ GOOD - Clear intent:
outstanding_invoices = frappe.db.sql("""
    SELECT
        name as invoice_id,
        customer,
        outstanding_amount
    FROM `tabSales Invoice`
    WHERE customer=%s AND docstatus=1
""", (customer_id,))
```

### Rule 0.2: Avoid Unnecessary Helper Functions

**Only create helpers when function is used 3+ times:**

```python
❌ BAD - Single-use helper:
def get_customer_name(customer_id):
    return frappe.db.get_value("Customer", customer_id, "customer_name")

def validate(self):
    name = get_customer_name(self.customer)  # Used only once

✅ GOOD - Inline when used once:
def validate(self):
    customer_name = frappe.db.get_value("Customer", self.customer, "customer_name")
```

**When to create helpers:**

| Situation | Action |
|-----------|--------|
| Used 1-2 times | Inline it |
| Used 3+ times | Create helper |
| Complex logic (>10 lines) | Extract to method (even if used once) |
| Improves testability | Extract to method |

### Rule 0.3: Keep It Simple

**Don't over-engineer solutions:**

```python
❌ BAD - Over-complicated:
class DiscountCalculator:
    def __init__(self, strategy):
        self.strategy = strategy

    def calculate(self, amount):
        return self.strategy.apply(amount)

class WholesaleDiscountStrategy:
    def apply(self, amount):
        return amount * 0.1

# Used once in entire codebase

✅ GOOD - Direct solution:
def calculate_discount(customer_group, amount):
    if customer_group == "Wholesale":
        return amount * 0.1
    elif customer_group == "Retail":
        return amount * 0.05
    return 0
```

**Complexity checklist:**
- [ ] Is this the simplest solution that works?
- [ ] Would a junior developer understand this?
- [ ] Am I solving a future problem that doesn't exist yet?
- [ ] Can I delete 50% of this code and still work?

### Rule 0.4: Naming Conventions

**Variables/Functions:**

```python
❌ BAD:
x = frappe.db.get_value("Customer", c, "cn")
def proc(d):
    return d * 1.1

✅ GOOD:
customer_name = frappe.db.get_value("Customer", customer_id, "customer_name")
def calculate_total_with_tax(subtotal):
    return subtotal * 1.1
```

**Be specific, not generic:**

| ❌ Bad | ✅ Good |
|--------|---------|
| `data` | `sales_orders` |
| `result` | `discount_amount` |
| `temp` | `current_stock_qty` |
| `obj` | `customer_doc` |
| `get_data()` | `get_pending_invoices()` |

### Rule 0.5: No Clever Code

**Write obvious code, not clever code:**

```python
❌ CLEVER (but hard to read):
total = sum(i.a for i in d.get("it", []) if i.s == "O")

✅ OBVIOUS:
open_items = [item for item in doc.get("items", []) if item.status == "Open"]
total = sum(item.amount for item in open_items)
```

**Code review question:** "Would I understand this code in 6 months?"

## 1. Server-Side First

**Rule:** Business logic lives in Python, not JavaScript.

```javascript
❌ BAD - Logic in client script:
frappe.ui.form.on("Sales Order", {
    refresh: function(frm) {
        let total = 0;
        frm.doc.items.forEach(item => {
            total += item.amount;
            item.tax = item.amount * 0.1;
        });
        frm.doc.grand_total = total + (total * 0.1);
    }
});
```

```python
✅ GOOD - Logic in server controller:
class SalesOrder(Document):
    def validate(self):
        self.calculate_totals()

    def calculate_totals(self):
        self.total = sum(item.amount for item in self.items)
        self.tax = self.total * 0.1
        self.grand_total = self.total + self.tax
```

**Why:** Server-side logic is testable, secure, and consistent.

## 2. Always Use frappe.utils

**Rule:** Never reinvent built-in utilities.

```python
❌ BAD - Custom implementations:
from datetime import datetime
date_obj = datetime.strptime(date_str, "%Y-%m-%d")

amount = float(amount_str) if amount_str else 0.0

formatted = "{:.2f}".format(number)
```

```python
✅ GOOD - frappe.utils:
from frappe.utils import getdate, flt, fmt_money

date_obj = getdate(date_str)  # Handles None, multiple formats

amount = flt(amount_str)  # Safe float conversion, returns 0.0 for invalid

formatted = fmt_money(number, currency="USD")  # Locale-aware
```

**Common frappe.utils Functions:**

| Function | Purpose | Example |
|----------|---------|---------|
| getdate(s) | Parse date safely | getdate("2025-01-15") |
| get_datetime(s) | Parse datetime | get_datetime("2025-01-15 14:30") |
| now() | Current datetime | now() |
| today() | Current date | today() |
| flt(v, decimals) | Safe float | flt("123.45", 2) |
| cint(v) | Safe int | cint("100") |
| cstr(v) | Safe string | cstr(None) → "" |
| fmt_money(v, currency) | Format money | fmt_money(1000, "USD") |
| add_days(date, days) | Date arithmetic | add_days(today(), 7) |
| date_diff(d1, d2) | Days between | date_diff(end, start) |

## 3. Always Parameterize Queries

**Rule:** Never use string concatenation/f-strings in SQL.

```python
❌ BAD - SQL injection vulnerability:
customer = frappe.form_dict.get("customer")
data = frappe.db.sql(f"""
    SELECT name, total FROM `tabSales Order`
    WHERE customer='{customer}'
""")
# Attack: customer = "'; DROP TABLE `tabSales Order`; --"
```

```python
✅ GOOD - Parameterized query:
customer = frappe.form_dict.get("customer")
data = frappe.db.sql("""
    SELECT name, total FROM `tabSales Order`
    WHERE customer=%s
""", (customer,), as_dict=True)
```

```python
✅ BETTER - Use ORM methods:
data = frappe.get_all("Sales Order",
    filters={"customer": customer},
    fields=["name", "total"])
```

## 4. Always Check Permissions

**Rule:** Every @frappe.whitelist() must validate permissions.

```python
❌ BAD - No permission check:
@frappe.whitelist()
def delete_sales_order(name):
    frappe.delete_doc("Sales Order", name)
    return "Deleted"
```

```python
✅ GOOD - Permission check first:
@frappe.whitelist()
def delete_sales_order(name):
    if not frappe.has_permission("Sales Order", "delete", name):
        frappe.throw("No permission to delete")

    frappe.delete_doc("Sales Order", name)
    return "Deleted"
```

**Permission Check Patterns:**

```python
# Check DocType-level permission
if frappe.has_permission("Sales Order", "write"):
    # User can write to Sales Order DocType

# Check document-level permission
if frappe.has_permission("Sales Order", "write", doc_name):
    # User can write to this specific Sales Order

# Check via controller method
doc = frappe.get_doc("Sales Order", name)
doc.check_permission("write")  # Throws error if no permission
```

## 5. Always Use frappe.ui Components

**Rule:** Never create custom HTML/CSS for standard UI patterns.

```javascript
❌ BAD - Custom HTML dialog:
let html = `
    <div class="modal">
        <input id="customer" type="text">
        <button onclick="submit()">Submit</button>
    </div>
`;
$('body').append(html);
```

```javascript
✅ GOOD - frappe.ui.Dialog:
let d = new frappe.ui.Dialog({
    title: "Select Customer",
    fields: [{
        fieldname: "customer",
        fieldtype: "Link",
        options: "Customer",
        label: "Customer"
    }],
    primary_action_label: "Submit",
    primary_action: (values) => {
        console.log(values.customer);
        d.hide();
    }
});
d.show();
```

**Common frappe.ui Components:**

| Component | Use Case | Code |
|-----------|----------|------|
| Dialog | Modal forms | `new frappe.ui.Dialog({...})` |
| FieldGroup | Dynamic fields | `new frappe.ui.FieldGroup({...})` |
| DataTable | Tables with sorting | `new frappe.DataTable({...})` |
| Tree | Hierarchical data | `new frappe.ui.Tree({...})` |
| Gantt | Timeline views | `new frappe.ui.Gantt({...})` |

## 6. Scaffold with Bench Commands

**Rule:** Use bench commands, not manual file creation.

```bash
❌ BAD - Manual files:
mkdir app/doctype/my_doctype
touch app/doctype/my_doctype/my_doctype.py
touch app/doctype/my_doctype/my_doctype.json
# ... forget files, wrong structure
```

```bash
✅ GOOD - Bench scaffold:
bench --site mysite new-doctype "My DocType"
# Creates all required files with correct structure
```

**Scaffold Commands:**

```bash
# New app
bench new-app app_name

# New DocType
bench --site sitename new-doctype "DocType Name"

# New page
bench --site sitename new-page page_name

# New report
bench --site sitename new-report "Report Name"
```

## 6.5. Clean Imports and Standard Structure

**Rule:** Direct imports, no path manipulation, follow Frappe conventions.

### Import Patterns

```python
✅ GOOD - Direct imports:
import frappe
from frappe import _
from frappe.utils import flt, getdate, now
from frappe.model.document import Document
from erpnext.stock.get_item_details import get_item_details

❌ BAD - Path manipulation:
import sys
sys.path.append("../../")
from some_module import function
```

### Standard DocType Structure

```
custom_app/
├── custom_app/
│   ├── __init__.py
│   ├── hooks.py                    # Module registration
│   ├── patches.txt                 # Database patches
│   └── [module_name]/
│       └── doctype/
│           └── [doctype_name]/
│               ├── __init__.py
│               ├── [doctype_name].py       # Controller
│               ├── [doctype_name].json     # DocType definition
│               ├── [doctype_name].js       # Client script
│               ├── test_[doctype_name].py  # Unit tests
│               └── [doctype_name].md       # Documentation
```

**Use bench scaffold - it creates correct structure automatically.**

## 7. Test Before Deploy

**Rule:** Write and run tests for all business logic.

```python
# test_sales_order.py
class TestSalesOrder(unittest.TestCase):
    def test_calculate_totals(self):
        so = frappe.get_doc({
            "doctype": "Sales Order",
            "customer": "_Test Customer",
            "items": [{
                "item_code": "_Test Item",
                "qty": 10,
                "rate": 100
            }]
        })
        so.calculate_totals()

        self.assertEqual(so.total, 1000)
        self.assertEqual(so.tax, 100)
        self.assertEqual(so.grand_total, 1100)
```

**Run tests:**
```bash
# All tests
bench --site sitename run-tests

# Specific app
bench --site sitename run-tests --app my_app

# Specific DocType
bench --site sitename run-tests --doctype "Sales Order"
```

## 8. Handle Errors Gracefully

**Rule:** Validate input, handle errors, provide clear messages.

### Translatable User Messages

**Rule:** All user-facing strings must use `_()` for translation.

```python
from frappe import _

✅ GOOD - Translatable:
frappe.msgprint(_("Sales Order created successfully"))
frappe.throw(_("Customer {0} does not exist").format(customer))

❌ BAD - Hardcoded English:
frappe.msgprint("Sales Order created successfully")
frappe.throw(f"Customer {customer} does not exist")
```

**Why:** Multi-language support, internationalization.

### Error Handling Pattern

```python
❌ BAD - No validation:
@frappe.whitelist()
def create_sales_order(customer, items):
    so = frappe.get_doc({
        "doctype": "Sales Order",
        "customer": customer,
        "items": items
    })
    so.insert()
    return so.name
```

```python
✅ GOOD - Validation + error handling:
@frappe.whitelist()
def create_sales_order(customer, items):
    # Validate inputs
    if not customer:
        frappe.throw("Customer is required")

    if not items or not isinstance(items, list):
        frappe.throw("Items must be a non-empty list")

    # Validate customer exists
    if not frappe.db.exists("Customer", customer):
        frappe.throw(f"Customer {customer} does not exist")

    try:
        so = frappe.get_doc({
            "doctype": "Sales Order",
            "customer": customer,
            "items": items
        })
        so.insert()
        frappe.db.commit()
        return so.name

    except Exception as e:
        frappe.log_error(f"Failed to create Sales Order: {str(e)}")
        frappe.throw("Failed to create Sales Order. Please check error log.")
```

## 9. Follow Naming Conventions

**Python:**
- **Files/Modules:** snake_case.py
- **Classes:** PascalCase
- **Functions/Variables:** snake_case
- **Constants:** UPPER_SNAKE_CASE

**JavaScript:**
- **Files:** snake_case.js
- **Classes:** PascalCase
- **Functions/Variables:** camelCase
- **Constants:** UPPER_SNAKE_CASE

**DocTypes:**
- **Name:** Space Separated Title Case
- **File:** space_separated_snake_case

**Examples:**
```python
# Python
class SalesOrder(Document):  # PascalCase class
    def calculate_total(self):  # snake_case method
        total_amount = 0  # snake_case variable
```

```javascript
// JavaScript
class SalesOrderHandler {  // PascalCase class
    calculateTotal() {  // camelCase method
        let totalAmount = 0;  // camelCase variable
    }
}
```

## 10. Never Customize Core DocTypes

**Rule:** Zero modifications to standard ERPNext/Frappe DocTypes.

### What NOT to do:
❌ Adding fields directly to Sales Order, Purchase Order, Item, Customer, etc.
❌ Modifying standard DocType JSON files
❌ Changing standard field properties

### What TO do:
✅ Use Custom Fields (Add via UI or fixtures)
✅ Create custom app with your customizations
✅ Use Property Setters for display changes

**Why:** Core modifications break on ERPNext/Frappe upgrades.

**Example:**
```python
# BAD - Modifying core
# erpnext/selling/doctype/sales_order/sales_order.json
# { "fields": [..., {"fieldname": "custom_field", ...}] }

# GOOD - Custom Field fixture
# my_app/fixtures/custom_field.json
[{
    "dt": "Sales Order",
    "fieldname": "custom_priority",
    "fieldtype": "Select",
    "options": "High\\nMedium\\nLow"
}]
```

## 11. Proper Registration via Fixtures & Hooks

**Rule:** All customizations registered in hooks.py and exported as fixtures.

### Fixtures for Version Control

Custom Fields, Property Setters, Workflows, Custom Scripts belong in fixtures:

```python
# hooks.py
fixtures = [
    {
        "dt": "Custom Field",
        "filters": [["dt", "in", ["Sales Order", "Item"]]]
    },
    {
        "dt": "Property Setter",
        "filters": [["doc_type", "in", ["Sales Order"]]]
    },
    {
        "dt": "Workflow",
        "filters": [["name", "=", "Purchase Order Approval"]]
    }
]
```

### Export Fixtures

```bash
# Export to JSON files
bench --site sitename export-fixtures

# Fixtures saved to: my_app/fixtures/*.json
# Commit to version control
git add my_app/fixtures/
git commit -m "Export customization fixtures"
```

### On Fresh Install

```bash
# Fixtures auto-import during app install
bench --site sitename install-app my_app
# All Custom Fields, Workflows, etc. recreated
```

**Why:** Version control for customizations, reproducible across environments.

## 12. Document for Future You

**Rule:** Code should be self-documenting. Comments for WHY, not WHAT.

```python
❌ BAD - Obvious comments:
# Get customer
customer = frappe.get_doc("Customer", customer_name)

# Loop through items
for item in items:
    # Add item to list
    item_list.append(item)
```

```python
✅ GOOD - Explain WHY:
# Fetch customer to validate credit limit before processing order
customer = frappe.get_doc("Customer", customer_name)

# Filter items: exclude cancelled and expired items per business rule BR-2025-01
for item in items:
    if item.status not in ["Cancelled", "Expired"]:
        item_list.append(item)
```

## Code Review Checklist

Before committing:
- [ ] Business logic in Python (not JavaScript)
- [ ] Using frappe.utils (not custom implementations)
- [ ] All queries parameterized (no f-strings in SQL)
- [ ] Permission checks in all @frappe.whitelist()
- [ ] Using frappe.ui components (no custom HTML/CSS)
- [ ] Clean imports (no path manipulation)
- [ ] Used bench scaffold for new DocTypes/Pages
- [ ] Input validation + error handling
- [ ] User messages use _() for translation
- [ ] Tests written and passing
- [ ] Following naming conventions
- [ ] Comments explain WHY, not WHAT
- [ ] Zero custom fields on core DocTypes (use Custom Field fixtures)
- [ ] Customizations in fixtures and hooks.py
- [ ] No hardcoded values (use config/settings)

## Related

- [Security Guidelines](./security-guidelines.md)
- [Performance Rules](./performance-rules.md)
- [Frappe Tech Stack](../core/frappe-tech-stack.md)
