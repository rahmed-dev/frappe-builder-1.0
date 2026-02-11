# Client-Side Patterns

Best practices for implementing client-side UI behavior in Frappe Framework.

**IMPORTANT:** Client scripts are for UI behavior ONLY, not business logic.

---

## frappe.ui.form.on Pattern

### Basic Form Events

```javascript
frappe.ui.form.on('DocType Name', {
    // Form load (once per form instance)
    onload: function(frm) {
        // Set queries, filters, initial setup
        // Runs once when form is first loaded
    },

    // Form refresh (after load and after every save)
    refresh: function(frm) {
        // Update UI based on document state
        // Add custom buttons
        // Show/hide fields
        // Runs frequently - keep it fast
    },

    // Before load (rarely used)
    before_load: function(frm) {
        // Advanced setup before form loads
    },

    // Before save
    before_save: function(frm) {
        // Final client-side checks before save
        // Return false to prevent save
    },

    // After save
    after_save: function(frm) {
        // Actions after successful save
        frappe.show_alert('Document saved successfully');
    },

    // Onload post render
    onload_post_render: function(frm) {
        // After form is fully rendered
        // Good for DOM manipulations
    }
});
```

### Field Change Events

```javascript
frappe.ui.form.on('DocType Name', {
    field_name: function(frm) {
        // Triggered when field_name changes
        // IMPORTANT: Always convert string to number

        let value = parseInt(frm.doc.field_name) || 0;

        // Use the converted value
        if (value > 100) {
            frappe.msgprint('Value is greater than 100');
        }
    },

    customer: function(frm) {
        // When link field changes, auto-fill related fields
        if (frm.doc.customer) {
            frappe.call({
                method: 'frappe.client.get',
                args: {
                    doctype: 'Customer',
                    name: frm.doc.customer
                },
                callback: function(r) {
                    if (r.message) {
                        frm.set_value('customer_group', r.message.customer_group);
                        frm.set_value('territory', r.message.territory);
                    }
                }
            });
        }
    }
});
```

---

## Type Conversion (CRITICAL)

### Always Convert Form Values

```javascript
// ❌ WRONG: String arithmetic
let qty = frm.doc.qty;  // "5" (string from form)
let total = qty * 10;   // "5555555555" (string concatenation!)

// ✅ CORRECT: Convert to number first
let qty = parseInt(frm.doc.qty) || 0;
let total = qty * 10;  // 50 (correct calculation)

// Float conversion
let rate = parseFloat(frm.doc.rate) || 0;
let amount = parseFloat(frm.doc.amount) || 0.0;

// Handle null/undefined
let value = parseInt(frm.doc.field) || 0;  // Default to 0 if null/undefined/""
let value = parseFloat(frm.doc.field) || 0.0;

// Check for NaN
let qty = parseInt(frm.doc.qty);
if (isNaN(qty)) {
    qty = 0;
}
```

### Type Conversion Examples

```javascript
// Integers (quantities, counts)
let quantity = parseInt(frm.doc.quantity) || 0;
let count = cint(frm.doc.count) || 0;  // frappe helper

// Floats (amounts, rates, decimals)
let rate = parseFloat(frm.doc.rate) || 0.0;
let amount = flt(frm.doc.amount) || 0.0;  // frappe helper

// Booleans
let is_active = frm.doc.is_active ? 1 : 0;
let is_checked = Boolean(frm.doc.checkbox_field);

// Dates (usually keep as string, validate on server)
let date_str = frm.doc.date;  // "2026-02-11"
```

---

## frappe.call Pattern

### Basic API Call

```javascript
frappe.call({
    method: 'app_name.module.api.function_name',
    args: {
        param1: value1,
        param2: value2
    },
    callback: function(r) {
        if (r.message) {
            // Success
            console.log(r.message);
            frappe.msgprint('Operation successful');
        }
    },
    error: function(r) {
        // Error handling
        frappe.msgprint('Operation failed');
    }
});
```

