# Copyright (c) {{year}}, {{company}} and contributors
# For license information, please see license.txt

import frappe
from frappe.model.document import Document
from frappe.utils import flt, getdate, now

class {{DocTypeName}}(Document):
    """
    {{DocTypeName}} controller
    Handles business logic for {{doctype_name}}
    """

    def validate(self):
        """
        Validation hook - runs before save
        Use for: Data validation, calculations, business rules
        """
        self.validate_mandatory_fields()
        self.calculate_totals()
        self.validate_business_rules()

    def validate_mandatory_fields(self):
        """Validate required fields beyond DocType definition"""
        if not self.field_name:
            frappe.throw("Field Name is required")

    def calculate_totals(self):
        """Calculate dependent values"""
        self.total = sum(flt(item.amount) for item in self.items)
        self.tax = self.total * 0.1
        self.grand_total = self.total + self.tax

    def validate_business_rules(self):
        """Enforce business logic"""
        # Example: Check credit limit
        if self.customer and self.grand_total:
            credit_limit = frappe.db.get_value("Customer", self.customer, "credit_limit")
            if credit_limit and self.grand_total > credit_limit:
                frappe.throw(f"Grand Total exceeds credit limit of {credit_limit}")

    def before_save(self):
        """
        Runs before validate() and save
        Use for: Setting default values, auto-naming
        """
        pass

    def after_insert(self):
        """
        Runs after document is inserted (first save only)
        Use for: Creating linked documents, notifications
        """
        pass

    def on_update(self):
        """
        Runs after document is updated
        Use for: Updating related documents, logging changes
        """
        pass

    def on_submit(self):
        """
        Runs when document is submitted
        Use for: Creating accounting entries, updating stock
        """
        self.create_stock_entry()
        self.update_related_documents()

    def create_stock_entry(self):
        """Create stock entry on submit"""
        if not self.items:
            return

        # Example stock entry creation
        stock_entry = frappe.get_doc({
            "doctype": "Stock Entry",
            "stock_entry_type": "Material Receipt",
            "company": self.company,
            "items": [{
                "item_code": item.item_code,
                "qty": item.qty,
                "basic_rate": item.rate
            } for item in self.items]
        })
        stock_entry.insert()
        stock_entry.submit()

        frappe.msgprint(f"Stock Entry {stock_entry.name} created")

    def update_related_documents(self):
        """Update linked documents"""
        # Example: Update customer balance
        if self.customer:
            # Custom logic here
            pass

    def on_cancel(self):
        """
        Runs when document is cancelled
        Use for: Reversing on_submit actions
        """
        self.cancel_stock_entry()

    def cancel_stock_entry(self):
        """Cancel related stock entry"""
        # Find and cancel stock entries
        stock_entries = frappe.get_all("Stock Entry",
            filters={"custom_reference": self.name},
            pluck="name")

        for se_name in stock_entries:
            se = frappe.get_doc("Stock Entry", se_name)
            if se.docstatus == 1:
                se.cancel()

    def on_trash(self):
        """
        Runs before document is deleted
        Use for: Checking if deletion is allowed, cleaning up linked records
        """
        # Check if document can be deleted
        if self.docstatus == 1:
            frappe.throw("Cannot delete submitted document")

        # Check for dependent documents
        linked_docs = frappe.get_all("Linked DocType",
            filters={"reference_doctype": self.doctype, "reference_name": self.name})

        if linked_docs:
            frappe.throw("Cannot delete - linked documents exist")

    def before_cancel(self):
        """Runs before document is cancelled"""
        pass

    def on_update_after_submit(self):
        """Runs when submitted document is updated (if allow_update_after_submit is enabled)"""
        pass

# Whitelisted API methods (can be called from client)

@frappe.whitelist()
def get_customer_details(customer):
    """
    Get customer details for form population
    Args:
        customer: Customer ID
    Returns:
        dict: Customer details
    """
    # ALWAYS check permissions
    if not frappe.has_permission("Customer", "read", customer):
        frappe.throw("No permission to access customer", frappe.PermissionError)

    return frappe.db.get_value("Customer", customer,
        ["customer_name", "customer_group", "territory", "credit_limit"],
        as_dict=True)

@frappe.whitelist()
def calculate_discount(customer, total):
    """
    Calculate discount based on customer group
    Args:
        customer: Customer ID
        total: Order total
    Returns:
        float: Discount amount
    """
    # Validate inputs
    if not customer or not total:
        frappe.throw("Customer and total are required")

    # Get customer group
    customer_group = frappe.db.get_value("Customer", customer, "customer_group")

    # Calculate discount
    discount_rate = 0
    if customer_group == "Wholesale":
        discount_rate = 0.1  # 10% for wholesale
    elif customer_group == "Retail":
        discount_rate = 0.05  # 5% for retail

    return flt(total) * discount_rate
