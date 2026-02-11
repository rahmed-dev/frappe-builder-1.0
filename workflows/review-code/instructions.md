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
<action>Check code against Frappe anti-patterns:

**SERVER-SIDE (Python) Anti-Patterns:**

❌ **Missing @frappe.whitelist() decorator:**
```python
# WRONG
def my_api_method():
    return {"status": "ok"}

# CORRECT
@frappe.whitelist()
def my_api_method():
    if not frappe.has_permission("DocType", "read"):
        frappe.throw(_("Not permitted"))
    return {"status": "ok"}
```

❌ **SQL injection risk:**
```python
# WRONG
frappe.db.sql(f"SELECT * FROM tabItem WHERE name = '{item_name}'")

# CORRECT
frappe.db.sql("SELECT * FROM tabItem WHERE name = %s", (item_name,))
# OR BETTER
frappe.get_all("Item", filters={"name": item_name})
```

❌ **Missing permission checks:**
```python
# WRONG
@frappe.whitelist()
def delete_all_orders():
    frappe.db.sql("DELETE FROM `tabSales Order`")

# CORRECT
@frappe.whitelist()
def delete_all_orders():
    if not frappe.has_permission("Sales Order", "delete"):
        frappe.throw(_("Not permitted"))
    # Additional checks for mass delete
```

❌ **Not using frappe.utils:**
```python
# WRONG
from datetime import datetime
today = datetime.now().strftime("%Y-%m-%d")

# CORRECT
from frappe.utils import today
today_date = today()
```

❌ **Direct database operations without parameters:**
```python
# WRONG
frappe.db.sql("UPDATE tabItem SET price = " + str(price))

# CORRECT
frappe.db.set_value("Item", item_name, "price", price)
```

**CLIENT-SIDE (JavaScript) Anti-Patterns:**

❌ **Client-side filtering (should be server-side):**
```javascript
// WRONG
frappe.call({
    method: "frappe.client.get_list",
    args: {doctype: "Sales Order"},
    callback: function(r) {
        let filtered = r.message.filter(d => d.status == "Draft");
    }
});

// CORRECT
frappe.call({
    method: "frappe.client.get_list",
    args: {
        doctype: "Sales Order",
        filters: {"status": "Draft"}
    }
});
```

❌ **Not converting form field values:**
```javascript
// WRONG
let total = frm.doc.qty * frm.doc.rate;  // Multiplying strings!

// CORRECT
let qty = parseInt(frm.doc.qty) || 0;
let rate = parseFloat(frm.doc.rate) || 0;
let total = qty * rate;
```

❌ **Custom HTML/CSS instead of frappe.ui:**
```javascript
// WRONG
$('body').append('<div class="custom-dialog">...</div>');

// CORRECT
let dialog = new frappe.ui.Dialog({
    title: 'Custom Dialog',
    fields: [...]
});
dialog.show();
```

❌ **console.log() in production:**
```javascript
// WRONG
console.log("Debug info:", data);

// CORRECT (for production)
// Remove console.log or use frappe.msgprint for user-facing messages
```

For EACH anti-pattern found, record:
- File:line location
- Anti-pattern type
- Code snippet (wrong)
- Risk/impact
- Suggested fix
</action>

<template-output>anti_patterns_detected</template-output>
</step>

<step n="4" goal="Check for Frappe built-in alternatives">
<action>Identify custom code that reinvents Frappe built-ins:

**Common Reinventions:**

Instead of custom date handling → Use frappe.utils:
- `frappe.utils.today()`
- `frappe.utils.now()`
- `frappe.utils.add_days(date, days)`
- `frappe.utils.get_datetime()`
- `frappe.utils.formatdate(date, format)`

Instead of custom number formatting → Use frappe.utils:
- `frappe.utils.flt(value, precision)`
- `frappe.utils.cint(value)`
- `frappe.utils.fmt_money(amount, currency)`

Instead of custom HTML → Use frappe.ui:
- `frappe.ui.Dialog`
- `frappe.ui.DataTable`
- `frappe.ui.form.MultiSelectDialog`
- `frappe.ui.Toolbar`

Instead of custom data fetching → Use frappe.db:
- `frappe.get_all(doctype, filters, fields)`
- `frappe.get_list(doctype, filters)`
- `frappe.get_doc(doctype, name)`
- `frappe.db.get_value(doctype, name, fieldname)`

Instead of custom permissions → Use frappe.permissions:
- `frappe.has_permission(doctype, ptype, doc)`
- `frappe.only_for(roles)`
- `@frappe.validate_and_sanitize_search_inputs`

For each reinvention, show Frappe built-in alternative.
</action>

<template-output>builtin_alternatives</template-output>
</step>

<step n="5" goal="Generate comprehensive review report">
<action>Create detailed code review report:

**Format:**
```
CODE REVIEW REPORT
==================

Organize findings by severity (Critical/Warn/Suggest) with file:line, description, risk, fix. List built-in alternatives (frappe.ui.Dialog, frappe.utils.fmt_money/add_days).</action>

<template-output>review_report</template-output>
</step>

<step n="6" goal="Present report and offer fixes">
<action>Display the code review report to user.

Ask: "Would you like me to fix these issues?"

Options:
1. Fix all automatically (use Edit tool)
2. Fix critical issues only
3. Fix specific issues (user selects)
4. Just provide report (user fixes manually)

If user wants fixes:
- Apply fixes using Edit tool
- Confirm each fix applied
- Re-run review to verify fixes

Optionally save report to file if user requests.
</action>

<template-output>fixes_applied</template-output>
</step>

<step n="7" goal="Update project state">
<action>After code review completion, update the project state:

**Files to Update:**
1. `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/active.yaml`
2. `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/features/{{current_feature}}.yaml` (if feature exists)

**active.yaml - Fields to Update:**
```yaml
current_task: "Code review completed"
workflow: "review-code"
workflow_step: 7
last_action: "Reviewed code, identified {{issue_count}} issues, applied {{fix_count}} fixes"
next_action: "Continue implementation or test changes"
specialist: "frappe-dev"
updated: "{{timestamp}}"
```

**feature file - Fields to Update** (if {{current_feature}} exists):
```yaml
status: "in-progress"
updated: "{{timestamp}}"
notes: "Code review completed: {{issue_count}} issues found, {{fix_count}} fixed"
```

**How to update:**
1. Read existing active.yaml
2. Update the fields above
3. If {{current_feature}} is set, also update the detailed feature file
4. Write back to both files
</action>

<template-output>state_updated</template-output>
</step>

</workflow>
