return {
  {
    'nmac427/guess-indent.nvim',
    lazy = true,
    keys = {},
    event = { "BufEnter" },
    opts = {
      auto_cmd = true,  -- Set to false to disable automatic execution
      override_editorconfig = false, -- Set to true to override settings set by .editorconfig
      filetype_exclude = {  -- A list of filetypes for which the auto command gets disabled
        "netrw",
        "tutor",
      },
      buftype_exclude = {  -- A list of buffer types for which the auto command gets disabled
        "help",
        "nofile",
        "terminal",
        "prompt",
      },
    },
  },

  -- PERF: hlchunk has very bad performance
  {
    "shellRaining/hlchunk.nvim",
    enabled = false,
    event = { "UIEnter" },
    config = function()
      _G.hlchunk_enabled = true
      _G.hlchunkToggle = function ()
        if _G.hlchunk_enabled == true then
          vim.cmd([[DisableHL]])
          _G.hlchunk_enabled = false
        else
          vim.cmd([[EnableHL]])
          _G.hlchunk_enabled = true
        end
      end
      local ft = require("hlchunk.utils.filetype")
      local ft_user = {
        supported = {
          "*.zig",
        },
        excluded = {
          glowpreview = true,
          dapui_scope = true,
          dapui_stacks = true,
          dapui_watches = true,
          dapui_console = true,
          dapui_breakpoints = true,
          lazyterm = true,
          ["neo-tree-popup"] = true,
          ["neo-tree"] = true,
        }
      }
      ft_user.supported = vim.list_extend(ft.support_filetypes, ft_user.supported)
      ft_user.excluded = vim.tbl_extend("force", ft.exclude_filetypes, ft_user.excluded)
      require("hlchunk").setup({
        chunk = {
          enable = true,
          notify = true,
          use_treesitter = true,
          -- details about support_filetypes and exclude_filetypes in https://github.com/shellRaining/hlchunk.nvim/blob/main/lua/hlchunk/utils/filetype.lua
          support_filetypes = ft_user.supported,
          exclude_filetypes = ft_user.excluded,
          chars = {
            horizontal_line = "─",
            vertical_line = "┊", --│
            left_top = "╭",
            left_bottom = "╰",
            right_arrow = "─", --▸
          },
          style = {
            { fg = "#806d9c" },
            { fg = "#c21f30" }, -- this fg is used to highlight wrong chunk
          },
          textobject = "",
          max_file_size = 1024 * 1024,
          error_sign = true,
        },

        indent = {
          enable = true,
          use_treesitter = true,
          chars = {
            -- "│",
            "¦",
            -- "┆",
            -- "┊",
          },
          style = {
            '#542429',
            '#594725',
            '#20425e',
            '#825a34',
            '#465e35',
            '#5f366b',
            '#2e595e',
            -- "#FF0000",
            -- "#FF7F00",
            -- "#FFFF00",
            -- "#00FF00",
            -- "#00FFFF",
            -- "#0000FF",
            -- "#8B00FF",
          },
        },

        line_num = {
          enable = false,
          use_treesitter = true,
          style = "#806d9c",
        },

        blank = {
          enable = false,
          chars = { " ", },
          style = { vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"), },
        },
      })
    end,
    keys = {
      { "<leader>uI", function() _G.hlchunkToggle() end, mode = "n",  desc = "Toggle IndentLine" }
    },
  },

  -- PERF: use cool-chunk instead of hlchunk, still has performance issue
  {
    "Mr-LLLLL/cool-chunk.nvim",
    enabled = false,
    event = { "CursorHold", "CursorHoldI" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local ft = require("cool-chunk.utils.filetype").support_filetypes
      require("cool-chunk").setup({
        chunk = {
          notify = true,
          support_filetypes = ft.support_filetypes,
          exclude_filetypes = ft.exclude_filetypes,
          hl_group = {
            chunk = "CursorLineNr",
            error = "Error",
          },
          chars = {
            horizontal_line = "─",
            vertical_line = "┊",
            left_top = "╭",
            left_bottom = "╰",
            left_arrow = "",
            bottom_arrow = "",
            right_arrow = "─",
          },
          textobject = "ah",
          animate_duration = 50,
          fire_event = { "CursorHold", "CursorHoldI" },
        },
        context = {
          notify = true,
          chars = {
            "│",
          },
          hl_group = {
            context = "LineNr",
          },
          exclude_filetypes = ft.exclude_filetypes,
          support_filetypes = ft.support_filetypes,
          textobject = "ih",
          jump_support_filetypes = { "lua", "python" },
          jump_start = "[{",
          jump_end = "]}",
          fire_event = { "CursorHold", "CursorHoldI" },
        },
        line_num = {
          notify = false,
          hl_group = {
            chunk = "CursorLineNr",
            context = "LineNr",
            error = "Error",
          },
          support_filetypes = ft.support_filetypes,
          exclude_filetypes = ft.exclude_filetypes,
          fire_event = { "CursorHold", "CursorHoldI" },
        }
      })
    end
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    optional = true,
    enabled = true,
    event = "LazyFile",
    main = "ibl",
    -- dev = true,
    opts = function (_, opts)
      local rainbow_highlights = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
      }

      local hooks = require('ibl.hooks')
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowRed',    { fg = '#542429' })
        vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#594725' })
        vim.api.nvim_set_hl(0, 'RainbowBlue',   { fg = '#20425e' })
        vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#825a34' })
        vim.api.nvim_set_hl(0, 'RainbowGreen',  { fg = '#465e35' })
        vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#5f366b' })
        vim.api.nvim_set_hl(0, 'RainbowCyan',   { fg = '#2e595e' })
        vim.api.nvim_set_hl(0, 'PinkIBLScope',  { fg = '#262626', bg = '#ff7eb6' })
      end)

      opts = {
        indent = {
          char = "┊",
          tab_char = "┊",
          smart_indent_cap = true,
          highlight = rainbow_highlights,
        },
        whitespace = {
          remove_blankline_trail = true,
        },
        scope = {
          -- TODO: ask at github whether the scope char cusomization supported 
          char = { "|" },
          enabled = true,
          show_start = false,
          show_end = false,
          show_exact_scope = false,
          injected_languages = true,
          highlight = {
            "@function",
            -- "PinkIBLScope",
          },
          exclude = {
            -- language = { "rust" },
            -- node_type = { lua = { "block", "chunk" } },
          },
          include = {
            node_type = {
              -- ["*"] = { "*" }, -- enabled all
              lua = {
                "return_statement",
                "table_constructor",
              },
            },
          },
        },
        exclude = {
          buftypes = {
            "terminal",
            "nofile",
            "quickfix",
            "prompt",
          },
          filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
            "log",
            "TelescopePrompt",
            "TelescopeResults",
            "terminal",
            "undotree",
            "snacks_terminal"
          },
        },
      }

      return opts
    end
  },
}
