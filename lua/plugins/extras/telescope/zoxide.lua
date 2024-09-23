return {
  "jvgrootveld/telescope-zoxide",
  enabled = LazyVim.has("telescope.nvim"),
  version = false,
  config = function(_, opts)
    local t = require("telescope")
    local z_utils = require("telescope._extensions.zoxide.utils")

    -- Configure the extension
    opts = {
      extensions = {
        zoxide = {
          prompt_title = "🙉 Zoxide",
          mappings = {
            default = {
              after_action = function(selection)
                print("Update to (" .. selection.z_score .. ") " .. selection.path)
              end,
            },
            ["<C-s>"] = {
              before_action = function(selection)
                print("before C-s")
              end,
              action = function(selection)
                -- vim.cmd.edit(selection.path)
                require("neo-tree.command").execute({ toggle = false, dir = vim.loop.cwd() })
              end,
            },
            -- ["<C-q>"] = { action = z_utils.create_basic_command("split") },
          },
        },
      },
    }

    t.setup(opts)
    t.load_extension("zoxide")
    vim.keymap.set("n", "<leader>sz", function() t.extensions.zoxide.list({
      cmd = jit.os == "Windows" and { "pwsh", "-nop", "-c", "zoxide query -ls" } or nil,
    }) end, { desc = "zoxide" })
  end,
}
