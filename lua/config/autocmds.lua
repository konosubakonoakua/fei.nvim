-- load usercmds first
pcall(require, "config/usercmds")

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set:
--   https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- NOTE: prefix groups with `user_`, NOT `lazyvim_`. LazyVim creates its groups as
-- `lazyvim_<name>` with `clear = true`, so an identically named group here would
-- silently wipe LazyVim's.
--
-- Filetype option tweaks live elsewhere:
--   * json/jsonc/json5 conceallevel is handled by LazyVim.
--   * large files are handled by snacks.bigfile (it switches the buffer to
--     `filetype = bigfile`, which stops treesitter & friends).
--   * `.ipf` commentstring is in after/ftplugin/ipf.lua (ft set by config/filetypes.lua).
local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Disable diagnostics in certain files.
-- NOTE: the buffer must be scoped explicitly, otherwise this disables
-- diagnostics globally for every buffer in the session.
vim.api.nvim_create_autocmd({ "BufRead", "BufNew" }, {
  group = augroup("disable_diagnostics"),
  pattern = { ".env", "*.md", "*.MD" },
  callback = function()
    vim.diagnostic.enable(false, { bufnr = 0 })
  end,
})

-- Command-line window: use q to quit, <C-q> to record.
vim.api.nvim_create_autocmd("CmdWinEnter", {
  group = augroup("cmdwin"),
  callback = function()
    vim.keymap.set({ "n", "i" }, "<C-y>", "<cr>q:", { buffer = true, silent = true })
    vim.keymap.set({ "n", "i" }, "<F5>", "<cr>q:", { buffer = true, silent = true })
    vim.keymap.set("n", "<C-q>", "q", { buffer = true, silent = true, noremap = true })
    vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = true, silent = true, noremap = true })
  end,
})
