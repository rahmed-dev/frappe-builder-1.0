# Project Archives

Completed projects stored here.

## Structure
```
archive/
└── [project-name]/
    ├── metadata.yaml     # Archive metadata (when, who, why)
    ├── active.yaml       # Final state
    ├── plan.md           # Implementation plan
    ├── tsd.md            # Tech spec (if exists)
    └── context/
        └── dump-*.md     # Context snapshots
```

## Resume Project
1. Copy `[project]/active.yaml` → `../active.yaml`
2. Uncheck all tasks in plan.md (for iteration)
3. Update `active.yaml` timestamp
