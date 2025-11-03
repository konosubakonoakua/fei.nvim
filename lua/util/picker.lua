local M = setmetatable({}, {
  __call = function(m, ...)
    return m.name(...)
  end,
})

M.name = function()
  if LazyVim.has_extra("editor.snacks_picker") then
    return "snacks_picker"
  elseif LazyVim.has_extra("editor.telescope") then
    return "telescope"
  elseif LazyVim.has_extra("editor.fzf") then
    return "fzf-lua"
  else
    LazyVim.error("No picker available. Requires `editor.telescope`, `editor.fzf` or `editor.snacks_picker`")
    return nil
  end
end

M.spec = function()
  if LazyVim.has_extra("editor.snacks_picker") then
    return "folke/snacks.nvim"
  elseif LazyVim.has_extra("editor.telescope") then
    return "nvim-telescope/telescope.nvim"
  elseif LazyVim.has_extra("editor.fzf") then
    return "ibhagwan/fzf-lua"
  else
    LazyVim.error(
      "No picker available. Requires `folke/snacks.nvim`, `nvim-telescope/telescope.nvim` or `ibhagwan/fzf-lua`"
    )
    return nil
  end
end

M.has_telescope = function()
  return LazyVim.has_extra("editor.telescope")
end

M.has_fzflua = function()
  return LazyVim.has_extra("editor.fzf")
end

M.has_snacks = function()
  return LazyVim.has_extra("editor.snacks_picker")
end

return M
