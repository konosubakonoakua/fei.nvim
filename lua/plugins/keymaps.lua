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

--- <leader>; utils
keymap("n", "<leader>;;", function()
  if LazyVim.has("snacks.nvim") then
    vim.cmd("Neotree close")
    -- TODO: dashboard open not fullscreen
    Snacks.dashboard.open()
  elseif LazyVim.has("dashboard-nvim") then
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
keymap("n", "<leader>;c", "<cmd>lcd %:p:h<cr>", { desc = ":lcd %:p:h" })
keymap("n", "<leader>;C", "<cmd>cd %:p:h<cr>", { desc = ":cd %:p:h" })
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

-- region LSP Mappings.
-- stylua: ignore start
local bufnr = vim.api.nvim_get_current_buf
vim.keymap.set( "n", "<space>wa", vim.lsp.buf.add_workspace_folder,
  { buffer = bufnr(), noremap = true, silent = true, desc = "Add workspace" })

vim.keymap.set( "n", "<space>wr", vim.lsp.buf.remove_workspace_folder,
  { buffer = bufnr(), noremap = true, silent = true, desc = "Remove workspace" })

vim.keymap.set("n", "<space>wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { buffer = bufnr(), noremap = true, silent = true, desc = "List workspace" })
-- stylua: ignore end
-- endregion LSP Mappings.

-- region notepad
-- stylua: ignore
vim.keymap.set("n", "<leader>;n", require("util.notepad").toggle, { desc = "Notepad" })
-- endregion notepad

return {
  -- telescope picker keymapping
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      -- TODO: add keymap to delete selected buffers, maybe need a keymap to select all
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        -- stylua: ignore
        mappings = {
          i = {
            ["<C-j>"] = function(...) return require("telescope.actions").move_selection_next(...) end,
            ["<C-k>"] = function(...) return require("telescope.actions").move_selection_previous(...) end,
            ["<C-n>"] = function(...) return require("telescope.actions").remove_selection(...) end,
            ["<C-p>"] = function(...) return require("telescope.actions.layout").toggle_preview(...) end,
          },
          n = {
            ["<C-p>"] = function(...) return require("telescope.actions.layout").toggle_preview(...) end,
          },
        },
      })

      opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
        -- stylua: ignore
        buffers = {
          mappings = {
            i = {
              ["<C-y>"] = function(...) return require("telescope.actions").delete_buffer(...) end,
            },
            n = {
              ["x"] = function(...) return require("telescope.actions").delete_buffer(...) end,
            },
          },
        },
      })

      return opts
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
    -- stylua: ignore
    keys = {
      { "<leader>fg", LazyVim.pick("git_files", { root = true }), desc = "Find Git-Files (root)" },
      { "<leader>fP", LazyVim.pick("files", { cwd = vim.fn.stdpath("data") .. "/lazy" }), desc = "Find Plugin File" },
      { "<leader>fR", LazyVim.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
      { "<leader>fr", LazyVim.pick("oldfiles", { root = true }), desc = "Recent (root)" },
      -- git
      { "<leader>gc", LazyVim.pick("git_commits", { root = true }), desc = "Git Commits (FzfLua)" },
      { "<leader>gs", LazyVim.pick("git_status", { root = true }), desc = "Git Status (FzfLua)" },
      -- search
      { "<leader><leader>", "", desc = "" },
      { "<leader><leader>b", LazyVim.pick("builtin"), desc = "Picker Builtin" },
      { "<leader>sL", function()
          local filespec = table.concat(require("util").filespec(), " ")
          require("fzf-lua").live_grep({ filespec = "-- " .. filespec, search = "/" })
        end,
        desc = "Find Lazy Plugin Spec",
      },
      { "<leader>sM", LazyVim.pick("man_pages"), desc = "Man pages" },
      -- { "<leader>sR", nil, desc = nil }, -- deleted
    },
  },

  -- neo-tree
  -- stylua: ignore
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<Leader>fB",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            dir = vim.fn.expand("%:p:h"),
          })
        end,
        desc = "Explorer NeoTree (Buffer Dir)",
      },
      { "<leader>ce", "<cmd>Neotree document_symbols<cr>", desc = "Neotree (Symbols)", },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            dir = LazyVim.root(),
            source = "git_status",
          })
        end,
        desc = "Git Explorer",
      },
    },
  },

  -- telescope keymapping
  -- stylua: ignore
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    keys = {
      { mode = "n", "<leader><leader>", "", desc = "" },
      { mode = "n", "<leader><leader>f", "<cmd>FZF!<cr>", desc = "FZF" },
      { mode = "n", "<leader><leader>b", function () require("telescope.builtin").builtin({ include_extensions = (vim.v.count ~= 0) }) end,   desc = "Telescope Builtins", noremap = true },
      { mode = "n", "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy current" },
      { mode = "n", "<leader>fc", function() require('telescope.builtin').find_files({find_command={'fd', vim.fn.expand("<cword>")}}) end,  desc = "Telescope Find cfile" },
      { mode = "n", "<leader>fC", LazyVim.pick.config_files(),  desc = "Find Config File" },
      { mode = "n", "<leader>fg", "<cmd>Telescope grep_string<cr>", desc = "Telescope Grep String", noremap = true },
      { mode = "n", "<leader>fG", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", desc = "Live grep args", noremap = true },
      { mode = "n", "<leader>fP", function() require("telescope.builtin").find_files( { cwd = require("lazy.core.config").options.root }) end, desc = "Find Plugin File"},
      { mode = "n", "<leader>gc", LazyVim.pick("git_commits", { root = true }), desc = "Commits" },
      { mode = "n", "<leader>gs", LazyVim.pick("git_status", { root = true }), desc = "Status" },
      { mode = "n", "<leader>sr", "<cmd>Telescope resume<cr>",    desc = "Telescope Resume" },
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
      -- { mode = "n", "<leader>sR", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" }, -- NOTE: overwrite LazyVim default mapping for telescope resume
      { mode = "n", "<leader>sL", function()
          local filespec = require("util").filespec()
          vim.print(vim.inspect(filespec))
          require("telescope.builtin").live_grep({ default_text = "", search_dirs = vim.tbl_values(filespec), })
        end,
        desc = "Find Lazy Plugin Spec",
      },
    },
  },

  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    optional = true,
    -- stylua: ignore
    keys = {
      -- NOTE: overwrite LazyVim default mapping for spectre
      { "<leader>sr", LazyVim.pick('resume'),                                                   mode = "n", desc = "Picker Resume"},
      { "<leader>cb", '<cmd>lua require("spectre").open_file_search()<CR>',                     mode = "n", desc = "Replace buffer (Spectre)"},
      { "<leader>cn", "<cmd>lua require('spectre').open({cwd=LazyVim.root()})<CR>",             mode = "n", desc = "Replace files root (Spectre)"},
      { "<leader>cb", '<esc><cmd>lua require("spectre").open_visual())<CR>',                    mode = "v", desc = "Replace visual buffer (Spectre)"},
      { "<leader>cn", '<esc><cmd>lua require("spectre").open_visual({cwd=LazyVim.root()})<CR>', mode = "v", desc = "Replace visual root (Spectre)"},
    },
  },

  -- grug-far, instead of spectre
  {
    "MagicDuck/grug-far.nvim",
    optional = true,
    -- stylua: ignore
    keys = {
      {
        "<leader>sR",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.grug_far({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
      { "<leader>sr", LazyVim.pick('resume'), mode = "n", desc = "Picker Resume" },
    },
    opts = function(_, opts)
      require("which-key").add({
        { "<leader>sR", icon = { icon = require("util.stuffs.icons").mode.R, color = "red" } },
      })
      return opts
    end,
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
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
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
      spec = {
        { "<leader>;", group = "utils", mode = { "n", "v" } },
        { "<leader>q", group = "quit/session/qf" },
      },
    },
  },

  -- todo-comments keymapping
  {
    "folke/todo-comments.nvim",
    optional = true,
    keys = LazyVim.has("telescope.nvim") and {
      { "<leader>xsf", "<cmd>TodoTelescope keywords=FIX,FIXME,BUG<CR>", mode = "n", desc = "Show FIXME" },
      { "<leader>xst", "<cmd>TodoTelescope keywords=TODO<CR>", mode = "n", desc = "Show TODO" },
      { "<leader>xsT", "<cmd>TodoTelescope keywords=TEST<CR>", mode = "n", desc = "Show TEST" },
      { "<leader>xsi", "<cmd>TodoTelescope keywords=INFO<CR>", mode = "n", desc = "Show INFO" },
    } or {},
  },
}

-- stylua: ignore end

-- vim:sw=2:ts=2:
