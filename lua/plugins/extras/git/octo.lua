return {
  {
    -- TODO: keymapping for 'octo.nvim'
    -- "konosubakonoakua/octo.nvim",
    'pwntester/octo.nvim',
    -- event = "VeryLazy", -- don't use event if use module
    module = false, -- NOTE: do not automatically load it
    init = function ()
      -- call `Octo` first time to load
      -- then the cmd will be overwritten by setup later
      vim.api.nvim_create_user_command('Octo', function ()
        vim.cmd[[Lazy load octo.nvim]]
        LazyVim.info(":Lazy load octo.nvim")
      end, {desc = ":Lazy load octo.nvim"})
    end,
    cmd = {"Octo"},
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
