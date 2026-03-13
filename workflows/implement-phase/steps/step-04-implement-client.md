---
name: "Implement Client-Side UI Behavior"
step: 4
description: "Implement minimal client-side logic for UI behavior only (no business logic)"
variables:
  - client_logic_implemented
  - form_behaviors_added
---

# Step 5: Implement Client-Side UI Behavior

**Goal:** Implement minimal client-side logic for UI behavior ONLY.

---

## MANDATORY EXECUTION RULES

<critical>
- Client scripts are ONLY for UI behavior (not business logic)
- Business logic MUST be on server-side
- ALWAYS convert form values (string → int/float) before calculations
- Use frappe.call() to invoke server-side methods
- Use frm.set_value() to update form fields
- Handle null/undefined values properly
- DO NOT put validations, calculations, or data operations in client scripts
</critical>

---

## Reference Materials

**Load patterns:** `data/client-patterns.md`

This file contains:
- frappe.ui.form.on pattern
- frappe.call pattern
- Type conversion (parseInt/parseFloat)
- Custom button pattern
- Field dependency patterns
- Auto-calculation patterns

---

## Session Variables (Available)

From Step 4:
- Implemented server-side logic
- API endpoints available

---

## Step Instructions

### 1. Understand Client Script Use Cases

**✅ VALID Use Cases (UI behavior only):**
- Show/hide fields based on other field values
- Enable/disable fields conditionally
- Auto-fill fields from server data
- Add custom buttons that call server methods
- Display messages and confirmations
- Refresh form sections
- Set default values
- Filter link fields
- Format field display
- Trigger form refresh

**❌ INVALID Use Cases (business logic):**
- Complex calculations
- Data validation (should be server-side)
- Database queries
- Creating/updating other documents
- Permission checks
- Business rules enforcement

---

### 2. Implement Field Dependencies

Show/hide or enable/disable fields based on conditions:

```javascript
frappe.ui.form.on('Asset Maintenance Request', {
    maintenance_type: function(frm) {
        // Show/hide preventive schedule fields
        if (frm.doc.maintenance_type === 'Preventive') {
            frm.set_df_property('schedule_date', 'reqd', 1);
            frm.set_df_property('recurrence_pattern', 'hidden', 0);
        } else {
            frm.set_df_property('schedule_date', 'reqd', 0);
            frm.set_df_property('recurrence_pattern', 'hidden', 1);
        }
    },

    status: function(frm) {
        // Disable fields when completed
        if (frm.doc.status === 'Completed') {
            frm.set_df_property('assigned_to', 'read_only', 1);
            frm.set_df_property('schedule_date', 'read_only', 1);
        }
    }
});
```

### 3. Implement Auto-Fill Logic

Fetch data from server and populate fields:

```javascript
frappe.ui.form.on('Asset Maintenance Request', {
    asset: function(frm) {
        // Auto-fill asset details when asset is selected
        if (frm.doc.asset) {
            frappe.call({
                method: 'frappe.client.get',
                args: {
                    doctype: 'Asset',
                    name: frm.doc.asset
                },
                callback: function(r) {
                    if (r.message) {
                        frm.set_value('asset_category', r.message.asset_category);
                        frm.set_value('location', r.message.location);
                        frm.set_value('asset_owner', r.message.asset_owner);
                    }
                }
            });
        }
    }
});
```

### 4. Implement Simple Calculations

**CRITICAL:** Always convert form values to numbers!

```javascript
frappe.ui.form.on('Asset Maintenance Request', {
    parts_cost: function(frm) {
        calculate_total_cost(frm);
    },

    labor_cost: function(frm) {
        calculate_total_cost(frm);
    }
});

function calculate_total_cost(frm) {
    // IMPORTANT: Convert string to number
    let parts_cost = parseFloat(frm.doc.parts_cost) || 0;
    let labor_cost = parseFloat(frm.doc.labor_cost) || 0;

    // Simple calculation only - complex logic should be server-side
    let total = parts_cost + labor_cost;

    frm.set_value('total_cost', total);
}
```

**Note:** For complex calculations (taxes, discounts, business rules), call server-side method instead:

```javascript
frappe.ui.form.on('Asset Maintenance Request', {
    parts_cost: function(frm) {
        // Call server for complex calculation
        frappe.call({
            method: 'app_name.module.api.calculate_maintenance_cost',
            args: {
                maintenance_request: frm.doc.name
            },
            callback: function(r) {
                if (r.message) {
                    frm.set_value('total_cost', r.message.total_cost);
                    frm.set_value('overhead', r.message.overhead);
                }
            }
        });
    }
});
```

### 5. Add Custom Buttons

```javascript
frappe.ui.form.on('Asset Maintenance Request', {
    refresh: function(frm) {
        // Add custom button to view asset history
        if (!frm.is_new()) {
            frm.add_custom_button(__('View Asset History'), function() {
                view_asset_history(frm);
            });

            // Add button to complete maintenance
            if (frm.doc.status === 'In Progress') {
                frm.add_custom_button(__('Mark as Completed'), function() {
                    complete_maintenance(frm);
                }, __('Actions'));
            }
        }
    }
});

function view_asset_history(frm) {
    frappe.call({
        method: 'app_name.module.api.get_asset_maintenance_history',
        args: {
            asset_name: frm.doc.asset
        },
        callback: function(r) {
            if (r.message) {
                // Show in dialog
                show_history_dialog(r.message);
            }
        }
    });
}

function complete_maintenance(frm) {
    frappe.confirm(
        'Mark this maintenance as completed?',
        function() {
            // Call server-side method
            frappe.call({
                method: 'app_name.module.api.complete_maintenance',
                args: {
                    maintenance_request: frm.doc.name
                },
                callback: function(r) {
                    if (r.message) {
                        frappe.show_alert({
                            message: __('Maintenance completed'),
                            indicator: 'green'
                        });
                        frm.reload_doc();
                    }
                }
            });
        }
    );
}
```

---

## Continue in Part B

**→ Load and execute:** `steps/step-04b-implement-client.md`

Part B covers: link field filters, child table handlers, common patterns, checklist, menu and state update.
