# Phase 4B: Agent MAKER Integration - Implementation Plan

**Project:** frappe-builder MAKER agent consistency
**Goal:** Update remaining agents to match workflow MAKER integration
**Status:** ⏳ NOT STARTED
**Version:** 1.0
**Date:** 2025-11-25
**Parent Plan:** IMPLEMENTATION-PLAN-CORRECTED.md (Phase 4 extension)

---

## CRITICAL: Read This First

**SESSION INDEPENDENCE:**
This plan is designed for multi-session execution. If you lose context mid-implementation:

**METHOD 1 (FASTEST):**
Jump to **Progress Tracker** (line 45) and find first unchecked `[ ]` task

**METHOD 2 (RESUME):**
1. Check Progress Tracker table
2. Find first `[ ]` task
3. Search for `### [task_id]:`
4. Resume from that section

---

## Quick Reference

| Item | Value |
|------|-------|
| **Project root** | `/home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/` |
| **Total tasks** | 8 tasks |
| **Current phase** | Phase 4B (Agent Integration) |
| **Estimated duration** | 2-3 hours |
| **Priority** | HIGH (consistency with workflows) |

---

## 📋 Implementation Progress Tracker

**CRITICAL FOR MULTI-SESSION:** Mark tasks as complete here. After context loss, check this table to resume instantly.

| Phase | ID | Task Description | Status |
|-------|----|--------------------|--------|
| **4B** | a1 | Backup BA agent instructions | [ ] |
| **4B** | a2 | Update BA: Load active.yaml on startup | [ ] |
| **4B** | a3 | Update BA: Update state after BRD creation | [ ] |
| **4B** | a4 | Backup Architect agent instructions | [ ] |
| **4B** | a5 | Update Architect: Load active.yaml on startup | [ ] |
| **4B** | a6 | Update Architect: Update state after TSD creation | [ ] |
| **4B** | a7 | Test BA agent with MAKER integration | [ ] |
| **4B** | a8 | Test Architect agent with MAKER integration | [ ] |

**Phase Completion Marker:**
- [ ] Phase 4B Complete (all a* tasks done + validation passed)

**Quick Status Check:**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/
grep -c "\[x\]" future-plans/maker-integration/PHASE-4B-AGENT-INTEGRATION.md
# Shows count of completed tasks
```

---

## Why Phase 4B?

### Problem Identified:
Phase 4 updated **workflows** to use MAKER state management, but the corresponding **agents** were NOT updated. This creates inconsistency:

| Component | MAKER Status | Issue |
|-----------|--------------|-------|
| analyze-requirements workflow | ✅ Updated (w5) | Extracts BRD summary |
| ERPNext BA agent | ❌ NOT updated | Doesn't extract summary |
| design-solution workflow | ✅ Updated (w4) | Updates TSD path |
| Frappe Architect agent | ❌ NOT updated | Doesn't update state |

**Result:** Users get different behavior when using workflow vs agent!

### Solution:
Update BA and Architect agents to match their workflow counterparts.

---

## Agent Priority Analysis

### ✅ Already Updated (Phases 2-3):
- frappe-nexus-sidecar (orchestrator)
- frappe-planner-sidecar (planner)
- frappe-dev-sidecar (developer)

### 🔴 HIGH PRIORITY (Phase 4B):
1. **ERPNext BA** - Creates BRD, needs Gap 4 fix
2. **Frappe Architect** - Creates TSD, needs state tracking

### 🟡 MEDIUM PRIORITY (Future Phase):
3. **QA Specialist** - Needs context, less critical
4. **Doc Writer** - Standalone, low urgency

### ⚪ OPTIONAL (May skip):
5. **Frappe Debugger** - Often standalone, ad-hoc

**This plan covers:** HIGH PRIORITY agents only (BA + Architect)

---

## 📝 Detailed Task Breakdown

### a1: Backup BA agent instructions

**File:** `agents/erpnext-ba-sidecar/instructions.md`

**Execute:**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

cp agents/erpnext-ba-sidecar/instructions.md \
   agents/erpnext-ba-sidecar/instructions.md.backup-pre-maker-$(date +%Y%m%d)
```

**Verify:**
```bash
ls -la agents/erpnext-ba-sidecar/*.backup-pre-maker*
# Should show backup file with today's date
```

**Completion Criteria:**
- [ ] instructions.md backed up with timestamp
- [ ] Can rollback if needed

**Status:** [ ] Not started

---

### a2: Update BA: Load active.yaml on startup

**File:** `agents/erpnext-ba-sidecar/instructions.md`

