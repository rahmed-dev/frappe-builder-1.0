#!/usr/bin/env bash

#═══════════════════════════════════════════════════════════════════════════════
# Frappe-Builder Module - Standalone Installer
#═══════════════════════════════════════════════════════════════════════════════
# Version: 1.0.0
# Description: Installs Frappe-Builder module for Claude Code and Cursor IDE
# Components:
#   - 8 Agents (registers YAML files directly - no compilation needed)
#   - 10 Workflows
#   - Configuration files
#   - Slash command registration
#═══════════════════════════════════════════════════════════════════════════════

set -e  # Exit on error

#───────────────────────────────────────────────────────────────────────────────
# CONFIGURATION
#───────────────────────────────────────────────────────────────────────────────

MODULE_CODE="frappe-builder"
MODULE_NAME="Frappe-Builder"
MODULE_VERSION="1.0.0"

# Detect script directory (where module is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_SOURCE_DIR="$SCRIPT_DIR"

# Installation paths
DEFAULT_PROJECT_ROOT="${PROJECT_ROOT:-$(pwd)}"
BMAD_DIR="${DEFAULT_PROJECT_ROOT}/.bmad"
MODULE_INSTALL_DIR="${BMAD_DIR}/custom/modules/${MODULE_CODE}"
CLAUDE_COMMANDS_DIR="${DEFAULT_PROJECT_ROOT}/.claude/commands"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

#───────────────────────────────────────────────────────────────────────────────
# UTILITY FUNCTIONS
#───────────────────────────────────────────────────────────────────────────────

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

log_header() {
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo ""
}

prompt_user() {
    local prompt="$1"
    local default="$2"
    local response

    if [ -n "$default" ]; then
        read -p "$(echo -e "${CYAN}?${NC} ${prompt} [${default}]: ")" response
        echo "${response:-$default}"
    else
        read -p "$(echo -e "${CYAN}?${NC} ${prompt}: ")" response
        echo "$response"
    fi
}

#───────────────────────────────────────────────────────────────────────────────
# CONFIGURATION GENERATION
#───────────────────────────────────────────────────────────────────────────────

generate_config() {
    log_header "STEP 1: Generating Configuration"

    local config_file="${MODULE_INSTALL_DIR}/config.yaml"

    # Prompt user for configuration values
    echo ""
    log_info "Welcome to ${MODULE_NAME}!"
    log_info "Please provide the following configuration:"
    echo ""

    local frappe_bench_path=$(prompt_user "Path to your Frappe bench directory" "$DEFAULT_PROJECT_ROOT")
    local default_site=$(prompt_user "Default Frappe site name for development" "site1.local")
    local user_name=$(prompt_user "Your name (for personalized communication)" "$USER")
    local communication_language=$(prompt_user "Communication language" "English")
    local document_output_language=$(prompt_user "Document output language" "English")

    # Generate config.yaml
    cat > "$config_file" <<EOF
# ${MODULE_NAME} Configuration
# Generated: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
# Version: ${MODULE_VERSION}

# User Configuration
user_name: "${user_name}"
communication_language: "${communication_language}"
document_output_language: "${document_output_language}"

# Frappe Environment
frappe_bench_path: "${frappe_bench_path}"
default_site: "${default_site}"

# Module Paths
module_code: "${MODULE_CODE}"
module_version: "${MODULE_VERSION}"
project_root: "${DEFAULT_PROJECT_ROOT}"
bmad_folder: ".bmad"

# Knowledge Base and Data
kb_location: "${MODULE_INSTALL_DIR}/knowledge"
module_data_path: "${MODULE_INSTALL_DIR}/data"
standards_path: "${MODULE_INSTALL_DIR}/standards"
templates_path: "${MODULE_INSTALL_DIR}/templates"

# Derived Paths
apps_directory: "${frappe_bench_path}/apps"
sites_directory: "${frappe_bench_path}/sites"
output_folder: "${DEFAULT_PROJECT_ROOT}/docs"

# Custom Configuration Values
custom_agent_location: '{project-root}/.bmad/custom/agents'
custom_workflow_location: '{project-root}/.bmad/custom/workflows'
custom_module_location: '{project-root}/.bmad/custom/modules'
install_user_docs: true
EOF

    log_success "Configuration generated: config.yaml"
}

#───────────────────────────────────────────────────────────────────────────────
# DIRECTORY STRUCTURE SETUP
#───────────────────────────────────────────────────────────────────────────────

