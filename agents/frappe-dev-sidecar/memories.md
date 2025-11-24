# Frappe-Dev Session Memories

## Current Session Context

**User:** {user_name}
**Current App:** {{current_app}}
**App Path:** {{app_path}}
**Docs Path:** {{docs_path}}
**Implementation Plans Path:** {{implementation_plans_path}}

---

## Current Implementation Work

**Project Name:** [Project being implemented]
**Source TSD:** [TSD filename]
**Implementation Plan:** [Plan filename]
**Current Phase:** [Phase 1 / Phase 2 / Phase 3]
**Phase Status:** [Not Started / In Progress / Testing / Complete]

---

## Phase Progress Tracking

### Phase 1: Foundation & Core Workflow
**Goal:** [What users can do after Phase 1]

**User Tasks (Phase 1):**
- [ ] [DocType 1]: Create via UI
- [ ] [DocType 2]: Create via UI
- [ ] [Custom Fields]: Add to [DocType]
- [ ] [Workflow]: Configure for [DocType]

**Developer Tasks (Phase 1):**
- [ ] [Server Script 1]: [Purpose]
- [ ] [Client Script 1]: [Purpose]
- [ ] [Script Report 1]: [Purpose]

**Current Task:** [What I'm working on right now]
**Status:** [In Progress / Testing / Complete]

### Phase 2: Extended Functionality
**Status:** [Not Started / In Progress / Complete]

**User Tasks (Phase 2):**
- [ ] [Task list]

**Developer Tasks (Phase 2):**
- [ ] [Task list]

### Phase 3: Enhancements & Optimizations
**Status:** [Not Started / In Progress / Complete]

**User Tasks (Phase 3):**
- [ ] [Task list]

**Developer Tasks (Phase 3):**
- [ ] [Task list]

---

## Code Implementation Summary

### DocTypes Created
1. **[DocType 1]**
   - Location: {{app_path}}/[module]/doctype/[doctype]/
   - Fields: [Field summary]
   - Controller: [Methods implemented]
   - Status: ✅ Created and migrated

2. **[DocType 2]**
   - [...]

### Custom Fields Added
| Target DocType | Field Name | Type | Purpose | Status |
|----------------|-----------|------|---------|--------|
| [DocType] | [field] | [type] | [purpose] | ✅ |

### Server Scripts Implemented
1. **[Script 1]** - {{app_path}}/[module]/[file].py
   - Purpose: [Description]
   - Trigger: [before_save / on_submit / @frappe.whitelist()]
   - Status: ✅ Implemented and tested

2. **[Script 2]**
   - [...]

### Client Scripts Implemented
1. **[Script 1]** - {{app_path}}/public/js/[doctype].js
   - Purpose: [Description]
   - Triggers: [refresh / field changes / custom buttons]
   - Status: ✅ Implemented and tested

### Script Reports Created
1. **[Report 1]** - {{app_path}}/[module]/report/[report_name]/
   - Purpose: [Description]
   - Data Sources: [DocTypes queried]
   - Filters: [Filter list]
   - Status: ✅ Created and tested

### Background Jobs Configured
1. **[Job 1]** - hooks.py + tasks.py
   - Frequency: [daily / hourly / weekly]
   - Purpose: [Description]
   - Status: ✅ Configured and tested

### API Endpoints Created
1. **@frappe.whitelist() - [method_name]**
   - File: {{app_path}}/[module]/[file].py
   - Purpose: [Description]
   - Args: [Param list]
   - Returns: [Return format]
   - Permission Check: ✅ Yes
   - Status: ✅ Implemented

---

## Testing & Validation

### Unit Tests Written
- [ ] [test_doctype_1.py]: [X tests] - [Passed/Failed]
- [ ] [test_module_1.py]: [X tests] - [Passed/Failed]

**Total Tests:** [X]
**Passed:** [Y]
**Failed:** [Z]

### Anti-Pattern Validation
**Last Validated:** [Date]

**Checks Performed:**
- ✅ All @frappe.whitelist() methods have permission checks
- ✅ No SQL injection vulnerabilities (parameterized queries)
- ✅ No client-side filtering (server-side only)
- ✅ No custom HTML/CSS (frappe.ui components used)
- ✅ No console.log() in production code
- ✅ frappe.utils used (not custom date/number handling)

**Issues Found:** [None / List of issues and fixes]

### Bench Operations Log
**Last bench build:** [Date/Time] - [Success/Failed]
**Last bench migrate:** [Date/Time] - [Success/Failed]
**Last bench restart:** [Date/Time] - [Success/Failed]

---

## Implementation Decisions Made

### Technical Decisions
1. **[Decision 1]**: [Chose approach X because...]
2. **[Decision 2]**: [Used Frappe pattern Y for...]
3. **[Decision 3]**: [Implemented Z differently from TSD because...]

### Frappe Patterns Used
1. **[Pattern 1]**: [Where used and why]
   - Example: Used frappe.ui.Dialog for data entry instead of custom form

2. **[Pattern 2]**: [Where used and why]
   - Example: Server-side filtering in Script Report instead of client-side

### Deviations from TSD
**Any implementation that differs from TSD (with justification):**
- [Feature X]: [Changed from TSD design because...]
- [Feature Y]: [Used Frappe built-in instead of custom because...]

---

## Blockers & Resolutions

### Current Blockers
- [ ] [Blocker 1]: [Description and impact]
- [ ] [Blocker 2]: [Description and impact]

### Resolved Blockers
1. **[Blocker that was resolved]**
   - Problem: [Description]
   - Resolution: [How it was fixed]
   - Resolved By: [Frappe-Debugger / Self / User clarification]
   - Date: [Date]

---

## Code Quality Notes

### Refactoring Needed
- [ ] [File/Function]: [Why refactoring needed]
- [ ] [File/Function]: [Why refactoring needed]

### Technical Debt
- [Debt item 1]: [Description and plan to address]
- [Debt item 2]: [Description and plan to address]

### Performance Considerations
- [Consideration 1]: [Query optimization needed?]
- [Consideration 2]: [Index needed for large datasets?]
- [Consideration 3]: [Background job needed for heavy processing?]

---

## Handoff Status

### Received from Frappe-Planner
- **Date:** [Date]
- **Implementation Plan Location:** {{implementation_plans_path}}/[filename].md
- **Source TSD:** {{tsd_path}}/[filename].md
- **Assigned Phase:** Phase 1
- **Planner's Notes:** [Any special notes from handoff]

### Handed to Frappe-Debugger
- **Date:** [Date if occurred]
- **Reason:** [Error / Anti-pattern / Performance issue]
- **Issue Description:** [What was handed off]
- **Resolution:** [What Debugger found/fixed]
- **Returned:** [Date]

### Handed back to Frappe-Planner
- **Date:** [Date]
- **Phase Complete:** Phase 1
- **Completion Criteria Met:** ✅ All
- **Notes:** [Any notes for next phase]

---

## Session Notes

### Complex Implementation Challenges
[Any particularly complex features and how they were implemented]

**Example:**
- Multi-level BOM calculation: [How it was implemented]
- Real-time stock synchronization: [Approach taken]

### Frappe Framework Learnings
[New Frappe patterns or features discovered during implementation]

**Example:**
- Discovered frappe.db.exists() is faster than frappe.get_all() for existence checks
- Learned about frappe.only_for() decorator for role-based API access

### Code Reuse Opportunities
[Patterns that can be reused in future implementations]

**Example:**
- Dialog template for multi-step data entry
- Background job error handling pattern

---

## User Guidance Provided

### UI Configuration Steps Guided
1. **[DocType Creation]**: [Date] - Guided user through creating [DocType]
2. **[Custom Fields]**: [Date] - Guided user through adding fields to [DocType]
3. **[Workflow]**: [Date] - Guided user through workflow configuration

**User Feedback:** [Any feedback user provided about the guidance]

---

## Files Modified/Created

### New Files Created
```
{{app_path}}/[module]/doctype/[doctype]/[doctype].py
{{app_path}}/[module]/doctype/[doctype]/[doctype].json
{{app_path}}/public/js/[doctype].js
{{app_path}}/[module]/report/[report]/[report].py
{{app_path}}/tasks.py
```

### Modified Files
```
{{app_path}}/hooks.py (added scheduler_events)
{{app_path}}/[module]/[file].py (added new methods)
```

---

## Session Variables

```
{{current_app}} = [app name]
{{app_path}} = {project-root}/apps/{{current_app}}
{{docs_path}} = {{app_path}}/docs
{{tsd_path}} = {{docs_path}}/tsd
{{implementation_plans_path}} = {{docs_path}}/implementation-plans
```

---

**Last Updated:** [Date]

**Notes:** Track implementation progress, code quality, testing results, and handoff status.
