---
name: "Validate Code Quality (Part B)"
step: "6b"
description: "Anti-pattern scan, report and completion decision"
variables:
  - anti_patterns_found
  - validation_status
---

# Step 6b: Validate — Anti-Pattern Scan & Report

---

## MANDATORY EXECUTION RULES

<critical>
- Scan ALL implemented files — DO NOT skip any
- Load data/anti-patterns-checklist.md as reference
- DO NOT mark complete if CRITICAL anti-patterns found unfixed
</critical>

---

## Phase B: Anti-Pattern Scan

### 4. Scan for Security Issues

**Load:** `data/anti-patterns-checklist.md` and scan all implemented files.

**A. Missing `@frappe.whitelist()` decorator**
- Scan all functions in `api.py` files
- **Severity: CRITICAL**

**B. SQL Injection Risks**
- Scan for string concatenation or f-strings in SQL queries
- **Severity: CRITICAL**

**C. Missing Permission Checks**
- Scan `@frappe.whitelist()` functions for `frappe.has_permission()`
- **Severity: CRITICAL**

### 5. Scan for Code Quality Issues

**D. Client-Side Business Logic**
- Scan `.js` files for complex calculations or database operations
- **Severity: HIGH**

**E. Not Converting Form Values**
- Scan for `frm.doc.field` used in arithmetic without `parseInt`/`parseFloat`
- **Severity: HIGH**

**F. Direct `frappe.db.sql` Without Params**
- Search for f-strings or `%` formatting in SQL queries
- **Severity: CRITICAL**

**G. Custom Date/Number Handling**
- Search for `datetime.strptime`, `strftime`, custom number formatting
- **Severity: MEDIUM**

**H. `console.log()` in Production**
- Scan `.js` files for `console.log()`
- **Severity: LOW**

**I. Missing `ignore_permissions` in Scheduled Jobs**
- Scan scheduled job functions
- **Severity: HIGH**

### 6. Generate Anti-Pattern Report

For each anti-pattern found:

```
[SEVERITY] Anti-Pattern Name
File: path/to/file.py
Line: XX
Code: offending snippet
Fix: recommended fix
```

**Summary:**
```
Anti-Patterns Found: [X]
├─ Critical: [X] 🔴
├─ High:     [X] 🟠
├─ Medium:   [X] 🟡
└─ Low:      [X] 🟢
```

---

## Menu

**If NO critical anti-patterns:**
**[A]** Auto-continue to Step 7 (Complete)
**[F]** Fix remaining issues now
**[P]** Pause here

**If CRITICAL anti-patterns found:**
**[F]** Fix critical issues now (RECOMMENDED)
**[D]** Document as known issues and continue (NOT RECOMMENDED)
**[C]** Cancel workflow

---

## Success Criteria

- ✅ All tests executed (from Part A)
- ✅ Anti-pattern scan completed on all files
- ✅ No CRITICAL anti-patterns (or all fixed)
- ✅ HIGH-priority issues addressed or documented
- ✅ Code is production-ready

---

## Update State

Update `session.yaml`:
```yaml
workflow_step: 6
current_task: "Validated code quality"
last_action: "Tests: [X passed / Y failed], Anti-patterns: [X found, Y critical]"
next_action: "Generate completion summary"
updated: "[current timestamp]"
```

---

## Next Step

**If [A]uto-continue:**
**→ Load and execute:** `steps/step-07-complete.md`

**If [F]ix issues:**
Fix issues → Rebuild/redeploy (Step 5) → Re-run validation → Proceed to Step 7

**If [P]ause:**
STOP here. User can review validation results.

**If [D]ocument issues:**
Record known issues, then proceed to Step 7.

**If [C]ancel:**
EXIT workflow. Update state and preserve progress.
