-- User keymaps, loaded by LazyVim on the VeryLazy event.
-- Default LazyVim keymaps:
--   https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- Split into focused modules:
--   windows.lua  window navigation / resizing / management
--   tabs.lua     tab pages
--   terminal.lua terminals & dotfile search
--   utils.lua    <leader>; utilities
--   lsp.lua      LSP workspace maps
--   gui.lua      GUI (Neovide) font & transparency maps

-- NOTE: <C-Fx> == <Fy> (y = x + 24);  <S-Fx> == <Fy> (y = x + 12).

-- make all keymaps silent by default
local raw_keymap = vim.keymap.set
---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  return raw_keymap(mode, lhs, rhs, opts)
end

local keymap = vim.keymap.set
local keydel = vim.keymap.del

-- write
keymap({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Write file" })
keymap({ "x", "n", "s" }, "<leader>fw", "<cmd>w<cr><esc>", { desc = "Write file" })

-- search: stay on the current match, clear highlight on <esc>
keymap("n", "*", "*N", { desc = "Search cword" })
keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- move lines
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
keymap("v", "<A-j>", "<cmd>m '>+1<cr>gv=gv", { desc = "Move down" })
keymap("v", "<A-k>", "<cmd>m '<-2<cr>gv=gv", { desc = "Move up" })

-- indent, stay in visual mode
keymap("v", "<", "<gv", { desc = "Visual indent <" })
keymap("v", ">", ">gv", { desc = "Visual indent >" })

-- better up/down (screen lines unless a count is given)
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- set tabstop / shiftwidth from a prompt
keymap("n", "<leader>u<tab>", function()
  local sel = vim.fn.confirm("Select desired tabstop & shiftwidth", "&2\n&4\n&8")
  if sel ~= 0 then
    vim.o.tabstop = 2 ^ sel
    vim.o.shiftwidth = 2 ^ sel
    vim.notify("tabstop & shiftwidth now equal to [" .. tostring(2 ^ sel) .. "]", vim.log.levels.WARN)
  end
end, { desc = "Set tabstop & shiftwidth" })

-- man/help for the word under the cursor
keymap("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- run macros without triggering autocmds
vim.cmd([[
  xnoremap @ :<C-U>execute "noautocmd '<,'>norm! " . v:count1 . "@" . getcharstr()<cr>
  nnoremap @ <cmd>execute "noautocmd norm! " . v:count1 . "@" . getcharstr()<cr>
]])

-- delete all empty buffers
keymap("n", "<leader>b.", function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      if #lines == 1 and #lines[1] == 0 then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end
end, { desc = "Delete all empty buffers" })

-- insert a `:set ts/sw` snippet (command defined in config/usercmds.lua)
keymap("n", "<leader>c/", "<cmd>InsertSetCommand<cr>", { desc = "Insert :set ts/sw command" })

-- free up <leader>l / <leader>L
keydel("n", "<leader>l")
keydel("n", "<leader>L")

-- neovide: paste from the system clipboard
if vim.g.neovide then
  keymap({ "n", "v", "s", "x", "o", "i", "l", "c", "t" }, "<C-S-v>", function()
    vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
  end)
end

-- submodules
require("config.keymaps.windows")
require("config.keymaps.tabs")
require("config.keymaps.terminal")
require("config.keymaps.utils")
require("config.keymaps.lsp")
require("config.keymaps.gui")

-- vim:sw=2:ts=2:
