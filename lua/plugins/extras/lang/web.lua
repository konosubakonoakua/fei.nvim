
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "html",
          "jsdoc",
          "jsonc",
          "tsx",
          "typescript",
          "javascript",
        })
      end
    end,
  },
}