**Find the section:** "FRAPPE BENCH AWARENESS" → "Startup Sequence"

**After step where config is loaded, ADD new section:**

```markdown
## MAKER Integration: Project State Awareness

### Load Active Project (If Exists)

**After loading config, before asking user for app:**

```yaml
OPTIONAL_FILE: {project-root}/.bmad/custom/modules/frappe-builder/state/active.yaml
```

**If active.yaml exists:**
1. Read and extract:
   - `project`: Project name
   - `app`: Current Frappe app
   - `brd`: BRD path (if already created)
   - `plan`: Plan path (if exists)
   - `summary`: Project summary
   - `notes`: Critical notes

2. Use extracted values:
   - Skip asking for app (use `app` from active.yaml)
   - Show project context: "Working on project: {project}"
   - If BRD exists: "BRD already created at: {brd}"

**If active.yaml does NOT exist:**
- Continue normal flow (ask user for app)
- This is a new project or no Nexus routing

**Benefits:**
- Auto-resumes project context
- No repeated "which app?" questions
- Knows if BRD already exists (can offer to update vs create)
```

**Location:** Insert after "Load Config" step, before "Ask User for Current App" step

**Completion Criteria:**
- [ ] Section added to instructions.md
- [ ] Positioned correctly in startup sequence
- [ ] Covers both "active.yaml exists" and "doesn't exist" cases

**Status:** [ ] Not started

---

### a3: Update BA: Update state after BRD creation

**File:** `agents/erpnext-ba-sidecar/instructions.md`

**Find the section:** Where BRD is saved (search for "Save.*BRD" or similar)

**After BRD is saved, ADD new section:**

```markdown
## MAKER Integration: Update Project State After BRD Creation

**After saving BRD document, update active.yaml:**

### Step 1: Extract BRD Summary (GAP 4 FIX)

**Critical:** Auto-extract summary for token efficiency

1. Read the saved BRD file
2. Locate "Executive Summary" section
3. Extract first 3 sentences (or up to 150 words)
4. This becomes the project summary for all agents

**Example extraction:**
```
BRD Executive Summary:
"The customer needs a custom approval workflow for Purchase Requisitions
exceeding $10,000. The workflow must route through Department Head, then
Finance Manager, then CEO. Email notifications are required at each stage."

Extracted Summary (3 sentences):
"The customer needs a custom approval workflow for Purchase Requisitions
exceeding $10,000. The workflow must route through Department Head, then
Finance Manager, then CEO. Email notifications are required at each stage."
```

### Step 2: Update active.yaml

**File to Update:** `{project-root}/.bmad/custom/modules/frappe-builder/state/active.yaml`

**If active.yaml exists:**
```python
# Read existing active.yaml
# Update these fields:
brd: "{{docs_path}}/brd/[filename].md"
summary: "[Extracted 3 sentences from Executive Summary]"
updated: "[Current timestamp]"
# Write back to active.yaml
```

**If active.yaml does NOT exist:**
- Inform user: "No active.yaml found. Use Nexus to initialize project state."
- Still save BRD normally
- State tracking will start when Nexus is used

### Benefits:
- Architect agent can auto-find BRD
- All agents get consistent project summary (<50 tokens)
- Gap 4 fix: Automated summary extraction (no manual work)
- State-based coordination enabled
```

**Location:** Insert after "Save BRD" step, before "Next Steps" or handoff section

**Completion Criteria:**
- [ ] Summary extraction logic documented
- [ ] active.yaml update instructions added
- [ ] Gap 4 fix explicitly mentioned
- [ ] Handles both "active.yaml exists" and "doesn't exist" cases

**Status:** [ ] Not started

---

### a4: Backup Architect agent instructions

**File:** `agents/frappe-architect-sidecar/instructions.md`

**Execute:**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

cp agents/frappe-architect-sidecar/instructions.md \
   agents/frappe-architect-sidecar/instructions.md.backup-pre-maker-$(date +%Y%m%d)
