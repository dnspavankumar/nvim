local M = {}

function M.ai_buffer(ai_type)
  local start_line, end_line = 1, vim.fn.line '$'
  if ai_type == 'i' then
    -- Skip first and last blank lines for `i` textobject
    local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
    -- Do nothing for buffer with all blanks
    if first_nonblank == 0 or last_nonblank == 0 then
      return { from = { line = start_line, col = 1 } }
    end
    start_line, end_line = first_nonblank, last_nonblank
  end

  local to_col = math.max(vim.fn.getline(end_line):len(), 1)
  return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end

---@param buf integer
function M.get_kind_filter(buf)
  local kind_filter = {
    default = {
      'Class',
      'Constructor',
      'Enum',
      'Field',
      'Function',
      'Interface',
      'Method',
      'Module',
      'Namespace',
      'Package',
      'Property',
      'Struct',
      'Trait',
    },
    markdown = false,
    help = false,
    -- you can specify a different filter for each filetype
    lua = {
      'Class',
      'Constructor',
      'Enum',
      'Field',
      'Function',
      'Interface',
      'Method',
      'Module',
      'Namespace',
      -- 'Package', -- remove package since luals uses it for control flow structures
      'Property',
      'Struct',
      'Trait',
    },
  }
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local ft = vim.bo[buf].filetype
  if kind_filter == false then
    return
  end
  if kind_filter[ft] == false then
    return
  end
  if type(kind_filter[ft]) == 'table' then
    return kind_filter[ft]
  end
  ---@diagnostic disable-next-line: return-type-mismatch
  return type(kind_filter) == 'table' and type(kind_filter.default) == 'table' and kind_filter.default or
      nil
end

function M.symbols_filter(entry, ctx)
  if ctx.symbols_filter == nil then
    ctx.symbols_filter = M.get_kind_filter(ctx.bufnr) or false
  end
  if ctx.symbols_filter == false then
    return true
  end
  return vim.tbl_contains(ctx.symbols_filter, entry.kind)
end

---@param name string
function M.get_opts(name)
  local plugin = require 'lazy.core.config'.spec.plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require 'lazy.core.plugin'
  return Plugin.values(plugin, 'opts', false)
end

--- Returns a function which matches a filepath against the given glob/wildcard patterns.
--- Also works with zipfile:/tarfile: buffers (via `strip_archive_subpath`).
function M.root_pattern(...)
  local patterns = vim.iter { ... }:flatten(math.huge):totable()

  return function(startpath)
    startpath = startpath or vim.api.nvim_buf_get_name(0)
    startpath = startpath ~= "" and startpath or vim.uv.cwd()
    startpath = M.strip_archive_subpath(startpath)

    for _, pattern in ipairs(patterns) do
      for path in vim.fs.parents(startpath) do
        local candidate = vim.fs.joinpath(path, pattern)
        if vim.uv.fs_stat(candidate) then
          return path
        end
      end
    end
  end
end

-- For zipfile: or tarfile: virtual paths, returns the path to the archive.
-- Other paths are returned unaltered.
function M.strip_archive_subpath(path)
  -- Matches regex from zip.vim / tar.vim
  path = vim.fn.substitute(path, 'zipfile://\\(.\\{-}\\)::[^\\\\].*$', '\\1', '')
  path = vim.fn.substitute(path, 'tarfile:\\(.\\{-}\\)::.*$', '\\1', '')
  return path
end

function M.get_root()
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then return vim.uv.cwd() end
  local root = M.root_pattern('Makefile', '.git', 'lua')(path)
  if root then return root end
  local dir = vim.fs.dirname(path)
  local home = vim.env.HOME
  local parts = vim.split(dir, '/', { plain = true })
  local depth = math.max(#parts - 2, 1)
  local curr = dir
  for _ = 1, #parts - depth do
    if curr == home or curr == '/' then break end
    curr = vim.fs.dirname(curr)
  end
  return curr or vim.uv.cwd()
end

return M
