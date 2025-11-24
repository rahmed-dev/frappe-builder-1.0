# ERPNext Stock & Inventory Module

Inventory management: warehouses, batch/serial tracking, valuation, movements.

## Core DocTypes

| Category | DocTypes | Purpose | Standard? |
|----------|----------|---------|-----------|
| **Item Master** | Item, Item Group, Item Variant, Item Price | Product master, categories, variants, pricing | ✅ |
| **Warehouse** | Warehouse, Warehouse Type | Storage locations, hierarchy, types | ✅ |
| **Transactions** | Stock Entry, Stock Reconciliation, Material Request, Stock Reservation Entry | Movements, adjustments, requests, reservations | ✅ |
| **Tracking** | Batch, Serial No | Lot/batch tracking, individual item tracking | ✅ |
| **Valuation** | Stock Ledger Entry, Landed Cost Voucher | Transaction log, cost allocation | ✅ |

### Item Master
Fields: Item Code/Name, Item Group, Stock UOM, Maintain Stock, Has Batch/Serial, Valuation Method (FIFO/Moving Avg), Default Warehouse, Reorder Level

### Stock Entry
Purpose: Material Issue, Receipt, Transfer, Manufacture, Repack
Auto-created: Work Order, Purchase Receipt, Delivery Note

### Stock Reconciliation
Physical stock adjustment, valuation adjustment

### Batch & Serial
**Batch:** Lot tracking, Manufacturing/Expiry dates, batch-wise inventory
**Serial:** Individual tracking, warranty/AMC tracking

## Business Processes

### 1. Stock Receipt (Purchase)
Purchase Receipt → Stock Ledger Entry auto-created → Valuation updated (FIFO/Moving Avg) → Warehouse balance updated → GL entry (Stock Dr, Stock Received Cr)

### 2. Stock Issue (Sales/Manufacturing)
Delivery Note or Stock Entry (Issue) → Stock Ledger → Warehouse reduced → Valuation calc

### 3. Stock Transfer
Stock Entry (Transfer) → From Warehouse reduced → To Warehouse increased → In-transit warehouse optional

### 4. Physical Stock Count
Stock Reconciliation → Enter actual quantities → System compares → Difference auto-adjusted → Valuation adjusted

## Configuration (No Code)

### Stock Settings
| Setting | Options |
|---------|---------|
| Item Naming By | Item Code/Naming Series |
| Default Valuation Method | FIFO/Moving Average |
| Allow Negative Stock | Yes/No |
| Auto Insert Price List Rate | Yes/No |
| Auto Set Serial Nos (FIFO) | Yes/No |
| Sample Retention Warehouse | Warehouse for Quality |

### Reorder Settings
Auto Material Request, Reorder level per warehouse, Lead time consideration

## Customization Tiers

### Tier 1: Standard ✅
Multi-warehouse, Batch tracking, Serial tracking, FIFO/Moving Avg, Stock transfers, Reorder alerts, Stock reconciliation

### Tier 2: Configuration ⚙️
Custom Item fields (dimensions, specs), Approval workflows for Stock Entry, Custom warehouse hierarchy, Item-wise reorder levels

### Tier 3: Scripts/Reports 🔨
Barcode scanning integration, Custom valuation logic (rare), Stock aging reports, Custom movement reports

### Tier 4: Custom App 🔨 (Rare)
WMS with bin locations, Advanced barcode/RFID, Pick/Pack/Ship workflow

## Integration Points

| Module | Integration |
|--------|-------------|
| Buying | Purchase Receipt → Stock Entry |
| Selling | Delivery Note → Stock Entry |
| Manufacturing | Work Order → Stock Entry (material consumption) |
| Quality | Quality Inspection → Stock acceptance/rejection |
| Accounting | Stock Ledger → General Ledger (valuation) |

## Standard Reports

1. Stock Balance - current levels
2. Stock Ledger - transaction-wise movements
3. Stock Ageing - inventory age analysis
4. Item-wise Stock History - movement history
5. Batch-wise Balance History - batch tracking
6. Serial No History - serial tracking
7. Stock Analytics - ABC, fast/slow moving

## Solution Design Checklist

- [ ] Batch tracking required? (Pharma, Food)
- [ ] Serial number tracking? (Electronics, Assets)
- [ ] Valuation method preference?
- [ ] Multiple warehouses? Hierarchy?
- [ ] Reorder level management?
- [ ] Consignment stock?
- [ ] Subcontracting inventory?
- [ ] Landed cost allocation?
- [ ] Stock reservation for orders?
- [ ] Barcode/RFID integration?

## Best Practices

1. **Valuation Method** - FIFO for expiry, Moving Avg for commodities
2. **Batch/Serial** - Enable only if needed (adds complexity)
3. **Warehouse Structure** - Keep simple, use hierarchy for grouping
4. **Negative Stock** - Avoid in production (use Material Request)
5. **Stock Reconciliation** - Regular physical counts
6. **Reorder Levels** - Set per warehouse, not globally
7. **Landed Costs** - Allocate freight/customs for accurate costing

---

**Remember:** ERPNext Stock is comprehensive. Standard features cover 90% of inventory. Batch/Serial are native - don't build custom tracking.
