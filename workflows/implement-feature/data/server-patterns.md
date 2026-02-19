# Server-Side Patterns

Best practices for implementing server-side business logic in Frappe Framework.

---

## Validation Patterns

### Basic Validation

```python
def validate(self):
    """Main validation method called before save"""
    self.validate_required_fields()
    self.validate_dates()
    self.validate_amounts()
    self.validate_permissions()
    self.calculate_totals()

def validate_required_fields(self):
    """Check required business fields beyond standard 'reqd' attribute"""
    if not self.field_name:
        frappe.throw(_("Field Name is required"))

    if self.type == "Special" and not self.special_field:
        frappe.throw(_("Special Field is required when Type is Special"))

def validate_dates(self):
    """Validate date logic"""
    from frappe.utils import getdate

    if self.from_date and self.to_date:
        if getdate(self.from_date) > getdate(self.to_date):
            frappe.throw(_("From Date cannot be after To Date"))

    if self.schedule_date and getdate(self.schedule_date) < getdate(frappe.utils.today()):
        frappe.throw(_("Schedule Date cannot be in the past"))

def validate_amounts(self):
    """Validate monetary amounts"""
    from frappe.utils import flt

    if flt(self.amount) < 0:
        frappe.throw(_("Amount cannot be negative"))

    if flt(self.discount_percent) > 100:
        frappe.throw(_("Discount cannot exceed 100%"))
```

---

## Hook Patterns

### Document Lifecycle Hooks

```python
def before_insert(self):
    """Called before new document is inserted into database"""
    # Set default values
    self.status = "Draft"
    self.created_by = frappe.session.user

def after_insert(self):
    """Called after new document is created"""
    # Send notifications
    self.send_creation_notification()

    # Create related documents
    self.create_default_tasks()

def before_save(self):
    """Called before every save (insert and update)"""
    # Auto-populate fields from linked documents
    if self.customer:
        customer = frappe.get_doc("Customer", self.customer)
        self.customer_group = customer.customer_group
        self.territory = customer.territory

    # Generate computed fields
    self.full_name = f"{self.first_name} {self.last_name}"

def on_update(self):
    """Called after every update (not on insert)"""
    # Update related documents
    if self.has_value_changed("status"):
        self.update_related_documents()

def on_submit(self):
    """Called when document is submitted"""
    # Create accounting entries
    self.make_gl_entries()

    # Update stock levels
    self.update_stock()

    # Change state
    self.db_set("workflow_state", "Submitted")

def on_cancel(self):
    """Called when submitted document is cancelled"""
    # Reverse accounting entries
    self.cancel_gl_entries()

    # Restore stock levels
    self.restore_stock()

    # Cancel related documents
    self.cancel_related_documents()

def on_trash(self):
    """Called before document is deleted"""
    # Check if deletion is allowed
    if self.docstatus == 1:
        frappe.throw(_("Cannot delete submitted document"))

    # Delete related documents
    self.delete_related_documents()

def before_rename(self, old_name, new_name, merge=False):
    """Called before document is renamed"""
    if merge:
        frappe.throw(_("Merging is not allowed for this DocType"))
```

---

## frappe.utils Usage

### Type Conversion

```python
from frappe.utils import flt, cint, cstr, sbool

# Float conversion (monetary amounts, decimals)
amount = flt(self.amount)  # "123.45" → 123.45, None → 0.0
total = flt(self.quantity) * flt(self.rate)

# Integer conversion (quantities, counts)
quantity = cint(self.quantity)  # "5" → 5, None → 0

# String conversion
name = cstr(self.name)  # Safely convert to string

# Boolean conversion
is_active = sbool(self.is_active)  # "1", "true", "Yes" → True
```

### Date Operations

```python
from frappe.utils import (
    getdate, today, now, now_datetime,
    add_days, add_months, date_diff, time_diff,
    get_first_day, get_last_day, formatdate
)

# Get dates
today_date = getdate(today())  # datetime.date object
current_datetime = now_datetime()  # datetime.datetime object

# Date arithmetic
future_date = add_days(today(), 30)  # 30 days from today
past_date = add_months(today(), -3)  # 3 months ago

# Date comparison
days_difference = date_diff(self.to_date, self.from_date)

# Month boundaries
month_start = get_first_day(today())
month_end = get_last_day(today())

# Formatting
formatted = formatdate(self.date, "dd-mm-yyyy")  # 15-02-2026
```

### Money Formatting

