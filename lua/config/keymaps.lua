-- NOTE:
-- map `<C-Fx>` is equal to map `<Fy>` where y = x + 24.
-- map `<S-Fx>` is equal to map `<Fy>` where y = x + 12.

-- region local functions

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--- This file is automatically loaded by lazyvim.config.init

-- stylua: ignore start
local _opts   = { silent = true }

-- make all keymaps silent by default
local keymap_set = vim.keymap.set
---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  return keymap_set(mode, lhs, rhs, opts)
end

local status, Utils = pcall(require, "util")
if not status then
  -- BUG: loop require in CI environment
  -- Error detected while processing /home/runner/.config/nvim/init.lua:
  LazyVim.error("Error loading util in config/keymaps")
  return {}
end

local _floatterm    = Utils.custom_floatterm
local _lazyterm     = Utils.custom_lazyterm
local _lazyterm_cwd = Utils.custom_lazyterm_cwd

local keymap             = vim.keymap.set
local keymap_force       = vim.keymap.set
local keydel             = vim.keymap.del

-- endregion local functions

if vim.g.neovide then
  vim.keymap.set(
      {'n', 'v', 's', 'x', 'o', 'i', 'l', 'c', 't'},
      '<C-S-v>',
      function() vim.api.nvim_paste(vim.fn.getreg('+'), true, -1) end,
      { noremap = true, silent = true }
  )
end

vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Write file" })
vim.keymap.set({ "x", "n", "s" }, "<leader>fw", "<cmd>w<cr><esc>", { desc = "Write file" })

-- TODO: maybe remap @ to disable minipairs before macro playing
-- 
-- vim.keymap.set({ "n" }, "@", function ()
--   vim.g.minipairs_disable = true
--   vim.cmd('@')
-- end, { desc = "Play Macro [reg]" })

-- stay when using * to search
keymap("n", "*", "*N", { desc = "Search cword"})

