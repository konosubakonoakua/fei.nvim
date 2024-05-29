return {
  {
    -- TODO: keymapping for 'octo.nvim'
    -- "konosubakonoakua/octo.nvim",
    'pwntester/octo.nvim',
    event = "VeryLazy",
    config = function()
      require("octo").setup({
        mappings_disable_default = false,
        suppress_missing_scope = {
          projects_v2 = true,
        },
      })
    end,
  },
}
