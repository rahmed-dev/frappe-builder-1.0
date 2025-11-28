# Diagnose Issue Workflow

Purpose: Perform root-cause analysis for errors, performance problems, or unexpected behavior in a Frappe app.

Inputs: Tracebacks/log snippets/behavior descriptions; project/app/site context.

Outputs: Root-cause summary, file:line references, recommended fixes, and prevention notes.

Entrypoint: `{project-root}/.bmad/frappe-builder/workflows/diagnose-issue/workflow.yaml`

Usage: Invoke via agent command `*diagnose` (Frappe-Debugger) or direct workflow path.
