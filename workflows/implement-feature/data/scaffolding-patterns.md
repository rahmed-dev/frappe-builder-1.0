# Scaffolding Patterns

Reference templates for generating boilerplate code following Frappe framework conventions.

---

## DocType JSON Structure

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
      "reqd": 1,
      "in_list_view": 1
    },
    {
      "fieldname": "link_field",
      "label": "Link Field",
      "fieldtype": "Link",
      "options": "Linked DocType",
      "reqd": 1
    },
    {
      "fieldname": "select_field",
      "label": "Select Field",
      "fieldtype": "Select",
      "options": "Option 1\nOption 2\nOption 3",
      "default": "Option 1"
    },
    {
      "fieldname": "section_break_1",
      "fieldtype": "Section Break"
    },
    {
      "fieldname": "child_table",
      "label": "Child Table",
      "fieldtype": "Table",
      "options": "Child DocType Name"
    }
  ],
  "permissions": [
    {
      "role": "System Manager",
      "read": 1,
      "write": 1,
      "create": 1,
      "delete": 1,
      "submit": 1,
      "cancel": 1
    },
    {
      "role": "User Role",
      "read": 1,
      "write": 1,
      "create": 1
    }
  ],
  "sort_field": "modified",
  "sort_order": "DESC",
  "track_seen": 1,
  "title_field": "name"
}
```

---

## Python Controller Template

```python
# Copyright (c) [Year], [Company] and contributors
# For license information, please see license.txt

import frappe
from frappe.model.document import Document

class DocTypeName(Document):
    """
    DocType controller for DocType Name

    Purpose: [Brief description of what this DocType represents]
    """

    def validate(self):
        """Validation logic before save"""
        self.validate_required_fields()
        self.validate_dates()
        self.calculate_totals()

    def validate_required_fields(self):
        """Check required business fields"""
        pass

    def validate_dates(self):
        """Validate date logic"""
        from frappe.utils import getdate
        pass

    def before_save(self):
        """Logic before document is saved"""
        pass

    def after_insert(self):
        """Logic after new document is created"""
        pass

    def on_submit(self):
        """Logic when document is submitted"""
        pass

    def on_cancel(self):
        """Logic when document is cancelled"""
        pass

    def on_trash(self):
        """Logic before document is deleted"""
        pass

    # Custom methods
    def custom_method(self):
        """Custom business logic"""
        pass
```

---

## Client Script Template

```javascript
// Copyright (c) [Year], [Company] and contributors
// For license information, please see license.txt

frappe.ui.form.on('DocType Name', {
    refresh: function(frm) {
        // Form refresh logic
        // Add custom buttons, set field properties, etc.

        if (!frm.is_new()) {
            frm.add_custom_button(__('Custom Action'), function() {
                // Button click logic
            });
        }
    },

    onload: function(frm) {
        // Form load logic
        // Set queries, filters, etc.
    },

    field_name: function(frm) {
        // Field change logic
        // IMPORTANT: Convert string values to numbers if needed
        // let value = parseInt(frm.doc.field_name) || 0;
    },

    link_field: function(frm) {
        // When link field changes, auto-fill related fields
        if (frm.doc.link_field) {
            frappe.call({
                method: 'frappe.client.get',
                args: {
                    doctype: 'Linked DocType',
                    name: frm.doc.link_field
                },
                callback: function(r) {
                    if (r.message) {
                        frm.set_value('auto_field', r.message.field_name);
                    }
                }
            });
        }
    }
});

// Child table events
frappe.ui.form.on('Child DocType Name', {
    child_table_add: function(frm, cdt, cdn) {
        // When new row is added
        let row = locals[cdt][cdn];
        row.default_field = 'Default Value';
    },

    quantity: function(frm, cdt, cdn) {
        // Calculate row total
        let row = locals[cdt][cdn];
        let qty = parseInt(row.quantity) || 0;
        let rate = parseFloat(row.rate) || 0;

        frappe.model.set_value(cdt, cdn, 'amount', qty * rate);
    }
});
```

---

## Report Script Template

```python
# Copyright (c) [Year], [Company] and contributors
# For license information, please see license.txt

import frappe
from frappe import _

