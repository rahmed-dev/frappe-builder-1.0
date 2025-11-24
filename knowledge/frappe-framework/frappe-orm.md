# Frappe ORM Patterns

> Database operations using Frappe's Object-Relational Mapping.

## Core Concepts

**Frappe ORM = Active Record Pattern**
- Each DocType is a database table
- Each document is a row
- Fields are columns
- Relationships via Link fields

## Document Operations

### Create (Insert)

```python
# Method 1: Dictionary
doc = frappe.get_doc({
    'doctype': 'Task',
    'subject': 'New Task',
    'status': 'Open',
    'priority': 'High'
})
doc.insert()

# Method 2: Constructor
doc = frappe.new_doc('Task')
doc.subject = 'New Task'
doc.status = 'Open'
doc.insert()

# Ignore permissions
doc.insert(ignore_permissions=True)

# Ignore mandatory
doc.insert(ignore_mandatory=True)
```

### Read (Get)

```python
# Get by name
doc = frappe.get_doc('Task', 'TASK-0001')

# Get single DocType (settings)
settings = frappe.get_doc('System Settings')

# Get cached
doc = frappe.get_cached_doc('Task', 'TASK-0001')

# Get all (list)
tasks = frappe.get_all(
    'Task',
    filters={'status': 'Open'},
    fields=['name', 'subject', 'priority'],
    order_by='creation desc',
    limit=10
)

# Get list (respects permissions)
tasks = frappe.get_list('Task', filters={'status': 'Open'})

# Pluck single field
names = frappe.get_all('Task', pluck='name')
# Returns: ['TASK-001', 'TASK-002', ...]
```

### Update (Save)

```python
# Get and update
doc = frappe.get_doc('Task', 'TASK-0001')
doc.status = 'Completed'
doc.save()

# Direct update (bypasses hooks)
frappe.db.set_value('Task', 'TASK-0001', 'status', 'Completed')

# Update multiple fields
frappe.db.set_value('Task', 'TASK-0001', {
    'status': 'Completed',
    'completed_date': frappe.utils.nowdate()
})

# Bulk update
frappe.db.sql("""
    UPDATE `tabTask`
    SET status = 'Completed'
    WHERE exp_end_date < CURDATE()
""")
frappe.db.commit()
```

### Delete

```python
# Delete document
frappe.delete_doc('Task', 'TASK-0001')

# Force delete (ignore links)
frappe.delete_doc('Task', 'TASK-0001', force=1)

# Delete multiple
frappe.delete_doc('Task', ['TASK-0001', 'TASK-0002'])

# Direct delete (bypasses hooks)
frappe.db.delete('Task', {'name': 'TASK-0001'})
```

## Filters

### Simple Filters

```python
# Equal
filters = {'status': 'Open'}

# Multiple conditions (AND)
filters = {
    'status': 'Open',
    'priority': 'High',
    'assigned_to': 'user@example.com'
}
```

### Advanced Filters

```python
# Not equal
filters = {'status': ['!=', 'Completed']}

# Greater than / Less than
filters = {'creation': ['>', '2025-01-01']}
filters = {'grand_total': ['<', 1000]}

# IN clause
filters = {'status': ['in', ['Open', 'Working']]}

# NOT IN
filters = {'status': ['not in', ['Completed', 'Cancelled']]}

# LIKE
filters = {'customer_name': ['like', '%Corp%']}

# BETWEEN
filters = {'creation': ['between', ['2025-01-01', '2025-12-31']]}

# IS NULL / IS NOT NULL
filters = {'remarks': ['is', 'not set']}
filters = {'remarks': ['is', 'set']}

# OR conditions
filters = [
    ['status', '=', 'Open'],
    ['status', '=', 'Working']
]

# Complex conditions
filters = [
    ['status', 'in', ['Open', 'Working']],
    ['priority', '=', 'High'],
    ['creation', '>', '2025-01-01']
]
```

## Relationships

### Link Fields

