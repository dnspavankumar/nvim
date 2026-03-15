-- diagnostics config
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    vim.diagnostic.config
    {
      float = { border = 'rounded' },
      underline = { severity = 'ERROR' },
      update_in_insert = false,
      virtual_text = {
        current_line = false,
        spacing = 4,
        source = 'if_many',
        prefix = '●',
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = ' ',
          [vim.diagnostic.severity.WARN] = ' ',
          [vim.diagnostic.severity.HINT] = ' ',
          [vim.diagnostic.severity.INFO] = ' ',
        },
      },
    }
  end
})


vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp" },
  callback = function(args)
    if vim.fn.executable("clangd") ~= 1 then
      return
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok, blink = pcall(require, "blink.cmp")
    if ok then
      capabilities = blink.get_lsp_capabilities(capabilities)
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
      name = "clangd",
      cmd = {
        "clangd",
        "--background-index",
        "--completion-style=detailed",
        "--header-insertion=never",
      },
      capabilities = capabilities,
      root_dir = vim.fs.root(args.buf, { "compile_commands.json", "compile_flags.txt", ".git" }),
      on_attach = on_attach,
    }

    if type(vim.lsp.config) == "function" and type(vim.lsp.enable) == "function" then
      vim.lsp.config("clangd", clangd_config)
      vim.lsp.enable("clangd")
    else
      vim.lsp.start(clangd_config)
    end
  end,
})
