# Server-Side Python Best Practices

## Core Rules

1. All business logic on server
2. Check document-level permissions before writes
3. Use Frappe ORM (not raw SQL) for CRUD
4. Always convert JavaScript form values (strings) to proper types

## Common Patterns

### API Method Pattern

```python
@frappe.whitelist()
def update_task(task_name, new_value):
    """
    Brief description

    Args:
        task_name (str): Task name
        new_value (str): New value

    Returns:
        dict: {"success": bool, "message": str}
    """
    task = frappe.get_doc("Task", task_name)

    # Check document-level permission
    if not frappe.has_permission("Task", "write", task):
        frappe.throw(_("No permission"), frappe.PermissionError)

    task.field = new_value
    task.save()

    return {"success": True, "message": _("Updated")}
```

### Type Conversion (CRITICAL)

```python
@frappe.whitelist()
def process(number_value, amount_value):
    # JavaScript sends ALL values as strings - MUST convert before validation
    number = int(number_value) if number_value else 0
    amount = flt(amount_value)  # Use flt() for currency

    # Validate AFTER conversion
    if number <= 0:
        frappe.throw(_("Number must be > 0"))
```

### Background Job Pattern

```python
def process_scheduled_task():
    """Daily/hourly scheduled task"""
    try:
        settings = frappe.get_single("Settings")
        if not settings.enable_feature:
            frappe.logger().info("Feature disabled")
            return

        records = frappe.get_all(
            "DocType",
            filters={"status": "Processing", "docstatus": 1},
            fields=["name"]
        )

        for rec in records:
            try:
                process_record(rec.name)
            except Exception as e:
                frappe.log_error(
                    title=f"Error: {rec.name}",
                    message=frappe.get_traceback()
                )

        frappe.logger().info(f"Processed {len(records)}")

    except Exception as e:
        frappe.log_error(title="Task Error", message=str(e))

def process_record(name):
    """Process single record"""
    doc = frappe.get_doc("DocType", name)
    doc.field = "value"
    doc.save(ignore_permissions=True)  # Needed for background jobs
    frappe.db.commit()  # Commit per record
```

### Bulk Operation Pattern

```python
@frappe.whitelist()
def bulk_update(task_ids):
    """
    Update multiple tasks

    Returns:
        dict: {"updated": int, "failed": int, "errors": list}
    """
    updated = failed = 0
    errors = []

    for task_id in task_ids:
        try:
            task = frappe.get_doc("Task", task_id)
            if not frappe.has_permission("Task", "write", task):
                raise frappe.PermissionError("No permission")

            task.status = "Completed"
            task.save()
            updated += 1

        except Exception as e:
            failed += 1
            errors.append(f"{task_id}: {str(e)}")
            frappe.log_error(str(e), "Bulk Update Error")

    return {"success": failed == 0, "updated": updated, "failed": failed, "errors": errors}
```

## Data Fetching

```python
# Get all with filters
tasks = frappe.get_all(
    "Task",
    filters={"project": project, "status": ["!=", "Completed"]},
    fields=["name", "subject", "status"],
    order_by="creation desc"
)

# Get single document
task = frappe.get_doc("Task", name)

# Get single field
value = frappe.db.get_value("Task", name, "status")

# SQL for complex queries (parameterized)
data = frappe.db.sql("""
    SELECT t.name, p.project_name
    FROM `tabTask` t
    LEFT JOIN `tabProject` p ON t.project = p.name
    WHERE t.status = %(status)s
""", {"status": status}, as_dict=True)
```

## Batch Processing

```python
BATCH_SIZE = 100
for i in range(0, len(items), BATCH_SIZE):
    batch = items[i:i+BATCH_SIZE]
    for item in batch:
        process_item(item)
    frappe.db.commit()  # Commit after each batch
```

## Key Rules

| Rule | Example |
|------|---------|
| Add docstrings to @frappe.whitelist() | See API Method Pattern above |
| ALWAYS convert string form values | `number = int(number_value)`, `amount = flt(amount_value)` |
| Check document-level permissions | `frappe.has_permission("Task", "write", task)` |
| Use ignore_permissions=True for background jobs | `doc.save(ignore_permissions=True)` |
| Return structured responses | `{"success": bool, "data": any}` |
| Log errors | `frappe.log_error(title, message)` |
| Use logger for scheduler | `frappe.logger().info()` |
| Commit after each record/batch | `frappe.db.commit()` |
