# Frappe-Debugger Session Memories

## Current Session Context

**User:** {user_name}
**Current App:** {{current_app}}
**App Path:** {{app_path}}
**Logs Path:** {{logs_path}}

---

## Current Debugging Work

**Issue Being Debugged:** [Error/behavior/performance issue]
**Reported By:** [Frappe-Dev / User / Direct report]
**Issue Type:** [Error-based / Behavior-based / Performance-based / Permission-based]
**Priority:** [Critical / High / Medium / Low]
**Status:** [Investigating / Root Cause Found / Fix Provided / Resolved]

---

## Error Diagnosis Log

### Active Errors
1. **[Error 1]**
   - Reported: [Date/Time]
   - Type: [ValidationError / PermissionError / etc.]
   - Location: {{app_path}}/[file].py:XXX
   - Root Cause: [Explanation]
   - Fix Status: [Investigating / Fix Provided / Resolved]

2. **[Error 2]**
   - [...]

### Resolved Errors
1. **[Resolved Error 1]**
   - Root Cause: [Explanation]
   - Location: {{app_path}}/[file].py:XXX
   - Fix Provided: [Code snippet]
   - Prevention: [Best practice taught]
   - Resolved: [Date]
   - Handed back to: Frappe-Dev

---

## Log Analysis Summary

### Error Log (error.log)
**Last Analyzed:** [Date/Time]

**Error Patterns Found:**
- [Error Type 1]: [X occurrences] - [Pattern description]
- [Error Type 2]: [Y occurrences] - [Pattern description]

**Critical Errors (Priority 1):**
- [Error]: [Frequency] - [Impact]

**Important Errors (Priority 2):**
- [Error]: [Frequency] - [Impact]

**Low Priority Warnings:**
- [Warning]: [Frequency]

### Web Log (web.log)
**Last Analyzed:** [Date/Time]

**Slow Requests (>1s):**
- [Endpoint 1]: [Avg time] - [Cause]
- [Endpoint 2]: [Avg time] - [Cause]

**Failed Requests (HTTP 500):**
- [Endpoint]: [Frequency] - [Error cause]

### Scheduler Log (scheduler.log)
**Last Analyzed:** [Date/Time]

**Failed Jobs:**
- [Job Name]: [Failure reason] - [Fix status]

**Slow Jobs:**
- [Job Name]: [Duration] - [Optimization needed?]

---

## Anti-Pattern Detection

### Scans Performed
**Last Scan:** [Date/Time]
**Files Scanned:** [List of files]

### Anti-Patterns Found

#### Critical (Security/Data Risk)
- [ ] **SQL Injection Vulnerability**: {{app_path}}/[file].py:XXX
  - Code: [Line of code]
  - Fix: [Parameterized query]
  - Status: [Reported to Frappe-Dev / Fixed]

- [ ] **Missing Permission Check**: {{app_path}}/[file].py:XXX
  - Code: [Line of code]
  - Fix: [Add frappe.has_permission()]
  - Status: [Reported to Frappe-Dev / Fixed]

#### Important (Performance/Maintainability)
- [ ] **Client-Side Filtering**: {{app_path}}/public/js/[file].js:XXX
  - Code: [Line of code]
  - Fix: [Server-side filter]
  - Status: [Reported to Frappe-Dev / Fixed]

- [ ] **N+1 Query Problem**: {{app_path}}/[file].py:XXX
  - Code: [Line of code]
  - Fix: [Batch query or join]
  - Status: [Reported to Frappe-Dev / Fixed]

#### Minor (Code Quality)
- [ ] **console.log() in Production**: {{app_path}}/public/js/[file].js:XXX
  - Code: [Line of code]
  - Fix: [Remove]
  - Status: [Reported to Frappe-Dev / Fixed]

---

## Performance Issues

### Slow Queries Identified
1. **[Query 1]**
   - Query: [SQL]
   - Execution Time: [Xms]
   - Cause: [Missing index / Table scan / etc.]
   - Fix Suggested: [Add index on [fields]]
   - Status: [Reported / Fixed]

2. **[Query 2]**
   - [...]

### Bottlenecks Identified
1. **[Bottleneck 1]**
   - Location: {{app_path}}/[file].py:XXX
   - Type: [N+1 queries / Heavy computation / etc.]
   - Impact: [Page load time / Report generation / etc.]
   - Fix Suggested: [Optimization approach]
   - Status: [Reported / Fixed]

---

## Behavior Issues Debugged

### Unexpected Behaviors
1. **[Behavior Issue 1]**
   - Expected: [What should happen]
   - Actual: [What is happening]
   - Root Cause: [Logic flaw / Missing condition / etc.]
   - Location: {{app_path}}/[file].py:XXX
   - Fix Provided: [Code change]
   - Status: [Resolved / In Progress]

---

## Permission Issues Resolved

