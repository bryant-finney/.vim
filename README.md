# dotvim

Yet another Neovim configuration with partial legacy support for Vim.

## Purpose

This repository contains a comprehensive Vim/Neovim configuration featuring:

- **LSP Integration**: Native LSP support for Python (pyright, ruff), Lua (lua_ls), JavaScript/TypeScript (eslint), and TOML (taplo)
- **Plugin Management**: Extensive plugin ecosystem managed via vim-plug
- **AI Assistance**: GitHub Copilot and CopilotChat integration
- **Git Integration**: vimagit, vim-gitgutter, and Octo.nvim for seamless version control
- **Code Quality**: ALE for async linting with auto-fix on save
- **Testing Infrastructure**: Automated test suite for LSP servers and configuration validation

## Prerequisites

- **Neovim**: v0.9.0 or higher (for full LSP and Lua support)
- **Vim**: v8.0+ (for legacy support, limited features)
- **Python**: 3.10 or higher
- **Node.js**: Required for some LSP servers (eslint)
- **direnv**: For automatic environment setup
- **uv**: Python package manager (auto-installed by direnv)

### Optional Dependencies

- **ripgrep**: For Telescope fuzzy finding
- **fd**: Enhanced file discovery for Telescope
- **taplo**: TOML language server
- **lua-language-server**: Lua LSP

## Setup

### 1. Install direnv

```bash
# macOS
brew install direnv

# Linux (Debian/Ubuntu)
sudo apt install direnv

# Or use your package manager of choice
```

Add direnv hook to your shell configuration:

```bash
# For bash: add to ~/.bashrc
eval "$(direnv hook bash)"

# For zsh: add to ~/.zshrc
eval "$(direnv hook zsh)"
```

### 2. Clone and Initialize

```bash
# Clone to ~/.vim
git clone git@github.com:bryant-finney/.vim.git ~/.vim
cd ~/.vim

# Allow direnv to load the environment
direnv allow
```

The `.envrc` file will automatically:

- Install `uv` (if not present)
- Create a Python virtual environment
- Install development dependencies
- Configure pre-commit hooks
- Set up environment variables

### 3. Install Vim Plugins

Open Vim/Neovim and run:

```vim
:PlugInstall
:UpdateRemotePlugins
```

## Running the Test Suite

The test suite validates LSP server functionality, configuration settings, and code quality tools. It is executed using `poethepoet` (the `poe` CLI) as configured in [`pyproject.toml`](pyproject.toml):

```bash
poe test
```

## Running Linters and Formatters

Linters, formatters, and static analysis tools are managed with [`pre-commit`](https://pre-commit.com/) (per [`.pre-commit-config.yaml`](.pre-commit-config.yaml)). To run the tools manually:

```bash
pre-commit run --all-files
```

## Repo Structure

- `after/`: Runtime path files loaded after default runtime files
  - `syntax/`: Custom syntax highlighting overrides
- **`autoload/`**: Auto-loaded Vim functions and plugin managers
  - Contains vim-plug installation
- **`bin/`**: Utility scripts and executables
- **`ftplugin/`**: Filetype-specific settings and configurations
- **`lua/`**: Neovim Lua configuration modules
  - `config.lua`: Main LSP and plugin configuration
  - `{lsp}.lua`: Individual LSP server configurations (pyright, ruff, lua_ls, eslint, taplo)
- **`plugged/`**: vim-plug plugin installations
- **`plugin/`**: Custom plugin scripts
  - `author.vim`: Author information for snippets
- **`spell/`**: Custom spelling dictionaries
- **`tests/`**: Test suite for configuration and LSP functionality
  - `*.lua`: Neovim test scripts for LSP servers
  - `*.py`: Python test scripts for syntax checking and validation
  - `fixtures/`: Test fixture files (intentionally malformed for testing)
- **`typings/`**: Python type stubs for external packages

### Configuration Files

- **`vimrc`**: Main Vim/Neovim configuration file
- **`.envrc`**: direnv configuration for automatic environment setup
- **`.luarc.json`**: Lua language server workspace configuration
- **`.taplo.toml`**: Taplo TOML formatter configuration
- **`pyproject.toml`**: Python project configuration (poe tasks, ruff, mypy, pyright)
- **`eslint.config.mjs`**: ESLint configuration
- **`.pre-commit-config.yaml`**: Pre-commit hooks configuration
- **`.python-version`**: Python version specification
- **`CLAUDE.md`**: Claude Code project-specific instructions

## Key Features

### Custom Keybindings

- **Navigation**: Cmd+arrows for macOS-style cursor movement
- **Line Manipulation**: Shift+Cmd+J/K to move lines, Ctrl+Shift+Cmd+J/K to copy lines
- **Git**: `gs` to open vimagit, `AJ`/`AK` for ALE error navigation
- **Window Management**: `W{hjkl}` for split navigation, `W{HJKL}` to move splits

### LSP Features

- **Auto-completion**: Native LSP completion
- **Go-to-definition**: `gd` in normal mode
- **Hover documentation**: `K` in normal mode
- **Format on save**: Automatic formatting via LSP and ALE

### Auto-formatting

Files are automatically formatted on save:

- **Python**: ruff (via ALE)
- **JavaScript/TypeScript/CSS/YAML/Markdown**: prettier (via ALE)
- **TOML**: taplo (via LSP)
- **Shell**: shfmt (via ALE)

## Maintenance Scripts

TODO: are these still useful?

- **`create_links.sh`**: Create symlinks for plugin files
- **`clear_links.sh`**: Remove plugin symlinks
- **`update_gitignore.sh`**: Update `.gitignore` based on patterns
