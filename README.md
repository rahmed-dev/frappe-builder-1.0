# Frappe-Builder Module

**A BMAD-compatible sub-agent module for comprehensive Frappe Framework development**

Frappe-Builder is a complete development ecosystem designed for large-scale, production-ready Frappe/ERPNext projects. It provides 8 specialized AI agents covering the entire software development lifecycle - from business requirements to code implementation, testing, and documentation.

Built on the BMAD Method, Frappe-Builder transforms complex Frappe development into a structured, agent-orchestrated workflow that follows industry best practices and Frappe framework conventions.

## What is Frappe-Builder?

Frappe-Builder is a **sub-agent compatible module** specifically designed for heavy and complex development work within the Frappe Framework ecosystem. Unlike general-purpose development tools, Frappe-Builder:

- **Understands Frappe deeply**: Built-in knowledge of Frappe Framework, ERPNext modules, DocTypes, and the 4-tier solution framework
- **Follows best practices**: Enforces 11 coding principles, security guidelines, and performance rules
- **Orchestrates specialists**: 8 specialized agents work together, each expert in their domain
- **Scales to complexity**: Handles enterprise-level ERPNext customizations and complex business requirements
- **Multi-project ready**: Manage multiple Frappe projects simultaneously with isolated state management

## Key Features

- **8 Specialized Agents**: Business Analyst, Architect, Planner, Developer, Debugger, QA Specialist, Doc Writer, and Orchestrator
- **Complete SDLC Coverage**: Requirements → Architecture → Planning → Development → Testing → Documentation
- **Multi-Project State Management**: Work on multiple Frappe projects without losing context
- **Token-Efficient Knowledge Base**: 88% token reduction through hybrid unified KB + quickref architecture
- **Comprehensive Standards**: 11 coding principles, security guidelines, performance rules, and anti-patterns
- **12 Workflow Automations**: Analyze requirements, design solutions, generate tests, review code, and more
- **4-Tier Framework Integration**: Automatic solution design using Standard → Configure → Scripts → Custom approach

## Installation

This source module generates its runtime config during install. Use `_module-installer/install-config.yaml` (installer template) to produce the installed `{project-root}/.bmad/frappe-builder/config.yaml` — there is no config.yaml in the source tree by design.

### Prerequisites

- BMAD Core installed and configured
- Frappe Bench setup (for development)
- Git installed

### Step 1: Clone BMAD Repository

```bash
# Clone the BMAD-METHOD repository
git clone https://github.com/your-org/BMAD-METHOD.git
cd BMAD-METHOD
```

### Step 2: Clone Frappe-Builder Module

```bash
# Navigate to modules directory
cd src/modules

# Clone frappe-builder module
git clone https://github.com/your-org/frappe-builder.git
```

Your directory structure should look like:
```
BMAD-METHOD/
├── src/
│   └── modules/
│       ├── frappe-builder/        # ← Frappe-Builder module
│       ├── bmm/
│       ├── bmb/
│       └── cis/
└── ...
```

### Step 3: Install BMAD with Frappe-Builder

```bash
# Return to BMAD root directory
cd ../..

# Install Node
npm install

# Run BMAD installer (interactive)
npm run bmad:install

# During installation:
# 1. Select modules to install
# 2. Check [x] frappe-builder
# 3. Provide Frappe bench path when prompted
# 4. Complete installation
```

### Step 4: Verify Installation

```bash
# Check that frappe-builder is installed
ls -la .bmad/

# You should see:
# .bmad/
# ├── frappe-builder/    # ← Module installed
# ├── bmm/
# ├── bmb/
# └── ...
```

### Step 5: Access Frappe-Nexus (Primary Agent)

```bash
# In Claude Code, invoke the orchestrator agent:
/bmad:frappe-builder:agents:frappe-nexus
```

You're ready to start developing with Frappe-Builder! 🎉

## Quick Start

After installation, start with the **Frappe-Nexus** orchestrator agent:

```
/bmad:frappe-builder:agents:frappe-nexus
```

Frappe-Nexus will:
1. Help you select or create a project
2. Route you to the appropriate specialist agent
3. Guide you through the Frappe development workflow

## What's Next?

See **USER-GUIDE.md** for:
- Detailed agent descriptions and capabilities
- Workflow examples and best practices
- Multi-project management
- Optimal usage patterns

## Module Structure

```
frappe-builder/
├── agents/                    # 8 specialized agents (see list below)
├── workflows/                 # 12 workflow automations (see list below)
├── knowledge/                 # Comprehensive Frappe/ERPNext KB
├── standards/                 # Coding principles & guidelines
├── state/                     # Multi-project state management (MAKER-inspired minimal state per step)
├── _module-installer/         # install-config.yaml (installer template → generates runtime config)
└── README.md                  # This file
```

### Agents (8)
- frappe-nexus.agent.yaml — orchestrator/router
- erpnext-ba.agent.yaml — requirements mapping
- frappe-architect.agent.yaml — 4-tier design
- frappe-planner.agent.yaml — sequencing/dependencies
- frappe-dev.agent.yaml — implementation
- frappe-debugger.agent.yaml — diagnostics/anti-patterns
- qa-specialist.agent.yaml — tests/scenarios
- doc-writer.agent.yaml — user docs

### Workflows (12)
- analyze-requirements — convert notes to BRD
- design-solution — produce TSD (4-tier)
- sequence-tasks — order tasks by dependencies
- create-roadmap — phased plan
- implement-feature — execute build
- diagnose-issue — debug flow
- generate-tests — manual + unittest scenarios
- review-code — anti-pattern/code review
- create-guide — user docs
- prepare-release — release checklist
- create-guide templates — doc templates
- design-solution/generate-tests/etc. templates where provided

### State Management
- `state/` holds multi-project context with minimal per-step state (inspired by `future-plans/maker-integration/maker-method-overview.md`).
- Active project pointer: `state/active-project.txt` contains the key/name of the currently active project.
- Per-project state: each project has `state/{{project_key}}/active.yaml` following `state/templates/active.yaml.template` and storing `project`, `app`, `site`, `plan`, `tsd`, `brd`, `phase`, `specialist`, `tasks`, `context`, `notes`, and `updated`.
- Agents (Nexus, BA, Architect, Planner, Dev, Debugger, QA, Doc-Writer) read/write the same `active.yaml` for `{{active_project}}`, updating phase/specialist/paths as they complete their part of the lifecycle.

### Installer
- Installer template: `_module-installer/install-config.yaml` (source). Generates installed `.bmad/frappe-builder/config.yaml`. No source config.yaml by design.

## Requirements

- **BMAD Core**: v6.0.0 or higher
- **Node.js**: v18+ (for BMAD installer)
- **Frappe Bench**: v14/v15 (for development)
- **Python**: 3.10+ (Frappe requirement)
- **Claude Code**: Latest version

## License

[Your License Here]

## Support

For issues, questions, or contributions:
- GitHub Issues: [Your Repo URL]
- Documentation: See USER-GUIDE.md
- BMAD Community: [Community Link]

## Credits

Built with the BMAD Method framework.
Frappe-Builder module created by [Your Name/Organization].
