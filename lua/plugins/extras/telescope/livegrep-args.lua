return {
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    enabled = LazyVim.has("telescope.nvim"),
    dependencies = { "nvim-telescope/telescope.nvim" },
    init = function()
      local lga_actions = require("telescope-live-grep-args.actions")
      require("telescope").setup({
        extensions = {
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            -- FIXME: lvie grep-args keymap not working
            mappings = { -- extend mappings
              i = {
                ["<A-k>"] = lga_actions.quote_prompt(),
                ["<A-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
            -- ... also accepts theme settings, for example:
            -- theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            -- layout_config = { mirror=true }, -- mirror preview pane
          },
        },
      })
      require("telescope").load_extension("live_grep_args")
    end,
  },
}
