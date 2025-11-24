# Data Import & Export

> Bulk data operations and migration patterns in Frappe.

## Import Methods

### CSV Import (UI)

```
1. Navigate to DocType list (e.g., Customer)
2. Menu → Import
3. Download template
4. Fill CSV with data
5. Upload CSV
6. Map fields (if needed)
7. Submit import
```

**CSV Template:**
```csv
ID,Customer Name,Customer Type,Territory,Customer Group
CUST-001,ABC Corp,Company,North,Commercial
CUST-002,John Doe,Individual,South,Retail
```

### Data Import Tool

```
Setup → Data Import

Features:
- Upload CSV/Excel
- Field mapping
- Data validation
- Preview before import
- Error reporting
- Skip/overwrite existing
```

### Programmatic Import

```python
# Import single document
doc_dict = {
    'doctype': 'Customer',
    'customer_name': 'ABC Corp',
    'customer_type': 'Company',
    'territory': 'North'
}

doc = frappe.get_doc(doc_dict)
doc.insert()

# Or use insert with dict
frappe.get_doc(doc_dict).insert()
```

### Bulk Import

```python
def import_customers(file_path):
    """Import customers from CSV"""
    import csv

    with open(file_path, 'r') as f:
        reader = csv.DictReader(f)

        for row in reader:
            try:
                doc = frappe.get_doc({
                    'doctype': 'Customer',
                    'customer_name': row['Customer Name'],
                    'customer_type': row['Customer Type'],
                    'territory': row['Territory'],
                    'customer_group': row['Customer Group']
                })
                doc.insert()
                frappe.db.commit()

            except Exception as e:
                frappe.log_error(frappe.get_traceback(),
                    f'Import Error: {row["Customer Name"]}')
                frappe.db.rollback()
```

## Export Methods

### Export from List

```
1. Navigate to DocType list
2. Apply filters (if needed)
3. Menu → Export
4. Select format: Excel/CSV
5. Download file
```

### Programmatic Export

```python
@frappe.whitelist()
def export_customers():
    """Export customers to CSV"""
    import csv
    from io import StringIO

    output = StringIO()
    writer = csv.writer(output)

    # Header
    writer.writerow(['ID', 'Customer Name', 'Type', 'Territory'])

    # Data
    customers = frappe.get_all('Customer',
        fields=['name', 'customer_name', 'customer_type', 'territory'])

    for customer in customers:
        writer.writerow([
            customer.name,
            customer.customer_name,
            customer.customer_type,
            customer.territory
        ])

    # Return as file
    frappe.response['result'] = output.getvalue()
    frappe.response['type'] = 'csv'
    frappe.response['doctype'] = 'Customer'
```

### Excel Export

```python
def export_to_excel(doctype, filters=None):
    """Export to Excel with formatting"""
    from frappe.utils.xlsxwriter import make_xlsx

    data = frappe.get_all(doctype,
        filters=filters or {},
        fields=['*'])

    # Convert to list of lists
    rows = []
    if data:
        rows.append(list(data[0].keys()))  # Header
        for row in data:
            rows.append(list(row.values()))

    xlsx_file = make_xlsx(rows, doctype)

    return xlsx_file
```

## Child Table Import

### CSV Format

```csv
Parent,Parent Field,Child Field 1,Child Field 2
SO-0001,items,ITEM-001,10
SO-0001,items,ITEM-002,5
SO-0002,items,ITEM-001,20
```

### Import with Children

```python
def import_sales_orders(file_path):
    """Import Sales Orders with items"""
    import csv

    orders = {}

    with open(file_path, 'r') as f:
        reader = csv.DictReader(f)

        for row in reader:
            order_name = row['Order Name']

            # Create parent if not exists
            if order_name not in orders:
                orders[order_name] = {
                    'doctype': 'Sales Order',
                    'customer': row['Customer'],
                    'items': []
                }

            # Add child
            orders[order_name]['items'].append({
                'item_code': row['Item Code'],
                'qty': row['Qty'],
                'rate': row['Rate']
            })

    # Insert orders
    for order_data in orders.values():
        doc = frappe.get_doc(order_data)
        doc.insert()
        frappe.db.commit()
```

## Data Migration

### Simple Migration

```python
def migrate_old_data():
    """Migrate from old system"""
    import json

    # Read old data
    with open('old_data.json', 'r') as f:
        old_data = json.load(f)

    for record in old_data:
        # Transform data
        new_record = {
            'doctype': 'Customer',
            'customer_name': record['name'],
            'email': record['email_address'],
            'phone': record['phone_number']
        }

        # Insert
        doc = frappe.get_doc(new_record)
        doc.insert(ignore_permissions=True)

    frappe.db.commit()
```