```python
from frappe.utils import fmt_money, money_in_words

# Format money
formatted = fmt_money(1234.56, currency="USD")  # "$1,234.56"
formatted = fmt_money(1234.56, currency="INR")  # "₹ 1,234.56"

# Money in words
words = money_in_words(1234.56, "USD")  # "One Thousand Two Hundred Thirty Four Point Fifty Six Only"
```

### Other Utilities

```python
from frappe.utils import (
    validate_email_address,
    validate_phone_number,
    comma_and, comma_or
)

# Email validation
try:
    validate_email_address(self.email, throw=True)
except frappe.InvalidEmailAddressError:
    frappe.throw(_("Invalid email address"))

# List formatting
users = ["Alice", "Bob", "Charlie"]
text = comma_and(users)  # "Alice, Bob and Charlie"
```

---

## Database Query Patterns

### Parameterized Queries (ALWAYS use this)

```python
# ✅ CORRECT: Parameterized query
data = frappe.db.sql("""
    SELECT *
    FROM `tabDocType`
    WHERE
        status = %(status)s
        AND date >= %(from_date)s
        AND amount > %(min_amount)s
""", {
    "status": status,
    "from_date": from_date,
    "min_amount": 100
}, as_dict=1)

# ✅ CORRECT: IN clause with parameterized query
statuses = ["Open", "Pending", "In Progress"]
data = frappe.db.sql("""
    SELECT *
    FROM `tabDocType`
    WHERE status IN %(statuses)s
""", {"statuses": statuses}, as_dict=1)
```

### frappe.db Methods

```python
# Get single value
value = frappe.db.get_value("DocType", "DOC-001", "field_name")

# Get multiple values
name, status = frappe.db.get_value(
    "DocType",
    {"name": "DOC-001"},
    ["name", "status"]
)

# Get single document as dict
doc = frappe.db.get_value(
    "DocType",
    "DOC-001",
    "*",
    as_dict=1
)

# Check if exists
exists = frappe.db.exists("DocType", "DOC-001")
exists = frappe.db.exists("DocType", {"field": "value"})

# Count
count = frappe.db.count("DocType", {"status": "Open"})

# Update value (bypasses controller logic)
frappe.db.set_value("DocType", "DOC-001", "status", "Completed")
frappe.db.set_value("DocType", "DOC-001", {
    "status": "Completed",
    "completion_date": today()
})

# Delete
frappe.db.delete("DocType", {"status": "Draft"})
```

### frappe.get_all and frappe.get_list

```python
# Get list of documents
docs = frappe.get_all(
    "DocType",
    filters={"status": "Open"},
    fields=["name", "title", "date"],
    order_by="date desc",
    limit=10
)

# With permission check
docs = frappe.get_list(
    "DocType",  # Same as get_all but with permission check
    filters={"status": "Open"},
    fields=["name", "title"],
    ignore_permissions=False  # Default
)

# Complex filters
docs = frappe.get_all(
    "DocType",
    filters=[
        ["status", "in", ["Open", "Pending"]],
        ["date", ">=", "2026-01-01"],
        ["amount", ">", 1000]
    ],
    or_filters=[
        ["priority", "=", "High"],
        ["is_urgent", "=", 1]
    ]
)

# Get only names (pluck)
names = frappe.get_all("DocType", filters={"status": "Open"}, pluck="name")
# Returns: ["DOC-001", "DOC-002", "DOC-003"]
```

---

## Permission Patterns

### Check Permissions

```python
# Check if user has permission
has_perm = frappe.has_permission("DocType", "read", doc=self.name)

# Throw error if no permission
frappe.has_permission("DocType", "write", doc=self.name, throw=True)

# Check in API endpoints (MANDATORY)
@frappe.whitelist()
def api_function(docname):
    frappe.has_permission("DocType", "read", throw=True)
    # ... function logic

# Get user permissions for a doctype
allowed = frappe.permissions.get_doctypes_with_read()
```

### Role-Based Logic

```python
# Check if user has role
if "System Manager" in frappe.get_roles():
    # Admin-only logic
    pass

# Check specific role
has_role = frappe.permissions.has_role("Sales Manager")

# Get user roles
roles = frappe.get_roles(user="user@example.com")
```

### Bypass Permissions

```python
# In scheduled jobs or system operations
doc = frappe.get_doc("DocType", "DOC-001")
doc.save(ignore_permissions=True)

# Get list without permission check
docs = frappe.get_all("DocType", filters={...}, ignore_permissions=True)

# Database operations always bypass permissions
frappe.db.set_value("DocType", "DOC-001", "status", "Completed")  # No permission check
```

