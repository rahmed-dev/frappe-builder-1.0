---
name: 'step-04-json'
description: 'Generate the Excalidraw JSON from the confirmed element plan'

nextStepFile: './step-05-svg.md'
excalidrawSpec: '../data/excalidraw-spec.md'
---

# Step 4: Generate Excalidraw JSON

## STEP GOAL:

Translate the confirmed element plan into a valid Excalidraw JSON file, applying all visual standards from the spec.

## MANDATORY EXECUTION RULES (READ FIRST):

### Universal Rules:
- 📖 CRITICAL: Read the complete step file before taking any action
- 🔄 CRITICAL: When loading next step with 'C', ensure entire file is read first
- ⏸️ ALWAYS halt at the menu and wait for user input

### Role Reinforcement:
- This is a technical execution step — apply the spec precisely
- The element plan was confirmed; translate it faithfully
- Flag any design decision you make that wasn't explicit in the plan

### Step-Specific Rules:
- Load {excalidrawSpec} and follow JSON format exactly
- Apply visual style: roughness=1, virgil font, correct colours from step 2
- Calculate positions systematically using spacing guidelines from spec
- Assign unique IDs to every element

## EXECUTION PROTOCOLS:
- Load {excalidrawSpec} for JSON format and style values
- Build elements array systematically: frames first, then shapes, then arrows, then text labels
- Calculate x/y positions from layout direction (step 2) and spacing guidelines
- Halt at menu after presenting JSON

## CONTEXT BOUNDARIES:
- Source: confirmed element plan (step 3), layout direction (step 2), colours (step 2)
- Load {excalidrawSpec} for format and style
- Do NOT generate SVG yet — that is step 5

## MANDATORY SEQUENCE

### 1. Load Excalidraw Spec

Load {excalidrawSpec} and apply JSON format, style values, and spacing guidelines.

### 2. Calculate Layout

Based on the confirmed layout direction (step 2) and element positions (step 3):
- Set frame positions (x, y, width, height)
- Position shapes within frames using spec spacing: ~60px horizontal gap, ~80px vertical gap
- Calculate arrow start/end points from shape edges

### 3. Build the JSON

Construct the complete `elements` array in order:
1. Frame elements (define group containers first)
2. Shape elements (rectangles, diamonds, ellipses per element plan)
3. Arrow elements with `startBinding` and `endBinding`
4. Text label elements for arrow labels

Apply to every element:
- `roughness: 1`
- `fontFamily: 1` (Virgil)
- `strokeWidth: 2` (shapes) or `1` (annotations)
- Correct stroke/fill colours from step 2 colour scheme
- Unique alphanumeric `id` for every element

### 4. Output the JSON

Write the complete JSON wrapped in a fenced code block. Note any design decisions made during layout:
> "I positioned [X] on the right side because [reason] — let me know if you'd prefer it elsewhere."

### 5. Present MENU OPTIONS

Display: "**Select:** [C] Continue to generate SVG"

#### Menu Handling Logic:
- IF C: Load, read entire file, and execute {nextStepFile}
- IF user spots an error or wants a layout change: Update the affected elements, show the change, redisplay this menu
- IF any other input: Answer, then redisplay this menu

#### EXECUTION RULES:
- ALWAYS halt and wait for user input
- ONLY proceed when user selects 'C'

## 🚨 SYSTEM SUCCESS/FAILURE METRICS

### ✅ SUCCESS:
- Valid Excalidraw JSON produced (correct root structure)
- Every element from the plan is in the JSON
- Visual style applied: roughness=1, virgil font, correct colours
- Every element has a unique ID
- Arrow bindings reference correct element IDs

### ❌ SYSTEM FAILURE:
- Deviating from confirmed element plan without flagging it
- Missing elements from the plan
- Invalid JSON structure
- Duplicate element IDs

**Master Rule:** Faithful translation. Valid JSON. Every element accounted for.
