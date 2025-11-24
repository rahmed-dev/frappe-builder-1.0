# ERPNext CRM & Lead Management

> Tier 1 reference for customer relationship management and lead tracking.

## CRM Module

### Core DocTypes

| DocType | Purpose | Key Features | Standard? |
|---------|---------|--------------|-----------|
| **Lead** | Potential customer | Source tracking, qualification, conversion to customer/opportunity | ✅ |
| **Opportunity** | Sales opportunity | Quotation generation, probability %, close date, stage tracking | ✅ |
| **Customer** | Confirmed customer | Groups, territories, credit limits, pricing rules, loyalty points | ✅ |
| **Contact** | Contact person | Email, phone, links to customer/supplier/lead, communication log | ✅ |
| **Address** | Physical/billing address | Multiple addresses per customer, preferred billing/shipping | ✅ |
| **Communication** | Email/call/meeting log | Timeline, auto-captured from email, manual entry | ✅ |
| **Campaign** | Marketing campaign | Source tracking, lead generation, ROI | ✅ |

### Business Process Flow

**Lead → Customer:**
1. Lead created (manual/web form/email)
2. Qualify lead → Set status (Open/Qualified/Lost)
3. Convert to Customer (if qualified)
4. OR Convert to Opportunity (for complex sales)

**Lead → Opportunity → Quotation → Sales Order:**
1. Lead → Convert to Opportunity
2. Opportunity → Create Quotation
3. Quotation → Convert to Sales Order
4. Sales Order → Fulfillment

**Direct Customer Creation:**
1. Create Customer directly (existing business)
2. Add contacts and addresses
3. Create Sales Orders

### Configuration

| Feature | Location | Use Case |
|---------|----------|----------|
| Lead Source | CRM → Lead Source | Website, Campaign, Reference, Cold Call |
| Lead Status | Lead DocType | Open, Replied, Opportunity, Quotation, Lost |
| Opportunity Type | CRM → Opportunity Type | Sales, Support, Maintenance |
| Sales Stage | CRM → Sales Stage | Prospecting, Qualification, Proposal, Negotiation |
| Customer Group | Selling → Customer Group | Individual, Commercial, Government |
| Territory | Selling → Territory | North, South, East, West, International |

### Customization (Tier 2)

**Custom Fields:**
- Add "Industry" to Lead (Link: Industry Type)
- Add "Company Size" to Lead (Select: 1-10, 11-50, 51-200, 200+)
- Add "Decision Timeline" to Opportunity (Select: Immediate, 1 month, 3 months, 6+ months)
- Add "Referral Source" to Customer (Link: Customer)

**Workflows:**
- Lead qualification workflow (Open → Qualified → Approved)
- Opportunity approval for high-value deals (>$50k)
- Customer credit approval workflow

**Reports:**
- Lead conversion rate by source (Script Report)
- Sales pipeline by stage
- Customer acquisition cost by campaign

## Lead Management

### Lead Lifecycle

```
New Lead → Contacted → Qualified → Converted/Lost
```

**Lead Status Values:**
- Open (new leads)
- Replied (initial contact made)
- Opportunity (qualified, created opportunity)
- Quotation (quotation sent)
- Lost (not interested/out of budget)
- Converted (became customer)

### Lead Capture

**Methods:**
1. **Web Form** - Public form on website
2. **Manual Entry** - Sales team creates
3. **Email** - Auto-create from email
4. **Import** - CSV import
5. **API** - Integration with marketing tools

**Web Form Example:**
```
Lead Form Fields:
- First Name*
- Last Name
- Email*
- Phone
- Company
- Lead Source → Campaign
```

### Lead Assignment

**Auto-Assignment Rules:**
- Territory-based (North → Sales Rep 1)
- Round-robin (distribute evenly)
- Load-balanced (assign to rep with fewest leads)

**Manual Assignment:**
- Assign to specific sales rep
- Team-based assignment

### Lead Qualification

**Qualification Criteria:**
- Budget available
- Authority to purchase
- Need identified
- Timeline defined
- BANT framework (Budget, Authority, Need, Timeline)

**Actions:**
- Create Opportunity (qualified)
- Mark as Lost (not qualified)
- Convert to Customer (direct sale)

## Opportunity Management

### Opportunity Stages

| Stage | Probability % | Actions |
|-------|---------------|---------|
| Prospecting | 10% | Initial contact |
| Qualification | 25% | Needs analysis |
| Proposal | 50% | Quotation sent |
| Negotiation | 75% | Price/terms discussion |
| Closed Won | 100% | Convert to order |
| Closed Lost | 0% | Lost deal |

### Expected Closing

```
Opportunity:
- Opportunity Amount: $50,000
- Probability: 50%
- Expected Revenue: $25,000
- Expected Closing Date: 2025-03-31
```

### Multiple Items

```
Opportunity Items:
1. Product A - Qty: 10 - Rate: $1,000
2. Product B - Qty: 5 - Rate: $2,000
Total Opportunity Value: $20,000
```

### Conversion

**Opportunity → Quotation:**
- Auto-populate items from opportunity
- Customer details filled
- Send quotation to customer

**Quotation → Sales Order:**
- Convert accepted quotation
- Mark opportunity as Won

## Customer Management

### Customer Types

| Type | Use Case |
|------|----------|
| Company | B2B customers |
| Individual | B2C customers |

### Customer Groups

**Hierarchy:**
```
All Customer Groups
├── Commercial
│   ├── Small Business
│   └── Enterprise
├── Individual
└── Government
```

**Uses:**
- Pricing rules by group
- Discounts for enterprise customers
- Reports by customer segment

### Territory Management

**Hierarchy:**
```
All Territories
├── North America
│   ├── USA
│   │   ├── East Coast
│   │   └── West Coast
│   └── Canada
└── Europe
```

**Uses:**
- Sales team assignment
- Sales targets by territory
- Regional pricing

### Credit Management

```
Customer:
- Credit Limit: $100,000
- Payment Terms: Net 30
- Bypass Credit Limit: No

System checks:
Outstanding + New Order <= Credit Limit
```

### Loyalty Program

```
Loyalty Program:
- Tier: Gold, Silver, Bronze
- Points: 1 point per $10 spent
- Redemption: 100 points = $10 discount

Customer Loyalty Points:
- Balance: 500 points
- Redeemable Value: $50
```

## Communication Tracking

### Communication Types

- **Email** - Auto-captured from email integration
- **Phone** - Manual log of calls
- **Meeting** - Meeting notes
- **Chat** - WhatsApp/chat logs
- **Visit** - Customer visit notes

### Email Integration

**Features:**
- Auto-create Communication on email
- Reply from ERPNext
- Email templates
- Email tracking

**Setup:**
1. Email Account → Configure IMAP/SMTP
2. Link to DocType (Lead, Customer, Opportunity)
3. Auto-create on receive

### Communication Timeline

**Visible on:**
- Lead
- Opportunity
- Customer
- Contact

**Shows:**
- All emails sent/received
- Phone calls logged
- Meetings scheduled
- Notes added
- Chronological timeline

## Campaign Management

### Campaign Tracking

```
Campaign:
- Campaign Name: Summer Sale 2025
- Campaign Start: 2025-06-01
- Campaign End: 2025-08-31
- Expected Revenue: $500,000

Track leads by source:
Lead → Lead Source: Campaign → Campaign: Summer Sale 2025
```

### ROI Calculation

```
Campaign Analytics:
- Leads Generated: 500
- Opportunities Created: 100
- Quotations Sent: 50
- Orders Won: 20
- Total Revenue: $100,000
- Campaign Cost: $10,000
- ROI: 900%
```

## Integration Points

### CRM → Sales

| Integration | How |
|-------------|-----|
| Lead → Opportunity | Convert qualified lead |
| Opportunity → Quotation | Create quotation from opportunity |
| Quotation → Sales Order | Convert to confirmed order |
| Customer → Sales Order | Create orders for customer |

### CRM → Support

| Integration | How |
|-------------|-----|
| Customer → Issue | Create support ticket |
| Contact → Communication | Log support calls |
| Customer → Warranty Claim | Track warranty issues |

## Automation

### Auto-Assignment

```
Assignment Rule:
- DocType: Lead
- Assign to: Sales Team role
- Priority: High
- Rule:
  - If territory = North → User A
  - If territory = South → User B
  - Else → Round Robin
```

### Email Alerts

**Triggers:**
- New lead created → Notify sales rep
- Opportunity not contacted in 7 days → Reminder
- Quotation not followed up → Alert manager
- Customer payment overdue → Reminder

### Auto-Email on Events

```
Email Alert:
- DocType: Opportunity
- Event: New
- Condition: opportunity_amount > 50000
- Recipients: sales.manager@company.com
- Subject: High-Value Opportunity Created
```

## Reports

### Standard Reports

- **Lead Details** - All leads with source, status
- **Opportunity Summary** - Pipeline by stage
- **Sales Funnel** - Lead → Opportunity → Quotation → Order
- **Customer Acquisition and Loyalty** - New vs repeat customers
- **Campaign Effectiveness** - ROI by campaign
- **Lost Opportunity** - Reasons for lost deals

### Custom Reports (Tier 3)

**Script Reports:**
- Lead conversion rate by source
- Sales cycle duration
- Win rate by sales rep
- Customer lifetime value
- Territory-wise performance

## Solution Design Checklist

**Before custom development:**

- [ ] Does ERPNext CRM handle lead management? ✅ YES
- [ ] Can Leads convert to Customers/Opportunities? ✅ YES
- [ ] Is web form available for lead capture? ✅ YES
- [ ] Can opportunity track sales stages? ✅ YES
- [ ] Is email integration available? ✅ YES
- [ ] Can communications be logged? ✅ YES
- [ ] Need custom lead fields? ⚙️ Custom Fields (Tier 2)
- [ ] Need lead approval workflow? ⚙️ Workflow (Tier 2)
- [ ] Need custom assignment rules? ⚙️ Assignment Rule (Tier 2)
- [ ] Need custom CRM analytics? 🔨 Script Report (Tier 3)

## Anti-Patterns

❌ **Don't:**
- Build custom lead management (use Lead DocType)
- Create custom opportunity tracking (use Opportunity)
- Build custom contact management (use Contact)
- Create custom email logging (use Communication)
- Build custom campaign tracking (use Campaign)
- Create custom assignment logic (use Assignment Rule)

✅ **Do:**
- Use built-in Lead → Opportunity → Quotation flow
- Configure Email Account for auto-logging
- Use Assignment Rules for auto-distribution
- Add Custom Fields for business-specific data
- Use Workflow for approval processes
- Use Script Reports for custom analytics
- Configure Web Forms for lead capture
