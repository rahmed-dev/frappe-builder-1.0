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

---

## Continue in Part B

**→ Load and execute:** `steps/step-06b-validate.md`

Part B covers: anti-pattern scan (A–I), report template, menu and state update.
