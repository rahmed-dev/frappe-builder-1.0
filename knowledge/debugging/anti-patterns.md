# Anti-Patterns & Code Smells

> Common mistakes in Frappe/ERPNext development and how to fix them.

## Database Anti-Patterns

### ❌ SQL Injection

```python
# WRONG - SQL injection vulnerability
status = request.args.get('status')
data = frappe.db.sql(f"SELECT * FROM `tabTask` WHERE status = '{status}'")

# CORRECT - parameterized query
status = request.args.get('status')
data = frappe.db.sql("""
    SELECT * FROM `tabTask`
    WHERE status = %(status)s
""", {'status': status})
```

### ❌ N+1 Query Problem

```python
# WRONG - N+1 queries
tasks = frappe.get_all('Task', fields=['name', 'project'])
for task in tasks:
    project = frappe.get_doc('Project', task.project)  # N queries!
    print(project.project_name)

# CORRECT - single join query
data = frappe.db.sql("""
    SELECT t.name, t.subject, p.project_name
    FROM `tabTask` t
    LEFT JOIN `tabProject` p ON t.project = p.name
""", as_dict=True)
```

### ❌ Fetching All Fields

```python
# WRONG - fetches all fields
tasks = frappe.get_all('Task')

# CORRECT - fetch only needed fields
tasks = frappe.get_all('Task', fields=['name', 'subject', 'status'])

# BEST - fetch single field
names = frappe.get_all('Task', pluck='name')
```

### ❌ Missing Filters

```python
# WRONG - fetches entire table
all_tasks = frappe.get_all('Task')
open_tasks = [t for t in all_tasks if t.status == 'Open']

# CORRECT - filter in database
open_tasks = frappe.get_all('Task', filters={'status': 'Open'})
```

## Permission Anti-Patterns

### ❌ Missing Permission Checks

```python
# WRONG - no permission check
@frappe.whitelist()
def delete_task(task_name):
    frappe.delete_doc('Task', task_name)

# CORRECT - check permission
@frappe.whitelist()
def delete_task(task_name):
    doc = frappe.get_doc('Task', task_name)
    if not frappe.has_permission('Task', 'delete', doc):
        frappe.throw('No permission')
    doc.delete()
```

### ❌ Skipping Permission in Hooks

```python
# WRONG - bypasses permissions
def validate_task(doc, method):
    frappe.db.set_value('Task', doc.name, 'status', 'Completed', update_modified=False)

# CORRECT - use doc methods
def validate_task(doc, method):
    if should_complete(doc):
        doc.status = 'Completed'
        # Save is called by framework
```

## Validation Anti-Patterns

### ❌ Client-Side Only Validation

```javascript
// WRONG - client-side only
frappe.ui.form.on('Task', {
    validate: function(frm) {
        if (frm.doc.qty < 0) {
            frappe.msgprint('Qty must be positive');
            frappe.validated = false;
        }
    }
});

// CORRECT - server-side validation
```

```python
# Python (server-side)
class Task(Document):
    def validate(self):
        if self.qty < 0:
            frappe.throw('Qty must be positive')
```

### ❌ Missing Type Conversion

```python
# WRONG - no type conversion
@frappe.whitelist()
def update_qty(item, qty):
    doc = frappe.get_doc('Item', item)
    doc.qty = qty  # qty is string from client!
    doc.save()

# CORRECT - convert types
from frappe.utils import cint

@frappe.whitelist()
def update_qty(item, qty):
    qty = cint(qty)  # Convert to int

    if qty < 0:
        frappe.throw('Qty must be positive')

    doc = frappe.get_doc('Item', item)
    doc.qty = qty
    doc.save()
```

## Code Organization Anti-Patterns

### ❌ God Object

```python
# WRONG - one class does everything
class TaskManager:
    def create_task(self): pass
    def update_task(self): pass
    def delete_task(self): pass
    def send_email(self): pass
    def generate_report(self): pass
    def sync_data(self): pass
    def calculate_metrics(self): pass
    # ... 50 more methods

# CORRECT - separate concerns
class TaskService:
    def create(self, data): pass
    def update(self, name, data): pass

class TaskNotification:
    def send_email(self, task): pass

class TaskReport:
    def generate(self, filters): pass
```

