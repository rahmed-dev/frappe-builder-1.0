# ERPNext Quality Module

Quality management: inspections, goals, procedures, reviews, feedback.

## Core DocTypes

| Category | DocTypes | Purpose | Standard? |
|----------|----------|---------|-----------|
| **Inspection** | Quality Inspection, Quality Inspection Template, Quality Inspection Parameter | Inspection records, parameters, acceptance criteria | ✅ |
| **QMS** | Quality Goal, Quality Procedure, Quality Review, Quality Feedback, Quality Action | Objectives/KPIs, SOPs, reviews, feedback, corrective/preventive actions | ✅ |

### Quality Inspection
Fields: Reference DocType (Purchase Receipt, Stock Entry, Delivery Note, Job Card), Item Code, Sample Size, Inspected By, Inspection Type (Incoming/Outgoing/In Process), Status (Accepted/Rejected), Readings table

### Quality Inspection Template
Reading parameters with acceptance criteria, linked to Item

### Quality Inspection Parameter
Master list: Weight, Dimension, Color, etc.

## Business Processes

### 1. Incoming QI (Purchase)
Purchase Receipt created (not submitted) → QI created → Inspector fills readings → Accepted/Rejected → If Accepted: PR submitted, If Rejected: Return created

**Config:** Inspection Required Before Purchase (Item master)

### 2. In-Process QI (Manufacturing)
Job Card created → QI created → Inspector fills readings → Status determines continuation → If Rejected: Rework or Scrap

**Config:** Inspection Required Before Delivery (Item master)

### 3. Outgoing QI (Sales)
Delivery Note created (not submitted) → QI created → Inspector fills readings → Accepted/Rejected → If Accepted: DN submitted, If Rejected: Delivery stopped

**Config:** Inspection Required Before Delivery (Item master)

### 4. Quality Goal Monitoring
Quality Goal defined (e.g., Defect Rate < 2%) → Periodic measurement → Quality Review → Quality Actions for deviations

## Configuration (No Code)

### Quality Settings
- Default Inspection Type
- Link QI to Work Order
- Inspection Required checkboxes (Item level)

### Item Configuration
- Inspection Required Before Purchase
- Inspection Required Before Delivery
- Quality Inspection Template (link)

## Customization Tiers

### Tier 1: Standard ✅
QI for Purchase/Sales/Manufacturing, Inspection templates, Acceptance/Rejection, Quality goals/reviews

### Tier 2: Configuration ⚙️
Custom inspection parameters, Approval workflow for QI, Custom fields for quality data, Auto-create QI on Purchase Receipt

### Tier 3: Scripts/Reports 🔨
Statistical Process Control (SPC) reports, Auto-calculation of results, Integration with measuring devices, Custom dashboards

### Tier 4: Custom App 🔨 (Rare)
Advanced SPC analysis, IoT integration for auto-inspection, Image-based QI (AI/ML), Full QMS with ISO compliance

## Integration Points

| Module | Integration |
|--------|-------------|
| Stock | Quality Inspection → Stock Entry (acceptance/rejection) |
| Buying | Purchase Receipt → Quality Inspection |
| Selling | Delivery Note → Quality Inspection |
| Manufacturing | Job Card → Quality Inspection |
| Projects | Quality Action → Project Task |

## Standard Reports

1. Quality Inspection Summary - status overview
2. Item Quality Inspection Summary - item-wise metrics
3. Supplier-wise Quality Inspection - supplier quality tracking

## Solution Design Checklist

- [ ] Incoming inspection required?
- [ ] In-process inspection required?
- [ ] Outgoing inspection required?
- [ ] Inspection parameters (dimensional, visual, functional)?
- [ ] Sampling method (100%, statistical)?
- [ ] Acceptance criteria definition?
- [ ] Rejection handling (scrap, rework, return)?
- [ ] Quality documentation (SOPs, Work Instructions)?
- [ ] Supplier quality monitoring?
- [ ] Quality metrics and KPIs?

## Best Practices

1. **Templates** - Create QI Templates for each item category
2. **Mandatory Inspection** - Enable at Item level, not globally
3. **Parameters** - Use QI Parameter master for consistency
4. **Acceptance Criteria** - Set min/max values in template
5. **Sample Size** - Define appropriate sample size in template
6. **Workflow** - Add approval workflow if multiple stakeholders
7. **Integration** - Link to Purchase/Sales/Manufacturing for automated flow
8. **Goals** - Set measurable Quality Goals with periodic reviews

---

**Remember:** ERPNext Quality covers standard inspection. Templates/parameters are configurable. Add custom SPC/AI only if standard insufficient.
