-- GUI-only (Neovide & other GUI clients) keymaps: font scaling / transparency.
if vim.fn.has("gui_running") ~= 1 then
  return
end

local keymap = vim.keymap.set

vim.notify("neovim running on GUI")

if vim.g.neovide == true then
  vim.g.neovide_scale_factor_max = 4.0
  vim.g.neovide_scale_factor_min = 0.1
  vim.g.neovide_scale_factor_default = 1.2
  vim.g.neovide_transparency_default = 0.8

  keymap({ "n", "i" }, "<C-=>", ":lua vim.g.neovide_scale_factor = math.min(vim.g.neovide_scale_factor + 0.1,  vim.g.neovide_scale_factor_max)<CR>", { desc = "Neovide Font +++" })
  keymap({ "n", "i" }, "<C-->", ":lua vim.g.neovide_scale_factor = math.max(vim.g.neovide_scale_factor - 0.1,  vim.g.neovide_scale_factor_min)<CR>", { desc = "Neovide Font ---" })
  keymap({ "n", "i" }, "<C-+>", ":lua vim.g.neovide_transparency = math.min(vim.g.neovide_transparency + 0.025, 1.0)<CR>", { desc = "Neovide Trans +++" })
  keymap({ "n", "i" }, "<C-_>", ":lua vim.g.neovide_transparency = math.max(vim.g.neovide_transparency - 0.025, 0.0)<CR>", { desc = "Neovide Trans ---" })
  keymap({ "n", "i" }, "<C-0>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor_default<CR>", { desc = "Neovide Font Reset" })
  keymap({ "n", "i" }, "<C-)>", ":lua vim.g.neovide_transparency = vim.g.neovide_transparency_default<CR>", { desc = "Neovide Trans Reset" })
else
  vim.g.gui_font_default_size = 16
  vim.g.gui_font_size = vim.g.gui_font_default_size
  vim.g.gui_font_face = vim.g.gui_font_face or "Lilex Nerd Font"

  local function RefreshGuiFont()
    vim.opt.guifont = string.format("%s:h%s", vim.g.gui_font_face, vim.g.gui_font_size)
  end
  local function ResizeGuiFont(delta)
    vim.g.gui_font_size = vim.g.gui_font_size + delta
    RefreshGuiFont()
  end
  local function ResetGuiFont()
    vim.g.gui_font_size = vim.g.gui_font_default_size
    RefreshGuiFont()
  end

  -- -- Call function on startup to set default value
  -- ResetGuiFont()

  keymap({ "n", "i" }, "<C-+>", function() ResizeGuiFont(1) end, { desc = "GUI FONT +++" })
  keymap({ "n", "i" }, "<C-->", function() ResizeGuiFont(-1) end, { desc = "GUI FONT ---" })
  keymap({ "n", "i" }, "<C-0>", function() ResetGuiFont() end, { desc = "GUI FONT Reset" })
end
