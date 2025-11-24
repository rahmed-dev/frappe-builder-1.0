// Copyright (c) {{year}}, {{company}} and contributors
// For license information, please see license.txt

frappe.ui.form.on('{{DocType}}', {
    // Form-level events

    onload: function(frm) {
        // Runs when form is loaded (first time only)
        // Use for: Setting up filters, custom buttons (that depend on form data)
    },

    refresh: function(frm) {
        // Runs every time form is refreshed (load, save, etc.)
        // Use for: Adding custom buttons, showing/hiding fields

        // Example: Add custom button
        if (!frm.is_new() && frm.doc.docstatus === 0) {
            frm.add_custom_button(__('Custom Action'), function() {
                frm.trigger('custom_action');
            });
        }

        // Example: Show/hide fields based on condition
        frm.toggle_display('field_name', frm.doc.status === 'Open');

        // Example: Make field mandatory conditionally
        frm.toggle_reqd('field_name', frm.doc.is_important);

        // Example: Set field as read-only
        frm.set_df_property('field_name', 'read_only', frm.doc.docstatus === 1);
    },

    before_save: function(frm) {
        // Runs before document is saved
        // Use for: Final validations, setting values
    },

    after_save: function(frm) {
        // Runs after document is saved
        // Use for: Showing messages, triggering workflows
        frappe.show_alert({
            message: __('Document saved successfully'),
            indicator: 'green'
        }, 3);
    },

    validate: function(frm) {
        // Runs during validation (before save)
        // Use for: Client-side validations
        if (frm.doc.total < 0) {
            frappe.throw(__('Total cannot be negative'));
        }
    },

    // Field-level events

    customer: function(frm) {
        // Runs when customer field changes
        // Use for: Fetching related data, updating dependent fields

        if (frm.doc.customer) {
            // Fetch customer details
            frappe.call({
                method: '{{app_name}}.{{module_name}}.doctype.{{doctype_name}}.{{doctype_name}}.get_customer_details',
                args: {
                    customer: frm.doc.customer
                },
                callback: function(r) {
                    if (r.message) {
                        frm.set_value('customer_name', r.message.customer_name);
                        frm.set_value('customer_group', r.message.customer_group);
                        frm.set_value('territory', r.message.territory);
                        frm.refresh_field('customer_name');
                    }
                }
            });
        }
    },

    date: function(frm) {
        // Validate date
        if (frm.doc.date && frm.doc.date < frappe.datetime.get_today()) {
            frappe.msgprint(__('Selected date is in the past'));
        }
    },

    total: function(frm) {
        // Calculate grand total when total changes
        frm.trigger('calculate_grand_total');
    },

    // Custom methods

    calculate_grand_total: function(frm) {
        // Calculate grand total
        let total = flt(frm.doc.total);
        let tax = total * 0.1;
        let grand_total = total + tax;

        frm.set_value('tax', tax);
        frm.set_value('grand_total', grand_total);
    },

    custom_action: function(frm) {
        // Custom button action
        frappe.confirm(
            __('Are you sure you want to proceed?'),
            function() {
                // User confirmed
                frappe.call({
                    method: '{{app_name}}.{{module_name}}.doctype.{{doctype_name}}.{{doctype_name}}.custom_method',
                    args: {
                        name: frm.doc.name
                    },
                    callback: function(r) {
                        if (!r.exc) {
                            frappe.show_alert({
                                message: __('Action completed'),
                                indicator: 'green'
                            });
                            frm.reload_doc();
                        }
                    }
                });
            }
        );
    }
});

// Child table events

frappe.ui.form.on('{{Child DocType}}', {
    // Runs when child table is refreshed
    items_add: function(frm, cdt, cdn) {
        // Runs when new row is added to child table
        let row = locals[cdt][cdn];
        row.qty = 1;  // Set default quantity
    },

    item_code: function(frm, cdt, cdn) {
        // Runs when item_code changes in child table
        let row = locals[cdt][cdn];

        if (row.item_code) {
            // Fetch item details
            frappe.call({
                method: 'erpnext.stock.get_item_details.get_item_details',
                args: {
                    item_code: row.item_code,
                    company: frm.doc.company
                },
                callback: function(r) {
                    if (r.message) {
                        frappe.model.set_value(cdt, cdn, 'item_name', r.message.item_name);
                        frappe.model.set_value(cdt, cdn, 'rate', r.message.price_list_rate);
                        frm.trigger('calculate_item_amount', cdt, cdn);
                    }
                }
            });
        }
    },

    qty: function(frm, cdt, cdn) {
        // Calculate amount when quantity changes
        frm.trigger('calculate_item_amount', cdt, cdn);
    },

    rate: function(frm, cdt, cdn) {
        // Calculate amount when rate changes
        frm.trigger('calculate_item_amount', cdt, cdn);
    },

    calculate_item_amount: function(frm, cdt, cdn) {
        // Calculate line item amount
        let row = locals[cdt][cdn];
        let amount = flt(row.qty) * flt(row.rate);
        frappe.model.set_value(cdt, cdn, 'amount', amount);

        // Recalculate form total
        frm.trigger('calculate_totals');
    },

    items_remove: function(frm, cdt, cdn) {
        // Runs when row is removed from child table
        frm.trigger('calculate_totals');
    },

    calculate_totals: function(frm) {
        // Calculate total from all child table rows
        let total = 0;
        $.each(frm.doc.items || [], function(i, item) {
            total += flt(item.amount);
        });

        frm.set_value('total', total);
        frm.trigger('calculate_grand_total');
    }
});

// Helper functions

function show_custom_dialog(frm) {
    // Example custom dialog
    let d = new frappe.ui.Dialog({
        title: __('Enter Details'),
        fields: [
            {
                fieldname: 'field1',
                fieldtype: 'Data',
                label: __('Field 1'),
                reqd: 1
            },
            {
                fieldname: 'field2',
                fieldtype: 'Int',
                label: __('Field 2'),
                default: 1
            },
            {
                fieldname: 'field3',
                fieldtype: 'Link',
                label: __('Field 3'),
                options: 'Customer'
            }
        ],
        primary_action_label: __('Submit'),
        primary_action: function(values) {
            // Process dialog values
            console.log(values);
            d.hide();

            // Update form
            frm.set_value('field1', values.field1);
            frm.save();
        }
    });
    d.show();
}

function debounce_search(frm, field_name, callback) {
    // Debounce field for search
    let timeout;
    frm.fields_dict[field_name].$input.on('input', function() {
        clearTimeout(timeout);
        timeout = setTimeout(function() {
            callback(frm.doc[field_name]);
        }, 300);  // Wait 300ms after last keystroke
    });
}
