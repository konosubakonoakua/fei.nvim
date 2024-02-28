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
    },
    -- stylua: ignore end
  },

  -- https://github.com/pocco81/true-zen.nvim
  {
    "Pocco81/true-zen.nvim",
    enabled = false,
    config = function()
      local api = vim.api

      -- FIXME: true-zen not working well
      -- cannot recover
      api.nvim_set_keymap("n", "<leader>zn", ":TZNarrow<CR>", {})
      api.nvim_set_keymap("v", "<leader>zn", ":'<,'>TZNarrow<CR>", {})
      api.nvim_set_keymap("n", "<leader>zf", ":TZFocus<CR>", {})
      api.nvim_set_keymap("n", "<leader>zm", ":TZMinimalist<CR>", {})
      api.nvim_set_keymap("n", "<leader>za", ":TZAtaraxis<CR>", {})
      -- -- or
      -- local truezen = require('true-zen')
      -- local keymap = vim.keymap
      --
      -- keymap.set('n', '<leader>zn', function()
      --   local first = 0
      --   local last = vim.api.nvim_buf_line_count(0)
      --   truezen.narrow(first, last)
      -- end, { noremap = true })
      -- keymap.set('v', '<leader>zn', function()
      --   local first = vim.fn.line('v')
      --   local last = vim.fn.line('.')
      --   truezen.narrow(first, last)
      -- end, { noremap = true })
      -- keymap.set('n', '<leader>zf', truezen.focus, { noremap = true })
      -- keymap.set('n', '<leader>zm', truezen.minimalist, { noremap = true })
      -- keymap.set('n', '<leader>za', truezen.ataraxis, { noremap = true })
      require("true-zen").setup({

      })
    end,
  },

  -- FIXME: some window remapping not working
  -- windows maximum & restore
  {
    "anuvyklack/windows.nvim",
    enabled = false, -- no need, use zen instead
    dependencies = "anuvyklack/middleclass",
    config = function()
      require("windows").setup()
      -- stylua: ignore start
      vim.keymap.set("n", "<C-w>z",     cmd_concat("WindowsMaximize"),              { desc = "WindowsMaximize" })
      vim.keymap.set("n", "<C-w>_",     cmd_concat("WindowsMaximizeVertically"),    { desc = "WindowsMaximize VER" })
      vim.keymap.set("n", "<C-w>|",     cmd_concat("WindowsMaximizeHorizontally"),  { desc = "WindowsMaximize HOR" })
      vim.keymap.set("n", "<C-w>=",     cmd_concat("WindowsEqualize"),              { desc = "WindowsEqualize" })
      vim.keymap.set("n", "<leader>wa", cmd_concat("WindowsToggleAutowidth"),       { desc = "New windows", remap = true })
      -- stylua: ignore end
    end,
  },

  -- https://github.com/nvim-zh/colorful-winsep.nvim
  {
    "konosubakonoakua/colorful-winsep.nvim",
    config = true,
    enabled = true,
    opts = function (_, opts)
          -- highlight for Window separator
          -- opts.hi = {
          --   bg = "#16161E",
          --   fg = "#1F3442",
          -- }
          -- This plugin will not be activated for filetype in the following table.
          opts.no_exec_files = { "packer", "TelescopePrompt", "mason", "CompetiTest", "NvimTree" }
          -- Symbols for separator lines, the order: horizontal, vertical, top left, top right, bottom left, bottom right.
          -- opts.symbols = { "━", "┃", "┏", "┓", "┗", "┛" }
          opts.symbols = { "━", "┃", "┏", "┓", "┗", "┛" }
          -- Smooth moving switch
          opts.smooth = false -- beter keep false when using neovide
          opts.anchor = {
            left = { height = 1, x = -1, y = -1 },
            right = { height = 1, x = -1, y = 0 },
            up = { width = 0, x = -1, y = 0 },
            bottom = { width = 0, x = 0, y = 0 },
          }
      return opts
    end,
    event = { "WinNew" },
  }
}
