--[[ Summary
  -- telescope
  -- telescope-fzf-native
  -- zen-mode (not good)
]]

local _util = require("lazyvim.util")

return {
  -- PERF: when using / to search, will aborting early if matched with flash

  -- TODO: config neo-tree
  -- use 'o' as toggle folder open or close
  {
    "nvim-neo-tree/neo-tree.nvim",
    config = function(_, opts)
      if vim.fn.executable("fd") == 1 then
        opts.filesystem.find_command = "fd"
        opts.filesystem.find_args = {
          fd = {
            "--exclude",
            ".git",
            "--exclude",
            "node_modules",
          },
        }
      end
      opts.filesystem.filtered_items = {
        visible = false, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        hide_by_name = {
          "node_modules",
        },
        hide_by_pattern = { -- uses glob style patterns
          --"*.meta",
          --"*/src/*/tsconfig.json",
        },
        always_show = { -- remains visible even if other settings would normally hide it
          --".gitignored",
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          ".DS_Store",
          "thumbs.db",
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      }
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        hint = "floating-big-letter",
      })
    end,
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
        ["<leader>;"] = { name = "+utils" },
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

  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  { "RRethy/vim-illuminate", enabled = false },
  {
    -- TODO: wait for PR to be merged
    -- "RRethy/vim-illuminate",
    "konosubakonoakua/vim-illuminate",
    name = "vim-illuminate-akua", -- INFO: if plugins have same name, rename both
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      under_cursor = true,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp", "treesitter", "regex" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {},
    opts = {
      defaults = {
        -- stylua: ignore start
        mappings = {
          i = {
            ["<C-j>"] = function(...) return require("telescope.actions").move_selection_next(...) end,
            ["<C-k>"] = function(...) return require("telescope.actions").move_selection_previous(...) end,
            ["<C-p>"] = function(...) return require("telescope.actions.layout").toggle_preview(...) end,
          },
          n = { ["<C-p>"] = function(...) return require("telescope.actions.layout").toggle_preview(...) end,
          },
        },
        -- stylua: ignore end
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      require("telescope").load_extension("macros")
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

  -- {
  --   "nvim-telescope/telescope-file-browser.nvim",
  --   dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  --   init = function()
  --     local fb_actions = require("telescope._extensions.file_browser.actions")
  --     require("telescope").setup({
  --       extensions = {
  --         file_browser = {
  --           cwd_to_path = false,
  --           grouped = true,
  --           files = true,
  --           add_dirs = true,
  --           depth = 1,
  --           auto_depth = false,
  --           select_buffer = false,
  --           hidden = { file_browser = false, folder_browser = false },
  --           hide_parent_dir = false,
  --           collapse_dirs = false,
  --           prompt_path = true,
  --           quiet = false,
  --           dir_icon = "",
  --           dir_icon_hl = "Default",
  --           display_stat = { date = true, size = true, mode = true },
  --           hijack_netrw = false,
  --           use_fd = true,
  --           git_status = false,
  --           mappings = {
  --             ["i"] = {
  --               ["<A-c>"] = fb_actions.create,
  --               ["<S-CR>"] = fb_actions.create_from_prompt,
  --               ["<A-r>"] = fb_actions.rename,
  --               ["<A-m>"] = fb_actions.move,
  --               ["<A-y>"] = fb_actions.copy,
  --               ["<A-d>"] = fb_actions.remove,
  --               ["<C-o>"] = fb_actions.open,
  --               ["<C-g>"] = fb_actions.goto_parent_dir,
  --               ["<C-e>"] = fb_actions.goto_home_dir,
  --               ["<C-w>"] = fb_actions.goto_cwd,
  --               ["<C-t>"] = fb_actions.change_cwd,
  --               ["<C-f>"] = fb_actions.toggle_browser,
  --               ["<C-h>"] = fb_actions.toggle_hidden,
  --               ["<C-s>"] = fb_actions.toggle_all,
  --               ["<bs>"] = fb_actions.backspace,
  --             },
  --             ["n"] = {
  --               ["c"] = fb_actions.create,
  --               ["r"] = fb_actions.rename,
  --               ["m"] = fb_actions.move,
  --               ["y"] = fb_actions.copy,
  --               ["d"] = fb_actions.remove,
  --               ["o"] = fb_actions.open,
  --               ["g"] = fb_actions.goto_parent_dir,
  --               ["e"] = fb_actions.goto_home_dir,
  --               ["w"] = fb_actions.goto_cwd,
  --               ["t"] = fb_actions.change_cwd,
  --               ["f"] = fb_actions.toggle_browser,
  --               ["h"] = fb_actions.toggle_hidden,
  --               ["s"] = fb_actions.toggle_all,
  --             },
  --           },
  --         },
  --       },
  --     })
  --     require("telescope").load_extension("file_browser")
  --   end,
  -- },

  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    init = function()
      local lga_actions = require("telescope-live-grep-args.actions")
      require("telescope").setup({
        extensions = {
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            --          -- FIXME: lvie grep-args keymap not working
            mappings = { -- extend mappings
              i = {
                ["<A-k>"] = lga_actions.quote_prompt(),
                ["<A-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
            -- ... also accepts theme settings, for example:
            -- theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            -- layout_config = { mirror=true }, -- mirror preview pane
          },
        },
      })
      require("telescope").load_extension("live_grep_args")
    end,
  },
  -- INFO: yanky on windows put sqlite to disabled, so force enable here
  { "kkharji/sqlite.lua", enabled = true },
  {
    "ecthelionvi/NeoComposer.nvim",
    opts = {
      notify = false,
      delay_timer = 0,
      queue_most_recent = false,
      window = {
        border = "rounded",
        winhl = {
          Normal = "ComposerNormal",
        },
      },
      colors = {
        bg = "#16161e",
        fg = "#ff9e64",
        red = "#ec5f67",
        blue = "#5fb3b3",
        green = "#99c794",
      },
      keymaps = {
        play_macro = "Q",
        yank_macro = "yq",
        stop_macro = "cq",
        toggle_record = "q",
        cycle_next = "<c-n>",
        cycle_prev = "<c-p>",
        toggle_macro_menu = "<m-q>",
      },
    },
    init = function()
      require("telescope").load_extension("macros")
    end,
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
    -- stylua: ignore start
    keys = {
      -- add <leader>uz to enter zen mode
      { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Zen Mode", },
    },
    -- stylua: ignore end
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

  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {},
  },

  -- markdown preview
  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow",
    keys = {},
    init = function()
      require("glow").setup({
        -- glow_path = "", -- will be filled automatically with your glow bin in $PATH, if any
        -- install_path = "~/.local/bin", -- default path for installing glow binary
        border = "shadow", -- floating window border config
        style = "dark", -- filled automatically with your current editor background, you can override using glow json style
        pager = false,
        width = 80,
        height = 100,
        width_ratio = 0.7, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
        height_ratio = 0.7,
      })
    end,
  },
}
