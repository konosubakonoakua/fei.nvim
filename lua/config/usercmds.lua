-- User commands.
-- LazyVim only auto-loads options/autocmds/keymaps, so config/autocmds.lua
-- requires this module on the VeryLazy event.

-- region lazyrc
-- Copy the reference `.lazy.lua` into the current project (overwrite).
vim.api.nvim_create_user_command("LazyrcGenerate", function()
  local source = vim.fn.stdpath("config") .. "/misc/.lazy.lua"
  local target = vim.fn.getcwd() .. "/.lazy.lua"

  if vim.fn.filereadable(source) == 0 then
    LazyVim.error("Source not found: " .. source, { title = "Generate .lazy.lua" })
    return
  end

  local ok = (vim.uv or vim.loop).fs_copyfile(source, target)
  if ok then
    LazyVim.info("Copied `.lazy.lua` to " .. target, { title = "Generate .lazy.lua" })
  else
    LazyVim.error("Cannot copy `.lazy.lua` to " .. target, { title = "Generate .lazy.lua" })
  end
end, { desc = "Copy misc/.lazy.lua to cwd (overwrite)" })
-- endregion lazyrc

-- region log
vim.api.nvim_create_user_command("LogOpen", function()
  -- `stdpath("log")/nvim.log` is the real log file (the old `/log` name is stale)
  local log = vim.env.NVIM_LOG_FILE or (vim.fn.stdpath("log") .. "/nvim.log")
  local bufnr = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(bufnr, log)
  vim.api.nvim_buf_call(bufnr, vim.cmd.view)
end, { desc = "Open Neovim log" })
-- endregion log

-- region dotfiles
vim.api.nvim_create_user_command("Dotfiles", function()
  Snacks.picker.files({
    dirs = {
      vim.fn.expand("~/.dotfiles"),
      vim.fn.expand("~/.config/.dotfiles"),
      vim.fn.stdpath("config"),
    },
  })
end, { desc = "Search dotfiles" })
-- endregion dotfiles

-- region set command
-- Insert a `:set ts/sw/sts/et` line as a comment (using the buffer
-- commentstring), handy for project-local `.nvim.lua` / modelines.
local function insert_set_command()
  local commentstring = vim.bo.commentstring or "# %s"
  local tab_width = vim.fn.input("Enter tab width (2/4/8): ")

  if tab_width ~= "2" and tab_width ~= "4" and tab_width ~= "8" then
    vim.notify("Invalid tab width. Please enter 2, 4, or 8.", vim.log.levels.WARN)
    return
  end

  local command = string.format("vim :set ts=%s sw=%s sts=%s et :", tab_width, tab_width, tab_width)
  vim.api.nvim_buf_set_lines(0, -1, -1, false, { string.format(commentstring, command) })
end

vim.api.nvim_create_user_command("InsertSetCommand", insert_set_command, {
  desc = "Insert a :set ts/sw command as a comment",
})
-- endregion set command
