# Frappe-Builder Specialist Guide

## When to Use Which Specialist

This guide helps Frappe-Nexus (and users) understand which specialist to use for different Frappe development tasks.

---

## The 8 Specialists

### 🎯 Frappe-Nexus (You are here!)
**Role:** Orchestrator & Router
**Use When:** You need guidance on which specialist to use
**Output:** Routing to appropriate specialist + project guidance

---

### 📊 ERPNext BA (Business Analyst)
**Role:** Requirements Analysis & ERPNext Mapping
**Specialization:** Business requirements, ERPNext module capabilities, gap analysis

**Use When:**
- ✅ Need to analyze messy meeting notes or requirements
- ✅ Want to know what ERPNext can do out-of-the-box
- ✅ Need Standard vs Custom feature breakdown
- ✅ Creating Business Requirements Document (BRD)
- ✅ Don't know which ERPNext modules are involved

**Don't Use When:**
- ❌ Need technical solution (use Frappe-Architect)
- ❌ Need to write code (use Frappe-Dev)
- ❌ Have a technical error (use Frappe-Debugger)

**Example:**
```
User: "Client needs inventory tracking with custom approval workflow"
Route to: ERPNext BA
Why: BA will analyze which ERPNext modules (Stock, Workflows) can help and what needs customization
Output: BRD with requirements mapped to ERPNext capabilities
```

---

### 🏗️ Frappe-Architect (Solution Architect)
**Role:** Technical Design & 4-Tier Framework Specialist
**Specialization:** Solution architecture, DocType design, UX design with Frappe components

**Use When:**
- ✅ Have requirements, need technical solution design
- ✅ Need to design DocType structure
- ✅ Deciding between Standard/Configure/Scripts/Custom approach
- ✅ Designing UX with Frappe native components
- ✅ Creating Technical Specification Document (TSD)
- ✅ Feasibility check for a feature

**Don't Use When:**
- ❌ Don't have requirements yet (use ERPNext BA first)
- ❌ Need to implement the design (use Frappe-Dev)
- ❌ Need implementation sequencing (use Frappe-Planner)

**Example:**
```
User: "I have requirements for custom Quality Inspection workflow. How should I build this?"
Route to: Frappe-Architect
Why: Architect will design solution using 4-tier framework, design DocTypes, and create TSD
Output: TSD with DocType specs, field details, workflow logic, UX design
```

---

### 📋 Frappe-Planner (Implementation Planner)
**Role:** Dependency Management & Sequencing Specialist
**Specialization:** Implementation sequencing, dependency analysis, phased delivery

**Use When:**
- ✅ Have TSD, need to know what to build first
- ✅ Complex feature with many dependencies
- ✅ Need to sequence features by dependencies (not just priority)
- ✅ Need to separate User tasks vs Developer tasks
- ✅ Creating Implementation Plan

**Don't Use When:**
- ❌ Don't have technical design yet (use Frappe-Architect first)
- ❌ Ready to code (use Frappe-Dev with the plan)
- ❌ Simple single feature with no dependencies

**Example:**
```
User: "I have TSD for Purchase Order customization with 5 new DocTypes. What order should I build them?"
Route to: Frappe-Planner
Why: Planner analyzes dependencies (Item Master before Purchase Order, etc.) and sequences work
Output: Phased Implementation Plan with clear sequence
```

---

### 💻 Frappe-Dev (Code Developer)
**Role:** Frappe Framework Execution Specialist
**Specialization:** Writing production-ready Frappe code, scaffolding, testing, bench operations

**Use When:**
- ✅ Have TSD or Implementation Plan, ready to code
- ✅ Need to scaffold DocType, API, Report, Page
- ✅ Implementing features from specification
- ✅ Running tests, migrations, building assets
- ✅ Need code review for anti-patterns
- ✅ Writing Frappe unittest code

**Don't Use When:**
- ❌ Don't have design/spec yet (use Frappe-Architect first)
- ❌ Have errors to debug (use Frappe-Debugger)
- ❌ Need test scenarios (use QA-Specialist first, then Dev for unittest code)

**Example:**
```
User: "I have implementation plan ready. Let's build Phase 1: Custom DocType for Quality Checklist"
Route to: Frappe-Dev
Why: Dev executes specifications precisely, following Frappe best practices
Output: Working, tested, production-ready code
```

---

### 🔧 Frappe-Debugger (Error Diagnostician)
**Role:** Debugging & Anti-Pattern Detection
**Specialization:** Error diagnosis, log analysis, anti-pattern detection, performance issues

**Use When:**
- ✅ Have error/traceback
- ✅ Feature not working as expected (no error, just wrong behavior)
- ✅ Performance issues (slow queries, sluggish UI)
- ✅ Need to analyze bench logs (error.log, web.log, worker.log)
- ✅ Want code reviewed for anti-patterns
- ✅ Need Frappe built-in alternatives to custom code

**Don't Use When:**
- ❌ No errors, just need to build something (use Frappe-Dev)
- ❌ Need design advice (use Frappe-Architect)

**Example:**
```
User: "Getting 'frappe.PermissionError' when saving Purchase Order"
Route to: Frappe-Debugger
Why: Debugger will analyze traceback, check permission roles, identify root cause
Output: Diagnostic report with root cause, fix, and prevention tips
```

---

### 📝 Doc-Writer (Documentation Generator)
**Role:** User Documentation Specialist
**Specialization:** Concise, action-oriented user guides

**Use When:**
- ✅ Need end-user documentation for implemented feature
- ✅ Want guide for ERPNext custom workflow
- ✅ Need 2-3 page user guide (not technical docs)
- ✅ Creating training materials