setup_module_structure() {
    log_header "STEP 2: Setting Up Module Structure"

    # If module is already at correct location, just verify
    if [ "$MODULE_SOURCE_DIR" == "$MODULE_INSTALL_DIR" ]; then
        log_info "Module already at installation location"
        log_success "Module structure verified"
        return 0
    fi

    # Create installation directories
    mkdir -p "${MODULE_INSTALL_DIR}"
    mkdir -p "${BMAD_DIR}/custom/agents"
    mkdir -p "${BMAD_DIR}/custom/workflows"

    # Copy or symlink module contents
    log_info "Installing module to ${MODULE_INSTALL_DIR}..."

    if command -v rsync >/dev/null 2>&1; then
        rsync -av --exclude='.git' --exclude='*.backup*' "${MODULE_SOURCE_DIR}/" "${MODULE_INSTALL_DIR}/"
        log_success "Module files copied via rsync"
    else
        cp -r "${MODULE_SOURCE_DIR}"/* "${MODULE_INSTALL_DIR}/"
        log_success "Module files copied"
    fi
}

#───────────────────────────────────────────────────────────────────────────────
# CLAUDE CODE REGISTRATION
#───────────────────────────────────────────────────────────────────────────────

register_claude_code() {
    log_header "STEP 3: Registering with Claude Code"

    mkdir -p "${CLAUDE_COMMANDS_DIR}/bmad/${MODULE_CODE}/agents"
    mkdir -p "${CLAUDE_COMMANDS_DIR}/bmad/${MODULE_CODE}/workflows"

    # Register agents
    log_info "Creating slash commands for agents..."
    local agent_count=0

    for agent_yaml in "${MODULE_INSTALL_DIR}/agents"/*.agent.yaml; do
        if [ -f "$agent_yaml" ]; then
            local agent_name=$(basename "$agent_yaml" .agent.yaml)
            local agent_cmd="${CLAUDE_COMMANDS_DIR}/bmad/${MODULE_CODE}/agents/${agent_name}.md"

            # Extract title from YAML
            local title=$(grep "^title:" "$agent_yaml" | sed 's/title: *"\(.*\)"/\1/' | tr -d '"')

            # Create slash command that loads the agent YAML
            cat > "$agent_cmd" <<EOF
---
name: "${agent_name}"
description: "${title}"
---

You must fully embody this agent's persona and follow all activation instructions exactly as specified. NEVER break character until given an exit command.

<agent-activation CRITICAL="TRUE">
1. LOAD the FULL agent file from ${MODULE_INSTALL_DIR}/agents/${agent_name}.agent.yaml
2. READ its entire contents - this contains the complete agent persona, menu, and instructions
3. Execute ALL activation steps exactly as written in the agent file
4. Follow the agent's persona and menu system precisely
5. Stay in character throughout the session
</agent-activation>
EOF
            ((agent_count++))
            log_success "Registered: /bmad:${MODULE_CODE}:agents:${agent_name}"
        fi
    done

    # Register workflows
    log_info "Creating slash commands for workflows..."
    local workflow_count=0

    for workflow_dir in "${MODULE_INSTALL_DIR}/workflows"/*; do
        if [ -d "$workflow_dir" ] && [ -f "$workflow_dir/workflow.yaml" ]; then
            local workflow_name=$(basename "$workflow_dir")
            local workflow_cmd="${CLAUDE_COMMANDS_DIR}/bmad/${MODULE_CODE}/workflows/${workflow_name}.md"

            # Extract description from workflow.yaml
            local description=$(grep "^description:" "$workflow_dir/workflow.yaml" | sed 's/description: *"\(.*\)"/\1/' | tr -d '"')

            # Create workflow slash command
            cat > "$workflow_cmd" <<EOF
---
name: "${workflow_name}"
description: "${description}"
---

Execute the ${workflow_name} workflow from the ${MODULE_NAME} module.

<workflow-execution CRITICAL="TRUE">
1. LOAD workflow configuration: ${MODULE_INSTALL_DIR}/workflows/${workflow_name}/workflow.yaml
2. LOAD workflow execution engine: {project-root}/.bmad/core/tasks/workflow.xml
3. Execute ALL workflow steps as defined in the instructions
4. Follow the workflow engine rules precisely
</workflow-execution>

Workflow Path: ${MODULE_INSTALL_DIR}/workflows/${workflow_name}/
EOF
            ((workflow_count++))
            log_success "Registered: /bmad:${MODULE_CODE}:workflows:${workflow_name}"
        fi
    done

    log_success "Registered ${agent_count} agents and ${workflow_count} workflows"
}

#───────────────────────────────────────────────────────────────────────────────
# CURSOR IDE REGISTRATION
#───────────────────────────────────────────────────────────────────────────────

register_cursor_ide() {
    log_header "STEP 4: Registering with Cursor IDE"

    local cursorrules_file="${DEFAULT_PROJECT_ROOT}/.cursorrules"

    # Build module section
    local cursor_section="
# ═══════════════════════════════════════════════════════════════════
# ${MODULE_NAME} - Custom BMAD Module
# ═══════════════════════════════════════════════════════════════════

## ${MODULE_NAME} Agents

Access via @agent-name or by loading agent YAML files directly:
"

    # Add each agent
    for agent_yaml in "${MODULE_INSTALL_DIR}/agents"/*.agent.yaml; do
        if [ -f "$agent_yaml" ]; then
            local agent_name=$(basename "$agent_yaml" .agent.yaml)
            local title=$(grep "^title:" "$agent_yaml" | sed 's/title: *"\(.*\)"/\1/' | tr -d '"')
            cursor_section+="
- @${agent_name}: ${title}
  Load: .bmad/custom/modules/${MODULE_CODE}/agents/${agent_name}.agent.yaml
"
        fi
    done

    cursor_section+="
## ${MODULE_NAME} Workflows

"

    # Add workflows
    for workflow_dir in "${MODULE_INSTALL_DIR}/workflows"/*; do
        if [ -d "$workflow_dir" ] && [ -f "$workflow_dir/workflow.yaml" ]; then
            local workflow_name=$(basename "$workflow_dir")
            local description=$(grep "^description:" "$workflow_dir/workflow.yaml" | sed 's/description: *"\(.*\)"/\1/' | tr -d '"')
            cursor_section+="
- ${workflow_name}: ${description}
  Load: .bmad/custom/modules/${MODULE_CODE}/workflows/${workflow_name}/workflow.yaml
"
        fi
    done

    cursor_section+="
## Module Configuration
Config: .bmad/custom/modules/${MODULE_CODE}/config.yaml
Knowledge: .bmad/custom/modules/${MODULE_CODE}/knowledge/
Standards: .bmad/custom/modules/${MODULE_CODE}/standards/
Templates: .bmad/custom/modules/${MODULE_CODE}/templates/
"

    # Append to .cursorrules
    if [ -f "$cursorrules_file" ]; then
        if ! grep -q "${MODULE_NAME} - Custom BMAD Module" "$cursorrules_file"; then
            echo "$cursor_section" >> "$cursorrules_file"
            log_success "Added ${MODULE_NAME} to .cursorrules"
        else
            log_warning ".cursorrules already contains ${MODULE_NAME} (skipping)"
        fi
    else
        echo "$cursor_section" > "$cursorrules_file"
        log_success "Created .cursorrules with ${MODULE_NAME}"
    fi
}

#───────────────────────────────────────────────────────────────────────────────
# VERIFICATION
#───────────────────────────────────────────────────────────────────────────────

verify_installation() {
    log_header "STEP 5: Verifying Installation"

    local errors=0

    # Check module directory
    if [ -d "$MODULE_INSTALL_DIR" ]; then
        log_success "Module directory exists"
    else
        log_error "Module directory missing"
        ((errors++))
    fi

    # Check config
    if [ -f "${MODULE_INSTALL_DIR}/config.yaml" ]; then
        log_success "Configuration file exists"
    else
        log_error "Configuration file missing"
        ((errors++))
    fi

    # Check agents
    local agent_count=$(find "${MODULE_INSTALL_DIR}/agents" -name "*.agent.yaml" 2>/dev/null | wc -l)
    if [ "$agent_count" -gt 0 ]; then
        log_success "Found ${agent_count} agent YAML files"
    else
        log_error "No agents found"
        ((errors++))
    fi

    # Check workflows
    local workflow_count=$(find "${MODULE_INSTALL_DIR}/workflows" -name "workflow.yaml" 2>/dev/null | wc -l)
    if [ "$workflow_count" -gt 0 ]; then
        log_success "Found ${workflow_count} workflows"
    else
        log_warning "No workflows found"
    fi

    # Check Claude commands
    if [ -d "${CLAUDE_COMMANDS_DIR}/bmad/${MODULE_CODE}" ]; then
        local cmd_count=$(find "${CLAUDE_COMMANDS_DIR}/bmad/${MODULE_CODE}" -name "*.md" 2>/dev/null | wc -l)
        log_success "Registered ${cmd_count} Claude Code commands"
    else
        log_error "Claude Code commands not registered"
        ((errors++))
    fi

    # Check Cursor integration
    if [ -f "${DEFAULT_PROJECT_ROOT}/.cursorrules" ] && grep -q "${MODULE_NAME}" "${DEFAULT_PROJECT_ROOT}/.cursorrules"; then
        log_success "Cursor IDE integration configured"
    else
        log_warning "Cursor IDE integration not found"
    fi

    return $errors
}

#───────────────────────────────────────────────────────────────────────────────
# POST-INSTALLATION INFO
#───────────────────────────────────────────────────────────────────────────────

show_post_install_info() {
    log_header "Installation Complete!"

    cat <<EOF
${GREEN}✓${NC} ${MODULE_NAME} ${MODULE_VERSION} has been successfully installed!

${CYAN}📁 Installation Location:${NC}
   ${MODULE_INSTALL_DIR}

${CYAN}🎯 Using the Module:${NC}

   ${YELLOW}Claude Code:${NC}
   - Type "/" to see available slash commands
   - Agents: /bmad:${MODULE_CODE}:agents:{name}
   - Workflows: /bmad:${MODULE_CODE}:workflows:{name}

   ${YELLOW}Cursor IDE:${NC}
   - Use @agent-name to reference agents
   - Configuration in .cursorrules

${CYAN}📚 Available Agents:${NC}
EOF

    for agent_yaml in "${MODULE_INSTALL_DIR}/agents"/*.agent.yaml; do
        if [ -f "$agent_yaml" ]; then
            local agent_name=$(basename "$agent_yaml" .agent.yaml)
            local title=$(grep "^title:" "$agent_yaml" | sed 's/title: *"\(.*\)"/\1/' | tr -d '"')
            echo "   • ${agent_name}: ${title}"
        fi
    done

    cat <<EOF

${CYAN}🔄 Available Workflows:${NC}
EOF

    for workflow_dir in "${MODULE_INSTALL_DIR}/workflows"/*; do
        if [ -d "$workflow_dir" ] && [ -f "$workflow_dir/workflow.yaml" ]; then
            local workflow_name=$(basename "$workflow_dir")
            echo "   • ${workflow_name}"
        fi
    done

    cat <<EOF

${CYAN}⚙️  Configuration:${NC}
   Edit: ${MODULE_INSTALL_DIR}/config.yaml

${CYAN}📖 Documentation:${NC}
   README: ${MODULE_INSTALL_DIR}/README.md

${CYAN}🔧 Troubleshooting:${NC}
   • Verify agents: ls ${MODULE_INSTALL_DIR}/agents/*.agent.yaml
   • Check config: cat ${MODULE_INSTALL_DIR}/config.yaml
   • Reinstall: $0

${GREEN}Happy coding with Frappe-Builder!${NC} 🚀

EOF
}

#───────────────────────────────────────────────────────────────────────────────
# MAIN INSTALLATION FLOW
#───────────────────────────────────────────────────────────────────────────────

main() {
    clear

    cat <<EOF
${CYAN}
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║        ${MODULE_NAME} Module Installer                             ║
║                 Version ${MODULE_VERSION}                               ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
${NC}

Installing module for:
  • Claude Code (slash commands)
  • Cursor IDE (.cursorrules integration)

Press Ctrl+C to cancel, or press Enter to continue...
EOF

    read -r

    # Execute installation steps
    setup_module_structure
    generate_config
    register_claude_code
    register_cursor_ide

    # Verify installation
    if verify_installation; then
        show_post_install_info
        exit 0
    else
        log_error "Installation completed with errors. Please review the output above."
        exit 1
    fi
}

#───────────────────────────────────────────────────────────────────────────────
# SCRIPT ENTRY POINT
#───────────────────────────────────────────────────────────────────────────────

# Check if running with --help
if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    cat <<EOF
${MODULE_NAME} Module Installer

Usage: $0 [OPTIONS]

Options:
  -h, --help          Show this help message
  --project-root DIR  Set project root directory (default: current directory)
  --uninstall         Uninstall the module

Description:
  Standalone installer for ${MODULE_NAME} module.

  This script:
    1. Sets up module directory structure
    2. Generates configuration from user input
    3. Registers module with Claude Code (slash commands)
    4. Integrates with Cursor IDE (.cursorrules)

Requirements:
  - Bash 4.0+
  - Basic Unix tools (sed, grep, find, mkdir, cp)

For more information, see: ${MODULE_SOURCE_DIR}/README.md
EOF
    exit 0
fi

# Handle uninstall
if [[ "${1:-}" == "--uninstall" ]]; then
    log_header "Uninstalling ${MODULE_NAME}"

    if [ -d "$MODULE_INSTALL_DIR" ]; then
        rm -rf "$MODULE_INSTALL_DIR"
        log_success "Removed module directory"
    fi

    if [ -d "${CLAUDE_COMMANDS_DIR}/bmad/${MODULE_CODE}" ]; then
        rm -rf "${CLAUDE_COMMANDS_DIR}/bmad/${MODULE_CODE}"
        log_success "Removed Claude Code commands"
    fi

    if [ -f "${DEFAULT_PROJECT_ROOT}/.cursorrules" ]; then
        log_info "Note: Please manually remove ${MODULE_NAME} section from .cursorrules"
    fi

    log_success "Uninstallation complete!"
    exit 0
fi

# Allow override of project root
if [[ "${1:-}" == "--project-root" ]]; then
    DEFAULT_PROJECT_ROOT="$2"
    shift 2
fi

# Run main installation
main "$@"
