return {
  {
    "chrisgrieser/nvim-origami",
    event = "VeryLazy",
    opts = {}, -- required even when using default config

    -- recommended: disable vim's auto-folding
    init = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
    config = function()
      require("origami").setup({
        useLspFoldsWithTreesitterFallback = { enable = false },
      })
      vim.api.nvim_create_autocmd("FileType", {
        desc = "Folding: use Treesitter as folding provider if available",
        callback = function(ctx)
          local filetype = ctx.match or vim.bo[ctx.buf].filetype
          local win = vim.api.nvim_get_current_win()
          local ok, hasParser = pcall(vim.treesitter.query.get, filetype, "folds")
          if ok and hasParser then
            vim.wo[win][0].foldmethod = "expr"
            vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          else
            vim.wo[win][0].foldmethod = "indent"
            vim.wo[win][0].foldexpr = ""
          end
        end,
      })
    end,
  },
}
