# Server-Side Python Hooks & Guidelines

> **Standards:** Load `coding-principles.md` first for WHY. This file = HOW (Frappe Python specifics).

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Variables/functions | `snake_case` | `get_total_amount` |
| Constants | `UPPER_SNAKE_CASE` | `BATCH_SIZE` |
| Private helpers | `_leading_underscore` | `_calculate_tax` |
| Classes | `PascalCase` | `SalesOrder` |
| DocTypes | Exact name | `frappe.get_doc("Task", name)` not "task" |

## Style Guidelines

- Follow PEP 8, line length 100 chars
- 4-space indentation
- Import order: standard library → third-party → frappe → local

## Function Structure

```python
@frappe.whitelist()
def api_method(param1, param2):
    """Brief description

    Args:
        param1 (str): Description
        param2 (int): Description

    Returns:
        dict: {"success": bool, "message": str}
    """
    # Implementation
    pass
```

## Data Access Patterns

| Operation | Method |
|-----------|--------|
| Create | `doc = frappe.get_doc({...}); doc.insert()` |
| Read | `frappe.get_doc("DocType", name)` or `frappe.get_all()` |
| Update | `doc = frappe.get_doc(...); doc.field = value; doc.save()` |
| Delete | `frappe.delete_doc("DocType", name)` |
| Get single value | `frappe.db.get_value("DocType", name, "field")` |
| Complex reads | `frappe.db.sql()` with parameterized queries |

## SQL Queries

```python
# ALWAYS use parameterized queries
data = frappe.db.sql("""
    SELECT * FROM `tabTask`
    WHERE name = %(name)s
""", {"name": name}, as_dict=True)

# NEVER use f-strings or concatenation (SQL injection risk)
```

## Error Handling

| Exception Type | Use Case |
|---------------|----------|
| `frappe.ValidationError` | Invalid data |
| `frappe.PermissionError` | No permission |
| `frappe.DoesNotExistError` | Record not found |
| `frappe.throw()` | User-facing errors |
| `frappe.log_error()` | Background logging |

## Permissions

```python
# ALWAYS check document-level permissions
if not frappe.has_permission("DocType", "write", doc):
    frappe.throw(_("No permission"), frappe.PermissionError)

# Check before any write operation
```

## Performance Guidelines

| Issue | Solution |
|-------|----------|
| N+1 queries | Fetch related data upfront or use SQL joins |
| Bulk operations | Process in batches (batch size: 100) |
| Expensive lookups | Use `frappe.cache()` |
| Large datasets | Fetch only needed fields |

## Testing Structure

- Separate validation, logic, side effects into different functions
- Use private helpers that can be tested independently
- Test each function in isolation
