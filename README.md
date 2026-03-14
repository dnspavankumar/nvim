# Neovim Competitive Programming Setup (C++)

This config is tuned for C++ competitive programming with VS Code-like shortcuts and CompetiTest integration.

## Core Features

- C++ compile/run via `g++` in `competitest.nvim`
- Competitive Companion receive support (port `27121`)
- Sidebar file explorer (`nvim-tree`)
- Floating terminal (`toggleterm`)
- File tabs / buffer bar (`bufferline`)
- Breadcrumbs in top bar (`barbecue` + `nvim-navic`)
- Editor scrollbar (`nvim-scrollbar`)
- Indentation scope matching/highlighting (`indent-blankline`)
- Visible `~` markers after end of file lines
- Ribbon-style statusline (powerline separators, auto adapts to current colorscheme)
- CompetiTest helper in right sidebar split layout
- Autocomplete, Treesitter, and LSP support
- Installed themes: `tokyonight-night` (default) and `gruvbox`

## Requirements

- Neovim `0.11+`
- `g++` in PATH
- Optional but recommended: `clangd` in PATH (for IDE features)
- Browser extension: Competitive Companion

## First Run

1. Open Neovim
2. Run `:Lazy sync`
3. Restart Neovim

## Leader Key

- `<leader>` is mapped to `Space`

## Keybindings

### Editing (VS Code style)

| Action | Keys | Mode |
|---|---|---|
| Copy line/selection | `Ctrl+C` | Normal/Visual/Insert |
| Paste | `Ctrl+V` | Normal/Visual/Insert |
| Cut line/selection | `Ctrl+X` | Normal/Visual/Insert |
| Select all | `Ctrl+A` | Normal/Insert |
| Save | `Ctrl+S` | Normal/Insert/Visual |
| Undo | `Ctrl+Z` | Normal/Insert |
| Redo | `Ctrl+Y` | Normal/Insert |
| Clear search highlight | `Esc` | Normal |

### Sidebar and Terminal

| Action | Keys | Mode |
|---|---|---|
| Toggle sidebar | `Ctrl+B` | Normal/Insert/Terminal |
| Toggle terminal | `Ctrl+\`` | Normal/Insert/Terminal |
| Terminal toggle fallback | `<leader>t` | Normal |

### File Tabs / Buffer Switching

| Action | Keys | Mode |
|---|---|---|
| Next file tab | `Ctrl+Tab` | Normal/Insert/Terminal |
| Previous file tab | `Ctrl+Shift+Tab` | Normal/Insert/Terminal |
| Next tab fallback | `Alt+Right` or `<leader>bn` | Normal |
| Previous tab fallback | `Alt+Left` or `<leader>bp` | Normal |
| Close current tab | `<leader>bd` | Normal |

### Competitive Programming (CompetiTest)

| Action | Keys | Mode |
|---|---|---|
| Run received testcases | `Ctrl+Alt+N` | Normal/Insert/Terminal |
| Run testcase fallback | `Alt+N` or `F5` | Normal |
| Open CP helper UI | `Ctrl+Alt+U` | Normal/Insert/Terminal |
| Open CP helper fallback | `<leader>cu` | Normal |
| Receive problem from Companion | `<leader>cp` | Normal |
| Add testcase | `<leader>ca` | Normal |
| Edit testcase | `<leader>ce` | Normal |
| Run testcases | `<leader>cr` | Normal |
| Delete testcase | `<leader>cd` | Normal |

### LSP Navigation (when `clangd` is installed)

| Action | Keys | Mode |
|---|---|---|
| Go to definition | `gd` | Normal |
| Go to declaration | `gD` | Normal |
| Go to implementation | `gi` | Normal |
| Find references | `gr` | Normal |
| Hover docs | `K` | Normal |
| Format file | `<leader>cf` | Normal |

## Competitive Companion Flow

1. Open a problem in browser
2. Click Competitive Companion extension
3. In Neovim, run with `Ctrl+Alt+N` (or `F5` fallback)
4. Open/reopen UI with `Ctrl+Alt+U`

## Notes

- Some terminals do not forward `Ctrl+Alt` combos correctly. Use provided fallbacks (`Alt+N`, `F5`, `<leader>cu`, `<leader>bn`, `<leader>bp`) if needed.
