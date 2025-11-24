# ERPNext Projects & Accounting Modules

> Tier 1 reference for project management, accounting features, and workflows.

## Projects Module

### Core DocTypes

| DocType | Purpose | Key Features | Standard? |
|---------|---------|--------------|-----------|
| **Project** | Project lifecycle management | Costing, task tracking, start/end dates, status | ✅ |
| **Task** | Task assignment/tracking | Dependencies, time tracking, status, priority | ✅ |
| **Timesheet** | Time tracking | Billable hours, payroll integration, project/task link | ✅ |
| **Project Template** | Reusable project structure | Pre-defined tasks, task templates | ✅ |
| **Project Type** | Project categorization | Internal, external, billable, non-billable | ✅ |

### Business Processes

**Project Creation:**
1. Create Project → Set dates, customer, cost center
2. Add tasks (manual or from template)
3. Assign users to tasks
4. Track progress via task completion %

**Time Tracking:**
1. Employee creates Timesheet
2. Links to Task/Project
3. Marks billable/non-billable hours
4. Integrates with Payroll (salary calculation)
5. Can generate Sales Invoice for billable hours

**Task Dependencies:**
- Set predecessor tasks
- Auto-calculate dates based on dependencies
- Gantt chart visualization

### Configuration

| Feature | Location | Use Case |
|---------|----------|----------|
| Project defaults | Project Settings | % completion method, ignore holidays |
| Task priorities | Task DocType | High, Medium, Low customization |
| Billable activities | Activity Type | Define billable vs non-billable activities |

### Customization (Tier 2)

**Custom Fields:**
- Add "Client Contact" to Project (Link: Contact)
- Add "Risk Level" to Project (Select: Low/Medium/High)
- Add "QA Status" to Task (Select: Pending/Pass/Fail)

**Workflows:**
- Project approval (Draft → Approved → In Progress → Completed)
- Task approval for sensitive projects

**Reports:**
- Project profitability (Script Report)
- Resource utilization by project
- Overdue tasks by user

## Accounting Module

### Core DocTypes

| DocType | Purpose | Key Features | Standard? |
|---------|---------|--------------|-----------|
| **Payment Entry** | Record payments | Advances, reconciliation, multi-currency | ✅ |
| **Journal Entry** | Manual accounting entries | Debit/credit entries, multi-account | ✅ |
| **Cost Center** | Profit center tracking | Budgets, hierarchical structure | ✅ |
| **Budget** | Budget management | Monthly/yearly budgets, variance analysis | ✅ |
| **Fiscal Year** | Financial year definition | Start/end dates, year-end closing | ✅ |
| **Accounts Settings** | Global accounting config | Defaults, frozen accounts, credit limits | ✅ |

### Business Processes

**Payment Entry:**
1. Create Payment Entry (Receive/Pay)
2. Select party (Customer/Supplier)
3. Select invoices to allocate
4. Record advance if no invoice
5. Submit → updates ledger

**Journal Entry:**
1. Create Journal Entry
2. Add accounts with debit/credit
3. Ensure debit = credit total
4. Add cost centers for tracking
5. Submit → posts to GL

**Cost Center Tracking:**
- Assign to transactions (PO, SO, Invoice)
- Track expenses/revenue by department
- Budget vs actual variance reports

### Configuration

| Feature | Location | Use Case |
|---------|----------|----------|
| Chart of Accounts | Accounts | Define account structure |
| Payment Terms | Payment Terms Template | Net 30, 50% advance patterns |
| Tax Templates | Sales/Purchase Taxes | VAT, GST configurations |
| Credit Limits | Customer/Supplier | Set credit limits by party |

### Customization (Tier 2)

**Custom Fields:**
- Add "Approval Required" to Payment Entry (Check)
- Add "Internal Order Number" to Journal Entry (Data)

**Workflows:**
- Payment approval (Draft → Pending → Approved → Paid)
- Journal entry approval for amounts > $10k

**Reports:**
- Cost center-wise profitability
- Budget variance by department
- Payment aging analysis

## Automation Features

### Workflow (Standard)

| Use Case | Configuration |
|----------|---------------|
| Project approval | States: Draft, Pending Approval, Approved, Rejected |
| Payment approval | Transitions based on amount threshold |
| Task sign-off | Multi-level approval for critical tasks |

**Setup:**
1. Create Workflow
2. Define States (Draft, Approved, etc.)
3. Define Transitions (who can move to next state)
4. Set email alerts per transition

### Auto Repeat

**Recurring Projects:**
- Monthly maintenance projects
- Quarterly audits
- Annual compliance tasks

**Configuration:**
1. Enable Auto Repeat on Project Template
2. Set frequency (Monthly, Quarterly)
3. Define start/end date

### Assignment Rule

**Auto-assign Tasks:**
- Round-robin assignment to team
- Load-balanced assignment (by open tasks)
- Department-based assignment

### Email Alert

**Notifications:**
- Task overdue → Notify assignee + manager
- Project milestone reached → Notify customer
- Payment received → Notify accounts team
- Budget exceeded → Notify cost center owner

**Configuration:**
1. Setup Email Alert
2. Select DocType (Task, Project, Payment Entry)
3. Define condition (due_date < today)
4. Set recipients (field-based or role-based)

## Integration Points

### Projects ↔ Accounting

| Integration | How |
|-------------|-----|
| Timesheet → Payroll | Billable hours calculate salary |
| Timesheet → Sales Invoice | Bill customers for project hours |
| Project → Cost Center | Track project expenses |
| Task completion → Journal Entry | Capitalize development costs |

### Projects ↔ HR

| Integration | How |
|-------------|-----|
| Task → Timesheet | Track employee time on tasks |
| Timesheet → Salary Slip | Auto-calculate salary from hours |
| Employee → Task Assignment | Assign based on department/skills |

## Solution Design Checklist

**Before custom development:**

- [ ] Does ERPNext Project module handle project lifecycle? ✅ YES
- [ ] Can Task dependencies model business process? ✅ YES (predecessors)
- [ ] Is time tracking needed? ✅ Timesheet built-in
- [ ] Need billable hours invoicing? ✅ Timesheet → Sales Invoice
- [ ] Need project costing? ✅ Built-in project costing
- [ ] Need payment tracking? ✅ Payment Entry built-in
- [ ] Need multi-level approvals? ⚙️ Use Workflow (Tier 2)
- [ ] Need custom project fields? ⚙️ Custom Fields (Tier 2)
- [ ] Need recurring projects? ⚙️ Auto Repeat (Tier 2)
- [ ] Need custom reports? 🔨 Script Report (Tier 3)
- [ ] Need simplified UI for project tracking? 🏗️ Custom Page (Tier 4)

## Anti-Patterns

❌ **Don't:**
- Build custom timesheet when ERPNext has Timesheet
- Create custom payment tracking (use Payment Entry)
- Build task dependency logic (use Task predecessors)
- Create manual budget tracking (use Budget + Cost Center)
- Build custom project templates (use Project Template)

✅ **Do:**
- Use built-in Project for lifecycle management
- Use Timesheet for all time tracking
- Use Payment Entry for all payments
- Use Cost Center for departmental tracking
- Add Custom Fields for business-specific data
- Use Workflow for approval processes
- Use Script Reports for custom analytics
