local M = {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration
    require("util.picker").spec(),
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