```

**Verify:**
```bash
ls -la agents/frappe-architect-sidecar/*.backup-pre-maker*
# Should show backup file with today's date
```

**Completion Criteria:**
- [ ] instructions.md backed up with timestamp
- [ ] Can rollback if needed

**Status:** [ ] Not started

---

### a5: Update Architect: Load active.yaml on startup

**File:** `agents/frappe-architect-sidecar/instructions.md`

**Find the section:** "FRAPPE BENCH AWARENESS" → "Startup Sequence"

**After step where config is loaded, ADD new section:**

```markdown
## MAKER Integration: Project State & BRD Discovery

### Load Active Project (If Exists)

**After loading config, before asking user for app:**

```yaml
OPTIONAL_FILE: {project-root}/.bmad/custom/modules/frappe-builder/state/active.yaml
```

**If active.yaml exists:**
1. Read and extract:
   - `project`: Project name
   - `app`: Current Frappe app
   - `brd`: BRD path (auto-find BRD!)
   - `summary`: Project summary (quick context)
   - `tsd`: TSD path (if already created)
   - `notes`: Critical notes

2. Use extracted values:
   - Skip asking for app (use `app` from active.yaml)
   - Show project context: "Working on project: {project}"
   - Show summary: "{summary}"
   - **Auto-find BRD:** "BRD found at: {brd}"
   - If TSD exists: "TSD already created at: {tsd}"

3. Load BRD automatically:
   - Read BRD from `brd` path
   - Don't ask user for BRD location
   - You have everything needed to start designing

**If active.yaml does NOT exist:**
- Continue normal flow (ask user for BRD location)
- This is a new project or no Nexus routing

**Benefits:**
- No "where's the BRD?" questions (auto-found!)
- Instant project context from summary (<50 tokens vs 1000+ for full BRD)
- Knows if TSD already exists (can offer to update vs create)
- Seamless handoff from BA
```

**Location:** Insert after "Load Config" step, before "Ask User for Current App" step

**Completion Criteria:**
- [ ] Section added to instructions.md
- [ ] Auto-finds BRD from active.yaml
- [ ] Loads summary for context
- [ ] Positioned correctly in startup sequence
- [ ] Covers both "active.yaml exists" and "doesn't exist" cases

**Status:** [ ] Not started

---

### a6: Update Architect: Update state after TSD creation

**File:** `agents/frappe-architect-sidecar/instructions.md`

**Find the section:** Where TSD is saved (search for "Save.*TSD" or similar)

**After TSD is saved, ADD new section:**

```markdown
## MAKER Integration: Update Project State After TSD Creation

**After saving TSD document, update active.yaml:**

### Update active.yaml

**File to Update:** `{project-root}/.bmad/custom/modules/frappe-builder/state/active.yaml`

**If active.yaml exists:**
```python
# Read existing active.yaml
# Update these fields:
tsd: "{{docs_path}}/tsd/[filename].md"
updated: "[Current timestamp]"
# Write back to active.yaml
```

**Fields to Update:**
- `tsd`: Path to created TSD document
- `updated`: Current timestamp

**If active.yaml does NOT exist:**
- Inform user: "No active.yaml found. Use Nexus to initialize project state."
- Still save TSD normally
- State tracking will start when Nexus is used

### Benefits:
- Planner agent can auto-find TSD
- Dev agent can auto-find TSD
- All agents know TSD is ready
- State-based coordination enabled
- Seamless handoff to Planner
```

**Location:** Insert after "Save TSD" step, before "Next Steps" or handoff section

**Completion Criteria:**
- [ ] active.yaml update instructions added
- [ ] TSD path tracking documented
- [ ] Handles both "active.yaml exists" and "doesn't exist" cases

**Status:** [ ] Not started

---

### a7: Test BA agent with MAKER integration

**Test scenario:** Use BA agent to create BRD, verify state updates

**Prerequisites:**
- [ ] Tasks a1-a3 complete
- [ ] Have a test Frappe app ready
- [ ] `state/` directory exists

**Test Steps:**

#### 1. Setup Test Project via Nexus
```bash
# Invoke frappe-nexus agent
# Select: "New project"
# Name: "Test BA Agent MAKER Integration"
# App: [your test app name]
```

**Verify:**
- [ ] `state/active.yaml` created
- [ ] Contains: project, app fields

---

#### 2. Invoke ERPNext BA Agent
```bash
# Invoke erpnext-ba agent
# Agent should auto-load active.yaml
# Agent should show project context
# Agent should know the app (not ask again)
```

**Verify:**
- [ ] BA loads active.yaml on startup
- [ ] BA displays project name
- [ ] BA doesn't ask for app (uses value from active.yaml)

---

#### 3. Create BRD via BA Agent
```bash
# Provide sample requirements to BA
# BA analyzes and creates BRD
# BA should auto-update active.yaml
```

**Verify:**
- [ ] BRD saved to `docs/brd/brd-*.md`
- [ ] `state/active.yaml` updated with `brd:` path
- [ ] `state/active.yaml` contains `summary:` field with extracted text
- [ ] Summary is 3 sentences from Executive Summary section
- [ ] Gap 4 fix working (auto-extraction, no manual input)

**Check:**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/
grep "brd:" state/active.yaml
grep "summary:" state/active.yaml

# Verify summary is from BRD
BRD_PATH=$(grep "brd:" state/active.yaml | cut -d' ' -f2)
head -50 "$BRD_PATH" | grep -A5 "Executive Summary"
```

---

#### 4. Test Resume Scenario
```bash
# Exit BA agent
# Invoke BA agent again
# BA should resume project context
```

**Verify:**
- [ ] BA loads active.yaml on second invocation
- [ ] BA shows existing BRD path
- [ ] BA offers to update vs create new BRD

---

**Test Completion Criteria:**
- [ ] BA loads active.yaml correctly
- [ ] BA updates active.yaml after BRD creation
- [ ] Summary extraction working (Gap 4 fix)
- [ ] Resume scenario working
- [ ] No errors during execution

**Status:** [ ] Not started

---

### a8: Test Architect agent with MAKER integration

**Test scenario:** Use Architect agent after BA, verify auto-finds BRD

**Prerequisites:**
- [ ] Task a7 complete (BA test passed)
- [ ] BRD exists in active.yaml from a7
- [ ] Tasks a4-a6 complete

**Test Steps:**

#### 1. Invoke Frappe Architect Agent
```bash
# Invoke frappe-architect agent
# Agent should auto-load active.yaml
# Agent should auto-find BRD
# Agent should display project summary
```

**Verify:**
- [ ] Architect loads active.yaml on startup
- [ ] Architect displays project name
- [ ] Architect shows summary (quick context)
- [ ] Architect displays BRD path (auto-found!)
- [ ] Architect doesn't ask "where's the BRD?" (major win!)
- [ ] Architect loads BRD automatically

---

#### 2. Create TSD via Architect Agent
```bash
# Architect analyzes BRD
# Architect creates TSD
# Architect should auto-update active.yaml
```

**Verify:**
- [ ] TSD saved to `docs/tsd/tsd-*.md`
- [ ] `state/active.yaml` updated with `tsd:` path
- [ ] Timestamp updated

**Check:**
```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/
grep "tsd:" state/active.yaml
```

---

#### 3. Test Resume Scenario
```bash
# Exit Architect agent
# Invoke Architect agent again
# Architect should resume project context
```

**Verify:**
- [ ] Architect loads active.yaml on second invocation
- [ ] Architect shows existing BRD and TSD paths
- [ ] Architect offers to update vs create new TSD

---

#### 4. Test Handoff to Planner
```bash
# Invoke frappe-planner agent
# Planner should auto-find TSD
```

**Verify:**
- [ ] Planner loads active.yaml
- [ ] Planner auto-finds TSD path
- [ ] Planner can proceed without asking for TSD location

---

**Test Completion Criteria:**
- [ ] Architect loads active.yaml correctly
- [ ] Architect auto-finds BRD (doesn't ask user)
- [ ] Architect uses summary for context
- [ ] Architect updates active.yaml after TSD creation
- [ ] Resume scenario working
- [ ] Handoff to Planner seamless
- [ ] No errors during execution

**Status:** [ ] Not started

---

## 🧪 Validation Script

**Create:** `validate-phase4b.sh`

```bash
#!/bin/bash
# Phase 4B Validation Script
# Checks that BA and Architect agent modifications are in place

cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

echo "========================================"
echo "Phase 4B Agent Integration Validation"
echo "========================================"
echo ""

# a1 & a4: Check backups
echo "=== Backups ==="
if [ -f "agents/erpnext-ba-sidecar/instructions.md.backup-pre-maker"* ]; then
    echo "✓ BA agent backed up"
else
    echo "✗ BA agent backup missing"
fi

if [ -f "agents/frappe-architect-sidecar/instructions.md.backup-pre-maker"* ]; then
    echo "✓ Architect agent backed up"
else
    echo "✗ Architect agent backup missing"
fi
echo ""

# a2: Check BA startup
echo "=== BA Agent: Load active.yaml on startup ==="
if grep -q "MAKER Integration.*Project State" agents/erpnext-ba-sidecar/instructions.md; then
    echo "✓ BA loads active.yaml section exists"
else
    echo "✗ BA startup section missing"
fi
echo ""

# a3: Check BA state update
echo "=== BA Agent: Update state after BRD ==="
if grep -q "Update Project State After BRD" agents/erpnext-ba-sidecar/instructions.md; then
    echo "✓ BA state update section exists"
else
    echo "✗ BA state update section missing"
fi

if grep -q "GAP 4 FIX" agents/erpnext-ba-sidecar/instructions.md; then
    echo "✓ Gap 4 fix mentioned in BA agent"
else
    echo "✗ Gap 4 fix not mentioned"
fi

if grep -q "first 3 sentences\|up to 150 words" agents/erpnext-ba-sidecar/instructions.md; then
    echo "✓ Summary extraction logic documented"
else
    echo "✗ Summary extraction logic missing"
fi
echo ""

# a5: Check Architect startup
echo "=== Architect Agent: Load active.yaml on startup ==="
if grep -q "MAKER Integration.*BRD Discovery" agents/frappe-architect-sidecar/instructions.md; then
    echo "✓ Architect loads active.yaml section exists"
else
    echo "✗ Architect startup section missing"
fi

if grep -q "Auto-find BRD" agents/frappe-architect-sidecar/instructions.md; then
    echo "✓ BRD auto-discovery documented"
else
    echo "✗ BRD auto-discovery missing"
fi
echo ""

# a6: Check Architect state update
echo "=== Architect Agent: Update state after TSD ==="
if grep -q "Update Project State After TSD" agents/frappe-architect-sidecar/instructions.md; then
    echo "✓ Architect state update section exists"
else
    echo "✗ Architect state update section missing"
fi
echo ""

# Progress tracker
echo "=== Progress Tracker ==="
COMPLETED=$(grep "| \*\*4B\*\*.*\[x\]" future-plans/maker-integration/PHASE-4B-AGENT-INTEGRATION.md | wc -l)
echo "Completed tasks: $COMPLETED / 8"
echo ""

echo "========================================"
echo "Validation Summary"
echo "========================================"
echo ""
echo "Manual testing required (a7, a8):"
echo "  - Test BA agent with Nexus project"
echo "  - Test Architect agent auto-finds BRD"
echo "  - Verify state updates working"
echo ""
```

---

## 📊 Benefits of Phase 4B

### Consistency:
- ✅ Agents match workflows (no behavior differences)
- ✅ Gap 4 fix works in both agent and workflow modes
- ✅ State tracking works regardless of entry point

### User Experience:
- ✅ No repeated "which app?" questions
- ✅ No "where's the BRD/TSD?" questions
- ✅ Seamless handoffs (BA → Architect → Planner → Dev)
- ✅ Auto-resume project context

### Token Efficiency:
- ✅ Summary field (<50 tokens) vs full BRD (1000+ tokens)
- ✅ Consistent with workflow efficiency gains
- ✅ All agents benefit from compression

---

## 🔄 Rollback Instructions

**If Phase 4B changes cause issues:**

```bash
cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

# Restore BA agent
cp agents/erpnext-ba-sidecar/instructions.md.backup-pre-maker* \
   agents/erpnext-ba-sidecar/instructions.md

# Restore Architect agent
cp agents/frappe-architect-sidecar/instructions.md.backup-pre-maker* \
   agents/frappe-architect-sidecar/instructions.md
```

---

## 🎯 Completion Checklist

**Phase 4B is complete when:**
- [x] Analysis complete (`AGENT-ANALYSIS.md` created)
- [ ] All 8 tasks (a1-a8) marked complete in Progress Tracker
- [ ] Both agents load active.yaml on startup
- [ ] BA agent extracts summary (Gap 4 fix)
- [ ] Architect agent auto-finds BRD
- [ ] Both agents update active.yaml after document creation
- [ ] Validation script passes
- [ ] Manual tests pass (a7, a8)
- [ ] No errors in agent execution
- [ ] Agents consistent with workflows

---

## 📞 Support

**Resume Instructions:**
1. Check Progress Tracker (line 45)
2. Find first `[ ]` unchecked task
3. Search for that task ID (e.g., `### a3:`)
4. Execute from that point

**Validation:**
```bash
bash future-plans/maker-integration/validate-phase4b.sh
```

**Questions?**
- Review `AGENT-ANALYSIS.md` for rationale
- Check workflow files for reference implementation
- Compare with Phase 4 workflow updates (w4, w5)

---

**Phase 4B Status:** ⏳ NOT STARTED
**Priority:** HIGH (consistency critical)
**Blocked by:** User decision to proceed
**Estimated time:** 2-3 hours

---

*"Workflows and agents must speak with one voice. Phase 4B brings harmony to the MAKER integration!"*

— Plan created 2025-11-25
