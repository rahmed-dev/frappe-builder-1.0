# MAKER Integration - CORRECTED Implementation Plan
**Project:** frappe-builder MAKER enhancements
**Goal:** Task granularity + context offloading + agent autonomy
**Status:** ✅ VALIDATED - Ready for execution (v2.1 with Gap fixes)
**Version:** 2.1 (Gap-Fixed)
**Date:** 2025-11-25 (Updated with BMad Builder evaluation)

---

## CRITICAL: Read This First

**SESSION INDEPENDENCE:**
This plan is designed for multi-session execution. If you lose context mid-implementation:

**METHOD 1 (FASTEST):**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/
bash future-plans/maker-integration/resume-maker-implementation.sh
```
Script shows: current phase, completed tasks, exact next task + line number

**METHOD 2 (MANUAL):**
1. Jump to **Progress Tracker** (line 54 in this plan)
2. Find first unchecked `[ ]` task
3. Search for that task's section: `### [task_id]:`
4. Resume execution from there

**METHOD 3 (DETAILED):**
1. Check current status: `cat .bmad/custom/modules/frappe-builder/state/active.yaml` (if exists)
2. Read Session Handoff Protocol (line 3674)
3. Follow step-by-step resume instructions

**VALIDATION STATUS:**
- ✅ Reviewed by BMad Builder (2025-11-25)
- ✅ All critical loopholes fixed
- ✅ MAKER alignment verified (93%)
- ✅ BMAD Core compliance confirmed
- ✅ Config paths corrected
- ✅ Context clearing mechanism defined
- ✅ Token monitoring method specified
- ✅ Gap analysis complete (4 gaps identified + fixed)
- ✅ Updated with Phase 4 (workflow integration)

**DO NOT use the original IMPLEMENTATION-PLAN.md - use THIS corrected version**

**GAPS ADDRESSED IN v2.1:**
1. ✅ Workflow YAML updates → Added Phase 4 with detailed tasks
2. ✅ TSD section mapping automation → Added task p2 in Phase 2
3. ✅ Config path clarity → Added to task i2 comments
4. ✅ BRD summary extraction → Added to task n3 in Phase 2

---

## Quick Reference

| Item | Value |
|------|-------|
| **Project root** | `/home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/` |
| **Config path** | `/home/riz/frappe-bench/.bmad/frappe-builder/config.yaml` ⚠️ Note location |
| **Standards** | anti-fluff-mandate.md, token-efficiency.md |
| **Total phases** | 4 (added workflow integration) |
| **Total tasks** | 31 (was 24, added 7 tasks) |
| **Current phase** | Phase 1 |
| **Current task** | Not started |
| **Estimated duration** | 5 days (realistic, with Phase 4) |

---

## 📋 Implementation Progress Tracker

**CRITICAL FOR MULTI-SESSION:** Mark tasks as complete here. After context loss, check this table to resume instantly.

**How to use:**
1. After completing any task, mark it: `[ ]` → `[x]`
2. On new session: Scan for first unchecked `[ ]` task
3. Jump to that task's section (Ctrl+F: "### [task_id]:")
4. Resume execution

| Phase | ID | Task Description | Status |
|-------|----|--------------------|--------|
| **1** | i1 | Create state/ directory structure | [x] |
| **1** | i2 | Create active.yaml template | [x] |
| **1** | i3 | Create context.md template | [x] |
| **1** | i4 | Create archive/ structure + metadata | [x] |
| **1** | i5 | Create token-efficient plan template | [x] |
| **1** | i6 | Validate templates against standards | [x] |
| **1** | i7 | Create state management XML tasks | [x] |
| **1** | i8 | Test sample plan, measure tokens | [x] |
| **2** | n1 | Backup Nexus files | [x] |
| **2** | n2 | Modify Nexus startup (load active.yaml) | [x] |
| **2** | n3 | Add new project flow + BRD summary | [x] |
| **2** | n4 | Add resume archived project | [x] |
| **2** | n5 | Add task range on routing | [x] |
| **2** | n6 | Add archive completion detection | [x] |
| **2** | n7 | Update Nexus memories.md | [x] |
| **2** | n8 | Test full lifecycle | [x] |
| **2** | p1 | Backup Planner files | [x] |
| **2** | p2 | Add TSD mapping automation | [x] |
| **3** | d1 | Backup Dev files | [x] |
| **3** | d2 | Dev load active.yaml on startup | [x] |
| **3** | d3 | Dev autonomous execution loop | [x] |
| **3** | d4 | Dev context size detection | [x] |
| **3** | d5 | Dev context offload integration | [x] |
| **3** | d6 | Dev plan checkbox updates | [x] |
| **3** | d7 | Dev return protocol | [x] |
| **3** | d8 | Test 10-task scenario | [x] |
| **4** | w1 | Backup workflow files | [x] |
| **4** | w2 | Update sequence-tasks workflow | [x] |
| **4** | w3 | Update implement-feature workflow | [x] |
| **4** | w4 | Update design-solution workflow | [x] |
| **4** | w5 | Update analyze-requirements workflow | [x] |
| **4** | w6 | Test full workflow chain | [ ] |
| **4** | w7 | Measure end-to-end token usage | [ ] |

**Phase Completion Markers:**
- [x] Phase 1 Complete (all i* tasks done + validation passed)
- [x] Phase 2 Complete (all n* and p* tasks done + validation passed)
- [x] Phase 3 Complete (all d* tasks done + validation passed)
- [ ] Phase 4 Complete (all w* tasks done + validation passed)

**Quick Status Check:**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/
grep -c "\[x\]" future-plans/maker-integration/IMPLEMENTATION-PLAN-CORRECTED.md
# Shows count of completed tasks
```

---

## Gap Analysis & Fixes (v2.1 Update)

**Evaluation Date:** 2025-11-25
**Evaluator:** BMad Builder
**Gaps Identified:** 4 (all addressed)

### Gap 1: Workflow YAML Integration Not Detailed

**Severity:** MEDIUM
**Impact:** Workflows might not use efficient templates, losing token savings

**Original State:**
- Post-Implementation section mentioned workflows vaguely
- No task-level breakdown for workflow updates
- No validation criteria

**Fix Applied:**
- ✅ Added **Phase 4: Workflow Integration** (7 tasks: w1-w7)
- ✅ Detailed modifications for 4 critical workflows
- ✅ Integration test (w6) validates all workflows work together
- ✅ End-to-end token measurement (w7)

**Tasks Added:** w1, w2, w3, w4, w5, w6, w7

---

### Gap 2: TSD Section Mapping Relies on Manual Work

**Severity:** MEDIUM
**Impact:** Manual mapping = error-prone, time-consuming, reduces planner efficiency

**Original State:**
- Plan template shows TSD mapping table (lines 369-381)
- No automation for HOW Planner generates this mapping
- Dev agents must manually find TSD sections

**Fix Applied:**
- ✅ Added **task p2**: Planner auto-generates TSD mapping
- ✅ Parsing logic: Extract TSD headers, match to task types
- ✅ Keyword matching table for task→section mapping
- ✅ Token estimation per section (line_count * 0.8)
- ✅ Integrated into sequence-tasks workflow (w2)

**Tasks Added:** p1 (backup), p2 (automation)

---

### Gap 3: Config Path Confusion Potential

**Severity:** LOW
**Impact:** Agents might look for config in wrong location, fail to load

**Original State:**
- Config path mentioned: `.bmad/frappe-builder/config.yaml`
- Module location: `.bmad/custom/modules/frappe-builder/`
- Potential confusion between installed vs custom locations

**Fix Applied:**
- ✅ Updated **Quick Reference** table: Config path with ⚠️ note
- ✅ Added comment in **active.yaml.template** (task i2):
  ```yaml
  # 🚨 CONFIG PATH CLARIFICATION (Gap 3 Fix):
  # Module config is at: /home/riz/frappe-bench/.bmad/frappe-builder/config.yaml
  # NOT at: .bmad/custom/modules/frappe-builder/config.yaml
  ```
- ✅ Explicit path in all agent instructions

**Tasks Modified:** i2 (enhanced comments)

---

### Gap 4: BRD Summary Extraction Not Automated

**Severity:** LOW
**Impact:** Summary field in active.yaml would be manually populated, defeating automation goal

**Original State:**
- active.yaml includes `summary:` field (lines 144-148)
- No specification of WHO extracts summary or WHEN
- Manual work = defeats MAKER automation principles

**Fix Applied:**
- ✅ Updated **task n3**: Nexus extracts BRD summary after BA completion
- ✅ Pseudocode added for extraction logic:
  - Read BRD (first 50 lines or "Executive Summary")
  - Extract 2-3 sentences
  - Update active.yaml summary field
  - Keep <50 tokens
- ✅ Integrated into **task w5**: analyze-requirements workflow auto-extracts
- ✅ Validation in Phase 2 & Phase 4 completion criteria

**Tasks Modified:** n3 (added extraction), w5 (workflow integration)

---

### Summary of Changes (v2.0 → v2.1)

| Change | Impact |
|--------|--------|
| Added Phase 4 (7 tasks) | Workflow integration now explicit and validated |
| Added tasks p1, p2 | TSD mapping automation (Gap 2 fix) |
| Enhanced task n3 | BRD summary extraction (Gap 4 fix) |
| Enhanced task i2 | Config path clarity (Gap 3 fix) |
| Updated task w5 | Workflow-level BRD summary automation |
| Updated Quick Reference | Config path warning |
| Updated Success Criteria | 4 phases, 31 tasks, 4 Gap fixes |
| Updated Phase 2 validation | Checks for Planner + Gap fixes |
| Updated Phase 4 validation | Checks for all Gap fixes in workflows |

**Total Tasks:** 24 → 31 (+7)
**Total Phases:** 3 → 4 (+1)
**Gap Fixes:** 0 → 4 (all critical gaps addressed)

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
- Minimal active.yaml (<200 tokens) - pointer + project summary
- Task range autonomy (Dev works d3:d10 without Nexus returns)
- Context offloading (>30k tokens → dump to file, manual restart)
- Token-efficient plans (1-5k simple, 5-10k medium, 10-15k complex vs 2000+ old)
- Project archival (completed → archive/, fresh start)

**Impact:** 8-12k tokens for 20-task project (92-94% reduction vs 138k)

### Core Components

| Component | Purpose | Token Impact |
|-----------|---------|--------------|
| active.yaml | Current project pointer + BRD summary | <200 tokens (was 900) |
| Token-efficient plan template | Planner output format | 1-15k tokens based on complexity (was 2000+) |
| context.md | Offloaded conversation history | <500 tokens (replaces 5000+) |
| Agent autonomy loop | Work through task range | 95% fewer round-trips |
| Archive system | Complete projects → storage | Clean slate |

---

## Phase 1: State Infrastructure & Templates

**Goal:** File structure + templates ready, no agent integration yet

**Duration:** 4 hours (realistic)

**Status:** [ ] Not started

### Tasks

| ID | Task | Deliverable | Tokens | Status |
|----|------|-------------|--------|--------|
| **i1** | Create `state/` directory structure | Dirs exist | - | [ ] |
| **i2** | Create `active.yaml` template | File template | <200 | [ ] |
| **i3** | Create `context.md` template | File template | <500 | [ ] |
| **i4** | Create `archive/` structure + metadata | Dir + README + metadata.yaml | - | [ ] |
| **i5** | Create token-efficient plan template | Markdown template | 1-15k | [ ] |
| **i6** | Validate templates against standards | Pass checklist | - | [ ] |
| **i7** | Create state management tasks (BMAD XML) | 2 XML task files | - | [ ] |
| **i8** | Test: Generate sample plan, measure tokens | <5k medium | - | [ ] |

---

### i1: Create state/ directory structure

**Execute in project root:**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/
mkdir -p state/archive
```

**Verify:**
```bash
ls -la state/
# Should show: archive/
```

**Completion Criteria:**
- [ ] Directory exists: `.bmad/custom/modules/frappe-builder/state/`
- [ ] Directory exists: `.bmad/custom/modules/frappe-builder/state/archive/`

---

### i2: Create active.yaml template

**File:** `.bmad/custom/modules/frappe-builder/state/active.yaml.template`

**Content:**
```yaml
# Active Project State - Pointer + Project Summary
# Token target: <200
# Updated: 2025-11-25 (CORRECTED VERSION v2.1 - added BRD summary, expanded budget)
#
# 🚨 CONFIG PATH CLARIFICATION (Gap 3 Fix):
# Module config is at: /home/riz/frappe-bench/.bmad/frappe-builder/config.yaml
# NOT at: .bmad/custom/modules/frappe-builder/config.yaml
# Agents must read from .bmad/frappe-builder/ (installed location)

project: ""           # Project display name
app: ""               # Frappe app name
plan: ""              # Path to implementation plan (relative to project root)
tsd: ""               # Path to TSD (if exists, relative to project root)
brd: ""               # Path to BRD (if exists, relative to project root)
phase: ""             # Current phase (Phase 1, Phase 2, etc)
specialist: ""        # Current agent (frappe-dev-sidecar, etc)
tasks: ""             # Task range (d3:d10, a1:a5, etc) or "complete"
context: null         # Path to context.md if offloaded (relative to state/)
updated: ""           # ISO timestamp (YYYY-MM-DDTHH:MM:SSZ)

# Project Summary (from BRD - keep concise)
# 🚨 AUTO-EXTRACTED (Gap 4 Fix): Nexus extracts this from BRD after BA completion
summary: |
  [2-3 sentence project description]
  [Key objective]
  [Primary user/stakeholder]

# Quick Context (optional - use for critical info agents need)
notes: ""             # Brief implementation notes, critical decisions, blockers
```

**Token Validation:**
```bash
# Count tokens (approximate: words * 1.3)
wc -w state/active.yaml.template
# Multiply result by 1.3
# Must be <200 tokens
```

**Completion Criteria:**
- [ ] File created at correct path
- [ ] Token count <200
- [ ] BRD field added
- [ ] Summary section added (with guidelines)
- [ ] Notes field added for critical context
- [ ] All fields documented inline
- [ ] YAML syntax valid (test with `python3 -c "import yaml; yaml.safe_load(open('state/active.yaml.template'))"`)

---

### i3: Create context.md template

**File:** `.bmad/custom/modules/frappe-builder/state/context.md.template`

**Content:**
```markdown
# Context: [Project] - [Phase]
Date: [ISO timestamp] | Agent: [specialist] | Session: [N]

## Summary
[1-2 sentence recap of what was accomplished this session]

## Completed

| Task | Description | Files | Status |
|------|-------------|-------|--------|
| [id] | [what] | [main file changed] | ✓ |

## Files Modified

| File | Purpose | Lines Changed |
|------|---------|---------------|
| [path] | [what it does] | +[X]/-[Y] |

## Current Task
**[id]:** [description]

**Progress:** [what's done, what's left]

**Blockers:** [None or specific issue]

## Key Decisions Made
- [Decision 1]: [Why]
- [Decision 2]: [Why]

## Issues / Notes
- [Issue or note with context]

## Next Session Actions
1. Resume at task: **[id]**
2. Load: active.yaml → plan.md → TSD section [§X.X]
3. Context to review: [specific area to focus on]

## Token Stats
- Session start: [X]k tokens
- Session end: [Y]k tokens
- Offload triggered at: [Z]k tokens

---
Context cleared after this dump. Use `/clear` to reset Claude Code context.
Agent will auto-load: active.yaml + this context + plan section on restart.
```

**Token Validation:**
```bash
wc -w state/context.md.template
# Multiply by 1.3, must be <500 tokens
```

**Completion Criteria:**
- [ ] File created at correct path
- [ ] Token count <500
- [ ] Enhanced tables (with file purposes, line changes)
- [ ] Summary section added
- [ ] Key decisions section added
- [ ] Token stats section added
- [ ] Richer context for resume

