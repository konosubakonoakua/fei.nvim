-- Neovim file explorer: edit your filesystem like a buffer
-- https://github.com/stevearc/oil.nvim

vim.keymap.set("n", "<leader>;o", ":Oil<cr>", { desc = "Oil explorer", noremap = true, silent=true })
return {
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  }
}
