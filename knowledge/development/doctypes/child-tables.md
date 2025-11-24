# Child Table Patterns

> Working with one-to-many relationships using child tables.

## Child Table Basics

**Parent-Child Relationship:**
- Parent: Main document (e.g., Sales Order)
- Child: Line items (e.g., Sales Order Item)

**Example:**
```
Sales Order (Parent)
├── Sales Order Item 1 (Child)
├── Sales Order Item 2 (Child)
└── Sales Order Item 3 (Child)
```

## Creating Child DocTypes

### Child DocType Definition

```python
# Child DocType: Sales Order Item
{
    "doctype": "DocType",
    "name": "Sales Order Item",
    "is_child": 1,           # Mark as child table
    "istable": 1,            # Is a table
    "editable_grid": 1,      # Editable in grid
    "fields": [
        {
            "fieldname": "item_code",
            "fieldtype": "Link",
            "options": "Item",
            "in_list_view": 1,
            "reqd": 1
        },
        {
            "fieldname": "qty",
            "fieldtype": "Float",
            "in_list_view": 1,
            "reqd": 1
        },
        {
            "fieldname": "rate",
            "fieldtype": "Currency",
            "in_list_view": 1
        },
        {
            "fieldname": "amount",
            "fieldtype": "Currency",
            "in_list_view": 1,
            "read_only": 1
        }
    ]
}
```

### Parent Table Field

```python
# Parent DocType: Sales Order
{
    "fieldname": "items",
    "fieldtype": "Table",
    "label": "Items",
    "options": "Sales Order Item"  # Child DocType name
}
```

## Adding Child Rows

### Python (Server-Side)

```python
# Method 1: append()
doc = frappe.get_doc('Sales Order', 'SO-0001')
doc.append('items', {
    'item_code': 'ITEM-001',
    'qty': 10,
    'rate': 100,
    'amount': 1000
})
doc.save()

# Method 2: Direct list manipulation
doc.items.append(frappe._dict({
    'item_code': 'ITEM-002',
    'qty': 5,
    'rate': 200
}))
doc.save()

# Method 3: get_doc with items
doc = frappe.get_doc({
    'doctype': 'Sales Order',
    'customer': 'CUST-001',
    'items': [
        {'item_code': 'ITEM-001', 'qty': 10, 'rate': 100},
        {'item_code': 'ITEM-002', 'qty': 5, 'rate': 200}
    ]
})
doc.insert()
```

### JavaScript (Client-Side)

```javascript
// Add child row
frappe.ui.form.on('Sales Order', {
    add_item: function(frm) {
        let row = frm.add_child('items');
        row.item_code = 'ITEM-001';
        row.qty = 1;
        frm.refresh_field('items');
    }
});

// Add via dialog
frappe.ui.form.on('Sales Order', {
    add_item_button: function(frm) {
        let d = new frappe.ui.Dialog({
            title: 'Add Item',
            fields: [
                {fieldname: 'item_code', fieldtype: 'Link', options: 'Item'},
                {fieldname: 'qty', fieldtype: 'Int'}
            ],
            primary_action: function(values) {
                let row = frm.add_child('items');
                row.item_code = values.item_code;
                row.qty = values.qty;
                frm.refresh_field('items');
                d.hide();
            }
        });
        d.show();
    }
});
```

## Updating Child Rows

### Python

```python
doc = frappe.get_doc('Sales Order', 'SO-0001')

# Update specific row
for item in doc.items:
    if item.item_code == 'ITEM-001':
        item.qty = 20
        item.amount = item.qty * item.rate

doc.save()

# Update by index
doc.items[0].qty = 15
doc.save()

# Update all rows
for item in doc.items:
    item.discount_percentage = 10
    item.amount = item.qty * item.rate * (1 - item.discount_percentage / 100)

doc.save()
```

### JavaScript

```javascript
frappe.ui.form.on('Sales Order Item', {
    qty: function(frm, cdt, cdn) {
        // Access child row
        let row = locals[cdt][cdn];

        // Calculate amount
        row.amount = row.qty * row.rate;

        // Refresh field
        frm.refresh_field('items');
    },

    rate: function(frm, cdt, cdn) {
        let row = locals[cdt][cdn];
        row.amount = row.qty * row.rate;
        frm.refresh_field('items');
    }
});
```

