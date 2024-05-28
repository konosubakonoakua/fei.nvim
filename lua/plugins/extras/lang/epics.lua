return {
  {
    "epics-extensions/epics.nvim",
    enabled = true,
    init = function ()
      require("epics").setup({})
    end
  },
}
