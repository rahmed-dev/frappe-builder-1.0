# Background Jobs & Async Processing

> Running long operations asynchronously in Frappe using RQ (Redis Queue).

## When to Use Background Jobs

**Use background jobs for:**
- Operations taking >30 seconds
- Bulk processing (1000+ records)
- Report generation
- Email campaigns
- Data synchronization
- File processing
- Heavy calculations

**Don't use for:**
- Quick operations (<5 seconds)
- Real-time user interactions
- Operations requiring immediate feedback

## Basic Usage

### Enqueue a Job

```python
import frappe

@frappe.whitelist()
def trigger_report():
    """API endpoint that triggers background job"""
    frappe.enqueue(
        'my_app.tasks.generate_report',
        queue='long',
        timeout=3600,
        user=frappe.session.user,
        filters={'from_date': '2025-01-01'}
    )

    return {'message': 'Report generation started'}

# my_app/tasks.py
def generate_report(filters):
    """Actual job function"""
    # Long-running operation
    data = process_large_dataset(filters)

    # Email result
    frappe.sendmail(
        recipients=[frappe.session.user],
        subject='Report Ready',
        message='Your report has been generated',
        attachments=[{'fname': 'report.csv', 'fcontent': data}]
    )
```

## Queue Types

| Queue | Timeout | Use Case |
|-------|---------|----------|
| `default` | 300s (5 min) | Standard operations |
| `short` | 60s (1 min) | Quick background tasks |
| `long` | 1800s (30 min) | Reports, bulk operations |
| Custom | Custom | Specialized processing |

```python
# Short queue (quick tasks)
frappe.enqueue('my_app.tasks.send_sms', queue='short')

# Default queue
frappe.enqueue('my_app.tasks.sync_data', queue='default')

# Long queue (heavy processing)
frappe.enqueue('my_app.tasks.generate_payroll', queue='long', timeout=3600)
```

## Parameters

### Common Parameters

```python
frappe.enqueue(
    method='my_app.tasks.process_data',  # Function path
    queue='default',                      # Queue name
    timeout=300,                          # Timeout in seconds
    is_async=True,                        # Run async (default True)
    now=False,                            # Run immediately in same thread
    job_name='unique_job_name',          # Unique identifier
    deduplicate=True,                     # Prevent duplicate jobs
    enqueue_after_commit=False,           # Enqueue after DB commit
    at_front=False,                       # Add to front of queue
    **kwargs                              # Arguments passed to method
)
```

### Example with All Options

```python
frappe.enqueue(
    method='my_app.tasks.process_order',
    queue='default',
    timeout=600,
    job_name=f'process_order_{order_id}',
    deduplicate=True,  # Don't queue if already queued
    order_id=order_id,
    user_email=frappe.session.user
)
```

## Job Patterns

### Simple Job

```python
def simple_task(param1, param2):
    """Simple background task"""
    result = perform_operation(param1, param2)
    return result
```

### Job with Progress Updates

```python
def bulk_update_task(item_list):
    """Update with progress tracking"""
    total = len(item_list)

    for idx, item in enumerate(item_list, 1):
        update_item(item)

        # Update progress (visible in background jobs list)
        frappe.publish_progress(
            percent=idx / total * 100,
            title='Updating Items',
            description=f'Processing {idx} of {total}'
        )

    return {'updated': total}
```

### Job with Error Handling

```python
def safe_task(data):
    """Task with proper error handling"""
    try:
        result = process_data(data)

        # Log success
        frappe.logger().info(f'Task completed: {result}')

        return {'success': True, 'result': result}

    except Exception as e:
        # Log error with traceback
        frappe.log_error(
            frappe.get_traceback(),
            f'Task Failed: {data}'
        )

        # Don't raise - job will be marked as failed
        return {'success': False, 'error': str(e)}
```

### Job with Email Notification

```python
def report_task(filters):
    """Generate report and email"""
    try:
        report_data = generate_report(filters)

        # Email success
        frappe.sendmail(
            recipients=[frappe.session.user],
            subject='Report Ready',
            message='Your report has been generated',
            attachments=[{
                'fname': 'report.xlsx',
                'fcontent': report_data
            }]
        )

    except Exception as e:
        # Email failure
        frappe.sendmail(
            recipients=[frappe.session.user],
            subject='Report Generation Failed',
            message=f'Error: {str(e)}'
        )
        raise
```

## Scheduled Jobs

### Define in Hooks

```python
# hooks.py
scheduler_events = {
    # Every hour
    "hourly": [
        "my_app.tasks.sync_hourly_data"
    ],

    # Every day at midnight
    "daily": [
        "my_app.tasks.cleanup_old_logs",
        "my_app.tasks.send_daily_summary"
    ],

    # Every week on Sunday
    "weekly": [
        "my_app.tasks.generate_weekly_report"
    ],

    # Every month on 1st
    "monthly": [
        "my_app.tasks.process_monthly_billing"
    ],

    # Custom cron (every 5 minutes)
    "cron": {
        "*/5 * * * *": [
            "my_app.tasks.check_alerts"
        ]
    },

    # All events (every scheduler run)
    "all": [
        "my_app.tasks.monitor_system"
    ]
}
```

### Scheduled Job Pattern

