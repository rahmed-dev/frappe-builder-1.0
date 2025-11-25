# MAKER Integration - Implementation Plan
**Project:** frappe-builder MAKER enhancements
**Goal:** Task granularity + context offloading + agent autonomy
**App:** frappe-builder module (`.bmad/custom/modules/frappe-builder/`)
**Sessions:** Multi-session execution (context-independent)

---

## Quick Reference

| Item | Value |
|------|-------|
| **Project root** | `/home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/` |
| **Standards** | anti-fluff-mandate.md, token-efficiency.md |
| **Total phases** | 3 |
| **Total tasks** | 24 (8 per phase) |
| **Current phase** | Phase 1 |
| **Current task** | Not started |

---

## Context: What We're Building

### Problem Statement
**Current state:**
- Agents load bloated memories.md (900+ tokens)
- Full Implementation Plans loaded per task (2000+ tokens)
- Dev returns to Nexus after EACH task (20 round-trips for 20 tasks)
- Context accumulates unbounded (can hit 200k+ tokens)
- No project archival (old projects clutter state)

**Impact:** 138k tokens for 20-task project

### Solution: MAKER-Inspired Approach
**New state:**
- Minimal active.yaml (60 tokens) - pointer only
- Task range autonomy (Dev works d3:d10 without Nexus returns)
- Context offloading (>50k tokens → dump to file, clear)
- Token-efficient plans (300 tokens vs 2000)
- Project archival (completed → archive/, fresh start)

**Impact:** 5k tokens for 20-task project (96% reduction)

### Core Components

| Component | Purpose | Token Impact |
|-----------|---------|--------------|
| active.yaml | Current project pointer | 60 tokens (was 900) |
| Token-efficient plan template | Planner output format | 300 tokens (was 2000) |
| context.md | Offloaded conversation history | 100 tokens (replaces 5000+) |
| Agent autonomy loop | Work through task range | 95% fewer round-trips |
| Archive system | Complete projects → storage | Clean slate |

---

## Phase 1: State Infrastructure & Templates

**Goal:** File structure + templates ready, no agent integration yet

**Duration:** 2-3 days

### Tasks

| ID | Task | Deliverable | Tokens | Status |
|----|------|-------------|--------|--------|
| **i1** | Create `state/` directory structure | Dirs exist | - | [ ] |
| **i2** | Create `active.yaml` template | File template | 60 | [ ] |
| **i3** | Create `context.md` template | File template | 100 | [ ] |
| **i4** | Create `archive/` structure | Dir + README | - | [ ] |
| **i5** | Create token-efficient plan template | Markdown template | 300 | [ ] |
| **i6** | Validate templates against standards | Pass checklist | - | [ ] |
| **i7** | Create state management tasks | 2 XML task files | - | [ ] |
| **i8** | Test: Generate sample plan, measure tokens | <350 tokens | - | [ ] |

### Task Details

#### i1: Create state/ directory structure
```bash
# Execute in project root
mkdir -p .bmad/custom/modules/frappe-builder/state/archive
```

**Verify:**
```bash
ls -la .bmad/custom/modules/frappe-builder/state/
# Should show: archive/
```

---

#### i2: Create active.yaml template
**File:** `.bmad/custom/modules/frappe-builder/state/active.yaml.template`

**Content:**
```yaml
# Active Project State - Pointer Only
# Token target: <60

project: ""           # Project display name
app: ""               # Frappe app name
plan: ""              # Path to implementation plan
tsd: ""               # Path to TSD (if exists)
phase: ""             # Current phase (Phase 1, Phase 2, etc)
specialist: ""        # Current agent (frappe-dev-sidecar, etc)
tasks: ""             # Task range (d3:d10, a1:a5, etc)
context: null         # Path to context.md if offloaded
updated: ""           # ISO timestamp
```

**Validation:**
- Count tokens: Must be <60
- All fields documented inline
- YAML valid

---

#### i3: Create context.md template
**File:** `.bmad/custom/modules/frappe-builder/state/context.md.template`

**Content:**
```markdown
# Context: [Project] - [Phase]
Date: [ISO] | Agent: [specialist]

## Completed

| Task | Description | Status |
|------|-------------|--------|
| [id] | [what] | ✓ |

## Files Modified
- [path]

## Current Task
[id]: [description]

## Issues
[None or list]

---
Context cleared after this dump
```

**Validation:**
- Count tokens: Must be <120
- Table format enforced
- No prose sections

---

#### i4: Create archive/ structure
**File:** `.bmad/custom/modules/frappe-builder/state/archive/README.md`

**Content:**
```markdown
# Project Archives

Completed projects stored here.

## Structure
```
archive/
└── [project-name]/
    ├── active.yaml       # Final state
    ├── plan.md           # Implementation plan
    ├── tsd.md            # Tech spec (if exists)
    └── context/
        └── dump-*.md     # Context snapshots
```

## Resume Project
1. Copy `[project]/active.yaml` → `../active.yaml`
2. Uncheck all tasks in plan.md (for iteration)
3. Update `active.yaml` timestamp
```

---

#### i5: Create token-efficient plan template
**File:** `.bmad/custom/modules/frappe-builder/templates/documents/implementation-plan-efficient.md`

**Content:**
```markdown
# Plan: [Project Name]
App: [app_name] | TSD: [path or "N/A"]

## Phase 1: [Goal One-Liner]

### User Tasks
- [ ] u1: DocType "[Name]" ([field1], [field2], [child_table])
- [ ] u2: Field on [DocType]: [field_name] ([Type])
- [ ] u3: Workflow: [DocType] ([State1→State2→State3])

### Dev Tasks
- [ ] d4: Validation - [rule]
- [ ] d5: Calc - [what]
- [ ] d6: Client - [behavior]
- [ ] d7: Server - [trigger action]

**Complete when:** [Observable outcome]

---

## Phase 2: [Goal]

### Dev Tasks
- [ ] d8: Report - [what data]
- [ ] d9: Dashboard - [metrics]
- [ ] d10: Background - [scheduled task]

**Complete when:** [Observable outcome]

---

## Phase 3: [Goal]
(Follow same format)

---

## Dependencies

| Task | Needs | Why |
|------|-------|-----|
| d5 | u2 | Field must exist first |
| d10 | d4-d9 | Core features before automation |

---

## Task Ranges

| Specialist | Phase 1 | Phase 2 | Phase 3 |
|------------|---------|---------|---------|
| User | u1:u3 | - | - |
| Dev | d4:d7 | d8:d10 | d11:d15 |
| QA | - | q1:q3 | - |

---

## Notes
- Dev works autonomously through ranges
- Updates checkboxes as completes
- Returns to Nexus when range complete or blocked
```

**Validation:**
- Count tokens: Must be <350 for 3-phase plan
- Tables used for dependencies & ranges
- Terse task format (WHAT only, no WHERE/HOW)
- Checkboxes present

---

#### i6: Validate templates against standards
**Checklist:**
- [ ] active.yaml: <60 tokens
- [ ] context.md: <120 tokens
- [ ] plan template: <350 tokens (3 phases)
- [ ] All use tables > bullets > prose (where applicable)
- [ ] No file paths in task specs
- [ ] No verbose explanations
- [ ] YAML/Markdown valid
- [ ] Passes anti-fluff mandate standards
- [ ] Information density >0.8 tokens/unit

**Reference standards:**
- `.bmad/custom/modules/frappe-builder/standards/core/anti-fluff-mandate.md`
- `.bmad/custom/modules/frappe-builder/standards/core/token-efficiency.md`

---

#### i7: Create state management tasks
**File 1:** `.bmad/custom/modules/frappe-builder/tasks/state/offload-context.xml`

**Purpose:** Detect context bloat, write dump, clear history

**Content:**
```xml
<task id="offload-context" name="Offload Context to File">
  <description>
    When context exceeds 50k tokens:
    1. Get completed tasks from plan
    2. Get modified files list
    3. Write context.md in table format
    4. Clear conversation history
    5. Update active.yaml: context = "state/context.md"
  </description>

  <instructions>
    1. Check context size: Count tokens in conversation
    2. IF size > 50000:
       - Read active.yaml for project name, phase
       - Read plan.md for completed tasks (checked boxes)
       - Create context.md:
         * Header: Project, phase, date, agent
         * Table: Completed tasks
         * List: Modified files
         * Current: Next task ID + description
       - Write to: .bmad/custom/modules/frappe-builder/state/context.md
       - Clear conversation history (tool/method specific to agent framework)
       - Update active.yaml: context = "state/context.md"
    3. ELSE: No action needed
  </instructions>

  <output>
    - context.md created (if >50k)
    - active.yaml updated
    - Fresh conversation context
  </output>
</task>
```

**File 2:** `.bmad/custom/modules/frappe-builder/tasks/state/archive-project.xml`

**Purpose:** Move completed project to archive

**Content:**
```xml
<task id="archive-project" name="Archive Completed Project">
  <description>
    Move completed project to archive/, clean for next project
  </description>

  <instructions>
    1. Verify project complete: active.yaml phase = "Complete"
    2. Create archive directory: state/archive/[project-name]/
    3. Copy files:
       - active.yaml → archive/[project]/active.yaml
       - [plan path] → archive/[project]/plan.md
       - [tsd path] → archive/[project]/tsd.md (if exists)
       - state/context.md → archive/[project]/context/dump-final.md (if exists)
    4. Delete: state/active.yaml
    5. Confirm to user: "Archived to state/archive/[project]/"
  </instructions>

  <output>
    - Project in archive/[project-name]/
    - state/active.yaml deleted
    - Fresh state for next project
  </output>
</task>
```

---

#### i8: Test template with sample plan
**Create test file:** `.bmad/custom/modules/frappe-builder/state/test-plan.md`

**Use template from i5**, fill with realistic data:
- 3 phases
- 15 tasks total
- Dependencies
- Task ranges

**Measure:**
```bash
# Count tokens (approximate: words * 1.3)
wc -w state/test-plan.md
# Multiply by 1.3 for token estimate
# Must be <350 tokens
```

**Validate:**
- All sections present
- Tables used correctly
- Terse format maintained
- Information complete (no data loss)

---

### Phase 1 Completion Criteria

- [ ] Directory structure exists: `state/`, `state/archive/`
- [ ] All templates created and validated
- [ ] Templates pass token count requirements
- [ ] Templates pass anti-fluff standards
- [ ] State management tasks written (XML files)
- [ ] Test plan generated, measured <350 tokens
- [ ] No agent integration yet (just infrastructure)

---

## Phase 2: Nexus Integration

**Goal:** Nexus uses state files instead of memories.md

**Duration:** 2-3 days

### Tasks

| ID | Task | Deliverable | File Modified | Status |
|----|------|-------------|---------------|--------|
| **n1** | Backup original Nexus instructions | .bak file | nexus instructions | [ ] |
| **n2** | Modify Nexus startup: Load active.yaml | Updated instructions | nexus instructions | [ ] |
| **n3** | Add Nexus: Create new project flow | Updated instructions | nexus instructions | [ ] |
| **n4** | Add Nexus: Resume archived project | Updated instructions | nexus instructions | [ ] |
| **n5** | Add Nexus: Set task range on routing | Updated instructions | nexus instructions | [ ] |
| **n6** | Add Nexus: Detect + archive completed | Updated instructions | nexus instructions | [ ] |
| **n7** | Update Nexus memories.md → state pointer | New memories format | nexus memories | [ ] |
| **n8** | Test: Full lifecycle (create→work→archive→resume) | Pass test | - | [ ] |

### Task Details

#### n1: Backup original Nexus instructions
```bash
cp agents/frappe-nexus-sidecar/instructions.md \
   agents/frappe-nexus-sidecar/instructions.md.backup-pre-maker
```

**Verify:**
```bash
ls -la agents/frappe-nexus-sidecar/
# Should show: instructions.md.backup-pre-maker
```

---

#### n2: Modify Nexus startup sequence
**File:** `agents/frappe-nexus-sidecar/instructions.md`

**Section to modify:** "Startup Sequence (EVERY TIME agent loads)" (lines 38-76)

**OLD startup (lines 38-76):**
```
1. Load Config
2. Detect Frappe Bench
3. Ask User for Current App
4. Set Session Paths
5. Confirm to User
6. Show Greeting and Menu
```

