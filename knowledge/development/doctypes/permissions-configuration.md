# Permissions & Access Control

> Configuring role-based permissions and access control in Frappe.

## Permission Levels

### Role Permissions

**DocType level permissions.**

```
DocType → Permissions tab

Roles:
- System Manager (all permissions)
- Sales User (read, write, create)
- Sales Master Manager (all + delete)
- Customer (read only portal)
```

**Permission Matrix:**

| Permission | Meaning | Example |
|------------|---------|---------|
| **Read** | View documents | View Sales Order |
| **Write** | Edit existing | Update quantity |
| **Create** | Create new | New Sales Order |
| **Delete** | Delete documents | Remove draft |
| **Submit** | Submit submittable | Submit Sales Order |
| **Cancel** | Cancel submitted | Cancel invoice |
| **Amend** | Amend cancelled | Amend and resubmit |
| **Report** | Run reports | Sales Report |
| **Import** | Data import | CSV import |
| **Export** | Data export | Export to Excel |
| **Print** | Print documents | Print invoice |
| **Email** | Email documents | Email quote |
| **Share** | Share with users | Share document |
| **Set User Permissions** | Restrict access | Limit to territory |

### Document-Level Permissions

**Restrict based on document fields.**

```python
# DocType JSON
{
    "permissions": [
        {
            "role": "Sales User",
            "read": 1,
            "write": 1,
            "create": 1,
            "if_owner": 1  # Only owner can edit
        },
        {
            "role": "Sales Manager",
            "read": 1,
            "write": 1,
            "create": 1,
            "delete": 1,
            "if_owner": 0  # Can edit all
        }
    ]
}
```

### Permission by Document Status

```python
{
    "permissions": [
        {
            "role": "Sales User",
            "permlevel": 0,
            "read": 1,
            "write": 1,
            "create": 1
        },
        {
            "role": "Sales User",
            "permlevel": 0,
            "read": 1,
            "write": 1,
            "submit": 1,
            "if_owner": 1  # Only submit own
        },
        {
            "role": "Sales Manager",
            "permlevel": 0,
            "cancel": 1,
            "amend": 1  # Manager can cancel/amend
        }
    ]
}
```

## User Permissions

### Territory Restriction

**Restrict users to specific territories.**

```
Setup → Permissions → User Permissions → New

User: sales@company.com
Allow: Territory
For Value: North Region

Result: User sees only North Region data
```

