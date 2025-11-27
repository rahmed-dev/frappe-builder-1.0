# 4-Tier Framework - Quick Reference

> **Full details:** `{project-root}/.bmad/frappe-builder/knowledge/frappe-framework/4-tier-framework.md`

## The Decision Tree

```
REQUIREMENT
    ↓
Does ERPNext have this EXACTLY? → YES → ✅ TIER 1: Use Standard
    ↓ NO
Can I add fields/workflows/config? → YES → ✅ TIER 2: Configure
    ↓ NO
Is it validation/calculation/report? → YES → ✅ TIER 3: Script It
    ↓ NO
Need custom DocTypes/modules? → YES → ✅ TIER 4: Custom App
```

## Tier 1: Standard ERPNext (Use As-Is)

**Check First:** Search ERPNext docs, explore modules
**Cost:** $0 | **Time:** Minutes | **Upgrade-Safe:** ✅ 100%

**Examples:**
- BOM management → BOM DocType
- Shift tracking → Shift Type + Assignment
- Quality inspection → Quality Inspection
- Batch tracking → Enable "Has Batch No"
- Approval workflows → Workflow DocType

## Tier 2: Configuration (No Code)

**Tools:** Custom Fields, Workflows, Print Formats, Dashboards
**Cost:** Minimal | **Time:** Days | **Upgrade-Safe:** ✅ Yes

**Use When:**
- Need extra data fields
- Multi-level approvals
- Custom layouts/reports
- Role-based access

**Examples:**
- Quality Grade field → Custom Field (Select)
- 3-level PO approval → Workflow
- Custom invoice format → Print Format

## Tier 3: Light Customization (Scripts)

**Tools:** Server Scripts, Client Scripts, Script Reports
**Cost:** Low | **Time:** Weeks | **Upgrade-Safe:** ⚠️ Moderate

**Use When:**
- Need business logic
- Calculations/validations
- Data synchronization
- Custom reports with logic

**Examples:**
- Auto-calculate lead time → Server Script
- Validate customer credit → Server Script
- Production efficiency report → Script Report

**Caution:** Can become complex, harder to maintain

## Tier 4: Custom App (Full Development)

**What:** Custom DocTypes, modules, advanced features
**Cost:** High | **Time:** Months | **Upgrade-Safe:** ⚠️ Requires care

**Use When:**
- Complex business processes
- Need custom DocTypes
- Integration with external systems
- Tier 3 insufficient

**Structure:** Use bench new-app, follow Frappe conventions

## Critical Decision Rule

**ALWAYS start at Tier 1. Move down ONLY if insufficient.**

- Can Tier 1 do it? → Use Tier 1
- Can Tier 2 do it? → Use Tier 2
- Can Tier 3 do it? → Use Tier 3
- Only then → Tier 4

**Why:** Lower tiers = less cost, easier maintenance, safer upgrades

## When in Doubt

1. Search ERPNext documentation
2. Check community forum for solutions
3. Consult `{project-root}/.bmad/frappe-builder/knowledge/frappe-framework/4-tier-framework.md`
4. Ask: "What's the simplest tier that solves this?"
