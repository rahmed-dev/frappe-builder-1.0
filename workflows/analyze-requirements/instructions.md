# Analyze Requirements Workflow Instructions

<critical>The workflow execution engine is governed by: {project-root}/.bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: workflow.yaml</critical>
<critical>This is a Frappe-specific workflow - Frappe bench awareness is MANDATORY</critical>

## Frappe Bench Context

**CRITICAL**: This workflow operates in Frappe bench environment.

**Session Variables** (set by agent or workflow):
- `{{current_app}}` - Frappe app name (e.g., "custom_app")
- `{{app_path}}` - Full path: `{frappe_bench_path}/apps/{{current_app}}`
- `{{docs_path}}` - Documents directory: `{{app_path}}/docs`

**Document Output Path:**
- BRD: `{{docs_path}}/brd/brd-{{date}}.md`

<workflow>

<step n="1" goal="Gather rough requirements from user">
<action>Collect the messy, unstructured requirements from the user.

This could be:
- Meeting notes
- Email threads
- Verbal descriptions
- Rough documentation
- User stories without structure

Ask the user:
"Please share your requirements in whatever form you have them - notes, emails, descriptions, anything. I'll help structure them into a proper BRD."

Accept input in any format. Don't worry about structure yet - we'll organize it in later steps.
</action>

<template-output>raw_requirements</template-output>
</step>

<step n="2" goal="Understand business context and goals">
<action>Explore the business context through open conversation:

Ask clarifying questions to understand:
- What problem is this solving?
- Who are the users? (roles, departments)
- What are the pain points with current process?
- What does success look like?
- Any compliance or regulatory requirements?

Adapt depth based on user's responses. If they're brief, dig deeper. If they're comprehensive, acknowledge and move forward.

This context is crucial for mapping to ERPNext modules correctly.
</action>

<template-output>business_context</template-output>
</step>

<step n="3" goal="Identify ERPNext modules involved">
<action>Based on the requirements and business context, identify which ERPNext modules are involved:

**ERPNext Core Modules:**
- **Sales**: Sales Orders, Quotations, Customers, Sales Invoices
- **Purchasing**: Purchase Orders, Suppliers, Purchase Receipts, Purchase Invoices
- **Stock**: Stock Entries, Item Management, Warehouses, Stock Reconciliation
- **Manufacturing**: BOM, Work Orders, Production Planning, Job Cards
- **HR**: Employee, Attendance, Leave, Payroll, Recruitment
- **CRM**: Leads, Opportunities, Customer interactions
- **Projects**: Project, Tasks, Timesheets, Project costing
- **Accounting**: Journal Entries, Payment Entries, Chart of Accounts
- **Assets**: Asset Management, Asset Maintenance

For each requirement, think:
- Which ERPNext module handles this naturally?
- Are there integrations needed between modules?
- What data flows between modules?

Present your analysis of which modules are involved and why.
</action>

<template-output>erpnext_modules</template-output>
</step>

<step n="4" goal="Gap analysis - Standard vs Custom">
<action>For each requirement, perform gap analysis:

**Standard Features:**
- What can ERPNext do out-of-the-box?
- Which standard DocTypes cover this?
- Are there standard workflows/processes?

**Configuration Needed:**
- What Custom Fields are needed?
- Do we need custom Workflows?
- Are there custom Print Formats required?
- Role permission adjustments?

**Custom Development:**
- What requires Server Scripts or Client Scripts?
- Do we need custom DocTypes?
- Are there unique business rules?
- Third-party integrations?

Be honest and precise. Don't over-promise standard features. Don't over-complicate with custom when configuration suffices.

Present as a table:
| Requirement | Standard? | Configuration | Custom Development |
</action>

<template-output>gap_analysis</template-output>
</step>

<step n="5" goal="Identify integration touch-points">
<action>Identify all integration points:

**Internal Integrations** (between ERPNext modules):
- Sales Order → Delivery Note → Sales Invoice
- Purchase Order → Purchase Receipt → Purchase Invoice
- Stock Entry impacts across modules

**External Integrations** (third-party systems):
- Payment gateways
- Shipping providers
- ERP systems
- CRM systems
- E-commerce platforms
- APIs

For each integration:
- What data flows?
- Sync frequency (real-time, batch, scheduled)?
- Direction (unidirectional, bidirectional)?
- Error handling requirements?
</action>

<template-output>integration_points</template-output>
</step>

<step n="6" goal="Define stakeholders and roles">
<action>Identify who will use this system:

**User Roles:**
- Who creates data? (Sales User, Purchase User, etc.)
- Who approves? (Sales Manager, Purchase Manager, etc.)
- Who views reports? (Management, Accountants, etc.)

**ERPNext Role Mapping:**
- Which ERPNext standard roles apply?
- Do we need custom roles?
- What permissions for each role?

**Departments Involved:**
- Which departments use which modules?
- Cross-departmental workflows?
</action>

<template-output>stakeholders</template-output>
</step>

<step n="7" goal="Structure into Business Requirements Document">
<action>Now structure everything into a formal BRD using the template.

Organize the collected information into:
1. Executive Summary (2-3 paragraphs)
2. Business Goals (bullets)
3. ERPNext Modules Involved (with justification)
4. Detailed Requirements (organized by module)
5. Gap Analysis (Standard/Config/Custom breakdown)
6. Integration Touch-Points (internal & external)
7. Stakeholders (roles and permissions)
8. Success Criteria (how we measure success)

Write in {document_output_language}.
Be clear, concise, and actionable.
</action>

<template-output>structured_brd</template-output>
</step>

<step n="8" goal="Validate completeness" optional="true">
<action>Review the BRD with the user:

Ask:
- "Have I captured all requirements?"
- "Is the ERPNext module mapping correct?"
- "Are there any missing integration points?"
- "Do the success criteria make sense?"

If user requests changes, update the relevant sections.
</action>

<action if="changes requested">Update the affected template sections</action>
</step>

<step n="9" goal="Update active.yaml with BRD path + Extract Summary (MAKER Integration - GAP 4 FIX)">
<action>After saving the BRD document, update the project state:

**File to Update:** `.bmad/custom/modules/frappe-builder/state/active.yaml`

**Step 1: Extract BRD Summary**
- Read the saved BRD file
- Locate the "Executive Summary" section
- Extract first 3 sentences (or up to 150 words)
- This summary provides quick context for all agents

**Step 2: Update active.yaml**
```yaml
brd: "{{docs_path}}/brd/brd-{{date}}.md"   # Path to created BRD
summary: "[Extracted 3 sentences from Executive Summary]"  # Quick project context
updated: "{{timestamp}}"                    # Current timestamp
```

**How to update:**
1. Read existing active.yaml
2. Update the `brd` field with the BRD path
3. Update the `summary` field with extracted Executive Summary text
4. Update the `updated` field with current timestamp
5. Write back to active.yaml

**Benefits of Summary Extraction:**
- Agents get instant project context (<50 tokens vs 1000+ for full BRD)
- Consistent summary across all agents
- No manual copy-paste needed
- Auto-updated when BRD changes

This enables:
- Architect can find BRD automatically
- All agents get quick project context via summary field
- Nexus tracks project artifacts
- State-based workflow coordination
- Gap 4 FIXED: BRD summary extraction is now automated
</action>

<template-output>state_updated_with_summary</template-output>
</step>

</workflow>
