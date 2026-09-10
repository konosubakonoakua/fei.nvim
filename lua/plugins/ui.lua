return {

  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = "slope",
        custom_areas = {
        },
      },
    },
  },

  {
    "folke/snacks.nvim",
    optional = true,
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      animate = {
        duration = 0,
      },
      bigfile = { enabled = true },
      dashboard = {
        preset = {
          header = require('util').logorandom(),
        },
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
      explorer = { enabled = true },
      indent = {
        enabled = true,
        scope = {
          animate = {
            enabled = false,
          },
        },
      },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          -- wo = { wrap = true } -- Wrap notifications
        }
      },
      terminal = {
        win = {
          keys = {
            nav_h = false,
            nav_j = false,
            nav_k = false,
            nav_l = false,
          },
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    version = false,
    event = "VeryLazy",
    opts = function(_, opts)
      local icons = require("util.icons")
      local ok, Statusline = pcall(require, "util.statusline")

      opts.options.component_separators = { left = "", right = "" }
      opts.options.section_separators = { left = "", right = "" }
      opts.options.disabled_filetypes = {
        statusline = { "dashboard" },
        winbar = {},
      }

      -- LazyVim's default lualine_x layout is:
      --   [ profiler, <noice command/mode...>, dap, lazy-updates, diff ]
      -- Reuse the components we keep instead of mutating the tables by index
      -- (the old version relied on hard-coded positions and silently dropped
      -- the file path / only removed half the noice entries).
      local x = opts.sections.lualine_x
      local profiler = x[1]
      local dap = x[#x - 2]
      local lazy_updates = x[#x - 1]
      local git_diff = x[#x]

      opts.sections.lualine_a = {
        { "mode", fmt = function(str) return str:sub(1, 1) end },
      }
      opts.sections.lualine_b = {
        { "branch", icon = { icons.lualine.branch.branch_v1, align = "left" } },
      }
      opts.sections.lualine_c = {
        git_diff,
        LazyVim.lualine.root_dir(),
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { LazyVim.lualine.pretty_path() },
        { -- file encoding
          function()
            local enc = vim.opt.fileencoding:get()
            return (enc ~= nil and ("[" .. enc .. "]")) or ""
          end,
          separator = "",
          padding = { left = 0, right = 0 },
        },
      }

      -- Right cluster: keep profiler / debugger / pending updates, drop noice.
      opts.sections.lualine_x = { profiler, dap, lazy_updates }

      opts.sections.lualine_y = {
        { -- cursor position
          function() return " 󰡪 " .. string.format("%d:%d", vim.fn.line("."), vim.fn.virtcol(".")) end,
          separator = "",
          padding = { left = 0, right = 0 },
        },
        { -- scroll position
          function()
            local cur, top, bottom = vim.fn.line("."), 1, vim.fn.line("$")
            if cur == top then
              return " 󰸻 TOP"
            elseif cur == bottom then
              return " 󰸻 BTM"
            end
            return " 󰸻 " .. string.format("%d", cur / bottom * 100)
          end,
          separator = "",
          padding = { left = 0, right = 0 },
        },
        { -- file format
          function() return icons.lualine.fileformat[vim.bo.ff] end,
          separator = "",
        },
      }
      opts.sections.lualine_z = {
        { ok and Statusline.recording_status() or function() return "" end, separator = "" },
      }

      return opts
    end,
  },
}
