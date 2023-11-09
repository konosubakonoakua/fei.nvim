return {
  -- TODO: tweak colorscheme
  { "nyoom-engineering/oxocarbon.nvim" },
  { "projekt0n/github-nvim-theme" },
  {
    "Mofiqul/adwaita.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.adwaita_darker = true
      vim.g.adwaita_disable_cursorline = true
      vim.g.adwaita_transparent = true
      -- vim.cmd("colorscheme adwaita")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "adwaita",
      colorscheme = "oxocarbon",
      -- colorscheme = "github_dark",
    },
  },
}
