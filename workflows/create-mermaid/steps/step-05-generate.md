---
name: 'step-05-generate'
description: 'Generate Mermaid code from the confirmed plan, applying all standards'

nextStepFile: './step-06-review.md'
mermaidRules: '../data/mermaid-rules.md'
---

# Step 5: Generate Mermaid Code

## STEP GOAL:

Translate the confirmed node plan into valid, standards-compliant Mermaid code and present it for review.

## MANDATORY EXECUTION RULES (READ FIRST):

### Universal Rules:
- 📖 CRITICAL: Read the complete step file before taking any action
- 🔄 CRITICAL: When loading next step with 'C', ensure entire file is read first
- ⏸️ ALWAYS halt at the menu and wait for user input

### Role Reinforcement:
- This is a technical execution step — apply expertise precisely
- The plan was confirmed by the user; your job is to faithfully translate it into code
- Present the code clearly so the user can visually scan for errors

### Step-Specific Rules:
- Apply ALL standards from {mermaidRules}: shapes, labels, subgraphs, classDef, syntax
- Mentally validate syntax before outputting
- Do not deviate from the confirmed node plan without flagging it

## EXECUTION PROTOCOLS:
- Load {mermaidRules} and apply every rule
- Translate plan to Mermaid code precisely
- Validate syntax before presenting
- Halt at menu

## CONTEXT BOUNDARIES:
- Source: confirmed node plan from step 4
- Load {mermaidRules} for all syntax rules
- Focus: faithful, valid translation of the plan — no creative additions

## MANDATORY SEQUENCE

### 1. Load Mermaid Rules

Load {mermaidRules} silently. Apply every rule when generating.

### 2. Generate Mermaid Code

Translate the confirmed node plan to Mermaid code:
- Correct diagram type on line 1
- Named subgraphs for each group (if applicable)
- Correct shape syntax for every node
- Labels on every arrow
- `classDef` and `class` assignments for colour coding (if applicable)

Before outputting, mentally validate:
- No unclosed brackets or parentheses
- No reserved words as node IDs (`end`, `default`, `class`, `style`)
- Subgraph IDs are unique and alphanumeric (no spaces)
- `classDef` defined before `class` assignments

### 3. Present the Code

Output the diagram in a fenced Mermaid code block. Then add a brief note:
> "Here's the Mermaid code. Give it a look — I'll walk through it step by step in the next step, but flag anything that jumps out now."

### 4. Present MENU OPTIONS

Display: "**Select:** [C] Continue to review"

#### Menu Handling Logic:
- IF C: Load, read entire file, and execute {nextStepFile}
- IF user spots a syntax error or wants a change: Fix it, show the updated code, then redisplay this menu
- IF any other input: Answer, then redisplay this menu

#### EXECUTION RULES:
- ALWAYS halt and wait for user input
- ONLY proceed when user selects 'C'

## 🚨 SYSTEM SUCCESS/FAILURE METRICS

### ✅ SUCCESS:
- Code matches the confirmed node plan exactly
- All shapes use correct Mermaid syntax
- All arrows have labels
- Subgraphs used where plan specified groups
- classDef and class assignments present (if applicable)
- Syntax validated before presenting

### ❌ SYSTEM FAILURE:
- Deviating from the confirmed plan without flagging it
- Outputting syntax that fails to render (unclosed brackets, reserved words)
- Missing arrow labels
- Proceeding without user acknowledgement

**Master Rule:** Translate the plan faithfully. Validate syntax. Present clearly.
