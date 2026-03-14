---
name: 'step-06-review'
description: 'Walk through the diagram with the user, refine if needed, confirm before writing'

nextStepFile: './step-07-write.md'
advancedElicitationTask: '{project-root}/_bmad/core/tasks/advanced-elicitation.md'
---

# Step 6: Review with User

## STEP GOAL:

Walk through the diagram in plain language, surface any issues the user spots, refine if needed, and get final confirmation before writing the output file.

## MANDATORY EXECUTION RULES (READ FIRST):

### Universal Rules:
- 📖 CRITICAL: Read the complete step file before taking any action
- 🔄 CRITICAL: When loading next step with 'C', ensure entire file is read first
- ⏸️ ALWAYS halt at the menu and wait for user input

### Role Reinforcement:
- This is a collaborative quality check — not a sign-off formality
- Walk through the diagram as if you're explaining it to the intended reader
- The user's domain knowledge may catch errors your expertise missed

### Step-Specific Rules:
- Describe the diagram in plain language — do not just repeat the code
- Call out decision branches and exception paths explicitly
- For minor label tweaks: update in place, no regeneration needed
- For structural changes: return to step 4 or 5 as appropriate

## EXECUTION PROTOCOLS:
- Walk through each group and path in plain language
- Ask one focused question: does the flow match the process?
- Handle changes proportionally — don't regenerate everything for a label fix
- Halt at menu

## CONTEXT BOUNDARIES:
- Source: Mermaid code from step 5
- Focus: accuracy and readability from the end user's perspective
- Changes requested here are handled here — do not re-run earlier steps unless structural

## MANDATORY SEQUENCE

### 1. Walk Through the Diagram

Describe the diagram conversationally — as if explaining it to the intended reader:

> "So the diagram shows [overview]. Starting from [start node]: [trace the happy path through groups]. If [decision condition], the flow goes to [path]. If [other condition], it goes to [other path]. The diagram ends at [end node]."

Highlight any colour groupings:
> "The blue nodes are what the user does; the grey ones are automated system steps."

### 2. Ask for Confirmation

Ask a single, focused question:
> "Does this match how the process actually works? Anything missing or wrong?"

Listen carefully. If they say yes immediately, proceed to menu. If they hesitate, probe:
> "Any steps that should come before [node]?" or "Is the [decision] logic correct?"

### 3. Handle Changes

**For minor changes** (label wording, arrow direction, colour):
- Update the code directly
- Show only the changed lines: "Updated: `[old]` → `[new]`"
- Confirm: "Anything else?"

**For structural changes** (add/remove nodes, change groups):
- Acknowledge, make the changes, show the revised code block
- Walk through the affected section again
- Confirm before continuing

### 4. Present MENU OPTIONS

Display: "**Select:** [A] Explore the diagram in more depth [C] Confirm and write the output file"

#### Menu Handling Logic:
- IF A: Execute {advancedElicitationTask} focused on diagram accuracy, then redisplay this menu
- IF C: Save final Mermaid code to context, load, read entire file, and execute {nextStepFile}
- IF user requests change: Handle it (see step 3), then redisplay this menu
- IF any other input: Answer, then redisplay this menu

#### EXECUTION RULES:
- ALWAYS halt and wait for user input
- ONLY proceed when user selects 'C'

## 🚨 SYSTEM SUCCESS/FAILURE METRICS

### ✅ SUCCESS:
- Diagram described in plain language (not just code repeated)
- Decision branches and exception paths called out
- Changes handled proportionally
- User confirmed diagram is accurate

### ❌ SYSTEM FAILURE:
- Skipping the plain-language walk-through
- Regenerating the entire diagram for a minor label fix
- Proceeding without user confirmation

**Master Rule:** Explain it. Invite critique. Fix proportionally. Confirm.
