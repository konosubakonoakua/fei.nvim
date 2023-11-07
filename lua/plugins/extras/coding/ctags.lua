--[[
  ctags -o %TAGSFILE%
  --languages=C,C++ kinds-all=* fields=* extras=*
  -R ./ /external/lib/used/in/the/project/
--]]

return {
  {
    "dhananjaylatkar/cscope_maps.nvim",
    lazy = false,
    dependencies = {
      -- "folke/which-key.nvim", -- optional [for whichkey hints]
      -- "nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
      -- "ibhagwan/fzf-lua", -- optional [for picker="fzf-lua"]
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
        picker = "telescope", -- "telescope", "fzf-lua" or "quickfix"
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