**NEW startup:**
```markdown
### Startup Sequence (EVERY TIME agent loads)

1. **Load Config**
   - Read {project-root}/.bmad/custom/modules/frappe-builder/config.yaml
   - Store all configuration variables

2. **Detect Frappe Bench**
   - Check if {project-root}/apps/ directory exists
   - If NOT found: Warn user "Frappe-Builder designed for Frappe bench"
   - If found: Proceed to step 3

3. **Check Active Project State**
   - Check if {project-root}/.bmad/custom/modules/frappe-builder/state/active.yaml exists

   **IF EXISTS (resuming project):**
   - Load active.yaml (60 tokens)
   - Read: project, app, phase, specialist, tasks
   - Greet: "Resuming '[project]' | [specialist] working on [tasks]"
   - Skip to step 6

   **IF NOT EXISTS (new or archived):**
   - Proceed to step 4

4. **New or Resume Decision**
   ```
   No active project. Choose:
   1. Start new project
   2. Resume archived project

   Enter choice (1 or 2):
   ```

   **IF choice = 1 (New project):**
   - Ask: "Which Frappe app?"
   - List: ls {project-root}/apps/
   - Store as {{current_app}}
   - Create active.yaml:
     ```yaml
     project: "[User provided name]"
     app: "{{current_app}}"
     plan: ""
     tsd: ""
     phase: "Planning"
     specialist: "frappe-nexus-sidecar"
     tasks: ""
     context: null
     updated: "[ISO timestamp]"
     ```
   - Proceed to step 6

   **IF choice = 2 (Resume archived):**
   - List: ls {project-root}/.bmad/custom/modules/frappe-builder/state/archive/
   - Ask: "Which project to resume?"
   - Copy: archive/[project]/active.yaml → state/active.yaml
   - Load active.yaml
   - Ask: "Iterate (uncheck tasks) or continue?"
     - Iterate: Uncheck all tasks in plan.md
     - Continue: Keep task states
   - Proceed to step 6

5. **Set Session Paths** (if new project)
   - {{app_path}} = {project-root}/apps/{{current_app}}
   - {{docs_path}} = {{app_path}}/docs

6. **Show Status and Greeting**
   ```
   ✅ Active Project: [project name]
   📱 App: [app]
   📍 Phase: [phase]
   🤖 Specialist: [specialist]
   📋 Tasks: [task range or "Not assigned"]

   What do you need?
   ```
```

**Token impact:**
- OLD: Load memories.md (900 tokens)
- NEW: Load active.yaml (60 tokens)
- **Savings: 840 tokens per session startup**

---

#### n3: Add Nexus: Create new project flow
**Already covered in n2, step 4 "IF choice = 1"**

**Additional: Create helper in instructions**

**Add section:** "Creating New Project"

```markdown
## Creating New Project

When user starts new project:
1. Ask for project name
2. Ask for Frappe app (list apps/ directory)
3. Create active.yaml in state/
4. Route to ERPNext BA for requirements (if no BRD exists)
5. Update active.yaml with plan path after Planner completes

**DO NOT:**
- Create memories.md (obsolete)
- Load old session state
```

---

#### n4: Add Nexus: Resume archived project
**Already covered in n2, step 4 "IF choice = 2"**

**Additional: Document resume options**

**Add section:** "Resuming Archived Projects"

```markdown
## Resuming Archived Projects

When user resumes from archive:
1. List available: ls state/archive/
2. User selects project
3. Copy archive/[project]/active.yaml → state/active.yaml
4. Ask: "Iterate or continue?"
   - **Iterate:** Uncheck all task boxes in plan.md, start fresh implementation
   - **Continue:** Keep task states, resume where left off
5. Update active.yaml timestamp
6. Load project context

**Use cases:**
- Iterate: User wants to rebuild with lessons learned
- Continue: User adding more features to completed project
```

---

#### n5: Add Nexus: Set task range on routing
**File:** `agents/frappe-nexus-sidecar/instructions.md`

**Section to modify:** "INTELLIGENT ROUTING LOGIC" (lines 96-143)

**Add to routing section:**

```markdown
### Setting Task Range for Specialists

When routing to specialist, update active.yaml with task range:

**Example: Routing to Dev for Phase 1 implementation**
```python
# Nexus reads plan.md, identifies Dev task range for Phase 1
# Plan shows: d4:d7 (4 tasks)

# Update active.yaml:
specialist: "frappe-dev-sidecar"
tasks: "d4:d7"
phase: "Phase 1"
updated: "[ISO timestamp]"
```

**Specialist receives:**
- Pointer to plan via active.yaml
- Task range to work autonomously
- Knows when to return (after d7 or if blocked)

**Task Range Format:**
- Single task: `d4`
- Range: `d4:d7` (tasks d4, d5, d6, d7)
- Multiple ranges: `d4:d7,d10:d12` (if non-contiguous)
```

---

#### n6: Add Nexus: Detect + archive completed
**File:** `agents/frappe-nexus-sidecar/instructions.md`

**Add new section:** "Project Completion & Archival"

```markdown
## Project Completion & Archival

### Detecting Completion

When specialist returns with "Project complete" or all phase tasks checked:
1. Verify: Read plan.md, check all tasks have ✓
2. Update active.yaml: phase = "Complete"

### Archival Flow

```
Ask user: "Project '[name]' complete! Archive?"

