---
name: "Implement Client-Side UI Behavior (Part B)"
step: "4b"
description: "Link field filters, child tables, common UI patterns and completion"
variables:
  - client_logic_implemented
  - form_behaviors_added
---

# Step 4b: Client Logic — Filters, Child Tables & Common Patterns

---

## MANDATORY EXECUTION RULES

<critical>
- Filters must use server-side query constraints only
- Child table row values must be type-converted before arithmetic
- Use frappe.confirm() before destructive actions
</critical>

---

### 6. Filter Link Fields

```javascript
frappe.ui.form.on('Asset Maintenance Request', {
    setup: function(frm) {
        // Filter assigned_to to Asset Manager role only
        frm.set_query('assigned_to', function() {
            return {
                filters: { 'role_profile_name': 'Asset Manager' }
            };
        });

        // Filter asset by category and status
        frm.set_query('asset', function() {
            return {
                filters: {
                    'asset_category': frm.doc.asset_category,
                    'status': 'Active'
                }
            };
        });
    }
});
```

---

### 7. Handle Child Tables

```javascript
frappe.ui.form.on('Maintenance Task', {  // Child table DocType
    tasks_add: function(frm, cdt, cdn) {
        let row = locals[cdt][cdn];
        row.status = 'Pending';
    },

    quantity: function(frm, cdt, cdn) {
        let row = locals[cdt][cdn];
        let qty = parseInt(row.quantity) || 0;
        let rate = parseFloat(row.rate) || 0;

        frappe.model.set_value(cdt, cdn, 'amount', qty * rate);
        calculate_parent_total(frm);
    }
});

function calculate_parent_total(frm) {
    let total = 0;
    frm.doc.tasks.forEach(function(row) {
        total += parseFloat(row.amount) || 0;
    });
    frm.set_value('total_task_cost', total);
}
```

---

## Common Patterns

### Pattern 1: Confirmation Dialog

```javascript
frappe.confirm(
    'Are you sure you want to proceed?',
    function() { frappe.call({ /* ... */ }); },
    function() { /* User clicked No */ }
);
```

### Pattern 2: Show Alert Message

```javascript
frappe.show_alert({
    message: __('Operation completed successfully'),
    indicator: 'green'  // green, blue, orange, red
}, 5);
```

### Pattern 3: Prompt for Input

```javascript
frappe.prompt({
    label: 'Reason', fieldname: 'reason',
    fieldtype: 'Text', reqd: 1
}, function(values) {
    frappe.call({
        method: 'app.api.function',
        args: { reason: values.reason }
    });
}, __('Enter Reason'), __('Submit'));
```

---

## Implementation Checklist

```
Client Script Implementation:
[ ] Field Dependencies    [✓] Show/hide, enable/disable
[ ] Auto-Fill Logic       [✓] Server fetch, populate
[ ] Simple Calculations   [✓] Type conversion, set values
[ ] Custom Buttons        [✓] Actions, server calls
[ ] Link Field Filters    [✓] Query filters
[ ] Child Table Handlers  [✓] Row calculations
```

---

## Menu

What would you like to do?

**[A]** Auto-continue to Step 5 (Deploy Code)
**[P]** Pause here (review client scripts before deployment)
**[C]** Cancel workflow

---

## Success Criteria

- ✅ All client-side UI behaviors implemented
- ✅ No business logic in client scripts
- ✅ Form values converted properly (parseInt/parseFloat)
- ✅ frappe.call() used for server communication
- ✅ frm.set_value() used for field updates
- ✅ Null/undefined values handled
- ✅ Custom buttons functional

---

## Update State

Update `session.yaml`:
```yaml
workflow_step: 4
current_task: "Implemented client-side UI behavior"
last_action: "Completed [X] client scripts with [Y] behaviors"
next_action: "Deploy code to Frappe bench"
updated: "[current timestamp]"
```

---

## Next Step

**If [A]uto-continue:**
**→ Load and execute:** `steps/step-05-deploy.md`

**If [P]ause:**
STOP here. User can review client scripts and resume later.

**If [C]ancel:**
EXIT workflow. Update state and preserve progress.
