# ERPNext Assets & Maintenance

> Asset lifecycle management and maintenance tracking.

## Assets Module

### Core DocTypes

| DocType | Purpose | Key Features | Standard? |
|---------|---------|--------------|-----------|
| **Asset** | Fixed asset tracking | Depreciation, location, custodian, value tracking | ✅ |
| **Asset Category** | Asset classification | Depreciation method, accounts, useful life | ✅ |
| **Asset Depreciation Schedule** | Depreciation tracking | Auto-generated schedule, journal entries | ✅ |
| **Asset Movement** | Location/custodian transfer | Track asset movements, history | ✅ |
| **Asset Maintenance** | Maintenance scheduling | Preventive maintenance, task assignment | ✅ |
| **Asset Maintenance Log** | Maintenance records | Work done, parts used, downtime | ✅ |
| **Asset Repair** | Repair tracking | Repair costs, capitalization | ✅ |
| **Asset Value Adjustment** | Revaluation | Impairment, appreciation | ✅ |

### Asset Lifecycle

```
Purchase → Capitalize → Depreciate → Maintain → Dispose/Sell
```

**Stages:**
1. **Purchase** - Buy asset via Purchase Invoice
2. **Capitalize** - Create Asset record
3. **Depreciate** - Auto-calculate depreciation
4. **Maintain** - Schedule maintenance
5. **Transfer** - Move location/custodian
6. **Dispose** - Sell or scrap

## Asset Creation

### From Purchase Invoice

```
1. Create Purchase Invoice
2. Item: Fixed Asset item (Is Fixed Asset = 1)
3. Asset: Auto-create or link existing
4. Submit invoice
5. Asset Status: Draft → Submit to capitalize
```

### Manual Asset Creation

```python
asset = frappe.get_doc({
    'doctype': 'Asset',
    'asset_name': 'Laptop - Dell XPS',
    'asset_category': 'Computer Equipment',
    'item_code': 'LAPTOP-DELL-XPS',
    'company': 'My Company',
    'purchase_date': '2025-01-01',
    'gross_purchase_amount': 1500,
    'location': 'Head Office',
    'custodian': 'EMP-001',
    'available_for_use_date': '2025-01-01',
    'calculate_depreciation': 1,
    'frequency_of_depreciation': 12,  # Months
    'total_number_of_depreciations': 36  # 3 years
})
asset.insert()
asset.submit()
```

## Asset Category

### Configuration

```
Asset Category: Computer Equipment
- Enable Capital Work in Progress: No
- Depreciation Method: Straight Line
- Frequency: 12 months
- Total Depreciations: 36 (3 years)
- Rate of Depreciation: 33.33%

Accounts:
- Fixed Asset Account: Fixed Assets - Computers
- Accumulated Depreciation Account: Accumulated Depreciation - Computers
- Depreciation Expense Account: Depreciation Expense
```

### Depreciation Methods

| Method | Calculation | Use Case |
|--------|-------------|----------|
| **Straight Line** | Equal amount each period | Most common, simple |
| **Written Down Value** | % of remaining value | Faster depreciation early |
| **Manual** | User-defined schedule | Custom scenarios |

## Depreciation

### Auto-Calculation

```
Gross Purchase Amount: $1,500
Salvage Value: $0
Useful Life: 3 years (36 months)
Frequency: 12 months

Annual Depreciation: ($1,500 - $0) / 3 = $500
```

### Depreciation Schedule

```
Year 1: Opening: $1,500 | Depreciation: $500 | Closing: $1,000
Year 2: Opening: $1,000 | Depreciation: $500 | Closing: $500
Year 3: Opening: $500   | Depreciation: $500 | Closing: $0
```

### Journal Entry (Auto-Created)

```
Debit:  Depreciation Expense - Computers: $500
Credit: Accumulated Depreciation - Computers: $500
```

## Asset Movement

### Transfer Location

```python
movement = frappe.get_doc({
    'doctype': 'Asset Movement',
    'asset': 'ASSET-0001',
    'purpose': 'Transfer',
    'from_location': 'Head Office',
    'to_location': 'Branch Office',
    'transaction_date': frappe.utils.nowdate(),
    'reference_doctype': 'Employee Transfer',
    'reference_name': 'EMP-TRANS-001'
})
movement.insert()
movement.submit()
```

