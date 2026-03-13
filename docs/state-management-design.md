# State Management Design
# Frappe-Builder | Internal Reference

## The Problem

Frappe development sessions are long and multi-specialist. A single feature can involve 4–5 agents across multiple conversations: BA captures requirements, Architect designs the solution, Planner sequences work, Dev implements, QA tests. Without persistent state, each new session starts blind.

BMAD's default answer is the **sidecar file** — a per-agent memory file that travels with the agent. For a single-agent workflow this works well. For a multi-agent system like Frappe-Builder, it creates fragmentation: each agent holds its own slice of context with no shared view of project progress.

---

## The Solution: 3-Level State Cascade

Frappe-Builder replaces the sidecar with a shared, project-scoped state system with three levels:

```
session.yaml          ← What is happening RIGHT NOW (always updated)
    │
    ▼
features/{id}.yaml    ← Detailed component-level progress (updated when work done)
    │
    ▼
inventory.yaml        ← One-line summary per feature (mirrors feature file)
```

### Level 1 — session.yaml (step-level breadcrumb)

Updated at **every step boundary**, by every agent. Tracks: current feature, current task, active workflow + step, last specialist, last action (past tense), next action (imperative), rolling last-3 actions.

Purpose: lets any agent resume exactly where the previous agent left off, in any new conversation.

### Level 2 — features/{feature-id}.yaml (feature-level detail)

Updated when **component work is completed**. Tracks every component (DocType, controller, script, API, report) with status (`planned → in-progress → completed`), progress (`X/Y`), and a one-sentence note.

Purpose: gives the Dev agent granular tracking during implementation; allows partial-session recovery without re-reading all code.

### Level 3 — inventory.yaml (project dashboard)

Updated **immediately after every feature file write** that changes status or progress. One entry per feature: status, progress fraction, one-line note. Mirrors feature file exactly — never stale.

Purpose: gives Nexus and Planner a bird's-eye view of all features without loading every feature file.

---

## Why Not BMAD Sidecar

| Concern | Sidecar | 3-Level Cascade |
|---------|---------|-----------------|
| Multi-agent context sharing | Each agent has its own sidecar — no shared view | Single session.yaml shared by all 8 agents |
| Project-level progress | Not tracked | inventory.yaml is always current |
| Feature-level granularity | Not tracked | features/{id}.yaml tracks every component |
| Resume after interruption | Agent-specific | Any agent can resume from session.yaml |
| Cross-session continuity | Requires loading each agent's sidecar | Load session.yaml once, full context available |

The sidecar model is well-suited for single-agent tools that maintain their own long-running memory. Frappe-Builder is a multi-agent ecosystem with sequential specialist handoffs — the shared cascade fits this pattern better.

---

## The Cascade Rule

Every agent's `critical_actions` includes an identical STATE CASCADE block:

```
(1) SESSION [always]
    Write session.yaml at every step boundary

(2) FEATURE FILE [if current_feature set AND component work done]
    Update features/{current_feature}.yaml
    Recalculate progress X/Y

(3) INVENTORY [if feature status or progress changed in step 2]
    Update inventory.yaml entry for {current_feature}
    Mirror status, progress, notes exactly
```

This is defined authoritatively in `standards/state-management.md` and copy-pasted verbatim into all 8 agent `critical_actions`. Consistency is enforced by design — not by calling a shared function, but by identical instruction across agents.

---

## Trade-offs

**Overhead:** Every agent writes state files. This adds tool calls per step.
- Accepted: resumability across multi-agent sessions is worth the overhead.

**Duplication:** inventory.yaml mirrors feature files. Two sources for the same data.
- Accepted: inventory enables fast project overview without loading all feature files. The cascade rule prevents divergence.

**Verbosity:** The STATE CASCADE block is long and repeated in all 8 agents.
- Accepted: verbosity in instructions is preferable to fragile shared-state calls. Each agent is self-contained.
