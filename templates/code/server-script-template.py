# Server Script Template
# DocType: {{DocType}}
# Trigger: {{trigger_event}}
# Description: {{description}}

import frappe
from frappe import _
from frappe.utils import flt, cint, getdate, now, add_days

# Server Script Types:
# 1. DocType Event: validate, before_save, after_insert, on_submit, on_cancel, on_trash
# 2. API: @frappe.whitelist() method accessible from client
# 3. Scheduled: Runs on schedule (daily, hourly, etc.)
# 4. Permission Query: Custom permission logic

# ============================================================================
# DOCTYPE EVENT SCRIPT
# ============================================================================

def validate(doc, method):
    """
    Runs before document is saved
    Use for: Validation, calculations, setting values
    """
    validate_required_fields(doc)
    calculate_totals(doc)
    apply_business_rules(doc)

def validate_required_fields(doc):
    """Custom validation beyond DocType definition"""
    if doc.field_name and not doc.related_field:
        frappe.throw(_("Related Field is required when Field Name is set"))

def calculate_totals(doc):
    """Calculate dependent values"""
    doc.total = sum(flt(item.amount) for item in doc.get("items", []))
    doc.tax = doc.total * 0.1
    doc.grand_total = doc.total + doc.tax

def apply_business_rules(doc):
    """Business logic enforcement"""
    # Example: Credit limit check
    if doc.customer and doc.grand_total:
        credit_limit = frappe.db.get_value("Customer", doc.customer, "credit_limit")
        outstanding = get_customer_outstanding(doc.customer)

        if credit_limit and (outstanding + doc.grand_total) > credit_limit:
            frappe.throw(_(f"Total outstanding will exceed credit limit of {credit_limit}"))

def get_customer_outstanding(customer):
    """Helper: Get customer's current outstanding amount"""
    result = frappe.db.sql("""
        SELECT SUM(outstanding_amount)
        FROM `tabSales Invoice`
        WHERE customer=%s AND docstatus=1 AND outstanding_amount > 0
    """, (customer,))
    return flt(result[0][0]) if result else 0

# ============================================================================

def before_save(doc, method):
    """Runs before validate and save"""
    # Set default values
    if not doc.date:
        doc.date = getdate()

def after_insert(doc, method):
    """Runs after document is inserted (first save)"""
    # Send notification
    send_notification(doc)

def send_notification(doc):
    """Helper: Send email notification"""
    recipients = frappe.db.get_all("User",
        filters={"role": "Sales Manager"},
        pluck="email")

    if recipients:
        frappe.sendmail(
            recipients=recipients,
            subject=f"New {doc.doctype}: {doc.name}",
            message=f"A new {doc.doctype} has been created by {frappe.session.user}"
        )

def on_submit(doc, method):
    """Runs when document is submitted"""
    create_journal_entry(doc)
    update_stock(doc)

def create_journal_entry(doc):
    """Helper: Create accounting entry"""
    # Example journal entry creation
    je = frappe.get_doc({
        "doctype": "Journal Entry",
        "voucher_type": "Journal Entry",
        "posting_date": doc.date,
        "accounts": [
            {
                "account": doc.debit_account,
                "debit_in_account_currency": doc.amount
            },
            {
                "account": doc.credit_account,
                "credit_in_account_currency": doc.amount
            }
        ]
    })
    je.insert()
    je.submit()

def update_stock(doc):
    """Helper: Update stock balances"""
    for item in doc.get("items", []):
        # Update bin qty
        frappe.db.sql("""
            UPDATE `tabBin`
            SET actual_qty = actual_qty + %s
            WHERE item_code=%s AND warehouse=%s
        """, (item.qty, item.item_code, item.warehouse))

def on_cancel(doc, method):
    """Runs when document is cancelled"""
    cancel_linked_documents(doc)

def cancel_linked_documents(doc):
    """Helper: Cancel related documents"""
    # Find and cancel journal entries
    je_list = frappe.get_all("Journal Entry",
        filters={"custom_reference": doc.name, "docstatus": 1},
        pluck="name")

    for je_name in je_list:
        je = frappe.get_doc("Journal Entry", je_name)
        je.cancel()

