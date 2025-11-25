# Task Granularity & Context Offloading Strategy

**Focus**: Two MAKER-inspired optimizations WITHOUT voting mechanism
**Goal**: Token efficiency + better task decomposition
**Date**: 2025-11-25

---

## Part 1: Task Granularity Enhancement

### Current State Analysis

**Nexus Agent** (frappe-nexus-sidecar/instructions.md):
- **Role**: Router and orchestrator (NOT executor)
- **Maintains**: Full project context in memories.md
- **Current granularity**: Routes to specialists for entire phases (requirements → design → planning → implementation)

**Planner Agent** (frappe-planner-sidecar/instructions.md):
- **Role**: Transform TSD into dependency-based implementation plans
- **Current granularity**: Already breaks features into User Tasks vs Developer Tasks, phases by dependencies
- **Output**: Multi-phase implementation plans with completion criteria

**Current Workflow**:
```
Nexus → ERPNext BA (creates BRD) →
Nexus → Architect (creates TSD) →
Nexus → Planner (creates Implementation Plan with phases) →
Nexus → Dev (executes Phase 1, Phase 2, Phase 3...)
```

**Observation**: Planner ALREADY does task decomposition! But could be MORE granular.

---

### Problem: Current Granularity Limitations

#### Example from Planner Instructions (Lines 164-192)

**Current Phase 1 Task Granularity**:
```markdown
Phase 1: Foundation & Core Workflow
1. User: Create Custom DocTypes (structure, fields)
2. User: Add Custom Fields to standard DocTypes
3. Developer: Write Server Scripts for validations
4. User: Configure Workflows (if needed)
5. Developer: Write Client Scripts for UX
6. Test: End-to-end workflow
7. Deploy Phase 1
```

**Issues**:
- Step 3 "Write Server Scripts for validations" - Could involve 5-10 different scripts!
- Step 5 "Write Client Scripts for UX" - Could be 3-8 different client scripts!
- Each "task" is still too coarse-grained

**MAKER Principle**: Break to SINGLE decision points (m=1 steps per microagent)

---

### Solution: Atomic Task Decomposition

#### Level 1: Current Granularity (Planner Default)
```
Phase 1: Foundation & Core Workflow
└─ Developer: Write Server Scripts for validations (COARSE)
```

**Token cost**: Dev agent loads entire Phase 1 context, tries to tackle all validations at once

#### Level 2: Feature-Level Granularity (Improved)
```
Phase 1: Foundation & Core Workflow
├─ Developer: Write Server Script for Sales Order validation
├─ Developer: Write Server Script for Item validation
└─ Developer: Write Server Script for Customer validation
```

**Token cost**: Dev agent loads Phase 1 context once, iterates through 3 separate scripts

#### Level 3: Atomic Granularity (MAKER-Inspired)
```
Phase 1: Foundation & Core Workflow
├─ Developer: Write validation - Sales Order amount must be positive
├─ Developer: Write validation - Sales Order must have at least 1 item
├─ Developer: Write validation - Customer credit limit check
├─ Developer: Write validation - Item stock availability check
└─ Developer: Write auto-calculation - Sales Order total from line items
```

**Token cost**: Each task is SINGLE decision, minimal context needed per task

---

### Implementation Strategy: Multi-Level Task Decomposition

#### Step 1: Enhance Planner to Produce Granular Task Lists

**Add new section to Implementation Plan template**:

