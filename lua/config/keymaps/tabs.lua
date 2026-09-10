-- Tab pages.
--
-- LazyVim already defines the core set, so only the extras live here:
--   <leader><tab>]      next tab        <leader><tab>[  previous tab
--   <leader><tab>d      close tab       <leader><tab>o  close other tabs
--   <leader><tab>f      first tab       <leader><tab>l  last tab
--   <leader><tab><tab>  new tab
local keymap = vim.keymap.set

keymap("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
