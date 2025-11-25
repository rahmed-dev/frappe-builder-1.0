# Plan: Custom Manufacturing Enhancement
App: custom_manufacturing | BRD: apps/custom_manufacturing/docs/brd-phase3.md | TSD: apps/custom_manufacturing/docs/tsd-phase3.md | Date: 2025-11-25
Complexity: Medium | Token Budget: 5-10k

## Project Context
**Goal:** Enhance manufacturing workflow with custom sales orders, production planning, and analytics
**Users:** Production managers, sales team, operations staff
**Success:** Complete order-to-production pipeline with reporting dashboard

---

## Phase 1: Order Processing

### User Tasks
- [ ] u1: DocType "Custom Sales Order" (customer, items[item,qty,rate], total) | TSD: §2.1
- [ ] u2: Field on Sales Order: custom_priority (Select: High/Medium/Low) | TSD: §2.2
- [ ] u3: Workflow: Custom Sales Order (Draft→Approved→In Production→Delivered) | TSD: §2.3

### Dev Tasks
- [ ] d4: Validation - total must be > 0 | TSD: §3.1.1
- [ ] d5: Validation - items table must have >= 1 row | TSD: §3.1.2
- [ ] d6: Calc - total from items (sum of qty * rate) | TSD: §3.2.1
- [ ] d7: Client - auto-fetch item rate on item select | TSD: §3.3.1

**Complete when:** Can create, validate, and submit Custom Sales Order
**Acceptance:** All validations working, calculations accurate, workflow functional

---

## Phase 2: Production Planning

### Dev Tasks
- [ ] d8: Server - create Production Order on approval | TSD: §4.1.1
- [ ] d9: Report - Daily production schedule | TSD: §4.2.1
- [ ] d10: Dashboard - Orders by priority + status | TSD: §4.3.1

**Complete when:** Production orders auto-created, reports working
**Acceptance:** Orders trigger correctly, report shows accurate data, dashboard displays metrics

---

## Phase 3: Analytics

### Dev Tasks
- [ ] d11: Report - Monthly order value by customer | TSD: §5.1.1
- [ ] d12: Background - send daily summary email | TSD: §5.2.1
- [ ] d13: Dashboard - Revenue trends chart | TSD: §5.3.1

**Complete when:** All analytics functional, email sending
**Acceptance:** Reports accurate, emails delivered daily, charts display trends

---

## Dependencies

| Task | Needs | Why | Blocker Risk |
|------|-------|-----|--------------|
| d6 | u1 | Items table must exist | High |
| d7 | u1, d6 | Need form + calc logic first | High |
| d8 | u3 | Workflow must exist to trigger | High |
| d9 | d8 | Need production orders to report on | Medium |
| d12 | d8, d9 | Need data before sending emails | Low |

---

## Task Ranges

| Specialist | Phase 1 | Phase 2 | Phase 3 | Total Tasks |
|------------|---------|---------|---------|-------------|
| User | u1:u3 | - | - | 3 |
| Dev | d4:d7 | d8:d10 | d11:d13 | 10 |

---

## TSD Section Mapping

**Format:** Task ID → TSD Section Reference

| Task | TSD Section | Topic | Est. Tokens |
|------|-------------|-------|-------------|
| d4 | §3.1.1 | Total validation rule | ~120 |
| d5 | §3.1.2 | Items table validation | ~100 |
| d6 | §3.2.1 | Total calculation formula | ~150 |
| d7 | §3.3.1 | Item rate auto-fetch logic | ~180 |
| d8 | §4.1.1 | Production Order creation trigger | ~250 |
| d9 | §4.2.1 | Production schedule report spec | ~200 |
| d10 | §4.3.1 | Dashboard metrics definition | ~180 |
| d11 | §5.1.1 | Monthly value report query | ~220 |
| d12 | §5.2.1 | Email summary format | ~150 |
| d13 | §5.3.1 | Revenue chart configuration | ~160 |

**Usage:** Dev loads only relevant TSD section per task (not entire TSD)

---

## Critical Decisions

| Decision | Options Considered | Chosen | Rationale |
|----------|-------------------|--------|-----------|
| Order workflow states | Simple (2) vs Detailed (4) | 4 states | Better production tracking |
| Priority field location | Sales Order vs separate DocType | Sales Order field | Simpler, less overhead |
| Email frequency | Realtime vs Daily vs Weekly | Daily | Balance between info and spam |

---

## Risk Mitigation

| Risk | Impact | Mitigation | Owner |
|------|--------|------------|-------|
| Email spam concerns | Medium | Daily digest only, opt-in | Dev |
| Production Order duplication | High | Unique constraint + validation | Dev |
| Report performance on large data | Medium | Index key fields, limit date range | Dev |

---

## Token Budget Tracking

**Plan Complexity:** Medium

| Component | Simple | Medium | Complex |
|-----------|--------|--------|---------|
| Base structure | <1k | <2k | <3k |
| Task definitions | <2k | <3k | <5k |
| Dependencies + mapping | <1k | <2k | <3k |
| Decisions + risks | <1k | <2k | <4k |
| **Total Target** | **<5k** | **<9k** | **<15k** |

---

## Notes
- Dev works autonomously through ranges
- Updates checkboxes as completes
- Returns to Nexus when range complete or blocked
- Uses `/context` to monitor token usage
- Restarts session if context >30k tokens
