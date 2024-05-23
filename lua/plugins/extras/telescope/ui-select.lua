return {
  -- https://github.com/nvim-telescope/telescope-ui-select.nvim
  desc = "Set vim.ui.select to telescope",
  'nvim-telescope/telescope-ui-select.nvim',
  config = function ()
    require("telescope").setup ({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({

          })
        }
      }
    })
    require("telescope").load_extension("ui-select")
  end
}
