# Naming Series & Document Naming

> Automatic document numbering and naming patterns.

## Auto-Naming Methods

### Naming Series (User-Selectable)

**Most common method** - Let users choose from predefined series.

```python
# DocType JSON
{
    "autoname": "naming_series:",
    "fields": [
        {
            "fieldname": "naming_series",
            "fieldtype": "Select",
            "label": "Series",
            "options": "SO-.YYYY.-.#####\nSO-BRANCH-.YYYY.-.####\nSO-WH-.####",
            "default": "SO-.YYYY.-.#####",
            "reqd": 1
        }
    ]
}
```

**Result:** SO-2025-00001, SO-2025-00002, ...

### Field-Based Naming

Use value from a field.

```python
{
    "autoname": "field:customer_name"
}
```

**Result:** Name = Customer Name field value

### Prompt (User Enters Name)

```python
{
    "autoname": "Prompt"
}
```

**Result:** User enters document name manually

### Format Pattern

Fixed pattern with placeholders.

```python
{
    "autoname": "format:SO-{customer}-{YYYY}-{####}"
}
```

**Result:** SO-CUST001-2025-0001

### Hash (Random)

Random alphanumeric hash.

```python
{
    "autoname": "hash"
}
```

**Result:** 8d7f3e2a1b4c

### Custom (Python Method)

Custom naming logic in controller.

```python
# DocType JSON
{
    "autoname": ""  # Leave empty
}

# Controller
class MyDocType(Document):
    def autoname(self):
        """Custom naming logic"""
        self.name = f"{self.prefix}-{self.customer}-{frappe.utils.nowdate()}"
```

## Naming Series Patterns

### Placeholders

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `####` | Sequential number (4 digits) | 0001, 0002 |
| `.####` | Auto-increment with period | .0001, .0002 |
| `YYYY` | 4-digit year | 2025 |
| `YY` | 2-digit year | 25 |
| `MM` | Month (2 digits) | 01, 02, ..., 12 |
| `DD` | Day (2 digits) | 01, 02, ..., 31 |
| `{fieldname}` | Field value | {customer} → CUST-001 |
| `.-` | Period or hyphen separator | SO-.YYYY = SO.2025 |

### Common Patterns

```python
# Year-based series (resets yearly)
"SO-.YYYY.-.#####"          # SO.2025.00001
"INV-YYYY-MM-####"          # INV-2025-01-0001

# Simple counter
"TASK-.#####"               # TASK.00001
"CUST-####"                 # CUST-0001

# Branch/location-based
"SO-{branch}-.####"         # SO-NORTH.0001
"INV-{warehouse}-####"      # INV-WH01-0001

# Date-based
"DO-YYYY-MM-DD-###"         # DO-2025-01-15-001

# Customer-based
"SO-{customer}-.####"       # SO-CUST001.0001

# Multiple series for selection
options: """
SO-.YYYY.-.#####
SO-EXPORT-.YYYY.-.####
SO-DOMESTIC-.YYYY.-.####
"""
```

## Setting Up Naming Series

### Method 1: Setup → Settings → Naming Series

1. Navigate to Setup → Settings → Naming Series
2. Select DocType
3. View/edit current series
4. Add new series
5. Set current value

### Method 2: DocType Definition

```python
{
    "autoname": "naming_series:",
    "fields": [
        {
            "fieldname": "naming_series",
            "fieldtype": "Select",
            "label": "Series",
            "options": "SO-.YYYY.-.#####",
            "default": "SO-.YYYY.-.#####"
        }
    ]
}
```

### Method 3: Programmatically

```python
# Set current value for series
frappe.db.sql("""
    INSERT INTO `tabSeries` (name, current)
    VALUES ('SO-.2025.-', 100)
    ON DUPLICATE KEY UPDATE current = 100
""")
```

## Custom Naming Logic

### Simple Custom Name

