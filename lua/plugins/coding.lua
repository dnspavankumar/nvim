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
                ls.add_snippets(lang, file)
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
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    dependencies = { 'folke/which-key.nvim' },
    opts = function()
      local ai = require 'mini.ai'
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter {
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          },
          f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
          c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
          d = { '%f[%d]%d+' },
          e = {
            { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
            '^().*()$',
          },
          g = require 'utils.plugins'.ai_buffer,
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call { name_pattern = '[%w_]' },
        },
      }
    end,
    config = function(_, opts)
      require 'mini.ai'.setup(opts)
      local objects = {
        { ' ', desc = 'whitespace' },
        { '"', desc = '" string' },
        { "'", desc = "' string" },
        { '(', desc = '() block' },
        { ')', desc = '() block with ws' },
        { '<', desc = '<> block' },
        { '>', desc = '<> block with ws' },
        { '?', desc = 'user prompt' },
        { 'U', desc = 'use/call without dot' },
        { '[', desc = '[] block' },
        { ']', desc = '[] block with ws' },
        { '_', desc = 'underscore' },
        { '`', desc = '` string' },
        { 'a', desc = 'argument' },
        { 'b', desc = ')]} block' },
        { 'c', desc = 'class' },
        { 'd', desc = 'digit(s)' },
        { 'e', desc = 'CamelCase / snake_case' },
        { 'f', desc = 'function' },
        { 'g', desc = 'entire file' },
        { 'i', desc = 'indent' },
        { 'o', desc = 'block, conditional, loop' },
        { 'q', desc = 'quote `"\'' },
        { 't', desc = 'tag' },
        { 'u', desc = 'use/call' },
        { '{', desc = '{} block' },
        { '}', desc = '{} with ws' },
      }

      ---@type wk.Spec[]
      local ret = { mode = { 'o', 'x' } }
      ---@type table<string, string>
      local mappings = vim.tbl_extend('force', {}, {
        around = 'a',
        inside = 'i',
        around_next = 'an',
        inside_next = 'in',
        around_last = 'al',
        inside_last = 'il',
      }, opts.mappings or {})
      mappings.goto_left = nil
      mappings.goto_right = nil

      for name, prefix in pairs(mappings) do
        name = name:gsub('^around_', ''):gsub('^inside_', '')
        ret[#ret + 1] = { prefix, group = name }
        for _, obj in ipairs(objects) do
          local desc = obj.desc
          if prefix:sub(1, 1) == 'i' then
            desc = desc:gsub(' with ws', '')
          end
          ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
        end
      end
      require 'which-key'.add(ret, { notify = false })
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = { 'InsertEnter', 'CmdLineEnter' },
    config = function()
      require("nvim-autopairs").setup()
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
