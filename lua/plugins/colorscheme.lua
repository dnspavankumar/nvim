return {
  {
    "binarylinuxx/graphite-nvim",
    priority = 1000,
  },
  {
    "Lokaltog/monotone.nvim",
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      vim.cmd.colorscheme("monotone")
    end,
  },
}
