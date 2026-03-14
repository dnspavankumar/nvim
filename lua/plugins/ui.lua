return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local function get_hl(name)
        local ok, value = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
        if ok then
          return value
        end
        return {}
      end

      local function set_eob_highlight()
        local comment = get_hl("Comment")
        local normal = get_hl("Normal")
        local tree_normal = get_hl("NvimTreeNormal")

        local normal_bg = normal.bg
        local tree_bg = tree_normal.bg or normal_bg
        local eob_fg = comment.fg or 0x5B6078

        vim.api.nvim_set_hl(0, "EndOfBuffer", {
          fg = eob_fg,
          bg = normal_bg,
        })

        -- Keep sidebar completely uniform after file list ends.
        vim.api.nvim_set_hl(0, "NvimTreeNormal", {
          bg = tree_bg,
        })
        vim.api.nvim_set_hl(0, "NvimTreeNormalNC", {
          bg = tree_bg,
        })
        vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", {
          fg = eob_fg,
          bg = tree_bg,
        })
        vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", {
          fg = tree_bg,
          bg = tree_bg,
        })
      end

      vim.cmd.colorscheme("tokyonight-night")
      set_eob_highlight()

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("visible-eob-tilde", { clear = true }),
        callback = set_eob_highlight,
      })
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = "",
          section_separators = "",
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "slant",
          always_show_bufferline = true,
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = true,
          show_close_icon = false,
        },
      })
    end,
  },
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = {
      highlight = true,
      separator = " > ",
      depth_limit = 6,
    },
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("barbecue").setup({
        attach_navic = false,
        create_autocmd = true,
        show_dirname = true,
        show_basename = true,
        show_navic = true,
        show_modified = true,
        symbols = {
          separator = " > ",
        },
      })
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    config = function()
      require("scrollbar").setup({
        show = true,
        show_in_active_only = false,
        set_highlights = true,
        folds = 1000,
        max_lines = false,
        hide_if_all_visible = false,
        throttle_ms = 100,
        marks = {
          Search = { text = { "-", "=" } },
          Error = { text = { "-", "=" } },
          Warn = { text = { "-", "=" } },
          Info = { text = { "-", "=" } },
          Hint = { text = { "-", "=" } },
          Misc = { text = { "-", "=" } },
        },
      })

      local ok_search, search = pcall(require, "scrollbar.handlers.search")
      if ok_search then
        search.setup({})
      end
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "lazy",
          "mason",
          "notify",
          "NvimTree",
          "toggleterm",
          "Trouble",
          "TelescopePrompt",
          "TelescopeResults",
        },
        buftypes = {
          "terminal",
          "nofile",
          "quickfix",
          "prompt",
        },
      },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
        api.config.mappings.default_on_attach(bufnr)

        local winid = vim.fn.bufwinid(bufnr)
        if winid ~= -1 then
          vim.api.nvim_set_option_value(
            "winhighlight",
            "Normal:NvimTreeNormal,NormalNC:NvimTreeNormalNC,EndOfBuffer:NvimTreeEndOfBuffer,WinSeparator:NvimTreeWinSeparator,CursorLine:NvimTreeCursorLine,CursorLineNr:NvimTreeCursorLineNr",
            { win = winid }
          )
        end
      end

      require("nvim-tree").setup({
        on_attach = on_attach,
        sort = { sorter = "case_sensitive" },
        view = {
          width = 36,
          side = "left",
        },
        renderer = {
          root_folder_label = false,
          group_empty = true,
          indent_markers = { enable = true },
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
          ignore = false,
        },
        update_focused_file = {
          enable = true,
          update_root = true,
        },
        actions = {
          open_file = {
            quit_on_open = false,
            resize_window = true,
          },
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
