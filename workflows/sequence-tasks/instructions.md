# Sequence Tasks Workflow Instructions

<critical>The workflow execution engine is governed by: {project-root}/.bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: workflow.yaml</critical>
<critical>This is a Frappe-specific workflow - Frappe bench awareness is MANDATORY</critical>

<workflow>

<step n="1" goal="Get unordered feature list from user">
<action>Ask user to provide unordered feature/task list.

Accept in any format:
- Bullet points
- Numbered list
- Comma-separated values
- Paragraph description
- Copy-paste from document

Parse and extract individual features/tasks.
</action>

<template-output>raw_task_list</template-output>
</step>

<step n="2" goal="Analyze dependencies for each task">
<action>For EACH task in the list, identify dependencies:

Ask for each task:
- **What DocTypes does this involve?**
- **Does this create or modify DocTypes?**
- **Does this depend on other DocTypes existing first?**
- **Does this depend on other features being complete?**

**Dependency Types:**
- **DocType Link Dependencies:** Task A uses DocType B → A depends on B existing
- **Data Flow Dependencies:** Task A reads data created by Task B → A depends on B
- **Configuration Dependencies:** Task A configures Feature B → B must exist first
- **Functional Dependencies:** Task A extends Task B → B must be done first

For each task, create dependency list:
```
Task: Create Sales Order custom fields
Depends on:
- Sales Order DocType exists (standard, no dependency)
- Customer custom fields (if Sales Order links to custom Customer fields)
```
</action>

<template-output>task_dependencies</template-output>
</step>

<step n="3" goal="Build dependency graph">
<action>Create visual dependency graph:

Categorize tasks:
- **No dependencies** (can start immediately)
- **One dependency** (depends on one other task)
- **Multiple dependencies** (depends on several tasks)
- **Blocking tasks** (many other tasks depend on this)

Create graph representation:
```
No Dependencies:
→ Task A (Customer DocType)
→ Task B (Item DocType)

Single Dependency:
→ Task C (Sales Order) depends on: Task A, Task B

Multiple Dependencies:
→ Task D (Delivery Note) depends on: Task C
→ Task E (Sales Invoice) depends on: Task C, Task D

Task C is BLOCKING (blocks Task D and E)
```

Identify circular dependencies (flag as issues):
```
⚠️ CIRCULAR: Task X depends on Task Y, Task Y depends on Task X
This needs to be resolved - cannot sequence with circular dependency.
```
</action>

<template-output>dependency_graph</template-output>
</step>

<step n="4" goal="Reorder tasks by dependencies">
<action>Create dependency-ordered sequence:

**Algorithm:**
1. Start with tasks that have no dependencies
2. Add tasks whose dependencies are all satisfied
3. Continue until all tasks ordered
4. Tasks with same dependency level can be parallel

**Sequenced List Format:**
```
Sequence 1 (No dependencies - can start immediately):
- Task A: Customer DocType
- Task B: Item DocType

Sequence 2 (Depends on Sequence 1):
- Task C: Sales Order (depends on A, B)

Sequence 3 (Depends on Sequence 2):
- Task D: Delivery Note (depends on C)
- Task E: Stock Entry (depends on C) [PARALLEL with D]

Sequence 4 (Depends on Sequence 3):
- Task F: Sales Invoice (depends on D)
```

For each sequence level, note:
- What tasks can be done
- What they depend on
- Which can be done in parallel
</action>

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
