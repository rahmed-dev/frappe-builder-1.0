# BMAD Module Building - Learning Path

**Purpose:** Learn how to build BMAD-compliant modules before migrating frappe-builder

**Estimated Time:** 4-6 hours of reading + 4-6 hours of practice

---

## 📚 Learning Sequence

### **Phase 1: Core Concepts** (2 hours)

Read in this order:

1. **Module Standards** (30 min)
   - Location: `_bmad/bmb/workflows/module/data/module-standards.md`
   - **Learn:** What is a module, 3 types, required structure
   - **Key Takeaway:** Module anatomy, naming conventions

2. **Module YAML Conventions** (45 min)
   - Location: `_bmad/bmb/workflows/module/data/module-yaml-conventions.md`
   - **Learn:** Variable system, configuration, how variables flow to agents/workflows
   - **Key Takeaway:** How to define user prompts, use variables

3. **Module Installer Standards** (30 min)
   - Location: `_bmad/bmb/workflows/module/data/module-installer-standards.md`
   - **Learn:** When to use installers, installer.js pattern
   - **Key Takeaway:** Platform-specific setup

4. **Quick Review** (15 min)
   - **Action:** Create a mental model of how modules work
   - **Question:** Can I explain module structure to someone?

---

### **Phase 2: Agent Architecture** (1.5 hours)

Read in this order:

1. **Agent Architecture (Module Context)** (30 min)
   - Location: `_bmad/bmb/workflows/module/data/agent-architecture.md`
   - **Learn:** Single vs multi-agent, BMM team example, sidecar pattern
   - **Key Takeaway:** How to plan agent teams

2. **Expert Agent Architecture** (30 min)
   - Location: `_bmad/bmb/workflows/agent/data/expert-agent-architecture.md`
   - **Learn:** Complex agent patterns
   - **Key Takeaway:** When to use detailed personas

3. **Simple Agent Architecture** (30 min)
   - Location: `_bmad/bmb/workflows/agent/data/simple-agent-architecture.md`
   - **Learn:** Lightweight agent patterns
   - **Key Takeaway:** When simplicity is better

---

### **Phase 3: Workflow Architecture** (2 hours)

Read in this order:

1. **Workflow Architecture** (45 min)
   - Location: `_bmad/bmb/workflows/workflow/data/architecture.md`
   - **Learn:** Micro-file design, JIT loading, sequential enforcement
   - **Key Takeaway:** Why workflows are split into step files

2. **Step Type Patterns** (30 min)
   - Location: `_bmad/bmb/workflows/workflow/data/step-type-patterns.md`
   - **Learn:** Different step patterns (init, gather, build, validate)
   - **Key Takeaway:** Step taxonomy

3. **Menu Handling Standards** (30 min)
   - Location: `_bmad/bmb/workflows/workflow/data/menu-handling-standards.md`
   - **Learn:** [A]/[P]/[C] pattern, menu-driven continuation
   - **Key Takeaway:** How users control workflow flow

4. **Workflow Examples** (15 min)
   - Location: `_bmad/bmb/workflows/workflow/data/workflow-examples.md`
   - **Learn:** Real-world patterns
   - **Key Takeaway:** What good workflows look like

---

### **Phase 4: Practice** (4-6 hours)

**Option A: Study Existing Modules**

1. **Study BMM Module** (2 hours)
   - Location: `_bmad/bmm/`
   - **Examine:**
     - `module.yaml` - How variables are defined
     - `agents/*.md` - Agent structure (especially dev.md, architect.md)
     - `workflows/*/workflow.md` - Entry points
     - `workflows/*/steps-*/` - Step-by-step execution
   - **Key Insight:** How a complete 9-agent module works

2. **Study BMB Module** (1 hour)
   - Location: `_bmad/bmb/`
   - **Examine:**
     - `agents/module-builder.md` - You already met me!
     - `workflows/module/workflow.md` - Quad-modal pattern
     - `workflows/agent/workflow.md` - Agent creation workflow
   - **Key Insight:** How meta-modules work (modules that create modules)

3. **Compare with Frappe-Builder** (1 hour)
   - Location: Your source `/home/riz/work-bench/frappe-builder/`
   - **Questions to Answer:**
     - How does frappe-builder differ from BMM?
     - What patterns does frappe-builder use that aren't BMAD-standard?
     - What needs to change to align with BMAD?

**Option B: Create a Test Module** (6 hours)

1. **Design Mini-Module** (1 hour)
   - Create: `test-module/module.yaml`
   - Define: 1-2 variables
   - Plan: 1 simple agent, 1 simple workflow

2. **Build Agent** (2 hours)
   - Create: `test-module/agents/test-agent.agent.yaml`
   - Follow: BMAD agent architecture patterns
   - Test: Installation, activation

3. **Build Workflow** (3 hours)
   - Create: `test-module/workflows/test-flow/workflow.md`
   - Create: `steps-c/step-01-init.md`, `step-02-execute.md`, `step-03-complete.md`
   - Follow: Micro-file design, menu pattern
   - Test: Execution, continuation

---

## 🎯 Key Questions to Answer

After completing this learning path, you should be able to answer:

### **Module Level:**
- [ ] What are the 3 module types and when to use each?
- [ ] What files are required in every module?
- [ ] How do variables in module.yaml flow to agents and workflows?
- [ ] When do you need a `_module-installer/` folder?