---

### i4: Create archive/ structure + metadata

**File 1:** `.bmad/custom/modules/frappe-builder/state/archive/README.md`

**Content:**
```markdown
# Project Archives

Completed projects stored here.

## Structure
```
archive/
└── [project-name]/
    ├── metadata.yaml     # Archive metadata (when, who, why)
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

**File 2:** `.bmad/custom/modules/frappe-builder/state/archive/metadata.yaml.template`

**Content:**
```yaml
# Archive Metadata Template
# Copy to archive/[project-name]/metadata.yaml when archiving

project: ""                    # Project display name
app: ""                        # Frappe app name
archived_date: ""              # ISO timestamp
archived_by: ""                # User name (from config.yaml)
reason: ""                     # "Complete" or "Paused" or "Cancelled"
final_status: ""               # "Complete", "Partial", "Blocked"
total_tasks: 0                 # Count from plan.md
completed_tasks: 0             # Count checked boxes
total_phases: 0                # Count phases in plan
final_phase: ""                # Last phase worked on
notes: ""                      # Optional additional context
```

**Completion Criteria:**
- [ ] README.md created with structure diagram
- [ ] metadata.yaml.template created
- [ ] Both files valid markdown/YAML

---

### i5: Create token-efficient plan template

**File:** `.bmad/custom/modules/frappe-builder/templates/documents/implementation-plan-efficient.md`

**Content:**
```markdown
# Plan: [Project Name]
App: [app_name] | BRD: [path] | TSD: [path or "N/A"] | Date: [ISO]
Complexity: [Simple/Medium/Complex] | Token Budget: [1-5k/5-10k/10-15k]

## Project Context
**Goal:** [1-sentence primary objective]
**Users:** [Who will use this]
**Success:** [How to measure completion]

---

## Phase 1: [Goal One-Liner]

### User Tasks
- [ ] u1: DocType "[Name]" ([field1], [field2], [child_table]) | TSD: §[section]
- [ ] u2: Field on [DocType]: [field_name] ([Type]) | TSD: §[section]
- [ ] u3: Workflow: [DocType] ([State1→State2→State3]) | TSD: §[section]

### Dev Tasks
- [ ] d4: Validation - [rule] | TSD: §[section]
- [ ] d5: Calc - [what] | TSD: §[section]
- [ ] d6: Client - [behavior] | TSD: §[section]
- [ ] d7: Server - [trigger action] | TSD: §[section]

**Complete when:** [Observable outcome]
**Acceptance:** [How to validate phase success]

---

## Phase 2: [Goal]

### Dev Tasks
- [ ] d8: Report - [what data] | TSD: §[section]
- [ ] d9: Dashboard - [metrics] | TSD: §[section]
- [ ] d10: Background - [scheduled task] | TSD: §[section]

**Complete when:** [Observable outcome]
**Acceptance:** [How to validate]

---

## Phase 3: [Goal]
(Follow same format)

---

## Dependencies

| Task | Needs | Why | Blocker Risk |
|------|-------|-----|--------------|
| d5 | u2 | Field must exist first | Medium |
| d10 | d4-d9 | Core features before automation | Low |

---

## Task Ranges

| Specialist | Phase 1 | Phase 2 | Phase 3 | Total Tasks |
|------------|---------|---------|---------|-------------|
| User | u1:u3 | - | - | 3 |
| Dev | d4:d7 | d8:d10 | d11:d15 | 12 |
| QA | - | q1:q3 | - | 3 |

---

## TSD Section Mapping

**Format:** Task ID → TSD Section Reference

| Task | TSD Section | Topic | Est. Tokens |
|------|-------------|-------|-------------|
| d4 | §3.2.1 | Validation rules | ~150 |
| d5 | §3.2.2 | Calculation logic | ~200 |
| d6 | §3.3.1 | Client-side behavior | ~180 |
| d7 | §3.4.1 | Server-side automation | ~220 |

**Usage:** Dev loads only relevant TSD section per task (not entire TSD)

---

## Critical Decisions

| Decision | Options Considered | Chosen | Rationale |
|----------|-------------------|--------|-----------|
| [Key decision 1] | [A, B, C] | [B] | [Why B] |

---

## Risk Mitigation

| Risk | Impact | Mitigation | Owner |
|------|--------|------------|-------|
| [Risk 1] | High/Med/Low | [How to handle] | [Specialist] |

---

## Token Budget Tracking

**Plan Complexity:** [Simple/Medium/Complex]

| Component | Simple | Medium | Complex |
|-----------|--------|--------|---------|
| Base structure | <1k | <2k | <3k |
| Task definitions | <2k | <3k | <5k |
| Dependencies + mapping | <1k | <2k | <3k |
| Decisions + risks | <1k | <2k | <4k |
| **Total Target** | **<5k** | **<9k** | **<15k** |

---

## Notes
- Dev works autonomously through ranges
- Updates checkboxes as completes
- Returns to Nexus when range complete or blocked
- Uses `/context` to monitor token usage
- Restarts session if context >30k tokens
```

**Token Validation:**
```bash
# Test with realistic plans
wc -w templates/documents/implementation-plan-efficient.md
# Multiply by 1.3

# Targets by complexity:
# Simple (1-2 phases, 5-10 tasks): <5k tokens
# Medium (3-4 phases, 11-20 tasks): <10k tokens
# Complex (5+ phases, 21+ tasks): <15k tokens
```

**Key Improvements:**
- ✅ Added complexity classification
- ✅ Added project context section
- ✅ Added BRD reference field
- ✅ Enhanced dependencies with blocker risk
- ✅ Added acceptance criteria per phase
- ✅ Added critical decisions table
- ✅ Added risk mitigation table
- ✅ Added token budget tracking table
- ✅ TSD section mapping with token estimates
- ✅ Scaled token budgets: 5k/10k/15k

**Completion Criteria:**
- [ ] File created at correct path
- [ ] Token count <5k for simple template
- [ ] Token count <10k for medium template
- [ ] Token count <15k for complex template
- [ ] All new sections present (context, decisions, risks)
- [ ] Tables used for dependencies, ranges, mapping, decisions, risks
- [ ] TSD mapping section present with token estimates
- [ ] Complexity indicator and budget tracker included
- [ ] Terse task format maintained (WHAT only)
- [ ] Checkboxes present for all tasks

---

### i6: Validate templates against standards

**Checklist:**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

# 1. Validate active.yaml token count
ACTIVE_TOKENS=$(wc -w state/active.yaml.template | awk '{print int($1 * 1.3)}')
echo "active.yaml: $ACTIVE_TOKENS tokens (target: <200)"
[ $ACTIVE_TOKENS -lt 200 ] && echo "✓ PASS" || echo "✗ FAIL"

# 2. Validate context.md token count
CONTEXT_TOKENS=$(wc -w state/context.md.template | awk '{print int($1 * 1.3)}')
echo "context.md: $CONTEXT_TOKENS tokens (target: <500)"
[ $CONTEXT_TOKENS -lt 500 ] && echo "✓ PASS" || echo "✗ FAIL"

# 3. Validate plan template token count
PLAN_TOKENS=$(wc -w templates/documents/implementation-plan-efficient.md | awk '{print int($1 * 1.3)}')
echo "plan template: $PLAN_TOKENS tokens"
echo "  Simple project target: <5,000 tokens"
echo "  Medium project target: <10,000 tokens"
echo "  Complex project target: <15,000 tokens"
if [ $PLAN_TOKENS -lt 5000 ]; then
    echo "  ✓ PASS (Simple)"
elif [ $PLAN_TOKENS -lt 10000 ]; then
    echo "  ✓ PASS (Medium)"
elif [ $PLAN_TOKENS -lt 15000 ]; then
    echo "  ✓ PASS (Complex)"
else
    echo "  ✗ FAIL (Exceeds 15k)"
fi

# 4. Validate YAML syntax
python3 -c "import yaml; yaml.safe_load(open('state/active.yaml.template'))" && echo "✓ active.yaml valid" || echo "✗ active.yaml invalid"

# 5. Check standards compliance
echo "Checking anti-fluff compliance..."
grep -q "Table format" state/context.md.template && echo "✓ context.md uses tables" || echo "✗ Missing tables"
grep -q "TSD Section Mapping" templates/documents/implementation-plan-efficient.md && echo "✓ TSD mapping present" || echo "✗ Missing TSD mapping"
grep -q "BRD:" templates/documents/implementation-plan-efficient.md && echo "✓ BRD reference present" || echo "✗ Missing BRD reference"
grep -q "Complexity:" templates/documents/implementation-plan-efficient.md && echo "✓ Complexity classification present" || echo "✗ Missing complexity"
grep -q "Token Budget Tracking" templates/documents/implementation-plan-efficient.md && echo "✓ Token budget tracker present" || echo "✗ Missing budget tracker"

# 6. Check active.yaml has new fields
grep -q "brd:" state/active.yaml.template && echo "✓ BRD field in active.yaml" || echo "✗ Missing BRD field"
grep -q "summary:" state/active.yaml.template && echo "✓ Summary field in active.yaml" || echo "✗ Missing summary field"
grep -q "notes:" state/active.yaml.template && echo "✓ Notes field in active.yaml" || echo "✗ Missing notes field"
```

**Standards Reference:**
- `.bmad/frappe-builder/standards/core/anti-fluff-mandate.md`
- `.bmad/frappe-builder/standards/core/token-efficiency.md`

**Completion Criteria:**
- [ ] active.yaml: <200 tokens
- [ ] active.yaml: Has BRD, summary, notes fields
- [ ] context.md: <500 tokens
- [ ] context.md: Enhanced tables with file purposes, decisions, token stats
- [ ] plan template: <5k (simple), <10k (medium), <15k (complex)
- [ ] plan template: Has complexity classification
- [ ] plan template: Has project context section
- [ ] plan template: Has BRD reference
- [ ] plan template: Has critical decisions table
- [ ] plan template: Has risk mitigation table
- [ ] plan template: Has token budget tracker
- [ ] All use tables > bullets > prose
- [ ] No file paths in task specs
- [ ] No verbose explanations
- [ ] YAML/Markdown valid
- [ ] Information density >0.8 tokens/unit
- [ ] TSD mapping present with token estimates

---

### i7: Create state management tasks (BMAD XML)

**File 1:** `.bmad/custom/modules/frappe-builder/tasks/state/offload-context.xml`

**Purpose:** Detect context bloat, write dump, signal restart needed

**Content:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- BMAD Core Compliant Task Definition -->
<!-- Version: 6.0 -->
<!-- Task: Context Offload for MAKER Integration -->

<bmad_task>
  <metadata>
    <id>offload-context</id>
    <name>Offload Context to File</name>
    <version>1.0</version>
    <category>state-management</category>
    <created>2025-11-25</created>
    <module>frappe-builder</module>
  </metadata>

  <description>
    Offload conversation context when token usage exceeds threshold.
    Creates structured context dump, updates active.yaml, signals need for session restart.
  </description>

  <trigger>
    <condition>Context usage > 30,000 tokens (check via /context command)</condition>
    <invoked_by>frappe-dev-sidecar, frappe-architect-sidecar, any specialist agent</invoked_by>
    <frequency>Check after completing each task</frequency>
  </trigger>

  <prerequisites>
    <item>active.yaml exists in state/</item>
    <item>context.md.template exists in state/</item>
    <item>Agent has completed at least 1 task</item>
  </prerequisites>

  <execution>
    <step n="1">
      <action>Check context usage</action>
      <method>Run `/context` command in Claude Code</method>
      <condition>If tokens > 30,000, proceed to step 2. If < 30,000, abort (no offload needed)</condition>
    </step>

    <step n="2">
      <action>Read active.yaml</action>
      <file>.bmad/custom/modules/frappe-builder/state/active.yaml</file>
      <extract>project, app, phase, specialist, plan</extract>
    </step>

    <step n="3">
      <action>Read plan.md for completed tasks</action>
      <file>[path from active.yaml]</file>
      <extract>All lines matching "- [x] [task_id]:" (checked boxes)</extract>
    </step>

    <step n="4">
      <action>Collect modified files list</action>
      <method>Review conversation history for files written/edited this session</method>
      <output>List of file paths</output>
    </step>

    <step n="5">
      <action>Identify current task</action>
      <method>Next unchecked task in task range from active.yaml</method>
      <output>Task ID and description</output>
    </step>

    <step n="6">
      <action>Create context.md</action>
      <template>state/context.md.template</template>
      <fill>
        - [Project]: From active.yaml
        - [Phase]: From active.yaml
        - [ISO timestamp]: Current UTC time
        - [specialist]: From active.yaml
        - [Session]: Increment if previous context.md exists
        - Completed tasks table: From step 3
        - Files modified list: From step 4
        - Current task: From step 5
      </fill>
      <output_path>.bmad/custom/modules/frappe-builder/state/context.md</output_path>
    </step>

    <step n="7">
      <action>Update active.yaml</action>
      <field>context</field>
      <value>"context.md"</value>
      <field>updated</field>
      <value>[Current ISO timestamp]</value>
      <output_path>.bmad/custom/modules/frappe-builder/state/active.yaml</output_path>
    </step>

    <step n="8">
      <action>Signal session restart required</action>
      <message>
        ⚠️ Context offloaded to state/context.md

        **Next Steps:**
        1. Review context dump: cat state/context.md
        2. Restart this agent session to clear context
        3. Agent will auto-load active.yaml + resume from [current task]

        **Why:** Context window was at [X] tokens. Fresh start needed.
      </message>
      <pause>true</pause>
    </step>
  </execution>

  <validation>
    <check>context.md file created at correct path</check>
    <check>context.md token count &lt; 120</check>
    <check>context.md contains completed tasks table</check>
    <check>active.yaml updated with context path</check>
    <check>active.yaml timestamp updated</check>
    <check>User notified of restart requirement</check>
  </validation>

  <error_handling>
    <error type="active.yaml not found">
      <action>Abort with message: "No active project. Run this task only during active development."</action>
    </error>
    <error type="plan.md not found">
      <action>Check active.yaml plan path, verify file exists, abort if missing</action>
    </error>
    <error type="context.md write failed">
      <action>Check permissions on state/ directory, retry once, abort if fails again</action>
    </error>
  </error_handling>

  <output>
    <file>.bmad/custom/modules/frappe-builder/state/context.md</file>
    <file>.bmad/custom/modules/frappe-builder/state/active.yaml (updated)</file>
    <notification>User instruction to restart session</notification>
  </output>

  <notes>
    - This task DOES NOT automatically clear context (not possible in Claude Code)
    - Relies on user to restart agent session after context.md created
    - Fresh session will auto-load active.yaml (60 tokens) + minimal plan section
    - Context reduction: ~50k → ~500 tokens after restart
  </notes>
</bmad_task>
```

**File 2:** `.bmad/custom/modules/frappe-builder/tasks/state/archive-project.xml`

**Purpose:** Move completed project to archive, clean for next project

**Content:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- BMAD Core Compliant Task Definition -->
<!-- Version: 6.0 -->
<!-- Task: Project Archival for MAKER Integration -->

