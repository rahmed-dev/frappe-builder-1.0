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
<action>Ask spec source (TSD, plan phase, or feature description). Load full doc (`tsd/*.md` or `implementation-plans/*.md`, sharded if needed). If ad-hoc, capture details. Ensure clear build scope.</action>

<template-output>specification</template-output>
</step>

<step n="2" goal="Identify components to build">
<action>Identify components: DocTypes (fields/children/links), server scripts (doctype/event, purpose), client scripts (UI behavior), reports (columns/filters), APIs (@frappe.whitelist params/returns), print formats, workflows. Build checklist.</action>

<template-output>implementation_checklist</template-output>
</step>

<step n="3" goal="Scaffold boilerplate for each component">
<action>For each component, scaffold minimal boilerplate using Frappe conventions: DocTypes (JSON with fields/permissions/order), server scripts (doctype/event, pseudocode, whitelisted if API), client scripts (doctype .js with needed hooks), reports (script/query folders), APIs (add whitelisted functions), workflows (states/transitions/roles), print formats (Jinja skeleton).</action>
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

**Server-Side Patterns (logic/pseudocode):** validations in controller, hooks (before_save/on_submit), custom methods. Critical: use frappe.utils, parameterized queries, permission checks, frappe.throw/msgprint. Avoid SQL concat/direct db.sql, client-side business logic, custom formatting. Implement server-side logic first.
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
✅ Convert form values (int/float), use frappe.call and frm.set_value, handle null/undefined. Avoid business logic/client DB/complex calcs (do server-side). Implement minimal client behavior.
</action>

<template-output>client_logic_implemented</template-output>
</step>

<step n="6" goal="Write all code to files">
<action>Write code/files to correct paths (DocType JSON/controller, client scripts, server/API, reports). Confirm writes succeed.</action>

<template-output>files_written</template-output>
</step>

<step n="7" goal="Run bench build">
<action>Run `bench build --app {{current_app}}`; check for JS/CSS errors; report and fix if fails.</action>

<template-output>build_result</template-output>
</step>

<step n="8" goal="Run bench migrate">
<action>Run `bench --site {{default_site}} migrate`; watch for errors (duplicate column, invalid JSON, missing dependency). Report/fix if fails; continue if succeeds.</action>

<template-output>migration_result</template-output>
</step>

<step n="9" goal="Clear cache and restart">
<action>Run `bench --site {{default_site}} clear-cache` and `bench restart` to refresh code/assets/metadata.</action>

<template-output>cache_cleared</template-output>
</step>

<step n="10" goal="Run tests">
<action>Run `bench --site {{default_site}} run-tests --app {{current_app}}`; report pass/fail details and rerun after fixes if needed.</action>

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