# ============================================================================
# API METHODS (Called from client)
# ============================================================================

@frappe.whitelist()
def get_filtered_data(doctype, filters):
    """
    Get filtered records
    Args:
        doctype: DocType name
        filters: dict of filters
    Returns:
        list: Filtered records
    """
    # ALWAYS check permissions
    if not frappe.has_permission(doctype, "read"):
        frappe.throw(_("No permission"), frappe.PermissionError)

    # Parse filters if string
    if isinstance(filters, str):
        import json
        filters = json.loads(filters)

    return frappe.get_all(doctype,
        filters=filters,
        fields=["name", "customer", "total", "status"])

@frappe.whitelist()
def calculate_discount(customer, total):
    """
    Calculate discount based on customer group
    Args:
        customer: Customer ID
        total: Order total
    Returns:
        dict: {discount_rate, discount_amount}
    """
    # Validate inputs
    if not customer or not total:
        frappe.throw(_("Customer and total are required"))

    # Get customer group
    customer_group = frappe.db.get_value("Customer", customer, "customer_group")

    # Discount logic
    discount_rate = 0
    if customer_group == "Wholesale":
        discount_rate = 0.1  # 10%
    elif customer_group == "Retail":
        discount_rate = 0.05  # 5%

    discount_amount = flt(total) * discount_rate

    return {
        "discount_rate": discount_rate,
        "discount_amount": discount_amount
    }

# ============================================================================
# SCHEDULED SCRIPTS (Run on schedule)
# ============================================================================

def daily_cleanup():
    """
    Runs daily
    Use for: Cleanup, maintenance, daily reports
    """
    # Delete old draft documents
    frappe.db.sql("""
        DELETE FROM `tab{{DocType}}`
        WHERE docstatus=0
        AND creation < DATE_SUB(NOW(), INTERVAL 30 DAY)
    """)

    frappe.db.commit()

def send_reminder_emails():
    """
    Runs hourly
    Use for: Reminders, alerts
    """
    # Find pending documents
    pending_docs = frappe.get_all("{{DocType}}",
        filters={"status": "Pending", "reminder_sent": 0},
        fields=["name", "customer", "owner"])

    for doc in pending_docs:
        # Send reminder
        frappe.sendmail(
            recipients=[doc.owner],
            subject=f"Reminder: {doc.name} is pending",
            message=f"Document {doc.name} for {doc.customer} is still pending approval"
        )

        # Mark reminder as sent
        frappe.db.set_value("{{DocType}}", doc.name, "reminder_sent", 1)

# ============================================================================
# PERMISSION QUERY (Custom permission logic)
# ============================================================================

def custom_permission_query(user):
    """
    Custom permission query
    Restricts records based on user role/territory/etc.

    Args:
        user: User email
    Returns:
        str: SQL condition to filter records
    """
    if "System Manager" in frappe.get_roles(user):
        # System Manager sees everything
        return ""

    if "Sales Manager" in frappe.get_roles(user):
        # Sales Manager sees their territory
        territory = frappe.db.get_value("User", user, "territory")
        if territory:
            return f"`territory` = '{territory}'"

    # Default: User sees only their own records
    return f"`owner` = '{user}'"

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

def log_activity(doc, action):
    """Helper: Log activity to custom table"""
    frappe.get_doc({
        "doctype": "Activity Log",
        "reference_doctype": doc.doctype,
        "reference_name": doc.name,
        "action": action,
        "user": frappe.session.user,
        "timestamp": now()
    }).insert(ignore_permissions=True)

def validate_date_range(from_date, to_date):
    """Helper: Validate date range"""
    from_date = getdate(from_date)
    to_date = getdate(to_date)

    if from_date > to_date:
        frappe.throw(_("From Date cannot be after To Date"))

    # Max 1 year range
    if (to_date - from_date).days > 365:
        frappe.throw(_("Date range cannot exceed 1 year"))

    return from_date, to_date