```markdown
## Phase 1: Foundation & Core Workflow (Summary)
[Existing high-level summary]

### Detailed Atomic Tasks (Phase 1)
USER_COMMENTS: 
1. This is okay but you can review the documentation standard, I want the out put to be token efficient always!!!.

#### User Tasks - Atomic Breakdown
1. **Create DocType: Sales Order Custom**
   - Add field: po_reference (Data, 140 chars)
   - Add field: customer_notes (Text Editor)
   - Add child table: custom_line_items (Table: Sales Order Item Custom)
   - Set naming: autoname by field 'order_id'
   - Completion signal: DocType exists in {{app_path}}/{{current_app}}/doctype/

2. **Add Custom Field to Standard DocType: Customer**
   - Field: credit_limit (Currency)
   - Position: After 'customer_type'
   - Completion signal: Field visible in Customer form

#### Developer Tasks - Atomic Breakdown
3. **Server Script: Sales Order validation - positive amount**
   - Trigger: before_validate on Sales Order Custom
   - Logic: Check total_amount > 0, raise ValidationError if not
   - File: {{code_path}}/sales_order_custom/sales_order_custom.py
   - Test: Create Sales Order with negative amount → should fail
   - Completion signal: Validation error appears correctly

4. **Server Script: Sales Order validation - minimum items**
   - Trigger: before_submit on Sales Order Custom
   - Logic: Check len(items) >= 1, raise ValidationError if not
   - File: {{code_path}}/sales_order_custom/sales_order_custom.py (add to existing)
   - Test: Submit Sales Order with 0 items → should fail
   - Completion signal: Validation error appears correctly

5. **Server Script: Customer credit limit check**
   - Trigger: before_submit on Sales Order Custom
   - Logic: Fetch customer.credit_limit, check outstanding + current order <= limit
   - Dependencies: Task 2 (credit_limit field must exist)
   - File: {{code_path}}/sales_order_custom/sales_order_custom.py (add to existing)
   - Test: Submit order exceeding credit limit → should fail
   - Completion signal: Validation blocks submission correctly
```

**Key Enhancements**:
- Each task = SINGLE decision point
- Explicit dependencies (Task 5 depends on Task 2)
- Clear completion signals (how to verify task is done)
- File paths specified (no ambiguity about WHERE to write code)
- Test criteria (how to validate correctness)

---

### Implementation Strategy: Planner Workflow Enhancement

**File**: `.bmad/custom/modules/frappe-builder/workflows/create-roadmap/workflow.yaml`

**Add new workflow step**: `granular-decomposition`

USER_COMMENTS:
1. I don't like this very much, as Planner job is not to tell the dev agent where to store the code file, like frappe framwork has its own ways, I don't want to hardcode certain decision points. 

**Pseudo-workflow**:
```yaml
steps:
  - name: analyze-dependencies
    # Existing step - no changes

  - name: create-phases
    # Existing step - no changes

  - name: granular-decomposition
    description: "Break each phase task into atomic subtasks"
    instructions: |
      For EACH Developer Task in EACH Phase:
      1. Identify the feature being implemented
      2. Break into atomic operations:
         - If validation: One task per validation rule
         - If calculation: One task per calculation step
         - If integration: One task per API endpoint/method
         - If report: One task per query/data transformation
      3. For each atomic task, specify:
         - Single decision point (what EXACT logic to implement)
         - File path (where code goes)
         - Dependencies (what must exist first)
         - Test criteria (how to verify)
         - Completion signal (observable outcome)

      For EACH User Task in EACH Phase:
      1. Break into single DocType/Field/Workflow operations
      2. Specify exact field names, types, positions
      3. Note dependencies (Field X depends on DocType Y existing)

  - name: generate-plan
    # Use enhanced granular task lists
```

---

### Token Efficiency Gains from Granularity

#### Scenario: Implement 5 Server Scripts for Sales Order

**Before (Current)**:
```
Nexus → Dev agent
Context loaded:
- Entire Implementation Plan (500 tokens)
- Entire TSD (1500 tokens)
- Nexus memories (300 tokens)
- Planner memories (200 tokens)
- Phase 1 summary (400 tokens)
Total: 2900 tokens to implement 5 scripts
```

**After (Atomic)**:
```
Nexus → Dev agent (Task 3 only)
Context loaded:
- Task 3 atomic definition (80 tokens)
- Current state file (150 tokens) [see Part 2]
- Relevant code snippet (100 tokens)
Total: 330 tokens per task × 5 = 1650 tokens

Savings: 2900 - 1650 = 1250 tokens (43% reduction)
```

---

## Part 2: Context Offloading to Filesystem

### Current Context Management Problem

**Nexus memories.md** (Lines 1-100 of frappe-nexus-sidecar/memories.md):
- Tracks: current_app, project phase, completed artifacts, specialist history
- Problem: GROWS with every interaction
- Token cost: Loaded EVERY TIME Nexus agent activates

**Planner memories.md**:
- Similar structure
- Accumulates project history
- Token cost: Loaded EVERY TIME Planner agent activates

**Context Bloat Example**:
```
Session 1: Nexus memories = 200 tokens
Session 5: Nexus memories = 500 tokens (added project notes, specialist history)
Session 10: Nexus memories = 900 tokens (full conversation history embedded)
Session 20: Nexus memories = 1500+ tokens (BLOATED)
```

