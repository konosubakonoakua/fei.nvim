-- bootstrap for lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

local spec = {
  -- add LazyVim and import its plugins
  { "LazyVim/LazyVim", import = "lazyvim.plugins" },
  { import = "plugins" },
}

require("lazy").setup({
  spec = spec,
  opts = {
    colorscheme = "oxocarbon",
    -- load the default settings
    defaults = {
      autocmds = true, -- lazyvim.config.autocmds
      keymaps = true, -- lazyvim.config.keymaps
      -- lazyvim.config.options can't be configured here since that's loaded before lazyvim setup
      -- if you want to disable loading options, add `package.loaded["lazyvim.config.options"] = true` to the top of your init.lua
    },
    -- icons used by other plugins
    icons = require("util.stuffs.icons"),
  },
  defaults = {
    lazy = false,
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = {
    missing = true, -- install missing plugins on startup
    colorscheme = { -- lazy.nvim ui theme with fallbacks
      "oxocarbon",
      "default",
    },
  },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  -- BUG: hot reloading not working well currently,
  -- always need to manually reopen nvim
  change_detection = {
    enabled = false,
    notify = true,
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",     -- highlight %
        -- "matchparen",  -- highlight ()[]{}
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    custom_keys = {
      ["<localleader>d"] = {
        function(plugin)
          dump(plugin)
        end,
        desc = "Dump Plugin",
      },
      ["<localleader>t"] = {
        function(plugin)
          require("lazy.util").float_term(nil, {
            cwd = plugin.dir,
          })
        end,
        desc = "Open terminal in plugin dir",
      },
    },
  },
})
