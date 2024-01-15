local depspath = vim.fn.stdpath("data") .. "/../nvim-deps"
if not vim.loop.fs_stat(depspath) then
  -- FIXME: notify not showing up
  vim.notify(depspath .. " not found, creating....", 3)
  vim.fn.mkdir(depspath, "p")
end

local function libsuffix()
  return jit.os == "Windows" and ".dll" or ".so"
end

local M = {
  os = jit.os,
  libdeps = {
    sqlite3 = depspath .. "/" .. "sqlite3" .. libsuffix(),
  },
}

function M.isPlatWindows()
  return jit.os == "Windows"
end

-- INFO: always use powershell on windows
if jit.os == "Windows" then
vim.cmd[[
  let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
  let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
  let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
  let &shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
  set shellquote= shellxquote=
]]
end

return M
