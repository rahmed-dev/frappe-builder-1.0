# Diagnostic Report
**Issue ID:** {{issue_id}}
**App:** {{app}}
**Date:** {{date}}
**Diagnosed By:** {{user_name}}

## Error Summary
**Type:** [Python Exception / JavaScript Error / SQL Error / Permission / Performance]
**Severity:** Critical / High / Medium / Low
**Impact:** [What's broken - 1 sentence]
**First Occurred:** [Date/time]
**Frequency:** [Once / Intermittent / Consistent]

## Symptoms
- [What user experiences]
- [Error messages visible to user]
- [When it occurs - specific trigger]

## Root Cause
[1-2 sentences explaining WHY error occurs]

## Error Evidence

### Traceback
```python
[Relevant traceback lines only - remove noise]
File "app/module/file.py", line 123, in method_name
    problematic_line_of_code
ErrorType: Error message here
```

### Request Context
- **User:** [Username/Role]
- **DocType:** [If applicable]
- **Document:** [name]
- **Action:** [What user was doing]

### Related Logs
```
[bench error.log relevant lines]
[bench web.log relevant lines]
```

## Technical Analysis

### File Location
**File:** `apps/{{app}}/{{app}}/{{module}}/{{file}}.py`
**Line:** {{line_number}}
**Method:** `{{method_name}}`

### Problematic Code
```python
# Current (broken) code
def method_name(self):
    problematic_line  # ← Error occurs here
    return result
```

### Why It Fails
[Technical explanation - assumptions violated, null values, type mismatch, etc.]

## Fix

### Code Changes
**File:** `apps/{{app}}/{{app}}/{{module}}/{{file}}.py`

```python
# BEFORE
def method_name(self):
    value = frappe.db.get_value("DocType", name, "field")
    return value.upper()  # Fails if value is None

# AFTER
def method_name(self):
    value = frappe.db.get_value("DocType", name, "field")
    return value.upper() if value else ""  # Handle None case
```

### Additional Changes
- [Database migration if needed]
- [Permission changes if needed]
- [Config changes if needed]

## Why This Fixes It
[1 sentence explaining why the fix works]

## Prevention

**Pattern to Avoid:**
```python
❌ Don't do this:
value = frappe.db.get_value(...)
result = value.upper()  # Assumes value is never None
```

**Best Practice:**
```python
✅ Do this instead:
value = frappe.db.get_value(...) or ""
result = value.upper()
```

**Related Standard:** [Link to coding principle / security guideline]

## Testing

### Reproduce Steps
1. [Exact steps to trigger original error]
2. [Include test data if needed]
3. [Expected: Error occurs]

### Verification Steps
1. [Apply fix]
2. [Run: bench restart]
3. [Repeat reproduce steps]
4. [Expected: No error, correct behavior]

### Test Cases
```python
# Unit test to prevent regression
def test_method_name_handles_none(self):
    # Case 1: Valid value
    doc.field = "TEST"
    result = doc.method_name()
    self.assertEqual(result, "TEST")

    # Case 2: None value (was failing)
    doc.field = None
    result = doc.method_name()
    self.assertEqual(result, "")  # Should not error
```

## Deployment

### Immediate Fix (Production)
```bash
# Apply hotfix
cd /path/to/frappe-bench
bench --site {{site}} migrate
bench restart
```

### Long-Term Fix (Development)
```bash
# Commit to version control
git add apps/{{app}}/...
git commit -m "fix: Handle None value in method_name"
git push
```

## Related Issues
- [Similar error pattern in other files]
- [GitHub issue link if applicable]

## Impact Assessment
**Before Fix:**
- Users affected: [Count/All]
- Data integrity: [Compromised/OK]
- Business impact: [Description]

**After Fix:**
- Risk of regression: Low/Medium/High
- Testing coverage: [Adequate/Needs more]

## Approval
- **Developer:** {{user_name}} - {{date}}
- **Reviewer:** [Name] - [Date]
- **Deployed:** [Date/time]
