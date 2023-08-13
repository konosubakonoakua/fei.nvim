return {
  {
    -- only work for Neovim version < 0.9.0
    "ukyouz/vim-gutentags",
    lazy = flase,
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
        -- "gtags_cscope",
      }
      vim.g.gutentags_add_default_project_roots = false
      vim.g.gutentags_exclude_project_root = { vim.fn.expand("~") }
      vim.g.gutentags_project_root = { ".root" }
      vim.g.gutentags_cache_dir = vim.fn.expand("~/.cache/nvim/ctags/")
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
