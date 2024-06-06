return {
  -- { import = "lazyvim.plugins.extras.util.octo" },

  {
    "echasnovski/mini.diff",
    keys = function ()
      return {
        {
          "<leader>gm",
          function()
            require("mini.diff").toggle_overlay(0)
          end,
          desc = "Toggle mini.diff overlay",
        },
      }
    end
  },

  -- Octo Keys
  {
    "pwntester/octo.nvim",
    init = function()
      vim.treesitter.language.register("markdown", "octo")
    end,
    opts = {
      picker = "telescope",
      enable_builtin = true,
      default_to_projects_v2 = true,
      default_merge_method = "squash",
      mappings_disable_default = false, -- disable all default keys
      suppress_missing_scope = {
        projects_v2 = true,
      },
    },
    keys = {
      { "<leader>go", "<cmd>Octo<cr>", desc = "Octo" },
      -- { "<leader>gi", "<cmd>Octo issue list<CR>", desc = "List Isues (Octo)" },
      -- { "<leader>gI", "<cmd>Octo issue search<CR>", desc = "Search Isues (Octo)" },
      -- { "<leader>gp", "<cmd>Octo pr list<CR>", desc = "List PRs (Octo)" },
      -- { "<leader>gP", "<cmd>Octo pr search<CR>", desc = "Search PRs (Octo)" },
      -- { "<leader>gr", "<cmd>Octo repo list<CR>", desc = "List Repos (Octo)" },
      -- { "<leader>gS", "<cmd>Octo search<CR>", desc = "Search (Octo)" },
      { "<leader>a", "", desc = "+assignee (Otco)", ft = "octo" },
      { "<leader>c", "", desc = "+comment/code (Otco)", ft = "octo" },
      { "<leader>l", "", desc = "+label (Otco)", ft = "octo" },
      { "<leader>i", "", desc = "+issue (Otco)", ft = "octo" },
      { "<leader>r", "", desc = "+react (Otco)", ft = "octo" },
      { "<leader>p", "", desc = "+pr (Otco)", ft = "octo" },
      { "<leader>v", "", desc = "+review (Otco)", ft = "octo" },
      { "@", "@<C-x><C-o>", mode = "i", ft = "octo", silent = true },
      { "#", "#<C-x><C-o>", mode = "i", ft = "octo", silent = true },
    },
  },

  -- Octo Picker
  {
    "pwntester/octo.nvim",
    opts = function(_, opts)
      if LazyVim.has("telescope.nvim") then
        opts.picker = "telescope"
      elseif LazyVim.has("fzf-lua") then
        opts.picker = "fzf-lua"
      else
        LazyVim.error("`octo.nvim` requires `telescope.nvim` or `fzf-lua`")
      end
    end,
  },

  -- Octo lazy loading
  {
    'pwntester/octo.nvim',
    cmd = "Octo",
    -- event = "VeryLazy", -- don't use event if use module
    module = false, -- NOTE: do not automatically load it
    init = function ()
      -- call `Octo` first time to load
      -- then the cmd will be overwritten by setup later
      vim.api.nvim_create_user_command('Octo', function ()
        vim.cmd[[Lazy load octo.nvim]]
        LazyVim.info(":Lazy load octo.nvim")
      end, {desc = ":Lazy load octo.nvim"})
    end,
  },
}
