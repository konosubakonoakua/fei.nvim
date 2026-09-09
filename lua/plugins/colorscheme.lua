local M = {
  -- TODO: tweak colorscheme
  {
    "konosubakonoakua/oxocarbon.nvim",
    -- "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
    version = false,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "oxocarbon",
    },
  },
}

return M
