local icons = require("util.icons").todo

return {

  -- todo-comments
  -- TODO: ###
  -- FIX: ###
  -- HACK: ###
  -- WARN: ###
  -- PERF: ###
  -- NOTE: ###
  -- TEST: ###
  {
    "folke/todo-comments.nvim",
    version = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    -- LazyVim passes `opts = {}`, so everything below is diffed against the
    -- plugin's own defaults: only keep what actually differs from them.
    opts = {
      keywords = {
        FIX = { icon = icons.bug, color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = icons.todo, color = "info" },
        HACK = { icon = icons.hack, color = "#F86F03" },
        WARN = { icon = icons.warn, color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = icons.perf, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = icons.note, color = "hint", alt = { "INFO" } },
        TEST = { icon = icons.test, color = "#2CD3E1", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      colors = {
        -- pin the colors instead of following the colorscheme's diagnostic groups
        error = { "#DC2626" },
        warning = { "#FBBF24" },
        info = { "#2563EB" },
        hint = { "#10B981" },
        default = { "#7C3AED" },
        test = { "#FF00FF" },
      },
    },
  },

  -- noice
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      }
      opts.lsp = {
        progress = {
          enabled = true,
          -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
          -- See the section on formatting for more details on how to customize.
          --- @type NoiceFormat|string
          format = "lsp_progress",
          --- @type NoiceFormat|string
          format_done = "lsp_progress_done",
          throttle = 1000 / 100, -- frequency to update lsp progress message
          view = "mini",
        },
        hover = {
          silent = true, -- set to true to not show a message if hover is not available
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
            luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
            throttle = 50, -- Debounce lsp signature help request by 50ms
          },
          ---@type NoiceViewOptions
          opts = {
            size = {
              max_height = 10, -- limit the lsp signature help hover size
            },
          }, -- merged with defaults from documentation
        },
      }
      opts.views = {
        mini = {
          timeout = 300,
          zindex = 20,
          win_options = {
            -- winbar = "",
            -- foldenable = false,
            winblend = 60,
          },
        },
      }
      return opts
    end,
  },

  {
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          -- https://github.com/folke/flash.nvim/issues/310
          enabled = false, -- BUG: not working with macro
          multi_line = false,
        },
        treesitter = {
          label = {
            rainbow = { enabled = true },
          },
        },
        -- TODO: map keys for flash.nvim treesitter_search
        treesitter_search = {
          label = {
            rainbow = { enabled = true },
          },
        },
      },
      -- search = { mode = "fuzzy" },
    },
  },

  {
    "gbprod/yanky.nvim",
    event = { "LazyFile", "VimEnter" },
  },
}
