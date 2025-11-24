# Frappe API Reference

> Most commonly used Frappe framework APIs with examples.

## Document Operations

### frappe.get_doc()

```python
# Get existing document
doc = frappe.get_doc('Sales Order', 'SO-0001')

# Create new document
doc = frappe.get_doc({
    'doctype': 'Task',
    'subject': 'New Task',
    'status': 'Open'
})
doc.insert()

# Get single DocType (settings)
settings = frappe.get_doc('System Settings')
```

### frappe.get_all()

```python
# Get list of documents
tasks = frappe.get_all(
    'Task',
    filters={'status': 'Open'},
    fields=['name', 'subject', 'exp_start_date'],
    order_by='exp_start_date asc',
    limit=10
)

# With complex filters
orders = frappe.get_all(
    'Sales Order',
    filters={
        'docstatus': 1,
        'grand_total': ['>', 1000],
        'customer': ['in', ['CUST-001', 'CUST-002']]
    },
    fields=['name', 'grand_total']
)

# Get single field (pluck)
names = frappe.get_all('Task', pluck='name')
# Returns: ['TASK-001', 'TASK-002', ...]
```

### frappe.get_list()

```python
# Like get_all but respects permissions
tasks = frappe.get_list(
    'Task',
    filters={'status': 'Open'},
    fields=['name', 'subject'],
    user='user@example.com'
)
```

### frappe.get_value()

```python
# Get single field value
customer_name = frappe.get_value('Customer', 'CUST-001', 'customer_name')

# Get multiple fields
values = frappe.get_value('Customer', 'CUST-001', ['customer_name', 'territory'], as_dict=True)
# Returns: {'customer_name': 'ABC Corp', 'territory': 'North'}

# With filters
email = frappe.get_value('User', {'full_name': 'John Doe'}, 'email')
```

### frappe.db.exists()

```python
# Check if document exists
if frappe.db.exists('Customer', 'CUST-001'):
    print('Customer exists')

# Check with filters
exists = frappe.db.exists({
    'doctype': 'Task',
    'subject': 'Duplicate Task',
    'status': 'Open'
})
```

### Document Save/Submit/Cancel

```python
# Save draft
doc = frappe.get_doc('Task', 'TASK-001')
doc.status = 'Working'
doc.save()

# Submit document
doc.submit()

# Cancel document
doc.cancel()

# Delete document
doc.delete()
```

## Database Operations

### frappe.db.sql()

```python
# Raw SQL query
data = frappe.db.sql("""
    SELECT name, subject, status
    FROM `tabTask`
    WHERE status = %(status)s
    ORDER BY creation DESC
""", {'status': 'Open'}, as_dict=True)

# Get single value
count = frappe.db.sql("""
    SELECT COUNT(*) FROM `tabTask` WHERE status = 'Open'
""")[0][0]

# As list
names = frappe.db.sql_list("SELECT name FROM `tabTask` WHERE status = 'Open'")
```

### frappe.db.set_value()

```python
# Update single field (no hooks)
frappe.db.set_value('Task', 'TASK-001', 'status', 'Completed')

# Update multiple fields
frappe.db.set_value('Task', 'TASK-001', {
    'status': 'Completed',
    'completed_on': frappe.utils.nowdate()
})

# Update with filters
frappe.db.set_value('Task', {'project': 'PROJ-001'}, 'priority', 'High')
```

### frappe.db.get_value()

```python
# Same as frappe.get_value() - preferred alias
status = frappe.db.get_value('Task', 'TASK-001', 'status')
```

### frappe.db.count()

```python
# Count documents
count = frappe.db.count('Task', {'status': 'Open'})
```

### frappe.db.delete()

```python
# Delete record (no hooks)
frappe.db.delete('Task', {'name': 'TASK-001'})

# Delete with filters
frappe.db.delete('Comment', {'reference_doctype': 'Task', 'reference_name': 'TASK-001'})
```

### frappe.db.commit() / rollback()

```python
try:
    doc1.save()
    doc2.save()
    frappe.db.commit()
except Exception:
    frappe.db.rollback()
    raise
```

## Permissions

### frappe.has_permission()

```python
# Check permission
if not frappe.has_permission('Task', 'read'):
    frappe.throw('No permission')

# Check on specific document
doc = frappe.get_doc('Task', 'TASK-001')
if not frappe.has_permission('Task', 'write', doc):
    frappe.throw('Cannot edit this task')

# Check for specific user
if not frappe.has_permission('Task', 'write', user='user@example.com'):
    frappe.throw('User has no permission')
```

### frappe.only_for()

```python
# Restrict to specific roles
@frappe.whitelist()
def sensitive_operation():
    frappe.only_for('System Manager')
    # Operation code
```

