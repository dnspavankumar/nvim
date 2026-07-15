-- Map leader to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load options, keymaps, and boot lazy.nvim
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

