-- Extra filetype detections that Neovim does not ship with.
-- Loaded early (from init.lua) so `after/ftplugin/<ft>.lua` works for these.
vim.filetype.add({
  extension = {
    ipf = "ipf", -- Igor Pro
  },
})
