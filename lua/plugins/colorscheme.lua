return {
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
  },
  {
    "sjl/badwolf",
    priority = 1000,
    init = function()
      vim.g.badwolf_darkgutter = 1
    end,
    config = function()
      vim.cmd.colorscheme("badwolf")

      local bg = "#000000" -- pitch black background
      local lime = "#aeee00" -- badwolf's lime
      local lime_groups = {
        "@preproc",
        "@keyword.directive",
        "@type.builtin",
        "@constant.builtin",
        "@namespace",
        "@function.builtin",
      }

      local function black_bg(group)
        local cur = vim.api.nvim_get_hl(0, { name = group })
        cur.bg = bg
        vim.api.nvim_set_hl(0, group, cur)
      end

      local function apply()
        vim.api.nvim_set_hl(0, "Normal", { fg = "#f8f6f2", bg = bg })
        for _, g in ipairs({ "LineNr", "SignColumn", "NormalFloat", "Pmenu" }) do
          black_bg(g)
        end
        for _, g in ipairs(lime_groups) do
          vim.api.nvim_set_hl(0, g, { fg = lime })
        end
      end

      apply()

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("BadwolfCustom", { clear = true }),
        callback = function()
          if vim.g.colors_name ~= "badwolf" then
            return
          end
          vim.schedule(apply)
        end,
      })
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
  },
}
