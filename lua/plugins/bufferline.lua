return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close Other Buffers" },
      { "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete Buffer" },
    },
    opts = {
      options = {
        mode = "buffers", -- show buffers, not tabs
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        diagnostics = "nvim_lsp",
        separator_style = "slant", -- "slant" | "slope" | "thick" | "thin"
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "left",
            separator = true,
          }
        },
      }
    }
  }
}
