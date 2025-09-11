# bash_tools
My useful bash tools for developer work

## Documentation for `bash_tools` Project

### Project Overview
**bash_tools** is a collection of Bash scripts and utilities designed to enhance developers' productivity. It provides tools for common development tasks, system administration, and automation.

### Project Structure
The project is organized as follows:

- **bin/**  
  Contains grouped Bash scripts, categorized by their functionality:
  - `_db` — scripts for database operations.
  - `_fs` — file system management tools.
  - `_rc` — configurations for the terminal environment.
  - `_git` — Git helper utilities.
  - `_k8s` — tools for interacting with Kubernetes.
  - `_kbd` — keyboard and shortcut tools.
  - `_mem` — utilities for memory monitoring and optimization.
  - `_mnt` — scripts for managing mounts.
  - `_net` — networking utilities.
  - `_prg` — process and system monitoring tools.
  - `_ssh` — SSH-related tools.
  - `_vpn` — VPN setup scripts.
  - `_other` — miscellaneous utilities.
  - `_sites` — scripts for web-related automations.
  - `_tools` — extra tools for various use cases.
  - `_backup` — backup creation/restoration tools.
  - `_device` — device interactions and management tools.
  - `_docker` — Docker management utilities.
  - `_dropbox` — Dropbox integration scripts.
  - `_datetime` — tools for working with dates and times.

- **LICENSE**  
  Contains details of the project's licensing.

- **README.md**  
  The main project description file you're reading.

- **add2.bashrc**  
  Script for appending specific configurations to `.bashrc`.

- **sample.bash_bin**  
  A sample script for demonstrating extensions or usage.

### Excluded Files and Directories
The following files and directories, as per the `.gitignore` configuration, are **not included** in the project repository or the documentation:
- `/.idea/`  
- Subdirectories and filenames within paths starting with `/__*`.

### Requirements
- A Unix-based system with a properly configured **Bash** shell.

### Features
- **Well-Organized**: Scripts separated into logical categories for easier navigation.
- **Modular**: Each script is designed for specific tasks and can be used independently.
- **Extendable**: Users can easily add their own scripts or modify existing ones as needed.

### Getting Started
1. Clone the repository:  
```shell script
git clone <repository-url>
```

2. Add the scripts or categories you need to your environment.
3. Update your `.bashrc` (optional) to include the `bash_tools/bin/` directory in your `PATH`:  
```shell script
export PATH="/path/to/bash_tools/bin:$PATH"
```

4. Load the new configurations with:  
```shell script
source ~/.bashrc
```


### License
Details regarding the project’s license are available in the **[LICENSE](./LICENSE)** file.

### Contributing
You are welcome to improve and expand **bash_tools**! Please follow standard Git workflows for contributions. If the project includes a `CONTRIBUTING.md` file, refer to it for the contribution guidelines. 

**Note**: This documentation excludes files and directories listed in the `.gitignore` configuration. For any missing explanations or additional details, please consult individual script documentation inside the respective directories.