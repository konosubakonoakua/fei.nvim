return {
  'Wansmer/treesj',
  keys = { '<space>m' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
  config = function()
    -- https://github.com/Wansmer/treesj
    require('treesj').setup({

    })
  end,
}
