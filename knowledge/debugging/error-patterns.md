# Common Error Patterns & Solutions

> Quick reference for debugging common Frappe/ERPNext errors.

## Permission Errors

### Error: "frappe.PermissionError: No permission for Task"

**Cause:** User lacks required permission or document-level access.

**Fix:**
```python
# Check permission before operation
if not frappe.has_permission('Task', 'read', doc):
    frappe.throw('No permission')

# Add role to DocType permissions
# Desk → DocType → Task → Permissions → Add Role
```

**Check:**
```bash
# In bench console
bench --site site-name console
>>> frappe.set_user('user@example.com')
>>> frappe.has_permission('Task', 'read')
```

### Error: "You are not permitted to access this document"

**Cause:** User Permission restriction.

**Fix:**
```python
# Check user permissions
permissions = frappe.defaults.get_user_permissions('user@example.com')

# Remove user permission
frappe.defaults.clear_user_permissions_for_doctype('Cost Center', 'user@example.com')

# Add user permission
frappe.defaults.add_user_permission('Cost Center', 'Manufacturing', 'user@example.com')
```

## Database Errors

### Error: "pymysql.err.ProgrammingError: Table doesn't exist"

**Cause:** Migration not run or DocType not synced.

**Fix:**
```bash
bench --site site-name migrate
bench --site site-name clear-cache
bench restart
```

### Error: "Duplicate entry 'TASK-001' for key 'PRIMARY'"

**Cause:** Document name already exists.

**Fix:**
```python
# Check if exists before insert
if frappe.db.exists('Task', 'TASK-001'):
    frappe.throw('Task already exists')

doc = frappe.get_doc({
    'doctype': 'Task',
    'subject': 'New Task'
})
doc.insert()
```

### Error: "Data too long for column"

**Cause:** Field value exceeds defined length.

**Fix:**
```python
# Increase field length in DocType JSON
{
    "fieldname": "description",
    "fieldtype": "Small Text"  # or "Long Text" or "Text Editor"
}

# Reload DocType
# bench --site site-name reload-doc app_name doctype_name "DocType Name"
```

## Validation Errors

### Error: "Cannot edit submitted document"

**Cause:** Attempting to modify submitted doc without `allow_on_submit`.

**Fix:**
```python
# Option 1: Cancel, amend, resubmit
doc.cancel()
amended_doc = frappe.copy_doc(doc)
amended_doc.insert()
amended_doc.submit()

# Option 2: Allow field edit after submit
# DocType JSON:
{
    "fieldname": "remarks",
    "allow_on_submit": 1
}
```

### Error: "Mandatory field required"

**Cause:** Required field is empty.

**Fix:**
```python
# Set field before save
doc.mandatory_field = 'value'
doc.save()

# Or make field non-mandatory in DocType JSON
{
    "fieldname": "optional_field",
    "reqd": 0
}
```

### Error: "Row # - [field]: Invalid value"

**Cause:** Child table validation failed.

**Fix:**
```python
# Validate child rows
def validate(self):
    for row in self.items:
        if row.qty <= 0:
            frappe.throw(f'Row {row.idx}: Qty must be positive')
```

## API Errors

### Error: "Not permitted for [method_name]"

**Cause:** Method not whitelisted or user lacks permission.

**Fix:**
```python
# Add @frappe.whitelist()
@frappe.whitelist()
def my_api_method():
    if not frappe.has_permission('Task', 'write'):
        frappe.throw('No permission')
    return {'success': True}
```

### Error: "Invalid Method"

**Cause:** Method path incorrect or not accessible.

**Fix:**
```python
# Correct method path in frappe.call()
frappe.call({
    method: 'my_app.my_app.doctype.my_doctype.my_doctype.my_method',
    // NOT: 'my_app.my_method'
})
```

### Error: "Expecting value: line 1 column 1 (char 0)"

**Cause:** API returned non-JSON response (often error page).

**Fix:**
```python
# Check server logs
tail -f sites/site-name/logs/error.log

# Ensure method returns valid JSON
@frappe.whitelist()
def my_method():
    return {'data': 'value'}  # Not: return "plain text"
```

## Import Errors

### Error: "No module named 'my_app'"

**Cause:** App not installed or Python path issue.

**Fix:**
```bash
# Reinstall app
bench --site site-name install-app my_app

# Check if app installed
bench --site site-name list-apps

# Rebuild
bench build --app my_app
bench restart
```

### Error: "cannot import name 'MyClass' from 'my_app.module'"

**Cause:** Circular import or class doesn't exist.

**Fix:**
```python
# Move import inside function
def my_function():
    from my_app.module import MyClass
    obj = MyClass()

# Or reorganize code to avoid circular imports
```

## JavaScript Errors

### Error: "frappe is not defined"

**Cause:** frappe.js not loaded or script running too early.

