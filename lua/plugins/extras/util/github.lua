return {
  {
    -- TODO: keymapping for 'octo.nvim'
    "konosubakonoakua/octo.nvim",
    -- 'pwntester/octo.nvim',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      -- OR 'ibhagwan/fzf-lua',
      "nvim-tree/nvim-web-devicons",
    },
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
