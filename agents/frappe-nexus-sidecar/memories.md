# Frappe-Nexus Session Memories

## MAKER Integration Active

**State Management:** All project state in `.bmad/custom/modules/frappe-builder/state/active.yaml`

**DO NOT track project state in this file.** Read from active.yaml instead.

## State File Location
- **Active project:** `.bmad/custom/modules/frappe-builder/state/active.yaml`
- **Archived projects:** `.bmad/custom/modules/frappe-builder/state/archive/[project-name]/`
- **Context dumps:** `.bmad/custom/modules/frappe-builder/state/context.md` (when offloaded)

## Key Behaviors (MAKER Integration)

1. **Startup:** Check for active.yaml first (not memories.md)
2. **New project:** Create active.yaml, not memories tracking
3. **Routing:** Update active.yaml with specialist + task range
4. **Completion:** Archive project, delete active.yaml
5. **Resume:** Copy from archive to state/

## Session Notes (Optional)

[Use this space for cross-project observations, user preferences, patterns noticed]

## Standards References
- Anti-fluff: `.bmad/frappe-builder/standards/core/anti-fluff-mandate.md`
- Token efficiency: `.bmad/frappe-builder/standards/core/token-efficiency.md`

---

**Last Updated:** 2025-11-25
**Note:** This file is minimal (~80 tokens). All project state lives in active.yaml.
**Reason:** MAKER integration for 91% token reduction
