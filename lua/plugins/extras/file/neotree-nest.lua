return {
  desc = "nest all config files for neotree",
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      -- Others dependencies
      "saifulapm/neotree-file-nesting-config", -- add plugin as dependency. no need any other config or setup call
    },
    opts = {
      -- recommanded config for better UI
      hide_root_node = true,
      retain_hidden_root_indent = true,
      filesystem = {
        filtered_items = {
          show_hidden_count = false,
          never_show = {
            ".DS_Store",
          },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
        },
      },
      -- others config
    },
    config = function(_, opts)
      -- Adding rules from plugin
      -- TODO: add expand key
      opts.nesting_rules = require("neotree-file-nesting-config").nesting_rules
      require("neo-tree").setup(opts)
    end,
  },
}