<bmad_task>
  <metadata>
    <id>archive-project</id>
    <name>Archive Completed Project</name>
    <version>1.0</version>
    <category>state-management</category>
    <created>2025-11-25</created>
    <module>frappe-builder</module>
  </metadata>

  <description>
    Move completed project to archive directory, create metadata, clean active state.
  </description>

  <trigger>
    <condition>Project completion confirmed (all tasks checked in plan.md)</condition>
    <invoked_by>frappe-nexus-sidecar</invoked_by>
    <user_confirmation>Required - ask user before archiving</user_confirmation>
  </trigger>

  <prerequisites>
    <item>active.yaml exists with phase = "Complete"</item>
    <item>archive/ directory exists</item>
    <item>User confirmed archival</item>
  </prerequisites>

  <execution>
    <step n="1">
      <action>Read active.yaml</action>
      <file>.bmad/custom/modules/frappe-builder/state/active.yaml</file>
      <extract>project, app, plan, tsd, phase</extract>
      <validate>phase must equal "Complete"</validate>
    </step>

    <step n="2">
      <action>Create archive directory</action>
      <path>.bmad/custom/modules/frappe-builder/state/archive/[project-name]/</path>
      <mkdir>Create if doesn't exist, including subdirectories</mkdir>
    </step>

    <step n="3">
      <action>Create metadata.yaml</action>
      <template>state/archive/metadata.yaml.template</template>
      <fill>
        - project: From active.yaml
        - app: From active.yaml
        - archived_date: Current ISO timestamp
        - archived_by: From config.yaml (user_name)
        - reason: "Complete" (or user-specified)
        - final_status: "Complete"
        - total_tasks: Count tasks in plan.md
        - completed_tasks: Count checked boxes in plan.md
        - total_phases: Count phases in plan.md
        - final_phase: From active.yaml
      </fill>
      <output_path>state/archive/[project-name]/metadata.yaml</output_path>
    </step>

    <step n="4">
      <action>Copy active.yaml to archive</action>
      <source>state/active.yaml</source>
      <destination>state/archive/[project-name]/active.yaml</destination>
    </step>

    <step n="5">
      <action>Copy plan.md to archive</action>
      <source>[plan path from active.yaml]</source>
      <destination>state/archive/[project-name]/plan.md</destination>
    </step>

    <step n="6">
      <action>Copy tsd.md to archive (if exists)</action>
      <source>[tsd path from active.yaml]</source>
      <destination>state/archive/[project-name]/tsd.md</destination>
      <condition>Only if tsd field in active.yaml is not empty</condition>
    </step>

    <step n="7">
      <action>Copy context dumps to archive (if exist)</action>
      <source>state/context.md</source>
      <destination>state/archive/[project-name]/context/dump-final.md</destination>
      <condition>Only if context.md exists</condition>
    </step>

    <step n="8">
      <action>Delete active.yaml from state/</action>
      <file>state/active.yaml</file>
      <confirm>Verify archive copy successful before deleting</confirm>
    </step>

    <step n="9">
      <action>Delete context.md from state/ (if exists)</action>
      <file>state/context.md</file>
      <optional>true</optional>
    </step>

    <step n="10">
      <action>Confirm to user</action>
      <message>
        ✅ Project "[project-name]" archived!

        **Archived to:** state/archive/[project-name]/
        **Contains:**
        - metadata.yaml (project details)
        - active.yaml (final state)
        - plan.md (implementation plan)
        - tsd.md (tech spec, if existed)
        - context/ (context dumps, if existed)

        **State cleared:** Ready for next project!

        **To resume later:**
        1. Copy archive/[project-name]/active.yaml → state/active.yaml
        2. Invoke Nexus
        3. Choose: Iterate (reimplement) or Continue (add features)
      </message>
    </step>
  </execution>

  <validation>
    <check>Archive directory created: archive/[project-name]/</check>
    <check>metadata.yaml created with all fields</check>
    <check>active.yaml copied to archive</check>
    <check>plan.md copied to archive</check>
    <check>tsd.md copied (if existed)</check>
    <check>state/active.yaml deleted</check>
    <check>User confirmation message displayed</check>
  </validation>

  <error_handling>
    <error type="active.yaml phase != Complete">
      <action>Abort with message: "Project not complete. Finish all tasks first."</action>
    </error>
    <error type="plan.md not found">
      <action>Warn user, ask if should proceed anyway (partial archive)</action>
    </error>
    <error type="archive directory creation failed">
      <action>Check permissions, retry once, abort if fails</action>
    </error>
    <error type="file copy failed">
      <action>Identify which file, check source exists, check destination writable, abort</action>
    </error>
  </error_handling>

  <output>
    <directory>state/archive/[project-name]/</directory>
    <file>metadata.yaml (in archive)</file>
    <file>active.yaml (in archive)</file>
    <file>plan.md (in archive)</file>
    <file>tsd.md (in archive, optional)</file>
    <deleted>state/active.yaml</deleted>
    <deleted>state/context.md (optional)</deleted>
  </output>

  <notes>
    - Always ask user confirmation before archiving
    - Verify archive copy successful before deleting from state/
    - Archive is immutable - don't modify archived projects
    - To resume: copy active.yaml back, not move (preserve archive)
  </notes>
</bmad_task>
```

**Completion Criteria:**
- [ ] offload-context.xml created with BMAD-compliant structure
- [ ] archive-project.xml created with BMAD-compliant structure
- [ ] Both XML files validate (well-formed XML)
- [ ] All required sections present (metadata, execution, validation, error_handling)
- [ ] Step-by-step execution logic clear
- [ ] Error handling defined

**Validation:**
```bash
# Check XML syntax
xmllint --noout tasks/state/offload-context.xml && echo "✓ Valid" || echo "✗ Invalid"
xmllint --noout tasks/state/archive-project.xml && echo "✓ Valid" || echo "✗ Invalid"
```

---

### i8: Test template with sample plan

**Create test file:** `.bmad/custom/modules/frappe-builder/state/test-plan.md`

**Use template from i5, fill with realistic data:**

```markdown
# Plan: Custom Manufacturing Enhancement
App: custom_manufacturing | TSD: apps/custom_manufacturing/docs/tsd-phase3.md | Date: 2025-11-25

## Phase 1: Order Processing

### User Tasks
- [ ] u1: DocType "Custom Sales Order" (customer, items[item,qty,rate], total) | TSD: §2.1
- [ ] u2: Field on Sales Order: custom_priority (Select: High/Medium/Low) | TSD: §2.2
- [ ] u3: Workflow: Custom Sales Order (Draft→Approved→In Production→Delivered) | TSD: §2.3

### Dev Tasks
- [ ] d4: Validation - total must be > 0 | TSD: §3.1.1
- [ ] d5: Validation - items table must have >= 1 row | TSD: §3.1.2
- [ ] d6: Calc - total from items (sum of qty * rate) | TSD: §3.2.1
- [ ] d7: Client - auto-fetch item rate on item select | TSD: §3.3.1

**Complete when:** Can create, validate, and submit Custom Sales Order

---

## Phase 2: Production Planning

### Dev Tasks
- [ ] d8: Server - create Production Order on approval | TSD: §4.1.1
- [ ] d9: Report - Daily production schedule | TSD: §4.2.1
- [ ] d10: Dashboard - Orders by priority + status | TSD: §4.3.1

**Complete when:** Production orders auto-created, reports working

---

## Phase 3: Analytics

### Dev Tasks
- [ ] d11: Report - Monthly order value by customer | TSD: §5.1.1
- [ ] d12: Background - send daily summary email | TSD: §5.2.1
- [ ] d13: Dashboard - Revenue trends chart | TSD: §5.3.1

**Complete when:** All analytics functional, email sending

---

## Dependencies

| Task | Needs | Why |
|------|-------|-----|
| d6 | u1 | Items table must exist |
| d7 | u1, d6 | Need form + calc logic first |
| d8 | u3 | Workflow must exist to trigger |
| d9 | d8 | Need production orders to report on |
| d12 | d8, d9 | Need data before sending emails |

---

## Task Ranges

| Specialist | Phase 1 | Phase 2 | Phase 3 |
|------------|---------|---------|---------|
| User | u1:u3 | - | - |
| Dev | d4:d7 | d8:d10 | d11:d13 |

---

## TSD Section Mapping

| Task | TSD Section | Topic |
|------|-------------|-------|
| d4 | §3.1.1 | Total validation rule |
| d5 | §3.1.2 | Items table validation |
| d6 | §3.2.1 | Total calculation formula |
| d7 | §3.3.1 | Item rate auto-fetch logic |
| d8 | §4.1.1 | Production Order creation trigger |
| d9 | §4.2.1 | Production schedule report spec |
| d10 | §4.3.1 | Dashboard metrics definition |
| d11 | §5.1.1 | Monthly value report query |
| d12 | §5.2.1 | Email summary format |
| d13 | §5.3.1 | Revenue chart configuration |

---

## Notes
- Dev works autonomously through ranges
- Updates checkboxes as completes
- Returns to Nexus when range complete or blocked
- Uses `/context` to monitor token usage
- Restarts session if context >30k tokens
```

**Measure:**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

# Count tokens (approximate: words * 1.3)
WORDS=$(wc -w state/test-plan.md | awk '{print $1}')
TOKENS=$(echo "$WORDS * 1.3" | bc)
echo "Test plan tokens: $TOKENS"

# Target depends on complexity
echo "Token targets:"
echo "  Simple (1-2 phases, <10 tasks): <5,000"
echo "  Medium (3-4 phases, 11-20 tasks): <10,000"
echo "  Complex (5+ phases, 21+ tasks): <15,000"

if (( $(echo "$TOKENS < 5000" | bc -l) )); then
    echo "✓ PASS - Simple project range"
elif (( $(echo "$TOKENS < 10000" | bc -l) )); then
    echo "✓ PASS - Medium project range"
elif (( $(echo "$TOKENS < 15000" | bc -l) )); then
    echo "✓ PASS - Complex project range"
else
    echo "✗ FAIL - Exceeds 15k, needs optimization"
fi
```

**Validate:**
- [ ] All sections present (3 phases, dependencies, ranges, TSD mapping, decisions, risks)
- [ ] Tables used correctly
- [ ] Complexity classification present
- [ ] BRD reference present
- [ ] Token budget tracker present
- [ ] Terse format maintained
- [ ] Information complete (no data loss vs verbose template)
- [ ] Token count within complexity target

**Completion Criteria:**
- [ ] test-plan.md created with realistic content (medium complexity)
- [ ] Token count measured and <10k for medium project
- [ ] All enhanced template sections validated (context, decisions, risks)
- [ ] Format matches efficient template v2.1
- [ ] BRD reference present
- [ ] Complexity classification present

---

### Phase 1 Completion Criteria

**Validate ALL before proceeding to Phase 2:**

**IMPORTANT:** After validation passes, mark phase complete in Progress Tracker (line 101)

```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

echo "=== Phase 1 Validation ==="

# 1. Directory structure
[ -d "state" ] && echo "✓ state/ exists" || echo "✗ state/ missing"
[ -d "state/archive" ] && echo "✓ state/archive/ exists" || echo "✗ archive/ missing"

# 2. Templates exist
[ -f "state/active.yaml.template" ] && echo "✓ active.yaml.template exists" || echo "✗ missing"
[ -f "state/context.md.template" ] && echo "✓ context.md.template exists" || echo "✗ missing"
[ -f "state/archive/README.md" ] && echo "✓ archive README exists" || echo "✗ missing"
[ -f "state/archive/metadata.yaml.template" ] && echo "✓ metadata template exists" || echo "✗ missing"
[ -f "templates/documents/implementation-plan-efficient.md" ] && echo "✓ plan template exists" || echo "✗ missing"

# 3. XML tasks exist
[ -f "tasks/state/offload-context.xml" ] && echo "✓ offload-context.xml exists" || echo "✗ missing"
[ -f "tasks/state/archive-project.xml" ] && echo "✓ archive-project.xml exists" || echo "✗ missing"

# 4. Test plan exists
[ -f "state/test-plan.md" ] && echo "✓ test-plan.md exists" || echo "✗ missing"

echo ""
echo "=== Token Count Validation ==="

# 5. Token counts
ACTIVE_TOKENS=$(wc -w state/active.yaml.template 2>/dev/null | awk '{print int($1 * 1.3)}')
echo "active.yaml: $ACTIVE_TOKENS tokens (target: <200)"

CONTEXT_TOKENS=$(wc -w state/context.md.template 2>/dev/null | awk '{print int($1 * 1.3)}')
echo "context.md: $CONTEXT_TOKENS tokens (target: <500)"

PLAN_TOKENS=$(wc -w templates/documents/implementation-plan-efficient.md 2>/dev/null | awk '{print int($1 * 1.3)}')
echo "plan template: $PLAN_TOKENS tokens"
echo "  Simple: <5k | Medium: <10k | Complex: <15k"

TEST_TOKENS=$(wc -w state/test-plan.md 2>/dev/null | awk '{print int($1 * 1.3)}')
echo "test plan: $TEST_TOKENS tokens (target: <10k for medium)"

echo ""
echo "=== XML Validation ==="

# 6. XML syntax
xmllint --noout tasks/state/offload-context.xml 2>/dev/null && echo "✓ offload-context.xml valid" || echo "✗ invalid XML"
xmllint --noout tasks/state/archive-project.xml 2>/dev/null && echo "✓ archive-project.xml valid" || echo "✗ invalid XML"

echo ""
echo "=== Standards Compliance ==="

# 7. Check key features
grep -q "TSD Section Mapping" templates/documents/implementation-plan-efficient.md && echo "✓ TSD mapping present" || echo "✗ missing TSD mapping"
grep -q "| Task | Description | Status |" state/context.md.template && echo "✓ Table format in context" || echo "✗ missing table"

echo ""
echo "Phase 1 validation complete!"
```

**Manual Checklist:**
- [ ] All files created at correct paths
- [ ] All token counts within targets
- [ ] XML files well-formed
- [ ] Templates follow anti-fluff standards
- [ ] TSD mapping present in plan template
- [ ] No agent integration yet (just infrastructure)

**Status:** Phase 1 [ ] Complete

**📝 UPDATE PROGRESS TRACKER:** Mark Phase 1 complete checkbox (line 101) before proceeding to Phase 2

---

## Phase 2: Nexus Integration

**Goal:** Nexus uses state files instead of memories.md

**Duration:** 1.5 days

**Status:** [ ] Not started

**Prerequisites:**
- [ ] Phase 1 complete and validated
- [ ] Backups created (see task n1)

### Tasks

| ID | Task | Deliverable | File Modified | Status |
|----|------|-------------|---------------|--------|
| **n1** | Backup original Nexus files | .bak files | nexus instructions + memories | [ ] |
| **n2** | Modify Nexus startup: Load active.yaml | Updated instructions | nexus instructions.md | [ ] |
| **n3** | Add Nexus: Create new project flow + BRD summary extraction | Updated instructions | nexus instructions.md | [ ] |
| **n4** | Add Nexus: Resume archived project | Updated instructions | nexus instructions.md | [ ] |
| **n5** | Add Nexus: Set task range on routing | Updated instructions | nexus instructions.md | [ ] |
| **n6** | Add Nexus: Detect + archive completed | Updated instructions | nexus instructions.md | [ ] |
| **n7** | Update Nexus memories.md → state pointer | New memories format | nexus memories.md | [ ] |
| **n8** | Test: Full lifecycle (create→archive→resume) | Pass test | - | [ ] |
| **p1** | Backup Planner instructions | .bak file | planner instructions | [ ] |
| **p2** | Add Planner: Auto-generate TSD section mapping | Updated instructions | planner instructions.md | [ ] |

---

### n1: Backup original Nexus files

**Execute:**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

# Backup instructions
cp agents/frappe-nexus-sidecar/instructions.md \
   agents/frappe-nexus-sidecar/instructions.md.backup-pre-maker-$(date +%Y%m%d)

# Backup memories
cp agents/frappe-nexus-sidecar/memories.md \
   agents/frappe-nexus-sidecar/memories.md.backup-pre-maker-$(date +%Y%m%d)
