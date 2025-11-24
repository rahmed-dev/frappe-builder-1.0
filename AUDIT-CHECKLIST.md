# Frappe-Builder Module - Audit Checklist

**Purpose:** Validate module completeness, BMAD compliance, and operational readiness

**Date:** 2025-11-23
**Version:** 1.0.0

---

## 1. Agent Configuration Audit

### 1.1 Knowledge Base Loading

**Check:** Do agents load KB files in critical_actions?

| Agent | KB Files Referenced | Status |
|-------|---------------------|--------|
| frappe-nexus | Should reference specialist-guide.md | ⏸️ TODO |
| erpnext-ba | Should reference erpnext-modules/*.md | ⏸️ TODO |
| frappe-architect | Should reference 4-tier-framework.md, configure-first-approach.md | ⏸️ TODO |
| frappe-planner | Should reference implementation patterns | ⏸️ TODO |
| frappe-dev | Should reference frappe-dev-critical.md, coding-principles.md | ✅ DONE |
| frappe-debugger | Should reference frappe-anti-patterns.md | ⏸️ TODO |
| doc-writer | Should reference anti-fluff-mandate.md, user-guide-template.md | ⏸️ TODO |
| qa-specialist | Should reference test-matrix-template.md | ⏸️ TODO |

**Validation Steps:**
```bash
# For each agent, check critical_actions section
grep -A 30 "critical_actions:" agents/*.agent.yaml | grep "Load.*knowledge"
```

**Expected:** Each agent loads relevant KB files from knowledge/ directory

---

### 1.2 Standards File Loading

**Check:** Do agents load and reference standards files?

| Standard File | Agents Should Load | Status |
|---------------|-------------------|--------|
| coding-principles.md | frappe-dev, frappe-architect, qa-specialist | ⏸️ PARTIAL |
| anti-fluff-mandate.md | doc-writer, all agents (documentation output) | ⏸️ TODO |
| token-efficiency.md | All agents | ⏸️ TODO |
| security-guidelines.md | frappe-dev, qa-specialist | ⏸️ TODO |
| performance-rules.md | frappe-dev, frappe-architect | ⏸️ TODO |
| frappe-tech-stack.md | frappe-architect, frappe-dev, erpnext-ba | ⏸️ TODO |

**Validation Steps:**
```bash
# Check if standards are referenced in critical_actions
grep -r "standards/" agents/*.agent.yaml
```

**Expected:** Agents load standards at initialization

---

### 1.3 Template Usage

**Check:** Do agents reference and use templates?

| Template Type | Agents Should Use | How Used |
|---------------|------------------|----------|
| brd-template.md | erpnext-ba | Generate Business Requirements |
| tsd-template.md | frappe-architect | Generate Technical Specs |
| implementation-plan-template.md | frappe-planner | Generate Implementation Plans |
| diagnostic-report-template.md | frappe-debugger | Generate Error Reports |
| test-matrix-template.md | qa-specialist | Generate Test Scenarios |
| user-guide-template.md | doc-writer | Generate User Guides |
| doctype-controller-template.py | frappe-dev | Generate DocType controllers |
| client-script-template.js | frappe-dev | Generate Client Scripts |
| server-script-template.py | frappe-dev | Generate Server Scripts |

**Validation Steps:**
```bash
# Check if templates are referenced in workflows or agent instructions
grep -r "template" agents/*.agent.yaml workflows/*/instructions.md
```

**Expected:** Agent instructions or workflows reference templates

---

### 1.4 Task File Integration

**Check:** Do workflows use reusable task files?

| Task Category | Files | Used By Workflows |
|--------------|-------|-------------------|
| bench/ | run-migrate.xml, build-assets.xml, run-tests.xml, check-site.xml | ⏸️ TODO |
| validation/ | validate-doctype.xml, check-permissions.xml, test-workflow.xml, validate-code.xml | ⏸️ TODO |
| scaffolding/ | create-doctype.xml, create-api.xml, create-report.xml | ⏸️ TODO |

**Validation Steps:**
```bash
# Check if workflows reference task files
grep -r "tasks/" workflows/*/workflow.yaml workflows/*/instructions.md
```

**Expected:** Workflows reference task files for reusable operations

---

## 2. Code Quality Standards Compliance

### 2.1 Agent Instruction Quality

**Check:** Do agents follow code quality mandates?

| Agent | Rule 0 Awareness | Helper Function Rules | Descriptive Naming | Simple Solutions |
|-------|-----------------|----------------------|-------------------|------------------|
| frappe-dev | ✅ YES | ✅ YES (3+ uses rule) | ✅ YES | ✅ YES |
| frappe-architect | ✅ YES | ⏸️ CHECK | ⏸️ CHECK | ⏸️ CHECK |
| qa-specialist | ⏸️ CHECK | ⏸️ CHECK | ⏸️ CHECK | ⏸️ CHECK |

**Validation Points:**
- [ ] Agent persona mentions "self-documenting code"
- [ ] Agent persona mentions "descriptive naming (no 'x', 'data', 'temp')"
- [ ] Agent persona mentions "helper functions only when used 3+ times"
- [ ] Agent persona mentions "keep it simple - no over-engineering"
- [ ] Agent persona mentions "no clever code - obvious solutions"

**Validation Steps:**
```bash
# Check frappe-dev for code quality mandates
grep -A 20 "CODE QUALITY" agents/frappe-dev.agent.yaml
```

**Expected:** All dev-related agents have code quality mandates in persona

---

### 2.2 Anti-Pattern Detection

**Check:** Do validation tasks and agents check for anti-patterns?

**Anti-Patterns Covered:**
- [ ] Missing @frappe.whitelist() decorators
- [ ] Client-side filtering (should be server-side)
- [ ] Custom HTML/CSS instead of frappe.ui components
- [ ] String concatenation in SQL queries
- [ ] Missing permission checks
- [ ] Not using frappe.utils for dates/numbers
- [ ] console.log() in production code
- [ ] Cryptic variable names (x, data, temp)
- [ ] Unnecessary helper functions (used 1-2 times only)
- [ ] Missing type conversion for form values

**Validation Steps:**
```bash
# Check validate-code.xml for anti-patterns
cat tasks/validation/validate-code.xml | grep -A 5 "anti_patterns"
```

**Expected:** All anti-patterns documented in validation tasks

---

## 3. Token Efficiency Audit

### 3.1 Agent Instruction Length

**Check:** Are agent instructions token-efficient?

| Agent | Instruction Length | Token Efficiency | Status |
|-------|-------------------|-----------------|--------|
| frappe-nexus | TBD | TBD | ⏸️ TODO |
| erpnext-ba | TBD | TBD | ⏸️ TODO |
| frappe-architect | TBD | TBD | ⏸️ TODO |
| frappe-planner | TBD | TBD | ⏸️ TODO |
| frappe-dev | TBD | TBD | ⏸️ TODO |
| frappe-debugger | TBD | TBD | ⏸️ TODO |
| doc-writer | TBD | TBD | ⏸️ TODO |
| qa-specialist | TBD | TBD | ⏸️ TODO |

**Token Efficiency Targets:**
- Agent YAML file: <500 lines
- Sidecar instructions.md: <1000 lines
- Sidecar KB files: Reference shared KB, not duplicate

**Validation Steps:**
```bash
# Count lines in agent files
wc -l agents/*.agent.yaml

# Count lines in sidecar instructions
wc -l agents/*/instructions.md

