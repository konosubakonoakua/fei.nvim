return {
  -- NOTE: no nvim-treesitter spec here on purpose. LazyVim's default
  -- `ensure_installed` already covers our parsers (its `opts_extend` merges
  -- instead of replacing), and indent/highlight/folds default to enabled.
  --
  -- NOTE: no mason-lspconfig spec either: LazyVim computes `ensure_installed`
  -- from the configured servers and calls `setup()` itself, and
  -- `automatic_installation` no longer exists in mason-lspconfig v2.
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = true,
        exclude = {}, -- filetypes for which you don't want to enable inlay hints
      },
      -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the code lenses.
      codelens = {
        enabled = false,
      },
      -- Enable lsp cursor word highlighting
      -- will be disabled by `illuminate`
      document_highlight = {
        enabled = false, -- slow with neodev when searching a large lua code base
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      -- setup = {
      --   -- Specify * to use this function as a fallback for any server
      --   ["*"] = function(server, opts)
      --     -- do not automatically configure lsp servers installed by mason
      --     return false -- true for bypassing or false for using default `lspconfig setup` in LazyVim
      --   end,
      -- },
    },
  },
}
