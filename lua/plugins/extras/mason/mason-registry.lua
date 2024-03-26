return {
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.registries = opts.registries or {
        "github:mason-org/mason-registry",
      }

      -- FIXME: mason cannot find lua path registry on windows
      vim.list_extend(opts.registries, jit.os == "Windows" and {} or {
        "lua:plugins.extras.mason.registries",
      })

      return opts
    end,
  },
}
