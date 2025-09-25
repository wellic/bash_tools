# Troubleshooting

**Common Issues and Solutions**:

- **Scripts Not Found**:
  ```bash
  # Check if PATH includes bash_tools/bin
  echo $PATH | grep bash_tools
  ```

- **Permission Denied**:
  ```bash
  # Make scripts executable
  chmod +x /path/to/bash_tools/bin/script-name
  ```

- **Bash Version Issues**:
  ```bash
  # Check Bash version
  bash --version
  ```

- **Environment Setup**:
  ```bash
  # Reload bash configuration
  source ~/.bashrc
  ```
