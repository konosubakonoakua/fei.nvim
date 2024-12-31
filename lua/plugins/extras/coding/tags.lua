--[[
  ctags -o %TAGSFILE%
  --languages=C,C++ kinds-all=* fields=* extras=*
  -R ./ /external/lib/used/in/the/project/
--]]

local _ctags = {
  {
    "dhananjaylatkar/cscope_maps.nvim",
    version = false,
    lazy = false,
    dependencies = {
      -- "folke/which-key.nvim", -- optional [for whichkey hints]
      require("util.picker").spec(),
      -- "nvim-tree/nvim-web-devicons", -- optional [for devicons in telescope or fzf]
    },
    opts = {
      -- maps related defaults
      disable_maps = false, -- "true" disables default keymaps
      skip_input_prompt = false, -- "true" doesn't ask for input

      -- cscope related defaults
      cscope = {
        -- location of cscope db file
        db_file = "./cscope.out",
        -- cscope executable
        exec = "cscope", -- "cscope" or "gtags-cscope"
        -- choose your fav picker
        picker = require("util.picker").name(), -- "telescope", "fzf-lua" or "quickfix"
        -- "true" does not open picker for single result, just JUMP
        skip_picker_for_single_result = false, -- "false" or "true"
        -- these args are directly passed to "cscope -f <db_file> <args>"
        db_build_cmd_args = { "-bqkv" },
        -- -- statusline indicator, default is cscope executable
        -- statusline_indicator = nil,
      },
    },
  },
  {
    "ukyouz/vim-gutentags",
    version = false,
    lazy = false,
    -- event = "VeryLazy",
    branch = "improve_update_perf",
    -- "dhananjaylatkar/vim-gutentags",
    after = "cscope_maps.nvim",
    config = function()
      vim.g.gutentags_modules = { "cscope_maps" } -- This is required. Other config is optional
      vim.g.gutentags_cscope_build_inverted_index_maps = 1
      vim.g.gutentags_cache_dir = vim.fn.expand("~/code/.gutentags")
      vim.g.gutentags_file_list_command = "fd -e c -e h"
      -- vim.g.gutentags_trace = 1
    end,
  },
}

local _gtags = {
  {
    -- only work for Neovim version < 0.9.0
    "ukyouz/vim-gutentags",
    version = false,
    lazy = false,
    enabled = false,
    event = "VeryLazy",
    branch = "improve_update_perf",
    ft = {
      "c",
      "cpp",
    },
    config = function()
      -- https://www.reddit.com/r/vim/comments/d77t6j/guide_how_to_setup_ctags_with_gutentags_properly/
      vim.g.gutentags_ctags_exclude = {
        "*.git",
        "*.svg",
        "*.hg",
        "*/tests/*",
        "build",
        "dist",
        "*sites/*/files/*",
        "bin",
        "node_modules",
        "bower_components",
        "cache",
        "compiled",
        "docs",
        "example",
        "bundle",
        "vendor",
        "*.md",
        "*-lock.json",
        "*.lock",
        "*bundle*.js",
        "*build*.js",
        ".*rc*",
        "*.json",
        "*.min.*",
        "*.map",
        "*.bak",
        "*.zip",
        "*.pyc",
        "*.class",
        "*.sln",
        "*.Master",
        "*.csproj",
        "*.tmp",
        "*.csproj.user",
        "*.cache",
        "*.pdb",
        "tags*",
        "cscope.*",
        ".venv",
        "*.exe",
        "*.dll",
        "*.mp3",
        "*.ogg",
        "*.flac",
        "*.swp",
        "*.swo",
        "*.bmp",
        "*.gif",
        "*.ico",
        "*.jpg",
        "*.png",
        "*.rar",
        "*.zip",
        "*.tar",
        "*.tar.gz",
        "*.tar.xz",
        "*.tar.bz2",
        "*.pdf",
        "*.doc",
        "*.docx",
        "*.ppt",
        "*.pptx",
      }
      -- vim.o.cscopetag = true
      -- vim.o.cscopeprg = "gtags-cscope"
      vim.g.gutentags_modules = {
        "ctags",
        "gtags_cscope",
      }
      vim.g.gutentags_add_default_project_roots = false
      vim.g.gutentags_exclude_project_root = { vim.fn.expand("~") }
      vim.g.gutentags_project_root = { ".root" }
      vim.notify(vim.g.gutentags_cache_dir)
      vim.g.gutentags_cache_dir = vim.fn.expand("~/.LfCache/gtags")
      -- vim.g.gutentags_cache_dir = vim.fn.expand("~/.cache/nvim/ctags/")
      vim.g.gutentags_generate_on_new = true
      vim.g.gutentags_generate_on_missing = true
      vim.g.gutentags_generate_on_write = true
      vim.g.gutentags_generate_on_empty_buffer = true
      vim.g.gutentags_ctags_extra_args = {
        "--tag-relative=yes",
        -- "--fields=+ailmnS",
        "--fields=+niazS",
        "--extra=+q",
        "--c++-kinds=+px",
        "--c-kinds=+px",
      }

      -- TODO: using lua implementation
      vim.cmd([[command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')]])
      vim.cmd([[
        if !isdirectory(g:gutentags_cache_dir)
            silent! call mkdir(g:gutentags_cache_dir, 'p')
        endif
      ]])
    end,
  },
  {
    "liuchengxu/vista.vim",
    version = false,
    enabled = false,
    keys = {
      {
        "<leader>ls",
        "<cmd>:Vista!!<cr>",
        desc = "List Symbols outline",
        noremap = false,
      },
    },
    config = function()
      vim.cmd("let g:vista#renderer#enable_icon = 1")
    end,
  },
}

local _gentags = {
  {
    "linrongbin16/gentags.nvim",
    config = function()
      require('gentags').setup()
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    optional = true,
    requires = {
      {
        -- https://github.com/quangnguyen30192/cmp-nvim-tags#troubleshooting
        'quangnguyen30192/cmp-nvim-tags',
        -- if you want the sources is available for some file types
        ft = {
          'c',
        }
      }
    },
    config = function ()
      require'cmp'.setup {
      sources = {
        {
          name = 'tags',
          option = {
            -- this is the default options, change them if you want.
            -- Delayed time after user input, in milliseconds.
            complete_defer = 100,
            -- Max items when searching `taglist`.
            max_items = 10,
            -- The number of characters that need to be typed to trigger
            -- auto-completion.
            keyword_length = 3,
            -- Use exact word match when searching `taglist`, for better searching
            -- performance.
            exact_match = false,
            -- Prioritize searching result for current buffer.
            current_buffer_only = false,
          },
        },
        -- more sources
      }
    }
    end
  },
}

return _gentags or _ctags or _gtags
