return {
  desc = "User config for python development, overwriting LazyVim python extras",
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "ninja", "python", "rst", "toml",
        })
      end
    end,
  },
  {
    "microsoft/python-type-stubs",
    version = "*",
    enabled = true,
    cond = true, -- only keep the latest version, do not require loading
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          enabled = false,
          -- mason = false,
        },
        ruff_lsp = {
          enabled = false,
          -- mason = false,
        },
      },
    },
  },
  -- {
  --   "nvim-neotest/neotest",
  --   optional = true,
  --   dependencies = {
  --     "nvim-neotest/neotest-python",
  --   },
  --   opts = {
  --     adapters = {
  --       ["neotest-python"] = {
  --         -- Here you can specify the settings for the adapter, i.e.
  --         -- runner = "pytest",
  --         -- python = ".venv/bin/python",
  --       },
  --     },
  --   },
  -- },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
      },

      -- NOTE:  avoid double setup cause venv-selector also calls setup
      -- config = function()
      --   local path = require("mason-registry").get_package("debugpy"):get_install_path()
      --   require("dap-python").setup(path .. "/venv/bin/python")
      -- end,
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "mfussenegger/nvim-dap-python" },
    enabled = true,
    lazy = false,
    cmd = "VenvSelect",
    opts = function(_, opts)
      -- FIXME: not working at all, dap-python only use custom func in enrich_config
      if LazyVim.has("nvim-dap-python") then
        opts.dap_enabled = true
      end
      return vim.tbl_deep_extend("force", opts, {
        name = {
          "venv",
          ".venv",
          "env",
          ".env",
        },
      })
    end,
    keys = {
      -- TODO: find an automatic way to set venv
      {
        "<leader>cv",
        function()
          vim.cmd("VenvSelect")
          local venv_path = require("venv-selector").get_active_path()
          if LazyVim.has("nvim-dap-python") then
            require("dap-python").setup(venv_path)
          end
        end,
        desc = "Select venv",
      },
      {
        "<leader>cV",
        "<cmd>lua require('venv-selector').deactivate_venv()<cr>",
        desc = "Deactivate venv",
      },
    },
  },
}
