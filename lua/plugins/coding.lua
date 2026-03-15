return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "master",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "c",
          "cpp",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "markdown",
          "markdown_inline",
          "json",
        },
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },

  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
    opts = {
      appearance = {
        kind_icons = {
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
          Text          = '󰉿 ', -- 
          TypeParameter = ' ',
          Unit          = ' ',
          Value         = ' ',
          Variable      = '󰀫 ',
        }
      },
      keymap = {
        preset = "default",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ['<C-e>'] = { 'cancel', 'fallback' }, -- also shows
      },
      snippets = { preset = "luasnip" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          path = {
            opts = { show_hidden_files_by_default = true },
          },
        },
      },
      cmdline = {
        enabled = true,
        completion = {
          menu = { auto_show = true },
          list = { selection = { preselect = false, auto_insert = true } },
        },
        keymap = {
          ['<CR>'] = { 'accept', 'fallback' },
          ['<Tab>'] = { 'select_next', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'fallback' },
          ['<C-e>'] = { 'cancel', 'fallback' }, -- also shows
          ['<C-y>'] = { 'select_and_accept' },
        }
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        list = { selection = { preselect = true, auto_insert = false } },
        menu = {
          auto_show = true,
          border = 'rounded',
          draw = {
            treesitter = { 'lsp' },
            padding = { 0, 1 },
            components = {
              source_name = {
                width = { fill = true },
                text = function(ctx)
                  local str = ctx.source_name:lower()
                  if str == 'buffer' then
                    str = 'buf'
                  elseif str == 'cmdline' then
                    return ''
                  elseif str == 'snippets' then
                    str = 'snip'
                  end
                  return '[' .. str .. ']'
                end
              },
              label_description = {
                text = function(ctx)
                  local mode = vim.api.nvim_get_mode().mode
                  return mode ~= 'c' and '' or ctx.label_description -- only show it in cmdline
                end
              },
            },
            columns = {
              { 'kind_icon',   'label' },
              { 'source_name', 'label_description', gap = 1 },
            },
          },
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
          scrollbar = false,
        },

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
          treesitter_highlighting = true,
          window = {
            border = 'rounded',
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
            scrollbar = false,
          }
        },
        ghost_text = {
          enabled = false,
        }
      },
    },

    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      -- snippets
      local langs = {
        'c',
        'cpp',
      }
      vim.api.nvim_create_autocmd('FileType', {
        pattern = langs,
        callback = function(args)
          local ls = require 'luasnip'
          _G.lang_done = _G.lang_done or {}

          for _, lang in ipairs(langs) do
            if args.match == lang and not _G.lang_done[lang] then
              local ok, file = pcall(require, 'snippets.' .. lang)
              if ok then
                ls.add_snippets(lang, require('snippets.' .. lang))
                _G.lang_done[lang] = true
                break
              end
            end
          end
        end,
      })

      opts.sources.compat = nil
      require 'blink.cmp'.setup(opts)
    end
  },

  {
    "echasnovski/mini.ai",
    version = "*",
    config = function()
      require("mini.ai").setup()
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = { 'InsertEnter', 'CmdLineEnter' },
    config = function()
      require("nvim-autopairs").setup({})
    end,
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
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      { 'MunifTanjim/nui.nvim' },
    },
    keys = {
      { '<leader>sn',  '',                                       desc = '+noice' },
      -- { '<leader>snl', function() require 'noice'.cmd 'last' end,    desc = 'Noice Last Message' },
      -- { '<leader>snh', function() require 'noice'.cmd 'history' end, desc = 'Noice History' },
      { '<leader>sna', function() require 'noice'.cmd 'all' end, desc = 'Noice All' },
      -- { '<leader>snd', function() require 'noice'.cmd 'dismiss' end, desc = 'Dismiss All' },
      -- { '<leader>snt', function() require 'noice'.cmd 'pick' end,    desc = 'Noice Picker (Telescope/FzfLua)' },
      {
        '<c-f>',
        function() if not require 'noice.lsp'.scroll(4) then return '<c-f>' end end,
        silent = true,
        expr = true,
        desc = 'Scroll Forward',
        mode = { 'i', 'n', 's' }
      },
      {
        '<c-b>',
        function() if not require 'noice.lsp'.scroll(-4) then return '<c-b>' end end,
        silent = true,
        expr = true,
        desc = 'Scroll Backward',
        mode = { 'i', 'n', 's' }
      },
    },

    ---@diagnostic disable: missing-fields
    ---@type NoiceConfig
    opts = {
      views = {
        hover = {
          scrollbar = true,
        },
      },
      cmdline = {
        view = 'cmdline', -- for default cmdline
      },
      presets = {
        command_palette = true,
        lsp_doc_border = true,
        bottom_search = true,
        long_message_to_split = true,
      },
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = false,
          },
        },
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '; after #%d+' },
              { find = '; before #%d+' },
            },
          },
          view = 'mini',
        },
      },
    },

    config = function(_, opts)
      require 'noice'.setup(opts)
    end
  },
}
