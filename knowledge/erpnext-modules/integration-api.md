# ERPNext Integration & REST API

> Integrating ERPNext with external systems using REST API and webhooks.

## REST API Basics

### Authentication

**Token-based (Recommended):**
```bash
# Generate API key/secret
User → API Access → Generate Keys

# Use in requests
curl -X GET "https://example.erpnext.com/api/resource/Customer" \
  -H "Authorization: token api_key:api_secret"
```

**Basic Auth:**
```bash
curl -X GET "https://example.erpnext.com/api/resource/Customer" \
  -u "username:password"
```

**OAuth 2.0:**
```
Setup Social Login → OAuth Authorization Server
Suitable for third-party app integrations
```

### API Endpoints

**Base URL:** `https://your-site.erpnext.com/api`

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/resource/{doctype}` | GET | List documents |
| `/api/resource/{doctype}/{name}` | GET | Get document |
| `/api/resource/{doctype}` | POST | Create document |
| `/api/resource/{doctype}/{name}` | PUT | Update document |
| `/api/resource/{doctype}/{name}` | DELETE | Delete document |
| `/api/method/{path}` | POST/GET | Call whitelisted method |

## CRUD Operations

### Create (POST)

```bash
curl -X POST "https://example.erpnext.com/api/resource/Customer" \
  -H "Authorization: token api_key:api_secret" \
  -H "Content-Type: application/json" \
  -d '{
    "customer_name": "New Customer",
    "customer_type": "Individual",
    "customer_group": "Commercial",
    "territory": "All Territories"
  }'
```

```python
import requests

url = "https://example.erpnext.com/api/resource/Customer"
headers = {
    "Authorization": "token api_key:api_secret",
    "Content-Type": "application/json"
}
data = {
    "customer_name": "New Customer",
    "customer_type": "Individual"
}

response = requests.post(url, headers=headers, json=data)
print(response.json())
```

### Read (GET)

```bash
# Get list
curl -X GET "https://example.erpnext.com/api/resource/Customer" \
  -H "Authorization: token api_key:api_secret"

# Get specific document
curl -X GET "https://example.erpnext.com/api/resource/Customer/CUST-001" \
  -H "Authorization: token api_key:api_secret"

# With filters
curl -X GET "https://example.erpnext.com/api/resource/Customer?filters=[[\"customer_type\",\"=\",\"Individual\"]]" \
  -H "Authorization: token api_key:api_secret"

# Limit fields
curl -X GET "https://example.erpnext.com/api/resource/Customer?fields=[\"name\",\"customer_name\",\"email\"]" \
  -H "Authorization: token api_key:api_secret"

# Pagination
curl -X GET "https://example.erpnext.com/api/resource/Customer?limit_start=0&limit_page_length=20" \
  -H "Authorization: token api_key:api_secret"
```

### Update (PUT)

```bash
curl -X PUT "https://example.erpnext.com/api/resource/Customer/CUST-001" \
  -H "Authorization: token api_key:api_secret" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "newemail@example.com",
    "mobile_no": "+1234567890"
  }'
```

### Delete (DELETE)

```bash
curl -X DELETE "https://example.erpnext.com/api/resource/Customer/CUST-001" \
  -H "Authorization: token api_key:api_secret"
```

## Calling Custom Methods

### Whitelisted Method

```python
# my_app/api.py
import frappe

@frappe.whitelist(allow_guest=False)
def get_customer_balance(customer):
    """Get customer outstanding balance"""
    if not frappe.has_permission('Customer', 'read'):
        frappe.throw('No permission')

    balance = frappe.db.get_value('Customer', customer, 'outstanding_amount')
    return {'customer': customer, 'balance': balance}
```

### Call via API

```bash
curl -X POST "https://example.erpnext.com/api/method/my_app.api.get_customer_balance" \
  -H "Authorization: token api_key:api_secret" \
  -H "Content-Type: application/json" \
  -d '{"customer": "CUST-001"}'
```

```python
import requests

url = "https://example.erpnext.com/api/method/my_app.api.get_customer_balance"
headers = {"Authorization": "token api_key:api_secret"}
data = {"customer": "CUST-001"}

