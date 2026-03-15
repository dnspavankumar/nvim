local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local cp = require("config.cp")

local function run_competitest()
  vim.cmd("CompetiTest run")
end

local function open_competitest_ui()
  -- Re-open existing UI if available; otherwise run once to build it.
  local ok = pcall(vim.cmd, "CompetiTest show_ui")
  if not ok then
    run_competitest()
  end
end

local function buffer_next()
  vim.cmd("BufferLineCycleNext")
end

local function buffer_prev()
  vim.cmd("BufferLineCyclePrev")
end

local function buffer_close()
  vim.cmd("bdelete")
end

-- VS Code-like editing shortcuts
map("n", "<C-c>", '"+yy', vim.tbl_extend("force", opts, { desc = "Copy line" }))
map("x", "<C-c>", '"+y', vim.tbl_extend("force", opts, { desc = "Copy selection" }))
map("i", "<C-c>", '<Esc>"+yygi', vim.tbl_extend("force", opts, { desc = "Copy line" }))
map("n", "<C-v>", '"+p', vim.tbl_extend("force", opts, { desc = "Paste" }))
map("x", "<C-v>", '"+p', vim.tbl_extend("force", opts, { desc = "Paste over selection" }))
map("i", "<C-v>", "<C-r>+", vim.tbl_extend("force", opts, { desc = "Paste in insert mode" }))
map("n", "<C-x>", '"+dd', vim.tbl_extend("force", opts, { desc = "Cut line" }))
map("x", "<C-x>", '"+d', vim.tbl_extend("force", opts, { desc = "Cut selection" }))
map("i", "<C-x>", '<Esc>"+ddgi', vim.tbl_extend("force", opts, { desc = "Cut line" }))
map("n", "<C-a>", "ggVG", vim.tbl_extend("force", opts, { desc = "Select all" }))
map("i", "<C-a>", "<Esc>ggVG", vim.tbl_extend("force", opts, { desc = "Select all" }))
map("n", "<C-s>", "<cmd>w<CR>", vim.tbl_extend("force", opts, { desc = "Save file" }))
map("i", "<C-s>", "<Esc><cmd>w<CR>a", vim.tbl_extend("force", opts, { desc = "Save file" }))
map("x", "<C-s>", "<Esc><cmd>w<CR>gv", vim.tbl_extend("force", opts, { desc = "Save file" }))
map("n", "<C-z>", "u", vim.tbl_extend("force", opts, { desc = "Undo" }))
map("i", "<C-z>", "<C-o>u", vim.tbl_extend("force", opts, { desc = "Undo" }))
map("n", "<C-y>", "<C-r>", vim.tbl_extend("force", opts, { desc = "Redo" }))
map("i", "<C-y>", "<C-o><C-r>", vim.tbl_extend("force", opts, { desc = "Redo" }))

-- Sidebar + terminal + CP workflow
map("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", vim.tbl_extend("force", opts, { desc = "Toggle sidebar" }))
map("i", "<C-b>", "<Esc><cmd>NvimTreeToggle<CR>", vim.tbl_extend("force", opts, { desc = "Toggle sidebar" }))
map("t", "<C-b>", "<C-\\><C-n><cmd>NvimTreeToggle<CR>", vim.tbl_extend("force", opts, { desc = "Toggle sidebar" }))

map("n", "<C-`>", "<cmd>ToggleTerm direction=float<CR>", vim.tbl_extend("force", opts, { desc = "Toggle terminal" }))
map("i", "<C-`>", "<Esc><cmd>ToggleTerm direction=float<CR>", vim.tbl_extend("force", opts, { desc = "Toggle terminal" }))
map("t", "<C-`>", "<C-\\><C-n><cmd>ToggleTerm direction=float<CR>", vim.tbl_extend("force", opts, { desc = "Toggle terminal" }))
map("n", "<leader>t", "<cmd>ToggleTerm direction=float<CR>", vim.tbl_extend("force", opts, { desc = "Toggle terminal fallback" }))

