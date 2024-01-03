-- PERF: toggle diagnosis at startup
local Util = require("lazyvim.util")
vim.diagnostic.disable()
Util.warn("Disabled diagnostics", { title = "Diagnostics" })

return {}