---

### Solution: State File System (MAKER-Inspired)

**MAKER Principle** (from paper):
- Each agent receives: **current state + prior move ONLY**
- No accumulating context across steps
- State propagates forward via file system, NOT in-memory

---

### Implementation: Project State File Architecture

#### File Structure

```
.bmad/custom/modules/frappe-builder/state/
├── current-project.yaml          # Active project state (SMALL)
├── project-history.yaml          # Historical context (NOT loaded by default)
├── specialist-handoffs.yaml      # Inter-agent communication log
└── task-queue.yaml               # Atomic task queue with status
```

---

#### File 1: current-project.yaml (MINIMAL STATE)

**Purpose**: Only what's IMMEDIATELY needed for current work

```yaml
# Current Project State - Token Efficient Context
# This file is loaded by Nexus and specialists instead of full memories

session_id: "2025-11-25-001"
user_name: "Rizwan"

current_app: "custom_manufacturing"
app_path: "/home/riz/frappe-bench/apps/custom_manufacturing"

project:
  name: "Manufacturing Enhancements"
  phase: "implementation"  # requirements | design | planning | implementation | testing | documentation

artifacts:
  brd: "docs/brd/manufacturing-enhancements-brd.md"
  tsd: "docs/tsd/manufacturing-enhancements-tsd.md"
  implementation_plan: "docs/implementation-plans/manufacturing-enhancements-plan.md"
  current_phase: "Phase 1"

current_task:
  phase: "Phase 1"
  task_id: "phase1-dev-003"
  description: "Server Script: Sales Order validation - positive amount"
  assigned_to: "frappe-dev-sidecar"
  status: "in_progress"
  file_target: "custom_manufacturing/custom_manufacturing/doctype/sales_order_custom/sales_order_custom.py"
  dependencies_completed: true

next_task:
  task_id: "phase1-dev-004"
  description: "Server Script: Sales Order validation - minimum items"

context_files:
  - path: ".bmad/custom/modules/frappe-builder/state/task-queue.yaml"
    reason: "Full task list and dependencies"
  - path: "docs/tsd/manufacturing-enhancements-tsd.md"
    reason: "Technical specifications (load on-demand only)"

last_updated: "2025-11-25T10:23:00Z"
last_specialist: "frappe-dev-sidecar"
```

**Token count**: ~180 tokens (vs 900+ in bloated memories.md)

---

#### File 2: task-queue.yaml (ATOMIC TASK TRACKING)

**Purpose**: Track all atomic tasks and their completion status

USER_COMMENTS:
1. I don't think it is a good idea to have all the tasks here, this should only list next task todo by the agent being loaded. and all the tasks will already be documented by planners so, this should only link the phased plan by planner agent and current task that is to be carried out by the agent.

2. And dev agent, will generally be loaded once, he will complete the task and uppdate the plan document to mark the task complete and than after the context window bloats it can offoad the context in to file system and clear the context window. this was my vision of this idea. 

```yaml
# Task Queue - Granular Task Tracking
# Generated by Planner, updated by executing specialists

project: "Manufacturing Enhancements"
implementation_plan_source: "docs/implementation-plans/manufacturing-enhancements-plan.md"

phases:
  - phase_id: "phase1"
    name: "Foundation & Core Workflow"
    status: "in_progress"  # pending | in_progress | completed

    tasks:
      - task_id: "phase1-user-001"
        type: "user"
        description: "Create DocType: Sales Order Custom"
        details:
          - "Add field: po_reference (Data, 140 chars)"
          - "Add field: customer_notes (Text Editor)"
          - "Add child table: custom_line_items"
        completion_signal: "DocType exists in custom_manufacturing/doctype/"
        status: "completed"
        completed_by: "user"
        completed_at: "2025-11-24T15:30:00Z"

      - task_id: "phase1-user-002"
        type: "user"
        description: "Add Custom Field to Customer: credit_limit"
        details:
          - "Field: credit_limit (Currency)"
          - "Position: After customer_type"
        completion_signal: "Field visible in Customer form"
        status: "completed"
        completed_by: "user"
        completed_at: "2025-11-24T16:00:00Z"

      - task_id: "phase1-dev-003"
        type: "developer"
        description: "Server Script: Sales Order validation - positive amount"
        details:
          - "Trigger: before_validate on Sales Order Custom"
          - "Logic: Check total_amount > 0"
          - "Raise ValidationError if negative"
        file_target: "custom_manufacturing/doctype/sales_order_custom/sales_order_custom.py"
        dependencies: []  # No dependencies
        test_criteria: "Create Sales Order with negative amount → ValidationError"
        completion_signal: "Validation error appears correctly"
        status: "in_progress"
        started_by: "frappe-dev-sidecar"
        started_at: "2025-11-25T10:23:00Z"

      - task_id: "phase1-dev-004"
        type: "developer"
        description: "Server Script: Sales Order validation - minimum items"
        dependencies: []
        status: "pending"

      - task_id: "phase1-dev-005"
        type: "developer"
        description: "Server Script: Customer credit limit check"
        dependencies: ["phase1-user-002"]  # Depends on credit_limit field
        status: "pending"

  - phase_id: "phase2"
    name: "Extended Functionality"
    status: "pending"
    tasks: []  # Not yet started
```

