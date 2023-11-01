-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set:
--   https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local Util = require("lazyvim.util")
require("lazyvim.util").has("mini.bufremove")

-- resize splits if window got resized
-- vim.api.nvim_create_autocmd({ "VimResized" }, {
--   callback = function()
--     vim.cmd("tabdo wincmd =")
--   end,
-- })

-- switches to dashboard when last buffer is closed
local dashboard_on_empty_callback = function()
  if Util.has("mini.starter") then
    vim.cmd([[Neotree close]])
    -- FIXME: maybe need to disable lazyload for opening starter
    require("mini.starter").open()
  elseif Util.has("alpha") then
    vim.cmd([[Neotree close]])
    vim.cmd([[Alpha]])
  end
end

if Util.has("mini.bufremove") then
  local open_starter_if_empty_buffer = function()
    local buf_id = vim.api.nvim_get_current_buf()
    local is_empty = vim.api.nvim_buf_get_name(buf_id) == "" and vim.bo[buf_id].filetype == ""
    if not is_empty then
      return
    end
    dashboard_on_empty_callback()
    vim.cmd(buf_id .. "bwipeout")
  end

  _G.my_bufdelete = function(...)
    -- FIXME: not called, don't know Y
    -- clue here: https://github.com/echasnovski/mini.nvim/discussions/389
    vim.notify("***********************")
    require("mini.bufremove").delete(...)
    open_starter_if_empty_buffer()
  end

  _G.my_bufwipeout = function(...)
    vim.notify("***********************")
    require("mini.bufremove").wipeout(...)
    open_starter_if_empty_buffer()
  end
elseif Util.has("bufdelete") then
  -- FIXME: make it working
  local alpha_on_empty = vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "BDeletePost*",
    group = alpha_on_empty,
    callback = function(event)
      local fallback_name = vim.api.nvim_buf_get_name(event.buf)
      local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
      local fallback_on_empty = fallback_name == "" and fallback_ft == ""
      if not fallback_on_empty then
        return
      end
      dashboard_on_empty_callback()
      vim.cmd(event.buf .. "bwipeout")
    end,
  })
end

-- create directories when needed, when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match

    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end,
})

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
