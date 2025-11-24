# Log Analysis Guide

> Reading and interpreting Frappe/ERPNext logs for debugging.

## Log File Locations

```
sites/site-name/logs/
├── error.log          # Python errors, exceptions
├── web.log            # HTTP requests
├── worker.log         # Background job logs
├── scheduler.log      # Scheduled job logs
├── backup.log         # Backup operation logs
└── query.log          # SQL queries (developer mode)
```

## Error Log (error.log)

### Reading Error Log

```bash
# Tail recent errors
tail -50 sites/site-name/logs/error.log

# Follow live errors
tail -f sites/site-name/logs/error.log

# Search for specific error
grep "PermissionError" sites/site-name/logs/error.log

# Last 100 lines with timestamps
tail -100 sites/site-name/logs/error.log | grep "^202"
```

### Error Log Format

```
2025-11-24 10:30:45,123 - ERROR - frappe.app -
Traceback (most recent call last):
  File "apps/frappe/frappe/app.py", line 123, in application
    response = frappe.api.handle()
  File "apps/frappe/frappe/api.py", line 54, in handle
    return frappe.handler.handle()
frappe.exceptions.PermissionError: No permission for Task
```

**Components:**
- **Timestamp:** `2025-11-24 10:30:45,123`
- **Level:** `ERROR`
- **Logger:** `frappe.app`
- **Traceback:** Stack trace showing error origin
- **Error Type:** `frappe.exceptions.PermissionError`
- **Message:** `No permission for Task`

### Common Error Patterns

**Permission Error:**
```
frappe.exceptions.PermissionError: No permission for Task
```
**Fix:** Check user roles and permissions.

**Validation Error:**
```
frappe.exceptions.ValidationError: Mandatory field 'Customer' required
```
**Fix:** Set required field before save.

**SQL Error:**
```
pymysql.err.ProgrammingError: (1146, "Table 'site.tabTask' doesn't exist")
```
**Fix:** Run `bench migrate`.

**Import Error:**
```
ImportError: cannot import name 'MyClass' from 'my_app.module'
```
**Fix:** Check import path, run `bench restart`.

## Web Log (web.log)

### Reading Web Log

```bash
# View recent requests
tail -50 sites/site-name/logs/web.log

# Filter by status code
grep "500" sites/site-name/logs/web.log

# Filter by endpoint
grep "/api/method/my_app" sites/site-name/logs/web.log

# Count requests
grep "GET" sites/site-name/logs/web.log | wc -l
```

### Web Log Format

```
127.0.0.1 - - [24/Nov/2025 10:30:45] "GET /api/method/my_app.api.get_tasks HTTP/1.1" 200 -
127.0.0.1 - - [24/Nov/2025 10:30:46] "POST /api/method/frappe.desk.form.save HTTP/1.1" 500 -
```

**Components:**
- **IP:** `127.0.0.1`
- **Timestamp:** `[24/Nov/2025 10:30:45]`
- **Method:** `GET`, `POST`, `PUT`, `DELETE`
- **Endpoint:** `/api/method/my_app.api.get_tasks`
- **Status Code:** `200`, `404`, `500`

### HTTP Status Codes

| Code | Meaning | Common Cause |
|------|---------|--------------|
| 200 | Success | Request completed |
| 403 | Forbidden | Permission denied |
| 404 | Not Found | Endpoint doesn't exist |
| 500 | Server Error | Python exception |
| 504 | Gateway Timeout | Request took too long |

## Worker Log (worker.log)

### Reading Worker Log

```bash
# Tail worker logs
tail -50 sites/site-name/logs/worker.log

# Follow background jobs
tail -f sites/site-name/logs/worker.log

# Check for job failures
grep "Failed" sites/site-name/logs/worker.log
```

### Worker Log Format

```
2025-11-24 10:30:45 RQ worker started, version 1.0
2025-11-24 10:30:50 default: my_app.tasks.process_data('arg1', kwarg='value')
2025-11-24 10:30:55 default: Job OK (5.2s)
2025-11-24 10:31:00 default: my_app.tasks.heavy_task()
2025-11-24 10:35:00 default: Job FAILED (4m 0s)
```

**Components:**
- **Timestamp:** Job start time
- **Queue:** `default`, `long`, `short`
- **Method:** Function being executed
- **Result:** `Job OK` or `Job FAILED`
- **Duration:** Time taken

## Scheduler Log (scheduler.log)

### Reading Scheduler Log

```bash
# Tail scheduler logs
tail -50 sites/site-name/logs/scheduler.log

# Check specific job
grep "my_app.tasks" sites/site-name/logs/scheduler.log

# Check for failures
grep "Exception" sites/site-name/logs/scheduler.log
```

### Scheduler Log Format

```
2025-11-24 10:00:00 Executing hourly events
2025-11-24 10:00:01 Running my_app.tasks.sync_data
2025-11-24 10:00:05 Completed my_app.tasks.sync_data
2025-11-24 10:00:05 Exception in my_app.tasks.failed_job: PermissionError
```

## Query Log (query.log)

### Enable Query Logging

```bash
# Enable in site_config.json
bench --site site-name set-config allow_tests 1
bench --site site-name set-config developer_mode 1
bench restart
```

### Reading Query Log

```bash
# View recent queries
tail -50 sites/site-name/logs/query.log

# Find slow queries
grep "took" sites/site-name/logs/query.log | grep -E "[0-9]{4,}ms"

# Find specific table queries
grep "tabTask" sites/site-name/logs/query.log
```

### Query Log Format

