return {
  {
    "projekt0n/github-nvim-theme",
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

        local function shift_rgb(color, delta)
          if type(color) ~= "number" then
            return nil
          end

          local r = math.floor(color / 0x10000)
          local g = math.floor((color % 0x10000) / 0x100)
          local b = color % 0x100

          r = math.min(255, math.max(0, r + delta))
          g = math.min(255, math.max(0, g + delta))
          b = math.min(255, math.max(0, b + delta))

          return (r * 0x10000) + (g * 0x100) + b
        end

        local normal_bg = normal.bg
        local normal_fg = normal.fg or 0xC9D1D9
        local tree_bg = shift_rgb(tree_normal.bg or normal_bg, -10) or 0x202938
        local status_bg = shift_rgb(normal_bg, 10) or 0x303A4A
        local status_nc_bg = shift_rgb(normal_bg, 5) or 0x2A3342
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
          fg = 0xFFFFFF,
          bg = tree_bg,
        })
        vim.api.nvim_set_hl(0, "WinSeparator", {
          fg = 0xFFFFFF,
          bg = normal_bg,
        })

        vim.api.nvim_set_hl(0, "StatusLine", {
          fg = normal_fg,
          bg = status_bg,
        })
        vim.api.nvim_set_hl(0, "StatusLineNC", {
          fg = eob_fg,
          bg = status_nc_bg,
        })

        for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "inactive" }) do
          for _, section in ipairs({ "b", "c", "x", "y" }) do
            local group = "lualine_" .. section .. "_" .. mode
            local existing = get_hl(group)
            vim.api.nvim_set_hl(0, group, {
              fg = existing.fg or normal_fg,
              bg = mode == "inactive" and status_nc_bg or status_bg,
            })
          end
        end
      end

      vim.cmd.colorscheme("github_dark")
      set_eob_highlight()

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("visible-eob-tilde", { clear = true }),
        callback = set_eob_highlight,
      })
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 999,
    opts = {},
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local lualine = require("lualine")
      local config = {
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "NvimTree" },
          },
        },
        sections = {
          lualine_a = {
            { "mode", separator = { left = "", right = "" }, right_padding = 2 },
          },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" } },
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = {
            { "location", separator = { left = "", right = "" }, left_padding = 2 },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
      }

      lualine.setup(config)

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("lualine-auto-theme-refresh", { clear = true }),
        callback = function()
          lualine.setup(config)
        end,
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local ok_vesper, vesper = pcall(require, "vesper")
      local highlights = nil
      if ok_vesper and vesper.bufferline then
        highlights = vesper.bufferline.highlights
      end

      require("bufferline").setup({
        highlights = highlights,
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