### ❌ Unnecessary Helper Functions

```python
# WRONG - helper used once
def get_task_name(doc):
    return doc.name

task_name = get_task_name(doc)

# CORRECT - use directly
task_name = doc.name

# Use helpers only for 3+ uses
def calculate_total(items):
    return sum(item.amount for item in items)

# Used multiple times
total1 = calculate_total(order.items)
total2 = calculate_total(invoice.items)
total3 = calculate_total(quote.items)
```

### ❌ Cryptic Variable Names

```python
# WRONG - unclear names
def process(d, x, t):
    if t == 'c':
        r = d.qty * d.rate
        return r * x

# CORRECT - descriptive names
def calculate_total_amount(item, tax_rate, transaction_type):
    if transaction_type == 'credit':
        base_amount = item.qty * item.rate
        return base_amount * tax_rate
```

## Performance Anti-Patterns

### ❌ Processing Large Data in Web Request

```python
# WRONG - blocks web request
@frappe.whitelist()
def process_all_tasks():
    tasks = frappe.get_all('Task', pluck='name')  # 10,000 tasks
    for task_name in tasks:
        process_task(task_name)  # Takes 5 minutes!
    return {'success': True}

# CORRECT - background job
@frappe.whitelist()
def process_all_tasks():
    frappe.enqueue(
        'my_app.tasks.process_all_tasks_async',
        queue='long',
        timeout=3600
    )
    return {'message': 'Processing started'}
```

### ❌ No Batching

```python
# WRONG - process all at once
def update_all():
    tasks = frappe.get_all('Task', pluck='name')
    for name in tasks:
        frappe.db.set_value('Task', name, 'processed', 1)
    frappe.db.commit()

# CORRECT - batch processing
def update_all():
    batch_size = 100
    offset = 0

    while True:
        tasks = frappe.get_all('Task', pluck='name', limit=batch_size, start=offset)
        if not tasks:
            break

        for name in tasks:
            frappe.db.set_value('Task', name, 'processed', 1)

        frappe.db.commit()
        offset += batch_size
```

### ❌ No Caching

```python
# WRONG - query every time
def get_company_name():
    return frappe.db.get_value('Company', filters={'is_default': 1}, fieldname='name')

# Called 100 times in loop
for i in range(100):
    company = get_company_name()  # 100 queries!

# CORRECT - cache result
def get_company_name():
    cache_key = 'default_company'
    company = frappe.cache().get_value(cache_key)

    if company is None:
        company = frappe.db.get_value('Company', filters={'is_default': 1}, fieldname='name')
        frappe.cache().set_value(cache_key, company, expires_in_sec=3600)

    return company
```

## JavaScript Anti-Patterns

### ❌ Global Pollution

```javascript
// WRONG - pollutes global namespace
var myData = {};
function processData() { }

// CORRECT - encapsulate
(function() {
    var myData = {};
    function processData() { }
})();

// Or use class
class MyPage {
    constructor() {
        this.myData = {};
    }
    processData() { }
}
```

### ❌ Client-Side Data Processing

```javascript
// WRONG - fetch all, filter client-side
frappe.call({
    method: 'my_app.api.get_all_tasks',
    callback: (r) => {
        let open_tasks = r.message.filter(t => t.status === 'Open');
        render(open_tasks);
    }
});

// CORRECT - filter server-side
frappe.call({
    method: 'my_app.api.get_tasks',
    args: { status: 'Open' },
    callback: (r) => {
        render(r.message);
    }
});
```

### ❌ Unscoped CSS

```css
/* WRONG - affects all pages */
.container { padding: 20px; }
.btn { min-height: 48px; }

/* CORRECT - scoped to page */
.page-my-custom-page .container { padding: 20px; }
.page-my-custom-page .btn-custom { min-height: 48px; }
```

## Error Handling Anti-Patterns

### ❌ Silent Failures

