---
name: 'step-03-type'
description: 'Propose diagram type based on reader clarity — confirm with user'

nextStepFile: './step-04-plan.md'
mermaidRules: '../data/mermaid-rules.md'
---

# Step 3: Choose Diagram Type

## STEP GOAL:

Select the Mermaid diagram type that will make the subject most readable to the intended audience, state the reason clearly, and get confirmation.

## MANDATORY EXECUTION RULES (READ FIRST):

### Universal Rules:
- 📖 CRITICAL: Read the complete step file before taking any action
- 🔄 CRITICAL: When loading next step with 'C', ensure entire file is read first
- ⏸️ ALWAYS halt at the menu and wait for user input

### Role Reinforcement:
- You are making a design decision that affects how readable the diagram will be
- Transparency matters — tell the user WHY you chose this type
- If they prefer another type, switch immediately and without debate

### Step-Specific Rules:
- Apply the type selection table from {mermaidRules} as a guide, not a constraint
- Frame your choice around the reader's experience, not technical correctness

## EXECUTION PROTOCOLS:
- Load {mermaidRules} for type selection reference
- State choice + reason in one clear sentence
- Offer alternatives if the choice isn't obvious
- Halt at menu

## CONTEXT BOUNDARIES:
- Based on: subject from step 1, complexity and groups from step 2
- Load {mermaidRules} for type reference
- Do NOT plan nodes yet — that is step 4

## MANDATORY SEQUENCE

### 1. Load Mermaid Rules

Load {mermaidRules} silently and apply the type selection guidance.

### 2. Choose and State Diagram Type

Pick the type that serves the reader, then state it:

> "I'll use `[type]` because [one-line reader-focused reason]."

Examples:
> "I'll use `stateDiagram-v2` because the status transitions — Draft, Submitted, Approved — are the core thing the user needs to follow."

> "I'll use `flowchart LR` because there are three roles acting in parallel and swim-lane grouping makes ownership obvious at a glance."

> "I'll use `erDiagram` even though this is a process — the box-and-relationship layout will show how these DocTypes connect more clearly than a flow would."

If the choice is genuinely close between two options, present both:
> "This could work as either `flowchart` or `sequenceDiagram`. The flowchart shows the decision logic better; the sequence diagram shows timing and who acts when. Which matters more for your reader?"

### 3. Present MENU OPTIONS

Display: "**Select:** [C] Confirm type and continue | or type an alternative if you'd prefer a different diagram type"

#### Menu Handling Logic:
- IF C: Save chosen type to context, load, read entire file, and execute {nextStepFile}
- IF user suggests alternative: Acknowledge, switch to their type, confirm, then proceed
- IF any question or comment: Answer, then redisplay this menu

#### EXECUTION RULES:
- ALWAYS halt and wait for user input
- ONLY proceed when user confirms (C or alternative accepted)

## 🚨 SYSTEM SUCCESS/FAILURE METRICS

### ✅ SUCCESS:
- Diagram type chosen with a reader-focused reason
- User confirmed or provided alternative
- Diagram type saved to context before proceeding

### ❌ SYSTEM FAILURE:
- Choosing type based on "correct usage" without considering reader experience
- Proceeding without user confirmation
- Planning nodes in this step

**Master Rule:** Choose for the reader. State why. Get confirmation.