-- clear hilight search
-- TODO: validate if this affects the `i<esc>j` sequence to moveline
-- Clear search with <esc>, currently only in normal mode
-- keymap({ "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- region line move
-- Move Lines
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
-- FIXED: `i<esc>j` sequence triggers <A-j> in insert mode
-- vim.opt.ttimeoutlen = 30
-- https://github.com/neovim/neovim/issues/27344
-- keydel({"i"}, "<A-j>")
-- keydel({"i"}, "<A-k>")
keymap("v", "<A-j>", "<cmd>m '>+1<cr>gv=gv", { desc = "Move down" })
keymap("v", "<A-k>", "<cmd>m '<-2<cr>gv=gv", { desc = "Move up" })
-- endregion line move

-- region indent
-- stay in visual mode when indent
keymap("v", "<", "<gv", { desc = "visual indent <"})
keymap("v", ">", ">gv", { desc = "visual indent >"})

-- change tabstop & shiftwidth
-- method with count
-- keymap("n", "<leader>u<tab>", function ()
--   local cmd = "<cmd>set tabstop=" .. vim.v.count .. " shiftwidth=" .. vim.v.count .. "<cr>"
--   vim.notify(cmd)
--   return cmd
-- end, {expr = true, desc = "Set tabstop & shiftwidth"})
--
keymap("n", "<leader>u<tab>", function ()
  local sel = vim.fn.confirm(
    "Select desired tabstop & shiftwidth",
    "&2\n&4\n&8")
  -- vim.notify(vim.inspect(sel))
  if sel ~= 0 then
    vim.o.tabstop = 2^sel
    vim.o.shiftwidth = 2^sel
    vim.notify(
      "tabstop & shiftwidth now equal to [" .. tostring(2^sel) .. "]",
      vim.log.levels.WARN)
  end
end, {desc = "Set tabstop & shiftwidth"})
-- endregion indent start

-- endregion visual mode remappings

-- better up/down
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- region windows remappings
-- TODO: find better keyremapping for windows
--

keymap("n", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window",  silent = true })
keymap("n", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window", silent = true })
keymap("n", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window", silent = true })
keymap("n", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window", silent = true })
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
keymap("n", "<leader>wo", "<cmd>wincmd o<cr>", { desc = "Delete all other windows", silent = true })
keymap("n", "<leader>ws", "<cmd>wincmd s<cr>", { desc = "Split window below", silent = true })
keymap("n", "<leader>wv", "<cmd>wincmd v<cr>", { desc = "Split window right", silent = true })
keymap("n", "<leader>wx", "<cmd>wincmd x<cr>", { desc = "Swap windows (stay)", silent = true })
keymap("n", "<leader>wr", "<cmd>wincmd r<cr>", { desc = "Swap windows", silent = true })
-- keymap("n", "<leader>wn", "<C-W>n", { desc = "New windows", remap = true })
-- keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
-- keymap("n", "<leader>ww", "<C-W>p", { desc = "Goto other window", remap = true })
-- keymap("n", "<leader>wr", "<C-W>r", { desc = "Rotate window (hor)", remap = true })
-- keymap("n", "<leader>wR", "<C-W>R", { desc = "Rotate window (ver)", remap = true })
-- keymap("n", "<leader>wz", "<C-W>=", { desc = "Restore window size", remap = true })
-- keymap("n", "<leader>wv", "<C-W>|", { desc = "Maximum window (ver)", remap = true })
-- keymap("n", "<leader>wf", "<C-W>|", { desc = "Maximum window (hor)", remap = true })
-- keymap("n", "<leader>wk", "<C-W>s", { desc = "Split window below", remap = true })
-- keymap("n", "<leader>wl", "<C-W>v", { desc = "Split window right", remap = true })
-- keymap("n", "<leader>wh", "<C-W>v<C-W>h", { desc = "Split window left", remap = true })
-- keymap("n", "<leader>wF", "<C-W>|<C-W>_", { desc = "Delete window (hor & ver)", remap = true })
-- keymap("n", "<leader>wj", "<C-W>s<C-W>k", { desc = "Split window above", remap = true })
-- endregion windows remappings


-- region tabs remappings
keymap("n", "<leader><tab>L", "<cmd>tablast<cr>", { desc = "Last Tab" })
keymap("n", "<leader><tab>F", "<cmd>tabfirst<cr>", { desc = "First Tab" })

keymap("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
keymap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
keymap("n", "<leader><tab>l", "<cmd>tabnext<cr>", { desc = "Next Tab" })
keymap("n", "<leader><tab>h", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
keymap("n", "<leader><tab><tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })

keymap("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
keymap("n", "<leader><tab>c", "<cmd>tabclose<cr>", { desc = "Close Tab" })
keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
keymap("n", "<leader><tab>;", "<cmd>tabclose<cr>", { desc = "Close Tab" })
-- keymap("n", "<leader><tab><tab>", "<cmd>tabclose<cr>", { desc = "Close Tab" })
-- endregion tabs remappings

-- region plugin remappings

-- search keywords in linux programmer's manual
keymap("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- -- floating terminal (using esc_esc to enter normal mode)
-- local _lazyterm_singleton = function ()
--   -- vim.notify(vim.inspect(vim.v.count))
--   -- NOTE: avoid to open another terminal after enter normal mode using <esc><esc>
--   -- but still can use a count prefix which not equal to 0 to create a new terminal
--   if vim.v.count == 0 and (vim.bo.ft == "lazyterm" or vim.bo.ft == "toggleterm") then
--     vim.cmd("close")
--   else
--     _lazyterm()
--   end
-- end

keymap("n", "<leader>fD", "<cmd>Dotfiles<cr>",  { desc = "Search dotfiles" })
keymap("n", "<leader>fT", _lazyterm_cwd,  { desc = "Terminal (cwd)" })
keymap("n", "<leader>ft", _lazyterm,      { desc = "Terminal (root dir)" })
-- keymap("n", "<c-/>",      _lazyterm_singleton,      { desc = "Terminal (root dir)" })
-- -- NOTE: most terminals don't correctly map C-/, and sometimes you need to use C-_ for that key instead.
-- keymap("n", "<c-_>",      _lazyterm_singleton,      { desc = "which_key_ignore" })

-- Terminal Mappings
-- TODO: mapping double esc causing fzf-lua quiting slowly using esc
--
-- keymap("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
-- keymap("t", "<C-h>", "", { desc = "disabled" })
-- keymap("t", "<C-j>", "", { desc = "disabled" })
-- keymap("t", "<C-k>", "", { desc = "disabled" })
-- keymap("t", "<C-l>", "", { desc = "disabled" })
-- keymap("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
-- keymap("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
-- keymap("t", "<C-L>", "<c-\\><c-n>A", { desc = "Clear Terminal" }) -- when <C-l> used for windows

-- Windows -- TODO: consider unregister windows shortcut
--
-- keymap("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
-- keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
-- keymap("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
-- keymap("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
-- keymap("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
-- keymap("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- endregion plugin remappings

-- region <leader>; group remappings

-- ptpython
if vim.fn.executable("ptpython") == 1 then
  -- TODO: consider adding python env selection
  vim.keymap.set("n", "<leader>;p", function()
    _floatterm(
      { "ptpython", "--vi" },
      { esc_esc = false, ctrl_hjkl = false, border = "rounded",
        env = {
          ['some_env_vars'] = "" -- NOTE: env parameter placeholder
        }
      }
    )
  end, { desc = "!ptpython" })
end

-- system monitor
if vim.fn.executable("btop") == 1 then
  vim.keymap.set("n", "<leader>;b", function()
    _floatterm({ "btop" }, { esc_esc = false, ctrl_hjkl = false, border = "rounded" })
  end, { desc = "!Btop" })
end

-- endregion <leader>; group remappings

-- region toggle options
-- BUG: lazyvim toggle is replaced with snacks toggle
--
-- local cmp_enabled = true
-- Snacks.toggle.wrap({
--   name = "Auto Completion",
--   get = function()
--     return cmp_enabled
--   end,
--   set = function(state)
--     -- NOTE: logic flipped, wired
--     if state then
--       cmp_enabled = true
--     else
--       cmp_enabled = false
--     end
--     require("cmp").setup.buffer({ enabled = cmp_enabled })
--     -- LazyVim.info("state: " .. vim.inspect(state))
--     -- LazyVim.info("cmd_enabled: " .. vim.inspect(cmp_enabled))
--   end,
-- }):map("<leader>ua")
-- NOTE:　enable lazyredraw to speed up macro execution

-- Snacks.toggle("lazyredraw", { name = "Lazyredraw" }):map("<leader>uR")
-- Snacks.toggle("statuscolumn", { name = "Statuscolumn", values = {"", vim.o.statuscolumn} }):map("<leader>uS")

-- endregion toggle options


-- region neovide keymapping
if vim.fn.has("gui_running") == 1 then
  vim.notify("neovim running on GUI")
  if vim.g.neovide == true then
    vim.g.neovide_scale_factor_max = 4.0
    vim.g.neovide_scale_factor_min = 0.1
    vim.g.neovide_scale_factor_default = 1.2
    vim.g.neovide_transparency_default = 0.8

    keymap_force({"n", "i"}, "<C-=>", ":lua vim.g.neovide_scale_factor = math.min(vim.g.neovide_scale_factor + 0.1,  vim.g.neovide_scale_factor_max)<CR>", { silent = true, desc = "Neovide Font +++" })
    keymap_force({"n", "i"}, "<C-->", ":lua vim.g.neovide_scale_factor = math.max(vim.g.neovide_scale_factor - 0.1,  vim.g.neovide_scale_factor_min)<CR>", { silent = true, desc = "Neovide Font ---"})
    keymap_force({"n", "i"}, "<C-+>", ":lua vim.g.neovide_transparency = math.min(vim.g.neovide_transparency + 0.025, 1.0)<CR>", { silent = true, desc = "Neovide Trans +++" })
    keymap_force({"n", "i"}, "<C-_>", ":lua vim.g.neovide_transparency = math.max(vim.g.neovide_transparency - 0.025, 0.0)<CR>", { silent = true, desc = "Neovide Trans ---" })
    keymap_force({"n", "i"}, "<C-0>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor_default<CR>", { silent = true , desc = "Neovide Font Reset"})
    keymap_force({"n", "i"}, "<C-)>", ":lua vim.g.neovide_transparency = vim.g.neovide_transparency_default<CR>", { silent = true , desc = "Neovide Trans Reset"})
  else
    vim.g.gui_font_default_size = 16
    vim.g.gui_font_size = vim.g.gui_font_default_size
    -- vim.g.gui_font_face = "Fira Code Retina"

    RefreshGuiFont = function() vim.opt.guifont = string.format("%s:h%s",vim.g.gui_font_face, vim.g.gui_font_size) end
    ResizeGuiFont = function(delta) vim.g.gui_font_size = vim.g.gui_font_size + delta; RefreshGuiFont() end
    ResetGuiFont = function () vim.g.gui_font_size = vim.g.gui_font_default_size; RefreshGuiFont() end

    -- -- Call function on startup to set default value
    -- ResetGuiFont()

    local opts = { noremap = true, silent = true }
    opts.desc = "GUI FONT +++"
    keymap_force({'n', 'i'}, "<C-+>", function() ResizeGuiFont(1)  end, opts)
    opts.desc = "GUI FONT ---"
    keymap_force({'n', 'i'}, "<C-->", function() ResizeGuiFont(-1) end, opts)
    opts.desc = "GUI FONT Reset"
    keymap_force({'n', 'i'}, "<C-0>", function() ResetGuiFont() end, opts)
  end
end
-- endregion neovide keymapping

-- region <leader>l/<leader>L
-- TODO: remap <leader>l and <leader>L
keydel("n", "<leader>l")
keydel("n", "<leader>L")
-- endregion <leader>l/<leader>L

-- NOTE: donot trigger autocmd when executing macro
-- https://www.reddit.com/r/neovim/comments/tsol2n/comment/i2ugipm
vim.cmd([[
  xnoremap @ :<C-U>execute "noautocmd '<,'>norm! " . v:count1 . "@" . getcharstr()<cr>
  nnoremap @ <cmd>execute "noautocmd norm! " . v:count1 . "@" . getcharstr()<cr>
]])

-- region <leader>b
keymap('n', '<leader>b.', function()
    local buffers = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_valid(buf) then
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          if #lines == 1 and #lines[1] == 0 then
          -- Buffer is empty, delete it
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end
  end, { desc = "Delete all empty buffer", noremap = true, silent = true })
-- endregion <leader>b

-- region <leader>c
local function insert_set_command()
    local commentstring = vim.bo.commentstring or "# %s"

    local tab_width = vim.fn.input("Enter tab width (2/4/8): ")

    if tab_width ~= "2" and tab_width ~= "4" and tab_width ~= "8" then
        print("Invalid tab width. Please enter 2, 4, or 8.")
        return
    end

    local command = string.format("vim :set ts=%s sw=%s sts=%s et :", tab_width, tab_width, tab_width)

    local commented_command = string.format(commentstring, command)

    vim.api.nvim_buf_set_lines(0, -1, -1, false, { commented_command })
end

vim.api.nvim_create_user_command("InsertSetCommand", insert_set_command, {})
keymap("n", "<leader>c/", ":InsertSetCommand<CR>")
-- endregion <leader>c

-- stylua: ignore end

-- vim:sw=2:ts=2:
