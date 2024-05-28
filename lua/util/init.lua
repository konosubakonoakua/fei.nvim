local M = {}
local term_border = "rounded"
local LazyVim = require("lazyvim.util")

M.cmd_concat = function(command)
  return table.concat({ "<Cmd>", command, "<CR>" })
end

M.custom_floatterm = LazyVim.terminal.open

M.custom_lazyterm = function()
  LazyVim.terminal(nil, {
    cwd = LazyVim.root(),
    ctrl_hjkl = false,
    size = { width = 0.95, height = 0.93 },
    border = term_border,
  })
end

M.custom_lazyterm_cwd = function()
  LazyVim.terminal(nil, {
    cwd = tostring(vim.fn.expand("%:p:h")),
    ctrl_hjkl = false,
    -- size = { width = 1.0, height = 1.0 },
    size = { width = 0.95, height = 0.93 },
    border = term_border,
  })
end

return M
