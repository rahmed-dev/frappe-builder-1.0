# Common Issues & Quick Fixes

> Frequent problems encountered in Frappe/ERPNext development with immediate solutions.

## Installation Issues

### "bench: command not found"

**Cause:** Bench not in PATH or not installed.

**Fix:**
```bash
# Add to PATH
export PATH=$PATH:~/.local/bin

# Or add to ~/.bashrc
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
source ~/.bashrc

# Reinstall bench if needed
pip3 install frappe-bench
```

### "Cannot connect to database"

**Cause:** MariaDB not running or wrong credentials.

**Fix:**
```bash
# Check MariaDB status
sudo service mysql status

# Start MariaDB
sudo service mysql start

# Check site_config.json credentials
cat sites/site-name/site_config.json

# Test connection
bench --site site-name mariadb
```

## Migration Issues

### "Table already exists"

**Cause:** Migration trying to create existing table.

**Fix:**
```bash
# Drop and recreate
bench --site site-name mariadb -e "DROP TABLE IF EXISTS \`tabDocType Name\`"
bench --site site-name migrate

# Or reset DocType
bench --site site-name console
>>> frappe.reload_doctype('DocType Name', force=True)
```

### "Column does not exist"

**Cause:** Missing field or migration not run.

**Fix:**
```bash
# Run migrations
bench --site site-name migrate

# Reload specific DocType
bench --site site-name reload-doc app_name doctype_name "DocType Name"

# Clear cache
bench --site site-name clear-cache
bench restart
```

## Build Issues

### "JavaScript build failed"

**Cause:** Syntax error in JS file or missing dependency.

**Fix:**
```bash
# Check error in output
bench build --app my_app

# Force rebuild
bench build --app my_app --force

# Clear node_modules and rebuild
rm -rf node_modules
yarn install
bench build
```

### "Asset not found"

**Cause:** Asset not built or wrong path.

**Fix:**
```bash
# Build assets
bench build --app my_app

# Check asset exists
ls -la sites/assets/

# Clear cache
bench --site site-name clear-cache
bench --site site-name clear-website-cache
```

## Permission Issues

### "PermissionError: [Errno 13]"

**Cause:** File permission issue.

**Fix:**
```bash
# Fix bench permissions
chmod -R 755 ~/frappe-bench

# Fix sites permissions
chmod -R o+rx ~/frappe-bench/sites

# Fix ownership
sudo chown -R $(whoami):$(whoami) ~/frappe-bench
```

### "User does not have access"

**Cause:** Missing role or user permission.

**Fix:**
```python
# Add role to user
bench --site site-name console
>>> frappe.get_doc('User', 'user@example.com').add_roles('Manufacturing User')

# Add user permission
>>> frappe.defaults.add_user_permission('Company', 'Test Company', 'user@example.com')

# Check permissions
>>> frappe.get_roles('user@example.com')
```

## Cache Issues

### "Changes not reflecting"

**Cause:** Cached data not cleared.

**Fix:**
```bash
# Clear all cache
bench --site site-name clear-cache

# Clear website cache
bench --site site-name clear-website-cache

# Rebuild search index
bench --site site-name build-search-index

# Restart
bench restart
```

### "Old data showing in report"

**Cause:** Report cache or stale data.

**Fix:**
```python
# Clear cache for specific report
bench --site site-name console
>>> frappe.cache().delete_key('*Report Name*')

# Or clear all
>>> frappe.cache().delete_key('*')
```

## Form Issues

### "Form not saving"

**Cause:** Validation error or mandatory field missing.

**Fix:**
```javascript
// Check browser console (F12) for errors

// Check mandatory fields
frappe.ui.form.on('Task', {
    validate: function(frm) {
        console.log('Validating:', frm.doc);
    }
});

// Check server logs
tail -f sites/site-name/logs/error.log
```

### "Field not showing"

**Cause:** Field hidden by permission or script.

**Fix:**
```javascript
// Check field property
frappe.ui.form.on('Task', {
    refresh: function(frm) {
        console.log(frm.fields_dict.my_field);
        console.log(frm.get_field('my_field').df);
    }
});

// Unhide field
frm.set_df_property('my_field', 'hidden', 0);
```

## API Issues

### "Method not whitelisted"

**Cause:** Missing `@frappe.whitelist()` decorator.

**Fix:**
```python
# Add decorator
@frappe.whitelist()
def my_method():
    return {'success': True}

# Restart after adding
bench restart
```

### "Invalid JSON response"

**Cause:** Method returning non-JSON or error.

**Fix:**
```python
# Always return dict or list
@frappe.whitelist()
def my_method():
    return {'data': 'value'}  # NOT: return "string"

# Check error log
tail -f sites/site-name/logs/error.log
```

## Scheduler Issues

### "Scheduled job not running"

**Cause:** Scheduler disabled or error in job.

**Fix:**
```bash
# Check scheduler status
bench --site site-name scheduler status

# Enable scheduler
bench --site site-name scheduler enable

# Check scheduler log
tail -f sites/site-name/logs/scheduler.log

# Test job manually
bench --site site-name console
>>> from my_app.tasks import my_job
>>> my_job()
```