```python
class Customer(Document):
    def autoname(self):
        """Custom naming"""
        # Get abbreviated name
        abbr = ''.join([c for c in self.customer_name if c.isupper()])

        # Add counter
        count = frappe.db.count('Customer') + 1

        self.name = f"CUST-{abbr}-{count:04d}"
```

### Complex Custom Name

```python
class SalesOrder(Document):
    def autoname(self):
        """Branch + year + sequence"""
        # Get branch abbreviation
        branch_abbr = frappe.db.get_value('Branch', self.branch, 'abbreviation')

        # Get year
        year = frappe.utils.getdate(self.transaction_date).year

        # Get next number for this branch/year
        series_name = f"SO-{branch_abbr}-{year}-"

        # Get or create series
        current = frappe.db.get_value('Series', series_name, 'current')

        if not current:
            current = 0

        next_num = current + 1

        # Update series
        frappe.db.sql("""
            INSERT INTO `tabSeries` (name, current)
            VALUES (%(series)s, %(current)s)
            ON DUPLICATE KEY UPDATE current = %(current)s
        """, {'series': series_name, 'current': next_num})

        self.name = f"{series_name}{next_num:04d}"
```

### Conditional Naming

```python
class Task(Document):
    def autoname(self):
        """Different series based on priority"""
        if self.priority == 'High':
            self.name = frappe.model.naming.make_autoname('URGENT-.####')
        elif self.priority == 'Medium':
            self.name = frappe.model.naming.make_autoname('TASK-.####')
        else:
            self.name = frappe.model.naming.make_autoname('ROUTINE-.####')
```

## Amending Documents

### Amendment Naming

When document is amended, auto-append revision number.

```python
# Original: SO-2025-00001
# Amended: SO-2025-00001-1
# Second amendment: SO-2025-00001-2
```

**Automatic for submittable DocTypes:**
```python
{
    "is_submittable": 1
}
```

**Custom amendment naming:**
```python
class SalesOrder(Document):
    def autoname(self):
        if self.amended_from:
            # Get base name
            base_name = self.amended_from.split('-')[0]

            # Get amendment number
            amendment_num = frappe.db.count('Sales Order', {
                'amended_from': self.amended_from
            }) + 1

            self.name = f"{base_name}-{amendment_num}"
        else:
            # Normal naming
            self.name = frappe.model.naming.make_autoname('SO-.YYYY.-.#####')
```

## Renaming Documents

### Allow Rename

```python
# DocType JSON
{
    "allow_rename": 1  # Allow manual rename
}
```

### Programmatic Rename

```python
# Rename document
frappe.rename_doc('Customer', 'OLD-NAME', 'NEW-NAME')

# Rename with merge
frappe.rename_doc('Customer', 'OLD-NAME', 'EXISTING-NAME', merge=True)

# Force rename (ignore links)
frappe.rename_doc('Customer', 'OLD-NAME', 'NEW-NAME', force=True)
```

### Bulk Rename

```python
# Rename multiple documents
renames = [
    ['OLD-1', 'NEW-1'],
    ['OLD-2', 'NEW-2'],
    ['OLD-3', 'NEW-3']
]

for old, new in renames:
    frappe.rename_doc('Customer', old, new)
    frappe.db.commit()
```

## Naming Validation

### Check Duplicate

```python
def validate(self):
    """Prevent duplicate names"""
    if frappe.db.exists(self.doctype, self.name):
        frappe.throw(f'Document {self.name} already exists')
```

### Name Format Validation

```python
def autoname(self):
    """Validate name format"""
    # Generate name
    self.name = f"CUST-{self.customer_code}"

    # Validate format
    if not self.name.startswith('CUST-'):
        frappe.throw('Customer name must start with CUST-')

    if len(self.name) > 20:
        frappe.throw('Customer name too long')
```

## Series Management

### Check Current Value

```python
# Get current value for series
current = frappe.db.get_value('Series', 'SO-.2025.-', 'current')
```

