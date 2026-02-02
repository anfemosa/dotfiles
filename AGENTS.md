# AGENTS.md - Development Guidelines for Dotfiles Repository

This repository contains personal shell configuration files using homeshick for dotfile management. Primary shell is zsh with bash support maintained.

## Build/Lint/Test Commands

### Shell Script Testing
```bash
# Test shell syntax
shellcheck home/.bashrc
shellcheck home/.zshrc
shellcheck home/.init_shell
shellcheck home/.dotfiles/*.sh

# Test specific function
bash -c "source home/.dotfiles/docker.sh && type dockbuild"
zsh -c "source home/.dotfiles/ros.sh && type sc_ws"
```

### Configuration Validation
```bash
# Validate zsh configuration
zsh -n home/.zshrc

# Validate bash configuration  
bash -n home/.bashrc

# Check homeshick setup
$HOME/.homesick/repos/homeshick/bin/homeshick check
```

### Docker/ROS Environment Testing
```bash
# Test docker functions
docker --version
dockbuild --help 2>/dev/null || echo "Function not loaded"

# Test ROS functions (only in ROS environment)
if command -v roscore >/dev/null 2>&1 || command -v ros2 >/dev/null 2>&1; then
    sc_ws
fi
```

## Code Style Guidelines

### Shell Script Standards
- Use **zsh** syntax for primary files, **bash** compatibility for .bashrc
- Indentation: **4 spaces** (no tabs)
- Line length: **max 100 characters**
- Quotes: **double quotes** for variables with spaces, single quotes for literals
- Functions: **snake_case** with descriptive names
- Variables: **UPPER_CASE** for exports, **lower_case** for local variables

### Import and Source Organization
```bash
# Order of operations in shell configs:
1. Prompt initialization (powerlevel10k)
2. Plugin manager (antidote)  
3. Core exports and PATH
4. Completion setup
5. Function definitions
6. Alias definitions
7. Conditional tool loading
```

### Error Handling
- Always check command existence before use: `command -v tool &>/dev/null`
- Validate function arguments: check count and values
- Use meaningful error messages with color codes
- Return proper exit codes (0 for success, 1 for errors)
- Clean up temporary state before error returns

### Naming Conventions
- **Files**: descriptive, lowercase with underscores (system.sh, git.sh)
- **Functions**: snake_case, verb-focused (sc_ws, dockbuild, clean_ws)
- **Aliases**: short, intuitive (ll, dpsa, cb, cbclean)
- **Variables**: UPPER_CASE for environment, lower_case for locals
- **Exports**: Descriptive names with tool prefixes (FZF_DEFAULT_COMMAND)

### Security Requirements
- **NEVER** use eval() or $(echo "$command") patterns
- **ALWAYS** validate user input in functions
- **NEVER** log sensitive data (passwords, keys, tokens)
- **ALWAYS** use absolute paths for critical operations
- **AVOID** command injection vulnerabilities in argument parsing

### Performance Considerations
- Defer expensive operations (homeshick refresh should not be on every shell start)
- Use lazy loading for heavy completions
- Cache frequently accessed data
- Minimize plugin load time - only load what's needed
- Consider shell startup time when adding new features

### ROS/Docker Function Patterns
- **Always** detect ROS_VERSION (1 vs 2) 
- **Always** validate ROS_DISTRO against supported versions
- **Always** provide help text for complex functions
- **Always** cleanup directory state before returns
- **Prefer** colcon for ROS2, catkin for ROS1

### Code Documentation
- Comment complex logic and workarounds
- Document function purpose and usage in help text
- Mark TODO/FIXME items clearly
- Explain non-obvious environment variable exports
- Include example usage in function help

## File Modification Guidelines

### When Editing Config Files:
1. **Read the entire file first** to understand context
2. **Maintain existing patterns** and coding style
3. **Test both zsh and bash** where applicable
4. **Validate syntax** before committing
5. **Check for existing aliases/functions** before adding new ones

### Adding New Tools:
1. Add to `.zsh_plugins.txt` for zsh plugins
2. Create conditional loading blocks in `.dotfiles/` modules  
3. Add aliases to system.sh or appropriate module
4. Update README with installation instructions
5. Test tool detection and fallback behavior

## Repository Structure
```
home/
├── .zshrc              # Primary zsh configuration
├── .bashrc             # Bash configuration  
├── .zsh_plugins.txt    # Antidote plugin list
├── .init_shell         # Shared initialization
├── .bash_aliases       # Command aliases
├── .p10k.zsh          # Powerlevel10k config
└── .dotfiles/          # Modular configurations
    ├── system.sh       # System aliases and functions
    ├── git.sh          # Git configurations  
    ├── docker.sh       # Docker/ROS workflows
    └── ros.sh          # ROS-specific functions
```

## Testing Before Commit
Always run these commands before committing changes:
```bash
# Syntax check all shell files
find home -name "*.sh" -exec shellcheck {} \;
shellcheck home/.bashrc home/.zshrc

# Configuration load test
zsh -c "source home/.zshrc && echo 'ZSH OK'"
bash -c "source home/.bashrc && echo 'BASH OK'"
```