### Migration with Relationships

```python
def migrate_with_links():
    """Migrate maintaining relationships"""
    # Map old IDs to new IDs
    customer_map = {}

    # First pass: Create customers
    for old_customer in old_customers:
        doc = frappe.get_doc({
            'doctype': 'Customer',
            'customer_name': old_customer['name']
        })
        doc.insert()

        # Store mapping
        customer_map[old_customer['id']] = doc.name

    frappe.db.commit()

    # Second pass: Create orders with links
    for old_order in old_orders:
        new_customer = customer_map[old_order['customer_id']]

        doc = frappe.get_doc({
            'doctype': 'Sales Order',
            'customer': new_customer,
            'transaction_date': old_order['date']
        })
        doc.insert()

    frappe.db.commit()
```

### Background Migration

```python
def start_migration():
    """Start background migration"""
    frappe.enqueue(
        'my_app.migration.migrate_all_data',
        queue='long',
        timeout=7200,
        total_records=10000
    )

def migrate_all_data(total_records):
    """Background migration with progress"""
    batch_size = 100

    for i in range(0, total_records, batch_size):
        # Migrate batch
        migrate_batch(i, batch_size)

        # Update progress
        frappe.publish_progress(
            percent=(i / total_records) * 100,
            title='Migrating Data',
            description=f'Processed {i} of {total_records}'
        )

        frappe.db.commit()
```

## Bulk Operations

### Bulk Update

```python
def bulk_update_territory():
    """Update territory for all customers in region"""
    customers = frappe.get_all('Customer',
        filters={'region': 'North'},
        pluck='name')

    for customer_name in customers:
        doc = frappe.get_doc('Customer', customer_name)
        doc.territory = 'North Region'
        doc.save()

        frappe.db.commit()  # Commit each to avoid timeout
```

### SQL Bulk Update

```python
def bulk_update_sql():
    """Faster bulk update using SQL"""
    frappe.db.sql("""
        UPDATE `tabCustomer`
        SET territory = 'North Region'
        WHERE region = 'North'
    """)

    frappe.db.commit()
```

### Bulk Delete

```python
def bulk_delete_cancelled_orders():
    """Delete cancelled orders older than 1 year"""
    from frappe.utils import add_years, nowdate

    cutoff_date = add_years(nowdate(), -1)

    orders = frappe.get_all('Sales Order', {
        'docstatus': 2,  # Cancelled
        'transaction_date': ['<', cutoff_date]
    }, pluck='name')

    for order in orders:
        frappe.delete_doc('Sales Order', order)

    frappe.db.commit()
```

## Data Validation

### Pre-Import Validation

```python
def validate_import_data(file_path):
    """Validate before import"""
    import csv

    errors = []

    with open(file_path, 'r') as f:
        reader = csv.DictReader(f)

        for idx, row in enumerate(reader, start=2):
            # Check required fields
            if not row.get('Customer Name'):
                errors.append(f'Row {idx}: Customer Name required')

            # Check valid values
            if row.get('Customer Type') not in ['Company', 'Individual']:
                errors.append(f'Row {idx}: Invalid Customer Type')

            # Check duplicates
            if frappe.db.exists('Customer', {'customer_name': row['Customer Name']}):
                errors.append(f'Row {idx}: Customer already exists')

    return errors
```

### Import with Validation

```python
def safe_import(data_list):
    """Import with validation and error tracking"""
    results = {
        'success': [],
        'errors': []
    }

    for idx, data in enumerate(data_list):
        try:
            # Validate
            validate_customer_data(data)

            # Insert
            doc = frappe.get_doc(data)
            doc.insert()

            results['success'].append({
                'row': idx + 1,
                'id': doc.name
            })

            frappe.db.commit()

        except Exception as e:
            results['errors'].append({
                'row': idx + 1,
                'error': str(e)
            })
            frappe.db.rollback()

    return results
```

## Performance Optimization

### Batch Processing

```python
def import_in_batches(data_list, batch_size=100):
    """Import in batches to avoid timeout"""
    total = len(data_list)

    for i in range(0, total, batch_size):
        batch = data_list[i:i + batch_size]

        for data in batch:
            doc = frappe.get_doc(data)
            doc.insert()

        # Commit after each batch
        frappe.db.commit()

        # Progress update
        print(f'Processed {min(i + batch_size, total)} of {total}')
```

### Skip Validation

