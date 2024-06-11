return {
  { import = "lazyvim.plugins.extras.editor.fzf" },
  {
    "ibhagwan/fzf-lua",
    -- optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts, 1, "default") -- use telescope profile
      opts.fzf_opts = { ["--layout"] = "reverse" } -- input box at TOP
      opts.winopts = {
        fullscreen = false,
        layout = "flex", -- horizontal|vertical|flex
        -- border = "none", -- 'none', 'single', 'double', 'thicc' (+cc) or 'rounded' (default)
        preview = {
          scrollchars = { "┃", "" },
          hidden = "nohidden",
        },
      }
      opts.previewers = {
        -- NOTE: remove the `-c` flag when using man-db
        -- replace with `man -P cat %s | col -bx` on OSX
        man = { cmd = "man %s | col -bx" },
      }
      return opts
    end,
    keys = {
      -- find
      { "<leader>fg", LazyVim.pick("git_files", { root = true }), desc = "Find Git-Files (root)" },
      { "<leader>fP", LazyVim.pick("files", { cwd = vim.fn.stdpath("data") .. "/lazy" }), desc = "Find Plugin File" },
      { "<leader>fR", LazyVim.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
      { "<leader>fr", LazyVim.pick("oldfiles", { root = true }), desc = "Recent (root)" },
      {
        "<leader>fl",
        function()
          local files = {} ---@type table<string, string>
          for _, plugin in pairs(require("lazy.core.config").plugins) do
            repeat
              if plugin._.module then
                local info = vim.loader.find(plugin._.module)[1]
                if info then
                  files[info.modpath] = info.modpath
                end
              end
              plugin = plugin._.super
            until not plugin
          end
          local filespec = table.concat(vim.tbl_values(files), " ")
          require("fzf-lua").live_grep({ filespec = "-- " .. filespec, search = "/" })
        end,
        desc = "Find Lazy Plugin Spec",
      },
      -- git
      { "<leader>gc", LazyVim.pick("git_commits", { root = true }), desc = "Git Commits (FzfLua)" },
      { "<leader>gs", LazyVim.pick("git_status", { root = true }), desc = "Git Status (FzfLua)" },
      -- search
      { "<leader><leader>", LazyVim.pick("builtin"), desc = "Picker Builtin" },
      { "<leader>sM", LazyVim.pick("man_pages"), desc = "Man pages" },
      -- { "<leader>sR", nil, desc = nil }, -- deleted
    },
  },
}
