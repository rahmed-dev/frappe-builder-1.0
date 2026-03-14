# Create Excalidraw Diagram Workflow

Purpose: Generate hand-drawn style Excalidraw diagrams for Frappe processes, flows, and relationships. Layout and shapes are chosen based on reader clarity — not diagram convention. Produces three output files per diagram.

Inputs: Process description, TSD, feature spec, or free-form user description of what needs diagramming.

Outputs (per diagram):
- `{{diagram_name}}.excalidraw` — editable source (open in Excalidraw app or VSCode extension)
- `{{diagram_name}}.svg` — embed-ready SVG for markdown and PDF
- `{{diagram_name}}-diagram.md` — companion doc with SVG already embedded

All files saved to `{{docs_path}}/diagrams/`.

Entrypoint: `{project-root}/_bmad/frappe-builder/workflows/create-excalidraw/workflow.md`

Usage: Invoke via agent command `*excalidraw` (Doc-Writer) or direct workflow path.

Structure: BMAD step-file architecture — `workflow.md` → `steps/step-01` through `step-08`, specs in `data/excalidraw-spec.md` and `data/svg-rules.md`.

Key rules:
- Layout chosen for reader clarity: flow / hierarchy / swim lanes / cluster / matrix
- Frames (groups) required for diagrams with more than 5 elements
- Every arrow must carry a label
- Hand-drawn style: roughness=1, virgil font, hachure fill
- SVG is fully self-contained for reliable PDF rendering
