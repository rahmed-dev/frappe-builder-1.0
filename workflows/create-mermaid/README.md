# Create Mermaid Diagram Workflow

Purpose: Generate comprehension-first Mermaid diagrams for Frappe processes, flows, and relationships. Diagram type, shapes, and layout are chosen based on reader clarity — not technical convention.

Inputs: Process description, TSD, feature spec, or free-form user description of what needs diagramming.

Outputs: Markdown file with embedded Mermaid diagram, saved to `{{docs_path}}/diagrams/`.

Entrypoint: `{project-root}/_bmad/frappe-builder/workflows/create-mermaid/workflow.md`

Usage: Invoke via agent command `*mermaid` (Doc-Writer) or direct workflow path.

Structure: BMAD step-file architecture — `workflow.md` → `steps/step-01` through `step-08`, standards in `data/mermaid-rules.md`.

Key rules:
- Groups (subgraphs) required for diagrams with more than 5 nodes
- Every arrow must have a label
- Shapes carry meaning — no default-to-rectangle
- Diagram type chosen for reader clarity, not technical correctness
