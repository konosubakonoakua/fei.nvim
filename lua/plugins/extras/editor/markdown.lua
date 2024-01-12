-- markdown preview
return {
{
  "ellisonleao/glow.nvim",
  version = false,
  config = true,
  cmd = "Glow",
  keys = {},
  init = function()
    require("glow").setup({
      -- glow_path = "", -- will be filled automatically with your glow bin in $PATH, if any
      install_path = "~/.local/bin", -- default path for installing glow binary
      border = "shadow", -- floating window border config
      -- pager = "bat",
      style = "dark", -- filled automatically with your current editor background, you can override using glow json style
      width = vim.api.nvim_win_get_width(0),
      height = vim.api.nvim_win_get_height(0),
      height_ratio = 1,
      width_ratio = 1, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
    })
  end,
  },
}
