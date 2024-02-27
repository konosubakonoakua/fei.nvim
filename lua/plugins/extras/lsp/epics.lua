return {
  {
    "epics-extensions/epics.nvim",
    -- "konosubakonoakua/epics.nvim",
    -- TODO: add filetype alias for makefile content
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
