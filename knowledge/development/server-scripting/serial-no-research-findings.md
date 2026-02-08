# ERPNext Serial Number Handling - Research Findings

## Overview

Research into how ERPNext handles serial number validation and attribute tracking to identify reusable patterns and utilities.

## Key Findings

### 1. ERPNext Serial Number Utilities

**Location:** `/apps/erpnext/erpnext/stock/doctype/serial_no/serial_no.py`

#### `get_serial_nos()` Utility

ERPNext provides a built-in utility to parse serial number strings:

```python
from erpnext.stock.doctype.serial_no.serial_no import get_serial_nos

def get_serial_nos(serial_no):
    """Parse serial number string into list.

    Handles:
    - List input (returns as-is)
    - String input with commas or newlines
    - Strips whitespace
    - Returns clean list
    """
    if isinstance(serial_no, list):
        return serial_no

    return [s.strip() for s in cstr(serial_no).strip().replace(",", "\n").split("\n") if s.strip()]
```

**Benefits:**
- ✅ Handles both comma and newline separators
- ✅ Strips whitespace automatically
- ✅ Returns clean list
- ✅ Standard ERPNext utility (upgrade-safe)

**Our Implementation:**
We created our own `parse_newline_separated_field()` which works similarly but only handles newlines. We should consider using ERPNext's utility instead for better compatibility.

---

### 2. Serial and Batch Bundle (Modern ERPNext)

**Location:** `/apps/erpnext/erpnext/stock/doctype/serial_and_batch_bundle/`

ERPNext v13+ uses a separate "Serial and Batch Bundle" DocType to manage serial/batch tracking:

**Structure:**
- **Serial and Batch Bundle** (header)
  - `type_of_transaction`: Inward/Outward/Maintenance
  - `voucher_type`: Stock Entry/Delivery Note/etc.
  - `warehouse`: Warehouse
  - `entries`: Child table of Serial and Batch Entry

- **Serial and Batch Entry** (child table)
  - `serial_no`: Individual serial number
  - `batch_no`: Batch number
  - `qty`: Quantity
  - `warehouse`: Warehouse
  - Custom fields can be added here

**How It Works:**
1. Stock transactions create Serial and Batch Bundle
2. Bundle contains individual entries for each serial/batch
3. Ledger entries link to bundle instead of serial no string
4. Provides better tracking and history

**Custom Fields in Bundle:**
You can add custom fields (heat_no, drawing_no, part_no) to:
- `Serial and Batch Entry` (child table) - Per transaction
- `Serial No` (master) - Permanent attributes

---

### 3. Stock Entry Validation Pattern

**Location:** `/apps/erpnext/erpnext/stock/doctype/stock_entry/stock_entry.py`

ERPNext Stock Entry has comprehensive validation methods:

```python
def validate(self):
    self.validate_duplicate_serial_and_batch_bundle("items")
    self.validate_posting_time()
    self.validate_purpose()
    self.validate_item()
    self.validate_warehouse()
    # ... many more validations
    self.clean_serial_nos()
    self.make_serial_and_batch_bundle_for_outward()
    self.validate_serialized_batch()
```

**Key Methods:**
- `validate_duplicate_serial_and_batch_bundle()` - Prevents duplicate serial nos
- `clean_serial_nos()` - Cleans and normalizes serial number strings
- `validate_serialized_batch()` - Validates serial/batch combinations
- `make_serial_and_batch_bundle_for_outward()` - Creates bundles for outward transactions

**Pattern:**
- Multiple small, focused validation methods
- Called from main `validate()` method
- Each method handles one concern
- Use frappe.throw() for errors

---

### 4. Delivery Note Serial Validation

**Location:** `/apps/erpnext/erpnext/stock/doctype/delivery_note/delivery_note.py`

Delivery Note has similar validation patterns:

```python
def validate(self):
    # ... other validations
    self.validate_standalone_serial_nos_customer()
    self.validate_reserved_stock()

def on_submit(self):
    self.validate_standalone_serial_nos_customer()
    # ... other actions
```

**Pattern:**
- Validates serial numbers on validate and on_submit
- Checks serial number ownership
- Validates against customer/warehouse rules

---

## Recommendations for Our Implementation

### Option 1: Continue with Current Approach ✅ (Recommended)

**What we have:**
- Custom utility module: `serial_no_validation.py`
- Reusable validation functions
- Works with current ERPNext structure
- Simple and straightforward

**Improvements:**
1. **Use ERPNext's `get_serial_nos()` utility:**
   ```python
   from erpnext.stock.doctype.serial_no.serial_no import get_serial_nos

   # Instead of our parse_newline_separated_field()
   serial_nos = get_serial_nos(item.serial_no)
   heat_nos = get_serial_nos(item.custom_heat_no)
   ```

2. **Follow ERPNext validation naming:**
   ```python
   # In stock_entry.py
   def validate(self):
       self.validate_serial_no_attributes()  # Clear, ERPNext-style name

   def validate_serial_no_attributes(self):
       validate_stock_entry_items(self)
   ```

3. **Add to Serial No master on Material Receipt:**
   ```python
   # On Stock Entry submit for Material Receipt
   # Update Serial No master with heat/drawing/part nos
   for serial_no, heat_no, drawing_no, part_no in zip(...):
       frappe.db.set_value("Serial No", serial_no, {
           "custom_heat_no": heat_no,
           "custom_drawing_no": drawing_no,
           "custom_part_no": part_no
       })
   ```

