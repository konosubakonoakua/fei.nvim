return {
  {
    -- "epics-extensions/epics.nvim",
    "konosubakonoakua/epics.nvim",
    enabled = true,
    init = function ()
      require("epics").setup({})
    end
  },
  {
    "konosubakonoakua/epics.vim",
    enabled = false,
  },
}
