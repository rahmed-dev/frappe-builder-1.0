# Security Checklist

> Essential security checks for Frappe/ERPNext development.

## Permission Checks

### @frappe.whitelist() Methods

```python
# ✅ ALWAYS check permissions
@frappe.whitelist()
def update_task(task_name, new_status):
    doc = frappe.get_doc('Task', task_name)

    # Check document-level permission
    if not frappe.has_permission('Task', 'write', doc):
        frappe.throw('No permission', frappe.PermissionError)

    doc.status = new_status
    doc.save()
    return {'success': True}

# ❌ NEVER skip permission checks
@frappe.whitelist()
def update_task_unsafe(task_name, new_status):
    doc = frappe.get_doc('Task', task_name)
    doc.status = new_status
    doc.save()  # Anyone can update any task!
```

### Permission Check Patterns

| Operation | Check |
|-----------|-------|
| Read | `frappe.has_permission('DocType', 'read', doc)` |
| Write | `frappe.has_permission('DocType', 'write', doc)` |
| Create | `frappe.has_permission('DocType', 'create')` |
| Delete | `frappe.has_permission('DocType', 'delete', doc)` |
| Submit | `frappe.has_permission('DocType', 'submit', doc)` |

## SQL Injection Prevention

### Parameterized Queries

```python
# ✅ CORRECT - parameterized
status = frappe.form_dict.get('status')
data = frappe.db.sql("""
    SELECT name, subject
    FROM `tabTask`
    WHERE status = %(status)s
""", {'status': status}, as_dict=True)

# ❌ WRONG - SQL injection risk
status = frappe.form_dict.get('status')
data = frappe.db.sql(f"SELECT name FROM `tabTask` WHERE status = '{status}'")
# Attack: status = "'; DROP TABLE tabTask; --"
```

### ORM Methods (Safe by Default)

```python
# ✅ Use frappe.get_all() - safe
tasks = frappe.get_all(
    'Task',
    filters={'status': user_input},
    fields=['name', 'subject']
)

# ✅ Use frappe.db.get_value() - safe
value = frappe.db.get_value('Task', user_input, 'status')
```

## Input Validation

### Type Conversion

```python
# ✅ ALWAYS convert and validate types
@frappe.whitelist()
def update_quantity(item_name, qty):
    from frappe.utils import cint

    # Convert to int (safe)
    qty = cint(qty)

    if qty <= 0:
        frappe.throw('Quantity must be positive')

    if qty > 1000:
        frappe.throw('Quantity exceeds maximum allowed')

    # Proceed with validated data
    doc = frappe.get_doc('Item', item_name)
    doc.qty = qty
    doc.save()
```

### Common Validation Patterns

```python
from frappe.utils import flt, cint, cstr, validate_email_address

# Integer validation
qty = cint(user_input, default=0)

# Float validation
amount = flt(user_input, precision=2)

# String validation
text = cstr(user_input).strip()

# Email validation
try:
    validate_email_address(email, throw=True)
except frappe.InvalidEmailAddressError:
    frappe.throw('Invalid email')

# Date validation
from frappe.utils import getdate
date_obj = getdate(user_input)  # Raises error if invalid
```

## XSS Prevention

### HTML Sanitization

```python
# ✅ Sanitize HTML input
import frappe.utils.html_utils

@frappe.whitelist()
def save_comment(comment_text):
    # Sanitize HTML
    clean_html = frappe.utils.html_utils.sanitize_html(comment_text)

    doc = frappe.get_doc({
        'doctype': 'Comment',
        'content': clean_html
    })
    doc.insert()
```

### Client-Side Display

```javascript
// ✅ Use jQuery text() for user input
$container.text(user_input);  // Escapes HTML

// ❌ WRONG - XSS risk
$container.html(user_input);  // Does NOT escape

// ✅ If HTML needed, sanitize first
frappe.call({
    method: 'my_app.api.get_sanitized_html',
    callback: (r) => {
        $container.html(r.message);  // Already sanitized server-side
    }
});
```

## Authentication & Session

### Restrict to Specific Roles

```python
# ✅ Restrict sensitive operations
@frappe.whitelist()
def delete_all_tasks():
    frappe.only_for('System Manager')

    # Only System Managers reach here
    frappe.db.delete('Task')
```

### Guest Access Control

```python
# ✅ Explicitly allow guest if needed
@frappe.whitelist(allow_guest=True)
def public_api():
    # Anyone can access
    return {'message': 'Public data'}

# ❌ Default (no guest access)
@frappe.whitelist()
def protected_api():
    # Requires authentication
    return {'message': 'Protected data'}
```

## File Upload Security

### Validate File Type

```python
@frappe.whitelist()
def upload_document(file_url):
    # Get file doc
    file_doc = frappe.get_doc('File', {'file_url': file_url})

    # Validate file type
    allowed_extensions = ['.pdf', '.docx', '.xlsx']
    file_ext = file_doc.file_name.split('.')[-1].lower()

    if f'.{file_ext}' not in allowed_extensions:
        frappe.throw('File type not allowed')

    # Validate file size
    max_size = 5 * 1024 * 1024  # 5 MB
    if file_doc.file_size > max_size:
        frappe.throw('File too large')
```

### Prevent Path Traversal

