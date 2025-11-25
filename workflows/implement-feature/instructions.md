# Implement Feature Workflow Instructions

<critical>The workflow execution engine is governed by: {project-root}/.bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: workflow.yaml</critical>
<critical>This is a Frappe-specific workflow - Frappe bench awareness is MANDATORY</critical>

## Frappe Bench Context

**CRITICAL**: This workflow operates in Frappe bench environment.

## MAKER Integration: Load Active Project State

**BEFORE loading any specification, load project state:**

```
Read: .bmad/custom/modules/frappe-builder/state/active.yaml

Extract:
- project: Project name
- app: Current Frappe app
- plan: Implementation plan path
- tsd: TSD path
- phase: Current phase
- tasks: Task range (if assigned)
- summary: BRD summary (quick context)
- notes: Critical context notes
```

**Benefits:**
- Lighter context (<200 tokens vs loading full memories)
- Always current state
- Quick project summary from BRD
- Task range awareness

**Session Variables:**
- `{{current_app}}` - Frappe app name (from active.yaml)
- `{{app_path}}` - Full path: `{frappe_bench_path}/apps/{{current_app}}`
- `{{docs_path}}` - Documents directory: `{{app_path}}/docs`

**Code Output Path:**
- All code: `{{app_path}}/{{current_app}}/`

<workflow>

<step n="1" goal="Load specification document">
<action>Ask user which specification to implement from:
- Technical Specification Document (TSD)?
- Implementation Plan phase?
- Specific feature description?

Search for document using fuzzy file matching.

If TSD or Implementation Plan:
- Try whole document first: `{{docs_path}}/tsd/*.md` or `{{docs_path}}/implementation-plans/*.md`
- Check sharded version if whole not found
- Read complete specification

If specific feature description:
- Get detailed description from user

Understand WHAT needs to be built before coding.
</action>

<template-output>specification</template-output>
</step>

<step n="2" goal="Identify components to build">
<action>Based on the specification, identify all components needed:

**Custom DocTypes:**
- List DocTypes to create
- Note fields, child tables, relationships

**Server Scripts:**
- List scripts needed (validation, calculation, trigger)
- Note which DocType/event

**Client Scripts:**
- List UI behaviors needed
- Note which DocType/event

**Reports:**
- List Script Reports or Query Reports
- Note columns, filters

**API Endpoints:**
- List @frappe.whitelist() functions
- Note parameters, return format

**Print Formats:**
- List custom print templates

**Workflows:**
- List workflow configurations

Create implementation checklist.
</action>

<template-output>implementation_checklist</template-output>
</step>

<step n="3" goal="Scaffold boilerplate for each component">
<action>For EACH component type, generate appropriate boilerplate:

**For Custom DocTypes:**
Generate JSON definition:
```json
{
 "doctype": "DocType",
 "name": "{{DocTypeName}}",
 "module": "{{module_name}}",
 "fields": [
  {
   "fieldname": "field1",
   "label": "Field 1",
   "fieldtype": "Data",
   "reqd": 1
  }
 ],
 "permissions": [],
 "sort_field": "modified",
 "sort_order": "DESC"
}
```

**For Server Scripts:**
```python
import frappe
from frappe import _

@frappe.whitelist()
def function_name(param1, param2):
    \"\"\"
    Function description

    Args:
        param1: Description
        param2: Description

    Returns:
        dict: Result
    \"\"\"
    # Permission check
    if not frappe.has_permission("DocType", "read"):
        frappe.throw(_("Insufficient permissions"), frappe.PermissionError)

    # Business logic here

    return {"status": "success"}
```

**For Client Scripts:**
```javascript
frappe.ui.form.on('DocType', {
    refresh: function(frm) {
        // Form refresh logic
    },

    field_name: function(frm) {
        // Field change logic
    }
});
```

