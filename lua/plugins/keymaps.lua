-- config is executed when the plugin loads. The
-- default implementation will automatically run
-- require(MAIN).setup(opts) if opts or config = true
-- is set. Lazy uses several heuristics to determine
-- the plugin’s MAIN module automatically based on the
-- plugin’s name. See also opts. To use the default
-- implementation without opts set config to true.

local keymap = vim.keymap.set
-- local keymap_force       = vim.keymap.set
-- local keydel             = vim.keymap.del

local status, Utils = pcall(require, "util")
if not status then
  -- BUG: loop require in CI environment
  -- Error detected while processing /home/runner/.config/nvim/init.lua:
  -- Error loading util
  -- Error loading util
  LazyVim.error("Error loading util in plugins/keymaps")
  return {}
end

local _floatterm = Utils.custom_floatterm
local _lazyterm = Utils.custom_lazyterm
local _lazyterm_cwd = Utils.custom_lazyterm_cwd

-- stylua: ignore start

-- Dashboard
keymap("n", "<leader>;;", function()
  if LazyVim.has("dashboard-nvim") then
    vim.cmd("Neotree close")
    vim.cmd("Dashboard")
  elseif LazyVim.has("alpha-nvim") then
    vim.cmd("Neotree close")
    vim.cmd("Alpha")
  elseif LazyVim.has("mini.starter") then
    local starter = require("mini.starter") -- TODO: need test mini.starter
    pcall(starter.refresh)
  end
end, { desc = "Dashboard", silent = true })

--- <leader>; utils
keymap("n", "<leader>;l", "<cmd>Lazy<cr>", { desc = "Lazy.nvim" })
keymap("n", "<leader>;m", "<cmd>Mason<cr>", { desc = "Mason" })
keymap("n", "<leader>;I", "<cmd>LspInfo<cr>", { desc = "LspInfo" })
keymap("n", "<leader>;t", _lazyterm_cwd, { desc = "Terminal (cwd)" })
keymap("n", "<leader>;T", _lazyterm, { desc = "Terminal (root dir)" })
keymap("n", "<leader>;x", "<cmd>LazyExtras<cr>", { desc = "LazyExtras" })
keymap("n", "<leader>;L", LazyVim.news.changelog, { desc = "LazyVim Changelog" })
keymap("n", "<leader>;P", function()
  vim.notify("Added '" .. LazyVim.root() .. "' to project list.", vim.log.levels.WARN)
  vim.cmd("AddProject")
end, { desc = "Project Add Current" })

-- region code
keymap( "n", "<leader>cB", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = "Replace buffer (Spectre)" })
keymap( "n", "<leader>cN", "<cmd>lua require('spectre').open({cwd=LazyVim.root()})<CR>", { desc = "Replace files (Spectre)" })
keymap( "v", "<leader>cN", '<esc><cmd>lua require("spectre").open_visual({cwd=LazyVim.root()})<CR>', { desc = "Replace cword (Spectre)" })
keymap( "v", "<leader>cw", '<cmd>lua require("spectre").open_visual({select_word=true, cwd=LazyVim.root()})<CR>', { desc = "Replace cword (Spectre)" })
-- endregion

-- region telescope
-- TODO: add fzf-lua mappings
if LazyVim.has("todo-comments.nvim") and LazyVim.has("telescope.nvim") then
  keymap("n", "<leader>xsf", "<cmd>TodoTelescope keywords=FIX,FIXME,BUG<CR>", { desc = "Show FIXME" })
  keymap("n", "<leader>xst", "<cmd>TodoTelescope keywords=TODO<CR>", { desc = "Show TODO" })
  keymap("n", "<leader>xsT", "<cmd>TodoTelescope keywords=TEST<CR>", { desc = "Show TEST" })
  keymap("n", "<leader>xsi", "<cmd>TodoTelescope keywords=INFO<CR>", { desc = "Show INFO" })
end

