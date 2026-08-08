return {
  "A7Lavinraj/assistant.nvim",
  config = function()
    require("assistant").setup({
      commands = {
        cpp = {
          extension = "cpp",
          compile = {
            main = "g++",
            args = { "$FILENAME_WITH_EXTENSION", "-o", "$FILENAME_WITHOUT_EXTENSION", "-std=c++20", "-O2", "-Wall" },
          },
          execute = {
            main = "./$FILENAME_WITHOUT_EXTENSION",
            args = nil,
          },
        },
      },
      ui = {
        border = "single",
        diff_mode = false,
        title_components_separator = "|",
      },
      core = {
        process_budget = 5000,
        port = 10043,
      },
    })
  end,
}
