---
name: 'step-06-review'
description: 'Review diagram with user, handle refinements, confirm before writing files'

nextStepFile: './step-07-write.md'
advancedElicitationTask: '{project-root}/_bmad/core/tasks/advanced-elicitation.md'
---

# Step 6: Review with User

## STEP GOAL:

Describe the diagram to the user in plain language, surface any issues, handle refinements proportionally, and get final confirmation before writing the three output files.

## MANDATORY EXECUTION RULES (READ FIRST):

### Universal Rules:
- 📖 CRITICAL: Read the complete step file before taking any action
- 🔄 CRITICAL: When loading next step with 'C', ensure entire file is read first
- ⏸️ ALWAYS halt at the menu and wait for user input

### Role Reinforcement:
- This is the final quality check before output — treat it seriously
- Walk through the diagram as if explaining it to the intended reader
- Refinements are expected and welcome; handle them proportionally

### Step-Specific Rules:
- Describe the diagram in plain language — don't just list elements
- Call out layout, groupings, and flow explicitly
- Minor changes: update in place (label wording, colour, arrow direction)
- Structural changes: regenerate affected JSON section + full SVG

## EXECUTION PROTOCOLS:
- Walk through the diagram conversationally
- Ask one focused question: does this match?
- Handle changes proportionally — don't regenerate everything for minor fixes
- Halt at menu

## CONTEXT BOUNDARIES:
- Source: Excalidraw JSON + SVG from steps 4–5
- Focus: accuracy and reader experience
- Changes here are final before writing — make them count

## MANDATORY SEQUENCE

### 1. Describe the Diagram

Walk through it as if presenting to the intended reader:

> "The diagram shows [overview]. It's organised into [N] [frames/groups]: [Group 1] on the [position] and [Group 2] on the [position]. Starting from [start element]: [trace the main path]. At [decision point], the flow splits: [path A] if [condition], or [path B] if [other condition]. The [colour] elements are [role/category]; the [colour] ones are [other role]."

Keep it conversational — this is how the reader will experience it.

### 2. Note the Three Outputs

Remind the user what they'll get:
> "Once confirmed, I'll save three files: the editable `.excalidraw` source, the `.svg` for embedding in your docs, and a companion `.md` with the SVG already included."

### 3. Ask for Confirmation

> "Does this match what you had in mind? Any elements to rename, reposition, or add?"

Listen carefully. If they say yes, proceed to menu. If they have changes:

**Minor changes** (label wording, colour swap, arrow label):
- Update the JSON element(s) and SVG text node(s) in place
- Show: "Updated `[old]` → `[new]`"
- Ask: "Anything else?"

**Structural changes** (add/remove elements, change layout):
- Acknowledge, update the affected JSON section
- Regenerate the full SVG (since positions change)
- Walk through the affected area again before continuing

### 4. Present MENU OPTIONS

Display: "**Select:** [A] Explore the diagram in more depth [C] Confirm and write output files"

#### Menu Handling Logic:
- IF A: Execute {advancedElicitationTask} focused on diagram accuracy, then redisplay this menu
- IF C: Save final JSON and SVG, load, read entire file, and execute {nextStepFile}
- IF user requests change: Handle proportionally (see step 3), then redisplay this menu
- IF any other input: Answer, then redisplay this menu

#### EXECUTION RULES:
- ALWAYS halt and wait for user input
- ONLY proceed when user selects 'C'

## 🚨 SYSTEM SUCCESS/FAILURE METRICS

### ✅ SUCCESS:
- Diagram described in plain language (not just element list)
- User understood what they'll receive (three files)
- Changes handled proportionally
- User confirmed before proceeding

### ❌ SYSTEM FAILURE:
- Skipping the plain-language description
- Regenerating everything for a label change
- Proceeding without confirmation

**Master Rule:** Describe it. Handle changes proportionally. Confirm everything before writing.