### Permission Problems
1. **[Permission Issue 1]**
   - User Role: [Role]
   - DocType: [DocType]
   - Permission Type: [Read / Write / Submit / etc.]
   - Blocked By: [Missing role permission / User permission / Workflow state / Custom logic]
   - Fix Provided: [How to grant permission]
   - Status: [Resolved / In Progress]

---

## Frappe Built-In Alternatives Suggested

### Reinvented Wheels Found
1. **Custom Date Handling** → {{app_path}}/[file].py:XXX
   - Current: [Custom datetime code]
   - Frappe Alternative: `frappe.utils.getdate(), add_days()`
   - Benefit: [Timezone-aware, user format support]
   - Status: [Suggested to Frappe-Dev / Implemented]

2. **Custom Dialog** → {{app_path}}/public/js/[file].js:XXX
   - Current: [Custom HTML modal]
   - Frappe Alternative: `frappe.ui.Dialog`
   - Benefit: [Native UI, consistent, maintained]
   - Status: [Suggested to Frappe-Dev / Implemented]

---

## Root Cause Analysis

### Complex Debugging Cases
[Document particularly complex debugging scenarios and how they were solved]

**Example:**
- **Issue:** Sales Order total calculation wrong, but only for wholesale customers
- **Investigation Process:**
  1. Checked controller validate() method - OK
  2. Checked Client Script - Found custom calculation
  3. Checked Server Script - Found before_save modifying discount
  4. Root Cause: Server Script and Client Script conflicting
- **Resolution:** Remove Client Script calculation, keep Server Script only
- **Prevention:** Avoid mixing server and client calculations for same field

---

## Common Error Patterns

### Recurring Errors
[Track errors that occur frequently across the app]

1. **AttributeError: 'NoneType' object has no attribute 'X'**
   - Frequency: [High / Medium / Low]
   - Common Cause: Field access before doc.reload()
   - Prevention: Always check `if doc and hasattr(doc, 'field')`

2. **PermissionError in Schedulers**
   - Frequency: [High / Medium / Low]
   - Common Cause: Missing ignore_permissions=True
   - Prevention: Always use ignore_permissions in scheduled tasks

---

## Diagnostic Techniques Used

### Successful Diagnostic Approaches
[Document what worked well for different types of issues]

**For Traceback Errors:**
- Read full traceback (not just last line)
- Trace backward from error to source
- Check what changed recently

**For Behavior Issues:**
- Add debug logging to code path
- Check error.log for frappe.logger() output
- Trace method execution order

**For Performance Issues:**
- Check web.log for slow requests
- Profile SQL queries with EXPLAIN
- Look for N+1 query patterns

---

## Prevention Knowledge Base

### Best Practices Taught
[Track Frappe best practices taught to prevent future errors]

1. **Always Use Parameterized Queries**
   - Taught: [Date]
   - To: [Frappe-Dev / User]
   - Context: [Fixing SQL injection vulnerability]

2. **Server-Side Filtering Over Client-Side**
   - Taught: [Date]
   - To: [Frappe-Dev / User]
   - Context: [Optimizing slow report]

3. **frappe.utils Over Custom Date Handling**
   - Taught: [Date]
   - To: [Frappe-Dev / User]
   - Context: [Fixing timezone issue]

---

## Handoff Status

### Received from Frappe-Dev
- **Date:** [Date]
- **Error Report:** [Description]
- **Code Location:** {{app_path}}/[file].py:XXX
- **Attempted Fixes:** [What Frappe-Dev tried]

### Handed Back to Frappe-Dev
- **Date:** [Date]
- **Root Cause:** [Explanation]
- **Fix Provided:** [Code snippet]
- **Prevention:** [Best practice]
- **Status:** Resolved

---

## Urgent Issues Tracker

### Critical Issues (Need Immediate Attention)
- [ ] **[Critical Issue 1]**: [Description]
  - Impact: [Blocks users / Data corruption / Security risk]
  - Status: [Investigating / Fix Provided]

### High Priority Issues
- [ ] **[High Priority Issue 1]**: [Description]
  - Impact: [Affects multiple users / Performance degradation]
  - Status: [Investigating / Fix Provided]

---

## Session Notes

### Complex Debugging Learnings
[Lessons learned from particularly challenging debugging scenarios]

**Example:**
- Learned: Frappe caches DocType meta - changes to JSON require bench restart
- Learned: Workflow state prevents editing even if user has write permission
- Learned: frappe.db.exists() is faster than frappe.get_all() for existence checks

---

## Session Variables

```
{{current_app}} = [app name]
{{app_path}} = {project-root}/apps/{{current_app}}
{{logs_path}} = {project-root}/sites/[site]/logs
```

---

**Last Updated:** [Date]

**Notes:** Track errors diagnosed, anti-patterns found, performance issues, and fixes provided.
