# Frappe-Builder v1.0.0 - Initial Release

## Overview

Frappe-Builder is a comprehensive BMAD module providing a complete Frappe/ERPNext development ecosystem with 8 specialized agents covering the entire SDLC from requirements to deployment.

## Key Features

### 🎯 Primary Orchestrator
- **Frappe-Nexus**: Intelligent routing agent that directs you to the right specialist
- 9+ slash commands for quick access to agents and workflows
- Pre-built orchestrated workflows for common development patterns

### 👥 5 Specialist Agents
1. **ERPNext BA** - Maps business needs to ERPNext modules, conducts gap analysis
2. **Frappe-Architect** - Designs solutions using 4-tier framework, DocType structures, and native UX components
3. **Frappe-Planner** - Creates phased roadmaps with dependency analysis
4. **Frappe-Dev** - Implements production-ready Frappe framework code
5. **Frappe-Debugger** - Diagnoses errors from bench logs with anti-pattern detection

### 🛠️ 2 Utility Agents
6. **Doc-Writer** - Generates concise user guides (2-3 pages)
7. **QA-Specialist** - Creates test scenarios and Frappe unittest code

### 📋 10 Workflows

**CORE Workflows:**
- `analyze-requirements` - Business needs → BRD
- `design-solution` - BRD → TSD
- `implement-feature` - TSD → Working code

**PLANNING Workflows:**
- `create-roadmap` - TSD → Implementation plan
- `sequence-tasks` - Feature list → Dependency ordering

**QUALITY Workflows:**
- `diagnose-issue` - Error logs → Root cause + fix
- `generate-tests` - Feature spec → Test matrix
- `review-code` - Code → Anti-pattern report

**DELIVERY Workflows:**
- `create-guide` - Feature → User documentation
- `prepare-release` - Project → Release checklist

### 🎪 Orchestrated Workflows
- **full-cycle**: Requirements → Design → Planning → Development → Testing → Documentation
- **quick-build**: Fast implementation from existing TSD
- **troubleshoot**: Iterative error diagnosis and fixing

### 🔧 Frappe Bench Awareness
- Automatic detection of Frappe bench installation
- Lists available apps at startup
- Dynamic app selection and context management
- All documents and code saved to correct app paths

## Installation

```bash
bmad install frappe-builder
```

During installation:
1. Provide your Frappe bench path (e.g., `/home/user/frappe-bench`)
2. Specify default site name (e.g., `site1.local`)
3. Module installs to `.bmad/custom/modules/frappe-builder/`

## Quick Start

```bash
# Load the main orchestrator
/bmad:frappe-builder:agents:frappe-nexus

# View available commands
*help

# Start a full development cycle
*full-cycle

# Or load specialists directly
*ba         # Business Analyst
*arch       # Architect
*dev        # Developer
*debug      # Debugger
```

## What's Included

### Module Structure
```
frappe-builder/
├── agents/           # 8 agents with sidecar knowledge
├── workflows/        # 10 complete workflows
├── standards/        # Frappe conventions and best practices
├── tasks/            # Reusable bench operations
├── templates/        # Document and code templates
├── knowledge/        # Deep Frappe/ERPNext reference
└── install.sh        # Interactive installer
```

### Standards & Best Practices
- Frappe framework conventions
- 4-tier implementation framework
- Code quality standards
- Testing standards
- Documentation guidelines
- Anti-pattern detection rules

## Requirements

- BMAD Core installed
- Frappe bench installation (v13+ recommended)
- Claude Code or compatible AI IDE

## Use Cases

✅ **Perfect for:**
- Frappe/ERPNext custom app development
- Business requirement analysis and gap assessment
- Solution architecture and DocType design
- Production-ready code implementation
- Error diagnosis and debugging
- Test scenario generation
- User documentation creation
- Release preparation

⚠️ **Note:**
- Workflows in Phase 2 are actively being developed
- Knowledge base will be expanded in Phase 4
- Some templates may require customization

## Documentation

- [README.md](README.md) - Complete module documentation
- [CHANGELOG.md](CHANGELOG.md) - Detailed version history
- [AUDIT-CHECKLIST.md](AUDIT-CHECKLIST.md) - Quality audit checklist

## Development Status

**Version 1.0.0** includes:
- ✅ 8 Complete agents
- ✅ Module installer
- ✅ Standards framework
- 🚧 10 Workflows (in development)
- 🚧 Knowledge base (expanding)

## Support

For issues, questions, or contributions:
- GitHub Issues: https://github.com/YOUR_USERNAME/frappe-builder/issues
- Discussions: https://github.com/YOUR_USERNAME/frappe-builder/discussions

## Author

Created by Rizwan (2025-11-20)

## License

[Your chosen license]

---

**Ready to revolutionize your Frappe development workflow?**

Install now: `bmad install frappe-builder`
