---
name: 'step-07-write'
description: 'Write all three output files: .excalidraw source, .svg embed, and companion .md'

nextStepFile: './step-08-complete.md'
diagramTemplate: '../template.md'
---

# Step 7: Write Output Files

## STEP GOAL:

Write all three output files — `.excalidraw`, `.svg`, and companion `.md` — to the correct paths.

## MANDATORY EXECUTION RULES (READ FIRST):

### Universal Rules:
- 📖 CRITICAL: Read the complete step file before taking any action
- 🔄 CRITICAL: When loading next step with 'C', ensure entire file is read first
- ⏸️ ALWAYS halt at the menu and wait for user input

### Role Reinforcement:
- Clean execution step — the creative work is done
- Three files, one path, confirm once

### Step-Specific Rules:
- Load {diagramTemplate} for the companion `.md`
- Write `.excalidraw` JSON exactly as confirmed in step 6
- Write `.svg` exactly as generated in step 5 (with any step 6 refinements applied)
- Confirm paths with user if `{{docs_path}}` is unclear

## EXECUTION PROTOCOLS:
- Resolve `{{diagram_name}}` slug and output path
- Write all three files in order
- Halt at menu

## CONTEXT BOUNDARIES:
- Source: confirmed JSON (step 6), SVG (step 5 + step 6 refinements), template
- Output path: `{{docs_path}}/diagrams/`
- Focus: write complete, correct files — no truncation

## MANDATORY SEQUENCE

### 1. Resolve Output Path

Determine:
- `{{diagram_name}}` — slug from diagram title (lowercase, hyphens, no spaces; e.g. `purchase-request-flow`)
- `{{diagram_title}}` — human-readable title
- Output folder: `{{docs_path}}/diagrams/`

If `{{docs_path}}` is not set, ask:
> "Where should I save these files? What's the path to your docs folder?"

### 2. Write the Three Files

**File 1:** `{{docs_path}}/diagrams/{{diagram_name}}.excalidraw`
Write the complete, confirmed Excalidraw JSON.

**File 2:** `{{docs_path}}/diagrams/{{diagram_name}}.svg`
Write the complete, confirmed SVG (with all step 6 refinements applied).

**File 3:** `{{docs_path}}/diagrams/{{diagram_name}}-diagram.md`
Load {diagramTemplate} and populate:
- `{{diagram_name}}`, `{{diagram_title}}`, `{{app}}`, `{{date}}`, `{{user_name}}`
- `{{diagram_description}}` — 1–2 sentence plain-language description
- `{{diagram_alt_text}}` — accessibility description of content
- SVG reference: `![{{diagram_title}}](./{{diagram_name}}.svg)`

### 3. Confirm All Three Written

Report:
> "Three files written to `{{docs_path}}/diagrams/`:
> - `{{diagram_name}}.excalidraw` — open in Excalidraw to edit
> - `{{diagram_name}}.svg` — embed in any markdown file
> - `{{diagram_name}}-diagram.md` — ready-made doc with SVG embedded"

### 4. Present MENU OPTIONS

Display: "**Select:** [C] Continue to wrap up"

#### Menu Handling Logic:
- IF C: Load, read entire file, and execute {nextStepFile}
- IF user wants to change filename or path: Update and rewrite, then redisplay this menu
- IF any other input: Answer, then redisplay this menu

#### EXECUTION RULES:
- ALWAYS halt and wait for user input
- ONLY proceed when user selects 'C'

## 🚨 SYSTEM SUCCESS/FAILURE METRICS

### ✅ SUCCESS:
- All three files written completely
- No `{{variable}}` placeholders left unresolved in any file
- Paths confirmed to user

### ❌ SYSTEM FAILURE:
- Writing only some of the three files
- Truncating JSON or SVG output
- Unresolved placeholders in companion `.md`

**Master Rule:** All three files. Complete. Confirmed.
