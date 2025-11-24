# Anti-Fluff Documentation Mandate

All frappe-builder outputs follow strict anti-fluff principles: maximum information density, zero decorative language.

## User Guides: 500 Words Max

**Structure:**
1. Quick Steps (numbered)
2. Field Reference (table)
3. Common Issues (problem → fix)
4. Example (code/screenshot)

**Rules:**
- Max 2-sentence intro
- Steps only, no philosophy
- Code examples mandatory
- No background/history sections

## Technical Documentation

**Format Hierarchy:**
1. **Tables** - Highest density (use for comparisons, references, matrices)
2. **Bullets** - Medium density (use for lists, steps, rules)
3. **Paragraphs** - Last resort (only for complex explanations)

**Example:**
```markdown
❌ BAD (80 tokens):
When working with Frappe's database layer, you have several options.
The frappe.db.get_value() function is particularly useful when you only
need to retrieve a single field from a document. This is more efficient
than loading the entire document with get_doc()...

✅ GOOD (25 tokens):
**Single Field Lookup:**
`frappe.db.get_value(doctype, name, field)` - Faster than get_doc()
Returns: Field value or None
```

## Agent Communication Style

**Forbidden Phrases:**
- ❌ "Let's explore..."
- ❌ "It's important to understand..."
- ❌ "You should definitely..."
- ❌ "The fascinating world of..."
- ❌ "First, let me explain the background..."
- ❌ "This is a critical concept..."
- ❌ "Before we dive in..."

**Required Pattern:**
1. **Direct answer first** (what user asked for)
2. **Code example second** (working implementation)
3. **Edge cases third** (gotchas/warnings)
4. **Done** (no summary, no conclusion)

## Code Documentation

**Inline Comments Only:**
```python
# ❌ BAD: Verbose function docstring
def update_stock(item_code, qty, warehouse):
    """
    This function updates the stock balance for a given item.
    It's important to note that this will affect inventory levels
    and should be used carefully. The function takes three parameters:
    item_code (the unique identifier for the item), qty (the quantity),
    and warehouse (where the stock is located).
    """
    pass

# ✅ GOOD: Concise inline comments
def update_stock(item_code, qty, warehouse):
    # Update bin qty, create Stock Ledger Entry
    bin_doc = frappe.get_doc("Bin", {"item_code": item_code, "warehouse": warehouse})
    bin_doc.actual_qty += qty  # Positive = IN, Negative = OUT
    bin_doc.save()
```

## Knowledge Base Files

**Structure:**
```markdown
# [Topic Name]

[2-sentence overview]

## Quick Reference
[Table or bullets with core info]

## Code Examples
[Working code with inline comments]

## Edge Cases
[Gotchas, errors, anti-patterns]

## Related
[Links to related KB files]
```

**Maximum Length:** 800 words

## Templates

**Maximum Length:** 400 words
**Structure:** Headers + placeholders only
**No explanatory text** - templates are filled in by workflows

## Metrics

**Target Information Density:**
- 1 token = 1 actionable piece of information
- Aim for 60-70% token reduction vs traditional docs
- ZERO data loss (compression, not deletion)

**Quality Check:**
- Can reader act on this immediately? (Yes/No)
- Is every sentence necessary? (Remove if No)
- Could this be a table instead? (Convert if Yes)
- Are there repeated concepts? (Reference, don't repeat)
