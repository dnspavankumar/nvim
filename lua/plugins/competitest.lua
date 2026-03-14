return {
  {
    "xeluxee/competitest.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
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

        view_mode = "split",
        split_ui = {
          position = "right",
          relative_to_editor = true,
          total_width = 0.42,
          vertical_layout = {
            { 1, "tc" },
            { 1, { { 1, "so" }, { 1, "eo" } } },
            { 1, { { 1, "si" }, { 1, "se" } } },
          },
        },
        floating_border = "rounded",

        received_files_extension = "cpp",
        received_problems_path = "$(HOME)/codeforces/$(PROBLEM).$(FEXT)",
        received_problems_prompt_path = true,
        received_contests_directory = "$(HOME)/codeforces/$(CONTEST)",
        received_contests_problems_path = "$(PROBLEM).$(FEXT)",
        received_contests_prompt_directory = true,
        received_contests_prompt_extension = true,
        open_received_problems = true,
        open_received_contests = true,
      })
    end,
  },
}
