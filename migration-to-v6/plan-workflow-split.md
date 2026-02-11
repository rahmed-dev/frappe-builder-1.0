# Workflow Split Plan: implement-phase + implement-feature

**Date:** 2026-02-08
**Architect:** Morgan (Module Architecture Specialist)
**Status:** READY FOR IMPLEMENTATION
**Session:** Planning complete, awaiting execution

---

## Executive Summary

Split the current `implement-feature` workflow into two independent, self-contained workflows:

1. **implement-phase** - TSD-based formal development (single-modal)
2. **implement-feature** - Real-world iterative development (bi-modal)

**Architectural Decision:** Keep each workflow **completely independent** (standard BMAD v6 pattern)

---

## Problem Statement

### Current State
- `implement-feature` workflow (247 lines, monolithic)
- Assumes TSD exists (formal development)
- No support for ad-hoc features or feature inventory

### Real-World Need
- **Formal development:** Big projects with TSD, phased approach
- **Iterative development:** Quick features without TSD, resume from inventory
- Need flexibility without complexity

### Solution
Two focused workflows instead of one complex workflow with branching logic.

---

## Architectural Decision

### **Option Chosen: Independent Self-Contained Workflows**

Each workflow is completely independent with its own:
- ✅ workflow.md orchestrator
- ✅ Complete set of step files
- ✅ Own data/ folder (patterns duplicated)
- ✅ Own workflow.yaml

**Why:**
- Standard BMAD v6 pattern (proven, reliable)
- No complex cross-workflow dependencies
- Easy to maintain and debug
- Clear separation of concerns
- Can evolve independently

**Tradeoff Accepted:**
- Some duplication of implementation steps (steps 3-9)
- Some duplication of data/ files (patterns)
- Update implementation logic = update both workflows
- This is acceptable for clarity and maintainability

---

## Workflow 1: implement-phase

### Purpose
Formal, phased development from Technical Specification Documents (TSD).
For big, structured projects with proper planning and documentation.

### Architecture
**Single-modal** - TSD-based only

### Structure
```
implement-phase/
├── workflow.md              # Orchestrator (TSD-based only)
├── steps/                   # 8 step files
│   ├── step-01-load-tsd.md
│   ├── step-02-identify.md
│   ├── step-03-scaffold.md
│   ├── step-04-implement-server.md
│   ├── step-05-implement-client.md
│   ├── step-06-deploy.md
│   ├── step-07-validate.md
│   └── step-08-complete.md
├── data/                    # Reference materials
│   ├── scaffolding-patterns.md
│   ├── server-patterns.md
│   ├── client-patterns.md
│   └── anti-patterns-checklist.md
└── workflow.yaml            # Metadata
```

### Step Breakdown

| Step | File | Lines | Purpose |
|------|------|-------|---------|
| 1 | step-01-load-tsd.md | ~60 | Load TSD document, understand scope |
| 2 | step-02-identify.md | ~50 | Identify components to build (DocTypes, scripts, etc.) |
| 3 | step-03-scaffold.md | ~50 | Generate boilerplate code |
| 4 | step-04-implement-server.md | ~60 | Implement server-side business logic |
| 5 | step-05-implement-client.md | ~60 | Implement client-side UI behavior |
| 6 | step-06-deploy.md | ~50 | Write files + build + migrate + cache |
| 7 | step-07-validate.md | ~70 | Run tests + anti-pattern scan |
| 8 | step-08-complete.md | ~60 | Summary + state update + context offload |

**Total:** ~460 lines across 8 files (avg 57 lines/file) ✅

### Entry Point
User invokes: `/bmad-frappe-builder-implement-phase`

### Workflow.md Key Features
- Load config from frappe-builder/config.yaml
- Load active project state
- Require TSD path (fail if not provided)
- Route to step-01-load-tsd.md

---

## Workflow 2: implement-feature

### Purpose
Real-world iterative feature development. Supports:
- Quick ad-hoc features without formal TSD
- Resume work on existing features from inventory

### Architecture
**Bi-modal** - New feature OR Resume from inventory

### Structure
```
implement-feature/
├── workflow.md              # Mode selector (New vs Resume)
├── steps-new/               # Mode 1: New ad-hoc feature (9 steps)
│   ├── step-01-gather-requirements.md
│   ├── step-02-quick-spec.md
│   ├── step-03-identify.md
│   ├── step-04-scaffold.md
│   ├── step-05-implement-server.md
│   ├── step-06-implement-client.md
│   ├── step-07-deploy.md
│   ├── step-08-validate.md
│   └── step-09-complete.md
├── steps-resume/            # Mode 2: Resume from inventory (9 steps)
│   ├── step-01-select-feature.md
│   ├── step-02-load-context.md
│   ├── step-03-identify.md
│   ├── step-04-scaffold.md
│   ├── step-05-implement-server.md
│   ├── step-06-implement-client.md
│   ├── step-07-deploy.md
│   ├── step-08-validate.md
│   └── step-09-complete.md
├── data/                    # Reference materials (same as implement-phase)
│   ├── scaffolding-patterns.md
│   ├── server-patterns.md
│   ├── client-patterns.md
│   └── anti-patterns-checklist.md
└── workflow.yaml            # Metadata
```

