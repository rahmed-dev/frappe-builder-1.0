# Frappe-Builder Specialist Guide

This is the lean routing brain for Frappe-Nexus: enough detail to pick the right specialist fast, without extra story or long examples.

---

## The 8 Specialists

### 🎯 Frappe-Nexus (You are here!)
- **Role:** Orchestrator & router across all Frappe-Builder specialists.
- **Use when:** You’re not sure who to call next, want an overview of the flow, or need help deciding the right entry point.
- **Don’t use when:** You already know the exact specialist you want; jump straight to them instead.

### 📊 ERPNext BA (Business Analyst)
- **Role:** Requirements analysis and ERPNext module mapping.
- **Use when:** Requirements are messy, you need Standard vs Custom breakdown, or you’re producing a BRD.
- **Don’t use when:** You need technical solution design (use Frappe-Architect) or code implementation (use Frappe-Dev).

### 🏗️ Frappe-Architect (Solution Architect)
- **Role:** Technical design using the Frappe and 4‑tier frameworks.
- **Use when:** You have business requirements and need DocType/UX/workflow design or a Technical Specification Document (TSD).
- **Don’t use when:** Requirements are unclear (start with ERPNext BA) or you’re ready to just execute code (use Frappe-Dev).

### 📋 Frappe-Planner (Implementation Planner)
- **Role:** Dependency analysis and implementation sequencing.
- **Use when:** You have a TSD and want phased rollout, dependency-aware ordering, or a clear implementation plan.
- **Don’t use when:** The feature is tiny with no real dependencies (go straight to Frappe-Dev) or you still lack a design (use Frappe-Architect first).

### 💻 Frappe-Dev (Code Developer)
- **Role:** Frappe framework execution—writing and refining production-ready code.
- **Use when:** You have a design or plan and are ready to scaffold DocTypes, write code, run tests, or perform code-level refactors.
- **Don’t use when:** You’re still clarifying requirements (ERPNext BA) or debating solution design (Frappe-Architect).

### 🔧 Frappe-Debugger (Error Diagnostician)
- **Role:** Error diagnosis, anti‑pattern detection, and performance troubleshooting.
- **Use when:** You have tracebacks, misbehavior without clear errors, slow queries, or suspected anti‑patterns.
- **Don’t use when:** You just need to build a new feature (Frappe-Dev) or redesign a solution (Frappe-Architect).

### 🧪 QA-Specialist (Test Scenario Generator)
- **Role:** Test matrix design and Frappe unittest scenario generation.
- **Use when:** A feature exists and you want comprehensive test coverage, edge‑case thinking, or unittest scaffolding.
- **Don’t use when:** The feature doesn’t exist yet (design tests with Frappe-Architect, then return here after implementation).

### 📝 Doc-Writer (Documentation Generator)
- **Role:** User‑facing documentation and training material.
- **Use when:** A feature is implemented and you need practical user guides or training docs.
- **Don’t use when:** You need developer‑level technical docs (capture those in the TSD or dev notes instead).

---

## Quick Reference: "I Need To..."

| I need to...                | Use this Specialist     |
|-----------------------------|-------------------------|
| Analyze requirements        | ERPNext BA              |
| Design solution             | Frappe-Architect        |
| Plan implementation order   | Frappe-Planner          |
| Write code                  | Frappe-Dev              |
| Fix error                   | Frappe-Debugger         |
| Create tests                | QA-Specialist           |
| Write user docs             | Doc-Writer              |
| Understand development flow | Frappe-Nexus (*start)   |
| Don’t know what I need      | Frappe-Nexus (*start)   |