```python
def fast_import(data_list):
    """Fast import skipping validations"""
    for data in data_list:
        doc = frappe.get_doc(data)

        # Skip validation and hooks for speed
        doc.flags.ignore_validate = True
        doc.flags.ignore_mandatory = True

        doc.insert()

    frappe.db.commit()
```

### Direct SQL Insert

```python
def bulk_insert_sql(data_list):
    """Fastest import using SQL (use with caution)"""
    values = []

    for data in data_list:
        values.append((
            data['name'],
            data['customer_name'],
            data['customer_type'],
            frappe.session.user,
            frappe.utils.now()
        ))

    frappe.db.sql("""
        INSERT INTO `tabCustomer`
        (name, customer_name, customer_type, owner, creation)
        VALUES %s
    """ % ','.join(['%s'] * len(values)), values)

    frappe.db.commit()
```

## Data Fixtures

### Export Fixtures

```python
# hooks.py
fixtures = [
    {'dt': 'Custom Field', 'filters': {'module': 'My App'}},
    {'dt': 'Property Setter', 'filters': {'module': 'My App'}},
    {'dt': 'Workflow', 'filters': {'name': 'Sales Order Approval'}},
    'UOM',
    {'dt': 'Territory', 'filters': {'is_group': 1}}
]

# Export
bench --site site-name export-fixtures
```

### Import Fixtures

```python
# On migrate, fixtures auto-imported
# Or manually:
bench --site site-name import-fixtures my_app
```

## Integration Patterns

### API-Based Import

```python
def import_from_api(api_url, api_key):
    """Import from external API"""
    import requests

    response = requests.get(
        api_url,
        headers={'Authorization': f'Bearer {api_key}'}
    )

    if response.status_code == 200:
        data = response.json()

        for record in data['results']:
            # Transform and import
            doc = frappe.get_doc({
                'doctype': 'Customer',
                'customer_name': record['name'],
                'email': record['email']
            })
            doc.insert()

        frappe.db.commit()
```

### Scheduled Import

```python
# hooks.py
scheduler_events = {
    "daily": [
        "my_app.import.daily_customer_sync"
    ]
}

def daily_customer_sync():
    """Sync customers daily from external system"""
    import_from_api(
        api_url=frappe.conf.external_api_url,
        api_key=frappe.conf.external_api_key
    )
```

## Common Patterns

### Upsert Pattern

```python
def upsert_customer(customer_data):
    """Insert or update customer"""
    customer_name = customer_data.get('name')

    if frappe.db.exists('Customer', customer_name):
        # Update
        doc = frappe.get_doc('Customer', customer_name)
        doc.update(customer_data)
        doc.save()
    else:
        # Insert
        doc = frappe.get_doc(customer_data)
        doc.insert()

    return doc
```

### Incremental Import

```python
def incremental_import():
    """Import only new/updated records"""
    # Get last sync time
    last_sync = frappe.db.get_single_value('Sync Settings', 'last_sync_time')

    # Fetch records updated after last sync
    records = fetch_external_data(modified_after=last_sync)

    for record in records:
        upsert_customer(record)

    # Update last sync time
    frappe.db.set_value('Sync Settings', 'Sync Settings',
        'last_sync_time', frappe.utils.now())
```

## Error Handling

### Error Logging

```python
def import_with_logging(data_list):
    """Import with detailed error logging"""
    for idx, data in enumerate(data_list):
        try:
            doc = frappe.get_doc(data)
            doc.insert()
            frappe.db.commit()

        except Exception as e:
            error_log = frappe.log_error(
                title=f'Import Error - Row {idx + 1}',
                message=frappe.get_traceback()
            )

            # Continue with next record
            frappe.db.rollback()
```

### Error Report

```python
def generate_error_report(errors):
    """Generate CSV of import errors"""
    import csv
    from io import StringIO

    output = StringIO()
    writer = csv.writer(output)

    writer.writerow(['Row', 'Error', 'Data'])

    for error in errors:
        writer.writerow([
            error['row'],
            error['error'],
            str(error['data'])
        ])

    return output.getvalue()
```

## Key Rules

- ✅ Validate data before import
- ✅ Use batch processing for large datasets
- ✅ Commit after each batch to avoid timeout
- ✅ Log errors and continue processing
- ✅ Use upsert for incremental sync
- ✅ Test import on small dataset first
- ✅ Handle child tables properly
- ✅ Map old IDs to new IDs for relationships
- ✅ Use background jobs for large imports
- ✅ Provide progress updates for long operations
- ❌ Don't import without validation
- ❌ Don't commit entire dataset at once
- ❌ Don't skip error handling
- ❌ Don't ignore duplicate checks
