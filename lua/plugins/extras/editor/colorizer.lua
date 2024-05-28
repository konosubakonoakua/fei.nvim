return {
  {
    -- https://github.com/brenoprata10/nvim-highlight-colors
    'brenoprata10/nvim-highlight-colors',
    enabled = false, -- not working with folding
    config = true,
    -- keys = {
    --   lua require("nvim-highlight-colors").turnOff()
    --   lua require("nvim-highlight-colors").turnOn()
    --   lua require("nvim-highlight-colors").toggle()
    -- }

  },
  {
    -- https://github.com/norcalli/nvim-colorizer.lua.git
    'norcalli/nvim-colorizer.lua',
    enabled = true,
    config = function ()
      require("colorizer").setup()
    end
  },
  {
    "max397574/colortils.nvim",
    cmd = "Colortils",
    config = function()
      require("colortils").setup()
    end,
  },
}