**For Script Reports:**
```python
import frappe

def execute(filters=None):
    columns = get_columns()
    data = get_data(filters)
    return columns, data

def get_columns():
    return [
        {"label": "Column 1", "fieldname": "col1", "fieldtype": "Data", "width": 150}
    ]

def get_data(filters):
    # Query logic here
    return []
```

Generate all boilerplate scaffolds.
</action>

<template-output>scaffolds_generated</template-output>
</step>

<step n="4" goal="Implement business logic - server-side first">
<action>Implement business logic following Frappe framework patterns:

**Server-Side Patterns:**
1. **Validation Logic** (in DocType controller):
```python
def validate(self):
    self.validate_dates()
    self.calculate_totals()
```

2. **Hooks** (before_save, on_submit, etc.):
```python
def before_save(self):
    # Logic before document saved
    pass

def on_submit(self):
    # Logic when document submitted
    pass
```

3. **Custom Methods**:
```python
def custom_method(self):
    # Business logic
    pass
```

**CRITICAL Frappe Patterns:**
✅ Use frappe.utils for date/number operations
✅ Use parameterized queries (frappe.db.get_all with filters dict)
✅ Add permission checks (frappe.has_permission)
✅ Use frappe.throw() for validation errors
✅ Use frappe.msgprint() for user notifications

❌ AVOID:
- String concatenation in SQL queries (SQL injection risk)
- Direct frappe.db.sql without parameters
- Business logic in client scripts
- Custom date/number formatting (use frappe.utils)

Implement all server-side logic.
</action>

<template-output>server_logic_implemented</template-output>
</step>

<step n="5" goal="Implement client scripts - minimal UI behavior only">
<action>Implement client-side logic (MINIMAL - UI behavior only):

**Client Script Use Cases:**
- Field dependencies (show/hide based on other fields)
- Auto-fill calculations (sum child table, etc.)
- Custom buttons (trigger server-side methods)
- Form refresh behavior
- Validation messages (pre-save warnings)

**Pattern:**
```javascript
frappe.ui.form.on('DocType', {
    field_name: function(frm) {
        // IMPORTANT: Convert string to number if needed
        let qty = parseInt(frm.doc.qty) || 0;
        let rate = parseFloat(frm.doc.rate) || 0;
        frm.set_value('total', qty * rate);
    },

    custom_button: function(frm) {
        // Call server-side method
        frappe.call({
            method: 'app.module.api.server_function',
            args: {
                doc_name: frm.doc.name
            },
            callback: function(r) {
                if (r.message) {
                    frappe.msgprint('Success');
                }
            }
        });
    }
});
```

