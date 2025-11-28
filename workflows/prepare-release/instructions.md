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
<action>Ask for release version, type (major/minor/patch), and scope (features/files). Store version, release_type, scope_description.</action>

<template-output>release_scope</template-output>
</step>

<step n="2" goal="Run comprehensive code review">
<action>Run review-code workflow on scoped files (or manually check whitelist/SQL injection/permissions/client filtering/console.log/built-in alternatives). Gate: fix critical issues before proceeding.</action>

<template-output>code_review_results</template-output>
</step>

<step n="3" goal="Generate and run tests">
<action>Ensure tests exist; use generate-tests workflow if needed. Run `bench --site {{default_site}} run-tests --app {{current_app}}`. Gate: all tests must pass; note coverage/edge cases.</action>

<template-output>test_results</template-output>
</step>

<step n="4" goal="Update or create documentation">
<action>Ensure guides exist for all features. If create-guide workflow available, invoke for gaps; otherwise produce concise guides (overview, when to use, how to use, field table, tips, troubleshooting) using ERPNext UI terms. Verify in `{{docs_path}}/guides/`.</action>

<template-output>documentation_status</template-output>
</step>

<step n="5" goal="Build release notes">
<action>Create comprehensive release notes.

**Format:**
```
# Release {{version}} - {{current_app}}

**Release Date:** {{date}}
**Release Type:** {{release_type}}

Sections: What's New (features/enhancements/fixes), Breaking Changes (if any), Installation/Upgrade commands, Testing performed, Known issues (with workarounds), Contributors, Support contact. Save to `{{docs_path}}/releases/release-{{version}}.md`.
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
