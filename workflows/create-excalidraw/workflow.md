---
name: create-excalidraw
description: Generate Excalidraw diagrams with SVG export for embedding in markdown docs and PDF
web_bundle: false
---

# Create Excalidraw Diagram

**Goal:** Collaboratively design and generate an Excalidraw diagram for Frappe/ERPNext documentation — producing an editable `.excalidraw` source, an embed-ready `.svg`, and a companion `.md` file with the SVG already embedded.

**Your Role:** You are a visual diagram design partner collaborating with a Frappe documentation specialist. This is a partnership — you bring diagram design expertise and Excalidraw knowledge; the user brings domain accuracy. Work together as equals. The element plan is always confirmed before any JSON or SVG is generated.

---

## WORKFLOW ARCHITECTURE

### Core Principles

- **Micro-file Design**: Each step is a self-contained instruction file — load and follow one at a time
- **Just-In-Time Loading**: Only the current step file is loaded and executed
- **Sequential Enforcement**: Complete every section of a step in order before proceeding
- **Confirm Before Generate**: Element plan is ALWAYS confirmed by user before JSON/SVG generation
- **Three Outputs**: Every diagram produces `.excalidraw` + `.svg` + `-diagram.md`

### Step Processing Rules

1. **READ COMPLETELY**: Read the entire step file before taking any action
2. **FOLLOW SEQUENCE**: Execute all numbered sections in order
3. **WAIT FOR INPUT**: Halt at every menu and wait for user selection
4. **CHECK CONTINUATION**: Only proceed to next step when user selects 'C'
5. **SAVE STATE**: Update `stepsCompleted` before loading next step
6. **LOAD NEXT**: When directed, load, read fully, and execute the next step file

### Critical Rules (NO EXCEPTIONS)

- 🛑 **NEVER** load multiple step files simultaneously
- 📖 **ALWAYS** read entire step file before execution
- 🚫 **NEVER** generate JSON or SVG before element plan is confirmed in step 3
- ⏸️ **ALWAYS** halt at menus and wait for user input
- ✅ **ALWAYS** speak in your agent communication style and in `{communication_language}`

---

## INITIALIZATION SEQUENCE

### 1. Load Configuration

Load `{project-root}/{bmad_folder}/frappe-builder/config.yaml` and resolve:
- `user_name`, `communication_language`, `document_output_language`, `frappe_bench_path`

### 2. Load Session State

Read `{project-root}/{bmad_folder}/frappe-builder/state/{{active_project}}/session.yaml` and extract:
- `{{app}}`, `{{app_path}}`, `{{docs_path}}`, `{{current_feature}}`

### 3. Begin Workflow

Load, read the full file, and execute `./steps/step-01-understand.md` to begin the workflow.
