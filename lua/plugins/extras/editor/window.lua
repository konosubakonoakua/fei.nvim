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
    -- NOTE: useful when debugging
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    keys = {
      {
        "<leader>wp",
        function()
          -- local _, tsc = pcall(require, "treesitter-context")
          -- pcall(function () tsc.disable() end)

          local selected_window = require("window-picker").pick_window()

          -- stylua: ignore
          if selected_window ~= nil
            and vim.api.nvim_win_is_valid(selected_window)
            -- and vim.api.nvim_win_get_height(selected_window) > 3
          then
            vim.api.nvim_set_current_win(selected_window)
          end

          -- pcall(function () tsc.enable() end)
        end,
        desc = "Window Picker",
      },
    },
    config = function()
      require("window-picker").setup({
        show_prompt = false,
        include_current = false,
        hint = "floating-big-letter",
        filter_rules = {
          include_current_win = false,
          autoselect_one = false,
          bo = { -- ignore
            filetype = {
              "neo-tree",
              "neo-tree-popup",
              "notify",
              "edgy",
              "noice",
              "NvimSeparator", -- "s1n7ax/nvim-window-picker"
            },
            buftype = { "terminal", "quickfix" },
          },
        },
        -- NOTE: find treesitter-context window too, need to exlude by filter, see below
        -- https://github.com/s1n7ax/nvim-window-picker/issues/67
        filter_func = function(windows, rules)
          local function predicate(wid)
            cfg = vim.api.nvim_win_get_config(wid)
            if not cfg.focusable then
              return false
            end
            return true
          end
          local filtered = vim.tbl_filter(predicate, windows)

          local dfilter = require("window-picker.filters.default-window-filter"):new()
          dfilter:set_config(rules)
          return dfilter:filter_windows(filtered)
        end,
        border = { style = "rounded", highlight = "Normal" },
      })
    end,
  },

  {
    "folke/edgy.nvim",
    optional = true,
    event = "VeryLazy",
    opts = {
      animate = { enabled = false },
      icons = { -- disable icons
        closed = "",
        open = "",
      }
    },
  },
}