### Reset Series

```python
# Reset series to 0
frappe.db.set_value('Series', 'SO-.2025.-', 'current', 0)

# Or delete series
frappe.db.delete('Series', {'name': 'SO-.2025.-'})
```

### Set Starting Number

```python
# Start from 1000
frappe.db.set_value('Series', 'SO-.2025.-', 'current', 999)
# Next number will be 1000
```

## Common Patterns

### Financial Year Based

```python
def get_fiscal_year_prefix():
    """FY 2024-25 → FY2425"""
    fiscal_year = frappe.defaults.get_user_default('fiscal_year')
    return fiscal_year.replace('-', '').replace(' ', '')

class SalesInvoice(Document):
    def autoname(self):
        prefix = get_fiscal_year_prefix()
        self.name = frappe.model.naming.make_autoname(f'{prefix}-####')
```

### Location-Based

```python
# Warehouse-specific series
{
    "autoname": "format:DO-{warehouse}-.YYYY.-.####"
}
# Result: DO-WH01.2025.0001
```

### Customer-Specific

```python
# Different series per customer type
class Quotation(Document):
    def autoname(self):
        customer = frappe.get_doc('Customer', self.customer)

        if customer.customer_type == 'Company':
            self.name = frappe.model.naming.make_autoname('QTN-B2B-.####')
        else:
            self.name = frappe.model.naming.make_autoname('QTN-B2C-.####')
```

## Best Practices

### ✅ Do:

```python
# Clear, meaningful prefixes
"SO-.YYYY.-.#####"       # Sales Order
"PO-.YYYY.-.#####"       # Purchase Order
"INV-.YYYY.-.#####"      # Invoice

# Year-based reset (manageable numbers)
"SO-.YYYY.-.#####"       # Resets each year

# Enough digits for scale
"SO-.####"               # Up to 9,999
"SO-.#####"              # Up to 99,999
"SO-.######"             # Up to 999,999

# Descriptive naming
def autoname(self):
    """Generate name: CUST-[ABBR]-[NUM]"""
    # ... logic
```

### ❌ Don't:

```python
# Unclear prefixes
"X-.####"                # What is X?

# No year separation (huge numbers)
"SO-.#######"            # SO.0234567 (hard to reference)

# Too few digits
"SO-.##"                 # Only 99 documents

# Complex user-entered names
{
    "autoname": "Prompt"  # For transactional docs
}
# Users make mistakes, duplicates

# Random hash for user-facing docs
{
    "autoname": "hash"    # Hard to reference
}
```

## Troubleshooting

### Duplicate Key Error

**Cause:** Series counter out of sync

**Fix:**
```python
# Find highest number
max_num = frappe.db.sql("""
    SELECT MAX(CAST(SUBSTRING_INDEX(name, '-', -1) AS UNSIGNED))
    FROM `tabSales Order`
    WHERE name LIKE 'SO-2025-%'
""")[0][0] or 0

# Update series
frappe.db.set_value('Series', 'SO-.2025.-', 'current', max_num)
```

### Wrong Series

**Cause:** Multiple series, wrong default

**Fix:**
```python
# Set correct default in DocType
{
    "fieldname": "naming_series",
    "default": "SO-.YYYY.-.#####"  # Correct default
}
```

## Key Rules

- ✅ Use naming_series for user-selectable series
- ✅ Use year-based patterns (YYYY) for reset
- ✅ Provide enough digits (4-5 for most cases)
- ✅ Use clear, meaningful prefixes
- ✅ Validate custom naming logic
- ✅ Handle amendment naming for submittable docs
- ✅ Check for duplicates in autoname()
- ✅ Use format: for simple field-based patterns
- ✅ Document custom naming logic
- ❌ Don't use Prompt for transactional docs
- ❌ Don't use hash for user-facing documents
- ❌ Don't skip duplicate validation
- ❌ Don't use too few digits