```
SELECT name, subject FROM `tabTask` WHERE status = 'Open' -- took 45ms
UPDATE `tabTask` SET status = 'Completed' WHERE name = 'TASK-001' -- took 12ms
SELECT * FROM `tabTask` -- took 2500ms (SLOW!)
```

**Identify slow queries:** Look for high millisecond values.

## Analyzing Stack Traces

### Python Stack Trace

```
Traceback (most recent call last):
  File "apps/my_app/my_app/api.py", line 45, in update_task
    doc = frappe.get_doc('Task', task_name)
  File "apps/frappe/frappe/model/document.py", line 912, in get_doc
    raise frappe.DoesNotExistError
frappe.exceptions.DoesNotExistError: Task TASK-999 not found
```

**Read bottom-up:**
1. **Error:** `frappe.exceptions.DoesNotExistError`
2. **Message:** `Task TASK-999 not found`
3. **Origin:** `apps/my_app/my_app/api.py`, line 45
4. **Function:** `update_task`

**Fix:** Check if task exists before getting doc.

## Log Levels

| Level | When to Use | Example |
|-------|-------------|---------|
| DEBUG | Detailed troubleshooting | Variable values, flow tracking |
| INFO | General information | Job started, completed |
| WARNING | Potential issues | Deprecated method used |
| ERROR | Errors that don't stop execution | Permission denied |
| CRITICAL | System-breaking errors | Database down |

### Custom Logging

```python
import frappe

# Debug (developer_mode only)
frappe.logger().debug(f'Processing task: {task_name}')

# Info
frappe.logger().info(f'Task {task_name} completed')

# Warning
frappe.logger().warning('This method is deprecated')

# Error
frappe.logger().error(f'Failed to process {task_name}')

# Log with traceback
frappe.log_error(frappe.get_traceback(), 'Custom Error Title')
```

## Common Log Analysis Tasks

### Find Recent Errors

```bash
# Last 10 errors
grep -i "error\|exception" sites/site-name/logs/error.log | tail -10

# Errors in last hour
find sites/site-name/logs/error.log -mmin -60 -exec tail {} \;
```

### Track API Performance

```bash
# Find slow API calls
grep "took" sites/site-name/logs/query.log | awk '{print $NF}' | sort -rn | head -20

# Count API calls by endpoint
grep "api/method" sites/site-name/logs/web.log | awk '{print $7}' | sort | uniq -c | sort -rn
```

### Identify Permission Issues

```bash
# Find all permission errors
grep "PermissionError" sites/site-name/logs/error.log

# Group by DocType
grep "No permission for" sites/site-name/logs/error.log | awk '{print $NF}' | sort | uniq -c
```

### Monitor Background Jobs

```bash
# Check job success rate
grep "Job OK" sites/site-name/logs/worker.log | wc -l
grep "Job FAILED" sites/site-name/logs/worker.log | wc -l

# Find long-running jobs
grep "Job OK" sites/site-name/logs/worker.log | grep -E "[0-9]+m" | tail -20
```

## Log Rotation

### Check Log Size

```bash
# Check log sizes
du -h sites/site-name/logs/*.log

# Find largest logs
ls -lh sites/site-name/logs/ | sort -k5 -rh | head -5
```

### Rotate Logs Manually

```bash
# Archive old logs
cd sites/site-name/logs
gzip error.log.1
gzip web.log.1

# Clear current log (keep file)
> error.log
> web.log
```

### Auto-Rotation (logrotate)

```bash
# /etc/logrotate.d/frappe-bench
/home/frappe/frappe-bench/sites/*/logs/*.log {
    daily
    rotate 30
    compress
    delaycompress
    notifempty
    create 0644 frappe frappe
    sharedscripts
}
```

## Real-Time Monitoring

### Multi-Tail

```bash
# Watch all logs simultaneously
tail -f sites/site-name/logs/error.log \
        sites/site-name/logs/web.log \
        sites/site-name/logs/worker.log
```

### Filter Critical Errors

```bash
# Watch for critical errors only
tail -f sites/site-name/logs/error.log | grep -i "critical\|exception"
```

### Custom Alert

```bash
# Email on error
tail -f sites/site-name/logs/error.log | while read line; do
    if echo "$line" | grep -q "CRITICAL"; then
        echo "$line" | mail -s "Critical Error" admin@example.com
    fi
done
```

## Troubleshooting Workflow

1. **Check error.log first**
   ```bash
   tail -50 sites/site-name/logs/error.log
   ```

2. **Check web.log for status codes**
   ```bash
   grep "500" sites/site-name/logs/web.log | tail -20
   ```

3. **Enable query logging**
   ```bash
   bench --site site-name set-config developer_mode 1
   bench restart
   ```

4. **Reproduce issue, check logs**
   ```bash
   tail -f sites/site-name/logs/error.log
   # Trigger issue
   ```

5. **Analyze stack trace**
   - Identify error type
   - Find error origin (file, line)
   - Read error message

6. **Check related logs**
   - worker.log for background jobs
   - scheduler.log for scheduled jobs
   - query.log for database issues

## Key Rules

- ✅ Always check error.log first
- ✅ Use `tail -f` for real-time monitoring
- ✅ Enable developer_mode for detailed logs
- ✅ Read stack traces bottom-up
- ✅ Check timestamp to correlate events
- ✅ Rotate logs to prevent disk issues
- ✅ Use grep to filter relevant entries
- ✅ Monitor query.log for slow queries
- ❌ Don't ignore warnings
- ❌ Don't delete logs without backup
