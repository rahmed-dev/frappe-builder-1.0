# Creating Print Formats for Reports Using UI

## Complete Guide for ERPNext/Frappe Framework

---

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites & Setup](#prerequisites--setup)
3. [Template Syntax](#template-syntax)
4. [🚨 CRITICAL: Variable Scoping](#-critical-variable-scoping-rules)
5. [Available Variables](#available-variables)
6. [Best Practices](#best-practices)
7. [Examples](#examples)
8. [Troubleshooting](#troubleshooting)
9. [Quick Reference](#quick-reference)

---

## Introduction

Create custom, professional print layouts for ERPNext reports directly from the UI. Features:
- ✅ Custom layouts with branding
- ✅ Professional data tables
- ✅ Totals and calculations
- ✅ Headers, footers, logos
- ✅ PDF export with formatting

---

## Prerequisites & Setup

### Requirements:
- Basic HTML, CSS, JavaScript knowledge
- ERPNext/Frappe with Print Format feature enabled
- Access to Print Format DocType

### Setup Steps:

1. **Navigate to Print Format** (Ctrl+K or ⌘+K) → "Print Format" → "+ New"

2. **Configure Settings:**

| Field | Value | Critical |
|-------|-------|----------|
| Print Format Name | e.g., "Sales Report - Custom" | |
| For | **"Report"** | ✓ Must be Report |
| Report | Select your report | |
| Print Format Type | **"JS"** | ✓ Must be JS |
| Enabled | ✓ Checked | |

3. **Write HTML** in HTML field
4. **Write CSS** in Custom CSS field
5. **Save and Test** → Go to report → Print button → Select your format

---

## Template Syntax

Uses JavaScript templating (similar to Jinja):

### 1. Print Values
```html
{%= variable_name %}
{%= data[i].field_name %}
{%= filters.employee_name %}
```

### 2. Code Blocks
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

### 3. Calculations
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

## 🚨 CRITICAL: Variable Scoping Rules

**This is the #1 cause of template errors!**

### The Problem
Variables defined in a closed code block `{% %}` lose scope and cannot be accessed later.

### ❌ WRONG - This Will Fail
```html
{%
for (var i = 0; i < data.length; i++) {
    var rowClass = "some-class";
}
%}
    <tr class="{%= rowClass %}">  <!-- ✗ ERROR: rowClass is not defined -->
```

### ✅ CORRECT - Keep Loop Open, Define Variables Inside
```html
{% for (var i = 0; i < data.length; i++) { %}
    {%
    var row = data[i];
    var rowClass = "some-class";
    var calculated = row.amount * 2;
    %}
    <tr class="{%= rowClass %}">  <!-- ✓ Works! -->
        <td>{%= calculated %}</td>
    </tr>
{% } %}
```

### Key Rules
1. Loop opening on its own line: `{% for ... { %}`
2. Variables in separate block INSIDE loop: `{% var x = ...; %}`
3. Variables stay in scope until loop closes: `{% } %}`
4. Define all row variables together in one block

---

## Available Variables

### 1. `data` - Array of Report Rows
Main data from your report. Field names are **slugified** (lowercase, spaces → underscores).

**Examples:**
- "Posting Date" → `posting_date`
- "Item Name" → `item_name`
- "Grand Total" → `grand_total`

```html
{% for (var i = 0; i < data.length; i++) { %}
    <td>{%= data[i].posting_date %}</td>
    <td>{%= data[i].item_name %}</td>
{% } %}
```

### 2. `filters` - Report Filters
```html
{% if (filters.from_date && filters.to_date) { %}
    <p>Period: {%= filters.from_date %} to {%= filters.to_date %}</p>
{% } %}
```

### 3. `title` - Report Title
```html
<h1>{%= title %}</h1>
```

### 4. JavaScript Functions
```html
<!-- Format numbers -->
{%= parseFloat(data[i].amount).toLocaleString("en-US", {minimumFractionDigits: 2}) %}

<!-- Format dates -->
{%= new Date(data[i].date).toLocaleDateString("en-US", {month: "short", day: "numeric", year: "numeric"}) %}

<!-- Conditionals -->
{%= data[i].status === "Completed" ? "✓" : "✗" %}
```

---

## Best Practices

### 1. Finding Field Names (Debug Method)
```html
<table class="table table-bordered">
    <tr><th>Field Name</th><th>Value</th></tr>
    {% if (data.length > 0) { %}
        {% for (var key in data[0]) { %}
            <tr>
                <td><strong>{%= key %}</strong></td>
                <td>{%= data[0][key] %}</td>
            </tr>
        {% } %}
    {% } %}
</table>
```
Save this, generate print → you'll see all field names!

### 2. Always Use Double Quotes
❌ Wrong: `{%= data[i].name || '' %}`
✅ Correct: `{%= data[i].name || "" %}`

### 3. Handle Empty Values
```html
{%= data[i].field_name || "" %}
{%= data[i].amount || 0 %}
```

### 4. Number Formatting
```html
{%= parseFloat(data[i].amount).toLocaleString("en-US", {minimumFractionDigits: 2, maximumFractionDigits: 2}) %}
<!-- Output: 1,234,567.89 -->
```

### 5. Bootstrap Classes Available
```html
<table class="table table-bordered table-striped">
<div class="row">
    <div class="col-xs-6">Left</div>
    <div class="col-xs-6">Right</div>
</div>
```

### 6. Styling Tips

**Keep It Simple:**
- White backgrounds with black/dark borders
- Avoid heavy gradients (don't print well)

**Badges (Status/Priority):**
```css
.badge {
    padding: 2px 10px;
    border-radius: 12px;  /* Pill-shaped */
    font-size: 10px;
    font-weight: 500;
}
.status-completed { background-color: #d4edda; color: #155724; }
.status-working { background-color: #cce5ff; color: #004085; }
```

**Compact Tables:**
```css
.task-table td { padding: 4px 8px; }  /* Compact but readable */
.task-table th { padding: 6px 8px; }
```

**Tree Structure:**
```html
{% for (var i = 0; i < data.length; i++) { %}
    {%
    var indentLevel = data[i].indent || 0;
    var paddingLeft = (indentLevel * 20) + 10;
    %}
    <td>
        <div style="padding-left: {%= paddingLeft %}px;">
            {% if (indentLevel > 1) { %}
                <span style="color: #999;">└─</span>
            {% } %}
            {%= data[i].name %}
        </div>
    </td>
{% } %}
```

---

## Examples

### Example 1: Report with Totals and Conditional Formatting
```html
<div style="padding: 20px;">
    <h2 style="text-align: center;">{%= title %}</h2>

    <!-- Filters Display -->
    {% if (filters.from_date && filters.to_date) { %}
        <p><strong>Period:</strong> {%= filters.from_date %} to {%= filters.to_date %}</p>
    {% } %}

    <table class="table table-bordered">
        <thead>
            <tr style="background-color: #f5f7fa;">
                <th>Item</th>
                <th>Amount</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            {%
            var total = 0;
            for (var i = 0; i < data.length; i++) {
                var row = data[i];
                var amount = parseFloat(row.amount) || 0;
                total += amount;

                // Conditional styling
                var rowStyle = "";
                if (amount > 10000) {
                    rowStyle = "background-color: #fff3cd;";
                } else if (row.status === "Overdue") {
                    rowStyle = "background-color: #f8d7da;";
                }
            %}
                <tr style="{%= rowStyle %}">
                    <td>{%= row.item_name %}</td>
                    <td style="text-align: right;">
                        {%= amount.toLocaleString("en-US", {minimumFractionDigits: 2}) %}
                    </td>
                    <td>
                        <span class="badge status-{%= row.status.toLowerCase() %}">
                            {%= row.status %}
                        </span>
                    </td>
                </tr>
            {% } %}

            <!-- Total Row -->
            <tr style="font-weight: bold; background-color: #e9ecef;">
                <td>Total:</td>
                <td style="text-align: right;">{%= total.toLocaleString("en-US", {minimumFractionDigits: 2}) %}</td>
                <td></td>
            </tr>
        </tbody>
    </table>
</div>
```

**CSS:**
```css
.table {
    width: 100%;
    border-collapse: collapse;
    font-size: 11px;
}
.table th {
    padding: 6px 8px;
    font-weight: 600;
    border: 1px solid #d1d8dd;
}
.table td {
    padding: 4px 8px;
    border: 1px solid #d1d8dd;
}
.badge {
    display: inline-block;
    padding: 2px 10px;
    border-radius: 12px;
    font-size: 10px;
    font-weight: 500;
}
.status-completed { background-color: #d4edda; color: #155724; }
.status-working { background-color: #cce5ff; color: #004085; }
.status-overdue { background-color: #f8d7da; color: #721c24; }
```

### Example 2: Hierarchical/Tree Report
```html
<div style="padding: 20px;">
    <h2 style="text-align: center;">Project Tasks</h2>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Task</th>
                <th>Status</th>
                <th>Progress</th>
            </tr>
        </thead>
        <tbody>
            {% for (var i = 0; i < data.length; i++) { %}
                {%
                var row = data[i];
                var isProject = row.is_project_row == 1;
                var indentLevel = row.indent || 0;
                var paddingLeft = (indentLevel * 20) + 10;

                var rowClass = isProject ? "project-row" : "";
                var progressVal = parseFloat(row.progress) || 0;
                var progressColor = progressVal < 30 ? "#dc3545" : progressVal < 70 ? "#ffc107" : "#28a745";
                %}

                <tr class="{%= rowClass %}">
                    <td>
                        <div style="padding-left: {%= paddingLeft %}px; {%= isProject ? 'font-weight: 700;' : '' %}">
                            {% if (indentLevel > 1) { %}
                                <span style="color: #999; margin-right: 5px;">└─</span>
                            {% } %}
                            {%= row.subject %}
                        </div>
                    </td>
                    <td style="text-align: center;">
                        <span class="badge status-{%= row.status.toLowerCase().replace(' ', '-') %}">
                            {%= row.status %}
                        </span>
                    </td>
                    <td style="text-align: center;">
                        <div style="display: flex; align-items: center; gap: 5px;">
                            <div style="width: 60px; height: 8px; background: #e9ecef; border-radius: 4px;">
                                <div style="height: 100%; width: {%= progressVal %}%; background: {%= progressColor %}; border-radius: 4px;"></div>
                            </div>
                            <span style="font-size: 10px;">{%= progressVal %}%</span>
                        </div>
                    </td>
                </tr>
            {% } %}
        </tbody>
    </table>
</div>
```

**CSS:**
```css
.project-row {
    background-color: #e8f4fd !important;
    border-top: 1px solid #a8d4f7;
    border-bottom: 1px solid #a8d4f7;
}
.project-row td {
    color: #1f77b4;
    font-weight: 600;
}
```

---

## Troubleshooting

### Problem 1: ReferenceError - Variable is not defined 🚨 MOST COMMON

**Symptom:** `ReferenceError: rowClass is not defined`

**Solution:** Follow the variable scoping pattern:
```html
{% for (var i = 0; i < data.length; i++) { %}
    {% var myVariable = "something"; %}
    <tr class="{%= myVariable %}">  <!-- ✓ Works -->
{% } %}
```

**Checklist:**
- ✓ Loop opening on own line? `{% for ... { %}`
- ✓ Variables in separate block INSIDE loop?
- ✓ Check browser console for exact variable name

---

### Problem 2: Template Code Shows as Text

**Symptom:** You see `{%= data[i].name %}` instead of values

**Solution:**
- Print Format Type = **"JS"** (not Jinja)
- For = **"Report"** (not DocType)
- Using `{%= %}` not `<%= %>`

---

### Problem 3: No Data Showing

**Debug:**
```html
<p>Total Rows: {%= data.length %}</p>
```
- Use debug template (see Best Practices) to see field names
- Verify field names are slugified correctly

---

### Problem 4: Numbers Not Formatted

```html
{%= parseFloat(data[i].amount).toLocaleString("en-US", {minimumFractionDigits: 2, maximumFractionDigits: 2}) %}
```

---

### Problem 5: Styling Not Applied

- Use inline styles for critical formatting
- Avoid complex CSS selectors
- Test in both screen and PDF view
- Put CSS in "Custom CSS" field, not HTML

---

### Problem 6: Syntax Errors

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

---

## Quick Reference

### Template Syntax Cheat Sheet

| Purpose | Syntax | Example |
|---------|--------|---------|
| Print value | `{%= expression %}` | `{%= data[i].name %}` |
| Code block | `{% code %}` | `{% for (...) { %}` |
| Close block | `{% } %}` | `{% } %}` |

### The Golden Pattern
```html
{% for (var i = 0; i < data.length; i++) { %}
    {%
    var row = data[i];
    // All variables here
    %}
    <!-- HTML using variables -->
{% } %}
```

### Common Patterns
```html
<!-- Loop -->
{% for (var i = 0; i < data.length; i++) { %}
    {%= data[i].field_name %}
{% } %}

<!-- Conditional -->
{% if (condition) { %}
    <!-- HTML -->
{% } %}

<!-- Calculate total -->
{% var total = 0;
for (var i = 0; i < data.length; i++) {
    total += parseFloat(data[i].amount) || 0;
} %}
Total: {%= total.toFixed(2) %}

<!-- Format number -->
{%= parseFloat(value).toLocaleString("en-US", {minimumFractionDigits: 2}) %}

<!-- Handle empty -->
{%= data[i].field || "" %}
```

### Field Name Conversion

| Column Name | Field Name |
|-------------|------------|
| Posting Date | `posting_date` |
| Item Name | `item_name` |
| Grand Total | `grand_total` |
| Employee Name | `employee_name` |

**Rule:** Spaces → underscores, lowercase

---

## Summary Checklist

**Critical Configuration:**
- [ ] Print Format Type = **"JS"**
- [ ] For = **"Report"**
- [ ] Custom CSS in Custom CSS field

**Variable Scoping (Most Common Error):**
- [ ] Loop opening on own line: `{% for ... { %}`
- [ ] Variables in separate `{% %}` block INSIDE loop
- [ ] Check console if "ReferenceError"

**Syntax:**
- [ ] Using `{%= %}` for output and `{% %}` for code
- [ ] Using double quotes (not single)
- [ ] All code blocks closed with `{% } %}`

**Data:**
- [ ] Field names slugified correctly
- [ ] Empty values handled with `|| ""` or `|| 0`
- [ ] Numbers formatted if needed

**Testing:**
- [ ] Tested in both screen and PDF view
- [ ] Checked browser console for errors

---

## Tips for Success

1. **Start Simple** - Basic template first, add features gradually
2. **Use Debug Template** - See exact field names before coding
3. **Test Frequently** - Save and test after each change
4. **Keep Backup** - Copy HTML/CSS before major changes
5. **Check Console** - Browser console shows all errors
6. **Keep It Clean** - Simple styling prints better

---

## Version History

- **Version 1.0** - Initial documentation
- **Version 1.1** - December 2025 - Added critical variable scoping section
- **Version 1.2** - December 16, 2025 - Condensed for better readability
- Feature introduced in: Frappe Framework PR #33178

---

**License:** This documentation is provided as-is for ERPNext/Frappe Framework users.
