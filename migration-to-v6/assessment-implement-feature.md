# BMAD v6 Workflow Assessment: implement-feature

**Date:** 2026-02-08
**Analyst:** Morgan (Module Architecture Specialist)
**Status:** COMPLIANCE ISSUE - Requires Migration to Step-File Architecture

---

## Executive Summary

The `implement-feature` workflow is **247 lines** - at the absolute BMAD v6 limit (250 max). While it has been updated with the new state management system, it does not follow BMAD v6's **step-file architecture**, which is a core compliance requirement.

**Recommendation:** Migrate to step-file architecture to achieve:
- ✅ BMAD v6 compliance
- ✅ Better agent focus (JIT loading)
- ✅ Easier maintenance
- ✅ Progressive disclosure
- ✅ Modular, reusable components

---

## Current State Analysis

### File Structure

```
implement-feature/
├── instructions.md          # 247 lines - MONOLITHIC (all 13 steps)
├── template.md              # (doesn't exist - action workflow)
├── README.md                # User-facing docs
└── workflow.yaml            # Metadata (v6 compliant ✅)
```

### Current Workflow Execution Model

- **All steps loaded at once** (247 lines in context)
- **No progressive disclosure** - agent sees entire workflow upfront
- **No JIT loading** - memory inefficient
- **Embedded code examples** in step descriptions (Python/JS patterns)
- **No separation** of reference materials from execution logic

### Current Step Breakdown (13 steps in one file)

| Step | Goal | Lines | Notes |
|------|------|-------|-------|
| 1 | Load specification document | ~10 | Input gathering |
| 2 | Identify components to build | ~15 | Analysis/planning |
| 3 | Scaffold boilerplate | ~25 | Includes Python code example |
| 4 | Implement server logic | ~20 | Includes server patterns |
| 5 | Implement client scripts | ~40 | Includes JS code examples |
| 6 | Write files | ~5 | File I/O |
| 7 | Run bench build | ~5 | Deployment |
| 8 | Run bench migrate | ~5 | Deployment |
| 9 | Clear cache and restart | ~5 | Deployment |
| 10 | Run tests | ~5 | Validation |
| 11 | Validate anti-patterns | ~30 | Quality check with anti-pattern list |
| 12 | Report completion | ~40 | Summary with structured output |
| 13 | Offload context (optional) | ~5 | Cleanup |

**Problems:**
- 🚨 Steps 5, 11, 12 are too large with embedded examples
- 🚨 Code examples should be in `data/` folder, not in step descriptions
- 🚨 No progressive disclosure - agent loads all 247 lines at once
- 🚨 Difficult to maintain - editing one step requires touching monolithic file

---

## BMAD v6 Compliant Architecture

### Proposed File Structure

```
implement-feature/
├── workflow.md              # Lean orchestrator (entry point)
├── steps/                   # Individual step files (JIT loading)
│   ├── step-01-init.md           (~60 lines)
│   ├── step-02-scaffold.md       (~50 lines)
│   ├── step-03-implement-server.md (~60 lines)
│   ├── step-04-implement-client.md (~60 lines)
│   ├── step-05-deploy.md         (~50 lines)
│   ├── step-06-validate.md       (~70 lines)
│   └── step-07-complete.md       (~60 lines)
├── data/                    # Reference materials (separated)
│   ├── scaffolding-patterns.md   # Python boilerplate examples
│   ├── server-patterns.md        # Server-side code patterns
│   ├── client-patterns.md        # JavaScript code examples
│   └── anti-patterns-checklist.md # Quality validation rules
├── templates/               # Output templates (if needed)
└── workflow.yaml            # Metadata (keep as-is ✅)
```

### Proposed Step Breakdown (7 files)

#### **step-01-init.md** (~60 lines)
**Goal:** Load specification and identify components

**Combines current steps 1 + 2:**
- Load TSD/implementation plan/ad-hoc description
- Identify components (DocTypes, scripts, reports, APIs)
- Build implementation checklist

