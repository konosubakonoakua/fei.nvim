-- config is executed when the plugin loads. The
-- default implementation will automatically run
-- require(MAIN).setup(opts) if opts or config = true
-- is set. Lazy uses several heuristics to determine
-- the plugin’s MAIN module automatically based on the
-- plugin’s name. See also opts. To use the default
-- implementation without opts set config to true.

local term_border = "rounded"
local _opts   = { silent = true }
local keymap             = vim.keymap.set
local keymap_force       = vim.keymap.set
local keydel             = vim.keymap.del
local _floatterm = require("util")._floatterm
local _lazyterm = require("util")._lazyterm
local _lazyterm_cwd = require("util")._lazyterm_cwd

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

keymap("n", "<leader>;l", "<cmd>Lazy<cr>",    { desc = "Lazy.nvim" })
keymap("n", "<leader>;m", "<cmd>Mason<cr>",   { desc = "Mason" })
keymap("n", "<leader>;I", "<cmd>LspInfo<cr>", { desc = "LspInfo" })
keymap("n", "<leader>;t", _lazyterm_cwd,      { desc = "Terminal (cwd)" })
keymap("n", "<leader>;T", _lazyterm,          { desc = "Terminal (root dir)" })
keymap("n", "<leader>;x", "<cmd>LazyExtras<cr>", { desc = "LazyExtras" })
keymap("n", "<leader>;L", LazyVim.news.changelog,  { desc = "LazyVim Changelog" })
keymap("n", "<leader>;P", function()
  vim.notify("Added '" .. LazyVim.root() .. "' to project list.", vim.log.levels.WARN)
  vim.cmd('AddProject')
end, { desc = "Project Add Current" })

-- region code
keymap('n', '<leader>cB', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = "Search cbuf (Spectre)" })
keymap('n', "<leader>cN", "<cmd>lua require('spectre').open({cwd=LazyVim.root()})<CR>", { desc = "Replace files (Spectre)" })
keymap('v', '<leader>cN', '<esc><cmd>lua require("spectre").open_visual({cwd=LazyVim.root()})<CR>', { desc = "Search cword (Spectre)" })
keymap('v', '<leader>cw', '<cmd>lua require("spectre").open_visual({select_word=true, cwd=LazyVim.root()})<CR>', { desc = "Search cword (Spectre)" })
-- endregion

-- region telescope
if LazyVim.has("todo-comments.nvim") then
  keymap("n", "<leader>xsf", "<cmd>TodoTelescope keywords=FIX,FIXME,BUG<CR>", { desc = "Show FIXME" })
  keymap("n", "<leader>xst", "<cmd>TodoTelescope keywords=TODO<CR>", { desc = "Show TODO" })
  keymap("n", "<leader>xsT", "<cmd>TodoTelescope keywords=TEST<CR>", { desc = "Show TEST" })
  keymap("n", "<leader>xsi", "<cmd>TodoTelescope keywords=INFO<CR>", { desc = "Show INFO" })
end

-- <leader>f
keymap_force("n", "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Fuzzy Search (Current)" })
keymap_force("n", "<leader>fc", function() require('telescope.builtin').find_files({find_command={'fd', vim.fn.expand("<cword>")}}) end, { desc = "Telescope Find cfile" })
keymap_force("n", "<leader>fC", LazyVim.telescope.config_files(), { desc = "Find Config File" })
keymap_force("n", "<leader>fg", ":Telescope grep_string<cr>", {desc = "Telescope Grep String", noremap = true})
keymap_force("n", "<leader>fG", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", {desc = "Live grep args", noremap = true})
keymap_force("n", "<leader>fP", function() require("telescope.builtin").find_files( { cwd = require("lazy.core.config").options.root }) end, {desc = "Find Plugin File"})

-- <leader>s
keymap_force("n", "<leader>sr", "<cmd>Telescope resume<cr>",   { desc = "Telescope Resume" })
keymap_force("n", "<leader>s;", function () require("telescope.builtin").builtin({ include_extensions = (vim.v.count ~= 0) }) end,  { desc = "Telescope Builtins", noremap = true })
-- keymap_force("n", "<leader>sb", ":lua require('telescope.builtin').current_buffer_fuzzy_find({default_text = vim.fn.expand('<cword>')})<cr>", {desc = "find current buffer", noremap = true})
keymap_force("n", "<leader>sb", ":lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", {desc = "find current buffer", noremap = true})
keymap_force("n", "<leader>sB", ":lua require('telescope.builtin').live_grep({grep_open_files=true})<cr>", {desc = "Find opened files", noremap = true})
keymap_force("n", "<leader>sM", "<cmd>Telescope man_pages sections=ALL<cr>", {desc = "Man Pages" })
keymap_force("n", "<leader>sg", LazyVim.telescope("live_grep"),                                        { desc = "Grep (root dir)" })
keymap_force("n", "<leader>sG", LazyVim.telescope("live_grep", { cwd = false }),                       { desc = "Grep (cwd)" })
keymap_force("v", "<leader>sw", LazyVim.telescope("grep_string"),                                      { desc = "Selection (root dir)" })
keymap_force("n", "<leader>sw", LazyVim.telescope("grep_string", { word_match = "-w" }),               { desc = "Word (root dir)" })
keymap_force("v", "<leader>sW", LazyVim.telescope("grep_string", { cwd = false }),                     { desc = "Selection (cwd)" })
keymap_force("n", "<leader>sW", LazyVim.telescope("grep_string", { cwd = false, word_match = "-w" }),  { desc = "Word (cwd)" })
keymap_force("n", "<leader>sj", "<cmd>Telescope jumplist<cr>",    { desc = "Jumplist", noremap = true })
keymap_force("n", "<leader>sl", "<cmd>Telescope loclist<cr>",     { desc = "Loclist", noremap = true })
keymap_force("n", "<leader>se", "<cmd>Telescope treesitter<cr>",  { desc = "Treesitter", noremap = true })
keymap_force("n", "<leader>su", "<cmd>Telescope tags<cr>",        { desc = "Tags", noremap = true })
keymap_force("n", "<leader>sU", "<cmd>Telescope tagstack<cr>",    { desc = "Tagstack", noremap = true })
-- endregion telescope

-- region LSP Mappings.
local bufnr = vim.api.nvim_get_current_buf
vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, {buffer = bufnr(), noremap = true, silent = true, desc = "Add workspace"})
vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, {buffer = bufnr(), noremap = true, silent = true, desc = "Remove workspace"})
vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, {buffer = bufnr(), noremap = true, silent = true, desc = "List workspace"})
-- endregion LSP Mappings.