---

## API Whitelist Patterns

### Basic API Endpoint

```python
@frappe.whitelist()
def api_function(param1, param2=None):
    """
    API endpoint accessible from client

    All parameters come as strings - convert as needed
    """
    # Permission check - MANDATORY
    frappe.has_permission("DocType", "read", throw=True)

    # Convert parameters
    param1 = cstr(param1)
    param2 = cint(param2) if param2 else None

    # Business logic
    result = process_data(param1, param2)

    return result
```

### API with Document Access

```python
@frappe.whitelist()
def process_document(docname):
    """Process a specific document"""
    # Load document (checks read permission)
    doc = frappe.get_doc("DocType", docname)

    # Check write permission if modifying
    if not frappe.has_permission("DocType", "write", doc=docname):
        frappe.throw(_("No permission to modify this document"))

    # Modify document
    doc.status = "Processed"
    doc.save()

    return {"status": "success", "name": doc.name}
```

### API with Guest Access

```python
@frappe.whitelist(allow_guest=True)
def public_api_function(param):
    """
    API accessible to non-logged-in users

    Use sparingly and validate all inputs carefully
    """
    # Validate input
    if not param:
        frappe.throw(_("Parameter is required"))

    # Rate limiting for guest access
    frappe.rate_limit(limit=10, seconds=60)

    # Process and return
    result = get_public_data(param)
    return result
```

---

## Error Handling

### Throwing Errors

```python
# User-facing error (shows in UI)
frappe.throw(_("Custom error message"))

# With title
frappe.throw(
    _("Insufficient stock for item {0}").format(self.item_name),
    title=_("Stock Error")
)

# Validation error
frappe.throw(_("Invalid data"), frappe.ValidationError)

# Permission error
frappe.throw(_("Insufficient permissions"), frappe.PermissionError)
```

### Logging Errors

```python
# Log error to Error Log DocType
try:
    risky_operation()
except Exception as e:
    frappe.log_error(
        message=frappe.get_traceback(),
        title=f"Failed to process {self.name}"
    )

# Log with context
frappe.log_error(
    message=f"Document: {self.name}\nError: {str(e)}",
    title="Process Error",
    reference_doctype=self.doctype,
    reference_name=self.name
)
```

### Messages

```python
# Success message (green)
frappe.msgprint(_("Operation completed successfully"), indicator="green")

# Info message (blue)
frappe.msgprint(_("Document saved"), indicator="blue")

# Warning message (orange)
frappe.msgprint(_("Some items are out of stock"), indicator="orange")

# Error message (red)
frappe.msgprint(_("Operation failed"), indicator="red")
```

---

## Background Jobs

### Enqueue Job

```python
# Enqueue long-running task
frappe.enqueue(
    method="app.module.tasks.long_running_task",
    queue="default",  # default, short, long
    timeout=300,  # seconds
    job_name=f"process_{self.name}",
    param1=value1,
    param2=value2
)

# Enqueue with callback
frappe.enqueue(
    method="app.module.tasks.process_data",
    queue="long",
    callback=lambda: frappe.msgprint("Processing complete"),
    doc_name=self.name
)
```

### Background Task Function

```python
def long_running_task(doc_name, param1, param2):
    """
    Background task function

    Runs in separate worker process
    """
    # Load document with ignore_permissions
    doc = frappe.get_doc("DocType", doc_name)

    # Process data
    for item in doc.items:
        process_item(item)

    # Update document
    doc.status = "Completed"
    doc.save(ignore_permissions=True)

    # Commit after each step for long tasks
    frappe.db.commit()
```

---

## Best Practices Summary

### ✅ DO:
- Use `frappe.throw()` for validation errors
- Use parameterized queries with `%(param)s` syntax
- Use `frappe.utils` for type conversion and date operations
- Check permissions in all API endpoints with `@frappe.whitelist()`
- Use `ignore_permissions=True` in scheduled jobs
- Convert form values with `flt()`, `cint()`, `cstr()`
- Log errors with `frappe.log_error()`
- Use `frappe.get_doc()` for document operations
- Commit transactions explicitly in long-running tasks

### ❌ DON'T:
- Use string concatenation in SQL queries
- Put business logic in client scripts
- Skip permission checks in API endpoints
- Use `frappe.db.sql()` without parameterization
- Access `frappe.db` directly from client
- Use bare `except:` clauses
- Modify documents without permission checks
- Use custom date/number formatting instead of frappe.utils
