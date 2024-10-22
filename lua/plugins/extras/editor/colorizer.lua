return {
  {
    -- https://github.com/norcalli/nvim-colorizer.lua.git
    'norcalli/nvim-colorizer.lua',
    enabled = true,
    config = function ()
      require("colorizer").setup()
    end
  },

  -- minty
  { "nvchad/volt", lazy = true },
  {
    "nvchad/minty",
    cmd = { "Shades", "Huefy" },
  },
}
