local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- better up/down
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- VS Code-like editing shortcuts
map("n", "<C-c>", 'yy', vim.tbl_extend("force", opts, { desc = "Copy line" }))
map({ "x", "v" }, "<C-c>", 'y', vim.tbl_extend("force", opts, { desc = "Copy selection" }))
map("i", "<C-c>", '<Esc>"+yygi', vim.tbl_extend("force", opts, { desc = "Copy line" }))
map("n", "<C-v>", 'p', vim.tbl_extend("force", opts, { desc = "Paste" }))
map("x", "<C-v>", 'p', vim.tbl_extend("force", opts, { desc = "Paste over selection" }))
map("i", "<C-v>", "<C-r>+", vim.tbl_extend("force", opts, { desc = "Paste in insert mode" }))
map("n", "<C-x>", 'dd', vim.tbl_extend("force", opts, { desc = "Cut line" }))
map("x", "<C-x>", 'd', vim.tbl_extend("force", opts, { desc = "Cut selection" }))
map("i", "<C-x>", '<Esc>ddgi', vim.tbl_extend("force", opts, { desc = "Cut line" }))
map("n", "<C-a>", "ggyG<c-o>", vim.tbl_extend("force", opts, { desc = "Select all" }))
map("i", "<C-a>", "<Esc>ggyG<c-o>", vim.tbl_extend("force", opts, { desc = "Select all" }))
map({ "n", "v" }, "<C-s>", "<esc><cmd>w<CR>", vim.tbl_extend("force", opts, { desc = "Save file" }))
map("i", "<C-s>", "<Esc><cmd>w<CR>a", vim.tbl_extend("force", opts, { desc = "Save file" }))
map("n", "<C-z>", "u", vim.tbl_extend("force", opts, { desc = "Undo" }))
map("i", "<C-z>", "<esc>u", vim.tbl_extend("force", opts, { desc = "Undo" }))
map("n", "<C-y>", "<C-r>", vim.tbl_extend("force", opts, { desc = "Redo" }))
map("i", "<C-y>", "<esc><C-r>", vim.tbl_extend("force", opts, { desc = "Redo" }))
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Lazy
map("n", "<leader>L", ":Lazy<cr>", { desc = "Lazy" })