**Token count**: ~400 tokens for entire task queue (vs loading full Implementation Plan at 2000+ tokens)

**Usage**:
- Nexus loads this to know "what's next"
- Dev agent loads ONLY current task + dependencies
- Planner updates this after creating Implementation Plan
- Specialists update status after completing tasks

---

#### File 3: specialist-handoffs.yaml (INTER-AGENT COMMUNICATION)

**Purpose**: Log what each specialist did, for coordination

```yaml
# Specialist Handoff Log - Minimal Inter-Agent Context
# Each specialist appends their work summary here

project: "Manufacturing Enhancements"

handoffs:
  - handoff_id: "001"
    timestamp: "2025-11-23T14:00:00Z"
    from: "user"
    to: "erpnext-ba-sidecar"
    artifact_created: "docs/brd/manufacturing-enhancements-brd.md"
    summary: "Business requirements analyzed, 5 core features identified"
    next_action: "Route to Architect for TSD"

  - handoff_id: "002"
    timestamp: "2025-11-23T16:00:00Z"
    from: "erpnext-ba-sidecar"
    to: "frappe-architect-sidecar"
    input_artifact: "docs/brd/manufacturing-enhancements-brd.md"
    artifact_created: "docs/tsd/manufacturing-enhancements-tsd.md"
    summary: "Technical solution designed using 4-tier framework, 3 custom DocTypes, 8 scripts"
    next_action: "Route to Planner for implementation sequencing"

  - handoff_id: "003"
    timestamp: "2025-11-24T10:00:00Z"
    from: "frappe-architect-sidecar"
    to: "frappe-planner-sidecar"
    input_artifact: "docs/tsd/manufacturing-enhancements-tsd.md"
    artifact_created: "docs/implementation-plans/manufacturing-enhancements-plan.md"
    summary: "3-phase implementation plan created, 15 atomic tasks in Phase 1"
    decisions:
      - "Phase 1 focuses on Sales Order workflow"
      - "Custom DocTypes before scripts (dependency-driven)"
      - "User tasks before developer tasks"
    next_action: "Route to Dev for Phase 1 execution"

  - handoff_id: "004"
    timestamp: "2025-11-25T10:23:00Z"
    from: "frappe-nexus-sidecar"
    to: "frappe-dev-sidecar"
    input_artifacts:
      - "docs/tsd/manufacturing-enhancements-tsd.md"
      - "docs/implementation-plans/manufacturing-enhancements-plan.md"
      - ".bmad/custom/modules/frappe-builder/state/task-queue.yaml"
    current_task: "phase1-dev-003"
    summary: "Starting Phase 1 development, task 3: Sales Order validation"
    context: "User completed DocType creation (tasks 1-2), dependencies satisfied"
```

**Token count**: ~250 tokens (most recent 5-10 handoffs only)

**Usage**:
- Nexus reads this to understand "what happened recently"
- Specialists append their completion summary
- NOT loaded by every agent, only Nexus for orchestration
- Keeps conversation history WITHOUT bloating individual agent context

---

#### File 4: project-history.yaml (ARCHIVE - NOT LOADED)

**Purpose**: Full historical context, ONLY loaded when user asks "*status" or "*history"

