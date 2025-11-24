# ERPNext HR & Payroll Module

Employee lifecycle, attendance, leave, payroll, recruitment, training, performance.

## Core DocTypes

| Category | DocTypes | Purpose | Standard? |
|----------|----------|---------|-----------|
| **Employee Mgmt** | Employee, Employment Type, Branch, Department, Designation | Employee master data, organizational structure | ✅ |
| **Attendance** | Attendance, Shift Type, Shift Assignment | Daily attendance, shift management, auto-attendance | ✅ |
| **Leave** | Leave Type, Leave Application, Leave Allocation, Compensatory Leave | Leave requests, approvals, balance tracking | ✅ |
| **Payroll** | Salary Structure, Salary Structure Assignment, Salary Slip, Payroll Entry, Additional Salary | Pay components, monthly processing, one-time payments | ✅ |
| **Recruitment** | Job Opening, Job Applicant, Job Offer, Appointment Letter | Hiring workflow | ✅ |
| **Training/Appraisal** | Training Program/Event/Result, Appraisal | Employee development | ✅ |
| **Claims** | Expense Claim, Employee Advance | Reimbursements, advance payments | ✅ |

## Business Processes

### 1. Employee Onboarding
Job Opening → Job Applicant → Job Offer → Employee → Salary Structure Assignment → Leave Allocation → Shift Assignment

**Standard flow, add custom onboarding checklist if needed**

### 2. Attendance Processing
Attendance marked (manual/biometric/mobile) → Shift validation → Late/Early marking → Overtime calc → Leave without pay

**Standard with Shift Type config**

### 3. Payroll Processing
Payroll Entry → Salary Slips generated → Leave without pay auto-calc → Additional Salaries → Advance recovery → Bank entries → Payment

**Standard ERPNext flow**

### 4. Leave Request
Employee submits → Approval workflow → Balance checked → Approved/Rejected → Attendance auto-marked

**Workflow + Email Alerts**

## Configuration (No Code)

### HR Settings
| Setting | Options |
|---------|---------|
| Retirement Age | Years |
| Standard Working Hours | Hours/day |
| Encrypt Salary Slips | Yes/No |
| Email Salary Slip | Yes/No |
| Leave Approval Notification | Yes/No |

### Payroll Settings
| Setting | Options |
|---------|---------|
| Include holidays in working days | Yes/No |
| Payroll based on Attendance | Yes/No |
| Unmarked Attendance As | Present/Absent |
| Half Day Fraction | 0.5 typical |
| Tax calculation method | Standard/Custom |

## Customization Tiers

### Tier 1: Standard ✅
Employee mgmt, Attendance, Leave, Simple payroll (fixed), Expense claims

### Tier 2: Configuration ⚙️
Custom salary components, Approval workflows, Custom fields (employee ID, personal data), Shift patterns

### Tier 3: Scripts/Reports 🔨
Biometric integration, Complex overtime calc, Custom tax, Payroll reports, Self-service portal

### Tier 4: Custom App 🔨 (Rare)
Advanced biometric, Mobile attendance app, Complex incentives, Advanced rostering, Advanced performance mgmt

## Integration Points

| Module | Integration |
|--------|-------------|
| Accounting | Salary journal entries, expense claims |
| Projects | Timesheet → Project costing |
| Manufacturing | Shift → Job Card (employee assignment) |

## Standard Reports

1. Monthly Attendance Sheet - employee-wise
2. Salary Register - payroll summary
3. Bank Remittance Report - payment list
4. Employee Leave Balance - balances
5. Employee Information - master data
6. Recruitment Analytics - hiring funnel

## Solution Design Checklist

- [ ] Fixed or variable salary?
- [ ] Shift work? Rotating shifts?
- [ ] Biometric integration needed?
- [ ] Overtime calculation method?
- [ ] Tax calculation (standard/complex)?
- [ ] Leave encashment required?
- [ ] Loan/Advance management?
- [ ] Performance appraisal frequency?
- [ ] Training management needed?
- [ ] Employee self-service portal?

## Best Practices

1. **Shift Management** - Use Shift Type + Assignment, not custom
2. **Payroll** - Start simple, add complexity gradually
3. **Leave** - Configure Leave Types properly (encashment, carry forward)
4. **Attendance** - Auto-attendance via biometric preferred
5. **Approval Workflows** - Use ERPNext Workflow
6. **Tax** - Additional Salary for variable components
7. **Reporting** - Standard reports cover 80%

---

**Remember:** ERPNext HR covers standard HR. Configure shift types, salary structures, workflows before building custom.
