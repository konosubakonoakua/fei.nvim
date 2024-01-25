return {
  {
    "glepnir/nerdicons.nvim",
    cmd = "NerdIcons",
    lazy = true,
    version = false,
    init = function()
      require("nerdicons").setup({
        border = "rounded",
        width = 0.7,
        prompt = "󰨭 ",
        preview_prompt = " ",
        down = "<C-j>",
        up = "<C-k>",
        copy = "<C-y>",
      })
    end,
  },
}
