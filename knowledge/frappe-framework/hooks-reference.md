# Frappe Hooks Reference

> Configure app behavior using hooks.py - event-based customization without modifying core.

## What are Hooks?

Hooks allow apps to inject custom logic into Frappe framework events without modifying core code. Defined in `my_app/hooks.py`.

## Document Hooks

### Override Controller Methods

```python
# hooks.py
doc_events = {
    "Task": {
        "validate": "my_app.custom.validate_task",
        "on_submit": "my_app.custom.task_submitted",
        "on_cancel": "my_app.custom.task_cancelled"
    },
    "*": {
        "on_update": "my_app.custom.log_all_updates"
    }
}

# my_app/custom.py
def validate_task(doc, method):
    if doc.status == 'Completed' and not doc.completed_date:
        frappe.throw('Completed date required')

def task_submitted(doc, method):
    # Create linked records, notifications
    pass
```

### Available Document Events

| Event | When | Use Case |
|-------|------|----------|
| `validate` | Before save | Business logic validation |
| `before_save` | After validate | Set computed fields |
| `after_insert` | After first save | Create linked records |
| `on_update` | After save (existing) | Update related docs |
| `on_submit` | On submit | Ledger/stock updates |
| `on_cancel` | On cancel | Reverse ledger/stock |
| `on_trash` | Before delete | Cleanup linked records |
| `on_update_after_submit` | After allowed field update | Recalculate totals |

## Scheduled Jobs

### Cron Jobs

```python
# hooks.py
scheduler_events = {
    # Every hour
    "hourly": [
        "my_app.tasks.sync_data"
    ],

    # Every day at midnight
    "daily": [
        "my_app.tasks.cleanup_old_logs"
    ],

    # Every week on Sunday
    "weekly": [
        "my_app.tasks.generate_weekly_report"
    ],

    # Every month on 1st
    "monthly": [
        "my_app.tasks.process_payroll"
    ],

    # Every 5 minutes
    "cron": {
        "*/5 * * * *": [
            "my_app.tasks.check_alerts"
        ]
    }
}

# my_app/tasks.py
def sync_data():
    # Runs every hour
    frappe.enqueue('my_app.tasks.heavy_sync', queue='long')

def cleanup_old_logs():
    # Delete logs older than 90 days
    frappe.db.delete('Error Log', {
        'creation': ['<', frappe.utils.add_days(None, -90)]
    })
```

### Scheduler Event Types

| Event | Frequency | Cron Equivalent |
|-------|-----------|-----------------|
| `all` | Every event | - |
| `hourly` | Every hour | `0 * * * *` |
| `hourly_long` | Every hour (long queue) | `0 * * * *` |
| `daily` | Midnight | `0 0 * * *` |
| `daily_long` | Midnight (long queue) | `0 0 * * *` |
| `weekly` | Sunday midnight | `0 0 * * 0` |
| `monthly` | 1st midnight | `0 0 1 * *` |
| `cron` | Custom cron | Custom |

## Permission Hooks

### Custom Permission Query

```python
# hooks.py
permission_query_conditions = {
    "Task": "my_app.permissions.get_task_permission_query"
}

# my_app/permissions.py
def get_task_permission_query(user):
    if not user:
        user = frappe.session.user

    if 'System Manager' in frappe.get_roles(user):
        return None  # See all

    # Only see assigned tasks
    return f"""(`tabTask`.assigned_to = {frappe.db.escape(user)})"""
```

### Has Permission Check

```python
# hooks.py
has_permission = {
    "Task": "my_app.permissions.has_task_permission"
}

# my_app/permissions.py
def has_task_permission(doc, user):
    if 'System Manager' in frappe.get_roles(user):
        return True

    return doc.assigned_to == user
```

## Override Whitelisted Methods

```python
# hooks.py
override_whitelisted_methods = {
    "frappe.desk.form.load.getdoc": "my_app.custom.custom_getdoc"
}

# my_app/custom.py
@frappe.whitelist()
def custom_getdoc(doctype, name):
    # Custom logic before loading doc
    doc = frappe.get_doc(doctype, name)

    # Add custom data
    doc.custom_field = calculate_custom_value(doc)

    return doc
```

## Jinja Hooks

### Custom Jinja Methods

```python
# hooks.py
jinja = {
    "methods": [
        "my_app.utils.get_company_name",
        "my_app.utils.format_currency"
    ]
}

# my_app/utils.py
def get_company_name():
    return frappe.defaults.get_user_default('Company')

def format_currency(amount):
    return frappe.utils.fmt_money(amount)
```

```jinja
{# Use in print format #}
{{ get_company_name() }}
{{ format_currency(doc.grand_total) }}
```

