# Script Report Structure & Guidelines

> **Standards:** Load `coding-principles.md` first. This file = Frappe Reports specifics.

## File Structure

Every Script Report has 3 files:
- **report_name.py** - Server-side data logic (80% of code)
- **report_name.json** - Filters and configuration
- **report_name.js** - Client-side UI formatting only

## Python File (.py)

```python
def execute(filters=None):
    """Main report function

    Args:
        filters (dict): Filter values from UI

    Returns:
        tuple: (columns, data)
    """
    if not filters:
        filters = {}

    columns = get_columns()
    data = get_data(filters)

    return columns, data

def get_columns():
    return [
        {
            "label": "Task",
            "fieldname": "task",
            "fieldtype": "Link",
            "options": "Task",
            "width": 200
        }
    ]

def get_data(filters):
    # Filter data here, not in JavaScript
    return frappe.get_all("Task", filters=filters, fields=[...])

@frappe.whitelist()
def server_action(param):
    # Whitelisted methods for button actions
    pass
```

## JSON File (.json)

```json
{
  "filters": [
    {
      "fieldname": "project",
      "fieldtype": "Link",
      "label": "Project",
      "options": "Project",
      "mandatory": 0
    }
  ],
  "ref_doctype": "Task",
  "is_standard": "Yes"
}
```

**After editing:** `bench --site [site] reload-doc [app] Report "[Report Name]"`

## JavaScript File (.js)

```javascript
frappe.query_reports["Report Name"] = {
    onload: function(report) {
        // Setup UI, event handlers
    },

    formatter: function(value, row, column, data, default_formatter) {
        value = default_formatter(value, row, column, data);
        // Add badges, buttons, custom formatting
        return value;
    }
};
```

## Naming Conventions

| Language | Convention |
|----------|------------|
| Python | `snake_case` functions/variables, `UPPER_SNAKE_CASE` constants |
| JavaScript | `camelCase` functions/variables, `UPPER_SNAKE_CASE` constants |

## Key Rules

- Filter data in Python execute(), never in JavaScript
- Define filters in JSON, not JavaScript
- Fetch only needed fields: `fields=["name", "subject"]`
- Event delegation for buttons: `$(document).on('click', '.btn', handler)`
- Always check permissions before server actions
- Handle errors with try/except
- Use parameterized SQL queries
- Add comments explaining business logic

## Minimalist Code

❌ **Avoid:**
- Emojis in code or UI
- Custom CSS for colors/aesthetics
- STATUS_COLORS mappings
- Decorative badges
- Unnecessary styling

✅ **Use:**
- Frappe built-in button/badge styles
- Essential functionality CSS only
