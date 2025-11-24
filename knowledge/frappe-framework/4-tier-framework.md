# 4-Tier Solution Framework

Configure-first principle: Check what ERPNext/Frappe provides before custom development. Ensures upgrade-safe, maintainable, cost-effective solutions.

## TIER 1: ERPNext Built-in (Use As-Is)

**Philosophy:** 80% of business needs are standard

**Approach:**
1. Search ERPNext module capabilities
2. Identify which module handles it
3. Identify specific DocTypes
4. Validate standard feature matches need
5. Present: "ERPNext has this - here's how"

**Examples:**
- BOM management → ERPNext BOM DocType
- Shift management → Shift Type + Shift Assignment
- Quality inspection → Quality Inspection module
- Batch tracking → Enable Has Batch No on Item
- Approval workflows → ERPNext Workflow

**Benefits:** Zero cost, immediate, upgrade-safe, community-tested

## TIER 2: Configuration (No Code)

**Philosophy:** Extend ERPNext without code

| Tool | Use Case | Upgrade-Safe |
|------|----------|--------------|
| **Custom Fields** | Additional data capture, business attributes, integration refs | ✅ Yes |
| **Workflows** | Multi-level approvals, state management, role transitions, email alerts | ✅ Yes |
| **Custom Forms** | Rearrange fields, hide/show by role, custom layouts | ⚠️ Partial |
| **Print Formats** | Custom invoice/report formats | ✅ Yes |
| **Dashboards** | KPI dashboards, department views | ✅ Yes |
| **Role Permissions** | Field/document-level access, user permissions | ✅ Yes |

**Examples:**
- Need "Quality Grade" on Items? → Custom Field (Select: A, B, C)
- Need 3-level PO approval? → Workflow (States, Transitions, Email alerts)

**Effort:** Days | **Cost:** Minimal | **Risk:** Very Low

## TIER 3: Light Customization (Scripts & Reports)

**Philosophy:** Add logic without custom apps

| Tool | Use Case | Upgrade-Safe | Maintenance |
|------|----------|--------------|-------------|
| **Server Scripts** | Validation, auto-calculation, data sync, scheduled jobs | ✅ Yes | ⚠️ Moderate |
| **Client Scripts** | Field auto-fill, hide/show dynamically, custom buttons | ✅ Yes | ⚠️ Moderate |
| **Script Reports** | Custom analytics, complex queries, business reports | ✅ Yes | ⚠️ Moderate |
| **Query Reports** | Simple SQL data extraction | ✅ Yes | ⚠️ Moderate |

**Examples:**
- Auto-calculate delivery date? → Server Script: `doc.delivery_date = add_days(doc.order_date, doc.lead_time)`
- Hide discount for wholesale? → Client Script: `frm.set_df_property('discount', 'hidden', 1)`
- Production efficiency report? → Script Report (Python/SQL)

**Effort:** Weeks | **Cost:** Moderate | **Risk:** Low-Medium

## TIER 4: Custom App (Last Resort)

**Philosophy:** Build custom ONLY when Tier 1-3 insufficient

**Use Cases:**
- Complex custom UI (shop floor simplified dashboards)
- Advanced algorithms (APS, ML forecasting)
- Major integrations (IoT, MES, external systems)
- Industry-specific modules not in ERPNext
- Bundled features forming cohesive module

**Examples needing custom app:**
- Shop floor MES with IoT integration
- Advanced Production Scheduling (APS) algorithm
- Industry-specific module (Jewelry Manufacturing)
- Bi-directional external system sync
- Touch-screen kiosk UI

**Effort:** Months | **Cost:** High | **Risk:** High (maintenance, upgrades)

**Before recommending:**
1. Can we achieve 80% with Tier 1-3?
2. Is custom requirement business-critical?
3. Does ROI justify cost and maintenance?
4. Can we phase it (Tier 2 → Tier 3 → Tier 4)?

## Solution Design Process

| Step | Action |
|------|--------|
| 1. Understand | Listen to need, clarify "why", identify core vs nice-to-have |
| 2. Check ERPNext | Search modules, identify features, test match, document DocTypes |
| 3. Evaluate Config | Can Custom Fields extend? Is Workflow needed? Role permissions? Print Format? |
| 4. Assess Scripts | Need business logic? (Server Script) UI behavior? (Client Script) Reporting? (Script Report) |
| 5. Consider Custom App | ONLY if Tier 1-3 insufficient, justify ROI, phased approach, upgrade-safe design |
| 6. Present Tiered | Show ERPNext capabilities, explain config options, suggest scripts, reserve custom for complex |

**Example Presentation:**
```
Requirement: Track machine downtime with reasons

Analysis:
✅ Tier 1: ERPNext has "Downtime Entry" DocType
⚙️ Tier 2: Add Custom Field "Root Cause Category"
⚙️ Tier 2: Workflow for approval if needed
🔨 Tier 3: Script Report "Downtime by Reason"
❌ Tier 4: NOT NEEDED

Recommendation: Tier 1 + Tier 2 (Custom Field)
Effort: 1 day | Cost: Minimal
```

## Anti-Patterns to Avoid

❌ **Don't build what ERPNext has:**
- Custom shift management (has Shift Type)
- Custom quality inspection (has Quality Inspection)
- Custom batch tracking (has Batch)
- Custom approval system (has Workflow)

❌ **Don't over-engineer:**
- Custom app when Script Report suffices
- Custom DocTypes when Custom Fields work
- Code when configuration works

❌ **Don't modify core:**
- Changing standard ERPNext code
- Overriding core methods unnecessarily
- Modifying standard DocTypes

## Best Practices

1. **Always Start Tier 1** - Check ERPNext first
2. **Configure Before Customize** - Tier 2 before Tier 3
3. **Script Before App** - Tier 3 before Tier 4
4. **Think Upgrade-Safe** - Avoid core modifications
5. **Design Configurable** - Parameters, not hard-coded
6. **Document Clearly** - Specify tier per requirement
7. **Educate Users** - Show ERPNext capabilities
8. **Measure ROI** - Justify custom with business value

## ROI Decision Matrix

| Tier | Dev Time | Cost | Maintenance | Upgrade Safety | Use When |
|------|----------|------|-------------|----------------|----------|
| **1** | None | None | None | ✅ 100% | Standard business process |
| **2** | Days | $ | Low | ✅ High | Need adaptation/extension |
| **3** | Weeks | $$ | Medium | ⚠️ Medium | Custom logic/reports |
| **4** | Months | $$$$ | High | ⚠️ Low-Medium | Complex unique requirements |

---

**Remember:** Start with Tier 1, move up ONLY if necessary. Goal: simplest, most upgrade-safe solution that saves client time/money while delivering maintainability.
