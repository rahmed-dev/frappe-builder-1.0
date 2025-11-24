# Doc-Writer Session Memories

## Current Session Context

**User:** {user_name}
**Current App:** {{current_app}}
**App Path:** {{app_path}}
**Docs Path:** {{docs_path}}
**Guides Path:** {{guides_path}}

---

## Current Documentation Work

**Feature Being Documented:** [Feature name]
**Requested By:** [Frappe-Architect / Frappe-Dev / User]
**Documentation Type:** [Feature Guide / Workflow Guide / Report Guide / Quick Reference]
**Status:** [Draft / Review / Complete]

---

## Guides Created

### User Guides
1. **[Feature Name] Guide** - {{guides_path}}/[filename].md
   - Type: [Feature / Workflow / Report / Quick Reference]
   - Length: [X pages]
   - Template Used: [Template name]
   - Created: [Date]
   - Status: ✅ Complete

2. **[Feature Name] Guide**
   - [...]

### Quick Reference Cards
1. **[Feature] Quick Reference** - {{guides_path}}/quick-reference-[feature].md
   - Length: 1 page
   - Created: [Date]
   - Status: ✅ Complete

---

## Documentation Statistics

**Total Guides Created:** [X]
**Average Length:** [Y pages]
**Templates Used:**
- Feature Guide: [X times]
- Workflow Guide: [Y times]
- Report Guide: [Z times]
- Quick Reference: [W times]

---

## Compacting Projects

### Documents Compacted
1. **[Document Name]**
   - Original Length: [X pages]
   - Compacted Length: [Y pages]
   - Reduction: [Z%]
   - Date: [Date]
   - Key Changes: [What was removed/improved]

---

## Features Documented

### Custom Features
- [Feature 1]: [Brief description] - Guide: [filename]
- [Feature 2]: [Brief description] - Guide: [filename]

### Workflows
- [Workflow 1]: [Brief description] - Guide: [filename]
- [Workflow 2]: [Brief description] - Guide: [filename]

### Reports
- [Report 1]: [Brief description] - Guide: [filename]
- [Report 2]: [Brief description] - Guide: [filename]

---

## Documentation Quality Notes

### Successful Patterns
[What worked well in guides that users loved]

**Example:**
- Using tables for field reference - users found it easy to scan
- Including keyboard shortcuts - power users appreciated this
- Front-loading purpose - users knew immediately if guide was relevant

### Areas for Improvement
[Feedback received or self-identified improvements]

**Example:**
- Need more troubleshooting examples for [feature]
- Screenshot descriptions could be clearer
- Some jargon slipped through in [guide name]

---

## User Feedback

### Positive Feedback
- **[Feature] Guide**: "[User quote]"
- **[Feature] Guide**: "[User quote]"

### Improvement Requests
- **[Feature] Guide**: Need more examples for [scenario]
- **[Feature] Guide**: Clarify [specific step]

---

## ERPNext Terminology Learned

### Standard ERPNext Terms
[Terms users see in ERPNext UI that should be used in guides]

- [Term 1]: [Where users see it] - [How to use in documentation]
- [Term 2]: [Where users see it] - [How to use in documentation]

**Example:**
- "Submit": Button users click to confirm document
- "Workflow State": Status shown in workflow-enabled documents
- "Child Table": Table within a form (Items table, Operations table)

---

## Writing Decisions Made

### Style Choices
1. **[Decision 1]**: [Why this approach]
   - Example: Using "Click Submit" instead of "Submit the document"
   - Reason: More direct, matches UI button text

2. **[Decision 2]**: [Why this approach]
   - Example: Tables for field reference instead of prose
   - Reason: Easier to scan, find specific field quickly

### Template Adaptations
[Times when standard template was adapted and why]

**Example:**
- **[Feature] Guide**: Added "Common Workflows" section because feature has multiple use cases
- **[Report] Guide**: Skipped "Exporting" section because report is view-only

---

## Handoff Status

### Received from Frappe-Architect
- **Date:** [Date]
- **Feature:** [Feature name]
- **TSD Location:** {{tsd_path}}/[filename].md
- **Request:** Document user interaction for [feature]

### Received from Frappe-Dev
- **Date:** [Date]
- **Feature:** [Feature name]
- **Implementation Status:** Complete
- **Request:** Create user guide

### Delivered to User
- **Date:** [Date]
- **Guide:** {{guides_path}}/[filename].md
- **Preview:** [One sentence purpose]
- **Status:** Ready for training

---

## Session Notes

### Complex Documentation Challenges
[Features that were particularly challenging to document and how they were handled]

**Example:**
- **Multi-step approval workflow**: Created state diagram in text format, numbered steps for each role
- **Complex report with many filters**: Created "Useful Filter Combos" section showing common scenarios

---

## Fluff Removal Techniques

### Common Fluff Patterns Removed
[Types of unnecessary content frequently removed]

1. **"What is ERPNext?" Introductions**
   - Removed: [X times]
   - Why: Users already know context

2. **Redundant Explanations**
   - Removed: [X times]
   - Example: Removed explanation of what "Save" button does

3. **Technical Background**
   - Removed: [X times]
   - Example: Removed "How the system works internally" section

---

## Documentation Templates Used

### Template Usage Statistics
- **Feature Guide Template**: [X times]
  - Average length: [Y pages]
  - User feedback: [Positive/Needs work]

- **Workflow Guide Template**: [X times]
  - Average length: [Y pages]
  - User feedback: [Positive/Needs work]

- **Report Guide Template**: [X times]
  - Average length: [Y pages]
  - User feedback: [Positive/Needs work]

- **Quick Reference Template**: [X times]
  - Average length: 1 page always
  - User feedback: [Positive/Needs work]

---

## Best Practices Learned

### From This Project
[Lessons learned specific to this app/project]

**Example:**
- This app's users prefer tables over prose
- Users need more troubleshooting help than average
- Quick reference cards are heavily used

### General Documentation Learnings
[Broadly applicable lessons]

**Example:**
- Active voice makes steps clearer
- Front-loading purpose saves user time
- 2-page guides get read, 12-page guides don't

---

## Review Checklist Results

### Guides Reviewed
1. **[Guide Name]**
   - Length: [X pages] - ✅ Pass (2-3 pages)
   - Active Voice: ✅ Pass
   - Screen Terminology: ⚠️ Minor issues - [Details]
   - Fluff-Free: ✅ Pass
   - Overall: [Rating]

---

## Session Variables

```
{{current_app}} = [app name]
{{app_path}} = {project-root}/apps/{{current_app}}
{{docs_path}} = {{app_path}}/docs
{{guides_path}} = {{docs_path}}/guides
```

---

**Last Updated:** [Date]

**Notes:** Track guides created, compacting results, user feedback, and documentation quality.
