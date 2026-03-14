return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        direction = "float",
        start_in_insert = true,
        persist_size = true,
        persist_mode = true,
        shade_terminals = false,
        float_opts = {
          border = "curved",
          winblend = 0,
        },
      })
    end,
  },
}
