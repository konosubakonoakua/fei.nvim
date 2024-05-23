return {
  {
    "glepnir/nerdicons.nvim",
    cmd = "NerdIcons",
    lazy = true,
    version = false,
    enabled = false, -- need use regex to search
    init = function()
      require("nerdicons").setup({
        border = "rounded",
        width = 0.7,
        prompt = "󰨭 ",
        preview_prompt = " ",
        down = "<C-j>",
        up = "<C-k>",
        copy = "<C-y>",
      })
    end,
  },
  {
    '2kabhishek/nerdy.nvim',
    version = false,
    enabled = true,
    lazy = true,
    event = "VeryLazy",
    cmd = {'Terdy', 'Nerdy'},
    dependencies = {
      'stevearc/dressing.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function ()
      vim.api.nvim_create_user_command('Terdy', 'Telescope nerdy', { desc = "Telescope nerd fonts with nerdy"})
      require('telescope').load_extension('nerdy')
    end
  },
}