```python
# WRONG - swallows all errors
try:
    doc.save()
except:
    pass  # Error ignored!

# CORRECT - handle specific errors
try:
    doc.save()
except frappe.ValidationError as e:
    frappe.log_error(frappe.get_traceback(), 'Validation Failed')
    frappe.throw(str(e))
except Exception as e:
    frappe.log_error(frappe.get_traceback(), 'Save Failed')
    raise
```

### ❌ Generic Error Messages

```python
# WRONG - unhelpful message
if not doc.customer:
    frappe.throw('Error')

# CORRECT - descriptive message
if not doc.customer:
    frappe.throw('Customer is required for Sales Order')
```

## Security Anti-Patterns

### ❌ Hardcoded Credentials

```python
# WRONG - hardcoded secrets
api_key = 'sk_live_12345abcdef'
db_password = 'admin123'

# CORRECT - environment variables
import os
api_key = os.environ.get('API_KEY')
```

### ❌ Logging Sensitive Data

```python
# WRONG - logs password
frappe.logger().info(f'User login: {username}, Password: {password}')

# CORRECT - never log passwords
frappe.logger().info(f'User login: {username}')
```

### ❌ No Input Sanitization

```python
# WRONG - XSS risk
@frappe.whitelist()
def save_comment(html_content):
    doc = frappe.get_doc({'doctype': 'Comment', 'content': html_content})
    doc.insert()

# CORRECT - sanitize HTML
import frappe.utils.html_utils

@frappe.whitelist()
def save_comment(html_content):
    clean_html = frappe.utils.html_utils.sanitize_html(html_content)
    doc = frappe.get_doc({'doctype': 'Comment', 'content': clean_html})
    doc.insert()
```

## Architecture Anti-Patterns

### ❌ Core Modifications

```python
# WRONG - modifying core file
# apps/frappe/frappe/model/document.py
class Document:
    def save(self):
        # Modified core logic

# CORRECT - use hooks
# hooks.py
doc_events = {
    "*": {
        "before_save": "my_app.custom.before_save_handler"
    }
}
```

### ❌ Tight Coupling

```python
# WRONG - tightly coupled
class OrderProcessor:
    def process(self, order):
        email = EmailService()
        email.send_gmail(order.customer_email)  # Coupled to Gmail

# CORRECT - dependency injection
class OrderProcessor:
    def __init__(self, email_service):
        self.email_service = email_service

    def process(self, order):
        self.email_service.send(order.customer_email)
```

## Testing Anti-Patterns

### ❌ No Tests

```python
# WRONG - no tests
def calculate_total(items):
    return sum(item.qty * item.rate for item in items)

# CORRECT - write tests
class TestCalculations(unittest.TestCase):
    def test_calculate_total(self):
        items = [
            {'qty': 10, 'rate': 100},
            {'qty': 5, 'rate': 200}
        ]
        total = calculate_total(items)
        self.assertEqual(total, 2000)
```

### ❌ Testing Implementation, Not Behavior

```python
# WRONG - tests implementation
def test_save_calls_validate(self):
    doc = Task()
    with mock.patch.object(doc, 'validate') as mock_validate:
        doc.save()
        mock_validate.assert_called_once()

# CORRECT - tests behavior
def test_save_validates_dates(self):
    doc = frappe.get_doc({
        'doctype': 'Task',
        'subject': 'Test',
        'exp_start_date': '2025-12-31',
        'exp_end_date': '2025-01-01'  # Before start!
    })
    with self.assertRaises(frappe.ValidationError):
        doc.insert()
```

## Key Rules for Clean Code

- ✅ Use parameterized SQL queries
- ✅ Check permissions in all whitelisted methods
- ✅ Validate on server-side, not client-side
- ✅ Convert types from client input
- ✅ Use descriptive variable/function names
- ✅ Follow 3+ uses rule for helpers
- ✅ Filter data in database, not Python
- ✅ Use background jobs for long operations
- ✅ Batch process large datasets
- ✅ Handle errors explicitly
- ✅ Never log sensitive data
- ✅ Never hardcode credentials
- ✅ Never modify core files
- ❌ Avoid god objects
- ❌ Avoid tight coupling