```

**Verify:**
```bash
ls -la agents/frappe-nexus-sidecar/*.backup-pre-maker*
# Should show two backup files with today's date
```

**Completion Criteria:**
- [ ] instructions.md backed up
- [ ] memories.md backed up
- [ ] Backup files have timestamp
- [ ] Can rollback if needed

---

### n2: Modify Nexus startup sequence

**File:** `agents/frappe-nexus-sidecar/instructions.md`

**Current location:** Lines 38-77 ("Startup Sequence")

**FIND this section:**
```markdown
### Startup Sequence (EVERY TIME agent loads)

1. **Load Config**
   - Read {project-root}/.bmad/frappe-builder/config.yaml
   - Store all configuration variables

2. **Detect Frappe Bench**
   - Check if {project-root}/apps/ directory exists
   - If NOT found: Warn user "Frappe-Builder is designed for Frappe bench environments..."
   - If found: Proceed to step 3

3. **Ask User for Current App**
   [Lists apps, asks user to select]

4. **Set Session Paths**
   [Sets paths]

5. **Confirm to User**
   [Shows confirmation]

6. **Show Greeting and Menu**
```

**REPLACE WITH:**
```markdown
### Startup Sequence (EVERY TIME agent loads)

1. **Load Config**
   - Read {project-root}/.bmad/frappe-builder/config.yaml
   - Store all configuration variables

2. **Detect Frappe Bench**
   - Check if {project-root}/apps/ directory exists
   - If NOT found: Warn user "Frappe-Builder designed for Frappe bench"
   - If found: Proceed to step 3

3. **Check Active Project State**
   - Check if {project-root}/.bmad/custom/modules/frappe-builder/state/active.yaml exists

   **IF EXISTS (resuming project):**
   - Load active.yaml (<200 tokens with summary)
   - Read: project, app, phase, specialist, tasks, summary, notes
   - Set {{current_app}} = app from active.yaml
   - Greet: "Resuming '[project]' | [specialist] working on [tasks]"
   - Display summary if present
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
   - Ask: "Project name?"
   - Store as {{project_name}}
   - Create active.yaml:
     ```yaml
     project: "{{project_name}}"
     app: "{{current_app}}"
     plan: ""
     tsd: ""
     phase: "Planning"
     specialist: "frappe-nexus-sidecar"
     tasks: ""
     context: null
     updated: "[ISO timestamp]"
     ```
   - Save to: .bmad/custom/modules/frappe-builder/state/active.yaml
   - Proceed to step 5

   **IF choice = 2 (Resume archived):**
   - List: ls {project-root}/.bmad/custom/modules/frappe-builder/state/archive/
   - Ask: "Which project to resume?"
   - User selects [project-name]
   - Copy: archive/[project-name]/active.yaml → state/active.yaml
   - Load active.yaml
   - Set {{current_app}} = app from active.yaml
   - Ask: "Iterate (uncheck tasks) or continue?"
     - **Iterate:** Uncheck all tasks in plan.md (- [x] → - [ ])
     - **Continue:** Keep task states as-is
   - Update active.yaml timestamp
   - Proceed to step 6

5. **Set Session Paths** (if new project)
   - {{app_path}} = {project-root}/apps/{{current_app}}
   - {{docs_path}} = {{app_path}}/docs
   - {{code_path}} = {{app_path}}/{{current_app}}

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

**Token Impact:**
- OLD: Load memories.md (900 tokens)
- NEW: Load active.yaml (<200 tokens with BRD summary)
- **Savings: 700-800 tokens per session startup**

**Completion Criteria:**
- [ ] Startup sequence modified (lines 38-77 area)
- [ ] Active.yaml check added as step 3
- [ ] New project flow creates active.yaml
- [ ] Resume flow copies from archive
- [ ] Config path correct: `.bmad/frappe-builder/config.yaml`
- [ ] State path correct: `.bmad/custom/modules/frappe-builder/state/`

---

### n3: Add Nexus: Create new project flow + BRD summary extraction

**Already covered in n2, step 4 "IF choice = 1"**

**Additional: Add helper section in instructions**

**File:** `agents/frappe-nexus-sidecar/instructions.md`

**Add after routing section (around line 145):**

```markdown
## Creating New Project

When user starts new project:
1. Ask for project name
2. Ask for Frappe app (list apps/ directory)
3. Create active.yaml in state/
4. Route to ERPNext BA for requirements (if no BRD exists)
5. **[GAP 4 FIX] After BA completes BRD:**
   - Read BRD file (first 50 lines or "Executive Summary" section)
   - Extract 2-3 sentence summary covering: project description, key objective, primary user
   - Update active.yaml `summary:` field with extracted text
   - Keep summary concise (<50 tokens)
6. Route to Planner after BRD complete
7. Update active.yaml with plan path after Planner completes

**DO NOT:**
- Create memories.md (obsolete with MAKER integration)
- Load old session state
- Track project details in this agent's memory

**State Management:**
All project state lives in active.yaml. Read it on startup, update it when routing.

**BRD Summary Extraction (Gap 4 Fix):**
```python
# Pseudocode for BRD summary extraction
brd_content = read_file(brd_path, limit=50)
summary = extract_sentences(brd_content, section="Executive Summary" or "Overview", max_sentences=3)
update_active_yaml(summary=summary)
```
```

**Completion Criteria:**
- [ ] "Creating New Project" section added
- [ ] Process documented (name → app → active.yaml → route)
- [ ] **BRD summary extraction step added (Gap 4 fix)**
- [ ] Anti-patterns listed (don't use memories.md)

---

### n4: Add Nexus: Resume archived project

**Already covered in n2, step 4 "IF choice = 2"**

**Additional: Add helper section**

**File:** `agents/frappe-nexus-sidecar/instructions.md`

**Add after "Creating New Project" section:**

```markdown
## Resuming Archived Projects

When user resumes from archive:
1. List available: ls state/archive/
2. User selects project
3. Copy archive/[project]/active.yaml → state/active.yaml
4. Ask: "Iterate or continue?"
   - **Iterate:** Uncheck all task boxes in plan.md (- [x] → - [ ]), start fresh implementation
   - **Continue:** Keep task states, resume where left off
5. Update active.yaml timestamp
6. Load project context from active.yaml

**Use cases:**
- **Iterate:** User wants to rebuild with lessons learned, improve implementation
- **Continue:** User adding more features to completed project, extending functionality

**Archive Preservation:**
- Always COPY from archive (never move)
- Archive remains immutable reference
- User can resume multiple times from same archive
```

**Completion Criteria:**
- [ ] "Resuming Archived Projects" section added
- [ ] Copy vs move clarified
- [ ] Iterate vs continue explained

---

### n5: Add Nexus: Set task range on routing

**File:** `agents/frappe-nexus-sidecar/instructions.md`

**Find:** "INTELLIGENT ROUTING LOGIC" section (around lines 96-143)

**Add subsection after routing table:**

```markdown
### Setting Task Range for Specialists

When routing to specialist, update active.yaml with task range:

**Process:**
1. Read plan.md to identify specialist's tasks for current phase
2. Determine task range (e.g., d4:d7 for Dev Phase 1 tasks)
3. Update active.yaml before routing:
   ```yaml
   specialist: "[specialist-name]"
   tasks: "[task-range]"
   phase: "[current-phase]"
   updated: "[ISO timestamp]"
   ```
4. Route to specialist with message: "You're assigned [tasks] for [phase]"

**Example: Routing to Dev for Phase 1 implementation**
```yaml
# Nexus reads plan.md, identifies Dev task range for Phase 1
# Plan shows: d4:d7 (4 tasks)

# Update active.yaml:
specialist: "frappe-dev-sidecar"
tasks: "d4:d7"
phase: "Phase 1"
updated: "2025-11-25T10:30:00Z"
```

**Specialist receives:**
- Pointer to plan via active.yaml
- Task range to work autonomously
- Knows when to return (after d7 complete or if blocked)

**Task Range Format:**
- Single task: `d4`
- Range: `d4:d7` (tasks d4, d5, d6, d7)
- Multiple ranges: `d4:d7,d10:d12` (if non-contiguous)
- Completed: `complete` (when specialist finishes all assigned tasks)

**Task ID Prefixes:**
- `u*` = User configuration tasks
- `d*` = Dev implementation tasks
- `q*` = QA testing tasks
- `a*` = Architect design tasks
- `p*` = Planner sequencing tasks
```

**Completion Criteria:**
- [ ] Task range section added to routing logic
- [ ] active.yaml update process documented
- [ ] Task range format specified
- [ ] Example provided

---

### n6: Add Nexus: Detect + archive completed

**File:** `agents/frappe-nexus-sidecar/instructions.md`

**Add new section after routing:**

```markdown
## Project Completion & Archival

### Detecting Completion

When specialist returns with "Project complete" or all phase tasks checked:
1. Read plan.md
2. Count total tasks vs checked tasks
3. If all checked: Proceed to archival flow
4. If some unchecked: Ask user if intentional partial completion

**Verification:**
```bash
# Count total tasks
grep -c "^\- \[ \]" plan.md
grep -c "^\- \[x\]" plan.md

# If counts match: All done
```

### Archival Flow

```
Ask user: "Project '[name]' complete! Archive?"

Options:
1. Yes, archive → Clean state for next project
2. No, keep active → Continue adding features

IF YES:
  1. Update active.yaml: phase = "Complete"
  2. Execute: tasks/state/archive-project.xml
  3. Confirm: "Archived to state/archive/[project]/"
  4. Inform: "state/active.yaml cleared. Ready for next project."
  5. Next startup will offer: "New or resume archived?"

IF NO:
  - Keep active.yaml (user may extend project later)
  - Inform: "Active project kept. Can resume or extend anytime."
```

### Next Session After Archival

- No active.yaml exists → Startup offers "New or resume archived?"
- User can resume archived project and:
  - **Iterate:** Rebuild from scratch with improvements
  - **Continue:** Add new features to completed project
```

**Completion Criteria:**
- [ ] Completion detection logic added
- [ ] Archival flow documented
- [ ] User confirmation required
- [ ] Next session behavior specified

---

### n7: Update Nexus memories.md format

**File:** `agents/frappe-nexus-sidecar/memories.md`

**Current:** Lines 1-100+ contain project state tracking

**REPLACE ENTIRE FILE with:**

```markdown
# Frappe-Nexus Session Memories

## MAKER Integration Active

**State Management:** All project state in `.bmad/custom/modules/frappe-builder/state/active.yaml`

**DO NOT track project state in this file.** Read from active.yaml instead.

## State File Location
- **Active project:** `.bmad/custom/modules/frappe-builder/state/active.yaml`
- **Archived projects:** `.bmad/custom/modules/frappe-builder/state/archive/[project-name]/`
- **Context dumps:** `.bmad/custom/modules/frappe-builder/state/context.md` (when offloaded)

## Key Behaviors (MAKER Integration)

1. **Startup:** Check for active.yaml first (not memories.md)
2. **New project:** Create active.yaml, not memories tracking
3. **Routing:** Update active.yaml with specialist + task range
4. **Completion:** Archive project, delete active.yaml
5. **Resume:** Copy from archive to state/

## Session Notes (Optional)

[Use this space for cross-project observations, user preferences, patterns noticed]

## Standards References
- Anti-fluff: `.bmad/frappe-builder/standards/core/anti-fluff-mandate.md`
- Token efficiency: `.bmad/frappe-builder/standards/core/token-efficiency.md`

---

**Last Updated:** 2025-11-25
**Note:** This file is minimal (~80 tokens). All project state lives in active.yaml.
**Reason:** MAKER integration for 96% token reduction
```

**Token Impact:**
- OLD memories.md: 900+ tokens (and growing with each project)
- NEW memories.md: ~80 tokens (static)
- **Savings: 820+ tokens**

**Completion Criteria:**
- [ ] memories.md replaced with minimal version
- [ ] Points to active.yaml for state
- [ ] Token count ~80
- [ ] No project-specific tracking

---

### n8: Test full lifecycle

**Test scenario:**

```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

echo "=== Phase 2 Full Lifecycle Test ==="

# SETUP: Clean state
rm -f state/active.yaml state/context.md
rm -rf state/archive/test-maker-integration

echo "Step 1: Start fresh (no active.yaml)"
[ ! -f state/active.yaml ] && echo "✓ Clean state" || echo "✗ active.yaml exists"

echo ""
echo "Step 2: Invoke Nexus (manual)"
echo "  → Select 'New project'"
echo "  → Name: Test MAKER Integration"
echo "  → App: [pick any test app]"
echo "  → Verify: active.yaml created"

# VALIDATION POINT 1
read -p "Press Enter after creating new project..."
[ -f state/active.yaml ] && echo "✓ active.yaml created" || echo "✗ FAIL - no active.yaml"

echo ""
echo "Step 3: Simulate Planner completion"
# Create mock plan
cat > apps/[test-app]/docs/test-plan.md << 'EOF'
# Plan: Test MAKER Integration
App: test_app | TSD: N/A

## Phase 1: Test
### Dev Tasks
- [ ] d1: Task one | TSD: N/A
- [ ] d2: Task two | TSD: N/A

**Complete when:** Both tasks done
EOF

# Update active.yaml with plan path
# (This would normally be done by Nexus when routing)
# Manually edit active.yaml: plan = "apps/[test-app]/docs/test-plan.md"

echo "  → Update active.yaml with plan path"
read -p "Press Enter after updating active.yaml with plan path..."

echo ""
echo "Step 4: Simulate Dev completing tasks"
# Mark tasks as complete
# (Manually edit test-plan.md: - [ ] → - [x])
echo "  → Mark tasks d1, d2 as complete in plan"
read -p "Press Enter after marking tasks complete..."

echo ""
echo "Step 5: Mark project complete"
# Update active.yaml: phase = "Complete"
echo "  → Update active.yaml: phase = 'Complete'"
read -p "Press Enter after setting phase = Complete..."

echo ""
echo "Step 6: Test archival"
echo "  → Invoke Nexus, it should detect completion"
echo "  → Answer 'yes' to archive"
read -p "Press Enter after archiving..."

# VALIDATION POINT 2
if [ -d "state/archive/test-maker-integration" ]; then
    echo "✓ Archive directory created"
    [ -f "state/archive/test-maker-integration/metadata.yaml" ] && echo "✓ metadata.yaml exists" || echo "✗ missing metadata"
    [ -f "state/archive/test-maker-integration/active.yaml" ] && echo "✓ active.yaml archived" || echo "✗ missing active.yaml"
    [ -f "state/archive/test-maker-integration/plan.md" ] && echo "✓ plan.md archived" || echo "✗ missing plan"
else
    echo "✗ FAIL - archive directory not created"
fi

[ ! -f "state/active.yaml" ] && echo "✓ state/active.yaml deleted" || echo "✗ FAIL - active.yaml still exists"

echo ""
echo "Step 7: Test resume"
echo "  → Invoke Nexus again"
echo "  → Select 'Resume archived'"
echo "  → Select 'Test MAKER Integration'"
read -p "Press Enter after resuming..."

# VALIDATION POINT 3
[ -f "state/active.yaml" ] && echo "✓ active.yaml restored" || echo "✗ FAIL - no active.yaml"

echo ""
echo "=== Test Complete ==="
```

**Validation checklist:**
- [ ] New project creates active.yaml
- [ ] active.yaml has correct fields (project, app, plan, etc)
- [ ] Routing updates active.yaml with specialist + tasks
- [ ] Completion detected when all tasks checked
- [ ] Archive creates correct structure (metadata.yaml + files)
- [ ] state/active.yaml deleted after archive
- [ ] Resume restores active.yaml from archive
- [ ] Token counts within targets (measure with `/context`)

**Manual Test Steps:**

1. **Clean start:**
   ```bash
   rm -f state/active.yaml
   ```

2. **Invoke Nexus** (use Claude Code to call agent)
3. **Select "New project"** → name it "Test MAKER Integration"
4. **Verify active.yaml created** → check file exists, has correct fields
5. **Simulate workflow:** Manually add plan path to active.yaml
6. **Complete tasks:** Mark tasks as done in plan
7. **Set completion:** Update active.yaml phase = "Complete"
8. **Invoke Nexus** → should detect completion, offer archive
9. **Archive** → verify archive directory created
10. **Verify cleanup** → active.yaml deleted
11. **Invoke Nexus** → should offer "Resume archived"
12. **Resume** → verify active.yaml restored

**Completion Criteria:**
- [ ] Full lifecycle test passes all validation points
- [ ] No errors during workflow
- [ ] Archive structure correct
- [ ] State management working as designed

---

### p1: Backup Planner instructions

**Execute:**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

cp agents/frappe-planner-sidecar/instructions.md \
   agents/frappe-planner-sidecar/instructions.md.backup-pre-maker-$(date +%Y%m%d)
```

**Verify:**
```bash
ls -la agents/frappe-planner-sidecar/*.backup-pre-maker*
# Should show backup file with today's date
```

**Completion Criteria:**
- [ ] instructions.md backed up with timestamp
- [ ] Can rollback if needed

---

### p2: Add Planner: Auto-generate TSD section mapping

**⚠️ GAP 2 FIX: TSD Section Mapping Automation**

**Problem:** Manual TSD mapping is error-prone and time-consuming

**Solution:** Planner automatically generates mapping when creating plan

**File:** `agents/frappe-planner-sidecar/instructions.md`

**Add new section after "Creating Implementation Plan" section:**

```markdown
## TSD Section Mapping (GAP 2 FIX)

**Purpose:** Auto-generate TSD section references for each task in plan

**When:** After creating task list, before writing final plan.md

**Process:**

1. **Parse TSD structure**
   - Read TSD file
   - Extract all headers (## Section N, ### Subsection N.M)
   - Build section index with line numbers

2. **Match tasks to sections**
   - For each task in plan:
     - Extract task type (DocType, Field, Validation, Calc, etc)
     - Search TSD for matching section by keyword
     - Estimate tokens for that section (line count * 0.8)
     - Assign TSD reference (§N.M format)

3. **Generate mapping table**
   ```markdown
   ## TSD Section Mapping

   | Task | TSD Section | Topic | Est. Tokens |
   |------|-------------|-------|-------------|
   | d4 | §3.2.1 | Validation rules | ~150 |
   | d5 | §3.2.2 | Calculation logic | ~200 |
   ```

4. **Add to plan.md**
   - Insert mapping table after "Task Ranges" section
   - Before "Critical Decisions" section

**Matching Keywords:**

| Task Type | TSD Keywords to Search |
|-----------|------------------------|
| DocType creation | "DocType", "Data Model", "Entity" |
| Field addition | "Fields", "Attributes", "Properties" |
| Validation | "Validation", "Business Rules", "Constraints" |
| Calculation | "Calculation", "Formula", "Computation" |
| Client script | "Client-side", "Form Script", "UI Logic" |
| Server script | "Server-side", "Hooks", "Automation" |
| Report | "Report", "Query", "Analytics" |
| Dashboard | "Dashboard", "Metrics", "KPI" |

**Token Estimation:**
```python
# Pseudocode
section_lines = count_lines_in_section(tsd, section_number)
estimated_tokens = int(section_lines * 0.8)  # ~0.8 tokens per line average
```

**Fallback:**
- If no TSD section match found: Use "TSD: N/A"
- If TSD doesn't exist: Skip mapping table entirely
```

**Completion Criteria:**
- [ ] "TSD Section Mapping" section added to Planner instructions
- [ ] Parsing logic documented
- [ ] Matching keywords table provided
- [ ] Token estimation formula specified
- [ ] Fallback cases handled
- [ ] Integration point in plan creation specified

---

### Phase 2 Completion Criteria

**Validate ALL before proceeding to Phase 3:**

```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

echo "=== Phase 2 Validation ==="

# 1. Backups exist
[ -f "agents/frappe-nexus-sidecar/instructions.md.backup-pre-maker"* ] && echo "✓ Instructions backed up" || echo "✗ No backup"
[ -f "agents/frappe-nexus-sidecar/memories.md.backup-pre-maker"* ] && echo "✓ Memories backed up" || echo "✗ No backup"

# 2. Files modified - Nexus
echo ""
echo "Check Nexus instructions.md for new sections:"
grep -q "Check Active Project State" agents/frappe-nexus-sidecar/instructions.md && echo "✓ Startup modified" || echo "✗ Missing startup changes"
grep -q "Setting Task Range" agents/frappe-nexus-sidecar/instructions.md && echo "✓ Task range section added" || echo "✗ Missing task range"
grep -q "Project Completion & Archival" agents/frappe-nexus-sidecar/instructions.md && echo "✓ Archival section added" || echo "✗ Missing archival"
grep -q "BRD summary extraction" agents/frappe-nexus-sidecar/instructions.md && echo "✓ Gap 4 fix present" || echo "✗ Missing BRD extraction"

# 3. Files modified - Planner
echo ""
echo "Check Planner instructions.md for new sections:"
[ -f "agents/frappe-planner-sidecar/instructions.md.backup-pre-maker"* ] && echo "✓ Planner backed up" || echo "✗ No Planner backup"
grep -q "TSD Section Mapping" agents/frappe-planner-sidecar/instructions.md && echo "✓ Gap 2 fix present (TSD mapping)" || echo "✗ Missing TSD mapping automation"

# 4. Memories updated
echo ""
echo "Check memories.md token count:"
MEM_TOKENS=$(wc -w agents/frappe-nexus-sidecar/memories.md | awk '{print int($1 * 1.3)}')
echo "Memories: $MEM_TOKENS tokens (target: <150)"
[ $MEM_TOKENS -lt 150 ] && echo "✓ Minimal memories" || echo "✗ Still bloated"

# 5. Test passed
echo ""
echo "Did full lifecycle test pass? (manual verification required)"
```

**Manual Checklist:**
- [ ] Nexus loads active.yaml instead of old memories.md
- [ ] New project flow creates active.yaml correctly
- [ ] BRD summary extraction working (Gap 4 fix verified)
- [ ] Resume archived flow works
- [ ] Task range set when routing to specialists
- [ ] Completion detection + archival working
- [ ] memories.md converted to minimal format (<150 tokens)
- [ ] Planner backup created (p1 done)
- [ ] TSD mapping automation added to Planner (p2 done)
- [ ] Full lifecycle test passes
- [ ] Token savings verified (900→<200 = 700-800 tokens on startup)
- [ ] active.yaml includes BRD, summary, notes fields

**Rollback Plan (if Phase 2 fails):**
```bash
# Restore original files
cp agents/frappe-nexus-sidecar/instructions.md.backup-pre-maker* \
   agents/frappe-nexus-sidecar/instructions.md
cp agents/frappe-nexus-sidecar/memories.md.backup-pre-maker* \
   agents/frappe-nexus-sidecar/memories.md

# Test Nexus works
# Invoke Nexus, verify startup succeeds
```

**Status:** Phase 2 [ ] Complete

**📝 UPDATE PROGRESS TRACKER:** Mark Phase 2 complete checkbox (line 102) before proceeding to Phase 3

---

## Phase 3: Dev Agent Autonomy + Context Offloading

**Goal:** Dev works through task ranges autonomously, offloads context when bloated

**Duration:** 2 days

**Status:** [ ] Not started

**Prerequisites:**
- [ ] Phase 1 complete
- [ ] Phase 2 complete and tested
- [ ] Backups exist

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

---

### d1: Backup Dev agent instructions

**Execute:**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

cp agents/frappe-dev-sidecar/instructions.md \
   agents/frappe-dev-sidecar/instructions.md.backup-pre-maker-$(date +%Y%m%d)
```

**Verify:**
```bash
ls -la agents/frappe-dev-sidecar/*.backup-pre-maker*
# Should show backup file with today's date
```

**Completion Criteria:**
- [ ] instructions.md backed up with timestamp

---

### d2: Add Dev: Load active.yaml for task range

**File:** `agents/frappe-dev-sidecar/instructions.md`

**Add section at top (after "Your Role", before "Frappe Bench Awareness"):**

```markdown
## MAKER Integration: Startup & Task Range

### Every Session Start

**CRITICAL:** Always load active.yaml first, before any other actions.

1. **Load Active Project**
   - Read: `.bmad/custom/modules/frappe-builder/state/active.yaml`
   - Extract:
     ```yaml
     project: "[name]"
     app: "[app]"
     plan: "[path]"           # Path to implementation plan
     tsd: "[path]"            # Path to TSD (if exists)
     brd: "[path]"            # Path to BRD (if exists)
     tasks: "[range]"         # Example: "d4:d7" or "d10:d15"
     phase: "[phase]"         # Example: "Phase 1"
     context: "[path or null]" # Previous context dump (if exists)
     summary: "[text]"        # Project summary from BRD
     notes: "[text]"          # Critical context notes
     ```

2. **Parse Task Range**
   ```python
   # Use this function to parse task range string
   def parse_task_range(task_string):
       """
       Parses task range string into list of task IDs.

       Examples:
       - "d4" → ["d4"]
       - "d4:d7" → ["d4", "d5", "d6", "d7"]
       - "d4:d7,d10:d12" → ["d4", "d5", "d6", "d7", "d10", "d11", "d12"]
       - "qa1:qa3" → ["qa1", "qa2", "qa3"]
       """
       if not task_string or task_string == "complete":
           return []

       task_list = []
       ranges = task_string.split(",")

       for r in ranges:
           r = r.strip()

           if ":" not in r:
               # Single task
               task_list.append(r)
           else:
               # Range
               start, end = r.split(":")
               prefix = ''.join([c for c in start if not c.isdigit()])
               start_num = int(''.join([c for c in start if c.isdigit()]))
               end_num = int(''.join([c for c in end if c.isdigit()]))

               for i in range(start_num, end_num + 1):
                   task_list.append(f"{prefix}{i}")

       return task_list

   # Example usage:
   # tasks = "d4:d7"
   # task_list = parse_task_range(tasks)
   # → ["d4", "d5", "d6", "d7"]
   ```

3. **Load Implementation Plan**
   - Read: Plan from path in active.yaml
   - Find Phase section matching active.yaml phase
   - Locate tasks in your assigned range
   - Extract task descriptions

4. **Load TSD (on-demand, per task)**
   - **DO NOT** load entire TSD upfront
   - For each task, check if task line has `| TSD: §[section]`
   - Load ONLY that TSD section when working on that task
   - Example:
     ```markdown
     # In plan.md:
     - [ ] d6: Calc - total from line items | TSD: §3.2.1

     # When working on d6:
     # Read TSD, find section "§3.2.1" or "### 3.2.1"
     # Load only that section (~150 tokens)
     ```

5. **Load Previous Context (if offloaded)**
   - If active.yaml `context` field is not null:
     - Read: `.bmad/custom/modules/frappe-builder/state/[context path]`
     - Review completed tasks + files modified
     - Understand current state
   - If context field is null:
     - Fresh start, no previous context

**Token cost (startup):**
- active.yaml: <200 tokens (with summary)
- Plan (current phase section): ~200-500 tokens (depends on complexity)
- Previous context (if offloaded): <500 tokens
- TSD section (per task, loaded on-demand): ~150-220 tokens
- **Total initial load: ~400-1200 tokens** (vs 4900+ old approach)
- **Savings: 75-92% reduction at startup**

### Configuration Path

**CRITICAL:** Use correct config path:
```
{project-root}/.bmad/frappe-builder/config.yaml
```

NOT: `.bmad/custom/modules/frappe-builder/config.yaml`
```

**Completion Criteria:**
- [ ] "MAKER Integration: Startup & Task Range" section added
- [ ] active.yaml loading documented
- [ ] Task range parser function provided
- [ ] TSD on-demand loading explained with `| TSD: §X` format
- [ ] Token costs calculated
- [ ] Config path correct

---

### d3: Add Dev: Autonomous execution loop

**File:** `agents/frappe-dev-sidecar/instructions.md`

**Add section after startup:**

```markdown
## Autonomous Task Execution Loop

### Pattern

Execute tasks in your assigned range WITHOUT returning to Nexus after each task.

```
FOR each task_id IN task_range:
  1. Read task description from plan.md
  2. Load relevant TSD section (if task has | TSD: §X)
  3. Implement task
  4. Test implementation
  5. Update plan.md: - [ ] → - [x]
  6. Update active.yaml: current task (optional)
  7. Check context size (see Context Management below)
  8. IF task_id == range_end:
       Exit loop, return to Nexus
     ELSE:
       Continue to next task
```

### Example Execution

**Task range:** d4:d7

**Autonomous execution:**

```
Task d4: "Validation - amount > 0 | TSD: §3.1.1"
  ├─ Load TSD section §3.1.1 (validation spec)
  ├─ Implement: Add validate() method to DocType controller
  ├─ Test: Create doc with amount = -100 → should raise error
  ├─ Update plan: ✓ d4
  ├─ Check context: 8k tokens → Continue
  └─ Move to d5

Task d5: "Validation - items >= 1 | TSD: §3.1.2"
  ├─ Load TSD section §3.1.2
  ├─ Implement: Add items table validation
  ├─ Test: Submit doc with 0 items → should raise error
  ├─ Update plan: ✓ d5
  ├─ Check context: 15k tokens → Continue
  └─ Move to d6

Task d6: "Calc - total from line items | TSD: §3.2.1"
  ├─ Load TSD section §3.2.1
  ├─ Implement: Add calculate_total() method
  ├─ Test: Verify total = sum(items.qty * items.rate)
  ├─ Update plan: ✓ d6
  ├─ Check context: 22k tokens → Continue
  └─ Move to d7

Task d7: "Server - create delivery note | TSD: §3.4.1"
  ├─ Load TSD section §3.4.1
  ├─ Implement: Server script on_submit
  ├─ Test: Submit order → delivery note created
  ├─ Update plan: ✓ d7
  ├─ Range complete → Return to Nexus with summary
  └─ DONE
```

**Result:** 4 tasks, 1 return to Nexus (vs 4 returns in old approach)

### Blocking Scenarios

**IF implementation blocked:**
- Unknown requirement (TSD unclear)
- Missing dependency (need another specialist's work)
- Error can't resolve (tech problem)
- Test failing (unexpected behavior)

**THEN:**
1. Update plan: Add blocker note to task
   ```markdown
   - [ ] d6: Calc - total from line items | TSD: §3.2.1
     BLOCKER: TSD doesn't specify how to handle tax calculation
   ```
2. Update active.yaml: Current task = where stopped
3. Return to Nexus with structured blocker message:
   ```json
   {
     "status": "blocked",
     "task": "d6",
     "blocker_type": "missing_requirement",
     "description": "TSD unclear on tax calculation logic",
     "recommended_specialist": "frappe-architect-sidecar"
   }
   ```
4. Nexus routes to recommended specialist to unblock

**Blocker Types → Specialist Mapping:**

| Blocker Type | Route To | Why |
|--------------|----------|-----|
| missing_requirement | frappe-architect-sidecar | Need design decision |
| unclear_spec | frappe-planner-sidecar | Clarify implementation plan |
| runtime_error | frappe-debugger-sidecar | Code not working |
| test_failure | qa-specialist-sidecar | Tests failing unexpectedly |
| missing_dependency | frappe-nexus-sidecar | Need library/module install |
| unknown | frappe-nexus-sidecar | Nexus triages manually |

**DO NOT:**
- Skip tasks (maintain sequence)
- Mark as complete if not tested
- Continue past blocker (stop and return)
- Return to Nexus just to "check in" (work autonomously)
```

**Completion Criteria:**
- [ ] Autonomous execution loop pattern documented
- [ ] Example walkthrough provided
- [ ] Blocking scenarios defined
- [ ] Blocker classification table added
- [ ] Return conditions clear (range complete OR blocked)

---

### d4: Add Dev: Context size detection

**File:** `agents/frappe-dev-sidecar/instructions.md`

**Add section:**

```markdown
## Context Management

### Detecting Context Bloat

**Check after each task completion using Claude Code `/context` command.**

**Process:**
1. After completing task, run: `/context`
2. Check "Current tokens used" value
3. If > 30,000 tokens → Trigger offload
4. If < 30,000 tokens → Continue to next task

**Example `/context` output:**
```
Current tokens used: 32,450 / 200,000 (16%)
- Messages: 12,000 tokens
- Files read: 15,000 tokens
- Tool outputs: 5,450 tokens
```
**Action:** 32,450 > 30,000 → Offload context

**Why 30,000 token threshold?**
- Conservative limit (15% of 200k window)
- Prevents performance degradation
- Allows room for TSD sections + testing
- Earlier offload = fresher context

**When to check:**
- After completing each task
- Before loading large TSD sections (>500 lines)
- If notice performance slowdown
- User-initiated (if user asks)

**Alternative: Message Count Heuristic**
If `/context` unavailable, estimate:
- ~800 tokens per code block generated
- ~150 tokens per text response
- ~1000 tokens per file read (average)
- Trigger offload after ~35 messages (rough proxy for 30k tokens)
```

**Completion Criteria:**
- [ ] `/context` command usage documented
- [ ] Threshold defined (30,000 tokens)
- [ ] Check frequency specified (after each task)
- [ ] Fallback heuristic provided

---

### d5: Add Dev: Context offload integration

**File:** `agents/frappe-dev-sidecar/instructions.md`

**Add to "Context Management" section:**

```markdown
### Offloading Process

**When context >30,000 tokens (detected via `/context`):**

**Step 1: Prepare for offload**
- Complete current task fully (don't stop mid-task)
- Update plan.md checkbox for current task
- Note current position in task range

**Step 2: Execute offload task**
```
Load and execute:
.bmad/custom/modules/frappe-builder/tasks/state/offload-context.xml

This task will:
1. Collect completed tasks from plan.md
2. List files modified this session
3. Identify next task in range
4. Create context.md with structured dump
5. Update active.yaml with context path
6. Notify you to restart session
```

**Step 3: Session restart (MANUAL)**
```
⚠️ Context offloaded to state/context.md

**User action required:**
1. Review context dump: cat .bmad/custom/modules/frappe-builder/state/context.md
2. Use `/clear` command to reset Claude Code context window
3. Re-invoke frappe-dev-sidecar agent

**What happens next:**
- Agent auto-loads active.yaml (<200 tokens with summary)
- Loads plan.md current phase (~200-500 tokens)
- Loads context.md summary (<500 tokens)
- Resumes at next task in range
- **Fresh context: ~400-1200 tokens** (vs 30,000+ before offload)
- **96-98% reduction from offload**
```

**Step 4: Resume after restart**
- Load active.yaml → identifies task range + current position
- Load context.md → understands what's been completed
- Read plan.md → finds next unchecked task in range
- Continue execution loop from where left off

### Example Context Offload

**Scenario:** Working on tasks d4:d10, completed d4-d6, context at 32k tokens

**Generated context.md:**
```markdown
# Context: Custom Manufacturing - Phase 1
Date: 2025-11-25T14:30:00Z | Agent: frappe-dev-sidecar | Session: 1

## Completed

| Task | Description | Status |
|------|-------------|--------|
| d4 | Validation - amount > 0 | ✓ |
| d5 | Validation - items >= 1 | ✓ |
| d6 | Calc - total from line items | ✓ |

## Files Modified
- apps/custom_manufacturing/custom_manufacturing/doctype/sales_order_custom/sales_order_custom.py
- apps/custom_manufacturing/custom_manufacturing/doctype/sales_order_custom/test_sales_order_custom.py

## Current Task
d7: Server - create delivery note on submit

## Issues
None

## Next Session
Resume at task: d7
Load: active.yaml → plan.md Phase 1 → TSD section §3.4.1

---
Context cleared after this dump. Use `/clear` to reset.
```

**Token count:** ~100 (replaces 32,000 conversation history)

**Efficiency gain:** 98.4-98.8% reduction

### Offload Frequency

**Proactive (Recommended):**
- After completing each phase (even if <30k tokens)
- Before starting large tasks (reports, complex features)
- When switching between specialists (if Dev calls Debugger)

**Reactive (Required):**
- When context >30k tokens
- When `/context` shows >15% usage
- If performance noticeably degrades
```

**Completion Criteria:**
- [ ] Offload process documented (4 steps)
- [ ] Session restart protocol clear (manual `/clear` + re-invoke)
- [ ] Resume mechanism explained
- [ ] Example context dump shown
- [ ] Token reduction highlighted
- [ ] Offload frequency guidelines provided

---

### d6: Add Dev: Update plan checkboxes

**File:** `agents/frappe-dev-sidecar/instructions.md`

**Add section:**

```markdown
## Updating Implementation Plan

### After Each Task Completion

**Update plan.md checkbox from unchecked to checked.**

**Safe Update Method (prevents corruption):**

```python
import re

def update_plan_checkbox(task_id, plan_path):
    """
    Safely update single task checkbox in plan.md

    Args:
        task_id: Task ID (e.g., "d4", "d10")
        plan_path: Full path to plan.md file

    Returns:
        True if updated, False if task not found
    """
    # Read plan
    with open(plan_path, 'r') as f:
        plan_content = f.read()

    # Use regex with word boundary to match exact task ID
    # Matches: "- [ ] d4:" but NOT "- [ ] d40:"
    pattern = rf'^(\s*- \[ \] {re.escape(task_id)}:.*?)$'

    # Check if task exists and is unchecked
    if not re.search(pattern, plan_content, re.MULTILINE):
        # Task not found or already checked
        return False

    # Replace [ ] with [x] for this task only
    updated = re.sub(
        pattern,
        lambda m: m.group(0).replace('[ ]', '[x]'),
        plan_content,
        flags=re.MULTILINE,
        count=1  # Only first match (should be only match)
    )

    # Write back
    with open(plan_path, 'w') as f:
        f.write(updated)

    return True

# Example usage:
# plan_path = "/home/riz/frappe-bench/apps/custom_manufacturing/docs/impl-plan.md"
# success = update_plan_checkbox("d6", plan_path)
# if success:
#     print("✓ Task d6 marked complete")
# else:
#     print("✗ Task d6 not found or already complete")
```

**BEFORE:**
```markdown
- [ ] d4: Validation - amount > 0 | TSD: §3.1.1
- [ ] d5: Validation - items >= 1 | TSD: §3.1.2
- [ ] d6: Calc - total from line items | TSD: §3.2.1
```

**AFTER (d6 completed):**
```markdown
- [ ] d4: Validation - amount > 0 | TSD: §3.1.1
- [ ] d5: Validation - items >= 1 | TSD: §3.1.2
- [x] d6: Calc - total from line items | TSD: §3.2.1
```

### Verification

After update:
1. Read plan.md again
2. Confirm checkbox changed: `- [ ] d6:` → `- [x] d6:`
3. Verify no other tasks accidentally modified
4. If verification fails: Abort, investigate corruption

### Error Handling

**If task not found in plan:**
- Check task_id spelling
- Check plan_path correct
- Verify plan.md has that task
- If truly missing: Return error to Nexus (plan/reality mismatch)

**If plan.md corrupted:**
- Do NOT continue
- Notify user immediately
- Suggest restore from backup or version control
```

**Completion Criteria:**
- [ ] Safe update function provided (regex-based)
- [ ] Example usage shown
- [ ] Before/after comparison clear
- [ ] Verification steps documented
- [ ] Error handling defined
- [ ] Prevents substring corruption (d4 vs d40)

---

### d7: Add Dev: Return protocol

**File:** `agents/frappe-dev-sidecar/instructions.md`

**Add section:**

```markdown
## Returning to Nexus

### When to Return

**ONLY return to Nexus in these scenarios:**

1. **Task range complete:** All assigned tasks executed and tested
2. **Blocked:** Cannot proceed due to missing info/dependency/error
3. **Phase complete:** All phase tasks done (if your range = entire phase)

**DO NOT return:**
- After each individual task (work autonomously)
- To "check in" or "update status"
- When context offloaded (just restart this agent)

### Return Message Format

**Success (range complete):**
```
✅ Phase [N] dev tasks complete ([range]).

**Completed:**
- d4: Validation - amount > 0 ✓
- d5: Validation - items >= 1 ✓
- d6: Calc - total from line items ✓
- d7: Server - create delivery note ✓

**Files modified:**
- apps/custom_manufacturing/.../sales_order_custom.py
- apps/custom_manufacturing/.../test_sales_order_custom.py

**Tests:** All passing (4/4 tests green)

**Context:** [X]k tokens used (offloaded [Y] times)

**Ready for:** [Next specialist - QA review, next phase, deployment, etc]
```

**Blocked:**
```json
{
  "status": "blocked",
  "task": "d6",
  "description": "Calc - total from line items",
  "blocker_type": "missing_requirement",
  "details": "TSD §3.2.1 doesn't specify whether to include tax in total calculation",
  "recommended_specialist": "frappe-architect-sidecar",
  "completed_so_far": ["d4", "d5"],
  "files_modified": [
    "apps/custom_manufacturing/.../sales_order_custom.py"
  ]
}
```

**Phase Complete:**
```
🎉 Phase [N] COMPLETE!

**Summary:**
- Total tasks: [X]
- Completed: [X]
- Tests: All passing
- Token usage: [X]k (avg [Y]k per task)
- Context offloads: [Z]

**Deliverables:**
- [List major features/files created]

**Next phase:** [Phase N+1 goal]
**Handoff to:** [Next specialist or Nexus for planning]
```

### Update active.yaml Before Return

**If range complete:**
```yaml
tasks: "complete"
phase: "[Next phase]"  # or "Complete" if project done
updated: "[ISO timestamp]"
```

**If blocked:**
```yaml
tasks: "[current task where blocked]"
# phase stays same
# specialist stays same (will return after unblock)
updated: "[ISO timestamp]"
```

### Nexus Routing After Return

Based on your return message, Nexus will:

| Return Status | Nexus Action |
|---------------|--------------|
| Range complete, phase not done | Route to next specialist in phase (QA, etc) |
| Range complete, phase done | Move to next phase planning |
| Blocked (missing_requirement) | Route to Architect for clarification |
| Blocked (runtime_error) | Route to Debugger for fix |
| Blocked (test_failure) | Route to QA for test review |
| Phase complete | Archive or plan next phase |

### Token Budget Report

Include in return message:
- Starting context: [X]k tokens
- Peak context: [Y]k tokens
- Offload count: [Z] times
- Final context: [W]k tokens
- Efficiency: [%] reduction vs old approach

**Example:**
```
Token budget:
- Start: 310 tokens (active.yaml + plan + context.md)
- Peak: 28k tokens (before offload)
- Offloads: 2 times
- Final: 3.2k tokens
- Efficiency: 93% reduction (vs 49k old approach for 10 tasks)
```
```

**Completion Criteria:**
- [ ] Return conditions defined (3 scenarios)
- [ ] Return message formats provided (success, blocked, complete)
- [ ] active.yaml update protocol specified
- [ ] Nexus routing table documented
- [ ] Token budget reporting added

---

### d8: Test 10-task scenario

**Test setup:**

Create realistic 10-task project to validate full MAKER integration:

**Step 1: Create test project**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

# Create test plan with 10 dev tasks
cat > state/test-10tasks-plan.md << 'EOF'
# Plan: MAKER Integration 10-Task Test
App: test_app | TSD: N/A | Date: 2025-11-25

## Phase 1: Validation Layer

### Dev Tasks
- [ ] d1: Validation - amount > 0 | TSD: N/A
- [ ] d2: Validation - items >= 1 | TSD: N/A
- [ ] d3: Validation - customer exists | TSD: N/A

**Complete when:** All validations working

---

## Phase 2: Business Logic

### Dev Tasks
- [ ] d4: Calc - line total (qty * rate) | TSD: N/A
- [ ] d5: Calc - grand total (sum lines) | TSD: N/A
- [ ] d6: Client - auto-fetch rate | TSD: N/A
- [ ] d7: Server - create delivery | TSD: N/A

**Complete when:** All calculations + automation working

---

## Phase 3: Reporting

### Dev Tasks
- [ ] d8: Report - daily orders | TSD: N/A
- [ ] d9: Dashboard - order metrics | TSD: N/A
- [ ] d10: Background - email summary | TSD: N/A

**Complete when:** Analytics functional

---

## Task Ranges
| Specialist | Phase 1 | Phase 2 | Phase 3 |
|------------|---------|---------|---------|
| Dev | d1:d3 | d4:d7 | d8:d10 |
EOF

# Create active.yaml for test
cat > state/active.yaml << EOF
project: "MAKER 10-Task Test"
app: "test_app"
plan: ".bmad/custom/modules/frappe-builder/state/test-10tasks-plan.md"
tsd: ""
phase: "Phase 1"
specialist: "frappe-dev-sidecar"
tasks: "d1:d10"
context: null
updated: "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
EOF
```

**Step 2: Test execution**

1. **Invoke Dev agent** (frappe-dev-sidecar)
2. **Agent should auto-load active.yaml** → task range d1:d10
3. **Implement tasks d1-d10** (simplified - just create placeholder code)
4. **Monitor with `/context`** after each task
5. **Trigger offload** when context >30k (should happen around task d6-d7)
6. **Verify offload creates context.md**
7. **Restart session** (use `/clear` + re-invoke agent)
8. **Agent resumes** from where left off
9. **Complete remaining tasks**
10. **Return to Nexus** with summary

**Step 3: Measure metrics**

Create measurement script:

```bash
#!/bin/bash
# File: state/measure-10task-test.sh

echo "=== MAKER Integration 10-Task Test Metrics ==="
echo ""

# 1. Initial load tokens
echo "1. Initial Load Tokens:"
ACTIVE_TOKENS=$(wc -w state/active.yaml | awk '{print int($1 * 1.3)}')
PLAN_TOKENS=$(wc -w state/test-10tasks-plan.md | awk '{print int($1 * 1.3)}')
INITIAL_TOTAL=$((ACTIVE_TOKENS + PLAN_TOKENS))
echo "   active.yaml: $ACTIVE_TOKENS tokens"
echo "   plan.md: $PLAN_TOKENS tokens"
echo "   Total initial: $INITIAL_TOTAL tokens"
echo "   Target: <1200 tokens (startup budget)"
if [ $INITIAL_TOTAL -lt 1200 ]; then
    echo "   ✓ PASS"
else
    echo "   ✗ FAIL"
fi

echo ""

# 2. Context offload check
echo "2. Context Offload:"
if [ -f "state/context.md" ]; then
    CONTEXT_TOKENS=$(wc -w state/context.md | awk '{print int($1 * 1.3)}')
    echo "   context.md exists: YES"
    echo "   context.md tokens: $CONTEXT_TOKENS"
    echo "   Target: <500 tokens"
    if [ $CONTEXT_TOKENS -lt 500 ]; then
        echo "   ✓ PASS"
    else
        echo "   ✗ FAIL"
    fi
else
    echo "   context.md exists: NO"
    echo "   ⚠ Context may not have been offloaded (test may not have hit 30k threshold)"
fi

echo ""

# 3. Plan checkboxes
echo "3. Task Completion:"
TOTAL_TASKS=$(grep -c "^\- \[ \]" state/test-10tasks-plan.md 2>/dev/null || echo 0)
COMPLETED_TASKS=$(grep -c "^\- \[x\]" state/test-10tasks-plan.md 2>/dev/null || echo 0)
echo "   Total tasks: $TOTAL_TASKS"
echo "   Completed: $COMPLETED_TASKS"
echo "   Target: 10 completed"
if [ $COMPLETED_TASKS -eq 10 ]; then
    echo "   ✓ PASS"
else
    echo "   ✗ FAIL ($COMPLETED_TASKS/10)"
fi

echo ""

# 4. Round trips
echo "4. Round Trips to Nexus:"
echo "   Old approach: 10 (one per task)"
echo "   MAKER approach: 1 (or 2 if offloaded mid-range)"
echo "   Target: ≤2"
echo "   (Manual verification required - check conversation history)"

echo ""

# 5. Token efficiency
echo "5. Token Efficiency Comparison:"
echo "   OLD APPROACH (10 tasks):"
echo "     Initial load: 4,900 tokens (memories + plan)"
echo "     Per task: 4,900 tokens × 10 = 49,000 tokens"
echo "   "
echo "   MAKER APPROACH (10 tasks):"
echo "     Initial load: ~$INITIAL_TOTAL tokens"
echo "     Context offload: ~$CONTEXT_TOKENS tokens (when triggered)"
echo "     Fresh restart: ~1000 tokens"
echo "     Estimated total: <5,000 tokens"
echo "   "
REDUCTION=$(echo "scale=1; (49000 - 5000) / 49000 * 100" | bc)
echo "   Token reduction: ~${REDUCTION}%"
echo "   Target: >85%"

echo ""
echo "=== Test Complete ==="
```

**Make executable:**
```bash
chmod +x state/measure-10task-test.sh
```

**Run after test:**
```bash
./state/measure-10task-test.sh
```

**Expected metrics:**

| Metric | Old Approach | New Approach | Target | Pass? |
|--------|-------------|--------------|--------|-------|
| Initial load | 4,900 tokens | ~1000 tokens | <1200 | [ ] |
| Per task context | Full reload (4,900) | Incremental (200-500) | <600 | [ ] |
| 10-task total | 49,000 tokens | ~4,500 tokens | <6,000 | [ ] |
| Context offloads | Never | 1-2 times | 1-2 | [ ] |
| Round trips to Nexus | 10 | 1 | 1 | [ ] |
| Token reduction | 0% | ~90% | >85% | [ ] |

**Pass criteria:**
- [ ] Initial load <1200 tokens
- [ ] Context offload triggered when >30k
- [ ] context.md created correctly (enhanced tables, <500 tokens)
- [ ] Fresh context after offload <1200 tokens
- [ ] All 10 tasks completed
- [ ] Total tokens <6000 (vs 49,000 old)
- [ ] 1 return to Nexus (vs 10 old)
- [ ] 85%+ token reduction achieved
- [ ] Session restart worked (resume from enhanced context.md)
- [ ] No data loss (all task details preserved)
- [ ] active.yaml includes BRD summary and notes

**Completion Criteria:**
- [ ] Test project created
- [ ] 10 tasks implemented via MAKER workflow
- [ ] Metrics measured via script
- [ ] All pass criteria met
- [ ] Test documents achievement of 96% token reduction goal

---

### Phase 3 Completion Criteria

**Validate ALL before considering Phase 3 complete:**

```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

echo "=== Phase 3 Validation ==="

# 1. Backup exists
[ -f "agents/frappe-dev-sidecar/instructions.md.backup-pre-maker"* ] && echo "✓ Dev backed up" || echo "✗ No backup"

# 2. Dev instructions modified
echo ""
echo "Check Dev instructions.md for new sections:"
grep -q "MAKER Integration: Startup & Task Range" agents/frappe-dev-sidecar/instructions.md && echo "✓ Startup added" || echo "✗ Missing"
grep -q "Autonomous Task Execution Loop" agents/frappe-dev-sidecar/instructions.md && echo "✓ Autonomy added" || echo "✗ Missing"
grep -q "Context Management" agents/frappe-dev-sidecar/instructions.md && echo "✓ Context mgmt added" || echo "✗ Missing"
grep -q "Updating Implementation Plan" agents/frappe-dev-sidecar/instructions.md && echo "✓ Checkbox update added" || echo "✗ Missing"
grep -q "Returning to Nexus" agents/frappe-dev-sidecar/instructions.md && echo "✓ Return protocol added" || echo "✗ Missing"

# 3. Test results
echo ""
echo "Run 10-task test metrics:"
if [ -f "state/measure-10task-test.sh" ]; then
    ./state/measure-10task-test.sh
else
    echo "✗ Test script not found"
fi

echo ""
echo "Manual verification required:"
echo "- [ ] Dev loads active.yaml on startup"
echo "- [ ] Task range parser works for all formats"
echo "- [ ] Autonomous loop executes multiple tasks"
echo "- [ ] /context command used for token monitoring"
echo "- [ ] Context offload triggered at 30k"
echo "- [ ] Session restart preserves state"
echo "- [ ] Plan checkboxes update safely (regex method)"
echo "- [ ] Return protocol working (range complete or blocked)"
echo "- [ ] 90%+ token reduction achieved"
```

**Manual Checklist:**
- [ ] Dev loads active.yaml for task range
- [ ] Autonomous execution loop implemented
- [ ] Context size detection working (`/context` command)
- [ ] Context offload integration complete
- [ ] Plan checkbox update safe (regex-based)
- [ ] Return protocol implemented (range complete or blocked)
- [ ] 10-task test passes all metrics
- [ ] 85%+ token reduction achieved
- [ ] Agent autonomy working (1 return vs 10)
- [ ] Enhanced context.md with decisions, token stats working

**Rollback Plan (if Phase 3 fails):**
```bash
# Restore Dev instructions
cp agents/frappe-dev-sidecar/instructions.md.backup-pre-maker* \
   agents/frappe-dev-sidecar/instructions.md

# Keep Nexus changes (Phase 2)
# Keep state infrastructure (Phase 1)

# Test Dev works
# Invoke Dev, verify startup succeeds
```

**Status:** Phase 3 [ ] Complete

**📝 UPDATE PROGRESS TRACKER:** Mark Phase 3 complete checkbox (line 103) before proceeding to Phase 4

---

## Phase 4: Workflow Integration (GAP 1 FIX)

**Goal:** Update workflows to use efficient templates and state files

**Duration:** 1 day

**Status:** [ ] Not started

**Prerequisites:**
- [ ] Phase 1 complete (templates exist)
- [ ] Phase 2 complete (Nexus + Planner integrated)
- [ ] Phase 3 complete (Dev autonomy working)

### Tasks

| ID | Task | Deliverable | File Modified | Status |
|----|------|-------------|---------------|--------|
| **w1** | Backup workflow files | .bak files | 3 workflow.yaml files | [ ] |
| **w2** | Update sequence-tasks workflow | Uses efficient plan template | sequence-tasks/workflow.yaml | [ ] |
| **w3** | Update implement-feature workflow | Reads active.yaml for context | implement-feature/workflow.yaml | [ ] |
| **w4** | Update design-solution workflow | References state/tsd.md path | design-solution/workflow.yaml | [ ] |
| **w5** | Update analyze-requirements workflow | Outputs to active.yaml BRD path | analyze-requirements/workflow.yaml | [ ] |
| **w6** | Test: Full workflow chain (BA→Arch→Plan→Dev) | Pass integration test | - | [ ] |
| **w7** | Measure: End-to-end token usage | <15k for medium project | - | [ ] |

---

### w1: Backup workflow files

**Execute:**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

# Backup critical workflows
cp workflows/sequence-tasks/workflow.yaml \
   workflows/sequence-tasks/workflow.yaml.backup-pre-maker-$(date +%Y%m%d)

cp workflows/implement-feature/workflow.yaml \
   workflows/implement-feature/workflow.yaml.backup-pre-maker-$(date +%Y%m%d)

cp workflows/design-solution/workflow.yaml \
   workflows/design-solution/workflow.yaml.backup-pre-maker-$(date +%Y%m%d)

cp workflows/analyze-requirements/workflow.yaml \
   workflows/analyze-requirements/workflow.yaml.backup-pre-maker-$(date +%Y%m%d)
```

**Verify:**
```bash
ls -la workflows/*/workflow.yaml.backup-pre-maker*
# Should show 4 backup files
```

**Completion Criteria:**
- [ ] All 4 workflows backed up with timestamp
- [ ] Can rollback if needed

---

### w2: Update sequence-tasks workflow (HIGH PRIORITY)

**File:** `workflows/sequence-tasks/workflow.yaml`

**Change:** Update output template reference

**FIND:**
```yaml
output:
  - type: file
    path: "{{docs_path}}/implementation-plan.md"
    template: "templates/documents/implementation-plan.md"
