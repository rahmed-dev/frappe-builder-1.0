# MAKER Integration - Agent Analysis

**Date:** 2025-11-25
**Purpose:** Determine which agents need MAKER integration updates

---

## Current Status

### ✅ Already Updated (Phases 2-3):
1. **frappe-nexus-sidecar** (Phase 2 - n1-n7)
   - Loads active.yaml on startup
   - Creates/resumes/archives projects
   - Routes to specialists with task ranges
   - Manages project lifecycle

2. **frappe-planner-sidecar** (Phase 2 - p1-p2, Phase 4 - w2)
   - Loads efficient template
   - Generates TSD mapping
   - Determines complexity

3. **frappe-dev-sidecar** (Phase 3 - d1-d7)
   - Loads active.yaml for task range
   - Autonomous execution loop
   - Context offload integration
   - Updates plan checkboxes

---

## 🔍 Agent Roles & MAKER Needs Analysis

### 1. ERPNext BA (Business Analyst)
**Role:** Analyze business requirements, create BRD
**Current State:** Loads config, asks for app, follows bench awareness

**MAKER Integration Needed:** ✅ **YES - HIGH PRIORITY**

**Why:**
- Creates BRD documents (should update active.yaml with BRD path)
- Should extract summary to active.yaml (Gap 4 fix)
- Nexus routes projects to BA first
- BA output feeds Architect

**What to Add:**
1. Load active.yaml on startup (if project exists)
2. After creating BRD: Update active.yaml with:
   - `brd: "[path]"`
   - `summary: "[extracted from Executive Summary]"`
   - `updated: "[timestamp]"`
3. Use project context from active.yaml (project name, app)

**Benefits:**
- Consistent with workflow integration (w5)
- BA agent behavior matches analyze-requirements workflow
- Auto-tracking of BRD artifacts
- Gap 4 fix works in agent mode too

---

### 2. Frappe Architect
**Role:** Design technical solutions, create TSD
**Current State:** Loads config, asks for app, follows bench awareness

**MAKER Integration Needed:** ✅ **YES - HIGH PRIORITY**

**Why:**
- Creates TSD documents (should update active.yaml with TSD path)
- Receives BRD from BA (should read BRD path from active.yaml)
- Should use summary field for quick context
- Architect output feeds Planner

**What to Add:**
1. Load active.yaml on startup
   - Get BRD path automatically
   - Get summary for context
   - Know current app/project
2. After creating TSD: Update active.yaml with:
   - `tsd: "[path]"`
   - `updated: "[timestamp]"`
