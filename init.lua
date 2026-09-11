if vim.env.VSCODE then
  vim.g.vscode = true
end

-- extra filetype detections (used by after/ftplugin/)
require("config.filetypes")

require("config.lazy")
