# Code Review Checklist

> Comprehensive checklist for reviewing Frappe/ERPNext code.

## Security

### Permission Checks

- [ ] All `@frappe.whitelist()` methods check permissions
- [ ] Document-level permissions checked before operations
- [ ] No bypass of permission system
- [ ] User permissions validated where applicable

```python
# ✅ GOOD
@frappe.whitelist()
def update_task(task_name, new_status):
    doc = frappe.get_doc('Task', task_name)
    if not frappe.has_permission('Task', 'write', doc):
        frappe.throw('No permission')
    doc.status = new_status
    doc.save()

# ❌ BAD
@frappe.whitelist()
def update_task(task_name, new_status):
    frappe.db.set_value('Task', task_name, 'status', new_status)
```

### SQL Injection Prevention

- [ ] All SQL queries use parameterization
- [ ] No string concatenation in SQL
- [ ] Use ORM methods when possible

```python
# ✅ GOOD
data = frappe.db.sql("""
    SELECT * FROM `tabTask`
    WHERE status = %(status)s
""", {'status': status})

# ❌ BAD
data = frappe.db.sql(f"SELECT * FROM `tabTask` WHERE status = '{status}'")
```

### Input Validation

- [ ] All user input validated and sanitized
- [ ] Type conversion using `flt()`, `cint()`, `cstr()`
- [ ] HTML content sanitized
- [ ] File uploads validated (type, size)

```python
# ✅ GOOD
from frappe.utils import cint
qty = cint(user_input)
if qty <= 0:
    frappe.throw('Qty must be positive')

# ❌ BAD
qty = user_input  # String from client!
```

### Sensitive Data

- [ ] No passwords or secrets in logs
- [ ] No sensitive data in error messages
- [ ] Credentials from environment variables
- [ ] API keys not hardcoded

## Performance

### Database Queries

- [ ] Fetch only needed fields (`fields=[...]`)
- [ ] Results limited (`limit=100`)
- [ ] Filters applied in database, not Python
- [ ] No N+1 query problems
- [ ] Indexes added for frequently filtered fields

```python
# ✅ GOOD
tasks = frappe.get_all(
    'Task',
    filters={'status': 'Open'},
    fields=['name', 'subject'],
    limit=100
)

# ❌ BAD
tasks = frappe.get_all('Task')  # Fetches all fields, all rows
```

### Long Operations

- [ ] Long operations (>30s) use background jobs
- [ ] Large datasets processed in batches
- [ ] Expensive computations cached
- [ ] Pagination implemented for large lists

```python
# ✅ GOOD
@frappe.whitelist()
def process_all_tasks():
    frappe.enqueue('my_app.tasks.process_all', queue='long')
    return {'message': 'Processing started'}

# ❌ BAD
@frappe.whitelist()
def process_all_tasks():
    # 10,000 tasks processed in web request!
    for task in frappe.get_all('Task', pluck='name'):
        process_task(task)
```

## Code Quality

### Naming Conventions

- [ ] Descriptive variable/function names
- [ ] Python: `snake_case` for functions/variables
- [ ] JavaScript: `camelCase` for functions/variables
- [ ] Constants: `UPPER_SNAKE_CASE`
- [ ] No single-letter variables (except loop counters)

```python
# ✅ GOOD
def calculate_total_amount(items, tax_rate):
    base_amount = sum(item.qty * item.rate for item in items)
    return base_amount * (1 + tax_rate)

# ❌ BAD
def calc(i, t):
    x = sum(a.q * a.r for a in i)
    return x * (1 + t)
```

### Helper Functions

- [ ] Helpers used 3+ times (not 1-2 times)
- [ ] Single responsibility per function
- [ ] No god functions (>50 lines)
- [ ] Clear function purpose

```python
# ✅ GOOD - used 3+ times
def calculate_tax(amount, tax_rate):
    return amount * tax_rate

total_tax = calculate_tax(order.total, 0.18)
item_tax = calculate_tax(item.amount, 0.18)
shipping_tax = calculate_tax(shipping.cost, 0.18)

# ❌ BAD - used once
def get_name(doc):
    return doc.name

name = get_name(doc)  # Just use doc.name!
```

### Error Handling

- [ ] Specific exceptions caught, not bare `except:`
- [ ] Errors logged with context
- [ ] User-friendly error messages
- [ ] No silent failures

```python
# ✅ GOOD
try:
    doc.save()
except frappe.ValidationError as e:
    frappe.log_error(frappe.get_traceback(), 'Validation Failed')
    frappe.throw(str(e))
except Exception as e:
    frappe.log_error(frappe.get_traceback(), 'Save Failed')
    raise

# ❌ BAD
try:
    doc.save()
except:
    pass  # Silent failure!
```

## Architecture

### Upgrade Safety

- [ ] No core file modifications
- [ ] Custom code in custom app
- [ ] Hooks used for extending core
- [ ] Custom Fields instead of core field modifications
- [ ] Fixtures defined for deployment

```python
# ✅ GOOD - using hooks
# hooks.py
doc_events = {
    "Sales Order": {
        "on_submit": "my_app.custom.sales_order_submitted"
    }
}

# ❌ BAD - modifying core file
# apps/erpnext/erpnext/selling/doctype/sales_order/sales_order.py
```

### Separation of Concerns

- [ ] Business logic in controller/API
- [ ] UI logic in client scripts
- [ ] Data access in models
- [ ] No tight coupling between modules

### Code Reuse

