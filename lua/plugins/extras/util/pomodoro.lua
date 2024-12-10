local emoji = require("util.icons").emoji

return {
  desc = "A simple, customizable pomodoro timer",
  "epwalsh/pomo.nvim",
  version = "*", -- Recommended, use latest release instead of latest commit
  lazy = true,
  cmd = { "TimerStart", "TimerRepeat" },
  dependencies = {
    -- Optional, but highly recommended if you want to use the "Default" timer
    "rcarriga/nvim-notify",
  },
  opts = {
    notifiers = {
      {
        name = "Default",
        opts = {
          sticky = false,
          title_icon = emoji.tomato,
          text_icon = "",
        },
      },

      -- The "System" notifier sends a system notification when the timer is finished.
      -- Available on MacOS natively and Linux via the `libnotify-bin` package.
      -- Tracking: https://github.com/epwalsh/pomo.nvim/issues/3
      -- { name = "System" },

      -- You can also define custom notifiers by providing an "init" function instead of a name.
      -- See "Defining custom notifiers" below for an example 👇
      -- { init = function(timer) ... end }
    },
  },
  config = function(_, opts)

    -- setup pomo
    require("pomo").setup(opts)

    -- setup lualine
    local lualine_z = require("lualine").get_config().sections.lualine_z or {}
    table.insert(lualine_z, {
      function()
        local ok, pomo = pcall(require, "pomo")
        if not ok then
          return ""
        end

        local timer = pomo.get_first_to_finish()
        if timer == nil then
          return ""
        end

        return emoji.tomato .. " " .. tostring(timer)
      end,
    })
    require("lualine").setup({
      sections = {
        lualine_z = lualine_z,
      },
    })

    -- setup telescope
    if require("util.picker").has_telescope() then
      require("telescope").load_extension("pomodori")
      vim.keymap.set("n", "<leader>xp", function()
        require("telescope").extensions.pomodori.timers()
      end, { desc = "Manage Pomodori Timers" })
    end
  end,
}
