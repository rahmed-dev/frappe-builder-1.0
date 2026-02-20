# Client-Side JavaScript Form Scripts

> **Standards:** Load `coding-principles.md` first for WHY. This file = HOW (Frappe JavaScript specifics).

## Naming Conventions

| Type | Convention |
|------|------------|
| Variables/functions | `camelCase` |
| Constants | `UPPER_SNAKE_CASE` |
| Private helpers | `_leadingUnderscore` |

## Style Guidelines

- Consistent indentation (2 or 4 spaces)
- Consistent quotes (single or double)
- Always use semicolons

## Form Event Structure

```javascript
frappe.ui.form.on('DocType', {
    refresh: function(frm) {
        // Setup buttons, fields, visibility
    },

    validate: function(frm) {
        // Client-side validation (server validates too)
    },

    field_name: function(frm) {
        // Handle field change
    }
});
```

## Report Structure

```javascript
frappe.query_reports["Report Name"] = {
    onload: function(report) {
        // Setup event handlers, buttons, styles
    },

    formatter: function(value, row, column, data, default_formatter) {
        value = default_formatter(value, row, column, data);
        // Apply custom formatting
        return value;
    }
};
```

## Event Handling

```javascript
// ALWAYS use event delegation
$(document).on('click', '.selector', handler);

// NEVER bind to elements that don't exist yet
// $('.selector').on('click', handler); // ❌ BAD

// Stop propagation when needed
$(document).on('click', '.btn', function(e) {
    e.stopPropagation();
});
```

## Dialog Validation

```javascript
primary_action(values) {
    // Validate before submitting
    if (!values.required_field) {
        frappe.msgprint(__('Required field missing'));
        return;
    }

    // Proceed with action
    frappe.call({...});
    d.hide();
}
```

## Error Handling

```javascript
// ALWAYS check data exists
if (r.message && r.message.data) {
    // Safe to access
}

// ALWAYS handle both callbacks
frappe.call({
    callback: function(r) {...},
    error: function(r) {
        frappe.msgprint(__('Error occurred'));
    }
});
```

## Performance

| Technique | Example |
|-----------|---------|
| Build HTML once | `html = parts.join(''); $container.html(html);` |
| Cache jQuery selections | `const $element = $('#id');` |
| Debounce search | `frappe.utils.debounce(fn, 300)` |

## Security

| Rule | Example |
|------|---------|
| Escape user input | `frappe.utils.escape_html(userInput)` |
| Never use eval() | ❌ `eval(code)` |
| Validate before sending | Check inputs before `frappe.call()` |

## Translation

```javascript
// Wrap all user-facing strings
frappe.msgprint(__('Task updated successfully'));

// With variables
__('Processed {0} items', [count]);
```

## Single DocType Used as a Tool Form

When a Single DocType is used as a UI tool (not for storing data), standard
form patterns behave unexpectedly. Confirmed through real usage (2026-02-20).

### Hiding the Save button

```javascript
refresh(frm) {
    frm.disable_save(); // removes Save button AND disables Ctrl+S
}
```

### Clearing fields after an action

❌ `frm.set_value(field, null)` — marks the form dirty, leaves unsaved
state indicator even after the action completes.

❌ `frm.reload_doc()` — reloads from DB. Since Single DocTypes persist
field values, this brings back previously saved values, not a clean form.

✅ **Correct approach:** set directly on `frm.doc`, refresh the UI,
then save back to DB to persist the empty state.

```javascript
function clear_tool_form(frm) {
    const fields_to_clear = ["field_a", "field_b", "field_c"];

    // Direct assignment — no events fired, no dirty marking
    fields_to_clear.forEach((fieldname) => {
        frm.doc[fieldname] = null;
    });

    // Restore Check fields to their defaults
    frm.doc.maintain_stock = 1;

    // Refresh UI then persist cleared state back to DB
    frm.refresh_fields();
    frm.save();
}
```

**Why this works:** `frm.doc[field] = null` bypasses Frappe's event/dirty
system. `frm.save()` persists the empty state so the form is in a clean
saved state ready for the next entry.

---

## Minimalist Code

❌ **Avoid:**
- Emojis in code or UI
- Custom CSS for colors/aesthetics
- STATUS_COLORS mappings
- Decorative badges
- Unnecessary styling

✅ **Use:**
- Frappe built-in classes: `btn-primary`, `indicator-green`
- Frappe defaults for formatting
- Only essential functionality CSS
