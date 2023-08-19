local depspath = vim.fn.stdpath("data") .. "/../nvim-deps"
if not vim.loop.fs_stat(depspath) then
  -- FIXME: notify not showing up
  vim.notify(depspath .. " not found, creating....", 3)
  vim.fn.mkdir(depspath, "p")
end

local function libsuffix()
  return jit.os == "Windows" and ".dll" or ".so"
end

return {
  os = jit.os,
  libdeps = {
    sqlite3 = depspath .. "/" .. "sqlite3" .. libsuffix(),
  },
}
