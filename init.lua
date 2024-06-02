if vim.env.VSCODE then
  vim.g.vscode = true
end

_G.dump = function(...)
  require("util.debug").dump(...)
end
_G.trace = function(...)
  require("util.debug").bt(...)
end

require("config.lazy")
