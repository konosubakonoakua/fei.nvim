local M = setmetatable({}, {
  __call = function(m, ...)
    return m.name(...)
  end,
})

M.name = function ()
  return (LazyVim.has("telescope.nvim") and "telescope")
    or (LazyVim.has("fzf-lua") and "fzf-lua")
    or (LazyVim.error("requires `telescope.nvim` or `fzf-lua`") and nil)
end


M.spec = function ()
  return (LazyVim.has("telescope.nvim") and "nvim-telescope/telescope.nvim")
    or (LazyVim.has("fzf-lua") and "ibhagwan/fzf-lua")
    or (LazyVim.error("requires `telescope.nvim` or `fzf-lua`") and nil)
end


M.has_telescope = function () return LazyVim.has("telescope.nvim") end
M.has_fzflua = function () return LazyVim.has("fzf-lua") end

return M
