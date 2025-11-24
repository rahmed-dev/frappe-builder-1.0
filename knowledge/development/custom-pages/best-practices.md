# Custom Frappe Pages - Best Practices

> **Standards:** Load `coding-principles.md` first. This file = Custom Pages specifics.

## What is a Custom Page?

Full-page UI component for custom interfaces beyond standard DocType forms.

**Use Cases:**
- Custom dashboards (shop floor, executive)
- Specialized workflows (quick entry)
- Data visualization
- Kiosk mode displays

**NOT for:**
- Standard forms (use Customize Form)
- Simple reports (use Script Report)
- Form modifications (use Client Scripts)

## File Structure

```
my_app/my_app/page/my_custom_page/
├── my_custom_page.json   # Page definition
├── my_custom_page.js     # Client logic
├── my_custom_page.py     # Server controller (optional)
└── my_custom_page.html   # Template (optional)
```

## Creating Pages

### CLI (Recommended)

```bash
bench new-page "My Custom Page"
bench --site site-name migrate
bench build --app my_app
bench --site site-name clear-cache
bench restart
```

### JSON Configuration

```json
{
 "name": "my-custom-page",
 "page_name": "My Custom Page",
 "title": "My Custom Page",
 "module": "My App",
 "standard": "Yes",
 "roles": [
  {"role": "System Manager"},
  {"role": "Manufacturing User"}
 ]
}
```

## JavaScript Pattern

```javascript
frappe.pages['my-custom-page'].on_page_load = function(wrapper) {
    // CRITICAL: Load page-specific CSS
    frappe.require('/assets/my_app/css/my_page.css');

    var page = frappe.ui.make_app_page({
        parent: wrapper,
        title: __('My Custom Page'),
        single_column: true
    });

    new MyCustomPage(page);
};

class MyCustomPage {
    constructor(page) {
        this.page = page;
        this.setup();
    }

    setup() {
        this.setup_toolbar();
        this.setup_ui();
        this.load_data();
    }

    setup_toolbar() {
        this.page.add_inner_button(__('Refresh'), () => {
            this.load_data();
        });
    }

    setup_ui() {
        this.$container = $('<div class="custom-page-container">')
            .appendTo(this.page.main);
    }

    load_data() {
        frappe.call({
            method: 'my_app.my_app.page.my_custom_page.get_data',
            callback: (r) => {
                if (r.message) {
                    this.render(r.message);
                }
            }
        });
    }

    render(data) {
        this.$container.html(`<div>${data}</div>`);
    }
}
```

## Python Controller

```python
import frappe

@frappe.whitelist()
def get_data(filters=None):
    """Get data for page"""
    if not frappe.has_permission('DocType', 'read'):
        frappe.throw('No permission')

    if isinstance(filters, str):
        filters = frappe.parse_json(filters)

    data = frappe.get_all(
        'DocType',
        filters=filters,
        fields=['name', 'field1']
    )
    return data

@frappe.whitelist()
def perform_action(name, action):
    """Action handler"""
    doc = frappe.get_doc('DocType', name)

    if not frappe.has_permission('DocType', 'write', doc):
        frappe.throw('No permission')

    doc.status = action
    doc.save()

    return {'success': True}
```

## CSS Scoping (CRITICAL)

**❌ WRONG - Pollutes global styles:**
```css
.container { padding: 20px; }
.btn { min-height: 48px; }
```

**✅ CORRECT - Scoped to page:**
```css
.page-my-custom-page .container { padding: 20px; }
.page-my-custom-page .btn-custom { min-height: 48px; }
```

**Load CSS on page load:**
```javascript
frappe.pages['my-custom-page'].on_page_load = function(wrapper) {
    frappe.require('/assets/my_app/css/my_page.css');
};
```

## Common Patterns

### Dashboard with Cards

```javascript
load_summary() {
    frappe.call({
        method: 'my_app.api.get_summary',
        callback: (r) => {
            r.message.forEach(item => {
                const card = $(`
                    <div class="summary-card">
                        <h4>${item.title}</h4>
                        <div class="value">${item.count}</div>
                    </div>
                `);
                this.$summary.append(card);
            });
        }
    });
}
```

### List with Filters

```javascript
setup_filters() {
    this.page.add_field({
        fieldname: 'status',
        fieldtype: 'Select',
        options: ['All', 'Open', 'Closed'],
        change: () => { this.load_data(); }
    });
}

load_data() {
    const filters = {
        status: this.page.fields_dict.status.get_value()
    };

    frappe.call({
        method: 'my_app.api.get_filtered_data',
        args: { filters: filters },
        callback: (r) => { this.render_list(r.message); }
    });
}
```

### Action Dialog

```javascript
show_action_dialog(item_name) {
    let d = new frappe.ui.Dialog({
        title: __('Action: {0}', [item_name]),
        fields: [
            {fieldname: 'action', fieldtype: 'Select', options: 'Approve\nReject'}
        ],
        primary_action: (values) => {
            // Prevent duplicates
            d.get_primary_btn().prop('disabled', true);

            frappe.call({
                method: 'my_app.api.perform_action',
                args: {name: item_name, action: values.action},
                callback: (r) => {
                    if (r.message.success) {
                        d.hide();
                        this.load_data();
                    }
                },
                error: () => {
                    d.get_primary_btn().prop('disabled', false);
                }
            });
        }
    });
    d.show();
}
```

## Frappe UI Components

### frappe.ui.Tree

```javascript
this.tree = new frappe.ui.Tree({
    parent: $(this.page.main),
    label: __('Items'),
    method: 'my_app.api.get_tree_nodes',
    on_click: (node) => {
        if (!node.expandable) {
            this.show_action_dialog(node.data.value);
        }
    }
});
```

### frappe.ui.Dialog

```javascript
let d = new frappe.ui.Dialog({
    title: __('Enter Details'),
    size: 'large',
    fields: [
        {fieldname: 'name', fieldtype: 'Data', reqd: 1},
        {fieldname: 'qty', fieldtype: 'Int', default: 1}
    ],
    primary_action_label: __('Submit'),
    primary_action: (values) => {
        d.get_primary_btn().prop('disabled', true);
        frappe.call({
            method: 'my_app.api.process',
            args: values,
            callback: (r) => {
                if (r.message.success) d.hide();
            }
        });
    }
});
d.show();
```

### frappe.ui.FieldGroup

```javascript
this.form = new frappe.ui.FieldGroup({
    parent: this.$form_wrapper,
    fields: [
        {fieldname: 'item', fieldtype: 'Link', options: 'Item'},
        {fieldname: 'qty', fieldtype: 'Int'}
    ]
});
this.form.make();

// Get values
let values = this.form.get_values();

// Set values
this.form.set_value('qty', 10);
```

## Page Toolbar

```javascript
// Primary action
this.page.set_primary_action(__('Create New'), () => {
    this.create_new();
}, 'add');

// Inner buttons (grouped)
this.page.add_inner_button(__('Refresh'), () => {
    this.load_data();
});

this.page.add_inner_button(__('Export CSV'), () => {
    this.export_csv();
}, __('Actions'));

// Menu items
this.page.add_menu_item(__('Settings'), () => {
    this.open_settings();
});
```

## Performance

### Lazy Loading

```javascript
load_data() {
    this.page.set_indicator(__('Loading...'), 'orange');

    frappe.call({
        method: 'my_app.api.get_data',
        callback: (r) => {
            this.render(r.message);
            this.page.clear_indicator();
        }
    });
}
```

### Debounced Search

```javascript
setup_search() {
    let timeout;
    this.page.add_field({
        fieldname: 'search',
        fieldtype: 'Data',
        placeholder: __('Search...'),
        change: () => {
            clearTimeout(timeout);
            timeout = setTimeout(() => {
                this.load_data();
            }, 300);
        }
    });
}
```

## Key Rules

- ✅ ALWAYS scope CSS to `.page-{name}`
- ✅ ALWAYS load CSS with `frappe.require()` on page load
- ✅ NEVER use `app_include_css` for page CSS
- ✅ ALWAYS check permissions before data operations
- ✅ ALWAYS disable submit buttons to prevent duplicates
- ✅ ALWAYS add error handlers to `frappe.call()`
- ✅ ALWAYS filter data server-side, not client-side
- ✅ Use Frappe UI components (Tree, Dialog, FieldGroup)

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Using `app_include_css` | Load with `frappe.require()` |
| Not scoping CSS | Prefix all selectors with `.page-{name}` |
| No permission checks | Check before data operations |
| Client-side filtering | Filter in Python execute() |
| Not disabling submit | Disable button on submit |
