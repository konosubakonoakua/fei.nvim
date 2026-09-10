-- Terminal helpers built on Snacks.terminal.
local M = {}

local border = "rounded"

---Open a floating terminal running `cmd`.
---@param cmd string|string[]
---@param opts? table
function M.floatterm(cmd, opts)
  return Snacks.terminal.open(cmd, opts)
end

---Toggle a terminal rooted at the project root.
function M.term_root()
  Snacks.terminal(nil, {
    cwd = LazyVim.root(),
    ctrl_hjkl = false,
    size = { width = 0.95, height = 0.93 },
    border = border,
  })
end

---Toggle a terminal rooted at the current file's directory.
function M.term_cwd()
  Snacks.terminal(nil, {
    cwd = tostring(vim.fn.expand("%:p:h")),
    ctrl_hjkl = false,
    size = { width = 0.95, height = 0.93 },
    border = border,
  })
end

return M
