---
name: 'step-04-plan'
description: 'Collaboratively plan all nodes with shapes and connections with labels — confirm before generating'

nextStepFile: './step-05-generate.md'
advancedElicitationTask: '{project-root}/_bmad/core/tasks/advanced-elicitation.md'
mermaidRules: '../data/mermaid-rules.md'
---

# Step 4: Plan Nodes & Connections

## STEP GOAL:

Design the diagram's structure in plain language — nodes with shapes, connections with labels — and confirm it is correct before writing any Mermaid code.

## MANDATORY EXECUTION RULES (READ FIRST):

### Universal Rules:
- 📖 CRITICAL: Read the complete step file before taking any action
- 🔄 CRITICAL: When loading next step with 'C', ensure entire file is read first
- ⏸️ ALWAYS halt at the menu and wait for user input

### Role Reinforcement:
- This is the design phase — you bring shape expertise, the user brings accuracy
- A plain-language plan caught early prevents wasted code generation later
- Invite the user to spot missing steps or wrong connections

### Step-Specific Rules:
- Apply shape vocabulary from {mermaidRules}
- Every connection needs a label — propose one if unsure
- If groups are defined, show which group each node belongs to
- FORBIDDEN: Writing Mermaid code in this step — that is step 5

## EXECUTION PROTOCOLS:
- Load {mermaidRules} for shape vocabulary
- Present plan as readable text, not Mermaid syntax
- Group nodes under their subgraph if applicable
- Halt at menu

## CONTEXT BOUNDARIES:
- Based on: subject (step 1), groups (step 2), diagram type (step 3)
- Load {mermaidRules} for shape and connection rules
- Do NOT write Mermaid code — plain language only

## MANDATORY SEQUENCE

### 1. Load Mermaid Rules

Load {mermaidRules} silently and apply shape vocabulary.

### 2. Draft the Node Plan

Build a plain-language node plan. Format it as:

```
[Group Name — if applicable]:
  [Shape: Label] →|connection label| [Shape: Label]
  [Shape: Label] →|connection label| [Shape: Label]

[Group Name 2 — if applicable]:
  ...
```

Use shape names (Rectangle, Diamond, Cylinder, etc.), not Mermaid syntax.

Example:
```
Customer Actions:
  Stadium: Start →|initiates| Rectangle: Submit Purchase Request
  Rectangle: Submit Purchase Request →|triggers| Diamond: Budget Available?

Approval:
  Diamond: Budget Available? →|yes, auto| Rectangle: Auto-Approve
  Diamond: Budget Available? →|no, over limit| Rectangle: Manager Review
  Rectangle: Manager Review →|approved| Stadium: End: Order Confirmed
  Rectangle: Manager Review →|rejected| Rounded: Returns to Draft
```

### 3. Note Colour Groups

If multiple roles or categories exist, note which colour group each node will belong to:
> "User actions (blue): Start, Submit. System actions (grey): Budget Check, Auto-Approve. Approval role (green): Manager Review."

### 4. Present Plan to User

Share the plan and invite corrections:
> "Here's the diagram structure I'm planning. Does this match the actual process? Anything missing, mislabelled, or in the wrong order?"

### 5. Present MENU OPTIONS

Display: "**Select:** [A] Work through the plan in more detail [C] Continue to generate Mermaid code"

#### Menu Handling Logic:
- IF A: Discuss specific nodes, connections, or labels in depth, refine plan, then redisplay this menu
- IF C: Save finalised node plan to context, load, read entire file, and execute {nextStepFile}
- IF user corrects or adds: Update plan, confirm correction, then redisplay this menu
- IF any other input: Answer, then redisplay this menu

#### EXECUTION RULES:
- ALWAYS halt and wait for user input
- ONLY proceed when user selects 'C'
- If significant changes requested, show revised plan before accepting C

## 🚨 SYSTEM SUCCESS/FAILURE METRICS

### ✅ SUCCESS:
- Every node has a shape type and label
- Every connection has a label
- Groups documented (if applicable)
- Colour groups noted (if applicable)
- User confirmed plan is accurate

### ❌ SYSTEM FAILURE:
- Writing Mermaid code in this step
- Proceeding without user confirmation on the plan
- Unlabelled connections in the plan
- Using vague shape labels ("box", "arrow") instead of vocabulary from mermaid-rules.md

**Master Rule:** Plan in plain language first. Confirm accuracy. Then generate.
