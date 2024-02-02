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

-- Auto disable or enable mini.pairs when using macro
vim.api.nvim_create_autocmd({ "RecordingEnter" }, {
  group = augroup("disable_minipairs_when_using_macro"),
  callback = function(event)
    vim.g.minipairs_disable = true
    -- vim.notify("minipairs disabled")
  end,
})

-- https://github.com/neovim/neovim/pull/24565
-- vim.api.nvim_create_autocmd({ "RecordingLeave" }, {
--   group = augroup("enable_minipairs_when_not_using_macro"),
--   callback = function(event)
--     vim.g.minipairs_disable = false
--     -- vim.notify("minipairs enabled")
--   end,
-- })

-- command history
vim.api.nvim_create_autocmd("cmdwinenter", {
  callback = function()
    vim.keymap.set({"n", "i"}, "<C-y>", "<cr>q:", { buffer = true })
    vim.keymap.set({"n", "i"}, "<F5>", "<cr>q:", { buffer = true })
    vim.keymap.set("n", "<leader>q", ":q<cr>", { buffer = true })
  end,
})
