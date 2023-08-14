-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if vim.g.neovide then
  vim.opt.guifont = { "Lilex Nerd Font Mono", "h9" }
  vim.g.neovide_scale_factor = 0.3
end

-- INFO: trailing 0x0A in return value of vim.fn.system, strip it
vim.g.python3_host_prog = vim.fn.system("which python3"):match("^%s*(.-)%s*$")