3. Read BRD from active.yaml path (don't ask user)

**Benefits:**
- Consistent with workflow integration (w4)
- Architect agent behavior matches design-solution workflow
- Auto-finds BRD (no manual path entry)
- Auto-tracks TSD artifacts

---

### 3. QA Specialist
**Role:** Create test scenarios, test plans
**Current State:** Unknown startup behavior

**MAKER Integration Needed:** ⚠️ **MAYBE - MEDIUM PRIORITY**

**Why:**
- QA validates implementation (needs context)
- Should know what's being tested (BRD summary helpful)
- Should reference TSD for test coverage
- May need to know task ranges being tested

**What to Add:**
1. Load active.yaml on startup
   - Get BRD path (requirements coverage)
   - Get TSD path (design coverage)
   - Get plan path (test against implementation plan)
   - Get summary for context
2. Optionally: Track test results in state

**Benefits:**
- QA has full context of what to test
- Can verify coverage against BRD/TSD
- Token-efficient context loading

**Note:** Less critical than BA/Architect since QA comes later in flow

---

### 4. Doc Writer
**Role:** Write user documentation
**Current State:** Unknown startup behavior

**MAKER Integration Needed:** ⚠️ **MAYBE - LOW PRIORITY**

**Why:**
- Docs describe implemented features
- Should reference BRD (what features exist)
- Should reference TSD (technical details)
- May need implementation plan context

**What to Add:**
1. Load active.yaml on startup
   - Get BRD path (feature list)
   - Get TSD path (technical details)
   - Get summary for overview
2. Optionally: Track documentation artifacts in state

**Benefits:**
- Doc writer has full context
- Can ensure docs match requirements
- Token-efficient context

**Note:** Lowest priority - docs come last, often standalone

---

### 5. Frappe Debugger
**Role:** Debug production issues, troubleshoot errors
**Current State:** Unknown startup behavior

**MAKER Integration Needed:** ❓ **QUESTIONABLE - LOW PRIORITY**

**Why:**
- Debugging is often ad-hoc, not project-lifecycle
- May not always have active project
- Operates on existing code, not new development

**What to Add (if useful):**
1. Load active.yaml if exists
   - Get app context
   - Get implementation artifacts for reference
2. BUT: Should work without active.yaml (standalone debugging)

**Benefits:**
- Minimal - debugger is often independent of project state
- May help in "debug feature X from plan" scenarios

**Note:** Lowest priority - may not need MAKER integration at all

---

## 📊 Priority Matrix

| Agent | Priority | Reason | Consistency With |
|-------|----------|--------|------------------|
| **ERPNext BA** | 🔴 **HIGH** | Creates BRD, Gap 4 fix needed | analyze-requirements workflow (w5) |
| **Frappe Architect** | 🔴 **HIGH** | Creates TSD, auto-find BRD | design-solution workflow (w4) |
| **QA Specialist** | 🟡 **MEDIUM** | Needs context, less critical timing | Testing workflows (future) |
| **Doc Writer** | 🟢 **LOW** | Standalone, post-implementation | Documentation workflows (future) |
| **Frappe Debugger** | ⚪ **OPTIONAL** | Often standalone, ad-hoc use | N/A |

---

## 🎯 Recommendation

### Phase 4 Extension (Phase 4B):

**Must Have (Complete MAKER integration):**
1. ✅ Update ERPNext BA agent (align with w5)
2. ✅ Update Frappe Architect agent (align with w4)

**Should Have (For completeness):**
3. ⚠️ Update QA Specialist agent (future-proofing)

**Nice to Have (Optional):**
4. 🟢 Update Doc Writer agent (if time permits)
5. ⚪ Consider Debugger (probably skip)

---

## 🔍 Consistency Check

### Workflow vs Agent Parity:

| Workflow | Agent Equivalent | Status |
|----------|------------------|--------|
| analyze-requirements | ERPNext BA | ❌ **MISMATCH** - workflow updated (w5), agent NOT |
| design-solution | Frappe Architect | ❌ **MISMATCH** - workflow updated (w4), agent NOT |
| implement-feature | Frappe Dev | ✅ **MATCH** - both updated |
| sequence-tasks | Frappe Planner | ✅ **MATCH** - both updated |

**Conclusion:** BA and Architect agents are OUT OF SYNC with their workflows!

---

## 📝 Task Breakdown (Phase 4B)

### Task: Update ERPNext BA Agent
**File:** `agents/erpnext-ba-sidecar/instructions.md`

**Changes:**
1. Add startup step: Load active.yaml (if exists)
2. Add completion step: Update active.yaml after BRD creation
   - Set `brd` path
   - Extract and set `summary` (Gap 4 fix)
   - Set `updated` timestamp

**Align with:** `workflows/analyze-requirements/instructions.md` (Step 9)

---

### Task: Update Frappe Architect Agent
**File:** `agents/frappe-architect-sidecar/instructions.md`

**Changes:**
1. Add startup step: Load active.yaml
   - Auto-find BRD path
   - Load summary for context
2. Add completion step: Update active.yaml after TSD creation
   - Set `tsd` path
   - Set `updated` timestamp

**Align with:** `workflows/design-solution/instructions.md` (Step 12)

---

### Task: Update QA Specialist Agent (Optional)
**File:** `agents/qa-specialist-sidecar/instructions.md`

**Changes:**
1. Add startup step: Load active.yaml (if exists)
   - Get BRD, TSD, plan paths
   - Load summary for context

---

## 🚀 Action Required

**Decision Point:** Should we extend Phase 4 to include BA and Architect agents?

**Options:**
1. **Option A: Add as Phase 4B** (Recommended)
   - Tasks: Update BA (high), Architect (high), QA (medium)
   - Effort: ~1-2 hours
   - Result: Complete MAKER consistency across agents + workflows

2. **Option B: Defer to Phase 5**
   - Keep Phase 4 as "workflow integration only"
   - Create new phase for "agent integration"
   - Risk: Inconsistency between workflow and agent behavior

3. **Option C: Skip agent updates**
   - Workflows have MAKER, agents don't
   - Risk: Confusion when using agents vs workflows
   - Not recommended - breaks consistency principle

---

## ✅ Recommendation: Add Phase 4B

**Rationale:**
- BA and Architect are high-touch agents (used frequently)
- Workflow-agent parity is critical for user experience
- Gap 4 fix should work in BOTH agent and workflow modes
- Small effort (2 agents), high impact (consistency)

**Tasks:**
- [ ] Backup BA and Architect instructions
- [ ] Update BA: Load active.yaml, update after BRD creation
- [ ] Update Architect: Load active.yaml, auto-find BRD, update after TSD
- [ ] Optional: Update QA Specialist
- [ ] Test: Create project, use BA agent, verify state updates
- [ ] Test: Use Architect agent, verify auto-finds BRD

---

**Status:** Awaiting Rizwan's decision on Phase 4B extension