```python
# my_app/tasks.py
def sync_hourly_data():
    """Scheduled hourly sync"""
    # For heavy operations, enqueue to background
    frappe.enqueue(
        'my_app.tasks.perform_heavy_sync',
        queue='long',
        timeout=3600
    )

def perform_heavy_sync():
    """Actual heavy sync operation"""
    # Long-running sync logic
    data = fetch_external_data()
    process_data(data)
```

## Managing Background Jobs

### Check Job Status

```python
# In bench console
bench --site site-name console

>>> from rq import Queue
>>> from frappe.utils.background_jobs import get_redis_conn

>>> q = Queue('default', connection=get_redis_conn())
>>> print(f'Jobs in queue: {q.count}')

>>> # Get job details
>>> job = q.fetch_job('job_id')
>>> print(job.get_status())
>>> print(job.result)
```

### Monitor Jobs

```bash
# Check worker logs
tail -f sites/site-name/logs/worker.log

# Check scheduler logs
tail -f sites/site-name/logs/scheduler.log

# Check job queue size
bench --site site-name console
>>> from rq import Queue
>>> from frappe.utils.background_jobs import get_redis_conn
>>> q = Queue('default', connection=get_redis_conn())
>>> print(q.count)
```

### Retry Failed Jobs

```python
# In bench console
from rq import Queue
from rq.job import Job
from frappe.utils.background_jobs import get_redis_conn

# Get failed queue
failed_q = Queue('failed', connection=get_redis_conn())

# Requeue all failed jobs
for job_id in failed_q.job_ids:
    job = Job.fetch(job_id, connection=get_redis_conn())
    job.requeue()
```

## Batch Processing Pattern

```python
def process_all_tasks():
    """Process tasks in batches"""
    batch_size = 100
    offset = 0

    while True:
        # Fetch batch
        tasks = frappe.get_all(
            'Task',
            filters={'status': 'Pending'},
            pluck='name',
            limit=batch_size,
            start=offset
        )

        if not tasks:
            break

        # Process batch
        for task_name in tasks:
            process_task(task_name)

        # Commit per batch
        frappe.db.commit()

        # Update progress
        offset += batch_size
        frappe.publish_progress(
            percent=min(offset / total_tasks * 100, 100),
            title='Processing Tasks'
        )

        # Prevent memory buildup
        tasks = None
```

## Deduplication

### Prevent Duplicate Jobs

```python
# Job won't be queued if already running/queued
frappe.enqueue(
    'my_app.tasks.sync_data',
    queue='default',
    job_name='sync_data_job',  # Unique name
    deduplicate=True           # Prevent duplicates
)
```

### Custom Deduplication Logic

```python
from rq import Queue
from frappe.utils.background_jobs import get_redis_conn

def enqueue_unique(method, queue='default', **kwargs):
    """Enqueue only if not already queued"""
    q = Queue(queue, connection=get_redis_conn())

    # Check if job already queued
    job_name = kwargs.get('job_name')
    if job_name:
        for job in q.jobs:
            if job.kwargs.get('job_name') == job_name:
                return {'message': 'Job already queued'}

    # Enqueue
    frappe.enqueue(method, queue=queue, **kwargs)
    return {'message': 'Job queued'}
```

## Testing Background Jobs

### Test Job Function Directly

```python
def test_report_generation(self):
    """Test job function directly"""
    from my_app.tasks import generate_report

    result = generate_report({'from_date': '2025-01-01'})

    self.assertTrue(result['success'])
    self.assertIsNotNone(result['data'])
```

### Mock Enqueue

```python
import mock

def test_trigger_report(self):
    """Test job is enqueued correctly"""
    with mock.patch('frappe.enqueue') as mock_enqueue:
        trigger_report()

        # Verify enqueue was called
        mock_enqueue.assert_called_once()
        args, kwargs = mock_enqueue.call_args

        self.assertEqual(args[0], 'my_app.tasks.generate_report')
        self.assertEqual(kwargs['queue'], 'long')
```

## Production Considerations

### Worker Management

```bash
# Check workers running
ps aux | grep rq:worker

# Production: use supervisor to manage workers
# /etc/supervisor/conf.d/frappe-bench-workers.conf
[program:frappe-bench-workers]
command=/home/frappe/frappe-bench/env/bin/bench worker --queue default,long,short
directory=/home/frappe/frappe-bench
user=frappe
autostart=true
autorestart=true
```

### Scaling Workers

```bash
# Start multiple workers for different queues
bench worker --queue default &
bench worker --queue long &
bench worker --queue short &

# Or use supervisor with multiple processes
```

### Memory Management

```python
# Free memory in long-running jobs
def process_large_data():
    batch_size = 1000

    for batch in get_batches(batch_size):
        process_batch(batch)
        frappe.db.commit()

        # Free memory
        batch = None
        import gc
        gc.collect()
```

## Key Rules

- ✅ Use background jobs for operations >30 seconds
- ✅ Choose appropriate queue (default/short/long)
- ✅ Set realistic timeout values
- ✅ Handle errors in job functions
- ✅ Log errors with `frappe.log_error()`
- ✅ Send notifications on completion/failure
- ✅ Use `frappe.publish_progress()` for long jobs
- ✅ Process large datasets in batches
- ✅ Commit database changes per batch
- ✅ Test job functions directly in unit tests
- ❌ Don't use for quick operations
- ❌ Don't block on job completion in API
- ❌ Don't ignore job failures
