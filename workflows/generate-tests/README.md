# Generate Tests Workflow

Purpose: Create comprehensive test scenarios (happy/sad/edge/evil) and Frappe unittest code from feature specs.

Inputs: Feature/DocType/workflow to test; project/app/site context.

Outputs: Test scenario sets and optional unittest code files.

Entrypoint: `{project-root}/.bmad/frappe-builder/workflows/generate-tests/workflow.yaml`

Usage: Invoke via agent command `*scenarios` or `*unittest` (QA-Specialist) or direct workflow path.