- [ ] Common logic extracted to utilities
- [ ] No code duplication
- [ ] Shared functions documented

## Validation

### Server-Side Validation

- [ ] All validation on server-side
- [ ] Client-side validation for UX only
- [ ] Mandatory fields checked
- [ ] Data ranges validated
- [ ] Business rules enforced

```python
# ✅ GOOD - server-side
class Task(Document):
    def validate(self):
        if self.exp_end_date < self.exp_start_date:
            frappe.throw('End date cannot be before start date')

# ❌ BAD - client-side only
```

### Type Safety

- [ ] User input converted to correct type
- [ ] Use `flt()`, `cint()`, `cstr()`
- [ ] Default values for conversions
- [ ] None/empty checks before operations

## JavaScript (Client-Side)

### API Calls

- [ ] Data filtering server-side, not client-side
- [ ] Error handlers on `frappe.call()`
- [ ] Buttons disabled during submission
- [ ] No sensitive logic client-side

```javascript
// ✅ GOOD
frappe.call({
    method: 'my_app.api.get_tasks',
    args: { status: 'Open' },  // Filter server-side
    callback: (r) => { render(r.message); },
    error: (r) => { frappe.msgprint('Error occurred'); }
});

// ❌ BAD
frappe.call({
    method: 'my_app.api.get_all_tasks',
    callback: (r) => {
        let open_tasks = r.message.filter(t => t.status === 'Open');  // Client filter!
        render(open_tasks);
    }
});
```

### CSS Scoping

- [ ] All CSS scoped to page/component
- [ ] No global style pollution
- [ ] CSS loaded with `frappe.require()`
- [ ] Not using `app_include_css` for page-specific styles

```css
/* ✅ GOOD */
.page-my-custom-page .container { padding: 20px; }

/* ❌ BAD */
.container { padding: 20px; }  /* Affects all pages! */
```

## Testing

### Test Coverage

- [ ] Unit tests for business logic
- [ ] Validation logic tested
- [ ] Edge cases tested
- [ ] Error conditions tested
- [ ] Integration tests for workflows

```python
# ✅ GOOD
def test_end_date_validation(self):
    doc = frappe.get_doc({
        'doctype': 'Task',
        'exp_start_date': '2025-12-31',
        'exp_end_date': '2025-01-01'
    })
    with self.assertRaises(frappe.ValidationError):
        doc.insert()
```

## Documentation

### Code Comments

- [ ] Complex logic explained
- [ ] Public API methods documented
- [ ] Docstrings for all public functions
- [ ] TODO/FIXME tracked
- [ ] No commented-out code (remove or document why)

```python
# ✅ GOOD
def calculate_weighted_average_cost(items):
    """Calculate weighted average cost for items.

    Args:
        items (list): List of item dicts with 'qty' and 'rate'

    Returns:
        float: Weighted average cost
    """
    total_value = sum(item['qty'] * item['rate'] for item in items)
    total_qty = sum(item['qty'] for item in items)
    return total_value / total_qty if total_qty > 0 else 0
```

### API Documentation

- [ ] Whitelisted methods documented
- [ ] Parameters explained
- [ ] Return values documented
- [ ] Example usage provided

## Git Practices

### Commits

- [ ] Descriptive commit messages
- [ ] Atomic commits (one logical change)
- [ ] No merge commits in feature branches
- [ ] No WIP commits in main branch

### Pull Requests

- [ ] PR description explains changes
- [ ] Tests added/updated
- [ ] No unrelated changes
- [ ] Conflicts resolved
- [ ] CI/CD passing

## Review Checklist Summary

**Before Approving:**

**Security:**
- [ ] Permission checks in all whitelisted methods
- [ ] Parameterized SQL queries
- [ ] Input validation and sanitization
- [ ] No sensitive data in logs

**Performance:**
- [ ] Efficient database queries
- [ ] Background jobs for long operations
- [ ] Batching for large datasets
- [ ] Caching where applicable

**Code Quality:**
- [ ] Descriptive naming
- [ ] Proper error handling
- [ ] No code duplication
- [ ] Comments where needed

**Architecture:**
- [ ] No core modifications
- [ ] Proper separation of concerns
- [ ] Upgrade-safe patterns
- [ ] Server-side validation

**Testing:**
- [ ] Tests added for new logic
- [ ] Edge cases covered
- [ ] Tests passing

**Documentation:**
- [ ] Code commented appropriately
- [ ] API methods documented
- [ ] README updated if needed

## Common Issues to Flag

| Issue | Impact | Fix |
|-------|--------|-----|
| Missing permission check | Security | Add `frappe.has_permission()` |
| SQL injection risk | Security | Use parameterized queries |
| Client-side filtering | Performance | Filter server-side |
| No background job | Performance | Use `frappe.enqueue()` |
| Cryptic variable names | Maintainability | Use descriptive names |
| No tests | Quality | Add unit tests |
| Core modification | Upgrade safety | Use hooks/custom app |
| Silent error handling | Debugging | Log errors, throw to user |

## Key Rules

- ✅ Security first (permissions, SQL injection, input validation)
- ✅ Performance matters (efficient queries, background jobs, batching)
- ✅ Code quality counts (naming, error handling, no duplication)
- ✅ Upgrade-safe always (no core mods, use hooks)
- ✅ Test everything (business logic, validations, edge cases)
- ✅ Document well (comments, docstrings, API docs)
- ❌ Never skip permission checks
- ❌ Never modify core files
- ❌ Never use string concatenation in SQL
- ❌ Never skip testing