### Call with Freeze Message

```javascript
frappe.call({
    method: 'app.api.long_operation',
    args: { doc_name: frm.doc.name },
    freeze: true,
    freeze_message: __('Processing...'),
    callback: function(r) {
        if (r.message) {
            frm.reload_doc();
        }
    }
});
```

### Call Standard frappe.client Methods

```javascript
// Get document
frappe.call({
    method: 'frappe.client.get',
    args: {
        doctype: 'Customer',
        name: customer_name
    },
    callback: function(r) {
        if (r.message) {
            // r.message is the document
            frm.set_value('customer_group', r.message.customer_group);
        }
    }
});

// Get list
frappe.call({
    method: 'frappe.client.get_list',
    args: {
        doctype: 'Item',
        filters: { item_group: 'Products' },
        fields: ['name', 'item_name', 'standard_rate']
    },
    callback: function(r) {
        if (r.message) {
            // r.message is array of documents
            console.log(r.message);
        }
    }
});

// Get value
frappe.call({
    method: 'frappe.client.get_value',
    args: {
        doctype: 'Company',
        filters: { name: company_name },
        fieldname: ['abbr', 'country']
    },
    callback: function(r) {
        if (r.message) {
            let abbr = r.message.abbr;
            let country = r.message.country;
        }
    }
});
```

---

## Custom Buttons

### Add Custom Buttons

```javascript
frappe.ui.form.on('DocType Name', {
    refresh: function(frm) {
        // Simple button
        frm.add_custom_button(__('Button Label'), function() {
            // Button click logic
            frappe.msgprint('Button clicked');
        });

        // Button with conditional display
        if (!frm.is_new() && frm.doc.status === 'Draft') {
            frm.add_custom_button(__('Submit for Approval'), function() {
                submit_for_approval(frm);
            });
        }

        // Button in a group
        frm.add_custom_button(__('Action 1'), function() {
            // Action 1 logic
        }, __('Actions'));

        frm.add_custom_button(__('Action 2'), function() {
            // Action 2 logic
        }, __('Actions'));

        // Make button primary (highlighted)
        frm.add_custom_button(__('Complete'), function() {
            complete_document(frm);
        }).addClass('btn-primary');
    }
});

function submit_for_approval(frm) {
    frappe.confirm(
        'Submit this document for approval?',
        function() {
            frappe.call({
                method: 'app.api.submit_for_approval',
                args: { doc_name: frm.doc.name },
                callback: function(r) {
                    if (r.message) {
                        frappe.show_alert({
                            message: __('Submitted for approval'),
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

## Field Show/Hide and Enable/Disable

### Field Visibility

```javascript
frappe.ui.form.on('DocType Name', {
    type: function(frm) {
        // Show/hide fields based on type
        if (frm.doc.type === 'Special') {
            frm.set_df_property('special_field', 'hidden', 0);  // Show
            frm.set_df_property('normal_field', 'hidden', 1);   // Hide
        } else {
            frm.set_df_property('special_field', 'hidden', 1);
            frm.set_df_property('normal_field', 'hidden', 0);
        }

        // Refresh field to apply changes
        frm.refresh_field('special_field');
        frm.refresh_field('normal_field');
    }
});
```

### Field Required/Optional

```javascript
frappe.ui.form.on('DocType Name', {
    payment_type: function(frm) {
        // Make field required conditionally
        if (frm.doc.payment_type === 'Credit Card') {
            frm.set_df_property('card_number', 'reqd', 1);
            frm.set_df_property('card_number', 'hidden', 0);
        } else {
            frm.set_df_property('card_number', 'reqd', 0);
            frm.set_df_property('card_number', 'hidden', 1);
        }

        frm.refresh_field('card_number');
    }
});
```

### Field Read-Only

```javascript
frappe.ui.form.on('DocType Name', {
    refresh: function(frm) {
        // Make fields read-only based on status
        if (frm.doc.status === 'Completed') {
            frm.set_df_property('amount', 'read_only', 1);
            frm.set_df_property('date', 'read_only', 1);
        }
    }
});
```

---

## Link Field Filters (set_query)

### Basic Filters

```javascript
frappe.ui.form.on('DocType Name', {
    setup: function(frm) {
        // Filter items by item group
        frm.set_query('item', function() {
            return {
                filters: {
                    item_group: 'Products',
                    disabled: 0
                }
            };
        });

        // Filter based on another field value
        frm.set_query('project', function() {
            return {
                filters: {
                    customer: frm.doc.customer,
                    status: 'Open'
                }
            };
        });
    }
});
```

### Advanced Filters

```javascript
frappe.ui.form.on('DocType Name', {
    setup: function(frm) {
        // Complex filters with OR conditions
        frm.set_query('employee', function() {
            return {
                filters: [
                    ['status', '=', 'Active'],
                    ['department', 'in', ['Sales', 'Marketing']],
                    ['date_of_joining', '<=', frappe.datetime.get_today()]
                ]
            };
        });

        // Custom query (for complex SQL)
        frm.set_query('item', function() {
            return {
                query: 'app.api.get_filtered_items',
                filters: {
                    customer: frm.doc.customer
                }
            };
        });
    }
});
```

---

## Child Table Patterns

### Child Table Events

```javascript
// Parent DocType events
frappe.ui.form.on('DocType Name', {
    refresh: function(frm) {
        // Do something with child table
    }
});

