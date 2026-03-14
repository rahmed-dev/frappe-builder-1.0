---
name: 'step-05-svg'
description: 'Generate the SVG export from the Excalidraw JSON — auto-proceeds to review'

nextStepFile: './step-06-review.md'
svgRules: '../data/svg-rules.md'
---

# Step 5: Generate SVG

## STEP GOAL:

Generate a self-contained, PDF-embeddable SVG that faithfully represents the Excalidraw diagram with hand-drawn aesthetic. Auto-proceeds to review.

## MANDATORY EXECUTION RULES (READ FIRST):

### Universal Rules:
- 📖 CRITICAL: Read the complete step file before taking any action
- 🔄 CRITICAL: When loading next step, ensure entire file is read first
- ✅ This is a validation sequence step — auto-proceed after completing generation

### Step-Specific Rules:
- Load {svgRules} and follow every rule
- SVG must be fully self-contained — no external dependencies that would break PDF rendering
- Calculate viewBox from element positions in JSON + 40px padding on each side

## EXECUTION PROTOCOLS:
- Load {svgRules}
- Generate SVG from the Excalidraw JSON produced in step 4
- Verify self-containment checklist
- Auto-proceed to {nextStepFile}

## CONTEXT BOUNDARIES:
- Source: Excalidraw JSON from step 4
- Load {svgRules} for all SVG requirements
- No user input needed — auto-proceeds

## MANDATORY SEQUENCE

### 1. Load SVG Rules

Load {svgRules} silently. Apply every rule when generating.

### 2. Calculate ViewBox

From the Excalidraw JSON element positions:
- Find min x and min y across all elements
- Find max (x + width) and max (y + height) across all elements
- ViewBox = `"{minX - 40} {minY - 40} {(maxX - minX) + 80} {(maxY - minY) + 80}"`

### 3. Generate the SVG

Build the SVG translating each Excalidraw element:
- **Frames** → dashed-border `<rect>` with label above
- **Rectangles** → `<rect>` with `rx="4"` (standard) or `rx="12"` (rounded)
- **Diamonds** → `<polygon>` with 4 points
- **Ellipses** → `<ellipse>`
- **Arrows** → `<line>` with arrowhead marker from `<defs>`
- **Text labels** → `<text>` centred in their shape or mid-arrow
- **Colours** → translate from Excalidraw hex values directly

Apply to all shapes:
- `stroke-linecap="round"` and `stroke-linejoin="round"` for hand-drawn feel
- Font: `font-family: Virgil, 'Segoe UI Emoji', cursive`

### 4. Verify Self-Containment

Check against {svgRules} checklist:
- [ ] No external image references
- [ ] Font import present in `<defs>`
- [ ] Arrowhead marker defined in `<defs>` before first use
- [ ] `viewBox` calculated with 40px padding
- [ ] All colours inline

If any check fails, fix before proceeding.

### 5. Display and Auto-Proceed

Note briefly:
> "SVG generated. Moving to review..."

Load, read the full file, and execute {nextStepFile}.

## 🚨 SYSTEM SUCCESS/FAILURE METRICS

### ✅ SUCCESS:
- SVG generated from the Excalidraw JSON
- All elements translated faithfully
- Self-containment checklist passed
- ViewBox calculated correctly
- Auto-proceeded to next step

### ❌ SYSTEM FAILURE:
- External resource references in SVG
- Missing `viewBox`
- Elements missing from SVG that were in JSON
- Halting for user input (this step auto-proceeds)

**Master Rule:** Generate faithfully. Verify self-containment. Auto-proceed.
