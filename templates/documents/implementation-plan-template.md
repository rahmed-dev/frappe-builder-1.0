# Implementation Plan
**Project:** {{project_name}}
**App:** {{current_app}}
**Date:** {{date}}
**TSD Reference:** [Link to TSD]
**Planner:** {{user_name}}

## Plan Overview
**Total Phases:** [X]
**Estimated Duration:** [X weeks]
**Team Size:** [X developers]

## Dependency Graph
```
Phase 1 (Foundation)
    ↓
Phase 2 (Core Features) → Phase 3 (Advanced Features)
    ↓                           ↓
        Phase 4 (Integration & Testing)
```

---

## Phase 1: [Phase Name] - Foundation
**Duration:** [X days]
**Dependencies:** None
**Goal:** [What this phase achieves]

### User Configuration Tasks
- [ ] Create Custom Fields: [DocType name]
  - Field: `custom_field_1` (Data)
  - Field: `custom_field_2` (Link)
- [ ] Configure Workflow: [Workflow name]
- [ ] Set up Print Format: [Format name]
- [ ] Create Role: [Role name] with permissions

**Estimated Time:** [X hours]

### Developer Implementation Tasks
- [ ] Create DocType: [DocType name]
  - Fields: [List key fields]
  - Controllers: validate(), on_submit()
- [ ] Implement Server Script: [Script name]
  - Logic: [Brief description]
- [ ] Write Unit Tests: test_[doctype_name].py
- [ ] Database Migration: [If needed]

**Estimated Time:** [X days]

### Deliverables
- ✓ [DocType] created and functional
- ✓ [Workflow] configured
- ✓ Tests passing

### Testing Checklist
- [ ] Unit tests pass
- [ ] Can create/save/submit document
- [ ] Permissions working correctly
- [ ] Workflow transitions work

---

## Phase 2: [Phase Name] - Core Features
**Duration:** [X days]
**Dependencies:** Phase 1 complete
**Goal:** [What this phase achieves]

### User Configuration Tasks
[Repeat structure from Phase 1]

### Developer Implementation Tasks
[Repeat structure from Phase 1]

### Deliverables
[List deliverables]

### Testing Checklist
[List tests]

---

## Phase 3: [Phase Name]
[Repeat structure]

---

## Phase 4: [Phase Name]
[Repeat structure]

---

## Cross-Phase Considerations

### Data Migration
**Phase:** [X]
**What:** [Data being migrated]
**From:** [Source]
**To:** [Destination]
**Volume:** [X records]
**Strategy:** [Bulk import / Script / Manual]

### Integration Testing
**After Phase:** [X]
**Test:** [Integration scenario]
**Expected:** [Result]

### Performance Testing
**After Phase:** [X]
**Test:** [Load scenario]
**Threshold:** [Acceptable performance]

## Risk Management

### Phase 1 Risks
- **Risk:** [Description]
  **Impact:** High/Medium/Low
  **Mitigation:** [Plan]
  **Contingency:** [Fallback]

### Phase 2 Risks
[Repeat structure]

## Rollback Plan

### Phase 1 Rollback
**If fails:**
1. [Step to undo]
2. [Step to restore]

### Phase 2 Rollback
[Repeat structure]

## Definition of Done (Per Phase)

**A phase is complete when:**
- [ ] All user configuration tasks done
- [ ] All developer tasks implemented
- [ ] All tests passing (unit + integration)
- [ ] Code reviewed and approved
- [ ] Documentation updated
- [ ] Deployed to staging
- [ ] UAT sign-off received
- [ ] Production deployment successful

## Communication Plan

### Status Updates
- **Frequency:** Daily/Weekly
- **Channel:** [Email/Slack/Meeting]
- **Attendees:** [Stakeholders]

### Phase Completion
- **Notification:** [Who to notify]
- **Demo:** [When to demonstrate]
- **Sign-off:** [Who approves]

## Resource Allocation

| Phase | Developer | Duration | Parallel Work |
|-------|-----------|----------|---------------|
| Phase 1 | Dev A | 3 days | None |
| Phase 2 | Dev A + Dev B | 5 days | Can split tasks |
| Phase 3 | Dev A | 2 days | Phase 4 prep |
| Phase 4 | Dev A + Dev B | 4 days | Final integration |

## Timeline

```
Week 1: Phase 1 (Days 1-3) + Phase 2 Start (Days 4-5)
Week 2: Phase 2 Complete (Days 1-3) + Phase 3 (Days 4-5)
Week 3: Phase 4 (Days 1-4) + Buffer (Day 5)
```

## Success Criteria

**Project succeeds when:**
- [ ] All phases completed
- [ ] All tests passing
- [ ] Performance meets thresholds
- [ ] UAT approved
- [ ] Production stable for 1 week
- [ ] User training complete

## Approval
- **Project Manager:** [Name] - [Date]
- **Technical Lead:** [Name] - [Date]
- **Stakeholder:** [Name] - [Date]