-- File tabs / buffers
map("n", "<C-Tab>", buffer_next, vim.tbl_extend("force", opts, { desc = "Next file tab" }))
map("n", "<C-S-Tab>", buffer_prev, vim.tbl_extend("force", opts, { desc = "Previous file tab" }))
map("i", "<C-Tab>", function()
  vim.cmd("stopinsert")
  buffer_next()
end, vim.tbl_extend("force", opts, { desc = "Next file tab" }))
map("i", "<C-S-Tab>", function()
  vim.cmd("stopinsert")
  buffer_prev()
end, vim.tbl_extend("force", opts, { desc = "Previous file tab" }))
map("t", "<C-Tab>", function()
  local esc_term = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
  vim.api.nvim_feedkeys(esc_term, "n", false)
  buffer_next()
end, vim.tbl_extend("force", opts, { desc = "Next file tab" }))
map("t", "<C-S-Tab>", function()
  local esc_term = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
  vim.api.nvim_feedkeys(esc_term, "n", false)
  buffer_prev()
end, vim.tbl_extend("force", opts, { desc = "Previous file tab" }))
map("n", "<A-Right>", buffer_next, vim.tbl_extend("force", opts, { desc = "Next file tab fallback" }))
map("n", "<A-Left>", buffer_prev, vim.tbl_extend("force", opts, { desc = "Previous file tab fallback" }))
map("n", "<leader>bn", buffer_next, vim.tbl_extend("force", opts, { desc = "Next file tab fallback" }))
map("n", "<leader>bp", buffer_prev, vim.tbl_extend("force", opts, { desc = "Previous file tab fallback" }))
map("n", "<leader>bd", buffer_close, vim.tbl_extend("force", opts, { desc = "Close current file tab" }))

map("n", "<C-A-n>", run_competitest, vim.tbl_extend("force", opts, { desc = "Run received testcases" }))
map("n", "<C-M-n>", run_competitest, vim.tbl_extend("force", opts, { desc = "Run received testcases" }))
map("n", "<M-n>", run_competitest, vim.tbl_extend("force", opts, { desc = "Run received testcases" }))
map("i", "<C-A-n>", function()
  vim.cmd("stopinsert")
  run_competitest()
end, vim.tbl_extend("force", opts, { desc = "Run received testcases" }))
map("t", "<C-A-n>", function()
  local esc_term = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
  vim.api.nvim_feedkeys(esc_term, "n", false)
  run_competitest()
end, vim.tbl_extend("force", opts, { desc = "Run received testcases" }))
map("n", "<F5>", cp.submit_current_file, vim.tbl_extend("force", opts, { desc = "Submit current file to Codeforces" }))
map("n", "<C-A-u>", open_competitest_ui, vim.tbl_extend("force", opts, { desc = "Open CP helper UI" }))
map("n", "<C-M-u>", open_competitest_ui, vim.tbl_extend("force", opts, { desc = "Open CP helper UI" }))
map("i", "<C-A-u>", function()
  vim.cmd("stopinsert")
  open_competitest_ui()
end, vim.tbl_extend("force", opts, { desc = "Open CP helper UI" }))
map("t", "<C-A-u>", function()
  local esc_term = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
  vim.api.nvim_feedkeys(esc_term, "n", false)
  open_competitest_ui()
end, vim.tbl_extend("force", opts, { desc = "Open CP helper UI" }))
map("n", "<leader>cu", open_competitest_ui, vim.tbl_extend("force", opts, { desc = "Open CP helper UI fallback" }))
map("n", "<leader>cp", "<cmd>CompetiTest receive problem<CR>", vim.tbl_extend("force", opts, { desc = "Receive problem from Companion" }))
map("n", "<leader>ca", "<cmd>CompetiTest add_testcase<CR>", vim.tbl_extend("force", opts, { desc = "Add testcase" }))
map("n", "<leader>ce", "<cmd>CompetiTest edit_testcase<CR>", vim.tbl_extend("force", opts, { desc = "Edit testcase" }))
map("n", "<leader>cr", "<cmd>CompetiTest run<CR>", vim.tbl_extend("force", opts, { desc = "Run testcases" }))
map("n", "<leader>cd", "<cmd>CompetiTest delete_testcase<CR>", vim.tbl_extend("force", opts, { desc = "Delete testcase" }))

map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)