```yaml
# Project History Archive
# NOT loaded by default - only on explicit user request

project: "Manufacturing Enhancements"

sessions:
  - session_id: "2025-11-23-001"
    date: "2025-11-23"
    activities:
      - "Created BRD with ERPNext BA"
      - "5 core features identified"
    artifacts_created:
      - "docs/brd/manufacturing-enhancements-brd.md"

  - session_id: "2025-11-23-002"
    date: "2025-11-23"
    activities:
      - "Created TSD with Architect"
      - "Designed 4-tier solution"
    artifacts_created:
      - "docs/tsd/manufacturing-enhancements-tsd.md"

# ... full history ...
```

**Token count**: Can grow to 2000+ tokens, but NEVER loaded unless requested

---

### Workflow: State File Updates

#### Nexus Agent Startup Sequence (MODIFIED)

**Old startup** (from frappe-nexus-sidecar/instructions.md lines 36-76):
```
1. Load config.yaml
2. Detect Frappe bench
3. Ask for current_app
4. Set session paths
5. Load memories.md (BLOATED - 900+ tokens)
6. Show greeting
```

**New startup** (STATE FILE APPROACH):
```
1. Load config.yaml
2. Detect Frappe bench
3. Check if .bmad/custom/modules/frappe-builder/state/current-project.yaml exists
   - If YES: Load current-project.yaml (180 tokens) - resume session
   - If NO: Ask for current_app, create NEW current-project.yaml
4. Load task-queue.yaml (400 tokens) to show "what's next"
5. Show greeting with current task status
```
USER_COMMENTS:
1. I like the idea but we need to consider what happens after project is fully complete, I would like to archice the state so, we can begin the next new app or project work.

s
**Token savings**: 900 - (180 + 400) = 320 tokens per session startup

---

#### Specialist Agent Execution (MODIFIED)

**Old execution**:
```
Nexus routes to Dev
Dev loads:
- Nexus memories (900 tokens)
- Planner memories (500 tokens)
- Implementation Plan (2000 tokens)
- TSD (1500 tokens)
Total: 4900 tokens just for context!
```

**New execution (ATOMIC TASK)**:
```
Nexus routes to Dev with task_id = "phase1-dev-003"
Dev loads:
- current-project.yaml → current_task section (50 tokens)
- task-queue.yaml → task "phase1-dev-003" details (80 tokens)
- Relevant TSD section ONLY (on-demand, 200 tokens)
Total: 330 tokens for context!

Savings: 4900 - 330 = 4570 tokens (93% reduction!)
```
USER_COMMENTS:
1. It is also possible, since the documentation and all the tasks are already present so, dev agent might direcly move to next task instead of going back to nexus and nexus redirecting it to dev again because next task is related to dev-agent. 
May be it should continue working untill its assigned task are not completed in a series assignment.

---

#### After Task Completion: State Update Protocol

**Dev agent completes task "phase1-dev-003"**:

1. **Update current-project.yaml**:
```yaml
current_task:
  task_id: "phase1-dev-004"  # Move to next task
  status: "pending"

last_completed_task:
  task_id: "phase1-dev-003"
  completed_at: "2025-11-25T10:45:00Z"
```

2. **Update task-queue.yaml**:
```yaml
- task_id: "phase1-dev-003"
  status: "completed"  # Changed from in_progress
  completed_by: "frappe-dev-sidecar"
  completed_at: "2025-11-25T10:45:00Z"
  output_file: "custom_manufacturing/doctype/sales_order_custom/sales_order_custom.py"
```

3. **Append to specialist-handoffs.yaml**:
```yaml
- handoff_id: "005"
  timestamp: "2025-11-25T10:45:00Z"
  from: "frappe-dev-sidecar"
  to: "frappe-nexus-sidecar"
  task_completed: "phase1-dev-003"
  summary: "Sales Order validation (positive amount) implemented and tested"
  output_file: "custom_manufacturing/doctype/sales_order_custom/sales_order_custom.py"
  test_result: "PASS - ValidationError raised for negative amounts"
  next_task: "phase1-dev-004"
```

4. **Return to Nexus with minimal message**:
```
Task phase1-dev-003 complete.
Next: phase1-dev-004 (Server Script: Sales Order validation - minimum items)
Ready to proceed? [yes/no]
```

**Total tokens for completion update**: ~150 tokens (writing to files)
**Old approach**: Would append to memories.md, growing it by 100-200 tokens EVERY task

