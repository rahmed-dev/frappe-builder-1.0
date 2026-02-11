---
name: "Scaffold Boilerplate Code"
step: 3
description: "Generate minimal boilerplate for all components using Frappe conventions"
variables:
  - scaffolds_generated
  - component_files
---

# Step 3: Scaffold Boilerplate Code

**Goal:** Generate minimal boilerplate code for all components identified in Step 2.

---

## MANDATORY EXECUTION RULES

<critical>
- Generate boilerplate for EVERY component in checklist
- Use Frappe framework conventions (DO NOT invent custom patterns)
- Include proper structure but minimal logic (placeholders OK)
- Follow naming conventions strictly
- DO NOT implement business logic yet (that's Step 4 & 5)
</critical>

---

## Reference Materials

**Load patterns:** `data/scaffolding-patterns.md`

This file contains templates for:
- DocType JSON structure
- Python controller skeleton
- Client script structure
- Report script template
- API function template

---

## Session Variables (Available)

From Step 2:
- Component checklist
- DocType specifications
- Script specifications
- Report specifications

---

## Step Instructions

### 1. Scaffold DocTypes

For each DocType in the checklist:

**A. Create DocType JSON**

Structure:
```json
{
  "name": "DocType Name",
  "module": "Module Name",
  "doctype": "DocType",
  "is_submittable": 0,
  "track_changes": 1,
  "fields": [
    {
      "fieldname": "field_name",
      "label": "Field Label",
      "fieldtype": "Data",
      "reqd": 1
    }
  ],
  "permissions": [
    {
      "role": "Role Name",
      "read": 1,
      "write": 1,
      "create": 1,
      "delete": 1
    }
  ]
}
```

**B. Create Python Controller**

Structure:
```python
# Copyright (c) [Year], [Company] and contributors
# For license information, please see license.txt

import frappe
from frappe.model.document import Document

class DocTypeName(Document):
    """DocType controller for DocType Name"""

    def validate(self):
        """Validation logic before save"""
        pass

    def before_save(self):
        """Logic before document is saved"""
        pass

    def on_submit(self):
        """Logic when document is submitted"""
        pass

    def on_cancel(self):
        """Logic when document is cancelled"""
        pass
```

**Location:**
- JSON: `{{app_path}}/{{current_app}}/{{module}}/doctype/{{doctype_folder}}/{{doctype_name}}.json`
- Controller: `{{app_path}}/{{current_app}}/{{module}}/doctype/{{doctype_folder}}/{{doctype_name}}.py`

### 2. Scaffold Server Scripts (API Endpoints)

For each API endpoint in the checklist:

**Template:**
```python
import frappe

@frappe.whitelist()
def function_name(param1, param2=None):
    """
    Purpose: [Brief description]

    Args:
        param1 (type): Description
        param2 (type, optional): Description

    Returns:
        type: Description of return value
    """
    # TODO: Implement business logic

    # Permission check
    frappe.has_permission("DocType Name", "read", throw=True)

    # Placeholder logic
    return {"status": "success", "data": []}
```

**Location:** `{{app_path}}/{{current_app}}/{{module}}/api.py`

### 3. Scaffold Client Scripts

For each client script in the checklist:

**Template:**
```javascript
// Copyright (c) [Year], [Company] and contributors
// For license information, please see license.txt

frappe.ui.form.on('DocType Name', {
    refresh: function(frm) {
        // Form refresh logic
    },

    field_name: function(frm) {
        // Field change logic
        // IMPORTANT: Convert string values to numbers if needed
        // let value = parseInt(frm.doc.field_name) || 0;
    },

    custom_button_add: function(frm) {
        // Add custom button
        frm.add_custom_button(__('Button Label'), function() {
            // Button click logic
            frappe.call({
                method: 'app.module.api.function_name',
                args: {
                    doc_name: frm.doc.name
                },
                callback: function(r) {
                    if (r.message) {
                        frappe.msgprint(__('Success'));
                        frm.refresh();
                    }
                }
            });
        });
    }
});
```

**Location:** `{{app_path}}/{{current_app}}/{{module}}/doctype/{{doctype_folder}}/{{doctype_name}}.js`

### 4. Scaffold Reports

For each report in the checklist:

**Query Report Template:**
```python
# Copyright (c) [Year], [Company] and contributors
# For license information, please see license.txt

import frappe

def execute(filters=None):
    """
    Report execution function

    Args:
        filters (dict): Report filters

    Returns:
        tuple: (columns, data)
    """
    columns = get_columns()
    data = get_data(filters)

    return columns, data

def get_columns():
    """Define report columns"""
    return [
        {
            "label": "Column Label",
            "fieldname": "column_fieldname",
            "fieldtype": "Data",
            "width": 150
        }
    ]

def get_data(filters):
    """Fetch report data"""
    # TODO: Implement query logic

    conditions = get_conditions(filters)

    data = frappe.db.sql("""
        SELECT
            column1,
            column2
        FROM
            `tabDocType Name`
        WHERE
            1=1 {conditions}
    """.format(conditions=conditions), filters, as_dict=1)

    return data

def get_conditions(filters):
    """Build WHERE conditions from filters"""
    conditions = ""

    if filters.get("filter_name"):
        conditions += " AND filter_field = %(filter_name)s"

    return conditions
```

**Location:** `{{app_path}}/{{current_app}}/{{module}}/report/{{report_folder}}/{{report_name}}.py`

### 5. Scaffold Workflows

For each workflow in the checklist:

**Template:**
```json
{
  "name": "Workflow Name",
  "doctype": "Workflow",
  "document_type": "DocType Name",
  "is_active": 1,
  "states": [
    {
      "state": "Draft",
      "doc_status": "0",
      "allow_edit": "All"
    }
  ],
  "transitions": [
    {
      "state": "Draft",
      "action": "Submit",
      "next_state": "Pending Approval",
      "allowed": "Role Name"
    }
  ]
}
```

**Location:** `{{app_path}}/{{current_app}}/{{module}}/workflow/{{workflow_name}}.json`

---

## Generate All Scaffolds

**For each component:**
1. Generate boilerplate code from templates
2. Replace placeholders with actual names
3. Add TODO comments for business logic
4. Verify structure is valid

**Track progress:**
```
Scaffolding Progress:
[✓] DocType: Asset Maintenance Request
[✓] Controller: Asset Maintenance Request
[✓] Client Script: Asset Maintenance Request
[✓] API: get_asset_maintenance_history
[✓] Report: Asset Maintenance Summary
[ ] Workflow: Maintenance Approval
```

---

## Menu

What would you like to do?

**[A]** Auto-continue to Step 4 (Implement Server Logic)
**[P]** Pause here (review scaffolds before implementing logic)
**[C]** Cancel workflow

---

## Success Criteria

- ✅ All components have boilerplate scaffolds generated
- ✅ Code follows Frappe conventions
- ✅ File structure is correct
- ✅ No syntax errors in scaffolds
- ✅ Placeholders clearly marked with TODO

---

## Update State

Update `active.yaml`:
```yaml
workflow_step: 3
current_task: "Scaffolded boilerplate for all components"
last_action: "Generated [X] DocTypes, [Y] scripts, [Z] reports"
next_action: "Implement server-side business logic"
updated: "[current timestamp]"
```

---

## Next Step

**If [A]uto-continue:**
**→ Load and execute:** `steps/step-04-implement-server.md`

**If [P]ause:**
STOP here. User can review scaffolds and resume later.

**If [C]ancel:**
EXIT workflow. Update state and preserve progress.
