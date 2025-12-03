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
<action>Ask for all raw inputs (notes, emails, descriptions, stories). Accept any format; no structuring yet.</action>

<template-output>raw_requirements</template-output>
</step>

<step n="2" goal="Understand business context and goals">
<action>Clarify business context: problem, roles/users, pain points, success criteria, compliance. Depth as needed.</action>

<template-output>business_context</template-output>
</step>

<step n="3" goal="Identify ERPNext modules involved">
<action>Map requirements to ERPNext modules (use erpnext-modules-guide "{bmad_folder}/frappe-builder/agents/erpnext-ba-sidecar/knowledge/erpnext-modules-guide.md"). Note module fit + data flows/integrations.</action>

<template-output>erpnext_modules</template-output>
</step>

<step n="4" goal="Gap analysis - Standard vs Custom">
<action>Gap analysis per requirement: Standard (OOB DocTypes/workflows), Configure (custom fields/workflows/print formats/roles), Custom (scripts, DocTypes, integrations). Present table: Requirement | Standard | Configure | Custom. Be conservative on “standard”.</action>

<template-output>gap_analysis</template-output>
</step>

<step n="5" goal="Identify integration touch-points">
<action>Identify integration points (internal flows, external systems). Capture data flows, direction, frequency, and error handling.</action>

<template-output>integration_points</template-output>
</step>

<step n="6" goal="Define stakeholders and roles">
<action>Identify roles/departments: who creates/approves/views; map to ERPNext roles; note custom roles/permissions if needed.</action>

<template-output>stakeholders</template-output>
</step>

<step n="7" goal="Structure into Business Requirements Document">
<action>Now structure everything into a formal BRD using the template.

Organize the collected information into:
1. Make all the Sections Numbered and Sub-headings numbered as well.
2. Executive Summary (1-2 paragraphs)
3. Business Goals (bullets)
4. ERPNext Modules Involved (with justification and Tabular Structure)
5. Detailed Requirements (organized by module)
6. Gap Analysis (Standard/Config/Custom breakdown)
7. Integration Touch-Points (internal & external)
8. Stakeholders (roles and permissions)
9. Success Criteria (how we measure success)

Write in {document_output_language}.
Be clear, compact, to-the-point, and actionable.
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

<step n="9" goal="Update active.yaml with BRD path + Extract Summary">
<action>After saving the BRD document, update the project state:

**File to Update:** `.bmad/frappe-builder/state/active.yaml`

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
</action>

<template-output>state_updated_with_summary</template-output>
</step>

</workflow>
