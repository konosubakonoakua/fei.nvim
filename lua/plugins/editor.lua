--[[ Summary
  -- telescope
  -- telescope-fzf-native
  -- zen-mode (not good)
]]

return {
  -- PERF: when using / to search, will aborting early if matched with flash

  -- TODO: config neo-tree
  -- use 'o' as toggle folder open or close
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["<space>"] = "none",
        },
      },
    },
  },

  -- here only using whichkey for reminding
  -- using 'keymap.lua' or other files to register actual keys
  {
    "folke/which-key.nvim",
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["gz"] = {},
        ["gs"] = { name = "+surround" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>l"] = { name = "*TBD*" }, -- TODO: remap <leader>l
        ["<leader>L"] = { name = "*TBD*" }, -- TODO: remap <leader>L
        ["<leader>;"] = { name = "+*TBD*" }, -- TODO: rename <leader>;
      },
    },
  },

  -- change surround mapping to gs
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fP",
        function()
          require("telescope.builtin").find_files(
            { cwd = require("lazy.core.config").options.root }
          )
        end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = function(...)
              return require("telescope.actions").move_selection_next(...)
            end,
            ["<C-k>"] = function(...)
              return require("telescope.actions").move_selection_previous(...)
            end,
            ["<C-p>"] = function(...)
              return require("telescope.actions.layout").toggle_preview(...)
            end,
          },
          n = {
            ["<C-p>"] = function(...)
              return require("telescope.actions.layout").toggle_preview(...)
            end,
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
    end,
  },

  -- add telescope-fzf-native
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },

  -- TODO: rework needed
  -- better to use another one
  -- https://github.com/pocco81/true-zen.nvim
  -- zen-mode
  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    opts = {
      window = {
        width = 0.85, -- width will be 85% of the editor width
      },
    },
    config = true,
    keys = {
      -- add <leader>uz to enter zen mode
      {
        "<leader>uz",
        "<cmd>ZenMode<cr>",
        desc = "Zen Mode",
      },
    },
  },

  -- windows maximum & restore
  {
    "anuvyklack/windows.nvim",
    dependencies = "anuvyklack/middleclass",
    config = function()
      require("windows").setup()
    end,
  },

  -- todo-comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      -- found icons on https://www.nerdfonts.com/cheat-sheet
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󰍦 ", color = "hint", alt = { "INFO" } },
        TEST = { icon = " ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
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
}
