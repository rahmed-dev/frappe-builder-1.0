# Frappe Anti-Patterns - Quick Reference

> **Full details:** `{project-root}/.bmad/frappe-builder/knowledge/debugging/anti-patterns.md`

## Top 10 Anti-Patterns to Detect

### 1. SQL Injection ⚠️ CRITICAL
```python
❌ BAD: frappe.db.sql(f"SELECT * FROM `tabTask` WHERE status='{status}'")
✅ GOOD: frappe.db.sql("SELECT * FROM `tabTask` WHERE status=%s", (status,))
```

### 2. N+1 Query Problem
```python
❌ BAD: Loop calling frappe.get_doc() for each item
✅ GOOD: Single JOIN query or frappe.get_all() with filters
```

### 3. Missing Permission Checks
```python
❌ BAD: @frappe.whitelist() without permission validation
✅ GOOD: Check frappe.has_permission() before operations
```

### 4. Ignoring Transaction Safety
```python
❌ BAD: Multiple db operations without frappe.db.commit()
✅ GOOD: Wrap in try/except, use frappe.db.commit()
```

### 5. Hardcoded Values
```python
❌ BAD: if customer_group == "Wholesale":
✅ GOOD: Load from Custom Settings/System Defaults
```

### 6. Not Using frappe.utils
```python
❌ BAD: Custom date parsing, float conversion
✅ GOOD: Use getdate(), flt(), cint(), cstr()
```

### 7. Business Logic in Client Scripts
```python
❌ BAD: Calculations/validations in .js files
✅ GOOD: Server-side in DocType controller .py
```

### 8. Inefficient Queries
```python
❌ BAD: frappe.get_all('Task') # Fetches all fields
✅ GOOD: frappe.get_all('Task', fields=['name', 'status'])
```

### 9. Not Handling Errors
```python
❌ BAD: No try/except, no validation
✅ GOOD: Validate inputs, catch exceptions, log errors
```

### 10. Modifying Core DocTypes
```python
❌ BAD: Editing erpnext/selling/doctype/sales_order/*.json
✅ GOOD: Use Custom Fields via fixtures
```

## Quick Debugging Checklist

When debugging an error:
- [ ] Check for SQL injection (parameterized queries?)
- [ ] Check for N+1 queries (console shows many DB hits?)
- [ ] Check permission validation (@frappe.whitelist functions?)
- [ ] Check transaction safety (commit/rollback?)
- [ ] Check error logs (bench --site sitename logs)
- [ ] Check for hardcoded values (should be in settings?)

## Red Flags in Code Review

🚩 **f-strings or .format() in SQL queries** → SQL injection risk
🚩 **frappe.get_doc() in loops** → N+1 query problem
🚩 **@frappe.whitelist() without has_permission()** → Security issue
🚩 **Business logic in .js files** → Architecture issue
🚩 **No try/except around db operations** → Crash risk
🚩 **Editing core ERPNext files** → Upgrade nightmare

## For Full Details

Consult the comprehensive anti-patterns guide:
`{project-root}/.bmad/frappe-builder/knowledge/debugging/anti-patterns.md`
