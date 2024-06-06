return {
  desc = "Temporary plugins for trial",
  { "sindrets/diffview.nvim", enabled = true, },
  {
    -- TODO: trial "nvimdev/indentmini.nvim"
    -- cons:
    --     no toggle, no color
    -- pros:
    --     maybe fast
    -- BUG: if this file only contains this plug, extras will raise error
    "nvimdev/indentmini.nvim",
    enabled = false,
    config = function()
      require("indentmini").setup({
        char = '|',
        exclude = {
          'markdown',
        },
      })
      -- Colors are applied automatically based on user-defined highlight groups.
      -- There is no default value.
      vim.cmd.highlight('IndentLine guifg=#123456')
      -- Current indent line highlight
      vim.cmd.highlight('IndentLineCurrent guifg=#123456')
    end,
  },
}
