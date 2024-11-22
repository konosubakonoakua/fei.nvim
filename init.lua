-- vim.opt.verbosefile = os.getenv("LOCALAPPDATA") .. "\\nvim-data\\log"
-- vim.opt.verbose = 15

if vim.env.VSCODE then
  vim.g.vscode = true
end

_G.fei = {
  debug_on = false,
  trace_on = false,
}

_G.dump = function(...)
  if _G.fei.debug_on then require("util.debug").dump(...) end
end

_G.trace = function(...)
  if _G.fei.debug_on then require("util.debug").bt(...) end
end

local should_profile = os.getenv("NVIM_PROFILE")
if should_profile then
  require("profile").instrument_autocmds()
  if should_profile:lower():match("^start") then
    require("profile").start("*")
  else
    require("profile").instrument("*")
  end
end

local function toggle_profile()
  if not should_profile then return end

  local prof = require("profile")
  if prof.is_recording() then
    prof.stop()
    vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
      if filename then
        prof.export(filename)
        vim.notify(string.format("Wrote %s", filename))
      end
    end)
  else
    prof.start("*")
  end
end

vim.keymap.set("", "<f1>", toggle_profile)

require("config.lazy")
