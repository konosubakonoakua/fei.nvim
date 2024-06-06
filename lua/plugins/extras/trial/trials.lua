return {
  desc = "Temporary plugins for trial",
  {
    -- TODO: trial "nvimdev/indentmini.nvim"
    -- cons:
    --     no toggle, no color
    -- pros:
    --     maybe fast
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
