return {
  desc = "User config for python development, overwriting LazyVim python extras",
  {
    "microsoft/python-type-stubs",
    version = "*",
    enabled = true,
    cond = true, -- only keep the latest version, do not require loading
  },
  {
    "mfussenegger/nvim-dap-python",
    optional = true,
    ft = "python", -- Call config for python files and load the cached venv automatically
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    ft = "python", -- Call config for python files and load the cached venv automatically
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
      },
    },
  },

  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "mfussenegger/nvim-dap-python" },
    enabled = true,
    optional = true,
    ft = "python", -- Call config for python files and load the cached venv automatically
    cmd = "VenvSelect",
    config = function()
      _home_dir = vim.env.HOME
      _home_dir_venvs_command1 = jit.os == "Windows"
          and "fd 'Scripts//python.exe$' " .. _home_dir .. "/.virtualenvs --full-path -IH -a"
        or "fd 'python$' ~/.virtualenvs --full-path -IH -a"
      _home_dir_venvs_command2 = jit.os == "Windows"
          and "fd 'Scripts//python.exe$' " .. _home_dir .. "/.venvs --full-path -IH -a"
        or "fd 'python$' ~/.venvs --full-path -IH -a"
      _home_dir_venvs_command3 = jit.os == "Windows"
          and "fd 'Scripts//python.exe$' " .. _home_dir .. "/venvs --full-path -IH -a"
        or "fd 'python$' ~/venvs --full-path -IH -a"
      require("venv-selector").setup({
        settings = {
          options = {
            debug = true,
          },
          search = {
            home_dir_venvs1 = {
              command = _home_dir_venvs_command1,
            },
            home_dir_venvs2 = {
              command = _home_dir_venvs_command2,
            },
            home_dir_venvs3 = {
              command = _home_dir_venvs_command3,
            },
          },
        },
      })
    end,
    keys = {
      -- TODO: find an automatic way to set venv
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select venv" },
      {
        "<leader>cV",
        "<cmd>lua require('venv-selector').deactivate()<cr>",
        desc = "Deactivate venv",
      },
    },
  },

  {
    "folke/trouble.nvim",
    optional = true,
    opts = {
      max_items = 9999,
    },
  },
}
