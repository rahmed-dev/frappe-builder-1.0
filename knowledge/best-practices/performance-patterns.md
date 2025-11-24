# Performance Optimization Patterns

> Performance best practices for Frappe/ERPNext development.

## Database Query Optimization

### Fetch Only Needed Fields

```python
# ❌ SLOW - fetches all fields
tasks = frappe.get_all('Task')

# ✅ FAST - fetch only needed fields
tasks = frappe.get_all(
    'Task',
    fields=['name', 'subject', 'status']
)

# ✅ FASTEST - fetch single field
task_names = frappe.get_all('Task', pluck='name')
```

### Limit Results

```python
# ❌ SLOW - fetches all records
all_tasks = frappe.get_all('Task')

# ✅ FAST - limit results
recent_tasks = frappe.get_all(
    'Task',
    fields=['name', 'subject'],
    order_by='creation desc',
    limit=20
)
```

### Use Proper Filters

```python
# ❌ SLOW - fetch all, filter client-side
all_tasks = frappe.get_all('Task', fields=['name', 'status'])
open_tasks = [t for t in all_tasks if t.status == 'Open']

# ✅ FAST - filter in database
open_tasks = frappe.get_all(
    'Task',
    filters={'status': 'Open'},
    fields=['name', 'subject']
)
```

### Avoid N+1 Queries

```python
# ❌ SLOW - N+1 query problem
tasks = frappe.get_all('Task', fields=['name', 'project'])
for task in tasks:
    project = frappe.get_doc('Project', task.project)  # N queries!
    print(project.project_name)

# ✅ FAST - single join query
data = frappe.db.sql("""
    SELECT t.name, t.subject, p.project_name
    FROM `tabTask` t
    LEFT JOIN `tabProject` p ON t.project = p.name
    WHERE t.status = 'Open'
""", as_dict=True)
```

## Batch Processing

### Process in Batches

```python
# ❌ SLOW - process all at once
def update_all_tasks():
    tasks = frappe.get_all('Task', pluck='name')  # 10,000 tasks

    for task_name in tasks:
        doc = frappe.get_doc('Task', task_name)
        doc.status = 'Updated'
        doc.save()

    frappe.db.commit()  # Huge transaction


# ✅ FAST - batch processing
def update_all_tasks():
    batch_size = 100
    offset = 0

    while True:
        tasks = frappe.get_all(
            'Task',
            fields=['name'],
            limit=batch_size,
            start=offset
        )

        if not tasks:
            break

        for task in tasks:
            doc = frappe.get_doc('Task', task.name)
            doc.status = 'Updated'
            doc.save()

        frappe.db.commit()  # Commit per batch
        offset += batch_size
```

### Bulk Updates

```python
# ❌ SLOW - update one by one
for task_name in task_names:
    frappe.db.set_value('Task', task_name, 'status', 'Completed')

# ✅ FAST - bulk update
frappe.db.sql("""
    UPDATE `tabTask`
    SET status = 'Completed'
    WHERE name IN %(names)s
""", {'names': task_names})

frappe.db.commit()
```

## Background Jobs

### Move Long Operations to Queue

```python
# ❌ SLOW - blocks web request
@frappe.whitelist()
def process_large_report():
    # Takes 5 minutes
    data = generate_report()
    return data  # User waits 5 minutes!


# ✅ FAST - background job
@frappe.whitelist()
def process_large_report():
    frappe.enqueue(
        'my_app.tasks.generate_report',
        queue='long',
        timeout=3600,
        user=frappe.session.user
    )

    return {'message': 'Report generation started'}

# In my_app/tasks.py
def generate_report():
    data = # ... expensive operation
    # Email result to user
    frappe.sendmail(
        recipients=[frappe.session.user],
        subject='Report Ready',
        message='Your report is ready'
    )
```

### Queue Selection

| Queue | Timeout | Use Case |
|-------|---------|----------|
| `default` | 300s | Normal operations |
| `short` | 60s | Quick tasks |
| `long` | 1800s | Heavy processing, reports |

```python
# Short task
frappe.enqueue('my_app.tasks.send_email', queue='short')

# Long task
frappe.enqueue('my_app.tasks.process_payroll', queue='long', timeout=3600)
```

## Caching

### Cache Static Data

```python
from frappe.utils import cint

# ❌ SLOW - query every time
def get_item_price(item_code):
    return frappe.db.get_value('Item Price', {'item_code': item_code}, 'price_list_rate')


# ✅ FAST - cache result
def get_item_price(item_code):
    cache_key = f'item_price:{item_code}'

    # Check cache
    price = frappe.cache().get_value(cache_key)

    if price is None:
        # Cache miss - fetch from DB
        price = frappe.db.get_value('Item Price', {'item_code': item_code}, 'price_list_rate')

        # Cache for 1 hour
        frappe.cache().set_value(cache_key, price, expires_in_sec=3600)

    return price
```

### Clear Cache When Needed

```python
class ItemPrice(Document):
    def on_update(self):
        # Clear cache when price changes
        cache_key = f'item_price:{self.item_code}'
        frappe.cache().delete_value(cache_key)
```

### Cache Expensive Computations

