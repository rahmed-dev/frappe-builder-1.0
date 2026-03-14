# Generate Tests Workflow Instructions

<critical>The workflow execution engine is governed by: {project-root}/.bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: workflow.yaml</critical>
<critical>This is a Frappe-specific workflow - Frappe bench awareness is MANDATORY</critical>

## Frappe Bench Context

**Session Variables:**
- `{{app}}` - Frappe app name
- `{{app_path}}` - Full path: `{frappe_bench_path}/apps/{{app}}`
- `{{docs_path}}` - Documents directory: `{{app_path}}/docs`

<workflow>

<step n="1" goal="Identify feature to test">
<action>Ask which feature/DocType to test; capture brief description (or load from TSD if given).</action>

<template-output>feature_spec</template-output>
</step>

<step n="2" goal="Generate test scenarios using real-world lenses">
<action>Generate scenarios by lens: Happy (valid flow), Lazy (skip optional/minimal entry), Uneducated (wrong formats/types), Mistake-prone (fat fingers), Evil (misuse: SQLi/XSS/perm escalation/tampering/overflow/concurrency/API abuse). For each: ID, description, input, expected, pass/fail.</action>

<template-output>test_scenarios</template-output>
</step>

<step n="3" goal="Create test matrix table">
<action>Build matrix: Test ID | Category | Scenario | Input | Expected Result | Pass/Fail. Cover all lenses.</action>

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
bench --site {{default_site}} run-tests --app {{app}}
```

**Run specific test module:**
```bash
bench --site {{default_site}} run-tests --app {{app}} --module tests.test_{{feature_name}}
```

**Run specific test case:**
```bash
bench --site {{default_site}} run-tests --app {{app}} --module tests.test_{{feature_name}} --test Test{{FeatureName}}.test_happy_path
```

**View test coverage:**
```bash
bench --site {{default_site}} run-tests --app {{app}} --coverage
```

Explain how to interpret test results:
- Dots (...) = tests passed
- F = test failed
- E = error in test
- s = test skipped
</action>

<template-output>execution_instructions</template-output>
</step>

<step n="6" goal="Update project state with test information">
<action>After test generation completion, update the project state:

**Files to Update:**
1. `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/active.yaml`
2. `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/features/{{current_feature}}.yaml` (if feature exists)

**active.yaml - Fields to Update:**
```yaml
current_task: "Tests generated and ready for execution"
workflow: "generate-tests"
workflow_step: 6
last_action: "Generated {{test_count}} test scenarios ({{happy_count}} happy, {{sad_count}} sad, {{edge_count}} edge, {{evil_count}} evil)"
next_action: "Run tests using bench commands or continue implementation"
specialist: "qa-specialist"
updated: "{{timestamp}}"
```

**feature file - Fields to Update** (if {{current_feature}} exists):
```yaml
status: "in-progress"
updated: "{{timestamp}}"
customizations:
  tests_generated: true
  test_count: {{test_count}}
  test_file: "{{test_file_path}}"
notes: "Tests generated: {{test_count}} scenarios created"
```

**How to update:**
1. Read existing active.yaml
2. Update the fields above
3. If {{current_feature}} is set, also update the detailed feature file with test information
4. Write back to both files
</action>

<template-output>state_updated</template-output>
<gate>
HALT: Do not confirm workflow complete until active.yaml is confirmed written.
If the write fails or is skipped, report the failure and stop.
</gate>
</step>

</workflow>
