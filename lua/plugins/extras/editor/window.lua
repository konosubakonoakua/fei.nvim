return {
  {
    "folke/zen-mode.nvim",
    enabled = true,
    version = false,
    lazy = true,
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
      { "<C-w>u", "<cmd>ZenMode<cr>", desc = "Zen Mode", },
    },
    -- stylua: ignore end
  },

  -- https://github.com/nvim-zh/colorful-winsep.nvim
  {
    -- "konosubakonoakua/colorful-winsep.nvim",
    "nvim-zh/colorful-winsep.nvim",
    enabled = true,
    config = true,
    event = { "WinNew" },
    opts = function(_, opts)
      opts.no_exec_files = {
        "packer",
        "TelescopePrompt",
        "mason",
        "CompetiTest",
        "NvimTree",
        "edgy",
        "neo-tree",
        "neo-tree-popup",
        "notify",
      }
      -- horizontal, vertical, top left, top right, bottom left, bottom right.
      opts.symbols = { "━", "┃", "┏", "┓", "┗", "┛" }
      opts.smooth = false -- beter keep false when using neovide
      return opts
    end,
  },

  {
    config = function()
    end,
  },

  {
    "folke/edgy.nvim",
    optional = true,
    event = "VeryLazy",
    opts = {
      animate = { enabled = false },
    },
  },
}
