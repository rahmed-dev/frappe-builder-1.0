# ERPNext Manufacturing Module

Production planning through execution - integrated with Stock, Buying, Selling, Quality modules.

## Core DocTypes

| DocType | Purpose | Key Features | Standard? |
|---------|---------|--------------|-----------|
| **Bill of Materials (BOM)** | Recipe for manufacturing | Single/multi-level, templates, costing, material planning | ✅ |
| **Work Order** | Production order | Make-to-order/stock, material tracking, backflush | ✅ |
| **Job Card** | Operation time/progress tracking | Shop floor tracking, workstation utilization, quality triggers | ✅ |
| **Production Plan** | Master production schedule | MRP, batch planning, auto work order creation | ✅ |
| **Workstation** | Production resources | Capacity planning, costing, scheduling | ✅ |
| **Operation** | Production steps | Routing, standard operations, costing | ✅ |
| **Downtime Entry** | Production downtime tracking | Efficiency analysis, maintenance planning | ✅ |

### BOM (Bill of Materials)
Fields: Item (finished good), Quantity, Raw Materials table, Operations table, Is Active/Default
Use Cases: Single/multi-level BOMs, variants, costing, material planning

### Work Order
Fields: Production Item, BOM No, Qty, Start/Delivery Date, Source/Target Warehouse, Required Items/Operations
Status: Draft → Not Started → In Process → Completed → Stopped
Use Cases: Make-to-order/stock, consumption tracking, progress tracking, backflush

### Job Card
Fields: Work Order, Operation, Workstation, Time Logs, Completed Qty, Employee
Use Cases: Shop floor tracking, operation progress, productivity, quality trigger

### Production Plan
Fields: Company, From/To Date, Get Sales Orders, Material Requests, Production Items
Use Cases: MRP, batch planning, material forecasting, auto work order creation

### Workstation
Fields: Name, Production Capacity (units/hour), Hour Rate, Working Hours, Holiday List
Use Cases: Capacity planning, costing, scheduling, resource allocation

## Business Processes

### Make-to-Order Flow
1. Sales Order → Production Plan → Work Orders → Material Request → Purchase Orders
2. Materials received → Work Order started → Job Cards completed → Finished goods transferred
3. Delivery Note against Sales Order

**Standard ERPNext flow**

### Make-to-Stock Flow
1. Forecast/Reorder trigger → Production Plan → Work Orders
2. Materials issued → Production → Stock updated

**Standard ERPNext flow**

### Subcontracting Flow
1. BOM with "Is Sub Contracted" items → PO for subcontracting
2. Stock Entry transfers materials → Subcontractor processes
3. Purchase Receipt receives goods → Materials backflushed

**✅ ERPNext native subcontracting**

## Configuration (No Code)

### Manufacturing Settings
| Setting | Options |
|---------|---------|
| Capacity Planning | Enable/disable |
| Default Warehouses | Source, Target, WIP |
| Material Transfer | Auto vs Manual |
| Backflush Method | Based on BOM vs Material Transfer |
| Over Production % | Percentage allowance |
| Update BOM Cost | Auto yes/no |

## Integration Points

| Module | Integration |
|--------|-------------|
| **Stock** | Material Request, Stock Entries, Warehouse mgmt, Batch/Serial tracking |
| **Buying** | Purchase Request from Production Plan, Subcontracting POs |
| **Selling** | Sales Order → Production Plan, Delivery Note after production |
| **Quality** | QI for raw materials/finished goods, Job Card → QI trigger |
| **Projects** | Project-based manufacturing, Work Order → Project link |

## Customization Tiers

### Tier 1: Standard (Use As-Is) ✅
BOM management, Work Order, Job Card, Production Planning, Material consumption, Subcontracting

### Tier 2: Configuration ⚙️
Custom Fields: BOM Revision, Engineering Drawing, Work Order Priority/Shift, Job Card Defects
Workflows: Production Plan approvals

### Tier 3: Scripts/Reports 🔨
Custom reports: OEE, Shop Floor Control Board
Client scripts: Auto-calculation
Server scripts: Validation logic

### Tier 4: Custom App 🔨 (Rare)
Advanced scheduling (APS), Custom shop floor UI, IoT/Machine integration, Advanced MES

## Standard Reports

1. Production Plan Summary - plan status
2. Work Order Summary - progress tracking
3. Job Card Summary - operation-wise
4. BOM Stock Report - material availability
5. Production Analytics - efficiency metrics
6. Downtime Analysis - by reason
7. Cost of Poor Quality - quality costs

## Solution Design Checklist

Ask these questions:
- [ ] Make-to-Order or Make-to-Stock?
- [ ] Multi-level BOMs needed?
- [ ] Operation routing required? (impacts job cards)
- [ ] Subcontracting involved?
- [ ] Batch/Serial tracking for materials/finished goods?
- [ ] Quality inspections at which stages?
- [ ] Capacity planning needed?
- [ ] External system integration? (MES, IoT)
- [ ] Custom reporting requirements?
- [ ] Approval workflows needed?

## Best Practices

1. **Check ERPNext first** - 90% of manufacturing is standard
2. **Configure before customize** - Use Custom Fields and Workflows
3. **Understand flow** - Sales Order → Production Plan → Work Order → Job Card
4. **Integration matters** - Manufacturing touches Stock, Buying, Selling, Quality
5. **Capacity planning** - Set up Workstations and Operations properly
6. **Accurate costing** - BOMs must be accurate
7. **Use native subcontracting** - Don't build custom
8. **Standard reports first** - Use Query Reports for custom needs

## Upgrade Safety

**Safe:** Standard features, Custom Fields, Workflows, Server Scripts

**Avoid:**
- ❌ Modifying core manufacturing DocTypes
- ❌ Changing standard workflows
- ❌ Overriding core methods

---

**Remember:** ERPNext Manufacturing is comprehensive. Configure first, customize second, build custom last.
