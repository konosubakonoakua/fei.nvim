--[[ Summary
  * nvim-notify
    * set timeout to 4s
    * set compact layout
    * set slide animation
    * new keys for listing notify history
]]

return {
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
    opts = {
      render = "compact",
      stages = "slide",
      timeout = 2000, -- TODO: adjust notify timeout
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },

  {
    "nvimdev/dashboard-nvim",
    opts = function()
      local logos = require("util.logos")
      local logo = logos[math.random(#logos)]

      logo = string.rep("\n", 8) .. logo .. "\n\n"
      -- local _util = require("lazyvim.util")

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
      -- stylua: ignore
      center = {
        { action = "Telescope find_files",              desc = " Find file",       icon = " ", key = "f" },
        { action = "ene | startinsert",                 desc = " New file",        icon = " ", key = "n" },
        { action = "Telescope oldfiles",                desc = " Recent files",    icon = " ", key = "r" },
        { action = "Telescope live_grep",               desc = " Find text",       icon = " ", key = "g" },
        { action = "e $MYVIMRC",                        desc = " Config",          icon = " ", key = "c" },
        { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
        { action = "LazyExtras",                        desc = " Lazy Extras",     icon = " ", key = "e" },
        { action = "Lazy",                              desc = " Lazy",            icon = "󰒲 ", key = "l" },
        { action = "qa",                                desc = " Quit",            icon = " ", key = "q" },
      },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      return opts
    end,
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = require("util.icons")
      local _util = require("lazyvim.util")

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },
        sections = {
          -- lualine_a = { "mode" },
          lualine_a = {
            -- fffstylua: ignore
            -- function() return string.upper(vim.fn.mode()) .. icons.mode end,
            function()
              local mode = vim.fn.mode()
              return icons.mode[mode] or mode
              -- vim.notify(require("util.icons").mode[vim.fn.mode()])
            end,
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
            },
            -- -- stylua: ignore
            -- {
            --   function() return require("noice").api.status.mode.get() end,
            --   cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            --   color = _util.fg("Constant"),
            -- },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = _util.ui.fg("Debug"),
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = _util.ui.fg("Special"),
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
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
}
