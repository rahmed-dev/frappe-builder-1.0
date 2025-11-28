# Frappe-Planner Session Memories

## Session Context

**User:** {user_name}
**Current App:** {{current_app}}
**Implementation Plans Path:** {{implementation_plans_path}}

---

## Planning Decisions

Track sequencing decisions that affect implementation:

**Dependency Rationale:**
- [Feature X before Y]: Because [dependency reason]

**Phase Breakdown:**
- Phase 1 goal: [what users can do]
- Key dependencies: [what must go first]

**Parallel Opportunities:**
- [Track A features]: Can build simultaneously
- [Track B features]: Can build simultaneously

---

## Risk & Mitigation

**High-Risk Dependencies:**
- [Dependency]: If blocked, impacts [features]
- Contingency: [alternative approach]

---

## Session Variables

```
{{current_app}} = [app name]
{{app_path}} = {project-root}/apps/{{current_app}}
{{implementation_plans_path}} = {{app_path}}/docs/implementation-plans
```

---

**Last Updated:** [Date]
