local function on_attach(client, bufnr)
  local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end
  local del = vim.keymap.del
  del('n', '[d')
  del('n', ']d')

  map('K', function() vim.lsp.buf.hover() end, 'Hover')
  map('gd', function() require 'fzf-lua'.lsp_definitions() end, 'Goto Definition')
  map('gD', function() require 'fzf-lua'.lsp_declarations() end, 'Goto Declaration')
  map("gi", function() require 'fzf-lua'.lsp_implementations() end, "Go to implementation")
  map('gr', function() require 'fzf-lua'.lsp_references() end, "List references")

  map('<leader>ca', function() vim.lsp.buf.code_action() end, 'Code Action')
  map('<leader>cr', function() vim.lsp.buf.rename() end, 'Rename')
  map('<leader>cf', function() vim.lsp.buf.format() end, 'Lsp Format')
  map('<leader>cd', function() vim.diagnostic.open_float() end, 'Line Diagnostics')
  map('<leader>sd', function() require 'fzf-lua'.diagnostics_document() end, 'Document Diagnostics')
  map('<leader>sD', function() require 'fzf-lua'.diagnostics_workspace() end, 'Workspace Diagnostics')

  map('[d', function() vim.diagnostic.jump { count = -1, float = false } end, 'Previous Diagnostic')
  map(']d', function() vim.diagnostic.jump { count = 1, float = false } end, 'Next Diagnostic')
  map('[e', function() vim.diagnostic.jump { count = -1, float = false, severity = 'ERROR' } end,
    'Previous Error')
  map(']e', function() vim.diagnostic.jump { count = 1, float = false, severity = 'ERROR' } end,
    'Next Error')

  local filter = require 'utils.plugins'.symbols_filter
  map('<leader>ss', function()
    require 'fzf-lua'.lsp_document_symbols { regex_filter = filter }
  end, 'Goto Symbol')
  map('<leader>sS', function()
    require 'fzf-lua'.lsp_live_workspace_symbols { regex_filter = filter }
  end, 'Goto Symbol')

  vim.keymap.set({ 'n', 'i' }, '<c-h>', function()
    local r, c = unpack(vim.api.nvim_win_get_cursor(0))
    local l = vim.api.nvim_get_current_line()
    if l:sub(c + 1, c + 1) == '(' then
      vim.api.nvim_win_set_cursor(0, { r, c + 1 })
    end
    vim.defer_fn(vim.lsp.buf.signature_help, 1)
  end, { desc = 'Signature Help', buffer = bufnr })

  -- format on save
  if client:supports_method 'textDocument/formatting' then
    local grp = vim.api.nvim_create_augroup('LspFormat' .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = grp,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format { bufnr = bufnr }
      end,
    })
  end

  -- breadcrumbs
  if client:supports_method 'textDocument/documentSymbol' then
    local ok_navic, navic = pcall(require, 'nvim-navic')
    if ok_navic then
      navic.attach(client, bufnr)
    end
  end

  -- inlayhints
  if client:supports_method 'textDocument/inlayHint' then
    vim.defer_fn(function()
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end, 0)
  end
end

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

    local clangd_config = {
      name = "clangd",
      cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--header-insertion=iwyu',
        '--completion-style=detailed',
        '--function-arg-placeholders',
        '--fallback-style=llvm',
      },
      capabilities = capabilities,
      root_dir = vim.fs.root(args.buf, { "compile_commands.json", "compile_flags.txt", ".git" }),
      on_attach = on_attach,
    }

    vim.lsp.config("clangd", clangd_config)
    vim.lsp.enable("clangd")
  end,
})

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
