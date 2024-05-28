return {
  {
    "konosubakonoakua/godbolt.nvim",
    lazy = true,
    version = false,
    init = function()
      vim.b.godbolt_exec = 0

      LazyVim.safe_keymap_set("n", "<leader>;e", function()
        if vim.b.godbolt_exec then
          vim.b.godbolt_exec = 0
          vim.notify("godbolt execute output disabled", vim.log.levels.WARN)
        else
          vim.b.godbolt_exec = 1
          vim.notify("godbolt execute output enabled", vim.log.levels.WARN)
        end
      end, { desc = "Toggle Godbolt Execution" })

      require("godbolt").setup({
        languages = {
          cpp = { compiler = "g122", options = {} },
          c = { compiler = "cg122", options = {} },
          rust = { compiler = "r1650", options = {} },
          -- any_additional_filetype = { compiler = ..., options = ... },
        },
        quickfix = {
          enable = true, -- whether to populate the quickfix list in case of errors
          auto_open = true, -- whether to open the quickfix list in case of errors
        },
        url = "https://godbolt.org", -- can be changed to a different godbolt instance
      })
    end,
  },
}
