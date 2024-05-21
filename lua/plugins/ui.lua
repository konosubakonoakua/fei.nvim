--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then return ''
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
       return str:sub(1, trunc_len) .. (no_ellipsis and '' or '...')
    end
    return str
  end
end

return {

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
      local logos = require("util.logos")
      local logo = logos[math.random(#logos)]
      logo = string.rep("\n", 8) .. logo .. "\n\n"
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
      local raw_colors = require("util.colors").raw_colors
      local mode_colors = require("util.colors").mode_colors

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
              function()
                local mode = vim.fn.mode()
                mode_text = icons.mode[mode] or mode
                return mode_text
              end,
              separator = {left = "", right = ""},
              color = function(section)
                local hlname = "lualine_c_inactive"
                local hl = vim.api.nvim_get_hl(
                  0, { name = hlname })
                return {
                  fg = mode_colors[vim.fn.mode()],
                  bg = string.format("#%x", hl.bg or 0) or "#00000000",
                  -- gui = "bold"
                }
              end,
              padding = { left = 1, right = 1 }
            },
          },
          lualine_b = {
            {
              'branch',
              icon = {
                icons.lualine.branch.branch_v1,
                align='left',
                -- TODO: change branch icon color according to repo status
                -- color = {
                --   fg = "lualine_b_branch_normal",
                --   gui = "bold",
                -- },
              },
              color = function(section)
                local hlname = "lualine_c_inactive"
                local hl = vim.api.nvim_get_hl(
                  0, { name = hlname })
                return {
                  -- fg = mode_colors[vim.fn.mode()],
                  fg = "#66ffffff",
                  bg = string.format("#%x", hl.bg or 0) or "#00000000",
                  gui = "bold"
                }
              end,
            },
          },
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
            { "filename", path = 4, symbols = {
                modified = icons.lualine.filename.modified,
                readonly = icons.lualine.filename.readonly,
                unnamed = icons.lualine.filename.unnamed,
              }, separator = "",
              fmt = trunc(120, 50, 50, true),
            },
            -- stylua: ignore
            { "aerial", sep = " ", sep_icon = "", depth = 5, dense = false, dense_sep = ".", colored = true, },
            {
              function() return require("nvim-navic").get_location() end,
              cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
              separator = "",
            },
          },
          lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = LazyVim.ui.fg("Statement"),
              separator="",
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = LazyVim.ui.fg("Constant"),
              separator="",
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = LazyVim.ui.fg("Debug"),
              separator="",
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = LazyVim.ui.fg("Special"),
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
            { "encoding", separator = "" },
            {
              function ()
                local cur = vim.fn.line('.')
                local btm = vim.fn.line('$')
                local top = 1
                local icon = "󰟙 "
                if cur == top then
                  return icon .. 'T:'
                elseif cur == btm then
                  return icon .. 'B:'
                else
                  return icon .. string.format('%d:', vim.fn.line('.') / vim.fn.line('$') * 100)
                end
              end,
              separator = "", padding = { left = 0, right = 0 }
            },
            {
              function ()
                local line = vim.fn.line('.')
                local col = vim.fn.virtcol('.')
                return string.format('%d:%d', line, col)
              end, separator = "", padding = { left = 0, right = 0 }
            },
          },
          lualine_z = {
            {
              function()
                local status = require("NeoComposer.ui").status_recording()
                return status == "" and os.date("%R") or status
              end,
              separator = "",
            },
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },

}