### Transfer Custodian

```python
movement = frappe.get_doc({
    'doctype': 'Asset Movement',
    'asset': 'ASSET-0001',
    'purpose': 'Transfer',
    'from_employee': 'EMP-001',
    'to_employee': 'EMP-002',
    'transaction_date': frappe.utils.nowdate()
})
movement.insert()
movement.submit()
```

## Maintenance Management

### Asset Maintenance Setup

```python
maintenance = frappe.get_doc({
    'doctype': 'Asset Maintenance',
    'asset_name': 'ASSET-0001',
    'company': 'My Company',
    'maintenance_tasks': [
        {
            'maintenance_task': 'Oil Change',
            'maintenance_type': 'Preventive Maintenance',
            'periodicity': 'Monthly',
            'start_date': '2025-01-01',
            'end_date': '2025-12-31',
            'assign_to': 'maintenance@company.com'
        },
        {
            'maintenance_task': 'Inspection',
            'maintenance_type': 'Calibration',
            'periodicity': 'Quarterly',
            'start_date': '2025-01-01'
        }
    ]
})
maintenance.insert()
maintenance.submit()
```

### Maintenance Log

```python
log = frappe.get_doc({
    'doctype': 'Asset Maintenance Log',
    'asset_maintenance': 'AST-MAINT-0001',
    'task': 'Oil Change',
    'maintenance_status': 'Completed',
    'completion_date': frappe.utils.nowdate(),
    'actions_performed': 'Changed engine oil, replaced filter',
    'downtime': 2,  # Hours
    'maintenance_team': [
        {'team_member': 'EMP-001'}
    ]
})
log.insert()
log.submit()
```

### Preventive Maintenance

**Periodicity Options:**
- Daily
- Weekly
- Monthly
- Quarterly
- Half-yearly
- Yearly
- 2 Yearly
- 3 Yearly

**Auto-Assignment:**
- Assigns to specified user
- Email notifications
- Due date tracking

## Asset Repair

### Record Repair

```python
repair = frappe.get_doc({
    'doctype': 'Asset Repair',
    'asset': 'ASSET-0001',
    'failure_date': '2025-06-01',
    'description': 'Hard drive failure',
    'repair_cost': 200,
    'increase_in_asset_life': 0,  # Or months to extend
    'capitalize_repair_cost': 0,  # Don't add to asset value
    'repair_status': 'Completed',
    'completion_date': '2025-06-02'
})
repair.insert()
repair.submit()
```

### Capitalize Repair

```python
# Major repair that extends life
repair = frappe.get_doc({
    'doctype': 'Asset Repair',
    'asset': 'ASSET-0001',
    'description': 'Major overhaul',
    'repair_cost': 5000,
    'increase_in_asset_life': 12,  # Extend by 1 year
    'capitalize_repair_cost': 1,   # Add to asset value
})
repair.insert()
repair.submit()
# Increases asset value, recalculates depreciation
```

## Asset Disposal

### Sale

```python
# Create Sales Invoice
invoice = frappe.get_doc({
    'doctype': 'Sales Invoice',
    'customer': 'CUST-001',
    'items': [
        {
            'item_code': 'LAPTOP-DELL-XPS',
            'qty': 1,
            'rate': 500  # Sale price
        }
    ]
})
invoice.insert()
invoice.submit()

# Link to asset
asset = frappe.get_doc('Asset', 'ASSET-0001')
asset.disposal_date = frappe.utils.nowdate()
asset.status = 'Sold'
asset.save()

# Journal entry auto-created:
# Debit: Customer - 500
# Debit: Accumulated Depreciation - 1000
# Credit: Fixed Assets - 1500
# If sold above book value, profit to income
```

### Scrap

```python
asset = frappe.get_doc('Asset', 'ASSET-0001')
asset.disposal_date = frappe.utils.nowdate()
asset.status = 'Scrapped'
asset.save()

# Write off journal entry
# Debit: Accumulated Depreciation
# Debit: Loss on Asset Disposal (if any remaining value)
# Credit: Fixed Asset
```

## Asset Value Adjustment

### Revaluation

