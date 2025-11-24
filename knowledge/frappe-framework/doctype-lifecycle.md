# DocType Lifecycle & Document States

> Core Frappe document lifecycle management patterns.

## Document States

### docstatus Values

| Value | State | Description | Can Edit? | Can Cancel? |
|-------|-------|-------------|-----------|-------------|
| `0` | Draft | Editable, not committed | ✅ Yes | ❌ No |
| `1` | Submitted | Committed, locked | ❌ No | ✅ Yes |
| `2` | Cancelled | Voided, archived | ❌ No | ❌ No |

### Checking State

```python
# Check if document is draft
if doc.docstatus == 0:
    doc.field = "new value"
    doc.save()

# Check if submitted
if doc.docstatus == 1:
    frappe.throw("Cannot modify submitted document")

# Check if cancelled
if doc.docstatus == 2:
    frappe.throw("Document is cancelled")
```

## Lifecycle Hooks

### Controller Hooks

```python
class MyDocType(Document):
    def validate(self):
        """Runs before save (draft or submit)"""
        self.validate_dates()
        self.calculate_totals()

    def before_save(self):
        """Runs after validate, before save"""
        self.set_defaults()

    def after_insert(self):
        """Runs after first save (new document)"""
        self.create_linked_records()

    def on_submit(self):
        """Runs when document is submitted"""
        self.update_stock()
        self.create_gl_entries()

    def on_cancel(self):
        """Runs when document is cancelled"""
        self.reverse_stock()
        self.reverse_gl_entries()

    def on_trash(self):
        """Runs before document is deleted"""
        self.delete_linked_records()

    def on_update_after_submit(self):
        """Runs when submitted doc is updated (if allowed)"""
        self.recalculate_linked_docs()
```

### Hook Execution Order

**Save (Draft):**
1. `validate()`
2. `before_save()`
3. Database INSERT/UPDATE
4. `after_insert()` (new docs only)
5. `on_update()` (existing docs)

**Submit:**
1. `validate()`
2. `before_submit()`
3. `on_submit()`
4. Database UPDATE (docstatus = 1)
5. `on_update_after_submit()` (if fields changed)

**Cancel:**
1. `before_cancel()`
2. `on_cancel()`
3. Database UPDATE (docstatus = 2)

**Delete:**
1. `on_trash()`
2. Database DELETE

## Submit vs Save

### When to Use Submit

```python
# DocType JSON - enable submit
{
    "is_submittable": 1
}
```

**Use submit for:**
- Financial transactions (Payment Entry, Journal Entry)
- Stock transactions (Stock Entry, Delivery Note)
- Manufacturing orders (Work Order, Job Card)
- Documents affecting ledger/inventory

**Don't submit:**
- Master data (Item, Customer, Supplier)
- Configuration (Settings, Custom Fields)
- Non-transactional records

### Allow Edit After Submit

```python
# DocType JSON - allow specific fields
{
    "is_submittable": 1,
    "fields": [
        {
            "fieldname": "remarks",
            "allow_on_submit": 1
        }
    ]
}
```

```python
# Controller - handle updates
def on_update_after_submit(self):
    """Runs when allowed fields updated"""
    self.notify_changes()
```

## Naming

### Auto-Naming Patterns

```python
# DocType JSON
{
    "autoname": "field:name1"           # Use field value
}

{
    "autoname": "SO-.YYYY.-.####"       # SO-2025-0001
}

{
    "autoname": "naming_series:"        # User selects series
}

{
    "autoname": "Prompt"                # User enters name
}

{
    "autoname": "hash"                  # Random hash
}
```

### Custom Naming

```python
class MyDocType(Document):
    def autoname(self):
        """Custom naming logic"""
        self.name = f"{self.prefix}-{self.custom_field}-{frappe.utils.nowdate()}"
```

## Permissions

### Role-Based Access

```python
# Check permission before operation
if not frappe.has_permission('DocType', 'read', doc):
    frappe.throw('No permission')

# Check specific permission
if not frappe.has_permission('DocType', 'write', doc):
    frappe.throw('Cannot edit')

# Check submit permission
if not frappe.has_permission('DocType', 'submit', doc):
    frappe.throw('Cannot submit')
```

### User Permissions

```python
# Restrict user to specific records
frappe.defaults.add_user_permission('Cost Center', 'Manufacturing', 'user@example.com')

# Check user permission
if not frappe.has_permission('Cost Center', ptype='read', user='user@example.com'):
    frappe.throw('No access to this cost center')
```

