# Design Solution Workflow Instructions

<critical>The workflow execution engine is governed by: {project-root}/.bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: workflow.yaml</critical>
<critical>This is a Frappe-specific workflow - Frappe bench awareness is MANDATORY</critical>

## Frappe Bench Context

**CRITICAL**: This workflow operates in Frappe bench environment.

**Session Variables:**
- `{{current_app}}` - Frappe app name
- `{{app_path}}` - Full path: `{frappe_bench_path}/apps/{{current_app}}`
- `{{docs_path}}` - Documents directory: `{{app_path}}/docs`

**Document Output Path:**
- TSD: `{{docs_path}}/tsd/tsd-{{date}}.md`

<workflow>

<step n="1" goal="Load Business Requirements Document">
<action>Search for BRD using fuzzy file matching.

Try patterns:
- `{{docs_path}}/brd/*.md`
- `{{docs_path}}/brd/*/index.md` (if sharded)

If sharded version found:
- Read index.md to understand structure
- Read ALL section files listed in index
- Treat combined content as single document

If multiple BRDs found, ask user which one to use.
</action>

<template-output>brd_content</template-output>
</step>

<step n="2" goal="Apply 4-tier framework to each requirement">
<action>For EACH requirement in the BRD, apply the 4-tier framework:

**Tier 1: Standard ERPNext Features**
Ask: Can ERPNext do this out-of-the-box?
- Which standard DocTypes handle this?
- Are there existing workflows/processes?
- Is this a common ERPNext use case?

**Tier 2: Configuration Required**
Ask: Can configuration achieve this without code?
- Custom Fields (which DocType, field details)?
- Workflow states and transitions?
- Property Setters (hide fields, change labels)?
- Print Format customizations?
- Role permissions?

**Tier 3: Scripts Required**
Ask: Do we need custom business logic?
- Server Scripts (validations, calculations, triggers)?
- Client Scripts (UI behavior, auto-fills, dependencies)?
- API endpoints (@frappe.whitelist())?

**Tier 4: Custom App Required**
Ask: Is a fully custom DocType needed?
- Custom DocType with controllers?
- Complex business logic?
- Hooks into Frappe events?
- Custom pages or portals?

**Decision Rule:** Use lowest tier possible. Only move up when lower tier cannot satisfy requirement.

Document tier decision for EACH requirement with justification.
</action>

<template-output>tier_analysis</template-output>
</step>

<step n="3" goal="Design DocType structures for Tier 4 requirements">
<action if="Tier 4 custom DocTypes needed">For each custom DocType required, design complete structure:

**DocType Definition:**
- DocType name (CamelCase, e.g., "Purchase Requisition")
- Purpose (what business entity does this represent?)
- Module (which ERPNext module does it belong to?)

**Fields Design:**
For each field specify:
- Fieldname (snake_case)
- Label (Display name)
- Fieldtype (Data, Link, Select, Table, Currency, Date, Text, Small Text, etc.)
- Options (for Select/Link fields)
- Mandatory (required field?)
- Read Only (calculated/auto-filled?)
- Depends On (show/hide based on other fields?)

**Child Table Design** (if nested data needed):
- Child DocType name
- Fields in child table
- Parent link

**Link Fields** (relationships to other DocTypes):
- Which DocTypes link to?
- Link field names
- Cascade behavior (what happens if linked doc deleted?)

**Naming Series:**
- Naming pattern (e.g., "PR-.YYYY.-.#####")
- Auto-naming rule

**Permissions:**
- Which roles can read/write/submit/delete?
- Field-level permissions if needed

**Workflows** (if approval process needed):
- States (Draft, Pending, Approved, Rejected)
- Transitions (who can move between states?)
- Email notifications

Present complete DocType designs in structured format.
</action>

<template-output>doctype_designs</template-output>
</step>

<step n="4" goal="Design configuration changes for Tier 2 requirements">
<action if="Tier 2 configuration needed">For each configuration change required:

**Custom Fields:**
- Target DocType (which standard DocType to customize?)
- Field specifications (same detail as DocType fields above)
- Insert After (where in form layout?)
- Purpose (why this field is needed?)

**Workflow Configuration:**
- Target DocType
- States and transitions
- Role-based permissions per state
- Email notifications per transition

**Property Setters:**
- Target DocType
- Property to change (label, hidden, read_only, etc.)
- New value
- Reason for change

**Print Format Customizations:**
- Target DocType
- Template changes
- Additional fields to display
- Formatting requirements

Present all configuration changes in structured format.
</action>

<template-output>configuration_design</template-output>
</step>

<step n="5" goal="Design script logic for Tier 3 requirements">
<action if="Tier 3 scripts needed">For each script required:

**Server Scripts:**
- DocType/Event (which DocType, which trigger: before_save, on_submit, etc.)
- Logic description (what does this script do?)
- Pseudo-code or detailed algorithm
- Validation rules
- Calculations
- Side effects (creates other docs, sends emails, etc.)

**Client Scripts:**
- DocType/Event (which DocType, which trigger: refresh, field change, etc.)
- UI behavior (what changes on screen?)
- Field dependencies (when field X changes, update field Y)
- Auto-fill logic
- Custom buttons (what do they do?)

**API Endpoints:**
- Function name (@frappe.whitelist())
- Parameters
- Business logic
- Return format
- Permission checks required

