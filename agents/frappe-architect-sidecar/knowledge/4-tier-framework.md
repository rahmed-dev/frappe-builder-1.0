# 4-Tier Framework - Quick Reference Guide

## The Four Tiers

```
Tier 1: STANDARD ERPNext
↓ (Can't do it with standard? ↓)
Tier 2: CONFIGURATION (Custom Fields, Workflows, etc.)
↓ (Need business logic? ↓)
Tier 3: SCRIPTING (Server Scripts, Client Scripts, Reports)
↓ (Still insufficient? ↓)
Tier 4: CUSTOM APP (Custom DocTypes, modules, complex code)
```

---

## Tier 1: Standard ERPNext

**What it is:** Use ERPNext out-of-the-box features with ZERO customization

**When to use:**
- ✅ ERPNext already has this feature
- ✅ Standard feature meets 100% of need
- ✅ No adaptation required

**Examples:**
- BOM management → Use ERPNext BOM DocType
- Shift management → Use Shift Type + Shift Assignment
- Quality inspection → Use Quality Inspection module
- Batch tracking → Enable "Has Batch No" on Item
- Approval workflows → Use ERPNext Workflow DocType

**Characteristics:**
- Development Time: None
- Cost: $0
- Maintenance: None
- Upgrade Safety: ✅ 100% safe
- Risk: None

**Decision:** Always check Tier 1 FIRST for ANY requirement!

---

## Tier 2: Configuration

**What it is:** Extend ERPNext without writing code

**When to use:**
- ✅ ERPNext has base feature, needs adaptation
- ✅ Need additional data fields
- ✅ Need approval processes
- ✅ Need custom document layouts
- ✅ Need role-based access control

**Available Tools:**

### 1. Custom Fields
Add fields to existing DocTypes without code

**Use for:**
- Additional data capture (Employee Badge Number, Item Shelf Location)
- Business-specific attributes (Quality Grade, Customer Segment)
- Integration references (External System ID)

**Example:**
```
Need: Track "Quality Grade" on Items
Solution: Add Custom Field "quality_grade" (Select: A\nB\nC) to Item DocType
```

### 2. Workflows
Define approval processes and state transitions

**Use for:**
- Multi-level approvals (Leave, Purchase, Expense)
- State management (Draft → Pending → Approved → Rejected)
- Role-based transitions
- Email notifications

**Example:**
```
Need: 3-level approval for Purchase Orders > $10k
Solution: Workflow with states and transitions based on role and PO amount
```

### 3. Customize Form / Property Setters
Modify form layout and behavior

**Use for:**
- Hide/show fields based on roles
- Rearrange field order
- Change field labels
- Set default values
- Make fields read-only conditionally

### 4. Print Formats
Custom document layouts

**Use for:**
- Custom invoice designs
- Company-specific report formats
- Multi-language documents

### 5. Permissions
Control access without code

**Use for:**
- Field-level permissions
- Document-level access
- User-specific permissions
- Role-based restrictions

**Characteristics:**
- Development Time: Days
- Cost: $ (minimal configuration time)
- Maintenance: Low
- Upgrade Safety: ✅ High (95%+)
- Risk: Very Low

---

## Tier 3: Scripting

**What it is:** Add business logic and custom reports without creating custom apps

**When to use:**
- ✅ Tier 1 + Tier 2 insufficient
- ✅ Need custom business logic
- ✅ Need custom calculations
- ✅ Need custom reports/analytics
- ✅ Need UI behavior customization
- ✅ Simple integrations

**Available Tools:**

### 1. Server Scripts (Python)
Business logic without app development

**Use for:**
- Validation rules ("Quantity must be multiple of 10")
- Auto-calculations ("Auto-fill Item Rate based on Customer")
- Data sync/integration ("Push data to external API")
- Scheduled jobs ("Daily stock reconciliation")

