# Website & E-Commerce

> Website module capabilities and e-commerce configuration in ERPNext.

## Website Module Features

### Core Capabilities

| Feature | Purpose | Standard? |
|---------|---------|-----------|
| **Web Page** | Static/dynamic pages | ✅ |
| **Blog Post** | Blog articles | ✅ |
| **Web Form** | Public forms (Contact, Lead) | ✅ |
| **Website Settings** | Configuration, navbar, footer | ✅ |
| **Portal Settings** | Customer/supplier portal | ✅ |
| **Website Theme** | Custom themes | ✅ |
| **Web Template** | Reusable templates | ✅ |

## E-Commerce Setup

### Shopping Cart Configuration

```
E-Commerce Settings:
- Enable Shopping Cart: Yes
- Company: Select company
- Price List: Standard Selling
- Default Customer Group: All Customer Groups
- Quotation Series: QTN-WEB-
```

### Item Configuration

```
Item:
- Show in Website: Yes
- Website Warehouse: Main Store
- Website Item Groups: Electronics, Accessories
- Website Image: Upload product image
- Website Description: Product details (HTML)
- Website Specifications: Table of specs
```

### Item Group Website

```
Item Group:
- Show in Website: Yes
- Route: /products/electronics
- Weightage: 10 (sort order)
- Slideshow: Homepage banner
- Description: Category description
```

## Shopping Cart Flow

```
Browse → Add to Cart → View Cart → Checkout → Payment → Order Confirmation
```

### Customer Journey

1. **Browse Products** - Item Group pages with filters
2. **Product Detail** - Item page with images, specs, reviews
3. **Add to Cart** - Quotation created in draft
4. **Cart Management** - Update quantities, apply coupons
5. **Checkout** - Address, shipping method selection
6. **Payment** - Payment gateway integration
7. **Order** - Quotation converted to Sales Order
8. **Confirmation** - Email with order details

## Item Display

### Product Page Elements

```html
- Product images (gallery)
- Product name and SKU
- Price (with/without tax)
- Stock availability
- Product description
- Specifications table
- Customer reviews
- Add to cart button
- Related products
```

### Configuration

```python
# Item Website Settings
{
    'show_in_website': 1,
    'website_image': '/files/product.jpg',
    'website_warehouse': 'Stores - C',
    'weightage': 5,  # Sort priority
    'slideshow': 'Product Slideshow',
    'website_item_groups': [
        {'item_group': 'Electronics'},
        {'item_group': 'Laptops'}
    ],
    'website_specifications': [
        {'label': 'Brand', 'description': 'Dell'},
        {'label': 'Warranty', 'description': '1 Year'}
    ]
}
```

## Payment Gateway Integration

### Supported Gateways

| Gateway | Integration | Setup |
|---------|-------------|-------|
| **Razorpay** | Built-in | E-Commerce Settings |
| **PayPal** | Built-in | Payment Gateway setup |
| **Stripe** | Built-in | API credentials |
| **Braintree** | Built-in | API credentials |
| **Paytm** | Built-in | Merchant credentials |

### Payment Gateway Setup

```
Payment Gateway: Razorpay
- Gateway Name: Razorpay
- Gateway Settings: Razorpay Settings
- Payment Account: Debtors - C
- Payment Request: Enable
- Supported Payment Methods: Card, UPI, Wallet
```

### Configuration

```python
# Razorpay Settings
{
    'api_key': 'rzp_test_xxxxx',
    'api_secret': '••••••••',
    'success_url': '/payment-success',
    'cancel_url': '/payment-cancel'
}
```

## Shipping Rules

### Configure Shipping

```
Shipping Rule: Standard Shipping
- Shipping Rule Type: Selling
- Label: Standard Delivery (3-5 days)
- Calculate Based On: Net Weight / Net Total

Shipping Rule Conditions:
- From Value: 0, To Value: 50, Shipping Amount: 10
- From Value: 50, To Value: 100, Shipping Amount: 5
- From Value: 100, To Value: 999999, Shipping Amount: 0

Shipping Rule Countries:
- Country: India, Shipping Amount: 10
- Country: United States, Shipping Amount: 25
```

### Apply at Checkout

```
Customer selects:
1. Shipping address
2. Shipping method (Standard/Express)
3. Charges calculated automatically
4. Added to quotation total
```

## Coupons & Promotions

### Pricing Rule for Discount

```
Pricing Rule: SUMMER2025
- Apply On: Grand Total
- Coupon Code Based: Yes
- Coupon Code: SUMMER2025
- Discount Type: Percentage
- Discount Percentage: 10
- Valid From: 2025-06-01
- Valid Upto: 2025-08-31
- Max Discount Amount: 1000

Conditions:
- Min Qty: 1
- Min Amount: 500
- Customer Group: All
- Item Groups: Electronics, Accessories
```

### Customer Applies Coupon

```
Cart → Apply Coupon → SUMMER2025 → Discount applied
```

## Customer Portal

### Portal Features

```
Customer Portal:
- My Orders (Sales Orders)
- My Invoices (Sales Invoices)
- My Shipments (Delivery Notes)
- My Quotations
- My Addresses
- My Profile
- Track Order Status
```

### Portal Configuration

```
Portal Settings:
- Default Portal Home Page: /me
- Default Role: Customer
- Hide Standard Menu: No
- Custom Menu Items:
  - Orders → /orders
  - Invoices → /invoices
  - Addresses → /addresses
```

## Website Customization

### Website Settings

```
Website Settings:
- Banner HTML: Custom HTML banner
- Brand HTML: Logo and name
- Navbar Items:
  - Products → /products
  - About → /about
  - Contact → /contact

Footer Items:
- Company Info
- Contact Details
- Social Links
- Copyright

Head HTML: Analytics scripts
```

