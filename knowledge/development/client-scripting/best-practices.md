# Client-Side JavaScript Best Practices

## Core Rules

1. Client-side for UI ONLY - never filter/process data
2. Minimalist - no emojis, no decorative CSS
3. Always add error handler to frappe.call()
4. Disable submit buttons to prevent duplicates

## frappe.call() Pattern

```javascript
frappe.call({
    method: 'app.api.method',
    args: {param: value},
    freeze: true,
    freeze_message: __('Processing...'),
    callback: function(r) {
        if (r.message && r.message.success) {
            frappe.msgprint(__('Success'));
            frm.reload_doc();
        }
    },
    error: function(r) {
        frappe.msgprint({
            title: __('Error'),
            message: r.message || __('Failed'),
            indicator: 'red'
        });
    }
});
```

## Dialog with Duplicate Prevention

```javascript
let d = new frappe.ui.Dialog({
    title: __('Title'),
    fields: [{
        fieldname: 'field',
        fieldtype: 'Data',
        reqd: 1
    }],
    primary_action_label: __('Submit'),
    primary_action(values) {
        // Disable button immediately
        d.get_primary_btn().prop('disabled', true);

        frappe.call({
            method: 'app.method',
            args: values,
            callback: function(r) {
                if (r.message.success) {
                    d.hide();
                    frm.reload_doc();
                }
            },
            error: function(r) {
                // Re-enable on error for retry
                d.get_primary_btn().prop('disabled', false);
            }
        });
    }
});
d.show();
```

## Dynamic Dialog Fields

```javascript
let d = new frappe.ui.Dialog({
    title: __('Settings'),
    fields: [
        {
            fieldname: 'calculation_method',
            fieldtype: 'Select',
            label: __('Method'),
            options: 'By Installments\nBy Amount',
            onchange: function() {
                let method = d.get_value('calculation_method');
                if (method === 'By Installments') {
                    d.set_df_property('installments', 'hidden', 0);
                    d.set_df_property('amount', 'hidden', 1);
                } else {
                    d.set_df_property('installments', 'hidden', 1);
                    d.set_df_property('amount', 'hidden', 0);
                }
            }
        },
        {fieldname: 'installments', fieldtype: 'Int', label: __('Installments')},
        {fieldname: 'amount', fieldtype: 'Currency', label: __('Amount'), hidden: 1}
    ]
});
d.show();
```

## Dialog Field Manipulation

| Operation | Method |
|-----------|--------|
| Get value | `d.get_value('fieldname')` |
| Set value | `d.set_value('fieldname', 'value')` |
| Show/hide | `d.set_df_property('fieldname', 'hidden', 0/1)` |
| Enable/disable | `d.set_df_property('fieldname', 'read_only', 0/1)` |
| Make required | `d.set_df_property('fieldname', 'reqd', 0/1)` |
| Access input | `d.fields_dict.fieldname.$input.on('change', fn)` |
| Get all values | `d.get_values()` |

## Common Field Types

| Type | Use Case |
|------|----------|
| Data | Short text |
| Text | Multi-line text |
| Int | Integer number |
| Float | Decimal number |
| Currency | Money amount |
| Date | Date picker |
| Datetime | Date + time |
| Select | Dropdown (options with `\n`) |
| Check | Checkbox |
| Link | Link to DocType |
| Table | Child table |
| HTML | Custom HTML area |
| Section Break | Start new section |
| Column Break | Start new column |

## CSS Scoping (CRITICAL)

### ❌ NEVER: Global CSS Pollution

```python
# hooks.py - DON'T DO THIS
app_include_css = "/assets/my_app/css/page.css"  # ❌ Affects entire ERPNext!
```

### ✅ CORRECT: Page-Specific CSS

**Method 1: Load on page load**
```javascript
// my_page.js
frappe.pages['my-page'].on_page_load = function(wrapper) {
    frappe.require('/assets/my_app/css/my_page.css');
    // ... rest of page code
};
```

**Method 2: Scope all selectors**
```css
/* my_page.css - scope to page class */
.page-my-custom-page .container { padding: 20px; }
.page-my-custom-page .card { background: white; }
```

**Frappe page classes:**
- `/app/shop-floor` → `.page-shop-floor`
- `/app/my-page` → `.page-my-page`

## What NOT to Do

❌ **No custom HTML/CSS for controls:**
```javascript
// BAD - Custom HTML
let html = `<div><input type="checkbox"> Label</div>`;

// GOOD - Frappe field
fields: [{fieldname: 'check', fieldtype: 'Check', label: __('Label')}]
```

❌ **No client-side filtering:**
```javascript
// BAD
data = data.filter(d => d.status === "Open");
```

❌ **No decorative CSS:**
```css
/* BAD */
.badge { border-radius: 9999px; }
```

❌ **No jQuery when Frappe has methods:**
```javascript
// BAD
$('#field').hide();

// GOOD
d.set_df_property('field', 'hidden', 1);
```

## Utilities

```javascript
// Currency formatting
format_currency(amount);

// Get single field
frappe.db.get_single_value('Settings', 'field').then(value => {...});

// Event delegation (dynamic elements)
$(document).on('click', '.btn', function() {
    const id = $(this).data('id');
});
```

## Key Rules

- **CRITICAL: NEVER use `app_include_css` for page-specific styles**
- **ALWAYS scope CSS to page class**
- **ALWAYS load page CSS with `frappe.require()`**
- **ALWAYS use Frappe native components** - no custom HTML/CSS for controls
- Use `d.set_df_property()` to show/hide/enable fields
- Wrap strings in `__()` for translation
- Always add error handler to `frappe.call()`
- Disable buttons during submission
- Never process/filter data client-side
- No emojis, no decorative CSS
- Use Section/Column Break for layout