## Child Tables

### Adding Child Rows

```python
# Create parent doc
doc = frappe.get_doc({
    'doctype': 'Sales Order',
    'customer': 'Customer A'
})

# Add child row
doc.append('items', {
    'item_code': 'ITEM-001',
    'qty': 10,
    'rate': 100
})

doc.save()
```

### Updating Child Rows

```python
doc = frappe.get_doc('Sales Order', 'SO-0001')

# Update specific row
for item in doc.items:
    if item.item_code == 'ITEM-001':
        item.qty = 20

doc.save()
```

### Deleting Child Rows

```python
# Remove specific row
doc.items = [item for item in doc.items if item.item_code != 'ITEM-001']
doc.save()

# Clear all rows
doc.items = []
doc.save()
```

## Linking Documents

### Link Fields

```python
# DocType JSON
{
    "fieldname": "customer",
    "fieldtype": "Link",
    "options": "Customer"
}
```

### Dynamic Links

```python
# DocType JSON - link based on another field
{
    "fieldname": "party_type",
    "fieldtype": "Link",
    "options": "DocType"
},
{
    "fieldname": "party",
    "fieldtype": "Dynamic Link",
    "options": "party_type"
}
```

### Get Linked Documents

```python
# Get all Sales Orders for a Customer
orders = frappe.get_all(
    'Sales Order',
    filters={'customer': 'CUST-001'},
    fields=['name', 'grand_total']
)

# Get document with linked data
doc = frappe.get_doc('Customer', 'CUST-001')
doc.get_linked_documents()  # Returns all linked docs
```

## Versioning

### Enable Versioning

```python
# DocType JSON
{
    "track_changes": 1
}
```

### Access Version History

```python
# Get all versions of a document
versions = frappe.get_all(
    'Version',
    filters={'ref_doctype': 'Sales Order', 'docname': 'SO-0001'},
    fields=['*'],
    order_by='modified desc'
)

# Get specific version data
version = frappe.get_doc('Version', version_name)
data = frappe.parse_json(version.data)
```

## Validation Patterns

### Common Validations

```python
class MyDocType(Document):
    def validate(self):
        self.validate_dates()
        self.validate_amounts()
        self.validate_duplicates()

    def validate_dates(self):
        if self.end_date < self.start_date:
            frappe.throw('End date cannot be before start date')

    def validate_amounts(self):
        if self.total < 0:
            frappe.throw('Total cannot be negative')

    def validate_duplicates(self):
        duplicate = frappe.db.exists({
            'doctype': self.doctype,
            'name': ['!=', self.name],
            'unique_field': self.unique_field
        })
        if duplicate:
            frappe.throw(f'Duplicate entry: {duplicate}')
```

### Prevent Deletion

```python
def on_trash(self):
    """Check before deletion"""
    if self.docstatus == 1:
        frappe.throw('Cannot delete submitted document')

    linked_docs = frappe.get_all(
        'Linked DocType',
        filters={'parent_doc': self.name}
    )

    if linked_docs:
        frappe.throw('Cannot delete - linked documents exist')
```

## Status Field Pattern

### Common Status Workflow

```python
# DocType JSON - add status field
{
    "fieldname": "status",
    "fieldtype": "Select",
    "options": "Draft\nPending\nApproved\nCompleted\nCancelled",
    "read_only": 1
}
```

```python
class MyDocType(Document):
    def on_submit(self):
        self.status = 'Pending'

    def approve(self):
        if self.docstatus != 1:
            frappe.throw('Document must be submitted')
        self.status = 'Approved'
        self.save()

    def complete(self):
        if self.status != 'Approved':
            frappe.throw('Document must be approved')
        self.status = 'Completed'
        self.save()
```

## Key Rules

- ✅ Use `validate()` for all business logic checks
- ✅ Use `on_submit()` for ledger/stock updates
- ✅ Use `on_cancel()` to reverse ledger/stock
- ✅ Check permissions before all operations
- ✅ Use `is_submittable` for transactional docs
- ✅ Enable `track_changes` for audit trail
- ✅ Validate dates, amounts, duplicates
- ✅ Clean up linked docs in `on_trash()`
- ❌ Never modify submitted docs without `allow_on_submit`
- ❌ Never skip validation hooks