### "Job timeout"

**Cause:** Job taking too long.

**Fix:**
```python
# Move to background with longer timeout
scheduler_events = {
    "daily_long": [  # Use _long queue
        "my_app.tasks.heavy_job"
    ]
}

# Or enqueue manually
def my_scheduled_job():
    frappe.enqueue(
        'my_app.tasks.actual_heavy_job',
        queue='long',
        timeout=3600
    )
```

## Import/Export Issues

### "Import failed"

**Cause:** Data format error or validation failure.

**Fix:**
```bash
# Check import log
bench --site site-name mariadb -e "SELECT * FROM \`tabData Import\` ORDER BY creation DESC LIMIT 1"

# Test in console
bench --site site-name console
>>> doc = frappe.get_doc({
...     'doctype': 'Task',
...     'subject': 'Test'
... })
>>> doc.insert()
```

### "Export not working"

**Cause:** Permission or query error.

**Fix:**
```python
# Test export manually
bench --site site-name console
>>> data = frappe.get_all('Task', fields=['*'], limit=5)
>>> import json
>>> print(json.dumps(data, indent=2))
```

## Background Job Issues

### "Background job stuck"

**Cause:** Worker not running or job error.

**Fix:**
```bash
# Check workers
ps aux | grep frappe

# Restart workers
bench restart

# Check job queue
bench --site site-name console
>>> from rq import Queue
>>> from frappe.utils.background_jobs import get_redis_conn
>>> q = Queue('default', connection=get_redis_conn())
>>> print(q.count)
```

### "Job failed silently"

**Cause:** Exception in background job not logged.

**Fix:**
```python
# Add try/except in job
def my_background_job():
    try:
        # Job logic
        pass
    except Exception as e:
        frappe.log_error(frappe.get_traceback(), 'Background Job Error')
        raise
```

## Email Issues

### "Email not sending"

**Cause:** Email account not configured or credentials wrong.

**Fix:**
```bash
# Check email account
bench --site site-name console
>>> frappe.get_doc('Email Account', 'Gmail').send_test_email('test@example.com')

# Check email queue
>>> frappe.get_all('Email Queue', filters={'status': 'Error'}, limit=5)

# Retry failed emails
>>> from frappe.email.queue import flush
>>> flush()
```

## Print Format Issues

### "Print format not showing"

**Cause:** Template error or missing data.

**Fix:**
```python
# Test in console
bench --site site-name console
>>> doc = frappe.get_doc('Sales Order', 'SO-0001')
>>> print(doc.as_dict())

# Check print format template
# Review .html file for Jinja errors
```

## Quick Diagnostics

### Check System Health

```bash
# Site info
bench --site site-name info

# Doctor check
bench --site site-name doctor

# Check logs
tail -20 sites/site-name/logs/error.log
tail -20 sites/site-name/logs/web.log
```

### Debug Mode

```bash
# Enable developer mode
bench --site site-name set-config developer_mode 1

# Enable query logging
bench --site site-name set-config allow_tests 1

# Restart
bench restart
```

### Reset Options

```bash
# Reset DocType (drops table)
bench --site site-name console
>>> frappe.delete_doc('DocType', 'My DocType', force=1)

# Reset site (DANGER - deletes all data)
bench --site site-name reinstall

# Restore from backup
bench --site site-name restore /path/to/backup.sql.gz
```

## Common Error Patterns

| Error | Cause | Quick Fix |
|-------|-------|-----------|
| "Table doesn't exist" | Migration not run | `bench migrate` |
| "Cannot edit submitted" | Doc submitted | Use `allow_on_submit` or cancel |
| "No permission" | Missing role/permission | Add role to user |
| "Mandatory field required" | Field empty | Set field value |
| "frappe is not defined" | Script loading order | Use `frappe.ready()` |
| "Gateway Timeout" | Request too long | Move to background job |
| "Asset not found" | Build not run | `bench build` |
| "Changes not showing" | Cache not cleared | `bench clear-cache` |

## Emergency Commands

```bash
# Complete rebuild
bench build --force
bench --site site-name migrate
bench --site site-name clear-cache
bench restart

# Fix permissions
chmod -R 755 ~/frappe-bench
chmod -R o+rx ~/frappe-bench/sites

# Restart services (production)
sudo supervisorctl restart all
sudo service nginx restart

# Check what's running
ps aux | grep frappe
ps aux | grep node
```

## Key Rules

- ✅ Always check logs first (`error.log`, `web.log`)
- ✅ Run `migrate` after schema changes
- ✅ Run `clear-cache` after code changes
- ✅ Run `build` after JS/CSS changes
- ✅ Use `bench console` for quick testing
- ✅ Enable `developer_mode` during development
- ✅ Check browser console (F12) for JS errors
- ✅ Test permissions with `frappe.has_permission()`
- ❌ Don't skip error messages
- ❌ Don't modify core files
