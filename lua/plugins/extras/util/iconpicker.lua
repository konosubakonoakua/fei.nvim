return {
  {
    "ziontee113/icon-picker.nvim",
    config = function()
      require("icon-picker").setup({ disable_legacy_commands = true })
      vim.keymap.set("n", "<Leader>si", "<cmd>IconPickerNormal<cr>", {
        desc = "IconPicker insert here",
        noremap = true,
        silent = true,
      })
    end,
  },
}
