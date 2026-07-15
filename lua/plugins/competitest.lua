return {
  {
    "xeluxee/competitest.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("competitest").setup({
        local_templates_directory = vim.fn.stdpath("config") .. "/templates",
        template_file = {
          cpp = vim.fn.stdpath("config") .. "/templates/template.cpp",
        },
        evaluate_template_modifiers = true,
        date_format = "%Y-%m-%d %H:%M:%S",

        -- Automatically save files on run
        save_current_file = true,
        save_all_files = true,

        -- Compilation & Execution settings
        compile_directory = ".",
        compile_command = {
          cpp = {
            exec = "g++",
            args = {
              "-O2",
              "-std=c++17",
              "-Wall",
              "-Wextra",
              "-Wshadow",
              "-DLOCAL",
              "$(FNAME)",
              "-o",
              "$(FNOEXT)",
            },
          },
        },
        run_command = {
          cpp = {
            exec = "./$(FNOEXT)",
          },
        },

        -- UI Layout configurations
        split_ui = {
          position = "right",
          relative = "editor",
          size = 0.35,
        },
        popup_ui = {
          total_width = 0.8,
          total_height = 0.8,
          layout = {
            { 1, { { 1, "tc" }, { 1, "so" } } },
            { 1, { { 1, "si" }, { 1, "eo" } } },
          },
        },
      })
    end,
  },
}
