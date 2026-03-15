local cp = require("utils.cp")

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

return {
  {
    "xeluxee/competitest.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      local function sanitize_segment(str, fallback)
        local value = (str or ""):gsub('[<>:"/\\|?*]', "_")
        if value == "" then
          return fallback or "unknown"
        end
        return value
      end

      local function parse_cf_url(url)
        if type(url) ~= "string" then
          return nil, nil
        end

        local contest, index = url:match("codeforces%.com/contest/(%d+)/problem/([A-Za-z][A-Za-z0-9]*)")
        if contest and index then
          return contest, index:upper()
        end

        contest, index = url:match("codeforces%.com/problemset/problem/(%d+)/([A-Za-z][A-Za-z0-9]*)")
        if contest and index then
          return contest, index:upper()
        end

        contest, index = url:match("codeforces%.com/gym/(%d+)/problem/([A-Za-z][A-Za-z0-9]*)")
        if contest and index then
          return contest, index:upper()
        end

        return nil, nil
      end

      require("competitest").setup({
        local_config_file_name = ".competitest.lua",
        companion_port = 27121,
        receive_print_message = true,
        start_receiving_persistently_on_setup = true,
        save_current_file = true,
        save_all_files = false,

        compile_directory = ".",
        compile_command = {
          cpp = {
            exec = "g++",
            args = {
              "-std=c++20",
              "-O2",
              "-Wall",
              "-Wextra",
              "-Wshadow",
              "$(FNAME)",
              "-o",
              "$(FNOEXT).exe",
            },
          },
        },

        running_directory = ".",
        run_command = {
          cpp = {
            exec = "./$(FNOEXT).exe",
          },
        },

        testcases_directory = "./testcases",
        testcases_use_single_file = false,
        testcases_auto_detect_storage = true,

        maximum_time = 5000,
        output_compare_method = "squish",

        runner_ui = {
          interface = "split",
        },
        split_ui = {
          position = "right",
          relative_to_editor = true,
          total_width = 0.30,
          vertical_layout = {
            { 2, "tc" },
            { 2, { { 1, "si" }, { 1, "se" } } },
            { 2, { { 1, "so" }, { 1, "eo" } } },
          },
        },
        floating_border = "rounded",

        received_files_extension = "cpp",
        received_problems_path = function(task, file_extension)
          local home = vim.uv.os_homedir()
          local contest, index = parse_cf_url(task.url)
          if contest and index then
            return string.format("%s/codeforces/%s/%s.%s", home, contest, index, file_extension)
          end
          local problem = sanitize_segment(task.name, "problem")
          return string.format("%s/codeforces/%s.%s", home, problem, file_extension)
        end,
        received_problems_prompt_path = false,
        received_contests_directory = function(task, _)
          local home = vim.uv.os_homedir()
          local contest = select(1, parse_cf_url(task.url))
          if contest then
            return string.format("%s/codeforces/%s", home, contest)
          end
          return string.format("%s/codeforces/%s", home, sanitize_segment(task.group, "contest"))
        end,
        received_contests_problems_path = function(task, file_extension)
          local _, index = parse_cf_url(task.url)
          if index then
            return string.format("%s.%s", index, file_extension)
          end
          local problem = sanitize_segment(task.name, "problem")
          return string.format("%s.%s", problem, file_extension)
        end,
        received_contests_prompt_directory = false,
        received_contests_prompt_extension = true,
        open_received_problems = true,
        open_received_contests = true,
      })
    end,
    keys = {
      { "<C-A-n>", run_competitest, mode = "n", noremap = true, silent = true, desc = "Run received testcases" },
      { "<C-M-n>", run_competitest, mode = "n", noremap = true, silent = true, desc = "Run received testcases" },
      { "<M-n>",   run_competitest, mode = "n", noremap = true, silent = true, desc = "Run received testcases" },
      {
        "<C-A-n>",
        function()
          vim.cmd("stopinsert"); run_competitest()
        end,
        mode = "i",
        noremap = true,
        silent = true,
        desc = "Run received testcases"
      },
      {
        "<C-A-n>",
        function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
          run_competitest()
        end,
        mode = "t",
        noremap = true,
        silent = true,
        desc = "Run received testcases"
      },
      { "<F5>",    cp.submit_current_file, mode = "n", noremap = true, silent = true, desc = "Submit current file to Codeforces" },
      { "<C-A-u>", open_competitest_ui,    mode = "n", noremap = true, silent = true, desc = "Open CP helper UI" },
      { "<C-M-u>", open_competitest_ui,    mode = "n", noremap = true, silent = true, desc = "Open CP helper UI" },
      {
        "<C-A-u>",
        function()
          vim.cmd("stopinsert"); open_competitest_ui()
        end,
        mode = "i",
        noremap = true,
        silent = true,
        desc = "Open CP helper UI"
      },
      {
        "<C-A-u>",
        function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
          open_competitest_ui()
        end,
        mode = "t",
        noremap = true,
        silent = true,
        desc = "Open CP helper UI"
      },
      { "<leader>cu", open_competitest_ui,                    mode = "n", noremap = true, silent = true, desc = "Open CP helper UI fallback" },
      { "<leader>cp", "<cmd>CompetiTest receive problem<cr>", mode = "n", noremap = true, silent = true, desc = "Receive problem from Companion" },
      { "<leader>ca", "<cmd>CompetiTest add_testcase<cr>",    mode = "n", noremap = true, silent = true, desc = "Add testcase" },
      { "<leader>ce", "<cmd>CompetiTest edit_testcase<cr>",   mode = "n", noremap = true, silent = true, desc = "Edit testcase" },
      { "<leader>cr", "<cmd>CompetiTest run<cr>",             mode = "n", noremap = true, silent = true, desc = "Run testcases" },
      { "<leader>cd", "<cmd>CompetiTest delete_testcase<cr>", mode = "n", noremap = true, silent = true, desc = "Delete testcase" },
    },
  },
}
