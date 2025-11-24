```yaml

frappe_knowledge:
  tech_stack:
    - Frappe Framework v14/v15
    - ERPNext (manufacturing, HR, accounting modules)
    - Python 3.10+ (backend)
    - JavaScript/jQuery (client-side UI only)
    - MariaDB/PostgreSQL
    - Redis (caching, queuing)
    - Gunicorn/Nginx
    - Jinja templating

  architecture:
    - DocTypes (core data models)
    - Custom Apps (modular extensions)
    - Pages (custom UI dashboards)
    - Reports (Script Reports, Query Reports)
    - Server Scripts (@frappe.whitelist() decorators)
    - Client Scripts (form/list view customization)
    - Hooks (scheduler, events, overrides)
    - Background Jobs (scheduler_events in hooks.py)

  critical_patterns:
    - Server API: '@frappe.whitelist()' + 'frappe.get_doc()' / 'frappe.get_all()'
    - Client calls: 'frappe.call({method, args, callback})'
    - Dialogs: 'frappe.ui.Dialog' with native field types
    - Permissions: 'frappe.has_permission(doctype, ptype, doc)'
    - Date handling: 'frappe.datetime.str_to_user()' (display), 'frappe.datetime.user_to_str()' (store)
    - Error handling: 'frappe.throw()' (user errors), 'frappe.log_error()' (background)
    - Bulk operations: Try/except per item, 'frappe.db.commit()' in loops
    - Type conversion: 'int(val) if val else 0', 'flt(val)' for currency
    - Background jobs: 'ignore_permissions=True' in schedulers
    - Return format: '{"success": bool, "data": any, "message": str}'

frappe_critical_mistakes_to_avoid:
  - '❌ Creating custom HTML/CSS instead of using Frappe native field types (Check, Select, Date, etc.)'
  - '❌ Client-side data filtering/processing - ALWAYS do in Python server methods'
  - '❌ Not registering JS/Python overrides in hooks.py'
  - '❌ Forgetting to run bench migrate after hooks.py or JSON changes'
  - '❌ Not using @frappe.whitelist() decorator on API methods'
  - '❌ Not converting string form values to int/float in Python'
  - '❌ Not checking permissions with frappe.has_permission() before writes'
  - '❌ Using frappe.format_value() for currency - use format_currency() instead'
  - '❌ Not disabling submit button in dialogs (causes duplicates)'
  - '❌ Leaving console.log() statements in production code'
  - '❌ Not using ignore_permissions=True in background jobs/schedulers'
  - '❌ Forgetting frappe.db.commit() in scheduler loops'
  - '❌ Incorrect date handling - Must store YYYY-MM-DD, display DD-MM-YYYY'
  - '❌ Using $("#id").hide() instead of d.set_df_property("field", "hidden", 1)'
  - '❌ Not building app after JS changes (bench build --app [app])'

frappe_commands_reference:
  setup:
    - 'bench new-app [app_name]'
    - 'bench --site [site] install-app [app_name]'
    - 'bench new-page [Page Name]'

  development:
    - 'bench --site [site] set-config developer_mode 1'
    - 'bench build --app [app_name]'
    - 'bench --site [site] migrate'
    - 'bench --site [site] reload-doc [app] [doctype] [name]'
    - 'bench --site [site] clear-cache'
    - 'bench restart'

  testing:
    - 'bench --site [site] execute "app.module.path.function"'
    - 'bench run-tests --app [app_name]'
    - 'tail -f sites/[site]/logs/error.log'
    - 'tail -f sites/[site]/logs/web.log'

  debugging:
    - 'bench --site [site] console  # Python REPL'
    - 'bench --site [site] mariadb  # Database shell'

frappe_code_patterns:
  server_api_template: |
    @frappe.whitelist()
    def my_method(param):
        """Brief description of what this does"""
        # 1. Permission check
        if not frappe.has_permission("DocType", "write"):
            frappe.throw(_("No permission"), frappe.PermissionError)

        # 2. Type conversion (JS sends strings)
        param = int(param) if param else 0

        # 3. Business logic
        result = process_data(param)

        # 4. Standard return format
        return {"success": True, "data": result, "message": "Success"}

  client_api_call_template: |
    frappe.call({
        method: 'app.module.path.my_method',
        args: {param: value},
        freeze: true,
        freeze_message: __('Processing...'),
        callback: function(r) {
            if (r.message && r.message.success) {
                frappe.show_alert(__('Success'));
                // Reload or update UI
            }
        },
        error: function(r) {
            frappe.msgprint(__('Error occurred'));
        }
    });

  dialog_template: |
    let d = new frappe.ui.Dialog({
        title: __('Title'),
        fields: [
            {fieldname: 'field1', fieldtype: 'Data', label: __('Field 1'), reqd: 1},
            {fieldname: 'field2', fieldtype: 'Int', label: __('Field 2')}
        ],
        primary_action_label: __('Submit'),
        primary_action(values) {
            d.get_primary_btn().prop('disabled', true);  // Prevent duplicates

            frappe.call({
                method: 'app.method',
                args: values,
                callback: function(r) {
                    if (r.message.success) d.hide();
                },
                error: function() {
                    d.get_primary_btn().prop('disabled', false);
                }
            });
        }
    });
    d.show();

  background_job_template: |
    # In hooks.py
    scheduler_events = {
        "daily": ["app.module.tasks.daily_task"]
    }

    # In app/module/tasks.py
    def daily_task():
        """Daily scheduled task"""
        try:
            records = frappe.get_all("DocType", filters={...})
            for rec in records:
                try:
                    process_record(rec)
                    frappe.db.commit()  # Commit per record
                except Exception as e:
                    frappe.log_error(title=f"Error: {rec.name}", message=str(e))
        except Exception as e:
            frappe.log_error(title="Task Error", message=str(e))
```
