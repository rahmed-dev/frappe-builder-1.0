# Frappe-Architect Session Memories

## Current Session Context

**User:** {user_name}
**Current App:** {{current_app}}
**App Path:** {{app_path}}
**Docs Path:** {{docs_path}}
**BRD Path:** {{brd_path}}
**TSD Path:** {{tsd_path}}

---

## Current Project Design

**Project Name:** [Project being designed]
**Input BRD:** [BRD filename]
**Current TSD Status:** [Draft / In Progress / Complete]

---

## Tier Classification Summary

**Requirements Analyzed:** [Total count]

**Tier Breakdown:**
- Tier 1 (Standard): [X requirements] - [List]
- Tier 2 (Configure): [Y requirements] - [List]
- Tier 3 (Scripts): [Z requirements] - [List]
- Tier 4 (Custom): [W requirements] - [List]

---

## DocType Designs

### Standard DocTypes Being Extended:
- [DocType 1]: [Customizations planned]
- [DocType 2]: [Customizations planned]

### Custom DocTypes Being Created:
- [DocType 1]: [Purpose]
- [DocType 2]: [Purpose]

---

## Configuration Requirements

**Custom Fields Designed:**
- [DocType]: [Field list]

**Workflows Designed:**
- [DocType]: [States and transitions]

**Property Setters:**
- [DocType]: [Properties being set]

---

## Custom Development Scope

**Server Scripts Needed:**
- [Script 1]: [Purpose and trigger]
- [Script 2]: [Purpose and trigger]

**Client Scripts Needed:**
- [Script 1]: [Purpose and trigger]

**Script Reports:**
- [Report 1]: [Purpose]

**Custom Apps (if Tier 4):**
- [App name]: [Scope]

---

## UX/UI Designs

**Custom Buttons:**
- [DocType]: [Button list with actions]

**Dialogs:**
- [Dialog name]: [Purpose and fields]

**Dashboards:**
- [Dashboard name]: [Cards and KPIs]

---

## Integration Designs

**External Integrations:**
- [System 1] ↔ ERPNext: [Integration type and data flow]
- [System 2] ↔ ERPNext: [Integration type and data flow]

**API Endpoints Designed:**
- [Endpoint 1]: [Method and purpose]
- [Endpoint 2]: [Method and purpose]

---

## Performance Planning

**Indexes Recommended:**
- [DocType].[field]: [Reason]

**Background Jobs:**
- [Job name]: [Frequency and purpose]

**Caching Strategy:**
- [What to cache]: [Duration and invalidation]

---

## Design Decisions Made

**Key Architectural Decisions:**
1. [Decision 1]: [Rationale]
2. [Decision 2]: [Rationale]
3. [Decision 3]: [Rationale]

**Trade-offs Considered:**
- [Trade-off 1]: [Chose X over Y because...]
- [Trade-off 2]: [Chose X over Y because...]

---

## Upgrade Safety Assessment

**Risk Level:** [High/Medium/Low]

**Upgrade Considerations:**
- [Consideration 1]
- [Consideration 2]

**Testing Required After Upgrades:**
- [Test 1]
- [Test 2]

---

## Pending Technical Clarifications

- [ ] [Clarification 1]
- [ ] [Clarification 2]
- [ ] [Clarification 3]

---

## User Patterns & Preferences

**Design Style:**
[User's preference - minimal custom, aggressive custom, etc.]

**Technical Level:**
[User's Frappe expertise]

**Risk Tolerance:**
[User's comfort with Tier 4 custom development]

---

## Session Notes

**Complex Design Challenges:**
[Any particularly complex requirements and how they were addressed]

**Lessons Learned:**
[Patterns that worked well for this project]

---

## TSD Status

**Current TSD:** [Filename if exists]
**Location:** {{tsd_path}}/[filename]
**Last Updated:** [Date]
**Status:** [Draft / Complete / Handed off to Planner]

---

## Session Variables

```
{{current_app}} = [app name]
{{app_path}} = {project-root}/apps/{{current_app}}
{{docs_path}} = {{app_path}}/docs
{{brd_path}} = {{docs_path}}/brd
{{tsd_path}} = {{docs_path}}/tsd
```

---

**Last Updated:** [Date]

**Notes:** Track technical design decisions, tier classifications, and TSD creation progress.
