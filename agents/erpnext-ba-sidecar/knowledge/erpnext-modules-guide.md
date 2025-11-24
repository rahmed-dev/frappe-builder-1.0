```yaml
erpnext_knowledge:
  modules_and_features:
    manufacturing:
      - Work Order (production planning, job cards, material consumption)
      - Job Card (shop floor operations, time tracking, employee assignment)
      - BOM (Bill of Materials with versioning, multi-level BOMs)
      - Production Plan (demand-driven manufacturing, material planning)
      - Operation (routing, workstation assignment, time standards)
      - Workstation (capacity planning, holiday management)
      - Quality Inspection (inspection templates, sample-based testing)
      - Downtime Entry (tracking machine downtime, reasons)
      - Material Request (stock requisitions, auto-generation from Work Orders)
      - Stock Entry (material transfer, consumption, manufacture)
      - Batch tracking (expiry, manufacturing date, batch-based stock)
      - Serial number tracking (item-level traceability)
      - Subcontracting (outsourced manufacturing, BOM transfer)

    human_resources:
      - Employee (master data, department, designation)
      - Shift Type & Shift Assignment (multiple shifts, auto-attendance)
      - Attendance (marking, late entries, half-day)
      - Leave Management (types, allocation, approval workflow)
      - Timesheet (project/task time tracking, billable hours)
      - Salary Structure & Payroll (flexible components, tax calculation)
      - Employee Advance (loans, deductions)
      - Appraisal system

    stock_inventory:
      - Item (variants, templates, groups, attributes)
      - Warehouse (nested, stock levels, reorder levels)
      - Stock Entry (all material movements)
      - Stock Reconciliation (physical inventory adjustment)
      - Batch & Serial Number (full traceability)
      - Landed Cost Voucher (import cost distribution)
      - Packing Slip (shipping management)

    quality_management:
      - Quality Inspection (configurable templates)
      - Quality Goal & Procedure
      - Quality Feedback
      - Quality Review

    projects:
      - Project (costing, task management)
      - Task (assignments, dependencies, time tracking)
      - Timesheet integration with payroll

    accounting:
      - Payment Entry (advances, reconciliation)
      - Journal Entry (manual accounting entries)
      - Cost Center (profit center tracking)
      - Budget tracking

    automation:
      - Workflow (multi-step approval flows)
      - Auto Repeat (recurring documents)
      - Assignment Rule (auto-assignment to users)
      - Email Alert (event-based notifications)
      - Server Script (custom logic without app)
      - Client Script (form behavior customization)

    reporting:
      - Standard Reports (50+ manufacturing reports)
      - Custom Report Builder
      - Script Reports (Python-based custom reports)
      - Query Reports (SQL-based reports)
      - Dashboard & Charts

  frappe_capabilities:
    customization_without_coding:
      - Custom Fields (add fields to any doctype)
      - Customize Form (hide/show/reorder fields, change labels)
      - Workflow (approval processes, state transitions)
      - Print Format (custom document designs)
      - Custom Dashboard (widgets, charts, KPIs)
      - DocType permissions (role-based access)
      - Email templates
      - Notification rules

    frappe_tech_stack:
      - DocTypes (database tables/forms)
      - Custom Frappe Pages (dashboards, custom UIs)
      - Script Reports (Python-based reporting)
      - Server Scripts (@frappe.whitelist() APIs)
      - Client Scripts (JavaScript for UI behavior)
      - Hooks (events, schedulers, overrides)
      - Custom Apps (modular extensions)
      - Web Forms (public-facing forms)
      - Portal Pages (customer/supplier portals)

    architecture_awareness:
      - Server-side first (data operations in Python)
      - Role-based permissions (User, Employee, Manufacturing User, etc.)
      - Document lifecycle (Draft → Submitted → Cancelled)
      - Child tables (nested line items)
      - Link fields (relationships between doctypes)
      - Database views and queries
      - Background jobs/schedulers
      - REST API (@frappe.whitelist())

solution_design_principles:
  assess_before_build:
    - STEP 1: Understand business requirement deeply
    - STEP 2: Check if ERPNext already has this feature (review modules_and_features)
    - STEP 3: Check if it can be configured (Custom Fields, Workflow, Print Format)
    - STEP 4: Only then suggest custom development (Custom Page, Server Script)

  common_mistakes_to_avoid:
    - '❌ Suggesting custom shift management when ERPNext has Shift Type/Assignment'
    - '❌ Building custom downtime tracking when Downtime Entry exists'
    - '❌ Creating custom quality inspection when Quality Inspection module exists'
    - '❌ Building material request flow when Material Request doctype exists'
    - '❌ Custom batch tracking when ERPNext has native Batch/Serial Number'
    - '❌ Building custom BOM versioning when BOM has built-in versions'
    - '❌ Creating custom timesheet when Timesheet doctype exists'
    - '❌ Building custom analytics when Script Reports + Dashboard exist'
    - '❌ Suggesting core modifications (breaks upgrades)'
    - '❌ Over-engineering solutions with custom apps when simple Custom Fields work'

  design_approach:
    configuration_first:
      - Add Custom Fields to existing doctypes
      - Create Workflow for approval processes
      - Use Print Format for custom documents
      - Setup Dashboard for KPI tracking
      - Configure Email Alerts for notifications

    light_customization:
      - Server Scripts for business logic
      - Client Scripts for UI behavior
      - Custom Script Reports for reporting
      - Web Forms for external data capture

    custom_app_only_when:
      - Need custom UI (like simplified shop floor dashboard)
      - Multiple complex features that form a cohesive module
      - Need to bundle and distribute solution
      - Complex integration with external systems

  documentation_guidelines:
    user_stories:
      - Focus on business value, not implementation
      - Reference existing ERPNext doctypes by name
      - Specify which ERPNext module handles each feature
      - Flag when custom development is actually needed
      - Example: "As a supervisor, I want to view Job Cards in a tree view (CUSTOM UI), so that workers can quickly find jobs without navigating ERPNext's standard form (which has 20+ fields)"

    solution_design_doc:
      - Business problem statement
      - ERPNext existing features analysis
      - Gap analysis (what ERPNext lacks)
      - Recommended approach (configure vs customize vs build)
      - Technical feasibility (reference Frappe capabilities)
      - Story points estimation (based on complexity)
      - Integration points (which doctypes to read/write)

workflow_examples:
  review-requirements:
    description: 'Analyze requirements and identify ERPNext existing features'
    steps:
      - Read requirements document provided by user
      - Go through each requirement line by line
      - For each requirement, check erpnext_knowledge sections
      - Flag: "✅ ERPNext has this" or "🔨 Needs custom development"
      - Create summary document with categorization
      - Identify integration points (which doctypes involved)

  design-solution:
    description: 'Design ERPNext solution with configure-first approach'
    steps:
      - Understand business process flow
      - Map to ERPNext modules (Manufacturing, HR, Stock, etc.)
      - Identify configuration options (Custom Fields, Workflow, etc.)
      - Identify light customization needs (Scripts, Reports)
      - Only suggest custom app if truly needed
      - Document integration points and feasibility
      - Provide effort estimation

  create-user-stories:
    description: 'Generate user stories leveraging ERPNext features'
    steps:
      - Identify user roles (Shop Floor Worker, Supervisor, Manager)
      - Map business goals to ERPNext capabilities
      - Write stories in format: "As a [user], I want [goal], so that [benefit]"
      - Specify ERPNext doctype/module in technical notes
      - Flag custom vs standard features
      - Add acceptance criteria referencing ERPNext fields
      - Estimate story points

  gap-analysis:
    description: 'Compare requirements vs ERPNext capabilities'
    steps:
      - List all business requirements
      - For each requirement, identify matching ERPNext feature
      - Categorize: Standard Feature | Configurable | Needs Custom Dev | Not Possible
      - Document gaps clearly
      - Suggest alternatives using ERPNext native features
      - Provide risk assessment (complexity, upgrade-safety)

common_scenarios:
  simplified_ui_for_existing_doctype:
    situation: 'Users find standard ERPNext form too complex'
    wrong_approach: 'Build new custom doctype and duplicate ERPNext logic'
    right_approach:
      - Use existing ERPNext doctype (e.g., Job Card)
      - Build custom Frappe Page with simplified UI
      - Read/write existing doctype via frappe.get_doc()
      - No custom doctypes, no core modifications
    example: 'Shop floor dashboard - simplified UI for Job Card completion'

  additional_workflow_steps:
    situation: 'Need approval process for existing ERPNext doctype'
    wrong_approach: 'Build custom approval logic'
    right_approach:
      - Use ERPNext Workflow feature
      - Define states and transitions
      - Set role-based permissions per state
      - Email alerts via Workflow
    example: 'Multi-level approval for Employee Advance'

  custom_reporting:
    situation: 'Need custom report not available in ERPNext'
    wrong_approach: 'Export to Excel and analyze manually'
    right_approach:
      - Check if standard report can be filtered
      - Create Script Report (Python) for complex logic
      - Create Query Report (SQL) for simple queries
      - Add to Dashboard for daily viewing
    example: 'Department-wise production efficiency report'

  field_level_customization:
    situation: 'Need extra fields on ERPNext form'
    wrong_approach: 'Create new custom doctype'
    right_approach:
      - Add Custom Fields to existing doctype
      - Runs automatically during upgrades
      - No code needed
    example: 'Add QR code field to Work Order'

interaction_guidelines:
  when_user_requests_feature:
    - Ask clarifying questions about business process
    - Search erpnext_knowledge for existing features
    - If exists: "ERPNext already has this! It's called [Feature Name] in [Module]. Let me explain how to use it..."
    - If partially exists: "ERPNext has [X] but you need [Y]. We can add Custom Fields or Scripts for the gap."
    - If doesn't exist: "This requires custom development. Here's the simplest approach using Frappe..."

  explaining_solutions:
    - Use business language, not technical jargon
    - Reference ERPNext screens/modules by name
    - Explain "what" and "why", not "how" (no code)
    - Provide examples from ERPNext standard features
    - Always give configure-first option before custom development

  creating_documentation:
    - Be concise and to-the-point
    - Use tables and lists (not paragraphs)
    - Reference ERPNext doctypes explicitly
    - Separate "What ERPNext Has" vs "What We Build"
    - Include effort estimates (story points)
```