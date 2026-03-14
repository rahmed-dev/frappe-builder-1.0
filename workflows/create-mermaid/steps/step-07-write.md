---
name: 'step-07-write'
description: 'Write the confirmed Mermaid diagram to the output file using the template'

nextStepFile: './step-08-complete.md'
diagramTemplate: '../template.md'
---

# Step 7: Write Output File

## STEP GOAL:

Populate the template with the confirmed diagram and write the output file to the correct path.

## MANDATORY EXECUTION RULES (READ FIRST):

### Universal Rules:
- 📖 CRITICAL: Read the complete step file before taking any action
- 🔄 CRITICAL: When loading next step with 'C', ensure entire file is read first
- ⏸️ ALWAYS halt at the menu and wait for user input

### Role Reinforcement:
- This is a clean execution step — the design work is done
- Ensure the output file is complete and self-contained

### Step-Specific Rules:
- Load {diagramTemplate} and populate all `{{variable}}` placeholders
- Confirm the output path with the user before writing if `{{docs_path}}` is unclear
- Write once — do not rewrite unless the user requests a change

## EXECUTION PROTOCOLS:
- Load {diagramTemplate}
- Resolve all placeholders from context
- Write file to `{{docs_path}}/diagrams/{{diagram_name}}-diagram.md`
- Halt at menu

## CONTEXT BOUNDARIES:
- Source: confirmed Mermaid code (step 6), diagram name, description, alt text
- Template: {diagramTemplate}
- Output path: `{{docs_path}}/diagrams/`

## MANDATORY SEQUENCE

### 1. Load Template

Load {diagramTemplate} and prepare to populate it.

### 2. Resolve Placeholders

Determine values for all template variables:
- `{{diagram_name}}` — slug derived from the subject (e.g. `purchase-request-flow`)
- `{{diagram_title}}` — human-readable title (e.g. "Purchase Request Flow")
- `{{app}}` — from session
- `{{date}}` — today's date
- `{{user_name}}` — from config
- `{{diagram_type}}` — the Mermaid type chosen in step 3
- `{{diagram_description}}` — 1–2 sentence plain-language description of what the diagram shows
- `{{diagram_alt_text}}` — accessibility description of the diagram content
- `{{mermaid_code}}` — the confirmed Mermaid code from step 6

If `{{docs_path}}` is not set in the session, ask:
> "Where should I save this? What's the path to your docs folder?"

### 3. Write the File

Write the populated template to:
`{{docs_path}}/diagrams/{{diagram_name}}-diagram.md`

### 4. Confirm Write

Report the output path:
> "Written to `{{docs_path}}/diagrams/{{diagram_name}}-diagram.md`."

### 5. Present MENU OPTIONS

Display: "**Select:** [C] Continue to wrap up"

#### Menu Handling Logic:
- IF C: Load, read entire file, and execute {nextStepFile}
- IF user wants to change the file path or name: Update and rewrite, then redisplay this menu
- IF any other input: Answer, then redisplay this menu

#### EXECUTION RULES:
- ALWAYS halt and wait for user input
- ONLY proceed when user selects 'C'

## 🚨 SYSTEM SUCCESS/FAILURE METRICS

### ✅ SUCCESS:
- Template loaded and all placeholders resolved
- File written to correct path
- Path confirmed to user

### ❌ SYSTEM FAILURE:
- Writing to wrong path
- Leaving any `{{variable}}` unresolved in the output file
- Proceeding without writing the file

**Master Rule:** Populate completely. Write once. Confirm the path.
