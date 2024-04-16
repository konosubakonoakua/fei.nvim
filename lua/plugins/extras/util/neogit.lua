local M = {
  "NeogitOrg/neogit",
  branch = "nightly",
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
  vim.keymap.set("n", "<leader>gn", function ()
    require("neogit").open({cwd = LazyVim.root()})
  end, { desc = "Neogit lazyroot" })
  vim.keymap.set("n", "<leader>gN", function ()
    require("neogit").open({cwd = vim.loop.cwd()})
  end, { desc = "Neogit CWD" })
end

return { M }
