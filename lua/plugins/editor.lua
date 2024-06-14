-- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes
-- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Visual-Customizations
--
-- Network
-- https://github.com/miversen33/netman.nvim#neo-tree
--
-- How to get the current path of a neo-tree buffer
-- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/319
--
--
local icons = require("util.stuffs.icons").todo
local neotree_mappings_filesystem = require("plugins.util.neotree").filesystem_window_mappings
local neotree_mappings_window = require("plugins.util.neotree").window_mappings
local neotree_mappings_documnet_symbols = require("plugins.util.neotree").document_symbols_window_mappings

return {

  -- TODO: config neo-tree
  -- when neo-tree win lost focus,
  -- dont redraw on large folder with many opend dir
  --
  { -- "konosubakonoakua/neo-tree.nvim",
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = {
      use_popups_for_input = false,
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        window = {
          mappings = neotree_mappings_filesystem,
        },
      },
      document_symbols = {
        follow_cursor = true,
        window = {
          mappings = neotree_mappings_documnet_symbols,
        },
      },
      window = {
        mappings = neotree_mappings_window,
      },
    },
  },

  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      -- PERF: default is "smart", performance killer
      opts.defaults.path_display = { "absolute" }
      opts.defaults.layout_config = {
        width = 999,
        height = 999,
        -- vertical = { width = 1.0, height = 1.0 }
      }
      return opts
    end,
  },

  { "junegunn/fzf", build = "./install --bin" },

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
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      -- found icons on https://www.nerdfonts.com/cheat-sheet
      keywords = {
        FIX = { icon = icons.bug, color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = icons.todo, color = "info" },
        HACK = { icon = icons.hack, color = "#F86F03" },
        WARN = { icon = icons.warn, color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = icons.perf, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = icons.note, color = "hint", alt = { "INFO" } },
        TEST = { icon = icons.test, color = "#2CD3E1", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      gui_style = {
        fg = "NONE", -- The gui style to use for the fg highlight group.
        bg = "BOLD", -- The gui style to use for the bg highlight group.
      },
      merge_keywords = true, -- when true, custom keywords will be merged with the defaults
      -- highlighting of the line containing the todo comment
      -- * before: highlights before the keyword (typically comment characters)
      -- * keyword: highlights of the keyword
      -- * after: highlights after the keyword (todo text)
      highlight = {
        multiline = true, -- enable multine todo comments
        multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
        before = "", -- "fg" or "bg" or empty
        keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      -- list of named colors where we try to extract the guifg from the
      -- list of highlight groups or use the hex color if hl not found as a fallback
      colors = {
        -- error   = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        -- warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        -- info    = { "DiagnosticInfo", "#2563EB" },
        -- hint    = { "DiagnosticHint", "#10B981" },
        -- default = { "Identifier", "#7C3AED" },
        -- test    = { "Identifier", "#FF00FF" }
        error = { "#DC2626" },
        warning = { "#FBBF24" },
        info = { "#2563EB" },
        hint = { "#10B981" },
        default = { "#7C3AED" },
        test = { "#FF00FF" },
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
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
}
