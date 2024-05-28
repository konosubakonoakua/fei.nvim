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
  { import = "plugins.extras.lsp.fennel" },

  -- c/cpp
  { import = "lazyvim.plugins.extras.lang.clangd" },
  { import = "lazyvim.plugins.extras.lang.cmake" },
  { import = "plugins.extras.util.godbolt" }, -- online compiler

  -- epics
  { import = "plugins.extras.lsp.epics" },

  -- python
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.python-semshi" },
  { import = "plugins.extras.lsp.python" },

  -- rust
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "plugins.extras.lsp.rust" },

  -- zig
  { import = "plugins.extras.lsp.zig" },

  -- latex
  { import = "lazyvim.plugins.extras.lang.tex" },

}
