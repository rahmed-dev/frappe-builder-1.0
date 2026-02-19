---
name: "Validate Code Quality"
step: 6
description: "Run tests and scan for anti-patterns to ensure code quality"
variables:
  - test_results
  - anti_patterns_found
  - validation_status
---

# Step 7: Validate Code Quality

**Goal:** Run tests and scan for Frappe anti-patterns to ensure production-ready code quality.

---

## MANDATORY EXECUTION RULES

<critical>
- Run ALL tests (unit tests, integration tests)
- Scan ALL implemented code for anti-patterns
- Report test failures with details
- Report anti-patterns with location and severity
- Offer to fix critical issues before completion
- DO NOT mark as complete if critical anti-patterns found
</critical>

---

## Reference Materials

**Load anti-pattern checklist:** `data/anti-patterns-checklist.md`

This file contains:
- Common Frappe anti-patterns
- Security vulnerabilities (SQL injection, XSS, missing permissions)
- Performance issues
- Code quality problems
- Best practice violations

---

## Session Variables (Available)

- `{{bench_path}}` - Path to Frappe bench
- `{{app}}` - Frappe app name
- `{{default_site}}` - Default site name
- Implemented code files and locations

---

## Step Instructions

### Phase A: Run Tests

#### 1. Execute Test Suite

**Command:**
```bash
cd {{bench_path}}
bench --site {{default_site}} run-tests --app {{app}}
```

**Options:**
- Run specific module: `--module {{module_name}}`
- Run specific doctype: `--doctype "{{DocType Name}}"`
- Verbose output: `--verbose`

**Watch for:**
- Test execution progress
- Pass/fail status
- Error messages
- Traceback details

**Expected output:**
```
Running tests for app: {{app}}

test_asset_maintenance_request_creation (test_asset_maintenance_request.TestAssetMaintenanceRequest) ... ok
test_asset_validation (test_asset_maintenance_request.TestAssetMaintenanceRequest) ... ok
test_maintenance_cost_calculation (test_asset_maintenance_request.TestAssetMaintenanceRequest) ... FAIL

----------------------------------------------------------------------
Ran 3 tests in 2.456s

FAILED (failures=1)
```

#### 2. Analyze Test Results

**Collect metrics:**
```
Test Results:
============
Total Tests: [X]
Passed: [X] ✓
Failed: [X] ✗
Skipped: [X] -
Duration: [X.XX] seconds
```

**For each failed test:**
- Test name
- Error message
- Traceback
- Expected vs actual values

**Example:**
```
FAILED: test_maintenance_cost_calculation
Error: AssertionError: 150.0 != 165.0
Expected total cost: 150.0
Actual total cost: 165.0

Traceback:
  File "test_asset_maintenance_request.py", line 45, in test_maintenance_cost_calculation
    self.assertEqual(doc.total_cost, 150.0)
```

#### 3. Handle Test Failures

**If tests fail:**

**Option 1: Investigate and fix now**
- Review failing test
- Check implementation logic
- Fix the code
- Rebuild: `bench build --app {{app}}`
- Re-run tests
- Verify pass

**Option 2: Document for later**
- Record failing tests
- Add to known issues list
- Continue with anti-pattern scan
- Address before final completion

**If all tests pass:**
- Continue to Phase B (Anti-Pattern Scan)

---

### Phase B: Anti-Pattern Scan

#### 4. Scan for Security Issues

**Load:** `data/anti-patterns-checklist.md`

**Scan all implemented files for:**

**A. Missing @frappe.whitelist() decorator**

Search in API files:
```python
# ❌ ANTI-PATTERN: Missing decorator
def get_data(filters):
    return frappe.db.sql("SELECT * FROM ...")

# ✅ CORRECT
@frappe.whitelist()
def get_data(filters):
    return frappe.db.sql("SELECT * FROM ...")
```

**Impact:** Function not accessible from client, security risk if exposed
**Severity:** CRITICAL

**B. SQL Injection Risks**

```python
# ❌ ANTI-PATTERN: String concatenation
frappe.db.sql("SELECT * FROM `tabUser` WHERE name = '%s'" % user_name)

# ✅ CORRECT: Parameterized query
frappe.db.sql("SELECT * FROM `tabUser` WHERE name = %(name)s", {"name": user_name})
```

**Impact:** SQL injection vulnerability
**Severity:** CRITICAL

**C. Missing Permission Checks**

```python
# ❌ ANTI-PATTERN: No permission check
@frappe.whitelist()
def delete_record(docname):
    frappe.delete_doc("DocType", docname)

# ✅ CORRECT: Check permissions
@frappe.whitelist()
def delete_record(docname):
    frappe.has_permission("DocType", "delete", throw=True)
    frappe.delete_doc("DocType", docname)
```

**Impact:** Unauthorized access
**Severity:** CRITICAL

#### 5. Scan for Code Quality Issues

**D. Client-Side Business Logic**

```javascript
// ❌ ANTI-PATTERN: Complex calculation on client
frappe.ui.form.on('DocType', {
    calculate_total: function(frm) {
        let total = 0;
        frm.doc.items.forEach(item => {
            let tax = item.amount * 0.18;  // Business logic on client
            let discount = get_discount(item);  // Complex logic
            total += item.amount + tax - discount;
        });
        frm.set_value('total', total);
    }
});

// ✅ CORRECT: Call server method
frappe.ui.form.on('DocType', {
    calculate_total: function(frm) {
        frappe.call({
            method: 'app.api.calculate_total',
            args: { doc: frm.doc },
            callback: function(r) {
                frm.set_value('total', r.message);
            }
        });
    }
});
```