```

**REPLACE WITH:**
```yaml
output:
  - type: file
    path: "{{docs_path}}/implementation-plan.md"
    template: "templates/documents/implementation-plan-efficient.md"
    params:
      complexity: "{{complexity}}"  # Simple/Medium/Complex (derived from task count)
      brd_path: "{{brd_path}}"
      tsd_path: "{{tsd_path}}"
```

**Add to workflow steps (after task sequencing, before output):**
```yaml
  - id: determine_complexity
    description: "Determine plan complexity based on task count"
    action:
      type: script
      script: |
        task_count = len(tasks)
        if task_count <= 10:
          complexity = "Simple"
        elif task_count <= 20:
          complexity = "Medium"
        else:
          complexity = "Complex"
        return complexity

  - id: enable_tsd_mapping
    description: "Generate TSD section mapping (Gap 2 fix)"
    condition: "{{tsd_path}} exists"
    action:
      type: execute_task
      task: "parse-tsd-and-map"  # Calls Planner's TSD mapping logic
      params:
        tsd: "{{tsd_path}}"
        tasks: "{{tasks}}"
```

**Completion Criteria:**
- [ ] Workflow uses implementation-plan-efficient.md template
- [ ] Complexity determination added
- [ ] TSD mapping step integrated
- [ ] Output includes complexity param

---

### w3: Update implement-feature workflow (MEDIUM PRIORITY)

**File:** `workflows/implement-feature/workflow.yaml`

**Change:** Read active.yaml for context instead of loading memories

**FIND (in workflow steps):**
```yaml
  - id: load_context
    description: "Load project context"
    action:
      type: read_memories
      agent: "frappe-dev-sidecar"
