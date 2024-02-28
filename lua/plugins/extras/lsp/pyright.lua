return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
    },
    opts = function(_, opts)
      ---@type lspconfig.options.pyright
      opts.servers.pyright = {
        settings = {
          python = {
          },
        },
      }
      opts.servers.pyright.before_init = function(_, config)
        config.settings.python.analysis = {
          autoImportCompletions = true,
          typeCheckingMode = "basic",
          autoSearchPaths = true,
          useLibraryCodeForTypes = false, -- PERF: slow when big libs imported
          diagnosticMode = "openFilesOnly",

          -- PERF: super sluggish when open too big projects
          stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs/stubs",
        }
      end
    end,
  }
}
