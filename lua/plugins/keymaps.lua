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
    pcall(vim.cmd, "Neotree close")
    -- TODO: dashboard open not fullscreen
    Snacks.dashboard.open()
  elseif LazyVim.has("dashboard-nvim") then
    pcall(vim.cmd, "Neotree close")
    vim.cmd("Dashboard")
  elseif LazyVim.has("alpha-nvim") then
    pcall(vim.cmd, "Neotree close")
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
    optional = true,
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
          grug.open({
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
        { "<leader>sR", icon = { icon = require("util.icons").mode.R, color = "red" } },
      })
      return opts
    end,
  },

  -- nvim-cmp keymapping
  {
    "hrsh7th/nvim-cmp",
    optional = true,
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
  { "rcarriga/nvim-notify", },

  -- indent-blankline keymapping
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false, -- disabled, use snacks instead.
    optional = true,
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

  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      -- Top Pickers & Explorer
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      -- find
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      -- git
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      -- { "<leader>g/", function() Snacks.picker.grep({ dirs={ LazyVim.root() } }) end, desc = "Git Grep" },
      { "<leader>g/", function() Snacks.picker.git_grep() end, desc = "Git Grep" },
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      -- { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      -- LSP
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      -- Other
      -- { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      -- { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
      { "<leader>wu",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<leader>wU",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
      { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<leader>uN", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      -- { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
      -- { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
      { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
      {
        "<leader>;N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      },
    },
  },
}
-- stylua: ignore end

-- vim:sw=2:ts=2:
