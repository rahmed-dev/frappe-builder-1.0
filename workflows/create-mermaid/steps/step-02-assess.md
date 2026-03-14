---
name: 'step-02-assess'
description: 'Assess diagram complexity and propose groups if needed — confirm with user before continuing'

nextStepFile: './step-03-type.md'
advancedElicitationTask: '{project-root}/_bmad/core/tasks/advanced-elicitation.md'
mermaidRules: '../data/mermaid-rules.md'
---

# Step 2: Assess Complexity & Propose Groups

## STEP GOAL:

Think through the subject's complexity, determine if subgraph groups are needed, propose them clearly, and get the user's confirmation before proceeding.

## MANDATORY EXECUTION RULES (READ FIRST):

### Universal Rules:
- 📖 CRITICAL: Read the complete step file before taking any action
- 🔄 CRITICAL: When loading next step with 'C', ensure entire file is read first
- ⏸️ ALWAYS halt at the menu and wait for user input

### Role Reinforcement:
- You are the diagram architect here — bring your expertise to the assessment
- The user validates whether your grouping makes sense for their domain
- Present your thinking, invite their input

### Step-Specific Rules:
- Load {mermaidRules} and apply the subgraph rules
- Be specific about proposed group names — use user-facing language, not technical terms
- If <5 nodes: no groups needed, say so briefly

## EXECUTION PROTOCOLS:
- Think through the subject before writing anything
- Present assessment in plain language
- Propose group names that a user would recognise in their daily work
- Halt at menu

## CONTEXT BOUNDARIES:
- Based on: what was understood in step 1
- Load {mermaidRules} for subgraph and layout rules
- Do NOT choose diagram type yet — that is step 3

## MANDATORY SEQUENCE

### 1. Load Mermaid Rules

Load {mermaidRules} silently. You will apply the subgraph rules in this step.

### 2. Assess Complexity

Think through the subject from step 1:
- Roughly how many distinct nodes (steps, states, entities) are there?
- Are there decision branches or parallel paths?
- Are multiple roles or systems involved?

### 3. Present Assessment

Share your thinking conversationally:

**If ≤5 nodes:**
> "This is a relatively compact diagram — [N] nodes, no need for groups. I'll keep it clean and flat."

**If >5 nodes:**
> "This is more involved — I'm counting roughly [N] elements. To keep it readable, I'd suggest splitting it into [N] groups: [Group 1 Name], [Group 2 Name], [Group 3 Name]. Each group would contain [brief description of what belongs where]. Does that grouping match how you think about this process?"

If the user suggests different group names or boundaries, accept them immediately.

### 4. Confirm Layout Direction

If groups were proposed:
> "Should these groups read left-to-right (parallel / role-separated) or top-to-bottom (sequential phases)?"

Or suggest based on subject:
> "Given these are sequential phases, I'd stack them top-to-bottom — does that work?"

### 5. Present MENU OPTIONS

Display: "**Select:** [A] Explore grouping options in more depth [C] Continue to diagram type"

#### Menu Handling Logic:
- IF A: Explore alternative grouping approaches with the user, then redisplay this menu
- IF C: Save assessment to context, then load, read entire file, and execute {nextStepFile}
- IF any other input: Answer, then redisplay this menu

#### EXECUTION RULES:
- ALWAYS halt and wait for user input after displaying the menu
- ONLY proceed to next step when user selects 'C'

## 🚨 SYSTEM SUCCESS/FAILURE METRICS

### ✅ SUCCESS:
- Node count estimated
- Groups proposed (or confirmed not needed) with user-facing names
- Layout direction agreed
- User confirmed before proceeding

### ❌ SYSTEM FAILURE:
- Proceeding without user confirmation on grouping
- Using technical labels for groups instead of user-facing names
- Choosing diagram type in this step

**Master Rule:** Propose, get confirmation, then continue.
