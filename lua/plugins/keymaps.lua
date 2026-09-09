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
  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    optional = true,
    -- stylua: ignore
    keys = {
      -- NOTE: overwrite LazyVim default mapping for spectre
      -- { "<leader>sr", LazyVim.pick('resume'),                                                   mode = "n", desc = "Picker Resume"},
      { "<leader>cb", '<cmd>lua require("spectre").open_file_search()<CR>',                     mode = "n", desc = "Replace buffer (Spectre)"},
      { "<leader>cn", "<cmd>lua require('spectre').open({cwd=LazyVim.root()})<CR>",             mode = "n", desc = "Replace files root (Spectre)"},
      { "<leader>cb", '<esc><cmd>lua require("spectre").open_visual())<CR>',                    mode = "v", desc = "Replace visual buffer (Spectre)"},
      { "<leader>cn", '<esc><cmd>lua require("spectre").open_visual({cwd=LazyVim.root()})<CR>', mode = "v", desc = "Replace visual root (Spectre)"},
    },
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
      { "<leader>snp", function() require("noice").cmd("pick") end, desc = "Picker" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,
        silent = true, expr = true, desc = "Scroll forward", mode = { "i", "n", "s" }, },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end,
        silent = true, expr = true, desc = "Scroll backward", mode = { "i", "n", "s" }, },
    },
  },

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
      { "<leader>g/", function() Snacks.picker.git_grep({ cwd = Snacks.git.get_root() }) end, desc = "Git Grep" },
      { "<leader>gc", function() vim.cmd('lcd ' .. vim.fn.fnameescape(Snacks.git.get_root())) end, desc = "Git lcd" },
      { "<leader>gC", function() vim.cmd('cd ' .. vim.fn.fnameescape(Snacks.git.get_root())) end, desc = "Git cd" },
      -- gh
      { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
      { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
      { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
      { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.git_grep({ cwd = Snacks.git.get_root() }) end, desc = "Git Grep" },
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
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      -- LSP
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
      { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
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
      -- { "<leader>uN", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
      { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
      { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
      {
        "<leader>N",
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
