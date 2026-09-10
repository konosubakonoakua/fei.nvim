-- load usercmds first
pcall(require, "config/usercmds")

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set:
--   https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- NOTE: prefix the groups with `user_`, NOT `lazyvim_`. LazyVim creates its own
-- groups as `lazyvim_<name>` with `clear = true`, so an identically named group
-- here silently wipes LazyVim's (e.g. our old `lazyvim_json_conceal` clobbered
-- LazyVim's json/jsonc/json5 conceal handling).
local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Disable diagnostics in certain files
-- NOTE: the buffer must be scoped explicitly, otherwise this disables
-- diagnostics globally for every buffer in the session.
vim.api.nvim_create_autocmd({ "BufRead", "BufNew" }, {
  group = augroup("disable_diagnostics"),
  pattern = { ".env", "*.md", "*.MD" },
  callback = function()
    vim.diagnostic.enable(false, { bufnr = 0 })
  end,
})

-- Disable tree-sitter for files over 1MB in size
vim.api.nvim_create_autocmd("BufRead", {
  group = augroup("large_file_treesitter"),
  pattern = "*",
  callback = function()
    local name = vim.api.nvim_buf_get_name(0)
    if name ~= "" and vim.fn.getfsize(name) > 500000 then
      vim.treesitter.stop()
    end
  end,
})

-- Fix conceallevel for json & help files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc" },
  callback = function()
    vim.wo.spell = false
    vim.wo.conceallevel = 0
  end,
})

-- NOTE: Use <C-v> instead
-- Auto disable or enable mini.pairs when using macro
--
-- vim.api.nvim_create_autocmd({ "RecordingEnter" }, {
--   group = augroup("disable_minipairs_when_using_macro"),
--   callback = function(event)
--     vim.g.minipairs_disable = true
    -- vim.notify("minipairs disabled")
--   end,
-- })

-- https://github.com/neovim/neovim/pull/24565
-- vim.api.nvim_create_autocmd({ "RecordingLeave" }, {
--   group = augroup("enable_minipairs_when_not_using_macro"),
--   callback = function(event)
--     vim.g.minipairs_disable = false
--     -- vim.notify("minipairs enabled")
--   end,
-- })

-- command history
-- command-line window
vim.api.nvim_create_autocmd("cmdwinenter", {
  group = augroup("cmdwin"),
  callback = function()
    vim.keymap.set({"n", "i"}, "<C-y>", "<cr>q:", { buffer = true, silent = true })
    vim.keymap.set({"n", "i"}, "<F5>", "<cr>q:", { buffer = true, silent = true })
    -- TODO: figure out whether it is possible to jump to another window while keeping command-line window
    -- vim.keymap.set({"n"}, "<C-k>", "<C-w>k", { buffer = true, silent = true })
    -- vim.keymap.set({"n"}, "<C-j>", "<C-w>j", { buffer = true, silent = true })
    -- NOTE: in cmdline-windows, use q to quit, <C-q> as recording
    vim.keymap.set("n", "<C-q>", "q", { buffer = true, silent = true, noremap = true })
    vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = true, silent = true, noremap = true })
  end,
})
--
-- vim.cmd[[
-- autocmd CmdWinEnter * lua require('cmp').setup({enabled = false})
-- autocmd CmdWinLeave * lua require('cmp').setup({enabled = true})
-- ]]

-- Set commentstring for igor pro
vim.api.nvim_create_autocmd({ "BufRead", "BufNew" }, {
  group = augroup("ipf_commentstring"),
  pattern = { "*.ipf", },
  callback = function()
    vim.o.commentstring = "// %s"
  end,
})
