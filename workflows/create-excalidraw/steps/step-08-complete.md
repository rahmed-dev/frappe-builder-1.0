---
name: 'step-08-complete'
description: 'Update project state and deliver a clear completion message'
---

# Step 8: Complete

## STEP GOAL:

Update the project session and feature state, then close the workflow with a clear, useful summary of what was produced and what the user can do next.

## MANDATORY EXECUTION RULES (READ FIRST):

### Universal Rules:
- 📖 CRITICAL: Read the complete step file before taking any action
- ✅ This is the final step — no next step to load

### Step-Specific Rules:
- Update session.yaml and feature file (if `{{current_feature}}` is set)
- Completion message must tell the user exactly what they have and what they can do with it

## EXECUTION PROTOCOLS:
- Update session.yaml
- Update feature file if applicable
- Deliver completion message

## MANDATORY SEQUENCE

### 1. Update session.yaml

Write to `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/session.yaml`:

```yaml
current_task: "Excalidraw diagram created"
workflow: "create-excalidraw"
workflow_step: 8
specialist: "doc-writer"
last_action: "Created Excalidraw diagram: {{diagram_name}} (.excalidraw + .svg + -diagram.md)"
next_action: "Embed diagram in relevant guide or continue documentation"
updated: "{{timestamp}}"
```

Push `last_action` to `recent_actions` (FIFO, max 3).

### 2. Update Feature File (if applicable)

If `{{current_feature}}` is set, update `features/{{current_feature}}.yaml`:

```yaml
status: "in-progress"
updated: "{{timestamp}}"
notes: "Excalidraw diagram created: {{diagram_name}}"
```

### 3. Deliver Completion

> "Done! Three files are saved in `{{docs_path}}/diagrams/`:
>
> - **`{{diagram_name}}.excalidraw`** — open this in [Excalidraw](https://excalidraw.com), the desktop app, or the VSCode Excalidraw extension to adjust the layout
> - **`{{diagram_name}}.svg`** — embed this in any markdown file with `![title](./diagrams/{{diagram_name}}.svg)`
> - **`{{diagram_name}}-diagram.md`** — a ready-made companion doc with the SVG already embedded, ready to include in your docs set or convert to PDF
>
> What's next — another diagram, back to the guide, or something else?"

## 🚨 SYSTEM SUCCESS/FAILURE METRICS

### ✅ SUCCESS:
- session.yaml updated
- Feature file updated (if applicable)
- User knows all three file paths and what to do with each

### ❌ SYSTEM FAILURE:
- Not updating session state
- Vague completion message
- Not explaining what the user can do with each file

**Master Rule:** Update state. Name every file. Tell the user what comes next.
