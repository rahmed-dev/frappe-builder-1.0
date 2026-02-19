# Update Knowledge Base Workflow Instructions

<critical>The workflow execution engine is governed by: {project-root}/.bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: workflow.yaml</critical>
<critical>KB index is at: {kb_location}/INDEX.md — always read it first to locate the right file</critical>

<workflow>

<step n="1" goal="Understand what to capture">
<action>Ask the user two things:
1. What knowledge needs to be added or updated?
2. What triggered it? (pattern discovered, research finding, correction, new topic)
</action>
<template-output>knowledge_input</template-output>
</step>

<step n="2" goal="Locate the right KB file">
<action>Read `{kb_location}/INDEX.md`. Identify the best matching file for this knowledge.

- If an existing file fits → update it
- If no file fits → identify the correct category folder and propose a new filename

If genuinely ambiguous, present the options briefly and let the user choose.
</action>
<template-output>kb_target</template-output>
</step>

<step n="3" goal="Draft and confirm content">
<action>If updating an existing file: read it first, then draft only the addition or correction.
If creating a new file: draft a complete, self-contained document.

Writing standards: concrete and specific, code examples where applicable, no duplication of existing content.

Show the draft to the user and get confirmation before writing.
</action>
<template-output>content_draft</template-output>
</step>

<step n="4" goal="Write to KB and update index">
<action>After user confirms:
- Write the content using the Edit tool (existing file) or Write tool (new file)
- If a new file was created: add a row to the correct table in `{kb_location}/INDEX.md` with the file path and a one-line description
</action>
<template-output>kb_written</template-output>
</step>

<step n="5" goal="Confirm and update state">
<action>Report what was done: file updated/created, whether INDEX.md was updated, one-line summary of knowledge captured.

Update `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/session.yaml`:
```yaml
last_action: "KB updated: {{kb_file_path}}"
next_action: "Continue previous task"
updated: "{{timestamp}}"
```
</action>
<template-output>update_complete</template-output>
</step>

</workflow>
