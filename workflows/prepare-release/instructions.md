# Prepare Release Workflow Instructions

<critical>The workflow execution engine is governed by: {project-root}/.bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: workflow.yaml</critical>
<critical>This is a Frappe-specific workflow - Frappe bench awareness is MANDATORY</critical>

## Frappe Bench Context

**Session Variables:**
- `{{current_app}}` - Frappe app name
- `{{app_path}}` - App directory: `{frappe_bench_path}/apps/{{current_app}}`
- `{{docs_path}}` - Documents directory: `{{app_path}}/docs`
- `{{version}}` - Release version number

<workflow>

<step n="1" goal="Get release scope and version">
<action>Ask user: What are we releasing?

Questions:
1. Version number (e.g., v1.2.0, v2.0.0-beta)?
2. Scope:
   - Major release (breaking changes)
   - Minor release (new features)
   - Patch release (bug fixes only)
3. Files/features included in this release?

Store:
- {{version}} - Version number
- {{release_type}} - major/minor/patch
- {{scope_description}} - What's included
</action>

<template-output>release_scope</template-output>
</step>

<step n="2" goal="Run comprehensive code review">
<action>Invoke review-code workflow on all files in scope.

**If review-code workflow exists:**
Use it to scan for Frappe anti-patterns.

**If NOT available:**
Manually check:
- Missing @frappe.whitelist() decorators
- SQL injection risks
- Missing permission checks
- Client-side filtering
- console.log() in production
- Custom code reinventing Frappe built-ins

Report all CRITICAL issues.

**GATE:** If critical issues found, STOP and fix before proceeding.
</action>

<template-output>code_review_results</template-output>
</step>

<step n="3" goal="Generate and run tests">
<action>Ensure all features have test coverage.

**If generate-tests workflow exists:**
Invoke it for features without tests.

**Run all tests:**
```bash
cd {frappe_bench_path}
bench --site {{default_site}} run-tests --app {{current_app}}
```

**Check test results:**
- All tests passing?
- Code coverage acceptable (>70%)?
- Edge cases covered?

**GATE:** All tests must pass before proceeding.
</action>

<template-output>test_results</template-output>
</step>

<step n="4" goal="Update or create documentation">
<action>Ensure all features have user guides.

**For each feature in release scope:**

<check if="create-guide workflow exists">
Invoke create-guide workflow for features without guides.
</check>

<check if="create-guide workflow NOT available">
Manually create concise user guides (2-3 pages):
- Overview (1 paragraph)
- When to use (bullets)
- How to use (numbered steps)
- Field reference (table)
- Tips (3-5 bullets)
- Troubleshooting (table)

Use ERPNext UI terminology (DocType, Child Table, etc.).
</check>

Verify all guides exist in `{{docs_path}}/guides/`.
</action>

<template-output>documentation_status</template-output>
</step>

<step n="5" goal="Build release notes">
<action>Create comprehensive release notes.

**Format:**
```
# Release {{version}} - {{current_app}}

**Release Date:** {{date}}

**Release Type:** {{release_type}}

## What's New

### New Features
- [Feature 1]: Brief description
- [Feature 2]: Brief description

### Enhancements
- [Enhancement 1]: What improved
- [Enhancement 2]: What improved

### Bug Fixes
- [Bug 1]: What was fixed
- [Bug 2]: What was fixed

### Breaking Changes (if major release)
- [Change 1]: What broke and migration path
- [Change 2]: What broke and migration path

## Installation

**New Installation:**
```bash
bench get-app {{current_app}}
bench --site [site-name] install-app {{current_app}}
```

**Upgrade from Previous Version:**
```bash
cd {frappe_bench_path}/apps/{{current_app}}
git pull
bench --site [site-name] migrate
bench --site [site-name] build
```

## Testing Performed

- Unit tests: [X passed]
- Integration tests: [X passed]
- Manual testing: [Scenarios tested]

## Known Issues

- [Issue 1]: Workaround
- [Issue 2]: Workaround

## Contributors

- {{user_name}}
- [Additional contributors if any]

---

**For questions or issues, contact:** [Support contact]
```

Save to: `{{docs_path}}/releases/release-{{version}}.md`
</action>

<template-output>release_notes</template-output>
</step>

