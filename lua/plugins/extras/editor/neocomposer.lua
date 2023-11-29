return {
  -- INFO: yanky on windows put sqlite to disabled, so force enable here
  { "kkharji/sqlite.lua", enabled = true },
  {
    "ecthelionvi/NeoComposer.nvim",
    version = false,
    opts = {
      notify = false,
      delay_timer = 0,
      queue_most_recent = true,
      window = {
        border = "rounded",
        winhl = {
          Normal = "ComposerNormal",
        },
      },
      colors = {
        bg = "#16161e",
        fg = "#ff9e64",
        red = "#ec5f67",
        blue = "#5fb3b3",
        green = "#99c794",
      },
      keymaps = {
        play_macro = "Q",
        yank_macro = "yq",
        stop_macro = "cq",
        toggle_record = "q",
        cycle_next = "<m-n>",
        cycle_prev = "<m-p>",
        toggle_macro_menu = "<m-q>",
      },
    },
    init = function()
      require("telescope").load_extension("macros")
    end,
  },
}
