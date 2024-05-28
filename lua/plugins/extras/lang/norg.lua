return {
  {
    -- https://github.com/nvim-neorg/neorg?tab=readme-ov-file
    "nvim-neorg/neorg",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neorg/neorg-telescope",
    },
    build = ":Neorg sync-parsers", -- NOTE: important fro neorg
    -- tag = "*",
    lazy = true,
    ft = "norg", -- lazy load on file type
    cmd = "Neorg", -- lazy load on command
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                work = "~/notes/work",
                home = "~/notes/home",
              },
            },
          },
          ["core.integrations.telescope"] = {},
        },
      })
      -- TODO: neorg remap telescope keymaps
      local neorg_callbacks = require("neorg.core.callbacks")
      neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
        -- Map all the below keybinds only when the "norg" mode is active
        keybinds.map_event_to_mode("norg", {
          n = { -- Bind keys in normal mode
            { "<C-s>", "core.integrations.telescope.find_linkable" },
          },

          i = { -- Bind in insert mode
            { "<C-l>", "core.integrations.telescope.insert_link" },
          },
        }, {
          silent = true,
          noremap = true,
        })
      end)
    end,
  },
}

-- vim:ts=2:sw=2:softtabstop=2:expandtab:
-- vim :set ts=2 sw=2 sts=2 et :
