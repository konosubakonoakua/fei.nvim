-- #region local functions

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--- This file is automatically loaded by lazyvim.config.init

local Util = require("lazyvim.util")
local keymap = require("util").keymap
local cmd_concat = require("util").cmd_concat
local _opts = { silent = true }

-- #endregion local functions

-- stylua: ignore start

-- #region visual mode remappings

--[[ Better paste
  remap "p" in visual mode to delete the highlighted text
  without overwriting your yanked/copied text,
  and then paste the content from the unnamed register.
]]
keymap("v", "p", '"_dP', _opts)

-- stay in visual mode when indent
keymap("v", "<", "<gv", _opts)
keymap("v", ">", ">gv", _opts)

-- better up/down
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- #endregion visual mode remappings

-- #region windows remappings

-- TODO: find new plugins for resizing
-- FIXME: soeme window remapping not working
keymap("n", "<C-w>z", cmd_concat("WindowsMaximize"), { desc = "WindowsMaximize" })
keymap("n", "<C-w>_", cmd_concat("WindowsMaximizeVertically"), { desc = "WindowsMaximize VER" })
keymap("n", "<C-w>|", cmd_concat("WindowsMaximizeHorizontally"), { desc = "WindowsMaximize HOR" })
keymap("n", "<C-w>=", cmd_concat("WindowsEqualize"), { desc = "WindowsEqualize" })
keymap("n", "<leader>wa", cmd_concat("WindowsToggleAutowidth"), { desc = "New windows", remap = true })

keymap("n", "<leader>wn", "<C-W>n", { desc = "New windows", remap = true })
keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
keymap("n", "<leader>wo", "<C-W>o", { desc = "Delete all other windows", remap = true })
keymap("n", "<leader>ww", "<C-W>p", { desc = "Goto other window", remap = true })
keymap("n", "<leader>wr", "<C-W>r", { desc = "Rotate window (hor)", remap = true })
keymap("n", "<leader>wR", "<C-W>R", { desc = "Rotate window (ver)", remap = true })
keymap("n", "<leader>wz", "<C-W>=", { desc = "Restore window size", remap = true })
keymap("n", "<leader>wv", "<C-W>|", { desc = "Maximum window (ver)", remap = true })
keymap("n", "<leader>wf", "<C-W>|", { desc = "Maximum window (hor)", remap = true })
keymap("n", "<leader>wk", "<C-W>s", { desc = "Split window below", remap = true })
keymap("n", "<leader>wl", "<C-W>v", { desc = "Split window right", remap = true })
keymap("n", "<leader>wh", "<C-W>v<C-W>h", { desc = "Split window left", remap = true })
keymap("n", "<leader>wF", "<C-W>|<C-W>_", { desc = "Delete window (hor & ver)", remap = true })
keymap("n", "<leader>wj", "<C-W>s<C-W>k", { desc = "Split window above", remap = true })

-- #endregion windows remappings

-- #region plugin remappings

-- TODO: what is this?
-- keywordprg
keymap("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- Terminal Mappings
keymap("t", "<C-L>", "<c-\\><c-n>A", { desc = "Clear Terminal" })
-- Trouble
-- Add keymap only show FIXME
if Util.has("todo-comments.nvim") then
  -- show fixme on telescope
  keymap("n", "<leader>xsf", "<cmd>TodoTelescope keywords=FIX,FIXME,BUG<CR>", { desc = "Show FIXME" })
  keymap("n", "<leader>xst", "<cmd>TodoTelescope keywords=TODO<CR>", { desc = "Show TODO" })
  keymap("n", "<leader>xsT", "<cmd>TodoTelescope keywords=TEST<CR>", { desc = "Show TEST" })
  keymap("n", "<leader>xsi", "<cmd>TodoTelescope keywords=INFO<CR>", { desc = "Show INFO" })
end
-- #endregion plugin remappings

--#region <leader>; group remappings

-- system monitor
if vim.fn.executable("btop") == 1 then vim.keymap.set("n", "<leader>;b", function()
    require("lazyvim.util").float_term({ "btop" }, { esc_esc = false, ctrl_hjkl = false })
  end, { desc = "btop" })
end

-- Dashboard
keymap("n", "<leader>;;", function()
  if Util.has("alpha-nvim") then
    vim.cmd("Neotree close")
    vim.cmd("Alpha")
  elseif Util.has("mini.starter") then
    local starter = require("mini.starter") -- TODO: need test mini.starter
    pcall(starter.refresh)
  end
end, { desc = "dashboard", silent = true })

keymap("n", "<leader>;l", "<cmd>Lazy<cr>", { desc = "Lazy" })
keymap("n", "<leader>;L", Util.changelog, { desc = "LazyVim Changelog" })
keymap("n", "<leader>;m", "<cmd>Mason<cr>", { desc = "Mason" })
keymap("n", "<leader>;I", "<cmd>LspInfo<cr>", { desc = "LspInfo" })

-- #endregion

-- #region toggle options
-- toggle options
keymap("n", "<leader>uf", require("lazyvim.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })
keymap("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
keymap("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
keymap("n", "<leader>ul", function() Util.toggle_number() end, { desc = "Toggle Line Numbers" })
keymap("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
keymap("n", "<leader>uC", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })
if vim.lsp.inlay_hint then
  keymap("n", "<leader>uh", function() vim.lsp.inlay_hint(0, nil) end, { desc = "Toggle Inlay Hints" })
end

-- #endregion toggle options

-- stylua: ignore end