// Child Table events
frappe.ui.form.on('Child Table DocType', {
    // When row is added
    items_add: function(frm, cdt, cdn) {
        let row = locals[cdt][cdn];
        row.quantity = 1;  // Set default
        row.rate = 0;
        frm.refresh_field('items');
    },

    // When row is removed
    items_remove: function(frm) {
        calculate_grand_total(frm);
    },

    // When field in row changes
    quantity: function(frm, cdt, cdn) {
        calculate_row_total(frm, cdt, cdn);
    },

    rate: function(frm, cdt, cdn) {
        calculate_row_total(frm, cdt, cdn);
    }
});

function calculate_row_total(frm, cdt, cdn) {
    let row = locals[cdt][cdn];

    // IMPORTANT: Convert to numbers
    let qty = parseInt(row.quantity) || 0;
    let rate = parseFloat(row.rate) || 0;

    let amount = qty * rate;

    // Set value in child table row
    frappe.model.set_value(cdt, cdn, 'amount', amount);

    // Recalculate parent total
    calculate_grand_total(frm);
}

function calculate_grand_total(frm) {
    let total = 0;

    // Iterate through child table
    frm.doc.items.forEach(function(row) {
        total += parseFloat(row.amount) || 0;
    });

    frm.set_value('grand_total', total);
}
```

---

## Dialog and Prompt Patterns

### Confirmation Dialog

```javascript
frappe.confirm(
    'Are you sure you want to proceed?',
    function() {
        // User clicked Yes
        proceed_with_action(frm);
    },
    function() {
        // User clicked No (optional)
        frappe.msgprint('Action cancelled');
    }
);
```

### Input Prompt

```javascript
frappe.prompt({
    label: 'Reason',
    fieldname: 'reason',
    fieldtype: 'Small Text',
    reqd: 1
}, function(values) {
    // User submitted
    frappe.call({
        method: 'app.api.reject_document',
        args: {
            doc_name: frm.doc.name,
            reason: values.reason
        }
    });
}, __('Enter Rejection Reason'), __('Submit'));
```

### Multi-Field Dialog

```javascript
let dialog = new frappe.ui.Dialog({
    title: 'Enter Details',
    fields: [
        {
            label: 'Date',
            fieldname: 'date',
            fieldtype: 'Date',
            reqd: 1
        },
        {
            label: 'Amount',
            fieldname: 'amount',
            fieldtype: 'Currency',
            reqd: 1
        },
        {
            label: 'Notes',
            fieldname: 'notes',
            fieldtype: 'Small Text'
        }
    ],
    primary_action_label: 'Submit',
    primary_action: function(values) {
        // Process values
        console.log(values.date, values.amount, values.notes);

        frappe.call({
            method: 'app.api.process',
            args: values,
            callback: function(r) {
                dialog.hide();
                frm.reload_doc();
            }
        });
    }
});

dialog.show();
```

---

## Messages and Alerts

### Show Alert (Toast)

```javascript
// Success (green)
frappe.show_alert({
    message: __('Operation completed successfully'),
    indicator: 'green'
}, 5);  // Display for 5 seconds

// Info (blue)
frappe.show_alert({
    message: __('Document updated'),
    indicator: 'blue'
}, 3);

// Warning (orange)
frappe.show_alert({
    message: __('Some items are out of stock'),
    indicator: 'orange'
}, 5);

// Error (red)
frappe.show_alert({
    message: __('Operation failed'),
    indicator: 'red'
}, 5);
```

### Message Box

```javascript
// Simple message
frappe.msgprint(__('Document saved successfully'));

// Message with title
frappe.msgprint({
    title: __('Success'),
    message: __('Document saved successfully'),
    indicator: 'green'
});

// Message with primary action
frappe.msgprint({
    title: __('Approval Required'),
    message: __('This document needs manager approval'),
    indicator: 'orange',
    primary_action: {
        label: 'Request Approval',
        action: function() {
            request_approval(frm);
        }
    }
});
```

---

## Best Practices Summary

### ✅ DO:

1. **Convert form values** to numbers with `parseInt()` or `parseFloat()`
2. **Handle null/undefined** with `|| 0` default
3. **Use frappe.call()** to invoke server methods
4. **Use frm.set_value()** to update form fields
5. **Check for new document** with `frm.is_new()`
6. **Refresh fields** after changing properties with `frm.refresh_field()`
7. **Use set_query** in setup event for link field filters
8. **Keep refresh event fast** - it runs frequently
9. **Use __(text)** for translatable strings
10. **Call server for complex logic** - don't implement on client

### ❌ DON'T:

1. **Put business logic** in client scripts (validations, calculations)
2. **Forget to convert** string form values to numbers
3. **Access database** directly from client
4. **Use frappe.db** in client scripts
5. **Do complex calculations** on client (tax, discounts, totals)
6. **Skip error handling** in frappe.call() callbacks
7. **Modify DOM** directly (use frappe methods instead)
8. **Use console.log()** in production (remove or use frappe.debug.log())
9. **Make blocking API calls** without freeze message
10. **Forget to refresh** form after server calls

---

## Common Pitfalls

### Pitfall 1: String Arithmetic
```javascript
// ❌ WRONG
let total = frm.doc.qty * frm.doc.rate;  // "555" if qty="5", rate="10"

// ✅ CORRECT
let total = parseInt(frm.doc.qty || 0) * parseFloat(frm.doc.rate || 0);
```

### Pitfall 2: Not Refreshing Fields
```javascript
// ❌ WRONG
frm.set_df_property('field', 'hidden', 1);
// Field doesn't hide immediately

// ✅ CORRECT
frm.set_df_property('field', 'hidden', 1);
frm.refresh_field('field');  // Apply change immediately
```

### Pitfall 3: Business Logic on Client
```javascript
// ❌ WRONG: Complex tax calculation on client
let tax = calculate_complex_tax(frm.doc);  // Can be bypassed

// ✅ CORRECT: Call server method
frappe.call({
    method: 'app.api.calculate_tax',
    args: { doc: frm.doc },
    callback: function(r) {
        frm.set_value('tax_amount', r.message);
    }
});
```
