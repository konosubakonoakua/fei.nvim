-- Generic helpers.
-- Terminal helpers live in util/term.lua, the lualine recording component in
-- util/statusline.lua, and the logo table in util/logos.lua.
local M = {}

---Return a random dashboard logo.
function M.logorandom()
  math.randomseed(os.time())
  local logos = require("util.logos")
  local logo = logos[math.random(#logos)]
  return logo
end

return M
