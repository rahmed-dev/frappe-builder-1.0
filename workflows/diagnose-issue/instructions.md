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
<action>Ask what the issue is (log error, traceback, unexpected behavior, performance). Capture brief context.</action>

<template-output>problem_description</template-output>
</step>

<step n="2" goal="Gather error evidence">
<action if="Error in logs">Tail relevant logs (error/web/scheduler). Note timestamps, error types, tracebacks.</action>
\n<action if="Python traceback provided">Identify error type, file:line, call stack, trigger.</action>
\n<action if="Unexpected behavior">Capture expected vs actual, steps to reproduce, DocType/feature, any messages.</action>

<template-output>error_evidence</template-output>
</step>

<step n="3" goal="Correlate logs if multiple errors">
<action if="Multiple log files read">Cross-reference timestamps/patterns across logs; note chains and recurrence.</action>

<template-output>log_correlation</template-output>
</step>

<step n="4" goal="Identify root cause">
<action>Find root cause: what code was doing, trigger condition/data, underlying issue (not just symptom). Note error type (Validation/Permission/Attribute/Type/DoesNotExist) and pinpoint cause.</action>

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

Optionally point to any local debugging notes or project-specific standards if they exist in the current app.

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
