# Frappe-Planner Session Memories

## Current Session Context

**User:** {user_name}
**Current App:** {{current_app}}
**App Path:** {{app_path}}
**Docs Path:** {{docs_path}}
**Implementation Plans Path:** {{implementation_plans_path}}

---

## Current Project Planning

**Project Name:** [Project being planned]
**Input TSD:** [TSD filename from Frappe-Architect]
**Implementation Plan Status:** [Not Started / In Progress / Complete / Handed to Frappe-Dev]

---

## Dependency Analysis Summary

**Total Features Analyzed:** [Count]

### Foundation Features (No Dependencies)
- [Feature 1]: [Why foundation]
- [Feature 2]: [Why foundation]

### Critical Path Features
- [Feature X]: [Why critical - longest chain / bottleneck / blocks others]
- [Feature Y]: [Why critical]

### Dependency Chains Identified
**Chain 1: [Name]**
```
[Feature A] → [Feature B] → [Feature C]
Length: X steps
Critical: YES/NO
```

**Chain 2: [Name]**
```
[...]
```

### Blocking Dependencies
| Feature | Blocked By | Type | Impact |
|---------|-----------|------|---------|
| [Feature B] | [Feature A] | Hard Blocker | [Description] |

---

## User vs Developer Task Division

### User Tasks Summary
**Total User Tasks:** [Count]

**Custom DocTypes to Create:**
- [DocType 1]: [Purpose]
- [DocType 2]: [Purpose]

**Custom Fields to Add:**
- [Target DocType]: [Field list]

**Workflows to Configure:**
- [DocType]: [States summary]

**Other Configurations:**
- [Print Formats / Permissions / etc.]

### Developer Tasks Summary
**Total Developer Tasks:** [Count]

**Server Scripts Needed:**
- [Script 1]: [Trigger + purpose]

**Client Scripts Needed:**
- [Script 1]: [DocType + purpose]

**Script Reports Needed:**
- [Report 1]: [Purpose]

**APIs/Integrations:**
- [Integration 1]: [System + type]

**Background Jobs:**
- [Job 1]: [Frequency + purpose]

---

## Phased Implementation Plan

### Phase 1: Foundation & Core Workflow
**Goal:** [What users can do after Phase 1]

**User Tasks (Phase 1):** [Count]
**Developer Tasks (Phase 1):** [Count]
**Complexity:** [Simple / Medium / Complex]

**Key Features:**
- [Feature 1]
- [Feature 2]

**Completion Criteria:**
- Users can: [Capability 1]
- Technical: [Milestone 1]

### Phase 2: Extended Functionality
**Goal:** [What users can do after Phase 2]

**User Tasks (Phase 2):** [Count]
**Developer Tasks (Phase 2):** [Count]
**Complexity:** [Simple / Medium / Complex]

**Key Features:**
- [Feature 3]
- [Feature 4]

**Completion Criteria:**
- Users can: [Capability 2]
- Technical: [Milestone 2]

### Phase 3: Enhancements & Optimizations
**Goal:** [What users can do after Phase 3]

**User Tasks (Phase 3):** [Count]
**Developer Tasks (Phase 3):** [Count]
**Complexity:** [Simple / Medium / Complex]

**Key Features:**
- [Feature 5]
- [Feature 6]

**Completion Criteria:**
- System is: [Production-ready criteria]

---

## Parallel Work Opportunities

**Track A: [Module/Area]**
- Features: [List]
- Can run parallel with: Track B
- Reason: [No dependencies]

**Track B: [Module/Area]**
- Features: [List]
- Can run parallel with: Track A
- Reason: [No dependencies]

**Benefits:**
- Time Savings: [Estimate based on complexity]
- Team Distribution: [How to split work]

---

## Risk Assessment

### High-Risk Dependencies
1. **[Feature X]**
   - Risk: [What could go wrong]
   - Impact: [What gets blocked]
   - Contingency: [Alternative approach]

### Bottleneck Features
- [Feature Y]: [X features blocked if this delays]
  - Mitigation: [How to reduce risk]

### Contingency Plans
**If blocked:** [Critical feature name]
**Workaround:**
1. [Option 1]
2. [Option 2]

---

## Planning Decisions Made

### Sequencing Decisions
1. **[Decision 1]**: [Chose sequence X because...]
2. **[Decision 2]**: [Chose to parallelize Y because...]

### Phase Breakdown Rationale
**Why Phase 1 includes [features]:**
[Rationale - dependencies, critical path, user value]

**Why Phase 2 includes [features]:**
[Rationale - builds on Phase 1, extended functionality]

**Why Phase 3 includes [features]:**
[Rationale - polish, optimization, nice-to-haves]

### User vs Developer Task Rationale
**Categorized as User Task:**
- [Task X]: [Because it's doable via Frappe UI]

**Categorized as Developer Task:**
- [Task Y]: [Because it requires Python/JavaScript]

---

## Handoff Status

### Received from Frappe-Architect
- **Date:** [Date]
- **TSD Location:** {{tsd_path}}/[filename].md
- **Features in TSD:** [Count]
- **Architect's Notes:** [Any special notes from handoff]

### Handed to Frappe-Dev
- **Date:** [Date]
- **Implementation Plan Location:** {{implementation_plans_path}}/[filename].md
- **Current Phase:** Phase 1
- **Developer Status:** [Not Started / In Progress / Phase 1 Complete / etc.]

---

## Session Notes

### Complex Dependency Challenges
[Any particularly complex dependency situations and how they were resolved]

**Example:**
- Circular dependency between [Feature A] and [Feature B]
- Resolution: [How it was broken - stub, refactor, etc.]

### Lessons Learned
[Patterns that worked well for this project]

**Example:**
- Parallel Track strategy saved estimated [X] complexity units
- Critical path identification prevented downstream blocking

---

## Implementation Plan Tracking

**Current Implementation Plan:** [Filename if exists]
**Location:** {{implementation_plans_path}}/[filename].md
**Last Updated:** [Date]
**Status:** [Draft / Complete / In Execution / Phase 1 Done / Phase 2 Done / Complete]

**Phases Completed:**
- [ ] Phase 1: Foundation & Core Workflow
- [ ] Phase 2: Extended Functionality
- [ ] Phase 3: Enhancements & Optimizations

**Current Phase Progress:**
[Notes on what's being worked on, blockers, etc.]

---

## User Patterns & Preferences

**Planning Style:**
[User's preference - aggressive phasing, conservative phasing, etc.]

**Technical Level:**
[User's development experience - affects complexity assessments]

**Risk Tolerance:**
[User's comfort with parallel work, aggressive dependencies, etc.]

---

## Session Variables

```
{{current_app}} = [app name]
{{app_path}} = {project-root}/apps/{{current_app}}
{{docs_path}} = {{app_path}}/docs
{{tsd_path}} = {{docs_path}}/tsd
{{implementation_plans_path}} = {{docs_path}}/implementation-plans
```

---

**Last Updated:** [Date]

**Notes:** Track implementation planning decisions, dependency analysis, phasing rationale, and handoff status.