### Mode 1: New Feature (steps-new/)

| Step | File | Lines | Purpose |
|------|------|-------|---------|
| 1 | step-01-gather-requirements.md | ~70 | Gather requirements interactively from user |
| 2 | step-02-quick-spec.md | ~60 | Create lightweight spec (no formal TSD) |
| 3 | step-03-identify.md | ~50 | Identify components (adapted from implement-phase) |
| 4 | step-04-scaffold.md | ~50 | Generate boilerplate |
| 5 | step-05-implement-server.md | ~60 | Server-side logic |
| 6 | step-06-implement-client.md | ~60 | Client-side behavior |
| 7 | step-07-deploy.md | ~50 | Write + build + migrate |
| 8 | step-08-validate.md | ~70 | Tests + anti-patterns |
| 9 | step-09-complete.md | ~60 | Summary + state update |

**Total:** ~530 lines across 9 files (avg 59 lines/file) ✅

### Mode 2: Resume Feature (steps-resume/)

| Step | File | Lines | Purpose |
|------|------|-------|---------|
| 1 | step-01-select-feature.md | ~80 | Show feature inventory, user selects |
| 2 | step-02-load-context.md | ~60 | Load feature context from state files |
| 3-9 | (same as steps-new) | ~450 | Implementation steps (identical to new mode) |

**Total:** ~590 lines across 9 files (avg 65 lines/file) ✅

### Entry Point
User invokes: `/bmad-frappe-builder-implement-feature`

### Workflow.md Key Features (Mode Selector)
- Load config from frappe-builder/config.yaml
- Load active project state
- Ask user to select mode:
  ```
  What would you like to do?

  [N] New Ad-Hoc Feature - Quick implementation without formal TSD
  [R] Resume Feature from Inventory - Continue existing work

  Select mode: [N/R]
  ```
- If N: Load `steps-new/step-01-gather-requirements.md`
- If R: Load `steps-resume/step-01-select-feature.md`

---

## Data Files (Reference Materials)

Both workflows have identical data/ folders with:

### **scaffolding-patterns.md** (~100 lines)
Extract from current step 3:
- DocType JSON structure template
- Controller Python template
- Report script template
- API function template
- Client script template

### **server-patterns.md** (~150 lines)
Extract from current step 4:
- Validation patterns
- Hook patterns (before_save, on_submit, etc.)
- frappe.utils usage examples
- Permission check patterns
- Parameterized query examples
- API whitelisting patterns

### **client-patterns.md** (~120 lines)
Extract from current step 5:
- frappe.ui.form.on pattern
- frappe.call pattern
- Type conversion (parseInt/parseFloat)
- Custom button pattern
- Field dependency patterns
- Auto-calculation patterns

### **anti-patterns-checklist.md** (~150 lines)
Extract from current step 11:
- Missing @frappe.whitelist()
- SQL injection risks (string concatenation)
- Missing permission checks
- Client-side business logic
- Custom date/number handling
- Direct frappe.db.sql without params
- Missing error handling
- console.log() in production
- Not converting form values
- etc.

---

## Implementation Steps

### **Phase 1: Create implement-phase** (~2 hours)

#### 1.1 Rename Current Workflow (5 min)
```bash
cd /home/riz/work-bench/frappe-builder/workflows
mv implement-feature implement-phase
cd implement-phase

# Backup current monolithic file
cp instructions.md instructions.md.backup
```

#### 1.2 Create Directory Structure (5 min)
```bash
mkdir -p steps data templates
```

#### 1.3 Create workflow.md (30 min)
- Lean orchestrator (TSD-based focus)
- Load config and state
- Route to step-01-load-tsd.md
- Include architecture principles (JIT loading, etc.)

#### 1.4 Split into Step Files (60 min)
- step-01-load-tsd.md - Load TSD document
- step-02-identify.md - Identify components
- step-03-scaffold.md - Generate boilerplate
- step-04-implement-server.md - Server logic
- step-05-implement-client.md - Client behavior
- step-06-deploy.md - Write + build + migrate
- step-07-validate.md - Tests + anti-patterns
- step-08-complete.md - Summary + state update

Each step file includes:
- Frontmatter (name, description, variables)
- MANDATORY EXECUTION RULES section
- Step instructions
- Menu (A/P/C where appropriate)
- Success/failure metrics

#### 1.5 Extract Data Files (20 min)
- scaffolding-patterns.md
- server-patterns.md
- client-patterns.md
- anti-patterns-checklist.md

