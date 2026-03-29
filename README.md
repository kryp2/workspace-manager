# Workspace Manager Orchestrator

A lightweight, modular tool to orchestrate large development ecosystems. Automatically clone, update, and configure dozens of repositories with a single command.

## Features
- **Dynamic Repository Fetching**: Automatically list and fetch all repositories from a GitHub organization or user using `gh cli`.
- **Ecosystem Orchestration**: Clone or update multiple repositories to a central workspace folder.
- **Private Configuration Sync**: Manage private configuration folders (like `.gemini`, `.claude`, or SSH keys) via a separate private repository.
- **Symlink Management**: Automatically links private configurations to both the workspace root and your system's `$HOME` directory.

## Getting Started

### 1. Installation
Clone this orchestrator to your machine:
```bash
git clone https://github.com/kryp2/workspace-manager.git
cd workspace-manager
```

### 2. Prerequisites
- **Git** installed.
- **GitHub CLI (`gh`)** installed (optional, but required for dynamic fetching).
  - Authenticate with: `gh auth login`

### 3. Usage
Run the main deployment script:
```bash
chmod +x deploy.sh
./deploy.sh
```

The script will guide you through:
1. Fetching your repository URLs.
2. Providing a URL for your private configuration repository (optional).
3. Orchestrating your entire ecosystem into `~/workspace`.

## Configuration
- **`repos.txt`**: A list of repository URLs to be managed.
- **`config-repo-url.txt`**: The URL of your private configuration repository.

## Architecture
Once deployed, your structure will look like this:
```text
~/
├── workspace/           # Central ecosystem root
│   ├── .gemini/        # Symlinked from private config repo
│   ├── .claude/        # Symlinked from private config repo
│   ├── project-repo-1/  # Managed by the orchestrator
│   ├── project-repo-2/
│   └── ...
```

## Contributing
Feel free to fork and submit pull requests for any features or bug fixes.

## License
MIT