response = requests.post(url, headers=headers, json=data)
print(response.json()['message'])
```

## Webhooks

### Setup Webhook

1. Setup → Integrations → Webhook
2. Webhook DocType: Sales Order
3. Request URL: https://external-system.com/webhook
4. Webhook Event: On Submit
5. Condition: doc.grand_total > 10000
6. Save

### Webhook Payload

```json
{
  "doctype": "Sales Order",
  "name": "SO-0001",
  "customer": "CUST-001",
  "grand_total": 15000,
  "items": [
    {
      "item_code": "ITEM-001",
      "qty": 10,
      "rate": 1500
    }
  ]
}
```

### Receive Webhook

```python
# Flask example
from flask import Flask, request

app = Flask(__name__)

@app.route('/webhook', methods=['POST'])
def handle_webhook():
    data = request.json

    # Process webhook
    if data.get('doctype') == 'Sales Order':
        order_name = data.get('name')
        customer = data.get('customer')

        # Your logic here
        process_order(order_name, customer)

    return {'status': 'success'}
```

## Integration Patterns

### Sync Customer to External CRM

```python
# hooks.py
doc_events = {
    "Customer": {
        "after_insert": "my_app.integrations.sync_customer_to_crm",
        "on_update": "my_app.integrations.sync_customer_to_crm"
    }
}

# my_app/integrations.py
import requests
import frappe

def sync_customer_to_crm(doc, method):
    """Sync customer to external CRM"""
    crm_url = frappe.conf.get('crm_api_url')
    crm_key = frappe.conf.get('crm_api_key')

    if not crm_url:
        return

    payload = {
        'name': doc.customer_name,
        'email': doc.email,
        'phone': doc.mobile_no,
        'company': doc.customer_name
    }

    try:
        response = requests.post(
            f'{crm_url}/contacts',
            headers={'Authorization': f'Bearer {crm_key}'},
            json=payload
        )

        if response.status_code == 200:
            # Store external ID
            doc.db_set('external_crm_id', response.json()['id'], update_modified=False)
            frappe.logger().info(f'Customer {doc.name} synced to CRM')

    except Exception as e:
        frappe.log_error(frappe.get_traceback(), 'CRM Sync Failed')
```

### Import Orders from E-commerce

```python
# my_app/tasks.py
import frappe
import requests

def import_ecommerce_orders():
    """Scheduled job to import orders"""
    api_url = frappe.conf.get('ecommerce_api_url')
    api_key = frappe.conf.get('ecommerce_api_key')

    # Get orders from last sync
    last_sync = frappe.db.get_single_value('Integration Settings', 'last_order_sync')

    response = requests.get(
        f'{api_url}/orders',
        headers={'Authorization': f'Bearer {api_key}'},
        params={'since': last_sync}
    )

    orders = response.json()

    for order_data in orders:
        # Check if already imported
        if frappe.db.exists('Sales Order', {'external_order_id': order_data['id']}):
            continue

        # Create Sales Order
        so = frappe.get_doc({
            'doctype': 'Sales Order',
            'customer': get_or_create_customer(order_data['customer']),
            'external_order_id': order_data['id'],
            'transaction_date': order_data['date'],
            'items': [
                {
                    'item_code': item['sku'],
                    'qty': item['quantity'],
                    'rate': item['price']
                }
                for item in order_data['items']
            ]
        })
        so.insert()
        so.submit()

    # Update last sync time
    frappe.db.set_single_value('Integration Settings', 'last_order_sync', frappe.utils.now())
    frappe.db.commit()
```

### Real-time Stock Sync

```python
# hooks.py
doc_events = {
    "Stock Ledger Entry": {
        "on_submit": "my_app.integrations.update_external_stock"
    }
}

# my_app/integrations.py
def update_external_stock(doc, method):
    """Update stock in external warehouse system"""
    if doc.voucher_type != 'Stock Entry':
        return

    # Get current stock
    stock_qty = frappe.db.get_value('Bin', {
        'item_code': doc.item_code,
        'warehouse': doc.warehouse
    }, 'actual_qty')

    # Push to external system
    frappe.enqueue(
        'my_app.integrations.push_stock_update',
        item_code=doc.item_code,
        warehouse=doc.warehouse,
        qty=stock_qty
    )

def push_stock_update(item_code, warehouse, qty):
    """Background job to push stock"""
    api_url = frappe.conf.get('warehouse_api_url')

    try:
        response = requests.post(
            f'{api_url}/stock/update',
            json={
                'sku': item_code,
                'location': warehouse,
                'quantity': qty
            }
        )

        if response.status_code != 200:
            frappe.log_error(response.text, 'Stock Sync Failed')

    except Exception as e:
        frappe.log_error(frappe.get_traceback(), 'Stock Sync Error')
