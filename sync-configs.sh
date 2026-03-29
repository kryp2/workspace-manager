#!/bin/bash
set -euo pipefail

# Configuration
CONFIG_REPO_URL_FILE="config-repo-url.txt"
CONFIG_TEMP_DIR="$HOME/.workspace-configs-temp"
WORKSPACE_ROOT="${WORKSPACE_ROOT:-$HOME/workspace}"

# ANSI Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Syncing Private Workspace Configs ===${NC}"

# Check for config repo URL
if [[ ! -s "$CONFIG_REPO_URL_FILE" ]]; then
    echo -e "${RED}Skipping config sync: No private config URL provided.${NC}"
    echo "If you have private configs like .gemini or .claude, provide a URL in $CONFIG_REPO_URL_FILE"
    exit 0
fi

CONFIG_REPO_URL=$(xargs < "$CONFIG_REPO_URL_FILE")

# Clone or update the private repository
if [[ -d "$CONFIG_TEMP_DIR" ]]; then
    echo -e "${BLUE}Updating existing private configurations...${NC}"
    (cd "$CONFIG_TEMP_DIR" && git pull)
else
    echo -e "${BLUE}Cloning private configuration repository...${NC}"
    git clone "$CONFIG_REPO_URL" "$CONFIG_TEMP_DIR"
fi

# Function to safely link directories (never removes real directories)
sync_config_dir() {
    local dir_name="$1"
    local source_path="$CONFIG_TEMP_DIR/$dir_name"
    local target_path="$WORKSPACE_ROOT/$dir_name"
    local home_path="$HOME/$dir_name"

    if [[ ! -d "$source_path" ]]; then
        echo -e "${RED}Warning: $dir_name not found in the config repository.${NC}"
        return
    fi

    echo -e "${GREEN}Linking config: $dir_name...${NC}"

    for dest in "$target_path" "$home_path"; do
        if [[ -L "$dest" ]]; then
            rm "$dest"
        elif [[ -e "$dest" ]]; then
            echo -e "${RED}Warning: $dest already exists and is not a symlink, skipping.${NC}"
            continue
        fi
        ln -s "$source_path" "$dest"
        echo -e "  - Linked $dir_name → $dest"
    done
}

# Sync default configuration directories
mkdir -p "$WORKSPACE_ROOT"
sync_config_dir ".gemini"
sync_config_dir ".claude"

# Add more directories as needed by adding sync_config_dir commands below

echo -e "\n${BLUE}=== Configuration Sync Complete! ===${NC}"