IF YES:
  1. Execute: tasks/state/archive-project.xml
  2. Confirm: "Archived to state/archive/[project]/"
  3. Inform: "state/active.yaml cleared. Ready for next project."

IF NO:
  - Keep active.yaml (user may add features later)
  - Inform: "Active project kept. Can resume or extend."
```

### Next Session After Archival

- No active.yaml exists
- Startup will offer: "New or resume archived?"
- User can resume and iterate if desired
```

---

#### n7: Update Nexus memories.md format
**File:** `agents/frappe-nexus-sidecar/memories.md`

**OLD format (lines 1-100):** Full project state tracking

**NEW format:**
```markdown
# Frappe-Nexus Session Memories

## State File Location
Active project state: `.bmad/custom/modules/frappe-builder/state/active.yaml`

**DO NOT track project state here. Read from active.yaml instead.**

## Session Notes
[Optional: User preferences, patterns observed across multiple projects]

## Standards References
- Anti-fluff: `.bmad/custom/modules/frappe-builder/standards/core/anti-fluff-mandate.md`
- Token efficiency: `.bmad/custom/modules/frappe-builder/standards/core/token-efficiency.md`

---

**Last Updated:** [Date]
**Note:** This file is minimal. All project state in active.yaml.
```

**Token impact:**
- OLD memories.md: 900+ tokens (and growing)
- NEW memories.md: ~80 tokens (static)
- **Savings: 820+ tokens**

---

#### n8: Test full lifecycle
**Test scenario:**

```
1. Start fresh (delete state/active.yaml if exists)
2. Invoke Nexus
3. Select "New project"
4. Name: "Test MAKER Integration"
5. App: Pick any test app
6. Verify: active.yaml created correctly
7. Route to Planner (simulate)
8. Update: active.yaml with plan path
9. Mark project complete: phase = "Complete"
10. Archive: Answer "yes" to archive
11. Verify: state/archive/test-maker-integration/ exists
12. Verify: state/active.yaml deleted
13. Invoke Nexus again
14. Select "Resume archived"
15. Select "Test MAKER Integration"
16. Verify: active.yaml restored
17. SUCCESS: Full lifecycle works
```

**Validation checklist:**
- [ ] New project creates active.yaml
- [ ] Routing updates active.yaml correctly
- [ ] Completion detected
- [ ] Archive creates correct structure
- [ ] active.yaml cleared after archive
- [ ] Resume restores active.yaml
- [ ] Token counts within targets

---

### Phase 2 Completion Criteria

- [ ] Nexus loads active.yaml instead of memories.md
- [ ] New project flow working
- [ ] Resume archived flow working
- [ ] Task range set when routing to specialists
- [ ] Completion detection + archival working
- [ ] memories.md converted to minimal format
- [ ] Full lifecycle test passes
- [ ] Token savings verified (900→60 = 840 tokens)

---

## Phase 3: Dev Agent Autonomy + Context Offloading

**Goal:** Dev works through task ranges autonomously, offloads context when bloated

**Duration:** 3-4 days

### Tasks

| ID | Task | Deliverable | File Modified | Status |
|----|------|-------------|---------------|--------|
| **d1** | Backup Dev agent instructions | .bak file | dev instructions | [ ] |
| **d2** | Add Dev: Load active.yaml for task range | Updated instructions | dev instructions | [ ] |
| **d3** | Add Dev: Autonomous execution loop | Updated instructions | dev instructions | [ ] |
| **d4** | Add Dev: Context size detection | Updated instructions | dev instructions | [ ] |
| **d5** | Add Dev: Context offload integration | Updated instructions | dev instructions | [ ] |
| **d6** | Add Dev: Update plan checkboxes | Updated instructions | dev instructions | [ ] |
| **d7** | Add Dev: Return protocol (range complete) | Updated instructions | dev instructions | [ ] |
| **d8** | Test: 10-task scenario, measure tokens | Pass test, metrics | - | [ ] |

### Task Details

#### d1: Backup Dev agent instructions
```bash
cp agents/frappe-dev-sidecar/instructions.md \
   agents/frappe-dev-sidecar/instructions.md.backup-pre-maker
```

---

#### d2: Add Dev: Load active.yaml for task range
**File:** `agents/frappe-dev-sidecar/instructions.md`

**Add section at top:** "Startup & Task Range"

