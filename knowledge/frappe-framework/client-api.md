# Client-Side JavaScript API Reference

> Essential Frappe JavaScript APIs for client-side development.

## frappe.call()

### Basic Usage

```javascript
frappe.call({
    method: 'my_app.api.get_data',
    args: {
        filters: {status: 'Open'}
    },
    callback: function(r) {
        if (r.message) {
            console.log(r.message);
        }
    }
});
```

### With Error Handling

```javascript
frappe.call({
    method: 'my_app.api.process_order',
    args: {order_id: 'SO-0001'},
    freeze: true,  // Show loading indicator
    freeze_message: 'Processing...',
    callback: function(r) {
        if (r.message.success) {
            frappe.msgprint('Order processed successfully');
        }
    },
    error: function(r) {
        frappe.msgprint('Error occurred');
    }
});
```

### Async/Await Pattern

```javascript
async function getData() {
    let response = await frappe.call({
        method: 'my_app.api.get_data',
        args: {status: 'Open'}
    });

    if (response.message) {
        return response.message;
    }
}
```

## Form Events

### DocType Controller

```javascript
frappe.ui.form.on('Task', {
    refresh: function(frm) {
        // Runs when form loads/refreshes
        if (frm.doc.status === 'Open') {
            frm.add_custom_button('Complete', () => {
                frm.set_value('status', 'Completed');
                frm.save();
            });
        }
    },

    onload: function(frm) {
        // Runs once when form first loads
        frm.set_query('project', () => {
            return {filters: {status: 'Open'}};
        });
    },

    validate: function(frm) {
        // Runs before save (client-side only!)
        if (frm.doc.exp_end_date < frm.doc.exp_start_date) {
            frappe.msgprint('End date cannot be before start date');
            frappe.validated = false;
        }
    },

    before_save: function(frm) {
        // Runs before save
    },

    after_save: function(frm) {
        // Runs after successful save
        frappe.show_alert({message: 'Task saved', indicator: 'green'});
    }
});
```

### Field Events

```javascript
frappe.ui.form.on('Task', {
    status: function(frm) {
        // Runs when status field changes
        if (frm.doc.status === 'Completed') {
            frm.set_value('completed_date', frappe.datetime.nowdate());
        }
    },

    customer: function(frm) {
        // Auto-fill customer details
        if (frm.doc.customer) {
            frappe.db.get_value('Customer', frm.doc.customer, 'customer_name')
                .then(r => {
                    frm.set_value('customer_name', r.message.customer_name);
                });
        }
    }
});
```

### Child Table Events

```javascript
frappe.ui.form.on('Sales Order Item', {
    qty: function(frm, cdt, cdn) {
        // Runs when qty changes in child table
        let row = locals[cdt][cdn];
        row.amount = row.qty * row.rate;
        frm.refresh_field('items');
    },

    items_add: function(frm, cdt, cdn) {
        // Runs when new row added
        let row = locals[cdt][cdn];
        row.rate = 100;  // Default rate
    },

    items_remove: function(frm, cdt, cdn) {
        // Runs when row removed
        frm.trigger('calculate_total');
    }
});
```

## frappe.db

### Get Value

```javascript
// Get single field
frappe.db.get_value('Customer', 'CUST-001', 'customer_name')
    .then(r => {
        console.log(r.message.customer_name);
    });

// Get multiple fields
frappe.db.get_value('Customer', 'CUST-001', ['customer_name', 'email'])
    .then(r => {
        console.log(r.message);
    });

// Get with filters
frappe.db.get_value('Customer', {is_default: 1}, 'name')
    .then(r => {
        console.log(r.message.name);
    });
```

### Get List

```javascript
// Get list of documents
frappe.db.get_list('Task', {
    fields: ['name', 'subject', 'status'],
    filters: {status: 'Open'},
    limit: 10,
    order_by: 'creation desc'
}).then(r => {
    console.log(r);
});
```

### Get Count

```javascript
frappe.db.count('Task', {filters: {status: 'Open'}})
    .then(count => {
        console.log(`Open tasks: ${count}`);
    });
```

### Get Single

```javascript
// Get single DocType (settings)
frappe.db.get_single('System Settings')
    .then(r => {
        console.log(r);
    });
```

## Form Manipulation

### Set Value

```javascript
// Set single field
frm.set_value('status', 'Completed');

// Set multiple fields
frm.set_value({
    'status': 'Completed',
    'completed_date': frappe.datetime.nowdate()
});

// Set child table row
frappe.model.set_value(cdt, cdn, 'qty', 10);
```

### Get Value

```javascript
// Get field value
let status = frm.doc.status;

// Get child table row value
let row = locals[cdt][cdn];
let qty = row.qty;
```

### Add/Remove Rows

```javascript
// Add child row
let row = frm.add_child('items');
row.item_code = 'ITEM-001';
row.qty = 10;
frm.refresh_field('items');

// Remove child row
frm.get_field('items').grid.grid_rows[idx].remove();
```

