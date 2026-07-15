local keymap = vim.keymap

-- Clear search highlighting with <leader>nh
keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Better window navigation
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-- Window splitting
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Buffer navigation
keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Prev Buffer" })
keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next Buffer" })
keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete Buffer" })

-- Neo-tree toggle
keymap.set("n", "<leader>e", "<cmd>Neotree toggle left<CR>", { desc = "Toggle file explorer sidebar" })
keymap.set("n", "<leader>fe", "<cmd>Neotree focus<CR>", { desc = "Focus file explorer sidebar" })

-- CompetiTest Keymaps (Competitive programming specific)
keymap.set("n", "<leader>pr", "<cmd>CompetiTest run<CR>", { desc = "CompetiTest: Run Tests" })
keymap.set("n", "<leader>pc", "<cmd>CompetiTest compile<CR>", { desc = "CompetiTest: Compile Only" })
keymap.set("n", "<leader>pa", "<cmd>CompetiTest add_testcase<CR>", { desc = "CompetiTest: Add Testcase" })
keymap.set("n", "<leader>pe", "<cmd>CompetiTest edit_testcase<CR>", { desc = "CompetiTest: Edit Testcase" })
keymap.set("n", "<leader>pd", "<cmd>CompetiTest delete_testcase<CR>", { desc = "CompetiTest: Delete Testcase" })
keymap.set("n", "<leader>pg", "<cmd>CompetiTest receive<CR>", { desc = "CompetiTest: Receive/Parse problem" })
keymap.set("n", "<leader>pi", "<cmd>CompetiTest show_ui<CR>", { desc = "CompetiTest: Show UI" })
