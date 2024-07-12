if vim.fn.has("nvim-0.11.0") == 0 then
  -- NOTE: commentstring fix for verilog is introduced by
  -- https://github.com/neovim/neovim/pull/28871
  -- which is not included until nvim-0.11.*
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "verilog" },
    callback = function()
      vim.bo.commentstring = "// %s"
    end,
  })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "verilog" })
      end
    end,
  },

  -- Add formatting
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = { verilog = { "verible" } },
    },
  },

  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        verible = {
          cmd = {
            'verible-verilog-ls',
            -- '--rules_config_search'
          },
        },
      },
    },
  },
}
