# Test Matrix
**Feature:** {{feature_name}}
**DocType:** {{doctype}}
**App:** {{app}}
**Date:** {{date}}
**QA Lead:** {{user_name}}

## Test Coverage Summary
| Category | Test Count | Status |
|----------|-----------|--------|
| Happy Path | [X] | ✓ / ✗ / ⏸ |
| Edge Cases | [X] | ✓ / ✗ / ⏸ |
| Error Handling | [X] | ✓ / ✗ / ⏸ |
| Security | [X] | ✓ / ✗ / ⏸ |
| Performance | [X] | ✓ / ✗ / ⏸ |
| **TOTAL** | **[X]** | **[%] Pass** |

---

## Test Scenarios

### Happy Path Tests

| ID | Scenario | Input | Expected Output | Result | Notes |
|----|----------|-------|-----------------|--------|-------|
| HP-001 | [Normal use case] | [Valid data] | [Success result] | ✓ / ✗ | [Any notes] |
| HP-002 | [Another normal case] | [Valid data] | [Success result] | ✓ / ✗ | |

### Edge Case Tests

#### Lazy User (Skips Optional Fields)
| ID | Scenario | Input | Expected Output | Result | Notes |
|----|----------|-------|-----------------|--------|-------|
| LC-001 | Submit with minimal required fields only | Required only | Should save/submit | ✓ / ✗ | |
| LC-002 | Skip optional customer notes | No notes | Should save without error | ✓ / ✗ | |

#### Uneducated User (Wrong Data Types/Formats)
| ID | Scenario | Input | Expected Output | Result | Notes |
|----|----------|-------|-----------------|--------|-------|
| UC-001 | Enter text in number field | "abc" in qty | Error: "Qty must be number" | ✓ / ✗ | |
| UC-002 | Invalid date format | "13/25/2025" | Error: "Invalid date" | ✓ / ✗ | |
| UC-003 | Negative quantity | qty = -10 | Error: "Qty must be positive" | ✓ / ✗ | |

#### Mistake-Prone User (Fat-Finger, Typos)
| ID | Scenario | Input | Expected Output | Result | Notes |
|----|----------|-------|-----------------|--------|-------|
| MP-001 | Extra zero in amount | 10000 instead of 1000 | Confirmation: "Large amount" | ✓ / ✗ | |
| MP-002 | Duplicate submission | Click Save twice | No duplicate created | ✓ / ✗ | |
| MP-003 | Wrong customer selected | Pick similar name | Confirmation dialog | ✓ / ✗ | |

#### Business Edge Cases
| ID | Scenario | Input | Expected Output | Result | Notes |
|----|----------|-------|-----------------|--------|-------|
| BE-001 | Backdate to previous fiscal year | Old date | Error or confirmation | ✓ / ✗ | |
| BE-002 | Amount exceeds credit limit | Huge total | Credit limit warning | ✓ / ✗ | |
| BE-003 | Item out of stock | Zero stock item | Stock warning | ✓ / ✗ | |
| BE-004 | Customer on credit hold | Blocked customer | Error: "Customer blocked" | ✓ / ✗ | |

### Error Handling Tests

| ID | Scenario | Input | Expected Output | Result | Notes |
|----|----------|-------|-----------------|--------|-------|
| ER-001 | Missing required field | Blank required field | Error: "Field X required" | ✓ / ✗ | |
| ER-002 | Invalid foreign key | Non-existent customer | Error: "Customer not found" | ✓ / ✗ | |
| ER-003 | Duplicate unique field | Existing ID | Error: "ID already exists" | ✓ / ✗ | |
| ER-004 | Database connection lost | [Simulate DB down] | Graceful error message | ✓ / ✗ | |

### Security Tests

| ID | Scenario | Input | Expected Output | Result | Notes |
|----|----------|-------|-----------------|--------|-------|
| SE-001 | Access without permission | User w/o read role | Error: "No permission" | ✓ / ✗ | |
| SE-002 | Modify read-only field | Try to change locked field | Error or ignored | ✓ / ✗ | |
| SE-003 | SQL injection attempt | `'; DROP TABLE--` | Sanitized, no SQL exec | ✓ / ✗ | |
| SE-004 | XSS attempt | `<script>alert()</script>` | Escaped HTML | ✓ / ✗ | |
| SE-005 | Access other user's document | Doc without permission | Error: "No permission" | ✓ / ✗ | |

### Performance Tests

| ID | Scenario | Volume | Expected Time | Actual Time | Result |
|----|----------|--------|---------------|-------------|--------|
| PE-001 | Load form | Single doc | < 2 seconds | | ✓ / ✗ |
| PE-002 | List view with 1000 records | 1000 records | < 3 seconds | | ✓ / ✗ |
| PE-003 | Bulk operation | 500 records | < 30 seconds | | ✓ / ✗ |
| PE-004 | Report generation | Full data | < 10 seconds | | ✓ / ✗ |

