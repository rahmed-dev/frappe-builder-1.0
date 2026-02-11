# Create Roadmap Workflow Instructions

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
- Implementation Plan: `{{docs_path}}/implementation-plans/plan-{{date}}.md`

<workflow>

<step n="1" goal="Load Technical Specification Document">
<action>Find TSD (`{{docs_path}}/tsd/*.md` or sharded index). If multiple, ask which. Load full content.</action>

<template-output>tsd_content</template-output>
</step>

<step n="2" goal="Extract all features from TSD">
<action>Extract all features/requirements from TSD, tag by tier (Standard/Configure/Scripts/Custom), note DocTypes and complexity.</action>

<template-output>feature_list</template-output>
</step>

<step n="3" goal="Analyze DocType dependencies">
<action>Build DocType dependency graph: links, child tables, workflow triggers, data flows. Mark blocking vs non-blocking; flag circular. List foundation/dependent DocTypes.</action>

<template-output>dependency_analysis</template-output>
</step>

<step n="4" goal="Identify critical path">
<action>Identify critical path: foundation features, top blockers, longest chains, minimum viable sequence. List the minimal sequence to a working system.</action>

<template-output>critical_path</template-output>
</step>

<step n="5" goal="Divide User tasks vs Developer tasks">
<action>For EACH feature in the feature list, categorize as User task or Developer task:

**USER TASKS** (Configuration via ERPNext UI):
- Custom DocType creation (structure, fields via UI)
- Custom Field additions to standard DocTypes
- Workflow configuration (states, transitions)
- Print Format customization (drag-and-drop designer)
- Role & Permission assignments
- Property Setters (hide fields, change labels)
- ERPNext standard features setup (Company, Warehouse, etc.)

**DEVELOPER TASKS** (Code):
- Server Scripts (Python business logic)
- Client Scripts (JavaScript UI behavior)
- Custom Reports (Python Script Reports)
- API endpoints (@frappe.whitelist())
- Third-party integrations (external APIs)
- Background jobs (scheduled tasks)
- Hooks (frappe hooks)
- Custom pages/portals

**Critical Distinction:**
- Can it be done by clicking in ERPNext UI? → User task
- Does it require writing code? → Developer task

Organize all features into these two categories.
</action>

<template-output>task_categorization</template-output>
</step>

<step n="6" goal="Create phased breakdown">
<action>Organize features into 3 phases based on dependencies:

**Phase 1: Foundation (MVP - Minimum Viable Product)**
Goal: Deliver minimum useful system

Include:
- Foundation DocTypes (no dependencies)
- Core workflow (end-to-end)
- Essential features only
- Must be independently testable and deployable

Criteria:
- Can user accomplish primary business goal?
- Are critical dependencies satisfied?
- Is this deployable and useful on its own?

**Phase 2: Build (Extended Functionality)**
Goal: Add features that build on Phase 1

Include:
- Features depending on Phase 1
- Enhanced capabilities
- Additional workflows
- Integrations

Criteria:
- Adds value beyond Phase 1
- Builds on existing foundation
- Can be deployed incrementally

**Phase 3: Enhance (Optimization & Nice-to-Haves)**
Goal: Polish and advanced features

Include:
- Performance optimizations
- Advanced reports
- Nice-to-have features
- Future enhancements

Criteria:
- Not critical for core functionality
- Improves user experience
- Can be deferred if needed

For each phase: list User tasks (UI/config), Dev tasks (code), dependencies, completion criteria.
</action>

<template-output>phased_breakdown</template-output>
</step>

<step n="7" goal="Identify parallel work opportunities">
<action>Identify parallel tracks (different modules/no shared deps/different owners). List per phase to accelerate delivery.</action>

<template-output>parallel_opportunities</template-output>
</step>

<step n="8" goal="Structure into Implementation Plan">
<action>Compile the plan in {document_output_language}: features categorized, dependencies, phases defined, User vs Dev tasks per phase, critical path, parallel opportunities, completion criteria. Plan should be actionable.</action>

<template-output>complete_plan</template-output>
</step>

<step n="9" goal="Validate plan with user" optional="true">
<action>Review Implementation Plan with user:

Ask:
- "Does the phasing make sense?"
- "Is Phase 1 truly the minimum viable product?"
- "Are the dependencies correct?"
- "Can we adjust timeline expectations based on complexity?"

If changes needed, update relevant sections.
</action>

<action if="changes requested">Update the affected template sections</action>
</step>

<step n="10" goal="Update project state with roadmap information">
<action>After roadmap creation, update the project state:

**Files to Update:**
1. `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/active.yaml`

**active.yaml - Fields to Update:**
```yaml
current_task: "Roadmap created, ready for task sequencing"
workflow: "create-roadmap"
workflow_step: 10
last_action: "Created implementation roadmap with {{phase_count}} phases"
next_action: "Sequence tasks within each phase"
specialist: "frappe-planner"
updated: "{{timestamp}}"
```

**How to update:**
1. Read existing active.yaml
2. Update the fields above
3. Write back to file

This enables smooth handoff to sequence-tasks workflow.
</action>

<template-output>state_updated</template-output>
</step>

</workflow>