# Check for duplication between agents
diff agents/frappe-dev-sidecar/instructions.md agents/frappe-architect-sidecar/instructions.md
```

**Expected:**
- No massive instruction files (>2000 lines)
- Standards referenced, not duplicated
- KB files shared, not agent-specific copies

---

### 3.2 KB File Token Efficiency

**Check:** Are KB files compressed and anti-fluff?

| KB File | Word Count | Target | Anti-Fluff | Tables Used |
|---------|-----------|--------|------------|-------------|
| manufacturing.md | ~800 | <1000 | ✅ YES | ✅ YES |
| hr-payroll.md | ~650 | <1000 | ✅ YES | ✅ YES |
| stock-inventory.md | ~600 | <1000 | ✅ YES | ✅ YES |
| quality-management.md | ~550 | <1000 | ✅ YES | ✅ YES |
| best-practices.md (server) | ~400 | <800 | ✅ YES | ✅ YES |
| best-practices.md (client) | ~450 | <800 | ✅ YES | ✅ YES |

**Anti-Fluff Checklist per File:**
- [ ] No "What is..." introductions (users know context)
- [ ] No motivational language
- [ ] No redundant explanations
- [ ] Tables over prose
- [ ] Bullets over paragraphs
- [ ] Code examples over descriptions
- [ ] No forbidden phrases: "comprehensive", "robust", "powerful", "cutting-edge"

**Validation Steps:**
```bash
# Check word count
wc -w knowledge/**/*.md