**Menu:** [C] Continue to scaffolding

---

#### **step-02-scaffold.md** (~50 lines)
**Goal:** Generate boilerplate for all components

**Current step 3 - with code examples moved to data/:**
- Generate DocType JSON, controller stubs
- Generate script boilerplate
- Generate report templates
- Reference: `{workflow_path}/data/scaffolding-patterns.md`

**Menu:** [P] Party Mode (collaborative refinement) | [C] Continue to implementation

---

#### **step-03-implement-server.md** (~60 lines)
**Goal:** Implement server-side business logic

**Current step 4 - with patterns moved to data/:**
- Implement validations in controllers
- Add hooks (before_save, on_submit, etc.)
- Implement custom methods
- Reference: `{workflow_path}/data/server-patterns.md`

**Menu:** [A] Advanced elicitation | [P] Party Mode | [C] Continue to client-side

---

#### **step-04-implement-client.md** (~60 lines)
**Goal:** Implement minimal client-side UI behavior

**Current step 5 - with JS examples moved to data/:**
- Field dependencies
- Auto-fill calculations
- Custom buttons
- Form refresh behavior
- Reference: `{workflow_path}/data/client-patterns.md`

**Menu:** [A] Advanced elicitation | [P] Party Mode | [C] Continue to deployment

---

#### **step-05-deploy.md** (~50 lines)
**Goal:** Write files and run build/migrate/cache cycle

**Combines current steps 6 + 7 + 8 + 9:**
- Write all code files to correct paths
- Run `bench build --app {{current_app}}`
- Run `bench migrate`
- Clear cache and restart
- Report build/migration results

**Menu:** [C] Continue to validation

---

#### **step-06-validate.md** (~70 lines)
**Goal:** Run tests and scan for anti-patterns

**Combines current steps 10 + 11:**
- Run `bench run-tests`
- Scan for Frappe anti-patterns
- Reference: `{workflow_path}/data/anti-patterns-checklist.md`
- Report issues and offer fixes

**Menu:** [C] Continue to completion

---

#### **step-07-complete.md** (~60 lines)
**Goal:** Report completion and next steps

**Combines current steps 12 + 13:**
- Comprehensive implementation summary
- Component inventory
- Test results
- Next steps guidance
- Optional: Offload context (invoke task)
- Update state files

**Menu:** [Done] - No next step

---

## Data Files (Reference Materials)

### **data/scaffolding-patterns.md**
Extract from current step 3 - Python boilerplate examples:
- DocType JSON structure
- Controller template
- Report script template
- API function template

### **data/server-patterns.md**
Extract from current step 4 - Server-side best practices:
- Validation patterns
- Hook patterns
- frappe.utils usage
- Permission check patterns
- Parameterized query examples

### **data/client-patterns.md**
Extract from current step 5 - JavaScript code examples:
- frappe.ui.form.on pattern
- frappe.call pattern
- Type conversion (parseInt/parseFloat)
- Custom button pattern

### **data/anti-patterns-checklist.md**
Extract from current step 11 - Complete anti-pattern list:
- Missing @frappe.whitelist()
- SQL injection risks
- Missing permission checks
- Client-side business logic
- Custom date/number handling
- etc.

---

## workflow.md (Orchestrator)

