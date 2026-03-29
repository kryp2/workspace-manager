#!/bin/bash
set -euo pipefail

# ANSI Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Dynamic Repository Fetch (GitHub CLI) ===${NC}"

# Check for GitHub CLI installation
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed.${NC}"
    echo "Please install it via: sudo apt update && sudo apt install gh"
    exit 1
fi

# Check authentication status
if ! gh auth status &> /dev/null; then
    echo -e "${RED}Error: You are not authenticated with GitHub CLI.${NC}"
    echo "Please run: ${BLUE}gh auth login${NC}"
    exit 1
fi

# Request Organization/Username and Topic
read -p "GitHub Username or Organization: " ORG_NAME
read -p "Filter by topic (Optional, press Enter for all): " TOPIC

if [[ -z "$TOPIC" ]]; then
    echo -e "${BLUE}Fetching all repositories for $ORG_NAME...${NC}"
    gh repo list "$ORG_NAME" --limit 100 --json url -q '.[].url' >> repos.txt
else
    echo -e "${BLUE}Fetching repositories for $ORG_NAME with topic '$TOPIC'...${NC}"
    gh repo list "$ORG_NAME" --topic "$TOPIC" --limit 100 --json url -q '.[].url' >> repos.txt
fi

# Remove duplicate entries
sort -u -o repos.txt repos.txt

if [[ -s repos.txt ]]; then
    echo -e "${GREEN}Success! $(wc -l < repos.txt | xargs) repo URLs in repos.txt.${NC}"
else
    echo -e "${RED}Error: No repositories found. Check username or topic.${NC}"
fi
