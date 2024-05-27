--[[
Enable project-specific plugin specs.

File .lazy.lua:
  is read when present in the current working directory
  should return a plugin spec
  has to be manually trusted for each instance of the file

This extra should be the last plugin spec added to lazy.nvim

```lua
return {
  -- lazyvim pre-defined extras
  -- { import = "lazyvim.plugins.extras.xxx" },
  -- user extras
  -- { import = "plugins.extras.xxx" },
}
```

See:
  :h 'exrc'
  :h :trust
--]]


return {
  { import = "lazyvim.plugins.extras.dap.core" },
  { import = "lazyvim.plugins.extras.dap.nlua" },
  { import = "plugins.extras.editor.dap" },
  { import = "plugins.extras.lsp.fennel" },
}