### Workflow Tests (If Applicable)

| ID | Scenario | Input | Expected State | Result | Notes |
|----|----------|-------|----------------|--------|-------|
| WF-001 | Submit document | Valid data | State: Pending | ✓ / ✗ | |
| WF-002 | Approve as manager | Pending doc | State: Approved | ✓ / ✗ | |
| WF-003 | Reject as manager | Pending doc | State: Rejected | ✓ / ✗ | |
| WF-004 | Submit without permission | Wrong role | Error: "No permission" | ✓ / ✗ | |

---

## Automated Test Code

### Unittest Template
```python
# File: apps/{{app}}/{{app}}/doctype/{{doctype}}/test_{{doctype}}.py

import frappe
import unittest

class Test{{DocType}}(unittest.TestCase):

    def setUp(self):
        """Setup test data"""
        # Create test records
        pass

    def tearDown(self):
        """Cleanup test data"""
        frappe.db.rollback()

    def test_happy_path_create_document(self):
        """HP-001: Create document with valid data"""
        doc = frappe.get_doc({
            "doctype": "{{DocType}}",
            "field1": "value1",
            "field2": 100
        })
        doc.insert()
        self.assertTrue(frappe.db.exists("{{DocType}}", doc.name))

    def test_edge_case_lazy_user(self):
        """LC-001: Minimal required fields only"""
        doc = frappe.get_doc({
            "doctype": "{{DocType}}",
            "field1": "value1"  # Only required field
            # Optional fields omitted
        })
        doc.insert()
        self.assertTrue(doc.name)  # Should save successfully

    def test_edge_case_uneducated_user_invalid_type(self):
        """UC-001: Invalid data type in number field"""
        doc = frappe.get_doc({
            "doctype": "{{DocType}}",
            "qty": "abc"  # String in number field
        })
        with self.assertRaises(frappe.ValidationError):
            doc.insert()

    def test_error_handling_missing_required(self):
        """ER-001: Missing required field"""
        doc = frappe.get_doc({
            "doctype": "{{DocType}}"
            # Missing required field1
        })
        with self.assertRaises(frappe.MandatoryError):
            doc.insert()

    def test_security_no_permission(self):
        """SE-001: Access without permission"""
        frappe.set_user("test@example.com")  # User without permission

        with self.assertRaises(frappe.PermissionError):
            doc = frappe.get_doc("{{DocType}}", "TEST-001")

        frappe.set_user("Administrator")  # Reset

    def test_performance_bulk_operation(self):
        """PE-003: Bulk insert performance"""
        import time
        start = time.time()

        for i in range(100):
            doc = frappe.get_doc({
                "doctype": "{{DocType}}",
                "field1": f"value{i}"
            })
            doc.insert()

        duration = time.time() - start
        self.assertLess(duration, 10)  # Should complete in < 10 seconds
```

### Run Tests
```bash
# Run all tests for this DocType
bench --site {{site}} run-tests --doctype "{{DocType}}"

# Run specific test
bench --site {{site}} run-tests --test "apps.{{app}}.{{app}}.doctype.{{doctype}}.test_{{doctype}}.Test{{DocType}}.test_happy_path_create_document"

# Run with coverage
bench --site {{site}} run-tests --doctype "{{DocType}}" --coverage
```

---

## Manual Test Checklist

### Pre-Testing Setup
- [ ] Test data created
- [ ] Test users with different roles created
- [ ] Bench logs cleared for clean testing

### During Testing
- [ ] Record actual vs expected for each test
- [ ] Screenshot failures
- [ ] Note any unexpected behavior
- [ ] Check bench logs for errors

### Post-Testing
- [ ] All critical tests passed
- [ ] Known issues documented
- [ ] Test data cleaned up
- [ ] Test report shared with team

---

## Test Results Summary

**Date Tested:** {{test_date}}
**Tester:** {{tester_name}}
**Environment:** Development / Staging / Production

### Results
- **Total Tests:** [X]
- **Passed:** [X] ([Y]%)
- **Failed:** [X] ([Y]%)
- **Skipped:** [X] ([Y]%)

### Critical Failures
1. [Test ID] - [Failure description]
2. [Test ID] - [Failure description]

### Known Issues
1. [Issue description] - [Severity] - [Workaround if any]

### Sign-Off
- [ ] All critical tests passed
- [ ] Known issues acceptable
- [ ] Ready for next stage (Staging/Production)

**Approved By:** [Name] - [Date]