def execute(filters=None):
    """
    Report execution function

    Args:
        filters (dict): Report filters from UI

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
            "label": _("Column 1"),
            "fieldname": "col1",
            "fieldtype": "Link",
            "options": "DocType",
            "width": 150
        },
        {
            "label": _("Column 2"),
            "fieldname": "col2",
            "fieldtype": "Data",
            "width": 120
        },
        {
            "label": _("Amount"),
            "fieldname": "amount",
            "fieldtype": "Currency",
            "width": 120
        }
    ]

def get_data(filters):
    """
    Fetch report data

    Args:
        filters (dict): Report filters

    Returns:
        list: List of dicts representing rows
    """
    conditions = get_conditions(filters)

    data = frappe.db.sql("""
        SELECT
            dt.name as col1,
            dt.field_name as col2,
            dt.amount as amount
        FROM
            `tabDocType Name` dt
        WHERE
            dt.docstatus < 2
            {conditions}
        ORDER BY
            dt.creation DESC
    """.format(conditions=conditions), filters, as_dict=1)

    return data

def get_conditions(filters):
    """
    Build WHERE conditions from filters

    Args:
        filters (dict): Report filters

    Returns:
        str: SQL WHERE conditions
    """
    conditions = ""

    if filters.get("from_date"):
        conditions += " AND dt.date >= %(from_date)s"

    if filters.get("to_date"):
        conditions += " AND dt.date <= %(to_date)s"

    if filters.get("status"):
        conditions += " AND dt.status = %(status)s"

    return conditions
```

---

## API Endpoint Template

```python
import frappe
from frappe import _

@frappe.whitelist()
def api_function_name(param1, param2=None):
    """
    API endpoint description

    Args:
        param1 (str): Parameter description
        param2 (str, optional): Optional parameter description

    Returns:
        dict: Return value description
    """
    # Permission check - MANDATORY for all API endpoints
    frappe.has_permission("DocType Name", "read", throw=True)

    # Validate input
    if not param1:
        frappe.throw(_("Parameter 1 is required"))

    # Business logic
    result = process_data(param1, param2)

    return {
        "status": "success",
        "data": result
    }

def process_data(param1, param2):
    """
    Internal helper function (not whitelisted)

    Args:
        param1: Data to process
        param2: Optional parameter

    Returns:
        Processed data
    """
    # Use parameterized queries
    data = frappe.db.sql("""
        SELECT *
        FROM `tabDocType Name`
        WHERE field1 = %(param1)s
    """, {"param1": param1}, as_dict=1)

    return data
```

---

## Workflow JSON Template

```json
{
  "name": "Workflow Name",
  "doctype": "Workflow",
  "document_type": "DocType Name",
  "is_active": 1,
  "send_email_alert": 1,
  "states": [
    {
      "state": "Draft",
      "doc_status": "0",
      "allow_edit": "All",
      "style": "Info"
    },
    {
      "state": "Pending Approval",
      "doc_status": "0",
      "allow_edit": "Approver Role",
      "style": "Warning"
    },
    {
      "state": "Approved",
      "doc_status": "1",
      "allow_edit": "Nobody",
      "style": "Success"
    },
    {
      "state": "Rejected",
      "doc_status": "2",
      "allow_edit": "Nobody",
      "style": "Danger"
    }
  ],
  "transitions": [
    {
      "state": "Draft",
      "action": "Submit for Approval",
      "next_state": "Pending Approval",
      "allowed": "Submitter Role",
      "allow_self_approval": 0
    },
    {
      "state": "Pending Approval",
      "action": "Approve",
      "next_state": "Approved",
      "allowed": "Approver Role"
    },
    {
      "state": "Pending Approval",
      "action": "Reject",
      "next_state": "Rejected",
      "allowed": "Approver Role"
    }
  ]
}
```

---

## Print Format Jinja Template

```html
<div class="print-format">
    <h1>{{ doc.name }}</h1>

    <div class="row">
        <div class="col-xs-6">
            <label>Field Label:</label>
            <div>{{ doc.field_name }}</div>
        </div>
        <div class="col-xs-6">
            <label>Date:</label>
            <div>{{ frappe.utils.formatdate(doc.date) }}</div>
        </div>
    </div>

    {% if doc.child_table %}
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Item</th>
                <th>Quantity</th>
                <th>Rate</th>
                <th>Amount</th>
            </tr>
        </thead>
        <tbody>
            {% for row in doc.child_table %}
            <tr>
                <td>{{ row.item_name }}</td>
                <td>{{ row.quantity }}</td>
                <td>{{ frappe.utils.fmt_money(row.rate) }}</td>
                <td>{{ frappe.utils.fmt_money(row.amount) }}</td>
            </tr>
            {% endfor %}
        </tbody>
    </table>
    {% endif %}

    <div class="row">
        <div class="col-xs-12 text-right">
            <strong>Total:</strong> {{ frappe.utils.fmt_money(doc.total) }}
        </div>
    </div>
</div>
```

---

## Scheduled Job Template

```python
import frappe
from frappe.utils import now_datetime

def scheduled_job_function():
    """
    Scheduled job that runs at specified intervals

    Configure in hooks.py:
    scheduler_events = {
        "daily": ["app.module.scheduled.scheduled_job_function"],
        "hourly": [...],
        "cron": {
            "0 9 * * *": ["app.module.scheduled.morning_job"]
        }
    }
    """
    # Use ignore_permissions for scheduled jobs
    docs = frappe.get_all(
        "DocType Name",
        filters={"status": "Pending"},
        fields=["name", "field1"],
        ignore_permissions=True
    )

    for doc in docs:
        try:
            # Process each document
            process_document(doc.name)
        except Exception as e:
            # Log errors but continue processing
            frappe.log_error(
                message=str(e),
                title=f"Scheduled Job Error: {doc.name}"
            )

def process_document(docname):
    """Process individual document"""
    doc = frappe.get_doc("DocType Name", docname)
    # Business logic here
    doc.save(ignore_permissions=True)
```

---

## Usage Notes

1. **Replace placeholders:**
   - `DocType Name` → Your actual DocType name
   - `Module Name` → Your module name
   - `[Year], [Company]` → Actual year and company name

2. **Follow naming conventions:**
   - DocType: PascalCase (`AssetMaintenanceRequest`)
   - Fields: snake_case (`maintenance_type`)
   - Files: snake_case (`asset_maintenance_request.py`)

3. **Always include:**
   - Copyright headers
   - Docstrings
   - Type hints where helpful
   - Permission checks in API endpoints

4. **File locations:**
   - DocTypes: `app/module/doctype/doctype_folder/`
   - Reports: `app/module/report/report_folder/`
   - API: `app/module/api.py`
   - Scheduled: `app/module/scheduled.py`
