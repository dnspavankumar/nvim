return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    direction = "float",
    start_in_insert = true,
    persist_size = true,
    persist_mode = true,
    shade_terminals = false,
    float_opts = {
      border = "curved",
      winblend = 0,
    },
  },
  keys = {
    {
      "<c-`>",
      ":ToggleTerm direction=float<cr>",
      noremap = true,
      silent = true,
      desc = "Toggle terminal fallback",
      mode = { "i" },
    },
    {
      "<c-`>",
      "<c-\\><c-n>:ToggleTerm direction=float<CR>",
      mode = { "t" },
      noremap = true,
      silent = true,
      desc = "Toggle terminal fallback",
    },
    {
      "<leader>t",
      ":ToggleTerm direction=float<CR>",
      mode = { "n" },
      noremap = true,
      silent = true,
      desc = "Toggle terminal fallback",
    }
  },
}
