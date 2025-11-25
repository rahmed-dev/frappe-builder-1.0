#!/bin/bash
# Phase 4 Validation Script
# Checks that all workflow modifications are in place

cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

echo "========================================"
echo "Phase 4 Workflow Integration Validation"
echo "========================================"
echo ""

# w1: Check backups
echo "=== w1: Backup Files ==="
BACKUPS=$(ls -1 workflows/*/workflow.yaml.backup-pre-maker-20251125 2>/dev/null | wc -l)
if [ $BACKUPS -eq 4 ]; then
    echo "✓ All 4 workflow backups exist"
else
    echo "✗ FAIL: Expected 4 backups, found $BACKUPS"
fi
echo ""

# w2: Check Planner modifications
echo "=== w2: Planner Template Integration ==="
if grep -q "implementation-plan-efficient.md" agents/frappe-planner-sidecar/instructions.md; then
    echo "✓ Planner loads efficient template"
else
    echo "✗ FAIL: Planner doesn't reference efficient template"
fi

if grep -q "Simple.*Medium.*Complex" agents/frappe-planner-sidecar/instructions.md; then
    echo "✓ Complexity determination added"
else
    echo "✗ FAIL: Complexity determination missing"
fi

if grep -q "TSD Section Mapping" agents/frappe-planner-sidecar/instructions.md; then
    echo "✓ TSD mapping section exists (Gap 2 fix)"
else
    echo "✗ FAIL: TSD mapping section missing"
fi
echo ""

# w3: Check implement-feature modifications
echo "=== w3: Implement-Feature Active.yaml Integration ==="
if grep -q "MAKER Integration.*Load Active Project State" workflows/implement-feature/instructions.md; then
    echo "✓ Implement-feature loads active.yaml"
else
    echo "✗ FAIL: Implement-feature doesn't load active.yaml"
fi

if grep -q "summary.*BRD summary" workflows/implement-feature/instructions.md; then
    echo "✓ Summary field usage documented"
else
    echo "✗ FAIL: Summary field not mentioned"
fi
echo ""

# w4: Check design-solution modifications
echo "=== w4: Design-Solution State Update ==="
if grep -q "Update active.yaml with TSD path" workflows/design-solution/instructions.md; then
    echo "✓ Design-solution updates active.yaml"
else
    echo "✗ FAIL: Design-solution doesn't update active.yaml"
fi

if grep -q "tsd:.*docs_path" workflows/design-solution/instructions.md; then
    echo "✓ TSD path update documented"
else
    echo "✗ FAIL: TSD path update missing"
fi
echo ""

# w5: Check analyze-requirements modifications
echo "=== w5: Analyze-Requirements BRD + Summary (Gap 4 Fix) ==="
if grep -q "Update active.yaml with BRD path.*Extract Summary" workflows/analyze-requirements/instructions.md; then
    echo "✓ Analyze-requirements updates BRD path + summary"
else
    echo "✗ FAIL: BRD path + summary update missing"
fi

if grep -q "GAP 4 FIX" workflows/analyze-requirements/instructions.md; then
    echo "✓ Gap 4 fix explicitly marked"
else
    echo "✗ FAIL: Gap 4 fix not marked"
fi

if grep -q "first 3 sentences\|up to 150 words" workflows/analyze-requirements/instructions.md; then
    echo "✓ Summary extraction logic documented"
else
    echo "✗ FAIL: Summary extraction logic missing"
fi
echo ""

# Check progress tracker
echo "=== Progress Tracker Update ==="
W_COMPLETE=$(grep "| \*\*4\*\*.*\[x\]" future-plans/maker-integration/IMPLEMENTATION-PLAN-CORRECTED.md | wc -l)
echo "Completed Phase 4 tasks: $W_COMPLETE / 7"
if [ $W_COMPLETE -ge 5 ]; then
    echo "✓ At least w1-w5 marked complete"
else
    echo "⚠ Only $W_COMPLETE tasks marked complete"
fi
echo ""

# Summary
echo "========================================"
echo "Validation Summary"
echo "========================================"
echo ""
echo "✅ Code Changes:"
echo "   - Planner: Loads efficient template, complexity, TSD mapping"
echo "   - Implement-feature: Loads active.yaml for context"
echo "   - Design-solution: Updates active.yaml with TSD path"
echo "   - Analyze-requirements: Updates BRD path + extracts summary (Gap 4)"
echo ""
echo "⏳ Manual Testing Required:"
echo "   - w6: Full workflow chain test"
echo "   - w7: End-to-end token measurement"
echo ""
echo "📄 See: PHASE4-TEST-SUMMARY.md for testing instructions"
echo ""
echo "To test manually:"
echo "  1. Create test project via Nexus"
echo "  2. Run: BA → Architect → Planner → Dev workflow"
echo "  3. Verify state updates at each step"
echo "  4. Measure tokens with /context command"
echo ""
