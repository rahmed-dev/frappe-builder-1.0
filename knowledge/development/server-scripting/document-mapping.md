# Document Mapping Pattern: Creating Related Documents

## Overview

When creating a new document from an existing document (e.g., Stock Entry from Sales Order, Delivery Note from Sales Order), use Frappe's **`get_mapped_doc()`** utility instead of manually creating and populating fields.

## Why Use `get_mapped_doc()`?

**Problems with Manual Approach:**
- ❌ Missing mandatory fields (conversion_factor, stock_uom, etc.)
- ❌ Incorrect UOM conversions
- ❌ No automatic field calculations
- ❌ Lots of boilerplate code
- ❌ Error-prone and hard to maintain

**Benefits of `get_mapped_doc()`:**
- ✅ Auto-fetches all mandatory fields
- ✅ Handles UOM conversions automatically
- ✅ Calculates derived fields (transfer_qty, etc.)
- ✅ Validates source document
- ✅ Clean, maintainable code
- ✅ Standard Frappe/ERPNext pattern

## Standard Pattern

### Server-Side Implementation

```python
# -*- coding: utf-8 -*-
import frappe
from frappe import _
from frappe.model.mapper import get_mapped_doc

@frappe.whitelist()
def create_target_doc_from_source(source_name, target_doc=None):
    """Create Target Document from Source Document.

    Args:
        source_name (str): Source document name
        target_doc: Optional existing target document

    Returns:
        Document: Target document (unsaved)
    """

    def set_missing_values(source, target):
        """Set custom fields and default values.

        Called once after mapping is complete.
        Use this to set header-level custom fields.
        """
        target.custom_field_1 = source.some_field
        target.custom_field_2 = "Default Value"
        # Set any other header fields here

    def update_item(source_item, target_item, source_parent):
        """Update each item after mapping.

        Called for each child table row.
        Use this to set item-level custom fields or calculations.
        """
        # Example: Set custom field from parent
        target_item.custom_field = source_parent.some_value

        # Example: Calculate custom quantity
        target_item.custom_qty = source_item.qty * 2

    # Map source document to target document
    doc = get_mapped_doc(
        "Source DocType",           # Source doctype name
        source_name,                # Source document name
        {
            "Source DocType": {     # Map header fields
                "doctype": "Target DocType",
                "validation": {
                    "docstatus": ["=", 1]  # Validate source is submitted
                }
            },
            "Source Item Table": {  # Map child table
                "doctype": "Target Item Table",
                "field_map": {
                    # Map specific fields (optional)
                    "source_field": "target_field",
                    "qty": "quantity"
                },
                "condition": lambda item: item.some_field > 0,  # Filter items
                "postprocess": update_item  # Called for each item
            }
        },
        target_doc,                 # Optional existing target doc
        set_missing_values          # Called after mapping
    )

    return doc
```

### Client-Side Implementation

```javascript
// Add button to source document form
frappe.ui.form.on('Source DocType', {
    refresh: function(frm) {
        if (frm.doc.docstatus === 1) {
            frm.add_custom_button(__('Create Target Doc'), function() {
                // Use Frappe's standard open_mapped_doc
                frappe.model.open_mapped_doc({
                    method: 'your_app.module.file.create_target_doc_from_source',
                    frm: frm
                });
            });
        }
    }
});
```

## Real-World Example: Stock Entry from Sales Order

### Requirement
Create a Material Receipt Stock Entry from a Sales Order with:
- Pre-filled header fields
- Only stock items (skip services)
- All mandatory fields properly set
- User selects warehouse before saving

### Server-Side (`sales_order.py`)

```python
# -*- coding: utf-8 -*-
import frappe
from frappe import _
from frappe.utils import today
from frappe.model.mapper import get_mapped_doc

@frappe.whitelist()
def create_material_receipt_from_sales_order(source_name, target_doc=None):
    """Create Material Receipt Stock Entry from Sales Order.

    Uses get_mapped_doc for proper field mapping including:
    - conversion_factor
    - stock_uom
    - transfer_qty
    - All other mandatory fields
    """

    def set_missing_values(source, target):
        """Set Stock Entry header fields."""
        target.stock_entry_type = "Material Receipt"
        target.posting_date = today()
        target.custom_customer_sales_order_number = source.name
        target.custom_customer_name__cpi = source.customer_name
        target.custom_subcontracted_order = 1

    def update_item(source_item, target_item, source_parent):
        """Additional item processing if needed."""
        # conversion_factor, stock_uom, transfer_qty are auto-set
        pass

    doc = get_mapped_doc(
        "Sales Order",
        source_name,
        {
            "Sales Order": {
                "doctype": "Stock Entry",
                "validation": {
                    "docstatus": ["=", 1]  # Must be submitted
                }
            },
            "Sales Order Item": {
                "doctype": "Stock Entry Detail",
                "field_map": {
                    "uom": "uom",
                    "stock_uom": "stock_uom"
                },
                # Only include stock items
                "condition": lambda item: frappe.db.get_value(
                    "Item", item.item_code, "is_stock_item"
                ),
                "postprocess": update_item
            }
        },
        target_doc,
        set_missing_values
    )

    return doc
```