```markdown
## Startup & Task Range

### Every Session Start

1. **Load Active Project**
   - Read: `.bmad/custom/modules/frappe-builder/state/active.yaml`
   - Extract:
     ```yaml
     project: "[name]"
     app: "[app]"
     plan: "[path]"
     tsd: "[path]"
     tasks: "[range]"  # Example: "d4:d7"
     phase: "[phase]"
     ```

2. **Parse Task Range**
   ```python
   # Example: tasks = "d4:d7"
   start = "d4"
   end = "d7"
   task_list = ["d4", "d5", "d6", "d7"]
   ```

3. **Load Implementation Plan**
   - Read: Plan from path in active.yaml
   - Find Phase section matching active.yaml phase
   - Locate tasks in range

4. **Load TSD (on-demand)**
   - Don't load entire TSD upfront
   - Load sections as needed per task
   - Keep context minimal

**Token cost:**
- active.yaml: 60 tokens
- Plan (full): 300 tokens
- TSD (per section): ~150 tokens
- **Total initial load: 360 tokens** (vs 4900 old approach)
```

---

#### d3: Add Dev: Autonomous execution loop
**File:** `agents/frappe-dev-sidecar/instructions.md`

**Add section:** "Autonomous Task Execution Loop"

```markdown
## Autonomous Task Execution Loop

### Pattern

```
FOR each task_id IN task_range:
  1. Read task from plan.md
  2. Load relevant TSD section (on-demand)
  3. Implement task
  4. Test implementation
  5. Update plan.md: - [ ] → - [x]
  6. Update active.yaml: current task
  7. Check context size (see Context Management)
  8. IF task_id == range_end:
       Exit loop, return to Nexus
     ELSE:
       Continue to next task
```

### Example

**Task range:** d4:d7

**Execution:**
```
Task d4: "Validation - amount > 0"
  - Implement validation in DocType controller
  - Test: Create doc with negative amount → error
  - Update plan: ✓ d4
  - Continue

Task d5: "Validation - items >= 1"
  - Implement validation
  - Test: Submit doc with 0 items → error
  - Update plan: ✓ d5
  - Check context: 25k tokens, continue

Task d6: "Calc - total from line items"
  - Implement calculation
  - Test: Verify total matches sum
  - Update plan: ✓ d6
  - Check context: 55k tokens → OFFLOAD (see Context Management)
  - Continue with fresh context

Task d7: "Server - create delivery note"
  - Implement server script
  - Test: Submit order → delivery note created
  - Update plan: ✓ d7
  - Range complete, return to Nexus
```

### Blocking Scenarios

**IF implementation blocked:**
- Unknown requirement
- Missing dependency
- Error can't resolve

**THEN:**
1. Update plan: Note blocker in task
2. Update active.yaml: current task (where stopped)
3. Return to Nexus: "Blocked on [task]: [reason]"
4. Nexus routes to appropriate specialist (Architect, Debugger, etc)

**DO NOT:**
- Skip tasks
- Mark as complete if not tested
- Continue past blocker
```

---

#### d4: Add Dev: Context size detection
**File:** `agents/frappe-dev-sidecar/instructions.md`

**Add section:** "Context Management"

```markdown
## Context Management

### Detecting Context Bloat

**Check after each task completion:**

```python
# Pseudo-code
def check_context():
    token_count = count_conversation_tokens()

    if token_count > 50000:
        return "OFFLOAD"
    else:
        return "CONTINUE"
```

### When to Check
- After completing each task
- Before loading large TSD sections
- If performance degrades

### Threshold
- **50,000 tokens** = trigger offload
- Adjust if needed based on context window limits
```

---

#### d5: Add Dev: Context offload integration
**File:** `agents/frappe-dev-sidecar/instructions.md`

**Add to "Context Management" section:**

```markdown
### Offloading Process

**When context >50k tokens:**

1. **Collect Data**
   - Completed tasks (from plan.md checked boxes)
   - Modified files list
   - Current task ID
   - Any issues encountered

2. **Execute Offload Task**
   ```
   Load: .bmad/custom/modules/frappe-builder/tasks/state/offload-context.xml
   Execute following its instructions:
     - Create context.md with table format
     - Write to state/context.md
     - Update active.yaml: context = "state/context.md"
   ```

3. **Clear Conversation History**
   - Method depends on agent framework
   - Goal: Reduce context to <10k tokens
   - Keep: active.yaml, plan.md pointer, current task

4. **Continue Execution**
   - Resume with fresh context
   - Next task loads minimal context
   - If need to recall: Load context.md (100 tokens)

### Example Context Dump

**After completing tasks d4-d6:**

```markdown
# Context: Test Project - Phase 1
Date: 2025-11-25T10:45:00Z | Agent: frappe-dev-sidecar