```python
# One-to-many
class SalesOrder(Document):
    # customer is Link field to Customer
    pass

# Access linked document
order = frappe.get_doc('Sales Order', 'SO-0001')
customer = frappe.get_doc('Customer', order.customer)
print(customer.customer_name)
```

### Child Tables

```python
# Parent-child relationship
order = frappe.get_doc('Sales Order', 'SO-0001')

# Access child rows
for item in order.items:
    print(item.item_code, item.qty, item.rate)

# Add child row
order.append('items', {
    'item_code': 'ITEM-001',
    'qty': 10,
    'rate': 100
})
order.save()

# Update child row
for item in order.items:
    if item.item_code == 'ITEM-001':
        item.qty = 20

order.save()

# Remove child row
order.items = [item for item in order.items if item.item_code != 'ITEM-001']
order.save()

# Clear all child rows
order.items = []
order.save()
```

### Dynamic Links

```python
# Link based on another field
{
    "fieldname": "party_type",
    "fieldtype": "Link",
    "options": "DocType"
},
{
    "fieldname": "party",
    "fieldtype": "Dynamic Link",
    "options": "party_type"
}

# Usage
doc.party_type = 'Customer'
doc.party = 'CUST-001'
# OR
doc.party_type = 'Supplier'
doc.party = 'SUP-001'
```

## Query Methods

### frappe.db.get_value()

```python
# Single field
customer_name = frappe.db.get_value('Customer', 'CUST-001', 'customer_name')

# Multiple fields
values = frappe.db.get_value(
    'Customer',
    'CUST-001',
    ['customer_name', 'email', 'territory'],
    as_dict=True
)
# Returns: {'customer_name': 'ABC Corp', 'email': '...', 'territory': 'North'}

# With filters
email = frappe.db.get_value('User', {'full_name': 'John Doe'}, 'email')

# Get single value from query
count = frappe.db.sql("""
    SELECT COUNT(*) FROM `tabTask` WHERE status = 'Open'
""")[0][0]
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

if exists:
    frappe.throw(f'Duplicate task found: {exists}')
```

### frappe.db.count()

```python
# Count documents
count = frappe.db.count('Task')

# Count with filters
open_count = frappe.db.count('Task', {'status': 'Open'})

# Count with complex filters
count = frappe.db.count('Task', [
    ['status', 'in', ['Open', 'Working']],
    ['priority', '=', 'High']
])
```

### frappe.db.sql()

```python
# Raw SQL query
tasks = frappe.db.sql("""
    SELECT name, subject, status
    FROM `tabTask`
    WHERE status = %(status)s
    ORDER BY creation DESC
    LIMIT 10
""", {'status': 'Open'}, as_dict=True)

# As list of lists
tasks = frappe.db.sql("""
    SELECT name, subject FROM `tabTask`
""")
# Returns: [['TASK-001', 'Subject 1'], ['TASK-002', 'Subject 2']]

# As dict
tasks = frappe.db.sql("""
    SELECT name, subject FROM `tabTask`
""", as_dict=True)
# Returns: [{'name': 'TASK-001', 'subject': 'Subject 1'}, ...]

# Single column list
names = frappe.db.sql_list("SELECT name FROM `tabTask` WHERE status = 'Open'")
# Returns: ['TASK-001', 'TASK-002', ...]
```

## Aggregation

### Count, Sum, Avg

```python
# Count
count = frappe.db.count('Task', {'status': 'Open'})

# Sum
total = frappe.db.sql("""
    SELECT SUM(grand_total)
    FROM `tabSales Order`
    WHERE status = 'Open'
""")[0][0] or 0

# Average
avg_qty = frappe.db.sql("""
    SELECT AVG(qty)
    FROM `tabSales Order Item`
    WHERE parent = %(parent)s
""", {'parent': 'SO-0001'})[0][0] or 0

# Group by
data = frappe.db.sql("""
    SELECT status, COUNT(*) as count
    FROM `tabTask`
    GROUP BY status
""", as_dict=True)
# Returns: [{'status': 'Open', 'count': 10}, {'status': 'Completed', 'count': 5}]
```

