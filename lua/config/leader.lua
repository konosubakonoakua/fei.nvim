-- <leader>; utility maps and LSP workspace maps.
-- Extracted from plugins/keymaps.lua so that file only holds lazy.nvim specs,
-- and loaded from config/keymaps.lua (on VeryLazy) so all user keymaps are
-- defined in one place, at one time.

local M = {}

function M.setup()
  local ok, Term = pcall(require, "util.term")
  if not ok then
    LazyVim.error("Error loading util.term in config/leader")
    return
  end

  local keymap = vim.keymap.set

  -- region <leader>; utils
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
  end, { desc = "Dashboard" })
  keymap("n", "<leader>;c", "<cmd>lcd %:p:h<cr>", { desc = ":lcd %:p:h" })
  keymap("n", "<leader>;C", "<cmd>cd %:p:h<cr>", { desc = ":cd %:p:h" })
  keymap("n", "<leader>;l", "<cmd>Lazy<cr>", { desc = "Lazy.nvim" })
  keymap("n", "<leader>;m", "<cmd>Mason<cr>", { desc = "Mason" })
  keymap("n", "<leader>;I", "<cmd>LspInfo<cr>", { desc = "LspInfo" })
  keymap("n", "<leader>;t", Term.term_cwd, { desc = "Terminal (cwd)" })
  keymap("n", "<leader>;T", Term.term_root, { desc = "Terminal (root dir)" })
  keymap("n", "<leader>;x", "<cmd>LazyExtras<cr>", { desc = "LazyExtras" })
  keymap("n", "<leader>;L", LazyVim.news.changelog, { desc = "LazyVim Changelog" })
  keymap("n", "<leader>;P", function()
    vim.notify("Added '" .. LazyVim.root() .. "' to project list.", vim.log.levels.WARN)
    vim.cmd("AddProject")
  end, { desc = "Project Add Current" })

  -- system monitor
  if vim.fn.executable("btop") == 1 then
    keymap("n", "<leader>;b", function()
      Term.floatterm({ "btop" }, { esc_esc = false, ctrl_hjkl = false, border = "rounded" })
    end, { desc = "!Btop" })
  end

  -- path copy
  keymap("n", "<leader>;p", function()
    local file_path = vim.fn.expand("%:p")
    vim.fn.setreg("+", file_path)
    vim.notify("Path copied: " .. file_path)
  end, { desc = "Copy file path" })
  -- endregion <leader>; utils

  -- region LSP workspace folders
  -- NOTE: buffer-local and (re)applied per attached client. The previous
  -- implementation captured the current buffer once at load time, so the maps
  -- only worked in that single buffer.
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("config_leader_lsp", { clear = true }),
    callback = function(event)
      local buf = event.buf
      keymap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { buffer = buf, desc = "Add workspace folder" })
      keymap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { buffer = buf, desc = "Remove workspace folder" })
      keymap("n", "<space>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, { buffer = buf, desc = "List workspace folders" })
    end,
  })
  -- endregion LSP workspace folders
end

return M
