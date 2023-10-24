-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local plat = require("platform")

if vim.g.neovide then
  -- font
  vim.opt.guifont = { "Lilex Nerd Font Mono", "h8" }
  vim.g.neovide_scale_factor = 1.0

  -- windows
  vim.g.neovide_remember_window_size = true

  -- cursor
  -- vim.g.neovide_cursor_animation_length = 0.13
  -- vim.g.neovide_cursor_trail_size = 0.8
  -- vim.g.neovide_cursor_antialiasing = true
  -- vim.g.neovide_cursor_animate_command_line = true
  -- vim.g.neovide_cursor_unfocused_outline_width = 0.125

  -- vfx
  -- vim.g.neovide_cursor_vfx_mode = "railgun"
end

vim.opt.exrc = true

-- INFO: trailing 0x0A in return value of vim.fn.system, strip it
if not plat.isPlatWindows() then
  vim.g.python3_host_prog = vim.fn.system("which python3"):match("^%s*(.-)%s*$")
end

-- sqlite.lua
if plat.isPlatWindows() then
  vim.g.sqlite_clib_path = plat.libdeps.sqlite3
end

vim.opt.guicursor = "a:block"