## Completed

| Task | Description | Status |
|------|-------------|--------|
| d4 | Validation - amount > 0 | ✓ |
| d5 | Validation - items >= 1 | ✓ |
| d6 | Calc - total from line items | ✓ |

## Files Modified
- custom_manufacturing/doctype/sales_order_custom/sales_order_custom.py
- custom_manufacturing/doctype/sales_order_custom/test_sales_order_custom.py

## Current Task
d7: Server - create delivery note

## Issues
None

---
Context cleared after this dump
```

**Tokens:** ~100 (replaces 55,000 conversation history)
```

---

#### d6: Add Dev: Update plan checkboxes
**File:** `agents/frappe-dev-sidecar/instructions.md`

**Add section:** "Updating Implementation Plan"

```markdown
## Updating Implementation Plan

### After Each Task Completion

**Update plan.md checkbox:**

```markdown
BEFORE:
- [ ] d4: Validation - amount > 0

AFTER:
- [x] d4: Validation - amount > 0
```

### Method

```python
# Pseudo-code
def update_plan_checkbox(task_id):
    plan_path = read_active_yaml()["plan"]
    plan_content = read_file(plan_path)

    # Find task line
    old_line = f"- [ ] {task_id}:"
    new_line = f"- [x] {task_id}:"

    # Replace
    updated_content = plan_content.replace(old_line, new_line)

    # Write back
    write_file(plan_path, updated_content)
```

### Verification

After update:
- Read plan.md
- Confirm checkbox changed: [ ] → [x]
- Verify no other tasks accidentally modified
```

---

#### d7: Add Dev: Return protocol
**File:** `agents/frappe-dev-sidecar/instructions.md`

**Add section:** "Returning to Nexus"

```markdown
## Returning to Nexus

### When to Return

1. **Task range complete:** All tasks in range executed and tested
2. **Blocked:** Cannot proceed due to missing info/dependency/error
3. **Phase complete:** All phase tasks done

### Return Message Format

**Success (range complete):**
```
Phase [N] dev tasks complete ([range]).

Completed:
- [task1]: [what] ✓
- [task2]: [what] ✓
- [task3]: [what] ✓

Files modified:
- [path1]
- [path2]

Tests: All passing

Ready for: [Next step - QA review, next phase, etc]
```

**Blocked:**
```
Blocked on task [id]: [description]

Issue: [Specific problem]

