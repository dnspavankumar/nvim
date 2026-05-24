local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop

if not uv.fs_stat(lazypath) then
  local clone_result = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.schedule(function()
      vim.notify("Failed to clone lazy.nvim:\n" .. clone_result, vim.log.levels.ERROR)
    end)
    return
  end
end

vim.opt.rtp:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")
if not ok then
  vim.schedule(function()
    vim.notify("lazy.nvim is not available. Check internet and restart Neovim.", vim.log.levels.ERROR)
  end)
  return
end

lazy.setup("plugins", {
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  ui = { border = "rounded" },
})

if vim.g.colorscheme_skip_persist then
  return
end

local last_file = vim.fn.stdpath("config") .. "/last_colorscheme"
local ok, lines = pcall(vim.fn.readfile, last_file)
if ok and #lines > 0 and lines[1] ~= "" then
  pcall(vim.cmd.colorscheme, lines[1])
else
  pcall(vim.cmd.colorscheme, "onedark")
end
