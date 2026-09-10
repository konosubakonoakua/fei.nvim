-- Terminals and dotfile search.
local ok, Term = pcall(require, "util.term")
if not ok then
  -- BUG: loop require in CI environment
  LazyVim.error("Error loading util.term in config/keymaps/terminal")
  return
end

local keymap = vim.keymap.set

keymap("n", "<leader>fD", "<cmd>Dotfiles<cr>", { desc = "Search dotfiles" })
keymap("n", "<leader>fT", Term.term_cwd, { desc = "Terminal (cwd)" })
keymap("n", "<leader>ft", Term.term_root, { desc = "Terminal (root dir)" })