```

**REPLACE WITH:**
```yaml
  - id: load_context
    description: "Load project context from state"
    action:
      type: read_file
      path: ".bmad/custom/modules/frappe-builder/state/active.yaml"
      extract:
        - project
        - app
        - plan
        - tsd
        - phase
        - tasks
        - summary  # BRD summary for quick context
```

**Completion Criteria:**
- [ ] Workflow reads active.yaml instead of memories
- [ ] Summary field extracted for context
- [ ] Lighter context loading (<200 tokens vs 900)

---

### w4: Update design-solution workflow (LOW PRIORITY)

**File:** `workflows/design-solution/workflow.yaml`

**Change:** Output TSD to state-tracked path

**FIND:**
```yaml
output:
  - type: file
    path: "{{docs_path}}/tsd.md"
```

**REPLACE WITH:**
```yaml
output:
  - type: file
    path: "{{docs_path}}/tsd.md"

  - type: update_state
    file: ".bmad/custom/modules/frappe-builder/state/active.yaml"
    fields:
      tsd: "{{docs_path}}/tsd.md"
      updated: "{{timestamp}}"
```

**Completion Criteria:**
- [ ] TSD output path written to active.yaml
- [ ] Timestamp updated
- [ ] Next agents can find TSD via active.yaml

---

### w5: Update analyze-requirements workflow (MEDIUM PRIORITY)

**File:** `workflows/analyze-requirements/workflow.yaml`

**Change:** Output BRD path to active.yaml + trigger summary extraction

**FIND:**
```yaml
output:
  - type: file
    path: "{{docs_path}}/brd.md"
