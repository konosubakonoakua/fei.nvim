-- NOTE: plugin spec
-- https://github.com/folke/lazy.nvim?tab=readme-ov-file#-plugin-spec

-- PERF: toggle diagnosis at startup
local Util = require("lazyvim.util")
vim.diagnostic.disable()
Util.warn("Disabled diagnostics", { title = "Diagnostics" })

return {}
