return {
  {
    "nvim-zh/colorful-winsep.nvim",
    enabled = true,
    config = true,
    event = { "WinNew" },
    opts = function(_, opts)
      opts.no_exec_files = {
        "packer",
        "TelescopePrompt",
        "mason",
        "CompetiTest",
        "NvimTree",
        "edgy",
        "neo-tree",
        "neo-tree-popup",
        "notify",
      }
      -- horizontal, vertical, top left, top right, bottom left, bottom right.
      opts.symbols = { "━", "┃", "┏", "┓", "┗", "┛" }
      opts.smooth = false -- beter keep false when using neovide
      return opts
    end,
  },
}
