# Token Efficiency Standards

Maximum information density with zero data loss. Compress format, not content.

## Core Principle

**Traditional docs:** 1 token = 0.3 information units (70% filler)
**frappe-builder:** 1 token = 1 information unit (0% filler)

## Compression Techniques

### 1. Tables Over Prose

**Use tables for:**
- Comparisons (A vs B vs C)
- References (method → purpose → syntax)
- Matrices (scenario × action)
- Mappings (input → output)

**Example:**
```markdown
❌ VERBOSE (120 tokens):
The frappe.db module provides several methods for database operations.
For retrieving a single value, use get_value(). For getting an entire
document, use get_doc(). If you need multiple documents with filters,
use get_all(). For counting records, use count(). Each has different
performance characteristics and use cases.

✅ COMPRESSED (45 tokens):
| Method | Use Case | Performance |
|--------|----------|-------------|
| get_value() | Single field | Fastest |
| get_doc() | Full document | Medium |
| get_all() | Multiple docs | Filtered |
| count() | Record count | Fast |
```

**Savings:** 62% fewer tokens, 100% of information preserved

### 2. Hierarchical Bullets

**Pattern:**
- **Category** - Brief description
  - Specific item 1 - Detail
  - Specific item 2 - Detail
  - Specific item 3 - Detail

**Example:**
```markdown
❌ FLAT (90 tokens):
Frappe has standard DocTypes that come out of box. Then you can add
custom fields to extend them. You can also write server scripts for
custom behavior. Finally, you can create entirely new custom DocTypes
when you need new entities.

✅ HIERARCHICAL (40 tokens):
**Customization Tiers:**
- **Standard** - Use existing → 0 dev time
- **Custom Fields** - Extend DocType → 5 min
- **Server Scripts** - Add behavior → 30 min
- **Custom DocTypes** - New entity → 2-4 hrs
```

**Savings:** 56% fewer tokens, adds time estimates

### 3. Code-First Documentation

**Show, don't tell:**
```markdown
❌ EXPLANATION-FIRST (100 tokens):
To create a new document in Frappe, you should use frappe.get_doc()
with a dictionary containing the DocType and field values. Then call
insert() to save it to the database. You can also use save() if you
want to update an existing document.

✅ CODE-FIRST (35 tokens):
# Create document
doc = frappe.get_doc({
    "doctype": "Sales Order",
    "customer": "CUST-001",
    "items": [{"item_code": "ITEM-001", "qty": 10}]
})
doc.insert()  # New doc
doc.save()    # Update existing
```

**Savings:** 65% fewer tokens, more actionable

### 4. Reference Over Repetition

**Single Source of Truth:**

Instead of repeating frappe.utils functions across multiple KB files:

**Create:** `data/kb/frappe-framework/frappe-utils-reference.md`
**Reference:** "See [frappe.utils reference](../frappe-framework/frappe-utils-reference.md)"

**Example:**
```markdown
❌ REPEATED (in 10 different KB files = 1000 tokens):
Common frappe.utils functions:
- getdate() - Parse date string
- now() - Current datetime
- flt() - Convert to float
[... repeated 10 times ...]

✅ REFERENCED (1 complete file + 9 links = 150 tokens):
**In frappe-utils-reference.md:** [Complete reference]
**In other files:** "Date handling: see [frappe.utils reference]"
```

**Savings:** 85% fewer tokens across module

### 5. Semantic Compression

**Use domain-specific shorthand:**

```markdown
❌ VERBOSE:
"Navigate to the Sales Order DocType and create a new document"

✅ COMPRESSED:
"Create Sales Order"

(Users know how to create documents in ERPNext)
```

**When user needs detail, provide it. When they don't, assume competence.**

## Maximum Lengths

**Strict Limits:**
- User Guide: **500 words** (2 pages)
- KB File: **800 words** (3 pages)
- Template: **400 words** (1.5 pages)
- Standards File: **600 words** (2.5 pages)
- Agent Instruction: **100 lines** (sidecar)

**How to Stay Under:**
1. Write complete version
2. Convert paragraphs → tables
3. Convert sentences → bullets
4. Compress explanations → code
5. Extract repeated info → references

## Information Density Test

**Before publishing any documentation:**

1. **Remove one sentence** - Is information lost?
   - Yes → Keep it
   - No → Delete it

2. **Convert to table** - Does it work?
   - Yes → Use table
   - No → Keep as text

3. **Add code example** - Does it replace explanation?
   - Yes → Remove explanation
   - No → Keep both

## Token Budget

**Typical frappe-builder Interaction:**

| Component | Traditional | frappe-builder | Savings |
|-----------|-------------|----------------|---------|
| Agent Response | 1500 tokens | 600 tokens | 60% |
| KB File Read | 2000 tokens | 800 tokens | 60% |
| Workflow Step | 1000 tokens | 400 tokens | 60% |
| **Total Interaction** | **4500 tokens** | **1800 tokens** | **60%** |

**Result:** 2.5x more interactions per context window

## Compression Checklist

Before saving any file:
- [ ] Could any paragraph be a table?
- [ ] Could any sentence be a bullet?
- [ ] Could any explanation be code?
- [ ] Is there repeated information? (Reference instead)
- [ ] Is every word necessary?
- [ ] Does it pass the "remove one sentence" test?
- [ ] Is it under the word limit?
- [ ] Is information density >0.8 tokens/unit?

## Example: Before/After

**BEFORE (frappe-experts style):**
```markdown
# Understanding Frappe's Permission System

Frappe has a sophisticated permission system that controls what users
can see and do. Understanding this system is crucial for building
secure applications.

## How Permissions Work

Permissions in Frappe are role-based. Each user is assigned one or
more roles, and each role has specific permissions on DocTypes. For
example, a Sales User role might have read and write permissions on
Sales Orders but only read permissions on Customers...

[Continues for 1200 words]
```

**AFTER (frappe-builder style):**
```markdown
# Permission System

Role-based access control. Users → Roles → DocType Permissions.

## Permission Matrix

| DocType | Role | Read | Write | Create | Delete | Submit |
|---------|------|------|-------|--------|--------|--------|
| Sales Order | Sales User | ✓ | ✓ | ✓ | ✗ | ✓ |
| Customer | Sales User | ✓ | ✗ | ✗ | ✗ | - |

## Check Permissions

```python
# In whitelisted method
if not frappe.has_permission("Sales Order", "write", doc.name):
    frappe.throw("No permission")

# In DocType controller
def validate(self):
    if not frappe.has_permission("Customer", "read", self.customer):
        frappe.throw("Cannot access customer")
```

## User Permissions

Restrict by field value:
- User A: See only Customer = "CUST-001"
- User B: See only Territory = "North"

**Set via:** User Permissions (Setup > Permissions > User Permissions)

## Common Patterns

**Read-only for specific role:**
```python
# permissions.py
def has_permission(doc, ptype, user):
    if frappe.session.user == "readonly@example.com":
        return ptype == "read"
    return True
```

## Related
- [Role Management](./role-management.md)
- [Row-Level Security](./row-level-security.md)
```

**Token Count:**
- Before: ~800 tokens
- After: ~280 tokens
- Savings: 65%
- Information Loss: 0%
