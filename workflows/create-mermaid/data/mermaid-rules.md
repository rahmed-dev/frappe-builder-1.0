# Mermaid Diagram Rules

**Core principle:** Comprehension over convention. Every choice serves the reader, not the textbook.

---

## Diagram Type Selection

Choose by what makes the subject most readable — not by what the "correct" type is.

| If the user needs to understand... | Use |
|-----------------------------------|-----|
| A process with decisions or branches | `flowchart` |
| Who does what and in what order across roles/systems | `sequenceDiagram` |
| Status stages and what triggers transitions | `stateDiagram-v2` |
| Relationships between DocTypes, concepts, or entities | `erDiagram` OR `flowchart` (whichever reads more clearly) |
| Hierarchy or grouping of things | `classDiagram` |

**Rule:** Propose your chosen type with a one-line reason. If the user prefers another, switch without debate.

---

## Subgraph Grouping (MANDATORY for >5 nodes)

Any diagram with more than 5 nodes MUST use named `subgraph` groups.

- Groups represent logical phases or roles (e.g. "Customer Actions", "Approval Stage", "System Processing")
- Each subgraph: 3–7 nodes maximum
- Name every subgraph with a plain-language user-facing label

**Layout of groups:**
- Sequential phases → stack **vertically** (`flowchart TD`)
- Parallel paths or role-separated → stack **horizontally** (`flowchart LR`)
- Mixed → outer graph `TD`, inner subgraphs `LR`

---

## Shape Vocabulary

| Shape | Syntax | Use For |
|-------|--------|---------|
| Rectangle | `[Label]` | Action, task, step |
| Rounded rectangle | `(Label)` | State, condition, result |
| Diamond | `{Label}` | Decision, branch |
| Stadium / pill | `([Label])` | Start, End |
| Cylinder | `[(Label)]` | Data store, DocType record |
| Circle | `((Label))` | Event, trigger, inter-group connector |
| Asymmetric | `>Label]` | Note, annotation, warning |

**Rule:** Never use rectangles for everything. Shape choice communicates meaning at a glance.

---

## Arrow Labels (MANDATORY)

Every arrow MUST carry a label. No unlabelled connections.

- 1–4 words
- Describes what triggers or causes the connection
- Examples: `-->|on submit|`, `-->|if rejected|`, `-->|auto-creates|`, `-->|user selects|`

---

## Colour Coding with classDef

For multi-role or multi-category diagrams:

```
classDef userAction fill:#dbeafe,stroke:#3b82f6,color:#1e3a5f
classDef systemAction fill:#f3f4f6,stroke:#6b7280,color:#111827
classDef errorPath fill:#fee2e2,stroke:#ef4444,color:#7f1d1d
classDef doctype fill:#d1fae5,stroke:#059669,color:#064e3b

class NodeA,NodeB userAction
class NodeC systemAction
```

Common category sets:
- User actions / System actions / Errors
- Role A / Role B / Shared steps
- Happy path / Exception path

---

## Syntax Validation Checklist

Before outputting code, mentally verify:
- [ ] Diagram type declared on line 1
- [ ] No unclosed brackets
- [ ] No reserved words used as node IDs (e.g. `end`, `default`)
- [ ] Subgraph IDs are unique and alphanumeric
- [ ] `sequenceDiagram` participants declared before use
- [ ] `classDef` defined before `class` assignments
- [ ] All arrows have labels