#### 1.6 Update workflow.yaml (5 min)
```yaml
name: implement-phase
description: "Implement feature from Technical Specification (TSD) with production-ready Frappe code"
# ... rest of config
```

#### 1.7 Test End-to-End (20 min)
- Run workflow from start to finish
- Verify JIT loading
- Verify menus work
- Verify state updates

---

### **Phase 2: Create implement-feature** (~2 hours)

#### 2.1 Create Directory Structure (5 min)
```bash
cd /home/riz/work-bench/frappe-builder/workflows
mkdir -p implement-feature/{steps-new,steps-resume,data,templates}
cd implement-feature
```

#### 2.2 Create workflow.md with Mode Selector (30 min)
- Mode determination (New vs Resume)
- Route to appropriate step folder
- Architecture principles

#### 2.3 Create steps-new/ Mode (50 min)
- step-01-gather-requirements.md - Interactive requirement gathering
- step-02-quick-spec.md - Create lightweight spec
- steps 3-9 - Adapt from implement-phase (adjust references)

#### 2.4 Create steps-resume/ Mode (50 min)
- step-01-select-feature.md - Show inventory, user selects
- step-02-load-context.md - Load feature state
- steps 3-9 - Copy from steps-new/ (identical implementation)

#### 2.5 Copy Data Files (5 min)
Copy from implement-phase/data/:
- scaffolding-patterns.md
- server-patterns.md
- client-patterns.md
- anti-patterns-checklist.md

#### 2.6 Create workflow.yaml (5 min)
```yaml
name: implement-feature
description: "Implement features iteratively - new or from inventory"
# ... rest of config
```

#### 2.7 Test Both Modes (20 min)
- Test New mode end-to-end
- Test Resume mode end-to-end
- Verify mode selector works
- Verify state updates

---

## State Management Integration

Both workflows update:

### **active.yaml**
```yaml
current_task: "Implementing server-side logic"
workflow: "implement-phase" or "implement-feature"
workflow_step: 4
last_action: "Scaffolded boilerplate for 3 DocTypes"
next_action: "Implement validation hooks"
specialist: "frappe-dev"
updated: "2026-02-08T..."
```

### **features/{feature-id}.yaml** (if feature exists)
```yaml
status: "in-progress"
updated: "2026-02-08T..."
notes: "Step 4: Implementing server-side business logic"
```

---

## Total Effort Estimate

### Time Breakdown
- Phase 1 (implement-phase): ~2 hours
- Phase 2 (implement-feature): ~2 hours
- **Total: ~4 hours**

### Complexity
**Medium** - Content exists, needs reorganization + new mode creation

---

## Success Criteria

### For implement-phase:
- ✅ All step files < 200 lines
- ✅ TSD-based only (no branching)
- ✅ JIT loading works
- ✅ Executes end-to-end successfully
- ✅ State updates work correctly
- ✅ BMAD v6 compliant

### For implement-feature:
- ✅ All step files < 200 lines
- ✅ Mode selector works (New vs Resume)
- ✅ New mode: interactive requirements gathering
- ✅ Resume mode: feature inventory selection
- ✅ Both modes execute successfully
- ✅ State updates work correctly
- ✅ BMAD v6 compliant (bi-modal pattern)

---

## Files to Update After Migration

### Skills to Update
Update `/home/riz/work-bench/frappe-builder/` skill references:
- Old: `bmad-frappe-builder-implement-feature`
- New:
  - `bmad-frappe-builder-implement-phase`
  - `bmad-frappe-builder-implement-feature`

### Documentation
- Update USER-GUIDE.md with new workflow names
- Update README.md with workflow descriptions

---

## Next Session Action Items

1. **Resume here:** Review this plan
2. **Decision:** Choose implementation approach:
   - Option A: Morgan does both workflows (~4 hours)
   - Option B: Phased (do implement-phase first, review, then implement-feature)
3. **Execute:** Implement the chosen approach
4. **Test:** Validate both workflows work end-to-end
5. **Update:** Skills and documentation

---

## Related Documents

- `/home/riz/work-bench/frappe-builder/migration-to-v6/assessment-implement-feature.md` - Detailed assessment of current workflow
- `/home/riz/work-bench/frappe-builder/migration-to-v6.md` - Overall migration guide
- `/home/riz/work-bench/frappe-builder/WORKFLOW-STATE-UPDATE-PROGRESS.md` - State management progress (needs update)

---

## Notes

- Current `implement-feature` workflow is backed up as `instructions.md.backup`
- All 10 workflows already have new state management (current_feature, workflow_step, etc.)
- This split addresses real-world Frappe development needs (formal vs iterative)
- Both workflows are self-contained and can evolve independently
- Data files (patterns) are duplicated intentionally for independence

---

**Status:** Ready for implementation in next session
**Next Step:** Review plan with Riz, choose implementation approach, execute
