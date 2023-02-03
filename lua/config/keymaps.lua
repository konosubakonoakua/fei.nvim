-- #region local functions

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--- This file is automatically loaded by lazyvim.config.init

local Util = require("lazyvim.util")
local _opts = { silent = true }

local function keymap(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local function cmd(command)
   return table.concat({ '<Cmd>', command, '<CR>' })
end

-- #endregion local functions

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
keymap('n', '<C-w>z', cmd 'WindowsMaximize',             { desc = "WindowsMaximize" })
keymap('n', '<C-w>_', cmd 'WindowsMaximizeVertically',   { desc = "WindowsMaximize VER" })
keymap('n', '<C-w>|', cmd 'WindowsMaximizeHorizontally', { desc = "WindowsMaximize HOR" })
keymap('n', '<C-w>=', cmd 'WindowsEqualize',             { desc = "WindowsEqualize" })
keymap("n", "<leader>wa", cmd 'WindowsToggleAutowidth',  { desc = "New windows", remap = true })

keymap("n", "<leader>wn", "<C-W>n",        { desc = "New windows", remap = true })
keymap("n", "<leader>wd", "<C-W>c",        { desc = "Delete window", remap = true })
keymap("n", "<leader>wo", "<C-W>o",        { desc = "Delete all other windows", remap = true })
keymap("n", "<leader>ww", "<C-W>p",        { desc = "Goto other window", remap = true })
keymap("n", "<leader>wr", "<C-W>r",        { desc = "Rotate window (hor)", remap = true })
keymap("n", "<leader>wR", "<C-W>R",        { desc = "Rotate window (ver)", remap = true })
keymap("n", "<leader>wz", "<C-W>=",        { desc = "Restore window size", remap = true })
keymap("n", "<leader>wv", "<C-W>|",        { desc = "Maximum window (ver)", remap = true })
keymap("n", "<leader>wf", "<C-W>|",        { desc = "Maximum window (hor)", remap = true })
keymap("n", "<leader>wF", "<C-W>|<C-W>_",  { desc = "Delete window (hor & ver)", remap = true })
keymap("n", "<leader>wj", "<C-W>s<C-W>k",  { desc = "Split window above", remap = true })
keymap("n", "<leader>wk", "<C-W>s",        { desc = "Split window below", remap = true })
keymap("n", "<leader>wh", "<C-W>v<C-W>h",  { desc = "Split window left", remap = true })
keymap("n", "<leader>wl", "<C-W>v",        { desc = "Split window right", remap = true })

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
if vim.fn.executable("btop") == 1 then
  vim.keymap.set( "n", "<leader>;b", function()
    require("lazyvim.util")
      .float_term({ "btop" }, { esc_esc = false, ctrl_hjkl = false })
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
end, { desc = "dashboard", silent = true})

keymap("n", "<leader>;l", "<cmd>Lazy<cr>", { desc = "Lazy" })
keymap("n", "<leader>;L", Util.changelog, {desc = "LazyVim Changelog"})

--#endregion

