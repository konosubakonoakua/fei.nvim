local M = {}

function M.keymap(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

function M.cmd_concat(command)
  return table.concat({ "<Cmd>", command, "<CR>" })
end

function M.is_disabled_plugin(plugin)
  local disabled = require("plugins.disabled")
  if not disabled then
    return false
  end
  return vim.tbl_contains(vim.tbl_flatten(disabled), plugin)
end

return M
