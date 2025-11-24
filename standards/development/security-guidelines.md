# Security Guidelines

Critical security rules for Frappe development. Non-negotiable.

## 1. Permission Checks

**Rule:** EVERY @frappe.whitelist() must verify permissions.

### Standard Pattern

```python
@frappe.whitelist()
def my_api_method(doctype, name):
    # STEP 1: Check permission FIRST
    if not frappe.has_permission(doctype, "read", name):
        frappe.throw("Insufficient permissions", frappe.PermissionError)

    # STEP 2: Proceed with logic
    doc = frappe.get_doc(doctype, name)
    return doc.as_dict()
```

### Permission Check Methods

| Method | Use Case |
|--------|----------|
| `frappe.has_permission(doctype, ptype, doc)` | Check if current user has permission |
| `doc.check_permission(ptype)` | Throws error if no permission |
| `frappe.only_for(roles)` | Decorator to restrict to specific roles |
| `frappe.permissions.has_permission_to_create(doctype)` | Check create permission |

### Role-Based Access

```python
from frappe import only_for

@frappe.whitelist()
@only_for("System Manager")
def delete_all_records(doctype):
    # Only System Managers can call this
    frappe.db.delete(doctype)
```

## 2. SQL Injection Prevention

**Rule:** NEVER use string formatting/f-strings in SQL.

### Vulnerable Code

```python
❌ CRITICAL VULNERABILITY:
customer = frappe.form_dict.get("customer")  # User input
frappe.db.sql(f"SELECT * FROM `tabCustomer` WHERE name='{customer}'")

# Attack: customer = "' OR '1'='1' --"
# Results in: SELECT * FROM `tabCustomer` WHERE name='' OR '1'='1' --'
# Returns ALL customers
```

### Safe Code

```python
✅ SAFE - Parameterized query:
customer = frappe.form_dict.get("customer")
frappe.db.sql("SELECT * FROM `tabCustomer` WHERE name=%s", (customer,))

✅ BETTER - Use ORM:
frappe.get_all("Customer", filters={"name": customer})

✅ BEST - Use get_value for single record:
frappe.db.get_value("Customer", customer, ["name", "customer_name"])
```

### Safe Query Patterns

```python
# Multiple parameters
frappe.db.sql("""
    SELECT name, total FROM `tabSales Order`
    WHERE customer=%s AND status=%s AND date>=%s
""", (customer, status, from_date), as_dict=True)

# IN clause (use tuple)
customers = ["CUST-001", "CUST-002"]
frappe.db.sql("""
    SELECT name FROM `tabSales Order`
    WHERE customer IN %s
""", (tuple(customers),))

# Dynamic table names - ONLY if from safe source
doctype = "Sales Order"  # From code, not user input
table_name = f"tab{doctype}"  # Safe - frappe convention
frappe.db.sql(f"SELECT name FROM `{table_name}` WHERE status='Open'")
```

## 3. XSS Prevention

**Rule:** Sanitize user input before displaying in HTML.

### Vulnerable Code

```python
❌ XSS VULNERABILITY:
@frappe.whitelist()
def show_message(message):
    frappe.msgprint(message)  # If message = "<script>alert('XSS')</script>"
```

### Safe Code

```python
✅ SAFE - Escape HTML:
from frappe.utils import escape_html

@frappe.whitelist()
def show_message(message):
    frappe.msgprint(escape_html(message))
```

### Client-Side Safety

```javascript
❌ BAD:
let user_input = frappe.form_dict.comment;
frm.set_df_property("description", "description",
    `<div>${user_input}</div>`);  // XSS risk

✅ GOOD:
let user_input = frappe.form_dict.comment;
frm.set_value("description", user_input);  // Frappe handles escaping
```

## 4. CSRF Protection

**Built-in:** Frappe handles CSRF automatically for POST requests.

**Important:** Don't disable CSRF protection.

```python
❌ NEVER DO THIS:
@frappe.whitelist(allow_guest=True)
def delete_records():  # Allows unauthenticated deletion
    frappe.db.delete("Sales Order")
```

```python
✅ SAFE:
@frappe.whitelist()  # Requires authentication + CSRF token
def delete_records():
    if not frappe.has_permission("Sales Order", "delete"):
        frappe.throw("No permission")
    # ... deletion logic
```

## 5. Password Security

**Rule:** Never store or log passwords in plaintext.

### Secure Password Handling

```python
from frappe.utils.password import get_decrypted_password, set_encrypted_password

# Store password
set_encrypted_password("User", user_email, password)

# Retrieve password
password = get_decrypted_password("User", user_email, "password")

# Hash for one-way comparison
from passlib.context import CryptContext
pwd_context = CryptContext(schemes=["bcrypt"])
hashed = pwd_context.hash(password)
is_valid = pwd_context.verify(password, hashed)
```