**Example:**
```
Need: Auto-calculate delivery date based on lead time
Solution: Server Script on Sales Order (before_save)
  doc.delivery_date = add_days(doc.order_date, doc.lead_time)
```

### 2. Client Scripts (JavaScript)
UI behavior without code changes

**Use for:**
- Field auto-fill
- Hide/show fields dynamically
- Custom buttons
- Field validations
- Form calculations

**Example:**
```
Need: Hide "Discount" field for wholesale customers
Solution: Client Script
  if (frm.doc.customer_type == 'Wholesale')
    frm.set_df_property('discount', 'hidden', 1);
```

### 3. Script Reports (Python/SQL)
Custom reports and analytics

**Use for:**
- Custom business analytics
- Complex queries
- Business-specific reports
- KPI dashboards

**Example:**
```
Need: Production Efficiency by Workstation report
Solution: Script Report with Python/SQL query joining Work Order, Job Card, Workstation
```

### 4. Query Reports (SQL)
Simple SQL-based reports

**Use for:**
- Simple data extraction
- Standard SQL queries
- Quick analytics

**Characteristics:**
- Development Time: Weeks
- Cost: $$ (moderate)
- Maintenance: Medium (requires Python/JavaScript knowledge)
- Upgrade Safety: ⚠️ Medium (test after upgrades)
- Risk: Low-Medium

---

## Tier 4: Custom App

**What it is:** Full custom development with custom DocTypes and modules

**When to use:**
- ✅ Tier 1-3 truly insufficient
- ✅ Complex business processes not in ERPNext
- ✅ Major system integrations
- ✅ Industry-specific modules
- ✅ Advanced algorithms (APS, ML forecasting)
- ✅ Complex custom UI required

**What you can build:**
- Custom DocTypes (new database tables/forms)
- Custom modules
- Complex business logic
- Advanced integrations (IoT, MES, external systems)
- Custom dashboards and pages
- Industry-specific features

**Examples:**
```
Truly need custom app when:
- ✅ Shop floor MES with IoT integration
- ✅ Advanced Production Scheduling (APS) algorithm
- ✅ Industry-specific module (Jewelry Manufacturing, Pharmaceuticals)
- ✅ Bi-directional integration with legacy ERP
- ✅ Simplified touch-screen kiosk for warehouse
```

**Characteristics:**
- Development Time: Months
- Cost: $$$$ (high)
- Maintenance: High (ongoing development team)
- Upgrade Safety: ⚠️ Low-Medium (depends on implementation)
- Risk: High (maintenance burden, upgrade complexity, bugs)

**Before recommending Tier 4, ask:**
1. ❓ Can we achieve 80% with Tier 1-3?
2. ❓ Is this requirement truly business-critical?
3. ❓ Does the ROI justify the cost and maintenance?
4. ❓ Can we phase it (Tier 2 → Tier 3 → Tier 4 over time)?

---

## Decision Framework

### Step 1: Check Standard (Tier 1)
```
Question: Does ERPNext have this feature?
→ YES: Use Tier 1, document which module/DocType
→ NO: Go to Step 2
```

### Step 2: Evaluate Configuration (Tier 2)
```
Questions:
- Can Custom Fields extend the DocType?
- Can Workflow handle the approval process?
- Can Property Setters achieve this?
- Can Print Format solve this?

→ YES to any: Use Tier 2, document configuration
→ NO to all: Go to Step 3
```

### Step 3: Assess Scripting (Tier 3)
```
Questions:
- Is this business logic? → Server Script
- Is this UI behavior? → Client Script
- Is this a report? → Script Report
- Is this a scheduled job? → Server Script with cron

→ YES to any: Use Tier 3, document script
→ NO to all: Go to Step 4
```

### Step 4: Consider Custom App (Tier 4)
```
Questions:
- Is custom DocType required?
- Is Tier 1-3 truly insufficient?
- Does ROI justify the cost?
- Can we phase this (start Tier 2/3, upgrade to Tier 4 later)?

→ YES and justified: Use Tier 4, design custom app
→ NO: Re-evaluate requirements with Business Analyst
```