### Custom Theme

```
Website Theme:
- Theme Name: My Store Theme
- Custom SCSS:
  $primary-color: #007bff;
  $font-family: 'Open Sans';
- Custom JS: Custom scripts
- Custom CSS: Additional styles
```

## Web Forms

### Lead Capture Form

```
Web Form: Contact Us
- DocType: Lead
- Published: Yes
- Route: /contact
- Success Message: "Thank you! We'll contact you soon."
- Success URL: /thank-you

Fields:
- First Name (required)
- Last Name
- Email (required, email validation)
- Phone
- Message (Text Editor)
- Source (hidden, default: Website)
```

### Customer Registration

```
Web Form: Register
- DocType: Customer
- Allow Edit: No
- Login Required: No
- Anonymous: Yes

Fields:
- Customer Name (required)
- Email (required)
- Phone
- Territory (hidden, default)
- Customer Group (hidden, default: Individual)

On Submit:
- Create User account
- Send welcome email
- Assign Customer role
```

## Programmatic Customization

### Custom Product Page

```python
# www/product/[product_id].py
def get_context(context):
    """Custom product page"""
    product_id = frappe.form_dict.product_id

    item = frappe.get_doc('Item', product_id)

    if not item.show_in_website:
        frappe.throw('Product not found', frappe.DoesNotExistError)

    context.item = item
    context.related_products = get_related_products(item.item_group)
    context.reviews = get_product_reviews(product_id)

    return context

def get_related_products(item_group, limit=4):
    """Get related products"""
    return frappe.get_all('Item', {
        'show_in_website': 1,
        'item_group': item_group
    }, fields=['name', 'item_name', 'website_image', 'standard_rate'], limit=limit)
```

### Custom Cart Logic

```python
@frappe.whitelist()
def add_to_cart(item_code, qty=1):
    """Custom add to cart"""
    quotation = get_shopping_cart_quotation()

    quotation.append('items', {
        'item_code': item_code,
        'qty': qty
    })

    quotation.save(ignore_permissions=True)

    return {'cart_count': len(quotation.items)}
```

### Custom Checkout

```python
@frappe.whitelist()
def apply_coupon(quotation_name, coupon_code):
    """Apply coupon to quotation"""
    quotation = frappe.get_doc('Quotation', quotation_name)

    # Validate coupon
    pricing_rule = frappe.get_doc('Pricing Rule', {'coupon_code': coupon_code})

    if not pricing_rule.validate_coupon():
        frappe.throw('Invalid or expired coupon')

    # Apply discount
    quotation.apply_pricing_rule()
    quotation.save()

    return {'success': True, 'grand_total': quotation.grand_total}
```

## SEO Configuration

### Item SEO

```
Item:
- Meta Title: Best Laptop 2025 - Dell XPS 15
- Meta Description: High-performance laptop with...
- Meta Keywords: laptop, dell, xps, gaming
- Meta Image: /files/laptop-og.jpg
```

### Website Route

```
Item Group:
- Route: /products/laptops
- Meta Title: Laptops - Shop Online
- Meta Description: Buy laptops online...

Item:
- Route: /products/laptops/dell-xps-15
- Auto-generated from item name
```

## Integration Points

### Website ↔ E-Commerce

| Integration | How |
|-------------|-----|
| Browse → Cart | Item page → Add to cart → Quotation |
| Cart → Order | Quotation → Place order → Sales Order |
| Order → Invoice | Sales Order → Submit → Sales Invoice |
| Invoice → Payment | Payment gateway → Payment Entry |

### E-Commerce ↔ Inventory

| Integration | How |
|-------------|-----|
| Stock Check | Item page shows stock from Website Warehouse |
| Stock Update | Sales Order → Stock reserved |
| Delivery | Delivery Note → Stock reduced |

## Analytics

### Track Events

```javascript
// Google Analytics
frappe.call({
    method: 'my_app.track_event',
    args: {
        category: 'E-commerce',
        action: 'Add to Cart',
        label: item_code
    }
});
```

### Reports

**Standard:**
- Website Analytics (page views, sessions)
- E-Commerce Analytics (revenue, conversions)
- Top Selling Items
- Cart Abandonment

## Common Patterns

### Product Catalog

```python
# www/products/index.py
def get_context(context):
    filters = frappe.form_dict

    context.items = frappe.get_all('Item', {
        'show_in_website': 1,
        'item_group': filters.get('category') if filters.get('category') else ['!=', '']
    }, fields=['name', 'item_name', 'website_image', 'standard_rate'])

    context.categories = frappe.get_all('Item Group',
        filters={'show_in_website': 1}, pluck='name')

    return context
```

### Customer Reviews

```python
# Custom DocType: Product Review
def add_review(item_code, rating, review_text):
    """Add product review"""
    doc = frappe.get_doc({
        'doctype': 'Product Review',
        'item': item_code,
        'customer': get_current_customer(),
        'rating': rating,
        'review': review_text
    })
    doc.insert(ignore_permissions=True)

    # Update item average rating
    update_item_rating(item_code)
```

## Key Rules

- ✅ Enable Shopping Cart in E-Commerce Settings
- ✅ Configure Website Warehouse for stock display
- ✅ Set up Payment Gateway before going live
- ✅ Configure Shipping Rules for delivery charges
- ✅ Use Pricing Rules for coupons/discounts
- ✅ Enable Portal for customer self-service
- ✅ Set SEO metadata for all products
- ✅ Test checkout flow end-to-end
- ✅ Configure email templates for order confirmation
- ✅ Set up SSL certificate for secure checkout
- ❌ Don't skip payment gateway testing
- ❌ Don't expose internal prices without tax
- ❌ Don't skip stock validation in checkout
