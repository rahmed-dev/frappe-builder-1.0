---
name: 'step-03-elements'
description: 'Define all diagram elements in plain language — confirm accuracy before any JSON is generated'

nextStepFile: './step-04-json.md'
advancedElicitationTask: '{project-root}/_bmad/core/tasks/advanced-elicitation.md'
excalidrawSpec: '../data/excalidraw-spec.md'
---

# Step 3: Define Elements

## STEP GOAL:

Produce a plain-language element plan covering every shape, label, connection, and group — and confirm it is accurate before generating any JSON or SVG.

## MANDATORY EXECUTION RULES (READ FIRST):

### Universal Rules:
- 📖 CRITICAL: Read the complete step file before taking any action
- 🔄 CRITICAL: When loading next step with 'C', ensure entire file is read first
- ⏸️ ALWAYS halt at the menu and wait for user input

### Role Reinforcement:
- This is the most important collaborative step — domain accuracy is caught here, not after generation
- The user's job is to confirm the plan is right; your job is to make it easy to read and verify
- A correction here costs one line; a correction after JSON generation costs much more

### Step-Specific Rules:
- FORBIDDEN: Generating any JSON or SVG in this step
- Present plan in plain language — no Excalidraw syntax
- Every connection must have a label
- Every frame/group must have a name

## EXECUTION PROTOCOLS:
- Load {excalidrawSpec} for shape vocabulary
- Draft element plan using the layout from step 2
- Present plan clearly — invite corrections
- Only proceed to JSON generation after explicit confirmation

## CONTEXT BOUNDARIES:
- Based on: subject (step 1), layout + colours (step 2)
- Load {excalidrawSpec} for shape types
- Focus: complete, accurate element list in plain language

## MANDATORY SEQUENCE

### 1. Load Excalidraw Spec

Load {excalidrawSpec} silently and apply shape vocabulary.

### 2. Draft the Element Plan

Build the plan using the confirmed layout from step 2. Format:

```
Frame/Group "[Name]" [colour if applicable]:
  [Shape]: "Label" →[arrow label]→ [Shape]: "Label"
  [Shape]: "Label" →[arrow label]→ [Shape]: "Label"

Frame/Group "[Name 2]":
  ...

Standalone connections (if any):
  [Shape] in [Group] →[label]→ [Shape] in [Group 2]
```

Use shape names (Rectangle, Rounded Rectangle, Diamond, Ellipse), not JSON type names.

Example:
```
Frame "Customer Actions" [blue]:
  Ellipse: "Start" →initiates→ Rectangle: "Submit Purchase Request"
  Rectangle: "Submit Purchase Request" →triggers→ [connects to Approval frame]

Frame "Approval" [grey]:
  Diamond: "Budget Available?" →yes, auto→ Rectangle: "Auto-Approve"
  Diamond: "Budget Available?" →over limit→ Rectangle: "Manager Review"
  Rectangle: "Manager Review" →approved→ Ellipse: "End: Confirmed"
  Rectangle: "Manager Review" →rejected→ Rounded Rectangle: "Returns to Draft"

Cross-frame arrow:
  Rectangle: "Submit Purchase Request" [Customer] →sends to→ Diamond: "Budget Available?" [Approval]
```

### 3. Note Layout Coordinates (Rough)

Briefly indicate relative positions — not pixel values, just orientation:
> "Customer Actions frame on the left, Approval frame on the right, connected by a horizontal arrow."

### 4. Present Plan to User

Share the plan and invite corrections:
> "Here's what I'm planning to draw. Does this match the actual process? Anything missing, mislabelled, or in the wrong group?"

Listen carefully. If they hesitate or seem uncertain, probe:
> "Should anything happen between [X] and [Y]?"

### 5. Present MENU OPTIONS

Display: "**Select:** [A] Work through the elements in more detail [C] Confirm plan and generate diagram"

#### Menu Handling Logic:
- IF A: Execute {advancedElicitationTask} on the element plan, then redisplay this menu
- IF C: Save confirmed element plan, load, read entire file, and execute {nextStepFile}
- IF user corrects or adds: Update plan, show revised section, confirm, then redisplay this menu
- IF any other input: Answer, then redisplay this menu

#### EXECUTION RULES:
- ALWAYS halt and wait for user input
- ONLY proceed when user explicitly confirms the plan with 'C'
- Do NOT proceed if the user seems uncertain — probe further

## 🚨 SYSTEM SUCCESS/FAILURE METRICS

### ✅ SUCCESS:
- Every shape has a type and label
- Every connection has an arrow label
- Every frame has a name
- Rough layout positions noted
- User explicitly confirmed the plan

### ❌ SYSTEM FAILURE:
- Generating JSON or SVG before plan is confirmed
- Proceeding when user seems uncertain
- Any connection without a label

**Master Rule:** Plan in plain language. Confirm before generating. This step prevents wasted work.
