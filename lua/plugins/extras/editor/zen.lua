return {
  {
    "folke/zen-mode.nvim",
    disabled = true,
    version = false,
    cmd = { "ZenMode" },
    opts = {
      window = {
        width = 1.0, -- width will be 85% of the editor width
      },
    },
    config = true,
    -- stylua: ignore start
    keys = {
      -- add <leader>uz to enter zen mode
      { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Zen Mode", },
    },
    -- stylua: ignore end
  },

  -- https://github.com/pocco81/true-zen.nvim
  {
    "Pocco81/true-zen.nvim",
    disabled = false,
    config = function()
      require("true-zen").setup {}
    end,
  },

  -- windows maximum & restore
  {
    "anuvyklack/windows.nvim",
    disabled = true, -- no need, use zen instead
    dependencies = "anuvyklack/middleclass",
    config = function()
      require("windows").setup()
    end,
  },
}
