-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if vim.g.neovide then
  -- disable lazyredraw
  vim.o.lazyredraw = false

  -- font
  vim.opt.guifont = "Lilex Nerd Font:h14"
  vim.g.neovide_scale_factor = 1.0

  -- windows
  vim.g.neovide_remember_window_size = true

  -- cursor
  -- vim.g.neovide_cursor_animation_length = 0.13
  -- vim.g.neovide_cursor_trail_size = 0.8
  -- vim.g.neovide_cursor_antialiasing = true
  -- vim.g.neovide_cursor_animate_command_line = true
  -- vim.g.neovide_cursor_unfocused_outline_width = 0.125

  -- vfx
  -- vim.g.neovide_cursor_vfx_mode = "railgun"
end

vim.opt.exrc = true -- allow local .nvim.lua .vimrc .exrc files
vim.opt.secure = true -- disable shell and write commands in local .nvim.lua .vimrc .exrc files

-- INFO: trailing 0x0A in return value of vim.fn.system, strip it
if vim.fn.has("win32") == 0 then
  vim.g.python3_host_prog = os.getenv("PYNVIM") or vim.fn.system("which python3"):match("^%s*(.-)%s*$") or 0
else
  vim.g.python3_host_prog = os.getenv("PYNVIM") or vim.fn.exepath("python.exe")
end
-- stylua: ignore
if (vim.g.python3_host_prog == nil)
  or (vim.g.python3_host_prog == "")
  or (vim.g.python3_host_prog == 0) then
  LazyVim.error([[
  python3 not found, please set `$PYNVIM` to python3 executable
    you also need to install pynvim:
    python3 -m pip install pynvim
  ]])
end

-- setup shell
local status, Platform = pcall(require, "platform")
if not status then
  -- BUG: loop require in CI environment
  LazyVim.error("Error loading util in config/keymaps")
else
  Platform.setup_shell()
end

-- sqlite.lua
if vim.fn.has("win32") == 1 then
  vim.g.sqlite_clib_path = Platform.libdeps.sqlite3
end

-- NOTE: stop setting guicursor manually with noice.nvim,
-- there's a chance that the guicursor disappears
-- vim.opt.guicursor = "a:block"
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
vim.g.dashboard_colorful_banner_chance = 0.001 -- %0.1 chance

-- FIXED: inner word of (???)
vim.opt.iskeyword:append({ "?" })

-- disable autoformat by default
vim.g.autoformat = false

-- Use faster grep alternatives if possible
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = [[rg --hidden --glob "!.git" --no-heading --smart-case --vimgrep --follow $*]]
  vim.opt.grepformat = "%f:%l:%c:%m"
elseif vim.fn.executable("ag") == 1 then
  vim.opt.grepprg = [[ag --nogroup --nocolor --vimgrep]]
  vim.opt.grepformat = "%f:%l:%c:%m"
end

-- alway use unix file format
vim.opt.ff = "unix"

-- INFO: Press <Esc>key too fast (under ttimeoutlen) will trigger <Alt-key>
-- https://github.com/neovim/neovim/issues/8213
-- https://github.com/neovim/neovim/pull/8226
vim.opt.ttimeoutlen = 30

-- lsp
-- NOTE: we need put here to load first, otherwise pyright will be installed too
-- Set to "basedpyright" to use basedpyright instead of pyright.
-- Moved to user extras
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

-- disable mouse
vim.opt.mouse = ""

-- backup
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"

-- vim.opt.cmdheight = 0

vim.opt.pumblend = 0 -- Popup blend

-- add fallback fileencodings
vim.opt.fileencodings = "utf-8,ucs-bom,gb18030,gbk,gb2312,cp936"
vim.opt.termencoding = "utf-8"
vim.opt.encoding = "utf-8"
