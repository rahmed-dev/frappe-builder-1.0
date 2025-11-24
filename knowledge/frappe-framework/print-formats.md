# Custom Print Formats

> Creating custom print templates for invoices, reports, and documents.

## What are Print Formats?

Print formats control how DocTypes are rendered for printing/PDF. Used for:
- Invoices
- Quotations
- Purchase Orders
- Delivery Notes
- Custom certificates
- Reports

## Creating Print Formats

### Method 1: Print Format Builder (No Code)

1. DocType → Print Format → New
2. Name: "Custom Invoice"
3. DocType: Sales Invoice
4. Use Print Format Builder
5. Drag/drop fields
6. Preview and save

**Best for:** Simple layouts, basic customization

### Method 2: Custom HTML (Jinja)

1. DocType → Print Format → New
2. Name: "Custom Invoice HTML"
3. DocType: Sales Invoice
4. Format Type: Jinja
5. Custom Format: 1
6. HTML: Write template

**Best for:** Complex layouts, full control

## Jinja Template Basics

### Document Data Access

```jinja
{# Access document fields #}
{{ doc.name }}
{{ doc.customer_name }}
{{ doc.grand_total }}
{{ doc.posting_date }}

{# Format currency #}
{{ frappe.utils.fmt_money(doc.grand_total) }}

{# Format date #}
{{ frappe.utils.formatdate(doc.posting_date) }}

{# Conditional rendering #}
{% if doc.customer_name %}
    <p>Customer: {{ doc.customer_name }}</p>
{% endif %}
```

### Child Table Iteration

```jinja
<table>
    <thead>
        <tr>
            <th>Item</th>
            <th>Qty</th>
            <th>Rate</th>
            <th>Amount</th>
        </tr>
    </thead>
    <tbody>
        {% for item in doc.items %}
        <tr>
            <td>{{ item.item_name }}</td>
            <td>{{ item.qty }}</td>
            <td>{{ frappe.utils.fmt_money(item.rate) }}</td>
            <td>{{ frappe.utils.fmt_money(item.amount) }}</td>
        </tr>
        {% endfor %}
    </tbody>
</table>
```

### Loop Controls

```jinja
{% for item in doc.items %}
    {# Loop index (1-based) #}
    {{ loop.index }}. {{ item.item_name }}

    {# First/last checks #}
    {% if loop.first %}First item{% endif %}
    {% if loop.last %}Last item{% endif %}

    {# Even/odd #}
    <tr class="{% if loop.index % 2 == 0 %}even{% else %}odd{% endif %}">
{% endfor %}
```

## Complete Invoice Template

```jinja
<div class="invoice-container">
    <!-- Header -->
    <div class="header">
        <div class="company-info">
            <h1>{{ frappe.get_doc('Company', doc.company).company_name }}</h1>
            <p>{{ frappe.get_doc('Address', doc.company_address).address_line1 }}</p>
            <p>{{ frappe.get_doc('Address', doc.company_address).city }}</p>
        </div>
        <div class="invoice-info">
            <h2>INVOICE</h2>
            <p>{{ doc.name }}</p>
            <p>Date: {{ frappe.utils.formatdate(doc.posting_date) }}</p>
        </div>
    </div>

    <!-- Customer Info -->
    <div class="customer-info">
        <h3>Bill To:</h3>
        <p><strong>{{ doc.customer_name }}</strong></p>
        {% if doc.customer_address %}
            <p>{{ frappe.get_doc('Address', doc.customer_address).address_line1 }}</p>
            <p>{{ frappe.get_doc('Address', doc.customer_address).city }}</p>
        {% endif %}
    </div>

    <!-- Items Table -->
    <table class="items-table">
        <thead>
            <tr>
                <th>#</th>
                <th>Item</th>
                <th>Description</th>
                <th class="right">Qty</th>
                <th class="right">Rate</th>
                <th class="right">Amount</th>
            </tr>
        </thead>
        <tbody>
            {% for item in doc.items %}
            <tr>
                <td>{{ loop.index }}</td>
                <td>{{ item.item_code }}</td>
                <td>{{ item.description or '' }}</td>
                <td class="right">{{ item.qty }}</td>
                <td class="right">{{ frappe.utils.fmt_money(item.rate) }}</td>
                <td class="right">{{ frappe.utils.fmt_money(item.amount) }}</td>
            </tr>
            {% endfor %}
        </tbody>
    </table>

    <!-- Totals -->
    <div class="totals">
        <table>
            <tr>
                <td>Subtotal:</td>
                <td class="right">{{ frappe.utils.fmt_money(doc.total) }}</td>
            </tr>
            {% for tax in doc.taxes %}
            <tr>
                <td>{{ tax.description }}:</td>
                <td class="right">{{ frappe.utils.fmt_money(tax.tax_amount) }}</td>
            </tr>
            {% endfor %}
            <tr class="grand-total">
                <td><strong>Grand Total:</strong></td>
                <td class="right"><strong>{{ frappe.utils.fmt_money(doc.grand_total) }}</strong></td>
            </tr>
        </table>
    </div>

    <!-- Footer -->
    <div class="footer">
        <p>{{ doc.terms or '' }}</p>
        <p class="signature">_____________________<br>Authorized Signature</p>
    </div>
</div>

<style>
    .invoice-container {
        font-family: Arial, sans-serif;
        padding: 20px;
        max-width: 800px;
        margin: 0 auto;
    }

    .header {
        display: flex;
        justify-content: space-between;
        margin-bottom: 30px;
        border-bottom: 2px solid #333;
        padding-bottom: 10px;
    }

    .customer-info {
        margin-bottom: 30px;
    }

    .items-table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
    }

    .items-table th,
    .items-table td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: left;
    }

    .items-table th {
        background-color: #f2f2f2;
        font-weight: bold;
    }

    .right {
        text-align: right;
    }

    .totals {
        float: right;
        width: 300px;
    }

    .totals table {
        width: 100%;
    }

    .grand-total {
        border-top: 2px solid #333;
        font-size: 1.2em;
    }

    .footer {
        clear: both;
        margin-top: 50px;
        padding-top: 20px;
        border-top: 1px solid #ddd;
    }

    .signature {
        text-align: right;
        margin-top: 50px;
    }
</style>
```

## Accessing Related Documents

```jinja
{# Get linked document #}
{% set customer = frappe.get_doc('Customer', doc.customer) %}
{{ customer.customer_name }}
{{ customer.email }}

{# Get address #}
{% if doc.customer_address %}
    {% set address = frappe.get_doc('Address', doc.customer_address) %}
    <p>{{ address.address_line1 }}</p>
    <p>{{ address.city }}, {{ address.state }} {{ address.pincode }}</p>
{% endif %}

{# Get company logo #}
{% set company = frappe.get_doc('Company', doc.company) %}
{% if company.company_logo %}
    <img src="{{ company.company_logo }}" style="max-width: 200px;">
{% endif %}
```

## Utility Functions

### Formatting

```jinja
{# Format money #}
{{ frappe.utils.fmt_money(doc.grand_total) }}

{# Format date #}
{{ frappe.utils.formatdate(doc.posting_date) }}
{{ frappe.utils.formatdate(doc.posting_date, 'dd-MM-yyyy') }}

{# Format number #}
{{ "%.2f"|format(doc.qty) }}

{# Format time #}
{{ frappe.utils.format_time(doc.creation) }}
```

### Translation

```jinja
{# Translate string #}
{{ _("Total Amount") }}
{{ _("Invoice Date") }}

{# With placeholder #}
{{ _("Invoice {0}").format(doc.name) }}
```

### Calculations

```jinja
{# Calculate total #}
{% set total_qty = 0 %}
{% for item in doc.items %}
    {% set total_qty = total_qty + item.qty %}
{% endfor %}
<p>Total Quantity: {{ total_qty }}</p>

{# Sum using filter #}
<p>Total Qty: {{ doc.items|sum(attribute='qty') }}</p>
```

## Conditionals

