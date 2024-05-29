local use_prj_lspconfig = false

local M = {

  -- TODO: comment unused extras

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

local lspconfig = {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- TODO: customize ensure_installed
      ensure_installed = {
        -- add project required packages here
      },
      automatic_installation = false,
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      setup = {
        -- false for using defaults
        -- basedpyright = function() return false end,
        -- neocmake = function() return false end,
        -- fortls = function() return false end,
        -- dockerls = function() return false end,
        -- texlab = function() return false end,
        -- yamlls = function() return false end,
        -- zls = function() return false end,
        -- lua_ls = function() return false end,
        -- bashls = function() return false end,
        -- clangd = function() return false end,
        -- ruff = function() return false end,
        -- basedpyright = function() return false end,
        -- rust_analyzer = function() return false end,
        -- marksman = function() return false end,
        -- taplo = function() return false end,
        -- docker_compose_language_service = function() return false end,
        -- jsonls = function() return false end,

        -- TODO: customize lspconfig setup
        ["*"] = function(server, opts) -- Specify * to use this function as a fallback for any server
          -- do not automatically configure lsp servers installed by mason
          return true -- ture for bypassing or false for using default `lspconfig setup` in LazyVim
        end,
      },
    },
  },
}

M = use_prj_lspconfig and vim.tbl_deep_extend("force", M, lspconfig) or M

return M


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

