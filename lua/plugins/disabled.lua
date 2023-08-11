-- put disable plugins here
return {
  -- disable unused colorschemes
  { "projekt0n/github-nvim-theme", enabled = false },
  { "catppuccin/nvim", enabled = false },
  { "folke/tokyonight.nvim", enabled = false },

  -- disable neo-tree & edgy
  -- edgy disabled in lazy.lua (no import)
  -- { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  -- { "folke/edgy.nvim", enabled = false },

  -- disable zen mode
  { "folke/zen-mode.nvim", enabled = false },

  -- disable windows resizing
  { "anuvyklack/windows.nvim", enabled = false },
}
