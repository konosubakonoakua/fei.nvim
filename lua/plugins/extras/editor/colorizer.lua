return {
  {
    "brenoprata10/nvim-highlight-colors",
    enabled = true,
    config = function()
      vim.opt.termguicolors = true
      require("nvim-highlight-colors").setup({})
    end,
  },
}
