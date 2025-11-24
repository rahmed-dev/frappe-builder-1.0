# Performance Rules

Optimize Frappe applications for speed and scalability.

## 1. Database Query Optimization

### Use Appropriate Methods

| Scenario | ❌ Slow | ✅ Fast | Speedup |
|----------|---------|---------|---------|
| Single field | get_doc() | get_value() | 10x |
| Exists check | get_doc() | exists() | 20x |
| Count records | get_all() then len() | count() | 15x |
| List with filters | get_all() then filter in Python | filters in get_all() | 5x |

### Examples

```python
❌ SLOW - Loads entire document:
doc = frappe.get_doc("Sales Order", name)
customer = doc.customer  # Only needed customer field

✅ FAST - Get single field:
customer = frappe.db.get_value("Sales Order", name, "customer")

❌ SLOW - Loads doc to check existence:
try:
    doc = frappe.get_doc("Customer", customer_name)
    exists = True
except:
    exists = False

✅ FAST - Direct exists check:
exists = frappe.db.exists("Customer", customer_name)

❌ SLOW - Load all then count:
records = frappe.get_all("Sales Order", filters={"status": "Open"})
count = len(records)

✅ FAST - Database count:
count = frappe.db.count("Sales Order", {"status": "Open"})
```

## 2. Server-Side Filtering

**Rule:** Filter at database level, not in application code.

```python
❌ SLOW - Client-side filtering:
all_orders = frappe.get_all("Sales Order", fields=["*"])
open_orders = [o for o in all_orders if o.status == "Open"]

✅ FAST - Server-side filtering:
open_orders = frappe.get_all("Sales Order",
    filters={"status": "Open"},
    fields=["name", "customer", "total"])
```

### Complex Filters

```python
# Multiple conditions
orders = frappe.get_all("Sales Order",
    filters={
        "status": "Open",
        "customer": customer,
        "date": [">=", from_date]
    },
    fields=["name", "total"])

# OR conditions
orders = frappe.get_all("Sales Order",
    filters={
        "status": ["in", ["Open", "Pending"]],
        "date": [">=", from_date]
    })
```

## 3. Index Critical Fields

**Rule:** Add database indexes for frequently filtered/searched fields.

### Check Slow Queries

```python
# Enable query logging in site_config.json
{
    "logging": 2,  # Log all queries
    "db_query_execution_timeout": 1.0  # Log queries > 1 second
}
```

### Add Indexes

```python
# In DocType JSON, add to field definition:
{
    "fieldname": "customer",
    "fieldtype": "Link",
    "options": "Customer",
    "search_index": 1  # Adds database index
}

# Or via migration:
frappe.db.add_index("Sales Order", ["customer", "status"])
```

### When to Index

**Index if field is:**
- Used in WHERE clauses frequently
- Used in JOIN conditions
- Foreign key (Link field)
- Sorted/grouped often

**Don't index:**
- Rarely queried fields
- High-cardinality text fields (descriptions)
- Frequently updated fields

## 4. Batch Operations

**Rule:** Process bulk data in batches, not loops.

```python
❌ SLOW - Individual operations:
for item_code in item_codes:  # 1000 items
    frappe.db.set_value("Item", item_code, "disabled", 1)
    # 1000 database queries

✅ FAST - Batch update:
frappe.db.sql("""
    UPDATE `tabItem`
    SET disabled=1
    WHERE name IN %s
""", (tuple(item_codes),))
# 1 database query

❌ SLOW - Individual inserts:
for row in data:  # 1000 rows
    doc = frappe.get_doc({"doctype": "Item", ...})
    doc.insert()
    # 1000 inserts + validation overhead

✅ FAST - Bulk insert:
frappe.db.bulk_insert("Item", fields, values)
# Or use sql with INSERT INTO ... VALUES
```

## 5. Caching Strategies

### frappe.cache()

```python
from frappe.utils import cache

@cache()  # Default 1 hour TTL
def get_exchange_rate(from_currency, to_currency):
    # Expensive API call
    rate = fetch_from_external_api(from_currency, to_currency)
    return rate

# Specify TTL (in seconds)
@cache(ttl=300)  # 5 minutes
def get_stock_price(symbol):
    return fetch_stock_price(symbol)
```

### Manual Caching

```python
# Set cache
frappe.cache().set_value("cache_key", value, expires_in_sec=3600)

# Get cache
value = frappe.cache().get_value("cache_key")

# Delete cache
frappe.cache().delete_value("cache_key")

# Cache with hashing (for complex keys)
from frappe.utils import cint
cache_key = f"customer_{customer}_orders_{cint(include_cancelled)}"
```

### What to Cache

**Cache:**
- External API responses
- Expensive calculations
- Rarely changing reference data
- User preferences

**Don't cache:**
- User-specific transactional data
- Real-time data (stock levels, order status)
- Security-sensitive information

## 6. Background Jobs

**Rule:** Offload long-running operations to background queue.

### Enqueue Tasks

