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
