# DocType Field Types Reference

> Complete field type reference for Frappe DocTypes.

## Data Entry Fields

### Data

**Use:** Short text input (max 140 characters)

```python
{
    "fieldname": "email",
    "fieldtype": "Data",
    "label": "Email",
    "options": "Email"  # Validates email format
}
```

**Options:**
- `Email` - Email validation
- `Name` - Name format
- `Phone` - Phone validation
- `URL` - URL validation

### Small Text

**Use:** Multi-line text (no formatting)

```python
{
    "fieldname": "address",
    "fieldtype": "Small Text",
    "label": "Address"
}
```

### Long Text

**Use:** Large text area (no formatting)

```python
{
    "fieldname": "description",
    "fieldtype": "Long Text",
    "label": "Description"
}
```

### Text Editor

**Use:** Rich text with formatting

```python
{
    "fieldname": "content",
    "fieldtype": "Text Editor",
    "label": "Content"
}
```

**Features:** Bold, italic, lists, links, images

### Code

**Use:** Code editor with syntax highlighting

```python
{
    "fieldname": "script",
    "fieldtype": "Code",
    "label": "Script",
    "options": "Python"  # or JavaScript, HTML, CSS, JSON
}
```

### Markdown Editor

**Use:** Markdown text with preview

```python
{
    "fieldname": "readme",
    "fieldtype": "Markdown Editor",
    "label": "README"
}
```

## Numeric Fields

### Int

**Use:** Integer numbers only

```python
{
    "fieldname": "qty",
    "fieldtype": "Int",
    "label": "Quantity",
    "default": "0"
}
```

### Float

**Use:** Decimal numbers

```python
{
    "fieldname": "rate",
    "fieldtype": "Float",
    "label": "Rate",
    "precision": "2"  # Decimal places
}
```

### Currency

**Use:** Money values (auto-formatted)

```python
{
    "fieldname": "amount",
    "fieldtype": "Currency",
    "label": "Amount",
    "options": "currency"  # Link to currency field
}
```

### Percent

**Use:** Percentage values

```python
{
    "fieldname": "tax_rate",
    "fieldtype": "Percent",
    "label": "Tax Rate"
}
```

**Display:** 18 → 18%

## Selection Fields

### Select

**Use:** Dropdown with fixed options

```python
{
    "fieldname": "status",
    "fieldtype": "Select",
    "label": "Status",
    "options": "Open\nWorking\nCompleted\nCancelled",
    "default": "Open"
}
```

**Multiple lines = separate options**

### Link

**Use:** Link to another DocType

```python
{
    "fieldname": "customer",
    "fieldtype": "Link",
    "label": "Customer",
    "options": "Customer"  # DocType name
}
```

**Features:**
- Autocomplete search
- Quick create (+ button)
- Validation (must exist)

### Dynamic Link

**Use:** Link based on another field

```python
{
    "fieldname": "party_type",
    "fieldtype": "Link",
    "options": "DocType"
},
{
    "fieldname": "party",
    "fieldtype": "Dynamic Link",
    "options": "party_type"  # Linked field
}
```

**Example:**
- party_type = "Customer" → party links to Customer
- party_type = "Supplier" → party links to Supplier

### Check

**Use:** Boolean checkbox

```python
{
    "fieldname": "is_active",
    "fieldtype": "Check",
    "label": "Is Active",
    "default": "1"
}
```

**Values:** 0 = unchecked, 1 = checked

## Date/Time Fields

### Date

**Use:** Date picker

```python
{
    "fieldname": "due_date",
    "fieldtype": "Date",
    "label": "Due Date"
}
```

**Format:** YYYY-MM-DD

### Datetime

**Use:** Date and time picker

```python
{
    "fieldname": "scheduled_time",
    "fieldtype": "Datetime",
    "label": "Scheduled Time"
}
```

**Format:** YYYY-MM-DD HH:MM:SS

### Time

**Use:** Time picker only

```python
{
    "fieldname": "start_time",
    "fieldtype": "Time",
    "label": "Start Time"
}
```

**Format:** HH:MM:SS

## File Fields

### Attach

**Use:** Single file upload

```python
{
    "fieldname": "attachment",
    "fieldtype": "Attach",
    "label": "Attachment"
}
```

**Returns:** `/files/filename.pdf`

### Attach Image

**Use:** Image upload with preview

```python
{
    "fieldname": "photo",
    "fieldtype": "Attach Image",
    "label": "Photo"
}
```

**Shows:** Image thumbnail

## Layout Fields

### Section Break

**Use:** Start new section

```python
{
    "fieldname": "section_details",
    "fieldtype": "Section Break",
    "label": "Details",
    "collapsible": 1
}
```

### Column Break

**Use:** Start new column

```python
{
    "fieldname": "column_break_1",
    "fieldtype": "Column Break"
}
```

**Layout:** 2 columns per section

### Tab Break

**Use:** Create tabs

```python
{
    "fieldname": "tab_general",
    "fieldtype": "Tab Break",
    "label": "General"
}
```

### HTML

**Use:** Static HTML content

```python
{
    "fieldname": "help_html",
    "fieldtype": "HTML",
    "options": "<p>Enter customer details below</p>"
}
```

### Heading

**Use:** Section heading

```python
{
    "fieldname": "heading_customer",
    "fieldtype": "Heading",
    "label": "Customer Information"
}
```

## Table Fields

### Table

**Use:** Child table (one-to-many)

```python
{
    "fieldname": "items",
    "fieldtype": "Table",
    "label": "Items",
    "options": "Sales Order Item"  # Child DocType
}
```

