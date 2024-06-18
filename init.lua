if vim.env.VSCODE then
  vim.g.vscode = true
end

_G.fei = {
  debug_on = false,
  trace_on = false,
}

_G.dump = function(...)
  if _G.fei.debug_on then require("util.debug").dump(...) end
end

_G.trace = function(...)
  if _G.fei.debug_on then require("util.debug").bt(...) end
end

require("config.lazy")
