-- #!/usr/bin/env bash
--
-- # CHANGE IF NEEDED:
-- server_path="$HOME/.cache/nvim/godot-server.pipe"
-- file=$1
-- line=$2
-- col=$3
--
-- [[ -e $server_path ]] || neovide "$file" -- --listen "$server_path"
--
-- nvim --server "$server_path" \
-- --remote-send "<C-\><C-N>:n $file<CR>:call cursor($line,$col)<CR>" "${@:4}"
--------------------------------------------------------------------------------------
-- https://github.com/neovide/neovide/issues/2481
return {
  desc = "godot & neovided & lsp",
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gdscript = {
          enabled = true,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      dap.adapters.godot = {
        type = "server",
        host = "127.0.0.1",
        port = 6006,
      }
      dap.configurations.gdscript = {
        {
          type = "godot",
          request = "launch",
          name = "Launch scene",
          project = "${workspaceFolder}",
          launch_scene = true,
        },
      }
    end,
  },
}