## Deleting Child Rows

### Python

```python
doc = frappe.get_doc('Sales Order', 'SO-0001')

# Remove specific row
doc.items = [item for item in doc.items if item.item_code != 'ITEM-001']
doc.save()

# Remove by index
doc.items.pop(0)  # Remove first row
doc.save()

# Clear all rows
doc.items = []
doc.save()

# Remove rows matching condition
doc.items = [item for item in doc.items if item.qty > 0]
doc.save()
```

### JavaScript

```javascript
// Remove specific row
frappe.ui.form.on('Sales Order Item', {
    items_remove: function(frm, cdt, cdn) {
        // Triggered when row is removed
        frm.trigger('calculate_total');
    }
});

// Remove programmatically
frm.get_field('items').grid.grid_rows[0].remove();

// Remove all rows
frm.clear_table('items');
frm.refresh_field('items');
```

## Accessing Child Data

### Python

```python
doc = frappe.get_doc('Sales Order', 'SO-0001')

# Iterate rows
for item in doc.items:
    print(f'{item.item_code}: {item.qty}')

# Get specific field values
item_codes = [item.item_code for item in doc.items]

# Sum values
total_qty = sum(item.qty for item in doc.items)
total_amount = sum(item.amount for item in doc.items)

# Filter rows
high_value_items = [item for item in doc.items if item.amount > 1000]

# Find specific row
item = next((item for item in doc.items if item.item_code == 'ITEM-001'), None)

# Get row by index
first_item = doc.items[0] if doc.items else None
```

### JavaScript

```javascript
// Access all rows
frm.doc.items.forEach(function(item) {
    console.log(item.item_code, item.qty);
});

// Sum values
let total = 0;
frm.doc.items.forEach(function(item) {
    total += item.amount;
});

// Find row
let item = frm.doc.items.find(d => d.item_code === 'ITEM-001');

// Filter rows
let high_value = frm.doc.items.filter(d => d.amount > 1000);
```

## Validation

### Child Row Validation

```python
class SalesOrder(Document):
    def validate(self):
        # Validate child table not empty
        if not self.items:
            frappe.throw('Please add at least one item')

        # Validate each row
        for item in self.items:
            if item.qty <= 0:
                frappe.throw(f'Row {item.idx}: Qty must be positive')

            if item.rate < 0:
                frappe.throw(f'Row {item.idx}: Rate cannot be negative')

            # Recalculate amount
            item.amount = item.qty * item.rate

        # Validate no duplicates
        item_codes = [item.item_code for item in self.items]
        if len(item_codes) != len(set(item_codes)):
            frappe.throw('Duplicate items not allowed')
```

### Client-Side Validation

```javascript
frappe.ui.form.on('Sales Order', {
    validate: function(frm) {
        // Check if items exist
        if (!frm.doc.items || frm.doc.items.length === 0) {
            frappe.msgprint('Please add at least one item');
            frappe.validated = false;
        }

        // Validate each row
        frm.doc.items.forEach(function(item, idx) {
            if (item.qty <= 0) {
                frappe.msgprint(`Row ${idx + 1}: Qty must be positive`);
                frappe.validated = false;
            }
        });
    }
});
```

## Calculations

### Row-Level Calculations

```python
def validate(self):
    for item in self.items:
        # Calculate amount
        item.amount = item.qty * item.rate

        # Apply discount
        if item.discount_percentage:
            item.discount_amount = item.amount * item.discount_percentage / 100
            item.amount = item.amount - item.discount_amount

        # Add tax
        if item.tax_rate:
            item.tax_amount = item.amount * item.tax_rate / 100
            item.amount = item.amount + item.tax_amount
```

### Document-Level Totals

```python
def validate(self):
    # Calculate row amounts
    for item in self.items:
        item.amount = item.qty * item.rate

    # Calculate totals
    self.total_qty = sum(item.qty for item in self.items)
    self.total = sum(item.amount for item in self.items)

    # Apply document-level discount
    if self.discount_percentage:
        self.discount_amount = self.total * self.discount_percentage / 100
        self.grand_total = self.total - self.discount_amount
    else:
        self.grand_total = self.total
```

