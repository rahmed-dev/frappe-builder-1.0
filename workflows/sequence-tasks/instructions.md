# Sequence Tasks Workflow Instructions

<critical>The workflow execution engine is governed by: {project-root}/.bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: workflow.yaml</critical>
<critical>This is a Frappe-specific workflow - Frappe bench awareness is MANDATORY</critical>

<workflow>

<step n="1" goal="Get unordered feature list from user">
<action>Ask for unordered feature/task list (any format). Parse into individual tasks.</action>

<template-output>raw_task_list</template-output>
</step>

<step n="2" goal="Analyze dependencies for each task">
<action>For each task, list dependencies: DocTypes involved/created, DocType/link prereqs, data/config/functional deps. Summarize per task.</action>

<template-output>task_dependencies</template-output>
</step>

<step n="3" goal="Build dependency graph">
<action>Categorize tasks: no deps, single, multiple, blocking. Flag circular deps. Provide simple graph/list.</action>

<template-output>dependency_graph</template-output>
</step>

<step n="4" goal="Reorder tasks by dependencies">
<action>Order tasks by satisfied dependencies; tasks at same level can run in parallel. Present by sequence level with deps/parallel notes.</action>

<template-output>sequenced_tasks</template-output>
</step>

<step n="5" goal="Present sequenced list with rationale">
<action>Present the final dependency-ordered task list:

**Format:**
For each task, explain:
- Position in sequence (why this order?)
- Dependencies (what must be done first?)
- Parallel opportunities (what can be done simultaneously?)
- Estimated complexity (Simple/Medium/Complex)

**Example Output:**
```
=== DEPENDENCY-ORDERED TASK SEQUENCE ===

Phase 1: Foundation (No Dependencies)
1. Customer DocType setup
   - No dependencies
   - Can start immediately
   - Blocks: Sales Order, Delivery Note

2. Item DocType setup
   - No dependencies
   - Can start immediately (parallel with #1)
   - Blocks: Sales Order, Stock Entry

Phase 2: Core Workflows (Depends on Phase 1)
3. Sales Order customization
   - Depends on: Customer (#1), Item (#2)
   - Must wait for Customer and Item to exist
   - Blocks: Delivery Note, Sales Invoice

Phase 3: Extended Features (Depends on Phase 2)
4. Delivery Note workflow
   - Depends on: Sales Order (#3)
   - Can run parallel with #5

5. Stock Entry enhancements
   - Depends on: Item (#2), Sales Order (#3)
   - Can run parallel with #4

Phase 4: Final Integration (Depends on Phase 3)
6. Sales Invoice automation
   - Depends on: Delivery Note (#4), Sales Order (#3)
   - Final task in sequence
```

Optionally save to file if user requests.
</action>

<template-output>final_presentation</template-output>
</step>

</workflow>