<step n="6" goal="Perform final pre-release checks">
<action>Run final checklist:

**Code Quality:**
- [ ] No console.log() statements
- [ ] No commented-out code blocks
- [ ] No TODO/FIXME comments in production code
- [ ] All imports used (no unused imports)
- [ ] Code formatted consistently

**Frappe Compliance:**
- [ ] All API methods have @frappe.whitelist()
- [ ] All API methods check permissions
- [ ] Using frappe.utils (not custom date/number handling)
- [ ] Parameterized queries (no SQL injection risks)
- [ ] Server-side filtering (not client-side)

**Documentation:**
- [ ] All features have user guides
- [ ] Release notes complete
- [ ] README.md updated (if applicable)
- [ ] API documentation current

**Testing:**
- [ ] All unit tests passing
- [ ] Manual testing completed
- [ ] Edge cases tested
- [ ] Error scenarios tested

**Bench Commands:**
```bash
# Build assets
bench --site {{default_site}} build

# Clear cache
bench --site {{default_site}} clear-cache

# Run tests one more time
bench --site {{default_site}} run-tests --app {{current_app}}

# Check for Python syntax errors
cd {frappe_bench_path}/apps/{{current_app}}
python -m py_compile **/*.py

# Check for JavaScript syntax errors
find . -name "*.js" -exec node --check {} \;
```

All checks must pass.
</action>

<template-output>pre_release_checklist</template-output>
</step>

<step n="7" goal="Tag release in git (if applicable)">
<action>If app is in version control, create git tag:

**Commands:**
```bash
cd {frappe_bench_path}/apps/{{current_app}}

# Ensure all changes committed
git status

# Create annotated tag
git tag -a {{version}} -m "Release {{version}}: [Brief description]"

# Push tag to remote
git push origin {{version}}

# Push changes
git push
```

**If NOT using git:**
Document release version in app version file or configuration.
</action>

<template-output>git_tag_status</template-output>
</step>

<step n="8" goal="Prepare deployment instructions">
<action>Create deployment checklist for production:

**Deployment Steps:**
```
PRE-DEPLOYMENT:
1. Backup production database
2. Backup production site files
3. Test deployment in staging environment
4. Notify users of maintenance window

DEPLOYMENT:
1. Put site in maintenance mode:
   bench --site [site-name] set-maintenance-mode on

2. Pull latest code:
   cd {frappe_bench_path}/apps/{{current_app}}
   git pull

3. Run migrations:
   bench --site [site-name] migrate

4. Build assets:
   bench --site [site-name] build

5. Clear cache:
   bench --site [site-name] clear-cache

6. Restart services:
   bench restart

7. Verify deployment:
   - Test key features
   - Check logs for errors
   - Verify data integrity

8. Exit maintenance mode:
   bench --site [site-name] set-maintenance-mode off

POST-DEPLOYMENT:
1. Monitor error logs for 24 hours
2. Notify users of successful deployment
3. Update internal documentation
```

Save to: `{{docs_path}}/deployment/deployment-{{version}}.md`
</action>

<template-output>deployment_instructions</template-output>
</step>

<step n="9" goal="Final release summary">
<action>Present final release summary to user:

**Release Summary:**
- Version: {{version}}
- Type: {{release_type}}
- Features: [Count] new features, [Count] enhancements, [Count] bug fixes
- Tests: [X] passing
- Documentation: [X] guides created/updated
- Release notes: {{release_notes_file}}
- Deployment instructions: {{docs_path}}/deployment/deployment-{{version}}.md

**Files Generated:**
- Release notes
- Deployment instructions
- User guides (if created)

**Status:** Ready for deployment

Ask: "Release preparation complete. Ready to deploy to production?"
</action>

<template-output>release_summary</template-output>
</step>

<step n="10" goal="Post-release follow-up" optional="true">
<action>After deployment, document post-release activities:

**Post-Release Checklist:**
- [ ] Monitor production logs for 24 hours
- [ ] Verify key workflows functioning
- [ ] Collect user feedback
- [ ] Document any issues encountered
- [ ] Update knowledge base with learnings

**Create post-release report if requested.**
</action>

<template-output>post_release_activities</template-output>
</step>

</workflow>