## User & Session

### frappe.session

```python
# Current user
user = frappe.session.user

# Session data
user_type = frappe.session.data.user_type
```

### frappe.get_roles()

```python
# Get user roles
roles = frappe.get_roles('user@example.com')
# Returns: ['Employee', 'Manufacturing User']

# Check if user has role
if 'System Manager' in frappe.get_roles():
    print('User is admin')
```

### frappe.set_user()

```python
# Switch context to different user
frappe.set_user('user@example.com')

# Reset to administrator
frappe.set_user('Administrator')
```

## Utilities

### Date/Time

```python
from frappe.utils import nowdate, now, add_days, getdate, get_datetime

# Current date/time
today = nowdate()           # '2025-11-24'
now_str = now()             # '2025-11-24 10:30:45'

# Add/subtract days
future = add_days(today, 7)
past = add_days(today, -7)

# Parse dates
date_obj = getdate('2025-11-24')
datetime_obj = get_datetime('2025-11-24 10:30:45')
```

### Data Conversion

```python
from frappe.utils import flt, cint, cstr

# Float conversion (handles None, '')
amount = flt('100.50')      # 100.5
safe_amt = flt(None, 0)     # 0 (default)

# Integer conversion
qty = cint('10')            # 10
safe_qty = cint('', 0)      # 0

# String conversion
text = cstr(100)            # '100'
```

### Message

```python
# Show message to user
frappe.msgprint('Task completed successfully')

# Show error
frappe.throw('Invalid data')

# Show with title
frappe.msgprint('Operation successful', title='Success', indicator='green')
```

### Logging

```python
# Log to file
frappe.log_error('Error message', 'Error Title')

# Log to console
frappe.logger().debug('Debug message')
frappe.logger().info('Info message')
frappe.logger().error('Error message')
```

## Cache

### frappe.cache()

```python
# Set cache
frappe.cache().set_value('key', {'data': 'value'})

# Get cache
data = frappe.cache().get_value('key')

# Delete cache
frappe.cache().delete_value('key')

# Clear all cache
frappe.cache().delete_key('*')
```

## Background Jobs

### frappe.enqueue()

```python
# Queue background job
frappe.enqueue(
    'my_app.tasks.process_data',
    queue='default',
    timeout=300,
    job_name='process_data_job',
    **{'param1': 'value1'}
)

# Long running job
frappe.enqueue(
    'my_app.tasks.heavy_processing',
    queue='long',
    timeout=3600
)
```

## API Methods

### @frappe.whitelist()

```python
# Allow web access
@frappe.whitelist()
def get_tasks(status=None):
    """Called via frappe.call()"""
    filters = {}
    if status:
        filters['status'] = status

    return frappe.get_all('Task', filters=filters, fields=['name', 'subject'])

# Allow guest access
@frappe.whitelist(allow_guest=True)
def public_api():
    return {'message': 'Public data'}
```

## Translation

### _()

```python
from frappe import _

# Translate string
message = _('Task completed successfully')

# With placeholder
message = _('Task {0} completed', 'TASK-001')

# With named placeholder
message = _('Task {task} completed on {date}', task='TASK-001', date=nowdate())
```

## Filters Syntax

```python
# Equal
filters = {'status': 'Open'}

# Not equal
filters = {'status': ['!=', 'Completed']}

# Greater than / Less than
filters = {'grand_total': ['>', 1000]}
filters = {'creation': ['<', '2025-01-01']}

# IN clause
filters = {'status': ['in', ['Open', 'Working']]}

# NOT IN
filters = {'status': ['not in', ['Completed', 'Cancelled']]}

# LIKE
filters = {'customer_name': ['like', '%Corp%']}

# Between
filters = {'creation': ['between', ['2025-01-01', '2025-12-31']]}

# IS NULL
filters = {'remarks': ['is', 'not set']}

# Multiple conditions (AND)
filters = {
    'status': 'Open',
    'priority': 'High',
    'assigned_to': 'user@example.com'
}

# OR conditions
filters = [
    ['status', '=', 'Open'],
    ['status', '=', 'Working']
]
```

## Key Rules

- ✅ Use `frappe.get_doc()` to trigger hooks
- ✅ Use `frappe.db.set_value()` to bypass hooks (performance)
- ✅ Always parameterize SQL queries (`%(param)s`)
- ✅ Check permissions before data operations
- ✅ Use `flt()`, `cint()` for safe type conversion
- ✅ Use `frappe.throw()` for user-facing errors
- ✅ Use `frappe.log_error()` for logging
- ✅ Use `frappe.enqueue()` for long-running tasks
- ❌ Never use string concatenation in SQL
- ❌ Never skip permission checks in whitelisted methods