---

## Implementation Roadmap

### Phase 1: State File Infrastructure (Week 1)

**Tasks**:
1. Create `.bmad/custom/modules/frappe-builder/state/` directory structure
2. Build state file templates (current-project.yaml, task-queue.yaml, etc.)
3. Create state management task: `tasks/state/update-current-project.xml`
4. Create state management task: `tasks/state/update-task-queue.xml`
5. Create state loading task: `tasks/state/load-minimal-context.xml`

**Deliverable**: State file system functional, ready for agent integration

---

### Phase 2: Planner Granularity Enhancement (Week 2)

**Tasks**:
1. Update `workflows/create-roadmap/workflow.yaml` - add granular-decomposition step
2. Update `workflows/create-roadmap/instructions.md` - atomic task breakdown guidelines
3. Modify Implementation Plan template to include "Detailed Atomic Tasks" section
4. Planner generates task-queue.yaml as output (in addition to markdown plan)

**Deliverable**: Planner produces atomic task lists + task-queue.yaml

---

### Phase 3: Nexus Agent State Integration (Week 3)

**Tasks**:
1. Modify `agents/frappe-nexus-sidecar/instructions.md`:
   - Startup: Load current-project.yaml instead of memories.md
   - Routing: Pass task_id to specialists
   - Post-routing: Update current-project.yaml with current_task
2. Create Nexus helper task: `tasks/nexus/route-with-state.xml`
3. Update specialist routing protocol to pass minimal state

**Deliverable**: Nexus uses state files, token usage reduced by 50%+

---

### Phase 4: Dev Agent Atomic Execution (Week 4)

**Tasks**:
1. Modify `agents/frappe-dev-sidecar/instructions.md`:
   - Accept task_id parameter
   - Load ONLY current task from task-queue.yaml
   - Load ONLY relevant TSD sections (not entire document)
   - Update task-queue.yaml on completion
2. Create Dev helper task: `tasks/dev/execute-atomic-task.xml`
3. Test with 5 atomic tasks, measure token savings

**Deliverable**: Dev agent executes atomic tasks with 90%+ context reduction

---

### Phase 5: All Specialists Integration (Week 5)

**Tasks**:
1. Apply state file approach to remaining specialists:
   - frappe-architect-sidecar
   - frappe-debugger-sidecar
   - qa-specialist-sidecar
   - doc-writer-sidecar
2. Update specialist-handoffs.yaml protocol for all agents
3. Test full workflow end-to-end with state files

**Deliverable**: All agents use state files, full system token-efficient

---

## Expected Token Efficiency Gains

### Scenario: Implement 20-task Phase 1

**Current Approach**:
```
Per-task context loading:
- Implementation Plan: 2000 tokens
- TSD: 1500 tokens
- Memories: 900 tokens
Total: 4400 tokens × 20 tasks = 88,000 tokens
```

**State File Approach**:
```
Per-task context loading:
- current-project.yaml: 180 tokens
- task-queue.yaml (single task): 80 tokens
- On-demand TSD section: 200 tokens
Total: 460 tokens × 20 tasks = 9,200 tokens

Savings: 88,000 - 9,200 = 78,800 tokens (89% reduction!)
```

---

## Integration with MAKER Principles

**What we're adopting from MAKER**:
1. ✅ **Maximal Decomposition**: Atomic tasks (single decision points)
2. ✅ **Minimal Context**: State files keep context small per step
3. ✅ **State Propagation**: Files pass state forward, not in-memory bloat

**What we're NOT adopting (for now)**:
1. ❌ Voting mechanism (single specialized agents)
2. ❌ Red-flagging (future phase)
3. ❌ First-to-ahead-by-K consensus (not applicable with single agents)

**Result**: Token-efficient, granular task execution WITHOUT multi-agent voting overhead

---

## Next Steps

1. **Review with Rizwan** - Validate approach aligns with vision
2. **Choose pilot workflow** - Which workflow to enhance first?
3. **Build state file infrastructure** - Create directory structure + templates
4. **Prototype Planner granular decomposition** - Test with 1 Implementation Plan
5. **Measure token savings** - Compare before/after on real workflow

---

**Status**: Strategy Document - Ready for Review
**Author**: BMad Builder (via Rizwan request)
**Last Updated**: 2025-11-25