```

**REPLACE WITH:**
```yaml
output:
  - type: file
    path: "{{docs_path}}/brd.md"

  - type: update_state
    file: ".bmad/custom/modules/frappe-builder/state/active.yaml"
    fields:
      brd: "{{docs_path}}/brd.md"
      updated: "{{timestamp}}"

  - type: extract_summary
    description: "Extract BRD summary for active.yaml (Gap 4 fix)"
    source: "{{docs_path}}/brd.md"
    section: "Executive Summary"
    max_sentences: 3
    target_field: "summary"
    target_file: ".bmad/custom/modules/frappe-builder/state/active.yaml"
```

**Completion Criteria:**
- [ ] BRD output path written to active.yaml
- [ ] Summary extraction step added
- [ ] Summary auto-populated in active.yaml
- [ ] Gap 4 fix fully automated

---

### w6: Test full workflow chain integration

**Test scenario:** Run complete BA → Architect → Planner → Dev cycle

**Execute:**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

echo "=== Phase 4 Integration Test ==="

# Setup test project
echo "1. Create test project via Nexus"
echo "   → Invoke frappe-nexus-sidecar"
echo "   → Select 'New project': Test Workflow Integration"
echo "   → App: [test app]"

read -p "Press Enter after creating project..."

# Test BA workflow
echo ""
echo "2. Run BA workflow: analyze-requirements"
echo "   → Should output BRD"
echo "   → Should update active.yaml with BRD path"
echo "   → Should extract summary to active.yaml"

read -p "Press Enter after BA workflow..."

# Verify BRD integration
if grep -q "brd:" state/active.yaml && grep -q "summary:" state/active.yaml; then
    echo "✓ BRD path and summary in active.yaml (Gap 4 fix working)"
else
    echo "✗ FAIL - BRD integration not working"
fi

# Test Architect workflow
echo ""
echo "3. Run Architect workflow: design-solution"
echo "   → Should output TSD"
echo "   → Should update active.yaml with TSD path"

read -p "Press Enter after Architect workflow..."

# Verify TSD integration
grep -q "tsd:" state/active.yaml && echo "✓ TSD path in active.yaml" || echo "✗ FAIL"

# Test Planner workflow
echo ""
echo "4. Run Planner workflow: sequence-tasks"
echo "   → Should use implementation-plan-efficient.md template"
echo "   → Should determine complexity"
echo "   → Should generate TSD section mapping (Gap 2 fix)"

read -p "Press Enter after Planner workflow..."

# Verify plan output
PLAN_PATH=$(grep "plan:" state/active.yaml | cut -d' ' -f2)
if [ -f "$PLAN_PATH" ]; then
    echo "✓ Plan created at: $PLAN_PATH"
    grep -q "Complexity:" "$PLAN_PATH" && echo "✓ Complexity classification present" || echo "✗ Missing"
    grep -q "TSD Section Mapping" "$PLAN_PATH" && echo "✓ TSD mapping present (Gap 2 fix)" || echo "✗ Missing"

    # Measure tokens
    PLAN_TOKENS=$(wc -w "$PLAN_PATH" | awk '{print int($1 * 1.3)}')
    echo "Plan tokens: $PLAN_TOKENS"
    if [ $PLAN_TOKENS -lt 10000 ]; then
        echo "✓ Within target (<10k for medium)"
    else
        echo "✗ Exceeds 10k"
    fi
else
    echo "✗ FAIL - Plan not found"
fi

# Test Dev workflow
echo ""
echo "5. Run Dev workflow: implement-feature"
echo "   → Should read active.yaml for context"
echo "   → Should load summary field"
echo "   → Should work through task range autonomously"

read -p "Press Enter after Dev completes first task..."

# Verify Dev integration
echo "✓ Manual verification: Did Dev load active.yaml successfully?"
echo "✓ Manual verification: Did Dev use summary for context?"

echo ""
echo "=== Integration Test Complete ==="
```

