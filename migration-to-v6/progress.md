# frappe-builder v6 Migration — Progress
**Last Updated:** 2026-02-19

---

## Project Context

**This is the source code of a BMAD module.**
- All agent files are `.agent.yaml` — they are compiled into `.md` during module installation. Do not treat YAML structure issues as runtime bugs; they affect the compiled output.
- Workflows are invoked by agents at runtime via the installed module path, not the source path.
- Changes here require re-installation/deployment to take effect (Phase 4).

---

## Completed

### Workflow Split (implement-phase + implement-feature)
- ✅ `implement-phase` workflow created (7 steps, TSD-based, single-modal)
- ✅ `implement-feature` workflow created (8 steps, bi-modal: New + Resume)
- ✅ State management redesigned: 3-file split (active.yaml / session.yaml / inventory.yaml)
- ✅ All 8 agent `.agent.yaml` files updated to session.yaml split
- ✅ All workflow.md + step files updated (session.yaml writes, inventory.yaml logic)
- ✅ All 8 sidecars removed; unique content absorbed into agent.yaml files

### Review Session (2026-02-19)
- ✅ doc-writer YAML structure fixed (`name/title/icon/type/module` moved to `agent:` level)
- ✅ Agent menus debloated:
  - frappe-planner: removed `*phase-breakdown`, `*optimize-sequence`, `*estimate-phases` (144 → 107 lines)
  - frappe-architect: removed `*tier-analysis` (120 → 115 lines)
  - frappe-debugger: removed `*query-analyze` (106 → 101 lines)
  - doc-writer: removed `*erpnext-feature`, `*workflow-guide`, `*report-guide` (106 → 91 lines)
- ✅ Scaffold steps removed from all 3 workflow paths:
  - `implement-feature/steps-new/step-04-scaffold.md` deleted
  - `implement-feature/steps-resume/step-04-scaffold.md` deleted
  - `implement-phase/steps/step-03-scaffold.md` deleted
- ✅ Complete steps trimmed to state update + brief report:
  - `steps-new/step-09` 239 → 80 lines
  - `steps-resume/step-09` 240 → 80 lines
  - `implement-phase/step-08` 432 → 72 lines
- ✅ Step files renumbered (gaps closed):
  - `steps-new` + `steps-resume`: now 1–8 (was 1–3, 5–9)
  - `implement-phase/steps`: now 1–7 (was 1–2, 4–8)
  - All internal routing and frontmatter `step:` numbers updated

---

## Pending

### D — Claude Code skill discovery in workflows
- Add instruction in `implement-feature/workflow.md` and `implement-phase/workflow.md` to check for relevant installed frappe skills (e.g. `/bmad-frappe-builder-*`) and invoke them alongside the workflow where applicable.
- **Blocked:** Need Riz to confirm skill names/triggers installed in Claude Code.

### F — Remove redundant state loading from workflow.md files (SKIPPED)
- Both `implement-feature/workflow.md` and `implement-phase/workflow.md` contain a "Load Active Project State" section that duplicates what agent `critical_actions` already does.
- **Decision:** Kept as reinforcement — not removed.

### H — Deploy and test (Phase 4)
- Deploy `implement-phase` to installed BMAD module, test end-to-end with a sample TSD
- Deploy `implement-feature` to installed BMAD module, test New mode and Resume mode end-to-end

---

## Completed (2026-02-19 session)

### C — Trim legacy monolithic workflows ✅
- `review-code/instructions.md` — 263 → 77 lines (−71%)
- `prepare-release/instructions.md` — 279 → 119 lines (−57%)
- State update steps in both migrated from old `active.yaml` + feature file pattern → `session.yaml`

### E — `{{app}}` vs `{{current_app}}` naming ✅
- Confirmed `active.yaml` stores `app`; `{{current_app}}` was a legacy alias with no separate source of truth
- `{{current_app}}` → `{{app}}` replaced across all agents, workflows, tasks, templates (30+ files)
- Unbraced `current_app` + single-brace `{docs_path}` in `frappe-nexus.agent.yaml` also fixed

### G — Remove orphan files from implement-phase ✅
- `implement-phase/instructions.md` deleted
- `implement-phase/instructions.md.backup` deleted

### I — Documentation updates ✅
- `USER-GUIDE.md`: workflow count 12 → 11, implement-phase step count 8 → 7 (scaffold removed), fixed duplicate #10 numbering, added `bmad-frappe-builder-implement-phase` and `bmad-frappe-builder-implement-feature` skill references
- `README.md`: workflow count 12 → 11, implement-phase step count 8 → 7, removed bogus template entries from workflow list
