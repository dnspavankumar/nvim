return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
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
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        submodules = false,
      },
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})

      local ok_cmp, cmp = pcall(require, "cmp")
      local ok_cmp_autopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
      if ok_cmp and ok_cmp_autopairs then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local ok_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp_lsp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      local on_attach = function(client, bufnr)
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end

        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("gi", vim.lsp.buf.implementation, "Go to implementation")
        map("gr", vim.lsp.buf.references, "References")
        map("K", vim.lsp.buf.hover, "Hover docs")
        map("<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, "Format file")

        local ok_navic, navic = pcall(require, "nvim-navic")
        if ok_navic and client.server_capabilities and client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end
      end

      local clangd_config = {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = {
          "clangd",
          "--background-index",
          "--completion-style=detailed",
          "--header-insertion=never",
        },
        filetypes = { "c", "cpp", "objc", "objcpp" },
      }

      if vim.fn.executable("clangd") ~= 1 then
        vim.schedule(function()
          vim.notify(
            "clangd not found in PATH. Your g++/gcc compile-run still works; install clangd for autocomplete and go-to-definition.",
            vim.log.levels.WARN
          )
        end)
        return
      end

      -- Neovim 0.11+ API (avoids deprecated lspconfig framework warning).
      if type(vim.lsp.config) == "function" and type(vim.lsp.enable) == "function" then
        vim.lsp.config("clangd", clangd_config)
        vim.lsp.enable("clangd")
        return
      end

      -- Backward-compatible fallback for older Neovim versions.
      local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
      if ok_lspconfig then
        lspconfig.clangd.setup(clangd_config)
      end
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
