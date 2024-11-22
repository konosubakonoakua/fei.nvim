-- layzgit editfile <C-o><C-e>, <C-o> to copy the filename, <C-e> to open it
-- https://github.com/kdheepak/lazygit.nvim/issues/22
if vim.fn.executable("lazygit") ~= 1 then
  vim.notify("lazygit not found")
  return {}
end

-- stylua: ignore start
local _opts   = { silent = true }
local _floatterm = Snacks.terminal.open

-- Function to check clipboard with retries
--[[
local function getRelativeFilepath(retries, delay)
  local relative_filepath
  -- for i = 1, retries do
  for i = 1, retries do
    relative_filepath = vim.fn.getreg("+")
    if relative_filepath ~= "" then
      return relative_filepath -- Return filepath if clipboard is not empty
    end
    vim.loop.sleep(delay) -- Wait before retrying
  end
  return nil -- Return nil if clipboard is still empty after retries
end
--]]

-- Function to handle editing from Lazygit
function LazygitEdit(original_buffer)
  local current_bufnr = vim.fn.bufnr("%")
  local channel_id = vim.fn.getbufvar(current_bufnr, "terminal_job_id")

  if not channel_id then
    vim.notify("No terminal job ID found.", vim.log.levels.ERROR)
    return
  end

  vim.fn.chansend(channel_id, "\15") -- \15 is <c-o>
  vim.cmd("close") -- Close Lazygit

  -- local relative_filepath = getRelativeFilepath(5, 50)

  -- Get the copied relative file path from the system clipboard
  local rel_filepath = vim.fn.getreg("+")

  -- Combine with the current working directory to get the full path
  local cwd = LazyVim.root()
  local abs_filepath = cwd .. "/" .. rel_filepath

  -- vim.notify(tostring(rel_filepath), vim.log.levels.WARN)
  -- vim.notify(tostring(abs_filepath), vim.log.levels.WARN)
  if not abs_filepath then
    vim.notify("Clipboard is empty or invalid.", vim.log.levels.ERROR)
    return
  end

  local winid = vim.fn.bufwinid(original_buffer)

  if winid == -1 then
    vim.notify("Could not find the original window.", vim.log.levels.ERROR)
    return
  end

  vim.fn.win_gotoid(winid)
  vim.cmd("e " .. abs_filepath)
end

-- Function to start Lazygit in a floating terminal
function StartLazygit()
  local current_buffer = vim.api.nvim_get_current_buf()
  local float_term = Snacks.terminal.open({ "lazygit" }, { cwd = LazyVim.root(), esc_esc = false, ctrl_hjkl = false })

  vim.api.nvim_buf_set_keymap(
    float_term.buf,
    "t",
    "<c-e>",
    string.format([[<Cmd>lua LazygitEdit(%d)<CR>]], current_buffer),
    { noremap = true, silent = true }
  )
end

-- force remap
vim.keymap.set("n", "<leader>gg", [[<Cmd>lua StartLazygit()<CR>]], { noremap = true, silent = true, desc="lazygit@" })
if true then
  return {} -- TODO: not used for now
else
  vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
  vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
  -- vim.g.lazygit_floating_window_border_chars = {'╭','─', '╮', '│', '╯','─', '╰', '│'} -- customize lazygit popup window border characters
  -- vim.g.lazygit_floating_window_use_plenary = 1 -- use plenary.nvim to manage floating window if available
  vim.g.lazygit_use_neovim_remote = 0 -- fallback to 0 if neovim-remote is not installed

  vim.g.lazygit_use_custom_config_file_path = 0 -- config file path is evaluated if this value is 1
  vim.g.lazygit_config_file_path = '' -- custom config file path
  -- OR
  vim.g.lazygit_config_file_path = {} -- table of custom config file paths

  vim.keymap.set("n", "<leader>gt", "<cmd>LazyGit<CR>", { noremap = true, silent = true, desc="lazygit" })

  return {
    {
      "kdheepak/lazygit.nvim",
      -- optional for floating window border decoration
      dependencies = { "nvim-lua/plenary.nvim", },
    },
  }
end