## Web Hooks

### Website Route Rules

```python
# hooks.py
website_route_rules = [
    {"from_route": "/old-page", "to_route": "/new-page"},
    {"from_route": "/blog/<path:name>", "to_route": "/posts/<name>"}
]
```

### Website Redirects

```python
# hooks.py
website_redirects = [
    {"source": "/old-url", "target": "/new-url"}
]
```

## App Hooks

### Boot Session

```python
# hooks.py
boot_session = "my_app.boot.boot_session"

# my_app/boot.py
def boot_session(bootinfo):
    """Add custom data to boot session"""
    bootinfo.custom_settings = {
        'allow_feature_x': frappe.db.get_single_value('Settings', 'allow_feature_x')
    }
```

Access in JavaScript:
```javascript
if (frappe.boot.custom_settings.allow_feature_x) {
    // Feature enabled
}
```

### Extend Bootinfo

```python
# hooks.py
extend_bootinfo = "my_app.boot.extend_bootinfo"

# my_app/boot.py
def extend_bootinfo(bootinfo):
    bootinfo.user_settings = frappe.get_doc('User Settings', frappe.session.user).as_dict()
```

## Fixtures

### Auto-Import Data

```python
# hooks.py
fixtures = [
    "Custom Field",
    "Property Setter",
    {"dt": "Workflow", "filters": [["name", "in", ["Task Workflow", "Approval Workflow"]]]},
]
```

Export fixtures:
```bash
bench --site site-name export-fixtures
```

## DocType Links

### Link Validation

```python
# hooks.py
doc_events = {
    "Sales Order": {
        "on_submit": "my_app.validations.validate_stock_availability"
    }
}

# my_app/validations.py
def validate_stock_availability(doc, method):
    for item in doc.items:
        available = frappe.db.get_value('Bin', {
            'item_code': item.item_code,
            'warehouse': item.warehouse
        }, 'actual_qty') or 0

        if available < item.qty:
            frappe.throw(f'Insufficient stock for {item.item_code}')
```

## File Hooks

### On File Upload

```python
# hooks.py
on_file_upload = "my_app.handlers.process_uploaded_file"

# my_app/handlers.py
def process_uploaded_file(doc):
    if doc.file_name.endswith('.pdf'):
        # Extract text, create records, etc.
        pass
```

## Notification Hooks

### Email Hooks

```python
# hooks.py
doc_events = {
    "Task": {
        "on_update": "my_app.notifications.notify_task_update"
    }
}

# my_app/notifications.py
def notify_task_update(doc, method):
    if doc.has_value_changed('status'):
        frappe.sendmail(
            recipients=[doc.assigned_to],
            subject=f'Task {doc.name} status changed',
            message=f'Status changed to {doc.status}'
        )
```

## Custom Hooks

### Regional Hooks

```python
# hooks.py
regional_overrides = {
    "India": {
        "erpnext.accounts.utils.get_taxes": "my_app.india.get_taxes"
    }
}
```

### After Migrate

```python
# hooks.py
after_migrate = [
    "my_app.migrate.setup_custom_fields",
    "my_app.migrate.sync_data"
]
```

## Global Hooks

### On Login/Logout

```python
# hooks.py
on_login = "my_app.auth.on_user_login"
on_logout = "my_app.auth.on_user_logout"

# my_app/auth.py
def on_user_login(login_manager):
    user = login_manager.user
    frappe.logger().info(f'User {user} logged in')

def on_user_logout(login_manager):
    frappe.logger().info(f'User logged out')
```

### On Session Creation

```python
# hooks.py
on_session_creation = "my_app.auth.setup_session"

# my_app/auth.py
def setup_session(login_manager):
    frappe.session.custom_data = get_user_preferences()
```

## Testing Hooks

```python
# hooks.py
required_apps = ["erpnext"]

before_tests = "my_app.tests.setup_test_data"

# my_app/tests.py
def setup_test_data():
    # Create test records
    if not frappe.db.exists('Company', '_Test Company'):
        frappe.get_doc({
            'doctype': 'Company',
            'company_name': '_Test Company'
        }).insert()
```

## Key Rules

- ✅ Use hooks for cross-cutting concerns (logging, notifications)
- ✅ Use `doc_events["*"]` for global behavior
- ✅ Use permission hooks for custom access control
- ✅ Use scheduler for background tasks
- ✅ Export fixtures for deployment
- ✅ Use `after_migrate` for one-time setup
- ✅ Test hooks don't affect core behavior
- ❌ Don't override core methods unnecessarily
- ❌ Don't use hooks for DocType-specific logic (use controller)
- ❌ Don't block main thread in scheduler (use enqueue)