```python
# ✅ Cache expensive calculations
def get_project_stats(project_name):
    cache_key = f'project_stats:{project_name}'

    stats = frappe.cache().get_value(cache_key)

    if stats is None:
        # Expensive computation
        stats = {
            'total_tasks': frappe.db.count('Task', {'project': project_name}),
            'completed': frappe.db.count('Task', {'project': project_name, 'status': 'Completed'}),
            'total_hours': frappe.db.sql("""
                SELECT SUM(hours) FROM `tabTimesheet Detail`
                WHERE project = %(project)s
            """, {'project': project_name})[0][0] or 0
        }

        frappe.cache().set_value(cache_key, stats, expires_in_sec=1800)

    return stats
```

## Index Usage

### Add Database Indexes

```python
# DocType JSON - add index for frequently filtered fields
{
    "fields": [
        {
            "fieldname": "status",
            "fieldtype": "Select",
            "search_index": 1  # Creates DB index
        },
        {
            "fieldname": "customer",
            "fieldtype": "Link",
            "options": "Customer",
            "search_index": 1
        }
    ]
}
```

### Query Indexed Fields

```python
# ✅ Uses index
tasks = frappe.get_all('Task', filters={'status': 'Open'})

# ❌ Full table scan
tasks = frappe.get_all('Task', filters={'description': ['like', '%urgent%']})
```

## Avoid Over-Fetching

### Lazy Loading

```python
# ❌ SLOW - loads all child rows
doc = frappe.get_doc('Sales Order', 'SO-0001')
# Automatically loads all items

# ✅ FAST - load only when needed
doc = frappe.get_doc('Sales Order', 'SO-0001')
if need_items:
    items = doc.items  # Load child table only if needed
```

### Pagination

```python
# ✅ Implement pagination for large lists
@frappe.whitelist()
def get_tasks(page=1, page_size=20):
    page = cint(page)
    page_size = cint(page_size)

    start = (page - 1) * page_size

    tasks = frappe.get_all(
        'Task',
        fields=['name', 'subject', 'status'],
        limit=page_size,
        start=start,
        order_by='creation desc'
    )

    total = frappe.db.count('Task')

    return {
        'tasks': tasks,
        'total': total,
        'page': page,
        'pages': (total + page_size - 1) // page_size
    }
```

## Client-Side Performance

### Debounce Search

```javascript
// ✅ Debounce search to reduce API calls
let timeout;
$('#search').on('input', function() {
    clearTimeout(timeout);
    timeout = setTimeout(() => {
        search($(this).val());
    }, 300);  // Wait 300ms after typing stops
});
```

### Lazy Load Images

```javascript
// ✅ Load images only when visible
<img data-src="/path/to/image.jpg" class="lazy-load">

// JavaScript
const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            const img = entry.target;
            img.src = img.dataset.src;
            observer.unobserve(img);
        }
    });
});

document.querySelectorAll('.lazy-load').forEach(img => {
    observer.observe(img);
});
```

## Report Optimization

### Script Reports

```python
# ❌ SLOW - fetch all data, process in Python
def execute(filters=None):
    data = frappe.get_all('Task', fields=['*'])

    # Process in Python
    result = []
    for task in data:
        if task.status == 'Open':
            result.append(task)

    return columns, result


# ✅ FAST - filter in SQL
def execute(filters=None):
    status = filters.get('status', 'Open')

    data = frappe.db.sql("""
        SELECT name, subject, status, assigned_to
        FROM `tabTask`
        WHERE status = %(status)s
        ORDER BY creation DESC
        LIMIT 1000
    """, {'status': status}, as_dict=True)

    return columns, data
```

## Memory Management

### Avoid Loading Large Data

```python
# ❌ Memory intensive
all_tasks = frappe.get_all('Task', fields=['*'])  # Loads everything into memory

# ✅ Stream or batch process
def process_all_tasks():
    batch_size = 100
    offset = 0

    while True:
        tasks = frappe.get_all('Task', limit=batch_size, start=offset)

        if not tasks:
            break

        process_batch(tasks)

        offset += batch_size
        tasks = None  # Free memory
```

## Profiling

### Find Slow Queries

```python
# Enable query logging
# site_config.json:
{
    "developer_mode": 1,
    "logging": 2
}

# Check logs
tail -f sites/site-name/logs/query.log
```

### Profile Python Code

```python
import cProfile
import pstats

def profile_function():
    profiler = cProfile.Profile()
    profiler.enable()

    # Function to profile
    my_expensive_function()

    profiler.disable()
    stats = pstats.Stats(profiler)
    stats.sort_stats('cumulative')
    stats.print_stats(20)  # Top 20 slowest
```

## Performance Checklist

- [ ] Fetch only needed fields (`fields=[...]`)
- [ ] Limit query results (`limit=100`)
- [ ] Filter in database, not Python
- [ ] Add indexes on frequently filtered fields
- [ ] Use batch processing for large operations
- [ ] Move long operations to background jobs
- [ ] Cache expensive computations
- [ ] Avoid N+1 queries (use joins)
- [ ] Use bulk updates instead of loops
- [ ] Implement pagination for lists
- [ ] Debounce client-side searches
- [ ] Profile slow endpoints

## Key Rules

- ✅ Fetch only needed fields with `fields=`
- ✅ Use `pluck='name'` for single field
- ✅ Filter in database, not client-side
- ✅ Process large datasets in batches
- ✅ Use background jobs for >30s operations
- ✅ Cache static/expensive data
- ✅ Add indexes on filtered fields
- ✅ Use joins to avoid N+1 queries
- ✅ Implement pagination for large lists
- ✅ Profile and optimize slow queries
- ❌ Never fetch all fields with `fields=['*']`
- ❌ Never load entire table without limit
- ❌ Never process large data in web request