-- region LSP Mappings.
local bufnr = vim.api.nvim_get_current_buf
vim.keymap.set( "n", "<space>wa", vim.lsp.buf.add_workspace_folder, { buffer = bufnr(), noremap = true, silent = true, desc = "Add workspace" })
vim.keymap.set( "n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { buffer = bufnr(), noremap = true, silent = true, desc = "Remove workspace" })
vim.keymap.set("n", "<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { buffer = bufnr(), noremap = true, silent = true, desc = "List workspace" })
-- endregion LSP Mappings.

-- region notepad
vim.keymap.set("n", "<leader>;n", function() require("util.notepad").toggle() end, { desc = "Notepad" })
-- endregion notepad

-- stylua: ignore end

return {
  -- telescope picker keymapping
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      -- stylua: ignore start
      -- TODO: add keymap to delete selected buffers, maybe need a keymap to select all
      opts.defaults.mappings = {
        i = {
          ["<C-j>"] = function(...) return require("telescope.actions").move_selection_next(...) end,
          ["<C-k>"] = function(...) return require("telescope.actions").move_selection_previous(...) end,
          -- ["<C-n>"] = function(...) return require("telescope.actions").move_selection_next(...) end,
          -- ["<C-p>"] = function(...) return require("telescope.actions").move_selection_previous(...) end,
          ["<C-p>"] = function(...) return require("telescope.actions.layout").toggle_preview(...) end,
        },
        n = {
          ["<C-p>"] = function(...) return require("telescope.actions.layout").toggle_preview(...) end,
        },
      }
      return opts
      -- stylua: ignore end
    end,
  },

  -- fzf-lua picker keymapping
  {
    "ibhagwan/fzf-lua",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local config = require("fzf-lua.config")
      -- local actions = require("fzf-lua.actions")

      -- Quickfix
      -- stylua: ignore start
      config.defaults.keymap.fzf    ["ctrl-o"]      = "jump"
      config.defaults.keymap.builtin["<C-h>"]       = "toggle-help"
      config.defaults.keymap.builtin["<C-l>"]       = "toggle-preview"
      config.defaults.keymap.builtin["<C-space>"]   = "toggle-fullscreen"
      -- stylua: ignore end

      table.insert(opts, 1, "default") -- use telescope profile
      opts.fzf_opts = { ["--layout"] = "reverse" } -- input box at TOP
      opts.winopts = {
        fullscreen = false,
        -- border = "none", -- 'none', 'single', 'double', 'thicc' (+cc) or 'rounded' (default)
        preview = {
          scrollchars = { "█", "" },
          hidden = "nohidden",
          layout = "vertical", -- horizontal|vertical|flex
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

  -- neotree keymapping
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   keys = {
  --     {
  --       "<Leader>fB",
  --       function()
  --         require("neo-tree.command").execute({ toggle = true, dir = vim.fn.expand("%:p:h") })
  --       end,
  --       desc = "Explorer NeoTree (Buffer Dir)"
  --     },
  --     {
  --       "<leader>ce", "<cmd>Neotree document_symbols<cr>", desc = "Neotree (Symbols)",
  --     },
  --     -- {
  --     --   "<leader>e",
  --     --   require("plugins.util.neotree").neotree_reveal_root,
  --     --   -- "<cmd>Neotree toggle show<cr>",
  --     --   desc = "Explorer NeoTree (root dir)",
  --     -- },
  --     -- {
  --     --   "<leader>E", -- NOTE: fix file following issue
  --     --   require("plugins.util.neotree").neotree_reveal_cwd,
  --     --   -- "<cmd>Neotree toggle show<cr>",
  --     --   desc = "Explorer NeoTree (cwd)",
  --     -- },
  --     -- {
  --     --   -- TODO: not working if already on the neotree window,
  --     --   -- consider record the last file buffer which needs to be revealed in <leader>e
  --     --   -- currently stop using auto-follow
  --     --   "<leader>fe", function ()
  --     --     -- TODO: quit if not on a realfile or use history
  --     --     require('neo-tree.command').execute({
  --     --       action = "show",
  --     --       source = "filesystem",
  --     --       position = "left",
  --     --       -- reveal_file = reveal_file,
  --     --       dir = LazyVim.root(),
  --     --       -- reveal_force_cwd = true,
  --     --       -- toggle = true,
  --     --     })
  --     --     -- FIXME: don't close opend folders
  --     --     -- show_only_explicitly_opened() can be disabled
  --     --     require("neo-tree.sources.filesystem.init").follow(nil, true)
  --     --     -- -- FIXME: cannot focus on file
  --     --     -- vim.cmd([[
  --     --     --   Neotree reveal
  --     --     -- ]])
  --     --     require('neo-tree.command').execute({
  --     --       action = "reveal",
  --     --       source = "filesystem",
  --     --       position = "left",
  --     --       dir = LazyVim.root(),
  --     --       -- toggle = true,
  --     --     })
  --     --   end,
  --     --   mode = 'n',
  --     --   desc="Open neo-tree at current file or working directory"
  --     -- },
  --   },
  -- },

  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    -- stylua: ignore
    keys = {
      -- NOTE: overwrite LazyVim default mapping for spectre
      { "<leader>sr", LazyVim.pick('resume'), desc = "Picker Resume"},
    },
  },

  -- telescope keymapping
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    keys = {
      { mode = "n", "<leader><leader>", "<cmd>FZF!<cr>", desc = "FZF" },
      { mode = "n", "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy Search (Current)" },
      { mode = "n", "<leader>fc", function() require('telescope.builtin').find_files({find_command={'fd', vim.fn.expand("<cword>")}}) end,  desc = "Telescope Find cfile" },
      { mode = "n", "<leader>fC", LazyVim.pick.config_files(),  desc = "Find Config File" },
      { mode = "n", "<leader>fg", "<cmd>Telescope grep_string<cr>", desc = "Telescope Grep String", noremap = true },
      { mode = "n", "<leader>fG", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", desc = "Live grep args", noremap = true },
      { mode = "n", "<leader>fP", function() require("telescope.builtin").find_files( { cwd = require("lazy.core.config").options.root }) end, desc = "Find Plugin File"},
      { mode = "n", "<leader>sr", "<cmd>Telescope resume<cr>",    desc = "Telescope Resume" },
      { mode = "n", "<leader>s;", function () require("telescope.builtin").builtin({ include_extensions = (vim.v.count ~= 0) }) end,   desc = "Telescope Builtins", noremap = true },
      { mode = "n", "<leader>sb", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", desc = "find current buffer", noremap = true },
      { mode = "n", "<leader>sB", "<cmd>lua require('telescope.builtin').live_grep({grep_open_files=true})<cr>", desc = "Find opened files", noremap = true},
      -- NOTE: need execute 'mandb' first, then we can find man files in user PATH
      { mode = "n", "<leader>sM", "<cmd>Telescope man_pages sections=ALL<cr>", desc = "Man Pages (mandb to update)" },
      -- { mode = "n", "<leader>sg", LazyVim.pick("live_grep"),                                         desc = "Grep (root dir)" },
      -- { mode = "n", "<leader>sG", LazyVim.pick("live_grep", { cwd = false }),                        desc = "Grep (cwd)" },
      -- { mode = "v", "<leader>sw", LazyVim.pick("grep_string"),                                       desc = "Selection (root dir)" },
      -- { mode = "n", "<leader>sw", LazyVim.pick("grep_string", { word_match = "-w" }),                desc = "Word (root dir)" },
      -- { mode = "v", "<leader>sW", LazyVim.pick("grep_string", { cwd = false }),                      desc = "Selection (cwd)" },
      -- { mode = "n", "<leader>sW", LazyVim.pick("grep_string", { cwd = false, word_match = "-w" }),   desc = "Word (cwd)" },
      { mode = "n", "<leader>sj", "<cmd>Telescope jumplist<cr>",     desc = "Jumplist", noremap = true },
      { mode = "n", "<leader>sl", "<cmd>Telescope loclist<cr>",      desc = "Loclist", noremap = true },
      { mode = "n", "<leader>se", "<cmd>Telescope treesitter<cr>",   desc = "Treesitter", noremap = true },
      { mode = "n", "<leader>su", "<cmd>Telescope tags<cr>",         desc = "Tags", noremap = true },
      { mode = "n", "<leader>sU", "<cmd>Telescope tagstack<cr>",     desc = "Tagstack", noremap = true },
      { mode = "n", "<leader>sR", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" }, -- NOTE: overwrite LazyVim default mapping for telescope resume
      { mode = "n", "<leader>fl", function()
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
          require("telescope.builtin").live_grep({
            default_text = "/",
            search_dirs = vim.tbl_values(files),
          })
        end,
        desc = "Find Lazy Plugin Spec",
      },
    },
  },

  -- nvim-cmp keymapping
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.completion.completeopt = "menu,menuone,noinsert"
      opts.mapping = vim.tbl_deep_extend("force", opts.mapping, {
        ["<UP>"] = cmp.mapping.scroll_docs(-4),
        ["<DOWN>"] = cmp.mapping.scroll_docs(4),
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ---- INFO: I need something else instead of `<C-e>` to abort cmp.
        ["<C-Space>"] = cmp.mapping({
          i = function()
            if cmp.visible() then -- pop-up menu is visible
              -- cmp.select_next_item()
              cmp.abort()
              cmp.close()
            else
              cmp.complete() -- open the pop-up menu
            end
          end,
        }),
      })
      return opts
    end,
  },

  -- test.core neotest keymapping
  {
    "nvim-neotest/neotest",
    -- stylua: ignore
    keys = {
    },
  },

  -- motion flash keymapping
  {
    "folke/flash.nvim",
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      { "<A-s>", mode = { "i", "x", "n", "s" }, function()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        require("flash").jump({
          search = {
            mode = "search",
            max_length = 0,
            multi_window = false,
          },
          label = { after = { 0, 0 } },
          -- label = { after = { 0, col } }, -- current col
          pattern = "^", -- start fo line (non-blank)
          highlight = {
            matches = false,
          },
        })
        vim.api.nvim_input(col .. 'l')
      end, { desc = "line jump" }}
    },
  },

  -- noice keymapping
  {
    "folke/noice.nvim",
    -- stylua: ignore
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline", },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      -- { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
      { "<leader>snp", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,
        silent = true, expr = true, desc = "Scroll forward", mode = { "i", "n", "s" }, },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end,
        silent = true, expr = true, desc = "Scroll backward", mode = { "i", "n", "s" }, },
    },
  },

  -- notify keymapping
  {
    "rcarriga/nvim-notify",
    keys = {
      { "<leader>un", function() require("notify").dismiss({ silent = true, pending = true }) end,
        desc = "Dismiss all Notifications",
      },
      -- TODO: add fzflua for nvim-notify
      -- https://github.com/ibhagwan/fzf-lua/wiki/Advanced
      {
        "<leader>uN",
        function()
          if require("util.picker").has_telescope() then
            require("telescope").extensions.notify.notify()
          else
            LazyVim.error("notify.nvim not support fzf-lua")
          end
        end,
        desc = "Dispaly all Notification histories",
      },
    },
  },

  -- indent-blankline keymapping
  {
    "lukas-reineke/indent-blankline.nvim",
    keys = {
      { "<leader>uI", "<cmd>IBLToggle<cr>", mode = "n", desc = "Toggle IndentLine" },
    },
  },

  -- which-key keymapping
  {
    "folke/which-key.nvim",
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["gz"] = {},
        ["<leader>;"] = { name = "+utils" },
      },
    },
  },
}

-- stylua: ignore end

-- vim:sw=2:ts=2:
