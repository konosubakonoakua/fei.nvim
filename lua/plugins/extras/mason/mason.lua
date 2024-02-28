return {
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.registries = {
        "lua:plugins.extras.mason.registries",
        "github:mason-org/mason-registry",
      }
    end,
  },
}
