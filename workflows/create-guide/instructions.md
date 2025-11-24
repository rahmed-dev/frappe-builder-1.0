# Create Guide Workflow Instructions

<critical>The workflow execution engine is governed by: {project-root}/.bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: workflow.yaml</critical>
<critical>This is a Frappe-specific workflow - Frappe bench awareness is MANDATORY</critical>

## Frappe Bench Context

**Session Variables:**
- `{{current_app}}` - Frappe app name
- `{{docs_path}}` - Documents directory: `{{app_path}}/docs`

<workflow>

<step n="1" goal="Understand the feature">
<action>Get feature information from user:

Ask: Which feature needs user guide?

Options:
1. Feature name and description (user provides)
2. Load from TSD (user provides path)
3. Explore implemented feature (user shows DocType/page)

Understand:
- What does this feature do?
- Who uses it?
- What problem does it solve?
- Key workflows/processes
</action>

<template-output>feature_understanding</template-output>
</step>

<step n="2" goal="Create overview - 1 paragraph">
<action>Write concise overview (1 paragraph, 3-5 sentences):

Answer:
- What is this feature?
- Who is it for?
- What problem does it solve?
- Key benefit to user

**Anti-fluff rule:** NO "Introduction to ERPNext" content. Assume user knows ERPNext basics.

Example:
"The Automated Purchase Requisition feature streamlines procurement by auto-generating purchase requests when stock falls below reorder levels. Designed for Store Managers and Purchase Officers, it eliminates manual stock monitoring and ensures timely replenishment. The system checks stock levels daily and creates requisitions that route to the Purchasing team for approval."

Write clear, direct overview.
</action>

<template-output>overview</template-output>
</step>

<step n="3" goal="Define when to use - bullets">
<action>List business scenarios when this feature is used:

**Format:**
- Use when [scenario 1]
- Use when [scenario 2]
- Use when [scenario 3]
- DON'T use when [anti-scenario]

Example:
- Use when stock levels reach reorder point
- Use when you need automated procurement tracking
- Use when managing multiple warehouses
- DON'T use for one-time emergency purchases (create Purchase Order directly)

Be specific about business context.
</action>

<template-output>when_to_use</template-output>
</step>

<step n="4" goal="Write how to use - numbered steps, screen-based">
<action>Write step-by-step instructions using ERPNext UI terminology:

**ERPNext UI Terms to use:**
- DocType (not "form" or "screen")
- Child Table (not "line items")
- Linked Document (not "related record")
- Workflow State (not "status")
- Dashboard (not "homepage")
- List View (not "index page")
- Form View (not "detail page")
- Submit (not "finalize" - specific ERPNext action)

**Format:**
1. Navigate to [Module] → [DocType]
2. Click [Button name]
3. Fill in [Field name]:
   - [Field 1]: [Guidance]
   - [Field 2]: [Guidance]
4. Click [Save/Submit]
5. Expected result: [What happens]

**Example:**
```
How to Create Automated Purchase Requisition:

1. Navigate to Buying → Purchase Requisition Settings
2. Enable "Auto Create Purchase Requisitions"
3. Set Reorder Level for each Item:
   - Go to Stock → Item
   - Open the Item you want to track
   - In "Reorder" section, set Reorder Level: 50
   - Set Reorder Qty: 100
4. Configure Schedule:
   - Go to Setup → Scheduler
   - Enable "Daily Stock Check"
5. System will automatically:
   - Check stock levels daily at 6 AM
   - Create Purchase Requisition when stock < Reorder Level
   - Assign to Purchase Manager for approval
```

Screen-based, numbered steps using exact UI terminology.
</action>

<template-output>how_to_use</template-output>
</step>

<step n="5" goal="Create field reference table">
<action>Document all relevant fields in table format:

**Format:**
| Field Name | Purpose | Required? | Format/Options |
|------------|---------|-----------|----------------|
| Customer | Select customer | Yes | Link to Customer |
| Item Code | Product to order | Yes | Link to Item |
| Quantity | Number of units | Yes | Positive number |
| Delivery Date | Expected delivery | No | Future date |

Include:
- ALL user-facing fields
- Purpose (what it's for)
- Whether required
- Data format or valid options
- Default values (if any)

This is a REFERENCE table, not instructions.
</action>

<template-output>field_reference</template-output>
</step>

<step n="6" goal="Add tips and best practices - bullets">
<action>Provide helpful tips:

**Format:**
- Tip: [Actionable advice]
- Shortcut: [Keyboard shortcut or quick method]
- Best Practice: [Recommended approach]
- Avoid: [Common mistake]

Example:
- Tip: Use Ctrl+K (Quick Search) to open any DocType quickly
- Shortcut: Ctrl+S saves form without needing to click Save button
- Best Practice: Set Reorder Levels during item creation, not later
- Avoid: Setting Reorder Level to 0 (disables automation)

3-5 bullets maximum. Practical, actionable tips only.
</action>

<template-output>tips</template-output>
</step>

<step n="7" goal="Create troubleshooting table">
<action>Document common issues and solutions:

**Format:**
| Issue | Solution |
|-------|----------|
| Requisitions not auto-creating | Check Scheduler enabled, Reorder Level set |
| Wrong quantity in requisition | Update Reorder Qty in Item master |
| No email notification | Check Workflow Email settings |

3-5 common issues only. Clear, actionable solutions.
</action>

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

If guide is longer than 3 pages, cut ruthlessly. Users want quick answers, not textbooks.
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

</workflow>
