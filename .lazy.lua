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
  --
  -- enable all extras for testing
  --

  -- debugger
  { import = "lazyvim.plugins.extras.dap.core" },
  { import = "plugins.extras.editor.dap" },

  -- lua
  { import = "lazyvim.plugins.extras.dap.nlua" },

  -- fennel
  { import = "plugins.extras.lang.fennel" },

  -- c/cpp
  { import = "lazyvim.plugins.extras.lang.clangd" },
  { import = "lazyvim.plugins.extras.lang.cmake" },
  { import = "plugins.extras.coding.godbolt" }, -- online compiler

  -- epics
  { import = "plugins.extras.lang.epics" },

  -- python
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.python-semshi" },
  { import = "plugins.extras.lang.python" },

  -- rust
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "plugins.extras.lang.rust" },

  -- zig
  { import = "plugins.extras.lang.zig" },

  -- latex
  { import = "lazyvim.plugins.extras.lang.tex" },

  -- xmake
  { import = "plugins.extras.build._xmake" },

}
