local _util       = require("lazyvim.util")
local keymap      = vim.keymap.set
local _floatterm  = _util.terminal.open

-- Glow Keymap
-- TODO: disable ctrl_hjkl & fix quit by q
if vim.fn.executable("glow") == 1 then
  -- FIXME: glow wont enter TUI with file path
  -- https://github.com/charmbracelet/glow/issues/489
  -- { "glow", tostring(vim.fn.expand("%:p"))},
  keymap("n", "<leader>;G", function ()
    -- vim.notify("open glow at " .. tostring(vim.fn.expand("%:p:h")))
    _floatterm(
    { "glow" }, { cwd = tostring(vim.fn.expand("%:p:h")), ctrl_hjkl = false }) end,
    { desc = "!Glow" })
  keymap("n", "<leader>;g", "<cmd>Glow<cr>", { desc = "Preview Markdown" })
end

-- markdown preview
-- TODO: adjust markdown preview size
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
