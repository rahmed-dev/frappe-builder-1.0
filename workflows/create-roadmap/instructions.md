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
<action>Search for TSD using fuzzy file matching.

Try patterns:
- `{{docs_path}}/tsd/*.md`
- `{{docs_path}}/tsd/*/index.md` (if sharded)

If sharded:
- Read index.md
- Read ALL section files
- Combine as single document

If multiple TSDs found, ask user which one.
</action>

<template-output>tsd_content</template-output>
</step>

<step n="2" goal="Extract all features from TSD">
<action>Review the TSD and extract every feature/requirement:

Organize by 4-tier framework:
- **Tier 1 (Standard):** Features using ERPNext out-of-box
- **Tier 2 (Configure):** Features needing configuration
- **Tier 3 (Scripts):** Features needing code scripts
- **Tier 4 (Custom):** Features needing custom DocTypes

For each feature, note:
- Feature name/description
- Which tier
- Which DocTypes involved
- Estimated complexity (Simple/Medium/Complex)

Create comprehensive feature list.
</action>

<template-output>feature_list</template-output>
</step>

<step n="3" goal="Analyze DocType dependencies">
<action>Build dependency graph for all DocTypes mentioned in TSD:

**Identify Dependencies:**
- **Link Fields:** DocType A has Link field to DocType B → A depends on B
- **Child Tables:** Parent DocType depends on Child DocType
- **Workflow Triggers:** DocType A creates DocType B on submit → A depends on B
- **Data Flow:** DocType A reads data from DocType B → A depends on B

**Dependency Types:**
- **Blocking:** Cannot build A until B exists
- **Non-blocking:** Can build in parallel, link later

Create dependency graph showing:
- Foundation DocTypes (no dependencies)
- Dependent DocTypes (depend on others)
- Interdependent DocTypes (circular dependencies - flag these!)

Present as:
```
Foundation:
- Customer (no dependencies)
- Item (no dependencies)

Dependent:
- Sales Order (depends on: Customer, Item)
- Delivery Note (depends on: Sales Order)
- Sales Invoice (depends on: Delivery Note, Sales Order)
```
</action>

<template-output>dependency_analysis</template-output>
</step>

<step n="4" goal="Identify critical path">
<action>Determine which features MUST be built first:

**Critical Path Analysis:**
1. Foundation features (no dependencies)
2. Features that block the most other features
3. Longest dependency chain
4. Features required for minimal viable system

Example:
```
Critical Path:
1. Customer DocType (blocks Sales Order)
2. Item DocType (blocks Sales Order)
3. Sales Order DocType (blocks Delivery Note, Sales Invoice)
4. Delivery Note DocType (blocks Sales Invoice)
5. Sales Invoice DocType (completes sales cycle)

This is the MINIMUM sequence for a working sales flow.
```

Identify THE critical path - the minimum sequence to get a working system.
</action>

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

For EACH phase, list:
- User tasks (what user configures via UI)
- Developer tasks (what developer codes)
- Dependencies (what must be done first)
- Completion criteria (how we know phase is done)
</action>

<template-output>phased_breakdown</template-output>
</step>

<step n="7" goal="Identify parallel work opportunities">
<action>Analyze which features can be built simultaneously:

**Parallel Work Criteria:**
- Features in different modules (Sales vs Stock)
- Features with no shared dependencies
- Features that don't interact with each other
- Features assigned to different developers

Example:
```
Parallel Tracks:
Track A (Sales Module):
- Sales Order customization
- Sales Invoice workflow
- Sales reports

Track B (Stock Module):
- Stock Entry enhancements
- Warehouse management
- Stock reports

These can be built simultaneously because they don't depend on each other.
```

Benefits:
- Faster delivery (2 developers work in parallel)
- Reduced waiting time
- Better resource utilization

Present parallel work opportunities for each phase.
</action>

<template-output>parallel_opportunities</template-output>
</step>

<step n="8" goal="Structure into Implementation Plan">
<action>Organize all planning information into the template:

Write in {document_output_language}.

Ensure completeness:
- All features categorized
- All dependencies identified
- All three phases defined
- User tasks vs Developer tasks split for each phase
- Critical path documented
- Parallel work opportunities identified
- Completion criteria for each phase

The Implementation Plan should be actionable - team can start work immediately with clear understanding of sequence.
</action>

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

</workflow>
