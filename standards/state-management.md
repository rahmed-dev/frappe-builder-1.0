# State Management Protocol
# Frappe-Builder | Version: 1.0

## Overview

State is split across **3 levels**, each with a distinct purpose and update frequency. Every agent must follow the cascade below at every step boundary.

---

## The 3 State Files

### 1. `session.yaml` — Step-level breadcrumb (always updated)

**What it tracks:** what is happening RIGHT NOW — current feature, task, workflow step, specialist, last/next action.

**Updated:** at EVERY step boundary without exception. If the `updated` timestamp has not changed since the step began, write it now and set `last_action: "State integrity restored (step boundary write recovered)"`.

**Fields to write each time:**
```yaml
current_feature: ""       # feature ID in progress (or "" if none)
current_component: ""     # component being worked on
current_task: ""          # one sentence: what is happening NOW
workflow: ""              # active workflow name
workflow_step: 0          # integer step number
last_action: ""           # past tense: what was just completed
next_action: ""           # imperative: what to do next
specialist: ""            # agent currently owning this work
updated: ""               # ISO 8601 timestamp — MUST change every step
recent_actions:           # rolling last 3 (FIFO — push new, drop oldest)
  - action: ""
    specialist: ""
    timestamp: ""
```

---

### 2. `features/{feature-id}.yaml` — Feature-level detail (updated when work is done)

**What it tracks:** detailed breakdown of every component in the feature — status per component, overall progress, notes, decisions.

**Updated:** whenever you perform work on a component within a feature. Not on every step — only when a component's status changes or notes need updating.

**Fields to update:**
- Each worked component: `status: planned → in-progress → completed`
- `progress: "X/Y"` — X = count of completed components, Y = total components
- `notes: ""` — one-sentence summary of where the feature stands right now
- `status:` — feature-level: `planned | in-progress | completed | on-hold | blocked`
- `completed: ""` — date when all components reach `completed`

**Rule:** Never leave a component in `in-progress` across sessions without updating notes to explain why.

---

### 3. `inventory.yaml` — Project-level dashboard (mirror of feature file summaries)

**What it tracks:** one-line summary per feature — status, progress, and a note. Used for resume mode, status checks, and reporting.

**Updated:** IMMEDIATELY after updating the feature file, if feature `status` or `progress` changed. Inventory is a live mirror — it must never be stale.

**Fields to update for the active feature:**
```yaml
features:
  {feature-id}:
    status: ""      # must match features/{feature-id}.yaml status
    progress: ""    # must match features/{feature-id}.yaml progress (e.g. "5/9")
    notes: ""       # must match features/{feature-id}.yaml notes (one sentence)
```

**Rule:** Every time you write the feature file and the status or progress changed, you MUST update inventory.yaml in the same operation. Do not wait. Do not skip.

---

## The Cascade — Execute in Order

```
STEP BOUNDARY OR WORK COMPLETION
         │
         ▼
(1) SESSION — always
    Write session.yaml
    Push to recent_actions (FIFO max 3)
         │
         ▼
(2) FEATURE FILE — if {{current_feature}} set AND component work done
    Update features/{{current_feature}}.yaml
    Recalculate progress X/Y
    Update notes + status
         │
         ▼
(3) INVENTORY — if feature status or progress changed in step 2
    Update inventory.yaml entry for {{current_feature}}
    Mirror status, progress, notes from feature file exactly
```

---

## Common Mistakes to Avoid

| Mistake | Correct Behavior |
|---|---|
| Only writing session.yaml | Always cascade to feature file and inventory when work was done |
| Updating feature file but not inventory | After every feature file write that changes status/progress, update inventory immediately |
| Leaving progress at "0/Y" after completing components | Recalculate X/Y every session — count completed components |
| Writing "see feature file" in inventory notes | Copy the actual one-sentence summary from the feature file |
| Skipping the cascade when told to "just do the task" | State cascade is non-negotiable — it protects resumability |

---

## New Feature Registration

When starting a NEW feature (not resuming):
1. Create `features/{feature-id}.yaml` from the appropriate template in `state/templates/`
2. Add entry to `inventory.yaml` with `status: planned`, `progress: "0/Y"`, `notes: ""`
3. Set `current_feature` in `session.yaml`

Do steps 1-2-3 in that order before beginning any implementation work.
