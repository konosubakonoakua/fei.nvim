-- Command-line window maps: `q` quits, `<C-q>` records a macro.
vim.api.nvim_create_autocmd("CmdWinEnter", {
  group = vim.api.nvim_create_augroup("user_cmdwin", { clear = true }),
  callback = function()
    local keymap = vim.keymap.set
    keymap({ "n", "i" }, "<C-y>", "<cr>q:", { buffer = true, silent = true })
    keymap({ "n", "i" }, "<F5>", "<cr>q:", { buffer = true, silent = true })
    keymap("n", "<C-q>", "q", { buffer = true, silent = true, noremap = true })
    keymap("n", "q", "<cmd>q<cr>", { buffer = true, silent = true, noremap = true })
  end,
})