### Client-Side (`sales_order.js`)

```javascript
frappe.ui.form.on('Sales Order', {
    refresh: function(frm) {
        if (frm.doc.docstatus === 1) {
            frm.add_custom_button(__('Create Material Receipt'), function() {
                frappe.model.open_mapped_doc({
                    method: 'your_app.module.sales_order.create_material_receipt_from_sales_order',
                    frm: frm
                });
            });
        }
    }
});
```

### What `get_mapped_doc()` Handles Automatically

✅ **Item Fields Auto-Populated:**
- `conversion_factor` - From Item UOM conversion table
- `stock_uom` - From Item master
- `transfer_qty` - Calculated as qty × conversion_factor
- `item_name` - From Item master
- `description` - From Item master
- All other standard item fields

✅ **Validation:**
- Checks source document exists
- Validates docstatus if specified
- Runs field validations

✅ **Child Table Filtering:**
- Condition function filters items
- Only matching items are mapped

## Field Mapping Options

### Basic Mapping
```python
"Source DocType": {
    "doctype": "Target DocType"
}
```
All fields with matching names are auto-mapped.

### Field Map (Rename Fields)
```python
"field_map": {
    "source_field_name": "target_field_name",
    "delivery_date": "schedule_date"
}
```

### Validation
```python
"validation": {
    "docstatus": ["=", 1],
    "status": ["!=", "Cancelled"]
}
```

### Condition (Filter Child Items)
```python
"condition": lambda item: item.qty > 0 and item.is_stock_item
```

### Postprocess (Modify After Mapping)
```python
"postprocess": update_item  # Called for each mapped row
```

## Common Use Cases

### 1. Sales Order → Delivery Note
```python
get_mapped_doc("Sales Order", so_name, {
    "Sales Order": {"doctype": "Delivery Note"},
    "Sales Order Item": {
        "doctype": "Delivery Note Item",
        "condition": lambda item: item.delivered_qty < item.qty
    }
})
```

### 2. Purchase Order → Purchase Receipt
```python
get_mapped_doc("Purchase Order", po_name, {
    "Purchase Order": {"doctype": "Purchase Receipt"},
    "Purchase Order Item": {
        "doctype": "Purchase Receipt Item",
        "condition": lambda item: item.received_qty < item.qty
    }
})
```

### 3. Sales Order → Material Request
See ERPNext source: `erpnext/selling/doctype/sales_order/sales_order.py`
```python
def make_material_request(source_name, target_doc=None):
    # Standard ERPNext implementation
    return get_mapped_doc("Sales Order", source_name, {...})
```

## ERPNext Standard Examples

Look at these ERPNext files for reference implementations:

**Sales Order:**
- `/apps/erpnext/erpnext/selling/doctype/sales_order/sales_order.py`
- Methods: `make_material_request()`, `make_delivery_note()`, `make_sales_invoice()`

**Purchase Order:**
- `/apps/erpnext/erpnext/buying/doctype/purchase_order/purchase_order.py`
- Methods: `make_purchase_receipt()`, `make_purchase_invoice()`

**Delivery Note:**
- `/apps/erpnext/erpnext/stock/doctype/delivery_note/delivery_note.py`
- Method: `make_sales_invoice()`

## Troubleshooting

### Issue: Mandatory Field Missing
**Solution:** Check if the field is in the child table mapping. `get_mapped_doc` auto-fetches fields, but custom fields may need explicit mapping.

### Issue: Conversion Factor Not Set
**Solution:** Ensure UOM Conversion Factor is defined in Item master for the UOM being used.

### Issue: Items Not Filtered
**Solution:** Check the `condition` lambda function. Make sure it's returning True/False correctly.

### Issue: Custom Fields Not Mapped
**Solution:** Use `set_missing_values()` for header fields or `postprocess` for item fields.

## Anti-Patterns to Avoid

❌ **Don't manually create and populate documents:**
```python
# BAD - Manual approach
stock_entry = frappe.new_doc("Stock Entry")
for item in sales_order.items:
    stock_entry.append("items", {
        "item_code": item.item_code,
        "qty": item.qty
        # Missing: conversion_factor, stock_uom, transfer_qty, etc.
    })
```

✅ **Do use get_mapped_doc:**
```python
# GOOD - Standard pattern
stock_entry = get_mapped_doc("Sales Order", so_name, {...})
```

## Summary

**When creating related documents:**
1. ✅ Use `get_mapped_doc()` on server-side
2. ✅ Use `frappe.model.open_mapped_doc()` on client-side
3. ✅ Define field mappings and conditions
4. ✅ Use `set_missing_values()` for custom header fields
5. ✅ Use `postprocess` for custom item logic
6. ✅ Let Frappe handle standard field fetching

**This pattern ensures:**
- All mandatory fields are populated
- UOM conversions work correctly
- Code is maintainable and upgrade-safe
- Follows ERPNext standard practices

## References

- Frappe Documentation: [Document Mapping](https://frappeframework.com/docs/user/en/api/document)
- ERPNext Source Code: See standard implementations in `erpnext/selling/`, `erpnext/buying/`, `erpnext/stock/`
- Frappe Utils: `frappe.model.mapper.get_mapped_doc()`