### **Agent Level:**
- [ ] When should I use multiple agents vs. one agent with sidecar?
- [ ] What's the difference between expert and simple agent architecture?
- [ ] How do agents coordinate (shared vs specialty commands)?
- [ ] What is the `hasSidecar` pattern and when to use it?

### **Workflow Level:**
- [ ] Why are workflows split into micro-files (step files)?
- [ ] What is Just-In-Time loading and why does it matter?
- [ ] How does the [A]/[P]/[C] menu pattern work?
- [ ] How do workflows track state and resume?
- [ ] What goes in frontmatter vs. step body?

### **Integration:**
- [ ] How do agents trigger workflows?
- [ ] How do workflows update state for agents to read?
- [ ] How does module.yaml configuration reach agents/workflows?

---

## 🚨 Critical Insights for Frappe-Builder Migration

After studying BMAD docs, you'll realize:

### **1. State Management Pattern**

**BMAD Standard:**
- State lives in **frontmatter variables** (workflow-level)
- Module configuration in **module.yaml** (user prompts)
- No external `active.yaml` files

**Frappe-Builder Current:**
- State lives in `state/{project}/active.yaml` (custom external files)
- Agents load state via `critical_actions`
- Not aligned with BMAD patterns

**Decision Needed:**
- Keep custom state pattern (not BMAD-compliant)?
- Migrate to BMAD frontmatter pattern (big refactor)?
- Hybrid approach?

---

### **2. Workflow Structure**

**BMAD Standard:**
- `workflow.md` = lean entry point (routing only)
- `steps-c/step-01-*.md` = micro-files (one concept each)
- Progressive disclosure (user sees one step at a time)

**Frappe-Builder Current:**
- `workflow.yaml` = config
- `instructions.md` = single file with ALL steps (XML blocks)
- Linear execution (all steps visible)

**Decision Needed:**
- Refactor to micro-file architecture?
- Keep monolithic instructions.md?
- How much BMAD compliance is needed?

---

### **3. Agent Activation**

**BMAD Standard:**
- Agents get config from `module.yaml` variables
- Activation steps load config, set context
- State tracked in workflow frontmatter

**Frappe-Builder Current:**
- Agents load `active-project.txt` → `active.yaml`
- Custom state management outside BMAD system
- Unique to frappe-builder (not portable)

**Decision Needed:**
- Migrate to BMAD config system?
- Keep custom state files?
- Document as "frappe-builder-specific extension"?

---

## 🎯 Recommended Next Steps

### **After Completing Learning Path:**

1. **Decision Session** (1-2 hours)
   - Review findings
   - Decide: Full BMAD compliance vs. Hybrid vs. Custom
   - Document deviations (if any)
   - Update migration plan based on decisions

2. **Refine Migration Plan** (2-4 hours)
   - If **Full BMAD Compliance:** Major refactor needed
     - Convert workflows to micro-file architecture
     - Move state to frontmatter variables
     - Align agents with BMAD activation patterns

   - If **Hybrid Approach:** Document extensions
     - Keep custom state pattern
     - Document as "frappe-builder extensions to BMAD"
     - Ensure compatibility with core BMAD features

   - If **Custom:** Fork and maintain separately
     - frappe-builder as standalone (not BMAD module)
     - Full control, no BMAD constraints

3. **Test Proof of Concept** (4-6 hours)
   - Pick ONE agent (frappe-dev)
   - Pick ONE workflow (implement-feature)
   - Migrate to chosen pattern (BMAD/Hybrid/Custom)
   - Test thoroughly
   - Validate approach before scaling

---

## 📋 Learning Checklist

Track your progress:

### Phase 1: Core Concepts
- [ ] Read module-standards.md
- [ ] Read module-yaml-conventions.md
- [ ] Read module-installer-standards.md
- [ ] Can explain: What is a BMAD module?

### Phase 2: Agent Architecture
- [ ] Read agent-architecture.md
- [ ] Read expert-agent-architecture.md
- [ ] Read simple-agent-architecture.md
- [ ] Can explain: Single vs multi-agent decision

### Phase 3: Workflow Architecture
- [ ] Read workflow architecture.md
- [ ] Read step-type-patterns.md
- [ ] Read menu-handling-standards.md
- [ ] Read workflow-examples.md
- [ ] Can explain: Why micro-files and JIT loading?

### Phase 4: Practice
- [ ] Study BMM module structure
- [ ] Study BMB module structure
- [ ] Compare with frappe-builder
- [ ] Create test module (optional but recommended)

### Decision & Planning
- [ ] Determine BMAD compliance level
- [ ] Document deviations (if any)
- [ ] Refine migration plan
- [ ] Create proof of concept

---

## 🆘 Reference Quick Links

**Module Building:**
- `_bmad/bmb/workflows/module/data/` - All module docs

**Agent Building:**
- `_bmad/bmb/workflows/agent/data/` - All agent docs

**Workflow Building:**
- `_bmad/bmb/workflows/workflow/data/` - All workflow docs

**Live Examples:**
- `_bmad/bmm/` - BMM module (9 agents, full software delivery)
- `_bmad/bmb/` - BMB module (meta-module for building modules)

---

**Good luck on your learning journey, Riz!**

Once you complete this, you'll have the knowledge to make informed decisions about your frappe-builder migration strategy.