**Usage:**
```python
doc.append('items', {
    'item_code': 'ITEM-001',
    'qty': 10,
    'rate': 100
})
```

### Table MultiSelect

**Use:** Select multiple values from table

```python
{
    "fieldname": "territories",
    "fieldtype": "Table MultiSelect",
    "label": "Territories",
    "options": "Territory"
}
```

## Special Fields

### Read Only

**Use:** Display-only calculated field

```python
{
    "fieldname": "total",
    "fieldtype": "Currency",
    "label": "Total",
    "read_only": 1
}
```

### Password

**Use:** Password input (masked)

```python
{
    "fieldname": "api_secret",
    "fieldtype": "Password",
    "label": "API Secret"
}
```

**Storage:** Encrypted

### Color

**Use:** Color picker

```python
{
    "fieldname": "color",
    "fieldtype": "Color",
    "label": "Color"
}
```

**Returns:** #FF0000

### Rating

**Use:** Star rating

```python
{
    "fieldname": "rating",
    "fieldtype": "Rating",
    "label": "Rating"
}
```

**Values:** 1-5 stars

### Signature

**Use:** Digital signature pad

```python
{
    "fieldname": "signature",
    "fieldtype": "Signature",
    "label": "Signature"
}
```

### Barcode

**Use:** Barcode display

```python
{
    "fieldname": "barcode",
    "fieldtype": "Barcode",
    "label": "Barcode",
    "options": "barcode_value"  # Field with barcode data
}
```

### Geolocation

**Use:** Map location picker

```python
{
    "fieldname": "location",
    "fieldtype": "Geolocation",
    "label": "Location"
}
```

**Returns:** {"type": "FeatureCollection", "features": [...]}

### Duration

**Use:** Time duration (HH:MM:SS)

```python
{
    "fieldname": "duration",
    "fieldtype": "Duration",
    "label": "Duration"
}
```

**Format:** 01:30:00 (1 hour 30 minutes)

### Icon

**Use:** Icon picker

```python
{
    "fieldname": "icon",
    "fieldtype": "Icon",
    "label": "Icon"
}
```

**Returns:** fa fa-home

## Field Properties

### Common Properties

```python
{
    "fieldname": "customer",        # Unique field name
    "fieldtype": "Link",            # Field type
    "label": "Customer",            # Display label
    "options": "Customer",          # Type-specific options
    "reqd": 1,                      # Mandatory
    "read_only": 1,                 # Non-editable
    "hidden": 1,                    # Hidden field
    "default": "value",             # Default value
    "description": "Help text",     # Field description
    "depends_on": "eval:doc.type == 'Sales'",  # Conditional display
    "mandatory_depends_on": "eval:doc.status == 'Submitted'",
    "read_only_depends_on": "eval:doc.docstatus == 1",
    "fetch_from": "customer.customer_name",  # Auto-fetch
    "fetch_if_empty": 1,            # Fetch only if empty
    "bold": 1,                      # Bold label
    "in_list_view": 1,              # Show in list
    "in_standard_filter": 1,        # Standard filter
    "in_global_search": 1,          # Global search
    "allow_on_submit": 1,           # Edit after submit
    "unique": 1,                    # Unique value
    "search_index": 1,              # Database index
    "length": 140,                  # Max length
    "precision": 2,                 # Decimal places
    "non_negative": 1,              # >= 0 only
    "translatable": 1,              # Multi-language
    "ignore_user_permissions": 1    # Bypass user permissions
}
```

### Validation

```python
# Depends On (conditional display)
"depends_on": "eval:doc.type == 'Customer'"
"depends_on": "eval:doc.grand_total > 1000"

# Mandatory Depends On
"mandatory_depends_on": "eval:doc.payment_type == 'Credit Card'"

# Read Only Depends On
"read_only_depends_on": "eval:doc.docstatus == 1"

# Options for validation
"options": "Email"         # Email validation
"options": "URL"           # URL validation
"options": "Phone"         # Phone validation
```

### Fetch From

```python
# Auto-fetch from linked document
{
    "fieldname": "customer_name",
    "fieldtype": "Data",
    "fetch_from": "customer.customer_name",
    "fetch_if_empty": 1
}
```

## Field Type Selection Guide

| Use Case | Field Type |
|----------|-----------|
| Short text (<140 chars) | Data |
| Long text (no formatting) | Small Text / Long Text |
| Rich text (formatting) | Text Editor |
| Markdown content | Markdown Editor |
| Code/scripts | Code |
| Whole numbers | Int |
| Decimals | Float |
| Money | Currency |
| Percentage | Percent |
| Fixed options | Select |
| Link to DocType | Link |
| Dynamic DocType link | Dynamic Link |
| Yes/No | Check |
| Date only | Date |
| Date and time | Datetime |
| Time only | Time |
| File upload | Attach |
| Image upload | Attach Image |
| Multiple rows | Table |
| Multiple selections | Table MultiSelect |
| Password | Password |
| Color | Color |
| Rating | Rating |
| Signature | Signature |
| Location | Geolocation |

## Key Rules

- ✅ Use Link for relationships
- ✅ Use Currency for money values
- ✅ Use Check for boolean values
- ✅ Use Table for child records
- ✅ Set `read_only: 1` for calculated fields
- ✅ Use `depends_on` for conditional fields
- ✅ Add `search_index: 1` for filtered fields
- ✅ Use `fetch_from` for auto-population
- ✅ Set `reqd: 1` for mandatory fields
- ✅ Use proper validation options (Email, URL, Phone)
- ❌ Don't use Data for long text
- ❌ Don't skip field descriptions
- ❌ Don't make everything mandatory