**Fix:**
```javascript
// Wait for frappe to load
frappe.ready(() => {
    // Your code here
});

// Or in page
frappe.pages['my-page'].on_page_load = function(wrapper) {
    // frappe is available here
};
```

### Error: "Cannot read property 'get_value' of undefined"

**Cause:** Field doesn't exist or form not ready.

**Fix:**
```javascript
// Check if field exists
if (frm.fields_dict.my_field) {
    let value = frm.doc.my_field;
}

// Wait for form to load
frappe.ui.form.on('Task', {
    onload: function(frm) {
        // Fields ready here
    }
});
```

## Performance Issues

### Error: "Gateway Timeout (504)"

**Cause:** Operation taking too long.

**Fix:**
```python
# Move to background job
frappe.enqueue(
    'my_app.tasks.long_running_task',
    queue='long',
    timeout=3600,
    **kwargs
)

# Increase timeout in config
# site_config.json:
{
    "http_timeout": 300
}
```

### Error: "Out of memory"

**Cause:** Processing too much data at once.

**Fix:**
```python
# Batch processing
def process_all_tasks():
    tasks = frappe.get_all('Task', pluck='name')

    batch_size = 100
    for i in range(0, len(tasks), batch_size):
        batch = tasks[i:i+batch_size]
        process_batch(batch)
        frappe.db.commit()  # Commit per batch
```

## CSS Issues

### Error: "Styles affecting other pages"

**Cause:** CSS not scoped to specific page.

**Fix:**
```css
/* ❌ WRONG - global pollution */
.container { padding: 20px; }

/* ✅ CORRECT - scoped */
.page-my-custom-page .container { padding: 20px; }
```

```javascript
// Load CSS only for specific page
frappe.pages['my-custom-page'].on_page_load = function(wrapper) {
    frappe.require('/assets/my_app/css/my_page.css');
};
```

## Workflow Errors

### Error: "Workflow State is mandatory"

**Cause:** Workflow enabled but state not set.

**Fix:**
```python
# Set initial workflow state
def before_insert(self):
    if not self.workflow_state:
        self.workflow_state = 'Draft'
```

### Error: "You are not allowed to change Workflow State to [state]"

**Cause:** User role not allowed for transition.

**Fix:**
```
# Check Workflow definition
Desk → Workflow → [Workflow Name] → Transitions
# Ensure user's role is allowed for transition
```

## Search Index Errors

### Error: "Search index update failed"

**Cause:** Search index corruption or missing.

**Fix:**
```bash
# Rebuild search index
bench --site site-name build-search-index

# Or migrate with skip
bench --site site-name migrate --skip-search-index
```

## Common Anti-Patterns

### SQL Injection Risk

```python
# ❌ WRONG - SQL injection risk
status = request.args.get('status')
data = frappe.db.sql(f"SELECT * FROM tabTask WHERE status = '{status}'")

# ✅ CORRECT - parameterized
data = frappe.db.sql("""
    SELECT * FROM tabTask WHERE status = %(status)s
""", {'status': status})
```

### Missing Permission Checks

```python
# ❌ WRONG - no permission check
@frappe.whitelist()
def delete_task(task_name):
    frappe.delete_doc('Task', task_name)

# ✅ CORRECT - check permission
@frappe.whitelist()
def delete_task(task_name):
    doc = frappe.get_doc('Task', task_name)
    if not frappe.has_permission('Task', 'delete', doc):
        frappe.throw('No permission')
    doc.delete()
```

### Client-Side Filtering

```python
# ❌ WRONG - fetch all, filter client-side
// JavaScript
frappe.call({
    method: 'my_app.api.get_all_tasks',
    callback: (r) => {
        let open_tasks = r.message.filter(t => t.status === 'Open');
    }
});

# ✅ CORRECT - filter server-side
@frappe.whitelist()
def get_tasks(status=None):
    filters = {}
    if status:
        filters['status'] = status
    return frappe.get_all('Task', filters=filters, fields=['name', 'subject'])
```

## Debugging Workflow

1. **Check error log:** `sites/site-name/logs/error.log`
2. **Check web log:** `sites/site-name/logs/web.log`
3. **Enable developer mode:** `bench --site site-name set-config developer_mode 1`
4. **Use bench console:** `bench --site site-name console`
5. **Check permissions:** `frappe.has_permission()`
6. **Test in isolation:** Create minimal test case
7. **Check SQL:** Enable query logging in developer mode
8. **Browser console:** Check for JS errors (F12)

## Key Rules

- ✅ Always check logs first: `error.log`, `web.log`
- ✅ Use `bench console` for quick debugging
- ✅ Enable `developer_mode` during development
- ✅ Check permissions before operations
- ✅ Use parameterized SQL queries
- ✅ Scope CSS to page class
- ✅ Use background jobs for long operations
- ✅ Batch process large datasets
- ❌ Never ignore permission errors
- ❌ Never use string concatenation in SQL
