#!/bin/bash
# Phase 4B Validation Script
# Checks that BA and Architect agent modifications are in place

cd /home/riz/frappe-bench/.bmad/custom/modules/frappe-builder/

echo "========================================"
echo "Phase 4B Agent Integration Validation"
echo "========================================"
echo ""

# a1 & a4: Check backups
echo "=== Backups ==="
if ls agents/erpnext-ba-sidecar/instructions.md.backup-pre-maker* 1> /dev/null 2>&1; then
    echo "✓ BA agent backed up"
else
    echo "✗ BA agent backup missing"
fi

if ls agents/frappe-architect-sidecar/instructions.md.backup-pre-maker* 1> /dev/null 2>&1; then
    echo "✓ Architect agent backed up"
else
    echo "✗ Architect agent backup missing"
fi
echo ""

# a2: Check BA startup
echo "=== BA Agent: Load active.yaml on startup ==="
if grep -q "MAKER Integration.*Project State" agents/erpnext-ba-sidecar/instructions.md; then
    echo "✓ BA loads active.yaml section exists"
else
    echo "✗ BA startup section missing"
fi
echo ""

# a3: Check BA state update
echo "=== BA Agent: Update state after BRD ==="
if grep -q "Update Project State After BRD" agents/erpnext-ba-sidecar/instructions.md; then
    echo "✓ BA state update section exists"
else
    echo "✗ BA state update section missing"
fi

if grep -q "GAP 4 FIX" agents/erpnext-ba-sidecar/instructions.md; then
    echo "✓ Gap 4 fix mentioned in BA agent"
else
    echo "✗ Gap 4 fix not mentioned"
fi

if grep -q "first 3 sentences\|up to 150 words" agents/erpnext-ba-sidecar/instructions.md; then
    echo "✓ Summary extraction logic documented"
else
    echo "✗ Summary extraction logic missing"
fi
echo ""

# a5: Check Architect startup
echo "=== Architect Agent: Load active.yaml on startup ==="
if grep -q "MAKER Integration.*BRD Discovery" agents/frappe-architect-sidecar/instructions.md; then
    echo "✓ Architect loads active.yaml section exists"
else
    echo "✗ Architect startup section missing"
fi

if grep -q "Auto-find BRD" agents/frappe-architect-sidecar/instructions.md; then
    echo "✓ BRD auto-discovery documented"
else
    echo "✗ BRD auto-discovery missing"
fi
echo ""

# a6: Check Architect state update
echo "=== Architect Agent: Update state after TSD ==="
if grep -q "Update Project State After TSD" agents/frappe-architect-sidecar/instructions.md; then
    echo "✓ Architect state update section exists"
else
    echo "✗ Architect state update section missing"
fi
echo ""

# Progress tracker
echo "=== Progress Tracker ==="
COMPLETED=$(grep "| \*\*4B\*\*.*\[x\]" future-plans/maker-integration/PHASE-4B-AGENT-INTEGRATION.md 2>/dev/null | wc -l)
echo "Completed tasks: $COMPLETED / 8"
echo ""

echo "========================================"
echo "Validation Summary"
echo "========================================"
echo ""
echo "📄 Files to review:"
echo "   - PHASE-4B-AGENT-INTEGRATION.md (main plan)"
echo "   - AGENT-ANALYSIS.md (rationale)"
echo ""
echo "Manual testing required (a7, a8):"
echo "  - Test BA agent with Nexus project"
echo "  - Test Architect agent auto-finds BRD"
echo "  - Verify state updates working"
echo ""
