# Website & Portal Routing

> Creating public-facing pages, portals, and web routes in Frappe.

## Web Pages

### Static Web Page

```
1. Website → Web Page → New
2. Route: about-us
3. Title: About Us
4. Published: Yes
5. Main Section: HTML content
6. Save
```

**Access:** `https://your-site.com/about-us`

### Dynamic Web Page (Controller)

```python
# my_app/www/product.py
import frappe

def get_context(context):
    """Set page context"""
    context.title = "Our Products"
    context.products = frappe.get_all(
        'Item',
        filters={'show_in_website': 1},
        fields=['name', 'item_name', 'description', 'image']
    )
    return context
```

```html
<!-- my_app/www/product.html -->
<h1>{{ title }}</h1>

<div class="products">
    {% for product in products %}
    <div class="product-card">
        <img src="{{ product.image }}">
        <h3>{{ product.item_name }}</h3>
        <p>{{ product.description }}</p>
    </div>
    {% endfor %}
</div>
```

**Access:** `https://your-site.com/product`

### Dynamic Route with Parameters

```python
# my_app/www/product/[product_id].py
import frappe

def get_context(context):
    """Product detail page"""
    product_id = frappe.form_dict.product_id

    context.product = frappe.get_doc('Item', product_id)

    if not context.product.show_in_website:
        frappe.throw('Product not found', frappe.DoesNotExistError)

    return context
```

```html
<!-- my_app/www/product/[product_id].html -->
<h1>{{ product.item_name }}</h1>

<img src="{{ product.image }}" alt="{{ product.item_name }}">

<div class="description">
    {{ product.description }}
</div>

<div class="price">
    {{ frappe.utils.fmt_money(product.standard_rate) }}
</div>

<button>Add to Cart</button>
```

**Access:** `https://your-site.com/product/ITEM-001`

## Web Forms

### Create Web Form

```
1. Website → Web Form → New
2. Title: Contact Us
3. Route: contact
4. DocType: Lead (or Contact)
5. Add Fields:
   - First Name (required)
   - Last Name
   - Email (required)
   - Phone
   - Message (Text Editor)
6. Success Message: "Thank you for contacting us!"
7. Published: Yes
```

**Access:** `https://your-site.com/contact`

### Custom Web Form Logic

```python
# hooks.py
webform_list_context = "my_app.web_form.custom_web_form_context"

# my_app/web_form.py
def custom_web_form_context(context):
    """Customize web form"""
    if context.doc.doctype == 'Lead':
        # Add custom fields
        context.custom_field = 'value'

        # Prefill data
        if frappe.session.user != 'Guest':
            user = frappe.get_doc('User', frappe.session.user)
            context.doc.email = user.email
```

## Portals

### Customer Portal

**Enable:**
```
Setup → Portal Settings → Enable
```

**Features:**
- View orders, invoices, payments
- Submit support tickets
- Track shipments
- Download documents

**Customize:**
```python
# my_app/portal/sales_order_list.py
import frappe

def get_list_context(context):
    """Customize sales order list"""
    context.title = "My Orders"
    context.show_sidebar = True

    # Custom filters
    context.filters = {
        'customer': frappe.db.get_value('Customer', {'user': frappe.session.user})
    }

    return context
```

### Supplier Portal

```python
# Enable supplier portal in Portal Settings

# my_app/portal/purchase_order_list.py
def get_list_context(context):
    """Supplier purchase orders"""
    context.title = "Purchase Orders"

    supplier = frappe.db.get_value('Supplier', {'user': frappe.session.user})

    context.filters = {'supplier': supplier}
    context.fields = ['name', 'transaction_date', 'grand_total', 'status']

    return context
```

## Route Rules

### URL Rewrite

```python
# hooks.py
website_route_rules = [
    # Old URL → New URL
    {"from_route": "/old-page", "to_route": "/new-page"},

    # Pattern matching
    {"from_route": "/blog/<path:name>", "to_route": "/posts/<name>"},

    # Static redirect
    {"from_route": "/shop", "to_route": "/products"},
]
```

### 301 Redirects

```python
# hooks.py
website_redirects = [
    # Source → Target (301 redirect)
    {"source": "/old-url", "target": "/new-url"},
    {"source": "/legacy-page", "target": "/modern-page"},
]
```

## Page Metadata

### SEO Settings

```python
def get_context(context):
    """Set SEO metadata"""
    context.title = "Product Catalog"
    context.meta_description = "Browse our wide range of products"
    context.meta_keywords = "products, catalog, shop"
    context.meta_image = "/files/og-image.jpg"

    # Open Graph tags
    context.og_title = "Our Products"
    context.og_description = "Check out our latest products"
    context.og_image = "/files/og-image.jpg"

    return context
```

```html
<!-- Rendered as -->
<head>
    <title>Product Catalog</title>
    <meta name="description" content="Browse our wide range of products">
    <meta name="keywords" content="products, catalog, shop">

    <meta property="og:title" content="Our Products">
    <meta property="og:description" content="Check out our latest products">
    <meta property="og:image" content="/files/og-image.jpg">
</head>
```

## Authentication

### Login Required

