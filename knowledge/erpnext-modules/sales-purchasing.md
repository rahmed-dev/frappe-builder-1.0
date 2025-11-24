# ERPNext Sales & Purchasing Modules

> Tier 1 reference for sales and purchasing workflows and features.

## Sales Module

### Core DocTypes

| DocType | Purpose | Key Features | Standard? |
|---------|---------|--------------|-----------|
| **Customer** | Customer master | Groups, territories, credit limits, pricing rules | ✅ |
| **Quotation** | Price quote | Optional, conversion to SO, validity period | ✅ |
| **Sales Order** | Confirmed order | Stock reservation, production plan trigger, partial delivery | ✅ |
| **Delivery Note** | Goods dispatch | Stock update, batch/serial tracking, packing slip | ✅ |
| **Sales Invoice** | Customer billing | Standalone or from DN, payment integration, taxes | ✅ |
| **Sales Return** | Return goods | Return against invoice, stock reversal, credit note | ✅ |

### Business Process Flow

**Standard Flow:**
1. Quotation (optional) → Convert to Sales Order
2. Sales Order → Reserve stock
3. Delivery Note → Dispatch goods, update stock
4. Sales Invoice → Bill customer
5. Payment Entry → Record payment

**Direct Invoice:**
1. Sales Invoice (without SO/DN)
2. Update stock directly
3. Payment Entry

**Advance Payment:**
1. Sales Order → Create advance Payment Entry
2. Delivery Note → Dispatch
3. Sales Invoice → Allocate advance payment

### Configuration

| Feature | Location | Use Case |
|---------|----------|----------|
| Selling Settings | Setup → Selling Settings | SO required, DN required, freeze settings |
| Price List | Stock → Price List | Standard Selling, Wholesale, Retail |
| Terms & Conditions | Selling → Terms & Conditions | Standard T&C templates |
| Sales Taxes Template | Accounts → Sales Taxes | VAT, GST configurations |
| Pricing Rule | Stock → Pricing Rule | Discounts, promotional pricing |

### Customization (Tier 2)

**Custom Fields:**
- Add "Delivery Instructions" to Delivery Note (Text)
- Add "Customer PO Number" to Sales Order (Data)
- Add "Salesperson Commission %" to Sales Order (Percent)

**Workflows:**
- Sales Order approval for amounts > $10,000
- Quotation approval workflow
- Credit limit approval

**Reports:**
- Sales analytics by territory (Script Report)
- Customer-wise profitability
- Pending deliveries

## Purchasing Module

### Core DocTypes

| DocType | Purpose | Key Features | Standard? |
|---------|---------|--------------|-----------|
| **Supplier** | Supplier master | Groups, payment terms, on-hold status | ✅ |
| **Request for Quotation** | RFQ to suppliers | Email to suppliers, quotation comparison | ✅ |
| **Supplier Quotation** | Supplier quote | Rate comparison, conversion to PO | ✅ |
| **Purchase Order** | Purchase order | Auto from Material Request, partial receipt, budget validation | ✅ |
| **Purchase Receipt** | Goods receipt | Stock update, quality inspection, batch/serial | ✅ |
| **Purchase Invoice** | Supplier bill | Standalone or from PR, payment integration, taxes | ✅ |
| **Purchase Return** | Return to supplier | Return against invoice, stock reversal, debit note | ✅ |

### Business Process Flow

**Standard Flow:**
1. Material Request → Create Purchase Order
2. Purchase Order → Confirm with supplier
3. Purchase Receipt → Receive goods, update stock
4. Quality Inspection (if applicable)
5. Purchase Invoice → Book expense
6. Payment Entry → Pay supplier

**Direct Receipt:**
1. Purchase Receipt (without PO)
2. Update stock directly
3. Purchase Invoice

**Services:**
1. Purchase Order (Is Service Item = Yes)
2. Purchase Invoice (no stock update)
3. Payment Entry

### Configuration

| Feature | Location | Use Case |
|---------|----------|----------|
| Buying Settings | Setup → Buying Settings | PO required, PR required, over-billing settings |
| Supplier Groups | Buying → Supplier Group | Local, International, Services |
| Purchase Taxes Template | Accounts → Purchase Taxes | VAT, customs duty |
| Budget | Accounts → Budget | Cost center budgets, variance alerts |

### Customization (Tier 2)

**Custom Fields:**
- Add "Supplier Part Number" to Purchase Order Item (Data)
- Add "Inspection Required" to Purchase Receipt (Check)
- Add "Delivery Lead Time (days)" to Supplier (Int)

**Workflows:**
- Purchase Order approval (multi-level based on amount)
- Material Request approval
- Supplier quotation comparison approval

**Reports:**
- Purchase analytics by supplier
- Budget variance by cost center
- Pending receipts

## Integration Points

### Sales ↔ Stock

| Integration | How |
|-------------|-----|
| SO → Stock Reservation | Reserve stock on SO submit |
| DN → Stock Ledger | Reduce stock on DN submit |
| Sales Invoice → Stock | Update stock if DN not created |
| Sales Return → Stock | Increase stock on return |

