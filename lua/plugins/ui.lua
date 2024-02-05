--[[ Summary
  * nvim-notify
    * set timeout to 0.5s
    * set compact layout
    * set slide animation
    * new keys for listing notify history
]]

local colors = {
  -- bg       = '#202328',
  bg       = '#161616', -- oxocarbon.nvim
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

local mode_color = {
  n = colors.red,
  i = colors.green,
  v = colors.blue,
  [''] = colors.blue,
  V = colors.blue,
  c = colors.magenta,
  no = colors.red,
  s = colors.orange,
  S = colors.orange,
  [''] = colors.orange,
  ic = colors.yellow,
  R = colors.violet,
  Rv = colors.violet,
  cv = colors.red,
  ce = colors.red,
  r = colors.cyan,
  rm = colors.cyan,
  ['r?'] = colors.cyan,
  ['!'] = colors.red,
  t = colors.red,
}

return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        signature = {
          enabled = true,
          auto_open = {
            enabled = false,
            trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
            luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
            throttle = 50, -- Debounce lsp signature help request by 50ms
          },
          view = nil, -- when nil, use defaults from documentation
          ---@type NoiceViewOptions
          opts = {}, -- merged with defaults from documentation
        },
      },
      presets = {
        lsp_doc_border = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    },
  },

  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    -- stylua: ignore
    keys = {
      { "<leader>un", function() require("notify").dismiss({ silent = true, pending = true }) end,
        desc = "Dismiss all Notifications", },
      { "<leader>uN", function() require("telescope").extensions.notify.notify() end,
        desc = "Dispaly all Notification histories", },
    },
    opts = function(_, opts)
      opts.render = "default" or "default" or "minimal" or "simple" or "compact" or "wrapped-compact"
      -- opts.stages = "slide"
      opts.timeout = 500 -- TODO: adjust notify timeout
      opts.max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end
      opts.max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end
    end,
  },

  {
    "nvimdev/dashboard-nvim",
    version = false,
    optional = true,
    opts = function(_, opts)
      local logos = require("util.logos")
      local logo = logos[math.random(#logos)]
      logo = string.rep("\n", 8) .. logo .. "\n\n"
      -- local _util = require("lazyvim.util")
      local use_preview = math.random() < vim.g.dashboard_colorful_banner_chance

      if require("platform").isPlatWindows() then
        use_preview = false
      end

      local preview = {
        command = "cat",
        file_path = vim.fn.stdpath("config") .. "/lua/util/logo_neovim.cat",
        file_height = 10,
        file_width = 70,
      }

      if not use_preview then
        preview = {}
      end
      opts.disable_move = not use_preview
      opts.preview = preview
      opts.config.header = vim.split(logo, "\n")
    end,
  },

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    version = false,
    event = "VeryLazy",
    opts = function()
      local icons = require("util.icons")
      local _util = require("lazyvim.util")

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
          -- component_separators = '',
          -- section_separators = '',
        },
        sections = {
          -- lualine_a = { "mode" },
          lualine_a = {
            {
              -- stylua: ignore
              -- function() return string.upper(vim.fn.mode()) .. icons.mode end,
              function()
                local mode = vim.fn.mode()
                mode_text = icons.mode[mode] or mode
                return mode_text .. ""
                -- vim.notify(require("util.icons").mode[vim.fn.mode()])
              end,
              separator = {left = "", right = ""},
              color = function(section)
                return { fg = mode_color[vim.fn.mode()], bg=colors.bg }
              end,
            },
          },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
              separator = "",
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "", readonly = "󰌾", unnamed = "󰴓" } },
            -- stylua: ignore
            {
              function() return require("nvim-navic").get_location() end,
              cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
            },
          },
          lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = _util.ui.fg("Statement"),
              separator="",
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = _util.ui.fg("Constant"),
              separator="",
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = _util.ui.fg("Debug"),
              separator="",
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = _util.ui.fg("Special"),
              separator="",
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              separator="",
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              local status = require("NeoComposer.ui").status_recording()
              return status == "" and os.date("%R") or status
            end,
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },

  {
    "shellRaining/hlchunk.nvim",
    enabled = true,
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
          enable = true,
          use_treesitter = false,
          style = "#806d9c",
        },

        blank = {
          enable = true,
          chars = { " ", },
          style = { vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"), },
        },
      })
    end,
    keys = {
      { "<leader>uI", function() _G.hlchunkToggle() end, mode = "n",  desc = "Toggle IndentLine" }
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    optional = true,
    enabled = false,
    event = "LazyFile",
    main = "ibl",
    keys = {
      { "<leader>uI", ":IBLToggle<cr>", mode = "n", desc = "Toggle IndentLine" }
    },
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
        vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#542429' })
        vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#594725' })
        vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#20425e' })
        vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#825a34' })
        vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#465e35' })
        vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#5f366b' })
        vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#2e595e' })
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
          char = "󰇝",
          -- char = "󱪼",
          enabled = true,
          show_start = false,
          show_end = false,
          show_exact_scope = false,
          -- highlight = {
          --   "@function"
          -- },
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
            "undotree"
          },
        },
      }
      return opts
    end
  },
}
