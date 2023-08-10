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
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
      {
        "<leader>uN",
        function()
          require("telescope").extensions.notify.notify()
        end,
        desc = "Dispaly all Notification histories",
      },
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

  -- Dashboard. This runs when neovim starts, and is what displays
  -- the "LAZYVIM" banner.
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
                                 __
    ___     ___    ___   __  __ /\_\    ___ ___
   / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\
  /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \
  \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\
   \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/
      ]]
      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", "󱇧 " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "󱋡 " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", "󱘢 " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("l", "󰤄 " .. " Lazy", ":Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
  },
}
