--[[
Enable project-specific plugin specs.

File .lazy.lua:
  is read when present in the current working directory
  should return a plugin spec
  has to be manually trusted for each instance of the file

This extra should be the last plugin spec added to lazy.nvim

See:
  :h 'exrc'
  :h :trust
--]]
return {

  -- user extras
  -- { import = "plugins.extras.xxx" },

}