```python
adjustment = frappe.get_doc({
    'doctype': 'Asset Value Adjustment',
    'asset': 'ASSET-0001',
    'company': 'My Company',
    'date': frappe.utils.nowdate(),
    'current_asset_value': 1000,
    'new_asset_value': 1200,  # Appreciated
    'difference_amount': 200,
    'cost_center': 'Main - MC'
})
adjustment.insert()
adjustment.submit()

# Journal Entry:
# Debit: Fixed Asset - 200
# Credit: Gain on Revaluation - 200
```

## Integration Points

### Assets ↔ Accounting

| Integration | How |
|-------------|-----|
| Purchase → Asset | Auto-create from Purchase Invoice |
| Depreciation → GL | Auto journal entries |
| Disposal → GL | Gain/loss on disposal |
| Repair → GL | Expense or capitalize |

### Assets ↔ HR

| Integration | How |
|-------------|-----|
| Employee → Custodian | Assign assets to employees |
| Transfer → Movement | Track with employee transfer |
| Exit → Return | Return assets on resignation |

### Assets ↔ Maintenance

| Integration | How |
|-------------|-----|
| Asset → Maintenance | Schedule preventive maintenance |
| Maintenance → Downtime | Track asset downtime |
| Repair → Cost | Track repair costs |

## Reports

### Standard Reports

- **Fixed Asset Register** - All assets with values
- **Asset Depreciation Ledger** - Depreciation history
- **Asset Maintenance** - Upcoming maintenance
- **Asset Movement** - Transfer history

### Custom Reports (Tier 3)

**Script Reports:**
- Asset utilization by location
- Maintenance cost by asset
- Depreciation projection
- Asset lifecycle analysis

## Automation

### Scheduled Depreciation

```python
# hooks.py
scheduler_events = {
    "monthly": [
        "erpnext.assets.doctype.asset.depreciation.make_depreciation_entry"
    ]
}
```

### Maintenance Reminders

```
Email Alert:
- DocType: Asset Maintenance Task
- Event: Days Before
- Days Before: 7
- Condition: task_status = 'Pending'
- Recipients: assign_to field
```

## Configuration

### Asset Settings

```
Setup → Assets Settings:
- Asset Depreciation Cost Center: Main - MC
- Disposal Account: Gain/Loss on Asset Disposal
- Depreciation Expense Account: Depreciation Expense
- Capital Work in Progress Account: CWIP
```

### Naming Series

```
Asset: ASSET-.YYYY.-.#####
Asset Maintenance: AST-MAINT-.YYYY.-.####
Asset Movement: AST-MOV-.YYYY.-.####
```

## Solution Design Checklist

**Before custom development:**

- [ ] Does ERPNext handle asset tracking? ✅ YES
- [ ] Can depreciation be auto-calculated? ✅ YES
- [ ] Is preventive maintenance supported? ✅ YES
- [ ] Can asset movements be tracked? ✅ YES
- [ ] Is disposal/sale handled? ✅ YES
- [ ] Need custom asset fields? ⚙️ Custom Fields (Tier 2)
- [ ] Need asset approval workflow? ⚙️ Workflow (Tier 2)
- [ ] Need custom maintenance schedules? ⚙️ Script (Tier 3)
- [ ] Need asset analytics? 🔨 Script Report (Tier 3)

## Anti-Patterns

❌ **Don't:**
- Build custom asset tracking (use Asset DocType)
- Create custom depreciation (use built-in calculation)
- Build custom maintenance system (use Asset Maintenance)
- Create manual depreciation entries (use auto-calculation)
- Track movements manually (use Asset Movement)

✅ **Do:**
- Use Asset Category for depreciation rules
- Enable auto-depreciation
- Schedule preventive maintenance
- Track all movements
- Add Custom Fields for business data
- Use Script Reports for custom analytics
- Link assets to employees as custodians

## Key Rules

- ✅ Create Asset Category before assets
- ✅ Enable depreciation for depreciable assets
- ✅ Schedule preventive maintenance
- ✅ Track all asset movements
- ✅ Capitalize only major repairs
- ✅ Use proper disposal process
- ✅ Review depreciation schedule before submit
- ✅ Assign custodian for accountability
- ❌ Don't manually create depreciation entries
- ❌ Don't skip asset movements
- ❌ Don't modify submitted depreciation
