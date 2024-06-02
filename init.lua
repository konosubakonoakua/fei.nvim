-- bootstrap lazy.nvim, LazyVim and your plugins

_G.dump = function(...)
  require("util.debug").dump(...)
end
_G.trace = function(...)
  require("util.debug").bt(...)
end

require("config.lazy")
