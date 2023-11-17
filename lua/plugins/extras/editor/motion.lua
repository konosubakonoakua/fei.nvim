-- https://github.com/gsuuon/tshjkl.nvim
return {
  {
    "gsuuon/tshjkl.nvim",
    opts = {
      keymaps = {
        toggle = "<leader>um",
      },
      marks = {
        parent = {
          virt_text = { { "h", "ModeMsg" } },
          virt_text_pos = "overlay",
        },
        child = {
          virt_text = { { "l", "ModeMsg" } },
          virt_text_pos = "overlay",
        },
        prev = {
          virt_text = { { "k", "ModeMsg" } },
          virt_text_pos = "overlay",
        },
        next = {
          virt_text = { { "j", "ModeMsg" } },
          virt_text_pos = "overlay",
        },
      },
    },
  },
}
