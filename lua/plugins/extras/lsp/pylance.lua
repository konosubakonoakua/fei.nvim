local util = require("lspconfig.util")

local root_files = {
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
  "pyrightconfig.json",
}

local pylance_default_config = {
  default_config = {
    cmd = { "pylance", "--stdio" },
    filetypes = { "python" },
    root_dir = function(fname)
      local root = util.root_pattern(unpack(root_files))(fname)
      if root and root ~= vim.env.HOME then
        return root
      end
      return util.find_git_ancestor(fname)
    end,
    single_file_support = true,

    settings = {
      python = {
        -- pythonPath = "python3",
        analysis = {
          addImport = { exactMatchOnly = true },

          autoFormatStrings = true,
          autoImportCompletions = true,
          autoSearchPaths = true,

          completeFunctionParens = false,

          diagnosticMode = "openFilesOnly", -- values: workspace | openFilesOnly

          enablePytestExtra = false,
          enablePytestSupport = true,
          enableSyncServer = false,
          extraCommitChars = true,

          gotoDefinitionInStringLiteral = true,

          importFormat = "absolute", -- values: absolute | relative
          indexing = true,

          inlayHints = {
            callArgumentNames = true,
            functionReturnTypes = true,
            pytestParameters = true,
            variableTypes = true,
          },

          logLevel = "Information", -- values: Trace | Information | Warning | Error

          persistAllIndices = true,

          stubPath = "typings",

          typeCheckingMode = "off", -- values: off | basic | strict

          useLibraryCodeForTypes = true,
          userFileIndexingLimit = 2000,
        },
      },
    },
  },
}

-- NOTE: pylance mason package only works on linux
return require("platform").isPlatWindows() and {} or {
  {
    "neovim/nvim-lspconfig",
    dependencies = {},
    -- TODO: find out why opts not working
    init = function()
      local configs = require("lspconfig.configs")
      require("lspconfig.configs").pylance = pylance_default_config
      require("lspconfig").pylance.setup({})
    end,
    -- opts = function(_, opts)
    -- end,
  },
}
