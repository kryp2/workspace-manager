#!/bin/bash
set -euo pipefail

# Configuration - Defaults to ~/workspace
WORKSPACE_ROOT="${WORKSPACE_ROOT:-$HOME/workspace}"
REPOS_FILE="repos.txt"

# ANSI Colors for Output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Workspace Manager: Orchestrating Ecosystem ===${NC}"

# Create workspace root if it doesn't exist
mkdir -p "$WORKSPACE_ROOT"

# Check if repos.txt exists
if [[ ! -f "$REPOS_FILE" ]]; then
    echo -e "${RED}Error: $REPOS_FILE not found!${NC}"
    echo "Please create a $REPOS_FILE with a list of repository URLs."
    exit 1
fi

# Iterate through each repository in the file
while IFS= read -r repo_url || [[ -n "$repo_url" ]]; do
    # Skip comments and empty lines
    [[ "$repo_url" =~ ^#.* ]] || [[ -z "$repo_url" ]] && continue

    # Extract repo name from URL
    repo_name=$(basename "$repo_url" .git)
    
    echo -e "\n${BLUE}Processing module: $repo_name...${NC}"

    if [[ -d "$WORKSPACE_ROOT/$repo_name" ]]; then
        echo -e "${GREEN}Module already exists. Updating via git pull...${NC}"
        (cd "$WORKSPACE_ROOT/$repo_name" && git pull)
    else
        echo -e "${GREEN}Cloning module from $repo_url...${NC}"
        git clone "$repo_url" "$WORKSPACE_ROOT/$repo_name"
    fi
done < "$REPOS_FILE"

echo -e "\n${BLUE}=== Workspace Manager: Orchestration Complete! ===${NC}"
echo "Your ecosystem is ready at: $WORKSPACE_ROOT"
