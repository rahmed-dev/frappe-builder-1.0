# Script Report Best Practices

## Core Rules

1. **ALWAYS filter/process data in Python (.py), NEVER in JavaScript (.js)**
2. **Minimalist Code: Only essential functionality, no decorative styling/emojis**

## Why Server-Side Filtering?

| Benefit | Reason |
|---------|--------|
| No race conditions | Deterministic execution |
| Respects permissions | Database enforces access |
| Better performance | Database does filtering |
| Cleaner code | 5 lines Python vs 120 lines JS |
| Filter changes instant | No full reload needed |

## Filter Definition

**Define in JSON:**
```json
{
  "filters": [
    {
      "fieldname": "show_completed",
      "fieldtype": "Check",
      "label": "Show Completed",
      "default": "0"
    }
  ]
}
```

**Use in Python:**
```python
def execute(filters=None):
    task_filters = {}
    if not filters.get("show_completed"):
        task_filters["status"] = ["!=", "Completed"]

    data = frappe.get_all("Task", filters=task_filters)
    return columns, data
```

## Data Fetching

```python
# Fetch only needed fields
tasks = frappe.get_all(
    "Task",
    filters=filters,
    fields=["name", "subject", "status"],  # Don't fetch all
    order_by="exp_start_date asc"
)

# SQL for complex queries with joins
data = frappe.db.sql("""
    SELECT t.name, t.subject, p.project_name
    FROM `tabTask` t
    LEFT JOIN `tabProject` p ON t.project = p.name
    WHERE t.status = %(status)s
""", {"status": status}, as_dict=True)
```

## User Permissions in Reports (CRITICAL)

Frappe's User Permission system only applies automatically when you use `frappe.get_list()`.
Query Builder (`frappe.qb`) executes directly and **bypasses permissions entirely**.

### Method Comparison

| Method | User Permissions Applied? | Use Case |
|--------|--------------------------|----------|
| `frappe.get_list()` | ✅ Yes (via DatabaseQuery) | Standard data fetching — default choice |
| `frappe.get_all()` | ⚠️ Only if `ignore_permissions=False` | Admin-only queries |
| `frappe.db.sql()` + `build_match_conditions()` | ✅ Manual, if applied correctly | Complex joins, aggregations |
| `frappe.qb` (Query Builder) | ❌ No — avoid in reports | — |
| `frappe.db.sql()` alone | ❌ No | Internal/admin tasks only |

### ✅ Pattern 1: frappe.get_list() — Use by Default

```python
def get_invoices(filters):
    """Fetch Sales Invoices respecting User Permissions automatically."""
    query_filters = {"docstatus": 1}

    if filters.get("company"):
        query_filters["company"] = filters.company

    if filters.get("from_date") and filters.get("to_date"):
        query_filters["posting_date"] = ["between", [filters.from_date, filters.to_date]]

    return frappe.get_list(
        "Sales Invoice",
        filters=query_filters,
        fields=["name", "customer", "employee", "posting_date", "grand_total"],
        order_by="posting_date desc, name desc"
    )
    # User Permissions enforced automatically — same as List View ✅
```

### ⚠️ Pattern 2: Custom SQL — Apply match_conditions Manually

When complex joins or aggregations require raw SQL:

```python
from frappe.desk.reportview import build_match_conditions

def get_invoice_summary(filters):
    """Custom SQL with manual User Permission enforcement."""
    query = """
        SELECT si.name, si.customer, emp.employee_name, si.grand_total
        FROM `tabSales Invoice` si
        LEFT JOIN `tabEmployee` emp ON si.employee = emp.name
        WHERE si.docstatus = 1
          AND si.company = %(company)s
    """

    match_conditions = build_match_conditions("Sales Invoice")
    if match_conditions:
        query += f" AND ({match_conditions})"

    query += " ORDER BY si.posting_date DESC"
    return frappe.db.sql(query, {"company": filters.company}, as_dict=True)
```