Present script designs with clear logic flow.
</action>

<template-output>script_designs</template-output>
</step>

<step n="6" goal="Design UX with Frappe native components">
<action>For custom UI elements, design using Frappe native components:

**Available Frappe UI Components:**
- **frappe.ui.Dialog** - Modal dialogs, wizards
- **frappe.ui.DataTable** - Interactive tables
- **frappe.ui.form.MultiSelectDialog** - Multi-select pickers
- **Custom Buttons** - Form toolbar buttons
- **Indicators/Badges** - Status indicators
- **Dashboard Cards** - KPI displays
- **Field Dependencies** - Dynamic form behavior

For each UI requirement:
- Which Frappe component to use?
- Configuration (title, fields, buttons)
- Interaction flow
- Data handling

**Anti-pattern to AVOID:**
❌ Custom HTML/CSS
❌ jQuery DOM manipulation
❌ Non-Frappe components

**Always use Frappe-native components** for upgrade safety and consistency.

Present UX designs with component specifications.
</action>

<template-output>ux_design</template-output>
</step>

<step n="7" goal="Analyze performance considerations">
<action>Review the design for performance implications:

**Field Indexing:**
- Which fields will be filtered/searched frequently?
- Recommend indexes on: Link fields, Select fields, frequently filtered Data fields

**Query Optimization:**
- Are there N+1 query patterns? (get_all in loops)
- Recommend batch queries or JOINs

**Background Jobs:**
- Which operations are heavy/slow?
- Recommend background jobs for: bulk operations, external API calls, complex calculations

**Caching:**
- What data is static or rarely changes?
- Recommend caching for: dropdown options, settings, reference data

**Data Volume:**
- Will child tables grow large?
- Recommend pagination for: large child tables, report results

Present performance recommendations with reasoning.
</action>

<template-output>performance_considerations</template-output>
</step>

<step n="8" goal="Assess upgrade safety">
<action>Evaluate how safe this design is for future ERPNext upgrades:

**Safe (No upgrade risk):**
✅ Using standard DocTypes only
✅ Custom Fields only
✅ Custom Print Formats
✅ Workflows on standard DocTypes
✅ Role permissions

**Moderate Risk (Test after upgrades):**
⚠️ Server Scripts (may need adjustment if Frappe API changes)
⚠️ Client Scripts (UI changes may affect)
⚠️ Custom DocTypes with Link to standard DocTypes

**High Risk (Avoid if possible):**
❌ Modifying core Frappe/ERPNext code
❌ Monkey-patching standard functions
❌ Overriding standard DocType controllers without super()

**Custom App with Hooks (Depends on hooks used):**
- Standard hooks (on_submit, on_cancel): Low risk
- Override hooks (doc_events replacing standard): High risk

Present upgrade safety assessment with risk mitigation strategies.
</action>

<template-output>upgrade_safety</template-output>
</step>

<step n="9" goal="Design integration architecture" optional="true">
<action if="external integrations required">For each external integration:

**API Design:**
- Endpoint structure (@frappe.whitelist() methods)
- HTTP methods (GET, POST, PUT, DELETE)
- Request format (JSON structure)
- Response format (JSON structure)

**Authentication:**
- API Key + Secret?
- OAuth?
- Token-based?
- IP whitelisting?

**Error Handling:**
- HTTP status codes
- Error response format
- Retry logic
- Timeout handling

**Data Sync:**
- Real-time (webhooks)?
- Batch (scheduled jobs)?
- Polling?
- Sync frequency?

**Rate Limiting:**
- Requests per minute?
- Throttling strategy?

Present integration architecture with sequence diagrams if needed.
</action>

<template-output>integration_architecture</template-output>
</step>

<step n="10" goal="Structure into Technical Specification Document">
<action>Organize all design information into the TSD template:

Write in {document_output_language}.

Ensure completeness:
- All requirements from BRD addressed
- All tiers documented
- All DocTypes designed
- All configurations specified
- All scripts designed
- UX components specified
- Performance considerations noted
- Upgrade safety assessed
- Integrations architected (if applicable)

The TSD should be implementation-ready - a developer should be able to build from this without clarification.
</action>

<template-output>complete_tsd</template-output>
</step>

<step n="11" goal="Validate completeness" optional="true">
<action>Review TSD with user:

Ask:
- "Does this design match your requirements?"
- "Is the 4-tier framework application correct?"
- "Are there any missing components?"
- "Does the upgrade safety assessment make sense?"

If changes needed, update the relevant sections.
</action>

<action if="changes requested">Update the affected template sections</action>
</step>

<step n="12" goal="Update active.yaml with TSD path (MAKER Integration)">
<action>After saving the TSD document, update the project state:

**File to Update:** `.bmad/custom/modules/frappe-builder/state/active.yaml`

**Fields to Update:**
```yaml
tsd: "{{docs_path}}/tsd/tsd-{{date}}.md"  # Path to the created TSD
updated: "{{timestamp}}"                   # Current timestamp
```

**How to update:**
1. Read existing active.yaml
2. Update the `tsd` field with the TSD path
3. Update the `updated` field with current timestamp
4. Write back to active.yaml

This enables:
- Planner can find TSD automatically
- Dev can reference TSD without searching
- Nexus tracks project artifacts
- State-based workflow coordination
</action>

<template-output>state_updated</template-output>
</step>

</workflow>
