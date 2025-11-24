# Generate Tests Workflow Instructions

<critical>The workflow execution engine is governed by: {project-root}/.bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: workflow.yaml</critical>
<critical>This is a Frappe-specific workflow - Frappe bench awareness is MANDATORY</critical>

## Frappe Bench Context

**Session Variables:**
- `{{current_app}}` - Frappe app name
- `{{app_path}}` - Full path: `{frappe_bench_path}/apps/{{current_app}}`
- `{{docs_path}}` - Documents directory: `{{app_path}}/docs`

<workflow>

<step n="1" goal="Identify feature to test">
<action>Ask user: Which feature needs test scenarios?

Get:
- Feature name
- DocType involved (if applicable)
- Feature description or specification

Can load from TSD if user provides path.
</action>

<template-output>feature_spec</template-output>
</step>

<step n="2" goal="Generate test scenarios using real-world lenses">
<action>Apply real-world user lenses to generate comprehensive test scenarios:

**HAPPY PATH TESTS (Everything works as designed):**
- All required fields provided with valid data
- Expected workflow completion
- Successful save/submit
- Expected calculations correct
- Expected side effects occur

**LAZY USER TESTS (Minimal effort):**
- Skip optional fields
- Use default values
- Minimal data entry
- Fastest path through workflow
- What breaks when fields left empty?

**UNEDUCATED USER TESTS (Wrong formats/types):**
- Text in number fields ("abc" in quantity)
- Invalid date formats ("01-20-2025" instead of "2025-01-20")
- Wrong data types (string where int expected)
- Invalid email formats
- Wrong select options

**MISTAKE-PRONE TESTS (Fat-finger errors):**
- Decimal point errors (10.5 becomes 105)
- Extra zeros (1000 becomes 10000)
- Transposed numbers (123 becomes 132)
- Copy-paste errors (partial data)
- Negative numbers where positive expected

**EVIL USER TESTS (Deliberate misuse):**
- SQL injection attempts: `'; DROP TABLE users; --`
- XSS attempts: `<script>alert('XSS')</script>`
- Permission escalation: Try to access admin functions
- Data tampering: Modify submitted docs
- Overflow attacks: 10000-character strings
- Concurrent conflicts: Submit same doc twice
- API abuse: Bypass UI validations

For each test scenario, specify:
- Test ID
- Scenario description
- Input data
- Expected result
- Pass/Fail criteria
</action>

<template-output>test_scenarios</template-output>
</step>

<step n="3" goal="Create test matrix table">
<action>Organize test scenarios into structured matrix:

| Test ID | Category | Scenario | Input | Expected Result | Pass/Fail |
|---------|----------|----------|-------|-----------------|-----------|
| T001 | Happy Path | Valid sales order | Customer: CUST-001, Items: valid | Order created | |
| T002 | Lazy User | Missing optional notes | Notes: empty | Order created (notes blank) | |
| T003 | Uneducated | Text in qty field | Qty: "abc" | ValidationError: Qty must be number | |
| T004 | Mistake-Prone | Extra zero in qty | Qty: 10000 (meant 1000) | Warning: Large quantity | |
| T005 | Evil User | SQL injection in customer | Customer: `'; DROP TABLE--` | Escaped, no SQL execution | |

Create comprehensive matrix covering all scenarios.
</action>

<template-output>test_matrix</template-output>
</step>

<step n="4" goal="Generate Frappe unittest code">
<action>Create Python unittest file for Frappe:

**Structure:**
```python
# -*- coding: utf-8 -*-
# Copyright (c) {{date.year}}, {{user_name}}
# License: MIT

import frappe
import unittest

class Test{{FeatureName}}(unittest.TestCase):
    def setUp(self):
        \"\"\"Set up test fixtures\"\"\"
        # Create test data
        self.test_customer = frappe.get_doc({
            "doctype": "Customer",
            "customer_name": "Test Customer",
            "customer_group": "Commercial",
            "territory": "All Territories"
        }).insert()

    def test_happy_path(self):
        \"\"\"Test successful feature operation with valid data\"\"\"
        doc = frappe.get_doc({
            "doctype": "Sales Order",
            "customer": self.test_customer.name,
            "items": [{
                "item_code": "Test Item",
                "qty": 10,
                "rate": 100
            }]
        })
        doc.insert()
        self.assertEqual(doc.docstatus, 0)
        self.assertEqual(doc.total, 1000)

    def test_validation_missing_customer(self):
        \"\"\"Test validation error when required field missing\"\"\"
        doc = frappe.get_doc({
            "doctype": "Sales Order",
            "items": [{
                "item_code": "Test Item",
                "qty": 10
            }]
        })
        self.assertRaises(frappe.ValidationError, doc.insert)

    def test_edge_case_zero_quantity(self):
        \"\"\"Test zero or negative quantity\"\"\"
        doc = frappe.get_doc({
            "doctype": "Sales Order",
            "customer": self.test_customer.name,
            "items": [{
                "item_code": "Test Item",
                "qty": 0,
                "rate": 100
            }]
        })
        self.assertRaises(frappe.ValidationError, doc.insert)

    def tearDown(self):
        \"\"\"Clean up test data\"\"\"
        frappe.db.rollback()
```

Generate complete unittest file covering:
- setUp() with test data creation
- test_happy_path() for valid flow
- test_validation_*() for each validation
- test_edge_case_*() for boundary conditions
- tearDown() with cleanup
</action>

<template-output>unittest_code</template-output>
</step>

<step n="5" goal="Save test matrix to docs">
<action>Save test matrix document:

File: `{{docs_path}}/test-scenarios/test-matrix-{{feature_name}}.md`

Include:
- Feature description
- Test matrix table
- Testing notes
- Manual testing instructions
</action>

<template-output>test_matrix_saved</template-output>
</step>

<step n="6" goal="Save unittest code to app">
<action>Save Python unittest file:

File: `{{app_path}}/tests/test_{{feature_name}}.py`

Create tests/ directory if doesn't exist.

Confirm file saved successfully.
</action>

<template-output>unittest_saved</template-output>
</step>

<step n="7" goal="Provide test execution instructions">
<action>Provide instructions for running tests:

**Run all tests:**
```bash
cd {frappe_bench_path}
bench --site {{default_site}} run-tests --app {{current_app}}
```

**Run specific test module:**
```bash
bench --site {{default_site}} run-tests --app {{current_app}} --module tests.test_{{feature_name}}
```

**Run specific test case:**
```bash
bench --site {{default_site}} run-tests --app {{current_app}} --module tests.test_{{feature_name}} --test Test{{FeatureName}}.test_happy_path
```

**View test coverage:**
```bash
bench --site {{default_site}} run-tests --app {{current_app}} --coverage
```

Explain how to interpret test results:
- Dots (...) = tests passed
- F = test failed
- E = error in test
- s = test skipped
</action>

<template-output>execution_instructions</template-output>
</step>

</workflow>