```markdown
---
name: implement-feature
description: Implement feature from Technical Specification with production-ready Frappe code
web_bundle: false
---

# Implement Feature Workflow

**Goal:** Transform Technical Specifications into production-ready Frappe code through disciplined step-by-step implementation.

**Your Role:** In addition to your name, communication_style, and persona, you are also a Frappe Framework purist who executes Technical Specifications with framework-native, production-ready code. You write READABLE, SIMPLE code that any developer can understand in 6 months.

---

## WORKFLOW ARCHITECTURE

This uses **step-file architecture** for disciplined execution:

### Core Principles
- **Micro-file Design**: Each step is a self-contained instruction file
- **Just-In-Time Loading**: Only the current step file is in memory
- **Sequential Enforcement**: Steps completed in order
- **State Tracking**: Track progress in active.yaml and feature files
- **Frappe-Native**: Always use framework features, never custom solutions

### Step Processing Rules
1. **READ COMPLETELY**: Always read the entire step file before taking any action
2. **FOLLOW SEQUENCE**: Execute numbered sections in order
3. **WAIT FOR INPUT**: Halt at menus and wait for user selection
4. **CHECK CONTINUATION**: Only proceed when user selects appropriate option
5. **SAVE STATE**: Update progress before loading next step
6. **LOAD NEXT**: When directed, load and execute the next step file

### Critical Rules
- 🛑 **NEVER** load multiple step files simultaneously
- 📖 **ALWAYS** read entire step file before execution
- 🚫 **NEVER** skip steps unless explicitly optional
- 💾 **ALWAYS** save progress and outputs
- 🎯 **ALWAYS** follow exact instructions in step files
- ⏸️ **ALWAYS** halt at menus and wait for input

---

## INITIALIZATION SEQUENCE

### 1. Configuration Loading
Load config from `{project-root}/_bmad/frappe-builder/config.yaml`:
- `user_name`, `communication_language`, `output_folder`
- `frappe_bench_path`, `default_site`

### 2. Load Active Project State
Load state from `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/active.yaml`

Populate session variables:
- `{{project}}`, `{{app}}`, `{{bench_path}}`
- `{{current_feature}}`, `{{current_component}}`, `{{current_task}}`
- `{{workflow}}`, `{{workflow_step}}`
- `{{last_action}}`, `{{next_action}}`

### 3. Start Execution
Load and execute first step:

**File:** `{workflow_path}/steps/step-01-init.md`

Read the entire file and follow all instructions within it.
```

---

## Comparison: Before vs. After

| Aspect | Before (Current) | After (v6 Compliant) |
|--------|------------------|----------------------|
| **File count** | 1 monolithic file (247 lines) | 7 step files + 4 data files + 1 orchestrator |
| **Step file size** | N/A - all in one | 50-70 lines each (well under 200 limit) |
| **Loading** | All 247 lines at once | JIT - one step at a time (50-70 lines) |
| **Code examples** | Embedded in steps | Separated in data/ files |
| **Progressive disclosure** | ❌ No - sees entire workflow | ✅ Yes - sees only current step |
| **Memory efficiency** | ❌ Poor - 247 lines in context | ✅ Excellent - 50-70 lines max |
| **Maintainability** | ❌ Difficult - edit monolith | ✅ Easy - edit individual steps |
| **BMAD v6 compliance** | ❌ Partial - state mgmt only | ✅ Full - step-file architecture |
| **Modularity** | ❌ No - monolithic | ✅ Yes - reusable data files |

---

## Benefits of Migration

### 1. **Better Agent Focus**
- Agent loads one 50-70 line step at a time
- Clearer, more focused execution
- Reduced cognitive load

### 2. **Memory Efficiency**
- Only current step in context (50-70 lines)
- vs. current 247 lines all loaded
- Significant token savings

### 3. **Progressive Disclosure**
- User sees journey unfold step-by-step
- Clearer understanding of where they are
- Better UX

### 4. **Easier Maintenance**
- Edit individual steps without touching others
- Reuse data files across workflows
- Safer refactoring

### 5. **BMAD v6 Compliance**
- Matches core architecture patterns
- Consistent with all v6 modules
- Future-proof

### 6. **Modularity & Reusability**
- Extract common patterns to data/ files
- Reuse across multiple workflows
- E.g., `anti-patterns-checklist.md` can be used by `review-code` workflow too

---

## Migration Effort Estimate

### Time Required: **2-3 hours**