**Impact:** Inconsistent calculations, bypass validations
**Severity:** HIGH

**E. Not Converting Form Values**

```javascript
// ❌ ANTI-PATTERN: String arithmetic
let qty = frm.doc.qty;  // "5" (string)
let total = qty * 10;   // "5555555555" (string concatenation)

// ✅ CORRECT: Convert to number
let qty = parseInt(frm.doc.qty) || 0;
let total = qty * 10;  // 50 (number)
```

**Impact:** Incorrect calculations
**Severity:** HIGH

**F. Direct frappe.db.sql Without Params**

```python
# ❌ ANTI-PATTERN
filters = f"status = '{status}' AND date = '{date}'"
frappe.db.sql(f"SELECT * FROM `tabDoc` WHERE {filters}")

# ✅ CORRECT
frappe.db.sql("""
    SELECT * FROM `tabDoc`
    WHERE status = %(status)s AND date = %(date)s
""", {"status": status, "date": date})
```

**Impact:** SQL injection vulnerability
**Severity:** CRITICAL

**G. Custom Date/Number Handling**

```python
# ❌ ANTI-PATTERN
date = datetime.strptime(date_string, "%Y-%m-%d")
formatted = f"{amount:,.2f}"

# ✅ CORRECT: Use frappe.utils
from frappe.utils import getdate, fmt_money
date = getdate(date_string)
formatted = fmt_money(amount, currency="USD")
```

**Impact:** Inconsistent formatting, bugs
**Severity:** MEDIUM

**H. console.log() in Production**

```javascript
// ❌ ANTI-PATTERN
console.log("Debug info:", frm.doc);
console.log(response);

// ✅ CORRECT
// Remove console.log() statements
// Or use: frappe.debug.log() for debug mode only
```

**Impact:** Performance, security (exposing data)
**Severity:** LOW

**I. Missing ignore_permissions in Scheduled Jobs**

```python
# ❌ ANTI-PATTERN
def scheduled_job():
    docs = frappe.get_all("DocType")  # Fails if no user context

# ✅ CORRECT
def scheduled_job():
    docs = frappe.get_all("DocType", ignore_permissions=True)
```

**Impact:** Scheduled job fails
**Severity:** HIGH

#### 6. Generate Anti-Pattern Report

For each anti-pattern found:

```
ANTI-PATTERN REPORT
===================

[CRITICAL] Missing @frappe.whitelist() Decorator
File: app/module/api.py
Line: 45
Code: def get_sensitive_data(user):
Fix: Add @frappe.whitelist() decorator above function

[CRITICAL] SQL Injection Risk
File: app/module/doctype/custom/custom.py
Line: 78
Code: frappe.db.sql("SELECT * WHERE name = '%s'" % name)
Fix: Use parameterized query: WHERE name = %(name)s

[HIGH] Business Logic in Client Script
File: app/module/doctype/custom/custom.js
Line: 23-35
Code: Complex tax calculation on client
Fix: Move calculation to server method

[MEDIUM] Not Using frappe.utils
File: app/module/api.py
Line: 102
Code: Custom date formatting with strftime
Fix: Use frappe.utils.formatdate()

[LOW] console.log() Statement
File: app/module/doctype/custom/custom.js
Line: 67
Code: console.log("Debug:", frm.doc)
Fix: Remove or use frappe.debug.log()
```

**Summary:**
```
Anti-Patterns Found: [X]
├─ Critical: [X] 🔴
├─ High: [X] 🟠
├─ Medium: [X] 🟡
└─ Low: [X] 🟢
```

---

## Menu

**What would you like to do?**

**If NO critical anti-patterns:**
**[A]** Auto-continue to Step 8 (Complete)
**[F]** Fix remaining issues now
**[P]** Pause here (review validation results)

**If CRITICAL anti-patterns found:**
**[F]** Fix critical issues now (RECOMMENDED)
**[D]** Document as known issues and continue (NOT RECOMMENDED)
**[C]** Cancel workflow

---

## Success Criteria

- ✅ All tests executed
- ✅ Test pass rate is acceptable (100% or documented failures)
- ✅ Anti-pattern scan completed
- ✅ No CRITICAL anti-patterns (or all fixed)
- ✅ HIGH-priority issues addressed or documented
- ✅ Code is production-ready

---

## Update State

Update `session.yaml`:
```yaml
workflow_step: 6
current_task: "Validated code quality"
last_action: "Tests: [X passed / Y failed], Anti-patterns: [X found, Y critical]"
next_action: "Generate completion summary"
updated: "[current timestamp]"
```

---

## Next Step

**If [A]uto-continue:**
**→ Load and execute:** `steps/step-07-complete.md`

**If [F]ix issues:**
1. Fix reported issues
2. Rebuild and redeploy (back to Step 6)
3. Re-run validation (current step)
4. Then proceed to Step 8

**If [P]ause:**
STOP here. User can review validation results.

**If [D]ocument issues:**
Record known issues, then proceed to Step 8.

**If [C]ancel:**
EXIT workflow. Update state and preserve progress.
