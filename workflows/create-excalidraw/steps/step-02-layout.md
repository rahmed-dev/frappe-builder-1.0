---
name: 'step-02-layout'
description: 'Propose layout pattern and colour scheme — confirm with user before continuing'

nextStepFile: './step-03-elements.md'
advancedElicitationTask: '{project-root}/_bmad/core/tasks/advanced-elicitation.md'
excalidrawSpec: '../data/excalidraw-spec.md'
---

# Step 2: Choose Layout Pattern

## STEP GOAL:

Select the layout pattern that will communicate the subject most clearly to the intended reader, propose a colour scheme, and get confirmation before designing the elements.

## MANDATORY EXECUTION RULES (READ FIRST):

### Universal Rules:
- 📖 CRITICAL: Read the complete step file before taking any action
- 🔄 CRITICAL: When loading next step with 'C', ensure entire file is read first
- ⏸️ ALWAYS halt at the menu and wait for user input

### Role Reinforcement:
- You are the visual design lead — bring confident recommendations
- The user validates whether your layout makes sense for their content
- State your choice with a clear reason; accept alternatives without debate

### Step-Specific Rules:
- Load {excalidrawSpec} and apply the layout pattern and colour tables
- Comprehension over convention — choose the layout that reads most clearly, not the "correct" one
- If the choice is obvious, propose it directly; if genuinely unclear, offer two options

## EXECUTION PROTOCOLS:
- Load {excalidrawSpec} silently for layout and colour reference
- Propose layout + colour scheme with reasons
- Halt at menu

## CONTEXT BOUNDARIES:
- Based on: subject and audience from step 1
- Load {excalidrawSpec} for layout and colour tables
- Do NOT define individual elements yet — that is step 3

## MANDATORY SEQUENCE

### 1. Load Excalidraw Spec

Load {excalidrawSpec} silently and apply the layout pattern and colour guidance.

### 2. Propose Layout Pattern

Choose the layout that best communicates the subject and state it:

> "I'll use a [layout name] layout because [reader-focused reason]."

Examples:
> "I'll use swim lanes because there are three roles — Customer, Sales Rep, Manager — and the reader needs to see who acts at each stage at a glance."

> "I'll use a left-to-right flow because this is a sequential pipeline and the reader is following steps in order."

> "I'll use a top-to-bottom hierarchy because this shows a parent-child DocType relationship and hierarchy reads most naturally top-down."

If genuinely unclear between two options, offer both briefly:
> "This could work as a flow (left-to-right, showing sequence) or a cluster (grouped boxes, showing categories). Which matters more — the order, or the groupings?"

### 3. Propose Colour Scheme

Suggest a colour coding approach based on the roles or categories in the diagram:

> "I'll colour-code by: [User actions = blue / System steps = grey / Errors = red]. Does that grouping make sense for your process?"

If the diagram is simple and single-role, skip colour coding:
> "This is straightforward enough that I'll keep it single-colour — clean and uncluttered."

### 4. Present MENU OPTIONS

Display: "**Select:** [A] Explore layout options in more depth [C] Confirm and continue to element design"

#### Menu Handling Logic:
- IF A: Execute {advancedElicitationTask} focused on layout exploration, then redisplay this menu
- IF C: Save layout + colour scheme to context, load, read entire file, and execute {nextStepFile}
- IF user suggests alternative: Acknowledge, switch, confirm, then redisplay this menu
- IF any other input: Answer, then redisplay this menu

#### EXECUTION RULES:
- ALWAYS halt and wait for user input
- ONLY proceed when user selects 'C'

## 🚨 SYSTEM SUCCESS/FAILURE METRICS

### ✅ SUCCESS:
- Layout pattern chosen with a reader-focused reason
- Colour scheme proposed (or single-colour justified)
- User confirmed both before proceeding

### ❌ SYSTEM FAILURE:
- Proceeding without user confirmation on layout
- Choosing layout based on "correct diagram type" instead of reader clarity
- Defining individual elements in this step

**Master Rule:** Propose with reason. Get confirmation. Then design elements.
