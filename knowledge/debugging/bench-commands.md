# Bench Commands Reference

> Essential bench commands for Frappe/ERPNext development and debugging.

## Site Management

### Create/Delete Site

```bash
# Create new site
bench new-site site-name --db-name database_name

# Delete site
bench drop-site site-name

# Archive site (backup then delete)
bench drop-site site-name --archived-sites-path ~/archived

# Restore archived site
bench restore site-name --with-private-files --with-public-files
```

### Site Status

```bash
# List all sites
bench --site site-name list-apps

# Site info
bench --site site-name info

# Check site health
bench --site site-name doctor
```

## App Management

### Install/Uninstall Apps

```bash
# Get app from GitHub
bench get-app https://github.com/frappe/erpnext

# Install app on site
bench --site site-name install-app erpnext

# Uninstall app
bench --site site-name uninstall-app custom_app

# List installed apps
bench --site site-name list-apps
```

## Database Operations

### Migrations

```bash
# Run migrations
bench --site site-name migrate

# Migrate specific app
bench --site site-name migrate --app custom_app

# Skip search index
bench --site site-name migrate --skip-search-index
```

### Console

```bash
# Open Python console
bench --site site-name console

# Example session:
>>> import frappe
>>> frappe.get_all('Task', limit=5)
>>> doc = frappe.get_doc('Task', 'TASK-001')
>>> doc.status
>>> exit()
```

### MariaDB Console

```bash
# Open database console
bench --site site-name mariadb

# Run SQL query
bench --site site-name mariadb -e "SELECT COUNT(*) FROM tabTask"
```

### Backup/Restore

```bash
# Backup site
bench --site site-name backup

# Backup with files
bench --site site-name backup --with-files

# Restore from backup
bench --site site-name restore /path/to/backup.sql.gz

# Restore with files
bench --site site-name restore /path/to/backup.sql.gz --with-private-files --with-public-files
```

## Build & Cache

### Build Assets

```bash
# Build all apps
bench build

# Build specific app
bench build --app custom_app

# Development mode (no minification)
bench build --app custom_app --force
```

### Clear Cache

```bash
# Clear site cache
bench --site site-name clear-cache

# Clear website cache
bench --site site-name clear-website-cache

# Rebuild search index
bench --site site-name build-search-index
```

## Development

### Create DocTypes/Pages/Reports

```bash
# Create DocType
bench make-app custom_app
cd apps/custom_app
bench new-doctype "My Custom DocType"

# Create Page
bench new-page "My Custom Page"

# Create Script Report
bench new-report "My Script Report"
```

### Reload DocType

```bash
# Reload DocType after JSON changes
bench --site site-name reload-doc module_name doctype_name "DocType Name"

# Example
bench --site site-name reload-doc custom_app DocType "Custom Task"
```

### Set Config

```bash
# Enable developer mode
bench --site site-name set-config developer_mode 1

# Disable maintenance mode
bench --site site-name set-config maintenance_mode 0

# Set max file size
bench --site site-name set-config max_file_size 10485760
```

## Testing

### Run Tests

```bash
# Run all tests
bench --site site-name run-tests

# Test specific app
bench --site site-name run-tests --app custom_app

# Test specific module
bench --site site-name run-tests --module custom_app.tests.test_custom

# Test specific test case
bench --site site-name run-tests --doctype "Task"

# Verbose output
bench --site site-name run-tests --verbose
```

## Bench Services

### Start/Stop/Restart

```bash
# Start bench (web + background workers)
bench start

# Restart bench
bench restart

# Stop bench (background processes)
bench --site site-name scheduler disable
```

### Scheduler

```bash
# Enable scheduler
bench --site site-name scheduler enable

# Disable scheduler
bench --site site-name scheduler disable

# Resume scheduler
bench --site site-name scheduler resume

# Check scheduler status
bench --site site-name scheduler status
```

## Logs

### View Logs

```bash
# Tail error log
tail -f sites/site-name/logs/error.log

# Tail web log
tail -f sites/site-name/logs/web.log

# Tail background worker log
tail -f sites/site-name/logs/worker.log

# Tail scheduler log
tail -f sites/site-name/logs/scheduler.log
```

### Enable Query Logging

```bash
# Enable SQL query logging
bench --site site-name set-config allow_tests 1
bench --site site-name set-config developer_mode 1

# Check site_config.json
cat sites/site-name/site_config.json
```

## Updates

### Update Bench

```bash
# Update all apps
bench update

# Update specific app
bench update --app erpnext

# Pull changes without migration
bench update --pull

# Build only
bench update --build

# Update bench framework
bench update --requirements
```

## Production

### Setup Production

```bash
# Setup production config
sudo bench setup production frappe_user

# Enable HTTPS
sudo bench setup lets-encrypt site-name

# Setup nginx
sudo bench setup nginx

# Setup supervisor
sudo bench setup supervisor
```

### Restart Services

```bash
# Restart web server
sudo service nginx restart

# Restart supervisor
sudo supervisorctl restart all

# Reload supervisor config
sudo supervisorctl reread
sudo supervisorctl update
```

## Troubleshooting

### Fix Issues

```bash
# Fix permissions
bench setup socketio
sudo chmod -R o+rx /home/frappe/frappe-bench/sites

# Reinstall app dependencies
bench setup requirements

# Rebuild all
bench build --force
bench --site site-name migrate
bench --site site-name clear-cache
bench restart
```

### Reset Data

```bash
# Reset DocType data
bench --site site-name execute frappe.utils.fixtures.sync_fixtures --args '["Custom Task"]'

# Drop table and recreate
bench --site site-name mariadb -e "DROP TABLE IF EXISTS \`tabCustom Task\`"
bench --site site-name migrate
```

## Multi-Site Commands

### Run on All Sites

```bash
# Migrate all sites
bench --site all migrate

# Clear cache on all sites
bench --site all clear-cache

# Backup all sites
bench --site all backup
```

## Utility Commands

### Export/Import

```bash
# Export DocType schema
bench --site site-name export-json "DocType Name" > doctype.json

# Import fixtures
bench --site site-name import-csv module_name file.csv --doctype "Task"
```

### Bench Config

```bash
# Show bench config
bench config

# Set config value
bench config dns_multitenant on

# Use SSL
bench config http_timeout 300
```

## Common Workflows

### After Code Changes

```bash
bench build --app custom_app
bench --site site-name clear-cache
bench restart
```

### After JSON Changes

```bash
bench --site site-name reload-doc app_name doctype_name "DocType Name"
bench --site site-name clear-cache
bench restart
```

### After DB Changes

```bash
bench --site site-name migrate
bench --site site-name clear-cache
bench restart
```

### Complete Rebuild

```bash
bench build --force
bench --site site-name migrate
bench --site site-name clear-cache
bench --site site-name build-search-index
bench restart
```

## Key Rules

- ✅ Always specify `--site site-name` for site-specific commands
- ✅ Run `migrate` after DocType changes
- ✅ Run `clear-cache` after config/code changes
- ✅ Run `build` after JS/CSS changes
- ✅ Use `--force` flag to force rebuild
- ✅ Check logs in `sites/site-name/logs/` for errors
- ✅ Use `bench console` for quick Python debugging
- ✅ Use `bench mariadb` for SQL queries
- ❌ Never run `bench update` on production without testing
- ❌ Never delete `site_config.json` manually
