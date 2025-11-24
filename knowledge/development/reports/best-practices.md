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
