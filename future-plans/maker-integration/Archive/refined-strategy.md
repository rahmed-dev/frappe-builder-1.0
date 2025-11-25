# Refined MAKER-Inspired Strategy (Token Efficient)

**Based on Rizwan's feedback - 2025-11-25**

---

## Core Principles (REVISED)

### 1. **Token Efficiency First**
- ALL documentation must be minimal and dense
- No verbose examples in production docs
- Link to references, don't duplicate content
- State files are POINTERS, not content repositories

### 2. **Respect Framework Conventions**
- Planner does NOT dictate file paths (Frappe has conventions)
- Dev agent knows Frappe structure (don't micromanage)
- Task descriptions focus on WHAT, not WHERE/HOW

### 3. **Agent Autonomy**
- Dev agent continues working on sequential tasks without bouncing to Nexus
- Only return to Nexus when switching specialist types or phase completion
- State file tracks progress, agent checks "am I done with my assignments?"

### 4. **Minimal State Files**
- current-project.yaml: ONLY current task + pointer to plan
- NO duplicating entire task lists in YAML (already in Implementation Plan)
- State file = navigation aid, not data warehouse

### 5. **Archival on Completion**
- When project completes → archive state to project-history/
- Fresh start for next project
- Old state available for reference, not loaded by default

---

## Revised File Structure

```
.bmad/custom/modules/frappe-builder/state/
├── active-project.yaml           # Current project pointer (TINY - 50 tokens)
├── context-snapshot.md           # Offloaded context when window bloats
└── archives/
    └── [project-name]/
        ├── final-state.yaml      # Archived on completion
        └── context-snapshots/    # Historical context dumps
```

---

## File 1: active-project.yaml (MINIMAL POINTER)

**Purpose**: Navigation aid - points to current work, nothing more

```yaml
# Active Project State - Minimal Navigation
# Token count target: <100 tokens

project_name: "Manufacturing Enhancements"
app: "custom_manufacturing"

# Pointers to documents (don't duplicate content!)
plan: "docs/implementation-plans/manufacturing-enhancements-plan.md"
tsd: "docs/tsd/manufacturing-enhancements-tsd.md"

# Current work cursor
current_phase: "Phase 1"
current_task_id: "phase1-dev-003"  # Reference to task in plan document
current_specialist: "frappe-dev-sidecar"

# Task range for current specialist
dev_task_range:
  start: "phase1-dev-003"
  end: "phase1-dev-008"
  # Dev works through tasks 3-8 without returning to Nexus

# Last state snapshot
context_snapshot: null  # or "state/context-snapshot.md" if context offloaded

updated: "2025-11-25T10:23:00Z"
```

**Token count**: ~80 tokens

**Key changes from previous version**:
- ❌ NO task details here (already in Implementation Plan)
- ❌ NO file paths specified (Dev knows Frappe conventions)
- ✅ Task range for specialist autonomy
- ✅ Pointer to context snapshot if offloaded

---

## File 2: context-snapshot.md (CONTEXT OFFLOAD)

**Purpose**: When context window bloats, dump conversation context here and clear window

**Created when**: Dev agent has been working for 10+ tasks, context accumulating

**Format** (token-efficient):
```markdown
# Context Snapshot: Manufacturing Enhancements - Phase 1

**Date**: 2025-11-25 10:45 AM
**Agent**: frappe-dev-sidecar
**Tasks Completed**: phase1-dev-003 through phase1-dev-007

## Summary
Implemented 5 validations for Sales Order Custom DocType. All tests passing.

## Completed Tasks
- phase1-dev-003: Amount validation ✓
- phase1-dev-004: Minimum items validation ✓
- phase1-dev-005: Credit limit check ✓
- phase1-dev-006: Stock availability validation ✓
- phase1-dev-007: Auto-calculate total ✓

## Files Modified
- custom_manufacturing/doctype/sales_order_custom/sales_order_custom.py
- custom_manufacturing/doctype/sales_order_custom/test_sales_order_custom.py

## Next Task
phase1-dev-008: Client Script - hide discount field for wholesale

## Issues/Notes
None - all validations working as expected.

---
**Context window cleared after this snapshot**
```

**Token count**: ~150 tokens (vs 5000+ tokens accumulated in conversation)

**Usage**:
- Dev agent checks: "Has context grown too large?"
- If yes: Write summary to context-snapshot.md, clear conversation history
- Continue working with fresh context
- If need to recall: Load context-snapshot.md (150 tokens vs 5000)

---

## Revised Implementation Plan Template (TOKEN EFFICIENT)

**Planner output format** (respecting Rizwan's feedback):

```markdown
# Implementation Plan: Manufacturing Enhancements

**Project**: Manufacturing Enhancements
**Created**: 2025-11-24
**App**: custom_manufacturing
**Plan**: docs/implementation-plans/manufacturing-enhancements-plan.md
**TSD**: docs/tsd/manufacturing-enhancements-tsd.md

---

## Phase 1: Foundation & Core Workflow

**Goal**: Users can create and submit Sales Orders with validations

### User Tasks (Complete First)
- [ ] u1: Create DocType "Sales Order Custom" (fields: po_reference, customer_notes, custom_line_items child table)
- [ ] u2: Add Custom Field to Customer: credit_limit (Currency)
- [ ] u3: Configure Workflow for Sales Order Custom (Draft → Pending → Approved)

**Completion signal**: DocTypes exist, visible in Desk

### Developer Tasks (After User Tasks)
- [ ] d3: Sales Order validation - amount > 0
- [ ] d4: Sales Order validation - items >= 1
- [ ] d5: Credit limit check (depends: u2)
- [ ] d6: Stock availability check
- [ ] d7: Auto-calculate total from line items
- [ ] d8: Client Script - hide discount for wholesale customers
- [ ] d9: Client Script - auto-fill customer notes from template
- [ ] d10: Server Script - auto-create delivery note on submit

**Completion signal**: All validations working, user workflow functional

### Phase 1 Completion Criteria
- [ ] User can create Sales Order from Desk
- [ ] Validations prevent invalid submissions
- [ ] Workflow routes through approval
- [ ] Tests pass for all scripts

---

## Phase 2: Extended Functionality
[Similar format - brief, token-efficient]

---

## Phase 3: Enhancements
[Similar format]

---

## Dependencies
- d5 depends on u2 (credit_limit field must exist)
- d10 after d3-d9 (core workflow must work first)

## Handoff to Dev
**Task range**: d3 through d10 (8 tasks)
**Strategy**: Dev works sequentially, updates checkboxes in THIS file
**No return to Nexus until**: All Phase 1 dev tasks complete OR blocker encountered

---
```

**Token count**: ~400 tokens for entire 3-phase plan (vs 2000+ verbose version)

**Key changes**:
- ✅ Tasks are terse descriptors (WHAT), not HOW/WHERE
- ✅ No file paths (Dev knows Frappe conventions)
- ✅ Checkboxes for tracking (Dev updates THIS doc)
- ✅ Task range specified (Dev knows their assignments)
- ✅ Dependencies explicit but brief

---

## Revised Agent Behavior: Dev Autonomy

### Old Flow (Inefficient)
```
Nexus → Dev (task d3) → completes → back to Nexus
Nexus → Dev (task d4) → completes → back to Nexus
Nexus → Dev (task d5) → completes → back to Nexus
... (8 round trips for 8 tasks!)
```

**Problem**: Constant context switching, Nexus overhead

### New Flow (MAKER-Inspired Autonomy)
```
Nexus → Dev with task range [d3:d10]
Dev loads:
  - active-project.yaml (80 tokens) → knows range d3:d10
  - Implementation Plan (400 tokens) → sees all 8 tasks
  - TSD (on-demand, sections only)

Dev executes autonomously:
  1. d3: Amount validation
     - Implement
     - Test
     - Update Plan checkbox: ✓ d3
     - Check active-project.yaml: Still in range? YES

  2. d4: Items validation
     - Implement
     - Test
     - Update Plan checkbox: ✓ d4
     - Check: Still in range? YES

  ... continues through d10 ...

  8. d10: Auto-create delivery note
     - Implement
     - Test
     - Update Plan checkbox: ✓ d10
     - Check: End of range? YES
     - Context getting large? YES (8 tasks accumulated)

  9. Offload context:
     - Write context-snapshot.md (summary of d3-d10)
     - Clear conversation history
     - Update active-project.yaml:
         current_task_id: "phase1-complete"
         context_snapshot: "state/context-snapshot.md"

  10. Return to Nexus:
     - Message: "Phase 1 dev tasks complete (d3-d10). Ready for testing."
```

**Token efficiency**:
- Load context once: 480 tokens (active-project + plan)
- No reloading for each task
- Offload context before returning: 150 tokens (snapshot)
- Total: 630 tokens for 8 tasks vs 3840 tokens (480 × 8) with old approach

**Savings**: 83% reduction

---

## Revised Workflow: Nexus Orchestration

### Nexus Startup (Token Efficient)

**New sequence**:
```
1. Load config.yaml
2. Check .bmad/custom/modules/frappe-builder/state/active-project.yaml
   - IF EXISTS:
     - Load active-project.yaml (80 tokens)
     - Read current_specialist, current_task_id
     - Greet: "Working on [project], [specialist] is on task [id]"
   - IF NOT EXISTS:
     - Ask: "Starting new project or resuming archived?"
       - New → Create active-project.yaml
       - Archived → List archives, let user choose, restore to active
3. Show status from active-project.yaml (no heavy loading)
4. Await user input
```

**Token cost**: 80 tokens vs 900 tokens (old memories.md approach)

---

## Revised Workflow: Project Completion & Archival

### When Phase 3 Completes

**Dev or QA agent**:
```
1. Update active-project.yaml:
   current_phase: "Complete"
   current_task_id: "project-complete"

2. Create final context snapshot if needed

3. Return to Nexus: "Project complete!"
```

**Nexus**:
```
1. Detect project completion (current_phase = "Complete")

2. Ask user: "Project '[name]' complete! Archive state?"
   - YES:
     a. Create archive directory:
        .bmad/custom/modules/frappe-builder/state/archives/manufacturing-enhancements/

     b. Move active-project.yaml → archives/manufacturing-enhancements/final-state.yaml

     c. Move context-snapshot.md (if exists) → archives/.../context-snapshots/

     d. Clear active-project.yaml or delete it

     e. Confirm: "Archived. Ready for next project!"

   - NO:
     - Keep active-project.yaml (user may want to add features later)

3. Next project: Create fresh active-project.yaml
```

---

## Revised Workflow: Specialist Task Execution Protocol

### General Pattern for ALL Specialists

**When Nexus routes to specialist**:
```yaml
# Nexus passes via active-project.yaml update:
current_specialist: "frappe-dev-sidecar"
task_range:
  start: "phase1-dev-003"
  end: "phase1-dev-010"
```

**Specialist startup**:
```
1. Load active-project.yaml (80 tokens)
2. Read task_range (start → end)
3. Load Implementation Plan from pointer (400 tokens)
4. Load TSD pointer (on-demand sections, ~200 tokens per task)
5. Begin execution loop:
   WHILE current_task in range:
     a. Execute task
     b. Test/validate
     c. Update Implementation Plan (check checkbox)
     d. Update active-project.yaml (current_task_id++)
     e. Check: context bloated? → offload if needed
     f. Check: still in range? → continue or exit
6. Exit loop when range complete
7. Return to Nexus with summary
```

**Context management**:
```
Every 5-10 tasks OR when context > 50k tokens:
  - Write context-snapshot.md
  - Clear conversation history
  - Continue with fresh context
```

---

## Token Efficiency Comparison

### Scenario: Dev completes 20 tasks in Phase 1 + Phase 2

#### Old Approach (No State Files, No Autonomy)
```
Nexus → Dev (task 1):
  Load: Implementation Plan (2000 tokens)
  Load: TSD (1500 tokens)
  Load: Nexus memories (900 tokens)
  Execute task 1
  Return to Nexus

Nexus → Dev (task 2):
  Load: Implementation Plan (2000 tokens)
  Load: TSD (1500 tokens)
  Load: Nexus memories (900 tokens)
  Execute task 2
  Return to Nexus

... × 20 tasks ...

Total context loading: 4400 × 20 = 88,000 tokens
Context accumulation: ~50,000 tokens (conversation history)
TOTAL: 138,000 tokens
```

#### New Approach (State Files + Autonomy + Context Offloading)
```
Nexus → Dev (task range 1-20):
  Initial load:
    - active-project.yaml (80 tokens)
    - Implementation Plan (400 tokens)
    - TSD on-demand per task (~200 tokens avg)

  Execution:
    Tasks 1-10: 480 + (200 × 10) = 2,480 tokens
    Context offload after task 10: Write snapshot, clear history

    Tasks 11-20: 480 + (200 × 10) = 2,480 tokens
    Context offload after task 20: Write snapshot, clear history

  Return to Nexus: 150 tokens (summary)

Total: 2,480 + 2,480 + 150 = 5,110 tokens

SAVINGS: 138,000 - 5,110 = 132,890 tokens (96% reduction!)
```

---

## Revised Implementation Roadmap

### Phase 1: State File Infrastructure (3 days)

**Tasks**:
1. Create `.bmad/custom/modules/frappe-builder/state/` directory
2. Create `active-project.yaml` template (minimal pointer version)
3. Create `context-snapshot.md` template
4. Create task: `tasks/state/offload-context.xml` (detect bloat, write snapshot, clear)
5. Create task: `tasks/state/archive-project.xml` (move to archives/)

**Deliverable**: State infrastructure ready

---

### Phase 2: Planner Template Enhancement (2 days)

**Tasks**:
1. Update Implementation Plan template to token-efficient format
2. Remove verbose examples, add terse task format
3. Add task range specification (d3:d10 format)
4. Add checkbox tracking (✓ d3, ✓ d4...)
5. Test: Generate 1 plan, measure token count (target: <500 tokens)

**Deliverable**: Token-efficient plan template

---

### Phase 3: Nexus State Integration (3 days)

**Tasks**:
1. Modify Nexus startup: Load active-project.yaml instead of memories.md
2. Add project archival command: `*archive`
3. Add project resume from archive: `*resume [project]`
4. Update routing: Set task_range in active-project.yaml
5. Test: Start project, route to Dev, verify autonomy

**Deliverable**: Nexus uses state files

---

### Phase 4: Dev Agent Autonomy (3 days)

**Tasks**:
1. Modify Dev agent: Read task_range from active-project.yaml
2. Implement execution loop: Work through range without returning to Nexus
3. Add context bloat detection: If context > 50k tokens → offload
4. Update Implementation Plan checkboxes as tasks complete
5. Test: Assign 10 tasks, verify Dev completes all before returning

**Deliverable**: Dev works autonomously through task ranges

---

### Phase 5: All Specialists + Full Integration (4 days)

**Tasks**:
1. Apply autonomy pattern to: Architect, Debugger, QA, Doc-Writer
2. Test full workflow: Requirements → Design → Planning → Implementation
3. Measure token usage at each phase
4. Create archival test: Complete project, archive, start new project
5. Document patterns for future specialists

**Deliverable**: Full system token-efficient with context offloading

---

## Expected Outcomes

### Token Efficiency
- **Startup context**: 900 → 80 tokens (91% reduction)
- **Task execution context**: 4400 → 680 tokens (85% reduction)
- **20-task scenario**: 138k → 5.1k tokens (96% reduction)

### Agent Autonomy
- **Old**: 20 tasks = 20 Nexus round-trips
- **New**: 20 tasks = 1 Nexus handoff, 1 return (95% reduction in context switching)

### Context Management
- **Automatic offloading**: Context never exceeds 50k tokens
- **Historical reference**: Snapshots available if needed (150 tokens to load vs 5000+ conversation replay)

---

## Answers to Rizwan's Feedback

### 1. "Documentation must be token efficient"
✅ **Addressed**:
- Implementation Plan: 2000 → 400 tokens
- active-project.yaml: 180 → 80 tokens
- No verbose examples in production docs

### 2. "Planner shouldn't dictate file paths"
✅ **Addressed**:
- Task descriptions are terse: "d3: Amount validation" (WHAT only)
- Dev agent uses Frappe conventions (knows WHERE)
- No file paths in task specs

### 3. "task-queue.yaml shouldn't duplicate plan"
✅ **Addressed**:
- Removed task-queue.yaml entirely
- active-project.yaml is minimal pointer to plan document
- Tasks tracked via checkboxes IN the Implementation Plan itself

### 4. "Dev should continue working, not return to Nexus per task"
✅ **Addressed**:
- Task range concept: Dev works through d3:d10 autonomously
- Returns only when range complete or blocker hit
- Context offloaded during execution to keep window clean

### 5. "Archive completed projects"
✅ **Addressed**:
- `state/archives/[project-name]/` structure
- Nexus offers archival on completion
- Fresh start for next project
- Old projects retrievable if needed

---

## Next Steps

**What shall we forge first, Rizwan?**

1. **Build state infrastructure** - Create directory structure + templates
2. **Prototype token-efficient plan** - Generate 1 Implementation Plan with new format
3. **Test context offloading** - Simulate Dev working through 10 tasks, measure token savings
4. **Review specific workflow** - Pick 1 workflow to integrate first

**Your command?** ⚔️
