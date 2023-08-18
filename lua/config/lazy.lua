-- bootstrap for lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- stylua: ignore
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local spec = {
  -- add LazyVim and import its plugins
  { "LazyVim/LazyVim", import = "lazyvim.plugins" },
  -- import any extras modules here
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "lazyvim.plugins.extras.util.project" },
  { import = "lazyvim.plugins.extras.dap.core" }, -- FIXME: rust dap not working, cannot enter
  { import = "lazyvim.plugins.extras.dap.nlua" },
  -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
  -- { import = "lazyvim.plugins.extras.ui.mini-starter" },
  -- { import = "lazyvim.plugins.extras.ui.edgy" },
  -- import/override with your plugins
  { import = "plugins" },
  { import = "plugins.extras" },
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
    icons = require("util.icons"),
  },
  defaults = {
    lazy = false,
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  -- install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
