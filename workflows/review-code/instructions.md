# Review Code Workflow Instructions

<critical>The workflow execution engine is governed by: {project-root}/.bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: workflow.yaml</critical>
<critical>This is a Frappe-specific workflow - Frappe bench awareness is MANDATORY</critical>

<workflow>

<step n="1" goal="Identify code to review">
<action>Ask which code to review (paths/recent changes/module/DocType). Collect file paths.</action>
<template-output>files_to_review</template-output>
</step>

<step n="2" goal="Load and analyze code files">
<action>Read specified code files (py: controllers/APIs/utils/hooks; js: client/form/custom pages; json: doctypes/custom fields).</action>
<template-output>code_content</template-output>
</step>

<step n="3" goal="Scan for Frappe anti-patterns">
<action>Check for these anti-patterns. For each found, record: file:line, type, code snippet, risk, fix.

**Server-side (Python):**
- Missing `@frappe.whitelist()` on API methods
- SQL injection: f-strings or concatenation in `frappe.db.sql()` — use `%s` params or ORM
- Missing permission checks in whitelisted methods
- Custom date/number handling — use `frappe.utils` instead
- Direct string-concat DB operations — use `frappe.db.set_value()` / ORM

**Client-side (JavaScript):**
- Client-side filtering of server results — pass `filters` arg server-side instead
- Multiplying form fields without `parseInt`/`parseFloat`
- Raw HTML/CSS instead of `frappe.ui` components
- `console.log()` statements in production code
</action>
<template-output>anti_patterns_detected</template-output>
</step>

<step n="4" goal="Check for Frappe built-in alternatives">
<action>Identify custom code reinventing Frappe built-ins:
- Date/time → `frappe.utils.today()`, `now()`, `add_days()`, `get_datetime()`, `formatdate()`
- Numbers → `frappe.utils.flt()`, `cint()`, `fmt_money()`
- UI → `frappe.ui.Dialog`, `DataTable`, `MultiSelectDialog`, `Toolbar`
- Data → `frappe.get_all()`, `get_list()`, `get_doc()`, `frappe.db.get_value()`
- Permissions → `frappe.has_permission()`, `only_for()`, `@validate_and_sanitize_search_inputs`
</action>
<template-output>builtin_alternatives</template-output>
</step>

<step n="5" goal="Generate review report">
<action>Produce a CODE REVIEW REPORT organized by severity (Critical / Warning / Suggestion). Each finding: file:line, type, description, risk, recommended fix. Include built-in alternatives section.</action>
<template-output>review_report</template-output>
</step>

<step n="6" goal="Present report and offer fixes">
<action>Display report. Ask: "Would you like me to fix these issues?" Options: (1) Fix all, (2) Critical only, (3) User-selected, (4) Report only. Apply fixes with Edit tool, confirm each, re-verify. Optionally save report to file.</action>
<template-output>fixes_applied</template-output>
</step>

<step n="7" goal="Update project state">
<action>Update `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/session.yaml`:
```yaml
last_action: "Code review: {{issue_count}} issues found, {{fix_count}} fixed"
next_action: "Continue implementation or test changes"
updated: "{{timestamp}}"
```
</action>
<template-output>state_updated</template-output>
<gate>
HALT: Do not respond with the next step until session.yaml is confirmed written.
If the write fails or is skipped, report the failure and stop.
</gate>
</step>

</workflow>