```python
import os

# ✅ Validate file path
def get_file_content(filename):
    # Prevent path traversal
    filename = os.path.basename(filename)

    file_path = os.path.join('/safe/directory', filename)

    # Ensure path is within safe directory
    if not os.path.realpath(file_path).startswith('/safe/directory'):
        frappe.throw('Invalid file path')

    with open(file_path, 'r') as f:
        return f.read()
```

## Sensitive Data

### Password Handling

```python
# ✅ NEVER log passwords
@frappe.whitelist()
def authenticate_user(username, password):
    # DON'T: frappe.logger().info(f'Password: {password}')

    # Authenticate without logging
    user = frappe.authenticate(username, password)
    return {'authenticated': True}
```

### Redact Sensitive Fields

```python
# ✅ Exclude sensitive fields from API response
@frappe.whitelist()
def get_user_details(user_name):
    user = frappe.get_doc('User', user_name)

    # Don't return password fields
    return {
        'name': user.name,
        'email': user.email,
        'full_name': user.full_name
        # NOT: 'api_key', 'api_secret', 'password'
    }
```

## Rate Limiting

### Prevent Brute Force

```python
from frappe.utils import now_datetime, add_to_date
from datetime import datetime

@frappe.whitelist(allow_guest=True)
def login_api(username, password):
    # Check rate limit
    cache_key = f'login_attempts:{username}'
    attempts = frappe.cache().get(cache_key) or 0

    if attempts >= 5:
        frappe.throw('Too many login attempts. Try again later.')

    # Authenticate
    try:
        user = frappe.authenticate(username, password)
        frappe.cache().delete_value(cache_key)
        return {'success': True}
    except:
        # Increment attempts
        frappe.cache().set_value(cache_key, attempts + 1, expires_in_sec=300)
        frappe.throw('Invalid credentials')
```

## Logging & Monitoring

### Log Security Events

```python
# ✅ Log security-relevant events
@frappe.whitelist()
def delete_company(company_name):
    if not frappe.has_permission('Company', 'delete'):
        # Log unauthorized attempt
        frappe.log_error(
            f'Unauthorized delete attempt by {frappe.session.user}',
            'Security Alert'
        )
        frappe.throw('No permission')

    # Log successful deletion
    frappe.logger().info(f'Company {company_name} deleted by {frappe.session.user}')

    frappe.delete_doc('Company', company_name)
```

### Audit Trail

```python
# ✅ Enable version tracking for sensitive DocTypes
# DocType JSON:
{
    "track_changes": 1,
    "track_seen": 1
}
```

## Configuration Security

### Secure site_config.json

```json
// ✅ Secure production config
{
    "developer_mode": 0,
    "disable_website_cache": 0,
    "allow_tests": 0,
    "server_script_enabled": 0,
    "deny_multiple_sessions": 1,
    "session_expiry": "06:00:00"
}
```

### Environment Variables

```python
# ✅ Use environment variables for secrets
import os

api_key = os.environ.get('THIRD_PARTY_API_KEY')

# ❌ NEVER hardcode secrets
api_key = 'sk_live_12345abcdef'  # WRONG!
```

## Security Checklist

### Before Production

- [ ] All `@frappe.whitelist()` methods check permissions
- [ ] No SQL queries use string concatenation
- [ ] All user input is validated and sanitized
- [ ] File uploads validate type and size
- [ ] Sensitive data is not logged
- [ ] `developer_mode` disabled
- [ ] `allow_tests` disabled
- [ ] Session expiry configured
- [ ] HTTPS enabled
- [ ] Database backups scheduled
- [ ] Error logs monitored

### Code Review Checklist

- [ ] Permission checks before data operations
- [ ] Parameterized SQL queries (no f-strings)
- [ ] Type conversion with `flt()`, `cint()`
- [ ] Input validation (ranges, formats)
- [ ] HTML sanitization for user content
- [ ] No hardcoded credentials
- [ ] Sensitive fields excluded from API responses
- [ ] Rate limiting for authentication endpoints
- [ ] Security events logged
- [ ] File path validation (prevent traversal)

## Common Vulnerabilities

| Vulnerability | Prevention |
|---------------|------------|
| **SQL Injection** | Use parameterized queries, ORM methods |
| **XSS** | Sanitize HTML, use `.text()` not `.html()` |
| **CSRF** | Frappe handles automatically via tokens |
| **Permission Bypass** | Check permissions in all whitelisted methods |
| **Path Traversal** | Validate file paths with `os.path.basename()` |
| **Brute Force** | Implement rate limiting |
| **Session Hijacking** | Use HTTPS, set session expiry |
| **Information Disclosure** | Don't expose sensitive fields, sanitize errors |

## Key Rules

- ✅ ALWAYS check permissions in `@frappe.whitelist()` methods
- ✅ ALWAYS use parameterized SQL queries
- ✅ ALWAYS validate and convert user input
- ✅ ALWAYS sanitize HTML from users
- ✅ ALWAYS validate file uploads (type, size, path)
- ✅ NEVER log passwords or sensitive data
- ✅ NEVER hardcode credentials
- ✅ NEVER trust user input
- ✅ Enable `track_changes` for sensitive DocTypes
- ✅ Use HTTPS in production
