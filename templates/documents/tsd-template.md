# Technical Specification Document
**Project:** {{project_name}}
**App:** {{current_app}}
**Date:** {{date}}
**BRD Reference:** [Link to BRD]
**Architect:** {{user_name}}

## Solution Overview
[2-3 sentences describing the technical approach]

## 4-Tier Architecture

| Tier | Component | Effort | Details |
|------|-----------|--------|---------|
| **Standard** | [List OOTB features] | 0 dev time | Configuration only |
| **Configure** | [Custom Fields/Workflows] | [X] hours | [Brief description] |
| **Scripts** | [Server/Client Scripts] | [X] hours | [Brief description] |
| **Custom** | [New DocTypes/APIs] | [X] days | [Brief description] |

## DocType Design

### New DocTypes

#### [DocType Name]
**Purpose:** [1 sentence]

**Fields:**
| Field | Type | Required | Notes |
|-------|------|----------|-------|
| [field_name] | [Link/Data/Int] | Yes/No | [Purpose] |

**Links:**
- → [Related DocType 1]
- → [Related DocType 2]

**Permissions:**
| Role | Read | Write | Create | Delete | Submit |
|------|------|-------|--------|--------|--------|
| [Role] | ✓ | ✓ | ✓ | ✗ | ✓ |

**Workflow:**
- Draft → Pending → Approved → Completed

---

### DocType Customizations

#### [Existing DocType Name]
**Custom Fields:**
- `custom_field_name` (Data) - [Purpose]
- `custom_amount` (Currency) - [Purpose]

**Custom Scripts:**
- Server Script: [Trigger] - [What it does]
- Client Script: [Event] - [What it does]

## Database Schema

### New Tables
```sql
-- tabNew DocType
CREATE TABLE `tabNew DocType` (
  `name` varchar(140) PRIMARY KEY,
  `field1` varchar(140),
  `field2` decimal(18,6),
  INDEX idx_field1 (field1)
);
```

### ERD
```
[Sales Order] 1---* [Custom Line Item]
      ↓
[Customer]
```

## APIs & Scripts

### Server Scripts

#### Script: [Script Name]
**Trigger:** [validate/on_submit/on_cancel]
**DocType:** [DocType Name]
**Logic:**
```python
# Calculate discount based on customer group
if doc.customer:
    customer_group = frappe.db.get_value("Customer", doc.customer, "customer_group")
    if customer_group == "Wholesale":
        doc.discount = doc.total * 0.1
```

### Client Scripts

#### Script: [Script Name]
**Event:** [refresh/before_save]
**Logic:**
```javascript
// Auto-populate item rate from price list
frappe.ui.form.on("Sales Order Item", "item_code", function(frm, cdt, cdn) {
    let row = locals[cdt][cdn];
    frappe.call({
        method: "erpnext.stock.get_item_details.get_item_details",
        args: {item_code: row.item_code},
        callback: (r) => {
            frappe.model.set_value(cdt, cdn, "rate", r.message.price_list_rate);
        }
    });
});
```

### REST APIs

#### API: [Endpoint Name]
**Method:** GET/POST
**Endpoint:** `/api/method/app.module.method_name`
**Auth:** Required
**Parameters:**
- `param1` (string) - [Description]
- `param2` (int) - [Description]

**Response:**
```json
{
    "message": {
        "status": "success",
        "data": []
    }
}
```

## UI Components

### Forms
- [DocType]: Custom fields added, sections reordered

### Reports
| Report Name | Type | Filters | Output |
|-------------|------|---------|--------|
| [Report] | Script Report | Date range, Customer | Excel/PDF |

### Dashboards
- [Dashboard Name]: [Widgets displayed]

### Dialogs
- [Dialog Name]: [When shown, what it collects]

## Workflows

### [Workflow Name]
**DocType:** [DocType Name]
**States:** Draft → Pending Approval → Approved → Rejected
**Transitions:**
- Draft → Pending: Submit button
- Pending → Approved: Manager approval
- Pending → Rejected: Manager rejection

**Roles:**
| State | Role | Actions |
|-------|------|---------|
| Draft | Sales User | Create, Edit, Submit |
| Pending | Sales Manager | Approve, Reject |

## Integration Points

### External Systems
- **System:** [Name]
- **Method:** REST API / FTP / Direct DB
- **Frequency:** Real-time / Hourly / Daily
- **Data Flow:** Inbound / Outbound / Both

## Security

### Role Permissions
| Role | Purpose | Access |
|------|---------|--------|
| [Role Name] | [Description] | [DocTypes + permission level] |

### Data Access Rules
- User Permissions: [Field-level restrictions]
- Row-Level Security: [Custom permission queries]

### Validation Rules
- [Field]: [Validation logic]
- [Field]: [Business rule enforcement]

## Performance Considerations

### Indexes
- `tabDocType`.`field_name` - For frequent filtering
- `tabDocType`.`(field1, field2)` - Composite index

### Caching
- [What data]: Cache for [duration]
- [Expensive calc]: Cache result

### Background Jobs
- [Operation]: Run in background queue (long)
- [Bulk process]: Enqueue for async processing

## Testing Strategy

### Unit Tests
- Test: [Method name] - [What it validates]
- Test: [Validation rule] - [Edge cases]

### Integration Tests
- Test: [Workflow] - [End-to-end flow]
- Test: [API] - [Request/response validation]

### Performance Tests
- Load test: [Scenario] - [Expected threshold]

## Deployment Plan

### Database Changes
```bash
# Migrations needed
bench --site {{site}} migrate
```

### Build Steps
```bash
bench --site {{site}} build
bench --site {{site}} clear-cache
```

### Rollback Plan
[How to revert if something fails]

## Assumptions & Risks

### Assumptions
- [Technical assumption 1]
- [Technical assumption 2]

### Risks
- **Risk:** [Description]
  **Mitigation:** [How we'll handle it]

## Approval
- **Technical Lead:** [Name] - [Date]
- **System Manager:** [Name] - [Date]
