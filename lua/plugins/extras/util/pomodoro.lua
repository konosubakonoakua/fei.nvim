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
    -- See below for full list of options 👇
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

        return "󰄉 " .. tostring(timer)
      end,
    })
    require("lualine").setup({
      sections = {
        lualine_z = lualine_z,
      },
    })

    -- setup telescope
    require("telescope").load_extension("pomodori")
    vim.keymap.set("n", "<leader>xp", function()
      require("telescope").extensions.pomodori.timers()
    end, { desc = "Manage Pomodori Timers" })
  end,
}