## Transactions

### Commit/Rollback

```python
try:
    doc1 = frappe.get_doc({...})
    doc1.insert()

    doc2 = frappe.get_doc({...})
    doc2.insert()

    frappe.db.commit()

except Exception:
    frappe.db.rollback()
    raise
```

### Auto-commit

```python
# Frappe auto-commits after each request
# Manual commit only needed for:
# - Background jobs
# - Long-running scripts
# - Batch operations

def batch_process():
    for i in range(0, 1000, 100):
        batch = get_batch(i, 100)
        process_batch(batch)
        frappe.db.commit()  # Commit per batch
```

## Caching

### Document Cache

```python
# Get from cache (faster)
doc = frappe.get_cached_doc('Task', 'TASK-0001')

# Get cached value
customer_name = frappe.get_cached_value('Customer', 'CUST-001', 'customer_name')

# Clear cache
frappe.clear_cache(doctype='Task', name='TASK-0001')
```

### Value Cache

```python
# Cache expensive queries
cache_key = 'task_count_open'
count = frappe.cache().get_value(cache_key)

if count is None:
    count = frappe.db.count('Task', {'status': 'Open'})
    frappe.cache().set_value(cache_key, count, expires_in_sec=3600)

return count
```

## Validation

### Exists Check

```python
def validate(self):
    # Check duplicate
    duplicate = frappe.db.exists({
        'doctype': self.doctype,
        'name': ['!=', self.name],
        'email': self.email
    })

    if duplicate:
        frappe.throw(f'Email already exists: {duplicate}')
```

### Reference Check

```python
def on_trash(self):
    # Check if referenced elsewhere
    linked = frappe.db.exists('Sales Order Item', {'item_code': self.name})

    if linked:
        frappe.throw('Cannot delete - item used in Sales Orders')
```

## Indexes

### Add Index

```python
# In DocType JSON
{
    "fieldname": "status",
    "fieldtype": "Select",
    "search_index": 1  # Creates database index
}

# Or via SQL
frappe.db.sql("""
    CREATE INDEX idx_status ON `tabTask` (status)
""")
```

### Composite Index

```python
frappe.db.sql("""
    CREATE INDEX idx_status_priority
    ON `tabTask` (status, priority)
""")
```

## Performance Patterns

### Fetch Only Needed Fields

```python
# Bad - fetches all fields
tasks = frappe.get_all('Task')

# Good - fetch specific fields
tasks = frappe.get_all('Task', fields=['name', 'subject', 'status'])

# Best - single field
names = frappe.get_all('Task', pluck='name')
```

### Use Filters

```python
# Bad - filter in Python
all_tasks = frappe.get_all('Task')
open_tasks = [t for t in all_tasks if t.status == 'Open']

# Good - filter in database
open_tasks = frappe.get_all('Task', filters={'status': 'Open'})
```

### Batch Processing

```python
# Bad - all at once
all_tasks = frappe.get_all('Task', pluck='name')
for task in all_tasks:
    process(task)

# Good - batch processing
batch_size = 100
offset = 0

while True:
    tasks = frappe.get_all('Task', limit=batch_size, start=offset, pluck='name')
    if not tasks:
        break

    for task in tasks:
        process(task)

    frappe.db.commit()
    offset += batch_size
```

## Key Rules

- ✅ Use `frappe.get_doc()` to trigger hooks
- ✅ Use `frappe.db.set_value()` to bypass hooks (performance)
- ✅ Use `frappe.get_all()` with `fields=` to limit data
- ✅ Use `pluck='name'` for single field lists
- ✅ Filter in database, not Python
- ✅ Use parameterized SQL (`%(param)s`)
- ✅ Check `exists()` before insert
- ✅ Add indexes on filtered fields
- ✅ Batch process large datasets
- ✅ Commit per batch in long operations
- ❌ Never use string concatenation in SQL
- ❌ Never fetch all fields without `fields=`
- ❌ Never filter data in Python loops
