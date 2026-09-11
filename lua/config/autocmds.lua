-- load usercmds first
pcall(require, "config/usercmds")

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set:
--   https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- NOTE: prefix groups with `user_`, NOT `lazyvim_`. LazyVim creates its groups as
-- `lazyvim_<name>` with `clear = true`, so an identically named group here would
-- silently wipe LazyVim's.
--
-- Things that used to live here now live elsewhere:
--   * json/jsonc/json5 conceallevel  -> LazyVim
--   * large files (treesitter, ...)  -> snacks.bigfile (`filetype = bigfile`)
--   * `.ipf` commentstring           -> after/ftplugin/ipf.lua
--   * cmdline-window maps            -> config/keymaps/cmdwin.lua
local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Disable diagnostics in certain files.
--
-- Deliberately a pattern autocmd instead of after/ftplugin files: the rule mixes
-- filename and extension patterns, and uppercase `*.MD` gets no filetype from
-- Neovim, so ftplugin files could not cover it.
--
-- NOTE: the buffer must be scoped explicitly, otherwise this disables
-- diagnostics globally for every buffer in the session.
vim.api.nvim_create_autocmd({ "BufRead", "BufNew" }, {
  group = augroup("disable_diagnostics"),
  pattern = { ".env", "*.md", "*.MD" },
  callback = function()
    vim.diagnostic.enable(false, { bufnr = 0 })
  end,
})
