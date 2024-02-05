local M = {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration

    -- Only one of these is needed, not both.
    "nvim-telescope/telescope.nvim", -- optional
    "ibhagwan/fzf-lua",              -- optional
  },
  config = true,
  enabled = true,
}

M.init = function ()
  vim.keymap.set("n", "<leader>gn", ":Neogit<cr>", { desc = "Neogit" })
end

return { M }
