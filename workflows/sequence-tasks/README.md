# Sequence Tasks Workflow

Purpose: Order implementation tasks by dependencies and roles (User vs Developer), producing a dependency-aware sequence.

Inputs: Unordered task/feature list (often from TSD).

Outputs: Sequenced task list with dependency rationale.

Entrypoint: `{project-root}/.bmad/frappe-builder/workflows/sequence-tasks/workflow.yaml`

Usage: Invoke via agent command `*sequence-tasks` (Frappe-Planner) or direct workflow path.
