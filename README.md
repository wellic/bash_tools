# bash_tools

My useful bash tools for developer work.

## Documentation for `bash_tools` Project

### Project Overview

**bash_tools** is a collection of Bash scripts and utilities designed to enhance developers' productivity. It provides tools for common development tasks, system administration, and automation.

---

### Project Structure

The project is organized as follows:

- **`bin/`** - The main directory containing all categorized Bash scripts:
  - **`_backup/`** — Scripts for creating, managing, and restoring system backups.
  - **`_datetime/`** — Utilities for working with dates, times, and scheduling operations.
  - **`_db/`** — Database management scripts including backups, queries, and administration tools.
  - **`_device/`** — Scripts for managing system devices, peripherals, and hardware interactions.
  - **`_docker/`** — Docker container management utilities, image handling, and containerization tools.
  - **`_dropbox/`** — Integration scripts for Dropbox file synchronization and cloud operations.
  - **`_fs/`** — File system management tools for searching, organizing, copying, and file operations.
  - **`_git/`** — Git helper utilities including branch management, commit operations, and version control shortcuts.
  - **`_install/`** — Install helpers for GitHub Releases (scripts print ready-to-run install commands; see `bin/_install/README.md`).
  - **`_k8s/`** — Kubernetes tools for cluster management, deployments, monitoring, and container orchestration.
  - **`_kbd/`** — Keyboard utilities, shortcut management, and input device configuration tools.
  - **`_mem/`** — Memory monitoring, optimization tools, and system performance utilities.
  - **`_mnt/`** — Mount point management scripts for file systems, drives, and network shares.
  - **`_net/`** — Network utilities for diagnostics, connectivity testing, and network configuration.
  - **`_other/`** — Miscellaneous utilities that don't fit into specific categories.
  - **`_prg/`** — Process monitoring, system administration, and program management tools.
  - **`_rc/`** — Shell environment configuration scripts and terminal customization tools.
  - **`_sites/`** — Web-related automation scripts for site management and deployment tasks.
  - **`_ssh/`** — SSH connection tools, key management, and remote server administration utilities.
  - **`_tmp/`** — Temporary scripts for ad-hoc tasks, prototyping, and one-time operations.
  - **`_tools/`** — General-purpose tools and utilities for various development and system tasks.
  - **`_vpn/`** — VPN setup, configuration, and management scripts.

- **`add2.bashrc`**:
  - Script for appending bash_tools configurations to your `.bashrc` file for easy environment setup.

- **`install_links`**:
  - Utility script for creating symbolic links and setting up the project environment.

- **`LICENSE`**:
  - Contains the project's licensing terms and conditions.

- **`README.md`**:
  - Main documentation file providing project overview and usage instructions.

- **`sample.bash_bin`**:
  - Example configuration file demonstrating how to extend and use the project tools.

---

### Requirements

To use **bash_tools**, you need:

- A Unix-based operating system (Linux or other Unix-like systems)
- **Bash** shell version 4.0 or higher
- Standard Unix utilities and commands

---

### Features

- **Comprehensive Tool Collection**: Over 20 categories of scripts covering development, system administration, and automation tasks
- **Organized Structure**: Logically categorized scripts for easy navigation and discovery
- **Modular Design**: Each script operates independently and can be combined for complex workflows
- **Cross-Platform Compatibility**: Works on most Unix-like systems
- **Easy Integration**: Simple setup process with environment configuration scripts
- **Extensible Framework**: Easy to add custom scripts or modify existing ones

---

### Getting Started

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd bash_tools
   ```

2. **Set Up Environment**:
  - Use the provided configuration script:
    ```bash
    ./add2.bashrc
    ```
  - Or manually add to your `.bashrc`:
    ```bash
    export PATH="$PATH:/path/to/bash_tools/bin"
    # Add individual categories as needed
    export PATH="$PATH:/path/to/bash_tools/bin/_git"
    export PATH="$PATH:/path/to/bash_tools/bin/_docker"
    # ... etc
    ```

3. **Create Symbolic Links** (optional):
   ```bash
   ./install_links
   ```

4. **Reload Your Shell**:
   ```bash
   source ~/.bashrc
   ```

5. **Start Using the Tools**:
  - Browse the `bin/` directory to find relevant scripts
  - Run scripts directly from the terminal once PATH is configured

---

### Usage Guidelines

1. **Review Before Execution**: Always examine scripts before running them, especially those that modify system settings or files
2. **Backup Important Data**: Use backup scripts in `_backup/` before making significant system changes
3. **Test in Safe Environment**: Test scripts in a development environment before using in production
4. **Read Documentation**: Check inline comments and documentation within individual scripts

---

### Excluded Files and Directories

The following are excluded from version control via `.gitignore`:

- `/.idea/` - IDE-specific configuration files
- Files and directories matching `/__*` patterns
- Temporary files and build artifacts

---

### License

This project is distributed under the terms specified in the [LICENSE](./LICENSE) file.

---

### Other Guides

- [CONTRIBUTING.md](./CONTRIBUTING.md)
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- [bin/_install/README.md](./bin/_install/README.md)

---

For additional help, refer to individual script documentation or open an issue in the project repository.
