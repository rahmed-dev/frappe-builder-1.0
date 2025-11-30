# Prepare Release Workflow

Purpose: Run a release checklist across code/tests/docs to ready a delivery.

Inputs: Implemented feature set, test results, documentation status.

Outputs: Release readiness confirmation and any remaining action items.

Entrypoint: `{project-root}/.bmad/frappe-builder/workflows/prepare-release/workflow.yaml`

Usage: Invoke via agent command `*prepare-release` (or direct workflow path) near delivery.
