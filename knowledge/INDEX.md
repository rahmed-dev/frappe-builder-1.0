# Knowledge Base Index

Use this index to find the right file before loading KB content.
**Workflow:** Read this index → identify relevant file(s) → load only those files.

---

## frappe-framework/

| File | Covers |
|------|--------|
| `frappe-framework/4-tier-framework.md` | Standard → Configure → Scripts → Custom decision framework; when to use each tier |
| `frappe-framework/background-jobs.md` | Frappe background jobs, queues, scheduled tasks, frappe.enqueue() |
| `frappe-framework/client-api.md` | frappe.call(), frappe.db, frappe.ui client-side JS APIs |
| `frappe-framework/configure-first-approach.md` | Configuration-first philosophy; workflows, email alerts, custom fields via UI |
| `frappe-framework/doctype-lifecycle.md` | Document lifecycle hooks: validate, before_save, on_submit, on_cancel, etc. |
| `frappe-framework/frappe-api.md` | Server-side Python API: frappe.get_doc, get_all, db.sql, permissions, utils |
| `frappe-framework/frappe-orm.md` | ORM patterns: get_all, get_list, db.get_value, db.set_value, filters, fields |
| `frappe-framework/hooks-reference.md` | hooks.py reference: all hook types, overrides, fixtures, schedulers |
| `frappe-framework/print-formats.md` | Print format design, Jinja templating in print formats, PDF layout, letter heads |
| `frappe-framework/website-routing.md` | Website module: page routing, web controllers, website context, portal pages |

---

## development/

### doctypes/
| File | Covers |
|------|--------|
| `development/doctypes/child-tables.md` | Child table DocTypes, table fields, child document logic |
| `development/doctypes/field-types.md` | All Frappe field types: Data, Link, Select, Table, Currency, etc. with options |
| `development/doctypes/naming-series.md` | Naming series configuration, autoname, custom naming logic |
| `development/doctypes/permissions-configuration.md` | Role permissions, user permissions, permission levels, field-level permissions |

### server-scripting/
| File | Covers |
|------|--------|
| `development/server-scripting/best-practices.md` | Server script best practices: security, performance, code patterns |
| `development/server-scripting/document-mapping.md` | Mapping fields between DocTypes, data migration patterns |
| `development/server-scripting/hooks-guide.md` | Practical hooks.py guide with real examples |
| `development/server-scripting/serial-no-research-findings.md` | Serial No / Batch tracking research and findings specific to ERPNext |

### client-scripting/
| File | Covers |
|------|--------|
| `development/client-scripting/best-practices.md` | Client script best practices: form events, triggers, field updates |
| `development/client-scripting/form-scripts.md` | frappe.ui.form.on patterns, frm.set_value, field filters, dialog from form |

### reports/
| File | Covers |
|------|--------|
| `development/reports/best-practices.md` | Report design best practices: performance, filters, formatting, User Permissions enforcement (frappe.get_list vs frappe.qb) |
| `development/reports/pf-for-reports-via-ui.md` | How to create Print Formats for Script Reports using the Frappe UI (no code) |
| `development/reports/script-reports.md` | Script Report implementation: Python + JS, columns, filters, data return |

### custom-pages/
| File | Covers |
|------|--------|
| `development/custom-pages/best-practices.md` | Custom page best practices: routing, permissions, page context |

### other/
| File | Covers |
|------|--------|
| `development/data-import-export.md` | Data Import tool, fixtures, export/import patterns, migration data |

---

## debugging/

| File | Covers |
|------|--------|
| `debugging/anti-patterns.md` | Common Frappe anti-patterns: SQL injection, missing whitelist, N+1 queries |
| `debugging/bench-commands.md` | bench CLI commands for debugging: logs, migrate, build, clear-cache |
| `debugging/common-issues.md` | Frequently encountered Frappe errors and their fixes |
| `debugging/error-patterns.md` | Error pattern recognition: tracebacks, permission errors, validation errors |
| `debugging/log-analysis.md` | Reading and analyzing bench logs: error.log, worker.log, web.log |

---

## best-practices/

| File | Covers |
|------|--------|
| `best-practices/code-review-checklist.md` | Code review checklist: security, performance, Frappe compliance |
| `best-practices/performance-patterns.md` | Query optimization, caching, bulk operations, N+1 avoidance |
| `best-practices/security-checklist.md` | Security checklist: XSS, SQL injection, permission checks, whitelist |
| `best-practices/testing-patterns.md` | Test patterns: setUp, tearDown, test data, assertion patterns |
| `best-practices/upgrade-safe-patterns.md` | Writing upgrade-safe code: avoiding hardcoded names, migration-safe patterns |

---

## erpnext-modules/

| File | Covers |
|------|--------|
| `erpnext-modules/assets-maintenance.md` | Asset module: asset lifecycle, maintenance, depreciation |
| `erpnext-modules/crm-leads.md` | CRM module: Lead, Opportunity, pipeline, activities |
| `erpnext-modules/hr-payroll.md` | HR module: Employee, Leave, Payroll, salary structures |
| `erpnext-modules/integration-api.md` | ERPNext integration patterns: REST API, webhooks, third-party connectors |
| `erpnext-modules/manufacturing.md` | Manufacturing module: BOM, Work Order, production planning |
| `erpnext-modules/projects-accounting.md` | Projects and Accounting: project tracking, cost centers, timesheets |
| `erpnext-modules/quality-management.md` | Quality Inspection, Quality Control workflows |
| `erpnext-modules/sales-purchasing.md` | Sales Order, Purchase Order, quotations, supplier/customer flows |
| `erpnext-modules/stock-inventory.md` | Stock module: Item, Warehouse, Stock Entry, valuation |
| `erpnext-modules/website-ecommerce.md` | Website and e-commerce: product catalog, shopping cart, checkout |

---

## agent-skills/

Structured skill references for specific development domains. Each skill has a `SKILL.md` (procedure) and `references/` (deep-dive docs).

| Skill folder | Covers |
|------|--------|
| `agent-skills/frappe-api-development/` | REST/RPC APIs, authentication, OAuth, permissions, webhooks, rate limiting |
| `agent-skills/frappe-app-development/` | App scaffolding, hooks, background jobs, translations, version compatibility |
| `agent-skills/frappe-desk-customization/` | Desk UI customization: form scripts, list views, JS API, dialogs |
| `agent-skills/frappe-doctype-development/` | DocType creation, controllers, child tables, field types, naming, permissions |
| `agent-skills/frappe-enterprise-patterns/` | Enterprise patterns: advanced permissions, queues, SLA, workflow patterns, integrations |
| `agent-skills/frappe-frontend-development/` | Vue 3 frontend with Frappe UI, portal development |
| `agent-skills/frappe-manager/` | Docker-based dev environments, bench commands, FM commands, SSL setup |
| `agent-skills/frappe-printing-templates/` | Print formats, email templates, Jinja templating, letter heads, PDF |
| `agent-skills/frappe-project-triage/` | Detect project type, installed apps, Frappe version, tooling |
| `agent-skills/frappe-reports/` | Report Builder, Query Reports (SQL), Script Reports (Python + JS) |
| `agent-skills/frappe-router/` | Entry-point skill that routes to the appropriate frappe skill |
| `agent-skills/frappe-testing/` | Unit tests, integration tests, UI tests (Cypress), fixtures, CI |
| `agent-skills/frappe-ui-patterns/` | UI/UX patterns from CRM/Helpdesk/HRMS: components, mobile, app shell |
| `agent-skills/frappe-web-forms/` | Public-facing web forms, portal data collection |
