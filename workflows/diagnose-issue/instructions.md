# Diagnose Issue Workflow Instructions

<critical>The workflow execution engine is governed by: {project-root}/.bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: workflow.yaml</critical>
<critical>This is a Frappe-specific workflow - Frappe bench awareness is MANDATORY</critical>

## Frappe Bench Context

**Session Variables:**
- `{{current_app}}` - Frappe app name
- `{{app_path}}` - Full path: `{frappe_bench_path}/apps/{{current_app}}`
- `{{docs_path}}` - Documents directory: `{{app_path}}/docs`

**Bench Logs Location:**
- Error log: `{frappe_bench_path}/sites/{{default_site}}/logs/error.log`
- Web log: `{frappe_bench_path}/sites/{{default_site}}/logs/web.log`
- Scheduler log: `{frappe_bench_path}/sites/{{default_site}}/logs/scheduler.log`

<workflow>

<step n="1" goal="Understand the problem">
<action>Ask user: What's the issue?

Options:
1. Error in logs (which log?)
2. Python traceback (paste it)
3. Unexpected behavior (no error message)
4. Performance issue (slow operation)

Get detailed description and context.
</action>

<template-output>problem_description</template-output>
</step>

<step n="2" goal="Gather error evidence">
<action if="Error in logs">Read bench logs:

- Error log (last 100 lines): `tail -100 {frappe_bench_path}/sites/{{default_site}}/logs/error.log`
- Web log (last 100 lines): `tail -100 {frappe_bench_path}/sites/{{default_site}}/logs/web.log`
- Scheduler log (last 50 lines): `tail -50 {frappe_bench_path}/sites/{{default_site}}/logs/scheduler.log`

Parse for:
- Timestamps
- Error types (ValidationError, PermissionError, etc.)
- Tracebacks
- Related errors
</action>

<action if="Python traceback provided">Analyze the traceback:

- Identify error type
- Trace error location (file:line)
- Understand call stack
- Identify triggering action
</action>

<action if="Unexpected behavior">Gather context:

- What did user expect?
- What actually happened?
- Steps to reproduce?
- Which DocType/feature?
- Any error messages (even if subtle)?
</action>

<template-output>error_evidence</template-output>
</step>

<step n="3" goal="Correlate logs if multiple errors">
<action if="Multiple log files read">Cross-reference logs:

Look for:
- Same timestamp errors in different logs
- Error chains (error A triggered error B)
- Patterns (same error recurring)

Correlation example:
```
error.log [10:30:15] - ValidationError in Sales Order
web.log [10:30:15] - POST /api/method/frappe.desk.form.save 500
scheduler.log [10:30:00] - Scheduled job "daily_sales_summary" started

→ The validation error occurred during scheduled job execution
```
</action>

<template-output>log_correlation</template-output>
</step>

<step n="4" goal="Identify root cause">
<action>Determine WHY the error occurred:

Ask:
- What was the code trying to do?
- What condition triggered the failure?
- What data caused the problem?
- What's the underlying issue (not just symptom)?

Common Frappe error patterns:
- **ValidationError**: Business rule violated (missing required field, invalid value)
- **PermissionError**: User lacks permission (role check failed)
- **AttributeError**: Accessing non-existent attribute (typo, wrong DocType field)
- **TypeError**: Wrong data type (string passed where int expected)
- **DoesNotExistError**: Document not found (invalid name/ID)

Root cause analysis:
- Symptom: "Sales Order won't save"
- Surface cause: "ValidationError: Customer is mandatory"
- Root cause: "Client script isn't setting customer field correctly (returns string 'undefined' instead of null)"
</action>

<template-output>root_cause</template-output>
</step>

<step n="5" goal="Check for anti-patterns">
<action>Scan for Frappe anti-patterns that may have caused or contributed to the issue:

Check for:
- ❌ Missing @frappe.whitelist() decorator (causes "Not Permitted" errors)
- ❌ Client-side filtering instead of server-side (performance issues)
- ❌ Custom HTML/CSS instead of frappe.ui (upgrade issues)
- ❌ SQL injection risk - string concatenation in queries (security risk)
- ❌ Missing permission checks in API methods
- ❌ Not using frappe.utils for dates/numbers (parsing errors)
- ❌ console.log() in production (doesn't help debugging)
- ❌ Not converting form field values to int/float (type errors)
- ❌ Missing ignore_permissions=True in schedulers (permission errors in background)
- ❌ Directly modifying standard DocType controllers (upgrade breaks)

If anti-patterns found, note them as contributing factors.
</action>

<template-output>anti_patterns_found</template-output>
</step>

<step n="6" goal="Provide the fix">
<action>Create concrete fix with code:

**Fix Format:**
1. What to change (file:line)
2. Current code (wrong)
3. Fixed code (correct)
4. Explanation (why this fixes it)

Example:
```
Fix: Convert form field value to integer

File: custom_app/custom_app/public/js/sales_order.js:45

Current (wrong):
frm.set_value('total', frm.doc.qty * frm.doc.rate);

Fixed (correct):
let qty = parseInt(frm.doc.qty) || 0;
let rate = parseFloat(frm.doc.rate) || 0;
frm.set_value('total', qty * rate);

Why: Form field values are strings. Multiplying strings gives NaN.
Always convert to numbers with parseInt()/parseFloat() and handle null/undefined with || 0.
```

Provide step-by-step fix instructions.
</action>

<template-output>fix_instructions</template-output>
</step>

<step n="7" goal="Prevention guidance">
<action>Explain how to prevent this error in the future:

**Prevention strategies:**
- Frappe best practices to follow
- Anti-patterns to avoid
- Testing approaches
- Code review checklist items

Link to relevant standards/knowledge base if applicable:
- `{project-root}/.bmad/frappe-builder/standards/development/code-quality.md`
- `{project-root}/.bmad/frappe-builder/knowledge-base/debugging/common-errors.md`

Example:
```
Prevention:
1. Always convert form field values before calculations
2. Use frappe.utils.flt() and frappe.utils.cint() for safe conversion
3. Add client-side validation to catch issues before save
4. Write unittest that tests with string inputs
```
</action>

<template-output>prevention_guidance</template-output>
</step>

<step n="8" goal="Structure into Diagnostic Report">
<action>Organize into template:

Write in {document_output_language}.

Include:
- Error summary
- Root cause analysis
- Anti-patterns detected
- Fix with code
- Prevention guidance
- Related issues (if any)
</action>

<template-output>diagnostic_report</template-output>
</step>

<step n="9" goal="Offer to implement fix" optional="true">
<action>Ask user: "Would you like me to implement this fix now?"

If yes:
- Use Edit tool to apply the fix
- Or invoke `implement-feature` workflow for more complex fixes

If no:
- Provide diagnostic report
- User can implement manually
</action>
</step>

</workflow>