**CRITICAL:**
✅ Always convert form field values (they're strings): int(), float()
✅ Use frappe.call() to invoke server methods
✅ Use frm.set_value() to update fields
✅ Handle null/undefined values

❌ AVOID:
- Business logic in client scripts
- Direct DB queries from client
- Complex calculations (do server-side)

Implement all client-side behavior.
</action>

<template-output>client_logic_implemented</template-output>
</step>

<step n="6" goal="Write all code to files">
<action>Save all implemented code to correct locations:

**DocType JSON:**
`{{app_path}}/{{current_app}}/{{module}}/doctype/{{doctype_name}}/{{doctype_name}}.json`

**DocType Controller (Python):**
`{{app_path}}/{{current_app}}/{{module}}/doctype/{{doctype_name}}/{{doctype_name}}.py`

**Client Scripts:**
`{{app_path}}/{{current_app}}/public/js/{{doctype_name}}.js`

**Server Scripts (API):**
`{{app_path}}/{{current_app}}/{{module}}/api.py`

**Reports:**
`{{app_path}}/{{current_app}}/{{module}}/report/{{report_name}}/{{report_name}}.py`

Confirm all files written successfully.
</action>

<template-output>files_written</template-output>
</step>

<step n="7" goal="Run bench build">
<action>Build the Frappe app to compile JavaScript and CSS:

Execute command:
```bash
cd {frappe_bench_path}
bench build --app {{current_app}}
```

Parse output:
- Look for "Built {{current_app}}"
- Check for JavaScript errors
- Check for CSS errors

If build fails:
- Report error details
- Suggest fixes
- Offer to retry after fixes

If build succeeds:
- Proceed to next step
</action>

<template-output>build_result</template-output>
</step>

<step n="8" goal="Run bench migrate">
<action>Run database migrations to create/update DocTypes:

Execute command:
```bash
cd {frappe_bench_path}
bench --site {{default_site}} migrate
```

Parse output:
- Look for "Migrating {{current_app}}"
- Check for table creation/alteration
- Check for errors

Common migration errors:
- Duplicate column: Field already exists
- Invalid JSON: DocType JSON syntax error
- Missing dependency: Linked DocType doesn't exist

If migration fails:
- Report error details
- Suggest fixes
- Offer to retry after fixes

If migration succeeds:
- Proceed to next step
</action>

<template-output>migration_result</template-output>
</step>

<step n="9" goal="Clear cache and restart">
<action>Clear Frappe cache and restart bench:

Execute commands:
```bash
cd {frappe_bench_path}
bench --site {{default_site}} clear-cache
bench restart
```

This ensures:
- New code is loaded
- JavaScript/CSS changes take effect
- DocType metadata refreshed
</action>

<template-output>cache_cleared</template-output>
</step>

<step n="10" goal="Run tests">
<action>Execute Frappe unit tests for the app:

Execute command:
```bash
cd {frappe_bench_path}
bench --site {{default_site}} run-tests --app {{current_app}}
```

Parse test results:
- Total tests run
- Passed count
- Failed count (with error details)
- Skipped count

If tests fail:
- Report which tests failed
- Show error tracebacks
- Suggest fixes
- Offer to re-run after fixes

If tests pass:
- Report success
- Proceed to validation
</action>

<template-output>test_results</template-output>
</step>

<step n="11" goal="Validate for anti-patterns">
<action>Scan implemented code for Frappe anti-patterns:

Check for:
❌ Missing @frappe.whitelist() on API endpoints
❌ Client-side filtering (should use frappe.get_all with filters)
❌ Custom HTML/CSS (should use frappe.ui components)
❌ SQL injection risks (string concatenation in queries)
❌ Missing permission checks
❌ Not using frappe.utils (custom date/number handling)
❌ console.log() statements in production code
❌ Not converting form field values (string → int/float)
❌ Missing ignore_permissions=True in scheduled jobs
❌ Direct frappe.db.sql without parameterization

For each anti-pattern found:
- Report location (file:line)
- Explain why it's problematic
- Suggest Frappe-native fix

If anti-patterns found:
- Offer to fix them now
- Or document for later review
</action>

<template-output>anti_pattern_scan</template-output>
</step>

<step n="12" goal="Report completion and next steps">
<action>Provide comprehensive implementation summary:

**Implemented Components:**
- Custom DocTypes: [List]
- Server Scripts: [List]
- Client Scripts: [List]
- Reports: [List]
- API Endpoints: [List]

**Build & Migration:**
- Build status: [Success/Failed]
- Migration status: [Success/Failed]

**Test Results:**
- Tests run: [X]
- Passed: [X]
- Failed: [X]
- Skipped: [X]

**Anti-Patterns:**
- Found: [X]
- Critical: [X]
- Warnings: [X]

**Code Location:**
- Files created in: `{{app_path}}/{{current_app}}/`

**Next Steps:**
1. Test manually in ERPNext UI
2. Generate test scenarios using `generate-tests` workflow
3. Create user documentation using `create-guide` workflow
4. If issues found, use `diagnose-issue` workflow

**Access the feature:**
- Navigate to: [DocType/Page name]
- Or use Quick Search (Ctrl+K): Type "{{DocTypeName}}"
</action>

<template-output>completion_summary</template-output>
</step>

</workflow>
