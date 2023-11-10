return {
  {
    "ahmedkhalf/project.nvim",
    version = false,
    opts = {
      manual_mode = false,
    },
    event = "VeryLazy",
    config = function(_, opts)
      opts.detection_methods = { "lsp", "pattern" }
      opts.patterns = {
        ".git",
        ".hg",
        ".svn",
        ".bzr",
        "_darcs",
        "Makefile",
        "package.json",
        "CMakeLists.txt",
        ".toml",
        ".yaml",
        "build.zig",
        "build.bazel",
        "configure.ac",
        "autogen.sh",
        "setup.py",
        "README",
        "README.md",
      }
      require("project_nvim").setup(opts)
      require("lazyvim.util").on_load("telescope.nvim", function()
        require("telescope").load_extension("projects")
      end)
    end,
    keys = {
      { "<leader>fp", "<Cmd>Telescope projects<CR>", desc = "Projects" },
    },
  },
}
