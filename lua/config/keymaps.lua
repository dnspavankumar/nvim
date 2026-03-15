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
map("i", "<C-c>", '<Esc>yygi', vim.tbl_extend("force", opts, { desc = "Copy line" }))
map("n", "<C-x>", 'dd', vim.tbl_extend("force", opts, { desc = "Cut line" }))
map("x", "<C-x>", 'd', vim.tbl_extend("force", opts, { desc = "Cut selection" }))
map("i", "<C-x>", '<Esc>ddgi', vim.tbl_extend("force", opts, { desc = "Cut line" }))
map("n", "<C-a>", "ggyG<c-o>", vim.tbl_extend("force", opts, { desc = "Select all" }))
map("i", "<C-a>", "<Esc>ggyG<c-o>", vim.tbl_extend("force", opts, { desc = "Select all" }))
map({ "n", "v" }, "<C-s>", "<esc><cmd>w<CR>", vim.tbl_extend("force", opts, { desc = "Save file" }))
map("i", "<C-s>", "<Esc><cmd>w<CR>a", vim.tbl_extend("force", opts, { desc = "Save file" }))
map("n", "<C-z>", "u", vim.tbl_extend("force", opts, { desc = "Undo" }))
map("i", "<C-z>", "<esc>u", vim.tbl_extend("force", opts, { desc = "Undo" }))

-- Clear search highlight
map({ 'n', 's' }, '<esc>', function()
  vim.cmd 'noh'
  return '<esc>'
end, { expr = true, desc = 'Escape and clear hlsearch' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next search result', silent = true })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result', silent = true })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result', silent = true })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev search result', silent = true })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result', silent = true })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result', silent = true })

-- Add undo break-points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- wrap
map('n', '<leader>uw', function()
  vim.o.wrap = not vim.o.wrap
end, { desc = "Toggle wrap", silent = true })

-- highlights under cursor
map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect pos', silent = true })
map('n', '<leader>uI', function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input 'I'
end, { desc = 'Inspect tree' })

-- windows
map('n', '<leader>-', '<c-w>s', { desc = 'Split window below', remap = true, silent = true })
map('n', '<leader>|', '<c-w>v', { desc = 'Split window right', remap = true, silent = true })

-- Lazy
map("n", "<leader>L", ":Lazy<cr>", { desc = "Lazy" })