```python
# my_app/www/dashboard.py
import frappe

def get_context(context):
    """Dashboard page (login required)"""
    if frappe.session.user == 'Guest':
        frappe.throw('Please login to continue', frappe.PermissionError)

    context.user_data = get_user_dashboard_data()

    return context
```

### Role-Based Access

```python
def get_context(context):
    """Admin-only page"""
    if 'System Manager' not in frappe.get_roles():
        frappe.throw('Access denied', frappe.PermissionError)

    context.admin_data = get_admin_data()

    return context
```

## API Endpoints

### Public API

```python
# my_app/www/api/products.py
import frappe

@frappe.whitelist(allow_guest=True)
def get_products(category=None):
    """Public API endpoint"""
    filters = {'show_in_website': 1}

    if category:
        filters['item_group'] = category

    products = frappe.get_all(
        'Item',
        filters=filters,
        fields=['name', 'item_name', 'description', 'standard_rate', 'image']
    )

    return {'products': products}
```

**Access:** `GET https://your-site.com/api/products?category=Electronics`

### Form Submission

```python
# my_app/www/api/contact.py
import frappe

@frappe.whitelist(allow_guest=True)
def submit_contact(name, email, message):
    """Contact form submission"""
    # Validate
    frappe.utils.validate_email_address(email, throw=True)

    # Create lead
    lead = frappe.get_doc({
        'doctype': 'Lead',
        'lead_name': name,
        'email_id': email,
        'notes': message,
        'source': 'Website'
    })
    lead.insert(ignore_permissions=True)

    # Send email notification
    frappe.sendmail(
        recipients=['sales@company.com'],
        subject='New Contact Form Submission',
        message=f'Name: {name}<br>Email: {email}<br>Message: {message}'
    )

    return {'success': True}
```

## Templates

### Base Template

```html
<!-- my_app/templates/base.html -->
<!DOCTYPE html>
<html>
<head>
    <title>{% block title %}{{ title }}{% endblock %}</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    {% block head_include %}{% endblock %}
</head>
<body>
    {% include "templates/includes/navbar.html" %}

    <main>
        {% block content %}{% endblock %}
    </main>

    {% include "templates/includes/footer.html" %}

    {% block script %}{% endblock %}
</body>
</html>
```

### Page Template

```html
<!-- my_app/www/products.html -->
{% extends "templates/base.html" %}

{% block title %}Products{% endblock %}

{% block content %}
<div class="container">
    <h1>Our Products</h1>

    <div class="product-grid">
        {% for product in products %}
        <div class="product-card">
            <img src="{{ product.image }}">
            <h3>{{ product.item_name }}</h3>
            <p>{{ frappe.utils.fmt_money(product.standard_rate) }}</p>
        </div>
        {% endfor %}
    </div>
</div>
{% endblock %}
```

## Caching

### Page Cache

```python
def get_context(context):
    """Cached page"""
    context.no_cache = 0  # Enable cache (default)
    context.cache_key = 'products_page'

    if frappe.cache().get_value(context.cache_key):
        return frappe.cache().get_value(context.cache_key)

    # Generate page data
    context.products = frappe.get_all('Item', filters={'show_in_website': 1})

    # Cache for 1 hour
    frappe.cache().set_value(context.cache_key, context, expires_in_sec=3600)

    return context
```

### Disable Cache

```python
def get_context(context):
    """No caching for dynamic pages"""
    context.no_cache = 1
    return context
```

## Sitemap

### Generate Sitemap

```python
# hooks.py
website_route_rules = [
    # Auto-generate sitemap for DocTypes
    {"from_route": "/products/<name>", "to_route": "/templates/product_detail.html"}
]

def get_website_context(context):
    """Add to sitemap"""
    context.website_sitemap = frappe.get_all(
        'Item',
        filters={'show_in_website': 1},
        fields=['name', 'modified']
    )
    return context
```

**Sitemap URL:** `https://your-site.com/sitemap.xml`

## Common Patterns

### Product Catalog

```python
# www/products/index.py
def get_context(context):
    context.products = frappe.get_all(
        'Item',
        filters={'show_in_website': 1},
        fields=['name', 'item_name', 'description', 'standard_rate', 'image', 'item_group']
    )

    context.categories = frappe.get_all('Item Group', pluck='name')

    return context
```

### Blog

```python
# www/blog/index.py
def get_context(context):
    context.blogs = frappe.get_all(
        'Blog Post',
        filters={'published': 1},
        fields=['name', 'title', 'blog_intro', 'published_on', 'blogger'],
        order_by='published_on desc',
        limit=10
    )

    return context
```

### FAQ Page

```python
# www/faq.py
def get_context(context):
    context.faqs = frappe.get_all(
        'FAQ',
        filters={'published': 1},
        fields=['question', 'answer'],
        order_by='idx'
    )

    return context
```

## Key Rules

- ✅ Use web pages for static content
- ✅ Use web forms for data capture
- ✅ Enable portals for customer/supplier access
- ✅ Set SEO metadata for all pages
- ✅ Check permissions for protected pages
- ✅ Cache static pages for performance
- ✅ Use route rules for clean URLs
- ✅ Validate all form submissions
- ✅ Use templates for consistent layout
- ✅ Test on mobile devices
- ❌ Don't skip permission checks
- ❌ Don't expose sensitive data without auth
- ❌ Don't skip input validation on forms