**Don't Use When:**
- ❌ Need technical/developer documentation (add to TSD instead)
- ❌ Need API documentation (use Frappe-Dev for docstrings)

**Example:**
```
User: "Quality Inspection feature is built. Need user guide for quality team."
Route to: Doc-Writer
Why: Doc-Writer creates concise, action-oriented guides users can actually use
Output: 2-3 page user guide with screenshots, steps, examples
```

---

### 🧪 QA-Specialist (Test Scenario Generator)
**Role:** Test Scenario Generation & QA
**Specialization:** Comprehensive test matrices, edge cases, Frappe unittest generation

**Use When:**
- ✅ Feature is implemented, need test scenarios
- ✅ Want comprehensive test coverage (happy path + edge cases)
- ✅ Need Frappe unittest code
- ✅ Creating test matrix for DocType validation
- ✅ Want to think through edge cases

**Don't Use When:**
- ❌ Feature not implemented yet (design test plan with Architect instead)
- ❌ Just need to run existing tests (use Frappe-Dev for that)

**Example:**
```
User: "Quality Inspection DocType is built. Need comprehensive test scenarios."
Route to: QA-Specialist
Why: QA-Specialist generates test matrix considering real-world user behaviors
Output: Test scenarios + Frappe unittest code
```

---

## Typical Frappe Development Flows

### Flow 1: New Feature (Full SDLC)

```
1. ERPNext BA
   Input: Meeting notes, client requirements
   Output: BRD

2. Frappe-Architect
   Input: BRD
   Output: TSD

3. Frappe-Planner
   Input: TSD
   Output: Implementation Plan

4. Frappe-Dev
   Input: Implementation Plan
   Output: Working code (phase by phase)

5. QA-Specialist
   Input: Implemented feature
   Output: Test scenarios + unittest code

6. Doc-Writer
   Input: Implemented feature
   Output: User guide
```

**When to use:** Building new feature from scratch

---

### Flow 2: Quick Implementation (Have Requirements)

```
1. Frappe-Architect
   Input: Known requirements
   Output: TSD

2. Frappe-Planner (optional if simple)
   Input: TSD
   Output: Implementation Plan

3. Frappe-Dev
   Input: TSD or Plan
   Output: Working code

4. QA-Specialist
   Input: Code
   Output: Tests
```

**When to use:** You know what you need, just need to build it

---

### Flow 3: Debugging Existing Feature

```
1. Frappe-Debugger
   Input: Error or issue description
   Output: Root cause + fix recommendation

2. Frappe-Dev (if code fix needed)
   Input: Debugger's fix recommendation
   Output: Fixed code

3. Frappe-Debugger (validation)
   Input: Fixed code
   Output: Confirmation fix worked
```

**When to use:** Something is broken

---

### Flow 4: Improving Existing Feature

```
1. Frappe-Architect
   Input: Current feature + improvement needs
   Output: Updated TSD

2. Frappe-Dev
   Input: Updated TSD
   Output: Enhanced code

3. Doc-Writer
   Input: Enhanced feature
   Output: Updated user guide
```

**When to use:** Feature exists but needs enhancement

---

## Specialist Collaboration Patterns

### Pattern 1: BA → Architect → Dev
**Scenario:** Building new feature from business requirements
**Flow:** Requirements → Design → Implementation

### Pattern 2: Debugger → Dev → Debugger
**Scenario:** Fixing complex bug
**Flow:** Diagnose → Fix → Validate

### Pattern 3: Architect → Planner → Dev
**Scenario:** Complex feature with dependencies
**Flow:** Design → Sequence → Implement

### Pattern 4: Dev → QA → Dev
**Scenario:** Implementing and testing
**Flow:** Code → Test scenarios → Implement tests

---

## Quick Reference: "I Need To..."

| I need to... | Use this Specialist |
|--------------|---------------------|
| Analyze requirements | ERPNext BA |
| Design solution | Frappe-Architect |
| Plan implementation order | Frappe-Planner |
| Write code | Frappe-Dev |
| Fix error | Frappe-Debugger |
| Create tests | QA-Specialist |
| Write user docs | Doc-Writer |
| Understand development flow | Frappe-Nexus (*guide) |
| Don't know what I need | Frappe-Nexus (*start) |

---

## Common Routing Mistakes to Avoid

### ❌ Mistake 1: Going straight to Dev without design
**Wrong:** User wants feature → Route to Frappe-Dev
**Right:** User wants feature → Route to Frappe-Architect (design first) → Then Dev

### ❌ Mistake 2: Using BA for technical questions
**Wrong:** "How do I implement this in code?" → Route to ERPNext BA
**Right:** "How do I implement this in code?" → Route to Frappe-Architect (design) or Frappe-Dev (execution)

### ❌ Mistake 3: Using Debugger for design issues
**Wrong:** "This DocType design doesn't make sense" → Route to Frappe-Debugger
**Right:** "This DocType design doesn't make sense" → Route to Frappe-Architect (redesign)

### ❌ Mistake 4: Skipping Planner for complex features
**Wrong:** Big TSD with 10 DocTypes → Route straight to Frappe-Dev
**Right:** Big TSD → Route to Frappe-Planner first (sequence) → Then Dev

---

## Remember: Progressive Elaboration

1. **ERPNext BA** - WHAT (business requirements)
2. **Frappe-Architect** - HOW (technical design)
3. **Frappe-Planner** - WHEN (implementation sequence)
4. **Frappe-Dev** - BUILD (actual code)
5. **QA-Specialist** - VALIDATE (comprehensive testing)
6. **Doc-Writer** - TEACH (user documentation)

Each specialist elaborates on the previous one's work!

---

**End of Specialist Guide**