### ❌ Anti-Pattern: Query Builder Bypasses Permissions

```python
# BAD — bypasses User Permissions, users see data they shouldn't
si = frappe.qb.DocType("Sales Invoice")
query = frappe.qb.from_(si).select(si.star).where(si.docstatus == 1)
return query.run(as_dict=True)
```

**Why `frappe.qb` fails:** It executes directly against the database without going through `DatabaseQuery`, which is the class that reads and applies User Permissions.

### Testing

Always test with a restricted user, not Administrator:

```python
# Debug: check what permissions a user has
user_perms = frappe.permissions.get_user_permissions("test.user@example.com")

# Debug: check what SQL conditions are generated
from frappe.desk.reportview import build_match_conditions
print(build_match_conditions("Sales Invoice"))
```

**Test checklist:**
1. Test as restricted user → verify data isolation
2. Test as Administrator → verify all data visible
3. Test edge cases: NULL field values, multiple permissions

---

## Column Definitions

```python
def get_columns():
    return [
        {
            "label": "Task",
            "fieldname": "task",
            "fieldtype": "Link",      # Clickable link
            "options": "Task",
            "width": 200
        },
        {
            "label": "Progress",
            "fieldname": "progress",
            "fieldtype": "Percent",    # Auto-formats
            "width": 100
        }
    ]
```

## JavaScript Usage (UI Only - Minimal)

❌ **Do NOT include:**
- Custom CSS for colors/styling
- STATUS_COLORS mappings
- Emojis
- Decorative badges
- Large CSS blocks

✅ **DO include (only if needed):**
- Action buttons calling server methods
- Event handlers
- Dialogs for input
- Minimal essential CSS

```javascript
frappe.query_reports["Report Name"] = {
    formatter: function(value, row, column, data, default_formatter) {
        value = default_formatter(value, row, column, data);

        if (column.fieldname === "actions") {
            value = `<button class="btn btn-xs btn-primary"
                     data-task="${data.name}">Update</button>`;
        }

        return value;
    },

    onload: function(report) {
        $(document).on('click', '.btn-primary', function() {
            const taskId = $(this).data('task');
            showDialog(taskId, report);
        });
    }
};
```

## Interactive Buttons Pattern

**Python (.py):**
```python
@frappe.whitelist()
def update_status(task_name, new_status):
    task = frappe.get_doc("Task", task_name)
    if not frappe.has_permission("Task", "write", task):
        frappe.throw("No permission")

    task.status = new_status
    task.save()
    return {"success": True}
```

**JavaScript (.js):**
```javascript
function showDialog(taskId, report) {
    let d = new frappe.ui.Dialog({
        title: 'Update Status',
        fields: [{
            fieldname: 'status',
            fieldtype: 'Select',
            options: ['Open', 'Working', 'Completed']
        }],
        primary_action(values) {
            frappe.call({
                method: 'app.report.report_name.update_status',
                args: {task_name: taskId, new_status: values.status},
                callback: (r) => {
                    if (r.message.success) report.refresh();
                }
            });
            d.hide();
        }
    });
    d.show();
}
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Filtering in JS | Filter in Python execute() |
| Not reloading JSON | `bench --site [site] reload-doc` after edit |
| N+1 queries | Fetch related data with joins |
| Fetching all fields | Specify only needed fields |
| No permission check | Check before server actions |

## Performance Tips

- Batch process large datasets (100 items/batch)
- Cache static data: `frappe.cache()`
- Require filters for large data reports
- Use `pluck` for single field: `frappe.get_all(..., pluck="name")`

## Key Takeaways

- **Server-side:** Data processing, filtering, business logic
- **Client-side:** Formatting, buttons, dialogs, styling
- Define filters in JSON
- Check permissions before writes
- Use parameterized SQL (prevent injection)
- Test with large datasets (500+ rows)