Need: [What's needed to unblock - Architect clarification, Debugger help, etc]

Completed so far:
- [tasks done]
```

### Update active.yaml Before Return

```yaml
# If range complete
tasks: "complete"
phase: "[Next phase or Complete]"

# If blocked
tasks: "[current task where blocked]"
# phase stays same
```

### DO NOT Return After Every Task

Only return when:
- ✓ Entire range complete
- ✓ Blocked (can't proceed)

**DO NOT return just to "check in"** - work autonomously through range
```

---

#### d8: Test 10-task scenario
**Test setup:**

Create test project with 10 dev tasks:
- Tasks d1-d10
- Assign to Dev: "d1:d10"
- Measure tokens at each stage

**Test execution:**

```
1. Fresh context: Invoke Dev with range d1:d10
2. Measure: Initial context load (should be ~360 tokens)
3. Execute: Tasks d1-d5
4. Measure: Context at d5 (should be ~30k tokens)
5. Execute: Tasks d6-d10
6. Measure: Context at d8 (should trigger offload at ~55k)
7. Verify: context.md created
8. Measure: Context after offload (should be <10k)
9. Complete: Tasks d9-d10
10. Measure: Total tokens for all 10 tasks
```

**Expected metrics:**

| Metric | Old Approach | New Approach | Target |
|--------|-------------|--------------|--------|
| Initial load | 4900 tokens | 360 tokens | <400 |
| Per task context | Full reload (4900) | Incremental (150) | <200 |
| 10-task total | 49,000 tokens | ~2,500 tokens | <3,000 |
| Context offloads | Never | 1-2 times | 1-2 |
| Round trips to Nexus | 10 | 1 | 1 |

**Pass criteria:**
- [ ] Initial load <400 tokens
- [ ] Context offload triggered when >50k
- [ ] context.md created correctly (table format, <120 tokens)
- [ ] Fresh context after offload (<10k tokens)
- [ ] All 10 tasks completed
- [ ] Total tokens <3000 (vs 49,000 old)
- [ ] 1 return to Nexus (vs 10 old)
- [ ] 90%+ token reduction achieved

---

### Phase 3 Completion Criteria

- [ ] Dev loads active.yaml for task range
- [ ] Autonomous execution loop implemented
- [ ] Context size detection working
- [ ] Context offload integrates correctly
- [ ] Plan checkboxes update after each task
- [ ] Return protocol implemented (range complete or blocked)
- [ ] 10-task test passes all metrics
- [ ] 90%+ token reduction achieved
- [ ] Agent autonomy working (1 return vs 10)

---

## Post-Implementation

### Rollout to Other Specialists

**Apply same pattern to:**
- frappe-architect-sidecar
- frappe-planner-sidecar
- frappe-debugger-sidecar
- qa-specialist-sidecar
- doc-writer-sidecar
- erpnext-ba-sidecar

**For each:**
1. Backup instructions.md
2. Add: Load active.yaml
3. Add: Task range autonomy
4. Add: Context offload
5. Add: Plan checkbox updates
6. Test: Task range scenario
7. Measure: Token savings

**Estimated:** 1-2 days per specialist (can parallelize)

---

## Metrics & Validation

### Token Efficiency Targets

| Component | Baseline | Target | Achieved |
|-----------|----------|--------|----------|
| Nexus startup | 900 | <100 | [ ] |
| Plan template | 2000 | <350 | [ ] |
| Context dump | 5000+ | <120 | [ ] |
| Dev 10 tasks | 49k | <3k | [ ] |
| Full 20-task project | 138k | <6k | [ ] |

### Success Criteria

**Functional:**
- [ ] All 3 phases complete
- [ ] All 24 tasks done
- [ ] State files working correctly
- [ ] Autonomy pattern functional
- [ ] Context offload automatic
- [ ] Archive/resume working

**Performance:**
- [ ] >90% token reduction
- [ ] >80% round-trip reduction
- [ ] Context never exceeds 60k
- [ ] Zero data loss (all info preserved)

**Quality:**
- [ ] Passes anti-fluff standards
- [ ] Passes token-efficiency standards
- [ ] Information density >0.8
- [ ] Session-independent (can resume after context loss)

---

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| active.yaml not loading | File path wrong | Check: `.bmad/custom/modules/frappe-builder/state/active.yaml` |
| Task range not parsing | Invalid format | Use: `d4:d7` (colon separator) |
| Context never offloads | Threshold not met | Lower threshold or run more tasks |
| Plan checkboxes not updating | File path wrong | Verify plan path in active.yaml |
| Archive fails | Paths don't exist | Check plan/tsd paths in active.yaml |

### Debug Checklist

If issues:
1. Verify file structure exists
2. Check active.yaml format (YAML valid?)
3. Count tokens in templates (within limits?)
4. Test state tasks independently
5. Check file paths (absolute vs relative)
6. Verify agent has write permissions

---

## Reference Links

**Standards:**
- Anti-fluff mandate: `.bmad/custom/modules/frappe-builder/standards/core/anti-fluff-mandate.md`
- Token efficiency: `.bmad/custom/modules/frappe-builder/standards/core/token-efficiency.md`

**Original research:**
- MAKER paper: https://arxiv.org/html/2511.09030v1
- Research overview: `future-plans/maker-integration/maker-method-overview.md`
- Integration strategy: `future-plans/maker-integration/final-implementation-strategy.md`

**Templates (after Phase 1):**
- active.yaml: `state/active.yaml.template`
- context.md: `state/context.md.template`
- Plan: `templates/documents/implementation-plan-efficient.md`

---

## Session Handoff Notes

**For next session (if context lost):**

1. **Check current status:**
   ```bash
   # See which phase we're in
   cat .bmad/custom/modules/frappe-builder/state/active.yaml

   # See which tasks are complete
   grep "\[x\]" [plan-path-from-active-yaml]
   ```

2. **Resume from this plan:**
   - Find current phase in this document
   - Find next unchecked task in relevant table
   - Read task details section
   - Execute task
   - Update checkbox in this plan
   - Update active.yaml if needed

3. **Don't repeat completed work:**
   - Check task status tables
   - Verify completion criteria met
   - Move to next incomplete task

---

**Plan Status:** Ready for execution
**Created:** 2025-11-25
**Last Updated:** 2025-11-25
**Token Count:** ~3500 tokens
**Format:** Tables + details (zero data loss)
**Session-Independent:** ✓ (all context included)
