# Neovim Competitive Programming Setup (C++)

This config is tuned for C++ competitive programming with VS Code-like shortcuts and CompetiTest integration.

## Core Features

- C++ compile/run via `g++` in `competitest.nvim`
- Competitive Companion receive support (port `27121`)
- File explorer (`mini.files`)
- Floating terminal (`toggleterm`)
- File tabs / buffer bar (`bufferline`)
- Breadcrumbs in top bar (`nvim-navic` )
- Editor scrollbar (`nvim-scrollbar`)
- Indentation scope matching/highlighting (`indent-blankline`)
- Ribbon-style statusline (powerline separators, auto adapts to current colorscheme)
- CompetiTest helper in right sidebar split layout
- Persistent editable C++ template (`:Template` or `:template`)
- Auto-fill template when opening an empty `.cpp` file
- `F5` Codeforces submit from inside Neovim
- Autocomplete, Treesitter, and LSP support
- Installed themes: `vesper` (default) and `gruvbox`

## Requirements

- Neovim `0.11+`
- `g++` in PATH
- Optional but recommended: `clangd` in PATH (for IDE features)
- Browser extension: Competitive Companion
- Optional but highly recommend: A nerd font. Suggested - JetBrains Nerd Font Mono

## First Run

1. Open Neovim
2. Run `:Lazy sync`
3. Restart Neovim

## Quick Start (Your Exact Workflow)

Use this flow each time you solve a Codeforces/online judge problem.

1. Open terminal in your solutions folder:
   - PowerShell:
     - `cd $HOME\codeforces`
     - `nvim`
2. In Chrome, open a problem on Codeforces (or another judge).
3. Click the Competitive Companion extension icon.
4. Switch to Neovim:
   - It will prompt how to save the received problem.
   - Choose `P` (Problem) to create a single problem file.
5. The file is created automatically (for example: `$HOME/codeforces/<contest>/<index>.cpp`).
6. Write your solution.
7. Run tests:
   - Preferred: `Alt+N`
   - Fallback: `Ctrl+Alt+N`
8. Submit to Codeforces directly from Neovim with `F5`.
9. Optional: edit your permanent C++ template with `:template`, save, and every new empty `.cpp` will auto-load it.

## Leader Key

- `<leader>` is mapped to `Space`

## Keybindings

It is highly recommended to learn vim-motions. It will help you experience the real power of Neovim. You can access the in-built guide using `:Tutor`.

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
| Fuzzy-find files | `<leader>ff` | Normal/Insert/Terminal |
| Next buffer | `<leader>bn` | Normal |
| Next buffer fallback | `Ctrl+Tab` | Normal |
| Previous buffer | `<leader>bp` | Normal |
| Previous buffer fallback | `Ctrl+Shift+Tab` | Normal |
| Close current buffer | `<leader>bd` | Normal |

### Competitive Programming (CompetiTest)

| Action | Keys | Mode |
|---|---|---|
| Run received testcases | `Ctrl+Alt+N` | Normal/Insert/Terminal |
| Run testcase fallback | `Alt+N` | Normal |
| Submit current file to Codeforces | `F5` | Normal |
| Open CP helper UI | `Ctrl+Alt+U` | Normal/Insert/Terminal |
| Open CP helper fallback | `<leader>cu` | Normal |
| Receive problem from Companion | `<leader>cp` | Normal |
| Add testcase | `<leader>ca` | Normal |
| Edit testcase | `<leader>ce` | Normal |
| Run testcases | `<leader>cr` | Normal |
| Delete testcase | `<leader>cd` | Normal |
| Edit persistent C++ template | `:Template` / `:template` | Command |
| Manual submit command | `:CFSubmit` | Command |
| Login for submit CLI | `:CFLogin` | Command |

### LSP Navigation (when `clangd` is installed)

| Action | Keys | Mode |
|---|---|---|
| Go to definition | `gd` | Normal |
| Go to declaration | `gD` | Normal |
| Go to implementation | `gi` | Normal |
| Find references | `gr` | Normal |
| Hover docs | `K` | Normal |
| Format file | `<leader>lf` | Normal |

To check all keymaps, do `<leader>?`.

## Competitive Companion Flow

1. Open a problem in browser.
2. Click Competitive Companion extension icon.
3. In Neovim, choose `P` when prompted to create the problem file.
4. Write your code in the created `.cpp` file.
5. Run tests with `Alt+N` (`Ctrl+Alt+N` fallback).
6. Submit with `F5` (`:CFSubmit` also works).
7. Open/reopen test UI with `Ctrl+Alt+U` (`<leader>cu` fallback).

## Codeforces Submit Setup

- `F5` uses `cf` CLI if available (`cf submit <contest> <problem> <file>`).
- If `cf` is not available, it tries `oj` (`oj submit -y <url> <file>`).
- If `oj` is not in PATH, it automatically falls back to `python -m onlinejudge_command.main submit -y <url> <file>`.
- First-time setup (one time): run `:CFLogin` and complete login in the terminal.
- Contest ID and problem index are auto-detected from Competitive Companion URL and saved in path format: `$HOME/codeforces/<contest>/<index>.cpp`.
- `F5` can also parse Codeforces URLs found in your source comments for older files.
- If you want a custom submit command, set it in Lua:
  - `vim.g.codeforces_submit_command = "your-command {contest} {problem} {file} {url}"`

## Notes

- Some terminals do not forward `Ctrl+Alt` combos correctly. Use provided fallbacks (`Alt+N`, `<leader>cu`, `<leader>bn`, `<leader>bp`) if needed.
- If problem receiving does not trigger from browser, run `<leader>cp` in Neovim to receive problem manually.
