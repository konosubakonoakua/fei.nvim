return {
  {
    -- only work for Neovim version < 0.9.0
    "ukyouz/vim-gutentags",
    enabled = false,
    event = "VeryLazy",
    branch = "improve_update_perf",
    ft = {
      "c",
      "cpp",
    },
    init = function()
      local user_dir = vim.api.nvim_eval("expand('~/.LfCache/gtags')")
      -- vim.o.cscopetag = true
      -- vim.o.cscopeprg = "gtags-cscope"
      vim.g.gutentags_modules = {
        "ctags",
        "gtags_cscope",
      }
      vim.g.gutentags_cache_dir = user_dir
      vim.g.gutentags_generate_on_missing = 1
      vim.g.gutentags_generate_on_write = 1
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
