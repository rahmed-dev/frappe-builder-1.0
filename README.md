# Frappe-Builder

Comprehensive Frappe/ERPNext development ecosystem with 8 specialized agents covering complete SDLC from requirements to deployment, including third-party integrations.

## Overview

Frappe-Builder provides:
- **8 Specialized Agents** (Primary, Specialist, Utility)
- **10 Workflows** (CORE, PLANNING, QUALITY, DELIVERY)
- **Frappe Bench Awareness** (all agents detect apps, ask for {{current_app}})
- **4-Tier Framework** (Standard → Configure → Scripts → Custom)
- **Anti-Pattern Detection** (catches common Frappe mistakes)

## Installation

```bash
bmad install frappe-builder
```

During installation:
1. Provide your Frappe bench path
2. Specify default site name
3. Module installs to `.bmad/frappe-builder/`

## Components

### PRIMARY AGENT: Frappe-Nexus 🎯

Intelligent orchestrator routing to the right specialist.

**Commands:** `*help`, `*start`, `*status`, `*ba`, `*arch`, `*plan`, `*dev`, `*debug`, `*qa`, `*docs`

**Orchestrated Workflows:** `*full-cycle`, `*quick-build`, `*troubleshoot`

### SPECIALIST AGENTS (5)

**1. ERPNext BA 📊** - Business Requirements Analyst
- Maps business needs to ERPNext modules (Sales, Purchasing, Stock, Manufacturing, HR, CRM, Projects)
- Gap analysis (Standard vs Custom)
- Workflow: `analyze-requirements` (messy notes → structured BRD)

**2. Frappe-Architect 🏗️** - Solution Architect
- 4-tier framework specialist (Standard → Configure → Scripts → Custom)
- DocType structure design
- UX design with Frappe native components (frappe.ui.Dialog, DataTable, Cards)
- Workflow: `design-solution` (BRD → TSD)

**3. Frappe-Planner 📋** - Implementation Planner
- Dependency analysis (DocType relationships)
- Phased delivery (User tasks vs Developer tasks)
- Workflows: `create-roadmap`, `sequence-tasks`

**4. Frappe-Dev 💻** - Code Developer
- Frappe framework purist (production-ready code)
- Server-side first, frappe.utils, parameterized queries
- Workflows: `implement-feature`, `review-code`

**5. Frappe-Debugger 🔧** - Error Diagnostician
- Bench log analysis (error.log, web.log, scheduler.log)
- Anti-pattern detection
- Workflow: `diagnose-issue`

### UTILITY AGENTS (2)

**6. Doc-Writer 📝** - Documentation Generator
- Anti-fluff user guides (2-3 pages max)
- ERPNext UI terminology
- Workflow: `create-guide`

**7. QA-Specialist 🧪** - Test Scenario Generator
- Real-world user lenses (lazy, uneducated, mistake-prone)
- Frappe unittest code generation
- Workflow: `generate-tests`

## Workflows (10)

### CORE Workflows (3)
1. **analyze-requirements** - Requirements → BRD (ERPNext modules mapping)
2. **design-solution** - BRD → TSD (4-tier framework)
3. **implement-feature** - TSD → Working code (Frappe native)

### PLANNING Workflows (2)
4. **create-roadmap** - TSD → Phased Implementation Plan
5. **sequence-tasks** - Feature list → Dependency-ordered tasks

### QUALITY Workflows (3)
6. **diagnose-issue** - Error logs → Diagnostic Report (root cause + fix)
7. **generate-tests** - Feature spec → Test matrix + unittest code
8. **review-code** - Code → Anti-pattern report

### DELIVERY Workflows (2)
9. **create-guide** - Feature → User guide (2-3 pages)
10. **prepare-release** - Project → Release checklist

## Quick Start

1. **Load the main agent:**
   ```
   /bmad:frappe-builder:agents:frappe-nexus
   ```

2. **View available commands:**
   ```
   *help
   ```

3. **Start a full development cycle:**
   ```
   *full-cycle
   ```
   This orchestrates: Requirements → Design → Planning → Development → Testing → Documentation

4. **Or use specialists directly:**
   ```
   *ba         # Load ERPNext BA for requirements
   *arch       # Load Frappe-Architect for design
   *dev        # Load Frappe-Dev for implementation
   *debug      # Load Frappe-Debugger for troubleshooting
   ```

## Frappe Bench Awareness

**CRITICAL**: All agents are Frappe bench-aware.

**At agent startup:**
1. Detects Frappe bench: Checks if `{frappe_bench_path}/apps/` exists
2. Lists available apps: `ls {frappe_bench_path}/apps/`
3. Asks user: "Which Frappe app are you working on?"
4. Sets session paths:
   - `{{current_app}}` = user's answer
   - `{{app_path}}` = `{frappe_bench_path}/apps/{{current_app}}`
   - `{{docs_path}}` = `{{app_path}}/docs`

