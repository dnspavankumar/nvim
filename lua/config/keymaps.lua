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

-- Assistant (A7Lavinraj/assistant.nvim) — open UI, run tests, auto-close on all AC
keymap.set("n", "<leader>t", function()
  if vim.bo.filetype ~= "cpp" then
    vim.notify("Assistant requires a C++ file", vim.log.levels.WARN)
    return
  end
  vim.cmd("cd ~/Downloads/Practice | Assistant")
  require("assistant.actions").run_testcases()

  local state = require("assistant.state")
  local wizard = require("assistant.builtins.__wizard").standard
  local timer = vim.uv.new_timer()
  if not timer then return end

  timer:start(200, 200, vim.schedule_wrap(function()
    local tests = state.get_global_key("tests")
    if not tests or #tests == 0 then return end

    local all_done = true
    local all_ac = true
    for _, tc in ipairs(tests) do
      if not tc.status or tc.status == "RN" then
        all_done = false
        all_ac = false
        break
      end
      if tc.status ~= "AC" then
        all_ac = false
      end
    end

    if all_done then
      timer:stop()
      if all_ac then
        vim.defer_fn(function()
          wizard:hide()
        end, 1500)
      end
    end
  end))
end, { desc = "Open assistant and run testcases (C++ only)" })
