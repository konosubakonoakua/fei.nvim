-- #region local functions

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--- This file is automatically loaded by lazyvim.config.init

-- stylua: ignore start
local _opts   = { silent = true }
-- local _myutil = require("util")
local _util   = require("lazyvim.util")
local _floatterm = _util.terminal.open

local _lazyterm       = function() _util.terminal(nil, { cwd = _util.root() }) end
local _lazyterm_cwd   = function() _util.terminal(nil, { cwd = tostring(vim.fn.expand("%:p:h")), ctrl_hjkl = false }) end
-- local _lazyterm       = function() _floatterm(nil, { cwd = _util.root(), ctrl_hjkl = false }) end
-- local _lazyterm_cwd   = function() _floatterm(nil, { cwd = tostring(vim.fn.expand("%:p:h")), ctrl_hjkl = false }) end

-- local keymap             = require("util").keymap
local keymap             = vim.keymap.set
local keymap_force       = vim.keymap.set
local cmd_concat         = require("util").cmd_concat
local is_disabled_plugin = require("util").is_disabled_plugin

-- #endregion local functions

-- #region flash jump line
vim.keymap.set({ "i", "x", "n", "s" }, "<A-s>", function()
  require("flash").jump({
    search = { mode = "search", max_length = 0 },
    label = { after = { 0, 0 } },
    pattern = "^",
  })
end, { desc = "line jump" })
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
-- #endregion flash jump line

-- TODO: maybe remap @ to disable minipairs before macro playing
-- 
-- vim.keymap.set({ "n" }, "@", function ()
--   vim.g.minipairs_disable = true
--   vim.cmd('@')
-- end, { desc = "Play Macro [reg]" })

-- stay when using * to search
keymap("n", "*", "*N", _opts)

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
-- FIXME: some window remapping not working
if not is_disabled_plugin("anuvyklack/windows.nvim") then
  keymap("n", "<C-w>z",     cmd_concat("WindowsMaximize"),              { desc = "WindowsMaximize" })
  keymap("n", "<C-w>_",     cmd_concat("WindowsMaximizeVertically"),    { desc = "WindowsMaximize VER" })
  keymap("n", "<C-w>|",     cmd_concat("WindowsMaximizeHorizontally"),  { desc = "WindowsMaximize HOR" })
  keymap("n", "<C-w>=",     cmd_concat("WindowsEqualize"),              { desc = "WindowsEqualize" })
  keymap("n", "<leader>wa", cmd_concat("WindowsToggleAutowidth"),       { desc = "New windows", remap = true })
end

-- TODO: find better keyremapping for windows
--
--[[
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
]]
-- #endregion windows remappings

-- #region plugin remappings