## Grid Customization

### JavaScript Grid Events

```javascript
frappe.ui.form.on('Sales Order Item', {
    // When row is added
    items_add: function(frm, cdt, cdn) {
        let row = locals[cdt][cdn];
        row.rate = 0;  // Set default
    },

    // When row is removed
    items_remove: function(frm, cdt, cdn) {
        frm.trigger('calculate_total');
    },

    // When field changes
    item_code: function(frm, cdt, cdn) {
        let row = locals[cdt][cdn];

        // Fetch item details
        if (row.item_code) {
            frappe.db.get_value('Item', row.item_code, ['standard_rate', 'uom'])
                .then(r => {
                    frappe.model.set_value(cdt, cdn, 'rate', r.message.standard_rate);
                    frappe.model.set_value(cdt, cdn, 'uom', r.message.uom);
                });
        }
    },

    // Before row is displayed
    form_render: function(frm, cdt, cdn) {
        let row = locals[cdt][cdn];
        // Custom rendering logic
    }
});
```

### Grid Buttons

```javascript
frappe.ui.form.on('Sales Order', {
    refresh: function(frm) {
        // Add button to each row
        frm.fields_dict.items.grid.add_custom_button('Get Rate', function(grid_row) {
            let item = grid_row.doc;
            fetch_item_rate(item.item_code).then(rate => {
                frappe.model.set_value(item.doctype, item.name, 'rate', rate);
            });
        });
    }
});
```

## Auto-Fetch Pattern

```python
# Child DocType field definition
{
    "fieldname": "item_name",
    "fieldtype": "Data",
    "fetch_from": "item_code.item_name",
    "fetch_if_empty": 1,
    "read_only": 1
}
```

```javascript
// Or manually in client script
frappe.ui.form.on('Sales Order Item', {
    item_code: function(frm, cdt, cdn) {
        let row = locals[cdt][cdn];

        if (row.item_code) {
            frappe.call({
                method: 'frappe.client.get_value',
                args: {
                    doctype: 'Item',
                    filters: {name: row.item_code},
                    fieldname: ['item_name', 'standard_rate', 'uom']
                },
                callback: function(r) {
                    if (r.message) {
                        frappe.model.set_value(cdt, cdn, 'item_name', r.message.item_name);
                        frappe.model.set_value(cdt, cdn, 'rate', r.message.standard_rate);
                        frappe.model.set_value(cdt, cdn, 'uom', r.message.uom);
                    }
                }
            });
        }
    }
});
```

## Performance Tips

### Efficient Iteration

```python
# Good - single loop
def calculate_totals(self):
    total = 0
    total_qty = 0

    for item in self.items:
        item.amount = item.qty * item.rate
        total += item.amount
        total_qty += item.qty

    self.total = total
    self.total_qty = total_qty

# Bad - multiple loops
def calculate_totals(self):
    for item in self.items:
        item.amount = item.qty * item.rate

    self.total = sum(item.amount for item in self.items)
    self.total_qty = sum(item.qty for item in self.items)
```

### Batch Updates

```python
# Good - batch update
frappe.db.sql("""
    UPDATE `tabSales Order Item`
    SET processed = 1
    WHERE parent = %(parent)s
""", {'parent': 'SO-0001'})

# Bad - row by row
for item in doc.items:
    frappe.db.set_value('Sales Order Item', item.name, 'processed', 1)
```

## Key Rules

- ✅ Set `is_child: 1` and `istable: 1` on child DocType
- ✅ Use `in_list_view: 1` for important child fields
- ✅ Calculate row amounts in validate()
- ✅ Validate child table is not empty
- ✅ Use `frm.refresh_field('items')` after changes
- ✅ Access child rows via `locals[cdt][cdn]` in JS
- ✅ Use `frappe.model.set_value()` for child field updates
- ✅ Handle empty child table gracefully
- ✅ Validate unique values if needed
- ✅ Use efficient loops for calculations
- ❌ Don't skip child row validation
- ❌ Don't modify child rows without saving parent
- ❌ Don't forget to refresh grid after changes
