# Technical Specification Document
**Project:** {{project_name}} | **App:** {{app}} | **Date:** {{date}} | **BRD:** [link] | **Architect:** {{user_name}}

## Overview
- Approach (2-3 sentences)
- Tier summary: Std/Config/Scripts/Custom with brief notes/effort

## Design
### New DocTypes
- [DocType] — purpose; fields table (Field | Type | Req? | Notes); links; permissions; workflow states/transitions.

### Customizations (existing DocTypes)
- Fields added; scripts (server/client) with triggers and logic summary; property setters.

### Scripts/APIs
- Server scripts (doctype/event, logic/pseudocode, perms)
- Client scripts (events, UI behavior)
- APIs (endpoint/method/auth/params/response shape)

### UI/Reports/Dashboards
- Forms changes (sections/fields)
- Reports table (Name | Type | Filters | Output)
- Dashboards/dialogs (purpose)

### Workflows
- Name, DocType, states, transitions, roles/actions

### Integration Points
- External systems, method, frequency, data flow

### Security & Performance
- Role/access highlights; validation rules
- Indexes/cache/background jobs

### Testing
- Unit/integration/perf outlines

### Deployment
- Migrations/build/cache steps; rollback note

### Risks/Assumptions
- Risks + mitigations; key assumptions

## Approval
- Technical Lead: [Name/Date]
- System Manager: [Name/Date]