**Breakdown:**
1. Create workflow.md orchestrator - **30 min**
2. Create 7 step files - **60 min** (split existing content, add menus)
3. Extract 4 data files - **30 min** (move code examples/patterns)
4. Test execution flow - **30 min** (run through workflow once)

### Complexity: **Medium**

**Why:**
- Content already exists (just needs reorganization)
- No business logic changes
- State management already updated (v6 compliant ✅)
- Clear step boundaries already defined

---

## Migration Path

### Phase 1: Create Structure (15 min)
```bash
cd /home/riz/work-bench/frappe-builder/workflows/implement-feature

# Backup current file
cp instructions.md instructions.md.backup

# Create new structure
mkdir -p steps data templates
touch workflow.md
touch steps/step-01-init.md
touch steps/step-02-scaffold.md
touch steps/step-03-implement-server.md
touch steps/step-04-implement-client.md
touch steps/step-05-deploy.md
touch steps/step-06-validate.md
touch steps/step-07-complete.md
touch data/scaffolding-patterns.md
touch data/server-patterns.md
touch data/client-patterns.md
touch data/anti-patterns-checklist.md
```

### Phase 2: Create workflow.md (30 min)
- Use template provided above
- Add Frappe-specific context
- Define initialization sequence
- Route to step-01

### Phase 3: Split Steps (60 min)
For each step file:
1. Extract relevant content from instructions.md
2. Add frontmatter (name, description, variables)
3. Add MANDATORY EXECUTION RULES section
4. Add menu with A/P/C options (where appropriate)
5. Reference data files where needed
6. Add success/failure metrics

### Phase 4: Extract Data Files (30 min)
1. **scaffolding-patterns.md** - Extract Python boilerplate from step 3
2. **server-patterns.md** - Extract server examples from step 4
3. **client-patterns.md** - Extract JS examples from step 5
4. **anti-patterns-checklist.md** - Extract anti-pattern list from step 11

### Phase 5: Test & Validate (30 min)
1. Run workflow end-to-end
2. Verify JIT loading works
3. Verify menus halt and wait
4. Verify state updates work
5. Verify data file references work

### Phase 6: Cleanup (15 min)
1. Archive instructions.md.backup
2. Update workflow.yaml if needed
3. Update README.md to reference new structure

---

## Next Steps

**Option A: Morgan Does It (Recommended for First Migration)**
- I migrate implement-feature to v6 architecture
- You review and approve
- Use as template for other 9 workflows
- **Time:** 2-3 hours

**Option B: Collaborative Migration**
- I create structure and workflow.md
- You split steps (I provide guidance)
- I extract data files
- We test together
- **Time:** 3-4 hours

**Option C: I Create Pattern, You Execute**
- I migrate implement-feature fully
- I create migration pattern document
- You migrate remaining 9 workflows using pattern
- **Time:** 2-3 hours (me) + 8-10 hours (you for remaining workflows)

---

## Risk Assessment

### Low Risk
- Content already exists (no new business logic)
- State management already v6 compliant
- Clear step boundaries already defined
- Can keep instructions.md.backup as safety net

### Success Criteria
- ✅ All step files < 200 lines
- ✅ JIT loading works (only current step in memory)
- ✅ Progressive disclosure works (user sees one step at a time)
- ✅ Menus halt and wait for input
- ✅ Data files properly referenced
- ✅ Workflow executes end-to-end successfully
- ✅ State updates work correctly

---

## Recommendation

**Proceed with Migration** using **Option A** (Morgan does it).

**Why:**
1. **First migration** - sets template for remaining 9 workflows
2. **Time efficient** - 2-3 hours vs. learning curve
3. **Quality assurance** - I ensure v6 compliance from start
4. **Knowledge transfer** - you learn by reviewing my work
5. **Momentum** - get one done, then decide on approach for remaining workflows

**After implement-feature migration:**
- Review the result
- Decide if you want me to migrate all 10, or create pattern for you to follow
- Apply same pattern to remaining workflows

---

**Ready to proceed with Option A?**
