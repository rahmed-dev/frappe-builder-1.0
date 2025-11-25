#!/bin/bash
# Quick Resume Script for MAKER Implementation
# Purpose: After context loss, run this to find your position instantly
# Usage: bash resume-maker-implementation.sh

cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║        MAKER IMPLEMENTATION - RESUME STATUS CHECKER           ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check which phase is complete by detecting artifacts
echo "📊 Phase Status Detection..."
echo ""

# Phase 1: Check for state infrastructure
if [ -d "state" ] && [ -f "state/active.yaml.template" ] && [ -f "templates/documents/implementation-plan-efficient.md" ]; then
    PHASE1="✅ COMPLETE"
    PHASE1_DETAIL="state/ exists, templates created"
else
    PHASE1="⏳ IN PROGRESS or TODO"
    PHASE1_DETAIL="state/ or templates missing"
fi

# Phase 2: Check for Nexus modifications
if grep -q "Check Active Project State" agents/frappe-nexus-sidecar/instructions.md 2>/dev/null && \
   grep -q "TSD Section Mapping" agents/frappe-planner-sidecar/instructions.md 2>/dev/null; then
    PHASE2="✅ COMPLETE"
    PHASE2_DETAIL="Nexus + Planner integrated"
else
    PHASE2="⏳ IN PROGRESS or TODO"
    PHASE2_DETAIL="Nexus or Planner not modified yet"
fi

# Phase 3: Check for Dev modifications
if grep -q "MAKER Integration: Startup" agents/frappe-dev-sidecar/instructions.md 2>/dev/null; then
    PHASE3="✅ COMPLETE"
    PHASE3_DETAIL="Dev autonomy integrated"
else
    PHASE3="⏳ IN PROGRESS or TODO"
    PHASE3_DETAIL="Dev not modified yet"
fi

# Phase 4: Check for workflow modifications
if grep -q "implementation-plan-efficient" workflows/sequence-tasks/workflow.yaml 2>/dev/null; then
    PHASE4="✅ COMPLETE"
    PHASE4_DETAIL="Workflows integrated"
else
    PHASE4="⏳ IN PROGRESS or TODO"
    PHASE4_DETAIL="Workflows not updated yet"
fi

# Display results
echo "┌─────────┬────────────────────┬──────────────────────────────────┐"
echo "│ Phase   │ Status             │ Details                          │"
echo "├─────────┼────────────────────┼──────────────────────────────────┤"
printf "│ Phase 1 │ %-18s │ %-32s │\n" "$PHASE1" "$PHASE1_DETAIL"
printf "│ Phase 2 │ %-18s │ %-32s │\n" "$PHASE2" "$PHASE2_DETAIL"
printf "│ Phase 3 │ %-18s │ %-32s │\n" "$PHASE3" "$PHASE3_DETAIL"
printf "│ Phase 4 │ %-18s │ %-32s │\n" "$PHASE4" "$PHASE4_DETAIL"
echo "└─────────┴────────────────────┴──────────────────────────────────┘"
echo ""

# Count completed tasks from plan file
PLAN_FILE="future-plans/maker-integration/IMPLEMENTATION-PLAN-CORRECTED.md"
if [ -f "$PLAN_FILE" ]; then
    COMPLETED=$(grep -c "\[x\]" "$PLAN_FILE" 2>/dev/null || echo "0")
    echo "📈 Tasks Completed: $COMPLETED / 31 ($(echo "scale=1; $COMPLETED * 100 / 31" | bc)%)"
    echo ""
fi

# Determine next action
echo "🎯 Next Action:"
echo ""

if [ "$PHASE1" == "⏳ IN PROGRESS or TODO" ]; then
    # Find first incomplete Phase 1 task
    echo "▶ RESUME AT: Phase 1"
    echo ""
    echo "  Next tasks to check (in order):"
    echo "    1. Task i1 - Create state/ directory"
    echo "       Line 163 in plan"
    echo "       Check: ls state/ 2>/dev/null"
    echo ""
    echo "    2. Task i2 - Create active.yaml template"
    echo "       Line 191 in plan"
    echo "       Check: ls state/active.yaml.template 2>/dev/null"
    echo ""
    echo "  📖 Open: $PLAN_FILE"
    echo "  🔍 Search for: '### i1:' or check Progress Tracker (line 54)"

elif [ "$PHASE2" == "⏳ IN PROGRESS or TODO" ]; then
    echo "▶ RESUME AT: Phase 2"
    echo ""
    echo "  Phase 1 complete! Moving to Nexus integration."
    echo ""
    echo "  Next tasks to check:"
    echo "    1. Task n1 - Backup Nexus"
    echo "       Line 1189 in plan"
    echo "       Check: ls agents/frappe-nexus-sidecar/*.backup-pre-maker* 2>/dev/null"
    echo ""
    echo "  📖 Open: $PLAN_FILE"
    echo "  🔍 Search for: '### n1:' or check Progress Tracker (line 54)"

elif [ "$PHASE3" == "⏳ IN PROGRESS or TODO" ]; then
    echo "▶ RESUME AT: Phase 3"
    echo ""
    echo "  Phase 2 complete! Moving to Dev autonomy."
    echo ""
    echo "  Next tasks to check:"
    echo "    1. Task d1 - Backup Dev"
    echo "       Line 1905 in plan"
    echo "       Check: ls agents/frappe-dev-sidecar/*.backup-pre-maker* 2>/dev/null"
    echo ""
    echo "  📖 Open: $PLAN_FILE"
    echo "  🔍 Search for: '### d1:' or check Progress Tracker (line 54)"

elif [ "$PHASE4" == "⏳ IN PROGRESS or TODO" ]; then
    echo "▶ RESUME AT: Phase 4"
    echo ""
    echo "  Phase 3 complete! Moving to workflow integration."
    echo ""
    echo "  Next tasks to check:"
    echo "    1. Task w1 - Backup workflows"
    echo "       Line 3025 in plan"
    echo "       Check: ls workflows/*/workflow.yaml.backup-pre-maker* 2>/dev/null"
    echo ""
    echo "  📖 Open: $PLAN_FILE"
    echo "  🔍 Search for: '### w1:' or check Progress Tracker (line 54)"

else
    echo "▶ ALL PHASES COMPLETE! 🎉🎊"
    echo ""
    echo "  MAKER integration fully deployed!"
    echo "  Run final validation:"
    echo "    cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/"
    echo "    # Check Success Criteria section (line ~3550)"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "💡 Quick Commands:"
echo "  • View plan:    cat $PLAN_FILE | less"
echo "  • Check task:   grep '### [task_id]:' $PLAN_FILE"
echo "  • Edit tracker: vim +54 $PLAN_FILE  # Jump to Progress Tracker"
echo ""
echo "🔗 Current directory: $(pwd)"
echo ""