-- search keywords in linux programmer's manual
keymap("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- floating terminal (using esc_esc to enter normal mode)
keymap("n", "<leader>fT", _lazyterm_cwd,  { desc = "Terminal (cwd)" })
keymap("n", "<leader>ft", _lazyterm,      { desc = "Terminal (root dir)" })
keymap("n", "<c-/>",      _lazyterm,      { desc = "Terminal (root dir)" })
keymap("n", "<c-_>",      _lazyterm,      { desc = "which_key_ignore" })

-- Terminal Mappings
-- TODO: mapping double esc causing fzf-lua quiting slowly using esc
--
-- keymap("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
-- keymap("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
-- keymap("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
-- keymap("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
-- keymap("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
-- keymap("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
-- keymap("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
keymap("t", "<C-L>", "<c-\\><c-n>A", { desc = "Clear Terminal" }) -- when <C-l> used for windows

-- Windows -- TODO: consider unregister windows shortcut
--
-- keymap("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
-- keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
-- keymap("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
-- keymap("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
-- keymap("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
-- keymap("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- #endregion plugin remappings

--#region <leader>; group remappings

-- Glow
-- TODO: disable ctrl_hjkl & fix quit by q
if vim.fn.executable("glow") == 1 then
  -- FIXME: glow wont enter TUI with file path
  -- https://github.com/charmbracelet/glow/issues/489
  -- { "glow", tostring(vim.fn.expand("%:p"))},
  keymap("n", "<leader>;g", function ()
    -- vim.notify("open glow at " .. tostring(vim.fn.expand("%:p:h")))
    _floatterm(
    { "glow" }, { cwd = tostring(vim.fn.expand("%:p:h")), ctrl_hjkl = false }) end,
    { desc = "!Glow" })
  -- keymap("n", "<leader>;g", "<cmd>Glow<cr>", { desc = "Glow" })
end

-- system monitor
if vim.fn.executable("btop") == 1 then
  vim.keymap.set("n", "<leader>;b", function()
    _floatterm({ "btop" }, { esc_esc = false, ctrl_hjkl = false })
  end, { desc = "!Btop" })
end

-- nnn
if vim.fn.executable("nnn") == 1 then
  vim.keymap.set("n", "<leader>;n", function()
    _floatterm({ "nnn" }, { esc_esc = false, ctrl_hjkl = false })
  end, { desc = "!nnn" })
end

-- Dashboard
keymap("n", "<leader>;;", function()
  if _util.has("dashboard-nvim") then
    vim.cmd("Neotree close")
    vim.cmd("Dashboard")
  elseif _util.has("alpha-nvim") then
    vim.cmd("Neotree close")
    vim.cmd("Alpha")
  elseif _util.has("mini.starter") then
    local starter = require("mini.starter") -- TODO: need test mini.starter
    pcall(starter.refresh)
  end
end, { desc = "Dashboard", silent = true })

keymap("n", "<leader>;l", "<cmd>Lazy<cr>",    { desc = "Lazy.nvim" })
keymap("n", "<leader>;m", "<cmd>Mason<cr>",   { desc = "Mason" })
keymap("n", "<leader>;I", "<cmd>LspInfo<cr>", { desc = "LspInfo" })
keymap("n", "<leader>;t", _lazyterm_cwd,      { desc = "Terminal (cwd)" })
keymap("n", "<leader>;T", _lazyterm,          { desc = "Terminal (root dir)" })
keymap("n", "<leader>;x", "<cmd>LazyExtras<cr>", { desc = "LazyExtras" })
keymap("n", "<leader>;L", _util.news.changelog,  { desc = "LazyVim Changelog" })
keymap("n", "<leader>;P", function()
  vim.notify("Added '" .. require("lazyvim.util").root() .. "' to project list.", vim.log.levels.WARN)
  vim.cmd('AddProject')
end, { desc = "Project Add Current" })

-- #endregion

-- #region toggle options
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
keymap_force("n", "<leader>uC", function() _util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })

if vim.lsp.inlay_hint then
  keymap_force("n", "<leader>uh", function() vim.lsp.inlay_hint(0, nil) end, { desc = "Toggle Inlay Hints" })
end

keymap("n", "<leader>us", function() _util.toggle("spell") end,      { desc = "Toggle Spelling" })
keymap("n", "<leader>uw", function() _util.toggle("wrap") end,       { desc = "Toggle Word Wrap" })
keymap("n", "<leader>ul", function() _util.toggle.number() end,      { desc = "Toggle Line Numbers" })
keymap("n", "<leader>ud", function() _util.toggle.diagnostics() end, { desc = "Toggle Diagnostics" })
keymap("n", "<leader>uf", function() require("lazyvim.util.format").toggle() end, { desc = "Toggle format on Save" })

_G.cmp_enabled = true
keymap("n", "<leader>ua", function()
    _G.cmp_enabled = not _G.cmp_enabled
    require("cmp").setup.buffer({ enabled = _G.cmp_enabled })
    if _G.cmp_enabled then
      vim.notify("Enabled: auto completion", vim.log.levels.WARN);
    else
      vim.notify("Disabled: auto completion", vim.log.levels.WARN);
    end
  end, { desc = "Toggle auto completion (buffer)" })


-- enable lazyredraw to speed up macro execution
_G.lazyredraw_enabled = true
keymap("n", "<leader>uR", function()
    _G.lazyredraw_enabled = not _G.lazyredraw_enabled

    if _G.lazyredraw_enabled then
      vim.cmd("set lazyredraw")
      vim.notify("Enabled: lazyredraw", vim.log.levels.WARN);
    else
      vim.cmd("set nolazyredraw")
      vim.notify("Disabled: lazyredraw", vim.log.levels.INFO);
    end
  end, { desc = "Toggle lazyredraw" })

-- #endregion toggle options

-- #region telescope
if _util.has("todo-comments.nvim") then
  keymap("n", "<leader>xsf", "<cmd>TodoTelescope keywords=FIX,FIXME,BUG<CR>", { desc = "Show FIXME" })
  keymap("n", "<leader>xst", "<cmd>TodoTelescope keywords=TODO<CR>", { desc = "Show TODO" })
  keymap("n", "<leader>xsT", "<cmd>TodoTelescope keywords=TEST<CR>", { desc = "Show TEST" })
  keymap("n", "<leader>xsi", "<cmd>TodoTelescope keywords=INFO<CR>", { desc = "Show INFO" })
end
keymap_force("n", "<leader>uc", _util.telescope("colorscheme", { enable_preview = true }), {desc = "Colorscheme with preview"})
keymap_force("n", "<leader>sr", "<cmd>Telescope resume<cr>",   { desc = "Telescope Resume" })
keymap_force("n", "<leader>s;", "<cmd>Telescope builtin<cr>",  { desc = "Telescope Builtins", noremap = true })
keymap_force("n", "<leader>sB", ":lua require('telescope.builtin').live_grep({grep_open_files=true})<cr>", {desc = "Find opened files", noremap = true})
keymap_force("n", "<leader>cR", "<cmd>Spectre<cr>",            { desc = "Replace in files (Spectre)" })
keymap_force("n", "<leader>fm", "<cmd>Telescope macros<cr>",   { desc = "NeoComposer Macros", noremap = true })
keymap_force("n", "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Fuzzy Search (Current)" })
keymap_force("n", "<leader>fc", function() require('telescope.builtin').find_files({find_command={'fd', vim.fn.expand("<cword>")}}) end, { desc = "Telescope Find cfile" })
keymap_force("n", "<leader>fC", _util.telescope.config_files(), { desc = "Find Config File" })
keymap_force("n", "<leader>fg", ":Telescope grep_string<cr>", {desc = "Telescope Grep String", noremap = true})
keymap_force("n", "<leader>fG", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", {desc = "Live grep args", noremap = true})
keymap_force("n", "<leader>fP", function() require("telescope.builtin").find_files( { cwd = require("lazy.core.config").options.root }) end, {desc = "Find Plugin File"})
-- #endregion telescope

-- stylua: ignore end