```jinja
{# If-else #}
{% if doc.grand_total > 10000 %}
    <p class="high-value">High Value Order</p>
{% elif doc.grand_total > 5000 %}
    <p class="medium-value">Medium Value Order</p>
{% else %}
    <p class="low-value">Standard Order</p>
{% endif %}

{# Check if field has value #}
{% if doc.remarks %}
    <div class="remarks">
        <h4>Remarks:</h4>
        <p>{{ doc.remarks }}</p>
    </div>
{% endif %}

{# Check list length #}
{% if doc.items|length > 10 %}
    <p>{{ doc.items|length }} items (Large order)</p>
{% endif %}
```

## Page Breaks

```html
<div class="page-break">
    <!-- Content before page break -->
</div>

<div class="page-break">
    <!-- Content after page break -->
</div>

<style>
    @media print {
        .page-break {
            page-break-after: always;
        }
    }
</style>
```

## Letterhead

### Using Standard Letterhead

```jinja
{# Letterhead automatically included if set in Print Settings #}
{# Or specify in Print Format: #}

{% if letterhead %}
    <div class="letterhead">
        {{ letterhead }}
    </div>
{% endif %}
```

### Custom Header/Footer

```html
<div class="print-header">
    <img src="/files/company-logo.png">
    <h2>{{ frappe.get_doc('Company', doc.company).company_name }}</h2>
</div>

<!-- Document content -->

<div class="print-footer">
    <p>Page <span class="page-number"></span> of <span class="total-pages"></span></p>
    <p>{{ frappe.get_doc('Company', doc.company).company_name }} | www.company.com</p>
</div>

<style>
    @media print {
        .print-header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
        }

        .print-footer {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            border-top: 1px solid #ddd;
            padding-top: 10px;
        }
    }
</style>
```

## QR Code / Barcode

```jinja
{# QR Code #}
<img src="/api/method/frappe.utils.print_format.get_qr_code?data={{ doc.name }}"
     style="width: 100px; height: 100px;">

{# Barcode #}
<img src="/api/method/frappe.utils.print_format.get_barcode?data={{ doc.name }}&barcode_type=Code128"
     style="width: 200px; height: 50px;">
```

## Multi-Language Support

```jinja
{# Check language #}
{% if frappe.lang == 'ar' %}
    <div dir="rtl">
        <!-- Arabic content -->
    </div>
{% else %}
    <div dir="ltr">
        <!-- English content -->
    </div>
{% endif %}

{# Translated labels #}
<p>{{ _("Invoice") }}</p>
<p>{{ _("Customer") }}: {{ doc.customer_name }}</p>
```

## Testing Print Formats

### Preview

1. Open document
2. Menu → Print → Select Print Format
3. Preview

### PDF

1. Open document
2. Menu → Print → Download PDF
3. Check PDF output

### Debug

```jinja
{# Debug document data #}
<pre>{{ doc|pprint }}</pre>

{# Check field value #}
{{ doc.get("field_name") or "Not set" }}
```

## Best Practices

- ✅ Test with real data (multiple scenarios)
- ✅ Handle missing fields gracefully (`or ''`)
- ✅ Use responsive CSS for different paper sizes
- ✅ Test print preview and PDF export
- ✅ Include page breaks for multi-page docs
- ✅ Use company letterhead when available
- ✅ Format currency and dates consistently
- ✅ Keep styles inline or in `<style>` tag
- ✅ Test with different languages if multi-lingual
- ✅ Include QR/barcode for tracking
- ❌ Don't use external CSS files (not printed)
- ❌ Don't use JavaScript (not supported)
- ❌ Don't assume fields always have values

## Key Rules

- ✅ Use Jinja templates for full control
- ✅ Access document fields with `{{ doc.fieldname }}`
- ✅ Format currency with `frappe.utils.fmt_money()`
- ✅ Iterate child tables with `{% for %}`
- ✅ Get linked docs with `frappe.get_doc()`
- ✅ Handle missing values with `or ''`
- ✅ Use `@media print` for print-specific styles
- ✅ Test with real documents before deployment
- ❌ Don't use external resources (CSS/JS files)
- ❌ Don't assume all fields are populated