# Check for forbidden phrases
grep -r "comprehensive\|robust\|powerful\|cutting-edge" knowledge/
```

**Expected:** All KB files <1000 words, zero forbidden phrases

---

### 3.3 Template Conciseness

**Check:** Are templates concise and practical?

| Template | Word Count | Target | Practical |
|----------|-----------|--------|-----------|
| brd-template.md | TBD | <500 | ⏸️ CHECK |
| tsd-template.md | TBD | <800 | ⏸️ CHECK |
| implementation-plan-template.md | TBD | <500 | ⏸️ CHECK |
| user-guide-template.md | TBD | <500 | ✅ YES |

**Validation Steps:**
```bash
# Check template word counts
wc -w templates/**/*.md
```

**Expected:** User-facing templates <500 words, technical templates <800 words

---

## 4. BMAD v6 Compliance

### 4.1 Module Structure

**Check:** Does module follow BMAD v6 conventions?

**Directory Structure:**
```
frappe-builder/
├── agents/                   ✅ Required
│   ├── *.agent.yaml         ✅ YAML source format
│   └── *-sidecar/           ✅ Sidecar folders
├── workflows/               ✅ Required
│   └── */
│       ├── workflow.yaml    ✅ Workflow definition
│       └── instructions.md  ✅ Workflow instructions
├── standards/               ✅ Required (frappe-builder specific)
│   ├── core/               ✅ Core standards
│   └── development/        ✅ Dev standards
├── templates/              ✅ Required (frappe-builder specific)
│   ├── documents/          ✅ Document templates
│   ├── technical/          ✅ Technical templates
│   └── code/               ✅ Code templates
├── tasks/                  ✅ Required (frappe-builder specific)
│   ├── bench/              ✅ Bench tasks
│   ├── validation/         ✅ Validation tasks
│   └── scaffolding/        ✅ Scaffolding tasks
├── knowledge/              ✅ Required (shared KB)
│   ├── frappe-framework/   ✅ Framework KB
│   ├── erpnext-modules/    ✅ Module KB
│   └── development/        ✅ Development KB
├── config.yaml             ✅ Required
├── install.sh              ✅ Required
├── README.md               ✅ Required
└── PROGRESS-REPORT.md      ✅ Tracking document
```

**Validation Steps:**
```bash
# Check directory structure exists
tree -L 2 /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

