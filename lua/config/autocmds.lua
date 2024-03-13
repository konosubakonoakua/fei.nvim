-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set:
--   https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- local Util = require("lazyvim.util")
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Disable diagnostics in certain files
vim.api.nvim_create_autocmd({ "BufRead", "BufNew" }, {
  pattern = { ".env", "*.md", "*.MD" },
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

-- Disable tree-sitter for files over 1MB in size
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*",
  callback = function()
    local size = vim.fn.getfsize(vim.fn.expand("%:p"))
    if size > 500000 then
      vim.treesitter.stop()
    end
  end,
})

-- Fix conceallevel for json & help files
vim.api.nvim_create_autocmd({ "FileType" }, {
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
  callback = function()
    vim.keymap.set({"n", "i"}, "<C-y>", "<cr>q:", { buffer = true, silent = true })
    vim.keymap.set({"n", "i"}, "<F5>", "<cr>q:", { buffer = true, silent = true })
    -- TODO: figure out whether it is possible to jump to another window while keeping command-line window
    -- vim.keymap.set({"n"}, "<C-k>", "<C-w>k", { buffer = true, silent = true })
    -- vim.keymap.set({"n"}, "<C-j>", "<C-w>j", { buffer = true, silent = true })
    -- NOTE: in cmdline-windows, use q to quit, <C-q> as recording
    vim.keymap.set("n", "<C-q>", "q", { buffer = true, silent = true, noremap = true })
    vim.keymap.set("n", "q", ":q<cr>", { buffer = true, silent = true, noremap = true })
  end,
})