### Purchasing ↔ Stock

| Integration | How |
|-------------|-----|
| PO → Material Request | Auto-create from MR |
| PR → Stock Ledger | Increase stock on PR submit |
| PR → Quality Inspection | Trigger QI if configured |
| Purchase Return → Stock | Reduce stock on return |

### Sales/Purchasing ↔ Accounting

| Integration | How |
|-------------|-----|
| Sales Invoice → GL | Debit Customer, Credit Revenue |
| Purchase Invoice → GL | Credit Supplier, Debit Expense |
| Payment Entry → GL | Update receivables/payables |
| Delivery Note → GL | Update stock value (perpetual) |

## Pricing & Discounts

### Price Lists

```
# Standard pricing
Item Master → Item Price
- Price List: Standard Selling
- Rate: 100

# Customer-specific pricing
Customer → Default Price List: Wholesale
Item Price:
- Price List: Wholesale
- Rate: 85
```

### Pricing Rules

**Quantity-based:**
- Buy 10+ units → 10% discount
- Buy 50+ units → 20% discount

**Customer-based:**
- VIP customers → 15% discount
- Bulk buyers → Free shipping

**Product-based:**
- Buy Product A → Get Product B free
- Buy from Category X → 5% discount

### Configure Pricing Rule

```
Pricing Rule:
- Apply On: Item Code
- Item Code: ITEM-001
- Min Qty: 10
- Discount %: 10
- Valid From: 2025-01-01
- Valid To: 2025-12-31
```

## Payment Terms

### Standard Terms

| Template | Terms |
|----------|-------|
| Net 30 | Payment due in 30 days |
| 50% Advance | 50% on order, 50% on delivery |
| 30-60-10 | 30% advance, 60% on delivery, 10% after 30 days |

### Configure Payment Terms

```
Payment Terms Template: 50% Advance
Payment Terms:
1. Invoice Portion: 50%
   Due Date Based On: Day(s) after invoice date
   Credit Days: 0
2. Invoice Portion: 50%
   Due Date Based On: Day(s) after invoice date
   Credit Days: 30
```

## Credit Management

### Credit Limit

```
Customer:
- Credit Limit: 100,000
- Bypass Credit Limit Check: No

# System validates:
- Outstanding + New Order <= Credit Limit
```

### On Hold

```
Customer:
- On Hold: Yes
- Hold Type: All/Invoices/Payments

# Prevents:
- Creating new transactions
```

## Taxes & Charges

### Sales Taxes

```
Sales Taxes and Charges Template: India GST
Taxes:
1. CGST - 9%
   Account Head: CGST - Tax
   Rate: 9
2. SGST - 9%
   Account Head: SGST - Tax
   Rate: 9
```

### Purchase Taxes

```
Purchase Taxes and Charges Template: Import Duty
Taxes:
1. Basic Customs Duty - 10%
   Account Head: Customs Duty - Tax
   Rate: 10
2. IGST - 18%
   Account Head: IGST - Tax
   Rate: 18
```

## Automation

### Auto-Creation Rules

**Material Request → Purchase Order:**
- Configure: Auto Create Purchase Order
- Supplier selection (default/manual)
- Grouping by supplier

**Sales Order → Delivery Note:**
- Configure: Auto Create Delivery Note
- Partial delivery allowed
- Pick list integration

### Auto-Repeat

**Recurring Sales:**
- Monthly subscriptions
- Annual maintenance contracts
- Quarterly supply orders

## Solution Design Checklist

**Before custom development:**

- [ ] Does ERPNext Sales module handle order lifecycle? ✅ YES
- [ ] Can Quotation → SO → DN → Invoice workflow work? ✅ YES
- [ ] Is advance payment needed? ✅ Payment Entry (advance)
- [ ] Need custom pricing? ⚙️ Price List + Pricing Rules (Tier 2)
- [ ] Need multi-level approvals? ⚙️ Workflow (Tier 2)
- [ ] Need custom fields? ⚙️ Custom Fields (Tier 2)
- [ ] Need sales analytics? 🔨 Script Report (Tier 3)
- [ ] Does ERPNext Purchasing handle procurement? ✅ YES
- [ ] Can MR → PO → PR → Invoice workflow work? ✅ YES
- [ ] Need supplier comparison? ✅ RFQ + Supplier Quotation
- [ ] Need budget tracking? ✅ Budget DocType
- [ ] Need custom procurement reports? 🔨 Script Report (Tier 3)

## Anti-Patterns

❌ **Don't:**
- Build custom order management (use Sales Order)
- Create custom quotation system (use Quotation)
- Build custom pricing logic (use Price List + Pricing Rules)
- Create custom payment tracking (use Payment Entry)
- Build custom tax calculation (use Tax Templates)
- Create custom procurement (use Purchase Order)
- Build custom approval system (use Workflow)

✅ **Do:**
- Use built-in Sales/Purchase modules
- Configure Price Lists for custom pricing
- Use Workflow for approvals
- Add Custom Fields for business data
- Use Payment Terms for flexible payment schedules
- Use Pricing Rules for discounts/promotions
- Use Script Reports for custom analytics
