# Create Guide Workflow Instructions

<critical>The workflow execution engine is governed by: {project-root}/{bmad_folder}/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: workflow.yaml</critical>
<critical>This is a Frappe-specific workflow - Frappe bench awareness is MANDATORY</critical>

## Frappe Bench Context

**Session Variables:**
- `{{current_app}}` - Frappe app name
- `{{docs_path}}` - Documents directory: `{{app_path}}/docs`

<workflow>

<step n="1" goal="Understand the feature">
<action>Ask which feature needs a guide; capture what it does, who uses it, problem solved, key workflow. Load from TSD if provided.</action>

<template-output>feature_understanding</template-output>
</step>

<step n="2" goal="Create overview - 1 paragraph">
<action>Write a concise overview (1 paragraph): what it is, who it’s for, problem solved, key benefit. No ERPNext intro fluff.</action>

<template-output>overview</template-output>
</step>

<step n="3" goal="Define when to use - bullets">
<action>List business scenarios as bullets: “Use when …” and one “DON’T use when …”. Keep context-specific.</action>

<template-output>when_to_use</template-output>
</step>

<step n="4" goal="Write how to use - numbered steps, screen-based">
<action>Write numbered, screen-based steps using ERPNext terms (DocType, Child Table, Linked Document, Workflow State, List/Form View, Submit). Format: navigate → click → fill fields (with guidance) → save/submit → expected result.</action>

<template-output>how_to_use</template-output>
</step>

<step n="5" goal="Create field reference table">
<action>Document user-facing fields in a table: Field | Purpose | Required? | Format/Options (defaults if relevant). Keep as reference, not steps.</action>

<template-output>field_reference</template-output>
</step>

<step n="6" goal="Add tips and best practices - bullets">
<action>Give 3-5 concise tips: actionable advice, shortcuts, best practices, and pitfalls to avoid. Keep user-focused.</action>

<template-output>tips</template-output>
</step>

<step n="7" goal="Create troubleshooting table">
<action>Document 3-5 common issues with concise fixes in a table (Issue | Solution).</action>

<template-output>troubleshooting</template-output>
</step>

<step n="8" goal="Apply anti-fluff principles">
<action>Review entire guide for fluff:

**Remove:**
- "Introduction to ERPNext" sections
- "What is a DocType?" explanations
- Feature history or background
- Repetitive explanations
- Over-explanation of obvious steps

**Keep it to 2-3 pages:**
- Overview: 1 paragraph
- When to Use: 3-5 bullets
- How to Use: 5-10 numbered steps
- Field Reference: Table
- Tips: 3-5 bullets
- Troubleshooting: 3-5 items

If guide is longer than 5 pages, cut ruthlessly. Users want quick answers, not textbooks.
</action>

<template-output>fluff_check</template-output>
</step>

<step n="9" goal="Structure into user guide">
<action>Organize into template using {document_output_language}.

Ensure:
- Concise (2-3 pages max)
- Uses ERPNext UI terminology
- Screen-based instructions
- Actionable tips
- Practical troubleshooting
- NO fluff
</action>

<template-output>complete_guide</template-output>
</step>

<step n="10" goal="Review with user" optional="true">
<action>Ask user: "Does this guide make sense? Any missing steps?"

If changes needed, update relevant sections.

Keep it concise - resist urge to add more content.
</action>
</step>

<step n="11" goal="Update project state with documentation info">
<action>After guide creation, update the project state:

**Files to Update:**
1. `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/active.yaml`
2. `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/features/{{current_feature}}.yaml` (if feature exists)

**active.yaml - Fields to Update:**
```yaml
current_task: "User guide created"
workflow: "create-guide"
workflow_step: 11
last_action: "Created user guide: {{guide_path}}"
next_action: "Review guide with stakeholders or continue implementation"
specialist: "doc-writer"
updated: "{{timestamp}}"
```

**feature file - Fields to Update** (if {{current_feature}} exists):
```yaml
status: "in-progress"
updated: "{{timestamp}}"
documentation:
  guide_created: true
  guide_path: "{{guide_path}}"
notes: "User guide completed: {{guide_title}}"
```

**How to update:**
1. Read existing active.yaml
2. Update the fields above
3. If {{current_feature}} is set, update detailed feature file with documentation info
4. Write back to both files
</action>

<template-output>state_updated</template-output>
</step>

</workflow>