-- stylua: ignore start
return {
  -- telescope keymapping
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      -- stylua: ignore start
      -- TODO: add keymap to delete selected buffers, maybe need a keymap to select all
      opts.defaults.mappings = {
        i = {
          ["<C-j>"] = function(...) return require("telescope.actions").move_selection_next(...) end,
          ["<C-k>"] = function(...) return require("telescope.actions").move_selection_previous(...) end,
          ["<C-n>"] = function(...) return require("telescope.actions").move_selection_next(...) end,
          ["<C-p>"] = function(...) return require("telescope.actions").move_selection_previous(...) end,
          ["<A-p>"] = function(...) return require("telescope.actions.layout").toggle_preview(...) end,
        },
        n = {
          ["<A-p>"] = function(...) return require("telescope.actions.layout").toggle_preview(...) end,
        },
      }
      return opts
      -- stylua: ignore end
    end,
  },

  -- neotree keymapping
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      -- region fix file following issue
      {
        "<leader>e",
        require("util.plugins.neotree").neotree_reveal_root,
        -- "<cmd>Neotree toggle show<cr>",
        desc = "Explorer NeoTree (root dir)",
      },
      {
        "<leader>E",
        require("util.plugins.neotree").neotree_reveal_cwd,
        -- "<cmd>Neotree toggle show<cr>",
        desc = "Explorer NeoTree (cwd)",
      },
      -- endregion fix file following issue
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer explorer",
      },
      {
        "<leader>ce", "<cmd>Neotree document_symbols<cr>", desc = "Neotree (Symbols)",
      },
      {
        -- TODO: not working if already on the neotree window,
        -- consider record the last file buffer which needs to be revealed in <leader>e
        -- currently stop using auto-follow
        "<leader>fe", function ()
          -- TODO: quit if not on a realfile or use history
          require('neo-tree.command').execute({
            action = "show",
            source = "filesystem",
            position = "left",
            -- reveal_file = reveal_file,
            dir = LazyVim.root(),
            -- reveal_force_cwd = true,
            -- toggle = true,
          })
          -- FIXME: don't close opend folders
          -- show_only_explicitly_opened() can be disabled
          require("neo-tree.sources.filesystem.init").follow(nil, true)
          -- -- FIXME: cannot focus on file
          -- vim.cmd([[
          --   Neotree reveal
          -- ]])
          require('neo-tree.command').execute({
            action = "reveal",
            source = "filesystem",
            position = "left",
            dir = LazyVim.root(),
            -- toggle = true,
          })
        end,
        mode = 'n',
        desc="Open neo-tree at current file or working directory"
      }
    },
  },

  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    -- stylua: ignore
    keys = {
      -- NOTE: overwrite LazyVim default mapping for spectre
      { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Telescope Resume"},
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- NOTE: overwrite LazyVim default mapping for telescope resume
      { "<leader>sR", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
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
      { "<leader>Tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
      { "<leader>TT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
      { "<leader>Tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
      { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
      { "<leader>To", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
      { "<leader>TO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      { "<leader>TS", function() require("neotest").run.stop() end, desc = "Stop" },
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
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    },
  },

  -- notify keymapping
  {
    "rcarriga/nvim-notify",
    -- stylua: ignore
    keys = {
      { "<leader>un", function() require("notify").dismiss({ silent = true, pending = true }) end,
        desc = "Dismiss all Notifications", },
      { "<leader>uN", function() require("telescope").extensions.notify.notify() end,
        desc = "Dispaly all Notification histories", },
    },
  },


  -- indent-blankline keymapping
  {
    "lukas-reineke/indent-blankline.nvim",
    keys = {
      { "<leader>uI", ":IBLToggle<cr>", mode = "n", desc = "Toggle IndentLine" }
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
        ["<leader>l"] = { name = "placeholder" }, -- TODO: remap <leader>l
        ["<leader>L"] = { name = "placeholder" }, -- TODO: remap <leader>L
        ["<leader>;"] = { name = "+utils" },
        ["<leader><leader>"] = { name = "+FzfLua" },
        ["<leader>T"] = { name = "+Test" },
        ["<leader>t"] = { name = "+Telescope" },
      },
    }
  },
}

-- stylua: ignore end

-- vim:sw=2:ts=2:
