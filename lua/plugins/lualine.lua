return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
          disabled_filetypes = {
            statusline = { "neo-tree" },
          },
        },
        sections = {
          lualine_a = {
            { "mode", separator = { left = "" }, padding = { left = 1, right = 2 } },
          },
          lualine_b = {
            { "branch", icon = "" },
            {
              "diff",
              symbols = { added = " ", modified = " ", removed = " " },
            },
          },
          lualine_c = {
            { "filename", file_status = true, path = 1 },
            {
              "diagnostics",
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
            },
          },
          lualine_x = {
            { "filetype", icon_only = false },
          },
          lualine_y = {
            "progress",
          },
          lualine_z = {
            { "location", separator = { right = "" }, padding = { left = 2, right = 1 } },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },
}
