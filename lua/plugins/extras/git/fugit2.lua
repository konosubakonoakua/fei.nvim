return {
  'SuperBo/fugit2.nvim',
  -- opts = {
  --   width = 100,
  --   height = 50,
  --   min_width = 50,
  --   content_width = 60,
  --   max_width = "80%",
  --   external_diffview = false,
  -- },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
    'nvim-lua/plenary.nvim',
    -- {
    --   'chrisgrieser/nvim-tinygit', -- optional: for Github PR view
    --   dependencies = { 'stevearc/dressing.nvim' }
    -- },
  },
  cmd = { 'Fugit2', 'Fugit2Diff', 'Fugit2Graph' },
  keys = {
    { '<leader>Ff', mode = 'n', '<cmd>Fugit2<cr>' },
    { '<leader>Fd', mode = 'n', '<cmd>Fugit2Diff<cr>' },
    { '<leader>Fg', mode = 'n', '<cmd>Fugit2Graph<cr>' },
  },
  config = true,
}
