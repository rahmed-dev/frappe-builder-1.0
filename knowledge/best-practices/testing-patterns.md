# Testing Patterns

> Unit testing best practices for Frappe/ERPNext applications.

## Test Structure

### File Organization

```
my_app/
├── my_app/
│   ├── doctype/
│   │   └── my_doctype/
│   │       ├── my_doctype.py
│   │       └── test_my_doctype.py      # Unit tests
│   └── tests/
│       ├── __init__.py
│       ├── test_api.py                  # API tests
│       └── test_utils.py                # Utility tests
└── tests/
    └── test_integration.py               # Integration tests
```

### Test Class Pattern

```python
# test_my_doctype.py
import frappe
import unittest

class TestMyDocType(unittest.TestCase):
    def setUp(self):
        """Runs before each test"""
        self.test_doc = self.create_test_doc()

    def tearDown(self):
        """Runs after each test"""
        frappe.db.rollback()

    def test_validation(self):
        """Test validation logic"""
        doc = self.test_doc
        doc.qty = -1

        with self.assertRaises(frappe.ValidationError):
            doc.save()

    def create_test_doc(self):
        """Helper to create test data"""
        return frappe.get_doc({
            'doctype': 'My DocType',
            'name': '_Test MyDocType',
            'qty': 10
        })
```

## Running Tests

### Command Line

```bash
# Run all tests
bench --site site-name run-tests

# Test specific app
bench --site site-name run-tests --app my_app

# Test specific module
bench --site site-name run-tests --module my_app.tests.test_api

# Test specific DocType
bench --site site-name run-tests --doctype "My DocType"

# Verbose output
bench --site site-name run-tests --verbose

# Fail fast (stop on first failure)
bench --site site-name run-tests --failfast
```

## Testing Patterns

### Test Validation Logic

```python
def test_end_date_validation(self):
    """End date must be after start date"""
    doc = frappe.get_doc({
        'doctype': 'Task',
        'subject': 'Test Task',
        'exp_start_date': '2025-12-31',
        'exp_end_date': '2025-01-01'  # Before start!
    })

    with self.assertRaises(frappe.ValidationError) as cm:
        doc.insert()

    self.assertIn('End date cannot be before start date', str(cm.exception))
```

### Test Calculations

```python
def test_total_calculation(self):
    """Test item total calculation"""
    doc = frappe.get_doc({
        'doctype': 'Sales Order',
        'customer': '_Test Customer',
        'items': [
            {'item_code': '_Test Item', 'qty': 10, 'rate': 100},
            {'item_code': '_Test Item 2', 'qty': 5, 'rate': 200}
        ]
    })
    doc.insert()

    # Check totals
    self.assertEqual(doc.items[0].amount, 1000)
    self.assertEqual(doc.items[1].amount, 1000)
    self.assertEqual(doc.total, 2000)
```

### Test Permissions

```python
def test_user_permission(self):
    """Test user can only access assigned tasks"""
    # Create user with limited access
    user = frappe.get_doc({
        'doctype': 'User',
        'email': '_test_user@example.com',
        'first_name': 'Test'
    })
    user.insert()

    frappe.set_user('_test_user@example.com')

    # Should not have access
    self.assertFalse(
        frappe.has_permission('Task', 'read', '_Test Task')
    )

    # Add user permission
    frappe.defaults.add_user_permission(
        'Task', '_Test Task', '_test_user@example.com'
    )

    # Now should have access
    self.assertTrue(
        frappe.has_permission('Task', 'read', '_Test Task')
    )

    # Cleanup
    frappe.set_user('Administrator')
```

### Test API Methods

```python
def test_whitelisted_method(self):
    """Test API method"""
    from my_app.api import get_tasks

    # Call method
    result = get_tasks(status='Open')

    # Verify result
    self.assertIsInstance(result, list)
    for task in result:
        self.assertEqual(task['status'], 'Open')
```

