# Neovim Health Check

> Generated on 2026-04-05 by `poe test-checkhealth`

## Summary

| Section                             | Status | OK   | Warnings | Errors |
| ----------------------------------- | ------ | ---- | -------- | ------ |
| [CopilotChat](#copilotchat)         | ⚠️     | 14   | 1        | 0      |
| [deoplete](#deoplete)               | ✅     | 5    | 0        | 0      |
| [lspconfig](#lspconfig)             | ✅     | 0    | 0        | 0      |
| [nvim-treesitter](#nvim-treesitter) | ⚠️     | 4    | 1        | 0      |
| [telescope](#telescope)             | ✅     | 4    | 0        | 0      |
| [vim.deprecated](#vimdeprecated)    | ✅     | 1    | 0        | 0      |
| [vim.health](#vimhealth)            | ✅     | 8    | 0        | 0      |
| [vim.lsp](#vimlsp)                  | ⚠️     | 0    | 2        | 0      |
| [vim.pack](#vimpack)                | ✅     | 1    | 0        | 0      |
| [vim.provider](#vimprovider)        | ⚠️     | 3    | 1        | 0      |
| [vim.treesitter](#vimtreesitter)    | ✅     | 1496 | 0        | 0      |

## CopilotChat

### CopilotChat.nvim [core]

- ✅ nvim: NVIM v0.12.0
  Build type: Release
  LuaJIT 2.1.1774896198
  Run "nvim -V1 -v" for more info
- ✅ initialized: true
- ✅ temp dir: writable (/tmp/lua_bzESSI)

### CopilotChat.nvim [commands]

- ✅ curl: curl 8.7.1 (x86_64-apple-darwin25.0) libcurl/8.7.1 (SecureTransport) LibreSSL/3.3.6 zlib/1.2.12 nghttp2/1.68.0
  Release-Date: 2024-03-27
  Protocols: dict file ftp ftps gopher gophers http https imap imaps ipfs ipns ldap ldaps mqtt pop3 pop3s rtsp smb smbs smtp smtps telnet tftp
  Features: alt-svc AsynchDNS GSS-API HSTS HTTP2 HTTPS-proxy IPv6 Kerberos Largefile libz MultiSSL NTLM SPNEGO SSL threadsafe UnixSockets
- ✅ git: git version 2.50.1 (Apple Git-155)
- ✅ rg: ripgrep 15.1.0
  features:+pcre2
  simd(compile):+NEON
  simd(runtime):+NEON
  PCRE2 10.45 is available (JIT is available)
- ✅ lynx: Lynx Version 2.9.2 (31 May 2024)
  libwww-FM 2.14, SSL-MM 1.4.1, OpenSSL 3.6.1, ncurses 6.6.20251230
  Built on darwin24.2.0 (May 31 2024 23:03:20).
  Copyrights held by the Lynx Developers Group,
  the University of Kansas, CERN, and other contributors.
  Distributed under the GNU General Public License (Version 2).
  *...(2 more lines)*
- ✅ gh: gh version 2.89.0 (2026-03-26)
  https://github.com/cli/cli/releases/tag/v2.89.0

### CopilotChat.nvim [dependencies]

- ✅ plenary: installed
- ✅ copilot: copilot.vim
- ✅ vim.ui.select: overridden by `@/Users/bf/.vim/plugged/telescope-ui-select.nvim/lua/telescope/_extensions/ui-select.lua`
- ⚠️ tiktoken_core: missing, optional for accurate token counting. See README for installation instructions.
- ✅ treesitter\[markdown\]: installed
- ✅ treesitter\[markdown/copilotchat\]: found
- ✅ treesitter\[diff\]: installed

## deoplete

### deoplete.nvim

- ✅ exists("v:t_list") was successful

- ✅ has("timers") was successful

- ✅ has("python3") was successful

- ✅ Require Python 3.6.1+ was successful

- ✅ Require msgpack 1.0.0+ was successful

- If you're still having problems, try the following commands:
  \- $ export NVIM_PYTHON_LOG_FILE=/tmp/log
  \- $ export NVIM_PYTHON_LOG_LEVEL=DEBUG
  \- $ nvim
  \- $ cat /tmp/log\_{PID}
  \- and then create an issue on github

## lspconfig

- Skipped. This healthcheck is redundant with `:checkhealth vim.lsp`.

## nvim-treesitter

*311 parsers with feature support. Run `:checkhealth nvim-treesitter` for full matrix.*

### Installation

- ⚠️ `tree-sitter` executable not found (parser generator, only needed for :TSInstallFromGrammar, not required for :TSInstall)
- ✅ `node` found v25.9.0 (only needed for :TSInstallFromGrammar)
- ✅ `git` executable found.
- ✅ `cc` executable found. Selected from { vim.NIL, "cc", "gcc", "clang", "cl", "zig" }
  Version: Apple clang version 21.0.0 (clang-2100.0.123.102)
- ✅ Neovim was compiled with tree-sitter runtime ABI version 15 (required >=13). Parsers must be compatible with runtime ABI.

*(11 additional info lines omitted)*

## telescope

### Checking for required plugins

- ✅ plenary installed.
- ✅ nvim-treesitter installed.

### Checking external dependencies

- ✅ rg: found ripgrep 15.1.0
- ✅ fd: found fd 10.4.2

### Installed extensions

### Telescope Extension: `ui-select`

- No healthcheck provided

## vim.deprecated

- ✅ No deprecated functions detected

## vim.health

### System Info

- Nvim version: `v0.12.0`
- Operating system: Darwin 25.4.0
- Terminal: WezTerm 20240203-110809-5046fc22
- $TERM: xterm-256color

### Configuration

- ✅ no issues found

### Runtime

- ✅ $VIMRUNTIME: /opt/homebrew/Cellar/neovim/0.12.0/share/nvim/runtime

### Performance

- ✅ Build type: Release

### Remote Plugins

- ✅ Up to date

### Terminal

- key_backspace (kbs) terminfo entry: `key_backspace=^H`
- key_dc (kdch1) terminfo entry: `key_dc=\E[3~`
- $TERM_PROGRAM="WezTerm"
- $COLORTERM="truecolor"

### External Tools

- ✅ ripgrep 15.1.0 (/opt/homebrew/bin/rg)
- ✅ vim.ui.open: handler found (open)
- ✅ git version 2.50.1 (Apple Git-155) (/usr/bin/git)
- ✅ curl 8.7.1 (/usr/bin/curl)
  curl 8.7.1 (x86_64-apple-darwin25.0) libcurl/8.7.1 (SecureTransport) LibreSSL/3.3.6 zlib/1.2.12 nghttp2/1.68.0
  Release-Date: 2024-03-27
  Protocols: dict file ftp ftps gopher gophers http https imap imaps ipfs ipns ldap ldaps mqtt pop3 pop3s rtsp smb smbs smtp smtps telnet tftp
  Features: alt-svc AsynchDNS GSS-API HSTS HTTP2 HTTPS-proxy IPv6 Kerberos Largefile libz MultiSSL NTLM SPNEGO SSL threadsafe UnixSockets

## vim.lsp

- LSP log level : WARN
- Log path: /Users/bf/.local/state/nvim/lsp.log
- Log size: 3270 KB

### vim.lsp: Active Features

### vim.lsp: Active Clients

- No active clients

### vim.lsp: Enabled Configurations

- ⚠️ 'vscode-eslint-language-server' is not executable. Configuration will not be used.

#### eslint

- **before_init:** `/Users/bf/.config/nvim/pack/nvim/start/nvim-lspconfig/lsp/eslint.lua:120`

- **cmd:** `vscode-eslint-language-server --stdio`

- **filetypes:** `javascript`, `javascriptreact`, `typescript`, `typescriptreact`, `vue`, `svelte`, `astro`, `htmlangular`

- **on_attach:** `/Users/bf/.config/nvim/pack/nvim/start/nvim-lspconfig/lsp/eslint.lua:51`

- **root_dir:** `/Users/bf/.config/nvim/pack/nvim/start/nvim-lspconfig/lsp/eslint.lua:65`

- **workspace_required:** true

- ⚠️ 'vscode-json-language-server' is not executable. Configuration will not be used.

#### jsonls

- **cmd:** `vscode-json-language-server --stdio`
- **filetypes:** `json`, `jsonc`
- **root_markers:** `.git`

#### lua_ls

- **cmd:** `lua-language-server`
- **filetypes:** `lua`
- **root_markers:** `.luarc.json`, `.luarc.jsonc`, `.luacheckrc`, `.stylua.toml`, `stylua.toml`, `selene.toml`, `selene.yml`, `.git`

#### pyright

- **cmd:** `pyright-langserver --stdio`
- **filetypes:** `python`
- **on_attach:** `/Users/bf/.config/nvim/pack/nvim/start/nvim-lspconfig/lsp/pyright.lua:43`
- **root_markers:** `pyproject.toml`, `setup.py`, `setup.cfg`, `requirements.txt`, `Pipfile`, `pyrightconfig.json`, `.git`

#### ruff

- **cmd:** `ruff server`
- **filetypes:** `python`
- **root_markers:** `pyproject.toml`, `ruff.toml`, `.ruff.toml`, `.git`

#### taplo

- **cmd:** `taplo lsp stdio`
- **filetypes:** `toml`
- **on_attach:** `/Users/bf/.vim/lua/taplo.lua:8`
- **root_markers:** `.taplo.toml`, `taplo.toml`, `.git`

### vim.lsp: File Watcher

- file watching "(workspace/didChangeWatchedFiles)" disabled on all clients

### vim.lsp: Position Encodings

- No active clients

## vim.pack

### vim.pack: basics

- ✅ `vim.pack` is not used

## vim.provider

### Clipboard (optional)

- ✅ Clipboard tool found: pbcopy

### Node.js provider (optional)

- ⚠️ Package "neovim" is out-of-date. Installed: 5.3.0, latest: 5.4.0

  - **Advice:** Run in shell: npm install -g neovim
  - **Advice:** Run in shell (if you use yarn): yarn global add neovim
  - **Advice:** Run in shell (if you use pnpm): pnpm install -g neovim

- Node.js: 25.9.0

- Nvim node.js host: /opt/homebrew/lib/node_modules/neovim/bin/cli.js

### Perl provider (optional)

- Disabled (loaded_perl_provider=0).

### Python 3 provider (optional)

- ✅ Latest pynvim is installed.

- pyenv: Path: /opt/homebrew/Cellar/pyenv/2.6.26/libexec/pyenv

- pyenv: Root: /Users/bf/.pyenv

- Using: g:python3_host_prog = "python3.12"

- Executable: /Users/bf/.vim/.venv/bin/python3.12

- Python version: 3.12.11

- pynvim version: 0.6.0

### Python virtualenv

- ✅ $VIRTUAL_ENV provides :!python.

- $VIRTUAL_ENV is set to: /Users/bf/.vim/.venv

- Python version: 3.12.11

### Ruby provider (optional)

- Disabled (loaded_ruby_provider=0).

## vim.treesitter

### Treesitter features

- Treesitter ABI support: min 13, max 15
- WASM parser support: false

### Treesitter parsers

*325 items checked (all OK). Run `:checkhealth vim.treesitter` for full list.*

### Treesitter queries

*1171 items checked (all OK). Run `:checkhealth vim.treesitter` for full list.*
