---
name: "Validate Code Quality"
step: 7
mode: "new"
description: "Run tests and scan for anti-patterns to ensure code quality"
variables:
  - test_results
  - anti_patterns_found
  - validation_status
---

# Step 8: Validate Code Quality

**Goal:** Run tests and scan for Frappe anti-patterns to ensure production-ready code quality.

---

## MANDATORY EXECUTION RULES

<critical>
- Run ALL tests for the app/module
- Scan ALL implemented code for anti-patterns
- Report test failures with details
- Report anti-patterns with location and severity
- Offer to fix critical issues before completion
- DO NOT mark as complete if critical anti-patterns remain unfixed
</critical>

---

## Reference Materials

**Load anti-pattern checklist:** `data/anti-patterns-checklist.md`

This file contains:
- Security vulnerabilities (SQL injection, XSS, missing permissions)
- Performance issues
- Code quality problems
- Best practice violations with fix guidance

---

## Session Variables (Available)

- `{{bench_path}}` - Path to Frappe bench
- `{{app}}` - Frappe app name
- `{{default_site}}` - Default site name
- Implemented code files and locations

---

## Step Instructions

### Phase A: Run Tests

```bash
cd {{bench_path}}
bench --site {{default_site}} run-tests --app {{app}}
```

Collect test results:
```
Test Results:
Total Tests: [X]
Passed: [X] ✓
Failed: [X] ✗
Duration: [X.XX] seconds
```

For each failed test — report: test name, error message, expected vs actual.

**If tests fail:** Fix now OR document as known issues and continue.

---

### Phase B: Anti-Pattern Scan

Load `data/anti-patterns-checklist.md` and scan all implemented files.

**Critical severity (must fix):**
- Missing `@frappe.whitelist()` on exposed functions
- SQL string concatenation (SQL injection risk)
- Missing permission checks in API endpoints
- Raw `frappe.db.sql()` without parameterized args

**High severity (should fix):**
- Business logic in client scripts
- Form values used in arithmetic without parseInt/parseFloat conversion
- Missing `ignore_permissions=True` in scheduled jobs

**Medium/Low severity (document):**
- Custom date/number formatting instead of frappe.utils
- console.log() statements in JavaScript

**Anti-Pattern Report:**
```
Anti-Patterns Found: [X]
├─ Critical: [X] 🔴
├─ High: [X] 🟠
├─ Medium: [X] 🟡
└─ Low: [X] 🟢

[CRITICAL] <type>
File: path/to/file.py  Line: X
Code: [snippet]
Fix: [what to do]
```

---

## Menu

**If NO critical anti-patterns:**
**[A]** Auto-continue to Step 9 (Complete)
**[F]** Fix remaining issues now
**[P]** Pause here (review validation results)

**If CRITICAL anti-patterns found:**
**[F]** Fix critical issues now (RECOMMENDED)
**[D]** Document as known issues and continue (NOT RECOMMENDED)
**[C]** Cancel workflow

---

## Success Criteria

- ✅ All tests executed
- ✅ Test results documented
- ✅ Anti-pattern scan completed
- ✅ No CRITICAL anti-patterns (or all fixed)
- ✅ HIGH-priority issues addressed or documented
- ✅ Code is production-ready

---

## Update State

Update `session.yaml`:
```yaml
workflow_step: 7
current_task: "Validated code quality"
last_action: "Tests: [X passed / Y failed], Anti-patterns: [X found, Y critical]"
next_action: "Generate completion summary"
updated: "[current timestamp]"
```

---

## Next Step

**If [A]uto-continue:**
**→ Load and execute:** `steps-new/step-08-complete.md`

**If [F]ix issues:**
1. Fix reported issues
2. Rebuild and redeploy (back to Step 7 if needed)
3. Re-run validation (current step)
4. Then proceed to Step 9

**If [P]ause:**
STOP here. User can review validation results.

**If [D]ocument issues:**
Record known issues, then proceed to Step 9.

**If [C]ancel:**
EXIT workflow. Update state and preserve progress.