# Verify required files
ls -la config.yaml install.sh README.md
```

**Expected:** All required directories and files present

---

### 4.2 Agent YAML Format

**Check:** Are agent files valid BMAD v6 YAML?

**Required Fields:**
- [ ] `name:` - Agent identifier
- [ ] `title:` - Display title
- [ ] `icon:` - Agent icon
- [ ] `type:` - Agent type (expert/utility)
- [ ] `module:` - Module name (frappe-builder)
- [ ] `metadata:` - description, version, author, role
- [ ] `critical_actions:` - Activation steps
- [ ] `persona:` - role, identity, communication_style, principles
- [ ] `menu:` - Command menu

**Validation Steps:**
```bash
# Validate YAML syntax
yamllint agents/*.agent.yaml

# Check required fields present
for f in agents/*.agent.yaml; do
    echo "Checking $f"
    grep -q "^name:" $f && echo "  ✅ name" || echo "  ❌ name"
    grep -q "^title:" $f && echo "  ✅ title" || echo "  ❌ title"
    grep -q "^icon:" $f && echo "  ✅ icon" || echo "  ❌ icon"
    grep -q "^type:" $f && echo "  ✅ type" || echo "  ❌ type"
    grep -q "^module:" $f && echo "  ✅ module" || echo "  ❌ module"
done
```

**Expected:** All agent YAML files valid and complete

---

### 4.3 Workflow Structure

**Check:** Do workflows follow BMAD v6 structure?

**Required Files per Workflow:**
- [ ] workflow.yaml - Workflow definition
- [ ] instructions.md - Agent instructions
- [ ] Optional: template.md - Output template

**workflow.yaml Required Fields:**
- [ ] `name:` - Workflow identifier
- [ ] `title:` - Display title
- [ ] `description:` - Brief description
- [ ] `agent:` - Primary agent
- [ ] `steps:` - Workflow steps

**Validation Steps:**
```bash
# Check each workflow has required files
for d in workflows/*/; do
    echo "Checking $d"
    [ -f "$d/workflow.yaml" ] && echo "  ✅ workflow.yaml" || echo "  ❌ workflow.yaml"
    [ -f "$d/instructions.md" ] && echo "  ✅ instructions.md" || echo "  ❌ instructions.md"
done

