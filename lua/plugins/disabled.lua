-- put disable plugins here
return {
  -- disable unused colorschemes
  { "projekt0n/github-nvim-theme", enabled = false },
  { "catppuccin/nvim", enabled = false },
  { "folke/tokyonight.nvim", enabled = false },

  -- disable neo-tree & edgy
  -- edgy disabled in lazy.lua (no import)
  -- { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { "folke/edgy.nvim", enabled = false },

  -- disable zen mode
  { "folke/zen-mode.nvim", enabled = false },

  -- disable windows resizing
  { "anuvyklack/windows.nvim", enabled = false },

  -- disable gtags
  -- { "ukyouz/vim-gutentags", enabled = false },
  { "liuchengxu/vista.vim", enabled = false },

  -- disable leaderf
  -- { "Yggdroot/LeaderF", enabled = false },
  -- { "konosubakonoakua/LeaderF", enabled = false },

  -- disable hardtime
  { "m4xshen/hardtime.nvim", enabled = false },

  -- disable fzf-lua
  { "ibhagwan/fzf-lua", enabled = false },

  -- disable telescope-file-browser
  -- { "nvim-telescope/telescope-file-browser.nvim", enabled = false },

  -- diable folke/noice.nvim
  -- causing cursor disapper until reopen, when leaderf enabled
  -- { "folke/noice.nvim", enabled = false },
}
