# QA-Specialist Session Memories

## Current Session Context

**User:** {user_name}
**Current App:** {{current_app}}
**App Path:** {{app_path}}
**Tests Path:** {{tests_path}}

---

## Current Testing Work

**Feature Being Tested:** [Feature name]
**Requested By:** [Frappe-Dev / User]
**Test Type:** [Manual Scenarios / Unittest Code / Both]
**Status:** [Generating / Review / Complete]

---

## Test Scenarios Generated

### Manual Test Scenarios
1. **[Feature Name] Test Scenarios** - {{tests_path}}/test-scenarios-[feature].md
   - Happy Path Tests: [X]
   - Sad Path Tests: [Y]
   - Edge Case Tests: [Z]
   - Evil User Tests: [W]
   - Total Tests: [N]
   - Created: [Date]
   - Status: ✅ Complete

2. **[Feature Name] Test Scenarios**
   - [...]

### Unittest Code Generated
1. **test_[doctype].py** - {{app_path}}/[module]/doctype/[doctype]/test_[doctype].py
   - Test Methods: [X]
   - Coverage: [Happy Path, Validations, Edge Cases]
   - Created: [Date]
   - Status: ✅ Complete

---

## Test Coverage Summary

**Total Features Tested:** [X]
**Total Manual Test Scenarios:** [Y]
**Total Unittest Methods:** [Z]

**Test Type Breakdown:**
- Happy Path Tests: [X]
- Sad Path Tests (Validations): [Y]
- Edge Case Tests: [Z]
- Evil User Tests (Security): [W]

---

## Features Tested

### DocTypes Tested
- **[DocType 1]**: [Test count] tests - [Manual/Unittest/Both]
- **[DocType 2]**: [Test count] tests - [Manual/Unittest/Both]

### Workflows Tested
- **[Workflow 1]**: [Test count] tests - [Approval process coverage]
- **[Workflow 2]**: [Test count] tests - [Approval process coverage]

### Reports Tested
- **[Report 1]**: [Test count] tests - [Data accuracy, filters, performance]
- **[Report 2]**: [Test count] tests - [Data accuracy, filters, performance]

---

## User Lens Application

### Lazy User Tests Generated
**Total:** [X tests]

**Common Scenarios:**
- Skip optional fields
- Use defaults without customization
- Submit without review

**Examples:**
- [Feature]: Test skipping [field] (optional)
- [Feature]: Test using default [value]

### Uneducated User Tests Generated
**Total:** [Y tests]

**Common Scenarios:**
- Wrong data formats (text in number field)
- Invalid date formats (MM-DD-YYYY)
- Wrong dropdown selections

**Examples:**
- [Feature]: Enter "ten" in quantity field
- [Feature]: Enter "01-20-2025" instead of "2025-01-20"

### Mistake-Prone User Tests Generated
**Total:** [Z tests]

**Common Scenarios:**
- Fat-finger errors (10000 instead of 1000)
- Accidental double-clicks
- Typos in critical fields

**Examples:**
- [Feature]: Enter 1000000 (extreme value)
- [Feature]: Click Submit twice (double-click)

### Evil User Tests Generated
**Total:** [W tests]

**Common Scenarios:**
- SQL injection attempts
- Permission escalation
- API bypass
- XSS attacks

**Examples:**
- [Feature]: Enter ' OR '1'='1 in search
- [Feature]: Call API without permission
- [Feature]: Enter <script> in text field

---

## Validation Test Matrices Created

### DocType Validation Matrices
1. **[DocType 1] Validation Matrix** - {{tests_path}}/test-matrix-[doctype1].md
   - Fields Tested: [X]
   - Business Rules: [Y]
   - Edge Cases: [Z]
   - Created: [Date]

2. **[DocType 2] Validation Matrix**
   - [...]

---

## Edge Cases Identified

### Boundary Conditions
- **[Feature]**: Min value = [X], Max value = [Y]
- **[Feature]**: Empty string, null, zero handling

### Date Boundaries
- **[Feature]**: Past dates, future dates, fiscal year boundaries
- **[Feature]**: Today, yesterday, end of month