### Test Hooks

```python
def test_on_submit_hook(self):
    """Test document hook creates linked record"""
    task = frappe.get_doc({
        'doctype': 'Task',
        'subject': 'Test Task'
    })
    task.insert()
    task.submit()

    # Check hook created linked record
    log = frappe.get_all(
        'Activity Log',
        filters={'reference_name': task.name}
    )
    self.assertEqual(len(log), 1)
```

### Test Background Jobs

```python
def test_background_job(self):
    """Test enqueued job"""
    from my_app.tasks import process_task

    # Mock enqueue
    with mock.patch('frappe.enqueue') as mock_enqueue:
        trigger_job('_Test Task')

        # Verify enqueue was called
        mock_enqueue.assert_called_once()
        args, kwargs = mock_enqueue.call_args
        self.assertEqual(args[0], 'my_app.tasks.process_task')

    # Test actual job function
    result = process_task('_Test Task')
    self.assertTrue(result['success'])
```

## Test Data Management

### Using Fixtures

```python
# hooks.py
fixtures = [
    {
        "dt": "Item",
        "filters": [["name", "like", "_Test%"]]
    }
]
```

```bash
# Export test data
bench --site site-name export-fixtures
```

### Creating Test Records

```python
def make_test_customer():
    """Create test customer if not exists"""
    if not frappe.db.exists('Customer', '_Test Customer'):
        customer = frappe.get_doc({
            'doctype': 'Customer',
            'customer_name': '_Test Customer',
            'customer_type': 'Individual'
        })
        customer.insert(ignore_permissions=True)
    return frappe.get_doc('Customer', '_Test Customer')
```

### Cleanup Pattern

```python
def tearDown(self):
    """Clean up test data"""
    # Rollback database changes
    frappe.db.rollback()

    # Delete test records
    frappe.delete_doc('Task', '_Test Task', force=1)

    # Clear cache
    frappe.clear_cache()
```

## Mocking

### Mock External API

```python
import mock

def test_external_api_call(self):
    """Test function that calls external API"""
    with mock.patch('requests.get') as mock_get:
        # Mock response
        mock_get.return_value.json.return_value = {'status': 'success'}
        mock_get.return_value.status_code = 200

        # Call function
        result = sync_external_data()

        # Verify
        self.assertTrue(result['success'])
        mock_get.assert_called_once()
```

### Mock Frappe Methods

```python
def test_with_mocked_db(self):
    """Test with mocked database call"""
    with mock.patch('frappe.db.get_value') as mock_get_value:
        mock_get_value.return_value = 'Test Company'

        result = get_company_name()

        self.assertEqual(result, 'Test Company')
        mock_get_value.assert_called_with('Company', filters={'is_default': 1}, fieldname='name')
```

## Testing Edge Cases

### Test Empty Data

```python
def test_empty_items(self):
    """Test order with no items"""
    doc = frappe.get_doc({
        'doctype': 'Sales Order',
        'customer': '_Test Customer',
        'items': []  # Empty!
    })

    with self.assertRaises(frappe.ValidationError):
        doc.insert()
```

### Test Boundary Values

```python
def test_quantity_boundaries(self):
    """Test min/max quantity"""
    # Test zero
    with self.assertRaises(frappe.ValidationError):
        create_item(qty=0)

    # Test negative
    with self.assertRaises(frappe.ValidationError):
        create_item(qty=-1)

    # Test valid
    doc = create_item(qty=1)
    self.assertEqual(doc.qty, 1)

    # Test max
    doc = create_item(qty=9999999)
    self.assertEqual(doc.qty, 9999999)
```

### Test Concurrent Access

```python
def test_concurrent_updates(self):
    """Test optimistic locking"""
    doc1 = frappe.get_doc('Task', '_Test Task')
    doc2 = frappe.get_doc('Task', '_Test Task')

    doc1.status = 'Completed'
    doc1.save()

    doc2.status = 'Cancelled'

    # Should detect concurrent modification
    with self.assertRaises(frappe.TimestampMismatchError):
        doc2.save()
```

## Integration Tests

### Test Complete Workflow

```python
def test_sales_order_to_invoice_flow(self):
    """Test complete order-to-payment flow"""
    # Create Sales Order
    so = frappe.get_doc({
        'doctype': 'Sales Order',
        'customer': '_Test Customer',
        'items': [{'item_code': '_Test Item', 'qty': 10, 'rate': 100}]
    })
    so.insert()
    so.submit()

    # Create Delivery Note
    dn = frappe.get_mapped_doc('Sales Order', so.name, target_doc='Delivery Note')
    dn.insert()
    dn.submit()

    # Create Sales Invoice
    si = frappe.get_mapped_doc('Sales Order', so.name, target_doc='Sales Invoice')
    si.insert()
    si.submit()

    # Verify stock
    stock_qty = frappe.db.get_value('Bin', {
        'item_code': '_Test Item',
        'warehouse': dn.items[0].warehouse
    }, 'actual_qty')

    self.assertIsNotNone(stock_qty)

    # Create Payment
    payment = frappe.get_doc({
        'doctype': 'Payment Entry',
        'payment_type': 'Receive',
        'party_type': 'Customer',
        'party': '_Test Customer',
        'paid_amount': 1000,
        'received_amount': 1000
    })
    payment.append('references', {
        'reference_doctype': 'Sales Invoice',
        'reference_name': si.name,
        'allocated_amount': 1000
    })
    payment.insert()
    payment.submit()

    # Verify outstanding
    outstanding = frappe.db.get_value('Sales Invoice', si.name, 'outstanding_amount')
    self.assertEqual(outstanding, 0)
```

## Performance Testing

### Test Query Performance

```python
import time

def test_query_performance(self):
    """Test query completes in acceptable time"""
    start = time.time()

    # Run query
    tasks = frappe.get_all('Task', filters={'status': 'Open'}, limit=1000)

    duration = time.time() - start

    # Should complete in < 1 second
    self.assertLess(duration, 1.0)
```

## Coverage

### Check Test Coverage

```bash
# Install coverage
pip install coverage

# Run with coverage
coverage run -m unittest discover apps/my_app/my_app/tests

# Generate report
coverage report

# Generate HTML report
coverage html
open htmlcov/index.html
```

## Continuous Integration

### GitHub Actions Example

```yaml
# .github/workflows/test.yml
name: Run Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.10'
      - name: Install dependencies
        run: |
          pip install frappe-bench
          bench init frappe-bench --skip-redis-config-generation
      - name: Run tests
        run: |
          cd frappe-bench
          bench --site test_site install-app my_app
          bench --site test_site run-tests --app my_app
```

## Test Best Practices

- ✅ Test behavior, not implementation
- ✅ Use descriptive test names
- ✅ One assertion per test (when possible)
- ✅ Test edge cases and boundaries
- ✅ Clean up test data in tearDown
- ✅ Use fixtures for consistent test data
- ✅ Mock external dependencies
- ✅ Test error conditions
- ✅ Achieve >80% code coverage
- ✅ Run tests before commit
- ❌ Don't test framework code
- ❌ Don't skip test cleanup
- ❌ Don't use production data in tests

## Key Rules

- ✅ Write tests for all business logic
- ✅ Use `setUp()` and `tearDown()` properly
- ✅ Test validation, calculations, permissions
- ✅ Mock external APIs and services
- ✅ Test edge cases and error conditions
- ✅ Name tests descriptively (`test_what_it_does`)
- ✅ Clean up test data after each test
- ✅ Use `frappe.db.rollback()` in tearDown
- ✅ Aim for >80% code coverage
- ✅ Run tests in CI/CD pipeline
- ❌ Don't skip writing tests
- ❌ Don't test Frappe framework itself
