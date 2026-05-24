return {
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup {
        options = {
          transparent = true,
          hide_nc_statusline = true,
        },
        groups = {
          all = {
            Normal = { bg = "none" },
            NormalNC = { bg = "none" },
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            Pmenu = { bg = "none" },
            PmenuSel = { bg = "none" },
            StatusLine = { bg = "none" },
            StatusLineNC = { bg = "none" },
            TabLine = { bg = "none" },
            TabLineFill = { bg = "none" },
            TabLineSel = { bg = "none" },
            CursorLine = { bg = "none" },
            CursorLineNr = { bg = "none" },
            SignColumn = { bg = "none" },
            WinSeparator = { bg = "none" },
          },
        },
      }
    end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 999,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 999,
    opts = {
      transparent = true,
      overrides = {
        Pmenu = { bg = 'NONE' },
        CursorLine = { bg = 'NONE' },
        NormalFloat = { bg = 'NONE' },
        FloatBorder = { bg = 'NONE' },
        StatusLine = { bg = 'NONE' },
        TabLineFill = { bg = 'NONE' },
      }
    },
  },

  {
    "jzone1366/twilight.nvim",
    lazy = false,
    priority = 999,
  },

  {
    "sjl/badwolf",
    lazy = false,
    priority = 999,
  },

  {
    "metalelf0/black-metal-theme-neovim",
    lazy = false,
    priority = 999,
    config = function()
      require("black-metal").setup {
        theme = "bathory",
        variant = "dark",
        transparent = true,
      }
    end,
  },

  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 999,
    opts = {
      style = "dark",
      transparent = true,
    },
  },

  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 999,
    opts = {
      options = {
        transparent = true,
      },
    },
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
            statusline = { "NvimTree", "neo-tree" },
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
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = {
      highlight = true,
      separator = " > ",
      depth_limit = 6,
      icons = {
        Array         = ' ',
        Boolean       = '󰨙 ',
        Class         = ' ',
        Color         = ' ',
        Control       = ' ',
        Collapsed     = ' ',
        Constant      = '󰏿 ',
        Constructor   = ' ',
        Enum          = ' ',
        EnumMember    = ' ',
        Event         = ' ',
        Field         = ' ',
        File          = ' ',
        Folder        = ' ',
        Function      = '󰊕 ',
        Interface     = ' ',
        Key           = ' ',
        Keyword       = ' ',
        Method        = '󰊕 ',
        Module        = ' ',
        Namespace     = '󰦮 ',
        Null          = ' ',
        Number        = '󰎠 ',
        Object        = ' ',
        Operator      = ' ',
        Package       = ' ',
        Property      = ' ',
        Reference     = ' ',
        Snippet       = '󱄽 ',
        String        = ' ',
        Struct        = '󰆼 ',
        Supermaven    = ' ',
        Text          = ' ',
        TypeParameter = ' ',
        Unit          = ' ',
        Value         = ' ',
        Variable      = '󰀫 ',
      },
    },
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
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts_extend = { 'spec' },
    opts = {
      preset = 'helix',
      spec = {
        { '<BS>',      desc = 'Decrement Selection', mode = 'x' },
        { '<c-space>', desc = 'Increment Selection', mode = { 'x', 'n' } },
        {
          mode = { 'n', 'v' },
          { '<leader>t', group = 'tabs' },
          { '<leader>c', group = 'lsp' },
          { '<leader>f', group = 'file/find' },
          { '<leader>g', group = 'git' },
          { '<leader>gh', group = 'hunks' },
          { '<leader>q', group = 'quit' },
          { '<leader>s', group = 'search' },
          { '<leader>u', group = 'ui', icon = { icon = '󰙵 ', color = 'cyan' } },
          { '[', group = 'prev' },
          { ']', group = 'next' },
          { 'g', group = 'goto' },
          { 'gs', group = 'surround' },
          { 'z', group = 'fold' },
          {
            '<leader>b',
            group = 'buffer',
            expand = function()
              return require 'which-key.extras'.expand.buf()
            end,
          },
          {
            '<leader>w',
            group = 'windows',
            proxy = '<c-w>',
            expand = function()
              return require 'which-key.extras'.expand.win()
            end,
          },
          -- better descriptions
          { 'gx', desc = 'Open with system app' },
        },
      },
    },
    keys = {
      {
        '<leader>?',
        function()
          require 'which-key'.show { global = true }
        end,
        desc = 'Buffer Keymaps (which-key)',
      },
      {
        '<c-w><space>',
        function()
          require 'which-key'.show { keys = '<c-w>', loop = true }
        end,
        desc = 'Window Hydra Mode',
      },
      {
        '<space>b<space>',
        function()
          require 'which-key'.show { keys = '<space>b', loop = true }
        end,
        desc = 'Buffer Hydra Mode',
      }
    },
    config = function(_, opts)
      require 'which-key'.setup(opts)
    end,
  },
}