**Throughout session:**
- All documents save to `{{docs_path}}/[document-type]/`
- All code implements to `{{app_path}}/{{current_app}}/`

**Example:**
```
Frappe-Nexus: Which Frappe app are you working on?
Available apps: custom_app, erpnext, frappe, hrms

User: custom_app

Frappe-Nexus: ✅ Working on 'custom_app'.
Documents will be saved to: /home/riz/frappe-bench/apps/custom_app/docs/
```

## Module Structure

```
frappe-builder/
├── agents/                    # 8 agents (compiled from YAML)
│   ├── frappe-nexus.agent.yaml
│   ├── erpnext-ba.agent.yaml
│   ├── frappe-architect.agent.yaml
│   ├── frappe-planner.agent.yaml
│   ├── frappe-dev.agent.yaml
│   ├── frappe-debugger.agent.yaml
│   ├── doc-writer.agent.yaml
│   ├── qa-specialist.agent.yaml
│   └── [agent-name]-sidecar/  # Each agent has sidecar
│       ├── instructions.md
│       ├── memories.md
│       └── knowledge/
├── workflows/                 # 10 workflows
│   ├── analyze-requirements/
│   ├── design-solution/
│   ├── implement-feature/
│   ├── create-roadmap/
│   ├── sequence-tasks/
│   ├── diagnose-issue/
│   ├── generate-tests/
│   ├── review-code/
│   ├── create-guide/
│   └── prepare-release/
├── standards/                 # Standards files
│   ├── core/
│   │   ├── frappe-conventions.md
│   │   ├── 4-tier-framework.md
│   │   └── bench-structure.md
│   └── development/
│       ├── code-quality.md
│       ├── testing-standards.md
│       └── documentation-standards.md
├── tasks/                     # Reusable tasks
│   ├── bench/
│   ├── validation/
│   └── scaffolding/
├── templates/                 # Document & code templates
│   ├── documents/
│   ├── technical/
│   └── code/
├── knowledge-base/            # Deep Frappe/ERPNext knowledge
│   ├── frappe-framework/
│   ├── erpnext-modules/
│   ├── development/
│   ├── debugging/
│   └── best-practices/
├── data/                      # Module data files
├── _module-installer/         # Installation config
│   ├── install-config.yaml
│   └── assets/
├── config.yaml                # Generated during installation
└── README.md                  # This file
```

## Configuration

Module configuration: `.bmad/frappe-builder/config.yaml`

Key settings:
- `frappe_bench_path` - Path to Frappe bench
- `default_site` - Default site name
- `kb_location` - Knowledge base directory
- `standards_path` - Standards files location
- `templates_path` - Template files location

## Examples

### Full Development Cycle

```
# Load Frappe-Nexus
/bmad:frappe-builder:agents:frappe-nexus

# Which app?
User: custom_app

# Start full cycle
*full-cycle

# This orchestrates:
1. ERPNext BA: analyze-requirements → BRD
2. Frappe-Architect: design-solution → TSD
3. Frappe-Planner: create-roadmap → Implementation Plan
4. Frappe-Dev: implement-feature → Code (phase by phase)
5. QA-Specialist: generate-tests → Test scenarios + unittest code
6. Doc-Writer: create-guide → User guides
```

### Quick Build (Already have TSD)

```
*quick-build

# Skips requirements & architecture, goes straight to:
1. Frappe-Planner: create-roadmap
2. Frappe-Dev: implement-feature
3. QA-Specialist: generate-tests
```

### Troubleshooting

```
*troubleshoot

# Routes between Debugger and Dev:
1. Frappe-Debugger: diagnose-issue → Root cause + fix
2. Frappe-Dev: implement fix
3. Iterate until resolved
```

## Development Status

**Current Version:** 1.0.0

**Phase 1: Critical Infrastructure**
- [x] 8 Agents complete
- [x] Module installer (install-config.yaml)
- [x] Module README.md

**Phase 2: Workflows** (In Progress)
- [ ] CORE workflows (3): analyze-requirements, design-solution, implement-feature
- [ ] PLANNING workflows (2): create-roadmap, sequence-tasks
- [ ] QUALITY workflows (3): diagnose-issue, generate-tests, review-code
- [ ] DELIVERY workflows (2): create-guide, prepare-release

**Phase 3: Infrastructure** (Planned)
- [ ] Standards (6 files)
- [ ] Tasks (10+ reusable operations)
- [ ] Templates (9+ document/code templates)

**Phase 4: Knowledge Base** (Planned)
- [ ] Frappe framework guides
- [ ] ERPNext module references
- [ ] Development best practices
- [ ] Debugging patterns

## Contributing

To extend Frappe-Builder:
1. Create agents using BMAD Core v6 YAML format
2. Create workflows following BMAD workflow specification
3. Add knowledge base files to relevant categories
4. Submit improvements via pull request

## Author

Created by Rizwan on 2025-11-20

## License

See project license

## Version

1.0.0 (Initial release)
