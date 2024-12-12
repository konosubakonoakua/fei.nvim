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

  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    opts = function(_, opts)
      opts.render = "default" or "default" or "minimal" or "simple" or "compact" or "wrapped-compact"
      opts.stages = "slide"
      opts.timeout = 800 -- TODO: adjust notify timeout
      opts.max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end
      opts.max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end
      opts.background_colour = "#000000"
    end,
  },

  -- dashboard
  {
    "nvimdev/dashboard-nvim",
    version = false,
    optional = true,
    opts = function(_, opts)
      local logo = require('util').logorandom()
      logo = string.rep("\n", 8) .. logo .. "\n\n"
      -- local use_preview = math.random() < vim.g.dashboard_colorful_banner_chance
      local use_preview = false

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

  {
    "folke/snacks.nvim",
    optional = true,
    priority = 1000,
    lazy = false,
    keys = {
      { "<leader>wu",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<leader>wU",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    },
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
      dim = {
        animate = {
          enabled = false,
        },
      },
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
      quickfile = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          wo = { wrap = true } -- Wrap notifications
        }
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

      opts.options.component_separators = { left = "", right = "" }
      opts.options.section_separators = { left = "", right = "" }
      opts.options.disabled_filetypes = {
        statusline = { "dashboard" },
        winbar = {},
      }

      -- NOTE: '#' operator only use indexed key table.
      -- t[#t+1] won't work here
      table.remove(opts.sections.lualine_a, 1) -- vim mode
      table.insert(opts.sections.lualine_a, {
        "mode",
        fmt = function(str)
          return str:sub(1, 1)
        end,
      })

      -- TODO: customize lualine branch icon and color
      -- MiniGit for obtaining status
      table.remove(opts.sections.lualine_b, 1) -- branch
      table.insert(opts.sections.lualine_b, {
        "branch",
        icon = { icons.lualine.branch.branch_v1, align = "left" },
      })


      -- stylua: ignore
      table.insert(
        opts.sections.lualine_c, -- move diff to lualine_c
        1, -- before lazyroot
        table.remove(opts.sections.lualine_x, #opts.sections.lualine_x)
      )
      -- table.insert(opts.sections.lualine_c, 3, table.remove(opts.sections.lualine_c, 2))
      table.insert(
        opts.sections.lualine_c,
        3,
        vim.tbl_extend("force", table.remove(opts.sections.lualine_c, 3), {
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        })
      )
      table.remove(opts.sections.lualine_c, #opts.sections.lualine_c) -- remove lsp symbol
      table.insert(opts.sections.lualine_c, { -- add encoding
        function()
          local enc = vim.opt.fileencoding:get()
          return (enc ~= nil and ("[" .. enc .. "]")) or ""
        end,
        seperator = "",
        padding = { left = 0, right = 0 },
      })

      -- BUG: noice lualine
      -- remove all noice component since not working
      for i = 1, #opts.sections.lualine_x, 1 do
        table.remove(opts.sections.lualine_x, i)
      end

      table.remove(opts.sections.lualine_y, 2) -- location
      table.remove(opts.sections.lualine_y, 1) -- progress
      local lualine_y = {
        {
          function()
            local icon = " 󰡪 "
            local line = vim.fn.line(".")
            local col = vim.fn.virtcol(".")
            return icon .. string.format("%d:%d", line, col)
          end,
          separator = "",
          padding = { left = 0, right = 0 },
        },
        {
          function()
            local cur = vim.fn.line(".")
            local btm = vim.fn.line("$")
            local top = 1
            local prefix = " 󰸻 "
            local suffix = ""
            if cur == top then
              return prefix .. "TOP" .. suffix
            elseif cur == btm then
              return prefix .. "BTM" .. suffix
            else
              return prefix .. string.format("%d", vim.fn.line(".") / vim.fn.line("$") * 100) .. suffix
            end
          end,
          separator = "",
          padding = { left = 0, right = 0 },
        },
        { -- os
          function()
            return icons.lualine.fileformat[vim.bo.ff]
          end,
          separator = "",
          -- padding = { left = 0, right = 0 },
        },
      }
      for _, x in pairs(lualine_y) do
        table.insert(opts.sections.lualine_y, x)
      end

      table.remove(opts.sections.lualine_z, 1) -- recording & time
      local res, Util = pcall(require, "util")
      -- stylua: ignore
      local lualine_z_record_component =
        res == true and Util.lualine_setup_recording_status() or function() return "" end
      local lualine_z = {
        {
          lualine_z_record_component,
          separator = "",
        },
      }
      for _, x in pairs(lualine_z) do
        table.insert(opts.sections.lualine_z, x)
      end

      return opts
    end,
  },
}