### Field Properties

```javascript
// Hide/show field
frm.set_df_property('discount', 'hidden', 1);
frm.set_df_property('discount', 'hidden', 0);

// Make mandatory
frm.set_df_property('customer', 'reqd', 1);

// Make read-only
frm.set_df_property('total', 'read_only', 1);

// Set description
frm.set_df_property('qty', 'description', 'Enter quantity in units');
```

## Buttons

### Custom Buttons

```javascript
// Add button
frm.add_custom_button('Send Email', () => {
    send_email(frm.doc.name);
});

// Add button to group
frm.add_custom_button('Export PDF', () => {
    export_pdf(frm.doc.name);
}, 'Actions');

frm.add_custom_button('Export Excel', () => {
    export_excel(frm.doc.name);
}, 'Actions');
```

### Primary Action

```javascript
// Set primary action button
frm.page.set_primary_action('Submit', () => {
    frm.submit();
}, 'check');

// Clear primary action
frm.page.clear_primary_action();
```

### Inner Buttons

```javascript
// Add button next to form title
frm.page.add_inner_button('Refresh', () => {
    frm.reload_doc();
});
```

## Dialogs

### Simple Dialog

```javascript
frappe.prompt('Enter reason', (values) => {
    console.log(values.reason);
}, 'Reason for cancellation');
```

### Multi-Field Dialog

```javascript
let d = new frappe.ui.Dialog({
    title: 'Enter Details',
    fields: [
        {
            fieldname: 'customer',
            fieldtype: 'Link',
            options: 'Customer',
            label: 'Customer',
            reqd: 1
        },
        {
            fieldname: 'qty',
            fieldtype: 'Int',
            label: 'Quantity',
            default: 1
        }
    ],
    primary_action_label: 'Submit',
    primary_action(values) {
        console.log(values);
        d.hide();
    }
});

d.show();
```

### Confirmation Dialog

```javascript
frappe.confirm(
    'Are you sure you want to delete this item?',
    () => {
        // User clicked yes
        delete_item();
    },
    () => {
        // User clicked no
    }
);
```

## Messages

### Show Message

```javascript
// Simple message
frappe.msgprint('Operation successful');

// Message with title
frappe.msgprint({
    title: 'Success',
    message: 'Order created successfully',
    indicator: 'green'
});
```

### Show Alert

```javascript
// Auto-dismiss alert
frappe.show_alert({
    message: 'Task updated',
    indicator: 'green'
}, 5);  // Dismiss after 5 seconds
```

### Throw Error

```javascript
frappe.throw('Invalid data provided');
```

## Utils

### Date/Time

```javascript
// Current date
let today = frappe.datetime.nowdate();

// Current datetime
let now = frappe.datetime.now_datetime();

// Add days
let future_date = frappe.datetime.add_days('2025-01-01', 7);

// Format date
let formatted = frappe.datetime.str_to_user('2025-01-01');

// Get diff in days
let days = frappe.datetime.get_day_diff('2025-12-31', '2025-01-01');
```

### Format

```javascript
// Format number
let formatted = frappe.format(1000, {fieldtype: 'Currency'});

// Format date
let date_str = frappe.format('2025-01-01', {fieldtype: 'Date'});
```

### Translation

```javascript
// Translate string
let msg = __('Task created successfully');

// With placeholder
let msg = __('Task {0} created', [task_name]);
```

## Query Reports

### Custom Report Script

```javascript
frappe.query_reports['My Report'] = {
    onload: function(report) {
        // Setup on report load
    },

    filters: [
        {
            fieldname: 'status',
            label: __('Status'),
            fieldtype: 'Select',
            options: ['', 'Open', 'Completed'],
            default: 'Open'
        }
    ],

    formatter: function(value, row, column, data, default_formatter) {
        value = default_formatter(value, row, column, data);

        if (column.fieldname === 'status' && data.status === 'Completed') {
            value = `<span class="indicator green">${value}</span>`;
        }

        return value;
    }
};
```

## LocalStorage

### Store Data

```javascript
// Store data
frappe.localstorage.set('my_key', {data: 'value'});

// Get data
let data = frappe.localstorage.get('my_key');

// Remove data
frappe.localstorage.remove('my_key');
```

## Key Rules

- ✅ Use `frappe.call()` for server communication
- ✅ Always add error handlers to API calls
- ✅ Use `frappe.db` for simple queries
- ✅ Validate on server-side, not client-side only
- ✅ Use `frm.set_value()` to update fields
- ✅ Use `frappe.msgprint()` for user messages
- ✅ Use `frappe.show_alert()` for temporary alerts
- ✅ Translate all user-facing strings with `__()`
- ✅ Use `async/await` for cleaner async code
- ✅ Disable buttons during submission
- ❌ Don't filter data client-side (filter server-side)
- ❌ Don't skip error handling on API calls
- ❌ Don't validate only client-side