# Validate workflow.yaml syntax
yamllint workflows/*/workflow.yaml
```

**Expected:** All workflows complete and valid

---

### 4.4 Config File Validity

**Check:** Is config.yaml valid and complete?

**Required Fields:**
```yaml
module:
  name: frappe-builder
  version: "1.0.0"
  description: "..."

user_name: "{user_name}"
communication_language: "{communication_language}"
project_root: "{project-root}"
agent_folder: "{agent-folder}"
```

**Validation Steps:**
```bash
# Validate config.yaml syntax
yamllint config.yaml

# Check required fields
grep -q "module:" config.yaml && echo "✅ module section" || echo "❌ module section"
grep -q "user_name:" config.yaml && echo "✅ user_name" || echo "❌ user_name"
```

**Expected:** Valid config with all required fields

---

## 5. Module Installer Functionality

### 5.1 Install Script Validation

**Check:** Does install.sh work correctly?

**Installation Steps to Test:**
```bash
# 1. Backup test
cd /home/riz/frappe-bench/.bmad/custom/modules/
cp -r frappe-builder frappe-builder-test-backup

# 2. Run installer
cd frappe-builder
./install.sh

# 3. Check outputs
# - Should compile agents from YAML to MD
# - Should show success messages
# - Should not error
```

**Expected Outputs:**
- [ ] All agent YAML files compile to .md
- [ ] No error messages
- [ ] Success confirmation shown
- [ ] Module ready to use

**Validation Checklist:**
- [ ] install.sh is executable (`chmod +x install.sh`)
- [ ] Compiles agents/*.agent.yaml → compiled-agents/*.md
- [ ] Shows clear progress messages
- [ ] Handles errors gracefully
- [ ] Creates necessary directories

---

### 5.2 Agent Invocation Test

**Check:** Can agents be invoked after installation?

**Test Steps:**
```bash
# Try to invoke each agent
/bmad:frappe-builder:agents:frappe-nexus
/bmad:frappe-builder:agents:erpnext-ba
/bmad:frappe-builder:agents:frappe-architect
/bmad:frappe-builder:agents:frappe-planner
/bmad:frappe-builder:agents:frappe-dev
/bmad:frappe-builder:agents:frappe-debugger
/bmad:frappe-builder:agents:doc-writer
/bmad:frappe-builder:agents:qa-specialist
```

**Expected:**
- [ ] Agent loads successfully
- [ ] Shows greeting/help message
- [ ] critical_actions execute
- [ ] KB files load (if referenced)
- [ ] Menu displays (if agent has *help command)

---

### 5.3 Workflow Invocation Test

**Check:** Can workflows be invoked?

**Test Workflows:**
- [ ] /bmad:frappe-builder:workflows:analyze-requirements
- [ ] /bmad:frappe-builder:workflows:design-solution
- [ ] /bmad:frappe-builder:workflows:create-roadmap
- [ ] /bmad:frappe-builder:workflows:implement-feature
- [ ] /bmad:frappe-builder:workflows:diagnose-issue
- [ ] /bmad:frappe-builder:workflows:generate-tests
- [ ] /bmad:frappe-builder:workflows:create-guide
- [ ] /bmad:frappe-builder:workflows:review-code
- [ ] /bmad:frappe-builder:workflows:sequence-tasks

**Expected:**
- [ ] Workflow loads
- [ ] Agent activates
- [ ] Instructions load
- [ ] Workflow executes

---

## 6. Knowledge Base Completeness

### 6.1 Coverage Audit

**Check:** Are all planned KB files present?

| Category | Planned | Present | % Complete |
|----------|---------|---------|------------|
| frappe-framework/ | 15 | 1 | 7% |
| erpnext-modules/ | 10 | 4 | 40% |
| development/server-scripting/ | 6 | 2 | 33% |
| development/client-scripting/ | 5 | 2 | 40% |
| development/reports/ | 4 | 2 | 50% |
| development/custom-pages/ | 3 | 0 | 0% |
| debugging/ | 10 | 0 | 0% |
| best-practices/ | 10 | 0 | 0% |
| **TOTAL** | **65** | **11** | **17%** |

**High-Priority Missing Files:**
- frappe-framework/doctype-lifecycle.md
- frappe-framework/hooks-reference.md
- frappe-framework/frappe-orm.md
- frappe-framework/frappe-api-reference.md
- erpnext-modules/sales-purchasing.md
- erpnext-modules/accounts-finance.md
- debugging/bench-commands.md
- debugging/error-patterns.md
- best-practices/security-checklist.md
- best-practices/performance-patterns.md

---

### 6.2 KB Quality Audit

**Check:** Do existing KB files meet quality standards?

**Quality Checklist per File:**
- [ ] Anti-fluff compliant (<1000 words for guides)
- [ ] Token-efficient (tables over prose)
- [ ] Code examples included
- [ ] Practical and actionable
- [ ] Zero decorative language
- [ ] Proper markdown formatting
- [ ] Accurate and up-to-date information

---

## 7. End-to-End Workflow Testing

### 7.1 Full Development Cycle Test

**Scenario:** Build a simple ERPNext customization end-to-end

**Steps:**
1. **Requirements Analysis**
   - Invoke: /bmad:frappe-builder:agents:erpnext-ba
   - Provide: "Need to track employee certifications"
   - Expected: BRD document with ERPNext module mapping

2. **Solution Design**
   - Invoke: /bmad:frappe-builder:agents:frappe-architect
   - Input: BRD from step 1
   - Expected: TSD with 4-tier analysis, DocType design

3. **Implementation Planning**
   - Invoke: /bmad:frappe-builder:agents:frappe-planner
   - Input: TSD from step 2
   - Expected: Implementation plan with phases, user vs dev tasks

4. **Code Development**
   - Invoke: /bmad:frappe-builder:agents:frappe-dev
   - Input: Implementation plan from step 3
   - Expected: Code following all standards (descriptive names, no unnecessary helpers, simple solutions)

5. **Code Review**
   - Invoke: /bmad:frappe-builder:workflows:review-code
   - Input: Code from step 4
   - Expected: Anti-pattern detection, code quality feedback

6. **Test Generation**
   - Invoke: /bmad:frappe-builder:agents:qa-specialist
   - Input: Implementation from step 4
   - Expected: Test scenarios (lazy/uneducated/mistake-prone user lenses)

7. **Documentation**
   - Invoke: /bmad:frappe-builder:agents:doc-writer
   - Input: Feature from step 4
   - Expected: Anti-fluff user guide (<500 words)

**Success Criteria:**
- [ ] All agents load successfully
- [ ] KB files accessible throughout
- [ ] Standards followed in all outputs
- [ ] Templates used appropriately
- [ ] Code quality mandates enforced
- [ ] No errors or missing references

---

## 8. Documentation Audit

### 8.1 README Completeness

**Check:** Is README.md comprehensive?

**Required Sections:**
- [ ] Module overview
- [ ] Features list
- [ ] Agent descriptions
- [ ] Workflow descriptions
- [ ] Installation instructions
- [ ] Usage examples
- [ ] Architecture overview
- [ ] Contributing guidelines (if open)

---

### 8.2 Progress Tracking

**Check:** Are progress documents up-to-date?

**Documents:**
- [ ] PROGRESS-REPORT.md - Current status
- [ ] SESSION-SUMMARY.md - Latest session
- [ ] AUDIT-CHECKLIST.md (this file) - Audit status

---

## 9. Web Research Integration

### 9.1 Agent Research Capabilities

**Check:** Do all agents have web research?

| Agent | WebSearch Tool | WebFetch Tool | Trusted Sources | Research-First Mandate |
|-------|---------------|---------------|-----------------|----------------------|
| frappe-nexus | ✅ YES | ✅ YES | ✅ YES | ✅ YES |
| erpnext-ba | ✅ YES | ✅ YES | ✅ YES | ✅ YES |
| frappe-architect | ✅ YES | ✅ YES | ✅ YES | ✅ YES |
| frappe-planner | ✅ YES | ✅ YES | ✅ YES | ✅ YES |
| frappe-dev | ✅ YES | ✅ YES | ✅ YES | ✅ YES |
| frappe-debugger | ✅ YES | ✅ YES | ✅ YES | ✅ YES |
| doc-writer | ✅ YES | ✅ YES | ✅ YES | ✅ YES |
| qa-specialist | ✅ YES | ✅ YES | ✅ YES | ✅ YES |

**Trusted Sources:**
- frappeframework.com
- docs.erpnext.com
- github.com/frappe/*
- manual.buildwithhussain.com

---

## 10. Overall Module Health

### 10.1 Readiness Score

**Calculate readiness based on checklist completion:**

| Category | Weight | Score | Weighted |
|----------|--------|-------|----------|
| Agent Configuration | 15% | TBD | TBD |
| Code Quality Compliance | 20% | TBD | TBD |
| Token Efficiency | 15% | TBD | TBD |
| BMAD Compliance | 20% | TBD | TBD |
| Installer Functionality | 10% | TBD | TBD |
| KB Completeness | 15% | TBD | TBD |
| E2E Testing | 5% | TBD | TBD |
| **TOTAL** | **100%** | **TBD** | **TBD** |

**Readiness Levels:**
- 90-100%: Production Ready ✅
- 75-89%: Beta Ready ⚠️
- 60-74%: Alpha Ready 🔄
- <60%: Not Ready ❌

---

## 11. Action Items from Audit

**High Priority:**
- [ ] Add KB file loading to agent critical_actions
- [ ] Add standards file references to agents
- [ ] Add template references to workflows
- [ ] Add task file usage to workflows
- [ ] Complete missing HIGH-priority KB files
- [ ] Test module installer end-to-end
- [ ] Run full development cycle test

**Medium Priority:**
- [ ] Optimize agent instruction length
- [ ] Remove duplication between agents
- [ ] Complete MEDIUM-priority KB files
- [ ] Add more code examples to KB
- [ ] Create debugging KB files

**Low Priority:**
- [ ] Add more templates
- [ ] Create additional task files
- [ ] Enhance documentation
- [ ] Add video tutorials

---

## Audit Sign-Off

**Auditor:** _________________
**Date:** _________________
**Overall Status:** _________________
**Readiness Score:** _____%
**Recommendation:** _________________

---

**END OF AUDIT CHECKLIST**