```python
# Long-running operation
@frappe.whitelist()
def send_bulk_emails(recipients):
    # Don't run in request thread
    frappe.enqueue(
        method="app.tasks.send_emails_task",
        queue="long",  # Queue: short, default, long
        timeout=3000,
        recipients=recipients
    )
    return "Emails queued for sending"

# In tasks.py
def send_emails_task(recipients):
    for recipient in recipients:
        frappe.sendmail(recipients=[recipient], ...)
```

### Queue Selection

| Queue | Timeout | Use For |
|-------|---------|---------|
| **short** | 300s (5 min) | Quick async tasks |
| **default** | 600s (10 min) | Standard operations |
| **long** | 1500s (25 min) | Bulk processing, reports |

### Enqueue at DocType Level

```python
# In controller
def on_submit(self):
    # Enqueue document method
    frappe.enqueue_doc(
        self.doctype,
        self.name,
        method="create_delivery_note",
        queue="default"
    )

def create_delivery_note(self):
    # Runs in background
    dn = frappe.get_doc({...})
    dn.insert()
```

## 7. Optimize Loops

```python
❌ SLOW - Database query per iteration:
for item in items:  # 100 items
    item_doc = frappe.get_doc("Item", item.item_code)
    item.item_name = item_doc.item_name
    # 100 queries

✅ FAST - Single query, dictionary lookup:
item_codes = [item.item_code for item in items]
item_map = {d.name: d.item_name for d in frappe.get_all(
    "Item",
    filters={"name": ["in", item_codes]},
    fields=["name", "item_name"]
)}
for item in items:
    item.item_name = item_map.get(item.item_code)
# 1 query
```

## 8. Limit Data Transfer

```python
❌ SLOW - Fetch all fields:
orders = frappe.get_all("Sales Order", fields=["*"])

✅ FAST - Fetch only needed fields:
orders = frappe.get_all("Sales Order",
    fields=["name", "customer", "total"])

❌ SLOW - No pagination:
orders = frappe.get_all("Sales Order")  # Could be 100k records

✅ FAST - Paginate:
orders = frappe.get_all("Sales Order",
    start=0,
    page_length=20)  # Load 20 at a time
```

## 9. Avoid N+1 Queries

**Problem:** Query in loop creates N+1 database calls.

```python
❌ N+1 PROBLEM:
orders = frappe.get_all("Sales Order", fields=["name"])  # 1 query
for order in orders:  # N queries
    customer = frappe.db.get_value("Sales Order", order.name, "customer")

✅ SOLUTION - Fetch with needed fields:
orders = frappe.get_all("Sales Order",
    fields=["name", "customer"])  # 1 query with JOIN

✅ ALTERNATIVE - Preload related data:
orders = frappe.get_all("Sales Order", fields=["name", "customer"])
customers = {d.name: d for d in frappe.get_all("Customer", ...)}
for order in orders:
    customer_data = customers.get(order.customer)
```

## 10. Client-Side Optimization

### Debounce Search

```javascript
❌ SLOW - Query on every keystroke:
frappe.ui.form.on("Sales Order", "customer", function(frm) {
    frappe.call({
        method: "get_customer_details",
        args: {customer: frm.doc.customer}
    });
});

✅ FAST - Debounce:
frappe.ui.form.on("Sales Order", "customer",
    frappe.utils.debounce(function(frm) {
        frappe.call({
            method: "get_customer_details",
            args: {customer: frm.doc.customer}
        });
    }, 300)  // Wait 300ms after last keystroke
);
```

### Lazy Load Data

```javascript
// Load data only when tab is clicked
frappe.ui.form.on("Sales Order", {
    refresh: function(frm) {
        // Don't load heavy data on form load
    },

    sales_analytics_tab: function(frm) {
        // Load analytics only when tab is viewed
        load_sales_analytics(frm);
    }
});
```

## Performance Checklist

Optimize for:
- [ ] Using get_value() for single fields (not get_doc())
- [ ] Server-side filtering (not client-side)
- [ ] Indexed fields for frequent queries
- [ ] Batch operations (not loops with individual queries)
- [ ] Caching expensive operations (API calls, calculations)
- [ ] Background jobs for long operations (>5 seconds)
- [ ] Preloading related data (avoid N+1)
- [ ] Limiting fields fetched (not SELECT *)
- [ ] Pagination for large datasets
- [ ] Debouncing user input triggers

## Monitoring Performance

### Enable Logging

```json
// site_config.json
{
    "logging": 2,
    "db_query_execution_timeout": 1.0,
    "enable_frappe_logger": true
}
```

### Analyze Queries

```python
# In code - profile queries
import frappe
frappe.db.sql("SET profiling = 1")

# Run your operation
result = frappe.get_all("Sales Order", ...)

# Check query profile
profiles = frappe.db.sql("SHOW PROFILES", as_dict=True)
for profile in profiles:
    print(f"Query: {profile.Query_ID}, Duration: {profile.Duration}")
```

### Use bench doctor

```bash
bench doctor
# Shows: Database size, site config, background jobs, errors
```

## Related

- [Coding Principles](./coding-principles.md)
- [Security Guidelines](./security-guidelines.md)
- [Database Optimization](https://frappeframework.com/docs/user/en/database)
