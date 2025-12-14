# Creating Print Formats for Reports Using UI

## Complete Guide for ERPNext/Frappe Framework

---

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Step-by-Step Guide](#step-by-step-guide)
4. [Template Syntax](#template-syntax)
5. [Available Variables](#available-variables)
6. [Best Practices](#best-practices)
7. [Common Examples](#common-examples)
8. [Troubleshooting](#troubleshooting)

---

## Introduction

The **Print Format for Reports** feature allows you to create custom, professional-looking print layouts for your ERPNext reports directly from the user interface. Previously, this required creating HTML files in the codebase, but now you can do it all through the UI!

### What You Can Do:
- ✅ Create custom print layouts for any report
- ✅ Add company branding and styling
- ✅ Format data tables professionally
- ✅ Calculate totals and subtotals
- ✅ Add headers, footers, and logos
- ✅ Export to PDF with custom formatting

---

## Prerequisites

### Required Knowledge:
- Basic HTML (for structure)
- Basic CSS (for styling)
- Basic JavaScript (for logic and calculation
s)

### System Requirements:
- ERPNext/Frappe Framework with Print Format for Reports feature enabled
- Access to Print Format DocType
- A report you want to customize

---

## Step-by-Step Guide

### Step 1: Navigate to Print Format

1. Go to **Search Bar** (Ctrl+K or ⌘+K)
2. Type **"Print Format"**
3. Click **"+ New"** to create a new print format

---

### Step 2: Configure Basic Settings

Fill in the following fields:

| Field | Value | Description |
|-------|-------|-------------|
| **Print Format Name** | e.g., "Sales Report - Custom" | A descriptive name for your format |
| **For** | Select **"Report"** | Choose Report (not DocType) |
| **Report** | Select your report | Choose from the dropdown (e.g., "Consolidated Salary") |
| **Print Format Type** | **JS** | Must be "JS" for reports |
| **Enabled** | ✓ Checked | Make it active |

---

### Step 3: Write Your HTML Template

In the **HTML** field, write your template using the special syntax.

#### Simple Example:

```html
<div style="padding: 20px;">
    <h2 style="text-align: center;">My Report Title</h2>
    
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Column 1</th>
                <th>Column 2</th>
                <th>Amount</th>
            </tr>
        </thead>
        <tbody>
            {% for (var i = 0; i < data.length; i++) { %}
                <tr>
                    <td>{%= data[i].column_1 %}</td>
                    <td>{%= data[i].column_2 %}</td>
                    <td>{%= data[i].amount %}</td>
                </tr>
            {% } %}
        </tbody>
    </table>
</div>
```

---

### Step 4: Add Custom CSS (Optional)

In the **Custom CSS** field, add your styling:

```css
.table {
    width: 100%;
    border-collapse: collapse;
}

.table th {
    background-color: #6b7280;
    color: white;
    padding: 10px;
}

.table td {
    padding: 8px;
    border: 1px solid #ddd;
}
```

---

### Step 5: Save and Test

1. Click **Save**
2. Go to your report
3. Click the **Print** button
4. Select your new print format from the dropdown
5. Preview and adjust as needed

---

## Template Syntax

### Important: Use `{% %}` NOT `<% %>`

Report print formats use a **special JavaScript templating syntax** that looks similar to Jinja:

### 1. Printing Values

```html
{%= variable_name %}
{%= data[i].field_name %}
{%= filters.employee_name %}
```

### 2. Code Blocks (Loops, Conditionals)

```html
{% for (var i = 0; i < data.length; i++) { %}
    <!-- Your HTML here -->
{% } %}

{% if (condition) { %}
    <!-- HTML when true -->
{% } else { %}
    <!-- HTML when false -->
{% } %}
```

### 3. Variables and Calculations

```html
{% 
var total = 0;
for (var i = 0; i < data.length; i++) {
    total += parseFloat(data[i].amount) || 0;
}
%}

<p>Total: {%= total.toFixed(2) %}</p>
```

---

## Available Variables

### 1. `data` - Array of Report Rows

This is the main data from your report. Each row is an object with **slugified field names**.

**Column Name → Field Name Conversion:**
- "Posting Date" → `posting_date`
- "Item Name" → `item_name`
- "Grand Total" → `grand_total`
- "Employee Name" → `employee_name`

**Example:**
```html
{% for (var i = 0; i < data.length; i++) { %}
    <tr>
        <td>{%= data[i].posting_date %}</td>
        <td>{%= data[i].item_name %}</td>
        <td>{%= data[i].grand_total %}</td>
    </tr>
{% } %}
```

---

### 2. `filters` - Report Filters

Access the filters applied to the report:

```html
{% if (filters.from_date && filters.to_date) { %}
    <p>Period: {%= filters.from_date %} to {%= filters.to_date %}</p>
{% } %}

{% if (filters.employee) { %}
    <p>Employee: {%= filters.employee %}</p>
{% } %}
```

---

### 3. `title` - Report Title

```html
<h1>{%= title %}</h1>
```

---

### 4. Global Functions

You can use built-in JavaScript functions:

```html
<!-- Format numbers -->
{%= parseFloat(data[i].amount).toLocaleString("en-US", {minimumFractionDigits: 2}) %}

<!-- Format dates -->
{%= new Date().toLocaleDateString() %}

<!-- Conditional formatting -->
{%= data[i].status === "Completed" ? "✓" : "✗" %}
```

---

## Best Practices

### 1. Finding Field Names (Debug Method)

If you don't know the exact field names, use this debug template:

```html
<div>
    <h3>Debug - Field Names</h3>
    <table class="table table-bordered">
        <tr>
            <th>Field Name</th>
            <th>Value</th>
        </tr>
        {% if (data.length > 0) { %}
            {% for (var key in data[0]) { %}
                <tr>
                    <td><strong>{%= key %}</strong></td>
                    <td>{%= data[0][key] %}</td>
                </tr>
            {% } %}
        {% } %}
    </table>
</div>
```

Save this, generate the print, and you'll see all field names!

---

### 2. Always Use Double Quotes

❌ **Wrong:**
```html
{%= data[i].name || '' %}
```

✅ **Correct:**
```html
{%= data[i].name || "" %}
```

Single quotes (`'`) can break the template engine.

---

### 3. Number Formatting

Use `toLocaleString()` for proper comma separators:

```html
<!-- Without formatting -->
{%= data[i].amount %}  
<!-- Output: 1234567.89 -->

<!-- With formatting -->
{%= parseFloat(data[i].amount).toLocaleString("en-US", {minimumFractionDigits: 2, maximumFractionDigits: 2}) %}  
<!-- Output: 1,234,567.89 -->
```

---

### 4. Handle Empty Values

Always handle null/undefined values:

```html
{%= data[i].field_name || "" %}
{%= data[i].amount || 0 %}
```

---

### 5. Use Bootstrap Classes

Bootstrap is available by default:

```html
<table class="table table-bordered table-striped">
<div class="row">
    <div class="col-xs-6">Left Column</div>
    <div class="col-xs-6">Right Column</div>
</div>
```

---

## Common Examples

### Example 1: Simple Report with Totals

```html
<div style="padding: 20px;">
    <h2 style="text-align: center;">Sales Report</h2>
    
    <table class="table table-bordered">
        <thead>
            <tr style="background-color: #6b7280; color: white;">
                <th>Item</th>
                <th>Quantity</th>
                <th class="text-right">Amount</th>
            </tr>
        </thead>
        <tbody>
            {% 
            var total = 0;
            for (var i = 0; i < data.length; i++) { 
                total += parseFloat(data[i].amount) || 0;
            %}
                <tr>
                    <td>{%= data[i].item_name %}</td>
                    <td>{%= data[i].qty %}</td>
                    <td class="text-right">{%= parseFloat(data[i].amount).toFixed(2) %}</td>
                </tr>
            {% } %}
            <tr style="font-weight: bold; background-color: #f0f0f0;">
                <td colspan="2" class="text-right">Total:</td>
                <td class="text-right">{%= total.toFixed(2) %}</td>
            </tr>
        </tbody>
    </table>
</div>
```

---

### Example 2: Report with Filters Display

```html
<div style="padding: 20px;">
    <h2 style="text-align: center;">Inventory Report</h2>
    
    <!-- Display Filters -->
    <div style="margin-bottom: 20px; padding: 10px; background-color: #f5f5f5;">
        <strong>Filters Applied:</strong><br>
        {% if (filters.from_date && filters.to_date) { %}
            Period: {%= filters.from_date %} to {%= filters.to_date %}<br>
        {% } %}
        {% if (filters.warehouse) { %}
            Warehouse: {%= filters.warehouse %}<br>
        {% } %}
    </div>
    
    <!-- Data Table -->
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Item Code</th>
                <th>Item Name</th>
                <th>Stock Qty</th>
            </tr>
        </thead>
        <tbody>
            {% for (var i = 0; i < data.length; i++) { %}
                <tr>
                    <td>{%= data[i].item_code %}</td>
                    <td>{%= data[i].item_name %}</td>
                    <td>{%= data[i].stock_qty %}</td>
                </tr>
            {% } %}
        </tbody>
    </table>
</div>
```

---

### Example 3: Conditional Formatting

```html
<div style="padding: 20px;">
    <h2>Aged Receivables</h2>
    
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Customer</th>
                <th>Invoice</th>
                <th>Amount</th>
                <th>Days Overdue</th>
            </tr>
        </thead>
        <tbody>
            {% for (var i = 0; i < data.length; i++) { %}
                {% 
                var days = data[i].days_overdue || 0;
                var rowStyle = days > 90 ? "background-color: #fee; color: red;" : 
                               days > 60 ? "background-color: #ffe; color: orange;" : "";
                %}
                <tr style="{%= rowStyle %}">
                    <td>{%= data[i].customer %}</td>
                    <td>{%= data[i].invoice_number %}</td>
                    <td>{%= data[i].amount %}</td>
                    <td>{%= days %} days</td>
                </tr>
            {% } %}
        </tbody>
    </table>
</div>
```

---

### Example 4: Grouped Data

```html
<div style="padding: 20px;">
    <h2>Sales by Category</h2>
    
    {% 
    var currentCategory = "";
    var categoryTotal = 0;
    %}
    
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Item</th>
                <th>Qty</th>
                <th>Amount</th>
            </tr>
        </thead>
        <tbody>
            {% for (var i = 0; i < data.length; i++) { %}
                {% if (currentCategory !== data[i].category) { %}
                    {% if (currentCategory !== "") { %}
                        <tr style="font-weight: bold; background-color: #f0f0f0;">
                            <td colspan="2">Subtotal - {%= currentCategory %}</td>
                            <td>{%= categoryTotal.toFixed(2) %}</td>
                        </tr>
                    {% } %}
                    {% currentCategory = data[i].category; categoryTotal = 0; %}
                    <tr style="background-color: #e0e0e0;">
                        <td colspan="3"><strong>{%= currentCategory %}</strong></td>
                    </tr>
                {% } %}
                <tr>
                    <td>{%= data[i].item_name %}</td>
                    <td>{%= data[i].qty %}</td>
                    <td>{%= data[i].amount %}</td>
                </tr>
                {% categoryTotal += parseFloat(data[i].amount) || 0; %}
            {% } %}
        </tbody>
    </table>
</div>
```

---

### Example 5: Consolidated Salary Report

```html
<div class="salary-report-container">
    <h1 class="report-title">Consolidated Salary Report</h1>
    
    <table class="salary-table">
        <thead>
            <tr>
                <th class="text-left">Earning Head</th>
                <th class="text-right">Amount</th>
                <th class="text-left">Deduction Head</th>
                <th class="text-right">Amount</th>
            </tr>
        </thead>
        <tbody>
            {% for (var i = 0; i < data.length; i++) { %}
                {% 
                var isTotalRow = (data[i].earning_head && (data[i].earning_head.toLowerCase().includes("total") || data[i].earning_head.toLowerCase().includes("net pay"))) || 
                                 (data[i].deduction_head && (data[i].deduction_head.toLowerCase().includes("total") || data[i].deduction_head.toLowerCase().includes("net pay")));
                var isNetPayRow = (data[i].deduction_head && data[i].deduction_head.toLowerCase().includes("net pay"));
                var rowClass = isNetPayRow ? "net-salary-row" : (isTotalRow ? "total-row" : "");
                %}
                
                <tr class="{%= rowClass %}">
                    <td>{%= data[i].earning_head || "" %}</td>
                    <td class="text-right">
                        {%= data[i].earning_amount ? parseFloat(data[i].earning_amount).toLocaleString("en-US", {minimumFractionDigits: 2, maximumFractionDigits: 2}) : "" %}
                    </td>
                    <td>{%= data[i].deduction_head || "" %}</td>
                    <td class="text-right">
                        {%= data[i].deduction_amount ? parseFloat(data[i].deduction_amount).toLocaleString("en-US", {minimumFractionDigits: 2, maximumFractionDigits: 2}) : "" %}
                    </td>
                </tr>
            {% } %}
        </tbody>
    </table>
</div>
```

**Corresponding CSS:**
```css
.salary-report-container {
    font-family: "Segoe UI", Arial, sans-serif;
    padding: 20px;
    max-width: 1100px;
    margin: 0 auto;
}

.report-title {
    text-align: center;
    font-size: 22px;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 25px;
    padding-bottom: 10px;
    border-bottom: 2px solid #d1d5db;
}

.salary-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 13px;
    border: 1px solid #d1d5db;
}

.salary-table thead tr {
    background-color: #6b7280;
}

.salary-table th {
    padding: 12px 10px;
    font-weight: 600;
    font-size: 13px;
    color: #ffffff;
    border: 1px solid #9ca3af;
}

.salary-table th.text-left {
    text-align: left;
}

.salary-table th.text-right {
    text-align: right;
}

.salary-table td {
    padding: 9px 10px;
    border: 1px solid #e5e7eb;
    color: #374151;
    line-height: 1.5;
}

.salary-table tbody tr:nth-child(even):not(.total-row):not(.net-salary-row) {
    background-color: #f9fafb;
}

.salary-table tbody tr:hover:not(.total-row):not(.net-salary-row) {
    background-color: #f3f4f6;
}

.text-right {
    text-align: right;
    font-family: "Courier New", monospace;
}

.text-left {
    text-align: left;
}

.total-row {
    background-color: #e5e7eb !important;
    font-weight: 700;
    border-top: 2px solid #6b7280;
}

.total-row td {
    padding: 12px 10px;
    font-size: 14px;
    color: #1f2937;
    font-weight: 700;
}

.net-salary-row {
    background-color: #374151 !important;
    font-weight: 700;
}

.net-salary-row td {
    padding: 14px 10px;
    font-size: 15px;
    color: #ffffff;
    border-color: #1f2937;
    font-weight: 700;
}

@media print {
    .salary-report-container {
        padding: 10px;
    }
}
```

---

## Troubleshooting

### Problem 1: Template Code Shows as Text

**Symptom:** You see `{%= data[i].name %}` in the output instead of actual values.

**Solution:** Make sure:
- Print Format Type is set to **"JS"**
- You're using `{%= %}` and `{% %}` (not `<%= %>` and `<% %>`)

---

### Problem 2: No Data Showing

**Symptom:** Table is empty or shows no rows.

**Debug Steps:**
1. Check if `data.length` is > 0:
```html
<p>Total Rows: {%= data.length %}</p>
```

2. Use the debug template to see field names (see Best Practices section)

3. Make sure you're using the correct field names (slugified)

---

### Problem 3: Numbers Not Formatted

**Symptom:** Numbers show as `123456.789` instead of `123,456.79`

**Solution:**
```html
{%= parseFloat(data[i].amount).toLocaleString("en-US", {minimumFractionDigits: 2, maximumFractionDigits: 2}) %}
```

---

### Problem 4: Styling Not Applied

**Symptom:** CSS doesn't work or looks different in PDF.

**Solutions:**
- Use inline styles for critical formatting
- Avoid complex CSS selectors
- Test both screen view and PDF output
- Use simple Bootstrap classes

---

### Problem 5: Syntax Errors

**Common Mistakes:**

❌ **Using single quotes:**
```html
{%= data[i].name || '' %}
```

✅ **Use double quotes:**
```html
{%= data[i].name || "" %}
```

❌ **Missing closing braces:**
```html
{% for (var i = 0; i < data.length; i++) { %}
    <tr>...</tr>
<!-- Missing {% } %} -->
```

✅ **Always close code blocks:**
```html
{% for (var i = 0; i < data.length; i++) { %}
    <tr>...</tr>
{% } %}
```

---

### Problem 6: Header Text Not Visible

**Symptom:** Table header text is invisible or same color as background.

**Solution:** Always set explicit text color for headers:
```css
.table th {
    background-color: #6b7280;
    color: #ffffff;  /* Add this! */
}
```

---

### Problem 7: Duplicate Totals

**Symptom:** Total rows appear twice in the report.

**Solution:** Check if your report data already includes totals. If so, don't calculate them again. Instead, detect and style them:

```html
{% for (var i = 0; i < data.length; i++) { %}
    {% 
    var isTotalRow = data[i].field_name && data[i].field_name.toLowerCase().includes("total");
    var rowClass = isTotalRow ? "total-row" : "";
    %}
    <tr class="{%= rowClass %}">
        <!-- your cells -->
    </tr>
{% } %}
```

---

## Quick Reference Card

### Template Syntax Cheat Sheet

| Purpose | Syntax | Example |
|---------|--------|---------|
| Print value | `{%= expression %}` | `{%= data[i].name %}` |
| Code block | `{% code %}` | `{% for (...) { %}` |
| Close block | `{% } %}` | `{% } %}` |
| Comment | `{# comment #}` | `{# This is a note #}` |

### Common Patterns

```html
<!-- Loop through data -->
{% for (var i = 0; i < data.length; i++) { %}
    {%= data[i].field_name %}
{% } %}

<!-- Conditional -->
{% if (condition) { %}
    <!-- HTML -->
{% } else { %}
    <!-- HTML -->
{% } %}

<!-- Calculate total -->
{% 
var total = 0;
for (var i = 0; i < data.length; i++) {
    total += parseFloat(data[i].amount) || 0;
}
%}
Total: {%= total.toFixed(2) %}

<!-- Format number -->
{%= parseFloat(value).toLocaleString("en-US", {minimumFractionDigits: 2}) %}

<!-- Handle empty values -->
{%= data[i].field || "" %}
{%= data[i].amount || 0 %}
```

---

## Field Name Conversion Table

Common column names and their slugified field names:

| Column Name | Field Name |
|-------------|------------|
| Posting Date | `posting_date` |
| Item Name | `item_name` |
| Item Code | `item_code` |
| Grand Total | `grand_total` |
| Employee Name | `employee_name` |
| Customer Name | `customer_name` |
| Invoice Number | `invoice_number` |
| Stock Qty | `stock_qty` |
| Unit Price | `unit_price` |
| Total Amount | `total_amount` |

**Rule:** Spaces → underscores, Convert to lowercase

---

## Additional Resources

- **ERPNext Forum:** https://discuss.frappe.io
- **Frappe Documentation:** https://frappeframework.com/docs
- **Bootstrap CSS:** https://getbootstrap.com/docs/3.4/
- **JavaScript Reference:** https://developer.mozilla.org/en-US/docs/Web/JavaScript
- **Number Formatting:** https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/toLocaleString

---

## Summary Checklist

Before saving your print format:

- [ ] Print Format Type is set to **"JS"**
- [ ] Using correct syntax: `{%= %}` and `{% %}`
- [ ] Using double quotes (not single quotes)
- [ ] Field names are slugified correctly
- [ ] All code blocks are properly closed
- [ ] Numbers are formatted if needed
- [ ] Empty values are handled
- [ ] Header text has explicit color (if using colored background)
- [ ] Checked for duplicate totals
- [ ] Tested in both screen and PDF view
- [ ] Custom CSS is in the "Custom CSS" field (not in HTML)

---

## Tips for Success

1. **Start Simple:** Begin with a basic template and add features gradually
2. **Use Debug Template:** Always use the debug template first to see exact field names
3. **Test Frequently:** Save and test after each major change
4. **Keep Backup:** Copy your HTML/CSS before making major changes
5. **Use Comments:** Add comments to complex logic for future reference
6. **Mobile Friendly:** Consider how the print will look on different paper sizes
7. **Reuse Components:** Save commonly used patterns for reuse

---

## Version History

- **Version 1.0** - Initial documentation
- Last Updated: December 2025
- Feature introduced in: Frappe Framework PR #33178

---

**License:** This documentation is provided as-is for ERPNext/Frappe Framework users.