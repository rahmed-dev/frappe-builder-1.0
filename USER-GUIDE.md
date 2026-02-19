# Frappe-Builder User Guide

**Complete guide to using the Frappe-Builder module effectively**

This guide covers all 8 agents, 11 workflows, multi-project management, and best practices for optimal Frappe development with BMAD.

---

## Table of Contents

1. [The 8 Specialized Agents](#the-8-specialized-agents)
2. [When to Use Which Agent](#when-to-use-which-agent)
3. [Multi-Project Management](#multi-project-management)
4. [Complete Development Workflow](#complete-development-workflow)
5. [11 Workflow Automations](#11-workflow-automations)
6. [Knowledge Base Architecture](#knowledge-base-architecture)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)

---

## The 8 Specialized Agents

### 🎯 Frappe-Nexus (Primary Orchestrator)

**Command:** `/bmad:frappe-builder:agents:frappe-nexus`

**Role:** Intelligent router and project orchestrator

**What it does:**
- Routes you to the right specialist based on your needs
- Manages project state and context switching
- Coordinates between specialists when needed
- Provides workflow guidance and next-step recommendations

**When to use:**
- Starting a new session
- Not sure which specialist you need
- Want project status and guidance
- Switching between projects

**Example:**
```
You: "I need to add inventory tracking to my app"
Frappe-Nexus: "Based on your need, I'll route you to ERPNext BA
              to analyze requirements and map ERPNext capabilities."
```

---

### 📊 ERPNext BA (Business Analyst)

**Command:** `/bmad:frappe-builder:agents:erpnext-ba`

**Role:** Requirements analysis and ERPNext feature mapping

**What it does:**
- Analyzes messy requirements and meeting notes
- Maps business needs to ERPNext modules and features
- Identifies Standard vs Custom requirements
- Creates structured Business Requirements Documents (BRD)
- Gap analysis (what ERPNext provides vs what needs development)

**When to use:**
- Starting a new project with unclear requirements
- Have client meeting notes to structure
- Need to know what ERPNext can do out-of-the-box
- Creating BRD from scratch

**Outputs:**
- `BRD.md` - Business Requirements Document
- ERPNext module mapping
- Standard vs Custom feature breakdown
- Gap analysis report

**Example:**
```
Input: Unstructured client notes about needing "quality checks with approvals"
Output: BRD mapping to ERPNext Quality Inspection + Workflow modules with customization needs identified
```

---

### 🏗️ Frappe-Architect (Solution Architect)

**Command:** `/bmad:frappe-builder:agents:frappe-architect`

**Role:** Technical design and 4-tier framework specialist

**What it does:**
- Designs technical solutions using 4-tier framework (Standard → Configure → Scripts → Custom)
- Designs DocType structures and field mappings
- Creates UX designs with Frappe native components
- Produces Technical Specification Documents (TSD)
- Makes build vs configure decisions

**When to use:**
- Have BRD, need technical design
- Deciding how to implement a feature
- Designing custom DocTypes
- Creating TSD for development team

**Outputs:**
- `TSD.md` - Technical Specification Document
- DocType specifications with fields
- Workflow logic and state diagrams
- UX wireframes using Frappe components
- 4-tier solution breakdown

**Example:**
```
Input: BRD requirement for "3-level purchase order approval"
Output: TSD using ERPNext Workflow (Tier 2: Configuration) with states, transitions, email alerts
```

---

### 📋 Frappe-Planner (Implementation Planner)

**Command:** `/bmad:frappe-builder:agents:frappe-planner`

**Role:** Implementation sequencing and dependency management

**What it does:**
- Sequences implementation tasks by dependencies (not just priority)
- Separates User tasks (configuration) vs Developer tasks (code)
- Creates phased implementation plans
- Identifies prerequisites and blockers
- Generates implementation roadmaps

**When to use:**
- Have TSD, need to know what to build first
- Complex feature with many dependencies
- Planning phased rollouts
- Need to coordinate User and Developer work

**Outputs:**
- `Implementation-Plan.md` - Sequenced task list
- Dependency graph
- User tasks vs Developer tasks split
- Phase breakdown with milestones

**Example:**
```
Input: TSD with 15 features
Output: 3-phase plan with dependencies mapped - Phase 1: Base DocTypes,
        Phase 2: Workflows, Phase 3: Integrations
```

---

### 💻 Frappe-Dev (Code Implementation Specialist)

**Command:** `/bmad:frappe-builder:agents:frappe-dev`

**Role:** Production-ready code implementation

**What it does:**
- Implements features from TSD with production-quality code
- Follows all 11 coding principles automatically
- Uses Frappe framework patterns (no reinventing wheels)
- Writes self-documenting, simple code
- Implements DocTypes, Server Scripts, Client Scripts, Reports

**When to use:**
- Have TSD, ready to write code
- Implementing specific features
- Need code review for Frappe best practices
- Writing production-ready Python/JavaScript

**Outputs:**
- DocType controllers (.py files)
- Server Scripts (@frappe.whitelist)
- Client Scripts (.js files)
- Script Reports
- Test files

**Key Principles:**
- Server-side first (business logic in Python)
- Uses frappe.utils (never reinvents)
- Parameterized queries (zero SQL injection)
- Permission checks on all @frappe.whitelist()
- Self-documenting code with descriptive names

**Example:**
```
Input: TSD for "auto-calculate delivery lead time based on supplier"
Output: Server Script with validation, frappe.utils usage, error handling, and tests
```

---

### 🔧 Frappe-Debugger (Error Diagnostician)

**Command:** `/bmad:frappe-builder:agents:frappe-debugger`

**Role:** Error diagnosis and anti-pattern detection

**What it does:**
- Diagnoses Frappe errors from tracebacks and logs
- Detects anti-patterns in code (SQL injection, N+1 queries, etc.)
- Suggests Frappe built-in alternatives to custom code
- Analyzes bench logs (error.log, web.log)
- Root cause analysis for silent failures

**When to use:**
- Facing Frappe errors or exceptions
- Code works but feels wrong
- Performance issues (slow queries)
- Need code review for anti-patterns
- Debugging production issues

**Detects:**
- SQL injection vulnerabilities
- N+1 query problems
- Missing permission checks
- Hardcoded values (should be settings)
- Not using frappe.utils helpers
- Business logic in client scripts
- Inefficient database queries

**Example:**
```
Input: "AttributeError: 'NoneType' object has no attribute 'customer_name'"
Output: Root cause analysis + fix suggestion with proper None handling
```

---

### 🧪 QA-Specialist (Test Scenario Generator)

**Command:** `/bmad:frappe-builder:agents:qa-specialist`

**Role:** Test scenario generation and quality assurance

**What it does:**
- Creates manual test scenarios (Happy/Sad/Edge/Evil paths)
- Generates Frappe unittest code
- Thinks like real users (lazy, mistake-prone, uneducated)
- Tests permission scenarios and edge cases
- Creates test data fixtures

**When to use:**
- Feature is coded, needs testing
- Creating test plans
- Generating unittest code
- Pre-release quality assurance

**Test Categories:**
- **Happy Path**: Normal usage flow
- **Sad Path**: Expected errors (validation failures)
- **Edge Cases**: Boundary conditions, empty data, max limits
- **Evil User**: Malicious input, permission bypassing attempts

**Outputs:**
- Manual test scenarios document
- Frappe unittest code (test_*.py files)
- Test data fixtures
- Permission testing matrix

**Example:**
```
Input: Custom Sales Order validation logic
Output: 12 test scenarios + unittest code covering valid/invalid cases and edge conditions
```

---

### 📝 Doc-Writer (User Documentation Specialist)

**Command:** `/bmad:frappe-builder:agents:doc-writer`

**Role:** Anti-fluff user guide creation

**What it does:**
- Creates concise user guides (2-3 pages max)
- Uses ERPNext UI terminology (not technical jargon)
- Direct, actionable language
- Screenshot placeholders and numbered steps
- Gets users productive fast

**When to use:**
- Feature is complete, needs user documentation
- Creating training materials
- Writing release notes
- End-user quick reference guides

**Output Format:**
- **What it does**: 2-sentence feature summary
- **How to use**: Numbered steps
- **Common scenarios**: Practical examples
- **Troubleshooting**: Common issues + fixes

**Principles:**
- Zero decorative language
- User-focused (not developer-focused)
- Assumes user is non-technical
- Action-oriented (do this, not "you can")

**Example:**
```
Input: Quality Inspection workflow implementation
Output: 2-page guide: "How to Create Quality Inspections" with 5 numbered steps
```

---

## When to Use Which Agent

### Decision Tree

```
START
├─ Need to understand requirements? → ERPNext BA
├─ Have requirements, need technical design? → Frappe-Architect
├─ Have design, need implementation sequence? → Frappe-Planner
├─ Ready to write code? → Frappe-Dev
├─ Code not working or has errors? → Frappe-Debugger
├─ Code works, need tests? → QA-Specialist
├─ Feature complete, need user docs? → Doc-Writer
└─ Not sure where you are? → Frappe-Nexus (will route you)
```

### Typical Project Flow

**Phase 1: Requirements** (ERPNext BA)
- Input: Client notes, requirements dump
- Output: BRD with ERPNext mapping

**Phase 2: Design** (Frappe-Architect)
- Input: BRD
- Output: TSD with DocType designs, 4-tier solution

**Phase 3: Planning** (Frappe-Planner)
- Input: TSD
- Output: Implementation Plan with phases and dependencies

**Phase 4: Development** (Frappe-Dev)
- Input: TSD + Implementation Plan
- Output: Production-ready code

**Phase 5: Testing** (QA-Specialist)
- Input: Implemented features
- Output: Test scenarios + unittest code

**Phase 6: Documentation** (Doc-Writer)
- Input: Completed features
- Output: User guides

**Throughout: Debugging** (Frappe-Debugger)
- When errors occur at any phase

---

## Multi-Project Management

### State Usage (3-file split, fast context)
- Active project state lives in `.bmad/frappe-builder/state/`
- `active-project.txt` selects the current project folder
- **3-file split per project:**
  - `active.yaml` — project config only: `project`, `app`, `site`, `bench_path` (rarely changes)
  - `session.yaml` — step state: `workflow`, `workflow_step`, `current_feature`, `last_action`, `next_action`, `specialist`, `updated`
  - `inventory.yaml` — feature list with status/progress (loaded on demand in resume mode)
- Agents write session fields to `session.yaml` at each step boundary; project config in `active.yaml` changes only when you switch sites or apps

Frappe-Builder supports working on **multiple Frappe projects simultaneously** without losing context.

### How It Works

Each project has its own **state folder**:

```
.bmad/frappe-builder/state/
├── active-project.txt          # Points to current project
├── nexus_erp/                  # Project 1
│   ├── active.yaml            # Project config (app, site, bench_path)
│   ├── session.yaml           # Current step state (workflow, step, last/next action)
│   ├── inventory.yaml         # Feature list (loaded on demand)
│   ├── features/              # Detailed per-feature context files
│   └── context.md             # Session offload (optional)
├── inventory_system/           # Project 2
│   ├── active.yaml
│   ├── session.yaml
│   ├── inventory.yaml
│   └── features/
└── templates/                  # State templates (active, session, inventory)
```

### Switching Projects

When you invoke any agent, it automatically:
1. Reads `active-project.txt` to find current project
2. Loads that project's `active.yaml` state
3. Extracts: project name, app, site, phase, current tasks

To switch projects:
- Simply update `active-project.txt` with new project folder name
- Next agent invocation loads new project state

### Per-Project Configuration

**active.yaml** (project config — rarely changes):
- **project**: Display name
- **app**: Frappe app name
- **site**: Frappe site for this project (per-project!)
- **bench_path**: Path to Frappe bench

**session.yaml** (updated at every step boundary):
- **workflow**: Active workflow name
- **workflow_step**: Current step number
- **current_feature**: Feature being worked on
- **specialist**: Last agent used
- **last_action** / **next_action**: Session continuity
- **updated**: Timestamp

### Example: Working on Two Projects

**Morning: Working on nexus_erp**
```
active-project.txt contains: nexus_erp
/bmad:frappe-builder:agents:frappe-dev
→ Loads nexus_erp/active.yaml
→ Continues Phase 3, tasks d5:d8
→ Uses site: nexus.local
```

**Afternoon: Switching to inventory_system**
```
Update active-project.txt to: inventory_system
/bmad:frappe-builder:agents:erpnext-ba
→ Loads inventory_system/active.yaml
→ Starts Phase 1, requirements analysis
→ Uses site: inventory.local
```

No manual config changes needed - each project remembers its own state!

---

## Complete Development Workflow

### Scenario: Custom Quality Inspection Workflow

**Starting Point:** Client wants "3-level quality approval with automatic email alerts"

#### Step 1: Requirements Analysis (ERPNext BA)

```bash
/bmad:frappe-builder:agents:erpnext-ba
```

**Conversation:**
```
You: "Client needs 3-level quality approval with email alerts"

BA: "Let me analyze ERPNext capabilities...

ERPNext provides:
- Quality Inspection DocType (STANDARD)
- Workflow system (CONFIGURE)
- Email Alert framework (CONFIGURE)

Recommendation:
- Use ERPNext Quality Inspection as-is (Tier 1)
- Add 3-level Workflow (Tier 2: Configuration)
- Configure Email Alerts (Tier 2: Configuration)

Zero custom code needed!

Creating BRD now..."

Output: apps/my_app/docs/brd/quality-inspection-workflow.md
```

#### Step 2: Technical Design (Frappe-Architect)

```bash
/bmad:frappe-builder:agents:frappe-architect
```

**Conversation:**
```
You: "Design the quality workflow from BRD"

Architect: "Analyzing BRD... Applying 4-tier framework...

Solution: TIER 2 (Configuration)

Workflow Design:
- States: Draft → QC Review → Manager Review → Director Review → Approved
- Transitions: Each level can Approve or Reject
- Email Alerts: On state change to each reviewer role

DocType: Quality Inspection (ERPNext standard)
Custom Fields needed:
- priority (Select: High/Medium/Low)
- inspection_notes (Text)

Creating TSD..."

Output: apps/my_app/docs/tsd/quality-inspection-workflow-tsd.md
```

#### Step 3: Implementation Planning (Frappe-Planner)

```bash
/bmad:frappe-builder:agents:frappe-planner
```

**Conversation:**
```
You: "Create implementation plan from TSD"

Planner: "Analyzing dependencies...

Phase 1: Foundation (USER tasks)
- U1: Add Custom Fields to Quality Inspection
- U2: Create Workflow states and transitions

Phase 2: Automation (USER tasks)
- U3: Configure Email Alerts for each state
- U4: Set up role permissions

Phase 3: Testing (DEVELOPER task)
- D1: Create test Quality Inspections
- D2: Verify workflow transitions
- D3: Test email triggers

Total: 7 tasks (6 User, 1 Developer)
User can complete 85% without coding!

Saving plan..."

Output: apps/my_app/docs/implementation-plans/qi-workflow-plan.md
```

#### Step 4: Development (Frappe-Dev)

```bash
/bmad:frappe-builder:agents:frappe-dev
```

**Conversation:**
```
You: "This is a Tier 2 solution - mostly user configuration.
      Help me create the fixtures."

Dev: "Creating fixtures for Custom Fields and Workflow...

File: my_app/fixtures/custom_field.json
[Custom field definitions...]

File: my_app/fixtures/workflow.json
[Workflow configuration...]

File: my_app/hooks.py
fixtures = [
    {"dt": "Custom Field", "filters": [["dt", "=", "Quality Inspection"]]},
    {"dt": "Workflow", "filters": [["name", "=", "Quality Inspection Approval"]]}
]

Run: bench --site sitename export-fixtures

Done! User can now configure Email Alerts via UI."
```

#### Step 5: Testing (QA-Specialist)

```bash
/bmad:frappe-builder:agents:qa-specialist
```

**Conversation:**
```
You: "Create test scenarios for the workflow"

QA: "Generating test scenarios...

Manual Test Scenarios:

HAPPY PATH:
1. Create QI as QC Inspector → Status: Draft
2. Submit for review → Status: QC Review, Email sent to QC Manager
3. QC Manager approves → Status: Manager Review, Email sent to Manager
...

SAD PATH:
1. QC Manager rejects → Status: Rejected, Email sent to creator
...

EDGE CASES:
1. User without permission tries to approve → Permission error
2. Skip workflow levels → Workflow prevents

Creating test plan document..."

Output: apps/my_app/tests/qi-workflow-test-plan.md
```

#### Step 6: Documentation (Doc-Writer)

```bash
/bmad:frappe-builder:agents:doc-writer
```

**Conversation:**
```
You: "Create user guide for quality inspections"

Doc-Writer: "Creating user guide...

# How to Create Quality Inspections

## What it does
Tracks quality checks with 3-level approval workflow.

## How to use
1. Open Quality Inspection list
2. Click New
3. Select Item and Inspection Template
4. Fill inspection readings
5. Click Submit
6. Quality checks automatically route to QC Manager

## Approval Process
- QC Manager reviews first
- Manager reviews second
- Director gives final approval

Done! 2-page guide saved."

Output: apps/my_app/docs/guides/quality-inspection-guide.md
```

**Total Time:** Requirements → Production in ~2 hours with agent assistance!

---

## 11 Workflow Automations

Frappe-Builder includes 11 pre-built workflow automations:

### 1. Analyze Requirements
**Command:** `/bmad:frappe-builder:workflows:analyze-requirements`

Converts messy requirements into structured BRD with ERPNext module mapping.

### 2. Design Solution
**Command:** `/bmad:frappe-builder:workflows:design-solution`

Creates TSD using 4-tier framework with DocType designs and UX.

### 3. Sequence Tasks
**Command:** `/bmad:frappe-builder:workflows:sequence-tasks`

Orders implementation tasks by dependencies with User/Developer split.

### 4. Implement Phase (Formal)
**Command:** `/bmad:frappe-builder:workflows:implement-phase`
**Skill:** `/bmad-frappe-builder-implement-phase`

Formal TSD-based implementation with 7 structured steps: load TSD → identify components → server logic → client logic → deploy → validate → complete.

### 5. Implement Feature (Iterative)
**Command:** `/bmad:frappe-builder:workflows:implement-feature`
**Skill:** `/bmad-frappe-builder-implement-feature`

Bi-modal iterative development: **[N] New** (gather requirements → quick spec → implement → deploy → test) or **[R] Resume** (select from feature inventory → load context → continue from where you left off).

### 6. Diagnose Issue
**Command:** `/bmad:frappe-builder:workflows:diagnose-issue`

Root cause analysis of errors with anti-pattern detection.

### 7. Generate Tests
**Command:** `/bmad:frappe-builder:workflows:generate-tests`

Creates test scenarios (Happy/Sad/Edge/Evil) and unittest code.

### 8. Review Code
**Command:** `/bmad:frappe-builder:workflows:review-code`

Scans code for anti-patterns and suggests Frappe built-in alternatives.

### 9. Create Guide
**Command:** `/bmad:frappe-builder:workflows:create-guide`

Generates concise user guide (2-3 pages) with ERPNext terminology.

### 10. Create Roadmap
**Command:** `/bmad:frappe-builder:workflows:create-roadmap`

Builds phased implementation plan with dependency analysis.

### 11. Prepare Release
**Command:** `/bmad:frappe-builder:workflows:prepare-release`

Final checklist: code review, tests, docs, release notes.

---

## Knowledge Base Architecture

### Hybrid System: Unified KB + On-Demand Quickrefs

**Unified Knowledge Base** (Comprehensive)
- Location: `.bmad/frappe-builder/knowledge/`
- Comprehensive markdown files covering Frappe/ERPNext domains
- Categories: frappe-framework, erpnext-modules, development, debugging, best-practices
- **Single source of truth** for all Frappe knowledge

**Agent Quickrefs** (On-demand)
- Distilled 50-100 line quick references per specialist domain
- Loaded **on-demand** when an agent runs relevant commands (JIT, not at startup)
- Example: `4-tier-quickref.md` loaded when frappe-architect runs `*design`
- References unified KB for full details when needed

**Token Efficiency:** Agents stay lean — only load reference material when the task requires it.

---

## Best Practices

### 1. Always Start with Frappe-Nexus

Don't jump directly to specialists. Let Frappe-Nexus:
- Assess your situation
- Route you correctly
- Manage project state

### 2. Follow the Natural Flow

Requirements (BA) → Design (Architect) → Planning (Planner) → Code (Dev) → Test (QA) → Docs (Doc-Writer)

Skipping steps leads to rework.

### 3. Use the 4-Tier Framework

Always check lower tiers before jumping to custom code:
1. Can ERPNext do this standard?
2. Can I configure it?
3. Can I script it?
4. Only then: custom app

### 4. Let frappe-dev Enforce Standards

Don't try to remember all 11 coding principles - frappe-dev automatically:
- Uses frappe.utils
- Parameterizes queries
- Checks permissions
- Writes self-documenting code
- Handles errors properly

### 5. Debug Early and Often

Don't wait for errors to pile up. Use frappe-debugger to:
- Review code for anti-patterns
- Catch issues before production
- Learn better patterns

### 6. Maintain Project State

Agents automatically write to `session.yaml` at each step boundary — you don't need to manage it manually. What to know:
- `active.yaml` only needs updating if you change site, app, or bench path
- `session.yaml` is written by every workflow step (last/next action, current feature, step number)
- `inventory.yaml` is auto-created and updated by the implement-feature workflow on feature completion

This ensures agents always know where you left off when you return.

### 7. One Project at a Time

While multi-project support exists, focus on one project per session for clarity.

Switch projects at natural breakpoints (end of phase, waiting for feedback).

---

## Troubleshooting

### Agent doesn't load project state

**Symptom:** Agent asks which app you're working on every time

**Fix:**
1. Check if `active-project.txt` exists in `.bmad/frappe-builder/state/`
2. Ensure it contains a valid project folder name
3. Verify project folder exists in `state/` directory

### Can't find unified KB files

**Symptom:** Agent says "knowledge file not found"

**Fix:**
1. Verify `.bmad/frappe-builder/knowledge/` directory exists
2. Re-run BMAD installer if files missing
3. Check agent is referencing correct path

### Workflows fail with "workflow.yaml not found"

**Symptom:** Workflow invocation errors

**Fix:**
1. Ensure frappe-builder is installed in `.bmad/frappe-builder/`
2. Not in src/modules/ - that's the source, not installed location
3. Check workflow path in agent menu commands

### Multiple projects conflict

**Symptom:** Wrong project state loading

**Fix:**
1. Verify `active-project.txt` points to correct project
2. Each project should have its own folder in `state/`
3. Don't manually edit state files - let agents manage them

### Agent loads wrong standards

**Symptom:** Agent references old coding principles

**Fix:**
1. Clear Claude Code cache
2. Restart agent session
3. Verify `standards/development/coding-principles.md` has latest content (should have 12 rules now)

---

## Advanced Usage

### Custom Agent Commands

Add frappe-builder agents to frappe-nexus menu for quick access:

```yaml
menu:
  - trigger: "*ba"
    action: "Invoke ERPNext BA specialist"
```

### Workflow Chaining

Chain multiple workflows for complex operations:

1. analyze-requirements
2. design-solution
3. implement-feature
4. generate-tests

### Knowledge Base Expansion

Add project-specific knowledge to unified KB:

```
knowledge/
└── custom/
    └── my-company-patterns.md
```

Reference in agent critical_actions.

---

## Summary

Frappe-Builder provides:
- ✅ **8 Specialized Agents** covering complete SDLC
- ✅ **11 Workflow Automations** for common tasks
- ✅ **Multi-Project Support** with isolated state
- ✅ **Token-Efficient Architecture** (88% reduction)
- ✅ **Comprehensive Standards** (11 coding principles)
- ✅ **Production-Ready Output** following Frappe best practices

Start with **Frappe-Nexus**, follow the natural workflow, and let the specialists guide you through professional Frappe development!

**Need help?** Frappe-Nexus is always your starting point: `/bmad:frappe-builder:agents:frappe-nexus`
