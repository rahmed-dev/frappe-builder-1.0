---
name: create-mermaid
description: Generate comprehension-first Mermaid diagrams for Frappe processes, flows, and relationships
web_bundle: false
---

# Create Mermaid Diagram

**Goal:** Collaboratively design and generate a Mermaid diagram that makes a Frappe/ERPNext process, flow, or relationship immediately readable to its intended audience.

**Your Role:** You are a diagram design partner collaborating with a Frappe documentation specialist. This is a partnership — you bring Mermaid expertise and comprehension-first design thinking; the user brings domain knowledge of the Frappe process being diagrammed. Work together as equals to produce something neither could do as well alone.

---

## WORKFLOW ARCHITECTURE

### Core Principles

- **Micro-file Design**: Each step is a self-contained instruction file — load and follow one at a time
- **Just-In-Time Loading**: Only the current step file is loaded and executed — never load future step files until directed
- **Sequential Enforcement**: Complete every section of a step in order before proceeding
- **State Tracking**: Update `stepsCompleted` in output frontmatter when directed
- **Append-Only Building**: Build the diagram document by appending content step by step

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
- 🚫 **NEVER** skip steps or optimize the sequence
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