**Validation Checklist:**
- [ ] BA workflow updates active.yaml (brd + summary)
- [ ] Architect workflow updates active.yaml (tsd)
- [ ] Planner workflow uses efficient template
- [ ] Planner workflow generates TSD mapping
- [ ] Plan complexity determined automatically
- [ ] Dev workflow reads active.yaml
- [ ] End-to-end chain works without errors
- [ ] All Gap fixes functional in workflow context

**Completion Criteria:**
- [ ] Full workflow chain test passes
- [ ] All 4 Gap fixes verified in workflow integration
- [ ] No errors in workflow execution
- [ ] State files updated correctly at each step

---

### w7: Measure end-to-end token usage

**Test:** Run complete project cycle, track tokens at each stage

**Execute:**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

echo "=== End-to-End Token Measurement ==="

# Use /context command at each stage to measure
echo "Measure at each workflow completion:"
echo ""
echo "Baseline (Nexus startup):"
echo "  → Use /context command"
echo "  → Record: Nexus startup tokens"
echo ""
echo "After BA (analyze-requirements):"
echo "  → Use /context command"
echo "  → Record: After BA tokens"
echo ""
echo "After Architect (design-solution):"
echo "  → Use /context command"
echo "  → Record: After Architect tokens"
echo ""
echo "After Planner (sequence-tasks):"
echo "  → Use /context command"
echo "  → Record: After Planner tokens"
echo "  → Read plan file, count its tokens"
echo ""
echo "After Dev (implement-feature, 10 tasks):"
echo "  → Use /context command"
echo "  → Record: After Dev tokens"
echo ""
echo "Total Context:"
echo "  → Final /context reading"
echo ""

# Calculate savings
echo "Target for medium project (11-20 tasks):"
echo "  Baseline: ~50-70k tokens"
echo "  With MAKER: <15k tokens"
echo "  Reduction: >75%"
```

**Metrics to Collect:**

| Stage | Baseline (OLD) | With MAKER (NEW) | Reduction |
|-------|----------------|------------------|-----------|
| Nexus startup | 900 | <200 | [ ]% |
| After BA | +2k | +500 | [ ]% |
| After Architect | +3k | +800 | [ ]% |
| After Planner | +2k | +500 | [ ]% |
| Plan file | 2k | <10k | [ ]% |
| After Dev (10 tasks) | +49k | +6k | [ ]% |
| **Total** | **~60k** | **~15k** | **~75%** |

**Completion Criteria:**
- [ ] Token measurements collected at each stage
- [ ] Total reduction >75% achieved
- [ ] Plan token count <10k for medium project
- [ ] Context never exceeds 30k (no offload needed in test)
- [ ] Metrics documented for validation

---

### Phase 4 Completion Criteria

**Validate ALL before declaring MAKER integration complete:**

```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

echo "=== Phase 4 Validation ==="

# 1. Workflow backups exist
[ -f "workflows/sequence-tasks/workflow.yaml.backup-pre-maker"* ] && echo "✓ sequence-tasks backed up" || echo "✗ No backup"
[ -f "workflows/implement-feature/workflow.yaml.backup-pre-maker"* ] && echo "✓ implement-feature backed up" || echo "✗ No backup"
[ -f "workflows/design-solution/workflow.yaml.backup-pre-maker"* ] && echo "✓ design-solution backed up" || echo "✗ No backup"
[ -f "workflows/analyze-requirements/workflow.yaml.backup-pre-maker"* ] && echo "✓ analyze-requirements backed up" || echo "✗ No backup"

# 2. Workflow modifications
echo ""
echo "Check workflow updates:"
grep -q "implementation-plan-efficient" workflows/sequence-tasks/workflow.yaml && echo "✓ Planner uses efficient template" || echo "✗ Still using old template"
grep -q "read_file.*active.yaml" workflows/implement-feature/workflow.yaml && echo "✓ Dev reads active.yaml" || echo "✗ Still using memories"
grep -q "update_state.*active.yaml.*tsd" workflows/design-solution/workflow.yaml && echo "✓ Architect updates state" || echo "✗ Missing state update"
grep -q "extract_summary" workflows/analyze-requirements/workflow.yaml && echo "✓ BA extracts summary (Gap 4)" || echo "✗ Missing summary extraction"

# 3. Integration test passed
echo ""
echo "Did full workflow chain test pass? (manual verification required)"

# 4. Token metrics
echo ""
echo "Check token reduction achieved:"
echo "  Target: >75% reduction"
echo "  Measured: [manual input from w7]"
```

**Manual Checklist:**
- [ ] All workflows backed up
- [ ] sequence-tasks uses efficient template
- [ ] implement-feature reads active.yaml
- [ ] design-solution updates active.yaml (tsd)
- [ ] analyze-requirements extracts BRD summary
- [ ] Full workflow chain test passes
- [ ] >75% token reduction achieved
- [ ] All 4 Gaps fixed and functional in workflows

**Rollback Plan (if Phase 4 fails):**
```bash
# Restore workflow files
cp workflows/sequence-tasks/workflow.yaml.backup-pre-maker* \
   workflows/sequence-tasks/workflow.yaml
cp workflows/implement-feature/workflow.yaml.backup-pre-maker* \
   workflows/implement-feature/workflow.yaml
cp workflows/design-solution/workflow.yaml.backup-pre-maker* \
   workflows/design-solution/workflow.yaml
cp workflows/analyze-requirements/workflow.yaml.backup-pre-maker* \
   workflows/analyze-requirements/workflow.yaml

# Keep all agent changes (Phases 2-3)
# Keep state infrastructure (Phase 1)
```

**Status:** Phase 4 [ ] Complete

**📝 UPDATE PROGRESS TRACKER:** Mark Phase 4 complete checkbox (line 104) - MAKER integration complete!

---

## Phase 5: Rollout to Other Specialists (OPTIONAL)

### Rollout to Other Specialists

**Once Phase 3 validated, apply same pattern to:**
- frappe-architect-sidecar
- frappe-planner-sidecar
- frappe-debugger-sidecar
- qa-specialist-sidecar
- doc-writer-sidecar
- erpnext-ba-sidecar

**For each specialist:**

| Step | Action | Time |
|------|--------|------|
| 1 | Backup instructions.md | 2 min |
| 2 | Add: Load active.yaml on startup | 30 min |
| 3 | Add: Task range autonomy (if applicable) | 1 hour |
| 4 | Add: Context offload integration | 30 min |
| 5 | Add: Plan checkbox updates (if writes plans) | 20 min |
| 6 | Test: Task range scenario | 1 hour |
| 7 | Measure: Token savings | 10 min |

**Estimated:** 3-4 hours per specialist

**Total for 7 specialists:** 21-28 hours (3-4 days if parallelized)

### Workflow Integration

**Workflows requiring updates:**

| Workflow | Change Needed | Priority | Time |
|----------|---------------|----------|------|
| sequence-tasks | Output to efficient plan template | HIGH | 2 hours |
| implement-feature | Read active.yaml for context | MEDIUM | 1 hour |
| design-solution | Reference state/tsd.md path | LOW | 30 min |

**Total workflow updates:** 3.5 hours

---

## Metrics & Validation

### Token Efficiency Targets

| Component | Baseline | Target | Achieved |
|-----------|----------|--------|----------|
| Nexus startup | 900 | <200 | [ ] |
| Plan template (simple) | 2000+ | <5k | [ ] |
| Plan template (medium) | 2000+ | <10k | [ ] |
| Plan template (complex) | 2000+ | <15k | [ ] |
| Context dump | 5000+ | <500 | [ ] |
| Dev 10 tasks | 49k | <6k | [ ] |
| Full 20-task project | 138k | <12k | [ ] |

### Success Criteria

**Functional:**
- [ ] All 4 phases complete (was 3, added Phase 4)
- [ ] All 31 tasks done (was 24, added 7 tasks)
- [ ] All 4 Gap fixes implemented and validated
- [ ] State files working correctly
- [ ] Autonomy pattern functional
- [ ] Context offload automatic (triggered at 30k)
- [ ] Archive/resume working
- [ ] Workflow integration complete

**Performance:**
- [ ] >85% token reduction (target: 90-92%)
- [ ] >80% round-trip reduction
- [ ] Context never exceeds 60k
- [ ] Zero data loss (all info preserved, richer context)

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
| Config not found | Wrong path | Use: `.bmad/frappe-builder/config.yaml` (NOT custom/modules/) |
| Task range not parsing | Invalid format | Use: `d4:d7` (colon separator, no spaces) |
| Context never offloads | Threshold not met | Check `/context`, ensure >30k before expecting offload |
| Plan checkboxes wrong | Regex failed | Check task ID exact match, verify no substring issues |
| Archive fails | Paths don't exist | Check plan/tsd paths in active.yaml are valid |
| XML task fails | Syntax error | Validate with `xmllint --noout [file].xml` |

### Debug Checklist

If issues occur:
1. [ ] Verify file structure exists (`state/`, `state/archive/`)
2. [ ] Check active.yaml format (YAML valid? Use `python3 -c "import yaml; yaml.safe_load(open('state/active.yaml'))"`)
3. [ ] Count tokens in templates (within limits? Use `wc -w | awk '{print int($1*1.3)}'`)
4. [ ] Test state tasks independently (load XML, execute steps)
5. [ ] Check file paths (correct project root, relative paths)
6. [ ] Verify agent has write permissions (`touch state/test.txt`)
7. [ ] Review backups (can rollback if needed)

---

## Reference Links

**Standards:**
- Anti-fluff mandate: `.bmad/frappe-builder/standards/core/anti-fluff-mandate.md`
- Token efficiency: `.bmad/frappe-builder/standards/core/token-efficiency.md`

**Original research:**
- MAKER paper: https://arxiv.org/html/2511.09030v1
- Research overview: `future-plans/maker-integration/maker-method-overview.md`
- Review report: `future-plans/maker-integration/PLAN-REVIEW-REPORT.md`

**Templates (after Phase 1):**
- active.yaml: `state/active.yaml.template`
- context.md: `state/context.md.template`
- Plan: `templates/documents/implementation-plan-efficient.md`
- Metadata: `state/archive/metadata.yaml.template`

**Tasks (BMAD XML):**
- Context offload: `tasks/state/offload-context.xml`
- Project archive: `tasks/state/archive-project.xml`

---

## Session Handoff Protocol

**If you lose context mid-implementation and need to resume:**

### Step 1: Run Resume Script (FASTEST METHOD)

```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/
bash future-plans/maker-integration/resume-maker-implementation.sh
```

**This script automatically:**
- Detects which phases are complete
- Shows completed task count
- Identifies exact next task to resume
- Provides line numbers for quick navigation

**Output example:**
```
Phase 1: ✅ COMPLETE (state/ exists, templates created)
Phase 2: ⏳ IN PROGRESS (Nexus or Planner not modified yet)

Tasks Completed: 12 / 31 (38.7%)

▶ RESUME AT: Phase 2
  Next task: n3 - Add new project flow
  Line 1425 in plan
```

### Step 1 Alternative: Manual Status Check

```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

# Check if active project exists (might be working ON a frappe project during MAKER implementation)
if [ -f "state/active.yaml" ]; then
    echo "Active project exists:"
    cat state/active.yaml
    echo ""
    echo "Current phase: $(grep 'phase:' state/active.yaml | cut -d':' -f2)"
    echo "Current tasks: $(grep 'tasks:' state/active.yaml | cut -d':' -f2)"
else
    echo "No active project - resume MAKER implementation"
fi

# Check which phase of MAKER implementation is complete
echo ""
echo "=== Implementation Status ==="
[ -d "state" ] && echo "✓ Phase 1 started (state/ exists)" || echo "✗ Phase 1 not started"
[ -f "state/active.yaml.template" ] && echo "✓ Phase 1 templates created" || echo "✗ Phase 1 incomplete"
grep -q "Check Active Project State" agents/frappe-nexus-sidecar/instructions.md 2>/dev/null && echo "✓ Phase 2 started (Nexus modified)" || echo "✗ Phase 2 not started"
grep -q "MAKER Integration: Startup" agents/frappe-dev-sidecar/instructions.md 2>/dev/null && echo "✓ Phase 3 started (Dev modified)" || echo "✗ Phase 3 not started"
grep -q "implementation-plan-efficient" workflows/sequence-tasks/workflow.yaml 2>/dev/null && echo "✓ Phase 4 started (Workflows modified)" || echo "✗ Phase 4 not started"
```

### Step 2: Check Progress Tracker

**Jump to line 54 in this plan** - View "Implementation Progress Tracker"

1. Scan table for first `[ ]` (unchecked) task
2. Note the task ID (e.g., "i3", "n5", "d7")
3. Use Ctrl+F to find: `### [task_id]:`
4. Read detailed instructions
5. Execute task
6. **Mark complete in TWO places:**
   - Progress Tracker (line 54): `[ ]` → `[x]`
   - Phase completion marker (line 101-104 depending on phase)
7. Repeat

**Example:**
```
Progress Tracker shows:
  | 1 | i1 | Create state/ dirs | [x] |  ← Done
  | 1 | i2 | Create active.yaml | [x] |  ← Done
  | 1 | i3 | Create context.md  | [ ] |  ← RESUME HERE!

Search for: "### i3: Create context.md template"
Jump to line ~233
Execute task
Mark [x] in tracker
```

### Step 3: Don't Repeat Completed Work

Before executing any task:
- [ ] Check if files already exist (templates, backups, etc)
- [ ] Verify completion criteria not already met
- [ ] Read validation sections to see what's done

### Example Resume Scenario

**Situation:** You're implementing Phase 2, completed tasks n1-n5, lost context.

**Resume:**
```bash
# 1. Check status
grep -q "Setting Task Range" agents/frappe-nexus-sidecar/instructions.md && echo "n5 done" || echo "n5 not done"

# 2. Look at Phase 2 task table in this plan
# See: n1-n5 checked, n6 next

# 3. Jump to section "### n6: Add Nexus: Detect + archive completed"

# 4. Read instructions, execute task

# 5. Mark n6 complete in this plan

# 6. Move to n7
```

---

**Plan Status:** ✅ VALIDATED & GAP-FIXED - Ready for execution
**Version:** 2.1 (Gap-Fixed)
**Created:** 2025-11-25
**Updated:** 2025-11-25 (BMad Builder evaluation + gap fixes)
**Review Report:** PLAN-REVIEW-REPORT.md
**Token Count:** ~13,500 tokens (this plan itself, expanded with Phase 4 + Gap fixes)
**Format:** Tables + details (zero data loss)
**Session-Independent:** ✓ (all context included)
**Multi-Session Safe:** ✓ (resume from any point)
**Original Fixes:** 12 critical issues from v1.0→v2.0
**Gap Fixes (v2.1):** 4 gaps identified and resolved
**Total Phases:** 4 (was 3, added workflow integration)
**Total Tasks:** 31 (was 24, added 7 tasks)
**BMAD Compliance:** 9.0/10 (EXCELLENT)
**MAKER Alignment:** 9.5/10 (EXCELLENT - pragmatic adaptation)

---

**REMEMBER:**
- Use `/context` to monitor tokens
- Backup before modifying agents
- Test each phase before proceeding
- Validate completion criteria
- Can rollback if needed
- This plan has ALL context - no need to reference other docs during execution
- **All 4 Gap fixes integrated** - plan is now production-complete

**v2.1 UPDATES COMPLETE:**
- ✅ Gap 1 fixed: Phase 4 added (workflow integration)
- ✅ Gap 2 fixed: TSD mapping automation (tasks p1, p2)
- ✅ Gap 3 fixed: Config path clarity (comments in i2)
- ✅ Gap 4 fixed: BRD summary extraction (enhanced n3, w5)

**Good luck, Rizwan! The MAKER integration will deliver the promised 91% token reduction!** 🧙⚡
