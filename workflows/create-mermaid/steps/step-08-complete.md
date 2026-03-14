---
name: 'step-08-complete'
description: 'Update project state and deliver a satisfying completion'
---

# Step 8: Complete

## STEP GOAL:

Update the project session and feature state, then close the workflow with a clear summary of what was produced.

## MANDATORY EXECUTION RULES (READ FIRST):

### Universal Rules:
- 📖 CRITICAL: Read the complete step file before taking any action
- ✅ This is the final step — no next step to load

### Step-Specific Rules:
- Update both session.yaml AND feature file (if `{{current_feature}}` is set)
- Completion message should be warm and useful — tell the user what they have and what they can do next

## EXECUTION PROTOCOLS:
- Update session.yaml
- Update feature file if applicable
- Deliver completion message

## MANDATORY SEQUENCE

### 1. Update session.yaml

Write to `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/session.yaml`:

```yaml
current_task: "Mermaid diagram created"
workflow: "create-mermaid"
workflow_step: 8
specialist: "doc-writer"
last_action: "Created Mermaid diagram: {{diagram_name}}-diagram.md"
next_action: "Embed diagram in relevant guide or continue documentation"
updated: "{{timestamp}}"
```

Push `last_action` to `recent_actions` (FIFO, max 3).

### 2. Update Feature File (if applicable)

If `{{current_feature}}` is set, update `features/{{current_feature}}.yaml`:

```yaml
status: "in-progress"
updated: "{{timestamp}}"
notes: "Mermaid diagram created: {{diagram_name}}"
```

### 3. Deliver Completion

Share a clear, useful completion message:

> "Done! Your diagram is saved at:
> `{{docs_path}}/diagrams/{{diagram_name}}-diagram.md`
>
> It contains the full Mermaid code block — embed it in any guide with a standard markdown link, or paste the code into [Mermaid Live Editor](https://mermaid.live) to preview it.
>
> What's next — another diagram, back to the guide, or something else?"

## 🚨 SYSTEM SUCCESS/FAILURE METRICS

### ✅ SUCCESS:
- session.yaml updated with correct fields
- Feature file updated (if applicable)
- User knows exactly where the file is and what to do next

### ❌ SYSTEM FAILURE:
- Not updating session state
- Vague completion message that doesn't tell user where the file is

**Master Rule:** Update state. Tell the user what they have and what comes next.
