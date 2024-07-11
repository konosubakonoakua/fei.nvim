return {
  {
    "2KAbhishek/termim.nvim",
    version = false,
    lazy = true,
    cmd = { "Fterm", "FTerm", "Sterm", "STerm", "Vterm", "VTerm" },
    keys = {
      { "<leader><leader>s", "<cmd>Sterm<cr>", desc = "Horizontal Terminal", silent = true, },
      { "<leader><leader>v", "<cmd>Vterm<cr>", desc = "Vertical Terminal", silent = true, },
      -- { "<leader><leader>g", "<cmd>Fterm lazygit<cr>", desc = "Lazygit" },
      -- { "<leader><leader>t", "<cmd>Fterm<cr>", desc = "Float Terminal" },

    },
  },
}
