-- region lazyrc
-- TODO: generate lazyrc according to project type
vim.api.nvim_create_user_command('LazyrcGenerate', function ()
  local uv = vim.uv or vim.loop
  local lazyrc = vim.fn.stdpath("config") .. "/misc/.lazy.lua"
  local target = vim.fn.getcwd()
  if not target then
    LazyVim.error("Cannot read cwd", { title = "Generate .lazy.lua" })
  else
    target = target .. "/.lazy.lua"
  end

  local res = uv.fs_copyfile(lazyrc, target)

  if res then
    LazyVim.info("Copied `.lazy.lua` to " .. target, { title = "Generate .lazy.lua" })
  else
    LazyVim.error("Cannot copy `.lazy.lua` to " .. target, { title = "Generate .lazy.lua" })
  end
end, {desc = "generate .lazy.lua (overwrite)"})
-- endregion lazyrc

-- region log
vim.api.nvim_create_user_command('LogOpen', function ()
  local uv = vim.uv or vim.loop
  local log = vim.fs.normalize(vim.fn.stdpath("log") .. "/log")
  local bufnr = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(bufnr, log)
  vim.api.nvim_buf_call(bufnr, vim.cmd.view)
end, {desc = "Open Neovim log"})
-- endregion log

return {}
