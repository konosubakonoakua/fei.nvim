local M = setmetatable({}, {
  __call = function(m, ...)
    return m.name(...)
  end,
})

M.name = function()
  return "quickfix"
end

M.spec = function()
  return "folke/snacks.nvim"
end

M.has_telescope = function()
  return false
end

M.has_fzflua = function()
  return false
end

M.has_snacks = function()
  return true
end

return M
