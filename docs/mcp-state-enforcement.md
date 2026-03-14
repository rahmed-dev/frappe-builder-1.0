# MCP State Enforcement Design

## Problem

The 3-level state cascade (session → feature → inventory) is defined in `standards/state-management.md`, but agents inconsistently apply it. The model treats state updates as optional hygiene rather than required behaviour, especially under context pressure.

## Proposed Solution: MCP Server + PostToolUse Hook

Split enforcement responsibility across three layers so no single mechanism carries the full burden.

---

## Architecture

```
session.yaml   → PostToolUse hook  (deterministic, always automatic)
feature.yaml   → MCP tool          (model signals explicit completion)
inventory.yaml → MCP server        (cascade, never touches the model)
```

### Layer 1 — session.yaml via PostToolUse Hook

A Claude Code `PostToolUse` hook fires after every tool call. The hook script checks whether the model just performed a write operation and, if so, updates `session.yaml` automatically — no model decision required.

```bash
# .claude/hooks/post-tool-use.sh
TOOL=$1  # Write, Edit, Bash, etc.

if [[ "$TOOL" == "Write" || "$TOOL" == "Edit" || "$TOOL" == "Bash" ]]; then
    python3 update_session.py --last-tool="$TOOL" --timestamp="$(date -u +%FT%TZ)"
fi
```

**Why this works:** The trigger is deterministic (file was touched → session updates). The model makes no judgement call. Timestamps are generated server-side, removing a common model error.

---

### Layer 2 — feature.yaml via MCP Tool

Expose a single, semantically unambiguous MCP tool:

```
complete_component(feature_id, component_id, notes)
```

The model calls this when it finishes a component. The tool name is concrete ("complete this component") rather than abstract ("update state"), which gives the model high-confidence timing — it knows exactly when a component is done vs. still in progress.

The MCP server handles the cascade to `inventory.yaml` internally. The model never touches inventory directly.

**Tool response:** Return only a minimal confirmation to avoid context bloat:
```json
{ "ok": true, "updated": "2026-03-14T10:32:00Z" }
```

---

### Layer 3 — inventory.yaml via Server Cascade

`inventory.yaml` is never written by the model. When `complete_component` is called, the MCP server:
1. Writes `features/{feature_id}.yaml`
2. Recalculates `progress X/Y`
3. Mirrors status, progress, and notes into `inventory.yaml`

This guarantees inventory is never stale.

---

## How the Model Knows When to Call complete_component

### For workflow-based work (primary path)

Embed the tool call as an explicit workflow gate step. The model follows workflow steps sequentially — this is far more reliable than relying on self-directed state hygiene.

```markdown
## Step 3: Implement List View
... implementation instructions ...

## Step 3 Gate
Call complete_component(feature_id="X", component_id="list-view") before proceeding.
```

### For ad-hoc work (fallback)

Use a checkbox convention in the feature file. The PostToolUse hook diffs the file after every write and detects when `[ ]` becomes `[x]`, triggering the cascade without any model decision.

```yaml
components:
  - id: list-view
    status: "[ ]"   # model writes [x] when done
  - id: form-view
    status: "[ ]"
```

```bash
# Hook diff check
git diff state/features/ | grep "^\+.*\[x\]"
# If match found → cascade triggered
```

---

## Context Window Impact

MCP tools add context in two places:

| What | When | Size |
|---|---|---|
| Tool schemas | Once at session start | ~100 tokens per tool |
| Tool responses | Each call | ~20 tokens (minimal confirmation only) |

This is **less** than the current approach where agents read full YAML files directly. The MCP approach reduces context bloat by keeping state reads out of the model's context entirely.

---

## Summary

| State Layer | Mechanism | Trigger | Model Decision? |
|---|---|---|---|
| `session.yaml` | PostToolUse hook | Any Write/Edit/Bash | No |
| `feature.yaml` | MCP `complete_component` | Workflow gate or checkbox diff | Minimal |
| `inventory.yaml` | MCP server cascade | Automatic after feature update | No |

---

## Implementation TODO

See `TODO.md` for the tracked build tasks.
