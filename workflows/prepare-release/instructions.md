# Prepare Release Workflow Instructions

<critical>The workflow execution engine is governed by: {project-root}/.bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: workflow.yaml</critical>
<critical>This is a Frappe-specific workflow - Frappe bench awareness is MANDATORY</critical>

<workflow>

<step n="1" goal="Get release scope and version">
<action>Ask for release version, type (major/minor/patch), and scope (features/files). Store: version, release_type, scope_description.</action>
<template-output>release_scope</template-output>
</step>

<step n="2" goal="Run comprehensive code review">
<action>Run review-code workflow on scoped files (or manually check: whitelist, SQL injection, permissions, client filtering, console.log, built-in alternatives). Gate: fix critical issues before proceeding.</action>
<template-output>code_review_results</template-output>
</step>

<step n="3" goal="Generate and run tests">
<action>Ensure tests exist; use generate-tests workflow if needed. Run `bench --site {{default_site}} run-tests --app {{app}}`. Gate: all tests must pass.</action>
<template-output>test_results</template-output>
</step>

<step n="4" goal="Update or create documentation">
<action>Ensure guides exist for all features in `{{app_path}}/docs/guides/`. Invoke create-guide workflow for gaps; otherwise produce concise guides (overview, when to use, how to use, field table, tips, troubleshooting) using ERPNext UI terms.</action>
<template-output>documentation_status</template-output>
</step>

<step n="5" goal="Build release notes">
<action>Create release notes at `{{app_path}}/docs/releases/release-{{version}}.md`:
```
# Release {{version}} - {{app}}
Date: {{date}} | Type: {{release_type}}

## What's New
[Features / Enhancements / Bug Fixes]

## Breaking Changes (if any)

## Installation / Upgrade
bench get-app {{app}} [repo-url]
bench --site [site] migrate

## Known Issues
[Issue + workaround if any]
```
</action>
<template-output>release_notes</template-output>
</step>

<step n="6" goal="Final pre-release checks">
<action>Verify all items before proceeding:

**Code Quality:** No console.log / commented-out blocks / TODO-FIXME in production / unused imports
**Frappe Compliance:** @whitelist on APIs / permission checks / frappe.utils / parameterized queries / server-side filters
**Documentation:** Feature guides exist / release notes complete / README updated
**Testing:** Unit tests pass / manual testing done / edge cases covered

Run: `bench --site {{default_site}} build && bench --site {{default_site}} clear-cache && bench --site {{default_site}} run-tests --app {{app}}`

All checks must pass before proceeding.
</action>
<template-output>pre_release_checklist</template-output>
</step>

<step n="7" goal="Tag release in git">
<action>If app is in version control:
```bash
cd {frappe_bench_path}/apps/{{app}}
git status  # confirm all committed
git tag -a {{version}} -m "Release {{version}}"
git push origin {{version}} && git push
```
If not using git, document release version in app config.
</action>
<template-output>git_tag_status</template-output>
</step>

<step n="8" goal="Prepare deployment instructions">
<action>Save deployment checklist to `{{app_path}}/docs/deployment/deployment-{{version}}.md`:

**Pre-deployment:** Backup DB + files / test on staging / notify users of maintenance window

**Deployment:**
1. `bench --site [site] set-maintenance-mode on`
2. `git pull` in app directory
3. `bench --site [site] migrate`
4. `bench --site [site] build && bench --site [site] clear-cache`
5. `bench restart`
6. Verify key features + check logs
7. `bench --site [site] set-maintenance-mode off`

**Post-deployment:** Monitor logs 24h / notify users / document issues
</action>
<template-output>deployment_instructions</template-output>
</step>

<step n="9" goal="Final release summary">
<action>Present summary: version, type, feature count, test count, docs created/updated, file paths generated. Confirm: "Release preparation complete. Ready to deploy to production?"</action>
<template-output>release_summary</template-output>
</step>

<step n="10" goal="Archive project state" optional="true">
<action>If this release marks project phase completion, archive state for future reference.</action>
<invoke-task path="{project-root}/{bmad_folder}/frappe-builder/tasks/state/archive-project.xml" />
<template-output>archive_status</template-output>
</step>

<step n="11" goal="Post-release follow-up" optional="true">
<action>After deployment: monitor logs 24h / verify key workflows / collect user feedback / document issues / update knowledge base.</action>
<template-output>post_release_activities</template-output>
</step>

<step n="12" goal="Update project state">
<action>Update `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/session.yaml`:
```yaml
last_action: "Release {{version}} prepared: {{change_count}} changes"
next_action: "{{project_complete ? 'Archive project or start new work' : 'Continue with next feature'}}"
updated: "{{timestamp}}"
```
If project complete, mark all features completed.
</action>
<template-output>state_updated</template-output>
</step>

</workflow>