### Never Log Passwords

```python
❌ BAD:
frappe.log_error(f"Login failed for user {email} with password {password}")

✅ GOOD:
frappe.log_error(f"Login failed for user {email}")
```

## 6. File Upload Security

**Rule:** Validate file types and sizes.

### Safe File Upload

```python
@frappe.whitelist()
def upload_file():
    files = frappe.request.files
    file = files.get("file")

    # Validate file type
    allowed_extensions = [".pdf", ".png", ".jpg", ".docx"]
    file_ext = os.path.splitext(file.filename)[1].lower()

    if file_ext not in allowed_extensions:
        frappe.throw(f"File type {file_ext} not allowed")

    # Validate file size (10MB limit)
    if len(file.read()) > 10 * 1024 * 1024:
        frappe.throw("File size exceeds 10MB limit")

    # Reset file pointer after size check
    file.seek(0)

    # Use Frappe's secure file handling
    file_doc = frappe.get_doc({
        "doctype": "File",
        "file_name": file.filename,
        "content": file.read(),
        "is_private": 1  # Important: Private by default
    })
    file_doc.save()

    return file_doc.file_url
```

## 7. Session Security

### Secure Session Handling

```python
# Check if user is logged in
if frappe.session.user == "Guest":
    frappe.throw("Please login", frappe.AuthenticationError)

# Get current user
user = frappe.session.user

# Check user roles
if "System Manager" in frappe.get_roles():
    # System Manager specific logic
    pass

# Session timeout is configured in site_config.json
# session_expiry: "06:00:00"  # 6 hours
```

### Logout Properly

```python
frappe.local.login_manager.logout()
frappe.db.commit()
```

## 8. API Rate Limiting

**Rule:** Prevent abuse with rate limiting.

```python
from frappe.rate_limiter import rate_limit

@frappe.whitelist(allow_guest=True)
@rate_limit(limit=10, seconds=60)  # 10 requests per minute
def public_api():
    return {"message": "Hello"}
```

## 9. Sensitive Data Handling

**Rule:** Mask/redact sensitive information in logs and responses.

```python
# Mask sensitive fields
def get_customer_data(customer):
    data = frappe.db.get_value("Customer", customer,
        ["name", "customer_name", "credit_card"], as_dict=True)

    # Mask credit card
    if data.get("credit_card"):
        data["credit_card"] = data["credit_card"][-4:].rjust(16, "*")

    return data
```

## 10. Environment-Specific Configs

**Rule:** Never hardcode secrets. Use site_config.json or environment variables.

```python
❌ BAD - Hardcoded secrets:
API_KEY = "sk_live_abc123xyz"
DATABASE_PASSWORD = "mypassword"
```

```python
✅ GOOD - From site_config.json:
# In site_config.json:
# {
#   "api_key": "sk_live_abc123xyz",
#   "database_password": "encrypted_value"
# }

# In code:
api_key = frappe.conf.get("api_key")
db_password = frappe.conf.get("database_password")

# OR from environment
import os
api_key = os.getenv("API_KEY")
```

## Security Checklist

Before deploying:
- [ ] All @frappe.whitelist() methods check permissions
- [ ] All SQL queries parameterized (no f-strings)
- [ ] User input sanitized before display (escape_html)
- [ ] Passwords encrypted, never logged
- [ ] File uploads validated (type, size)
- [ ] Sensitive data masked in logs/responses
- [ ] No hardcoded secrets (use site_config.json)
- [ ] Rate limiting on public APIs
- [ ] HTTPS enabled in production
- [ ] Security headers configured (Nginx)

## Common Vulnerabilities

| Vulnerability | Example | Fix |
|---------------|---------|-----|
| **SQL Injection** | f"WHERE name='{user_input}'" | Parameterized: "WHERE name=%s", (input,) |
| **XSS** | msgprint(user_input) | msgprint(escape_html(user_input)) |
| **Missing Auth** | No permission check | Add has_permission() check |
| **Password Leak** | Logging passwords | Never log passwords |
| **File Upload** | No validation | Check type, size, content |
| **Hardcoded Secrets** | API_KEY = "abc123" | Use frappe.conf.get("api_key") |
| **IDOR** | Direct access by ID | Check user has permission to that doc |

## Related

- [Coding Principles](./coding-principles.md)
- [Performance Rules](./performance-rules.md)
- [Frappe Permissions](https://frappeframework.com/docs/user/en/basics/permissions)
