return {
  {
    "vim-airline/vim-airline",
    init = function()
      vim.g.airline_powerline_fonts = 1
      vim.g.airline_extensions = { "branch", "quickfix" }
      vim.g["airline#extensions#branch#enabled"] = 1

      -- Lock airline to a custom theme so no colorscheme/theme can recolor it.
      vim.g.airline_theme = "custom"

      -- Hardcoded HSL colors. hsl(h, s%, l%) is converted to hex for airline.
      local function hsl(h, s, l)
        local function hue(p, q, t)
          if t < 0 then t = t + 1 end
          if t > 1 then t = t - 1 end
          if t < 1 / 6 then return p + (q - p) * 6 * t end
          if t < 1 / 2 then return q end
          if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
          return p
        end
        s = s / 100
        l = l / 100
        local r, g, b
        if s == 0 then
          r, g, b = l, l, l
        else
          local q = l < 0.5 and l * (1 + s) or l + s - l * s
          local p = 2 * l - q
          r = hue(p, q, h / 360 + 1 / 3)
          g = hue(p, q, h / 360)
          b = hue(p, q, h / 360 - 1 / 3)
        end
        local function hex(v)
          return string.format("%02X", math.floor(v * 255 + 0.5))
        end
        return "#" .. hex(r) .. hex(g) .. hex(b)
      end

      local C = {
        bg        = hsl(0, 0, 12),  -- dark gray, section b/c/x/y background
        fg        = hsl(0, 0, 83),  -- light gray, section b/c/x/y text
        accent_fg = hsl(0, 0, 10),  -- near-black text on the accent sections
        normal    = hsl(45, 100, 51), -- yellow accent (normal mode)
        insert    = hsl(42, 100, 50), -- yellow accent (insert/terminal mode)
        replace   = hsl(44, 100, 45), -- yellow accent (replace mode)
        visual    = hsl(43, 89, 38),  -- yellow accent (visual mode)
        warning   = hsl(30, 100, 50), -- orange for warnings
        error     = hsl(0, 100, 40),  -- red for errors
      }

      local function entry(fg, bg, attr)
        return { fg, bg, "", "", attr or "" }
      end

      local function mode(accent)
        local a = entry(C.accent_fg, accent)
        local b = entry(C.fg, C.bg)
        local c = entry(C.fg, C.bg)
        local x = entry(C.fg, C.bg)
        local y = entry(C.fg, C.bg)
        local z = entry(C.accent_fg, accent)
        return {
          airline_a = a,
          airline_b = b,
          airline_c = c,
          airline_x = x,
          airline_y = y,
          airline_z = z,
          airline_warning = entry(C.accent_fg, C.warning),
          airline_error = entry(C.accent_fg, C.error),
          airline_term = entry(C.fg, C.bg),
        }
      end

      local function inactive_mode()
        local a = entry(C.fg, C.bg)
        local b = entry(C.fg, C.bg)
        local c = entry(C.fg, C.bg)
        local x = entry(C.fg, C.bg)
        local y = entry(C.fg, C.bg)
        local z = entry(C.fg, C.bg)
        return {
          airline_a = a,
          airline_b = b,
          airline_c = c,
          airline_x = x,
          airline_y = y,
          airline_z = z,
          airline_warning = entry(C.accent_fg, C.warning),
          airline_error = entry(C.accent_fg, C.error),
          airline_term = entry(C.fg, C.bg),
        }
      end

      local normal = mode(C.normal)
      local insert = mode(C.insert)
      local visual = mode(C.visual)
      local replace = mode(C.replace)
      local inactive = inactive_mode()

      local accents = {
        none = { "", "", "", "", "" },
        bold = { "", "", "", "", "bold" },
        italic = { "", "", "", "", "italic" },
        red = { C.normal, "", "", "", "" },
        green = { C.normal, "", "", "", "" },
        blue = { C.normal, "", "", "", "" },
        yellow = { C.normal, "", "", "", "" },
        orange = { C.normal, "", "", "", "" },
        purple = { C.normal, "", "", "", "" },
      }

      vim.g["airline#themes#custom#palette"] = {
        normal = normal,
        normal_modified = normal,
        insert = insert,
        insert_modified = insert,
        insert_paste = insert,
        insert_paste_modified = insert,
        visual = visual,
        visual_modified = visual,
        replace = replace,
        replace_modified = replace,
        commandline = normal,
        commandline_modified = normal,
        terminal = insert,
        terminal_modified = insert,
        multi = insert,
        inactive = inactive,
        inactive_modified = inactive,
        accents = accents,
      }
    end,
  },
  {
    "airblade/vim-gitgutter",
    event = "VeryLazy",
    init = function()
      vim.g.gitgutter_set_sign_backgrounds = 0
    end,
  },
}
