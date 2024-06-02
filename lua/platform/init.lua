local depspath = vim.fn.stdpath("data") .. "/../nvim-deps"
if not vim.loop.fs_stat(depspath) then
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

function M.isPlatGithubAction()
  -- export env in bash: export PLATFORM_GITHUB_ACTION=1
  return os.getenv("PLATFORM_GITHUB_ACTION") == "1"
end

-- INFO: always use powershell on windows
if vim.fn.has("win32") == 1 then
  LazyVim.terminal.setup("pwsh")
else
  --  FIXME: #2429 shell not exit normally, related to SHELL path
  -- extract bash form /bin/bash
  -- NOTE: CI bug: /home/runner/.config/nvim/lua/platform/init.lua:38: attempt to index a nil value
  if not M.isPlatGithubAction() then
    local shell = os.getenv("SHELL"):match("([^"..package.config:sub(1,1).."]+)$") or "bash"
    LazyVim.terminal.setup(shell)
  else
    LazyVim.terminal.setup("bash")
  end
end


if not M.isPlatGithubAction() then
  if vim.fn.executable("tree-sitter") == 0 then
    LazyVim.error("tree-sitter cli executable not found. you can download it from: https://github.com/tree-sitter/tree-sitter/releases")
  end

  if vim.fn.executable("gh") == 0 then
    LazyVim.error("github cli executable not found. you can download it from: https://github.com/cli/cli/releases")
  end
end

return M