```

## Configuration

### Store API Credentials

```python
# site_config.json (NOT committed to git)
{
    "external_api_url": "https://api.external.com",
    "external_api_key": "secret_key_here"
}

# Access in code
api_url = frappe.conf.get('external_api_url')
api_key = frappe.conf.get('external_api_key')
```

### Custom DocType for Settings

```python
# Create "Integration Settings" Single DocType
{
    "doctype": "DocType",
    "name": "Integration Settings",
    "issingle": 1,
    "fields": [
        {"fieldname": "crm_api_url", "fieldtype": "Data"},
        {"fieldname": "crm_api_key", "fieldtype": "Password"},
        {"fieldname": "last_sync", "fieldtype": "Datetime"}
    ]
}

# Access
settings = frappe.get_single('Integration Settings')
api_url = settings.crm_api_url
```

## Error Handling

```python
import requests
import frappe

def call_external_api(url, data):
    """Robust API call with retry"""
    max_retries = 3
    retry_count = 0

    while retry_count < max_retries:
        try:
            response = requests.post(url, json=data, timeout=30)

            if response.status_code == 200:
                return response.json()

            elif response.status_code in [401, 403]:
                frappe.throw('Authentication failed')

            elif response.status_code >= 500:
                # Server error - retry
                retry_count += 1
                continue

            else:
                # Client error - don't retry
                frappe.log_error(response.text, 'API Error')
                frappe.throw(f'API error: {response.status_code}')

        except requests.Timeout:
            retry_count += 1
            frappe.logger().warning(f'API timeout, retry {retry_count}')

        except Exception as e:
            frappe.log_error(frappe.get_traceback(), 'API Call Failed')
            raise

    frappe.throw('API call failed after retries')
```

## Python Client Example

```python
import requests

class ERPNextClient:
    def __init__(self, base_url, api_key, api_secret):
        self.base_url = base_url.rstrip('/')
        self.headers = {
            'Authorization': f'token {api_key}:{api_secret}',
            'Content-Type': 'application/json'
        }

    def get_list(self, doctype, filters=None, fields=None, limit=20):
        """Get list of documents"""
        params = {'limit_page_length': limit}

        if filters:
            params['filters'] = str(filters)
        if fields:
            params['fields'] = str(fields)

        response = requests.get(
            f'{self.base_url}/api/resource/{doctype}',
            headers=self.headers,
            params=params
        )
        response.raise_for_status()
        return response.json()['data']

    def get_doc(self, doctype, name):
        """Get single document"""
        response = requests.get(
            f'{self.base_url}/api/resource/{doctype}/{name}',
            headers=self.headers
        )
        response.raise_for_status()
        return response.json()['data']

    def create_doc(self, doctype, data):
        """Create document"""
        response = requests.post(
            f'{self.base_url}/api/resource/{doctype}',
            headers=self.headers,
            json=data
        )
        response.raise_for_status()
        return response.json()['data']

    def update_doc(self, doctype, name, data):
        """Update document"""
        response = requests.put(
            f'{self.base_url}/api/resource/{doctype}/{name}',
            headers=self.headers,
            json=data
        )
        response.raise_for_status()
        return response.json()['data']

    def call_method(self, method, **kwargs):
        """Call whitelisted method"""
        response = requests.post(
            f'{self.base_url}/api/method/{method}',
            headers=self.headers,
            json=kwargs
        )
        response.raise_for_status()
        return response.json()['message']

# Usage
client = ERPNextClient(
    'https://example.erpnext.com',
    'api_key',
    'api_secret'
)

# Get customers
customers = client.get_list('Customer', filters=[['customer_type', '=', 'Individual']])

# Create sales order
order = client.create_doc('Sales Order', {
    'customer': 'CUST-001',
    'items': [
        {'item_code': 'ITEM-001', 'qty': 10, 'rate': 100}
    ]
})

# Call custom method
balance = client.call_method('my_app.api.get_customer_balance', customer='CUST-001')
```

## Key Rules

- ✅ Use API key/secret for authentication
- ✅ Always check permissions in whitelisted methods
- ✅ Use webhooks for real-time sync
- ✅ Use background jobs for heavy integrations
- ✅ Implement retry logic for external APIs
- ✅ Log all integration errors
- ✅ Store credentials in site_config.json
- ✅ Use pagination for large datasets
- ✅ Validate data before creating documents
- ✅ Handle rate limits and timeouts
- ❌ Don't hardcode API keys in code
- ❌ Don't skip error handling
- ❌ Don't sync in real-time for heavy operations
