local uv = vim.uv or vim.loop
local autosave_timers = {} -- map of buf -> timer
local delay = 1000 -- delay in milliseconds (1 second)

local function autosave(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  -- Check if buffer is modified, normal, has a file path, and is not read-only
  if vim.bo[buf].modified
     and vim.bo[buf].buftype == ""
     and vim.api.nvim_buf_get_name(buf) ~= ""
     and not vim.bo[buf].readonly then

    -- Cancel existing timer for this buffer to debounce
    if autosave_timers[buf] then
      autosave_timers[buf]:stop()
      autosave_timers[buf]:close()
      autosave_timers[buf] = nil
    end

    -- Start a new timer
    local timer = uv.new_timer()
    autosave_timers[buf] = timer
    timer:start(delay, 0, vim.schedule_wrap(function()
      if autosave_timers[buf] == timer then
        autosave_timers[buf] = nil
      end
      if not timer:is_closing() then
        timer:stop()
        timer:close()
      end

      -- Re-verify conditions before saving
      if vim.api.nvim_buf_is_valid(buf)
         and vim.bo[buf].modified
         and vim.bo[buf].buftype == ""
         and vim.api.nvim_buf_get_name(buf) ~= ""
         and not vim.bo[buf].readonly then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("silent! write")
        end)
      end
    end))
  end
end

local group = vim.api.nvim_create_augroup("AutosaveGroup", { clear = true })

-- Trigger autosave on text change in normal or insert mode
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  group = group,
  callback = function(ev)
    autosave(ev.buf)
  end,
})

-- Save all modified buffers on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modified then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("silent! write")
        end)
      end
    end
  end,
})

-- Template for new C++ files
local template_group = vim.api.nvim_create_augroup("CppTemplate", { clear = true })
vim.api.nvim_create_autocmd("BufNewFile", {
  group = template_group,
  pattern = { "*.cpp", "*.cc" },
  callback = function()
    local template = vim.fn.expand("~/.config/nvim/templates/template.cpp")
    local lines = vim.fn.readfile(template)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.bo.filetype = "cpp"
    for i, line in ipairs(lines) do
      if line:match("solve%(%)") then
        vim.api.nvim_win_set_cursor(0, { i + 1, 4 })
        break
      end
    end
  end,
})

-- Remove bold from statusline/tabline UI elements only (not syntax)
local nobold_group = vim.api.nvim_create_augroup("NoBoldUI", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = nobold_group,
  callback = function()
    vim.api.nvim_set_hl(0, "StatusLine", { fg = "#d4d4d4", bg = "#1e1e1e", bold = false })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#d4d4d4", bg = "#1e1e1e", bold = false })
    vim.api.nvim_set_hl(0, "TabLine", { bold = false })
    vim.api.nvim_set_hl(0, "TabLineSel", { bold = false })
    vim.api.nvim_set_hl(0, "TabLineFill", { bold = false })
    vim.api.nvim_set_hl(0, "WinBar", { fg = "#f8f6f2", bg = "#000000", bold = false })
    vim.api.nvim_set_hl(0, "WinBarNC", { fg = "#f8f6f2", bg = "#000000", bold = false })
  end,
})

-- Use cindent for C/C++ instead of treesitter indent (treesitter has issues with Neovim 0.12)
local indent_group = vim.api.nvim_create_augroup("CppIndent", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = { "c", "cpp" },
  callback = function()
    vim.bo.cindent = true
    vim.bo.indentexpr = ""
  end,
})

-- Clean up timers when buffer is deleted or unloaded
vim.api.nvim_create_autocmd({ "BufUnload", "BufDelete" }, {
  group = group,
  callback = function(ev)
    local buf = ev.buf
    if autosave_timers[buf] then
      autosave_timers[buf]:stop()
      if not autosave_timers[buf]:is_closing() then
        autosave_timers[buf]:close()
      end
      autosave_timers[buf] = nil
    end
  end,
})
