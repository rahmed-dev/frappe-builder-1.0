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
<action>Find BRD (`{{docs_path}}/brd/*.md` or sharded index). If multiple, ask which. Load full content.</action>

<template-output>brd_content</template-output>
</step>

<step n="2" goal="Apply 4-tier framework to each requirement">
<action>For each requirement, choose lowest viable tier (Standard → Configure → Scripts → Custom). Note DocTypes/workflows/config needs, script needs, or custom DocType need. Document tier + rationale per requirement.</action>

<template-output>tier_analysis</template-output>
</step>

<step n="3" goal="Design DocType structures for Tier 4 requirements">
<action if="Tier 4 custom DocTypes needed">Design each custom DocType: name/purpose/module; fields (name/label/type/options/reqd/readonly/depends on); child tables; links; naming series; permissions; workflows (states/transitions/notifications). Present structured design.</action>

<template-output>doctype_designs</template-output>
</step>

<step n="4" goal="Design configuration changes for Tier 2 requirements">
<action if="Tier 2 configuration needed">List config changes: custom fields (target DocType, specs, insert after, purpose), workflows (states/transitions/roles/notifications), property setters (property/value/reason), print formats (target, additions, formatting). Present structured.</action>

<template-output>configuration_design</template-output>
</step>

<step n="5" goal="Design script logic for Tier 3 requirements">
<action if="Tier 3 scripts needed">For each script: server (doctype/event, logic, pseudocode, validations/calcs, side effects), client (doctype/event, UI behavior, dependencies, autofill, buttons), APIs (whitelisted endpoints, payloads, errors). Keep logic/pseudocode only.</action>
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

**Caching:** note static data to cache (dropdowns/settings/reference).\n\n**Data Volume:** flag large child tables/reports; recommend pagination.\n\nPresent performance recommendations with reasoning.</action>

<template-output>performance_considerations</template-output>
</step>

<step n="8" goal="Assess upgrade safety">
<action>Upgrade safety: Safe (standard DocTypes, custom fields/prints, workflows, roles); Moderate (server/client scripts, custom DocTypes linking standard); High risk (core mods, monkey-patching, override controllers without super). Hooks: standard low, overrides high. Provide mitigations.</action>

<template-output>upgrade_safety</template-output>
</step>

<step n="9" goal="Design integration architecture" optional="true">
<action if="external integrations required">For each integration: API design (endpoints/methods/payloads/responses), auth (key/secret, OAuth, token, IP allowlist), error handling (status codes, format, retries/timeouts), sync mode (webhooks, batch jobs, polling), conflict handling, security (rate limits, validation, permissions).</action>
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
