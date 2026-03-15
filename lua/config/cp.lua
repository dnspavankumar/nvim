local M = {}

local template_path = vim.fn.stdpath("config") .. "/templates/cpp_template.cpp"

local default_template = {
  "#include <bits/stdc++.h>",
  "using namespace std;",
  "",
  "int main() {",
  "    ios::sync_with_stdio(false);",
  "    cin.tie(nullptr);",
  "",
  "    return 0;",
  "}",
}

local function normalize_path(path)
  return (path or ""):gsub("\\", "/")
end

local function ensure_template_file()
  local template_dir = vim.fn.fnamemodify(template_path, ":h")
  if vim.fn.isdirectory(template_dir) == 0 then
    vim.fn.mkdir(template_dir, "p")
  end

  if vim.fn.filereadable(template_path) == 0 then
    vim.fn.writefile(default_template, template_path)
  end
end

local function get_template_lines()
  ensure_template_file()
  local lines = vim.fn.readfile(template_path)
  if #lines == 0 then
    return default_template
  end
  return lines
end

local function buffer_is_empty(bufnr)
  if vim.api.nvim_buf_line_count(bufnr) ~= 1 then
    return false
  end

  local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
  return first_line == ""
end

local function apply_template_if_empty(bufnr)
  local name = normalize_path(vim.api.nvim_buf_get_name(bufnr))
  if name == normalize_path(template_path) then
    return
  end

  if vim.bo[bufnr].buftype ~= "" then
    return
  end

  if not buffer_is_empty(bufnr) then
    return
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, get_template_lines())
end

local function parse_from_filename(filepath)
  local stem = vim.fn.fnamemodify(filepath, ":t:r")

  local contest, problem = stem:match("^(%d+)([A-Za-z][A-Za-z0-9]*)$")
  if contest and problem then
    return contest, problem:upper()
  end

  contest, problem = stem:match("^(%d+)[-_]([A-Za-z][A-Za-z0-9]*)$")
  if contest and problem then
    return contest, problem:upper()
  end

  problem = stem:match("^([A-Za-z][A-Za-z0-9]*)[%._%-%s]")
  if problem then
    return nil, problem:upper()
  end

  if stem:match("^[A-Za-z][A-Za-z0-9]*$") then
    return nil, stem:upper()
  end

  return nil, nil
end

local function parse_codeforces_from_url(url)
  if type(url) ~= "string" then
    return nil, nil
  end

  local contest, problem = url:match("codeforces%.com/contest/(%d+)/problem/([A-Za-z][A-Za-z0-9]*)")
  if contest and problem then
    return contest, problem:upper()
  end

  contest, problem = url:match("codeforces%.com/problemset/problem/(%d+)/([A-Za-z][A-Za-z0-9]*)")
  if contest and problem then
    return contest, problem:upper()
  end

  contest, problem = url:match("codeforces%.com/gym/(%d+)/problem/([A-Za-z][A-Za-z0-9]*)")
  if contest and problem then
    return contest, problem:upper()
  end

  return nil, nil
end

local function parse_contest_from_parent(filepath)
  local parent = vim.fn.fnamemodify(filepath, ":h:t")
  if parent:match("^%d+$") then
    return parent
  end
  return nil
end

local function sanitize_input(value)
  return (value or ""):gsub("%s+", "")
end

local function read_lines_head(filepath, max_lines)
  local current = normalize_path(vim.api.nvim_buf_get_name(0))
  if current == normalize_path(filepath) then
    local count = math.min(max_lines, vim.api.nvim_buf_line_count(0))
    return vim.api.nvim_buf_get_lines(0, 0, count, false)
  end

  local ok, lines = pcall(vim.fn.readfile, filepath, "", max_lines)
  if ok then
    return lines
  end
  return {}
end

local function parse_from_source_url(filepath)
  local lines = read_lines_head(filepath, 80)
  for _, line in ipairs(lines) do
    local url = line:match("https?://%S+")
    if url and url:find("codeforces%.com") then
      url = url:gsub("[%)%]}>\"'%,%.]+$", "")
      local contest, problem = parse_codeforces_from_url(url)
      if contest and problem then
        return contest, problem
      end
    end
  end
  return nil, nil
end

local function resolve_problem_context(filepath)
  local contest, problem = parse_from_filename(filepath)
  contest = contest or parse_contest_from_parent(filepath)

  local url_contest, url_problem = parse_from_source_url(filepath)
  contest = contest or url_contest
  problem = problem or url_problem

  if not contest then
    contest = sanitize_input(vim.fn.input("Codeforces contest ID: "))
  end

  if not problem then
    local guessed = vim.fn.fnamemodify(filepath, ":t:r")
    if guessed:match("^[A-Za-z][A-Za-z0-9]*$") then
      guessed = guessed:upper()
    else
      guessed = ""
    end
    problem = sanitize_input(vim.fn.input("Codeforces problem index (A/B/C1...): ", guessed))
  end

  contest = sanitize_input(contest)
  problem = sanitize_input(problem):upper()

  if contest == "" or problem == "" then
    return nil, nil
  end

  return contest, problem
end

local function build_submit_command(filepath, contest, problem)
  local url = string.format("https://codeforces.com/contest/%s/problem/%s", contest, problem)
  local replacements = {
    contest = vim.fn.shellescape(contest),
    problem = vim.fn.shellescape(problem),
    file = vim.fn.shellescape(filepath),
    url = vim.fn.shellescape(url),
  }

  local custom = vim.g.codeforces_submit_command
  if type(custom) == "string" and custom ~= "" then
    return (custom:gsub("{(%w+)}", function(key)
      return replacements[key] or ""
    end))
  end

  if vim.fn.executable("cf") == 1 then
    return string.format(
      "cf submit %s %s %s",
      replacements.contest,
      replacements.problem,
      replacements.file
    )
  end

  if vim.fn.executable("oj") == 1 then
    return string.format("oj submit -y %s %s", replacements.url, replacements.file)
  end

  if vim.fn.executable("python") == 1 then
    return string.format("python -m onlinejudge_command.main submit -y %s %s", replacements.url, replacements.file)
  end

  if vim.fn.executable("py") == 1 then
    return string.format("py -m onlinejudge_command.main submit -y %s %s", replacements.url, replacements.file)
  end

  return nil
end

local function build_login_command()
  if vim.fn.executable("cf") == 1 then
    return "cf login"
  end

  if vim.fn.executable("oj") == 1 then
    return "oj login https://codeforces.com/"
  end

  if vim.fn.executable("python") == 1 then
    return "python -m onlinejudge_command.main login https://codeforces.com/"
  end

  if vim.fn.executable("py") == 1 then
    return "py -m onlinejudge_command.main login https://codeforces.com/"
  end

  return nil
end

local function open_terminal_with_command(command)
  vim.cmd("botright 12split")
  vim.cmd("terminal " .. command)
  vim.cmd("startinsert")
end

function M.open_template()
  ensure_template_file()
  vim.cmd("edit " .. vim.fn.fnameescape(template_path))
end

function M.submit_current_file()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == "" then
    vim.notify("Save the current file before submitting.", vim.log.levels.WARN)
    return
  end

  if not filepath:match("%.cpp$") then
    vim.notify("F5 submit currently supports .cpp files only.", vim.log.levels.WARN)
    return
  end

  if vim.bo.modified then
    vim.cmd("write")
  end

  local contest, problem = resolve_problem_context(filepath)
  if not contest or not problem then
    vim.notify("Submission cancelled: contest ID or problem index is missing.", vim.log.levels.WARN)
    return
  end

  local command = build_submit_command(filepath, contest, problem)
  if not command then
    vim.notify(
      "No submit command found. Install 'cf' or 'online-judge-tools', or set vim.g.codeforces_submit_command.",
      vim.log.levels.ERROR
    )
    return
  end

  vim.notify(string.format("Submitting %s (%s%s)...", vim.fn.fnamemodify(filepath, ":t"), contest, problem))
  open_terminal_with_command(command)
end

function M.login_codeforces()
  local command = build_login_command()
  if not command then
    vim.notify(
      "No login command found. Install 'cf' or 'online-judge-tools'.",
      vim.log.levels.ERROR
    )
    return
  end

  vim.notify("Opening Codeforces login flow in terminal...")
  open_terminal_with_command(command)
end

function M.setup()
  ensure_template_file()

  if vim.fn.exists(":Template") == 0 then
    vim.api.nvim_create_user_command("Template", function()
      M.open_template()
    end, { desc = "Edit persistent C++ template" })
  end

  if vim.fn.exists(":CFSubmit") == 0 then
    vim.api.nvim_create_user_command("CFSubmit", function()
      M.submit_current_file()
    end, { desc = "Submit current C++ file to Codeforces" })
  end

  if vim.fn.exists(":CFLogin") == 0 then
    vim.api.nvim_create_user_command("CFLogin", function()
      M.login_codeforces()
    end, { desc = "Login for Codeforces submit CLI" })
  end

  pcall(vim.cmd, "cunabbrev template")
  vim.cmd([[
    cnoreabbrev <expr> template
      \ getcmdtype() ==# ':' && getcmdline() ==# 'template' ? 'Template' : 'template'
  ]])

  local group = vim.api.nvim_create_augroup("CppTemplateAutofill", { clear = true })
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
    group = group,
    pattern = "*.cpp",
    callback = function(args)
      apply_template_if_empty(args.buf)
    end,
    desc = "Auto insert saved C++ template in empty files",
  })
end

return M
