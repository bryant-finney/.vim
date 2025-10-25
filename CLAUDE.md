# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Vim/Neovim configuration repository located at `~/.vim`. It contains a comprehensive setup with custom keybindings, plugin management via vim-plug, and both VimScript and Lua configurations.

## Architecture

### Configuration Structure

- **vimrc**: Main configuration file containing:
  - Custom keybindings for normal, insert, visual, and command modes
  - Plugin configurations (ALE, vim-markdown, vim-latex, etc.)
  - Auto-formatting and whitespace cleanup functions
  - Syntax highlighting customizations

- **lua/config.lua**: Neovim-specific Lua configuration for:
  - Telescope (fuzzy finder and UI selector)
  - LSP configurations (pyright, ruff, lua_ls, eslint)
  - CopilotChat integration
  - nvim-treesitter setup
  - Octo.nvim (GitHub integration)

- **plugin/**: Contains custom plugin scripts
  - `author.vim`: Author information for snippets

- **after/syntax/**: Custom syntax highlighting overrides

- **ftplugin/**: Filetype-specific settings

- **plugged/**: vim-plug installation directory (gitignored)

### Plugin Management

Plugins are managed via vim-plug. Installation command:
```vim
:PlugInstall
```

Update plugins:
```vim
:PlugUpdate
```

Clean unused plugins:
```vim
:PlugClean
```

### Key Plugin Categories

1. **Language Support**:
   - Python: jedi-vim, black, semshi
   - LaTeX: vim-latex
   - Terraform: vim-terraform, vim-terraform-completion
   - Markdown: vim-markdown
   - JSON: vim-json
   - GraphQL: vim-graphql

2. **Linting & Formatting**: ALE (Asynchronous Lint Engine)
   - Auto-fixes on save for multiple languages
   - Python: ruff, mypy, bandit
   - Shell: shellcheck, shfmt
   - JavaScript/TypeScript/CSS/YAML/TOML: prettier

3. **Git Integration**:
   - vim-gitgutter: Shows git diff in gutter
   - vimagit: Git interface (open with `gs` in normal mode)
   - Octo.nvim: GitHub PR/issue management

4. **AI Assistance**:
   - copilot.vim
   - CopilotChat.nvim

5. **Editing Enhancement**:
   - vim-surround: Manage surrounding quotes/brackets
   - auto-pairs: Auto-close brackets/quotes
   - vim-visual-multi: Multiple cursors

## Key Mappings

### Navigation
- `<D-Left>` / `<D-Right>`: Move to beginning/end of line (Cmd+arrow on Mac)
- `<D-Up>` / `<D-Down>`: Move to beginning/end of file
- `<C-Left>` / `<C-Right>`: Word boundary navigation

### Line Manipulation
- `<S-D-J>` / `<S-D-K>`: Move line up/down
- `<C-S-D-J>` / `<C-S-D-K>`: Copy line up/down
- `<D-[>` / `<D-]>`: Indent/dedent (preserves cursor position)

### Git
- `gs`: Open vimagit interface

### ALE Navigation
- `AJ`: Next ALE error
- `AK`: Previous ALE error

### Window Management
- `Wh`, `Wj`, `Wl`, `Wk`: Navigate splits
- `WH`, `WJ`, `WL`, `WK`: Move splits

## Code Formatting

### Automatic Formatting on Save

- **Python**: Formatted with ruff and ruff_format via ALE
- **JSON**: Formatted with python's json.tool
- **Shell**: Formatted with shfmt (options: `-i 2 -ci -kp`)
- **JavaScript/TypeScript/CSS/YAML/TOML/Markdown**: Formatted with prettier

### Whitespace Management

The `TrimWhitespace()` function automatically:
- Removes trailing whitespace
- Converts tabs to spaces (for C, C++, markdown, tex, vim files)

## LSP Configuration (Neovim)

When running in Neovim, LSP servers are configured in `lua/config.lua`:

- **pyright**: Python type checking (with import organization disabled, using ruff instead)
- **ruff**: Python linting and formatting
- **lua_ls**: Lua language server
- **eslint**: JavaScript/TypeScript linting

## Development Workflow

### Reload Configuration
```vim
:Reload
```
This sources `$MYVIMRC` to apply configuration changes without restarting.

### Link Plugin Files
The `create_links.sh` script creates symlinks for black and ultisnips plugin files into the appropriate vim directories.

### Working with Python
- ALE automatically uses pipenv/poetry when detected
- Python 3 host program: `python3`
- Linters: mypy, ruff
- Formatters: ruff, ruff_format

### Working with GitHub
- Octo.nvim provides extensive GitHub integration
- Use `:Octo` commands for PR and issue management
- Extensive keybindings available under `<localleader>` prefix

## Color Scheme

Uses `slate` colorscheme with custom highlighting functions:
- `PrettyColors()`: Applied to most file types
- `GitPrettyColors()`: Applied to git commit messages
- `TodoPrettyColors()`: Highlights TODO and NOTE comments
- Background transparency enabled for terminal use

## Recent Fixes (2025-10-25)

### ESLint Language Server Installation
The ESLint LSP server is now installed via npm:
```bash
npm install -g vscode-langservers-extracted
```
This package provides language servers for: eslint, html, css, and json.

### nvim-lspconfig Plugin Management
nvim-lspconfig is now managed via vim-plug (previously was manually installed in `~/.config/nvim/pack/`). This ensures consistent updates through `:PlugUpdate`.

### ipkg Parser Issue
The ipkg treesitter parser was causing installation errors and has been removed. The parser is listed in `ignore_install` but treesitter still tried to install it. If it reappears, manually remove with:
```vim
:TSUninstall ipkg
```

### Plugin Organization
- Neovim-specific plugins (lspconfig, plenary, CopilotChat, telescope, treesitter, octo, semshi) are now properly wrapped in `if has('nvim')` conditionals
- This maintains full compatibility with classic Vim while enabling enhanced Neovim features

## Compatibility Notes

- Configuration works with both Vim and Neovim
- Neovim-specific features loaded conditionally via `has('nvim')`
- Platform-specific keybindings for macOS vs other systems (detected via `has('macunix')`)
- Classic Vim uses deoplete with nvim-yarp and vim-hug-neovim-rpc for compatibility
- Neovim uses native remote plugin support