### Large Datasets
- **[Feature]**: 1 item vs 1000 items performance
- **[Feature]**: Concurrent access scenarios

### Data Integrity
- **[Feature]**: Linked document deleted
- **[Feature]**: Orphaned records
- **[Feature]**: Circular dependencies

---

## Unittest Execution Results

### Test Runs
1. **[Date]** - test_[doctype].py
   - Total Tests: [X]
   - Passed: [Y]
   - Failed: [Z]
   - Errors: [W]
   - Command: `bench --site [site] run-tests --doctype "[DocType]"`
   - Notes: [Any issues found]

---

## Test Failures Tracked

### Failed Tests
1. **test_[method_name]** - [DocType]
   - Failure Date: [Date]
   - Reason: [Expected X, got Y]
   - Root Cause: [Bug in code / Test issue]
   - Status: [Reported to Frappe-Dev / Fixed]

---

## Security Tests

### SQL Injection Tests
- **[Feature 1]**: ✅ Blocked (parameterized queries)
- **[Feature 2]**: ⚠️ Vulnerable - [Details]

### XSS Tests
- **[Feature 1]**: ✅ Escaped (HTML encoding)
- **[Feature 2]**: ⚠️ Vulnerable - [Details]

### Permission Tests
- **[Feature 1]**: ✅ Permission checks present
- **[Feature 2]**: ⚠️ Missing permission check - [Details]

---

## Test Patterns & Reusable Code

### Common Test Data Helpers
```python
# Reusable helper functions across tests
create_test_customer()
create_test_item()
create_test_sales_order()
```

### Common Test Patterns
1. **Required Field Validation**
   ```python
   doc = frappe.get_doc({"doctype": "X", ...})  # Missing required field
   self.assertRaises(frappe.ValidationError, doc.insert)
   ```

2. **Auto-Calculation Test**
   ```python
   doc = frappe.get_doc({"doctype": "X", "qty": 10, "rate": 50})
   doc.insert()
   self.assertEqual(doc.total, 500)
   ```

---

## Handoff Status

### Received from Frappe-Dev
- **Date:** [Date]
- **Feature:** [Feature name]
- **Code Location:** {{app_path}}/[module]/
- **Request:** Generate test scenarios

### Delivered Test Package
- **Date:** [Date]
- **Manual Tests:** {{tests_path}}/test-scenarios-[feature].md
- **Unittest Code:** {{app_path}}/[module]/doctype/[doctype]/test_[doctype].py
- **Test Count:** [N] scenarios
- **Coverage:** Happy Path, Sad Paths, Edge Cases, Evil User

---

## Session Notes

### Complex Testing Challenges
[Features that were particularly challenging to test and how they were handled]

**Example:**
- **Multi-step workflow**: Created state transition matrix, tested all paths
- **Complex report with 20 filters**: Created filter combination test matrix
- **Real-time sync feature**: Created concurrent access test scenarios

### Testing Insights
[Patterns discovered during test generation]

**Example:**
- Most validation errors come from "uneducated user" scenarios
- Evil user tests found 2 SQL injection vulnerabilities
- Edge case tests revealed date handling bugs

---

## Test Automation Progress

### Automated Tests
**Total DocTypes:** [X]
**DocTypes with Unittest:** [Y]
**Automation Coverage:** [Z%]

**Remaining Manual-Only:**
- [Feature 1]: [Reason - e.g., UI-heavy, requires visual verification]
- [Feature 2]: [Reason]

---

## Quality Metrics

### Test Scenario Quality
- **Average tests per feature:** [X]
- **User lens coverage:** [% features with all 4 lenses]
- **Edge case coverage:** [% features with edge case tests]
- **Security test coverage:** [% features with evil user tests]

### Unittest Quality
- **Test methods per DocType:** [Avg X]
- **setUp/tearDown present:** [Y%]
- **Helper functions created:** [Z]

---

## Session Variables

```
{{current_app}} = [app name]
{{app_path}} = {project-root}/apps/{{current_app}}
{{tests_path}} = {{app_path}}/tests
```

---

**Last Updated:** [Date]

**Notes:** Track test scenarios generated, unittest code created, failures, security vulnerabilities, and test coverage.
