return {
  {
    "rasulomaroff/reactive.nvim",
    enabled = true,
    keys = {
      {
        "<leader>uM",
        function()
          vim.cmd("ReactiveToggle")
          vim.notify("ReactiveToggle", vim.log.levels.WARN)
        end,
        desc = "Toggle Reactive Cursorlines",
      },
    },
    event = "VeryLazy",
    config = function()
      rgb_tweak = require("util.colors").rgb_tweak
      rgb_tweak_ratio = 0.25
      require("reactive").add_preset({
        name = "my-preset",
        skip = function()
          return vim.api.nvim_buf_get_option(0, "buftype") == ""
        end,
        static = {
          winhl = {
            inactive = {
              CursorLine = { bg = "#202020" },
              CursorLineNr = { fg = "#b0b0b0", bg = "#202020" },
            },
          },
        },
        modes = {
          i = {
            winhl = {
              CursorLine = { bg = rgb_tweak("#42be65", rgb_tweak_ratio) },
              CursorLineNr = { fg = "#42be65", bg = rgb_tweak("#42be65", rgb_tweak_ratio) },
            },
          },
          -- visual
          [{ "v", "V", "\x16" }] = {
            winhl = {
              CursorLineNr = { fg = "#be95ff" },
              Visual = { bg = rgb_tweak("#be95ff", rgb_tweak_ratio) },
            },
          },
          -- replace
          R = {
            winhl = {
              CursorLine = { bg = rgb_tweak("#eaca89", rgb_tweak_ratio) },
              CursorLineNr = { fg = "#eaca89", bg = rgb_tweak("#eaca89", rgb_tweak_ratio) },
            },
          },
        },
      })
    end,
  },
}