---

## Tier Comparison Matrix

| Factor | Tier 1 | Tier 2 | Tier 3 | Tier 4 |
|--------|--------|--------|--------|--------|
| **Development Time** | None | Days | Weeks | Months |
| **Cost** | $0 | $ | $$ | $$$$ |
| **Maintenance** | None | Low | Medium | High |
| **Upgrade Safety** | ✅ 100% | ✅ 95% | ⚠️ 80% | ⚠️ 60% |
| **Requires Code** | ❌ No | ❌ No | ✅ Yes | ✅ Yes |
| **Requires Developer** | ❌ No | ❌ No | ✅ Yes | ✅ Yes |
| **Risk** | None | Very Low | Low-Med | High |
| **Flexibility** | Low | Medium | High | Very High |

---

## Anti-Patterns (What NOT to Do)

### ❌ Don't Build What ERPNext Has
```
Wrong: Building custom shift management
Right: Use ERPNext Shift Type + Shift Assignment (Tier 1)

Wrong: Building custom approval system
Right: Use ERPNext Workflow (Tier 2)

Wrong: Building custom batch tracking
Right: Enable "Has Batch No" on Item (Tier 1)
```

### ❌ Don't Skip Tiers
```
Wrong: "Client wants custom workflow" → Jump to Tier 4 custom app
Right: Check Tier 2 Workflow first (usually sufficient)

Wrong: "Need custom calculation" → Build custom DocType
Right: Try Tier 3 Server Script first (often sufficient)
```

### ❌ Don't Over-Engineer
```
Wrong: Custom app for simple field addition
Right: Tier 2 Custom Fields

Wrong: Custom UI when Frappe components work
Right: Use frappe.ui.Dialog, frappe.ui.DataTable (Tier 2/3)
```

### ❌ Don't Modify Core
```
Wrong: Changing standard ERPNext code directly
Right: Use hooks, overrides, or custom fields (Tier 2/3)

Wrong: Modifying standard DocType structure
Right: Add Custom Fields (Tier 2)
```

---

## Best Practices

1. **Always Start with Tier 1**
   - Search ERPNext documentation
   - Check what modules exist
   - Validate standard features meet the need

2. **Configure Before Customize**
   - Try Tier 2 before Tier 3
   - Try Tier 3 before Tier 4
   - Simpler = Better

3. **Think Upgrade-Safe**
   - Avoid core modifications
   - Use standard extension points
   - Test after ERPNext upgrades

4. **Design Configurable**
   - Use parameters, not hardcoded values
   - Settings DocType for configuration
   - Easy for users to adjust without developer

5. **Document the Tier**
   - Clearly state which tier for each requirement
   - Justify why that tier is needed
   - Explain why lower tiers insufficient

6. **Measure ROI**
   - Custom development (Tier 4) must justify cost
   - Compare: Tier 4 cost vs business value
   - Consider: Can we phase? (Tier 2 now, Tier 4 later if proven valuable)

---

## Quick Decision Flowchart

```
START: New Requirement

↓

Does ERPNext have this?
  YES → Tier 1 (Standard) → DONE ✅
  NO ↓

Can Custom Fields + Workflow achieve this?
  YES → Tier 2 (Configure) → DONE ✅
  NO ↓

Is this logic or reporting?
  YES → Tier 3 (Scripts) → DONE ✅
  NO ↓

Is Tier 4 truly justified?
  YES → Tier 4 (Custom App) → Design carefully ⚠️
  NO → Re-evaluate requirements with BA 🔄
```

---

## Remember

**The Golden Rule:**
> "Always climb the tiers. Start with Tier 1, move up ONLY when necessary. Your goal is the simplest, most upgrade-safe solution that meets the business need."

**When in doubt:**
> "Can we achieve 80% with a lower tier? Then use the lower tier and deliver value faster!"

---

**End of 4-Tier Framework Guide**
