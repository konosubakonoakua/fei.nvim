-- LSP workspace-folder maps.
-- Buffer-local and (re)applied per attached client; the maps would otherwise
-- only work in whichever buffer happened to be current when they were defined.
local keymap = vim.keymap.set

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_workspace", { clear = true }),
  callback = function(event)
    local buf = event.buf
    keymap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { buffer = buf, desc = "Add workspace folder" })
    keymap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { buffer = buf, desc = "Remove workspace folder" })
    keymap("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { buffer = buf, desc = "List workspace folders" })
  end,
})
