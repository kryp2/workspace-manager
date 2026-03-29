#!/bin/bash
set -euo pipefail

# Ensure we're in the script's directory
cd "$(dirname "$0")"

# ANSI Colors
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Workspace Manager: Orchestrator ===${NC}"

# Ensure scripts are executable
chmod +x setup.sh sync-configs.sh fetch-repos.sh

# 1. Fetch Repositories
if [[ ! -s "repos.txt" ]]; then
    echo "repos.txt is empty or missing."
    echo "Would you like to fetch your repositories automatically from GitHub now? (y/n)"
    read -p "> " fetch_choice
    if [[ "$fetch_choice" == "y" ]]; then
        ./fetch-repos.sh
    fi
else
    echo "repos.txt already contains repository links."
    echo "Would you like to fetch new/updated repositories dynamically from GitHub? (y/n)"
    read -p "> " fetch_choice
    if [[ "$fetch_choice" == "y" ]]; then
        ./fetch-repos.sh
    fi
fi

# 2. Configure Private Configs
if [[ ! -s "config-repo-url.txt" ]]; then
    echo -e "\n${BLUE}Configuring private workspace folders (.gemini, .claude):${NC}"
    echo "Please provide the URL to your private configuration repository (optional):"
    read -p "URL: " repo_url
    if [[ ! -z "$repo_url" ]]; then
        echo "$repo_url" > config-repo-url.txt
    fi
else
    current_url=$(cat config-repo-url.txt)
    echo -e "\nCurrent config-repo: ${BLUE}$current_url${NC}"
    echo "Would you like to change this URL? (y/n)"
    read -p "> " change_config
    if [[ "$change_config" == "y" ]]; then
        echo "Provide the new URL for your private configuration repository:"
        read -p "URL: " repo_url
        echo "$repo_url" > config-repo-url.txt
    fi
fi

# 3. Start Orchestration
echo -e "\n${BLUE}Starting ecosystem orchestration...${NC}"
./setup.sh
./sync-configs.sh

echo -e "\n${BLUE}=== Deployment Complete! ===${NC}"
echo "Your ecosystem has been successfully deployed to ~/workspace"