---

### Option 2: Use Serial and Batch Bundle (Advanced)

**If you want to track attributes per transaction:**

1. Add custom fields to `Serial and Batch Entry`:
   - `custom_heat_no`
   - `custom_drawing_no`
   - `custom_part_no`

2. Validation happens automatically through bundle creation

3. Full transaction history per serial number

**Pros:**
- ✅ Better transaction tracking
- ✅ Audit trail for each transaction
- ✅ Leverages ERPNext's modern architecture

**Cons:**
- ❌ More complex implementation
- ❌ Requires understanding bundle system
- ❌ Heavier change to existing workflows

---

## Code Examples

### Using ERPNext's get_serial_nos() Utility

**Before (Our Implementation):**
```python
def parse_newline_separated_field(field_value):
    if not field_value:
        return []
    values = [v.strip() for v in str(field_value).split('\n') if v.strip()]
    return values

serial_nos = parse_newline_separated_field(item.serial_no)
```

**After (Using ERPNext):**
```python
from erpnext.stock.doctype.serial_no.serial_no import get_serial_nos

# Handles commas, newlines, whitespace automatically
serial_nos = get_serial_nos(item.serial_no)
heat_nos = get_serial_nos(item.custom_heat_no)
drawing_nos = get_serial_nos(item.custom_drawing_no)
part_nos = get_serial_nos(item.custom_part_no)
```

---

### Auto-Update Serial No Master (Recommended Addition)

**Add this to Material Receipt validation:**

```python
def update_serial_no_attributes_on_receipt(stock_entry):
    """Update Serial No master with heat/drawing/part numbers on Material Receipt.

    This creates permanent attribute records in Serial No master
    that can be validated on future transactions.
    """
    if stock_entry.stock_entry_type != "Material Receipt":
        return

    for item in stock_entry.items:
        if not item.get('serial_no'):
            continue

        serial_nos = get_serial_nos(item.serial_no)
        heat_nos = get_serial_nos(item.get('custom_heat_no'))
        drawing_nos = get_serial_nos(item.get('custom_drawing_no'))
        part_nos = get_serial_nos(item.get('custom_part_no'))

        # Zip them together (assumes 1:1 validated already)
        for idx, serial_no in enumerate(serial_nos):
            heat_no = heat_nos[idx] if idx < len(heat_nos) else None
            drawing_no = drawing_nos[idx] if idx < len(drawing_nos) else None
            part_no = part_nos[idx] if idx < len(part_nos) else None

            # Update Serial No master
            frappe.db.set_value("Serial No", serial_no, {
                "custom_heat_no": heat_no,
                "custom_drawing_no": drawing_no,
                "custom_part_no": part_no
            }, update_modified=False)
```

**Then call from on_submit:**
```python
def on_submit(doc, method=None):
    """Stock Entry on_submit hook."""
    update_serial_no_attributes_on_receipt(doc)
```

---

## Summary

### What ERPNext Provides:
✅ **`get_serial_nos()`** - Standard utility for parsing serial numbers
✅ **Serial and Batch Bundle** - Modern transaction tracking system
✅ **Validation patterns** - Multiple focused validation methods
✅ **Stock Controller** - Base class with common stock validation

### What We Need to Build:
🔧 **Custom validation logic** - Our specific 1:1 and attribute matching rules
🔧 **Serial No attribute updates** - Auto-populate Serial No master on receipt
🔧 **Reusable utilities** - For other doctypes (Delivery Note, Purchase Receipt)

### Recommended Next Steps:

1. **Refactor to use ERPNext's `get_serial_nos()`:**
   - More robust (handles commas + newlines)
   - Upgrade-safe (standard ERPNext utility)
   - Better compatibility

2. **Add Serial No master update on Material Receipt:**
   - Permanently store heat/drawing/part no with serial
   - Enables validation on all future transactions
   - Single source of truth

3. **Keep our custom validation utilities:**
   - Our business rules are unique
   - Reusable across doctypes
   - Well-documented and maintainable

4. **Consider Serial and Batch Bundle for future:**
   - If you need transaction-level attribute history
   - If you want to leverage ERPNext's modern architecture
   - Can migrate later without breaking existing functionality

---

## Files to Reference

**ERPNext Serial Number Files:**
- `/apps/erpnext/erpnext/stock/doctype/serial_no/serial_no.py` - Serial No controller and utilities
- `/apps/erpnext/erpnext/stock/doctype/serial_and_batch_bundle/serial_and_batch_bundle.py` - Modern bundle system
- `/apps/erpnext/erpnext/stock/doctype/stock_entry/stock_entry.py` - Stock Entry validations
- `/apps/erpnext/erpnext/stock/doctype/delivery_note/delivery_note.py` - Delivery Note validations

**Our Implementation:**
- `/apps/globcom_manufacturing/globcom_manufacturing/globcom_manufacturing_custom/utils/serial_no_validation.py` - Validation utilities
- `/apps/globcom_manufacturing/globcom_manufacturing/globcom_manufacturing_custom/stock_entry/stock_entry.py` - Stock Entry controller

---

**Last Updated:** 2026-02-03
**ERPNext Version:** 15.93.2
**Frappe Version:** 15.94.0