**Apply To:**
- Customer (filter by territory)
- Sales Order (filter by customer's territory)
- Sales Invoice (filter by customer's territory)

### Company Restriction

```python
# Restrict to specific company
frappe.defaults.add_user_default('company', 'Company A', 'user@company.com')

# User sees only Company A data
```

### Programmatic User Permissions

```python
# Add user permission
frappe.get_doc({
    'doctype': 'User Permission',
    'user': 'sales@company.com',
    'allow': 'Customer',
    'for_value': 'CUST-001',
    'apply_to_all_doctypes': 0,
    'applicable_for': 'Sales Order'  # Apply only to Sales Order
}).insert()

# Remove user permission
frappe.db.delete('User Permission', {
    'user': 'sales@company.com',
    'allow': 'Customer',
    'for_value': 'CUST-001'
})
```

## Field-Level Permissions

### Permission Levels

**Different permissions for specific fields.**

```python
# DocType JSON
{
    "fields": [
        {
            "fieldname": "customer",
            "fieldtype": "Link",
            "permlevel": 0  # Normal permission
        },
        {
            "fieldname": "discount_percentage",
            "fieldtype": "Percent",
            "permlevel": 1  # Restricted field
        },
        {
            "fieldname": "commission_rate",
            "fieldtype": "Percent",
            "permlevel": 2  # Highly restricted
        }
    ],
    "permissions": [
        {
            "role": "Sales User",
            "permlevel": 0,
            "read": 1,
            "write": 1
        },
        {
            "role": "Sales Manager",
            "permlevel": 1,
            "read": 1,
            "write": 1  # Can edit discount
        },
        {
            "role": "Sales Master Manager",
            "permlevel": 2,
            "read": 1,
            "write": 1  # Can edit commission
        }
    ]
}
```

**Result:**
- Sales User: Can't see/edit discount or commission
- Sales Manager: Can see/edit discount, can't edit commission
- Sales Master Manager: Can see/edit everything

## Custom Permission Checks

### Python Permission Validation

```python
class SalesOrder(Document):
    def validate(self):
        """Custom permission logic"""
        # Check if user can set discount > 10%
        if self.discount_percentage > 10:
            if 'Sales Manager' not in frappe.get_roles():
                frappe.throw('Only Sales Manager can set discount > 10%')

        # Check if user owns the customer
        if not self.is_new():
            if not self.has_permission('write'):
                frappe.throw('No permission to edit this order')

    def has_permission(doc, ptype, user):
        """Override permission check"""
        # Check user permissions
        allowed_customers = frappe.get_list('User Permission', {
            'user': user,
            'allow': 'Customer'
        }, pluck='for_value')

        if allowed_customers and doc.customer not in allowed_customers:
            return False

        return True
```

### JavaScript Permission Check

```javascript
frappe.ui.form.on('Sales Order', {
    refresh: function(frm) {
        // Check if user can submit
        if (!frm.doc.__islocal && frm.doc.docstatus === 0) {
            if (frappe.user_roles.includes('Sales Manager')) {
                frm.add_custom_button('Submit', () => {
                    frm.savesubmit();
                });
            }
        }

        // Hide field if no permission
        if (!frappe.user_roles.includes('Sales Manager')) {
            frm.set_df_property('discount_percentage', 'hidden', 1);
        }
    },

    before_save: function(frm) {
        // Validate before save
        if (frm.doc.discount_percentage > 10) {
            if (!frappe.user_roles.includes('Sales Manager')) {
                frappe.throw('Only Sales Manager can set discount > 10%');
            }
        }
    }
});
```

## Portal Permissions

### Customer Portal

```python
# Enable portal access
{
    "permissions": [
        {
            "role": "Customer",
            "read": 1,
            "write": 0,
            "create": 0,
            "if_owner": 1
        }
    ],
    "has_web_view": 1
}

# Portal list view
def get_list_context(context):
    """Customer portal list"""
    context.show_sidebar = True
    context.no_breadcrumbs = True

    # Only show customer's own orders
    customer = frappe.db.get_value('Customer', {'user': frappe.session.user})

    if customer:
        context.filters = {'customer': customer}
    else:
        context.filters = {'name': ['=', '']}  # Empty result

    return context
```

### Supplier Portal

```python
# Portal settings
has_website_permission = {
    "Sales Order": "my_app.permissions.sales_order_portal_permission"
}

# my_app/permissions.py
def sales_order_portal_permission(doc, user):
    """Check if user can view Sales Order in portal"""
    # Check if user is linked to customer
    customer = frappe.db.get_value('Customer', {'user': user})

    if customer and doc.customer == customer:
        return True

    return False
```

## Sharing

### Share Document

```python
# Share with user
frappe.share.add('Sales Order', 'SO-0001', 'user@company.com',
    read=1, write=1, share=1)

# Share with everyone
frappe.share.set_permission('Sales Order', 'SO-0001',
    everyone=1, read=1)

# Get shared users
shared_users = frappe.share.get_users('Sales Order', 'SO-0001')

# Remove share
frappe.share.remove('Sales Order', 'SO-0001', 'user@company.com')
```

### Custom Share Rules

```python
class SalesOrder(Document):
    def on_update(self):
        """Auto-share with sales team"""
        if self.assigned_to:
            frappe.share.add(self.doctype, self.name, self.assigned_to,
                read=1, write=1, submit=1)

        # Share with manager
        manager = frappe.db.get_value('User', self.owner, 'manager')
        if manager:
            frappe.share.add(self.doctype, self.name, manager,
                read=1, write=0)
```

## Role Hierarchy

### Role Inheritance

```python
# hooks.py
role_hierarchy = {
    'Sales Master Manager': ['Sales Manager', 'Sales User'],
    'Sales Manager': ['Sales User']
}

# Result: Sales Master Manager has all Sales Manager + Sales User permissions
```

## Permission Queries

### Custom Permission Query

```python
# hooks.py
permission_query_conditions = {
    "Sales Order": "my_app.permissions.sales_order_query"
}

# my_app/permissions.py
def sales_order_query(user):
    """Filter Sales Orders based on user"""
    if 'Sales Master Manager' in frappe.get_roles(user):
        return None  # No restriction

    # Restrict to user's territory
    territories = frappe.get_all('User Permission', {
        'user': user,
        'allow': 'Territory'
    }, pluck='for_value')

    if territories:
        return f"""(`tabSales Order`.territory in ({','.join([f"'{t}'" for t in territories])}))"""

    return '1=0'  # No access
```

## Security Patterns

### Permission Helper

```python
def check_permission(doctype, doc, ptype='read'):
    """Check if user has permission"""
    if not frappe.has_permission(doctype, ptype, doc):
        frappe.throw(f'No {ptype} permission for {doctype}',
            frappe.PermissionError)

def check_owner(doc):
    """Check if user is owner"""
    if doc.owner != frappe.session.user:
        if 'System Manager' not in frappe.get_roles():
            frappe.throw('Only owner can edit', frappe.PermissionError)

def check_role(role):
    """Check if user has role"""
    if role not in frappe.get_roles():
        frappe.throw(f'Role {role} required', frappe.PermissionError)
```

### Whitelisted Method Security

```python
@frappe.whitelist()
def update_order_status(order_name, new_status):
    """Update order status with permission check"""
    # Check permission
    doc = frappe.get_doc('Sales Order', order_name)

    if not frappe.has_permission('Sales Order', 'write', doc):
        frappe.throw('No permission to edit', frappe.PermissionError)

    # Update
    doc.status = new_status
    doc.save()

    return {'success': True}
```

## Testing Permissions

### Test as User

```python
# Set user for testing
frappe.set_user('user@company.com')

try:
    doc = frappe.get_doc('Sales Order', 'SO-0001')
    doc.save()
except frappe.PermissionError:
    print('User cannot save')

# Reset to admin
frappe.set_user('Administrator')
```

### Permission Test Cases

```python
class TestSalesOrderPermissions(unittest.TestCase):
    def test_user_permission(self):
        """Test user can only see own territory"""
        frappe.set_user('sales@company.com')

        # Add user permission
        frappe.get_doc({
            'doctype': 'User Permission',
            'user': 'sales@company.com',
            'allow': 'Territory',
            'for_value': 'North'
        }).insert()

        # Should see North orders
        orders = frappe.get_all('Sales Order',
            filters={'territory': 'North'})
        self.assertTrue(len(orders) > 0)

        # Should not see South orders
        with self.assertRaises(frappe.PermissionError):
            frappe.get_doc('Sales Order', 'SO-SOUTH-0001')
```

## Common Patterns

### Manager Approval

```python
{
    "permissions": [
        {
            "role": "Employee",
            "read": 1,
            "write": 1,
            "create": 1,
            "if_owner": 1
        },
        {
            "role": "Manager",
            "submit": 1,
            "cancel": 1
        }
    ]
}
```

### Territory-Based Access

```python
# Sales User restricted to territory
def sales_order_query(user):
    territories = get_user_territories(user)
    if territories:
        return f"territory in ('{\"','\".join(territories)}')"
    return '1=0'
```

### Company-Based Multi-Tenancy

```python
def get_permission_query_conditions(user):
    """Restrict to user's companies"""
    companies = frappe.get_all('User Permission', {
        'user': user,
        'allow': 'Company'
    }, pluck='for_value')

    if companies:
        return f"company in ('{\"','\".join(companies)}')"

    return None
```

## Key Rules

- ✅ Always check permissions in whitelisted methods
- ✅ Use User Permissions for data restrictions
- ✅ Use Field Permissions (permlevel) for sensitive fields
- ✅ Test permissions as different users
- ✅ Use has_permission() for custom checks
- ✅ Set if_owner for personal documents
- ✅ Use permission queries for list filtering
- ✅ Document permission requirements
- ✅ Use role hierarchy for permission inheritance
- ❌ Don't skip permission checks assuming safe context
- ❌ Don't use ignore_permissions without validation
- ❌ Don't hardcode user/role checks
- ❌ Don't expose sensitive fields to all roles
