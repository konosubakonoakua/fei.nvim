return {
  {
    "ahmedkhalf/project.nvim",
    version = false,
    opts = {
      -- only add project manually, using :AddProject
      manual_mode = true,
    },
    event = "VeryLazy",
    config = function(_, opts)
      opts.detection_methods = { "lsp", "pattern" }
      opts.patterns = {
        ".git",
        ".root",
      }
      require("project_nvim").setup(opts)
        LazyVim.on_load("telescope.nvim", function()
          _ = LazyVim.has("telescope.nvim") and require("telescope").load_extension("projects")
      end)
    end,
    keys = {
      { "<leader>fp", "<Cmd>Telescope projects<CR>", desc = "Projects" },
    },
  },
  { -- https://github.com/CWood-sdf/spaceport.nvim
    'CWood-sdf/spaceport.nvim',
    enabled = false,
    opts = {},
    lazy = false, -- load spaceport immediately
  },
}
